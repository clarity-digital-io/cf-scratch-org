@RestResource(urlMapping='/api/ClarityForm/*')
global with sharing class ClarityFormService {

    @HttpGet
    global static Map<String, Clarity_Form__c> getForms() {

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        Map<String, Map<Clarity_Form__c, List<Clarity_Form_Question__c>>> formNames = new Map<String, Map<Clarity_Form__c, List<Clarity_Form_Question__c>>>(); 

        List<Clarity_Form__c> forms = [SELECT Id, Name, Limit__c, End_Date__c, Clarity_Form_Style__r.Multi_Page__c, 
            Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Color__c 
            FROM Clarity_Form__c];

        for(Clarity_Form__c form : forms) {
            formNames.put(form.Name, new Map<Clarity_Form__c, List<Clarity_Form_Question__c>>{ form, new List<Clarity_Form_Question__c>() }); 
        }

        return formNames;

    }

}
