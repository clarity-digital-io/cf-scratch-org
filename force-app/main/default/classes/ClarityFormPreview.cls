public with sharing class ClarityFormPreview {

    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled
    public static Map<String, List<sObject>> preview(String recordId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c WHERE Id =: recordId Limit 1];

        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            Title__c, Order__c, Required__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

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

        String searchString = 'FIND ' + searchTerm + ' IN ALL FIELDS RETURNING ' + lookupObject + '(Id, Name)';

        List<List<sObject>> searchResults = search.query(searchString);

        List<LookupSearchResult> results = new List<LookupSearchResult>();


        String accountIcon = 'standard:account';

        Account [] accounts = ((List<Account>) searchResults[0]);

        for (Account account : accounts) {
            results.add(new LookupSearchResult(account.Id, 'Account', accountIcon, account.Name, 'Account • '+ account.BillingCity));
        }


        String opptyIcon = 'standard:opportunity';

        Opportunity [] opptys = ((List<Opportunity>) searchResults[1]);

        for (Opportunity oppty : opptys) {
            results.add(new LookupSearchResult(oppty.Id, 'Opportunity', opptyIcon, oppty.Name, 'Opportunity • '+ oppty.StageName));
        }

        return results;
    }

}


