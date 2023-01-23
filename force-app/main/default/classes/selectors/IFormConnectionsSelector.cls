public interface IFormConnectionsSelector extends fflib_ISObjectSelector {
  List<Form_Connection__c> selectConnectionsByResponseId(String responseId);

  List<Form_Connection__c> selectConnectionsByFormVersionId(
    String formVersionId
  );
  List<Form_Connection__c> selectConnectionsByFormVersionIds(
    Set<Id> formVersionIds
  );
}
