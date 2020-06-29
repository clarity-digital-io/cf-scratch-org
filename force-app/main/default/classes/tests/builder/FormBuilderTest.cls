@isTest
public class FormBuilderTest {

    @testSetup
    public static void setup(){

		Form__c form = TestDataFactory.generateForm();

		List<Question__c> questions = TestDataFactory.generateQuestions(new List<Form__c>{ form });

        List<Form_Connection__c> connections = TestDataFactory.generateConnections(true, form, new List<String>{ 'Opportunity' });

    }

    @isTest
    public static void shouldSaveQuestions() {

		Form__c form = [SELECT Id FROM Form__c]; 

		List<Question__c> questions = [SELECT Id FROM Question__c];

        String sQuestions = JSON.serialize(questions); 

		Test.startTest();

        	List<String> questionIds = BuilderController.save(sQuestions);

		Test.stopTest();

		System.assertEquals(0, questionIds.size());

    }

    @isTest
    public static void shouldStartupFormBuilder() {

		Form__c form = [SELECT Id FROM Form__c]; 
		
		Test.startTest();
        
			Form__c formStart = BuilderController.getForm(form.Id);
		
		Test.stopTest();

		System.assertNotEquals(null, formStart);
    }

	@isTest
    public static void shouldStartupNewFormBuilder() {

        Form__c formStart = BuilderController.getForm('');

		System.assertEquals(null, formStart);

    }

    @isTest
    public static void shouldUpdateForm() {

        Form__c form = TestDataFactory.generateForm();

		form.Label__c = 'Test New Form'; 

		String sForm = JSON.serialize(form); 

		Test.startTest();

        	Form__c updatedForm = BuilderController.updateForm(sForm);

		Test.stopTest();

		System.assertEquals(form.Label__c, updatedForm.Label__c);
    }

    @isTest
    public static void shouldGetQuestions() {

        Form__c form = [SELECT Id FROM Form__c LIMIT 1];

		List<Question__c> expectedQuestions = [SELECT Id FROM Question__c]; 

		Test.startTest();

        	List<Question__c> questions = BuilderController.getQuestions(form.Id);

		Test.stopTest();

		System.assertEquals(expectedQuestions.size(), questions.size());
    }

    @isTest
    public static void shouldSaveQuestionEdit() {
        
		Question__c question = [SELECT Id, Title__c FROM Question__c LIMIT 1]; 
		
		question.Title__c = 'Something Else'; 

		String sQuestion = JSON.serialize(question); 

		Test.startTest();

        	String updatedQuestion = BuilderController.saveQuestion(sQuestion); 

		Test.stopTest();

		Question__c newQuestion = [SELECT Id, Title__c FROM Question__c LIMIT 1]; 

		System.assertEquals('Something Else', newQuestion.Title__c);

    }

    @isTest
    public static void shouldSaveQuestionWithOptions() {

        Form__c form = [SELECT Id FROM Form__c LIMIT 1];

		List<Question__c> expectedQuestions = [SELECT Id FROM Question__c WHERE Type__c = 'Dropdown']; 

		List<Question_Option__c> optionsCreate = TestDataFactory.generateQuestionOptions(expectedQuestions);

		String sQuestion = JSON.serialize(expectedQuestions[0]); 

		String sQuestionOptions = JSON.serialize(optionsCreate); 

		Test.startTest();

        Map<String, List<sObject>> options = BuilderController.saveQuestionWithOptions(sQuestion, sQuestionOptions);

		Test.stopTest();

		System.assertEquals(1, options.get('Options').size());
	}
	
    @isTest
    public static void shouldDeleteQuestion() {

		String sDeleteQuestionId = ''; 

		List<Question__c> keepQuestions = new List<Question__c>(); 
		List<Question__c> questions = [SELECT Id, Type__c FROM Question__c]; 

		for(Question__c question : questions) {
			if(question.Type__c == 'Dropdown') {
				
				sDeleteQuestionId = question.Id;

			} else {

				keepQuestions.add(question); 

			}
		}

		Test.startTest();

	        List<Question__c> updatedQuestions = BuilderController.deleteQuestion(JSON.serialize(keepQuestions), sDeleteQuestionId);

		Test.stopTest();

		System.assertEquals(questions.size() - 1, updatedQuestions.size());

    }

    @isTest
    public static void shouldGetSObjectsAvailable() {

        List<String> sObjects = BuilderController.getSObjectsAvailable();

		System.assertEquals(true, sObjects.size() > 1);

    }

    @isTest
    public static void shouldGetSObjectFields() {

        Map<String, Map<String, Map<String, String>>> sObjectFields = BuilderController.getSObjectFields('Account'); 

		System.assertEquals(true, sObjectFields.size() > 1);

    }

    @isTest
    public static void shouldGetConnections() {

		Form__c form = [SELECT Id FROM Form__c]; 
		
		Test.startTest();
        
			List<Form_Connection__c> connections = BuilderController.getConnections(form.Id);
		
		Test.stopTest();

		System.assertEquals(1, connections.size());

	}
	
}
