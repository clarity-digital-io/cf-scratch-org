public interface IResponsesSelector extends fflib_ISObjectSelector 
{
	List<Response__c> selectById(Set<Id> idSet);
	List<Response__c> selectWithAllDetailsByIds(Set<Id> recordIds);
	List<Response__c> getResponsesByOwner(List<String> userIds);
	List<Response__c> selectRecent();
}