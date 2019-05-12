global with sharing class ClarityFormBuilder {
	
    public class Question {
        public String title { get; set; }
        public Integer order  { get; set; }
        public String type  { get; set; }
    }

    @RemoteAction
    global static void save(String sQuestions){

        List<Question> parsedQuestions = (List<Question>)JSON.deserialize(sQuestions, List<Question>.class);

        List<Clarity_Form_Question__c> clarityQuestions = new List<Clarity_Form_Question__c>(); 

        for(Question question : parsedQuestions) {
            System.debug('question: ' + question.title); 
        }

    }
}