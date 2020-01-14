global with sharing class ClarityFormResponse {

    private final static Integer MAX_RESULTS = 5;
    
    @RemoteAction
    global static Map<String, List<sObject>> preview(String formId) {

        Map<String, List<sObject>> formDetails = ClarityFormsService.create((Id)formId);

        return formDetails; 

    }

    @RemoteAction 
    global static List<forms__Form_Connection__c> checkConnections(String responseId) {
        
        List<forms__Form_Connection__c> requiredConnections = new List<forms__Form_Connection__c>(); 

        forms__Form_Response__c response = [SELECT Id, forms__Form__c FROM forms__Form_Response__c WHERE Id =: responseId LIMIT 1];

        Map<Id, forms__Form_Connection__c> connections = new Map<Id, forms__Form_Connection__c>([SELECT Id, Salesforce_Object__c, New__c FROM forms__Form_Connection__c WHERE forms__Form__c =: response.forms__Form__c AND New__c = false]);

        if(connections.size() > 0) {

            List<forms__Form_Response_Connection__c> responseConnections = [SELECT Id, forms__Form_Connection__c 
                FROM forms__Form_Response_Connection__c WHERE forms__Form_Response__c =: responseId AND forms__Form_Connection__c IN :connections.keySet()];

            if(responseConnections.size() == 0) {
                return connections.values();
            } 

            Set<Id> responseConnectedIds = new Set<Id>(); 

            for(forms__Form_Response_Connection__c rc : responseConnections){
                responseConnectedIds.add(rc.forms__Form_Connection__c); 
            }

            for(forms__Form_Connection__c connection : connections.values()) {
                if(!responseConnectedIds.contains(connection.Id)) {
                    requiredConnections.add(connection); 
                }
            }

        }

        return requiredConnections;
    }

    @RemoteAction
    global static List<forms__Form_Connection__c> getConnections(String formName) {

        forms__Form__c form = [SELECT Id FROM forms__Form__c WHERE Name =: formName LIMIT 1];

        List<forms__Form_Connection__c> connections = [SELECT Id, Salesforce_Object__c, New__c FROM forms__Form_Connection__c WHERE forms__Form__c =: form.Id];

        return connections; 

    }

    @RemoteAction
    global static Map<Id, List<sObject>> getRecordGroupResults(String responseId, String formId) {

        List<forms__Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM forms__Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM forms__Form_Question_Flow_Designs__r LIMIT 1),
            (SELECT Id, Field_Type__c, Field__c, Operator__c, Type__c, Value__c, forms__Form_Question__c FROM forms__Form_Question_Criteria__r),
            Salesforce_Object__c, FreeText_Type__c, Title__c, Order__c, Required__c, Lookup__c, 
            Salesforce_Field__c, Record_Group__c, Record_Group__r.Salesforce_Object__c, 
            Page__c, Type__c FROM forms__Form_Question__c WHERE forms__Form__c =: formId];

        List<forms__Form_Answer__c> answers = [SELECT Id, Record__c, Answer__c, Date_Answer__c, ContentDocument__c, 
            forms__Form_Question__r.Salesforce_Object__c, forms__Form_Response__c, forms__Form_Question__c, 
            forms__Form_Question__r.Record_Group__c, forms__Form_Question__r.Type__c  
            FROM forms__Form_Answer__c WHERE forms__Form_Response__c =: responseId];

        Map<Id, List<sObject>> records = ClarityFormsService.getRecordGroupSubmissions(answers, questions);

        return records; 

    }

    @RemoteAction
    global static Map<String, List<sObject>> create(String formName, String sConnections) {

        Map<String, List<sObject>> formDetails = ClarityFormsService.create(formName, sConnections);

        return formDetails; 

    }

    @RemoteAction
    global static Map<String, List<sObject>> edit(String responseId, String sConnections) {

        Map<String, List<sObject>> formDetails = ClarityFormsService.edit(responseId, sConnections);

        return formDetails; 

    }

    @RemoteAction
    global static List<forms__Form_Answer__c> saveAnswer(String answer){

        List<forms__Form_Answer__c> savedAnswers = ClarityFormsService.save(answer); 

        return savedAnswers;
        
    }

    @RemoteAction
    global static List<String> save(List<String> answerValues) {

        String answerImages = answerValues[0];
        String answers = answerValues[1];
        String formResponseId = answerValues[2]; 

        List<forms__Form_Answer__c> savedAnswerImages = ClarityFormsService.upload(answerImages); 

        List<forms__Form_Answer__c> savedAnswers = ClarityFormsService.save(answers); 

        List<String> success = ClarityFormsService.updateStatus(new List<String>{ formResponseId }, 'In Progress');

        return success; 

    }

    @RemoteAction
    global static List<String> submit(List<String> answerValues) {

        String answerImages = answerValues[0];
        String answers = answerValues[1];
        String formResponseId = answerValues[2]; 

        List<forms__Form_Answer__c> savedAnswerImages = ClarityFormsService.upload(answerImages); 

        List<forms__Form_Answer__c> savedAnswers = ClarityFormsService.save(answers); 

        List<String> success = ClarityFormsService.updateStatus(new List<String>{ formResponseId }, 'Submitted');

        return success; 
        
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
    global static List<LookupResult> connectionSearch(List<String> searchItems) {

        String searchTerm = searchItems[0];
        String lookupObject = searchItems[1];
        String fields = searchItems[2]; 

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

        forms__Form_Answer__c answer = new forms__Form_Answer__c(
            forms__Form_Response__c = responseId, 
            forms__Form_Question__c = recordGroupId,
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

        List<forms__Form_Question__c> picklistQuestions = [SELECT Id, Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, 
            Record_Group__r.Salesforce_Object__c, Salesforce_Field__c, Type__c FROM forms__Form_Question__c WHERE ID IN :sPicklistQuestionIds];

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
