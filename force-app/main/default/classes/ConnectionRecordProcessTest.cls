@isTest
public class ConnectionRecordProcessTest {

    @testSetup
    public static void setup(){
                
        forms__Form__c form = ClarityTestDataFactory.generateForm();

        List<forms__Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(form);

    }

    @isTest
    public static void shouldUpdateProcessToFailed() {
        
        ConnectionCreateJob.chainJob = false;

        forms__Form__c form = [SELECT Id, Status__c FROM forms__Form__c];

        List<forms__Form_Connection__c> connections = ClarityTestDataFactory.generateConnections(form,  new List<String>{ 'Opportunity' });

        List<forms__Form_Question__c> questions = [SELECT Id, Title__c FROM forms__Form_Question__c WHERE Type__c = 'Comment'];

        ClarityTestDataFactory.generateConnectionFields(connections[0], new Map<String, Id>{'ForecastCategoryName' =>  questions[0].Id });

        ClarityTestDataFactory.publishForm(form);

        forms__Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

        ClarityTestDataFactory.generateAnswers(response, questions);

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 

        List<forms__Form_Connection_Process__c> connectionProcess = [SELECT Id, Status__c FROM forms__Form_Connection_Process__c]; 

        for(forms__Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Failed', process.Status__c); 
        }

        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

        System.assertEquals(opportunities.size(), 0);

    }

    @isTest
    public static void shouldCreateOpportunityConnectionFromCustomValue() {

        ConnectionCreateJob.chainJob = false;

        forms__Form__c form = [SELECT Id, Status__c FROM forms__Form__c];

        List<forms__Form_Connection__c> connections = ClarityTestDataFactory.generateConnections(form,  new List<String>{ 'Opportunity' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections[0], new Map<String, String>{ 'Name' => 'Custom Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        ClarityTestDataFactory.publishForm(form);

        forms__Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

        List<forms__Form_Question__c> questions = [SELECT Id, Title__c FROM forms__Form_Question__c WHERE Type__c = 'Comment'];

        ClarityTestDataFactory.generateAnswers(response, questions);

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 

        List<forms__Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM forms__Form_Connection_Process__c]; 

        for(forms__Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

        System.assertEquals(opportunities.size(), 1);
    }

    @isTest
    public static void shouldCreateMultipleConnectionsFromCustomValues(){

        ConnectionCreateJob.chainJob = false;

        forms__Form__c form = [SELECT Id, Status__c FROM forms__Form__c];

        List<forms__Form_Connection__c> connections = ClarityTestDataFactory.generateConnections(form,  new List<String>{ 'Opportunity', 'Contact' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections[0], new Map<String, String>{ 'Name' => 'Custom Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections[1], new Map<String, String>{ 'FirstName' => 'Clarity', 'LastName' => 'Developer' });

        ClarityTestDataFactory.publishForm(form);

        forms__Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

        forms__Form_Question__c question = [SELECT Id, Title__c FROM forms__Form_Question__c WHERE Type__c = 'Comment' LIMIT 1];

        //update on answer creation
        ClarityTestDataFactory.updateAnswer(response, question);

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 

        List<forms__Form_Connection_Process__c> connectionProcess = [SELECT Id, Status__c FROM forms__Form_Connection_Process__c]; 

        for(forms__Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

        System.assertEquals(1, opportunities.size());

        List<Contact> contacts = [SELECT Id FROM Contact];

        System.assertEquals(1, contacts.size());

    }

    @isTest
    public static void shouldCreateOpportunityConnectionFromQuestionValue() {

        ConnectionCreateJob.chainJob = false;

        forms__Form__c form = [SELECT Id, Status__c FROM forms__Form__c];

        List<forms__Form_Connection__c> connections = ClarityTestDataFactory.generateConnections(form,  new List<String>{ 'Opportunity' });

        List<forms__Form_Question__c> questions = [SELECT Id, Title__c FROM forms__Form_Question__c WHERE Type__c = 'Comment'];

        ClarityTestDataFactory.generateConnectionFields(connections[0], new Map<String, String>{ 'Name' => questions[0].Id });

        ClarityTestDataFactory.generateCustomConnectionFields(connections[0], new Map<String, String>{ 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        ClarityTestDataFactory.publishForm(form);

        forms__Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

        ClarityTestDataFactory.generateAnswers(response, questions);

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 

        List<forms__Form_Connection_Process__c> connectionProcess = [SELECT Id, Status__c FROM forms__Form_Connection_Process__c]; 

        for(forms__Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Opportunity> opportunities = [SELECT Id, Name FROM Opportunity];

        System.assertEquals(1, opportunities.size());

        System.assertEquals('Answer for: ' + questions[0].Title__c, opportunities[0].Name);

    }

    @isTest
    public static void shouldCreateMultipleConnectionsWithAppropriateStoreIds(){

        ConnectionCreateJob.chainJob = false;

        forms__Form__c form = [SELECT Id, Status__c FROM forms__Form__c];

        List<forms__Form_Connection__c> connections = ClarityTestDataFactory.generateConnections(form,  new List<String>{ 'Account', 'Opportunity' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections[0], new Map<String, String>{ 'Name' => 'Custom Account Name' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections[1], new Map<String, String>{ 'Name' => 'Custom Opportunity Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030', 'AccountId' => '{Connection_Account}' });

        ClarityTestDataFactory.publishForm(form);

        forms__Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

        List<forms__Form_Question__c> questions = [SELECT Id, Title__c FROM forms__Form_Question__c WHERE Type__c = 'Comment'];

        ClarityTestDataFactory.generateAnswers(response, questions);

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 

        List<forms__Form_Connection_Process__c> connectionProcess = [SELECT Id, Status__c FROM forms__Form_Connection_Process__c]; 

        for(forms__Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Account> accounts = [SELECT Id FROM Account];

        System.assertEquals(accounts.size(), 1);

        List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity];

        System.assertEquals(opportunities.size(), 1);

        System.assertEquals(accounts[0].Id, opportunities[0].AccountId);

    }

}
