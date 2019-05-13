global with sharing class ClarityFormBuilder {
	
    public class Question {
        public String title { get; set; }
        public Integer order  { get; set; }
        public String type  { get; set; }
        public String formId  { get; set; }
    }

    @RemoteAction
    global static List<String> save(String sQuestions){

        List<String> saved = new List<String>(); 

        List<Question> parsedQuestions = (List<Question>)JSON.deserialize(sQuestions, List<Question>.class);

        List<Clarity_Form_Question__c> clarityQuestions = new List<Clarity_Form_Question__c>(); 

        for(Question question : parsedQuestions) {

            Clarity_Form_Question__c newQuestion = new Clarity_Form_Question__c(
                Clarity_Form__c = question.formId,
                Title__c        = question.title, 
                Type__c         = question.type, 
                Order__c        = question.order
            );
            
            clarityQuestions.add(newQuestion); 

        }

        List<Database.SaveResult> results = Database.insert(clarityQuestions, true); 

        for(Database.SaveResult result : results) {

            if(result.isSuccess()) {
                saved.add(result.getId());
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
}