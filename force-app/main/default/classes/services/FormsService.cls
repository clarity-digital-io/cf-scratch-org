public with sharing class FormsService {

	
	public static Map<String, Map<String, sObject>> getMobileRecords() {

		Map<String, Map<String, sObject>> records = new Map<String, Map<String, sObject>>(); 

		List<Form__c> forms = [SELECT Id FROM Form__c WHERE Status__c = 'Published'];

		List<Id> formIds = new List<Id>(); 

		for (Form__c form : forms) {
			formIds.add(form.Id); 
		}

		List<Form_Connection__c> formConnections = [SELECT Id, Form__c, Salesforce_Object__c, New__c, 
		(SELECT Id, Salesforce_Field__c, PreFill__c, Custom_Value__c, Question__c FROM Form_Connection_Fields__r) 
		FROM Form_Connection__c WHERE Form__c IN :formIds];


		Map<String, Set<String>> objectFields = new Map<String, Set<String>>(); 

		for(Form_Connection__c formConnection : formConnections) {

			for(Form_Connection_Field__c field : formConnection.Form_Connection_Fields__r) {
							
				if(objectFields.get(formConnection.Salesforce_Object__c) != null) {

					Set<String> fields = objectFields.get(formConnection.Salesforce_Object__c); 
					fields.add(field.Salesforce_Field__c);
					objectFields.put(formConnection.Salesforce_Object__c, fields); 

				} else {

					Set<String> fields = new Set<String>();

					if(formConnection.Salesforce_Object__c == 'Case') {
						fields.add('Subject');
					} else {
						fields.add('Name');
					}

					fields.add('Id');
					fields.add(field.Salesforce_Field__c);
					
					objectFields.put(formConnection.Salesforce_Object__c, fields); 

				}
            }
			
		}

		Integer limitCount = 0;

		for(String objectName : objectFields.keySet()) {

			if(limitCount > 10) {
				continue; 
			}

			List<String> sFields = new List<String>(); 

			Set<String> fields = objectFields.get(objectName); 

			String joinedFields = '';

			for(String field : fields) {
				sFields.add(field);
			}

			if(sFields.size() > 0) {
				joinedFields = String.join(sFields, ', ');
				joinedFields = joinedFields.removeEnd(',');
			} 
			System.debug('joinedFields: ' + joinedFields); 
			String sQuery = 'SELECT ' + joinedFields + ' FROM ' + objectName + ' LIMIT 50';

			List<sObject> results = Database.query(sQuery);

			Map<String, sObject> sObjectRecords = new Map<String, sObject>(); 

			for(SObject result : results) {
				sObjectRecords.put(result.Id, result);
			} 

			records.put(objectName, sObjectRecords);

			limitCount = limitCount + 1; 

		}

		return records;
	}

	public static List<Form__c> getForms() {
		return service().getForms();
	}

	public static Form__c getFormById(String formId) {
		return service().getFormById(formId);
	}

	public static Form__c updateForm(Form__c form) {
		return service().updateForm(form);
	}

	public static IFormsService service(){
		return (IFormsService) Application.service.newInstance(IFormsService.class);
	}
}

