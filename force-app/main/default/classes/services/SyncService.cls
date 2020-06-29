public with sharing class SyncService {

	public static String registerUsers() {
		return service().registerUsers();
	}

	public static String connectOrganization() {
		return service().connectOrganization();
	}

	public static String getOrganizationInformation() {
		return service().getOrganizationInformation();
	}

	public static void process(String userId) {
		service().process(userId);
	}

	public static ISyncService service(){
		return (ISyncService) Application.service.newInstance(ISyncService.class);
	}

}