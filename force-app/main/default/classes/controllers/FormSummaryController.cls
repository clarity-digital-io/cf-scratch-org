public with sharing class FormSummaryController {

	//create response from lightning
	@AuraEnabled
	public static Id newResponse(String formName){
		
		Form__c form = FormsService.getFormByName(formName); 
		Response__c response = ResponsesService.create(form.Id); 

		return response.Id; 

	}
	
    @AuraEnabled
    public static Form__c getForm(String recordId) {

		Form__c form = FormsService.getFormById(recordId); 

		return form; 

    }

    @AuraEnabled
    public static List<Response__c> getFormResponses(String recordId){

		List<Response__c> responses = ResponsesService.getResponsesByFormId(recordId);

        return responses; 

    }

    @AuraEnabled
    public static String deleteFormResponse(String recordId){

		Id responseId = ResponsesService.deleteById(recordId);
        
        return responseId;
    }

    @AuraEnabled
    public static String deleteForm(String recordId){

		Id formId = FormsService.deleteById(recordId);

        return formId;

	}

    @AuraEnabled
    public static Form__c publishForm(String recordId){

		Form__c form = FormsService.publishForm(recordId); 

	    return form;

    }

    @AuraEnabled(cacheable=true)
    public static  Map<String, List<Map<String, String>>> getAnswerColumns(String recordId, Integer offset){

		Map<String, List<Map<String, String>>> table = ResponsesService.getResultAnswersByFormId(recordId, offset); 

        return table;

    }
    
}
