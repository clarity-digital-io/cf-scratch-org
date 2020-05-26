public interface IResponsesSelector extends fflib_ISObjectSelector 
{
	List<Response__c> selectRecent();
}