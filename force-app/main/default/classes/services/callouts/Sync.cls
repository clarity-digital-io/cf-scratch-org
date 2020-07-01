public class Sync {

	public static HttpResponse getOrganizationSetup(String organizationId) {

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://clarity-mobile-api.herokuapp.com/information/' + organizationId);
		request.setHeader('Content-Type', 'application/json');
		request.setMethod('POST');

		HttpResponse response = http.send(request);
		return response; 

	}

	public static HttpResponse connectOrganization(Connect connect, String organizationId) {

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://clarity-mobile-api.herokuapp.com/connect/' + organizationId);
		request.setBody(JSON.serialize(connect));
		request.setHeader('Content-Type', 'application/json');
		request.setMethod('POST');
		HttpResponse response = http.send(request);

		return response; 

	}

	public static HttpResponse registerUsers(List<String> users, String organizationId) {

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://clarity-mobile-api.herokuapp.com/register/' + organizationId );
		request.setBody(JSON.serialize(users));
		request.setHeader('Content-Type', 'application/json');
		request.setMethod('POST');
		request.setTimeout(20000);
		HttpResponse response = http.send(request);
		return response; 

	}

	@future(callout=true) 
	public static void process(String userId) {

		//need a way to query for lookups / connections / record groups we will need

		List<Account> accounts = [SELECT Id, Name, OwnerId, Type, LastModifiedDate, CreatedDate FROM Account];
		
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://clarity-mobile-api.herokuapp.com/sync/' + userId );
		request.setBody(JSON.serialize(accounts));
		request.setHeader('Content-Type', 'application/json');
		request.setMethod('POST');
		HttpResponse response = http.send(request);

	}
}


