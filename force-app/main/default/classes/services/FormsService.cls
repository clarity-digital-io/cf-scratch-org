public with sharing class FormsService {

	public static List<Form__c> getForms() {
		return service().getForms();
	}

	public static List<Form__c> getFormsByStatus(String status) {
		return service().getFormsByStatus(status);
	}
	
	public static Form__c getFormById(String formId) {
		return service().getFormById(formId);
	}

	public static Form__c getFormByName(String formName) {
		return service().getFormByName(formName);
	}

	public static Form__c updateForm(Form__c form) {
		return service().updateForm(form);
	}

	public static IFormsService service(){
		return (IFormsService) Application.service.newInstance(IFormsService.class);
	}
}

