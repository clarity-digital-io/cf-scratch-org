public with sharing class ImagesHelper {

	public static List<ContentVersion> getContentVersions(String file, String questionId, String responseId) {

		List<ContentVersion> cvs = new List<ContentVersion>(); 

		ContentVersion content = new ContentVersion(
			ContentLocation = 'S', 
			PathOnClient    = 'Image.jpeg',
			Origin          = 'H', 
			Title           = 'Image',
			Response__c 	= responseId,
			Question__c 	= questionId, 
			VersionData     = EncodingUtil.base64Decode(file) // converting your binary string to Blob
		);

		cvs.add(content); 
		
		return cvs; 
		
	}
	
}
