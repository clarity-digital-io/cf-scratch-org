@RestResource(urlMapping='/Responses/*')
global with sharing class ResponsesResource {
	
	@HttpGet
    global static List<Response__c> getResponses() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

		List<Response__c> responses = ResponsesService.getResponses();

        return responses;

	}
	
	@HttpPost
    global static List<Response__c> saveResponse() {

        RestRequest req = RestContext.request;

		RestResponse res = RestContext.response;
		
		String requestBody = RestContext.request.requestBody.toString();
		
		List<Response> responses = (List<Response>) JSON.deserialize(requestBody, List<Response>.class);

		// Call Service Method - Is mobile Yes
		List<Response__c> insertedResponses = ResponsesService.saveResponse(responses, true);

        return insertedResponses;

	}
	
}