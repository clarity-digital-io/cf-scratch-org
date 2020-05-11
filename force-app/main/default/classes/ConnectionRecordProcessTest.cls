@isTest
public class ConnectionRecordProcessTest {

    @testSetup
    public static void setup(){
                
        List<Clarity_Form__c> forms = TestDataFactory.generateForms(5);

        List<Clarity_Form_Question__c> questions = TestDataFactory.generateQuestions(forms);
		//response 1 prep
        List<Clarity_Form_Connection__c> connections = TestDataFactory.generateConnections(true, forms[0], new List<String>{ 'Opportunity' });

        TestDataFactory.generateConnectionFields(connections[0], new Map<String, Id>{'ForecastCategoryName' =>  questions[0].Id });

        TestDataFactory.publishForm(forms[0]);

		Clarity_Form_Response__c response = TestDataFactory.generateResponse(forms[0]);
		//response 2 prep
		List<Clarity_Form_Connection__c> connections2 = TestDataFactory.generateConnections(true, forms[1], new List<String>{ 'Opportunity' });

        TestDataFactory.generateCustomConnectionFields(connections2[0], new Map<String, String>{ 'Name' => 'Custom Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        TestDataFactory.publishForm(forms[1]);

		Clarity_Form_Response__c response2 = TestDataFactory.generateResponse(forms[1]);

        TestDataFactory.generateAnswers(response2, questions);
		
		//response 3 prep
        List<Clarity_Form_Connection__c> connections3 = TestDataFactory.generateConnections(true, forms[2], new List<String>{ 'Opportunity', 'Contact' });

        TestDataFactory.generateCustomConnectionFields(connections3[0], new Map<String, String>{ 'Name' => 'Custom Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        TestDataFactory.generateCustomConnectionFields(connections3[1], new Map<String, String>{ 'FirstName' => 'Clarity', 'LastName' => 'Developer' });

        TestDataFactory.publishForm(forms[2]);

        Clarity_Form_Response__c response3 = TestDataFactory.generateResponse(forms[2]);

        TestDataFactory.generateAnswers(response3, questions);

        Clarity_Form_Question__c question = [SELECT Id, Type__c, Title__c FROM Clarity_Form_Question__c WHERE Type__c = 'Comment' AND Clarity_Form__c =: forms[2].Id LIMIT 1];

		TestDataFactory.updateAnswer(response3, question);

		//response 4 prep
        List<Clarity_Form_Connection__c> connections4 = TestDataFactory.generateConnections(true, forms[3], new List<String>{ 'Opportunity' });

        List<Clarity_Form_Question__c> questions4 = [SELECT Id, Type__c, Title__c FROM Clarity_Form_Question__c WHERE Type__c = 'Comment' AND Clarity_Form__c =: forms[3].Id];

        TestDataFactory.generateConnectionFields(connections4[0], new Map<String, String>{ 'Name' => questions4[0].Id });

        TestDataFactory.generateCustomConnectionFields(connections4[0], new Map<String, String>{ 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        TestDataFactory.publishForm(forms[3]);

        Clarity_Form_Response__c response4 = TestDataFactory.generateResponse(forms[3]);

        TestDataFactory.generateAnswers(response4, questions4);
		
		//response 5 prep
        List<Clarity_Form_Connection__c> connections5 = TestDataFactory.generateConnections(true, forms[4],  new List<String>{ 'Account', 'Opportunity' });

        TestDataFactory.generateCustomConnectionFields(connections5[0], new Map<String, String>{ 'Name' => 'Custom Account Name' });

        TestDataFactory.generateCustomConnectionFields(connections5[1], new Map<String, String>{ 'Name' => 'Custom Opportunity Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030', 'AccountId' => '{Connection_Account}' });

        TestDataFactory.publishForm(forms[4]);

        Clarity_Form_Response__c response5 = TestDataFactory.generateResponse(forms[4]);

        List<Clarity_Form_Question__c> questions5 = [SELECT Id,  Type__c, Title__c FROM Clarity_Form_Question__c WHERE Type__c = 'Comment' AND Clarity_Form__c =: forms[4].Id];

        TestDataFactory.generateAnswers(response5, questions5);
    }

    @isTest
    public static void shouldUpdateProcessToFailed() {
        
        ConnectionCreateJob.chainJob = false;

        List<Clarity_Form_Response__c> responses = [SELECT Id, Name, Status__c, Clarity_Form__c FROM Clarity_Form_Response__c];

		Clarity_Form_Response__c response = responses[0];

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

			Database.SaveResult result = Database.update(responses[0], true); 

			if(!result.isSuccess()) {
				System.debug('error');
			}
        
        Test.stopTest(); 

		List<Opportunity> opportunities = [SELECT Id, ForecastCategoryName FROM Opportunity];

        List<Clarity_Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Clarity_Form_Connection_Process__c WHERE Clarity_Form_Response__c =: response.Id]; 

        for(Clarity_Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Failed', process.Status__c); 
        }

        System.assertEquals(opportunities.size(), 0);

    }

    @isTest
    public static void shouldCreateOpportunityConnectionFromCustomValue() {

        ConnectionCreateJob.chainJob = false;

        List<Clarity_Form_Response__c> responses = [SELECT Id, Status__c FROM Clarity_Form_Response__c];

		Clarity_Form_Response__c response = responses[1];

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

			Database.SaveResult result = Database.update(response, true); 

			if(!result.isSuccess()) {
				System.debug('error');
			}
        
        Test.stopTest(); 

        List<Clarity_Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Clarity_Form_Connection_Process__c]; 

        for(Clarity_Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

        System.assertEquals(opportunities.size(), 1);
    }

    @isTest
    public static void shouldCreateMultipleConnectionsFromCustomValues(){

        ConnectionCreateJob.chainJob = false;

        List<Clarity_Form_Response__c> responses = [SELECT Id, Status__c FROM Clarity_Form_Response__c];

		Clarity_Form_Response__c response = responses[2];

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 

        List<Clarity_Form_Connection_Process__c> connectionProcess = [SELECT Id, Status__c FROM Clarity_Form_Connection_Process__c]; 

        for(Clarity_Form_Connection_Process__c process : connectionProcess) {
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

        List<Clarity_Form_Response__c> responses = [SELECT Id, Status__c, Clarity_Form__c FROM Clarity_Form_Response__c];

		Clarity_Form_Response__c response = responses[3];

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 

        List<Clarity_Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Clarity_Form_Connection_Process__c WHERE Clarity_Form_Response__c =: response.Id]; 

        for(Clarity_Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Opportunity> opportunities = [SELECT Id, Name FROM Opportunity];

        System.assertEquals(1, opportunities.size());

    }

    @isTest
    public static void shouldCreateMultipleConnectionsWithAppropriateStoreIds(){

        ConnectionCreateJob.chainJob = false;

        List<Clarity_Form_Response__c> responses = [SELECT Id, Status__c, Clarity_Form__c FROM Clarity_Form_Response__c];

		Clarity_Form_Response__c response = responses[4];

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 

        List<Clarity_Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Clarity_Form_Connection_Process__c WHERE Clarity_Form_Response__c =: response.Id]; 

        for(Clarity_Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Account> accounts = [SELECT Id FROM Account];

        System.assertEquals(accounts.size(), 1);

        List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity];

        System.assertEquals(opportunities.size(), 1);

        System.assertEquals(accounts[0].Id, opportunities[0].AccountId);

    }

}
