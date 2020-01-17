trigger ClarityFormQuestionTrigger on Clarity_Form_Question__c (after insert, after update, after delete) {
  TriggerFactory.createHandler(Clarity_Form_Question__c.SObjectType);
}