public class Sync {
  public static Mobile_API__mdt getAPI() {
    Mobile_API__mdt api = [SELECT URL__c FROM Mobile_API__mdt LIMIT 1];
    return api;
  }

  public static HttpResponse getOrganizationSetup(String organizationId) {
    Mobile_API__mdt api = getAPI();

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(api.URL__c + '/information/' + organizationId);
    request.setHeader('Content-Type', 'application/json');
    request.setMethod('POST');

    HttpResponse response = http.send(request);
    return response;
  }

  public static HttpResponse connectOrganization(
    Connect connect,
    String organizationId
  ) {
    Mobile_API__mdt api = getAPI();

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(api.URL__c + '/connect/' + organizationId);
    request.setBody(JSON.serialize(connect));
    request.setHeader('Content-Type', 'application/json');
    request.setMethod('POST');
    HttpResponse response = http.send(request);

    return response;
  }

  public static HttpResponse registerUsers(
    List<String> users,
    String organizationId
  ) {
    Mobile_API__mdt api = getAPI();

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(api.URL__c + '/register/' + organizationId);
    request.setBody(JSON.serialize(users));
    request.setHeader('Content-Type', 'application/json');
    request.setMethod('POST');
    HttpResponse response = http.send(request);
    return response;
  }

  public static HttpResponse connectPublishedForms(
    Connect connect,
    String organizationId
  ) {
    Mobile_API__mdt api = getAPI();

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(api.URL__c + '/forms/' + organizationId);
    request.setBody(JSON.serialize(connect));
    request.setHeader('Content-Type', 'application/json');
    request.setMethod('POST');
    HttpResponse response = http.send(request);

    return response;
  }

  public static void process(String userId, List<sObject> records) {
    Mobile_API__mdt api = getAPI();

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(api.URL__c + '/sync/' + userId);
    request.setBody(JSON.serialize(records));
    request.setHeader('Content-Type', 'application/json');
    request.setMethod('POST');
    HttpResponse response = http.send(request);
  }
}

//accounts
//for apps we can get the last 500 on modified/created
//on apps section can set to online mode and query from salesforce if offline or essentials (not primary salesforce) get from realm

//connection
//this is for offline mode
//get latest 500 records for

//question
//this is for offline mode
//get latest 500 records for

