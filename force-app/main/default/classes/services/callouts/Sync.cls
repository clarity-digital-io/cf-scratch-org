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

	public static HttpResponse connectOrganization(Connect connect, String organizationId) {

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

	public static HttpResponse registerUsers(List<String> users, String organizationId) {

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

	@future(callout=true) 
	public static void process(String userId) {

		Mobile_API__mdt api = getAPI();
		//need a way to query for lookups / connections / record groups we will need
		List<Account> accounts = [SELECT Id, Name, OwnerId, Type, LastModifiedDate, CreatedDate FROM Account];
		
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(api.URL__c + '/sync/' + userId );
		request.setBody(JSON.serialize(accounts));
		request.setHeader('Content-Type', 'application/json');
		request.setMethod('POST');
		HttpResponse response = http.send(request);

	}
}


