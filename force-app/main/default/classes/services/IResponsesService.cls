public interface IResponsesService {
	List<Response__c> getResponses();
	List<Response__c> saveResponse(List<Response> responses, Boolean mobile);
}