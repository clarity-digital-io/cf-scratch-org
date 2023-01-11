trigger ResponseTrigger on Response__c(
  before insert,
  before update,
  after insert,
  after update
) {
  fflib_SObjectDomain.triggerHandler(Responses.class);
}
