public with sharing class ClarityFormResponse {

    private final static Integer MAX_RESULTS = 5;
    
    @AuraEnabled
    public static String submit(String formResponseId) {

        Clarity_Form_Response__c response = [SELECT Id, Status__c FROM Clarity_Form_Response__c WHERE Id =: formResponseId AND Status__c != 'Submitted' Limit 1];

        response.Status__c = 'Submitted'; 

        Database.SaveResult result = Database.update(response);

        if(!result.isSuccess())
            System.debug('error deleting');

        return 'Success'; 

    }

    @AuraEnabled
    public static Map<String, List<sObject>> create(String recordId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c WHERE Id =: recordId AND Status__c = 'Published' Limit 1];
        
        Clarity_Form_Response__c response = new Clarity_Form_Response__c(
            Status__c       = 'New', 
            Clarity_Form__c = form.Id
        );

        Database.SaveResult result = Database.insert(response);

        if(!result.isSuccess())
            System.debug('error creating new repsonse');

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
    public static Map<String, List<sObject>> preview(String recordId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name FROM Clarity_Form__c WHERE Id =: recordId Limit 1];
        
        Clarity_Form_Response__c response = [SELECT Id, (SELECT Id FROM Clarity_Form_Answers__r) FROM Clarity_Form_Response__c WHERE Status__c = 'Preview' AND Clarity_Form__c =: form.Id];

        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        List<Clarity_Form_Answer__c> answers = new List<Clarity_Form_Answer__c>();

        answers.addAll(response.Clarity_Form_Answers__r);

        if(answers.size() > 0) {
            
            List<Database.DeleteResult> deleteResults = Database.delete(answers);

            for(Database.DeleteResult result : deleteResults) {

                if(!result.isSuccess()) {
                    System.debug('error deleting');
                }

            }

        }

        formDetails.put('FormResponse', new List<sObject>{ response });
        formDetails.put('Form', new List<sObject>{ form });
        formDetails.put('Questions', questions);

        return formDetails; 

    }

    @AuraEnabled
    public static Clarity_Form_Answer__c saveAnswer(String answer){
        
        Clarity_Form_Answer__c parsedAnswer = (Clarity_Form_Answer__c)JSON.deserialize(answer, Clarity_Form_Answer__c.class);

        Database.UpsertResult result = Database.upsert(parsedAnswer, true); 

        if(!result.isSuccess()) {

            System.debug('error: ' + result.getErrors());

        }

        return parsedAnswer;
        
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
