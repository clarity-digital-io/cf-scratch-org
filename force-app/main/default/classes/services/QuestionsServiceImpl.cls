public class QuestionsServiceImpl implements IQuestionsService {
	
	public List<Question__c> getQuestions() {
		List<Question__c> questions = QuestionsSelector.newInstance().selectWithAllDetails();
		return questions; 
	}

	public List<Question__c> getFormQuestions(Id formId) {
		List<Question__c> questions = QuestionsSelector.newInstance().selectWithAllDetailsByIds(new Set<Id>{ formId });
		return questions; 
	}

	public List<String> saveQuestions(List<Question__c> questions) {
		
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());    	  	    										

		uow.registerUpsert(questions);
		
		// Commit updates to questions		
		uow.commitWork();	

		List<String> quesitonIds = new List<String>();
		for(SObject question : questions)
		quesitonIds.add((ID)question.get('Id'));
		return quesitonIds;

	}

	public Map<String, List<sObject>> saveQuestionWithDetails(Question__c question, List<Question_Option__c> options) {

		//Good candidate to move to domain layer of Question Options
		List<Question_Option__c> deleteOptions = new List<Question_Option__c>();

        List<Question_Option__c> existingOptions = QuestionOptionsSelector.newInstance().selectByQuestionId(question.Id); 
		
        Map<Id, Question_Option__c> updatedQuestionOptionsById = new Map<Id, Question_Option__c>();

        for(Question_Option__c o : options) {
            updatedQuestionOptionsById.put(o.Id, o); 
        }

        List<Question_Option__c> notFoundInParsedQuestionOptions = new List<Question_Option__c>();

        for(Question_Option__c existing : existingOptions) {

            if(updatedQuestionOptionsById.get(existing.Id) == null) {
                deleteOptions.add(existing); 
            }

        }


		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());    	  	    										

		uow.registerUpsert(question);

		uow.registerDeleted(deleteOptions);
		
		uow.registerUpsert(options);

		uow.commitWork();	

		Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 

        List<sObject> newOptions = new List<sObject>(); 
        newOptions.addAll(options);
        
        results.put('Question', new List<sObject> { question });
        results.put('Options', newOptions);

        return results;
	}
}
