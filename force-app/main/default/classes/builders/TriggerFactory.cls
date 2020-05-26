/*
* @author efigenio.ben@clarityforms.io
* @date 01/05/2017
*
* @group TriggerFactory
*
* @description Used to instantiate and execute Trigger Handlers associated with sObjects.
*/
public class TriggerFactory {
	/*******************************************************************************************************
	* @description List of soTypes to prevent running Handlers during Testing
	*/
	public static Set<Schema.sObjectType> Exclusions = new Set<Schema.sObjectType>();

	/*******************************************************************************************************
	* @description Map to make sure each trigger handler only runs once
	*/
	private static Map<Schema.sObjectType, Integer> Recursions = new Map<Schema.sObjectType, Integer>();
    
	/*******************************************************************************************************
	* @description Create and execute a trigger handler
	* @param soType SObject Type
	* @example
	* TriggerFactory.createHandler(soType);
	*/
	public static void createHandler(Schema.sObjectType soType) {
        
		// Get a handler appropriate to the object being processed
		ITrigger handler = getHandler(soType);

		// Allow exlcusion of Triggers from running during Unit Tests
		if (Test.isRunningTest() && Exclusions.contains(soType)) {
			System.debug('[TF - ' + soType + '] - : Not Executing (Excluded)...');
		}
		else if (isFirstRun(soTYpe)) {
			execute(handler, soType);
		} 
		else {
			System.debug('[TF - ' + soType + '] - : Not Executing (Recursive call)...');
		}
	}

	/*******************************************************************************************************
	* @description Control the execution of the handler
	* @param handler A Trigger Handler to execute
	* @param soType Object type to process
	* @example
	* TriggerFactory.execute(handler, soType);
	*/
	private static void execute(ITrigger handler, Schema.sObjectType soType) {
		// Before Trigger
		if (Trigger.isBefore) {
			// Call the bulk before to handle any caching of data and enable bulkification
			handler.bulkBefore();

			// Iterate through the records to be deleted passing them to the handler.
			if (Trigger.isDelete) {
				for (SObject so : Trigger.old) {
					handler.beforeDelete(so);
				}
			}
			// Iterate through the records to be inserted passing them to the handler.
			else if (Trigger.isInsert) {
				for (SObject so : Trigger.new) {
					handler.beforeInsert(so);
				}
			}
			// Iterate through the records to be updated passing them to the handler.
			else if (Trigger.isUpdate) {
				for (SObject so : Trigger.old) {
					handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
		}
		else {
			// Call the bulk after to handle any caching of data and enable bulkification
			handler.bulkAfter();

			// Iterate through the records deleted passing them to the handler.
			if (Trigger.isDelete) {
				for (SObject so : Trigger.old) {
					handler.afterDelete(so);
				}
			}
			// Iterate through the records inserted passing them to the handler.
			else if (Trigger.isInsert) {
				for (SObject so : Trigger.new) {
						handler.afterInsert(so);
				}
			}
			// Iterate through the records updated passing them to the handler.
			else if (Trigger.isUpdate) {
				for (SObject so : Trigger.old) {
					handler.afterUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
		}

		// Perform any post processing
		handler.andFinally();
	}

	/*******************************************************************************************************
	* @description Get the appropriate handler for the object type.
	* @param soType Object type to process
	* @example
	* TriggerFactory.getHandler(soType);
	*/
	private static ITrigger getHandler(Schema.sObjectType soType) {
		try {
			String handlerName = soType.getDescribe().getName().replaceAll('__c|__', '');
			handlerName = handlerName.replaceAll('forms', ''); 
			return (ITrigger)Type.forName(handlerName + 'TriggerHandler').newInstance();
		} 
		catch(Exception e) {

			String handlerName = soType.getDescribe().getName().replaceAll('__c|__', '');
			handlerName = handlerName.replaceAll('forms', ''); 

			throw new TriggerException('No Trigger Handler registered for Object Type: ' + soType + ' ' + handlerName);
		}
	}

	/*******************************************************************************************************
	* @description Calculate whether the Trigger Handler for the soType has ran once before and after
	* @param soType Object type to process
	* @example
	* TriggerFactory.isFirstRun(soType);
	*/
	private static Boolean isFirstRun(Schema.sObjectType soType) {
		Integer recCount = Recursions.containsKey(soType) ? Recursions.get(soType) : 0;

		recCount = recCount + 1;

		Recursions.put(soType, recCount);
        
		return recCount < 3 ? true : false;
	}
}