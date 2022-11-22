public interface IFormConnectionFieldsService {
	List<Form_Connection_Field__c> getByConnectionId(String connectionId);
	List<Form_Connection_Field__c> updateFields(List<Form_Connection_Field__c> parsedConnectionFields, String connectionId);
}