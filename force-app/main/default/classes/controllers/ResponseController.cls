public with sharing class ResponseController {

	@AuraEnabled
    public static Response__c getResponse(String recordId) {

		Response__c response = ResponsesService.getResponseWithDetailsById(recordId); 

		return response; 

    }
	
}