public class ResponsesServiceImpl implements IResponsesService {

	public List<Response__c> getResponses() {
		List<Response__c> responses = ResponsesSelector.newInstance().selectRecent();
		return responses; 
	}

}
