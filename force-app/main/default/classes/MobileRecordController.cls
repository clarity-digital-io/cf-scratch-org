@RestResource(urlMapping='/MobileRecordController/*')
global with sharing class MobileRecordController {
	
	@HttpGet
    global static Map<String, Map<String, sObject>>	getRecords() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        Map<String, Map<String, sObject>> records = ClarityFormsService.getMobileRecords();

        return records;

	}
	
}

/* 
List<sObject> or Map<sObject> of Records
Trying to get Salesforce Records (Up to 50) 
For Standard and Custom Objects Connected to... Clarity Forms

{
	'Account': {
		'05456422111ID': { Id: '', Name: '' }, 
		'1231234565646': { Id: '', Name: '' }, 
	},
	'Case': {
		'05456422111ID': { Id: '', Name: '' }, 
		'1231234565646': { Id: '', Name: '' }, 
	},
	'Service_Request__c': {
		'05456422111ID': { Id: '', Name: '' }, 
		'1231234565646': { Id: '', Name: '' }, 
	}
}

Map<String, Map<String, sObject>>

*/