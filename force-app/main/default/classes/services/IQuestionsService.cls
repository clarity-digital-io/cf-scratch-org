public interface IQuestionsService {
	List<Question__c> getQuestions();
	List<Question__c> getFormQuestions(Id formId);
	List<String> saveQuestions(List<Question__c> questions);
	Map<String, List<sObject>> saveQuestionWithDetails(Question__c question, List<Question_Option__c> options);
}