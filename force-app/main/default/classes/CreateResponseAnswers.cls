/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 07/22/2019
*
* @group Clarity_Form_Response__c
*
* @description On insert of Clarity_Form_Response__c create an answer for each question.
*/
public class CreateResponseAnswers {

    private static Map<Id, List<Clarity_Form_Question__c>> FormQuestions {
        get {

            if(FormQuestions == null) {

                FormQuestions = new Map<Id,  List<Clarity_Form_Question__c>>();

                List<Id> formIds = new List<Id>();

                for(Clarity_Form_Response__c response : (List<Clarity_Form_Response__c>)Trigger.new) {
                    formIds.add(response.Clarity_Form__c);
                }

                List<Clarity_Form_Question__c> questions = [SELECT Id, Clarity_Form__c FROM Clarity_Form_Question__c WHERE Clarity_Form__c IN :formIds];

                for(Clarity_Form_Question__c question : questions) { 

                    if(FormQuestions.get(question.Clarity_Form__c) != null) {
                        
                        FormQuestions.get(question.Clarity_Form__c).add(question);

                    } else {

                        FormQuestions.put(question.Clarity_Form__c, new List<Clarity_Form_Question__c>{ question });

                    }

                }

            }
            
            return FormQuestions;
        }
        set; 
    }

    public static void execute(List<Clarity_Form_Answer__c> answersToBeCreated, Clarity_Form_Response__c response) {
        
        if(response.Status__c != 'New') return; 
                
        if(FormQuestions.get(response.Clarity_Form__c) == null) return; 

        List<Clarity_Form_Question__c> questions = FormQuestions.get(response.Clarity_Form__c); 

        for(Clarity_Form_Question__c question : questions) {
            Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
                Clarity_Form_Response__c = response.Id, 
                Clarity_Form_Question__c = question.Id
            );

            answersToBeCreated.add(answer);
        }

    }

}
