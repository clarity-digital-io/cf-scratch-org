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
			Form__c.Multi_Page__c,
			Form__c.CreatedById.Name,
			Form__c.Has_Thank_You__c,
			Form__c.Thank_You_Redirect__c,
			Form__c.Limit__c,
			Form__c.Multi_Page_Val__c,
			Form__c.Multi_Page_Info__c,
			Form__c.End_Date__c
	   };
	}

	public List<Form__c> selectById(Set<Id> recordIds){
		return (List<Form__c>) selectSObjectsById(recordIds);
	}

	public List<Form__c> selectWithResponseItems(){
		fflib_QueryFactory query = newQueryFactory().selectField('CreatedById.Name');

		new QuestionsSelector().
			addQueryFactorySubselect(query,'forms__Questions__r');

		new ResponsesSelector().
			  addQueryFactorySubselect(query,'forms__Responses__r').selectField('CreatedById.Name').selectField('Form__c.Title__c');
   
		return (List<Form__c>) Database.query( query.toSOQL() );
	}  

	public static IFormsSelector newInstance(){
		return (IFormsSelector) Application.selector.newInstance(Form__c.SObjectType);
	}
}

// (SELECT Id, Label__c, Active_Flow__c, Choice_Image__c, Order__c FROM Question_Options__r), 
// (SELECT Id, Field_Type__c, Field__c, Operator__c, Type__c, Value__c, Question__c FROM Question_Criteria__r),