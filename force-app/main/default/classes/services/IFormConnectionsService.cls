public interface IFormConnectionsService {
  List<Form_Connection__c> getConnectionsByResponseId(String responseId);
  List<Form_Connection__c> getConnectionsByFormVersionIds(
    Set<Id> formVersionIds
  );
  List<Form_Connection__c> getConnectionsByFormVersionId(String formVersionId);
  List<Form_Connection__c> save(
    List<Form_Connection__c> removedConnections,
    List<Form_Connection__c> newConnections
  );
}
