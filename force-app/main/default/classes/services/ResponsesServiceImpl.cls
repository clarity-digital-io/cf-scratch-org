public class ResponsesServiceImpl implements IResponsesService {

	public List<Response__c> getResponses() {
		List<Response__c> responses = ResponsesSelector.newInstance().selectRecent();
		return responses; 
	}

	public Response__c getResponseWithDetailsById(String responseId) {
		List<Response__c> responses = ResponsesSelector.newInstance().selectWithAllDetailsByIds(new Set<Id>{ responseId });
		return responses[0]; 
	}

	public Response__c getResponseById(String responseId) {
		List<Response__c> responses = ResponsesSelector.newInstance().selectById(new Set<Id>{ responseId });
		return responses[0]; 
	}

	public List<Response__c> getResponsesByOwner(List<String> userIds) {
		List<Response__c> responses = ResponsesSelector.newInstance().getResponsesByOwner(userIds);
		return responses; 
	}

	public Response__c create(String formId) {
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		Response__c newResponse = new Response__c(
			Form__c = formId,
			Status__c = 'New'
		);

		uow.registerNew(newResponse);

		uow.commitWork();	

		return newResponse;
	}

	public Response__c save(List<Answer__c> newAnswers, String responseId, String status) {

		List<Response__c> responses = ResponsesSelector.newInstance().selectById(new Set<Id>{ responseId });
		Response__c response = responses[0];
		response.Status__c = status; 

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		IAnswers ans = Answers.newInstance(newAnswers);				

		ans.save(uow); 

		uow.registerUpsert(response);

		uow.commitWork();	

		return response; 
		
	}

	public List<Response__c> saveResponse(List<Response> responses, Boolean mobile) {
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());
		
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

	public List<Response_Connection__c> saveConnections(String responseId, List<Map<String, String>> parsedConnections) {

		List<Response__c> responses = ResponsesSelector.newInstance().selectById(new Set<Id>{ responseId });

		Response__c response = responses[0];

		List<Response_Connection__c> connections = new List<Response_Connection__c>(); 

		for(Map<String, String> parsedConnection : parsedConnections) {

            Response_Connection__c connection = new Response_Connection__c(
                Record__c = parsedConnection.get('key'),
                Form_Connection__c = parsedConnection.get('connectionId'),
                Response__c = responseId
            );

			connections.add(connection); 
			
			String fieldName = parsedConnection.containsKey('sObject') ? parsedConnection.get('sObject') : '';
			String recordId = parsedConnection.containsKey('key') ? parsedConnection.get('key') : '';
			Boolean fieldCheck = SObjectType.Response__c.fields.getMap().containsKey('forms__connection_' + fieldName.toLowerCase() + '__c');
			
			if(fieldCheck) {
				response.put('forms__Connection_' + fieldName + '__c', recordId);
			}

        }

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerNew(connections);
		uow.registerUpsert(response); 
		uow.commitWork();	

		return connections;

	}

}
