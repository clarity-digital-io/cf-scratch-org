public interface IFormVersionsService {
  Form_Version__c updateFormVersion(Form_Version__c formVersion);
  List<Form_Version__c> getFormVersionsByFormId(String formId);
  Form_Version__c getFormVersionById(String formVersionId);
  List<Form_Version__c> getFormVersionsByIds(Set<Id> formVersionIds);
  Form_Version__c getActiveFormVersionByFormId(String formId);
}
