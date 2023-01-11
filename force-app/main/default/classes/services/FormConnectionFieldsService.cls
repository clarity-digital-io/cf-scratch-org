public with sharing class FormConnectionFieldsService {
  public static List<Form_Connection_Field__c> getByConnectionId(
    String connectionId
  ) {
    return service().getByConnectionId(connectionId);
  }

  public static List<Form_Connection_Field__c> updateFields(
    List<Form_Connection_Field__c> parsedConnectionFields,
    String connectionId
  ) {
    return service().updateFields(parsedConnectionFields, connectionId);
  }

  public static IFormConnectionFieldsService service() {
    return (IFormConnectionFieldsService) Application.service.newInstance(
      IFormConnectionFieldsService.class
    );
  }
}
