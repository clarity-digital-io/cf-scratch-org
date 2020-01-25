@isTest
public class CreateResponseAnswersTest {

    @testSetup
    public static void setup(){
                
        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

        List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(new List<Clarity_Form__c>{ form });

    }

    @isTest
    public static void shouldCreateAnswersOnResponseCreate() {

        Clarity_Form__c form = [SELECT Id, Status__c FROM Clarity_Form__c LIMIT 1];

        List<Clarity_Form_Question__c> questions = [SELECT Id FROM Clarity_Form_Question__c];

        Test.startTest();       
            
            Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

        Test.stopTest(); 

        List<Clarity_Form_Answer__c> answers = [SELECT Id FROM Clarity_Form_Answer__c];

        System.assertNotEquals(questions.size(), answers.size());

    }

}
