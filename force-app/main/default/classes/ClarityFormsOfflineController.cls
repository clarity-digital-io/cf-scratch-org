@RestResource(urlMapping='/api/ClarityFormsOffline/*')
global with sharing class ClarityFormsOfflineController {

    @HttpPost
    global static void getOfflineRecords() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        String sForms = RestContext.request.requestBody.toString();

        Map<String, List<String>> parsedForms = (Map<String, List<String>>)JSON.deserialize(sForms, Map<String, List<String>>.class);

        System.debug(parsedForms);

    }

}
