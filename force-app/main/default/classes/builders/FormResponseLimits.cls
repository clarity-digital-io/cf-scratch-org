/**
* @author ben@clarityforms.io
* @company Clarity Forms
* @date 11/27/2019
*
* @group Response__c
*
* @description On insert of Response__c check submission limits
*/
public class FormResponseLimits {

    private static Map<Id, Form__c> Forms {
        get {
            if(Forms == null) {

                Forms = new Map<Id, Form__c>();

                List<Id> formIds = new List<Id>();

                for(Response__c response : (List<Response__c>)Trigger.new) {
                    formIds.add(response.Form__c);
                }

                Forms = new Map<Id, Form__c>([SELECT Id, Limit__c, End_Date__c FROM Form__c WHERE Id IN :formIds]);

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

                for(Response__c response : (List<Response__c>)Trigger.new) {
                    formIds.add(response.Form__c);
                }

                List<Form__c> forms = [SELECT Id, 
                    (SELECT Id FROM Responses__r WHERE Status__c = 'Submitted') FROM Form__c WHERE Id IN :formIds];

                for(Form__c form : forms) {
                    ResponsesSubmitted.put(form.Id, form.Responses__r.size());
                }

            }
            return ResponsesSubmitted;
        }
        set;
    }

    public static void execute(Response__c response) {

        if(ResponsesSubmitted.get(response.Form__c) == null) return;

        if(Forms.get(response.Form__c) == null) return; 

        Form__c form = Forms.get(response.Form__c);

        if(ResponsesSubmitted.get(response.Form__c) >= form.Limit__c) {
            response.addError('Form has reached it\'s limit in responses allowed.');
        }
    }

}
