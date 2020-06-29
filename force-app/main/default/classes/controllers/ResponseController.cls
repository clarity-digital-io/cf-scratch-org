global with sharing class ResponseController {

	@RemoteAction 
    global static List<Form_Connection__c> getRequiredConnections(String responseId) {

		List<Form_Connection__c> requiredConnections = FormConnectionsService.getConnectionsByResponseId(responseId); 

        return requiredConnections;

	}

	@RemoteAction 
	global static List<sObject> saveConnections(String responseId, String sConnections) {

		List<Map<String, String>> parsedConnections = (List<Map<String, String>>)JSON.deserialize(sConnections, List<Map<String, String>>.class);
		//update lookups on response object keep on single service to use domain / unit of work
		Response__c response = ResponsesService.getResponseById(responseId); 

		List<Response_Connection__c> responseConnections = ResponsesService.saveConnections(responseId, parsedConnections); 

		List<Form_Connection__c> formConnections = FormConnectionsService.getConnectionsByFormId(response.Form__c); 

		List<sObject> records = RecordsHelper.getRecords(formConnections, responseConnections, response); 

		return records; 

	}

	@RemoteAction 
	global static Map<String, List<sObject>> edit(String responseId) {

		Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

		Response__c response = ResponsesService.getResponseWithDetailsById(responseId); 

		Form__c form = FormsService.getFormById(response.Form__c); 

		List<Form_Connection__c> formConnections = FormConnectionsService.getConnectionsByFormId(response.Form__c); 

		List<Form_Connection_Field__c> mappingFields = new List<Form_Connection_Field__c>(); 
		List<Form_Connection_Field__c> prefillFields = new List<Form_Connection_Field__c>(); 

		for(Form_Connection__c connection : formConnections) {
			for(Form_Connection_Field__c connectionField : connection.Form_Connection_Fields__r) {
				if(connectionField.PreFill__c) {
					prefillFields.add(connectionField);
				} else {
					mappingFields.add(connectionField);
				}
			}
		}

		formDetails.put('Connections', response.forms__Response_Connections__r);
		formDetails.put('Answers', response.Answers__r);
		formDetails.put('Questions', form.Questions__r);
        formDetails.put('FormResponse', new List<sObject>{ response });

		formDetails.put('Form', new List<sObject>{ form });
		formDetails.put('Mapping', mappingFields);
		formDetails.put('Prefills', prefillFields);

		return formDetails; 

	}

	@RemoteAction
	global static List<Answer__c> uploadAttachment(List<String> answerValues) {

		String answerImageName = answerValues[0];
		String answerImages = answerValues[1];
		String questionId = answerValues[2]; 
		String responseId = answerValues[3]; 

		List<ContentVersion> attachments = AttachmentsHelper.getContentVersions(answerImageName, answerImages, questionId, responseId);

		List<Answer__c> answers = AnswersService.save(attachments, questionId, responseId); 

		return answers; 

	}

	@RemoteAction
    global static Response__c save(List<String> answerValues) {

        String answers = answerValues[0];
		String responseId = answerValues[1]; 
		String status = answerValues[2];

		List<Answer__c> parsedAnswers = (List<Answer__c>)JSON.deserialize(answers, List<Answer__c>.class);
		
		Response__c response = ResponsesService.save(parsedAnswers, responseId, status); 

        return response; 

	}
	
	@RemoteAction 
    global static List<LookupResult> search(List<String> searchItems) {

        String searchTerm = searchItems[0];
        String lookupObject = searchItems[1];
        String questionId = searchItems[2]; 

		String returningField = 'Name';

		if(lookupObject == 'Case') {
			returningField = 'Subject';
		}

		Schema.SObjectType convertType = Schema.getGlobalDescribe().get(lookupObject);

		List<LookupResult> results = new List<LookupResult>();

		Boolean access = convertType.getDescribe().isAccessible();

		if(access) {

			String searchString = 'FIND :searchTerm IN ALL FIELDS RETURNING ' + lookupObject + ' (Id, ' + returningField + ')';

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
    global static Map<Id, List<sObject>> getRecordGroupResults(String responseId, String formId) {
		
        List<Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c, Choice_Image__c, Order__c FROM Question_Options__r), 
            (SELECT Id, Field_Type__c, Field__c, Operator__c, Type__c, Value__c, Question__c FROM Question_Criteria__r),
            Salesforce_Object__c, FreeText_Type__c, Title__c, Order__c, Required__c, Lookup__c, 
            Salesforce_Field__c, Record_Group__c, Record_Group__r.Salesforce_Object__c, 
            Page__c, Type__c FROM Question__c WHERE Form__c =: formId];

        List<Answer__c> answers = [SELECT Id, Record__c, Answer__c, Date_Answer__c, ContentDocument__c, 
            Question__r.Salesforce_Object__c, Response__c, Question__c, 
            Question__r.Record_Group__c, Question__r.Type__c  
            FROM Answer__c WHERE Response__c =: responseId];

        Map<Id, List<sObject>> records = RecordsHelper.getRecordGroupSubmissions(answers, questions);

        return records; 

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