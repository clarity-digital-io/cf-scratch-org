public interface IFormsService {
	Id deleteById(String recordId);
	Form__c publishForm(Id formId);
	List<Form__c> getForms();
	Form__c getFormById(String formId);
	Form__c getFormByName(String formName);
	Form__c updateForm(Form__c form);
	List<Form__c> getFormsByStatus(String status);
}