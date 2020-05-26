/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 07/22/2019
*
* @group Response__c
*
* @description On insert of Response__c create an answer for each question.
*/
public class CreateResponseAnswers {

    private static Map<Id, List<Question__c>> FormQuestions {
        get {

            if(FormQuestions == null) {

                FormQuestions = new Map<Id,  List<Question__c>>();

                List<Id> formIds = new List<Id>();

                for(Response__c response : (List<Response__c>)Trigger.new) {
                    formIds.add(response.Form__c);
                }

                List<Question__c> questions = [SELECT Id, Record_Group__c, Type__c, Form__c FROM Question__c WHERE Form__c IN :formIds];

                for(Question__c question : questions) { 

                    if(FormQuestions.get(question.Form__c) != null) {
                        
                        FormQuestions.get(question.Form__c).add(question);

                    } else {

                        FormQuestions.put(question.Form__c, new List<Question__c>{ question });

                    }

                }

            }
            
            return FormQuestions;
        }
        set; 
    }

    public static void execute(List<Answer__c> answersToBeCreated, Response__c response) {
        
        if(response.Status__c != 'New') return; 
                
        if(FormQuestions.get(response.Form__c) == null) return; 

        List<Question__c> questions = FormQuestions.get(response.Form__c); 

        for(Question__c question : questions) {

            if(question.Record_Group__c == null && question.Type__c != 'RecordGroup' && question.Type__c != 'FreeText') {
                Answer__c answer = new Answer__c(
                    Response__c = response.Id, 
                    Question__c = question.Id
                );
                answersToBeCreated.add(answer);
            }
        }

    }

}
