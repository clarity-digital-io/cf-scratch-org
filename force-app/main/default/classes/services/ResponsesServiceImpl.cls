public class ResponsesServiceImpl implements IResponsesService {

	public List<Response__c> getResponses() {
		List<Response__c> responses = ResponsesSelector.newInstance().selectRecent();
		return responses; 
	}

	public List<Response__c> saveResponse(List<Response> responses, Boolean mobile) {
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
		
		List<Response__c> newResponses = new List<Response__c>();
		for(Response response : responses) {

			Response__c newResponse = new Response__c(
				Form__c = response.formId,
				UUID__c = response.responseId,
				Status__c = 'Submitted'
			);

			uow.registerNew(newResponse);

			for(Answer answer : response.answers) {
	
				Answer__c newAnswer = new Answer__c(
					Question__c = answer.questionId, 
					Response__c = newResponse.Id,
					Answer__c 	= answer.answer
				);
	
				uow.registerNew(newAnswer, Answer__c.Response__c, newResponse);
	
			}
			newResponses.add(newResponse);			
		}
		uow.commitWork();	
		
		return newResponses; 
		
	}

}
