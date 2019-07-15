trigger ClarityFormQuestionTrigger on Clarity_Form_Question__c (after insert) {
  TriggerFactory.createHandler(Clarity_Form_Question__c.SObjectType);
}