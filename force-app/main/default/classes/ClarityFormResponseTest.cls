@isTest
public class ClarityFormResponseTest {

    @testSetup
    public static void setup(){

		Clarity_Form__c form = ClarityTestDataFactory.generateForm();

		List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(new List<Clarity_Form__c>{ form });

        List<Clarity_Form_Connection__c> connections = ClarityTestDataFactory.generateConnections(false, form,  new List<String>{ 'Opportunity' });

    }

	@isTest
	public static void shouldGetPreview() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		Test.startTest();

			Map<String, List<sObject>> preview = ClarityFormResponse.preview(form.Id); 

		Test.stopTest();

		System.assertEquals(1, preview.size());

	}

	@isTest
	public static void shouldCheckConnections() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		List<Clarity_Form_Connection__c> connections = [SELECT Id FROM Clarity_Form_Connection__c];

		List<Clarity_Form_Response_Connection__c> responseConnections = ClarityTestDataFactory.generateResponseConnection(response.Id, connections); 

		Test.startTest();

			List<Clarity_Form_Connection__c> checkConnections = ClarityFormResponse.checkConnections(response.Id); 

		Test.stopTest();

		System.assertEquals(0, checkConnections.size());

	}

	@isTest
	public static void shouldGetConnections() {
		
		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Test.startTest();

			List<Clarity_Form_Connection__c> connections = ClarityFormResponse.getConnections(form.Name); 

		Test.stopTest();

		System.assertEquals(1, connections.size());

	}

	@isTest
	public static void shouldGetRecordGroupResults() {
		
		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		List<Clarity_Form_Question__c> questions = [SELECT Id, Type__c, Title__c FROM Clarity_Form_Question__c WHERE Type__c = 'RecordGroup' AND Clarity_Form__c =: form.Id];

        ClarityTestDataFactory.generateRecordGroupAnswers(response, questions);

		Test.startTest();

			Map<Id, List<sObject>> recordGroupResults = ClarityFormResponse.getRecordGroupResults(response.Id, form.Id); 

		Test.stopTest();

		System.assertNotEquals(0, recordGroupResults.size());

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
		
		valueConnections.add(mappedConnections);

		Test.startTest();

			Map<String, List<sObject>> create = ClarityFormResponse.create(form.Name, JSON.serialize(valueConnections)); 

		Test.stopTest();

		System.assertEquals(1, create.get('Connections').size());
	}

	@isTest
	public static void shouldEditResponse() {
		
		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

		Test.startTest();

			Map<String, List<sObject>> edit = ClarityFormResponse.edit(response.Id, null);

		Test.stopTest();

		System.assertEquals(new List<Clarity_Form_Response_Connection__c>(), edit.get('Connections'));

	}

	@isTest
	public static void shouldSaveAnswer() {

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

		String sAnswer = JSON.serialize(answers); 

		Test.startTest();

			List<Clarity_Form_Answer__c> rAnswers = ClarityFormResponse.saveAnswer(sAnswer);

		Test.stopTest();

		System.assertEquals('Test', rAnswers[0].Answer__c);
	}

	@isTest
	public static void shouldSaveResponse() {

		Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c LIMIT 1];

		Clarity_Form_Response__c response = ClarityTestDataFactory.generateResponse(form);

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

			List<String> save = ClarityFormResponse.save(holdAnswers);

		Test.stopTest();

		System.assertEquals(1, save.size());

	}

	@isTest
	public static void shouldSubmitResponse() {

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

			List<String> submit = ClarityFormResponse.submit(holdAnswers);

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

			List<ClarityFormResponse.LookupResult> search = ClarityFormResponse.search(searchItems);

		Test.stopTest();

		System.assertEquals(1, search.size());
	}

}
