public class AccountsServiceImpl implements IAccountsService {
	
	public List<Account> getAccountsWithChecklistGroups() {
		//get accounts with form
		List<Account> accounts = AccountsSelector.newInstance().selectRecent();

		return accounts; 
	}
}