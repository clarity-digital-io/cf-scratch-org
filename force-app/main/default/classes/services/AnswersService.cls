public with sharing class AnswersService {

	public static List<Answer__c> save(List<Answer__c> parsedAnswers, Schema.sObjectField uniqueExternalField) {
		return service().save(parsedAnswers, uniqueExternalField);
	}

	public static List<Answer__c> save(List<ContentVersion> attachments, String questionId, String responseId) {
		return service().save(attachments, questionId, responseId);
	}

	public static List<Answer__c> save(List<ContentVersion> attachments, List<String> answerIds) {
		return service().save(attachments, answerIds);
	}

	public static IAnswersService service(){
		return (IAnswersService) Application.service.newInstance(IAnswersService.class);
	}

}