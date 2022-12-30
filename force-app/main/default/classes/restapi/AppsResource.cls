@RestResource(urlMapping='/v1/Apps/*')
global with sharing class AppsResource {
  @HttpGet
  global static List<App> getApps() {
    /**
     * Will query by params
     * param searchTerm
     * param geoLocation
     * param offset
     * param limit
     */

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;

    List<Account> accounts = AccountsService.getAccountsWithChecklistGroups();
    Set<Id> checkListGroupIds = new Set<Id>();

    for (Account account : accounts) {
      checkListGroupIds.add(account.Checklist_Group__c);
    }

    List<Checklist_Group__c> checklists = ChecklistGroupsSelector.newInstance()
      .selectByIdWithForms(checkListGroupIds);
    Map<Id, Checklist_Group__c> checkListGroups = new Map<Id, Checklist_Group__c>();

    for (Checklist_Group__c checklistGroup : checklistGroups) {
      checkListGroups.put(checklistGroup.Id, checklistGroup);
    }

    List<App> apps = new List<App>();

    for (Account account : accounts) {
      Checklist_Group__c checklistGroup = checklistGroups.get(
        account.Checklist_Group__c
      );
      App app = new App();
      app.record = account;
      app.checklistGroup = checklistGroup;
      app.forms = checklist.Forms__r;
      apps.add(app);
    }

    return apps;
  }
}
