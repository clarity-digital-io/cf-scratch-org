trigger QuestionTrigger on Question__c (after insert, after update, after delete) {
  fflib_SObjectDomain.triggerHandler(Questions.class);
}