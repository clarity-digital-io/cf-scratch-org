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
}
