public with sharing class FormResponseController {
    
    @AuraEnabled
    public static List<Clarity_Form_Response__c> getFormResponses(String name){

        List<Clarity_Form_Response__c> responses = [SELECT Id, Status__c, Completion__c, CreatedDate, Submitted_Date__c 
            FROM Clarity_Form_Response__c WHERE Clarity_Form__r.Name =: name AND Status__c != 'Preview'];

        return responses; 

    }

    @AuraEnabled
    public static Id deleteFormResponse(String responseId){
        
        Clarity_Form_Response__c response = [SELECT Id, Name FROM Clarity_Form_Response__c WHERE Id =: responseId];

        Database.DeleteResult result = Database.delete(response, true); 

        if(!result.isSuccess()) {
            throw new AuraHandledException('Unable to delete response: ' + response.Name);
        }

        return result.getId();
    }

}
