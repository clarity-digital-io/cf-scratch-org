/**
* @author ben@clarityforms.io
* @company Clarity Forms
* @date 07/07/2019
*
* @group Form_Connection__c
*
* @description Form_Connection Trigger Handler for the Form_Connection SObject. This class implements the ITrigger
*  Please check ITrigger and TriggerFactory to understand the order execution and methods used
*/
public class Form_ConnectionTriggerHandler implements ITrigger {
    
    /*******************************************************************************************************
	* @description List of fields to be deleted in the andFinally method
	*/
	private List<Form_Connection_Field__c> fieldsToBeDeleted = new List<Form_Connection_Field__c>();
    
    /*******************************************************************************************************
	* @description This method is called prior to execution of a BEFORE trigger. Use this to cache
	* any data required into maps prior execution of the trigger.
	*/
	public void bulkBefore() {

		if (Trigger.isInsert) {

		}

		if (Trigger.isUpdate) {

		}
	}

	/*******************************************************************************************************
	* @description This method is called prior to execution of an AFTER trigger. Use this to cache
	* any data required into maps prior execution of the trigger.
	*/
	public void bulkAfter() {

		if (Trigger.isInsert) {

		}

		if (Trigger.isUpdate) {

		}

		if (Trigger.isDelete) {

		}
	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record to be inserted during a BEFORE
	* trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
	*/
	public void beforeInsert(SObject so) {

	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record to be updated during a BEFORE
	* trigger.
	*/
	public void beforeUpdate(SObject oldSo, SObject so) {

	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record to be deleted during a BEFORE
	* trigger.
	*/
	public void beforeDelete(SObject so) {

	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record inserted during an AFTER
	* trigger. Always put field validation in the 'After' methods in case another trigger
	* has modified any values. The record is 'read only' by this point.
	*/
	public void afterInsert(SObject so) {

	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record updated during an AFTER
	* trigger.
	*/
	public void afterUpdate(SObject oldSo, SObject so) {

        Form_Connection__c oldConnection = (Form_Connection__c) oldSo; 

        Form_Connection__c newConnection = (Form_Connection__c) so; 

        ConnectionFieldValidation.execute(fieldsToBeDeleted, oldConnection, newConnection);

	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record deleted during an AFTER
	* trigger.
	*/
	public void afterDelete(SObject so) {

	}

    /*******************************************************************************************************
    * @description This method is called once all records have been processed by the trigger. Use this
    * method to accomplish any final operations such as creation or updates of other records.
    */
	public void andFinally() {

		if (!fieldsToBeDeleted.isEmpty() && Schema.sObjectType.Form_Connection_Field__c.isDeletable()) {
            delete fieldsToBeDeleted; 
		}

	}
}