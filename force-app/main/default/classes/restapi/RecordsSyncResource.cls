@RestResource(urlMapping='/v1/Records/*')
global with sharing class RecordsSyncResource {
  @HttpGet
  global static String getRecords() {
    RestRequest req = RestContext.request;

    RestResponse res = RestContext.response;

    SyncService.process(UserInfo.getUserId());

    return 'In Progress';
  }
}
