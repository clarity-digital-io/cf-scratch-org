@isTest
public class ClarityFormResponseTest {

    @testSetup
    public static void setup(){

		Clarity_Form__c form = ClarityTestDataFactory.generateForm();

		List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(form);

        List<Clarity_Form_Connection__c> connections = ClarityTestDataFactory.generateConnections(form,  new List<String>{ 'Opportunity' });

    }

	@isTest
	public static void shouldGetPreview() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		Test.startTest();

			Map<String, List<sObject>> preview = ClarityFormResponse.preview(form.Id); 

		Test.stopTest();

	}

	@isTest
	public static void shouldCheckConnections() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		Test.startTest();

			List<Clarity_Form_Connection__c> connections = ClarityFormResponse.checkConnections(response.Id); 

		Test.stopTest();

	}

	@isTest
	public static void shouldGetConnections() {
		
		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Test.startTest();

			List<Clarity_Form_Connection__c> connections = ClarityFormResponse.getConnections(form.Name); 

		Test.stopTest();

	}

	@isTest
	public static void shouldGetRecordGroupResults() {
		
		// Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		// Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		// Test.startTest();

		// 	Map<Id, List<sObject>> recordGroupResults = ClarityFormResponse.getRecordGroupResults(response.Id, form.Id); 

		// Test.stopTest();

	}

	@isTest
	public static void shouldCreateResponse() {
		
		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		List<Clarity_Form_Connection__c> connections = [SELECT Id FROM Clarity_Form_Connection__c];

		String sConnections = JSON.serialize(connections); 

		Test.startTest();

			Map<String, List<sObject>> create = ClarityFormResponse.create(form.Name, sConnections); 

		Test.stopTest();

	}

	@isTest
	public static void shouldEditResponse() {
		
		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		List<Clarity_Form_Connection__c> connections = [SELECT Id FROM Clarity_Form_Connection__c];

		String sConnections = JSON.serialize(connections); 

		Test.startTest();

			Map<String, List<sObject>> edit = ClarityFormResponse.edit(response.Id, sConnections);

		Test.stopTest();

	}

	@isTest
	public static void shouldSaveAnswer() {

		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		List<Clarity_Form_Question__c> questions = [SELECT Id FROM Clarity_Form_Question__c];

		Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
			Clarity_Form_Question__c = questions[0].Id, 
			Answer__c				 = 'Test', 
			Clarity_Form_Response__c = response.Id
		);

		String sAnswer = JSON.serialize(answer); 

		Test.startTest();

			List<Clarity_Form_Answer__c> answers = ClarityFormResponse.saveAnswer(sAnswer);

		Test.stopTest();

	}

	@isTest
	public static void shouldSaveResponse() {

		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		List<Clarity_Form_Question__c> questions = [SELECT Id FROM Clarity_Form_Question__c];

		List<Clarity_Form_Answer__c> answers = new List<Clarity_Form_Answer__c>(); 

		Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
			Clarity_Form_Question__c = questions[0].Id, 
			Answer__c				 = 'Test',
			Clarity_Form_Response__c = response.Id
		);

		answers.add(answer); 

		String answerValues = JSON.serialize(answers); 

		List<String> holdAnswers = new List<String>{ '', answerValues, response.Id }; 

		Test.startTest();

			List<String> save = ClarityFormResponse.save(holdAnswers);

		Test.stopTest();

	}

	@isTest
	public static void shouldSubmitResponse() {

		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		List<Clarity_Form_Question__c> questions = [SELECT Id FROM Clarity_Form_Question__c];

		Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
			Clarity_Form_Question__c = questions[0].Id, 
			Answer__c				 = 'Test',
			Clarity_Form_Response__c = response.Id
		);

		String answerValue = JSON.serialize(answer); 

		Test.startTest();

			List<Clarity_Form_Answer__c> answers = ClarityFormResponse.saveAnswer(answerValue);

		Test.stopTest();	

	}

	@isTest
	public static void shouldReturnLookSearchResults() {
		
		List<String> searchItems = new List<String>{ 'Test', 'Account', '' };

		Test.startTest();

			List<ClarityFormResponse.LookupResult> search = ClarityFormResponse.search(searchItems);

		Test.stopTest();
	}

	@isTest
	public static void shouldCreateRecord() {

		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		Clarity_Form_Question__c recordGroup = ClarityTestDataFactory.generateRecordGroup(form);

		String records = '[{"field":"OpportunityId","value":"2","type":"REFERENCE"},{"field":"Quantity","value":1,"type":"INTEGER"},{"field":"Product2Id","value":"2","type":"REFERENCE"}]';

		List<String> recordValues = new List<String>{ response.Id, recordGroup.Id, 'Opportunity', records };

		Test.startTest();

			sObject result = ClarityFormResponse.createRecord(recordValues);

		Test.stopTest();
	}

	@isTest
	public static void shouldGetRecordGroupPicklist() {
		
	}

}
