public class QuestionsServiceImpl implements IQuestionsService {
	
	public List<Question__c> getQuestions() {
		List<Question__c> questions = QuestionsSelector.newInstance().selectWithAllDetails();
		return questions; 
	}

}
