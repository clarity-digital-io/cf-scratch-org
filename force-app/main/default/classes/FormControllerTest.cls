@isTest
public class FormControllerTest {

    @testSetup
    public static void setup(){
                
        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

        List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(new List<Clarity_Form__c>{ form });

        Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

    }

    @isTest
    public static void shouldGetForm() {

        Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c Limit 1];

        Clarity_Form__c formReturned = FormController.getForm(form.Id);

        System.assertEquals('Clarity Form', formReturned.Label__c);

    }

    @isTest
    public static void shouldGetFormResponses() {

        Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c Limit 1];

        List<Clarity_Form_Response__c> responses = FormController.getFormResponses(null, form.Name);

        System.assertEquals(1, responses.size());

    }

    @isTest
    public static void shouldDeleteFormResponse() {

        Clarity_Form_Response__c response = [SELECT Id FROM Clarity_Form_Response__c Limit 1]; 

        String deleteFormResponseId = FormController.deleteFormResponse(response.Id);

        System.assertEquals(response.Id, deleteFormResponseId);
    }

    @isTest
    public static void shouldNotDeleteForm() {

        Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c Limit 1];

        List<Clarity_Form_Response__c> responses = [SELECT Id FROM Clarity_Form_Response__c]; 

        try {
            String status = FormController.deleteForm(form.Id);
        } catch (AuraHandledException e) {
            System.assertEquals('Script-thrown exception', e.getMessage());
        }

        System.assertNotEquals(0, responses.size());

    }

    @isTest
    public static void shouldDeleteForm() {

        Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c Limit 1];

        List<Clarity_Form_Response__c> responses = [SELECT Id FROM Clarity_Form_Response__c]; 

        Test.startTest();
            delete responses; 
        Test.stopTest();

        String status = FormController.deleteForm(form.Id);

        System.assertEquals('Success', status);

    }

    @isTest
    public static void shouldPublishForm() {

        Clarity_Form__c form = [SELECT Id, Status__c FROM Clarity_Form__c Limit 1];

        System.assertNotEquals('Published', form.Status__c);

        Test.startTest();

            Clarity_Form__c updatedForm = FormController.publishForm(form.Id);

        Test.stopTest();

        System.assertEquals('Published', updatedForm.Status__c);

    }

	@isTest
	public static void shouldGetAnswerColumns() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c Limit 1];

        Clarity_Form_Response__c response = [SELECT Id FROM Clarity_Form_Response__c Limit 1];

		List<Clarity_Form_Question__c> questions = [SELECT Id, Type__c, Title__c FROM Clarity_Form_Question__c];

		ClarityTestDataFactory.generateAnswers(response, questions);

		Test.startTest();

			Map<String, List<Map<String, String>>> answers = FormController.getAnswerColumns(form.Id);

		Test.stopTest();

		System.assertNotEquals(true, answers.size() == 0);
	}
}
