public class FormsServiceImpl implements IFormsService {
	
	public List<Form__c> getForms() {
		List<Form__c> forms = FormsSelector.newInstance().selectWithResponseItems();
		return forms; 
	}

	public List<Form__c> getFormsByStatus(String status) {
		List<Form__c> forms = FormsSelector.newInstance().selectByStatus(status);
		return forms; 
	}

	public Form__c getFormById(String formId) {
		List<Form__c> forms = FormsSelector.newInstance().selectWithQuestions(new Set<Id> { formId });
		return forms[0]; 
	}

	public static Form__c getFormByName(String formName) {
		List<Form__c> forms = FormsSelector.newInstance().selectByName(formName);
		return forms[0]; 
	}

	public Id deleteById(String recordId) {
		
		List<Form__c> forms = FormsSelector.newInstance().selectByIdWithResponses(recordId); 
		
		if(forms[0].forms__Responses__r.size() > 0) {
            throw new AuraHandledException('Unable to delete form while it has Responses');
		}

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerDeleted(forms[0]);
		
		return forms[0].Id; 

	}

	public Form__c updateForm(Form__c form) {
		
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());    	  	    										

		uow.registerUpsert(form);
		// Commit updates to questions		
		uow.commitWork();	

		return form; 

	}

	public Form__c publishForm(Id formId) {

		List<Form__c> forms = FormsSelector.newInstance().selectById(new Set<Id> {formId});

		forms[0].Status__c = 'Published'; 

		Form__c form = updateForm(forms[0]);

		return form; 

	}

	public Form__c setToDraft(Id formId) {

		List<Form__c> forms = FormsSelector.newInstance().selectById(new Set<Id> {formId});

		forms[0].Status__c = 'Draft'; 

		Form__c form = updateForm(forms[0]);

		return form; 

	}


}
