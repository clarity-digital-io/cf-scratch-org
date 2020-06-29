public interface IFormConnectionsSelector extends fflib_ISObjectSelector {
	List<Form_Connection__c> selectConnectionsByFormId(String formId);
	List<Form_Connection__c> selectConnectionsByFormIds(Set<Id> formIds);
}