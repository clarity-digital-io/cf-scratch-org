public interface IAnswersService {
	List<Answer__c> save(List<Answer__c> answers, Schema.sObjectField uniqueExternalField);
	List<Answer__c> save(List<ContentVersion> attachments, String questionId, String responseId);
	List<Answer__c> save(List<ContentVersion> attachments, List<String> answerIds);
}