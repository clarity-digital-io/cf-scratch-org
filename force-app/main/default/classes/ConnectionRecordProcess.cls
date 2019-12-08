/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 07/13/2019
*
* @group Clarity_Form_Response__c
*
* @description On update or insert of Clarity_Form_Response__c, find any related connections 
*/
public class ConnectionRecordProcess {

    private static Map<Id, List<Clarity_Form_Connection__c>> Connections {
        get {

            if(Connections == null) {

                Connections = new Map<Id, List<Clarity_Form_Connection__c>>(); 

                List<Id> formIds = new List<Id>(); 

                for(Clarity_Form_Response__c response : (List<Clarity_Form_Response__c>)Trigger.new) {
                    formIds.add(response.Clarity_Form__c);
                }
                
                List<Clarity_Form_Connection__c> formConnections = [SELECT Id, Result_Holder__c, Salesforce_Object__c, Clarity_Form__c FROM Clarity_Form_Connection__c WHERE Clarity_Form__c IN :formIds];

                for(Clarity_Form_Connection__c connection : formConnections) {

                    if(Connections.get(connection.Clarity_Form__c) == null) {
                        Connections.put(connection.Clarity_Form__c, new List<Clarity_Form_Connection__c>{ connection });
                    } else {
                        Connections.get(connection.Clarity_Form__c).add(connection); 
                    }

                }

            }

            return Connections;

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

    private static Map<Id, Map<Id, Clarity_Form_Connection_Process__c>> ResponseConnectionProcess {
        get {
            if(ResponseConnectionProcess == null) {
                
                ResponseConnectionProcess = new Map<Id, Map<Id, Clarity_Form_Connection_Process__c>>(); 

                List<Clarity_Form_Connection_Process__c> connectionProcess = new List<Clarity_Form_Connection_Process__c>();

                for(Clarity_Form_Response__c response : (List<Clarity_Form_Response__c>)Trigger.new) {

                    List<Clarity_Form_Connection__c> allConnections = Connections.get(response.Clarity_Form__c);

                    ResponseConnectionProcess.put(response.Id, new Map<Id, Clarity_Form_Connection_Process__c>());

                    for(Clarity_Form_Connection__c connection : allConnections) {

                        Clarity_Form_Connection_Process__c process = new Clarity_Form_Connection_Process__c(
                            Clarity_Form_Connection__c      = connection.Id, 
                            Clarity_Form_Response__c        = response.Id, 
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

    public static void execute(Clarity_Form_Response__c oldResponse, Clarity_Form_Response__c response) {
        
        if(oldResponse.Status__c == 'Submitted' || response.Status__c != 'Submitted') return; 
                
        if(Connections.get(response.Clarity_Form__c) == null ||  Connections.get(response.Clarity_Form__c).size() == 0) return; 

        List<Clarity_Form_Connection__c> connections = Connections.get(response.Clarity_Form__c);
        //need to check if it's a new or updating an existing connection
        List<Clarity_Form_Response_Connection__c> responseConnections = new List<Clarity_Form_Response_Connection__c>();

        Map<Id, Clarity_Form_Answer__c> answersByQuestions = ResponseAnswers.get(response.Id);

        Map<Id, Clarity_Form_Connection_Process__c> processByConnections = ResponseConnectionProcess.get(response.Id); 

        Map<String, Id> storedResults = new Map<String, Id>();

        System.enqueueJob(new ConnectionCreateJob(0, connections, answersByQuestions, processByConnections, storedResults));

    }

}
