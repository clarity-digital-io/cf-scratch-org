public class ClaritySurveyRequest {

    @Future(callout=true)
    public static void send(String records){

        HttpRequest req = new HttpRequest(); 

        req.setEndpoint('callout:ClaritySurvey/process');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(records);
        System.debug('req: ' + req);
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
