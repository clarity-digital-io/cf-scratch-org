public with sharing class SyncService {

	public static void process(String userId) {
		service().process(userId);
	}

	public static ISyncService service(){
		return (ISyncService) Application.service.newInstance(ISyncService.class);
	}

}