public with sharing class ContentVersions extends fflib_SObjectDomain implements IContentVersions {

	public void save(fflib_ISObjectUnitOfWork uow)
	{

		uow.registerNew((List<ContentVersion>) Records);
		
		for(ContentVersion cv : (List<ContentVersion>) Records) {
	
			Answer__c answer = new Answer__c(
				ContentDocument__c = cv.ContentDocumentId,
				ContentVersion__c = cv.Id,
				Question__c = cv.Question__c,
				Response__c = cv.Response__c
			);

			uow.registerNew(answer, Answer__c.ContentVersion__c, cv);				

			ContentDocumentLink formLink = new ContentDocumentLink(
				ContentDocumentId   = cv.ContentDocumentId, //Add ContentDocumentId
				LinkedEntityId      = cv.Response__c, //Add attachment parentId
				ShareType           = 'V', //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
				Visibility          = 'AllUsers' //AllUsers, InternalUsers, SharedUsers
			);

			uow.registerNew(formLink, ContentDocumentLink.ContentDocumentId, cv);				

            ContentDocumentLink answerLink = new ContentDocumentLink(
                ContentDocumentId   = cv.ContentDocumentId, //Add ContentDocumentId
                LinkedEntityId      = answer.Id, //Add attachment parentId
                ShareType           = 'V', //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                Visibility          = 'AllUsers' //AllUsers, InternalUsers, SharedUsers
            );
        
			uow.registerNew(answerLink, ContentDocumentLink.LinkedEntityId, answer);				

		}

	}

	public static IContentVersions newInstance(List<ContentVersion> recordList)
	{
		return (IContentVersions) Application.Domain.newInstance(recordList);
	}

	public static IContentVersions newInstance(Set<Id> recordIdSet)
	{
		return (IContentVersions) Application.Domain.newInstance(recordIdSet);
	}
	
	public ContentVersions(List<ContentVersion> sObjectList)
	{
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new ContentVersions(sObjectList);
		}
	}
	
}
