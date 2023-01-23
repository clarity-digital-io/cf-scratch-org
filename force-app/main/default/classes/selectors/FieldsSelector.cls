public with sharing class FieldsSelector extends fflib_SObjectSelector implements IFieldsSelector {
  public Schema.SObjectType getSObjectType() {
    return Field__mdt.sObjectType;
  }

  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Field__mdt.DeveloperName,
      Field__mdt.Level__c,
      Field__mdt.Type__c
    };
  }

  public List<Field__mdt> selectAllFields() {
    fflib_QueryFactory query = newQueryFactory();

    return (List<Field__mdt>) Database.query(query.toSOQL());
  }

  public static IFieldsSelector newInstance() {
    return (IFieldsSelector) Application.selector.newInstance(
      Field__mdt.SObjectType
    );
  }
}
