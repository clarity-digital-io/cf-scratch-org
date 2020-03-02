@RestResource(urlMapping='/MobileSyncController/*')
global with sharing class MobileSyncController {
	
	@HttpPost
    global static Map<String, String> updateResponses(Map<String, List<String>> responseWithAnswers) {

		System.debug('responseWithAnswers: ' + responseWithAnswers);

		Map<String, String> statusUpdates =  new Map<String, String>(); 
		
		for(String responseId : responseWithAnswers.keySet()) {

			List<String> answerValues = responseWithAnswers.get(responseId); 

			String answerImages = answerValues[0];
			String answers = answerValues[1];
			String status = answerValues[2]; 
			String formId = answerValues[3];

			if(responseId.contains('New')) {

				responseId = ClarityFormsService.createMobile(formId); 
				statusUpdates.put(responseId, 'New'); 

			} else {

				statusUpdates.put(responseId, 'In Progress'); 

			}
			
			if(answerImages != '') {
				List<Clarity_Form_Answer__c> savedAnswerImages = ClarityFormsService.upload(answerImages); 
			}
	
			if(answers != '') {
				List<Clarity_Form_Answer__c> savedAnswers = ClarityFormsService.save(answers);
			}
			
			List<String> updatedStatus = ClarityFormsService.updateStatus(new List<String>{ responseId }, status);

			statusUpdates.put(responseId, updatedStatus[0]);

		}

        return statusUpdates;

	}


/**
 * 
 * User has input some details on the form
 * They have "saved" response on mobile
 * They have "submitted" response on mobile
 * 
 * Basically a saved or submitted response (In progress)
 * 
 * resposne { answer: answer, answer: answer, answer: image }
 * 
 * A Synced boolean and a Last Sync Date Check Might be helpful
 * 
 */
	
 //Maybe add history tracking for response form changes
}
