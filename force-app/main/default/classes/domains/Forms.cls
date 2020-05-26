public with sharing class Forms extends fflib_SObjectDomain implements IForms {

	public static IForms newInstance(List<Form__c> recordList)
	{
		return (IForms) Application.Domain.newInstance(recordList);
	}

	public static IForms newInstance(Set<Id> recordIdSet)
	{
		return (IForms) Application.Domain.newInstance(recordIdSet);
	}
	
	public Forms(List<Form__c> sObjectList)
	{
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new Forms(sObjectList);
		}
	}
}
