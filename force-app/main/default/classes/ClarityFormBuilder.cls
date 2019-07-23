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

            Clarity_Form_Style__c styling = new Clarity_Form_Style__c(Name = 'Clarity Form Styling', Background_Color__c = '#FFF', Color__c = '#333');

            Database.SaveResult stylingResult = Database.insert(styling); 

            if(!stylingResult.isSuccess()) System.debug('throw error'); // throw error

            Clarity_Form__c newForm = new Clarity_Form__c(Name = 'Clarity Form', Clarity_Form_Style__c = styling.Id); 
            
            Database.SaveResult result = Database.insert(newForm); 

            if(!result.isSuccess()) System.debug('throw error'); // throw error
            
            Clarity_Form_Response__c response = new Clarity_Form_Response__c(Status__c = 'Preview', Clarity_Form__c = newForm.Id);

            Database.SaveResult resultResponse = Database.insert(response); 

            if(!resultResponse.isSuccess()) System.debug('throw error'); // throw error

            formId = newForm.Id;

        } 
        
        form = [SELECT Id, Name, Limit__c, End_Date__c, Clarity_Form_Style__r.Multi_Page__c, Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Color__c, 
            Clarity_Form_Assignment__c, Clarity_Form_Assignment__r.Assign__c, Clarity_Form_Assignment__r.Default_Assign__c, Clarity_Form_Assignment__r.Name 
            FROM Clarity_Form__c WHERE Id =: formId];

        return form; 

    }

    @RemoteAction
    global static Clarity_Form__c updateForm(String sForm) {

        Clarity_Form__c parsedForm = (Clarity_Form__c)JSON.deserialize(sForm, Clarity_Form__c.class);

        Database.SaveResult result = Database.update(parsedForm, true); 

        if(!result.isSuccess()) {
            System.debug('error');
        }

        return parsedForm;
    
    }

    @RemoteAction
    global static List<Clarity_Form_Style__c> getDesigns() {

        List<Clarity_Form_Style__c> designs = [SELECT Id, Multi_Page__c, Background_Image__c, Background_Color__c, Button_Color__c, Color__c FROM Clarity_Form_Style__c];

        return designs; 
        
    }

    @RemoteAction
    global static Clarity_Form_Style__c updateDesign(String sDesign, String file) {

        Clarity_Form_Style__c parsedStyle = (Clarity_Form_Style__c)JSON.deserialize(sDesign, Clarity_Form_Style__c.class);

        if(file != '') {

            ContentVersion content = new ContentVersion();
            content.ContentLocation = 'S'; 
            content.PathOnClient = parsedStyle.Name + 'Background.png';
            content.Title = parsedStyle.Name + ' Background'; 
            content.VersionData = EncodingUtil.base64Decode(file); // converting your binary string to Blob

            Database.SaveResult contentResult = Database.insert(content, true); 

            if(!contentResult.isSuccess()) {
                System.debug('error');
            }

            //we should delete any related to this record

            Id documentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:content.Id].ContentDocumentId;

            ContentDocumentLink documentLink = new ContentDocumentLink();
            documentLink.ContentDocumentId = documentId;
            documentLink.LinkedEntityId = parsedStyle.Id; 
            documentLink.ShareType = 'I'; 
            documentLink.Visibility = 'AllUsers';
            
            Database.SaveResult documentResult = Database.insert(documentLink, true); 

            if(!documentResult.isSuccess()) {
                System.debug('error');
            }

            //Attach to Clarity Form Style

            parsedStyle.Background_Image__c = documentId;

            Database.SaveResult result = Database.update(parsedStyle, true); 

            if(!result.isSuccess()) {
                System.debug('error');
            }

        } else {

            parsedStyle.Background_Image__c = '';

            Database.SaveResult result = Database.update(parsedStyle, true); 

            if(!result.isSuccess()) {
                System.debug('error');
            }

        }

        return parsedStyle;

    }

    @RemoteAction
    global static List<Clarity_Form_Question__c> getQuestions(String recordId){

        List<Clarity_Form_Question__c> questions = [SELECT Id, Page__c, Salesforce_Object__c, Salesforce_Field__c, Record_Group__c, Required__c, Title__c, Order__c, Type__c, Clarity_Form__c, Max_Length__c, Lookup__c 
            FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: recordId];

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

    // @RemoteAction
    // global static  Map<String, List<sObject>> saveQuestionWithPictureOptions(String sQuestion, String sQuestionOptions) {

    //     List<Clarity_Form_Question_Option__c> parsedQuestionOptions = (List<Clarity_Form_Question_Option__c>)JSON.deserialize(sQuestionOptions, List<Clarity_Form_Question_Option__c>.class);

    //     for(Clarity_Form_Question_Option__c option : parsedQuestionOptions) {
    //         Map<String, Object> optionFields = new Map<String, Object>( option.getPopulatedFieldsAsMap() );
    //     }
        
    //     Map<String, List<sObject>> = saveQuestionWithOptions(sQuestion, sQuestionOptions); 

    // }


    @RemoteAction
    global static Map<String, List<sObject>> saveQuestionWithOptions(String sQuestion, String sQuestionOptions) {

        Clarity_Form_Question__c parsedQuestion = (Clarity_Form_Question__c)JSON.deserialize(sQuestion, Clarity_Form_Question__c.class);

        Database.SaveResult resultQuestion = Database.update(parsedQuestion, true); 

        if(!resultQuestion.isSuccess()) {
            System.debug('error result');
        }

        List<Clarity_Form_Question_Option__c> currentOptions = [SELECT Id, Active_Flow__c, Label__c FROM Clarity_Form_Question_Option__c WHERE Clarity_Form_Question__c =: parsedQuestion.Id];

        List<Clarity_Form_Question_Option__c> parsedQuestionOptions = (List<Clarity_Form_Question_Option__c>)JSON.deserialize(sQuestionOptions, List<Clarity_Form_Question_Option__c>.class);

        Map<Id, Clarity_Form_Question_Option__c> updatedQuestionOptionsById = new Map<Id, Clarity_Form_Question_Option__c>();

        for(Clarity_Form_Question_Option__c o : parsedQuestionOptions) {
            updatedQuestionOptionsById.put(o.Id, o); 
        }

        List<Clarity_Form_Question_Option__c> notFoundInParsedQuestionOptions = new List<Clarity_Form_Question_Option__c>();

        for(Clarity_Form_Question_Option__c currentOption : currentOptions) {

            if(updatedQuestionOptionsById.get(currentOption.Id) == null) {
                notFoundInParsedQuestionOptions.add(currentOption); 
            }

        }

        if(notFoundInParsedQuestionOptions.size() > 0) {
            
            List<Database.DeleteResult> deleteOptions = Database.delete(notFoundInParsedQuestionOptions, true);

            for(Database.DeleteResult deleteOption : deleteOptions) {

                if(!deleteOption.isSuccess()) {

                    System.debug('error: ' + deleteOption.getErrors());

                }

            }
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
    global static List<Clarity_Form_Question__c> pageDelete(String sQuestions, String sDetails) {

        List<String> details = (List<String>)JSON.deserialize(sDetails, List<String>.class);

        Double page = Double.valueOf(details[0]); 
        String recordId = details[1];

        List<Clarity_Form_Question__c> questionsToDelete = [SELECT Id, Page__c, Salesforce_Object__c, Salesforce_Field__c, Record_Group__c, Required__c, Title__c, Order__c, Type__c, Clarity_Form__c, Max_Length__c, Lookup__c 
            FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: recordId AND Page__c =: page];

        List<Database.DeleteResult> deleteResults = Database.delete(questionsToDelete, true); 

        for(Database.DeleteResult result : deleteResults) {
            if(!result.isSuccess()) {
                System.debug('delete fail');
            }
        }
        
        List<Clarity_Form_Question__c> parsedQuestions = (List<Clarity_Form_Question__c>)JSON.deserialize(sQuestions, List<Clarity_Form_Question__c>.class);

        if(parsedQuestions.size() > 0) {
            List<Database.SaveResult> results = Database.update(parsedQuestions, true); 

            for(Database.SaveResult sResult : results) {

                if(!sResult.isSuccess()) {
                    System.debug('error');
                }

            }
        }

        return parsedQuestions; 

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

        List<Clarity_Form_Question_Flow_Design__c> flowDesign = [SELECT Id, Active__c, Form_Submission__c, Clarity_Form_Question__c FROM Clarity_Form_Question_Flow_Design__c WHERE Clarity_Form_Question__c =: sQuestionId LIMIT 1];

        List<Clarity_Form_Question_Option__c> questionOptions = [SELECT Id, Active_Flow__c, Choice_Image__c, Label__c FROM Clarity_Form_Question_Option__c WHERE Clarity_Form_Question__c =: sQuestionId];

        List<Clarity_Form_Question_Criteria__c> criteria = [SELECT Id, Field_Type__c, Field__c, Operator__c, Type__c, Value__c, Clarity_Form_Question__c FROM Clarity_Form_Question_Criteria__c WHERE Clarity_Form_Question__c =: sQuestionId];

        Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 

        results.put('Criteria', criteria);
        results.put('Options', questionOptions);
        results.put('FlowDesign', flowDesign);

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
    global static Map<String, List<sObject>> savQuestionWithCriteria(String sQuestion, String sCriteria) {

        Clarity_Form_Question__c parsedQuestion = (Clarity_Form_Question__c)JSON.deserialize(sQuestion, Clarity_Form_Question__c.class);

        Database.SaveResult resultQuestion = Database.update(parsedQuestion, true); 

        if(!resultQuestion.isSuccess()) {
            System.debug('error');
        }

        List<Clarity_Form_Question_Criteria__c> currentCriteria = [SELECT Id FROM Clarity_Form_Question_Criteria__c WHERE Clarity_Form_Question__c =: parsedQuestion.Id];

        List<Database.DeleteResult> resultCriteriaDelete = Database.delete(currentCriteria, true); 

        for(Database.DeleteResult criteriaDelete : resultCriteriaDelete) {

            if(!criteriaDelete.isSuccess()) {

                System.debug('error: ' + criteriaDelete.getErrors());

            }

        }

        List<Clarity_Form_Question_Criteria__c> parsedCriteria = (List<Clarity_Form_Question_Criteria__c>)JSON.deserialize(sCriteria, List<Clarity_Form_Question_Criteria__c>.class);

        List<Database.SaveResult> resultCriteria = Database.insert(parsedCriteria, true); 

        for(Database.SaveResult newCriteria : resultCriteria) {

            if(!newCriteria.isSuccess()) {

                System.debug('error: ' + newCriteria.getErrors());

            }

        }

        Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 

        results.put('Criteria', parsedCriteria);
        results.put('Question', new List<sObject> { parsedQuestion });

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
    global static Map<String, Map<String, String>> getSObjectFields(String objectType) {

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
    global static Clarity_Form_Assignment__c createAssignment(String name, String formId) {

        Clarity_Form_Assignment__c assignment = new Clarity_Form_Assignment__c(Name = name);

        Database.SaveResult assignmentResult = Database.insert(assignment, true); 

        if(!assignmentResult.isSuccess()) {
            System.debug('error');
        }

        Clarity_Form__c form = [SELECT Id FROM Clarity_Form__c WHERE Id =: formId];
        form.Clarity_Form_Assignment__c = assignment.Id; 
        
        Database.SaveResult formResult = Database.update(form); 

        if(!formResult.isSuccess()) {
            System.debug('error');
        }

        return assignment; 

    }

    @RemoteAction
    global static List<Clarity_Form_Assignment_Rule__c> getAssignmentRules(String formAssignmentId) {

        List<Clarity_Form_Assignment_Rule__c> rules = [SELECT Id FROM Clarity_Form_Assignment_Rule__c WHERE Clarity_Form_Assignment__c = :formAssignmentId];

        return rules; 

    }

    @RemoteAction
    global static List<Clarity_Form_Assignment_Rule__c> saveAssignmentRules(String sFormAssignment, String sFormAssignmentRules) {

        Clarity_Form_Assignment__c assignment = (Clarity_Form_Assignment__c)JSON.deserialize(sFormAssignment, Clarity_Form_Assignment__c.class); 

        Database.SaveResult assignmentResult = Database.update(assignment, true); 

        if(!assignmentResult.isSuccess()) {
            System.debug('error');
        }

        List<Clarity_Form_Assignment_Rule__c> parsedAssignmentRules = (List<Clarity_Form_Assignment_Rule__c>)JSON.deserialize(sFormAssignmentRules, List<Clarity_Form_Assignment_Rule__c>.class);

        for(Clarity_Form_Assignment_Rule__c rule : parsedAssignmentRules) {
            rule.Clarity_Form_Assignment__c = assignment.Id; 
        }

        List<Database.UpsertResult> results = Database.upsert(parsedAssignmentRules, true); 

        for(Database.UpsertResult result : results) {

            if(!result.isSuccess()) {
                System.debug('error');
            }

        }

        return parsedAssignmentRules; 

    }

    @RemoteAction
    global static List<Clarity_Form_Question__c> saveRecordGroupFields(String sRecordGroupFields, String relatedRecordGroupId) {

        List<Clarity_Form_Question__c> recordFieldsToDelete = [SELECT Id FROM Clarity_Form_Question__c WHERE Record_Group__c =: relatedRecordGroupId]; 

        List<Database.DeleteResult> deleteResults = Database.delete(recordFieldsToDelete, true);

        for(Database.DeleteResult deleteResult : deleteResults) {
            
            if(!deleteResult.isSuccess()) {
                System.debug('error: ' + deleteResult.getErrors());
            }

        }

        List<Clarity_Form_Question__c> parsedRecordGroupFields = (List<Clarity_Form_Question__c>)JSON.deserialize(sRecordGroupFields, List<Clarity_Form_Question__c>.class);

        List<Database.UpsertResult> resultRecordFields = Database.upsert(parsedRecordGroupFields, true); 

        for(Database.UpsertResult result : resultRecordFields) {

            if(!result.isSuccess()) {
                System.debug('error: ' + result.getErrors());
            }

        }

        return parsedRecordGroupFields; 

    }

    @RemoteAction
    global static List<Clarity_Form_Connection__c> getConnections(String formId){

        List<Clarity_Form_Connection__c> connections = [SELECT Id, Active__c, Salesforce_Object__c FROM Clarity_Form_Connection__c WHERE Clarity_Form__c =: formId];

        return connections; 
        
    }

    @RemoteAction
    global static Map<String, List<Object>> getConnectionFieldMapping(String connectionId, String objectType) {

        Map<String, List<Object>> fieldMapping = new Map<String, List<Object>>(); 

        List<Clarity_Form_Connection_Field__c> connectionFields = [SELECT Id, Clarity_Form_Connection__c, Custom_Value__c, Salesforce_Field__c, Clarity_Form_Question__c FROM Clarity_Form_Connection_Field__c WHERE Clarity_Form_Connection__c =: connectionId];
        
        SObjectType sObjType = ((SObject)Type.forName(objectType).newInstance()).getSObjectType();

        Schema.DescribeSObjectResult result = sObjType.getDescribe();

        Map<String, Schema.SObjectField> fields = result.fields.getMap();      

        List<String> sObjectFields = new List<String>();   

        for(String fieldName : fields.keySet()) { 

            Schema.SObjectField field = fields.get(fieldName);

            Schema.DescribeFieldResult fieldResult = field.getDescribe();

            Schema.DisplayType type = fieldResult.getType();

            List <Schema.sObjectType> reference = fieldResult.getReferenceTo();

            Boolean isFieldReq  = fieldResult.isNillable();
            Boolean isFieldCreateable = fieldResult.isCreateable(); 

            if(!isFieldReq && isFieldCreateable) {

                sObjectFields.add('' + field);

            } 

        }

        fieldMapping.put('Mapping', connectionFields);
        fieldMapping.put('Fields', sObjectFields);

        return fieldMapping;

    }

    @RemoteAction
    global static List<Clarity_Form_Connection__c> saveConnections(String sConnections, String formId) {

        List<Clarity_Form_Connection__c> parsedConnections = (List<Clarity_Form_Connection__c>)JSON.deserialize(sConnections, List<Clarity_Form_Connection__c>.class);

        List<Database.UpsertResult> results = Database.upsert(parsedConnections, true); 

        for(Database.UpsertResult result : results) {

            if(!result.isSuccess()) {

                System.debug('error: ' + result.getErrors());

            }

        }

        return parsedConnections; 

    }

    @RemoteAction
    global static List<Clarity_Form_Connection_Field__c> saveActiveFieldConnections(String sActiveConnectionFields, String connectionId) {

        List<Clarity_Form_Connection_Field__c> connection = [SELECT Id FROM Clarity_Form_Connection_Field__c WHERE Clarity_Form_Connection__c =: connectionId];

        List<Database.DeleteResult> resultConnectionDelete = Database.delete(connection, true); 

        for(Database.DeleteResult connectionDelete : resultConnectionDelete) {

            if(!connectionDelete.isSuccess()) {

                System.debug('error: ' + connectionDelete.getErrors());

            }

        }

        List<Clarity_Form_Connection_Field__c> parsedConnectionFields = (List<Clarity_Form_Connection_Field__c>)JSON.deserialize(sActiveConnectionFields, List<Clarity_Form_Connection_Field__c>.class);

        if(parsedConnectionFields.size() > 0) {

            List<Database.UpsertResult> results = Database.upsert(parsedConnectionFields, true); 

            for(Database.UpsertResult result : results) {

                if(!result.isSuccess()) {

                    System.debug('error: ' + result.getErrors());

                }
            }

        }

        return parsedConnectionFields; 
    }

    @RemoteAction
    global static List<sObject> getUsers(String searchTerm){

        List<sObject> results = new List<sObject>(); 

        String searchKey = '%' + searchTerm + '%';

        List<sObject> users = (List<sObject>)[SELECT Id, Name, UserName FROM User WHERE Name LIKE :searchKey OR UserName LIKE :searchKey LIMIT 20];

        List<sObject> queue = (List<sObject>)[SELECT Id, Name FROM Group WHERE Name LIKE :searchKey AND Type = 'Queue' LIMIT 20];

        results.addAll(users);
        results.addAll(queue);

        return results;

    }

}