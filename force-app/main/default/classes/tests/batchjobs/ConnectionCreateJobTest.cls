@isTest
public class ConnectionCreateJobTest {

	public static void generateConnectedResponseForm(Form__c form, List<Question__c> questions, List<String> newConnections, List<Map<String, Id>> connectionFields, List<Map<String, String>> customConnectionFields, Boolean withAnswers) {

		List<Form_Connection__c> connections = TestDataFactory.generateConnections(true, form.Id, newConnections);

		List<Form_Connection__c> connectionsSaved = FormConnectionsService.save(new List<Form_Connection__c>(), connections);

		List<Form_Connection_Field__c> allFields = new List<Form_Connection_Field__c>();
		
		Integer connectionFieldCount = 0;

		for(Map<String, String> connectionField : connectionFields) {

			Form_Connection__c connection = connections[connectionFieldCount];
			List<Form_Connection_Field__c> fields = TestDataFactory.generateConnectionFields(connection.Id, connectionField);
			List<Form_Connection_Field__c> fieldsSaved = FormConnectionFieldsService.updateFields(fields, connection.Id);
			connectionFieldCount++; 

		}

		Integer customConnectionFieldCount = 0;

		for(Map<String, String> customConnectionField : customConnectionFields) {

			Form_Connection__c connection = connections[customConnectionFieldCount];
			List<Form_Connection_Field__c> customFields = TestDataFactory.generateCustomConnectionFields(connection.Id, customConnectionField);
			List<Form_Connection_Field__c> customFieldsSaved = FormConnectionFieldsService.updateFields(customFields, connection.Id);
			customConnectionFieldCount++; 
			
		}

		form.Status__c = 'Published';

		Form__c updatedForm = FormsService.updateForm(form);

		Response__c response = ResponsesService.create(updatedForm.Id); 

		if(withAnswers) {

			Map<String,String> answers = TestDataFactory.generateAnswers(response, questions);

			List<Answer__c> answersList = new List<Answer__c>(); 

			for(String questionId : answers.keySet()) {
				Answer__c answer = new Answer__c(
					Question__c = questionId,
					Answer__c = answers.get(questionId),
					Response__c = response.Id
				);
				answersList.add(answer);
			}

			Response__c updatedResponse = ResponsesService.save(answersList, response.Id, response.Status__c); 

		}

	}

    @testSetup
    public static void setup(){
						
		User user = TestDataFactory.generateUserWithBuilderPermissions(); 

		System.runAs(user) {

			List<Form__c> forms = TestDataFactory.generateForms(5);

			List<Question__c> questions = TestDataFactory.generateQuestions(forms);
			
			List<Question__c> savedQuestions = QuestionsService.saveQuestions(questions);

			//response 1 
			List<Map<String, String>> fields0 = new List<Map<String, Id>>();
			fields0.add(new Map<String, String>{'ForecastCategoryName' =>  questions[0].Id });
			generateConnectedResponseForm(forms[0], savedQuestions, new List<String>{ 'Opportunity' }, fields0, new List<Map<String, String>>(), false);

			//response 2
			List<Map<String, String>> customFields = new List<Map<String, String>>();
			customFields.add(new Map<String, String>{ 'Name' => 'Custom Name', 'StageName' => 'Prospecting', 'CloseDate' => '07/22/2030' });
			generateConnectedResponseForm(forms[1], savedQuestions, new List<String>{ 'Opportunity' }, new List<Map<String, Id>>(), customFields, true);
			
			//response 3
			List<Map<String, String>> customFields1 = new List<Map<String, String>>();
			customFields1.add(new Map<String, String>{ 'Name' => 'Custom Name' });
			customFields1.add(new Map<String, String>{ 'Name' => 'Clarity' });
			generateConnectedResponseForm(forms[2], savedQuestions, new List<String>{ 'Account', 'Account' }, new List<Map<String, Id>>(), customFields1, true);

			//response 4
			List<Question__c> commentQuestions1 = [SELECT Id, Type__c, Title__c FROM Question__c WHERE Type__c = 'Comment' AND Form__c =: forms[3].Id];
			List<Map<String, String>> fields3 = new List<Map<String, Id>>();
			fields3.add(new Map<String, String>{ 'Name' => commentQuestions1[0].Id });
			generateConnectedResponseForm(forms[3], questions, new List<String>{ 'Account' }, fields3, new List<Map<String, String>>(), true);

			//response 5 prep
			List<Question__c> commentQuestions2 = [SELECT Id,  Type__c, Title__c FROM Question__c WHERE Type__c = 'Comment' AND Form__c =: forms[4].Id];

			List<Map<String, String>> customFields3 = new List<Map<String, String>>();
			customFields3.add(new Map<String, String>{ 'Name' => 'Custom Parent Name' });
			customFields3.add(new Map<String, String>{ 'Name' => 'Custom Child Name', 'ParentId' => '{Connection_Account}' });

			generateConnectedResponseForm(forms[4], commentQuestions2, new List<String>{ 'Account', 'Account' }, new List<Map<String, String>>(), customFields3, true);
	
		}
	}

    @isTest
    public static void shouldUpdateProcessToFailed() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {
        
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

			System.assertEquals(0, opportunities.size());
			
		}

	}
	
	/**
	 * Fail to create opportunity because missing Opportunity__c on Response__c
	 */

    @isTest
    public static void shouldFailToCreateOpportunityConnectionFromCustomValue() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			ConnectionCreateJob.chainJob = false;

			List<Response__c> responses = [SELECT Id, Form__c, Status__c FROM Response__c];

			Test.startTest();       
				
				Response__c response = ResponsesService.save(new List<Answer__c>(), responses[1].Id, 'Submitted'); 
			
			Test.stopTest(); 

			List<Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Form_Connection_Process__c]; 

			for(Form_Connection_Process__c process : connectionProcess) {
				System.assertEquals('Success', process.Status__c); 
			}

			List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

			System.assertEquals(1, opportunities.size());
			
		}
    }

    @isTest
    public static void shouldCreateMultipleConnectionsFromCustomValues(){

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			ConnectionCreateJob.chainJob = false;

			List<Response__c> responses = [SELECT Id, Status__c FROM Response__c];

			Test.startTest();       
				
				Response__c response = ResponsesService.save(new List<Answer__c>(), responses[2].Id, 'Submitted'); 
			
			Test.stopTest(); 

			List<Account> accounts = [SELECT Id FROM Account];

			System.assertEquals(2, accounts.size());
			
			List<Form_Connection_Process__c> connectionProcess = [SELECT Id, Status__c FROM Form_Connection_Process__c]; 

			for(Form_Connection_Process__c process : connectionProcess) {
				System.assertEquals('Success', process.Status__c); 
			}
			
		}
    }

    @isTest
    public static void shouldCreateAccountConnectionFromQuestionValue() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			ConnectionCreateJob.chainJob = false;

			List<Response__c> responses = [SELECT Id, Status__c, Form__c FROM Response__c];

			Test.startTest();       
			
				Response__c response = ResponsesService.save(new List<Answer__c>(), responses[3].Id, 'Submitted'); 
			
			Test.stopTest(); 

			List<Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Form_Connection_Process__c WHERE Response__c =: response.Id]; 

			for(Form_Connection_Process__c process : connectionProcess) {
				System.assertEquals('Success', process.Status__c); 
			}

			List<Account> accounts = [SELECT Id, Name FROM Account];

			System.assertEquals(1, accounts.size());
			
		}

    }

    @isTest
    public static void shouldCreateMultipleConnectionsWithAppropriateStoreIds(){

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {
			ConnectionCreateJob.chainJob = false;

			List<Response__c> responses = [SELECT Id, Status__c, Form__c FROM Response__c];

			Test.startTest();       
				
				Response__c response = ResponsesService.save(new List<Answer__c>(), responses[4].Id, 'Submitted'); 
			
			Test.stopTest(); 

			List<Form_Connection_Process__c> connectionProcess = [SELECT Id, Salesforce_Connection_Object__c, Status__c FROM Form_Connection_Process__c WHERE Response__c =: response.Id]; 

			for(Form_Connection_Process__c process : connectionProcess) {
				System.assertEquals('Success', process.Status__c); 
			}

			List<Account> accounts = [SELECT Id, ParentId FROM Account];

			System.assertEquals(accounts.size(), 2);

			System.assertEquals(accounts[0].Id, accounts[1].ParentId);
		}

    }

}
