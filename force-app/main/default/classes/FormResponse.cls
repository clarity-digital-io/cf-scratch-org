global with sharing class FormResponse {

    private final static Integer MAX_RESULTS = 5;
    
    @RemoteAction
    global static Map<String, List<sObject>> preview(String formId) {

        Map<String, List<sObject>> formDetails = FormService.create((Id)formId);

        return formDetails; 

    }

    @RemoteAction 
    global static List<Form_Connection__c> checkConnections(String responseId) {
        
        List<Form_Connection__c> requiredConnections = new List<Form_Connection__c>(); 

        Response__c response = [SELECT Id, Form__c FROM Response__c WHERE Id =: responseId LIMIT 1];

        Map<Id, Form_Connection__c> connections = new Map<Id, Form_Connection__c>([SELECT Id, Salesforce_Object__c, New__c FROM Form_Connection__c WHERE Form__c =: response.Form__c AND New__c = false]);

        if(connections.size() > 0) {

            List<Response_Connection__c> responseConnections = [SELECT Id, Form_Connection__c 
                FROM Response_Connection__c WHERE Response__c =: responseId AND Form_Connection__c IN :connections.keySet()];

            if(responseConnections.size() == 0) {
                return connections.values();
            } 

            Set<Id> responseConnectedIds = new Set<Id>(); 

            for(Response_Connection__c rc : responseConnections){
                responseConnectedIds.add(rc.Form_Connection__c); 
            }
			System.debug('responseConnectedIds: ' + responseConnectedIds); 
            for(Form_Connection__c connection : connections.values()) {
                if(!responseConnectedIds.contains(connection.Id)) {
                    requiredConnections.add(connection); 
                }
            }

        }

        return requiredConnections;
    }

    @RemoteAction
    global static List<Form_Connection__c> getConnections(String formName) {

        Form__c form = [SELECT Id FROM Form__c WHERE Name =: formName LIMIT 1];

        List<Form_Connection__c> connections = [SELECT Id, Salesforce_Object__c, New__c FROM Form_Connection__c WHERE Form__c =: form.Id];

        return connections; 

    }

    @RemoteAction
    global static Map<Id, List<sObject>> getRecordGroupResults(String responseId, String formId) {

        List<Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c, Choice_Image__c, Order__c FROM Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Flow_Designs__r LIMIT 1),
            (SELECT Id, Field_Type__c, Field__c, Operator__c, Type__c, Value__c, Question__c FROM Question_Criteria__r),
            Salesforce_Object__c, FreeText_Type__c, Title__c, Order__c, Required__c, Lookup__c, 
            Salesforce_Field__c, Record_Group__c, Record_Group__r.Salesforce_Object__c, 
            Page__c, Type__c FROM Question__c WHERE Form__c =: formId];

        List<Answer__c> answers = [SELECT Id, Record__c, Answer__c, Date_Answer__c, ContentDocument__c, 
            Question__r.Salesforce_Object__c, Response__c, Question__c, 
            Question__r.Record_Group__c, Question__r.Type__c  
            FROM Answer__c WHERE Response__c =: responseId];

        Map<Id, List<sObject>> records = FormService.getRecordGroupSubmissions(answers, questions);

        return records; 

    }

    @RemoteAction
    global static Map<String, List<sObject>> create(String formName, String sConnections) {

        Map<String, List<sObject>> formDetails = FormService.create(formName, sConnections);

        return formDetails; 

    }

    @RemoteAction
    global static Map<String, List<sObject>> edit(String responseId, String sConnections) {

        Map<String, List<sObject>> formDetails = FormService.edit(responseId, sConnections);

        return formDetails; 

    }

    @RemoteAction
    global static List<Answer__c> saveAnswer(String answers){

        List<Answer__c> savedAnswers = FormService.save(answers); 

        return savedAnswers;
        
    }

    @RemoteAction
    global static List<String> save(List<String> answerValues) {

        String answerImages = answerValues[0];
        String answers = answerValues[1];
        String formResponseId = answerValues[2]; 

        List<Answer__c> savedAnswerImages = FormService.upload(answerImages); 

        List<Answer__c> savedAnswers = FormService.save(answers); 

        List<String> success = FormService.updateStatus(new List<String>{ formResponseId }, 'In Progress');

        return success; 

    }

    @RemoteAction
    global static List<String> submit(List<String> answerValues) {

        String answerImages = answerValues[0];
        String answers = answerValues[1];
        String formResponseId = answerValues[2]; 

        List<Answer__c> savedAnswerImages = FormService.upload(answerImages); 

        List<Answer__c> savedAnswers = FormService.save(answers); 

        List<String> success = FormService.updateStatus(new List<String>{ formResponseId }, 'Submitted');

        return success; 
        
    }
	
    @RemoteAction 
    global static List<LookupResult> search(List<String> searchItems) {

        String searchTerm = searchItems[0];
        String lookupObject = searchItems[1];
        String questionId = searchItems[2]; 

        searchTerm += '*';

		String returningField = 'Name';

		if(lookupObject == 'Case') {
			returningField = 'Subject';
		}

		Schema.SObjectType convertType = Schema.getGlobalDescribe().get(lookupObject);

		List<LookupResult> results = new List<LookupResult>();

		Boolean access = convertType.getDescribe().isAccessible();

		if(access) {

			String searchString = 'FIND ' + '\'%' + searchTerm + '%\'' + ' IN ALL FIELDS RETURNING ' + lookupObject + ' (Id, ' + returningField + ')';

			List<List<sObject>> searchResults = search.query(searchString);


			List<sObject> records = ((List<sObject>) searchResults[0]);

			for (sObject record : records) {
				results.add(new LookupResult(record.Id, lookupObject, (String)record.get(returningField), lookupObject));
			}

		}

        return results;
    }

    @RemoteAction 
    global static sObject createRecord(List<String> recordValues) {

        String responseId = recordValues[0]; 
        String recordGroupId = recordValues[1]; 
        String sObjectName = recordValues[2];
        String records = recordValues[3];

        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(sObjectName);

        List<Record> recordFields = (List<Record>)JSON.deserialize(records, List<Record>.class);

        sObject genericObject = convertType.newSObject();

        Map<String, Schema.SObjectField> sObjectFields = convertType.getDescribe().fields.getMap();

        for(Record record : recordFields) {

			Boolean accessField = sObjectFields.get(record.field).getDescribe().isCreateable();

			if(accessField) {

				if(record.type == 'Date') {

					Date value = Date.valueOf(record.value);
					genericObject.put(record.field, value);

				} else {
					
					genericObject.put(record.field, record.value);

				}

			}

        }

		Boolean access = convertType.getDescribe().isCreateable(); 

		if(access) {
        
			Database.UpsertResult result = Database.upsert(genericObject, true); 

			if(!result.isSuccess()) {

				System.debug('error: ' + result.getErrors());

			}

			Answer__c answer = new Answer__c(
				Response__c = responseId, 
				Question__c = recordGroupId,
				Record__c                = result.getId()
			);

			Database.UpsertResult resultAnswer = Database.upsert(answer, true); 

			if(!resultAnswer.isSuccess()) {

				System.debug('error: ' + resultAnswer.getErrors());

			}

		} else {

			System.debug('User lacks create access to this object.');

		}
		
		return genericObject;

    }

    @RemoteAction
    global static Map<String, Map<String, Map<String, String>>> getRecordGroupPicklist(List<String> sPicklistQuestionIds) {

        List<Question__c> picklistQuestions = [SELECT Id, Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, 
            Record_Group__r.Salesforce_Object__c, Salesforce_Field__c, Type__c FROM Question__c WHERE ID IN :sPicklistQuestionIds];

        Map<String, List<String>> rcp = FormService.filterRecordGroupPicklist(picklistQuestions);

        Map<String, Map<String, Map<String, String>>> values = FormService.getSalesforcePicklistValues(rcp);

        return values; 

    }

    global class Record {

        public String field; 
        public String value; 
        public String type; 

    }

    global class LookupResult {

        private Id id;
        private String type;
        private String label;
        private String subTitle;

        public LookupResult(Id id, String type, String label, String subTitle) {
            this.id = id;
            this.type = type;
            this.label = label;
            this.subTitle = subTitle;
        }

    }
    
}
