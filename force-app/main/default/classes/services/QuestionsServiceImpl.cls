public class QuestionsServiceImpl implements IQuestionsService {
  public List<Question__c> getQuestions() {
    List<Question__c> questions = QuestionsSelector.newInstance()
      .selectWithAllDetails();
    return questions;
  }

  public List<Question__c> getFormVersionsQuestions(Set<Id> formversionIds) {
    List<Question__c> questions = QuestionsSelector.newInstance()
      .selectWithAllDetailsByIds(formVersionIds);
    return questions;
  }

  public List<Question__c> getFormVersionQuestions(Id formVersionId) {
    List<Question__c> questions = QuestionsSelector.newInstance()
      .selectWithAllDetailsByIds(new Set<Id>{ formVersionId });
    return questions;
  }

  public List<Question__c> saveRecordGroup(
    List<Question__c> recordGroupFields,
    String relatedRecordGroupId
  ) {
    //Good candidate to move to domain layer of Question Options
    List<Question__c> deleteExistingRecordGroupFields = QuestionsSelector.newInstance()
      .selectByRelatedRecordGroupId(relatedRecordGroupId);

    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerDeleted(deleteExistingRecordGroupFields);

    uow.registerUpsert(recordGroupFields);

    uow.commitWork();

    return recordGroupFields;
  }

  public List<Question__c> saveQuestions(List<Question__c> questions) {
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerUpsert(questions);

    uow.commitWork();

    return questions;
  }

  public Map<String, List<sObject>> saveQuestionWithDetails(
    Question__c question,
    List<Question_Option__c> options
  ) {
    //Good candidate to move to domain layer of Question Options
    List<Question_Option__c> deleteOptions = new List<Question_Option__c>();

    List<Question_Option__c> existingOptions = QuestionOptionsSelector.newInstance()
      .selectByQuestionId(question.Id);

    Map<Id, Question_Option__c> updatedQuestionOptionsById = new Map<Id, Question_Option__c>();

    for (Question_Option__c o : options) {
      updatedQuestionOptionsById.put(o.Id, o);
    }

    List<Question_Option__c> notFoundInParsedQuestionOptions = new List<Question_Option__c>();

    for (Question_Option__c existing : existingOptions) {
      if (updatedQuestionOptionsById.get(existing.Id) == null) {
        deleteOptions.add(existing);
      }
    }

    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerUpsert(question);

    uow.registerDeleted(deleteOptions);

    uow.registerUpsert(options);

    uow.commitWork();

    Map<String, List<sObject>> results = new Map<String, List<sObject>>();

    List<sObject> newOptions = new List<sObject>();
    newOptions.addAll(options);

    results.put('Question', new List<sObject>{ question });
    results.put('Options', newOptions);

    return results;
  }

  public Map<String, List<sObject>> saveQuestionWithCriteriaDetails(
    Question__c question,
    List<Question_Criteria__c> criteria
  ) {
    List<Question_Criteria__c> existingCriteria = QuestionCriteriaSelector.newInstance()
      .selectByQuestionId(question.Id);

    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerUpsert(question);

    uow.registerDeleted(existingCriteria);

    uow.registerUpsert(criteria);

    uow.commitWork();

    Map<String, List<sObject>> results = new Map<String, List<sObject>>();

    List<sObject> newCriteria = new List<sObject>();
    newCriteria.addAll(criteria);

    results.put('Question', new List<sObject>{ question });
    results.put('Criteria', newCriteria);

    return results;
  }

  public List<Question__c> deleteQuestion(
    List<Question__c> questions,
    Question__c questionDelete
  ) {
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerDeleted(questionDelete);

    List<Question__c> newQuestionsCheck = new List<Question__c>();

    for (Question__c question : questions) {
      if (question.Id != questionDelete.Id) {
        newQuestionsCheck.add(question);
      }
    }

    uow.registerUpsert(newQuestionsCheck);

    uow.commitWork();

    return newQuestionsCheck;
  }

  public List<Question__c> deleteQuestions(
    List<Question__c> deleted,
    String formId
  ) {
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerDeleted(deleted);

    uow.commitWork();

    List<Question__c> questions = QuestionsSelector.newInstance()
      .selectWithAllDetailsByIds(new Set<Id>{ formId });

    return questions;
  }

  public List<Question__c> save(
    List<Question__c> questions,
    List<Question_Option__c> questionOptions,
    List<Question_Criteria__c> questionCriteria
  ) {
    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    uow.registerUpsert(questions);

    Map<String, Question__c> externalIdToQuestion = new Map<String, Question__c>();

    // Add External Id only to Question__c in Builder
    for (Question__c question : questions) {
      externalIdToQuestion.put(question.ExternalBuilderId__c, question);
    }

    // register options
    for (Question_Option__c option : questionOptions) {
      Question__c question = externalIdToQuestion.get(option.Question__c);
      option.Question__c = question.Id;
      uow.registerNew(option, Question_Option__c.Question__c, question);
    }

    // register criteria
    for (Question_Criteria__c criterion : questionCriteria) {
      Question__c question = externalIdToQuestion.get(criterion.Question__c);
      criterion.Question__c = question.Id;
      uow.registerNew(criterion, Question_Criteria__c.Question__c, question);
    }

    uow.commitWork();

    return questions;
  }
}
