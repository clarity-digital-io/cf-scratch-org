public with sharing class Answers extends fflib_SObjectDomain implements IAnswers {
  public void save(fflib_ISObjectUnitOfWork uow) {
    List<Answer__c> answers = (List<Answer__c>) Records;
    uow.registerUpsert(answers);
  }

  public static IAnswers newInstance(List<Answer__c> recordList) {
    return (IAnswers) Application.Domain.newInstance(recordList);
  }

  public static IAnswers newInstance(Set<Id> recordIdSet) {
    return (IAnswers) Application.Domain.newInstance(recordIdSet);
  }

  public Answers(List<Answer__c> sObjectList) {
    // Domain classes are initialised with lists to enforce bulkification throughout
    super(sObjectList);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Answers(sObjectList);
    }
  }
}
