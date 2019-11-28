/**
* @author ben@clarityforms.io
* @company Clarity Forms
* @date 11/27/2019
*
* @group Clarity_Form_Response__c
*
* @description On insert of Clarity_Form_Response__c check submission limits
*/
public class FormResponseLimits {

    private static Map<Id, Clarity_Form__c> Forms {
        get {
            if(Forms == null) {

                Forms = new Map<Id, Clarity_Form__c>();

                List<Id> formIds = new List<Id>();

                for(Clarity_Form_Response__c response : (List<Clarity_Form_Response__c>)Trigger.new) {
                    formIds.add(response.Clarity_Form__c);
                }

                Forms = new Map<Id, Clarity_Form__c>([SELECT Id, Limit__c, End_Date__c FROM Clarity_Form__c WHERE Id IN :formIds]);

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

                for(Clarity_Form_Response__c response : (List<Clarity_Form_Response__c>)Trigger.new) {
                    formIds.add(response.Clarity_Form__c);
                }

                List<Clarity_Form__c> forms = [SELECT Id, 
                    (SELECT Id FROM Clarity_Form_Responses__r WHERE Status__c = 'Submitted') FROM Clarity_Form__c WHERE Id IN :formIds];

                for(Clarity_Form__c form : forms) {
                    ResponsesSubmitted.put(form.Id, form.Clarity_Form_Responses__r.size());
                }

            }
            return ResponsesSubmitted;
        }
        set;
    }

    public static void execute(Clarity_Form_Response__c response) {

        if(ResponsesSubmitted.get(response.Clarity_Form__c) == null) return;

        if(Forms.get(response.Clarity_Form__c) == null) return; 

        Clarity_Form__c form = Forms.get(response.Clarity_Form__c);

        if(ResponsesSubmitted.get(response.Clarity_Form__c) >= form.Limit__c) {
            response.addError('Form has reached it\'s limit in responses allowed.');
        }

        if(form.End_Date__c == null) return;

        if(System.today() >= form.End_Date__c) {
            response.addError('Response allowed submit date has ended.');
        }
    }

}
