/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 07/19/2019
*
* @group Clarity_Form_Response__c
*
* @description On update or insert of Clarity_Form_Response__c, assign to Assigned user
*/
public class FormResponseAssignment {

    private static Map<Id, Clarity_Form_Assignment__c> Assignment {
        get {

            if(Assignment == null) {

                Assignment = new Map<Id, Clarity_Form_Assignment__c>();

                Map<Id, Id> formIdByAssignmentIds = new Map<Id, Id>(); 

                List<Id> formIds = new List<Id>();

                for(Clarity_Form_Response__c response : (List<Clarity_Form_Response__c>)Trigger.new) {
                    formIds.add(response.Clarity_Form__c);
                }

                List<Clarity_Form__c> forms = [SELECT Id, Clarity_Form_Assignment__c FROM Clarity_Form__c WHERE Id IN :formIds AND Clarity_Form_Assignment__c != ''];

                for(Clarity_Form__c form : forms) { 

                    formIdByAssignmentIds.put(form.Clarity_Form_Assignment__c, form.Id);

                }

                List<Clarity_Form_Assignment__c> assignments = [SELECT Id, Logic__c, Assign__c, (SELECT Id, Operator__c, Field__c, Value__c FROM Clarity_Form_Assignment_Rules__r) FROM Clarity_Form_Assignment__c WHERE Id IN :formIdByAssignmentIds.keySet()];

                for(Clarity_Form_Assignment__c a : assignments) {
                    Id formId = formIdByAssignmentIds.get(a.Id); 
                    Assignment.put(formId, a);
                }

            }
            return Assignment;
        }
        set; 
    }

    private static Map<Id, Map<Id, Clarity_Form_Answer__c>> ResponseAnswers {
        get {
            if(ResponseAnswers == null) {

                ResponseAnswers = new Map<Id, Map<Id, Clarity_Form_Answer__c>>(); 

                List<Clarity_Form_Answer__c> answers = [SELECT Id, Clarity_Form_Question__c, Clarity_Form_Response__c, Answer__c FROM Clarity_Form_Answer__c WHERE Clarity_Form_Response__c IN :Trigger.newMap.keySet()];

                for(Clarity_Form_Answer__c answer : answers) {

                    Map<Id, Clarity_Form_Answer__c> currentResponseAnswers = new Map<Id, Clarity_Form_Answer__c>(); 

                    if(ResponseAnswers.get(answer.Clarity_Form_Response__c) != null) {
                        
                        currentResponseAnswers = ResponseAnswers.get(answer.Clarity_Form_Response__c); 

                    } else {

                        currentResponseAnswers = new Map<Id, Clarity_Form_Answer__c>(); 

                    }

                    currentResponseAnswers.put(answer.Clarity_Form_Question__c, answer);

                    ResponseAnswers.put(answer.Clarity_Form_Response__c, currentResponseAnswers);
                }

            }
            return ResponseAnswers;
        }
        set; 
    }

    public static void execute(Clarity_Form_Response__c oldResponse, Clarity_Form_Response__c response) {
        
        if(oldResponse.Status__c == 'Submitted' || response.Status__c != 'Submitted') return; 
                
        if(Assignment.get(response.Clarity_Form__c) == null) return; 

        Clarity_Form_Assignment__c assignment = Assignment.get(response.Clarity_Form__c); 

        if(assignment.Assign__c == null && assignment.Default_Assign__c == null) return;

        if(assignment.Clarity_Form_Assignment_Rules__r.size () == 0) {
            response.OwnerId__c = assignment.Assign__c;
            return;
        } 

        List<Clarity_Form_Assignment_Rule__c> rules = assignment.Clarity_Form_Assignment_Rules__r;

        Boolean shouldAssign = false; 

        Map<Id, Clarity_Form_Answer__c> questionAnswers = ResponseAnswers.get(response.Id);

        if(assignment.Logic__c == 'OR') {

            for(Clarity_Form_Assignment_Rule__c rule : rules) {
                
                if(questionAnswers.get(rule.Field__c) != null) {

                    Clarity_Form_Answer__c answer = questionAnswers.get(rule.Field__c); 

                    shouldAssign = operateOnAnswer(answer.Answer__c, rule); 

                    if(shouldAssign) {
                        break; 
                    }

                }

            }

        }

        if(assignment.Logic__c == 'AND') {

            for(Clarity_Form_Assignment_Rule__c rule : rules) {
                
                if(questionAnswers.get(rule.Field__c) != null) {

                    Clarity_Form_Answer__c answer = questionAnswers.get(rule.Field__c); 

                    shouldAssign = operateOnAnswer(answer.Answer__c, rule); 

                    if(!shouldAssign) {
                        break; 
                    }

                }

            }

        }

        if(shouldAssign) {

            response.OwnerId__c = assignment.Assign__c;

        }

    }

    public static Boolean operateOnAnswer(String answer, Clarity_Form_Assignment_Rule__c rule) {

        Boolean shouldAssign = false; 

        if(rule.Operator__c == 'Equals') {
            shouldAssign = answer == rule.Value__c ? true : false; 
        }

        if(rule.Operator__c == 'Not Equal') {
            shouldAssign = answer != rule.Value__c ? true : false; 
        }

        if(rule.Operator__c == 'Is Not Null') {
            shouldAssign = answer != null ? true : false; 
        }

        if(rule.Operator__c == 'Is Greater than or equal to') {
            shouldAssign = Integer.valueOf(answer) >= Integer.valueOf(rule.Value__c) ? true : false; 
        }

        if(rule.Operator__c == 'Is Less than or equal to') {
            shouldAssign = Integer.valueOf(answer) >= Integer.valueOf(rule.Value__c) ? true : false; 
        }

        return shouldAssign;

    }

}
