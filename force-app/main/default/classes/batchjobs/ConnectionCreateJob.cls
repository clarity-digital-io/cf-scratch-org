public class ConnectionCreateJob implements Queueable {
  @testVisible
  private static Boolean chainJob = true;

  private Integer order;

  private List<Form_Connection__c> connections;

  private Map<Id, Response_Connection__c> responseConnections;

  private Map<Id, Answer__c> answersByQuestion;

  private Map<Id, Form_Connection_Process__c> processByConnections;

  private Map<String, Id> storedResults;

  private Response__c response;

  public ConnectionCreateJob(
    Integer order,
    List<Form_Connection__c> connections,
    Map<Id, Response_Connection__c> responseConnections,
    Map<Id, Answer__c> answersByQuestion,
    Map<Id, Form_Connection_Process__c> processByConnections,
    Map<String, Id> storedResults,
    Response__c response
  ) {
    this.order = order;
    this.connections = connections;
    this.responseConnections = responseConnections;
    this.answersByQuestion = answersByQuestion;
    this.processByConnections = processByConnections;
    this.storedResults = storedResults;
    this.response = response;
  }

  public void execute(QueueableContext context) {
    Form_Connection__c connection = connections[order];

    Form_Connection_Process__c connectionStatus = processByConnections.get(
      connection.Id
    );

    List<Form_Connection_Field__c> fields = FormConnectionFieldsSelector.newInstance()
      .selectFieldsByConnectionId(connection.Id);

    if (fields.size() > 0) {
      Response_Connection__c rConnection = null;

      if (responseConnections.get(connection.Id) != null) {
        rConnection = responseConnections.get(connection.Id);
      }

      Schema.SObjectType convertType = Schema.getGlobalDescribe()
        .get(connection.Salesforce_Object__c);

      String genericObjectName = convertType.getDescribe().getName();

      Map<String, Schema.SObjectField> sObjectFields = convertType.getDescribe()
        .fields.getMap();

      SObject genericObject = null;
      SObject createdObject = null;

      if (rConnection != null) {
        genericObject = convertType.newSObject(rConnection.Record__c);
      } else {
        genericObject = convertType.newSObject();
      }

      try {
        genericObject = generateSObject(
          genericObject,
          fields,
          sObjectFields,
          answersByQuestion,
          storedResults
        );

        createdObject = ResponsesService.upsertConnectionSObject(
          genericObject,
          connectionStatus,
          response
        );
      } catch (Exception e) {
        System.debug('exception: ' + e.getMessage());
        connectionStatus.Description__c = e.getMessage();
        connectionStatus.Status__c = 'Failed';
        ResponsesService.updateFormConnectionStatus(
          new List<Form_Connection_Process__c>{ connectionStatus }
        );
      }

      if (createdObject != null) {
        storedResults.put(connection.Result_Holder__c, createdObject.Id);
      }
    } else {
      connectionStatus.Description__c = 'No Fields on Connection';
      connectionStatus.Status__c = 'Failed';
      ResponsesService.updateFormConnectionStatus(
        new List<Form_Connection_Process__c>{ connectionStatus }
      );
    }

    if ((connections.size() > (order + 1)) && chainJob) {
      System.enqueueJob(
        new ConnectionCreateJob(
          order + 1,
          connections,
          responseConnections,
          answersByQuestion,
          processByConnections,
          storedResults,
          response
        )
      );
    }

    //Test classes
    if ((connections.size() > (order + 1)) && !chainJob) {
      ConnectionCreateJob job = new ConnectionCreateJob(
        order + 1,
        connections,
        responseConnections,
        answersByQuestion,
        processByConnections,
        storedResults,
        response
      );
      job.execute(null);
    }
  }

  public SObject generateSObject(
    SObject genericObject,
    List<Form_Connection_Field__c> fields,
    Map<String, Schema.SObjectField> sObjectFields,
    Map<Id, Answer__c> answersByQuestion,
    Map<String, Id> storedResults
  ) {
    for (Form_Connection_Field__c field : fields) {
      if (field.Salesforce_Field__c == null)
        continue;

      String dirtyAnswer;
      System.debug('field: ' + field);

      if (
        field.Question__c != null &&
        answersByQuestion.containsKey(field.Question__c)
      ) {
        dirtyAnswer = answersByQuestion.get(field.Question__c).Answer__c != null
          ? answersByQuestion.get(field.Question__c).Answer__c
          : '';
      } else if (field.Custom_Value__c != null) {
        dirtyAnswer = field.Custom_Value__c;

        if (storedResults.get((String) dirtyAnswer) != null) {
          dirtyAnswer = Id.valueOf(storedResults.get((String) dirtyAnswer));
        }
      }

      Schema.DescribeFieldResult fieldResult = sObjectFields.get(
          field.Salesforce_Field__c
        )
        .getDescribe();

      Object cleanAnswer = cleanType(fieldResult, dirtyAnswer);

      genericObject.put(field.Salesforce_Field__c, cleanAnswer);
    }

    return genericObject;
  }

  public Object cleanType(
    Schema.DescribeFieldResult fieldResult,
    String dirtyAnswer
  ) {
    Schema.DisplayType display = fieldResult.getType();

    Object cleanValue = null;

    try {
      if (display == Schema.DisplayType.Boolean) {
        cleanValue = Boolean.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Combobox) {
        cleanValue = String.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Currency) {
        Decimal c = Decimal.valueOf(dirtyAnswer);
        cleanValue = c.setScale(8, RoundingMode.HALF_EVEN);
      }
      if (display == Schema.DisplayType.Date) {
        cleanValue = Date.parse(dirtyAnswer);
      }
      if (display == Schema.DisplayType.DateTime) {
        cleanValue = Datetime.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Double) {
        cleanValue = Decimal.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Email) {
        cleanValue = String.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.ID) {
        cleanValue = Id.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Integer) {
        cleanValue = Integer.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Long) {
        cleanValue = Long.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.MultiPicklist) {
        cleanValue = String.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Percent) {
        cleanValue = Double.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Phone) {
        cleanValue = String.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Picklist) {
        cleanValue = String.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Reference) {
        // Schema.SObjectType reference = fieldResult.getReferenceTo();

        // String referenceName = reference.getDescribe().getName();

        cleanValue = Id.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.String) {
        cleanValue = String.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.TextArea) {
        cleanValue = String.valueOf(dirtyAnswer);
      }
      if (display == Schema.DisplayType.Time) {
        DateTime dt = Datetime.valueOf(dirtyAnswer);
        cleanValue = Time.newInstance(
          dt.hour(),
          dt.minute(),
          dt.second(),
          dt.millisecond()
        );
      }
      if (display == Schema.DisplayType.URL) {
        cleanValue = String.valueOf(dirtyAnswer);
      }
    } catch (Exception e) {
      // add logging of error
    }

    return cleanValue;
  }
}
