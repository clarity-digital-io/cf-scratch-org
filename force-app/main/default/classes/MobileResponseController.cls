@RestResource(urlMapping='/MobileResponseController/*')
global with sharing class MobileResponseController {
	
	@HttpGet
    global static Map<String, Map<String, List<sObject>>> getResponses() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        Map<String, Map<String, List<sObject>>> responses = MobileService.getMobileResponses();

        return responses;

	}
	
	@HttpPost
    global static Map<String, String> submitResponse() {

		String requestBody = RestContext.request.requestBody.toString();

		List<Answer> answers = (List<Answer>) JSON.deserialize(requestBody, List<Answer>.class);

		// List<String> answerValues = incomingAnswers.get('data'); 

		// String answerImages = answerValues[0];
        // String answers = answerValues[1];
		// String formResponseId = answerValues[2]; 

		// if(answerImages != '') {
		// 	List<Clarity_Form_Answer__c> savedAnswerImages = FormService.upload(answerImages); 
		// }

		List<sObject> savedAnswers = save(answers); 

        // List<String> success = FormService.updateStatus(new List<String>{ formResponseId }, 'Submitted');
		
		Map<String, String> test = new Map<String, String>(); 

        return test;

	}

	public static List<sObject> save(List<Answer> answers) {

		List<sObject> records = new List<sObject>(); 

		for(Answer answer: answers) {

			Clarity_Form_Response__c response = new Clarity_Form_Response__c(
				UUID__c = answer.responseId,
				Clarity_Form__c = answer.formId
			);

			records.add(response);

			Clarity_Form_Answer__c newAnswer = new Clarity_Form_Answer__c(
				Clarity_Form_Response__r = new Clarity_Form_Response__c(UUID__c = response.UUID__c),
				Answer__c = answer.answer,
				Clarity_Form_Question__c = answer.questionId
			);

			records.add(newAnswer);

		}
		
		Boolean hasPermission = FLSUtility.isCreateable(records[0]);

		if(hasPermission) {

			List<Database.SaveResult> results = Database.insert(records, true); 

			for(Database.SaveResult result : results) {
				
				if(!result.isSuccess()) {

					System.debug('error: ' + result.getErrors());

				}

			}
			
		}

        return records;

	}

	global class Answer {
		global String answer; 
		global Id questionId;
		global String type; 
		global String responseId;
		global String formId;
	}
	
}