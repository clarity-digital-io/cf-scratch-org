public class AnswersSelector extends fflib_SObjectSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Answer__c.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Answer__c.Id,
			Answer__c.Name,
			Answer__c.Answer__c,
			Answer__c.Response__c,
			Answer__c.ContentDocument__c,
			Answer__c.ContentVersion__c,
			Answer__c.Date_Answer__c,
			Answer__c.Record__c
		};
	}

	public List<Answer__c> selectById(Set<Id> recordIds){
		return (List<Answer__c>) selectSObjectsById(recordIds);
	}

	public static IAnswersSelector newInstance(){
		return (IAnswersSelector) Application.selector.newInstance(Answer__c.SObjectType);
	}
 
}