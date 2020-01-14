/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 07/22/2019
*
* @group forms__Form_Response__c
*
* @description On insert of forms__Form_Response__c create an answer for each question.
*/
public class CreateResponseAnswers {

    private static Map<Id, List<forms__Form_Question__c>> FormQuestions {
        get {

            if(FormQuestions == null) {

                FormQuestions = new Map<Id,  List<forms__Form_Question__c>>();

                List<Id> formIds = new List<Id>();

                for(forms__Form_Response__c response : (List<forms__Form_Response__c>)Trigger.new) {
                    formIds.add(response.forms__Form__c);
                }

                List<forms__Form_Question__c> questions = [SELECT Id, Record_Group__c, Type__c, forms__Form__c FROM forms__Form_Question__c WHERE forms__Form__c IN :formIds];

                for(forms__Form_Question__c question : questions) { 

                    if(FormQuestions.get(question.forms__Form__c) != null) {
                        
                        FormQuestions.get(question.forms__Form__c).add(question);

                    } else {

                        FormQuestions.put(question.forms__Form__c, new List<forms__Form_Question__c>{ question });

                    }

                }

            }
            
            return FormQuestions;
        }
        set; 
    }

    public static void execute(List<forms__Form_Answer__c> answersToBeCreated, forms__Form_Response__c response) {
        
        if(response.Status__c != 'New') return; 
                
        if(FormQuestions.get(response.forms__Form__c) == null) return; 

        List<forms__Form_Question__c> questions = FormQuestions.get(response.forms__Form__c); 

        for(forms__Form_Question__c question : questions) {

            if(question.Record_Group__c == null && question.Type__c != 'RecordGroup' && question.Type__c != 'FreeText') {
                forms__Form_Answer__c answer = new forms__Form_Answer__c(
                    forms__Form_Response__c = response.Id, 
                    forms__Form_Question__c = question.Id
                );
                answersToBeCreated.add(answer);
            }
        }

    }

}
