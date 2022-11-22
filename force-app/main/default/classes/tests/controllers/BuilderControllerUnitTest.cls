@isTest
public class BuilderControllerUnitTest {
	
	@TestSetup
	static void setup(){

		User user = TestDataFactory.generateUserWithBuilderPermissions(); 

		System.runAs(user) {

			Form__c form = TestDataFactory.generateForm(); 
			
			List<Question__c> newQuestions = TestDataFactory.generateQuestions(new List<Form__c>{ form });

			BuilderController.save(JSON.serialize(newQuestions));

		}

	}


    @isTest
    public static void shouldSave() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			List<Form__c> forms = [SELECT Id FROM Form__c];
			
			List<Question__c> newQuestions = TestDataFactory.generateQuestions(forms);
			
			Test.startTest();

				List<String> questionIds = BuilderController.save(JSON.serialize(newQuestions));

			Test.stopTest();

			System.assertEquals(newQuestions.size(), questionIds.size());
			
		}

	}

    @isTest
    public static void shouldGetForm() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id existingFormId = existingForm.Id; 

			Test.startTest();

				Form__c form = BuilderController.getForm(existingFormId);

			Test.stopTest();
			
			System.assertEquals(existingFormId, form.Id);

		}
		
    }
		
	@isTest
    public static void shouldUpdateForm() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c form = [SELECT Id, Status__c FROM Form__c LIMIT 1];
			
			form.Status__c = 'Published';
			
			Test.startTest();

				Form__c updatedForm = BuilderController.updateForm(JSON.serialize(form));

			Test.stopTest();

			System.assertEquals('Published', updatedForm.Status__c);

		}

	}
	
	@isTest
    public static void shouldGetQuestions() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id existingFormId = existingForm.Id; 

			Test.startTest();

				List<Question__c> questions = BuilderController.getQuestions(existingFormId);

			Test.stopTest();

			List<Question__c> existingQuestions = [SELECT Id FROM Question__c];

			System.assertEquals(questions.size(), existingQuestions.size());

		}

    }
		
	@isTest
    public static void shouldSaveQuestion() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			List<Form__c> forms = [SELECT Id FROM Form__c];

			List<Question__c> questions = TestDataFactory.generateQuestions(forms);

			Question__c question = questions[0];

			question.Title__c = 'Save Test';
			
			String questionId = BuilderController.saveQuestion(JSON.serialize(question));

			Question__c updatedQuestion = [SELECT Id, Title__c FROM Question__c WHERE Id = :questionId LIMIT 1];

			System.assertEquals('Save Test', updatedQuestion.Title__c);

		}


	}
	
	@isTest
    public static void shouldSaveQuestionWithOptions() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

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
		
	}
	
	@isTest
    public static void shouldSaveQuestionWithCriteria() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c form = [SELECT Id FROM Form__c LIMIT 1];

			List<Question__c> questions = [SELECT Id, Type__c FROM Question__c Limit 3]; 

			List<Question_Criteria__c> criteria = TestDataFactory.generateQuestionCriteria(questions);

			String sQuestion = JSON.serialize(questions[0]); 

			String sCriteria = JSON.serialize(criteria); 

			Test.startTest();

				Map<String, List<sObject>> options = BuilderController.saveQuestionWithCriteria(sQuestion, sCriteria);

			Test.stopTest();

			System.assertEquals(2, options.get('Criteria').size());

		}

	}
	
	@isTest
    public static void shouldSaveRecordGroupFields() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c form = [SELECT Id FROM Form__c LIMIT 1];

			Question__c recordGroup = TestDataFactory.generateRecordGroup(form);

			String relatedRecordGroupId = BuilderController.saveQuestion(JSON.serialize(recordGroup));

			List<Question__c> recordGroupFields = TestDataFactory.generateRecordGroupFields(recordGroup);

			String sRecordGroupFields = JSON.serialize(recordGroupFields); 

			Test.startTest();

				List<Question__c> newFields = BuilderController.saveRecordGroupFields(sRecordGroupFields, relatedRecordGroupId);

			Test.stopTest();

			System.assertEquals(recordGroupFields.size(), newFields.size());

		}


	}
	
	@isTest
    public static void shouldGetConnections() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id formId = existingForm.Id; 

			List<String> connectionObjects = new List<String>{ 'Opportunity', 'Case' };

			List<Form_Connection__c> connections = TestDataFactory.generateConnections(true, formId, connectionObjects);

			List<Form_Connection__c> removedConnections = new List<Form_Connection__c>();

			List<String> connect = new List<String>{ JSON.serialize(connections), formId, JSON.serialize(removedConnections) };

			List<Form_Connection__c> savedConnections = BuilderController.saveConnections(connect);

			Test.startTest();

				List<Form_Connection__c> newConnections = BuilderController.getConnections(formId);

			Test.stopTest();

			System.assertEquals(savedConnections.size(), newConnections.size());

		}
		
    }
	
	@isTest
    public static void shouldSaveConnections() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id formId = existingForm.Id; 

			List<String> connectionObjects = new List<String>{ 'Opportunity', 'Case' };

			List<Form_Connection__c> connections = TestDataFactory.generateConnections(true, formId, new List<String>{ 'Opportunity', 'Case' });

			List<Form_Connection__c> removedConnections = new List<Form_Connection__c>();

			List<String> connect = new List<String>{ JSON.serialize(connections), formId, JSON.serialize(removedConnections) };

			Test.startTest();

				List<Form_Connection__c> savedConnections = BuilderController.saveConnections(connect);

			Test.stopTest();

			System.assertEquals(connections.size(), savedConnections.size());

		}

	}
	
	@isTest
    public static void shouldSaveActiveFieldConnections() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Form__c existingForm = [SELECT Id FROM Form__c LIMIT 1];

			Id formId = existingForm.Id; 

			List<Form_Connection__c> connections = TestDataFactory.generateConnections(true, formId, new List<String>{ 'Opportunity' });

			List<Form_Connection__c> removedConnections = new List<Form_Connection__c>();

			List<String> connect = new List<String>{ JSON.serialize(connections), formId, JSON.serialize(removedConnections) };

			List<Form_Connection__c> savedConnections = BuilderController.saveConnections(connect);

			List<Question__c> questions = [SELECT Id FROM Question__c WHERE Type__c = 'Dropdown' LIMIT 1]; 

			List<Form_Connection_Field__c> fields = TestDataFactory.generateConnectionFields(savedConnections[0].Id, new Map<String, String>{'ForecastCategoryName' =>  questions[0].Id });

			String sFields = JSON.serialize(fields); 

			Test.startTest();

				Map<String, List<Object>> activeFieldConnections = BuilderController.saveActiveFieldConnections(sFields, savedConnections[0].Id);

			Test.stopTest();

			System.assertEquals(1, activeFieldConnections.get('Mapping').size());

		}


	}
	
	@isTest
    public static void shouldDeleteQuestion() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			List<Question__c> questions = [SELECT Id FROM Question__c]; 

			System.assertEquals(36, questions.size());

			String sQuestions = JSON.serialize(questions); 

			Test.startTest();

				List<Question__c> questionsLeft = BuilderController.deleteQuestion(sQuestions, questions[0].Id);

			Test.stopTest();

			System.assertEquals(questions.size() - 1, questionsLeft.size());

		}

	}
	
	@isTest
    public static void shoulGetSObjectsAvailable() {

		User user = [SELECT Id FROM USER WHERE UserName = 'test_cl@clarityforms.io' Limit 1];
		
		System.runAs(user) {

			Map<String, Map<String, Map<String, String>>> fields = BuilderController.getSObjectFields('Account');

			System.assertNotEquals(fields.get('Required'), null);

			System.assertNotEquals(fields.get('NotRequired'), null);

		}

    }
		

}
