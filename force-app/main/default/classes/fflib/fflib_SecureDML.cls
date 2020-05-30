/**
* @author Charles Naccio
* @date 5/31/2019
*
* @group Security
* @group-content ../../ApexDocContent/Security.htm
*
* @description A unit of work DML interface for executing secure database write operations 
* based on user level permissions.
*/
public inherited sharing class fflib_SecureDML implements fflib_SObjectUnitOfWork.IDML {
    
    /*******************************************************************************************************
    * Class Properties
    */

    /**
    * @description Sobject types that crud/fls security has been disabled for.
    */
    protected Set<SObjectType> disabledSecurity {get; private set;}

    /*******************************************************************************************************
    * Class Interface Methods
    */

    /**
    * @description Default Constructor.
    */
    public fflib_SecureDML() {
        
        // Security is not disabled for any sobject types by default
        disabledSecurity = new Set<SObjectType>();
    }

    /**
    * @description Construct with sobject types we want to disable security for
    */
    public fflib_SecureDML(Set<SObjectType> disabledSecurity) {
        this.disabledSecurity = disabledSecurity;
    }

    /**
    * @description Insert given sobject records into database if user has appropriate permissions
    * @param List of sobject records
    * @example
    * fflib_SecureDML.dmlInsert(new List<SObject>{*});
    */
    public void dmlInsert(List<SObject> records) {
        if (records == null || records.size() == 0) return; // avoid wasting any cycles

        // Check CRUD and FLS before inserting records
        if (enforcingSecurity(getSobjectType(records)))
            checkInsertSecurity(records);

        // Insert records if above security check passed
        insert records;
    }
    
    /**
    * @description Update given sobject records in database if user has appropriate permissions
    * @param List of sobject records
    * @example
    * fflib_SecureDML.dmlUpdate(new List<SObject>{*});
    */
    public void dmlUpdate(List<SObject> records) {
        if (records == null || records.size() == 0) return; // avoid wasting any cycles
        
        // Check CRUD and FLS before updating records, if not handled elsewhere
		if (enforcingSecurity(getSobjectType(records)))
			checkUpdateSecurity(records);

        // Update records if above security check passed
        update records;
    }

    /**
    * @description Delete given sobject records from database if user has appropriate permissions
    * @param List of sobject records
    * @example
    * fflib_SecureDML.dmlDelete(new List<SObject>{*});
    */
    public void dmlDelete(List<SObject> records) {
        if (records == null || records.size() == 0) return; // avoid wasting any cycles
        
        // Check CRUD security before deleting records
        if (enforcingSecurity(getSobjectType(records)))
            checkDeleteSecurity(records);

        // Delete records if above security check passed
        delete records;
    }

    /**
    * @description Publish platform events for given records
    * @param List of sobject records
    * @example
    * fflib_SecureDML.eventPublish(new List<SObject>{*});
    */
    public void eventPublish(List<SObject> records) {
        if (records == null || records.size() == 0) return; // avoid wasting any cycles
        EventBus.publish(records);
	}
	
	/**
    * @description Delete Recycle Bin of Given Records
    * @param List of sobject records
    * @example
    * fflib_SecureDML.emptyRecycleBin(new List<SObject>{*});
    */
	public void emptyRecycleBin(List<SObject> records) {}


    /**
	* @description Enable or disable CRUD/Field Level Security enforcement. Use the disable method sparingly 
    * and only when you believe the DML being executed is purely system level and not user level
    * @param SObject type you want to enable/disable security enforcement for
    * @param Whether or not you want to enable or disable security
	*/
	public void enforceSecurity(SObjectType sObjectType, Boolean enable) {
		if(enable)
            disabledSecurity.remove(sObjectType);
		else
            disabledSecurity.add(sObjectType);
	}
	
	/**
	* @description Confirm if CRUD/Field level security is being enforced for given SObject type.
    * @param SObject type you want to check security enforcement for
	*/
	public boolean enforcingSecurity(SObjectType sObjectType) {
		return disabledSecurity.contains(sObjectType) ? false : true;
	}

    /*******************************************************************************************************
    * Check Security Methods
    */

    /**
    * @description Scans given records and populated fields and ensures user has permission to create 
    * those records and set those fields. Throws SecurityException (crud or fls) if user does not have 
    * appropriate permissions.
    * @param List of sobject records
    * @example
    * fflib_SecureDML.checkInsertSecurity(new List<Project__c>{*});
    */
	private static void checkInsertSecurity(List<SObject> records) {

        // Scan records for populated fields, for each sobject type
        Map<SObjectType, List<String>> populatedFields = resolvePopulatedFields(records);

        // Check field level security for all populated fields within each given sobject type
        for (SObjectType sObjectType : populatedFields.keySet())

            // Check populated fields against user's permissions and throw an exception for any failures
            fflib_SecurityUtils.checkInsert(sObjectType, populatedFields.get(sObjectType));
	}

    /**
    * @description Scans given records and changed fields and ensures user has permission to update 
    * those records and/or fields. Throws SecurityException (crud or fls) if user does not have 
    * appropriate permissions.
    * @param List of sobject records
    * @example
    * fflib_SecureDML.checkUpdateSecurity(new List<Project__c>{*});
    */
	private static void checkUpdateSecurity(List<SObject> records) {

        // Scan records for updated fields, for each sobject type
        Map<SObjectType, List<String>> updatedFields = resolveUpdatedFields(records);

        // Check field level security for all updated fields within each given sobject type
        for (SObjectType sObjectType : updatedFields.keySet())

            // Check updated fields against user's permissions and throw an exception for any failures
            fflib_SecurityUtils.checkUpdate(sObjectType, updatedFields.get(sObjectType));
	}

    /**
    * @description Checks that user has permission to delete given records. Throws SecurityException (crud) if
    * user does not have appropriate permissions.
    * @param List of sobject records
    * @example
    * fflib_SecureDML.checkDeleteSecurity(new List<Project__c>{*});
    */
	private static void checkDeleteSecurity(List<SObject> records) {
        
        // Check each sobject type for given records
        for (SObjectType sObjectType : groupBySObjectType(records).keySet())

            // Check user's permission to delete records, and throw exception for any failures
            fflib_SecurityUtils.checkObjectIsDeletable(sObjectType);
	}

    /*******************************************************************************************************
    * Class General Methods
    */

    /**
    * @description Resolve populated fields for/from given record
    * @param Sobject record 
    * @return Populated fields
    * @example
    * Set<String> populatedFields = fflib_SecureDML.resolvePopulatedFields(new SObject(*));
    */
    private static Set<String> resolvePopulatedFields(SObject record) {
    	
        // Grab populated fields
        List<String> populatedFields = new List<String>(record.getPopulatedFieldsAsMap().keySet());
        
        // Remove relationship fields as they're not needed for dml security validation
        if (populatedFields != null)
            for (Integer i = populatedFields.size() - 1; i >= 0 ; i--) {
                if (populatedFields.get(i).endsWithIgnoreCase('__r'))
                    populatedFields.remove(i);
            }
        
        // Return populated fields to caller
        return new Set<String>(populatedFields);
        
        /**
         * NOTE: Please upvote https://success.salesforce.com/ideaView?id=08730000000l5vbAAA)
         */
    }

    /**
    * @description Resolve populated fields for/from given records
    * @param List of sobject records
    * @return Map of populated fields by sobject type
    * @example
    * Map<SObjectType, List<String>> populatedFields = 
    *   fflib_SecureDML.resolvePopulatedFields(new List<SObject>(*));
    */
    private static Map<SObjectType, List<String>> resolvePopulatedFields(List<SObject> records) {
    	Map<SObjectType, List<String>> populatedFieldsByType = new Map<SObjectType, List<String>>();
    	Set<String> populatedFields = new Set<String>();
    	SObjectType sObjectType; // there's always only one sobject type
        for(SObject record : records) {
            if (sObjectType == null)
                sObjectType = record.getSObjectType();
    		populatedFields.addAll(resolvePopulatedFields(record));
        }
        if (populatedFields.size() > 0)
            populatedFieldsByType.put(sObjectType, new List<String>(populatedFields));
        return populatedFieldsByType;
    }

    /**
    * @description Resolve updated fields for/from given record, and previous record
    * @param Sobject record 
    * @param Previous version of sobject record; prior to updates.
    * @return Updated fields
    * @example
    * Set<String> updatedFields = fflib_SecureDML.resolveUpdatedFields(new SObject(*), new SObject(*));
    */
    public static Set<String> resolveUpdatedFields(SObject record, SObject previousRecord) {
    	Set<String> updatedFields = new Set<String>();
        
        // Scan through each populated field for given record
        for(String populatedField : resolvePopulatedFields(record)) {
            
            // Populated field is considered updated if it's value is different from the previous record
            if (record.get(populatedField) != previousRecord.get(populatedField)) {
                updatedFields.add(populatedField);
            }
        }

        // Return updated fields to caller
        return updatedFields;
    }

    /**
    * @description Resolve updated fields for/from given records
    * @param List of sobject records
    * @return Map of updated fields by sobject type
    * @example
    * Map<SObjectType, List<String>> updatedFields = 
    *   fflib_SecureDML.resolveUpdatedFields(new List<SObject>(*));
    */
    private static Map<SObjectType, List<String>> resolveUpdatedFields(List<SObject> records) {
        Map<SObjectType, List<String>> updatedFieldsByType = new Map<SObjectType, List<String>>();

        // Get populated fields and sobject type for given records
        Map<SObjectType, List<String>> populatedFields = resolvePopulatedFields(records);
        for (SObjectType sObjectType : populatedFields.keySet()) {
            
            // Grab previous/existing records
            Map<Id, SObject> previousRecords = getPreviousRecords(
                records,
                sObjectType,
                populatedFields.get(sObjectType)
            );
            
            // Figure out which fields have been updated
            Set<String> updatedFields = new Set<String>();
            for(SObject record : records)
                updatedFields.addAll(resolveUpdatedFields(record, previousRecords.get(record.Id)));
            
            // Group updated fields by sobject type
            if (updatedFields.size() > 0)
                updatedFieldsByType.put(sObjectType, new List<String>(updatedFields));
            
            // Break loop, as we'll always have only a single sobject type and thus one iteration
            break;
        }
        
        // Return updated fields by sobject type to caller
        return updatedFieldsByType;
    }

    /**
    * @description Get current version of given records as they current are in the database
    * @param List of sobject records
    * @param Sobject type of given records
    * @param Fields to query from previous records
    * @return Map of current/previous version of given records, grouped by record id.
    * @example
    * Map<Id, SObject> previousRecords = fflib_SecureDML.getPreviousRecords(new List<SObject>{*});
    */
    private static Map<Id, SObject> getPreviousRecords(
        List<SObject> records,
        SObjectType sObjectType,
        List<String> fields
    ) {

        // Setup sobject query
        fflib_QueryFactory query = Application.Selector.newInstance(sObjectType)
            .newQueryFactory(false)
            .selectFields(fields)
            .setCondition('Id IN :records');
        
        // Execute query and return previous records to caller
        return new Map<Id, SObject>(Database.query(query.toSOQL()));
    }

    /**
    * @description Return given records grouped by sobject type
    * @param List of sobject records
    * @return Map of records by sobject type
    * @example
    * Map<SObjectType, List<SObject>> recordsBySObjectType = fflib_SecureDML.groupBySObjectType(new List<SObject>(*));
    */
    private static Map<SObjectType, List<SObject>> groupBySObjectType(List<SObject> records) {
    	Map<SObjectType, List<SObject>> recordsBySObjectType = new Map<SObjectType, List<SObject>>();
        for (SObject record : records) {
            SObjectType sObjectType = record.getSObjectType();
            if (!recordsBySObjectType.containsKey(sObjectType))
                recordsBySObjectType.put(sObjectType, records);
            break; // records will always of a single sobject type
        }
        return recordsBySObjectType;
    }

    /**
    * @description Grab sobject type for given records (it'll always be a single type)
    * @param List of sobject records
    * @return Sobject type of given records
    * @example
    * SObjectType sObjectType = fflib_SecureDML.getSobjectType(new List<SObject>{*});
    */
    private static SObjectType getSobjectType(List<SObject> records) {
        for (SObject record : records) {
            return record.getSObjectType();
        }
        return null;
    }
}