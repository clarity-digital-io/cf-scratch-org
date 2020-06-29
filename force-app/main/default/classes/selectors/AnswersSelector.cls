public class AnswersSelector extends fflib_SObjectSelector implements IAnswersSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Answer__c.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Answer__c.Id,
			Answer__c.UUID__c,
			Answer__c.Name,
			Answer__c.Answer__c,
			Answer__c.Response__c,
			Answer__c.Question__c,
			Answer__c.ContentDocument__c,
			Answer__c.ContentVersion__c,
			Answer__c.Date_Answer__c,
			Answer__c.Record__c
		};
	}

	public List<Answer__c> selectById(Set<Id> recordIds){
		return (List<Answer__c>) selectSObjectsById(recordIds);
	}

	public List<Answer__c> getAnswersByResponseId(Set<Id> responseIds) {
		fflib_QueryFactory query = newQueryFactory();
		query.setCondition('Response__c = :responseIds');

		return (List<Answer__c>) Database.query( query.toSOQL() );
	}

	public List<Answer__c> selectByCustomQuery(String customQuery, String questionId, String responseId) {
		fflib_QueryFactory query = newQueryFactory();
		query.setCondition(customQuery);
		return (List<Answer__c>) Database.query( query.toSOQL());
	}

	public List<Answer__c> selectByCustomQuery(String customQuery, List<String> answerIds) {
		fflib_QueryFactory query = newQueryFactory();
		query.setCondition(customQuery);
		return (List<Answer__c>) Database.query( query.toSOQL());
	}

	public static IAnswersSelector newInstance(){
		return (IAnswersSelector) Application.selector.newInstance(Answer__c.SObjectType);
	}
 
}