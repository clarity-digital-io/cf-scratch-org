public interface IFormsSelector extends fflib_ISObjectSelector 
{
	List<Form__c> selectById(Set<Id> idSet);
	List<Form__c> selectWithResponseItems();
}