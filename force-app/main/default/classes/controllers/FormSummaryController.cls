public with sharing class FormSummaryController {
  @AuraEnabled
  public static Form__c getForm(String recordId) {
    Form__c form = FormsService.getFormById(recordId);

    return form;
  }

  @AuraEnabled
  public static List<Response__c> getFormVersionResponses(
    String formVersionId
  ) {
    List<Response__c> responses = ResponsesService.getResponsesByFormVersionId(
      formVersionId
    );

    return responses;
  }

  // @AuraEnabled
  // public static List<Response__c> getFormResponses(String formId) {
  //   List<Response__c> responses = ResponsesService.getResponsesByFormId(formId);

  //   return responses;
  // }

  @AuraEnabled
  public static String deleteFormResponse(String responseId) {
    Id deletedResponseId = ResponsesService.deleteById(responseId);

    return deletedResponseId;
  }

  @AuraEnabled
  public static String deleteForm(String formId) {
    Id deletedFormId = FormsService.deleteById(formId);

    return deletedFormId;
  }

  @AuraEnabled
  public static Form__c publishForm(String formId) {
    Form__c form = FormsService.publishForm(formId);

    return form;
  }

  @AuraEnabled
  public static Form__c setToDraft(String recordId) {
    Form__c form = FormsService.setToDraft(recordId);

    return form;
  }

  @AuraEnabled(cacheable=true)
  public static Map<String, List<Map<String, String>>> getAnswerColumns(
    String recordId,
    Integer offset
  ) {
    Map<String, List<Map<String, String>>> table = ResponsesService.getResultAnswersByFormVersionId(
      recordId,
      offset
    );

    return table;
  }
}
