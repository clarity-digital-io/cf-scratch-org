public with sharing class WizardController {

	@AuraEnabled
	public static String getSetup(){

		//String response = SetupService.getOrganizationInformation(); 

		Organization organization = [Select Id, Name FROM Organization Limit 1]; 

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://clarity-mobile-api.herokuapp.com/information/' + organization.Id);
		request.setHeader('Content-Type', 'application/json');
		request.setMethod('POST');
		HttpResponse response = http.send(request);

		return response.getBody(); 

	}

	@AuraEnabled
	public static void createConnect(){

		//String response = SyncService.connectOrganization(); 

		Organization organization = [Select Id, Name FROM Organization Limit 1]; 

		List<Form> preparedForms = new List<Form>(); 

		List<Form__c> forms = FormsService.getFormsByStatus('Published');

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
			preparedForms.add(preparedForm);
		}

		Connect connect = new Connect(); 

		connect.org = organization;
		connect.forms =  preparedForms;

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://clarity-mobile-api.herokuapp.com/connect/' + organization.Id);
		request.setBody(JSON.serialize(connect));
		request.setHeader('Content-Type', 'application/json');
		request.setMethod('POST');
		request.setTimeout(20000);
		HttpResponse response = http.send(request);
		System.debug('response.getStatusCode: ' + response.getStatusCode()); 
		System.debug('response.getBody: ' + response.getBody()); 

		if (response.getStatusCode() == 200) {

		}

	}

	public static void usersSync() {

		//String response = SyncService.registerUsers(); 

		Organization organization = [Select Id, IsSandbox, Name FROM Organization Limit 1]; 

		//query salesforce users
		List<String> users = new List<String>();

		List<PermissionSetAssignment> psas = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Clarity_Forms_Mobile'];

		for(PermissionSetAssignment psa : psas) {
			//probably can remove sandbox notice
			users.add(psa.AssigneeId); 
		}

		List<Response__c> responses = ResponsesService.getResponsesByOwner(users);

		Map<Id, List<Response__c>> ownerResponses = new Map<Id, List<Response__c>>(); 

		for(Response__c response : responses) {
			if(ownerResponses.get(response.OwnerId) != null) {
				ownerResponses.get(response.OwnerId).add(response); 
			} else {
				ownerResponses.put(response.OwnerId, new List<Response__c>{ response });
			}
		}

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('http://thawing-falls-33419.herokuapp.com/register/' + organization.Id );
		request.setBody(JSON.serialize(ownerResponses));
		request.setHeader('Content-Type', 'application/json');
		request.setMethod('POST');
		request.setTimeout(20000);
		HttpResponse response = http.send(request);

		if (response.getStatusCode() == 200) {

		}

	}


	public class Connect {
		public Organization org;
		public List<Form> forms;
	}

	public class Form {
		public Form__c form;
		public List<Question__c> questions;
	}

}
