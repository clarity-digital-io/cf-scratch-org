public class ChecklistGroupsSelector extends fflib_SObjectSelector implements IChecklistGroupsSelector {
  public Schema.SObjectType getSObjectType() {
    return Checklist_Group__c.sObjectType;
  }

  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Checklist_Group__c.Id,
      Checklist_Group__c.Name,
      Checklist_Group__c.Standard__c
    };
  }

  public List<Checklist_Group__c> selectById(Set<Id> recordIds) {
    return (List<Checklist_Group__c>) selectSObjectsById(recordIds);
  }

  public List<Checklist_Group__c> selectGroups() {
    fflib_QueryFactory query = newQueryFactory();

    return (List<Checklist_Group__c>) Database.query(query.toSOQL());
  }

  public List<Checklist_Group__c> selectByIdWithForms(Set<Id> recordIds) {
    fflib_QueryFactory query = newQueryFactory();

    query.setCondition('Id IN :recordIds');

    new FormsSelector().addQueryFactorySubselect(query, 'cforms__Forms__r');

    return (List<Checklist_Group__c>) Database.query(query.toSOQL());
  }

  public static IChecklistGroupsSelector newInstance() {
    return (IChecklistGroupsSelector) Application.selector.newInstance(
      Checklist_Group__c.SObjectType
    );
  }
}
