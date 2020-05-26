public interface IResponsesSelector extends fflib_ISObjectSelector 
{
	List<Response__c> selectById(Set<Id> idSet);
	List<Response__c> selectRecent();
}