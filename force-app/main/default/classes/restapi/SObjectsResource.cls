@RestResource(urlMapping='/SObjects/*')
global with sharing class SObjectsResource {
	
	@HttpGet
    global static Map<String, List<sObject>> getRecords() {

        RestRequest req = RestContext.request;

		RestResponse res = RestContext.response;
		
		String requestBody = RestContext.request.requestBody.toString();
		
		List<Response> responses = (List<Response>) JSON.deserialize(requestBody, List<Response>.class);

        Map<String, List<sObject>> records = new Map<String, List<sObject>>(); 

        return records;

	}
}
