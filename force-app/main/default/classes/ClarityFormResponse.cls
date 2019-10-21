global with sharing class ClarityFormResponse {

    private final static Integer MAX_RESULTS = 5;

    @RemoteAction
    global static List<String> submit(String formResponseId) {

        List<String> success = ClarityFormsService.submit(new List<String>{ formResponseId });

        return success; 
        
    }

    @RemoteAction
    global static Map<String, List<sObject>> preview(String formId) {

        Map<String, List<sObject>> formDetails = ClarityFormsService.create((Id)formId);

        return formDetails; 

    }

    @RemoteAction
    global static Map<String, List<sObject>> create(String formName) {

        Map<String, List<sObject>> formDetails = ClarityFormsService.create(formName);

        return formDetails; 

    }

    @RemoteAction
    global static Map<String, List<sObject>> edit(String responseId) {

        Map<String, List<sObject>> formDetails = ClarityFormsService.edit(responseId);

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
