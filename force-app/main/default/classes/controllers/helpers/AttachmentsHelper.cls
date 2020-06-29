public with sharing class AttachmentsHelper {

	public static List<ContentVersion> getContentVersions(String fileName, String file, String questionId, String responseId) {

		List<ContentVersion> cvs = new List<ContentVersion>(); 

		ContentVersion content = new ContentVersion(
			ContentLocation = 'S', 
			PathOnClient    = fileName,
			Origin          = 'H', 
			Title           = fileName,
			Response__c 	= responseId,
			Question__c 	= questionId, 
			VersionData     = EncodingUtil.base64Decode(file) // converting your binary string to Blob
		);

		cvs.add(content); 
		
		return cvs; 
		
	}
	
}
