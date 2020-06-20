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

        List<Form__c> forms = [SELECT Id, Title__c, Label__c, Status__c, Name FROM Form__c WHERE Id =: recordId Limit 1]; 

		return forms[0]; 

    }

    @AuraEnabled
    public static List<Response__c> getFormResponses(String formId, String name, String recordId, String sObjectName){

		List<Response__c> responses = new List<Response__c>();

		if(recordId != null && sObjectName != null && sObjectName != 'Clarity') {
			responses = Database.query('SELECT Id, Name, Status__c, Completion__c, CreatedDate, Submitted_Date__c FROM Response__c WHERE (Form__c = :formId OR Form__r.Name = :name) AND' + ' Connection_' + sObjectName + '__c = :recordId');
		} else if(formId != null || name != null) {
			responses = [SELECT Id, Name, Status__c, Completion__c, CreatedDate, Submitted_Date__c FROM Response__c WHERE (Form__c = :formId OR Form__r.Name = :name)];
		}

        return responses; 

    }

    @AuraEnabled
    public static String deleteFormResponse(String responseId){
        
		Response__c response = [SELECT Id, Name FROM Response__c WHERE Id =: responseId Limit 1];
		
		Database.DeleteResult result = Database.delete(response, true); 

		if(!result.isSuccess()) {
			throw new AuraHandledException('Unable to delete response: ' + response.Name);
		}

        return responseId;
    }

    @AuraEnabled
    public static String deleteForm(String recordId){
        
        Form__c form = [SELECT Id, Name, (SELECT Id FROM Responses__r) FROM Form__c WHERE Id =: recordId Limit 1]; 

        if(form.Responses__r.size() > 0) {
            throw new AuraHandledException('Unable to delete form while it has Responses');
        }

		Database.DeleteResult result = Database.delete(form, true); 

		if(!result.isSuccess()) {
			throw new AuraHandledException('Unable to delete form: ' + form.Name);
		}

        return 'Success';

	}

    @AuraEnabled
    public static Form__c publishForm(String recordId){
        
        Form__c form = [SELECT Id, Status__c, Name FROM Form__c WHERE Id =: recordId Limit 1]; 

		form.Status__c = 'Published'; 

		Database.SaveResult result = Database.update(form, true); 

		if(!result.isSuccess()) {
			throw new AuraHandledException('Unable to publish form: ' + form.Name);
		}

	    return form;

    }

    @AuraEnabled(cacheable=true)
    public static  Map<String, List<Map<String, String>>> getAnswerColumns(String recordId){
        
        Form__c form = [SELECT Id, (SELECT Id, Name, Record_Group__c, Title__c, Type__c FROM Questions__r) 
            FROM Form__c WHERE Id =: recordId Limit 1]; 

        List<Question__c> questions = [SELECT Id, Type__c, 
            (SELECT Id, Label__c, Choice_Image__c FROM Question_Options__r) FROM Question__c WHERE Form__c =: recordId];

        Map<Id, List<Question_Option__c>> questionOptions = new Map<Id, List<Question_Option__c>>();

        for(Question__c question : questions) {

            if(question.Type__c == 'Checkbox' || question.Type__c == 'Dropdown' || question.Type__c == 'PictureChoice') {
                questionOptions.put(question.Id, question.Question_Options__r);
            }

        }

        Map<String, List<Map<String, String>>> table = new Map<String, List<Map<String, String>>>();

        List<Map<String, String>> columns = new List<Map<String, String>>();

        columns.add(new Map<String, String> { 'fieldName' => 'id' }); 

        for(Question__c question : form.Questions__r) {

            if(question.Record_Group__c == null && question.Type__c != 'RecordGroup') {

                Map<String, String> column = buildColumn(question);
                if(column.size() > 0 ) {
                    columns.add(column); 
                }

            }

        }

        table.put('Columns', columns); 

        List<Map<String, String>> rows = new List<Map<String, String>>();

        List<Response__c> responses = [SELECT Id, Name, 
            (SELECT Id, ContentDocument__c, Date_Answer__c, Answer__c, Record__c, Question__c, 
            Question__r.Type__c, Question__r.Name, ContentVersion__c  
            FROM Answers__r) FROM Response__c WHERE Form__c =: recordId AND Status__c != 'Preview'];

        for(Response__c response : responses) {
            
            Map<String, String> row = new Map<String, String>(); 

            row.put('id', response.Name);

            for(Answer__c answer : response.Answers__r) {

                if(answer.Question__r.Type__c == 'Attachments') {
                    
                    if(row.get(answer.Question__r.Name) != null) {

                        String sAttachments = row.get(answer.Question__r.Name); 

                        List<String> attachments = (List<String>)JSON.deserialize(sAttachments, List<String>.class);

                        attachments.add('/sfc/servlet.shepherd/version/download/' + answer.ContentVersion__c);

                        row.put(answer.Question__r.Name, JSON.serialize(attachments));

                    } else {

                        if(answer.ContentVersion__c != null) {
                            List<String> attachments = new List<String>{ '/sfc/servlet.shepherd/version/download/' + answer.ContentVersion__c };
                            row.put(answer.Question__r.Name, JSON.serialize(attachments));
                        }

                    }

                } else {

                    row.put(answer.Question__r.Name, buildAnswer(answer, questionOptions));

                }

            }

            rows.add(row); 

        }

        table.put('Data', rows); 

        return table;

    }
    
    public static Map<String, String> buildColumn(Question__c question) {

        Map<String, String> column = new Map<String, String>(); 

        if(question.Type__c != 'FreeText') {
            
            column.put('id', question.Id);
            column.put('label', question.Title__c);
            column.put('fieldName', question.Name);
            column.put('type', question.Type__c.toLowerCase());

        }

        return column; 

    }

    public static String buildAnswer(Answer__c answer, Map<Id, List<Question_Option__c>> questionOptions) {

        switch on answer.Question__r.Type__c {
            when 'PictureChoice','Checkbox','Dropdown' {

                String value = '';

				List<Question_Option__c> options = new List<Question_Option__c>();
				
				if( questionOptions.get(answer.Question__c) != null ) {
					options = questionOptions.get(answer.Question__c);
				}
				
				List<String> answers = answer.Answer__c != null ? answer.Answer__c.split(',') : new List<String>();

                for(Question_Option__c option : options) {
					System.debug('answer: ' + answer);

					for(String splitAnswer : answers) {
						if(option.Id == splitAnswer) {
							value = value + option.Label__c + ' '; 
						}
					}

                }

                return value;

            }
            when 'Date' {
                return answer.Date_Answer__c != null ? answer.Date_Answer__c.format() : '';
            }
            when 'RecordGroup' {
                return answer.Record__c;
            }
            when 'Attachments' {
                return answer.ContentVersion__c;
			}
            when else {
                return answer.Answer__c;
            }
        }

    }

}
