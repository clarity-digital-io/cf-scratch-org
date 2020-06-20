public with sharing class ResponsesService {

	public static List<Response__c> getResponses() {
		return service().getResponses();
	}

	public static List<Response__c> getResponsesByOwner(List<String> users) {
		return service().getResponsesByOwner(users);
	}

	public static Response__c getResponseWithDetailsById(String responseId) {
		return service().getResponseWithDetailsById(responseId);
	}

	public static Response__c getResponseById(String responseId) {
		return service().getResponseById(responseId);
	}

	public static Response__c create(String formId) {
		return service().create(formId);
	}

	public static Response__c save(List<Answer__c> answers, String responseId, String status) {
		return service().save(answers, responseId, status);
	}

	public static List<Response__c> saveResponse(List<Response> responses, Boolean mobile) {
		return service().saveResponse(responses, mobile);
	}

	public static List<Response_Connection__c> saveConnections(String responseId, List<Map<String, String>> connections) {
		return service().saveConnections(responseId, connections);
	}

	public static IResponsesService service(){
		return (IResponsesService) Application.service.newInstance(IResponsesService.class);
	}

}

