trigger ClarityFormQuestionTrigger on forms__Form_Question__c (after insert, after update, after delete) {
  TriggerFactory.createHandler(forms__Form_Question__c.SObjectType);
}