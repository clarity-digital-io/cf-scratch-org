public interface IFormConnectionsService {
	List<Form_Connection__c> getConnectionsByResponseId(String responseId);
	List<Form_Connection__c> getConnectionsByFormId(String formId);
	List<Form_Connection__c> getConnectionsByFormIds(Set<Id> formIds);
	List<Form_Connection__c> getConnectionsByFormName(String formName);
	List<Form_Connection__c> getConnectionsByFormStatus(String status);
	List<Form_Connection__c> save(List<Form_Connection__c> removedConnections, List<Form_Connection__c> newConnections);
}