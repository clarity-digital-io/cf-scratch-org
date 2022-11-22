public class ChecklistGroupsServiceImpl implements IChecklistGroupsService {
	
	public List<Checklist_Group__c> getGroups() {
		List<Checklist_Group__c> groups = ChecklistGroupsSelector.newInstance().selectGroups();
		return groups; 
	}

}
