@isTest
public class AttachmentsResourceUnitTest {

	@TestSetup
	public static void setup(){
		
		Form__c form = TestDataFactory.generateForm(); 

		Form__c updatedForm = FormsService.updateForm(form);

		List<Question__c> newQuestions = TestDataFactory.generateAttachmentQuestions(form, 5);

		List<Question__c> questions = QuestionsService.saveQuestions(newQuestions);

		updatedForm.Status__c = 'Published';

		Form__c publishedForm = FormsService.updateForm(updatedForm);

		Response__c response = ResponseController.createResponse( publishedForm.Id, JSON.serialize(new Map<String, String>()) );

	}

	@isTest
	public static void shouldUpdateAttachments() {
		
		Response__c response = [SELECT Id, UUID__c FROM Response__c LIMIT 1];

		List<Question__c> questions = [SELECT Id FROM Question__c LIMIT 5];

		Map<String, String> data = new Map<String, String>();

		List<Attachment> attachments = new List<Attachment>();

		for(Question__c question : questions) {
			
			Attachment attachment = new Attachment();

			attachment.UUID = 'UUID-' + question.Id;
			attachment.Name = 'Test';
			attachment.Base64 = 'Base64';
			attachment.Question = question.Id;
			attachment.Response = response.UUID__c;
			attachment.Path = 'Path';

			attachments.add(attachment); 

		}

		data.put('data', JSON.serialize(attachments));

		RestRequest request = new RestRequest();

		request.httpMethod = 'POST';
		request.requestBody = Blob.valueOf(JSON.serialize(data));

		RestContext.request = request;

		AttachmentsResource.updateAttachments();

		List<Answer__c> updatedAttachments = [SELECT Id, ContentVersion__c FROM Answer__c];
		
		System.assertEquals(attachments.size(), updatedAttachments.size());

		List<ContentVersion> cvs = [SELECT Id FROM ContentVersion];

		System.assertEquals(attachments.size(), cvs.size());

	} 
	
}
