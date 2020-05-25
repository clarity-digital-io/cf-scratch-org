public with sharing class MobileService {

	
	public static Map<String, Map<String, sObject>> getMobileRecords() {

		Map<String, Map<String, sObject>> records = new Map<String, Map<String, sObject>>(); 

		List<Form__c> forms = [SELECT Id FROM Form__c WHERE Status__c = 'Published'];

		List<Id> formIds = new List<Id>(); 

		for (Form__c form : forms) {
			formIds.add(form.Id); 
		}

		List<Form_Connection__c> formConnections = [SELECT Id, Form__c, Salesforce_Object__c, New__c, 
		(SELECT Id, Salesforce_Field__c, PreFill__c, Custom_Value__c, Question__c FROM Form_Connection_Fields__r) 
		FROM Form_Connection__c WHERE Form__c IN :formIds];


		Map<String, Set<String>> objectFields = new Map<String, Set<String>>(); 

		for(Form_Connection__c formConnection : formConnections) {

			for(Form_Connection_Field__c field : formConnection.Form_Connection_Fields__r) {
							
				if(objectFields.get(formConnection.Salesforce_Object__c) != null) {

					Set<String> fields = objectFields.get(formConnection.Salesforce_Object__c); 
					fields.add(field.Salesforce_Field__c);
					objectFields.put(formConnection.Salesforce_Object__c, fields); 

				} else {

					Set<String> fields = new Set<String>();

					if(formConnection.Salesforce_Object__c == 'Case') {
						fields.add('Subject');
					} else {
						fields.add('Name');
					}

					fields.add('Id');
					fields.add(field.Salesforce_Field__c);
					
					objectFields.put(formConnection.Salesforce_Object__c, fields); 

				}
            }
			
		}

		Integer limitCount = 0;

		for(String objectName : objectFields.keySet()) {

			if(limitCount > 10) {
				continue; 
			}

			List<String> sFields = new List<String>(); 

			Set<String> fields = objectFields.get(objectName); 

			String joinedFields = '';

			for(String field : fields) {
				sFields.add(field);
			}

			if(sFields.size() > 0) {
				joinedFields = String.join(sFields, ', ');
				joinedFields = joinedFields.removeEnd(',');
			} 
			System.debug('joinedFields: ' + joinedFields); 
			String sQuery = 'SELECT ' + joinedFields + ' FROM ' + objectName + ' LIMIT 50';

			List<sObject> results = Database.query(sQuery);

			Map<String, sObject> sObjectRecords = new Map<String, sObject>(); 

			for(SObject result : results) {
				sObjectRecords.put(result.Id, result);
			} 

			records.put(objectName, sObjectRecords);

			limitCount = limitCount + 1; 

		}

		return records;
	}

	public static Map<String, Map<String, List<sObject>>> getMobileForms() {

        Map<String, Map<String, List<sObject>>> formDetails = new Map<String, Map<String, List<sObject>>>(); 

        /**
        * Grab Forms
        **/
        List<Form__c> forms = [SELECT Id, Name, Limit__c, Status__c, End_Date__c, Multi_Page__c, Multi_Page_Info__c, Multi_Page_Val__c FROM Form__c WHERE Status__c = 'Published'];
		
		if(forms.size() == 0) {
			return formDetails; 
		}

        List<Id> formIds = new List<Id>(); 

        for(Form__c form : forms) {
            formIds.add(form.Id); 
        }

        /**
        * Grab Form Questions 
        **/
        Map<Id, List<Question__c>> questionsByForms = new Map<Id, List<Question__c>>();

        List<Question__c> questions = [SELECT Id, Form__c, 
            (SELECT Id, Label__c, Active_Flow__c FROM Question_Options__r), 
            (SELECT Id, Active__c, Form_Submission__c FROM Flow_Designs__r LIMIT 1),
            Title__c, Order__c, Required__c, Lookup__c, Record_Group__c, Type__c FROM Question__c WHERE Form__c IN :formIds];

        for(Question__c question : questions) {
            
            if(questionsByForms.get(question.Form__c) != null) {

                questionsByForms.get(question.Form__c).add(question); 

            } else {

                questionsByForms.put(question.Form__c, new List<Question__c>{ question }); 

            }

        }

        /**
        * Grab Form Connections Mapping Fields & Prefilled Fields
        **/

        Map<Id, List<Form_Connection_Field__c>> prefillFieldsByForms = new Map<Id, List<Form_Connection_Field__c>>();
        Map<Id, List<Form_Connection_Field__c>> mappingFieldsByForms = new Map<Id, List<Form_Connection_Field__c>>();

        List<Form_Connection__c> formConnections = [SELECT Id, Form__c, Salesforce_Object__c, New__c, 
            (SELECT Id, Salesforce_Field__c, PreFill__c, Custom_Value__c, Question__c FROM Form_Connection_Fields__r) 
            FROM Form_Connection__c WHERE Form__c IN :formIds AND New__c = false];

        for(Form_Connection__c formConnection : formConnections) {

            List<Form_Connection_Field__c> prefillFields = new List<Form_Connection_Field__c>(); 
            List<Form_Connection_Field__c> mappingFields = new List<Form_Connection_Field__c>(); 

            for(Form_Connection_Field__c connectionField : formConnection.Form_Connection_Fields__r) {

                if(connectionField.PreFill__c) {

                    prefillFields.add(connectionField);

                } else {

                    mappingFields.add(connectionField);

                }
            }

            if(prefillFieldsByForms.get(formConnection.Form__c) != null) {

                prefillFieldsByForms.get(formConnection.Form__c).addAll(prefillFields); 

            } else {

                prefillFieldsByForms.put(formConnection.Form__c, prefillFields); 

            }

            if(mappingFieldsByForms.get(formConnection.Form__c) != null) {

                mappingFieldsByForms.get(formConnection.Form__c).addAll(mappingFields); 

            } else {

                mappingFieldsByForms.put(formConnection.Form__c, mappingFields); 

            }
        }

        for(Form__c form : forms) {

            Map<String, List<sObject>> formDetail = new Map<String, List<sObject>>();
        
            formDetail.put('Form', new List<sObject>{ form });
            formDetail.put('Questions', questionsByForms.get(form.Id));

            //Make grab existing form responses and bring those back?

            formDetail.put('Mapping', mappingFieldsByForms.get(form.Id));
            formDetail.put('Prefills', prefillFieldsByForms.get(form.Id));

            formDetails.put(form.Id, formDetail); 

        }

        return formDetails; 
        
	}

	public static Map<String, Map<String, List<sObject>>> getMobileResponses() {

		Map<String, Map<String, List<sObject>>> responseDetails = new Map<String, Map<String, List<sObject>>>(); 

		List<sObject> records = new  List<sObject>(); 

		List<Response__c> responses = [SELECT Id, Form__c, Status__c, OwnerId__c FROM Response__c];

		Set<Id> responseIds = new Set<Id>();

		for(Response__c response : responses) {
			responseIds.add(response.Id); 
		}

		//Answers by responseId
		Map<Id, List<Answer__c>> answersByResponseId = new Map<Id, List<Answer__c>>();

		List<Answer__c> answers = [SELECT Id, Name, Record__c, Answer__c, Date_Answer__c, ContentVersion__c, ContentDocument__c, 
			Question__r.Salesforce_Object__c, Response__c, Question__c, 
			Question__r.Record_Group__c, Question__r.Type__c  
			FROM Answer__c WHERE Response__c IN :responseIds];

		for(Answer__c answer : answers) {

			if(answersByResponseId.get(answer.Response__c) != null) {
				List<Answer__c> responseAnswers = answersByResponseId.get(answer.Response__c);
				responseAnswers.add(answer); 
				answersByResponseId.put(answer.Response__c, responseAnswers);
			} else {
				answersByResponseId.put(answer.Response__c, new List<Answer__c>{ answer });
			}

		}

		Map<String, Map<String, List<sObject>>> forms = getMobileForms();

		if(forms.size() == 0) {
			return responseDetails;
		}

		for(Response__c response : responses) {
			
			Map<String, List<sObject>> formDetail = forms.get(response.Form__c);

			List<Answer__c> responseAnswers = answersByResponseId.get(response.Id); 

			formDetail.put('Answers', responseAnswers); 
			formDetail.put('Response', new List<Response__c>{ response });
			
			responseDetails.put(response.Id, formDetail);

		}

		return responseDetails; 
		
	}

}

