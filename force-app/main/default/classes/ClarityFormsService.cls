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

    public static Map<String, List<sObject>> edit(String responseId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form_Response__c response = [SELECT Id, Clarity_Form__c, Status__c, OwnerId__c 
            FROM Clarity_Form_Response__c WHERE Id =: responseId Limit 1];

        Clarity_Form__c form = [SELECT Id, Name, Clarity_Form_Style__r.Button_Color__c, 
            Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Color__c 
            FROM Clarity_Form__c WHERE Id =: response.Clarity_Form__c LIMIT 1];

        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        List<Clarity_Form_Answer__c> answers = [SELECT Id, Answer__c, ContentDocument__c, Clarity_Form_Response__c, Clarity_Form_Question__c, Clarity_Form_Question__r.Type__c  
            FROM Clarity_Form_Answer__c WHERE Clarity_Form_Response__c =: response.Id];

        formDetails.put('Form', new List<sObject>{ form });
        formDetails.put('FormResponse', new List<sObject>{ response });
        formDetails.put('Questions', questions);
        formDetails.put('Answers', answers);

        return formDetails; 
    }

    public static Map<String, List<sObject>> create(String formName) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name, Clarity_Form_Style__r.Button_Color__c, 
            Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Color__c 
            FROM Clarity_Form__c WHERE Name =: formName LIMIT 1];
        
        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        Clarity_Form_Response__c response = new Clarity_Form_Response__c(
            Status__c       = 'New', 
            Clarity_Form__c = form.Id,
            OwnerId__c      = UserInfo.getUserId()
        );

        Database.SaveResult result = Database.insert(response);

        if(!result.isSuccess()) {
            System.debug('error creating new repsonse');
        }

        List<Clarity_Form_Answer__c> answers = [SELECT Id, Answer__c, ContentDocument__c, Clarity_Form_Response__c, Clarity_Form_Question__c, Clarity_Form_Question__r.Type__c  
            FROM Clarity_Form_Answer__c WHERE Clarity_Form_Response__c =: response.Id];

        formDetails.put('Form', new List<sObject>{ form });
        formDetails.put('FormResponse', new List<sObject>{ response });
        formDetails.put('Questions', questions);
        formDetails.put('Answers', answers);

        return formDetails; 
        
    }

    public static List<String> submit(List<String> responseIds) {

        List<String> success = new List<String>(); 

        List<Clarity_Form_Response__c> responsesUpdated = new List<Clarity_Form_Response__c>(); 
        
        Map<Id, Clarity_Form_Response__c> responses = new Map<Id, Clarity_Form_Response__c>([SELECT Id, Name, Status__c FROM Clarity_Form_Response__c WHERE Id IN :responseIds AND Status__c != 'Submitted']);

        for(Clarity_Form_Response__c response : responses.values()) {
        
            response.Status__c = 'Submitted'; 
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

    public static List<Clarity_Form_Answer__c> save(List<String> answers) {

        List<Clarity_Form_Answer__c> parsedAnswers = new List<Clarity_Form_Answer__c>();

        for(String answer : answers) {
            
            Clarity_Form_Answer__c parsedAnswer = (Clarity_Form_Answer__c)JSON.deserialize(answer, Clarity_Form_Answer__c.class);
            parsedAnswers.add(parsedAnswer); 

        }

        List<Database.SaveResult> results = Database.update(parsedAnswers, true); 

        for(Database.SaveResult result : results) {
            
            if(!result.isSuccess()) {

                System.debug('error: ' + result.getErrors());

            }

        }

        return parsedAnswers;

    }

    public static List<String> prepareAnswers(Map<String, List<String>> sAnswers) {

        List<String> allAnswers = new List<String>(); 

        for(String responseId : sAnswers.keySet()) {

            List<String> answers = sAnswers.get(responseId); 

            allAnswers.addAll(answers);

        }

        return allAnswers;

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

        Map<String, ContentVersion> contentsByQuestion = new Map<String, ContentVersion>();

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
                        VersionData     = EncodingUtil.base64Decode(file) // converting your binary string to Blob
                    );

                    contentsByQuestion.put(questionId, content);

                }

            }

        }

        List<Database.SaveResult> contentResults = Database.insert(contentsByQuestion.values(), true); 

        for(Database.SaveResult contentResult : contentResults) {

            if(!contentResult.isSuccess()) {
                System.debug('error');
            }

        }

        for(String questionId : contentsByQuestion.keySet()) {

            ContentVersion cv = contentsByQuestion.get(questionId); 

            String responseId = questionResponseIds.get(questionId);

            Clarity_Form_Response__c response = responses.get(responseId); 

            cv.OwnerId = response.OwnerId__c; 

            contentsByQuestion.put(questionId, cv); 

        }

        List<Database.SaveResult> updateContentResults = Database.update(contentsByQuestion.values(), true); 

        for(Database.SaveResult updateContentResult : updateContentResults) {

            if(!updateContentResult.isSuccess()) {
                System.debug('error');
            }

        }

        Map<Id, String> questionIdByContentVersionId = new Map<Id, String>(); 

        for(String questionId : contentsByQuestion.keySet()) {

            ContentVersion cv = contentsByQuestion.get(questionId); 

            questionIdByContentVersionId.put(cv.Id, questionId); 

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

}
