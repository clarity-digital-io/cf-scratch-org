public class ClaritySurveyRequest {

    @Future(callout=true)
    public static void send(String records){

        HttpRequest req = new HttpRequest(); 
        
        ClaritySurvey__mdt clarityCallout = [SELECT APIKey__c, Endpoint__c FROM ClaritySurvey__mdt];

        req.setEndpoint(clarityCallout.Endpoint__c);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        //req.setHeader('client-id', clarityCallout.ClientId__c); 
        req.setHeader('api-key', clarityCallout.APIKey__c); 
        req.setBody(records);

        sendRequest(req); 

    }

    public static void sendRequest(HttpRequest req){

        HttpResponse response = new HttpResponse();

        try {

			Http http = new Http();
			response = http.send(req);

			Integer statusCode = response.getStatusCode();

			if(statusCode == null || statusCode == 200) {
                
                ClaritySurveyHandler.log(response.getBody()); 

			}

		} catch (System.CalloutException e) {

            System.debug('ERROR NEW: ' + e.getMessage()); 

		}

    }

}
