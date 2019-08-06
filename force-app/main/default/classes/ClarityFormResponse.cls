global with sharing class ClarityFormResponse {

    private final static Integer MAX_RESULTS = 5;

    @RemoteAction
    global static Map<String, List<sObject>> preview(String recordId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name, Clarity_Form_Style__r.Multi_Page__c, Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Color__c FROM Clarity_Form__c WHERE Id =: recordId Limit 1];
        
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
    global static List<String> submit(String formResponseId) {

        List<String> success = ClarityFormsService.submit(new List<String>{ formResponseId });

        return success; 
        
    }

    @RemoteAction
    global static Map<String, List<sObject>> create(String formName) {

        Clarity_Form__c form = [SELECT Id, Name, Clarity_Form_Style__r.Button_Color__c, 
            Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Color__c 
            FROM Clarity_Form__c WHERE Name =: formName Limit 1];

        Map<String, List<sObject>> formDetails = ClarityFormsService.getForm(form.Id);

        return formDetails; 

    }

    @RemoteAction
    global static Map<String, List<sObject>> edit(String responseId) {

        Clarity_Form_Response__c response = [SELECT Id FROM Clarity_Form_Response__c WHERE Id =: responseId Limit 1];

        Map<String, List<sObject>> formDetails = ClarityFormsService.getForm(response.Clarity_Form__c);

        return formDetails; 

    }

    @RemoteAction
    global static List<Clarity_Form_Answer__c> saveAnswer(String answer){

        List<Clarity_Form_Answer__c> savedAnswers = ClarityFormsService.save(new List<String>{ answer }); 

        return savedAnswers;
        
    }

    @RemoteAction
    global static List<Clarity_Form_Answer__c> saveAnswerImage(String answerImages) {

        List<Clarity_Form_Answer__c> savedAnswers = ClarityFormsService.upload(answerImages); 

        return savedAnswers;   

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
    global static sObject createRecord(String recordGroupId, String sObjectName, String records) {

        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(sObjectName);

        List<Record> recordFields = (List<Record>)JSON.deserialize(records, List<Record>.class);

        sObject genericObject = convertType.newSObject();

        for(Record record : recordFields) {

            genericObject.put(record.field, record.value);

        }

        Database.UpsertResult result = Database.upsert(genericObject, true); 

        if(!result.isSuccess()) {

            System.debug('error: ' + result.getErrors());

        }

        Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
            Clarity_Form_Question__c = recordGroupId,
            Record__c                = result.getId()
        );

        Database.UpsertResult resultAnswer = Database.upsert(answer, true); 

        if(!resultAnswer.isSuccess()) {

            System.debug('error: ' + resultAnswer.getErrors());

        }
        return genericObject;
    }

    global class Record {

        public String field; 
        public Object value; 

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
