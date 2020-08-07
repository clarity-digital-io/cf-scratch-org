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
	
	public override void onAfterUpdate(Map<Id, sObject> existingRecords) {

		Set<Id> publishedFormIds = new Set<Id>();

		for (sObject oldSo : existingRecords.values()) {
			Form__c oldForm = (Form__c) oldSo; 
			Form__c newForm = (Form__c) Trigger.newMap.get(oldForm.Id); 
			if(oldForm.Status__c != 'Published' && newForm.Status__c == 'Published') {
				publishedFormIds.add(newForm.Id);
			}
		}

		if(publishedFormIds.size() > 0) {
			//syncPublishedForm(publishedFormIds);
		}

	}

	@future(callout=true)
	public static void syncPublishedForm(Set<Id> formIds) {

		SyncService.connectOrganizationForms(formIds);

	}

	
	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new Forms(sObjectList);
		}
	}
}