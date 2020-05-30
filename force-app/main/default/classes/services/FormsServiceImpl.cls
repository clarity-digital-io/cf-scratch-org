public class FormsServiceImpl implements IFormsService {
	
	public List<Form__c> getForms() {
		List<Form__c> forms = FormsSelector.newInstance().selectWithResponseItems();
		return forms; 
	}

	public Form__c getFormById(String formId) {
		List<Form__c> forms = FormsSelector.newInstance().selectById(new Set<Id> { formId });
		return forms[0]; 
	}

	public Form__c updateForm(Form__c form) {
		
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());    	  	    										

		uow.registerUpsert(form);
		
		// Commit updates to questions		
		uow.commitWork();	

		return form; 

	}


}
