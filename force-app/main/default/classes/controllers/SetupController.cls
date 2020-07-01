public with sharing class SetupController {

	@AuraEnabled
	public static String getSetup(){

		String response = SyncService.getOrganizationInformation(); 

		return response; 

	}

	@AuraEnabled
	public static String createConnect(){

		String response = SyncService.connectOrganization(); 

		return response; 

	}

	@AuraEnabled
	public static String registerUsers() {

		String response = SyncService.registerUsers(); 

		return response; 

	}

}
