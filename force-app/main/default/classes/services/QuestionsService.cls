public with sharing class QuestionsService {

	public static List<Question__c> getQuestions() {
		return service().getQuestions();
	}

	public static List<Question__c> getFormQuestions(Id formId) {
		return service().getFormQuestions(formId);
	}

	public static List<String> saveQuestions(List<Question__c> questions) {
		return service().saveQuestions(questions);
	}

	public static Map<String, List<sObject>> saveQuestionWithDetails(Question__c question, List<Question_Option__c> options) {
		return service().saveQuestionWithDetails(question, options);
	}

	public static Map<String, List<sObject>> saveQuestionWithCriteriaDetails(Question__c question, List<Question_Criteria__c> criteria) {
		return service().saveQuestionWithCriteriaDetails(question, criteria);
	}

	public static List<Question__c> deleteQuestion(List<Question__c> questions, Question__c questionDelete) {
		return service().deleteQuestion(questions, questionDelete);
	}

	public static IQuestionsService service(){
		return (IQuestionsService) Application.service.newInstance(IQuestionsService.class);
	}

}
