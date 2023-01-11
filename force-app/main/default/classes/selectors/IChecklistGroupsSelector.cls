public interface IChecklistGroupsSelector extends fflib_ISObjectSelector {
  List<Checklist_Group__c> selectById(Set<Id> idSet);
  List<Checklist_Group__c> selectGroups();
  List<Checklist_Group__c> selectByIdWithForms(Set<Id> idSet);
}
