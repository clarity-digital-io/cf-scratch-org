public with sharing class ChecklistGroupsService {

	public static List<Checklist_Group__c> getGroups() {
		return service().getGroups();
	}

	public static IChecklistGroupsService service(){
		return (IChecklistGroupsService) Application.service.newInstance(IChecklistGroupsService.class);
	}
}

