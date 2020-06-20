public with sharing class SyncService {

	@InvocableMethod
	public static void process(List<String> userId) {
		service().process(userId[0]);
	}

	public static ISyncService service(){
		return (ISyncService) Application.service.newInstance(ISyncService.class);
	}
}

