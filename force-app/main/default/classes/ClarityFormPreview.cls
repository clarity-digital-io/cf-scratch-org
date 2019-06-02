public with sharing class ClarityFormPreview {

    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled
    public static Map<String, List<sObject>> preview(String recordId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c WHERE Id =: recordId Limit 1];
        
        Clarity_Form_Response__c response = [SELECT Id FROM Clarity_Form_Response__c WHERE Status__c = 'Preview' AND Clarity_Form__c =: form.Id];

        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        formDetails.put('FormResponse', new List<sObject>{ response });
        formDetails.put('Form', new List<sObject>{ form });
        formDetails.put('Questions', questions);

        return formDetails; 

    }

    @AuraEnabled
    public static void publishFlow(String questionFlow) {
        System.debug(questionFlow);
    }

    @AuraEnabled(Cacheable=true)
    public static List<LookupSearchResult> search(String searchTerm, String lookupObject, List<String> selectedIds) {

        searchTerm += '*';

        String searchString = 'FIND ' + '\'' + searchTerm + '\'' + ' IN ALL FIELDS RETURNING ' + lookupObject + ' (Id)';

        List<List<sObject>> searchResults = search.query(searchString);

        List<LookupSearchResult> results = new List<LookupSearchResult>();

        String recordIcon = 'standard:' + lookupObject.toLowerCase();

        List<sObject> records = ((List<sObject>) searchResults[0]);

        for (sObject record : records) {
            results.add(new LookupSearchResult(record.Id, lookupObject, recordIcon, (String)record.get('Id'), lookupObject));
        }

        return results;
    }

}


