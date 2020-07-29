global with sharing class BuilderController {

	@RemoteAction
    global static List<String> save(String sQuestions){

        List<Question__c> parsedQuestions = (List<Question__c>)JSON.deserialize(sQuestions, List<Question__c>.class);
		
		List<Question__c> questions = QuestionsService.saveQuestions(parsedQuestions);

		List<String> saved = new List<String>();

		for(SObject question : questions) {
			saved.add((ID)question.get('Id'));
		}

		return saved; 
		
	}

	@RemoteAction
    global static Form__c getForm(String formId) {
		
		Form__c form = FormsService.getFormById(formId);

		return form;

    }
	
	@RemoteAction
    global static Form__c updateForm(String sForm) {

		Form__c parsedForm = (Form__c)JSON.deserialize(sForm, Form__c.class);

		Form__c form = FormsService.updateForm(parsedForm);

        return parsedForm;
    
	}
	
	@RemoteAction
    global static List<Question__c> getQuestions(String formId){

		List<Question__c> questions = QuestionsService.getFormQuestions((Id)formId); 
		
        return questions; 

	}
	
	@RemoteAction
    global static String saveQuestion(String sQuestion) {

		Question__c parsedQuestion = (Question__c)JSON.deserialize(sQuestion, Question__c.class);
		
		List<Question__c> questions = QuestionsService.saveQuestions(new List<Question__c> { parsedQuestion });

		List<String> saved = new List<String>();
		
		for(SObject question : questions) {
			saved.add((ID)question.get('Id'));
		}

		return saved[0]; 

	}

	@RemoteAction
    global static Map<String, List<sObject>> saveQuestionWithOptions(String sQuestion, String sQuestionOptions) {

		Question__c parsedQuestion = (Question__c)JSON.deserialize(sQuestion, Question__c.class);

		List<Question_Option__c> parsedQuestionOptions = (List<Question_Option__c>)JSON.deserialize(sQuestionOptions, List<Question_Option__c>.class);

        Map<String, List<sObject>> results = QuestionsService.saveQuestionWithDetails(parsedQuestion, parsedQuestionOptions);
		
		return results;

	}

	@RemoteAction
    global static Map<String, List<sObject>> saveQuestionWithCriteria(String sQuestion, String sCriteria) {

		Question__c parsedQuestion = (Question__c)JSON.deserialize(sQuestion, Question__c.class);

        List<Question_Criteria__c> parsedCriteria = (List<Question_Criteria__c>)JSON.deserialize(sCriteria, List<Question_Criteria__c>.class);

        Map<String, List<sObject>> results = QuestionsService.saveQuestionWithCriteriaDetails(parsedQuestion, parsedCriteria);
		
        return results;
        
	}
	
	@RemoteAction
    global static List<Question__c> saveRecordGroupFields(String sRecordGroupFields, String relatedRecordGroupId) {

		List<Question__c> parsedRecordGroupFields = (List<Question__c>)JSON.deserialize(sRecordGroupFields, List<Question__c>.class);

		List<Question__c> recordGroupQuestions = QuestionsService.saveRecordGroup(parsedRecordGroupFields, relatedRecordGroupId); 

		return recordGroupQuestions; 

	}

	@RemoteAction
    global static List<Form_Connection__c> getConnections(String formId){

		List<Form_Connection__c> connections = FormConnectionsService.getConnectionsByFormId(formId); 
		
		return connections; 
		
	}

	@RemoteAction
    global static Map<String, List<Object>> getConnectionFieldMapping(String connectionId, String objectType) {

        Map<String, List<Object>> fieldMapping = new Map<String, List<Object>>(); 
	
		List<Form_Connection_Field__c> connectionFields = FormConnectionFieldsService.getByConnectionId(connectionId); 

        List<Form_Connection_Field__c> mappingFields = new List<Form_Connection_Field__c>(); 
        List<Form_Connection_Field__c> prefillFields = new List<Form_Connection_Field__c>(); 

        for(Form_Connection_Field__c connectionField : connectionFields) {
            if(connectionField.PreFill__c) {
                prefillFields.add(connectionField);
            } else {
                mappingFields.add(connectionField);
            }
        }
        
        SObjectType sObjType = ((SObject)Type.forName(objectType).newInstance()).getSObjectType();

        Schema.DescribeSObjectResult result = sObjType.getDescribe();

        Map<String, Schema.SObjectField> fields = result.fields.getMap();      

        List<String> sObjectFields = new List<String>();   

        for(String fieldName : fields.keySet()) { 

            Schema.SObjectField field = fields.get(fieldName);

            Schema.DescribeFieldResult fieldResult = field.getDescribe();

            Schema.DisplayType type = fieldResult.getType();

            List <Schema.sObjectType> reference = fieldResult.getReferenceTo();
            Boolean isFieldCreateable = fieldResult.isCreateable(); 

            if(isFieldCreateable) {

                sObjectFields.add('' + field);

            }

        }

        sObjectFields.add('Id');

        fieldMapping.put('Mapping', mappingFields);
        fieldMapping.put('Prefills', prefillFields);
        fieldMapping.put('Fields', sObjectFields);

        return fieldMapping;

    }
	
	@RemoteAction
    global static List<Form_Connection__c> saveConnections(List<String> connect) {

        String sConnections = connect[0];
        String formId = connect[1]; 
        String sRemoved = connect[2];

		List<Form_Connection__c> parsedConnections = (List<Form_Connection__c>)JSON.deserialize(sConnections, List<Form_Connection__c>.class);

		List<Form_Connection__c> removedParsedConnections = (List<Form_Connection__c>)JSON.deserialize(sRemoved, List<Form_Connection__c>.class);
		
		List<Form_Connection__c> validatedConnections = new List<Form_Connection__c>();

		for(Form_Connection__c parsedConnection : parsedConnections) {
			if(parsedConnection.Salesforce_Object__c != '') {
				validatedConnections.add(parsedConnection);
			}
		}

		List<Form_Connection__c> updatedConnections = FormConnectionsService.save(removedParsedConnections, validatedConnections); 

        return updatedConnections; 

    }

	@RemoteAction
    global static Map<String, List<Object>> saveActiveFieldConnections(String sActiveConnectionFields, String connectionId) {

		Map<String, List<Object>> fieldMapping = new Map<String, List<Object>>(); 

		List<Form_Connection_Field__c> parsedConnectionFields = (List<Form_Connection_Field__c>)JSON.deserialize(sActiveConnectionFields, List<Form_Connection_Field__c>.class);

		List<Form_Connection_Field__c> updatedConnectionFields = FormConnectionFieldsService.updateFields(parsedConnectionFields, connectionId);

        List<Form_Connection_Field__c> mappingFields = new List<Form_Connection_Field__c>(); 
        List<Form_Connection_Field__c> prefillFields = new List<Form_Connection_Field__c>(); 

        for(Form_Connection_Field__c connectionField : parsedConnectionFields) {
            if(connectionField.PreFill__c) {
                prefillFields.add(connectionField);
            } else {
                mappingFields.add(connectionField);
            }
        }
        
        fieldMapping.put('Mapping', mappingFields);
        fieldMapping.put('Prefills', prefillFields);

		return fieldMapping; 

	}

    @RemoteAction 
    global static List<Question__c> pageQuestionsDelete(String sQuestions, String formId) {

		List<Question__c> parsedQuestions = (List<Question__c>)JSON.deserialize(sQuestions, List<Question__c>.class);

		List<Question__c> questions = QuestionsService.deleteQuestions(parsedQuestions, formId); 

		return questions;
   
	}
	
	@RemoteAction 
    global static List<Question__c> deleteQuestion(String sQuestions, String sDeleteQuestionId) {
		
		Id questionId = (Id)sDeleteQuestionId;

		Question__c questionToDelete = (Question__c)questionId.getSobjectType().newSObject((Id)sDeleteQuestionId);

		List<Question__c> parsedQuestions = (List<Question__c>)JSON.deserialize(sQuestions, List<Question__c>.class);
		
		List<Question__c> updatedQuestions = QuestionsService.deleteQuestion(parsedQuestions, questionToDelete);

		return updatedQuestions;
		
	}

	@RemoteAction
    global static List<String> getSObjectsAvailable() {

        List<String> lookups = new List<String>(); 

        Map<String, Schema.SObjectType> sObjectsAvailable = Schema.getGlobalDescribe();

        for(Schema.SObjectType so : sObjectsAvailable.values()) {
			//checkfls
			
			if(so.getDescribe().isCreateable() && so.getDescribe().isUpdateable() && so.getDescribe().isAccessible()) {
				lookups.add(so.getDescribe().getName());
			}
        
        }

        return lookups; 

	}
	
	@RemoteAction
    global static Map<String, Map<String, Map<String, String>>> getSObjectFields(String objectType) {

        SObjectType sObjType = ((SObject)Type.forName(objectType).newInstance()).getSObjectType();

        Schema.DescribeSObjectResult result = sObjType.getDescribe();

        Map<String, Schema.SObjectField> fields = result.fields.getMap();

        Map<String, Map<String, Map<String, String>>> requiredFields = new Map<String, Map<String, Map<String, String>>>();

        requiredFields.put('Required', new Map<String, Map<String, String>>());
        requiredFields.put('NotRequired', new Map<String, Map<String, String>>());

        for(String fieldName : fields.keySet()) { 

            Schema.SObjectField field = fields.get(fieldName);

            Schema.DescribeFieldResult fieldResult = field.getDescribe();

            String relationshipName = fieldResult.getRelationshipName();

            String referenceName = null; 

            if(relationshipName != null) {
                for(Schema.SObjectType reference : fieldResult.getReferenceTo()) {
                    referenceName = reference.getDescribe().getName();
                }
            }

            Schema.DisplayType type = fieldResult.getType();

            Boolean isFieldReq  = fieldResult.isNillable();
            Boolean isFieldCreateable = fieldResult.isCreateable(); 
			Boolean isDefaultedOnCreate = fieldResult.isDefaultedOnCreate();
			Boolean isAccessible = fieldResult.isAccessible();
			Boolean isUpdateable = fieldResult.isUpdateable();

            if(!isFieldReq && isFieldCreateable && !isDefaultedOnCreate && isAccessible) {

                requiredFields.get('Required').put('' + field, new Map<String, String>{ '' + type => '' + referenceName });

            } else if(isFieldCreateable && !isDefaultedOnCreate && isAccessible && isUpdateable) {

                requiredFields.get('NotRequired').put('' + field, new Map<String, String>{ '' + type => '' + referenceName });

            }

        }

        return requiredFields; 

    }

}
