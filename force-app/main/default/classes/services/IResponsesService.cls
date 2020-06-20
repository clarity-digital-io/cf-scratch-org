public interface IResponsesService {
	Response__c save(List<Answer__c> answers, String responseId, String status);
	Response__c create(String formId);
	Response__c getResponseWithDetailsById(String responseId);
	Response__c getResponseById(String responseId);
	List<Response__c> getResponses();
	List<Response__c> getResponsesByOwner(List<String> userIds);
	List<Response__c> saveResponse(List<Response> responses, Boolean mobile);
	List<Response_Connection__c> saveConnections(String responseId, List<Map<String, String>> connections);
}