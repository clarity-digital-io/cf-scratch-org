global with sharing class ClarityFormResponse {

    private final static Integer MAX_RESULTS = 5;

    @RemoteAction
    global static List<String> submit(String answerImages, String formResponseId) {

        List<Clarity_Form_Answer__c> savedAnswers = ClarityFormsService.upload(answerImages); 

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
    global static List<LookupResult> search(List<String> searchItems) {

        String searchTerm = searchItems[0];
        String lookupObject = searchItems[1];
        String questionId = searchItems[2]; 

        searchTerm += '*';

        String searchString = 'FIND ' + '\'' + searchTerm + '\'' + ' IN ALL FIELDS RETURNING ' + lookupObject + ' (Id, Name)';

        List<List<sObject>> searchResults = search.query(searchString);

        List<LookupResult> results = new List<LookupResult>();

        String recordIcon = 'standard:' + lookupObject.toLowerCase();

        List<sObject> records = ((List<sObject>) searchResults[0]);

        for (sObject record : records) {
            System.debug('record: ' + record);
            results.add(new LookupResult(record.Id, lookupObject, (String)record.get('Name'), lookupObject));
        }

        return results;
    }

    @RemoteAction 
    global static sObject createRecord(List<String> recordValues) {

        String responseId = recordValues[0]; 
        String recordGroupId = recordValues[1]; 
        String sObjectName = recordValues[2];
        String records = recordValues[3];

        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(sObjectName);

        List<Record> recordFields = (List<Record>)JSON.deserialize(records, List<Record>.class);

        sObject genericObject = convertType.newSObject();

        for(Record record : recordFields) {

            if(record.type == 'Date') {

                Date value = Date.parse(record.value); 
                genericObject.put(record.field, value);

            } else {
                
                genericObject.put(record.field, record.value);

            }

        }

        Database.UpsertResult result = Database.upsert(genericObject, true); 

        if(!result.isSuccess()) {

            System.debug('error: ' + result.getErrors());

        }

        Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
            Clarity_Form_Response__c = responseId, 
            Clarity_Form_Question__c = recordGroupId,
            Record__c                = result.getId()
        );

        Database.UpsertResult resultAnswer = Database.upsert(answer, true); 

        if(!resultAnswer.isSuccess()) {

            System.debug('error: ' + resultAnswer.getErrors());

        }

        return genericObject;

    }

    @RemoteAction
    global static Map<String, Map<String, Map<String, String>>> getRecordGroupPicklist(List<String> sPicklistQuestionIds) {

        List<Clarity_Form_Question__c> picklistQuestions = [SELECT Id, Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, 
            Record_Group__r.Salesforce_Object__c, Salesforce_Field__c, Type__c FROM Clarity_Form_Question__c WHERE ID IN :sPicklistQuestionIds];

        Map<String, List<String>> rcp = ClarityFormsService.filterRecordGroupPicklist(picklistQuestions);

        Map<String, Map<String, Map<String, String>>> values = ClarityFormsService.getSalesforcePicklistValues(rcp);

        return values; 

    }

    global class Record {

        public String field; 
        public String value; 
        public String type; 

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
