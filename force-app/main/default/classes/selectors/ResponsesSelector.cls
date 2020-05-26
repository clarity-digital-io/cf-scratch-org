public class ResponsesSelector extends fflib_SObjectSelector implements IResponsesSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Response__c.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Response__c.Id,
			Response__c.Name,
			Response__c.Completion__c,
			Response__c.Status__c,
			Response__c.Submitted_Date__c,
			Response__c.UUID__c,
			Response__c.Form__c
	   };
	}

	public List<Response__c> selectById(Set<Id> recordIds){
		return (List<Response__c>) selectSObjectsById(recordIds);
	}

	public List<Response__c> selectRecent(){
		fflib_QueryFactory query = newQueryFactory();

		query.addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING);
		query.setLimit( 100 );

		new AnswersSelector().
			addQueryFactorySubselect(query,'forms__Answers__r');
   
		return (List<Response__c>) Database.query( query.toSOQL() );
	}  

	public static IResponsesSelector newInstance(){
		return (IResponsesSelector) Application.selector.newInstance(Response__c.SObjectType);
	}
 
}