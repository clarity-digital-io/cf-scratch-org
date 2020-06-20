public interface IFormsSelector extends fflib_ISObjectSelector 
{
	List<Form__c> selectById(Set<Id> idSet);
	List<Form__c> selectWithQuestions(Set<Id> formIds);
	List<Form__c> selectByName(String formName);
	List<Form__c> selectWithResponseItems();
	List<Form__c> selectByStatus(String status);
}