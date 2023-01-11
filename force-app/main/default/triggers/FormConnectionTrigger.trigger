trigger FormConnectionTrigger on Form_Connection__c(after update) {
  fflib_SObjectDomain.triggerHandler(FormConnections.class);
}
