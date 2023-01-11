public interface IResponseConnectionsSelector extends fflib_ISObjectSelector {
  List<Response_Connection__c> getByResponseId(Set<Id> responseIds);
  List<Response_Connection__c> selectResponseConnectionsByConnectionIds(
    Set<Id> connectionIds,
    String responseId
  );
}
