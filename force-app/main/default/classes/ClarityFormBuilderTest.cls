@isTest
public class ClarityFormBuilderTest {

    @testSetup
    public static void setup(){
        
    }

    @isTest
    public static void shouldSaveQuestions() {

        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

        String sQuestions = ''; 

        List<String> questionIds = ClarityFormBuilder.save(sQuestions);

    }

    @isTest
    public static void shouldStartupFormBuilder() {

        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

        Clarity_Form__c formStart = ClarityFormBuilder.startup(form.Id);

    }

    @isTest
    public static void shouldUpdateForm() {

        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

		String sForm = JSON.serialize(form); 

        Clarity_Form__c updatedForm = ClarityFormBuilder.updateForm(sForm);
    }

    @isTest
    public static void shouldGetDesigns() {

        List<Clarity_Form_Style__c> designs = ClarityFormBuilder.getDesigns(); 
    }

    @isTest
    public static void shouldUpdateDesign() {

		String sDesign = '';

		String file = '';

        Clarity_Form_Style__c style = ClarityFormBuilder.updateDesign(sDesign, file);

    }


    @isTest
    public static void shouldGetQuestions() {

        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

        List<Clarity_Form_Question__c> questions = ClarityFormBuilder.getQuestions(form.Id);

    }

    @isTest
    public static void shouldGetQuestionOptions() {

		Clarity_Form_Question__c question = new Clarity_Form_Question__c(); 

        List<Clarity_Form_Question_Option__c> options = ClarityFormBuilder.getQuestionOptions(question.Id);

    }


    @isTest
    public static void shouldSaveQuestionEdit() {
        
		String sQuestion = ''; 

        String updatedQuestion = ClarityFormBuilder.saveQuestion(sQuestion); 

    }

    @isTest
    public static void shouldSaveQuestionWithOptions() {

		String sQuestion = ''; 

		String sQuestionOptions = ''; 

        Map<String, List<sObject>> options = ClarityFormBuilder.saveQuestionWithOptions(sQuestion, sQuestionOptions);

    }

    @isTest
    public static void shouldDeletePage() {

		String sQuestions = ''; 

		String sDetails = ''; 

        List<Clarity_Form_Question__c> updatedQuestions = ClarityFormBuilder.pageDelete(sQuestions, sDetails); 
    
    }

    @isTest
    public static void shouldDeleteQuestion() {

		String sQuestions = ''; 

		String sDeleteQuestionId = ''; 

        List<Clarity_Form_Question__c> updatedQuestions = ClarityFormBuilder.deleteQuestion(sQuestions, sDeleteQuestionId);

    }

    @isTest
    public static void shouldGetQuestionEditDetails() {

		String sQuestionId = ''; 

        Map<String, List<sObject>> details = ClarityFormBuilder.getQuestionEditDetails(sQuestionId);

    }


    @isTest
    public static void shouldSaveFlowDesign() {

		String sFlowDesign = ''; 

		String sQuestionOptions = ''; 

        Map<String, List<sObject>> flowDesigns = ClarityFormBuilder.saveFlowDesign(sFlowDesign, sQuestionOptions);

    }

    @isTest
    public static void shouldSaveQuestionWithCriteria() {

		String sQuestion = ''; 

		String sCriteria = ''; 

        Map<String, List<sObject>> questions = ClarityFormBuilder.saveQuestionWithCriteria(sQuestion, sCriteria);

    }

    @isTest
    public static void shouldGetSObjectsAvailable() {

        List<String> sObjects = ClarityFormBuilder.getSObjectsAvailable();

    }

    @isTest
    public static void shouldGetSObjectFields() {

		String objectType = '';

        Map<String, Map<String, Map<String, String>>> sObjectFields = ClarityFormBuilder.getSObjectFields(objectType); 

    }

    @isTest
    public static void shouldCreateAssignment() {

		String name = ''; 

		String formId = ''; 

        Clarity_Form_Assignment__c assignment = ClarityFormBuilder.createAssignment(name, formId);

    }

    @isTest
    public static void shouldGetAssignmentRules() {

		String formAssignmentId = ''; 

        List<Clarity_Form_Assignment_Rule__c> rules = ClarityFormBuilder.getAssignmentRules(formAssignmentId);

    }


    @isTest
    public static void shouldSaveAssignmentRules() {

		String sFormAssignment = ''; 
		
		String sFormAssignmentRules = ''; 

        List<Clarity_Form_Assignment_Rule__c> rules = ClarityFormBuilder.saveAssignmentRules(sFormAssignment, sFormAssignmentRules);

    }

    @isTest
    public static void shouldSaveRecordGroupFields() {

		String sRecordGroupFields = ''; 
		
		String relatedRecordGroupId = ''; 

        List<Clarity_Form_Question__c> fields = ClarityFormBuilder.saveRecordGroupFields(sRecordGroupFields, relatedRecordGroupId);

    }

    @isTest
    public static void shouldGetConnections() {

		String formId = ''; 

        List<Clarity_Form_Connection__c> connections = ClarityFormBuilder.getConnections(formId);

    }

    @isTest
    public static void shouldGetConnectionFieldMapping() {

		String connectionId = ''; 

		String objectType = ''; 

        Map<String, List<Object>> mapping = ClarityFormBuilder.getConnectionFieldMapping(connectionId, objectType);

    }

    @isTest
    public static void shouldSaveConnections() {

		List<String> connect = new List<String>(); 

        List<Clarity_Form_Connection__c> connections = ClarityFormBuilder.saveConnections(connect);

    }

    @isTest
    public static void shouldSaveActiveFieldConnections() {

		String sActiveConnectionFields = ''; 
		
		String connectionId = ''; 

        Map<String, List<Object>> activeFieldConnections = ClarityFormBuilder.saveActiveFieldConnections(sActiveConnectionFields, connectionId);

    }

    @isTest
    public static void shouldGetUsers() {

		String searchTerm = ''; 

        List<sObject> users = ClarityFormBuilder.getUsers(searchTerm);

    }

    @isTest
    public static void shouldUpdateStatus() {

		String formId = ''; 

		String status = ''; 

        Map<String, Object> formStatus = ClarityFormBuilder.updateStatus(formId, status);

    }
}
