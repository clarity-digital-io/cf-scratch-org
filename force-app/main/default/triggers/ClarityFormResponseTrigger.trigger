trigger ClarityFormResponseTrigger on Clarity_Form_Response__c (before update, after insert, after update) {
  TriggerFactory.createHandler(Clarity_Form_Response__c.SObjectType);
}