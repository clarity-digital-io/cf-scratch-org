@RestResource(urlMapping='/api/ClarityFormsExternal/*')
global with sharing class ClarityFormsExternalController {

    @HttpGet
    global static Map<String, List<sObject>> getForm() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        String formId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        Map<String, List<sObject>> form = ClarityFormsService.create(formId);

        return form;

    }

    // @HttpPost
    // global static String submit(String responseId, List<String> answers) {
    //     return 'Test';
    // }

}
