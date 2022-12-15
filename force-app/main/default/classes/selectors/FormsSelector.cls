public class FormsSelector extends fflib_SObjectSelector implements IFormsSelector {
  public Schema.SObjectType getSObjectType() {
    return Form__c.sObjectType;
  }

  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Form__c.Id,
      Form__c.Name,
      Form__c.Title__c,
      Form__c.Status__c,
      Form__c.CreatedDate,
      Form__c.Multi_Page__c,
      Form__c.CreatedById.Name,
      Form__c.Description__c,
      Form__c.Has_Thank_You__c,
      Form__c.Thank_You_Redirect__c,
      Form__c.Multi_Page_Val__c,
      Form__c.Multi_Page_Info__c,
      Form__c.End_Date__c,
      Form__c.Checklist_Group__c
    };
  }

  public List<Form__c> selectById(Set<Id> recordIds) {
    return (List<Form__c>) selectSObjectsById(recordIds);
  }

  public List<Form__c> selectByIdWithResponses(Id recordId) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Id = :recordId');

    new ResponsesSelector()
      .addQueryFactorySubselect(query, 'cforms__Responses__r');

    return (List<Form__c>) Database.query(query.toSOQL());
  }

  public List<Form__c> selectByName(String name) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Name = :name');

    new QuestionsSelector()
      .addQueryFactorySubselect(query, 'cforms__Questions__r');

    return (List<Form__c>) Database.query(query.toSOQL());
  }

  public List<Form__c> selectByStatus(String status) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Status__c = :status');
    return (List<Form__c>) Database.query(query.toSOQL());
  }

  public List<Form__c> selectWithResponseItems() {
    fflib_QueryFactory query = newQueryFactory()
      .selectField('CreatedById.Name');

    new QuestionsSelector()
      .addQueryFactorySubselect(query, 'cforms__Questions__r');

    new ResponsesSelector()
      .addQueryFactorySubselect(query, 'cforms__Responses__r')
      .selectField('CreatedById.Name')
      .selectField('Form__c.Title__c');

    return (List<Form__c>) Database.query(query.toSOQL());
  }

  public List<Form__c> selectWithQuestions(Set<Id> formIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Id IN :formIds');

    new QuestionsSelector()
      .addQueryFactorySubselect(query, 'cforms__Questions__r');

    return (List<Form__c>) Database.query(query.toSOQL());
  }

  public static IFormsSelector newInstance() {
    return (IFormsSelector) Application.selector.newInstance(
      Form__c.SObjectType
    );
  }
}
