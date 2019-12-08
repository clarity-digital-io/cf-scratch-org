public with sharing class ClarityFormsService {

    public static Map<String, Map<String, List<sObject>>> getForms() {

        Map<String, Map<String, List<sObject>>> formDetails = new Map<String, Map<String, List<sObject>>>(); 

        List<Clarity_Form__c> forms = [SELECT Id, Name, Limit__c, End_Date__c, Clarity_Form_Style__r.Multi_Page__c, 
            Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Color__c FROM Clarity_Form__c];

        List<Id> formIds = new List<Id>(); 

        for(Clarity_Form__c form : forms) {
            formIds.add(form.Id); 
        }

        Map<Id, List<Clarity_Form_Question__c>> questionsByForms = new Map<Id, List<Clarity_Form_Question__c>>();

        List<Clarity_Form_Question__c> questions = [SELECT Id, Clarity_Form__c, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c IN :formIds];

        for(Clarity_Form_Question__c question : questions) {
            
            if(questionsByForms.get(question.Clarity_Form__c) != null) {

                questionsByForms.get(question.Clarity_Form__c).add(question); 

            } else {

                questionsByForms.put(question.Clarity_Form__c, new List<Clarity_Form_Question__c>{ question }); 

            }

        }

        for(Clarity_Form__c form : forms) {

            Map<String, List<sObject>> formDetail = new Map<String, List<sObject>>();
        
            formDetail.put('Form', new List<sObject>{ form });
            formDetail.put('Questions', questionsByForms.get(form.Id));

            formDetails.put(form.Id, formDetail); 

        }

        return formDetails; 
        
    }

    // public static Id clone(Id recordId) {

    //     Clarity_Form__c form = [SELECT Id, Name, Limit__c, Status__c, End_Date__c, Clarity_Form_Style__c, Clarity_Form_Assignment__c     
    //         FROM Clarity_Form__c WHERE Id =: recordId Limit 1]; 

    //     List<Clarity_Form_Connection__c> connections = [SELECT Id, Salesforce_Object__c, New__c, 
    //         (SELECT Id, Salesforce_Field__c, PreFill__c, Custom_Value__c, Clarity_Form_Question__c FROM Clarity_Form_Connection_Fields__r) 
    //         FROM Clarity_Form_Connection__c WHERE Clarity_Form__c =: form.Id];

    //     List<Clarity_Form_Question__c> questions = [SELECT Id, 
    //         (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
    //         (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
    //         (SELECT Id, Field_Type__c, Field__c, Operator__c, Type__c, Value__c, Clarity_Form_Question__c FROM Clarity_Form_Question_Criteria__r),
    //         Salesforce_Object__c, Title__c, Order__c, Required__c, Lookup__c, Salesforce_Field__c, Record_Group__c, Record_Group__r.Salesforce_Object__c, 
    //         Page__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

    //     Clarity_Form__c newForm = form.clone(false); 

    //     Database.SaveResult result = Database.insert(newForm, true); 

    //     if(!result.isSuccess()) {
    //         throw new AuraHandledException('Unable to clone form: ' + form.Name);
    //     }

    //     List<Clarity_Form_Connection__c> newConnections = new List<Clarity_Form_Connection__c>(); 

    //     List<Clarity_Form_Connection_Field__c> newConnectionFields = new List<Clarity_Form_Connection_Field__c>(); 

    //     for(Clarity_Form_Connection__c connection : connections) {

    //         Clarity_Form_Connection__c newConnection = connection.clone(false); 
    //         newConnection.Clarity_Form__c = newForm.Id;

    //         newConnections.add(newConnection); 

    //         for(Clarity_Form_Connection_Field__c field : connection.Clarity_Form_Connection_Fields__r) {

    //             Clarity_Form_Connection_Field__c newField = field.clone(false); 
    //             newField.Clarity_Form_Connection__c = newConnection;
    //             newConnectionFields.add(newField); 

    //         }

    //     }

    //     List<Clarity_Form_Question__c> newQuestions = new List<Clarity_Form_Question__c>(); 

    //     List<Clarity_Form_Question_Option__c> newOptions = new List<Clarity_Form_Question_Option__c>(); 

    //     List<Clarity_Form_Question_Flow_Design__c> newDesigns = new List<Clarity_Form_Question_Flow_Design__c>(); 

    //     List<Clarity_Form_Question_Criteria__c> newCriterias = new List<Clarity_Form_Question_Criteria__c>(); 

    //     for(Clarity_Form_Question__c question : questions) {

    //         Clarity_Form_Question__c newQuestion = question.clone(false); 
    //         newQuestion.Clarity_Form__c = newForm.Id; 

    //         newQuestions.add(newQuestion); 

    //         for(Clarity_Form_Question_Option__c option : question.Clarity_Form_Question_Options__r) {

    //             Clarity_Form_Question_Option__c newOption = option.clone(false);
    //             newOption.Clarity_Form_Question__c = newQuestion;
    //             newOptions.add(newOption);

    //         }

    //         for(Clarity_Form_Question_Flow_Design__c design : question.Clarity_Form_Question_Flow_Designs__r) {

    //             Clarity_Form_Question_Flow_Design__c newDesign = design.clone(false); 
    //             newDesign.Clarity_Form_Question__c = newQuestion;
    //             newDesigns.add(newOption);

    //         }

    //         for(Clarity_Form_Question_Criteria__c criteria : question.Clarity_Form_Question_Criteria__r) {

    //             Clarity_Form_Question_Criteria__c newCriteria = criteria.clone(false); 
    //             newCriteria.Clarity_Form_Question__c = newQuestion;
    //             newCriteria.add(newOption);

    //         }

    //     }

    //     Database.SaveResult resultConnections = Database.insert(newConnections, true);

    //     if(!resultConnections.isSuccess()) {
    //         throw new AuraHandledException('Unable to clone form: ' + form.Name);
    //     }

    //     Database.SaveResult resultConnectionFields = Database.insert(newConnectionFields, true); 

    //     if(!resultConnectionFields.isSuccess()) {
    //         throw new AuraHandledException('Unable to clone form: ' + form.Name);
    //     }

    //     Database.SaveResult resultQuestions = Database.insert(newQuestions, true); 

    //     if(!resultQuestions.isSuccess()) {
    //         throw new AuraHandledException('Unable to clone form: ' + form.Name);
    //     }

    //     Database.SaveResult resultOptions = Database.insert(newOptions, true); 

    //     if(!resultOptions.isSuccess()) {
    //         throw new AuraHandledException('Unable to clone form: ' + form.Name);
    //     }

    //     Database.SaveResult resultDesigns = Database.insert(newDesigns, true); 

    //     if(!resultDesigns.isSuccess()) {
    //         throw new AuraHandledException('Unable to clone form: ' + form.Name);
    //     }

    //     Database.SaveResult resultCriterias = Database.insert(newCriterias, true); 

    //     if(!resultCriterias.isSuccess()) {
    //         throw new AuraHandledException('Unable to clone form: ' + form.Name);
    //     }

    // }


    public static List<sObject> connectionRecords(List<Clarity_Form_Response_Connection__c> responseConnections, List<Clarity_Form_Connection__c> formConnections) {

        List<sObject> records = new List<sObject>(); 

        Map<Id, Clarity_Form_Response_Connection__c> responseConnectionById = new Map<Id, Clarity_Form_Response_Connection__c>(); 

        for(Clarity_Form_Response_Connection__c responseConnection : responseConnections) {
            responseConnectionById.put(responseConnection.Clarity_Form_Connection__c, responseConnection);
        }

        for(Clarity_Form_Connection__c formConnection : formConnections) {

            List<String> sFields = new List<String>(); 

            Clarity_Form_Response_Connection__c responseConnection = responseConnectionById.get(formConnection.Id); 

            for(Clarity_Form_Connection_Field__c field : formConnection.Clarity_Form_Connection_Fields__r) {
                sFields.add(field.Salesforce_Field__c); 
            }

            String joinedFields = '';

            if(sFields.size() > 0) {
                joinedFields = String.join(sFields, ', ');
                joinedFields = joinedFields.removeEnd(',');
                joinedFields = ', ' + joinedFields;
            } 

            String record = responseConnection.Record__c;

            sObject result = Database.query('SELECT Id' + joinedFields + ' FROM ' + formConnection.Salesforce_Object__c + ' WHERE Id = :record LIMIT 1');

            records.add(result);
        }

        return records; 

    }


    public static List<Clarity_Form_Response_Connection__c> submitConnections(String responseId, String sConnections) {

        List<Clarity_Form_Response_Connection__c> connections = new List<Clarity_Form_Response_Connection__c>(); 

        List<Map<String, String>> parsedConnections = (List<Map<String, String>>)JSON.deserialize(sConnections, List<Map<String, String>>.class);

        if(parsedConnections.size() == 0) {
            return connections;
        }

        for(Map<String, String> parsedConnection : parsedConnections) {

            Clarity_Form_Response_Connection__c connection = new Clarity_Form_Response_Connection__c(
                Record__c = parsedConnection.get('key'),
                Clarity_Form_Connection__c = parsedConnection.get('connectionId'),
                Clarity_Form_Response__c = responseId
            );

            connections.add(connection); 

        }

        List<Database.SaveResult> connectionResults = Database.insert(connections, true); 

        for(Database.SaveResult connectionResult : connectionResults) {

            if(!connectionResult.isSuccess()) {
                System.debug('error');
            }

        }
        
        return connections;   
    }
 
    public static Map<String, List<sObject>> edit(Id responseId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form_Response__c response = [SELECT Id, Clarity_Form__c, Status__c, OwnerId__c 
            FROM Clarity_Form_Response__c WHERE Id =: responseId Limit 1];

        Clarity_Form__c form = [SELECT Id, Name, Clarity_Form_Style__r.Button_Color__c, 
            Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Multi_Page__c, Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Color__c 
            FROM Clarity_Form__c WHERE Id =: response.Clarity_Form__c LIMIT 1];

        List<Clarity_Form_Connection__c> connections = [SELECT Id, Salesforce_Object__c, New__c, 
            (SELECT Id, Salesforce_Field__c, PreFill__c, Custom_Value__c, Clarity_Form_Question__c FROM Clarity_Form_Connection_Fields__r) 
            FROM Clarity_Form_Connection__c WHERE Clarity_Form__c =: form.Id];

        List<Clarity_Form_Connection_Field__c> mappingFields = new List<Clarity_Form_Connection_Field__c>(); 
        List<Clarity_Form_Connection_Field__c> prefillFields = new List<Clarity_Form_Connection_Field__c>(); 

        for(Clarity_Form_Connection__c connection : connections) {
            for(Clarity_Form_Connection_Field__c connectionField : connection.Clarity_Form_Connection_Fields__r) {
                if(connectionField.PreFill__c) {
                    prefillFields.add(connectionField);
                } else {
                    mappingFields.add(connectionField);
                }
            }
        }

        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            (SELECT Id, Field_Type__c, Field__c, Operator__c, Type__c, Value__c, Clarity_Form_Question__c FROM Clarity_Form_Question_Criteria__r),
            Salesforce_Object__c, Title__c, Order__c, Required__c, Lookup__c, Salesforce_Field__c, Record_Group__c, Record_Group__r.Salesforce_Object__c, 
            Page__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        List<Clarity_Form_Answer__c> answers = [SELECT Id, Answer__c, Date_Answer__c, ContentDocument__c, Clarity_Form_Response__c, Clarity_Form_Question__c, Clarity_Form_Question__r.Type__c  
            FROM Clarity_Form_Answer__c WHERE Clarity_Form_Response__c =: response.Id];

        formDetails.put('Form', new List<sObject>{ form });
        formDetails.put('FormResponse', new List<sObject>{ response });
        formDetails.put('Connections', connections);
        formDetails.put('ResponseConnections', new List<sObject>());
        formDetails.put('Mapping', mappingFields);
        formDetails.put('Prefills', prefillFields);
        formDetails.put('Questions', questions);
        formDetails.put('Answers', answers);

        return formDetails; 
    }

    public static  Map<String, List<sObject>> create(Id formId) {

        Clarity_Form__c form = [SELECT Id, Name, Clarity_Form_Style__r.Button_Color__c, 
            Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Multi_Page__c, Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Color__c 
            FROM Clarity_Form__c WHERE Id =: formId LIMIT 1];

        List<Clarity_Form_Response__c> oldResponses = [SELECT Id, Clarity_Form__c, Status__c, OwnerId__c 
            FROM Clarity_Form_Response__c WHERE Clarity_Form__c =: formId];

        if(oldResponses.size() > 0) {

            List<Database.DeleteResult> deleteOldResponses = Database.delete(oldResponses, true);

        }

        Clarity_Form_Response__c response = new Clarity_Form_Response__c(
            Status__c       = 'Preview', 
            Clarity_Form__c = form.Id,
            OwnerId__c      = UserInfo.getUserId()
        );

        Database.SaveResult result = Database.insert(response);

        if(!result.isSuccess()) {
            System.debug('error creating new repsonse');
        }

        return create(form, response, null); 

    } 

    public static  Map<String, List<sObject>> create(String formName, String sConnections) {

        Clarity_Form__c form = [SELECT Id, Name, Clarity_Form_Style__r.Button_Color__c, 
            Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Multi_Page__c, Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Color__c 
            FROM Clarity_Form__c WHERE Name =: formName LIMIT 1];

        Clarity_Form_Response__c response = new Clarity_Form_Response__c(
            Status__c       = 'New', 
            Clarity_Form__c = form.Id,
            OwnerId__c      = UserInfo.getUserId()
        );

        Database.SaveResult result = Database.insert(response);

        if(!result.isSuccess()) {
            System.debug('error creating new repsonse');
        }

        return create(form, response, sConnections); 

    }  

    public static Map<String, List<sObject>> create(Clarity_Form__c form, Clarity_Form_Response__c response, String sConnections) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        List<Clarity_Form_Connection__c> formConnections = [SELECT Id, Salesforce_Object__c, New__c, 
            (SELECT Id, Salesforce_Field__c, PreFill__c, Custom_Value__c, Clarity_Form_Question__c FROM Clarity_Form_Connection_Fields__r) 
            FROM Clarity_Form_Connection__c WHERE Clarity_Form__c =: form.Id];

        List<Clarity_Form_Connection_Field__c> mappingFields = new List<Clarity_Form_Connection_Field__c>(); 
        List<Clarity_Form_Connection_Field__c> prefillFields = new List<Clarity_Form_Connection_Field__c>(); 

        for(Clarity_Form_Connection__c formConnection : formConnections) {
            for(Clarity_Form_Connection_Field__c connectionField : formConnection.Clarity_Form_Connection_Fields__r) {
                if(connectionField.PreFill__c) {
                    prefillFields.add(connectionField);
                } else {
                    mappingFields.add(connectionField);
                }
            }
        }
        
        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            Salesforce_Object__c, Title__c, Order__c, Required__c, Lookup__c, Salesforce_Field__c, Record_Group__c, Record_Group__r.Salesforce_Object__c, 
            Page__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        List<Clarity_Form_Answer__c> answers = [SELECT Id, Answer__c, Date_Answer__c, ContentDocument__c, Clarity_Form_Response__c, Clarity_Form_Question__c, Clarity_Form_Question__r.Type__c  
            FROM Clarity_Form_Answer__c WHERE Clarity_Form_Response__c =: response.Id];

        formDetails.put('Form', new List<sObject>{ form });
        formDetails.put('FormResponse', new List<sObject>{ response });

        formDetails.put('Mapping', mappingFields);
        formDetails.put('Prefills', prefillFields);
        formDetails.put('Questions', questions);
        formDetails.put('Answers', answers);

        if(sConnections != null) {

            List<Clarity_Form_Response_Connection__c> responseConnections = submitConnections(response.Id, sConnections);
            List<sObject> records = new  List<sObject>(); 

            if(responseConnections.size() > 0) {
                records = connectionRecords(responseConnections, formConnections);            
            }

            formDetails.put('Connections', responseConnections);
            formDetails.put('ConnectedRecords', records);

        }

        return formDetails; 
        
    }

    public static List<String> updateStatus(List<String> responseIds, String status) {

        List<String> success = new List<String>(); 

        List<Clarity_Form_Response__c> responsesUpdated = new List<Clarity_Form_Response__c>(); 
        
        Map<Id, Clarity_Form_Response__c> responses = new Map<Id, Clarity_Form_Response__c>([SELECT Id, Name, Status__c FROM Clarity_Form_Response__c WHERE Id IN :responseIds AND Status__c != 'Submitted']);

        for(Clarity_Form_Response__c response : responses.values()) {
        
            response.Status__c = status; 
            responsesUpdated.add(response); 

        }

        List<Database.SaveResult> results = Database.update(responsesUpdated, false);

        for(Database.SaveResult result : results) {

            if(result.isSuccess()) {
                Clarity_Form_Response__c response = responses.get(result.getId());
                success.add(response.Name);
            }

        }

        return success; 

    }

    public static List<Clarity_Form_Answer__c> save(String answers) {

        List<Clarity_Form_Answer__c> parsedAnswers = (List<Clarity_Form_Answer__c>)JSON.deserialize(answers, List<Clarity_Form_Answer__c>.class);

        List<Database.UpsertResult> results = Database.upsert(parsedAnswers, true); 

        for(Database.UpsertResult result : results) {
            
            if(!result.isSuccess()) {

                System.debug('error: ' + result.getErrors());

            }

        }

        return parsedAnswers;

    }

    public static String prepareAnswers(Map<String, List<String>> sAnswers) {

        List<String> allAnswers = new List<String>(); 

        for(String responseId : sAnswers.keySet()) {

            List<String> answers = sAnswers.get(responseId); 

            allAnswers.addAll(answers);

        }

        return JSON.serialize(allAnswers);

    }

    public static List<Clarity_Form_Answer__c> upload(String sFileAnswers) {

        Map<String, Map<String, List<String>>> parsedFileAnswers = (Map<String, Map<String, List<String>>>)JSON.deserialize(sFileAnswers, Map<String, Map<String, List<String>>>.class);

        Map<String, String> questionResponseIds = new Map<String, String>();

        for(Id responseId : parsedFileAnswers.keySet()) {

            Map<String, List<String>> questionImages = parsedFileAnswers.get(responseId); 

            for(String questionId : questionImages.keySet()) {
                questionResponseIds.put(questionId, responseId);
            }
            
        }

        Map<Id, Clarity_Form_Response__c> responses = new Map<Id, Clarity_Form_Response__c>([SELECT Id, OwnerId__c FROM Clarity_Form_Response__c WHERE Id IN :parsedFileAnswers.keySet()]); 

        Map<String, List<ContentVersion>> contentsByQuestion = new Map<String, List<ContentVersion>>();

        for(String responseId : parsedFileAnswers.keySet()) {

            Map<String, List<String>> imagesByQuestions = parsedFileAnswers.get(responseId); 

            for(String questionId : imagesByQuestions.keySet()) {

                List<String> files = imagesByQuestions.get(questionId); 

                for(String file : files) {

                    ContentVersion content = new ContentVersion(
                        ContentLocation = 'S', 
                        PathOnClient    = 'Image.jpeg',
                        Origin          = 'H', 
                        Title           = 'Image',
                        Clarity_Form_Response__c = responseId,
                        VersionData     = EncodingUtil.base64Decode(file) // converting your binary string to Blob
                    );

                    if(contentsByQuestion.get(questionId) != null) {

                        contentsByQuestion.get(questionId).add(content);

                    } else {
                    
                        contentsByQuestion.put(questionId, new List<ContentVersion> { content });

                    }

                }

            }

        }

        List<ContentVersion> cvSaves = new List<ContentVersion>();

        for(List<ContentVersion> cvs : contentsByQuestion.values()) {
            cvSaves.addAll(cvs);
        }

        List<Database.SaveResult> contentResults = Database.insert(cvSaves, true); 

        for(Database.SaveResult contentResult : contentResults) {

            if(!contentResult.isSuccess()) {
                System.debug('error');
            }

        }

        List<ContentVersion> cvUpdates = new List<ContentVersion>();

        for(String questionId : contentsByQuestion.keySet()) {

            List<ContentVersion> cvs = contentsByQuestion.get(questionId); 

            String responseId = questionResponseIds.get(questionId);

            Clarity_Form_Response__c response = responses.get(responseId); 

            for(ContentVersion cv : cvs) {
                cv.OwnerId = response.OwnerId__c; 
                cvUpdates.add(cv); 
            }

            contentsByQuestion.put(questionId, cvs); 

        }

        List<Database.SaveResult> updateContentResults = Database.update(cvUpdates, true); 

        for(Database.SaveResult updateContentResult : updateContentResults) {

            if(!updateContentResult.isSuccess()) {
                System.debug('error');
            }

        }

        Map<Id, String> questionIdByContentVersionId = new Map<Id, String>(); 

        for(String questionId : contentsByQuestion.keySet()) {

            List<ContentVersion> cvs = contentsByQuestion.get(questionId); 

            for(ContentVersion cv : cvs) {
                questionIdByContentVersionId.put(cv.Id, questionId); 
            }

        }

        Map<Id, ContentVersion> createdContentVersions = new Map<Id, ContentVersion>([SELECT Id, Title, ContentSize, ContentDocumentId FROM ContentVersion WHERE Id IN :questionIdByContentVersionId.keySet()]);

        List<ContentDocumentLink> links = new List<ContentDocumentLink>(); 

        Map<Id, Clarity_Form_Answer__c> answersByContentVersion = new Map<Id, Clarity_Form_Answer__c>(); 

        for(Id cvId : createdContentVersions.keySet()) {

            ContentVersion cv = createdContentVersions.get(cvId); 

            String questionId = questionIdByContentVersionId.get(cvId); 

            String responseId = questionResponseIds.get(questionId); 

            Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
                ContentDocument__c = cv.ContentDocumentId,
                Clarity_Form_Question__c = questionId,
                Clarity_Form_Response__c = responseId
            );

            answersByContentVersion.put(cvId, answer);

            ContentDocumentLink formLink = new ContentDocumentLink(
                ContentDocumentId   = cv.ContentDocumentId, //Add ContentDocumentId
                LinkedEntityId      = responseId, //Add attachment parentId
                ShareType           = 'V', //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                Visibility          = 'AllUsers' //AllUsers, InternalUsers, SharedUsers
            );

            links.add(formLink); 

        }

        List<Database.SaveResult> answerResults = Database.insert(answersByContentVersion.values(), true); 

        for(Database.SaveResult answerResult : answerResults) {
            if(!answerResult.isSuccess()) {
                System.debug('error');
            }
        }

        for(Id cvId : answersByContentVersion.keySet()) {

            ContentVersion cv = createdContentVersions.get(cvId); 
            
            Clarity_Form_Answer__c answer = answersByContentVersion.get(cvId); 
            
            ContentDocumentLink answerLink = new ContentDocumentLink(
                ContentDocumentId   = cv.ContentDocumentId, //Add ContentDocumentId
                LinkedEntityId      = answer.Id, //Add attachment parentId
                ShareType           = 'V', //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                Visibility          = 'AllUsers' //AllUsers, InternalUsers, SharedUsers
            );
        
            links.add(answerLink); 

        }

        List<Database.SaveResult> formLinkResults = Database.insert(links, true); 

        for(Database.SaveResult formLinkResult : formLinkResults) {
            if(!formLinkResult.isSuccess()) {
                System.debug('error');
            }
        }

        return answersByContentVersion.values(); 

    }

    public static List<sObject> getSObjectConnections(List<Clarity_Form_Connection__c> connections) {

        return new List<sObject>(); 

    }

    public static Map<String, sObject> applyExistingConnections(String records) {

        List<Connection> connectionsRequired = (List<Connection>)JSON.deserialize(records, List<Connection>.class);

        Map<String, sObject> connectionResults = new Map<String, sObject>(); 

        for(Connection c : connectionsRequired) {

            List<String> sFields = new List<String>(); 

            for(Clarity_Form_Connection_Field__c field : c.Fields) {
                sFields.add(field.Salesforce_Field__c); 
            }

            String joinedFields = String.join(sFields, ', ');

            joinedFields = joinedFields.removeEnd(',');

            sObject result = Database.query('SELECT ' + joinedFields + 'FROM ' + c.SalesforceObject + ' WHERE Id =: ' + c.RecordId + ' LIMIT 1');
            //set salesforce as key
            connectionResults.put(c.SalesforceObject, result); 
        }

        return connectionResults; 
    }

    public static Map<String, List<String>> filterRecordGroupPicklist(List<Clarity_Form_Question__c> questions) {

        Map<String, List<String>> salesforceObjectFields = new Map<String, List<String>>(); 

        for(Clarity_Form_Question__c question : questions) {
            if(question.Record_Group__c != null && question.Type__c == 'PICKLIST') {

                if(salesforceObjectFields.get(question.Record_Group__r.Salesforce_Object__c) != null) {
                    salesforceObjectFields.get(question.Record_Group__r.Salesforce_Object__c).add(question.Salesforce_Field__c);
                } else {
                    salesforceObjectFields.put(question.Record_Group__r.Salesforce_Object__c, new List<String>{ question.Salesforce_Field__c });
                }

            }
        }

        return salesforceObjectFields;
    }

    public static Map<String, Map<String, Map<String, String>>> getSalesforcePicklistValues(Map<String, List<String>> salesforceObjectFields) {
        
        Map<String, Map<String, Map<String, String>>> values = new Map<String, Map<String, Map<String, String>>>(); 

        List<String> salesforceObjects = new List<String>(salesforceObjectFields.keySet());

        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(salesforceObjects);

        for(Schema.DescribeSobjectResult res : results) {

            List<String> fields = salesforceObjectFields.get(res.getName()); 

            Map<String, Map<String, String>> fieldPicklistValues = new Map<String, Map<String, String>>(); 

            for(String field : fields) {

                List<Schema.PicklistEntry> entries = res.fields.getMap().get(field).getDescribe().getPicklistValues();
                
                Map<String, String> picklistValues = new Map<String, String>();

                for(Schema.PicklistEntry entry : entries) {
	                if (entry.isActive()) {
                        picklistValues.put(entry.getValue(), entry.getLabel());
                    }
                }

                fieldPicklistValues.put(field, picklistValues);

            }

            values.put(res.getName(), fieldPicklistValues);

        }

        return values;

    }

    public class Connection {
        public String RecordId; 
        public String SalesforceObject;
        public List<Clarity_Form_Connection_Field__c> Fields;
    }

}
