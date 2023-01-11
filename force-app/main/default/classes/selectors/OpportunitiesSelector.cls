public class OpportunitiesSelector extends fflib_SObjectSelector implements IOpportunitiesSelector {
  public Schema.SObjectType getSObjectType() {
    return Opportunity.sObjectType;
  }

  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{ Opportunity.Id, Opportunity.Name };
  }

  public List<Opportunity> selectById(Set<Id> recordIds) {
    return (List<Opportunity>) selectSObjectsById(recordIds);
  }

  public static IOpportunitiesSelector newInstance() {
    return (IOpportunitiesSelector) Application.selector.newInstance(
      Opportunity.SObjectType
    );
  }
}
