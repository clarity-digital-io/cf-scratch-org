trigger ClarityFormResponseTrigger on Clarity_Form_Response__c (after update) {
  TriggerFactory.createHandler(Clarity_Form_Response__c.SObjectType);
}