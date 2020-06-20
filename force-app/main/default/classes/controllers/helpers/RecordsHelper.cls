public with sharing class RecordsHelper {
	
	public static List<sObject> getRecords(List<Form_Connection__c> formConnections, List<Response_Connection__c> responseConnections, Response__c response) {

		List<sObject> records = new List<sObject>(); 

		Map<Id, Response_Connection__c> responseConnectionById = new Map<Id, Response_Connection__c>(); 

        for(Response_Connection__c responseConnection : responseConnections) {
            responseConnectionById.put(responseConnection.Form_Connection__c, responseConnection);
        }

		for(Form_Connection__c formConnection : formConnections) {
	
			List<String> sFields = new List<String>(); 

			Response_Connection__c responseConnection = responseConnectionById.get(formConnection.Id); 

			Map<String, Form_Connection_Field__c> uniqueFields = new Map<String, Form_Connection_Field__c>(); 

			for(Form_Connection_Field__c field : formConnection.Form_Connection_Fields__r) {
				uniqueFields.put(field.Salesforce_Field__c, field);
			}

			for(Form_Connection_Field__c field : uniqueFields.values()) {
				if(field.Salesforce_Field__c != 'Id' && field.Salesforce_Field__c != 'Name' && field.Salesforce_Field__c != 'Subject') {
					sFields.add(field.Salesforce_Field__c);
				}
			}

			String joinedFields = '';

			if(sFields.size() > 0) {
				joinedFields = String.join(sFields, ', ');
				joinedFields = joinedFields.removeEnd(',');
				if(joinedFields != null && joinedFields != '') {
					joinedFields = ', ' + joinedFields;
				}
			} 

			String record = responseConnection.Record__c;

			String returningField = 'Name';

			if(formConnection.Salesforce_Object__c == 'Case') {
				returningField = 'Subject';
			}

			sObject result = Database.query('SELECT Id, ' + returningField + ' ' + joinedFields + ' FROM ' + formConnection.Salesforce_Object__c + ' WHERE Id = :record LIMIT 1');

			records.add(result);
		}

		return records; 

	}

	public static Map<Id, List<sObject>> getRecordGroupSubmissions(List<Answer__c> answers, List<Question__c> questions) {

        Map<Id, List<sObject>> recordGroupSubmissions = new Map<Id, List<sObject>>();

        Map<String, Set<String>> recordGroupFields = new Map<String, Set<String>>(); 
		

        //get the field names by sboject
        for(Question__c question : questions) {

            if(question.Record_Group__c != null) {

                String sObjectName = question.Record_Group__r.Salesforce_Object__c;

                Id recordGroupId = question.Record_Group__c; 

                String field = question.Salesforce_Field__c;

				Schema.SObjectType convertType = Schema.getGlobalDescribe().get(sObjectName);

				Map<String, Schema.SObjectField> sObjectFields = convertType.getDescribe().fields.getMap();

				Boolean access = sObjectFields.get(field).getDescribe().isAccessible();

                if(recordGroupFields.get(sObjectName) != null && access) {

                    recordGroupFields.get(sObjectName).add(field);

                } else if(access) {

                    recordGroupFields.put(sObjectName, new Set<String>{ field });

                }

            }
        }

        Map<String, Set<String>> recordIdsBySObjectName = new Map<String, Set<String>>(); 

        Map<String, Set<String>> recordIdsByRecordGroupId = new Map<String, Set<String>>(); 

        Map<Id, Id> recordGroupIdByRecordId = new Map<Id, Id>();

        //get the recordIds created by sobject name that way we can query for them
        //we will also need to be able to know which recordIds belong to which record group/question ids
        //ability to get sbojectname by recordgroupid
        for(Answer__c answer : answers) {

            if(answer.Question__r.Type__c == 'RecordGroup') {

                Id recordId = answer.Record__c; 
                Id recordGroupId = answer.Question__c; 
                String sObjectName = answer.Question__r.Salesforce_Object__c;

                if(recordIdsBySObjectName.get(sObjectName) != null) {

                    recordIdsBySObjectName.get(sObjectName).add(recordId);

                } else {

                    recordIdsBySObjectName.put(sObjectName, new Set<String>{ recordId });

                }

                if(recordIdsByRecordGroupId.get(recordGroupId) != null) {

                    recordIdsByRecordGroupId.get(recordGroupId).add(recordId);

                } else {

                    recordIdsByRecordGroupId.put(recordGroupId, new Set<String>{ recordId });

                }

                recordGroupIdByRecordId.put(recordId, recordGroupId); 

            }
        }

        //need to be able to query for sobject recordIds only once and assign results to map by questionId/recordGroupId
        for(String sObjectName : recordGroupFields.keySet()) {

            List<String> sFields = new List<String>(recordGroupFields.get(sObjectName));

            Set<String> recordIds = recordIdsBySObjectName.get(sObjectName);

            String joinedFields = '';

            if(sFields.size() > 0) {
                joinedFields = String.join(sFields, ', ');
                joinedFields = joinedFields.removeEnd(',');
                joinedFields = ', ' + joinedFields;
            } 

            List<sObject> results = Database.query('SELECT Id ' + joinedFields + ' FROM ' + sObjectName + ' WHERE Id IN :recordIds WITH SECURITY_ENFORCED');

            for(sObject result : results) {

                Id recordGroupId = recordGroupIdByRecordId.get(result.Id); 

                if(recordGroupSubmissions.get(recordGroupId) != null) {
                    
                    recordGroupSubmissions.get(recordGroupId).add(result); 

                } else {

                    recordGroupSubmissions.put(recordGroupId, new List<sObject> { result }); 

                }

            }

        }

        return recordGroupSubmissions;

    }

}
