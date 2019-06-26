global with sharing class ClarityFormResponse {

    private final static Integer MAX_RESULTS = 5;
    
    @RemoteAction
    global static String submit(String formResponseId) {

        Clarity_Form_Response__c response = [SELECT Id, Status__c FROM Clarity_Form_Response__c WHERE Id =: formResponseId AND Status__c != 'Submitted' Limit 1];

        response.Status__c = 'Submitted'; 

        Database.SaveResult result = Database.update(response);

        if(!result.isSuccess())
            System.debug('error deleting');

        return 'Success'; 

    }

    @RemoteAction
    global static Map<String, List<sObject>> create(String recordId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name, Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Color__c FROM Clarity_Form__c WHERE Id =: recordId AND Status__c = 'Published' Limit 1];
        
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

    @RemoteAction
    global static Map<String, List<sObject>> preview(String recordId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name, Multi_Page__c, Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Color__c FROM Clarity_Form__c WHERE Id =: recordId Limit 1];
        
        Clarity_Form_Response__c response = [SELECT Id, (SELECT Id, Clarity_Form_Question__c, Answer__c FROM Clarity_Form_Answers__r) FROM Clarity_Form_Response__c WHERE Status__c = 'Preview' AND Clarity_Form__c =: form.Id];

        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            (SELECT Id, Clarity_Form_Question__c, Field__c, Operator__c, Type__c, Value__c FROM Clarity_Form_Question_Criteria__r), 
            Page__c, Logic__c, Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        formDetails.put('Answers', response.Clarity_Form_Answers__r);
        formDetails.put('FormResponse', new List<sObject>{ response });
        formDetails.put('Form', new List<sObject>{ form });
        formDetails.put('Questions', questions);

        return formDetails; 

    }

    @RemoteAction
    global static Clarity_Form_Answer__c saveAnswer(String answer){
        
        Clarity_Form_Answer__c parsedAnswer = (Clarity_Form_Answer__c)JSON.deserialize(answer, Clarity_Form_Answer__c.class);

        Database.UpsertResult result = Database.upsert(parsedAnswer, true); 

        if(!result.isSuccess()) {

            System.debug('error: ' + result.getErrors());

        }

        return parsedAnswer;
        
    }

    @RemoteAction
    global static void publishFlow(String questionFlow) {
        System.debug(questionFlow);
    }

    @RemoteAction 
    global static List<LookupResult> search(String searchTerm, String lookupObject, String questionId) {

        searchTerm += '*';

        String searchString = 'FIND ' + '\'' + searchTerm + '\'' + ' IN ALL FIELDS RETURNING ' + lookupObject + ' (Id)';

        List<List<sObject>> searchResults = search.query(searchString);

        List<LookupResult> results = new List<LookupResult>();

        String recordIcon = 'standard:' + lookupObject.toLowerCase();

        List<sObject> records = ((List<sObject>) searchResults[0]);

        for (sObject record : records) {
            System.debug('record: ' + record);
            results.add(new LookupResult(record.Id, lookupObject, (String)record.get('Id'), lookupObject));
        }

        return results;
    }

    @RemoteAction 
    global static Id createRecord(String sObject, Map<String, String> records) {
        //OpportunityLineItem
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(sObject);

        Sobject genericObject = convertType.newSObject();

        genericObject.OpportunityId = ''; 

        Database.UpsertResult result = Database.upsert(genericObject, true); 

        if(!result.isSuccess()) {

            System.debug('error: ' + result.getErrors());

        }

        return result.Id; 

    }

    global class LookupResult {

        private Id id;
        private String type;
        private String label;
        private String subTitle;

        public LookupResult(Id id, String type, String label, String subTitle) {
            this.id = id;
            this.type = type;
            this.label = label;
            this.subTitle = subTitle;
        }

    }
    
}
