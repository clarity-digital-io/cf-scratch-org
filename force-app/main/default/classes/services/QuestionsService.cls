public with sharing class QuestionsService {

	public static List<Question__c> getQuestions() {
		return service().getQuestions();
	}

	public static IQuestionsService service(){
		return (IQuestionsService) Application.service.newInstance(IQuestionsService.class);
	}

}
