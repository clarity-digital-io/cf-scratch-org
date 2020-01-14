trigger ClarityFormResponseTrigger on forms__Form_Response__c (before insert, before update, after insert, after update) {
  TriggerFactory.createHandler(forms__Form_Response__c.SObjectType);
}