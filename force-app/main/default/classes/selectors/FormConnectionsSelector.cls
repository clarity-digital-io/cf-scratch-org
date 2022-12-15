public with sharing class FormConnectionsSelector extends fflib_SObjectSelector implements IFormConnectionsSelector {
  public Schema.SObjectType getSObjectType() {
    return Form_Connection__c.sObjectType;
  }

  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Form_Connection__c.Id,
      Form_Connection__c.Name,
      Form_Connection__c.New__c,
      Form_Connection__c.Result_Holder__c,
      Form_Connection__c.Salesforce_Object__c,
      Form_Connection__c.Type__c,
      Form_Connection__c.Form__c
    };
  }

  public List<Form_Connection__c> selectConnectionsByResponseId(
    String responseId
  ) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Form__c = :formId AND New__c = true');
    return (List<Form_Connection__c>) Database.query(query.toSOQL());
  }

  public List<Form_Connection__c> selectConnectionsByFormIds(Set<Id> formIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Form__c IN :formIds');

    return (List<Form_Connection__c>) Database.query(query.toSOQL());
  }

  public List<Form_Connection__c> selectConnectionsByFormId(String formId) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Form__c = :formId');

    new FormConnectionFieldsSelector()
      .addQueryFactorySubselect(query, 'cforms__Form_Connection_Fields__r');

    return (List<Form_Connection__c>) Database.query(query.toSOQL());
  }

  public List<Form_Connection__c> selectConnectionsByFormStatus(String status) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Form__r.Status__c = :status');

    new FormConnectionFieldsSelector()
      .addQueryFactorySubselect(query, 'cforms__Form_Connection_Fields__r');

    return (List<Form_Connection__c>) Database.query(query.toSOQL());
  }

  public static IFormConnectionsSelector newInstance() {
    return (IFormConnectionsSelector) Application.selector.newInstance(
      Form_Connection__c.SObjectType
    );
  }
}
