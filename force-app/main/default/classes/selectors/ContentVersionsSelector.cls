public class ContentVersionsSelector extends fflib_SObjectSelector implements IContentVersionsSelector {
 
	public Schema.SObjectType getSObjectType(){
	   return ContentVersion.sObjectType;
	}
  
	public List<Schema.SObjectField> getSObjectFieldList(){
	   return new List<Schema.SObjectField> {
			ContentVersion.Id,
			ContentVersion.Answer_UUID__c,
			ContentVersion.Response__c,
			ContentVersion.Question__c,
			ContentVersion.ContentDocumentId
		};
	}

	public List<ContentVersion> selectById(Set<Id> recordIds){
		return (List<ContentVersion>) selectSObjectsById(recordIds);
	}

	public static IContentVersionsSelector newInstance(){
		return (IContentVersionsSelector) Application.selector.newInstance(ContentVersion.SObjectType);
	}
 
}