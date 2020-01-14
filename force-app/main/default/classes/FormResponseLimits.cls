/**
* @author ben@clarityforms.io
* @company Clarity Forms
* @date 11/27/2019
*
* @group forms__Form_Response__c
*
* @description On insert of forms__Form_Response__c check submission limits
*/
public class FormResponseLimits {

    private static Map<Id, forms__Form__c> Forms {
        get {
            if(Forms == null) {

                Forms = new Map<Id, forms__Form__c>();

                List<Id> formIds = new List<Id>();

                for(forms__Form_Response__c response : (List<forms__Form_Response__c>)Trigger.new) {
                    formIds.add(response.forms__Form__c);
                }

                Forms = new Map<Id, forms__Form__c>([SELECT Id, Limit__c, End_Date__c FROM forms__Form__c WHERE Id IN :formIds]);

            }
            return Forms;
        }
        set;
    }

    private static Map<Id, Integer> ResponsesSubmitted {
        get {
            if(ResponsesSubmitted == null) {

                ResponsesSubmitted = new Map<Id, Integer>();

                List<Id> formIds = new List<Id>();

                for(forms__Form_Response__c response : (List<forms__Form_Response__c>)Trigger.new) {
                    formIds.add(response.forms__Form__c);
                }

                List<forms__Form__c> forms = [SELECT Id, 
                    (SELECT Id FROM forms__Form_Responses__r WHERE Status__c = 'Submitted') FROM forms__Form__c WHERE Id IN :formIds];

                for(forms__Form__c form : forms) {
                    ResponsesSubmitted.put(form.Id, form.forms__Form_Responses__r.size());
                }

            }
            return ResponsesSubmitted;
        }
        set;
    }

    public static void execute(forms__Form_Response__c response) {

        if(ResponsesSubmitted.get(response.forms__Form__c) == null) return;

        if(Forms.get(response.forms__Form__c) == null) return; 

        forms__Form__c form = Forms.get(response.forms__Form__c);

        if(ResponsesSubmitted.get(response.forms__Form__c) >= form.Limit__c) {
            response.addError('Form has reached it\'s limit in responses allowed.');
        }
    }

}
