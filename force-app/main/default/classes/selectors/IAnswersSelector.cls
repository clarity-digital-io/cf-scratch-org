public interface IAnswersSelector extends fflib_ISObjectSelector {
	List<Answer__c> selectByCustomQuery(String customQuery, String questionId, String responseId);
	List<Answer__c> getAnswersByResponseId(Set<Id> responseIds);
	List<Answer__c> selectByCustomQuery(String customQuery, List<String> answerIds);
}