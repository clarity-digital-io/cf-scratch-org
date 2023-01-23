public class FormVersionsSelector extends fflib_SObjectSelector implements IFormVersionsSelector {
  public Schema.SObjectType getSObjectType() {
    return Form_Version__c.sObjectType;
  }

  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{ Form__c.Id, Form__c.Name };
  }

  public List<Form_Version__c> selectById(Set<Id> recordIds) {
    return (List<Form_Version__c>) selectSObjectsById(recordIds);
  }

  public List<Form_Version__c> selectByFormId(Id formId) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Form__c = :formId');

    new QuestionsSelector()
      .addQueryFactorySubselect(query, 'cforms__Questions__r');

    return (List<Form_Version__c>) Database.query(query.toSOQL());
  }

  public static IFormVersionsSelector newInstance() {
    return (IFormVersionsSelector) Application.selector.newInstance(
      Form_Version__c.SObjectType
    );
  }
}
