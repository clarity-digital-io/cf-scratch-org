public class FormConnectionsServiceImpl implements IFormConnectionsService {
  public List<Form_Connection__c> getConnectionsByResponseId(
    String responseId
  ) {
    List<Form_Connection__c> requiredConnections = new List<Form_Connection__c>();

    List<Response__c> response = ResponsesSelector.newInstance()
      .selectById(new Set<Id>{ responseId });

    List<Form_Connection__c> allFormConnections = FormConnectionsSelector.newInstance()
      .selectConnectionsByFormVersionId(response[0].Form_Version__c);

    Set<Id> connectionIds = new Set<Id>();

    for (Form_Connection__c connection : allFormConnections) {
      connectionIds.add(connection.Id);
    }

    List<Response_Connection__c> responseConnections = ResponseConnectionsSelector.newInstance()
      .selectResponseConnectionsByConnectionIds(connectionIds, responseId);

    if (responseConnections.size() == 0) {
      return allFormConnections;
    }

    Set<Id> responseConnectedIds = new Set<Id>();

    for (Response_Connection__c responseConnection : responseConnections) {
      responseConnectedIds.add(responseConnection.Form_Connection__c);
    }

    for (Form_Connection__c connection : allFormConnections) {
      if (!responseConnectedIds.contains(connection.Id)) {
        requiredConnections.add(connection);
      }
    }

    return requiredConnections;
  }

  public List<Form_Connection__c> getConnectionsByFormVersionId(
    String formVersionId
  ) {
    List<Form_Connection__c> connections = FormConnectionsSelector.newInstance()
      .selectConnectionsByFormVersionId(formVersionId);
    return connections;
  }

  public List<Form_Connection__c> getConnectionsByFormVersionIds(
    Set<Id> formVersionIds
  ) {
    List<Form_Connection__c> connections = FormConnectionsSelector.newInstance()
      .selectConnectionsByFormVersionIds(formVersionIds);
    return connections;
  }

  public List<Form_Connection__c> save(
    List<Form_Connection__c> removedConnections,
    List<Form_Connection__c> newConnections
  ) {
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerDeleted(removedConnections);

    uow.registerUpsert(newConnections);

    uow.commitWork();

    return newConnections;
  }
}
