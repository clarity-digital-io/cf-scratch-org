global with sharing class BuilderController {

	@RemoteAction
    global static List<String> save(String sQuestions){

        List<Question__c> parsedQuestions = (List<Question__c>)JSON.deserialize(sQuestions, List<Question__c>.class);
		
		List<String> saved = QuestionsService.saveQuestions(parsedQuestions);

		return saved; 
		
	}

	@RemoteAction
    global static Form__c getForm(String formId) {
		
		Form__c form = FormsService.getFormById(formId);

		return form;

    }
	
	@RemoteAction
    global static Form__c updateForm(String sForm) {

		Form__c parsedForm = (Form__c)JSON.deserialize(sForm, Form__c.class);

		Form__c form = FormsService.updateForm(parsedForm);

        return parsedForm;
    
	}
	
	@RemoteAction
    global static List<Question__c> getQuestions(String recordId){

		List<Question__c> questions = QuestionsService.getFormQuestions((Id)recordId); 
		
        return questions; 

	}
	
	@RemoteAction
    global static String saveQuestion(String sQuestion) {

		Question__c parsedQuestion = (Question__c)JSON.deserialize(sQuestion, Question__c.class);
		
		List<String> saved = QuestionsService.saveQuestions(new List<Question__c> { parsedQuestion });

		return saved[0]; 

	}

	@RemoteAction
    global static Map<String, List<sObject>> saveQuestionWithOptions(String sQuestion, String sQuestionOptions) {

		Map<String, Object> mapSObject = (Map<String, Object>) JSON.deserializeUntyped( sQuestion );

		mapSObject.remove( 'forms__Question_Options__r' );

		Question__c parsedQuestion = (Question__c)JSON.deserialize(JSON.serialize(mapSObject), Question__c.class);
		//need to delete previous options
		List<Question_Option__c> parsedQuestionOptions = (List<Question_Option__c>)JSON.deserialize(sQuestionOptions, List<Question_Option__c>.class);

        Map<String, List<sObject>> results = QuestionsService.saveQuestionWithDetails(parsedQuestion, parsedQuestionOptions);
		
		return results;

	}

}
