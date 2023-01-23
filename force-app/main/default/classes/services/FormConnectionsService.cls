public with sharing class FormConnectionsService {
  public static List<Form_Connection__c> getConnectionsByResponseId(
    String responseId
  ) {
    return service().getConnectionsByResponseId(responseId);
  }

  public static List<Form_Connection__c> getConnectionsByFormVersionId(
    String formVersionId
  ) {
    return service().getConnectionsByFormVersionId(formVersionId);
  }

  public static List<Form_Connection__c> getConnectionsByFormVersionIds(
    Set<Id> formVersionIds
  ) {
    return service().getConnectionsByFormVersionIds(formVersionIds);
  }

  public static List<Form_Connection__c> save(
    List<Form_Connection__c> removedConnections,
    List<Form_Connection__c> newConnections
  ) {
    return service().save(removedConnections, newConnections);
  }

  public static IFormConnectionsService service() {
    return (IFormConnectionsService) Application.service.newInstance(
      IFormConnectionsService.class
    );
  }
}
