public with sharing class ResponseConnectionsSelector extends fflib_SObjectSelector implements IResponseConnectionsSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Response_Connection__c.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Response_Connection__c.Id,
			Response_Connection__c.Name,
			Response_Connection__c.Form_Connection__c,
			Response_Connection__c.Response__c,
			Response_Connection__c.Record__c
	   };
	}
	
	public List<Response_Connection__c> selectResponseConnectionsByConnectionIds(Set<Id> connectionIds, String responseId){
		fflib_QueryFactory query = newQueryFactory();
		query.setCondition('Form_Connection__c IN :connectionIds AND Id = :responseId');
		return (List<Response_Connection__c>) Database.query( query.toSOQL() );
	}

	public List<Response_Connection__c> getByResponseId(Set<Id> responseIds){
		fflib_QueryFactory query = newQueryFactory();
		query.setCondition('Response__c IN :responseIds');
		return (List<Response_Connection__c>) Database.query( query.toSOQL() );
	}

	public static IResponseConnectionsSelector newInstance(){
		return (IResponseConnectionsSelector) Application.selector.newInstance(Response_Connection__c.SObjectType);
	}
}
