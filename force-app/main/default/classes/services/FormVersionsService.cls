public with sharing class FormVersionsService {
  public static Form_Version__c updateFormVersion(Form_Version__c formVersion) {
    return service().updateFormVersion(formVersion);
  }

  public static List<Form_Version__c> getFormVersionsByFormId(String formId) {
    return service().getFormVersionsByFormId(formId);
  }

  public static Form_Version__c getFormVersionById(String formVersionId) {
    return service().getFormVersionById(formVersionId);
  }

  public static List<Form_Version__c> getFormVersionsByIds(
    Set<Id> formVersionIds
  ) {
    return service().getFormVersionsByIds(formVersionIds);
  }

  public static Form_Version__c getActiveFormVersionByFormId(String formId) {
    return service().getActiveFormVersionByFormId(formId);
  }

  public static IFormVersionsService service() {
    return (IFormVersionsService) Application.service.newInstance(
      IFormVersionsService.class
    );
  }
}
