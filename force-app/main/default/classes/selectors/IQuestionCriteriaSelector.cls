public interface IQuestionCriteriaSelector extends fflib_ISObjectSelector {
  List<Question_Criteria__c> selectByQuestionId(Id questionId);
}
