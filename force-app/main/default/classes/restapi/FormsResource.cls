@RestResource(urlMapping='/Forms/*')
global with sharing class FormsResource {
	
	@HttpGet
    global static List<Form> getForms() {

        RestRequest req = RestContext.request;

		RestResponse res = RestContext.response;
		
		List<Form> preparedForms = new List<Form>(); 

		List<Form__c> forms = FormsService.getForms();

		List<Question__c> questions = QuestionsService.getQuestions();

		Map<Id, List<Question__c>> formQuestions = new Map<Id, List<Question__c>>();

		for(Question__c question : questions) {
			if(formQuestions.get(question.Form__c) != null) {
				formQuestions.get(question.Form__c).add(question);
			} else {
				formQuestions.put(question.Form__c, new List<Question__c>{ question });
			}
		}
		
		for(Form__c form : forms) {
			Form preparedForm = new Form();
			preparedForm.form = form; 
			preparedForm.questions = formQuestions.get(form.Id) != null ? formQuestions.get(form.Id) : new List<Question__c>();
			preparedForm.responses = form.Responses__r;
			preparedForms.add(preparedForm);
		}

        return preparedForms;

	}
	
	global class Form {
		global Form__c form;
		global List<Question__c> questions;
		global List<Response__c> responses;
	}
}

