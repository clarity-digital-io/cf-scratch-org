trigger ClarityFormConnectionTrigger on forms__Form_Connection__c (after update) {
  TriggerFactory.createHandler(forms__Form_Connection__c.SObjectType);
}
