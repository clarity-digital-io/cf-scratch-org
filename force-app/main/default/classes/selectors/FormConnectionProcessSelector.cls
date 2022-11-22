public with sharing class FormConnectionProcessSelector extends fflib_SObjectSelector implements IFormConnectionProcessSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Form_Connection_Process__c.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Form_Connection_Process__c.Id,
			Form_Connection_Process__c.Name,
			Form_Connection_Process__c.Status__c,
			Form_Connection_Process__c.Response__c,
			Form_Connection_Process__c.Form_Connection__c,
			Form_Connection_Process__c.Salesforce_Connection_Object__c,
			Form_Connection_Process__c.Description__c
	   };
	}

	public static IFormConnectionProcessSelector newInstance(){
		return (IFormConnectionProcessSelector) Application.selector.newInstance(Form_Connection_Process__c.SObjectType);
	}
}
