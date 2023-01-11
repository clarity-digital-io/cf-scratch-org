public interface IQuestionOptionsSelector extends fflib_ISObjectSelector {
  List<Question_Option__c> selectById(Set<Id> idSet);
  List<Question_Option__c> selectByQuestionId(Id questionId);
}
