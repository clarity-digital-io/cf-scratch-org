@isTest
public class FormResponseTest {

    @testSetup
    public static void setup(){

		Clarity_Form__c form = TestDataFactory.generateForm();

		List<Clarity_Form_Question__c> questions = TestDataFactory.generateQuestions(new List<Clarity_Form__c>{ form });

        List<Clarity_Form_Connection__c> connections = TestDataFactory.generateConnections(false, form,  new List<String>{ 'Opportunity' });

    }

	@isTest
	public static void shouldGetPreview() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		Test.startTest();

			Map<String, List<sObject>> preview = FormResponse.preview(form.Id); 

		Test.stopTest();

		System.assertEquals(6, preview.size());

	}

	@isTest
	public static void shouldCheckConnections() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = TestDataFactory.generateResponse(form);

		List<Clarity_Form_Connection__c> connections = [SELECT Id FROM Clarity_Form_Connection__c];

		List<Clarity_Form_Response_Connection__c> responseConnections = TestDataFactory.generateResponseConnection(response.Id, connections); 

		Test.startTest();

			List<Clarity_Form_Connection__c> checkConnections = FormResponse.checkConnections(response.Id); 

		Test.stopTest();

		System.assertEquals(0, checkConnections.size());

	}

	@isTest
	public static void shouldGetConnections() {
		
		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Test.startTest();

			List<Clarity_Form_Connection__c> connections = FormResponse.getConnections(form.Name); 

		Test.stopTest();

		System.assertEquals(1, connections.size());

	}

	@isTest
	public static void shouldGetRecordGroupResults() {
		
		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = TestDataFactory.generateResponse(form);

		List<Clarity_Form_Question__c> questions = [SELECT Id, Type__c, Title__c FROM Clarity_Form_Question__c WHERE Type__c = 'RecordGroup' AND Clarity_Form__c =: form.Id];

        TestDataFactory.generateRecordGroupAnswers(response, questions);

		Test.startTest();

			Map<Id, List<sObject>> recordGroupResults = FormResponse.getRecordGroupResults(response.Id, form.Id); 

		Test.stopTest();

		System.assertNotEquals(1, recordGroupResults.size());

	}

	@isTest
	public static void shouldCreateResponse() {
		
		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		List<Clarity_Form_Connection__c> connections = [SELECT Id FROM Clarity_Form_Connection__c];

		Opportunity opp = new Opportunity(Name = 'Test', StageName = 'Prospecting', CloseDate = date.newInstance(2030, 11, 21)); 

		insert opp; 

		List<Map<String, String>> valueConnections = new List<Map<String, String>>(); 

		Map<String, String> mappedConnections = new Map<String, String>();

		mappedConnections.put('key', opp.Id); 
		mappedConnections.put('label', 'Test Connection'); 
		mappedConnections.put('connectionId', connections[0].Id); 
		mappedConnections.put('sObjectName', 'Opportunity'); 
		
		valueConnections.add(mappedConnections);

		Test.startTest();

			Map<String, List<sObject>> create = FormResponse.create(form.Name, JSON.serialize(valueConnections)); 

		Test.stopTest();

		System.assertEquals(1, create.get('Connections').size());
	}

	@isTest
	public static void shouldEditResponse() {
		
		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = TestDataFactory.generateResponse(form);

		Test.startTest();

			Map<String, List<sObject>> edit = FormResponse.edit(response.Id, null);

		Test.stopTest();

		System.assertEquals(new List<Clarity_Form_Response_Connection__c>(), edit.get('Connections'));

	}

	@isTest
	public static void shouldSaveAnswer() {

		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = TestDataFactory.generateResponse(form);

		List<Clarity_Form_Question__c> questions = [SELECT Id FROM Clarity_Form_Question__c];

		List<Clarity_Form_Answer__c> answers = new List<Clarity_Form_Answer__c>(); 

		Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
			Clarity_Form_Question__c = questions[0].Id, 
			Answer__c				 = 'Test', 
			Clarity_Form_Response__c = response.Id
		);

		answers.add(answer); 

		String sAnswer = JSON.serialize(answers); 

		Test.startTest();

			List<Clarity_Form_Answer__c> rAnswers = FormResponse.saveAnswer(sAnswer);

		Test.stopTest();

		System.assertEquals('Test', rAnswers[0].Answer__c);
	}

	@isTest
	public static void shouldSaveResponse() {

		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = TestDataFactory.generateResponse(form);

		List<Clarity_Form_Question__c> questions = [SELECT Id, Type__c FROM Clarity_Form_Question__c];

		List<Clarity_Form_Answer__c> answers = new List<Clarity_Form_Answer__c>(); 

		Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
			Clarity_Form_Question__c = questions[0].Id, 
			Answer__c				 = 'Test',
			Clarity_Form_Response__c = response.Id
		);

		answers.add(answer); 

		String answerValues = JSON.serialize(answers); 

		String aQuestionId = '';

		for(Clarity_Form_Question__c question : questions) {
			if(question.Type__c == 'Attachments') {
				aQuestionId = question.Id; 
			}
		}

		List<String> holdAnswers = new List<String>{ '{"' + response.Id + '":{"' + aQuestionId + '":["iVBOR"]}}', answerValues, response.Id }; 

		Test.startTest();

			List<String> save = FormResponse.save(holdAnswers);

		Test.stopTest();

		System.assertEquals(1, save.size());

	}

	@isTest
	public static void shouldSubmitResponse() {

		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = TestDataFactory.generateResponse(form);

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

			List<String> submit = FormResponse.submit(holdAnswers);

		Test.stopTest();	

		System.assertEquals(1, submit.size());

	}

	@isTest
	public static void shouldReturnLookSearchResults() {
		
		Opportunity opp = new Opportunity(Name = 'Test', StageName = 'Prospecting', CloseDate = date.newInstance(2030, 11, 21)); 
		
		insert opp; 

		List<Id> fixedSearchResults = new List<Id>{opp.Id};
        Test.setFixedSearchResults(fixedSearchResults);

		List<String> searchItems = new List<String>{ 'Tes', 'Opportunity', '' };

		Test.startTest();

			List<FormResponse.LookupResult> search = FormResponse.search(searchItems);

		Test.stopTest();

		System.assertEquals(1, search.size());
	}

}
