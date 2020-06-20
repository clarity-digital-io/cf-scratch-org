public class AnswersServiceImpl implements IAnswersService {

	public List<Answer__c> save(List<Answer__c> parsedAnswers) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());
		
		uow.registerUpsert(parsedAnswers);

		return parsedAnswers;

	}

	public List<Answer__c> save(List<ContentVersion> attachments, String questionId, String responseId) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		IContentVersions cvs = ContentVersions.newInstance(attachments);				

		cvs.save(uow);

		uow.commitWork();	

		List<Answer__c> answers = AnswersSelector.newInstance().selectByCustomQuery('Response__c = :responseId AND Question__c = :questionId', questionId, responseId);

		return answers;

	}

}