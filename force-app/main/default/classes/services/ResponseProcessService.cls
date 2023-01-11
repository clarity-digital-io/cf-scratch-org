public with sharing class ResponseProcessService {
  public static void saveConnectionProcess(
    Form_Connection_Process__c connectionProcess
  ) {
    service().saveConnectionProcess(connectionProcess);
  }

  public static void saveResponse(List<Response__c> responses) {
    service().saveResponse(responses);
  }

  public static IResponseProcessService service() {
    return (IResponseProcessService) Application.service.newInstance(
      IResponseProcessService.class
    );
  }
}
