global with sharing class ClarityFormBuilder {
	
    @RemoteAction
    global static List<String> save(String sQuestions){

        List<String> saved = new List<String>(); 

        List<Clarity_Form_Question__c> parsedQuestions = (List<Clarity_Form_Question__c>)JSON.deserialize(sQuestions, List<Clarity_Form_Question__c>.class);

        List<Database.UpsertResult> results = Database.upsert(parsedQuestions, true); 

        for(Database.UpsertResult result : results) {

            if(result.isSuccess()) {
                if(result.isCreated()) {
                    saved.add(result.getId());
                }
            }

        }

        return saved; 
    }

    @RemoteAction
    global static Clarity_Form__c startup(String formId) {
        
        Clarity_Form__c form = null;

        if(formId == '') {

            Clarity_Form_Style__c styling = [SELECT Id, Background_Color__c, Color__c FROM Clarity_Form_Style__c WHERE Name = 'Classic'];

            Clarity_Form__c newForm = new Clarity_Form__c(Name = 'Clarity Form', Clarity_Form_Style__c = styling.Id); 
            
            Database.SaveResult result = Database.insert(newForm); 

            if(!result.isSuccess()) System.debug('throw error'); // throw error
            
            Clarity_Form_Response__c response = new Clarity_Form_Response__c(Status__c = 'Preview', Clarity_Form__c = newForm.Id);

            Database.SaveResult resultResponse = Database.insert(response); 

            if(!resultResponse.isSuccess()) System.debug('throw error'); // throw error

            formId = newForm.Id;

        } 
        
        form = [SELECT Id, Name, Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Color__c FROM Clarity_Form__c WHERE Id =: formId];

        return form; 

    }

    @RemoteAction
    global static List<Clarity_Form_Question__c> getQuestions(String recordId){

        Clarity_Form__c form = [SELECT Id, Name, Status__c FROM Clarity_Form__c WHERE Id =: recordId LIMIT 1];

        List<Clarity_Form_Question__c> questions = [SELECT Id, Required__c, Title__c, Order__c, Type__c, Clarity_Form__c, Max_Length__c, Lookup__c 
            FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        return questions; 

    }

    @RemoteAction
    global static List<Clarity_Form_Question_Option__c> getQuestionOptions(String sQuestionId) {

        List<Clarity_Form_Question_Option__c> options = [SELECT Id, Active_Flow__c, Label__c FROM Clarity_Form_Question_Option__c WHERE Clarity_Form_Question__c =: sQuestionId];

        return options; 

    }

    @RemoteAction
    global static String saveQuestion(String sQuestion) {

        Clarity_Form_Question__c parsedQuestion = (Clarity_Form_Question__c)JSON.deserialize(sQuestion, Clarity_Form_Question__c.class);

        Database.SaveResult result = Database.update(parsedQuestion, true); 

        if(!result.isSuccess()) {
            System.debug('error');
        }
        
        return result.getId();

    }

    @RemoteAction
    global static Map<String, List<sObject>> saveQuestionWithOptions(String sQuestion, String sQuestionOptions) {

        Clarity_Form_Question__c parsedQuestion = (Clarity_Form_Question__c)JSON.deserialize(sQuestion, Clarity_Form_Question__c.class);

        List<Clarity_Form_Question_Option__c> parsedQuestionOptions = (List<Clarity_Form_Question_Option__c>)JSON.deserialize(sQuestionOptions, List<Clarity_Form_Question_Option__c>.class);

        Database.SaveResult resultQuestion = Database.update(parsedQuestion, true); 

        if(!resultQuestion.isSuccess()) {
            System.debug('error');
        }

        List<Database.UpsertResult> resultOptions = Database.upsert(parsedQuestionOptions, true); 
        
        for(Database.UpsertResult result : resultOptions) {

            if(!result.isSuccess()) {

                System.debug('error: ' + result.getErrors());

            }

        }

        Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 
        
        List<sObject> options = new List<sObject>(); 
        options.addAll(parsedQuestionOptions);
        
        results.put('Question', new List<sObject> { parsedQuestion });
        results.put('Options', options);

        return results;
    }

    @RemoteAction 
    global static List<Clarity_Form_Question__c> deleteQuestion(String sQuestions, String sDeleteQuestionId) {

        Clarity_Form_Question__c questionToDelete = [SELECT Id FROM Clarity_Form_Question__c WHERE Id =: sDeleteQuestionId];

        Database.DeleteResult result = Database.delete(questionToDelete, true);

        if(!result.isSuccess()) {
            System.debug('error: ' + result.getErrors());
        }
        
        List<Clarity_Form_Question__c> parsedQuestions = (List<Clarity_Form_Question__c>)JSON.deserialize(sQuestions, List<Clarity_Form_Question__c>.class);

        List<Database.SaveResult> results = Database.update(parsedQuestions, true); 

        for(Database.SaveResult sResult : results) {

            if(!sResult.isSuccess()) {
                System.debug('error');
            }

        }

        return parsedQuestions;
    }

    @RemoteAction 
    global static Map<String, List<sObject>> getQuestionEditDetails(String sQuestionId) {

        Clarity_Form_Question_Flow_Design__c flowDesign = [SELECT Id, Active__c, Form_Submission__c, Clarity_Form_Question__c FROM Clarity_Form_Question_Flow_Design__c WHERE Clarity_Form_Question__c =: sQuestionId LIMIT 1];

        List<Clarity_Form_Question_Option__c> questionOptions = [SELECT Id, Active_Flow__c, Label__c FROM Clarity_Form_Question_Option__c WHERE Clarity_Form_Question__c =: sQuestionId];

        List<Clarity_Form_Question_Criteria__c> criteria = [SELECT Id, Field__c, Operator__c, Type__c, Value__c, Clarity_Form_Question__c FROM Clarity_Form_Question_Criteria__c WHERE Clarity_Form_Question__c =: sQuestionId];

        Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 
        
        List<sObject> options = new List<sObject>(); 
        options.addAll(questionOptions);

        List<sObject> flow = new List<sObject>(); 
        flow.add(flowDesign);

        results.put('Criteria', criteria);
        results.put('Options', options);
        results.put('FlowDesign', flow);

        return results;

    }

    @RemoteAction
    global static Map<String, List<sObject>> saveFlowDesign(String sFlowDesign, String sQuestionOptions) {

        Clarity_Form_Question_Flow_Design__c parsedFlowDesign = (Clarity_Form_Question_Flow_Design__c)JSON.deserialize(sFlowDesign, Clarity_Form_Question_Flow_Design__c.class);
    
        Database.UpsertResult result = Database.upsert(parsedFlowDesign, true); 

        if(!result.isSuccess()) {
           System.debug('log error: '); 
        }

        List<Clarity_Form_Question_Option__c> parsedQuestionOptions = (List<Clarity_Form_Question_Option__c>)JSON.deserialize(sQuestionOptions, List<Clarity_Form_Question_Option__c>.class);

        List<Database.UpsertResult> resultOptions = Database.upsert(parsedQuestionOptions, true); 
        
        for(Database.UpsertResult resultOption : resultOptions) {

            if(!resultOption.isSuccess()) {

                System.debug('error: ' + resultOption.getErrors());

            }

        }

        List<sObject> options = new List<sObject>(); 
        options.addAll(parsedQuestionOptions);

        List<sObject> flow = new List<sObject>(); 
        flow.add(parsedFlowDesign);

        Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 

        results.put('Options', options);
        results.put('FlowDesign', flow);


        return results;
        
    }

    @RemoteAction
    global static List<String> getSObjectsAvailable() {

        List<String> lookups = new List<String>(); 

        Map<String, Schema.SObjectType> sObjectsAvailable = Schema.getGlobalDescribe();

        for(Schema.SObjectType so : sObjectsAvailable.values()) {

            lookups.add(so.getDescribe().getName());
        
        }

        return lookups; 

    }

    @RemoteAction
    global static Map<String, Map<String, String>> getRecordGroupFields(String objectType) {

        SObjectType sObjType = ((SObject)Type.forName(objectType).newInstance()).getSObjectType();

        Schema.DescribeSObjectResult result = sObjType.getDescribe();

        Map<String, Schema.SObjectField> fields = result.fields.getMap();

        Map<String, Map<String, String>> requiredFields = new Map<String, Map<String, String>>();

        requiredFields.put('Required', new Map<String, String>());
        requiredFields.put('NotRequired', new Map<String, String>());

        for(String fieldName : fields.keySet()) { 

            Schema.SObjectField field = fields.get(fieldName);

            Schema.DescribeFieldResult fieldResult = field.getDescribe();

            Schema.DisplayType type = fieldResult.getType();

            Boolean isFieldReq  = fieldResult.isNillable();
            Boolean isFieldCreateable = fieldResult.isCreateable(); 

            if(!isFieldReq && isFieldCreateable) {

                requiredFields.get('Required').put('' + field, '' + type);

            } else if(isFieldCreateable) {

                requiredFields.get('NotRequired').put('' + field, '' + type);

            }

        }

        return requiredFields; 

    }

    @RemoteAction
    global static List<User> getUsers(String searchTerm){

        String searchKey = '%' + searchTerm + '%';

        List<User> users = [SELECT Id, Name FROM User WHERE Name LIKE :searchKey LIMIT 20];

        return users;

    }

}