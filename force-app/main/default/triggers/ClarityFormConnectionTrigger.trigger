trigger ClarityFormConnectionTrigger on Clarity_Form_Connection__c (after update) {
  TriggerFactory.createHandler(Clarity_Form_Connection__c.SObjectType);
}
