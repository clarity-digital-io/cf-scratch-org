public with sharing class AccountsService {
  public static List<Account> getAccountsWithChecklistGroups() {
    return service().getAccountsWithChecklistGroups();
  }

  public static IAccountsService service() {
    return (IAccountsService) Application.service.newInstance(
      IAccountsService.class
    );
  }
}
