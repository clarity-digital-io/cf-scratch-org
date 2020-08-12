@isTest
public class FormSummaryControllerUnitTest {
	
	@TestSetup
	static void setup(){

		User user = TestDataFactory.generateUserWithBuilderPermissions(); 

		System.runAs(user) {

			Form__c form = TestDataFactory.generateForm(); 

			List<Question__c> newQuestions = TestDataFactory.generateQuestions(new List<Form__c>{ form });
	
			BuilderController.save(JSON.serialize(newQuestions));
	
			ResponseController.createResponse(form.Id, JSON.serialize(new Map<String, String>()));

		}
		
	}

	@isTest
	public static void shouldGetForm() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id formId = existingForm.Id; 

			Test.startTest();

				Form__c form = FormSummaryController.getForm(formId);

			Test.stopTest();

			System.assertEquals(formId, form.Id);

		}

	}

	@isTest
	public static void shouldGetFormResponses() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id formId = existingForm.Id; 

			List<Response__c> existingResponses = [SELECT Id FROM Response__c];

			Test.startTest();

				List<Response__c> responses = FormSummaryController.getFormResponses(formId);

			Test.stopTest();

			System.assertEquals(existingResponses.size(), responses.size());

		}

	}

	@isTest
	public static void shouldDeleteFormResponse() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Response__c existingResponse = [SELECT Id FROM Response__c LIMIT 1];

			Test.startTest();

				String deletedResponseId = FormSummaryController.deleteFormResponse(existingResponse.Id);

			Test.stopTest();

			System.assertEquals(existingResponse.Id, Id.valueOf(deletedResponseId));

		}

	}

	@isTest
	public static void shouldNotDeleteForm() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id formId = existingForm.Id; 

			Test.startTest();

				try {
					String deletedFormId = FormSummaryController.deleteForm(formId);
				} catch (AuraHandledException e) {
					System.assertEquals('Script-thrown exception', e.getMessage());
				}
				
			Test.stopTest();

		}

	}

	@isTest
	public static void shouldDeleteForm() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id formId = existingForm.Id; 

			Response__c existingResponse = [SELECT Id FROM Response__c LIMIT 1];

			String deletedResponseId = FormSummaryController.deleteFormResponse(existingResponse.Id);

			Test.startTest();

				String deletedFormId = FormSummaryController.deleteForm(formId);

			Test.stopTest();

			System.assertEquals(formId, Id.valueOf(deletedFormId));

		}

	}

	@isTest
	public static void shouldPublishForm() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id formId = existingForm.Id; 

			Test.startTest();

				Form__c form = FormSummaryController.publishForm(formId);

			Test.stopTest();

			System.assertEquals('Published', form.Status__c);

		}

	}

	@isTest
	public static void shouldGetAnswerColumns() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c form = [SELECT Id FROM Form__c Limit 1];

			Response__c response = [SELECT Id FROM Response__c Limit 1];

			List<Question__c> questions = [SELECT Id, Type__c, Title__c FROM Question__c];

			TestDataFactory.generateAnswers(response, questions);

			Test.startTest();

				//Map<String, List<Map<String, String>>> answers = FormSummaryController.getAnswerColumns(form.Id);

			Test.stopTest();

			//System.assertNotEquals(true, answers.size() == 0);

		}
		
	}

}
