public interface IFormsService {
  Id deleteById(String recordId);
  Form__c publishForm(Id formId);
  Form__c setToDraft(Id formId);
  List<Form__c> getForms();
  Form__c getFormById(String formId);
  List<Form__c> getFormByIds(Set<Id> formIds);
  Form__c getFormByName(String formName);
  Form__c updateForm(Form__c form);
  List<Form__c> getFormsByStatus(String status);
  void setActiveFormVersion(String formId, String formVersionId);
}
