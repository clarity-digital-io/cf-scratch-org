public class AccountsSelector extends fflib_SObjectSelector implements IAccountsSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return Account.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			Account.Id,
			Account.Name,
			Account.BillingAddress,
			Account.Phone,
			Account.Checklist_Group__c
	   };
	}

	public List<Account> selectById(Set<Id> recordIds){
		return (List<Account>) selectSObjectsById(recordIds);
	}
	
	public List<Account> selectRecent(){
		fflib_QueryFactory query = newQueryFactory();

		query.setCondition('Checklist_Group__c != NULL');
		query.selectField('Checklist_Group__c');
		query.addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING);
		query.setLimit( 100 );
   
		return (List<Account>) Database.query( query.toSOQL() );
	}  

	public static IAccountsSelector newInstance(){
		return (IAccountsSelector) Application.selector.newInstance(Account.SObjectType);
	}
 
}