@RestResource(urlMapping='/v1/Jobs/*')
global with sharing class JobsResource {
	
	@HttpPost
    global static String updateJob() {

        RestRequest req = RestContext.request;

		RestResponse res = RestContext.response;
		
		String[] uriParts = req.requestURI.split('/');

        return 'Success';

	}

}