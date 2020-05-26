public with sharing class ResponsesService {

	public static List<Response__c> getResponses() {
		return service().getResponses();
	}

	public static List<Response__c> saveResponse(List<Response> responses, Boolean mobile) {
		return service().saveResponse(responses, mobile);
	}

	public static IResponsesService service(){
		return (IResponsesService) Application.service.newInstance(IResponsesService.class);
	}

}

