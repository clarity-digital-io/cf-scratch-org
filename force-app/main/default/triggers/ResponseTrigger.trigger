trigger ResponseTrigger on Response__c (before insert, before update, after insert, after update) {
  TriggerFactory.createHandler(Response__c.SObjectType);
}