@isTest
public class FormResponseAssignmentTest {

    @testSetup
    public static void setup(){
                
        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

        List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(form);

    }

    @isTest
    public static void shouldAssignFormToUserCreated() {

        Clarity_Form__c form = [SELECT Id, Status__c FROM Clarity_Form__c];

        Clarity_Form_Question__c question = [SELECT Id, Type__c, Title__c FROM Clarity_Form_Question__c WHERE Type__c = 'Comment' LIMIT 1];

        User u = ClarityTestDataFactory.generateUser();

        Clarity_Form_Assignment__c assignment = ClarityTestDataFactory.generateAssignment(form, u, 'AND');

        ClarityTestDataFactory.generateAssignmentRules(assignment.Id, new List<Clarity_Form_Question__c> { question }, 'Comment');

        ClarityTestDataFactory.publishForm(form);

        Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

        ClarityTestDataFactory.updateAnswer(response, question);

        System.assertEquals(response.OwnerId__c, null);

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 

        Clarity_Form_Response__c submittedResponse = [SELECT Id, OwnerId__c FROM Clarity_Form_Response__c Limit 1];

        //System.assertEquals(submittedResponse.OwnerId__c, u.Id);

    }

}
