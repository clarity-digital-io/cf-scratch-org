@RestResource(urlMapping='/v1/Attachments/*')
global with sharing class AttachmentsResource {
  @HttpPost
  global static List<Answer__c> updateAttachments() {
    RestRequest req = RestContext.request;

    RestResponse res = RestContext.response;

    String body = req.requestBody.toString();

    Map<String, String> data = (Map<String, String>) JSON.deserialize(
      body,
      Map<String, String>.class
    );

    String attachments = data.get('data');

    List<Attachment> parsedAttachments = (List<Attachment>) JSON.deserialize(
      attachments,
      List<Attachment>.class
    );

    List<ContentVersion> cvs = new List<ContentVersion>();

    List<String> answerIds = new List<String>();

    for (Attachment attachment : parsedAttachments) {
      ContentVersion content = new ContentVersion(
        ContentLocation = 'S',
        PathOnClient = attachment.Name,
        Origin = 'H',
        Title = attachment.Name,
        Response__r = new Response__c(UUID__c = attachment.Response),
        Answer_UUID__c = attachment.UUID,
        Question__c = attachment.Question,
        VersionData = EncodingUtil.base64Decode(attachment.Base64) // converting your binary string to Blob
      );

      answerIds.add(attachment.UUID);

      cvs.add(content);
    }

    List<Answer__c> answers = AnswersService.save(cvs, answerIds);

    return answers;
  }
}
