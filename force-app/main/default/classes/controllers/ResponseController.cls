public with sharing class ResponseController {

	@AuraEnabled
    public static Response__c getResponse(String recordId) {

		Response__c response = ResponsesService.getResponseWithDetailsById(recordId); 

		return response; 

	}
	
	@AuraEnabled(cacheable=true)
	public static List<Response__c> getResponses(String recordId){

		List<Response__c> responses = ResponsesService.getResponsesByConnectedId(recordId); 

		return responses; 

	}
	
	@AuraEnabled(cacheable=true)
	public static List<Form_Connection__c> getConnections(String recordId){

		List<Form_Connection__c> connections = FormConnectionsService.getConnectionsByFormId(recordId); 

		return connections;

	}

	@AuraEnabled(cacheable=true)
	public static List<Question__c> getQuestions(String recordId){

		List<Question__c> questions = QuestionsService.getFormQuestions(recordId); 

		List<Question> questionList = new List<Question>();

		for(Question__c q : questions) {
			questionList.add(new Question(q));
		} 

		questionList.sort();

		List<Question__c> results = new List<Question__c>();

		for(Question q : questionList) {
			results.add(q.question);
		}

		return results;

	}

	@AuraEnabled
	public static Id saveResponse(String formId, String sResponse, String status, String recordId){

		Map<String, String> parsedResponse = (Map<String, String>)JSON.deserialize(sResponse, Map<String, String>.class);

		Response__c newResponse = ResponsesService.create(formId, recordId);

		List<Answer__c> answers = new List<Answer__c>(); 

		for(String questionId : parsedResponse.keySet()) {
			Answer__c answer = new Answer__c(
				Question__c = questionId,
				Answer__c = parsedResponse.get(questionId),
				Response__c = newResponse.Id
			);
			answers.add(answer);
		}

		Response__c response = ResponsesService.save(answers, newResponse.Id, status); 

		return response.Id;

	}
	
	@AuraEnabled(cacheable=true)
	public static List<LookupSearchResult> formSearch(String searchTerm, List<String> selectedIds) {
		
		Integer MAX_RESULTS = 5;

		searchTerm += '%';

		List<Form__c> forms = [SELECT Id, Name, Title__c, Description__c FROM Form__c WHERE Title__c LIKE :searchTerm AND Id NOT IN :selectedIds LIMIT :MAX_RESULTS];

		List<LookupSearchResult> results = new List<LookupSearchResult>();

		String formIcon = 'standard:record';

		for (Form__c form : forms) {
			results.add(
				new LookupSearchResult(
					form.Id,
					'Form',
					formIcon,
					form.Title__c,
					'Form • ' + form.Description__c
				)
			);
		}

		results.sort();

		return results;
	}

	@AuraEnabled(cacheable=true)
	public static List<LookupSearchResult> connectionSearch(String searchTerm, List<String> selectedIds, String connection) {
		
		Integer MAX_RESULTS = 5;

		searchTerm += '%';

		List<sObject> records = Database.query('SELECT Id, Name FROM ' + connection + ' WHERE Name Like :searchTerm AND Id NOT IN :selectedIds LIMIT :MAX_RESULTS');

		List<LookupSearchResult> results = new List<LookupSearchResult>();

		String recordIcon = 'standard:record';

		for (sObject record : records) {
			results.add(
				new LookupSearchResult(
					record.Id,
					'Form',
					recordIcon,
					(String)record.get('Name'),
					connection
				)
			);
		}

		results.sort();

		return results;
	}
}