@RestResource(urlMapping='/MobileFormController/*')
global with sharing class MobileFormController {
	
	@HttpGet
    global static Map<String, Map<String, List<sObject>>> getForms() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        Map<String, Map<String, List<sObject>>> forms = ClarityFormsService.getMobileForms();

        return forms;

    }
}
