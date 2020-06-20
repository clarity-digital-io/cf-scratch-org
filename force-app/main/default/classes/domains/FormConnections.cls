public with sharing class FormConnections extends fflib_SObjectDomain implements IFormConnections {

	public static IFormConnections newInstance(List<Form_Connection__c> recordList)
	{
		return (IFormConnections) Application.Domain.newInstance(recordList);
	}
	
	public FormConnections(List<Form_Connection__c> sObjectList)
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

	public override void onAfterUpdate(Map<Id, sObject> existingRecords) {
		
		List<Form_Connection_Field__c> fieldsToBeDeleted = new List<Form_Connection_Field__c>(); 

		for(sObject oldSo : existingRecords.values()) {
			Form_Connection__c oldConnection = (Form_Connection__c) oldSo; 
			Form_Connection__c newConnection = (Form_Connection__c) Trigger.newMap.get(oldConnection.Id); 

			if(oldConnection.Salesforce_Object__c != newConnection.Salesforce_Object__c) {
				List<Form_Connection_Field__c> fields = ConnectionFieldValidation.ConnectionFields.get(newConnection.Id);
				fieldsToBeDeleted.addAll(fields);
			}

		}

		//We can move this form connection fields domain to delete
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());    	  	    										
		uow.registerDeleted(fieldsToBeDeleted);
		uow.commitWork();	

	}
}
