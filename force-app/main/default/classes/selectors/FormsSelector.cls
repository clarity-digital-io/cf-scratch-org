public class FormsSelector extends fflib_SObjectSelector implements IFormsSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Form__c.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Form__c.Id,
			Form__c.Name,
			Form__c.Title__c,
			Form__c.Status__c,
			Form__c.CreatedDate,
			Form__c.Multi_Page__c
	   };
	}

	public List<Form__c> selectById(Set<Id> recordIds){
		return (List<Form__c>) selectSObjectsById(recordIds);
	}

	public List<Form__c> selectWithResponseItems(){
		fflib_QueryFactory query = newQueryFactory();

		new QuestionsSelector().
			addQueryFactorySubselect(query,'forms__Questions__r');

		new ResponsesSelector().
			  addQueryFactorySubselect(query,'forms__Responses__r');
   
		return (List<Form__c>) Database.query( query.toSOQL() );
	}  

	public static IFormsSelector newInstance(){
		return (IFormsSelector) Application.selector.newInstance(Form__c.SObjectType);
	}
}