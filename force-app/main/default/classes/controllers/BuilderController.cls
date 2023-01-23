global with sharing class BuilderController {
  @RemoteAction
  global static List<String> save(String sFormVersion, List<String> values) {
    String sQuestions = values[0];
    String sQuestionOptions = values[1];
    String sQuestionCriteria = values[2];
    String sQuestionPictureOptions = values[3];
    String sFormConnections = values[4];
    String sFormConnectionFields = values[5];

    Form_Version__c parsedFormVersion = (Form_Version__c) JSON.deserialize(
      sFormVersion,
      Form__c.class
    );

    List<Question__c> parsedQuestions = (List<Question__c>) JSON.deserialize(
      sQuestions,
      List<Question__c>.class
    );

    List<Question_Option__c> parsedQuestionOptions = (List<Question_Option__c>) JSON.deserialize(
      sQuestionOptions,
      List<Question_Option__c>.class
    );

    List<Question_Criteria__c> parsedQuestionCriteria = (List<Question_Criteria__c>) JSON.deserialize(
      sQuestionCriteria,
      List<Question_Criteria__c>.class
    );

    List<Question_Option__c> parsedQuestionPictureOptions = (List<Question_Option__c>) JSON.deserialize(
      sQuestionPictureOptions,
      List<Question_Option__c>.class
    );

    List<Form_Connection__c> parsedFormConnections = (List<Form_Connection__c>) JSON.deserialize(
      sFormConnections,
      List<Form_Connection__c>.class
    );

    List<Form_Connection_Field__c> parsedFormConnectionFields = (List<Form_Connection_Field__c>) JSON.deserialize(
      sFormConnectionFields,
      List<Form_Connection_Field__c>.class
    );

    Form_Version__c formVersion = FormVersionsService.updateFormVersion(
      parsedFormVersion
    );

    // questions
    QuestionsService.save(
      parsedQuestions,
      parsedQuestionOptions,
      parsedQuestionCriteria
    );

    return new List<String>();

    // picture questions
    // parsedQuestionPictureOptions

    // form connections
    // FormConnections.save(parsedFormConnections, parsedFormConnectionFields);

    // if (parsedQuestions.size() > 0) {
    // }
    // List<Question__c> questions = QuestionsService.saveQuestions(
    //   parsedQuestions
    // );

    // Map<String, List<sObject>> results = QuestionsService.saveQuestionWithDetails(
    //   parsedQuestion,
    //   parsedQuestionOptions
    // );

    // Map<String, List<sObject>> results = QuestionsService.saveQuestionWithCriteriaDetails(
    //   parsedQuestion,
    //   parsedQuestionCriteria
    // );

    // List<String> saved = new List<String>();

    // for (SObject question : questions) {
    //   saved.add((ID) question.get('Id'));
    // }

    // return saved;
  }

  @RemoteAction
  global static List<String> getSObjectsAvailable(List<String> test) {
    List<String> lookups = new List<String>();

    Map<String, Schema.SObjectType> sObjectsAvailable = Schema.getGlobalDescribe();

    for (Schema.SObjectType so : sObjectsAvailable.values()) {
      //checkfls
      if (
        so.getDescribe().isCreateable() &&
        so.getDescribe().isUpdateable() &&
        so.getDescribe().isAccessible()
      ) {
        lookups.add(so.getDescribe().getName());
      }
    }

    return lookups;
  }

  @RemoteAction
  global static List<Field__mdt> getAvailableFields(List<String> test) {
    // need to filter these by subscription level
    List<Field__mdt> fields = FieldsService.getAvailableFields();

    return fields;
  }

  @RemoteAction
  global static Form_Version__c getFormVersion(List<String> pFormVersionId) {
    String formVersionId = pFormVersionId[0];

    Form_Version__c formVersion = FormVersionsService.getFormVersionById(
      formVersionId
    );

    return formVersion;
  }

  @RemoteAction
  global static Form__c getForm(List<String> pFormId) {
    String formId = pFormId[0];

    Form__c form = FormsService.getFormById(formId);

    return form;
  }

  @RemoteAction
  global static List<Question__c> getQuestions(List<String> sFormVersionId) {
    String formVersionId = sFormVersionId[0];
    List<Question__c> questions = QuestionsService.getFormVersionQuestions(
      (Id) formVersionId
    );

    return questions;
  }

  @RemoteAction
  global static List<Question__c> saveRecordGroupFields(
    String sRecordGroupFields,
    String relatedRecordGroupId
  ) {
    List<Question__c> parsedRecordGroupFields = (List<Question__c>) JSON.deserialize(
      sRecordGroupFields,
      List<Question__c>.class
    );

    List<Question__c> recordGroupQuestions = QuestionsService.saveRecordGroup(
      parsedRecordGroupFields,
      relatedRecordGroupId
    );

    return recordGroupQuestions;
  }

  @RemoteAction
  global static List<Form_Connection__c> getConnections(String formVersionId) {
    List<Form_Connection__c> connections = FormConnectionsService.getConnectionsByFormVersionId(
      formVersionId
    );

    return connections;
  }

  @RemoteAction
  global static Map<String, List<Object>> getConnectionFieldMapping(
    String connectionId,
    String objectType
  ) {
    Map<String, List<Object>> fieldMapping = new Map<String, List<Object>>();

    List<Form_Connection_Field__c> connectionFields = FormConnectionFieldsService.getByConnectionId(
      connectionId
    );

    List<Form_Connection_Field__c> mappingFields = new List<Form_Connection_Field__c>();
    List<Form_Connection_Field__c> prefillFields = new List<Form_Connection_Field__c>();

    for (Form_Connection_Field__c connectionField : connectionFields) {
      if (connectionField.PreFill__c) {
        prefillFields.add(connectionField);
      } else {
        mappingFields.add(connectionField);
      }
    }

    SObjectType sObjType = ((SObject) Type.forName(objectType).newInstance())
      .getSObjectType();

    Schema.DescribeSObjectResult result = sObjType.getDescribe();

    Map<String, Schema.SObjectField> fields = result.fields.getMap();

    List<String> sObjectFields = new List<String>();

    for (String fieldName : fields.keySet()) {
      Schema.SObjectField field = fields.get(fieldName);

      Schema.DescribeFieldResult fieldResult = field.getDescribe();

      Schema.DisplayType type = fieldResult.getType();

      List<Schema.sObjectType> reference = fieldResult.getReferenceTo();
      Boolean isFieldCreateable = fieldResult.isCreateable();

      if (isFieldCreateable) {
        sObjectFields.add('' + field);
      }
    }

    sObjectFields.add('Id');

    fieldMapping.put('Mapping', mappingFields);
    fieldMapping.put('Prefills', prefillFields);
    fieldMapping.put('Fields', sObjectFields);

    return fieldMapping;
  }

  @RemoteAction
  global static List<Form_Connection__c> saveConnections(List<String> connect) {
    String sConnections = connect[0];
    String formId = connect[1];
    String sRemoved = connect[2];

    List<Form_Connection__c> parsedConnections = (List<Form_Connection__c>) JSON.deserialize(
      sConnections,
      List<Form_Connection__c>.class
    );

    List<Form_Connection__c> removedParsedConnections = (List<Form_Connection__c>) JSON.deserialize(
      sRemoved,
      List<Form_Connection__c>.class
    );

    List<Form_Connection__c> validatedConnections = new List<Form_Connection__c>();

    for (Form_Connection__c parsedConnection : parsedConnections) {
      if (parsedConnection.Salesforce_Object__c != '') {
        validatedConnections.add(parsedConnection);
      }
    }

    List<Form_Connection__c> updatedConnections = FormConnectionsService.save(
      removedParsedConnections,
      validatedConnections
    );

    return updatedConnections;
  }

  @RemoteAction
  global static Map<String, List<Object>> saveActiveFieldConnections(
    String sActiveConnectionFields,
    String connectionId
  ) {
    Map<String, List<Object>> fieldMapping = new Map<String, List<Object>>();

    List<Form_Connection_Field__c> parsedConnectionFields = (List<Form_Connection_Field__c>) JSON.deserialize(
      sActiveConnectionFields,
      List<Form_Connection_Field__c>.class
    );

    List<Form_Connection_Field__c> updatedConnectionFields = FormConnectionFieldsService.updateFields(
      parsedConnectionFields,
      connectionId
    );

    List<Form_Connection_Field__c> mappingFields = new List<Form_Connection_Field__c>();
    List<Form_Connection_Field__c> prefillFields = new List<Form_Connection_Field__c>();

    for (Form_Connection_Field__c connectionField : parsedConnectionFields) {
      if (connectionField.PreFill__c) {
        prefillFields.add(connectionField);
      } else {
        mappingFields.add(connectionField);
      }
    }

    fieldMapping.put('Mapping', mappingFields);
    fieldMapping.put('Prefills', prefillFields);

    return fieldMapping;
  }

  @RemoteAction
  global static List<Question__c> pageQuestionsDelete(
    String sQuestions,
    String formId
  ) {
    List<Question__c> parsedQuestions = (List<Question__c>) JSON.deserialize(
      sQuestions,
      List<Question__c>.class
    );

    List<Question__c> questions = QuestionsService.deleteQuestions(
      parsedQuestions,
      formId
    );

    return questions;
  }

  @RemoteAction
  global static List<Question__c> deleteQuestion(
    String sQuestions,
    String sDeleteQuestionId
  ) {
    Id questionId = (Id) sDeleteQuestionId;

    Question__c questionToDelete = (Question__c) questionId.getSobjectType()
      .newSObject((Id) sDeleteQuestionId);

    List<Question__c> parsedQuestions = (List<Question__c>) JSON.deserialize(
      sQuestions,
      List<Question__c>.class
    );

    List<Question__c> updatedQuestions = QuestionsService.deleteQuestion(
      parsedQuestions,
      questionToDelete
    );

    return updatedQuestions;
  }

  //maybe update this to pojo for easier deserialization and to make cleaner
  // @RemoteAction
  // global static Map<String, Map<String, Map<String, String>>> getSObjectFields(
  @RemoteAction
  global static List<Map<String, Object>> getSObjectFields(
    List<String> objectType
  ) {
    SObjectType sObjType = ((SObject) Type.forName(objectType[0]).newInstance())
      .getSObjectType();

    Schema.DescribeSObjectResult result = sObjType.getDescribe();

    Map<String, Schema.SObjectField> fields = result.fields.getMap();

    List<Map<String, Object>> sObjectFields = new List<Map<String, Object>>();

    // Map<String, Map<String, Map<String, String>>> requiredFields = new Map<String, Map<String, Map<String, String>>>();

    // requiredFields.put('Required', new Map<String, Map<String, String>>());
    // requiredFields.put('NotRequired', new Map<String, Map<String, String>>());

    for (String fieldName : fields.keySet()) {
      Schema.SObjectField field = fields.get(fieldName);
      Schema.DescribeFieldResult fieldDescribeResult = field.getDescribe();
      String relationshipName = fieldDescribeResult.getRelationshipName();
      String referenceName = null;

      if (relationshipName != null) {
        for (
          Schema.SObjectType reference : fieldDescribeResult.getReferenceTo()
        ) {
          referenceName = reference.getDescribe().getName();
        }
      }

      Schema.DisplayType type = fieldDescribeResult.getType();

      Boolean isFieldReq = fieldDescribeResult.isNillable();
      Boolean isFieldCreateable = fieldDescribeResult.isCreateable();
      Boolean isDefaultedOnCreate = fieldDescribeResult.isDefaultedOnCreate();
      Boolean isAccessible = fieldDescribeResult.isAccessible();
      Boolean isUpdateable = fieldDescribeResult.isUpdateable();

      if (!isDefaultedOnCreate && isFieldCreateable && isAccessible) {
        Map<String, Object> sObjectField = new Map<String, Object>{
          'field' => '' + field,
          'required' => isFieldReq,
          'type' => '' + type,
          'reference' => referenceName != null ? '' + referenceName : null,
          'prefill' => isDefaultedOnCreate
        };

        sObjectFields.add(sObjectField);
      }

      // if (
      //   !isFieldReq &&
      //   isFieldCreateable &&
      //   !isDefaultedOnCreate &&
      //   isAccessible
      // ) {
      //   requiredFields.get('Required')
      //     .put(
      //       '' + field,
      //       new Map<String, String>{ '' + type => '' + referenceName }
      //     );
      // } else if (
      //   isFieldCreateable &&
      //   !isDefaultedOnCreate &&
      //   isAccessible &&
      //   isUpdateable
      // ) {
      //   requiredFields.get('NotRequired')
      //     .put(
      //       '' + field,
      //       new Map<String, String>{ '' + type => '' + referenceName }
      //     );
      // }
    }

    return sObjectFields;
  }
}
