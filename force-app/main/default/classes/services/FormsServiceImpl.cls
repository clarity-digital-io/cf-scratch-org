public class FormsServiceImpl implements IFormsService {
	
	public List<Form__c> getForms() {
		List<Form__c> forms = FormsSelector.newInstance().selectWithResponseItems();
		return forms; 
	}

}
