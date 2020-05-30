public interface IFormsService {
	List<Form__c> getForms();
	Form__c getFormById(String formId);
	Form__c updateForm(Form__c form);
}