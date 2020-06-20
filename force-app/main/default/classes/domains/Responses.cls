public with sharing class Responses extends fflib_SObjectDomain implements IResponses {

	public static IResponses newInstance(List<Response__c> recordList)
	{
		return (IResponses) Application.Domain.newInstance(recordList);
	}

	public static IResponses newInstance(Set<Id> recordIdSet)
	{
		return (IResponses) Application.Domain.newInstance(recordIdSet);
	}
	
	public Responses(List<Response__c> sObjectList)
	{
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new Responses(sObjectList);
		}
	}

	public override void onAfterUpdate(Map<Id, sObject> existingRecords) {
		
		for(sObject oldSo : existingRecords.values()) {
			Response__c oldResponse = (Response__c) oldSo; 
			Response__c newResponse = (Response__c) Trigger.newMap.get(oldResponse.Id); 

			if(oldResponse.Status__c == 'Submitted' || newResponse.Status__c != 'Submitted') return; 

			List<Form_Connection__c> connections = ConnectionRecordProcess.Connections.get(newResponse.Form__c);

			if(connections == null || connections.size() == 0) return;

			Map<Id, Response_Connection__c> rConnections = ConnectionRecordProcess.ResponseConnections.get(newResponse.Id) != null ? ConnectionRecordProcess.ResponseConnections.get(newResponse.Id) : new Map<Id, Response_Connection__c>();

			Map<Id, Answer__c> answersByQuestions = ConnectionRecordProcess.ResponseAnswers.get(newResponse.Id);

			Map<Id, Form_Connection_Process__c> processByConnections = ConnectionRecordProcess.ResponseConnectionProcess.get(newResponse.Id); 

			Map<String, Id> storedResults = new Map<String, Id>();

			System.enqueueJob(new ConnectionCreateJob(0, connections, rConnections, answersByQuestions, processByConnections, storedResults, newResponse));
		}

	}

}
