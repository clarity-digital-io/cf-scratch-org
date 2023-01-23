public class FormVersionsServiceImpl implements IFormVersionsService {
  public Form_Version__c updateFormVersion(Form_Version__c formVersion) {
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerUpsert(formVersion);
    uow.commitWork();

    return formVersion;
  }

  public List<Form_Version__c> getFormVersionsByFormId(String formId) {
    List<Form_Version__c> formVersions = FormVersionsSelector.newInstance()
      .selectByFormId(formId);
    return formVersions;
  }

  public Form_Version__c getFormVersionById(String formVersionId) {
    List<Form_Version__c> formVersions = FormVersionsSelector.newInstance()
      .selectById(new Set<Id>{ formVersionId });
    return formVersions[0];
  }

  public List<Form_Version__c> getFormVersionsByIds(Set<Id> formVersionIds) {
    List<Form_Version__c> formVersions = FormVersionsSelector.newInstance()
      .selectById(formVersionIds);
    return formVersions;
  }

  public Form_Version__c getActiveFormVersionByFormId(String formId) {
    List<Form__c> forms = FormsSelector.newInstance()
      .selectById(new Set<Id>{ formId });
    if (forms.size() == 0) {
      // throw new Exception('No forms with Id');
    }
    Form__c form = forms[0];
    List<Form_Version__c> formVersions = FormVersionsSelector.newInstance()
      .selectById(new Set<Id>{ form.Active_Form_Version__c });
    return formVersions[0];
  }
}
