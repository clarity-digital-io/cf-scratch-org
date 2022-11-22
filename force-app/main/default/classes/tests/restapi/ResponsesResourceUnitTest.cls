@isTest
public class ResponsesResourceUnitTest {

	@TestSetup
	public static void setup(){
		
		User user = TestDataFactory.generateUserWithBuilderPermissions(); 

		System.runAs(user) {

			Form__c form = TestDataFactory.generateForm(); 

			Form__c updatedForm = FormsService.updateForm(form);

			List<Question__c> newQuestions = TestDataFactory.generateQuestions(new List<Form__c>{ form });

			List<Question__c> questions = QuestionsService.saveQuestions(newQuestions);

			updatedForm.Status__c = 'Published';

			Form__c publishedForm = FormsService.updateForm(updatedForm);

			Response__c response = ResponseController.createResponse( publishedForm.Id, JSON.serialize(new Map<String, String>()) );

			Response__c response2 = ResponseController.createResponse( publishedForm.Id, JSON.serialize(new Map<String, String>()) );

		}
	}

	@isTest
	public static void shouldDeleteResponses() {
		
		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];

		System.runAs(user) {

			List<Response__c> responses = [SELECT Id, UUID__c FROM Response__c];

			System.assertEquals(2, responses.size());

			List<String> uuids = new List<String>();

			for(Response__c response : responses) {
				uuids.add(response.UUID__c);
			}

			RestRequest request = new RestRequest();

			request.httpMethod = 'DELETE';
			request.requestBody = Blob.valueOf(JSON.serialize(uuids));

			RestContext.request = request;

			ResponsesResource.deleteResponses();

			Test.startTest();

				List<Response__c> afterDelete = [SELECT Id FROM Response__c];

			Test.stopTest();

			System.assertEquals(0, afterDelete.size());

		}

	}

	@isTest
	public static void shouldUpdateResponses() {

				
		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];

		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id existingFormId = existingForm.Id; 
			
			Map<String, String> data = new Map<String, String>();

			List<Response> responses = new List<Response>();

			for (Integer i = 0; i < 5; i++) {
				
				Response response = new Response();

				response.OwnerId = UserInfo.getUserId();
				response.Status = 'In Progress';
				response.UUID = 'TEST-123' + i;
				response.Form = existingFormId;

				responses.add(response);

			}

			data.put('data', JSON.serialize(responses));

			RestRequest request = new RestRequest();

			request.httpMethod = 'POST';
			request.requestBody = Blob.valueOf(JSON.serialize(data));

			RestContext.request = request;

			ResponsesResource.updateResponses();

			Test.startTest();

				List<Response__c> updatedResponses = [SELECT Id FROM Response__c];

			Test.stopTest();

			System.assertEquals(7, updatedResponses.size());

		}

	}

}
