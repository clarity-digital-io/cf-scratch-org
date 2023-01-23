public interface IQuestionsSelector extends fflib_ISObjectSelector {
  List<Question__c> selectById(Set<Id> idSet);
  List<Question__c> selectWithAllDetails();
  List<Question__c> selectWithAllDetailsByIds(Set<Id> formVersionIds);
  List<Question__c> selectByFormVersionIds(Set<Id> formVersionIds);
  List<Question__c> selectByRelatedRecordGroupId(String relatedRecordGroupId);
}
