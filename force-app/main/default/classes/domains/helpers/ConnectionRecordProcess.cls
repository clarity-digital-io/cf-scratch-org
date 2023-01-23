/**
 * @author ben@clarityforms.io
 * @company Clarity Forms
 * @date 07/13/2019
 *
 * @group Response__c
 *
 * @description On update or insert of Response__c, find any related connections
 */
public class ConnectionRecordProcess {
  public static Map<Id, List<Form_Connection__c>> Connections {
    get {
      if (Connections == null) {
        Connections = new Map<Id, List<Form_Connection__c>>();

        Set<Id> formVersionIds = new Set<Id>();

        for (Response__c response : (List<Response__c>) Trigger.new) {
          formVersionIds.add(response.cforms__Form_Version__c);
        }

        List<Form_Connection__c> formConnections = FormConnectionsSelector.newInstance()
          .selectConnectionsByFormVersionIds(formVersionIds);

        for (Form_Connection__c connection : formConnections) {
          if (Connections.get(connection.Form__c) == null) {
            Connections.put(
              connection.Form__c,
              new List<Form_Connection__c>{ connection }
            );
          } else {
            Connections.get(connection.Form__c).add(connection);
          }
        }
      }

      return Connections;
    }
    set;
  }

  public static Map<Id, Map<Id, Answer__c>> ResponseAnswers {
    get {
      if (ResponseAnswers == null) {
        ResponseAnswers = new Map<Id, Map<Id, Answer__c>>();

        List<Answer__c> answers = AnswersSelector.newInstance()
          .getAnswersByResponseId(Trigger.newMap.keySet());

        for (Answer__c answer : answers) {
          Map<Id, Answer__c> currentResponseAnswers = new Map<Id, Answer__c>();

          if (ResponseAnswers.get(answer.Response__c) != null) {
            currentResponseAnswers = ResponseAnswers.get(answer.Response__c);
          }

          currentResponseAnswers.put(answer.Question__c, answer);

          ResponseAnswers.put(answer.Response__c, currentResponseAnswers);
        }
      }
      return ResponseAnswers;
    }
    set;
  }

  public static Map<Id, Map<Id, Form_Connection_Process__c>> ResponseConnectionProcess {
    get {
      if (ResponseConnectionProcess == null) {
        ResponseConnectionProcess = new Map<Id, Map<Id, Form_Connection_Process__c>>();

        List<Form_Connection_Process__c> connectionProcess = new List<Form_Connection_Process__c>();

        for (Response__c response : (List<Response__c>) Trigger.new) {
          List<Form_Connection__c> allConnections = Connections.get(
            response.Form__c
          );

          ResponseConnectionProcess.put(
            response.Id,
            new Map<Id, Form_Connection_Process__c>()
          );

          for (Form_Connection__c connection : allConnections) {
            Form_Connection_Process__c process = new Form_Connection_Process__c(
              Form_Connection__c = connection.Id,
              Response__c = response.Id,
              Status__c = 'In Progress'
            );

            connectionProcess.add(process);

            ResponseConnectionProcess.get(response.Id)
              .put(connection.Id, process);
          }
        }

        ResponsesService.updateFormConnectionStatus(connectionProcess);
      }

      return ResponseConnectionProcess;
    }
    set;
  }

  public static Map<Id, Map<Id, Response_Connection__c>> ResponseConnections {
    get {
      if (ResponseConnections == null) {
        ResponseConnections = new Map<Id, Map<Id, Response_Connection__c>>();

        List<Response_Connection__c> connections = ResponseConnectionsSelector.newInstance()
          .getByResponseId(Trigger.newMap.keySet());

        for (Response_Connection__c connection : connections) {
          Map<Id, Response_Connection__c> currentResponseConnections = new Map<Id, Response_Connection__c>();

          if (ResponseConnections.get(connection.Response__c) != null) {
            currentResponseConnections = ResponseConnections.get(
              connection.Response__c
            );
            currentResponseConnections.put(
              connection.Form_Connection__c,
              connection
            );
            ResponseConnections.put(
              connection.Response__c,
              currentResponseConnections
            );
          } else {
            ResponseConnections.put(
              connection.Response__c,
              new Map<Id, Response_Connection__c>{
                connection.Form_Connection__c => connection
              }
            );
          }
        }
      }

      return ResponseConnections;
    }
    set;
  }
}
