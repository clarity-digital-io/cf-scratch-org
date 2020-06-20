public with sharing class Questions extends fflib_SObjectDomain implements IQuestions {

	public static IQuestions newInstance(List<Question__c> recordList)
	{
		return (IQuestions) Application.Domain.newInstance(recordList);
	}

	public static IQuestions newInstance(Set<Id> recordIdSet)
	{
		return (IQuestions) Application.Domain.newInstance(recordIdSet);
	}
	
	public Questions(List<Question__c> sObjectList)
	{
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new Questions(sObjectList);
		}
	}
	
}
