@isTest
public class CreateResponseAnswersTest {

    @testSetup
    public static void setup(){
                
        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

        List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(form);

    }

    @isTest
    public static void shouldAssignFormToUserCreated() {

        Clarity_Form__c form = [SELECT Id, Status__c FROM Clarity_Form__c];

        List<Clarity_Form_Question__c> questions = [SELECT Id FROM Clarity_Form_Question__c];

        Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

        Test.startTest();       
            
            List<Clarity_Form_Answer__c> answers = [SELECT Id FROM Clarity_Form_Answer__c];

            System.assertEquals(questions.size(), answers.size());

        Test.stopTest(); 

    }

}
