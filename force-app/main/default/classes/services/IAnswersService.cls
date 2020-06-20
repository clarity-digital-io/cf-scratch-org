public interface IAnswersService {
	List<Answer__c> save(List<Answer__c> answers);
	List<Answer__c> save(List<ContentVersion> attachments, String questionId, String responseId);
}