@RestResource(urlMapping='/v1/Answers/*')
global with sharing class AnswersResource {
	
	@HttpPost
    global static String updateAnswers() {

        RestRequest req = RestContext.request;

		RestResponse res = RestContext.response;
		
		String body = req.requestBody.toString();

		Map<String, String> data = (Map<String, String>)JSON.deserialize(body, Map<String, String>.class);

		String answers = data.get('data');

		List<Answer> parsedAnswers =  (List<Answer>)JSON.deserialize(answers, List<Answer>.class);

		List<Answer__c> readyAnswers = new List<Answer__c>();

		for(Answer parsedAnswer : parsedAnswers) {
			Answer__c answer = new Answer__c(
				UUID__c = parsedAnswer.UUID,
				Answer__c = parsedAnswer.Answer,
				Question__c = parsedAnswer.Question,
				Response__r = new Response__c(UUID__c = parsedAnswer.Response)
			);
			readyAnswers.add(answer); 
		}

		Schema.DescribeFieldResult unique = Answer__c.UUID__c.getDescribe();
		Schema.sObjectField uniqueExternalField = unique.getSObjectField();

		List<Answer__c> savedAnswers = AnswersService.save(readyAnswers, uniqueExternalField);

        return 'Success';

	}

}