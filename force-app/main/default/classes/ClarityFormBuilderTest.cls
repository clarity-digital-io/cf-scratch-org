@isTest
public class ClarityFormBuilderTest {

    @testSetup
    public static void setup(){

		Clarity_Form__c form = ClarityTestDataFactory.generateForm();

		List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(new List<Clarity_Form__c>{ form });

        List<Clarity_Form_Connection__c> connections = ClarityTestDataFactory.generateConnections(true, form, new List<String>{ 'Opportunity' });

    }

    @isTest
    public static void shouldSaveQuestions() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c]; 

		List<Clarity_Form_Question__c> questions = [SELECT Id FROM Clarity_Form_Question__c];

        String sQuestions = JSON.serialize(questions); 

		Test.startTest();

        	List<String> questionIds = ClarityFormBuilder.save(sQuestions);

		Test.stopTest();

		System.assertEquals(0, questionIds.size());

    }

    @isTest
    public static void shouldStartupFormBuilder() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c]; 
		
		Test.startTest();
        
			Clarity_Form__c formStart = ClarityFormBuilder.startup(form.Id);
		
		Test.stopTest();

		System.assertNotEquals(null, formStart);
    }

	@isTest
    public static void shouldStartupNewFormBuilder() {

        Clarity_Form__c formStart = ClarityFormBuilder.startup('');

		System.assertNotEquals(null, formStart);

    }

    @isTest
    public static void shouldUpdateForm() {

        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

		form.Label__c = 'Test New Form'; 

		String sForm = JSON.serialize(form); 

		Test.startTest();

        	Clarity_Form__c updatedForm = ClarityFormBuilder.updateForm(sForm);

		Test.stopTest();

		System.assertEquals(form.Label__c, updatedForm.Label__c);
    }

    @isTest
    public static void shouldGetQuestions() {

        Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		List<Clarity_Form_Question__c> expectedQuestions = [SELECT Id FROM Clarity_Form_Question__c]; 

		Test.startTest();

        	List<Clarity_Form_Question__c> questions = ClarityFormBuilder.getQuestions(form.Id);

		Test.stopTest();

		System.assertEquals(expectedQuestions.size(), questions.size());
    }

    @isTest
    public static void shouldGetQuestionOptions() {

        Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		List<Clarity_Form_Question__c> expectedQuestions = [SELECT Id FROM Clarity_Form_Question__c WHERE Type__c = 'Dropdown']; 

		List<Clarity_Form_Question_Option__c> optionsCreate = ClarityTestDataFactory.generateQuestionOptions(expectedQuestions);

		insert optionsCreate;

		Test.startTest();

       		List<Clarity_Form_Question_Option__c> options = ClarityFormBuilder.getQuestionOptions(expectedQuestions[0].Id);

		Test.stopTest();

		System.assertEquals(1, options.size());

    }


    @isTest
    public static void shouldSaveQuestionEdit() {
        
		Clarity_Form_Question__c question = [SELECT Id, Title__c FROM Clarity_Form_Question__c LIMIT 1]; 
		
		question.Title__c = 'Something Else'; 

		String sQuestion = JSON.serialize(question); 

		Test.startTest();

        	String updatedQuestion = ClarityFormBuilder.saveQuestion(sQuestion); 

		Test.stopTest();

		Clarity_Form_Question__c newQuestion = [SELECT Id, Title__c FROM Clarity_Form_Question__c LIMIT 1]; 

		System.assertEquals('Something Else', newQuestion.Title__c);

    }

    @isTest
    public static void shouldSaveQuestionWithOptions() {

        Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		List<Clarity_Form_Question__c> expectedQuestions = [SELECT Id FROM Clarity_Form_Question__c WHERE Type__c = 'Dropdown']; 

		List<Clarity_Form_Question_Option__c> optionsCreate = ClarityTestDataFactory.generateQuestionOptions(expectedQuestions);

		String sQuestion = JSON.serialize(expectedQuestions[0]); 

		String sQuestionOptions = JSON.serialize(optionsCreate); 

		Test.startTest();

        Map<String, List<sObject>> options = ClarityFormBuilder.saveQuestionWithOptions(sQuestion, sQuestionOptions);

		Test.stopTest();

		System.assertEquals(1, options.get('Options').size());
    }

    @isTest
    public static void shouldDeletePage() {

		String sQuestions = ''; 

		String sDetails = ''; 

        //List<Clarity_Form_Question__c> updatedQuestions = ClarityFormBuilder.pageDelete(sQuestions, sDetails); 
    
    }

    @isTest
    public static void shouldDeleteQuestion() {

		String sDeleteQuestionId = ''; 

		List<Clarity_Form_Question__c> keepQuestions = new List<Clarity_Form_Question__c>(); 
		List<Clarity_Form_Question__c> questions = [SELECT Id, Type__c FROM Clarity_Form_Question__c]; 

		for(Clarity_Form_Question__c question : questions) {
			if(question.Type__c == 'Dropdown') {
				
				sDeleteQuestionId = question.Id;

			} else {

				keepQuestions.add(question); 

			}
		}

		Test.startTest();

	        List<Clarity_Form_Question__c> updatedQuestions = ClarityFormBuilder.deleteQuestion(JSON.serialize(keepQuestions), sDeleteQuestionId);

		Test.stopTest();

		System.assertEquals(questions.size() - 1, updatedQuestions.size());

    }

    @isTest
    public static void shouldGetQuestionEditDetails() {

		String sQuestionId = ''; 

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		List<Clarity_Form_Question__c> expectedQuestions = [SELECT Id FROM Clarity_Form_Question__c WHERE Type__c = 'Dropdown']; 
		
		Test.startTest();

        	Map<String, List<sObject>> details = ClarityFormBuilder.getQuestionEditDetails(expectedQuestions[0].Id);

		Test.stopTest();

		System.assertEquals(0, details.get('Options').size());
    }

    @isTest
    public static void shouldSaveQuestionWithCriteria() {

		String sQuestion = ''; 

		String sCriteria = ''; 

        //Map<String, List<sObject>> questions = ClarityFormBuilder.saveQuestionWithCriteria(sQuestion, sCriteria);

    }

    @isTest
    public static void shouldGetSObjectsAvailable() {

        List<String> sObjects = ClarityFormBuilder.getSObjectsAvailable();

		System.assertEquals(true, sObjects.size() > 1);

    }

    @isTest
    public static void shouldGetSObjectFields() {

        Map<String, Map<String, Map<String, String>>> sObjectFields = ClarityFormBuilder.getSObjectFields('Account'); 

    }

    @isTest
    public static void shouldSaveRecordGroupFields() {

		String sRecordGroupFields = ''; 
		
		String relatedRecordGroupId = ''; 

        //List<Clarity_Form_Question__c> fields = ClarityFormBuilder.saveRecordGroupFields(sRecordGroupFields, relatedRecordGroupId);

    }

    @isTest
    public static void shouldGetConnections() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c]; 
		
		Test.startTest();
        
			List<Clarity_Form_Connection__c> connections = ClarityFormBuilder.getConnections(form.Id);
		
		Test.stopTest();

		System.assertEquals(1, connections.size());

    }

    @isTest
    public static void shouldGetConnectionFieldMapping() {

		String connectionId = ''; 

		String objectType = ''; 

        //Map<String, List<Object>> mapping = ClarityFormBuilder.getConnectionFieldMapping(connectionId, objectType);

    }

    @isTest
    public static void shouldSaveConnections() {

		List<String> connect = new List<String>(); 

       // List<Clarity_Form_Connection__c> connections = ClarityFormBuilder.saveConnections(connect);

    }

    @isTest
    public static void shouldSaveActiveFieldConnections() {

		String sActiveConnectionFields = ''; 
		
		String connectionId = ''; 

        //Map<String, List<Object>> activeFieldConnections = ClarityFormBuilder.saveActiveFieldConnections(sActiveConnectionFields, connectionId);

    }

    @isTest
    public static void shouldUpdateStatus() {

		Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c LIMIT 1];

		Test.startTest();

			Map<String, Object> result = ClarityFormBuilder.updateStatus(form.Id, 'Published');

		Test.stopTest();

		System.assertEquals('Success', result.get('Status'));

    }
}
