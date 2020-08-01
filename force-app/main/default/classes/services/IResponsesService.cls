public interface IResponsesService {
	Id deleteById(String responseId);
	List<String> deleteResponsesByUUIDs(List<String> UUIDs);
	Response__c save(List<Answer__c> answers, String responseId, String status);
	List<Response__c> save(List<Response__c> responses, Schema.sObjectField uniqueExternalField);
	Response__c create(String formId);
	Response__c create(String formId, Map<String, String> connectionRecordIds);
	Response__c getResponseWithDetailsById(String responseId);
	Response__c getResponseById(String responseId);
	List<Response__c> getResponsesByFormId(String formId);
	List<Response__c> getResponses();
	List<Response__c> getResponsesByOwner(List<String> userIds);
	List<Response__c> getResponsesByConnectedId(String recordId);
	List<Response_Connection__c> saveConnections(String responseId, List<Map<String, String>> connections);
	Map<String, List<Map<String, String>>> getResultAnswersByFormId(String recordId, Integer offset);
	sObject upsertConnectionSObject(sObject record, Form_Connection_Process__c connectionStatus, Response__c response);
	void updateFormConnectionStatus(Form_Connection_Process__c connectionStatus);
}