public with sharing class RecordsService {
	public static List<sObject> getRecords() {
		return service().getRecords();
	}

	public static IRecordsService service(){
		return (IRecordsService) Application.service.newInstance(IRecordsService.class);
	}
}
