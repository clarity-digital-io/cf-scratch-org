@RestResource(urlMapping='/Forms/*')
global with sharing class FormsResource {
	
	@HttpGet
    global static List<Form__c> getForms() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        //Map<String, Map<String, List<sObject>>> forms = MobileService.getMobileForms();

		// Map<String, Map<String, List<sObject>>> forms = FormsService.

		List<Form__c> forms = FormsService.getForms();

        return forms;

    }
}