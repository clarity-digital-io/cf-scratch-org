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

	public static List<Response__c> getResponsesByFormId(String responseId) {
		return service().getResponsesByFormId(responseId);
	}

	public static List<Response__c> getResponsesByConnectedId(String recordId) {
		return service().getResponsesByConnectedId(recordId);
	}

	public static Response__c getResponseById(String responseId) {
		return service().getResponseById(responseId);
	}

	public static Response__c create(String formId) {
		return service().create(formId);
	}

	public static Response__c create(String formId, Map<String, String> connectionRecordIds) {
		return service().create(formId, connectionRecordIds);
	}

	public static Response__c save(List<Answer__c> answers, String responseId, String status) {
		return service().save(answers, responseId, status);
	}

	public static List<Response__c> save(List<Response__c> responses, Schema.sObjectField uniqueExternalField) {
		return service().save(responses, uniqueExternalField);
	}

	public static List<Response_Connection__c> saveConnections(String responseId, List<Map<String, String>> connections) {
		return service().saveConnections(responseId, connections);
	}

	public static Id deleteById(String responseId) {
		return service().deleteById(responseId);
	}

	public static List<String> deleteResponsesByUUIDs(List<String> UUIDs) {
		return service().deleteResponsesByUUIDs(UUIDs);
	}

	public static Map<String, List<Map<String, String>>> getResultAnswersByFormId(String recordId, Integer offset) {
		return service().getResultAnswersByFormId(recordId, offset);
	}

	public static sObject upsertConnectionSObject(sObject record, Form_Connection_Process__c connectionStatus, Response__c response) {
		return service().upsertConnectionSObject(record, connectionStatus, response);
	}

	public static void updateFormConnectionStatus(Form_Connection_Process__c connectionStatus) {
		service().updateFormConnectionStatus(connectionStatus);
	}

	public static IResponsesService service(){
		return (IResponsesService) Application.service.newInstance(IResponsesService.class);
	}

}

