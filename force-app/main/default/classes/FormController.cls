public with sharing class FormController {

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

    @AuraEnabled
    public static String deleteForm(String recordId){
        
        Clarity_Form__c form = [SELECT Id, Name, (SELECT Id FROM Clarity_Form_Responses__r) FROM Clarity_Form__c WHERE Id =: recordId Limit 1]; 

        if(form.Clarity_Form_Responses__r.size() > 0) {
            throw new AuraHandledException('Unable to delete form while it has Responses');
        }

        Database.DeleteResult result = Database.delete(form, true); 

        if(!result.isSuccess()) {
            throw new AuraHandledException('Unable to delete form: ' + form.Name);
        }

        return 'Success';

    }

    @AuraEnabled
    public static Id cloneForm(String recordId){
        
        Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c WHERE Id =: recordId Limit 1]; 

        Clarity_Form__c newForm = form.clone(false); 

        Database.SaveResult result = Database.insert(newForm, true); 

        if(!result.isSuccess()) {
            throw new AuraHandledException('Unable to clone form: ' + form.Name);
        }

        return newForm.Id;

    }

    @AuraEnabled
    public static String publishForm(String recordId){
        
        Clarity_Form__c form = [SELECT Id, Status__c, Name FROM Clarity_Form__c WHERE Id =: recordId Limit 1]; 

        form.Status__c = 'Published'; 

        Database.SaveResult result = Database.update(form, true); 

        if(!result.isSuccess()) {
            throw new AuraHandledException('Unable to publish form: ' + form.Name);
        }

        return 'Success';

    }

}
