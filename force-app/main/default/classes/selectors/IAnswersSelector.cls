public interface IAnswersSelector extends fflib_ISObjectSelector {
	List<Answer__c> selectByCustomQuery(String customQuery, String questionId, String responseId);
}