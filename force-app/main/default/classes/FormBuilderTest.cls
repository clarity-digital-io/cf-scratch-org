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

        	List<String> questionIds = FormBuilder.save(sQuestions);

		Test.stopTest();

		System.assertEquals(0, questionIds.size());

    }

    @isTest
    public static void shouldStartupFormBuilder() {

		Form__c form = [SELECT Id FROM Form__c]; 
		
		Test.startTest();
        
			Form__c formStart = FormBuilder.startup(form.Id);
		
		Test.stopTest();

		System.assertNotEquals(null, formStart);
    }

	@isTest
    public static void shouldStartupNewFormBuilder() {

        Form__c formStart = FormBuilder.startup('');

		System.assertEquals(null, formStart);

    }

    @isTest
    public static void shouldUpdateForm() {

        Form__c form = TestDataFactory.generateForm();

		form.Label__c = 'Test New Form'; 

		String sForm = JSON.serialize(form); 

		Test.startTest();

        	Form__c updatedForm = FormBuilder.updateForm(sForm);

		Test.stopTest();

		System.assertEquals(form.Label__c, updatedForm.Label__c);
    }

    @isTest
    public static void shouldGetQuestions() {

        Form__c form = [SELECT Id FROM Form__c LIMIT 1];

		List<Question__c> expectedQuestions = [SELECT Id FROM Question__c]; 

		Test.startTest();

        	List<Question__c> questions = FormBuilder.getQuestions(form.Id);

		Test.stopTest();

		System.assertEquals(expectedQuestions.size(), questions.size());
    }

    @isTest
    public static void shouldGetQuestionOptions() {

        Form__c form = [SELECT Id FROM Form__c LIMIT 1];

		List<Question__c> expectedQuestions = [SELECT Id FROM Question__c WHERE Type__c = 'Dropdown']; 

		List<Question_Option__c> optionsCreate = TestDataFactory.generateQuestionOptions(expectedQuestions);

		insert optionsCreate;

		Test.startTest();

       		List<Question_Option__c> options = FormBuilder.getQuestionOptions(expectedQuestions[0].Id);

		Test.stopTest();

		System.assertEquals(1, options.size());

    }


    @isTest
    public static void shouldSaveQuestionEdit() {
        
		Question__c question = [SELECT Id, Title__c FROM Question__c LIMIT 1]; 
		
		question.Title__c = 'Something Else'; 

		String sQuestion = JSON.serialize(question); 

		Test.startTest();

        	String updatedQuestion = FormBuilder.saveQuestion(sQuestion); 

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

        Map<String, List<sObject>> options = FormBuilder.saveQuestionWithOptions(sQuestion, sQuestionOptions);

		Test.stopTest();

		System.assertEquals(1, options.get('Options').size());
	}
	
	@isTest
    public static void shouldSaveQuestionWithPictureOptions() {

        Form__c form = [SELECT Id FROM Form__c LIMIT 1];

		List<Question__c> expectedQuestions = [SELECT Id, Form__c FROM Question__c WHERE Type__c = 'Dropdown']; 

		List<Question_Option__c> optionsCreate = TestDataFactory.generateQuestionOptions(expectedQuestions);

		String sQuestion = JSON.serialize(expectedQuestions[0]); 

		Map<Decimal, Question_Option__c> optionsCreateMap = new Map<Decimal, Question_Option__c>();

		for(Question_Option__c option : optionsCreate) {
			optionsCreateMap.put(option.Order__c, option); 
		}

		String sQuestionOptions = JSON.serialize(optionsCreateMap); 

		String images = JSON.serialize(new Map<String, String>{ '0' => 'testimage' }); 

		Test.startTest();

		List<String> optionValues = new List<String>{sQuestion, sQuestionOptions, images};

        Map<String, List<sObject>> options = FormBuilder.saveQuestionWithPictureOptions(optionValues);

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

	        List<Question__c> updatedQuestions = FormBuilder.deleteQuestion(JSON.serialize(keepQuestions), sDeleteQuestionId);

		Test.stopTest();

		System.assertEquals(questions.size() - 1, updatedQuestions.size());

    }

    @isTest
    public static void shouldGetQuestionEditDetails() {

		String sQuestionId = ''; 

		Form__c form = [SELECT Id FROM Form__c LIMIT 1];

		List<Question__c> expectedQuestions = [SELECT Id FROM Question__c WHERE Type__c = 'Dropdown']; 
		
		Test.startTest();

        	Map<String, List<sObject>> details = FormBuilder.getQuestionEditDetails(expectedQuestions[0].Id);

		Test.stopTest();

		System.assertEquals(0, details.get('Options').size());
    }

    @isTest
    public static void shouldGetSObjectsAvailable() {

        List<String> sObjects = FormBuilder.getSObjectsAvailable();

		System.assertEquals(true, sObjects.size() > 1);

    }

    @isTest
    public static void shouldGetSObjectFields() {

        Map<String, Map<String, Map<String, String>>> sObjectFields = FormBuilder.getSObjectFields('Account'); 

		System.assertEquals(true, sObjectFields.size() > 1);

    }

    @isTest
    public static void shouldGetConnections() {

		Form__c form = [SELECT Id FROM Form__c]; 
		
		Test.startTest();
        
			List<Form_Connection__c> connections = FormBuilder.getConnections(form.Id);
		
		Test.stopTest();

		System.assertEquals(1, connections.size());

    }

    @isTest
    public static void shouldUpdateStatus() {

		Form__c form = [SELECT Id FROM Form__c LIMIT 1];

		Test.startTest();

			Map<String, Object> result = FormBuilder.updateStatus(form.Id, 'Published');

		Test.stopTest();

		System.assertEquals('Success', result.get('Status'));

    }
}
