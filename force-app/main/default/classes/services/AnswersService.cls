public with sharing class AnswersService {

	public static List<Answer__c> save(List<Answer__c> parsedAnswers) {
		return service().save(parsedAnswers);
	}

	public static List<Answer__c> save(List<ContentVersion> attachments, String questionId, String responseId) {
		return service().save(attachments, questionId, responseId);
	}

	public static IAnswersService service(){
		return (IAnswersService) Application.service.newInstance(IAnswersService.class);
	}

}