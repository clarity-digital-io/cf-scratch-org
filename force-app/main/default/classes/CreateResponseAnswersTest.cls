@isTest
public class CreateResponseAnswersTest {

    @testSetup
    public static void setup(){
                
        Form__c form = TestDataFactory.generateForm();

        List<Question__c> questions = TestDataFactory.generateQuestions(new List<Form__c>{ form });

    }

    @isTest
    public static void shouldCreateAnswersOnResponseCreate() {

        Form__c form = [SELECT Id, Status__c FROM Form__c LIMIT 1];

        List<Question__c> questions = [SELECT Id FROM Question__c];

        Test.startTest();       
            
            Response__c response = TestDataFactory.generateResponse(form);

        Test.stopTest(); 

        List<Answer__c> answers = [SELECT Id FROM Answer__c];

        System.assertNotEquals(questions.size(), answers.size());

    }

}
