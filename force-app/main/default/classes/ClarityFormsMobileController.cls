@RestResource(urlMapping='/api/ClarityFormsMobile/*')
global with sharing class ClarityFormsMobileController {

    @HttpGet
    global static Map<String, Map<String, List<sObject>>> getForms() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        Map<String, Map<String, List<sObject>>> forms = ClarityFormsService.getForms();

        return forms;

    }

    @HttpPut 
    global static List<forms__Form_Answer__c> save() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        String body = RestContext.request.requestBody.toString();

        Map<String, List<String>> sAnswers = (Map<String, List<String>>)JSON.deserialize(body, Map<String, List<String>>.class);
        
        String saveAnswers = ClarityFormsService.prepareAnswers(sAnswers); 

        List<forms__Form_Answer__c> savedAnswers = ClarityFormsService.save(saveAnswers); 

        return savedAnswers;

    }

    @HttpPost
    global static List<String> submit() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        String body = RestContext.request.requestBody.toString();

        List<String> responseIds = (List<String>)JSON.deserialize(body, List<String>.class);

        List<String> success = ClarityFormsService.updateStatus(responseIds, 'Submitted');

        return success; 

    }

}
