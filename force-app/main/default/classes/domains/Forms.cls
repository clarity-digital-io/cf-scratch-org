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
		for (sObject oldSo : existingRecords.values()) {
			Form__c oldForm = (Form__c) oldSo; 
			Form__c newForm = (Form__c) Trigger.newMap.get(oldForm.Id); 
			if(oldForm.Status__c != 'Published' && newForm.Status__c == 'Published') {
				//syncForm(newForm.Id); 
			}
		}
	}

	@future(callout=true)
	public static void syncForm(Id newFormId) {

		// Form__c form = [SELECT Id, Title__c, Sync_Status__c FROM Form__c Limit 1]; 

		// Http http = new Http();
		// HttpRequest request = new HttpRequest();
		// request.setEndpoint('https://thawing-falls-33419.herokuapp.com/forms');
		// request.setBody(JSON.serialize(form));
		// request.setHeader('Content-Type', 'application/json');
		// request.setMethod('POST');
		// HttpResponse response = http.send(request);

		// if (response.getStatusCode() == 200) {
		// 	form.Sync_Status__c = 'Complete'; 
		// 	update form; 
		// }

	}

	
	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new Forms(sObjectList);
		}
	}
}
