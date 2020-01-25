@isTest
public class ConnectionRecordProcessTest {

    @testSetup
    public static void setup(){
                
        List<Clarity_Form__c> forms = ClarityTestDataFactory.generateForms(5);

        List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(forms);
		//response 1 prep
        List<Clarity_Form_Connection__c> connections = ClarityTestDataFactory.generateConnections(true, forms[0], new List<String>{ 'Opportunity' });

        ClarityTestDataFactory.generateConnectionFields(connections[0], new Map<String, Id>{'ForecastCategoryName' =>  questions[0].Id });

        ClarityTestDataFactory.publishForm(forms[0]);

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(forms[0]);
		//response 2 prep
		List<Clarity_Form_Connection__c> connections2 = ClarityTestDataFactory.generateConnections(true, forms[1], new List<String>{ 'Opportunity' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections2[0], new Map<String, String>{ 'Name' => 'Custom Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        ClarityTestDataFactory.publishForm(forms[1]);

		Clarity_Form_Response__c response2 = ClarityTestDataFactory.generateResponse(forms[1]);

        ClarityTestDataFactory.generateAnswers(response2, questions);
		
		//response 3 prep
        List<Clarity_Form_Connection__c> connections3 = ClarityTestDataFactory.generateConnections(true, forms[2], new List<String>{ 'Opportunity', 'Contact' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections3[0], new Map<String, String>{ 'Name' => 'Custom Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections3[1], new Map<String, String>{ 'FirstName' => 'Clarity', 'LastName' => 'Developer' });

        ClarityTestDataFactory.publishForm(forms[2]);

        Clarity_Form_Response__c response3 = ClarityTestDataFactory.generateResponse(forms[2]);

        ClarityTestDataFactory.generateAnswers(response3, questions);

        Clarity_Form_Question__c question = [SELECT Id, Type__c, Title__c FROM Clarity_Form_Question__c WHERE Type__c = 'Comment' AND Clarity_Form__c =: forms[2].Id LIMIT 1];

		ClarityTestDataFactory.updateAnswer(response3, question);

		//response 4 prep
        List<Clarity_Form_Connection__c> connections4 = ClarityTestDataFactory.generateConnections(true, forms[3], new List<String>{ 'Opportunity' });

        List<Clarity_Form_Question__c> questions4 = [SELECT Id, Type__c, Title__c FROM Clarity_Form_Question__c WHERE Type__c = 'Comment' AND Clarity_Form__c =: forms[3].Id];

        ClarityTestDataFactory.generateConnectionFields(connections4[0], new Map<String, String>{ 'Name' => questions4[0].Id });

        ClarityTestDataFactory.generateCustomConnectionFields(connections4[0], new Map<String, String>{ 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        ClarityTestDataFactory.publishForm(forms[3]);

        Clarity_Form_Response__c response4 = ClarityTestDataFactory.generateResponse(forms[3]);

        ClarityTestDataFactory.generateAnswers(response4, questions4);
		
		//response 5 prep
        List<Clarity_Form_Connection__c> connections5 = ClarityTestDataFactory.generateConnections(true, forms[4],  new List<String>{ 'Account', 'Opportunity' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections5[0], new Map<String, String>{ 'Name' => 'Custom Account Name' });

        ClarityTestDataFactory.generateCustomConnectionFields(connections5[1], new Map<String, String>{ 'Name' => 'Custom Opportunity Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030', 'AccountId' => '{Connection_Account}' });

        ClarityTestDataFactory.publishForm(forms[4]);

        Clarity_Form_Response__c response5 = ClarityTestDataFactory.generateResponse(forms[4]);

        List<Clarity_Form_Question__c> questions5 = [SELECT Id,  Type__c, Title__c FROM Clarity_Form_Question__c WHERE Type__c = 'Comment' AND Clarity_Form__c =: forms[4].Id];

        ClarityTestDataFactory.generateAnswers(response5, questions5);
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
