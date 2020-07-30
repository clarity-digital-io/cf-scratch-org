@isTest
public class ResponseControllerUnitTest {

	@TestSetup
	public static void setup(){
		
		Form__c form = TestDataFactory.generateForm(); 

		Form__c updatedForm = FormsService.updateForm(form);

		List<Question__c> newQuestions = TestDataFactory.generateQuestions(new List<Form__c>{ form });

		List<Question__c> questions = QuestionsService.saveQuestions(newQuestions);

		updatedForm.Status__c = 'Published';

		Form__c publishedForm = FormsService.updateForm(updatedForm);

	}

	@isTest
    public static void shouldCreateResponse() {

		Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

		Id existingFormId = existingForm.Id; 
		
		Test.startTest();

			Response__c response = ResponseController.createResponse( existingFormId, JSON.serialize(new Map<String, String>()) );

		Test.stopTest();
		
		System.assertEquals(existingFormId, response.Form__c);

	}

	@isTest
    public static void shouldGetResponse() {

		Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

		Id existingFormId = existingForm.Id; 

		Response__c newResponse = ResponseController.createResponse( existingFormId, JSON.serialize(new Map<String, String>()) );

		Test.startTest();

			Response__c response = ResponseController.getResponse( newResponse.Id );

		Test.stopTest();

		System.assertEquals(newResponse.Id, response.Id);

	}
	
	@isTest
    public static void shouldGetResponses() {

		Account newAccount = new Account(Name = 'Test Class');

		insert newAccount;

		Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

		Id existingFormId = existingForm.Id; 

		Map<String, String> connectionRecordIds = new Map<String, String>{ 'Account' => newAccount.Id };

		Response__c newResponse = ResponseController.createResponse( existingFormId, JSON.serialize(connectionRecordIds) );

		Test.startTest();

			List<Response__c> responses = ResponseController.getResponses( newAccount.Id );

		Test.stopTest();

		System.assertEquals(newAccount.Id, responses[0].Account__c);

	}
	
	@isTest
    public static void shouldGetConnections() {


	}
	
	@isTest
    public static void shouldGetQuestions() {

		Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

		Id existingFormId = existingForm.Id; 

		List<Question__c> existingQuestions = [SELECT Id FROM Question__c];

		Test.startTest();

			List<Question__c> questions = ResponseController.getQuestions( existingFormId );

		Test.stopTest();

		System.assertEquals(existingQuestions.size(), questions.size());

	}
	
	@isTest
    public static void shouldSaveResponse() {

		Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

		Id existingFormId = existingForm.Id; 

		Response__c response = ResponseController.createResponse( existingFormId, JSON.serialize(new Map<String, String>()) );

		List<Question__c> questions = [SELECT Id FROM Question__c LIMIT 3];
		
		List<Answer__c> answers = TestDataFactory.generateAnswers(response, questions);

		String sAnswers = JSON.serialize(answers);

		Test.startTest();

			Id savedResponseId = ResponseController.saveResponse( response.Id, sAnswers, 'In Progress' );

		Test.stopTest();

		List<Answer__c> updatedAnswers = [SELECT Id FROM Answer__c WHERE Response__c =: savedResponseId];

		System.assertEquals(answers.size(), updatedAnswers.size());

	}
	
	@isTest
    public static void shouldFormSearch() {

		Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

		Id existingFormId = existingForm.Id; 

		Test.startTest();

			List<LookupSearchResult> results = ResponseController.formSearch( 'Clarity', new List<String>() );

		Test.stopTest();

		System.assertEquals(results[0].id, existingFormId);

	}
	
	@isTest
    public static void shouldConnectionSearch() {

		Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

		Id existingFormId = existingForm.Id; 

		Account newAccount = new Account(Name = 'Test Class');
		
		insert newAccount;

		Test.startTest();

			List<LookupSearchResult> results = ResponseController.connectionSearch( 'Test', new List<String>(), 'Account');

		Test.stopTest();

		System.assertEquals(results[0].id, newAccount.Id);

    }
}
