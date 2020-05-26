public class QuestionsSelector extends fflib_SObjectSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Answer__c.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Question__c.Id,
			Question__c.Name,
			Question__c.Title__c,
			Question__c.Type__c,
			Question__c.Order__c,
			Question__c.Lookup__c,
			Question__c.Max_Length__c,
			Question__c.Max_Range__c,
			Question__c.Min_Range__c,
			Question__c.Page__c,
			Question__c.Required__c,
			Question__c.Salesforce_Field__c,
			Question__c.Salesforce_Object__c,
			Question__c.Logic__c,
			Question__c.FreeText_Type__c,
			Question__c.Form__c,
			Question__c.Record_Group__c,
			Question__c.Prefill_Type__c
		};
	}

	public List<Question__c> selectById(Set<Id> recordIds){
		return (List<Question__c>) selectSObjectsById(recordIds);
	}

	public static IQuestionsSelector newInstance(){
		return (IQuestionsSelector) Application.selector.newInstance(Question__c.SObjectType);
	}
 
}