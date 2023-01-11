public class QuestionCriteriaSelector extends fflib_SObjectSelector implements IQuestionCriteriaSelector {
  public Schema.SObjectType getSObjectType() {
    return Question_Criteria__c.sObjectType;
  }

  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Question_Criteria__c.Id,
      Question_Criteria__c.Name,
      Question_Criteria__c.Question__c,
      Question_Criteria__c.Field__c,
      Question_Criteria__c.Field_Type__c,
      Question_Criteria__c.Operator__c,
      Question_Criteria__c.Type__c,
      Question_Criteria__c.Value__c
    };
  }

  public List<Question_Criteria__c> selectById(Set<Id> recordIds) {
    return (List<Question_Criteria__c>) selectSObjectsById(recordIds);
  }

  public List<Question_Criteria__c> selectByQuestionId(Id questionId) {
    fflib_QueryFactory query = newQueryFactory();
    query.setCondition('Question__c = :questionId');

    return (List<Question_Criteria__c>) Database.query(query.toSOQL());
  }

  public static IQuestionCriteriaSelector newInstance() {
    return (IQuestionCriteriaSelector) Application.selector.newInstance(
      Question_Criteria__c.SObjectType
    );
  }
}
