trigger QuestionTrigger on Question__c (after insert, after update, after delete) {
  TriggerFactory.createHandler(Question__c.SObjectType);
}