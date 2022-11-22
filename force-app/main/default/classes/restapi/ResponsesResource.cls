@RestResource(urlMapping='/v1/Responses')
global with sharing class ResponsesResource {

	@HttpDelete
	global static List<String> deleteResponses() {

		RestRequest req = RestContext.request;

		RestResponse res = RestContext.response;

		String body = req.requestBody.toString();

		List<String> parsedUUIDs = (List<String>)JSON.deserialize(body, List<String>.class);

		List<String> deletedResponses = ResponsesService.deleteResponsesByUUIDs(parsedUUIDs);

		return parsedUUIDs; 
	}
	
	@HttpPost
    global static String updateResponses() {

        RestRequest req = RestContext.request;

		RestResponse res = RestContext.response;
		
		String body = req.requestBody.toString();

		Map<String, String> data = (Map<String, String>)JSON.deserialize(body, Map<String, String>.class);

		String responses = data.get('data');

		List<Response> parsedResponses = (List<Response>)JSON.deserialize(responses, List<Response>.class);

		List<Response__c> readyResponses = new List<Response__c>();

		for(Response parsedResponse : parsedResponses) {

			Id ownerId = Id.valueOf(parsedResponse.OwnerId); 

			Response__c response = new Response__c(
				OwnerId = ownerId,
				Status__c = parsedResponse.Status,
				UUID__c = parsedResponse.UUID,
				Form__c = parsedResponse.Form
			);
			readyResponses.add(response); 
		}

		Schema.DescribeFieldResult unique = Response__c.UUID__c.getDescribe();
		Schema.sObjectField uniqueExternalField = unique.getSObjectField();

		List<Response__c> savedResponses = ResponsesService.save(readyResponses, uniqueExternalField); 

        return 'Success';

	}

}
