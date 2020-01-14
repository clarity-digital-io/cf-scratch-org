/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 07/13/2019
*
* @group forms__Form_Response__c
*
* @description On update or insert of forms__Form_Response__c, find any related connections 
*/
public class ConnectionRecordProcess {

    private static Map<Id, List<forms__Form_Connection__c>> Connections {
        get {

            if(Connections == null) {

                Connections = new Map<Id, List<forms__Form_Connection__c>>(); 

                List<Id> formIds = new List<Id>(); 

                for(forms__Form_Response__c response : (List<forms__Form_Response__c>)Trigger.new) {
                    formIds.add(response.forms__Form__c);
                }
                
                List<forms__Form_Connection__c> formConnections = [SELECT Id, Result_Holder__c, Salesforce_Object__c, forms__Form__c FROM forms__Form_Connection__c WHERE forms__Form__c IN :formIds];

                for(forms__Form_Connection__c connection : formConnections) {

                    if(Connections.get(connection.forms__Form__c) == null) {
                        Connections.put(connection.forms__Form__c, new List<forms__Form_Connection__c>{ connection });
                    } else {
                        Connections.get(connection.forms__Form__c).add(connection); 
                    }

                }

            }

            return Connections;

        }
        set;
    }

    private static Map<Id, Map<Id, forms__Form_Answer__c>> ResponseAnswers {
        get {
            if(ResponseAnswers == null) {

                ResponseAnswers = new Map<Id, Map<Id, forms__Form_Answer__c>>(); 

                List<forms__Form_Answer__c> answers = [SELECT Id, forms__Form_Question__c, forms__Form_Response__c, Answer__c FROM forms__Form_Answer__c WHERE forms__Form_Response__c IN :Trigger.newMap.keySet()];

                for(forms__Form_Answer__c answer : answers) {

                    Map<Id, forms__Form_Answer__c> currentResponseAnswers = new Map<Id, forms__Form_Answer__c>(); 

                    if(ResponseAnswers.get(answer.forms__Form_Response__c) != null) {
                        
                        currentResponseAnswers = ResponseAnswers.get(answer.forms__Form_Response__c); 

                    } else {

                        currentResponseAnswers = new Map<Id, forms__Form_Answer__c>(); 

                    }

                    currentResponseAnswers.put(answer.forms__Form_Question__c, answer);

                    ResponseAnswers.put(answer.forms__Form_Response__c, currentResponseAnswers);
                }

            }
            return ResponseAnswers;
        }
        set; 
    }

    private static Map<Id, Map<Id, forms__Form_Connection_Process__c>> ResponseConnectionProcess {
        get {
            if(ResponseConnectionProcess == null) {
                
                ResponseConnectionProcess = new Map<Id, Map<Id, forms__Form_Connection_Process__c>>(); 

                List<forms__Form_Connection_Process__c> connectionProcess = new List<forms__Form_Connection_Process__c>();

                for(forms__Form_Response__c response : (List<forms__Form_Response__c>)Trigger.new) {

                    List<forms__Form_Connection__c> allConnections = Connections.get(response.forms__Form__c);

                    ResponseConnectionProcess.put(response.Id, new Map<Id, forms__Form_Connection_Process__c>());

                    for(forms__Form_Connection__c connection : allConnections) {

                        forms__Form_Connection_Process__c process = new forms__Form_Connection_Process__c(
                            forms__Form_Connection__c      = connection.Id, 
                            forms__Form_Response__c        = response.Id, 
                            Status__c                       = 'In Progress'
                        );
                        
                        connectionProcess.add(process);

                        ResponseConnectionProcess.get(response.Id).put(connection.Id, process); 

                    }

                }

                insert connectionProcess;

            }

            return ResponseConnectionProcess;
        }
        set;
    }

    public static void execute(forms__Form_Response__c oldResponse, forms__Form_Response__c response) {
        
        if(oldResponse.Status__c == 'Submitted' || response.Status__c != 'Submitted') return; 
                
        if(Connections.get(response.forms__Form__c) == null ||  Connections.get(response.forms__Form__c).size() == 0) return; 

        List<forms__Form_Connection__c> connections = Connections.get(response.forms__Form__c);
        //need to check if it's a new or updating an existing connection
        List<forms__Form_Response_Connection__c> responseConnections = new List<forms__Form_Response_Connection__c>();

        Map<Id, forms__Form_Answer__c> answersByQuestions = ResponseAnswers.get(response.Id);

        Map<Id, forms__Form_Connection_Process__c> processByConnections = ResponseConnectionProcess.get(response.Id); 

        Map<String, Id> storedResults = new Map<String, Id>();

        System.enqueueJob(new ConnectionCreateJob(0, connections, answersByQuestions, processByConnections, storedResults));

    }

}
