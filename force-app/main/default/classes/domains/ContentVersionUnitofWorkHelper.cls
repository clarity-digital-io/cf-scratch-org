public class ContentVersionUnitofWorkHelper implements fflib_SObjectUnitOfWork.IDoWork
{       
    public Database.UpsertResult[] AnswerResults {get; private set;}
	public Database.UpsertResult[] ContentDocumentLinkResults {get; private set;}

	private List<ContentVersion> cv_records;

    public ContentVersionUnitofWorkHelper()
    {  
        cv_records = new List<ContentVersion>();
    }
     
    public void registerContentVersions(List<ContentVersion> records)
    {
		cv_records.addAll(records);
    }
     
    public void doWork()
    {
		Set<Id> cv_recordIds = new Set<Id>();

		for(ContentVersion cv : cv_records) {
			cv_recordIds.add(cv.Id); 
		}
		
		List<Answer__c> answers = new List<Answer__c>();
		List<ContentDocumentLink> links = new List<ContentDocumentLink>();

		List<ContentVersion> updatedCVRecords = ContentVersionsSelector.newInstance().selectById(cv_recordIds);

		for(ContentVersion cv : updatedCVRecords) {

			Answer__c answer = new Answer__c(
				UUID__c = cv.Answer_UUID__c,
				ContentDocument__c = cv.ContentDocumentId,
				ContentVersion__c = cv.Id,
				Question__c = cv.Question__c,
				Response__c = cv.Response__c
			);
			
			answers.add(answer); 

			ContentDocumentLink formLink = new ContentDocumentLink(
				ContentDocumentId   = cv.ContentDocumentId, //Add ContentDocumentId
				LinkedEntityId      = cv.Response__c, //Add attachment parentId
				ShareType           = 'V', //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
				Visibility          = 'AllUsers' //AllUsers, InternalUsers, SharedUsers
			);

			links.add(formLink); 

		}

		AnswerResults = Database.upsert(answers, false);  
		
		for(Answer__c answer : answers) {

			ContentDocumentLink answerLink = new ContentDocumentLink(
                ContentDocumentId   = answer.ContentDocument__c, //Add ContentDocumentId
                LinkedEntityId      = answer.Id, //Add attachment parentId
                ShareType           = 'V', //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                Visibility          = 'AllUsers' //AllUsers, InternalUsers, SharedUsers
			);
			
			links.add(answerLink); 

		}

		ContentDocumentLinkResults = Database.upsert(links, false);                
    }
}