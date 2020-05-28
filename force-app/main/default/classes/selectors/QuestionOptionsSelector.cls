public class QuestionOptionsSelector extends fflib_SObjectSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Question_Option__c.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Question_Option__c.Id,
			Question_Option__c.Name,
			Question_Option__c.Label__c
		};
	}

	public List<Question_Option__c> selectById(Set<Id> recordIds){
		return (List<Question_Option__c>) selectSObjectsById(recordIds);
	}

	public static IQuestionOptionsSelector newInstance(){
		return (IQuestionOptionsSelector) Application.selector.newInstance(Question_Option__c.SObjectType);
	}
 
}