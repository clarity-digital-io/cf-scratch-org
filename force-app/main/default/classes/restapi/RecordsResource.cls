@RestResource(urlMapping='/Records/*')
global with sharing class RecordsResource {
	
	@HttpGet
    global static List<sObject> getRecords() {

        RestRequest req = RestContext.request;

		RestResponse res = RestContext.response;
		
		List<sObject> records = RecordsService.getRecords();

        return records;

	}
}
