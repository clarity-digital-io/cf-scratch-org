@isTest
public class ConnectionCreateJobTest {

    @testSetup
    public static void setup(){
                
        List<Form__c> forms = TestDataFactory.generateForms(5);

		List<Question__c> questions = TestDataFactory.generateQuestions(forms);
		
		List<Question__c> savedQuestions = QuestionsService.saveQuestions(questions);

		//response 1 prep
        List<Form_Connection__c> connections = TestDataFactory.generateConnections(true, forms[0].Id, new List<String>{ 'Opportunity' });

        TestDataFactory.generateConnectionFields(connections[0], new Map<String, Id>{'ForecastCategoryName' =>  questions[0].Id });

		//TestDataFactory.publishForm(forms[0]);
		forms[0].Status__c = 'Published';
		Form__c updatedForm1 = FormsService.updateForm(forms[0]);

		Response__c response = ResponsesService.create(updatedForm1.Id); 

		//response 2 prep
		List<Form_Connection__c> connections2 = TestDataFactory.generateConnections(true, forms[1].Id, new List<String>{ 'Opportunity' });

        TestDataFactory.generateCustomConnectionFields(connections2[0], new Map<String, String>{ 'Name' => 'Custom Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

		//TestDataFactory.publishForm(forms[1]);
		forms[1].Status__c = 'Published';
		Form__c updatedForm2 = FormsService.updateForm(forms[1]);

		Response__c response2 = ResponsesService.create(updatedForm1.Id); 

        Map<String,String> answers2 = TestDataFactory.generateAnswers(response2, questions);
		
		//response 3 prep
        List<Form_Connection__c> connections3 = TestDataFactory.generateConnections(true, forms[2].Id, new List<String>{ 'Opportunity', 'Contact' });

        TestDataFactory.generateCustomConnectionFields(connections3[0], new Map<String, String>{ 'Name' => 'Custom Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

        TestDataFactory.generateCustomConnectionFields(connections3[1], new Map<String, String>{ 'FirstName' => 'Clarity', 'LastName' => 'Developer' });

		//TestDataFactory.publishForm(forms[2]);
		forms[2].Status__c = 'Published';
		Form__c updatedForm3 = FormsService.updateForm(forms[2]);
		
		Response__c response3 = ResponsesService.create(updatedForm3.Id); 

        Map<String,String> answers3 = TestDataFactory.generateAnswers(response3, questions);

        Question__c question = [SELECT Id, Type__c, Title__c FROM Question__c WHERE Type__c = 'Comment' AND Form__c =: forms[2].Id LIMIT 1];

		//TestDataFactory.updateAnswer(response3, question);

		//response 4 prep
        List<Form_Connection__c> connections4 = TestDataFactory.generateConnections(true, forms[3].Id, new List<String>{ 'Opportunity' });

        List<Question__c> questions4 = [SELECT Id, Type__c, Title__c FROM Question__c WHERE Type__c = 'Comment' AND Form__c =: forms[3].Id];

        TestDataFactory.generateConnectionFields(connections4[0], new Map<String, String>{ 'Name' => questions4[0].Id });

        TestDataFactory.generateCustomConnectionFields(connections4[0], new Map<String, String>{ 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });

		//TestDataFactory.publishForm(forms[3]);
		forms[3].Status__c = 'Published';
		Form__c updatedForm4 = FormsService.updateForm(forms[3]);
		
		Response__c response4 = ResponsesService.create(updatedForm4.Id); 

        Map<String,String> answers4 = TestDataFactory.generateAnswers(response4, questions4);
		
		//response 5 prep
        List<Form_Connection__c> connections5 = TestDataFactory.generateConnections(true, forms[4].Id,  new List<String>{ 'Account', 'Opportunity' });

        TestDataFactory.generateCustomConnectionFields(connections5[0], new Map<String, String>{ 'Name' => 'Custom Account Name' });

        TestDataFactory.generateCustomConnectionFields(connections5[1], new Map<String, String>{ 'Name' => 'Custom Opportunity Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030', 'AccountId' => '{Connection_Account}' });

        //TestDataFactory.publishForm(forms[4]);
		forms[4].Status__c = 'Published';
		Form__c updatedForm5 = FormsService.updateForm(forms[4]);

		Response__c response5 = ResponsesService.create(updatedForm5.Id); 

        List<Question__c> questions5 = [SELECT Id,  Type__c, Title__c FROM Question__c WHERE Type__c = 'Comment' AND Form__c =: forms[4].Id];

        Map<String,String> answers5 = TestDataFactory.generateAnswers(response5, questions5);
    }

    @isTest
    public static void shouldUpdateProcessToFailed() {
        
        ConnectionCreateJob.chainJob = false;

        List<Response__c> responses = [SELECT Id, Name, Status__c, Form__c FROM Response__c];

		Test.startTest();       

			//can skip controller to test service and process directly
			Response__c response = ResponsesService.save(new List<Answer__c>(), responses[0].Id, 'Submitted'); 
        
        Test.stopTest(); 

		List<Opportunity> opportunities = [SELECT Id, ForecastCategoryName FROM Opportunity];

        List<Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Form_Connection_Process__c WHERE Response__c =: response.Id]; 

        for(Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Failed', process.Status__c); 
        }

        System.assertEquals(opportunities.size(), 0);

    }

    @isTest
    public static void shouldCreateOpportunityConnectionFromCustomValue() {

        ConnectionCreateJob.chainJob = false;

        List<Response__c> responses = [SELECT Id, Status__c FROM Response__c];

        Test.startTest();       
            
			Response__c response = ResponsesService.save(new List<Answer__c>(), responses[1].Id, 'Submitted'); 
        
        Test.stopTest(); 

        List<Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Form_Connection_Process__c]; 

        for(Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

        System.assertEquals(opportunities.size(), 1);
    }

    @isTest
    public static void shouldCreateMultipleConnectionsFromCustomValues(){

        ConnectionCreateJob.chainJob = false;

        List<Response__c> responses = [SELECT Id, Status__c FROM Response__c];

        Test.startTest();       
            
			Response__c response = ResponsesService.save(new List<Answer__c>(), responses[2].Id, 'Submitted'); 
        
        Test.stopTest(); 

        List<Form_Connection_Process__c> connectionProcess = [SELECT Id, Status__c FROM Form_Connection_Process__c]; 

        for(Form_Connection_Process__c process : connectionProcess) {
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

        List<Response__c> responses = [SELECT Id, Status__c, Form__c FROM Response__c];

        Test.startTest();       
		
			Response__c response = ResponsesService.save(new List<Answer__c>(), responses[3].Id, 'Submitted'); 
        
        Test.stopTest(); 

        List<Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Form_Connection_Process__c WHERE Response__c =: response.Id]; 

        for(Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Opportunity> opportunities = [SELECT Id, Name FROM Opportunity];

        System.assertEquals(1, opportunities.size());

    }

    @isTest
    public static void shouldCreateMultipleConnectionsWithAppropriateStoreIds(){

        ConnectionCreateJob.chainJob = false;

        List<Response__c> responses = [SELECT Id, Status__c, Form__c FROM Response__c];

        Test.startTest();       
            
			Response__c response = ResponsesService.save(new List<Answer__c>(), responses[4].Id, 'Submitted'); 
        
        Test.stopTest(); 

        List<Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Form_Connection_Process__c WHERE Response__c =: response.Id]; 

        for(Form_Connection_Process__c process : connectionProcess) {
            System.assertEquals('Success', process.Status__c); 
        }

        List<Account> accounts = [SELECT Id FROM Account];

        System.assertEquals(accounts.size(), 1);

        List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity];

        System.assertEquals(opportunities.size(), 1);

        System.assertEquals(accounts[0].Id, opportunities[0].AccountId);

    }

}
