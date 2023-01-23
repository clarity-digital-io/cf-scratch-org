public interface IFormVersionsSelector extends fflib_ISObjectSelector {
  List<Form_Version__c> selectById(Set<Id> idSet);
  List<Form_Version__c> selectByFormId(String formId);
}
