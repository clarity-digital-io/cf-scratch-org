public interface IQuestionsSelector extends fflib_ISObjectSelector {
	List<Question__c> selectById(Set<Id> idSet);
	List<Question__c> selectWithAllDetails();
}