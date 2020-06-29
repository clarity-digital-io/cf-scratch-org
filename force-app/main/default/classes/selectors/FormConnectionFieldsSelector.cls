public with sharing class FormConnectionFieldsSelector extends fflib_SObjectSelector implements IFormConnectionFieldsSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Form_Connection_Field__c.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Form_Connection_Field__c.Id,
			Form_Connection_Field__c.Name,
			Form_Connection_Field__c.Form_Connection__c,
			Form_Connection_Field__c.Question__c,
			Form_Connection_Field__c.Custom_Value__c,
			Form_Connection_Field__c.PreFill__c,
			Form_Connection_Field__c.Salesforce_Field__c
	   };
	}

	public List<Form_Connection_Field__c> selectFieldsByConnectionId(String connectionId){
		fflib_QueryFactory query = newQueryFactory();
		query.setCondition('Form_Connection__c = :connectionId');
		return (List<Form_Connection_Field__c>) Database.query( query.toSOQL() );
	}

	public List<Form_Connection_Field__c> selectFieldsByConnectionId(Set<Id> connectionIds){
		fflib_QueryFactory query = newQueryFactory();
		query.setCondition('Form_Connection__c IN :connectionIds');
		return (List<Form_Connection_Field__c>) Database.query( query.toSOQL() );
	}

	public static IFormConnectionFieldsSelector newInstance(){
		return (IFormConnectionFieldsSelector) Application.selector.newInstance(Form_Connection_Field__c.SObjectType);
	}
}
