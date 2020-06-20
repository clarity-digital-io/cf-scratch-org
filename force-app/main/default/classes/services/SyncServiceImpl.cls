public class SyncServiceImpl implements ISyncService {
	
	public static void process(String userId) {

		System.debug('requests: ' + userId); 
		sync(userId); 
		
	}

	@future(callout=true) 
	public static void sync(String userId) {
		//query sobjects + fields that need to be included
		List<Account> accounts = [SELECT Id, Name, OwnerId, Type, LastModifiedDate, CreatedDate FROM Account];
		
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('http://thawing-falls-33419.herokuapp.com/sync/' + userId );
		request.setBody(JSON.serialize(accounts));
		request.setHeader('Content-Type', 'application/json');
		request.setMethod('POST');
		HttpResponse response = http.send(request);
		
	}

}
