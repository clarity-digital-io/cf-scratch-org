trigger FormConnectionTrigger on Form_Connection__c (after update) {
  TriggerFactory.createHandler(Form_Connection__c.SObjectType);
}
