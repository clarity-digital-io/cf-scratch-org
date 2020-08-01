@isTest
public class AppsResourceUnitTest {

	@TestSetup
	public static void setup(){
		
		List<Checklist_Group__c> groups = TestDataFactory.generateChecklistGroups(3);

		insert groups; 

		List<Form__c> forms = TestDataFactory.generateFormsWithGroup(groups); 

		upsert forms; 

		List<Account> accounts = TestDataFactory.generateApps(groups);

		insert accounts;

		Account account = new Account(
			Name = 'No Group'
		);

		insert account; 

	}

	@isTest
	public static void shouldGetApps() {

		List<Account> accounts = [SELECT Id FROM Account];

		System.assertEquals(accounts.size(), 4);
		
		RestRequest request = new RestRequest();

		request.httpMethod = 'GET';
		RestContext.request = request;

		List<App> apps = AppsResource.getApps();

		//return number of apps (accounts in this case with checklist);
		System.assertEquals(accounts.size() - 1, apps.size());

	} 
	
}
