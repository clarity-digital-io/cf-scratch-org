/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 05/16/2019
*
* @group forms__Form_Question__c
*
* @description forms__Form_Question Trigger Handler for the forms__Form_Question SObject. This class implements the ITrigger
*  Please check ITrigger and TriggerFactory to understand the order execution and methods used
*/
public class forms__Form_QuestionTriggerHandler implements ITrigger {
    
    /*******************************************************************************************************
	* @description List of flow designs to be updated in the andFinally method
	*/
	private List<forms__Form_Question_Flow_Design__c> flowDesignsToBeCreated = new List<forms__Form_Question_Flow_Design__c>();
	private List<forms__Form_Audit_Log__c> logs = new List<forms__Form_Audit_Log__c>();

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

        forms__Form_Question__c cf = (forms__Form_Question__c) so; 

        QuestionFlowDesigns.execute(flowDesignsToBeCreated, cf);
		AuditLogBuilderService.execute(logs, cf, null, 'Title__c');

	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record updated during an AFTER
	* trigger.
	*/
	public void afterUpdate(SObject oldSo, SObject so) {

        forms__Form_Question__c oldCf = (forms__Form_Question__c) oldSo; 
		forms__Form_Question__c newCf = (forms__Form_Question__c) so; 

		AuditLogBuilderService.execute(logs, newCf, oldCf, 'Title__c');

	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record deleted during an AFTER
	* trigger.
	*/
	public void afterDelete(SObject so) {

		forms__Form_Question__c newCf = (forms__Form_Question__c) so; 

		AuditLogBuilderService.execute(logs, newCf, null, 'Title__c');

	}

    /*******************************************************************************************************
    * @description This method is called once all records have been processed by the trigger. Use this
    * method to accomplish any final operations such as creation or updates of other records.
    */
	public void andFinally() {
		if (!flowDesignsToBeCreated.isEmpty()) {
            insert flowDesignsToBeCreated; 
		}
		if (!logs.isEmpty()) {
            insert logs; 
		}
	}
}