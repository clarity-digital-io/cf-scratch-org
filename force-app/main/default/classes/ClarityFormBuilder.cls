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
    global static String createForm(){

        Clarity_Form__c form = new Clarity_Form__c(
            Name = 'Clarity Form'
        );

        Database.SaveResult result = Database.insert(form); 

        if(!result.isSuccess()) {
            //throw error
        }

        return result.getId(); 

    }

    @RemoteAction
    global static List<Clarity_Form_Question__c> getQuestions(String recordId){

        Clarity_Form__c form = [SELECT Id, Name, Status__c FROM Clarity_Form__c WHERE Id =: recordId LIMIT 1];

        List<Clarity_Form_Question__c> questions = [SELECT Id, Required__c, Title__c, Order__c, Type__c, Clarity_Form__c,
            (SELECT Id, Label__c FROM Clarity_Form_Question_Options__r) FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: form.Id];

        return questions; 

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
    global static String saveQuestionOption(String sQuestionOption) {

        Clarity_Form_Question_Option__c parsedQuestionOption = (Clarity_Form_Question_Option__c)JSON.deserialize(sQuestionOption, Clarity_Form_Question_Option__c.class);

        Database.SaveResult result = Database.update(parsedQuestionOption, true); 

        if(!result.isSuccess()) {
            System.debug('error');
        }
        
        return result.getId();

    }

}