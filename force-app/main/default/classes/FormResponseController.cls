public with sharing class FormResponseController {
    
    @AuraEnabled
    public static Clarity_Form__c getForm(String recordId) {

        Clarity_Form__c form = [SELECT Id, Status__c, Responses_Completed__c, Completion_Rate__c, Responses_Started__c, Name, 
            (SELECT Id, Status__c, Name FROM Clarity_Form_Responses__r) FROM Clarity_Form__c WHERE Id =: recordId Limit 1]; 

        return form; 

    }

    @AuraEnabled
    public static List<Clarity_Form_Response__c> getFormResponses(String name){

        List<Clarity_Form_Response__c> responses = [SELECT Id, Status__c, Completion__c, CreatedDate, Submitted_Date__c 
            FROM Clarity_Form_Response__c WHERE Clarity_Form__r.Name =: name AND Status__c != 'Preview'];

        return responses; 

    }

    @AuraEnabled
    public static String deleteFormResponse(String responseId){
        
        Clarity_Form_Response__c response = [SELECT Id, Name FROM Clarity_Form_Response__c WHERE Id =: responseId Limit 1];

        Database.DeleteResult result = Database.delete(response, true); 

        if(!result.isSuccess()) {
            throw new AuraHandledException('Unable to delete response: ' + response.Name);
        }

        return responseId;
    }

}
