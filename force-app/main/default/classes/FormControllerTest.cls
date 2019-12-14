@isTest
public class FormControllerTest {

    @testSetup
    public static void setup(){
                
        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

        List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(form);

        Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

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

    // @isTest
    // public static void shouldCloneForm() {

    //     Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c Limit 1];

    //     List<Clarity_Form_Question__c> questions = [SELECT Id FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id]; 

    //     Test.startTest();

    //         Id newFormId = FormController.cloneForm(form.Id);

    //     Test.stopTest();

    //     System.assertNotEquals(form.Id, newFormId);

    //     List<Clarity_Form_Question__c> clonedQuestions = [SELECT Id FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: newFormId]; 

    //     System.assertEquals(questions.size(), clonedQuestions.size()); 

    //     System.assertEquals(2, forms.size());

    // }

    @isTest
    public static void shouldPublishForm() {

        Clarity_Form__c form = [SELECT Id, Status__c FROM Clarity_Form__c Limit 1];

        System.assertNotEquals('Published', form.Status__c);

        Test.startTest();

            String status = FormController.publishForm(form.Id);

        Test.stopTest();

        Clarity_Form__c updatedForm = [SELECT Id, Status__c FROM Clarity_Form__c Limit 1];

        System.assertEquals('Published', updatedForm.Status__c);

    }
}
