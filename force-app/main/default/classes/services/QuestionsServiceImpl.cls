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

	public Map<String, List<sObject>> saveQuestionWithCriteriaDetails(Question__c question, List<Question_Criteria__c> criteria) {

        List<Question_Criteria__c> existingCriteria = QuestionCriteriaSelector.newInstance().selectByQuestionId(question.Id); 
		
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());    	  	    										

		uow.registerUpsert(question);

		uow.registerDeleted(existingCriteria);
		
		uow.registerUpsert(criteria);

		uow.commitWork();	

		Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 

        List<sObject> newCriteria = new List<sObject>(); 
        newCriteria.addAll(criteria);
        
        results.put('Question', new List<sObject> { question });
        results.put('Criteria', newCriteria);

        return results;
	}

	public List<Question__c> deleteQuestion(List<Question__c> questions, Question__c questionDelete) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());    	  	    										

		uow.registerDeleted(questionDelete);

		uow.registerUpsert(questions);

		uow.commitWork();	

		return questions; 

	}

}
