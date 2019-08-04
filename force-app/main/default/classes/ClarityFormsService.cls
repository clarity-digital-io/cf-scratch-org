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

    public static Map<String, List<sObject>> getForm(String formId) {

        Map<String, List<sObject>> formDetails = new Map<String, List<sObject>>();

        Clarity_Form__c form = [SELECT Id, Name, Clarity_Form_Style__r.Button_Color__c, 
            Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Color__c 
            FROM Clarity_Form__c WHERE Id =: formId LIMIT 1];
        
        List<Clarity_Form_Question__c> questions = [SELECT Id, 
            (SELECT Id, Label__c, Active_Flow__c FROM Clarity_Form_Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Clarity_Form_Question_Flow_Designs__r LIMIT 1),
            Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, Type__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        Clarity_Form_Response__c response = new Clarity_Form_Response__c(
            Status__c       = 'New', 
            Clarity_Form__c = form.Id
        );

        Database.SaveResult result = Database.insert(response);

        if(!result.isSuccess())
            System.debug('error creating new repsonse');

        List<Clarity_Form_Answer__c> answers = [SELECT Id, Answer__c, Clarity_Form_Response__c, Clarity_Form_Question__c 
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

}
