public with sharing class FormResponseController {
    
    @AuraEnabled
    public static List<Clarity_Form_Response__c> getFormResponses(String name){

        List<Clarity_Form_Response__c> responses = [SELECT Id, Status__c, Completion__c, CreatedDate, Submitted_Date__c 
            FROM Clarity_Form_Response__c WHERE Clarity_Form__r.Name =: name AND Status__c != 'Preview'];

        return responses; 

    }

}
