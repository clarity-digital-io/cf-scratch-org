public interface IQuestionsService {
	List<Question__c> getQuestions();
	List<Question__c> getFormQuestions(Id formId);
	List<Question__c> getFormsQuestions(Set<Id> formIds);
	List<Question__c> saveRecordGroup(List<Question__c> recordGroupFields, String relatedRecordGroupId);
	List<String> saveQuestions(List<Question__c> questions);
	Map<String, List<sObject>> saveQuestionWithDetails(Question__c question, List<Question_Option__c> options);
	Map<String, List<sObject>> saveQuestionWithCriteriaDetails(Question__c question, List<Question_Criteria__c> criteria);
	List<Question__c> deleteQuestion(List<Question__c> questions, Question__c questionDelete);
	List<Question__c> deleteQuestions(List<Question__c> questions, String formId);
}