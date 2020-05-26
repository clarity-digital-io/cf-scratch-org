@RestResource(urlMapping='/Responses/*')
global with sharing class ResponsesResource {
	
	@HttpGet
    global static List<Response__c> getResponses() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        //Map<String, Map<String, List<sObject>>> forms = MobileService.getMobileForms();

		// Map<String, Map<String, List<sObject>>> forms = FormsService.

		List<Response__c> responses = ResponsesService.getResponses();

        return responses;

    }
}