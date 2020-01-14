@isTest
public class CreateResponseAnswersTest {

    @testSetup
    public static void setup(){
                
        forms__Form__c form = ClarityTestDataFactory.generateForm();

        List<forms__Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(form);

    }

    @isTest
    public static void shouldCreateAnswersOnResponseCreate() {

        forms__Form__c form = [SELECT Id, Status__c FROM forms__Form__c LIMIT 1];

        List<forms__Form_Question__c> questions = [SELECT Id FROM forms__Form_Question__c];

        Test.startTest();       
            
            forms__Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

        Test.stopTest(); 

        List<forms__Form_Answer__c> answers = [SELECT Id FROM forms__Form_Answer__c];

        System.assertNotEquals(questions.size(), answers.size());

    }

}
