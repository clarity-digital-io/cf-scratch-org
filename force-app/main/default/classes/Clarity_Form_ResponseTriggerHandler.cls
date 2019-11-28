/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 07/07/2019
*
* @group Clarity_Form_Response__c
*
* @description Clarity_Form_Response Trigger Handler for the Clarity_Form_Response SObject. This class implements the ITrigger
*  Please check ITrigger and TriggerFactory to understand the order execution and methods used
*/
public class Clarity_Form_ResponseTriggerHandler implements ITrigger {
    
    /*******************************************************************************************************
	* @description List of answers to be inserted in the andFinally method
	*/
	private List<Clarity_Form_Answer__c> answersToBeCreated = new List<Clarity_Form_Answer__c>();

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

        Clarity_Form_Response__c response = (Clarity_Form_Response__c) so; 

		FormResponseLimits.execute(response);

	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record to be updated during a BEFORE
	* trigger.
	*/
	public void beforeUpdate(SObject oldSo, SObject so) {

        Clarity_Form_Response__c oldResponse = (Clarity_Form_Response__c) oldSo; 

        Clarity_Form_Response__c newResponse = (Clarity_Form_Response__c) so; 

		FormResponseAssignment.execute(oldResponse, newResponse);

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

		Clarity_Form_Response__c newResponse = (Clarity_Form_Response__c) so; 

        CreateResponseAnswers.execute(answersToBeCreated, newResponse); 

	}

	/*******************************************************************************************************
	* @description This method is called iteratively for each record updated during an AFTER
	* trigger.
	*/
	public void afterUpdate(SObject oldSo, SObject so) {

        Clarity_Form_Response__c oldResponse = (Clarity_Form_Response__c) oldSo; 

        Clarity_Form_Response__c newResponse = (Clarity_Form_Response__c) so; 

        ConnectionRecordProcess.execute(oldResponse, newResponse); 

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
		if (!answersToBeCreated.isEmpty()) {
            insert answersToBeCreated; 
		}
	}
}