public with sharing class ClarityFormPreview {

    @AuraEnabled
    public static Map<String, List<sObject>> preview(String recordId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c WHERE Id =: recordId Limit 1];

        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1)
            Title__c, Order__c, Required__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        formDetails.put('Form', new List<sObject>{ form });
        formDetails.put('Questions', questions);

        return formDetails; 

    }

}
