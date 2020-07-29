public with sharing class ResponseController {

	@AuraEnabled(cacheable=true)
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
	public static List<Form_Connection__c> getConnections(String formId){

		List<Form_Connection__c> connections = FormConnectionsService.getConnectionsByFormId(formId); 

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
	public static Response__c createResponse(String formId, String sRecordIds){
		
		Map<String, String> parsedConnectedRecordIds = (Map<String, String>)JSON.deserialize(sRecordIds, Map<String, String>.class);

		Response__c newResponse = ResponsesService.create(formId, parsedConnectedRecordIds);

		return newResponse;

	}

	@AuraEnabled
	public static Id saveResponse(String responseId, String sAnswers, String status){

		Map<String, String> parsedAnswers = (Map<String, String>)JSON.deserialize(sAnswers, Map<String, String>.class);

		List<Answer__c> answers = new List<Answer__c>(); 

		for(String questionId : parsedAnswers.keySet()) {
			Answer__c answer = new Answer__c(
				Question__c = questionId,
				Answer__c = parsedAnswers.get(questionId),
				Response__c = responseId
			);
			answers.add(answer);
		}

		Response__c response = ResponsesService.save(answers, responseId, status); 

		return responseId;

	}

	@AuraEnabled
	public static Id editResponse(String responseId, String sAnswers, String status){

		Map<String, String> parsedAnswers = (Map<String, String>)JSON.deserialize(sAnswers, Map<String, String>.class);

		List<Answer__c> answers = new List<Answer__c>(); 

		for(String questionId : parsedAnswers.keySet()) {
			Answer__c answer = new Answer__c(
				Question__c = questionId,
				Answer__c = parsedAnswers.get(questionId),
				Response__c = responseId
			);
			answers.add(answer);
		}

		return responseId;

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

		String nameField = 'Name';

		if(connection == 'Case') {
			nameField = 'Subject';
		}

		List<sObject> records = Database.query('SELECT Id, ' + nameField + ' FROM ' + connection + ' WHERE ' + nameField + ' Like :searchTerm AND Id NOT IN :selectedIds LIMIT :MAX_RESULTS');

		List<LookupSearchResult> results = new List<LookupSearchResult>();

		String recordIcon = 'standard:record';

		for (sObject record : records) {
			results.add(
				new LookupSearchResult(
					record.Id,
					'Form',
					recordIcon,
					(String)record.get(nameField),
					connection
				)
			);
		}

		results.sort();

		return results;
	}
}