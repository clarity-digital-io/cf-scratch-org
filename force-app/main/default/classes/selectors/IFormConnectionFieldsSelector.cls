public interface IFormConnectionFieldsSelector extends fflib_ISObjectSelector {
	List<Form_Connection_Field__c> selectFieldsByConnectionId(String connectionId);
}