@isTest
public class FormSummaryControllerTest {

    @testSetup
    public static void setup(){
                
        Form__c form = TestDataFactory.generateForm();

        List<Question__c> questions = TestDataFactory.generateQuestions(new List<Form__c>{ form });

        Response__c response = TestDataFactory.generateResponse(form);

	}

    @isTest
    public static void shouldGetForm() {

        Form__c form = [SELECT Id FROM Form__c Limit 1];

        Form__c formReturned = FormSummaryController.getForm(form.Id);

        System.assertEquals('Clarity Form', formReturned.Label__c);

    }

    @isTest
    public static void shouldGetFormResponses() {

        Form__c form = [SELECT Id, Name FROM Form__c Limit 1];

        List<Response__c> responses = FormSummaryController.getFormResponses(null, form.Name, null, null);

        System.assertEquals(1, responses.size());

    }

    @isTest
    public static void shouldDeleteFormResponse() {

        Response__c response = [SELECT Id FROM Response__c Limit 1]; 

        String deleteFormResponseId = FormSummaryController.deleteFormResponse(response.Id);

        System.assertEquals(response.Id, deleteFormResponseId);
    }

    @isTest
    public static void shouldNotDeleteForm() {

        Form__c form = [SELECT Id, Name FROM Form__c Limit 1];

        List<Response__c> responses = [SELECT Id FROM Response__c]; 

        try {
            String status = FormSummaryController.deleteForm(form.Id);
        } catch (AuraHandledException e) {
            System.assertEquals('Script-thrown exception', e.getMessage());
        }

        System.assertNotEquals(0, responses.size());

    }

    @isTest
    public static void shouldDeleteForm() {

        Form__c form = [SELECT Id, Name FROM Form__c Limit 1];

        List<Response__c> responses = [SELECT Id FROM Response__c]; 

        Test.startTest();
            delete responses; 
        Test.stopTest();

        String status = FormSummaryController.deleteForm(form.Id);

        System.assertEquals('Success', status);

    }

    @isTest
    public static void shouldPublishForm() {

        Form__c form = [SELECT Id, Status__c FROM Form__c Limit 1];

        System.assertNotEquals('Published', form.Status__c);

        Test.startTest();

            Form__c updatedForm = FormSummaryController.publishForm(form.Id);

        Test.stopTest();

        System.assertEquals('Published', updatedForm.Status__c);

    }

	@isTest
	public static void shouldGetAnswerColumns() {

		Form__c form = [SELECT Id FROM Form__c Limit 1];

        Response__c response = [SELECT Id FROM Response__c Limit 1];

		List<Question__c> questions = [SELECT Id, Type__c, Title__c FROM Question__c];

		TestDataFactory.generateAnswers(response, questions);

		Test.startTest();

			Map<String, List<Map<String, String>>> answers = FormSummaryController.getAnswerColumns(form.Id);

		Test.stopTest();

		System.assertNotEquals(true, answers.size() == 0);
	}
}
