public class ResponsesSelector extends fflib_SObjectSelector implements IResponsesSelector {
  public Schema.SObjectType getSObjectType() {
    return Response__c.sObjectType;
  }

  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Response__c.Id,
      Response__c.Name,
      Response__c.Completion__c,
      Response__c.Status__c,
      Response__c.Submitted_Date__c,
      Response__c.UUID__c,
      Response__c.Form__c,
      Response__c.CreatedById.Name,
      Response__c.OwnerId,
      Response__c.Checklist__c,
      Response__c.Account__c
    };
  }

  public List<Response__c> selectById(Set<Id> recordIds) {
    return (List<Response__c>) selectSObjectsById(recordIds);
  }

  public List<Response__c> selectByUUIDs(Set<String> UUIDs) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('UUID__c IN :UUIDs');
    return (List<Response__c>) Database.query(query.toSOQL());
  }

  public List<Response__c> selectByFormId(Set<Id> recordIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Form__c IN :recordIds');
    return (List<Response__c>) Database.query(query.toSOQL());
  }

  public List<Response__c> selectResponsesByOwner(List<String> userIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('OwnerId = :userIds');
    return (List<Response__c>) Database.query(query.toSOQL());
  }

  public List<Response__c> selectResponsesByConnectedId(
    String customQuery,
    String recordId
  ) {
    fflib_QueryFactory query = newQueryFactory()
      .selectField('Form__c.Title__c');
    query.setCondition(customQuery);
    return (List<Response__c>) Database.query(query.toSOQL());
  }

  public List<Response__c> selectWithAllDetailsByIds(Set<Id> recordIds) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Id IN :recordIds');

    new ResponseConnectionsSelector()
      .addQueryFactorySubselect(query, 'cforms__Response_Connections__r');

    new AnswersSelector()
      .addQueryFactorySubselect(query, 'cforms__Answers__r')
      .selectField('Question__c.Type__c')
      .selectField('Question__c.Title__c');

    return (List<Response__c>) Database.query(query.toSOQL());
  }

  public List<Response__c> selectRecent() {
    fflib_QueryFactory query = newQueryFactory()
      .selectField('CreatedById.Name')
      .selectField('Form__r.Title__c');

    query.addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING);
    query.setLimit(100);

    new AnswersSelector().addQueryFactorySubselect(query, 'cforms__Answers__r');

    return (List<Response__c>) Database.query(query.toSOQL());
  }

  public static IResponsesSelector newInstance() {
    return (IResponsesSelector) Application.selector.newInstance(
      Response__c.SObjectType
    );
  }
}
