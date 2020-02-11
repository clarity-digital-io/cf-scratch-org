// getResponses(Filter || Status || Null / Page) => Map (Responses with Questions+)

// submit(Response) => Response object with updated status

@RestResource(urlMapping='/MobileResponseController/*')
global with sharing class MobileResponseController {
	
	@HttpGet
    global static Map<String, Map<String, List<sObject>>> getResponses() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        Map<String, Map<String, List<sObject>>> responses = ClarityFormsService.getMobileResponses();

        return responses;

	}
	
	@HttpPost
    global static List<String> submitResponse(List<String> answerValues) {

		String answerImages = answerValues[0];
        String answers = answerValues[1];
		String formResponseId = answerValues[2]; 

		List<Clarity_Form_Answer__c> savedAnswerImages = ClarityFormsService.upload(answerImages); 

		List<Clarity_Form_Answer__c> savedAnswers = ClarityFormsService.save(answers); 
		
        List<String> success = ClarityFormsService.updateStatus(new List<String>{ formResponseId }, 'Submitted');

        return success;

    }
}
