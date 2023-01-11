public class FormConnectionFieldsServiceImpl implements IFormConnectionFieldsService {
  public List<Form_Connection_Field__c> getByConnectionId(String connectionId) {
    List<Form_Connection_Field__c> fields = FormConnectionFieldsSelector.newInstance()
      .selectFieldsByConnectionId(connectionId);

    return fields;
  }

  public List<Form_Connection_Field__c> updateFields(
    List<Form_Connection_Field__c> newConnectionFields,
    String connectionId
  ) {
    List<Form_Connection_Field__c> deleteFields = FormConnectionFieldsSelector.newInstance()
      .selectFieldsByConnectionId(connectionId);

    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerDeleted(deleteFields);

    uow.registerUpsert(newConnectionFields);

    uow.commitWork();

    return newConnectionFields;
  }
}
