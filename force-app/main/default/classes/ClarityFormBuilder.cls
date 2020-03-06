global with sharing class ClarityFormBuilder {
	
    @RemoteAction
    global static List<String> save(String sQuestions){

        List<String> saved = new List<String>(); 

        List<Clarity_Form_Question__c> parsedQuestions = (List<Clarity_Form_Question__c>)JSON.deserialize(sQuestions, List<Clarity_Form_Question__c>.class);

        List<Database.UpsertResult> results = Database.upsert(parsedQuestions, true); 

        for(Database.UpsertResult result : results) {

            if(result.isSuccess()) {
                if(result.isCreated()) {
                    saved.add(result.getId());
                }
            }

        }

        return saved; 
    }

    @RemoteAction
    global static Clarity_Form__c startup(String formId) {
        
        Clarity_Form__c form = [SELECT Id, Name, Limit__c, Status__c, End_Date__c, Clarity_Form_Style__r.Name, Clarity_Form_Style__r.Multi_Page__c, Clarity_Form_Style__r.Background_Image__c, Clarity_Form_Style__r.Background_Color__c, Clarity_Form_Style__r.Color__c, 
            Clarity_Form_Assignment__c, Clarity_Form_Assignment__r.Assign__c, Clarity_Form_Assignment__r.Default_Assign__c, Clarity_Form_Assignment__r.Name 
            FROM Clarity_Form__c WHERE Id =: formId];

        return form; 

    }

    @RemoteAction
    global static Clarity_Form__c updateForm(String sForm) {

        Clarity_Form__c parsedForm = (Clarity_Form__c)JSON.deserialize(sForm, Clarity_Form__c.class);

        Database.SaveResult result = Database.update(parsedForm, true); 

        if(!result.isSuccess()) {
            System.debug('error');
        }

        return parsedForm;
    
    }

    @RemoteAction
    global static List<Clarity_Form_Question__c> getQuestions(String recordId){

        List<Clarity_Form_Question__c> questions = [SELECT Id, Page__c, Salesforce_Object__c, Salesforce_Field__c, Record_Group__c, Required__c, Title__c, Order__c, 
            (SELECT Id, Order__c, Label__c, Choice_Image__c FROM Clarity_Form_Question_Options__r), Type__c, Clarity_Form__c, Max_Length__c, Lookup__c 
            FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: recordId];

        return questions; 

    }

    @RemoteAction
    global static List<Clarity_Form_Question_Option__c> getQuestionOptions(String sQuestionId) {

        List<Clarity_Form_Question_Option__c> options = [SELECT Id, Order__c, Active_Flow__c, Label__c, Choice_Image__c FROM Clarity_Form_Question_Option__c WHERE Clarity_Form_Question__c =: sQuestionId];

        return options; 

    }

    @RemoteAction
    global static String saveQuestion(String sQuestion) {

        Clarity_Form_Question__c parsedQuestion = (Clarity_Form_Question__c)JSON.deserialize(sQuestion, Clarity_Form_Question__c.class);

        Database.SaveResult result = Database.update(parsedQuestion, true); 

        if(!result.isSuccess()) {
            System.debug('error');
        }
        
        return result.getId();

    }

	@RemoteAction
	global static Map<String, List<sObject>> saveQuestionWithPictureOptions(List<String> optionValues) {

		String sQuestion = optionValues[0];
		String sQuestionOptions = optionValues[1];
		String sQuestionOptionImages = optionValues[2];

		Map<String, Clarity_Form_Question_Option__c> parsedOptions = (Map<String, Clarity_Form_Question_Option__c>)JSON.deserialize(sQuestionOptions, Map<String, Clarity_Form_Question_Option__c>.class);

		List<Clarity_Form_Question_Option__c> options = new List<Clarity_Form_Question_Option__c>();

		for(Clarity_Form_Question_Option__c option : parsedOptions.values()) {
			options.add(option);
		}

		String sQuestionOptionsList = JSON.serialize(options);
		Map<String, List<sObject>> savedOptions = saveQuestionWithOptions(sQuestion, sQuestionOptionsList);

		Map<String, Clarity_Form_Question_Option__c> savedParsedOptions = new Map<String, Clarity_Form_Question_Option__c>();
		for(String result : savedOptions.keySet()) {
			if(result == 'Options') {
				List<sObject> recentlySavedOptions = savedOptions.get(result);
				for(Clarity_Form_Question_Option__c so : (List<Clarity_Form_Question_Option__c>)recentlySavedOptions) {
					Integer order = so.Order__c.intValue(); 
					savedParsedOptions.put(order.format(), so); 
				}
			}
		}

		Map<String, String> parsedOptionImages = (Map<String, String>)JSON.deserialize(sQuestionOptionImages, Map<String, String>.class);

		if(parsedOptionImages.size() > 0) {

			Clarity_Form_Question__c parsedQuestion = (Clarity_Form_Question__c)JSON.deserialize(sQuestion, Clarity_Form_Question__c.class);
	
			Map<String, ContentVersion> contents = new Map<String, ContentVersion>();

			for(String optionId : parsedOptionImages.keySet()) {
				
				String img = parsedOptionImages.get(optionId); 
				
				ContentVersion content = new ContentVersion(
					ContentLocation = 'S', 
					PathOnClient    = 'Image.jpeg',
					Origin          = 'H', 
					Title           = 'Image',
					Clarity_Form__c = parsedQuestion.forms__Clarity_Form__c,
					VersionData     = EncodingUtil.base64Decode(img) // converting your binary string to Blob
				);

				contents.put(optionId, content);
			}

			List<ContentVersion> cvSaves = new List<ContentVersion>();

			for(ContentVersion cv : contents.values()) {
				cvSaves.add(cv);
			}

			List<Database.SaveResult> contentResults = Database.insert(cvSaves, true); 

			for(Database.SaveResult contentResult : contentResults) {
	
				if(!contentResult.isSuccess()) {
					System.debug('error');
				}
	
			}

			List<Clarity_Form_Question_Option__c> updateOptions = new List<Clarity_Form_Question_Option__c>();

			for(String optionId : contents.keySet()) {
				ContentVersion cv = contents.get(optionId); 
				System.debug('savedParsedOptions: ' + savedParsedOptions); 
				if(savedParsedOptions.get(optionId) != null) {
					Clarity_Form_Question_Option__c option = savedParsedOptions.get(optionId);

					option.Choice_Image__c = cv.Id; 
	
					updateOptions.add(option); 
				}
				
			}

			List<Database.SaveResult> optionsResults = Database.update(updateOptions, true); 

			for(Database.SaveResult optionsResult : optionsResults) {
	
				if(!optionsResult.isSuccess()) {
					System.debug('error');
				}
	
			}

			List<ContentVersion> cvUpdates = new List<ContentVersion>();

			Set<Id> cvIds = new Set<Id>();

			for(ContentVersion cv : cvSaves) {
				cv.OwnerId = UserInfo.getUserId();
				cvUpdates.add(cv); 
				cvIds.add(cv.Id); 
			}

			List<Database.SaveResult> updateContentResults = Database.update(cvUpdates, true); 

			for(Database.SaveResult updateContentResult : updateContentResults) {
	
				if(!updateContentResult.isSuccess()) {
					System.debug('error');
				}
	
			}

			Map<Id, ContentVersion> createdContentVersions = new Map<Id, ContentVersion>([SELECT Id, Title, ContentSize, ContentDocumentId FROM ContentVersion WHERE Id IN :cvIds]);

			List<ContentDocumentLink> links = new List<ContentDocumentLink>(); 

			for(Id cvId : createdContentVersions.keySet()) {
			
				ContentVersion cv = createdContentVersions.get(cvId); 

				ContentDocumentLink formLink = new ContentDocumentLink(
					ContentDocumentId   = cv.ContentDocumentId, //Add ContentDocumentId
					LinkedEntityId      = parsedQuestion.Clarity_Form__c, //Add attachment parentId
					ShareType           = 'V', //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
					Visibility          = 'AllUsers' //AllUsers, InternalUsers, SharedUsers
				);
	
				links.add(formLink); 

			}
	
			List<Database.SaveResult> formLinkResults = Database.insert(links, true); 

			for(Database.SaveResult formLinkResult : formLinkResults) {
				if(!formLinkResult.isSuccess()) {
					System.debug('error');
				}
			}
		
		} 

		return savedOptions; 

	}

    @RemoteAction
    global static Map<String, List<sObject>> saveQuestionWithOptions(String sQuestion, String sQuestionOptions) {

        Clarity_Form_Question__c parsedQuestion = (Clarity_Form_Question__c)JSON.deserialize(sQuestion, Clarity_Form_Question__c.class);

        Database.SaveResult resultQuestion = Database.update(parsedQuestion, true); 

        if(!resultQuestion.isSuccess()) {
            System.debug('error result');
        }

        List<Clarity_Form_Question_Option__c> currentOptions = [SELECT Id, Order__c, Active_Flow__c, Label__c, Choice_Image__c FROM Clarity_Form_Question_Option__c WHERE Clarity_Form_Question__c =: parsedQuestion.Id];

        List<Clarity_Form_Question_Option__c> parsedQuestionOptions = (List<Clarity_Form_Question_Option__c>)JSON.deserialize(sQuestionOptions, List<Clarity_Form_Question_Option__c>.class);

        Map<Id, Clarity_Form_Question_Option__c> updatedQuestionOptionsById = new Map<Id, Clarity_Form_Question_Option__c>();

        for(Clarity_Form_Question_Option__c o : parsedQuestionOptions) {
            updatedQuestionOptionsById.put(o.Id, o); 
        }

        List<Clarity_Form_Question_Option__c> notFoundInParsedQuestionOptions = new List<Clarity_Form_Question_Option__c>();

        for(Clarity_Form_Question_Option__c currentOption : currentOptions) {

            if(updatedQuestionOptionsById.get(currentOption.Id) == null) {
                notFoundInParsedQuestionOptions.add(currentOption); 
            }

        }

        if(notFoundInParsedQuestionOptions.size() > 0) {
            
            List<Database.DeleteResult> deleteOptions = Database.delete(notFoundInParsedQuestionOptions, true);

            for(Database.DeleteResult deleteOption : deleteOptions) {

                if(!deleteOption.isSuccess()) {

                    System.debug('error: ' + deleteOption.getErrors());

                }

            }
        }

        List<Database.UpsertResult> resultOptions = Database.upsert(parsedQuestionOptions, true); 
        
        for(Database.UpsertResult result : resultOptions) {

            if(!result.isSuccess()) {

                System.debug('error: ' + result.getErrors());

            }

        }

        Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 
        
        List<sObject> options = new List<sObject>(); 
        options.addAll(parsedQuestionOptions);
        
        results.put('Question', new List<sObject> { parsedQuestion });
        results.put('Options', options);

        return results;

    }

    @RemoteAction 
    global static List<Clarity_Form_Question__c> pageDelete(String sQuestions, String sDetails) {

        List<String> details = (List<String>)JSON.deserialize(sDetails, List<String>.class);

        Double page = Double.valueOf(details[0]); 
        String recordId = details[1];

        List<Clarity_Form_Question__c> questionsToDelete = [SELECT Id, Page__c, Salesforce_Object__c, Salesforce_Field__c, Record_Group__c, Required__c, Title__c, Order__c, Type__c, Clarity_Form__c, Max_Length__c, Lookup__c 
            FROM Clarity_Form_Question__c WHERE Clarity_Form__c =: recordId AND Page__c =: page];

        List<Database.DeleteResult> deleteResults = Database.delete(questionsToDelete, true); 

        for(Database.DeleteResult result : deleteResults) {
            if(!result.isSuccess()) {
                System.debug('delete fail');
            }
        }
        
        List<Clarity_Form_Question__c> parsedQuestions = (List<Clarity_Form_Question__c>)JSON.deserialize(sQuestions, List<Clarity_Form_Question__c>.class);

        if(parsedQuestions.size() > 0) {
            List<Database.SaveResult> results = Database.update(parsedQuestions, true); 

            for(Database.SaveResult sResult : results) {

                if(!sResult.isSuccess()) {
                    System.debug('error');
                }

            }
        }

        return parsedQuestions; 

    }

    @RemoteAction 
    global static List<Clarity_Form_Question__c> deleteQuestion(String sQuestions, String sDeleteQuestionId) {

        Clarity_Form_Question__c questionToDelete = [SELECT Id FROM Clarity_Form_Question__c WHERE Id =: sDeleteQuestionId];

        Database.DeleteResult result = Database.delete(questionToDelete, true);

        if(!result.isSuccess()) {
            System.debug('error: ' + result.getErrors());
        }
        
        List<Clarity_Form_Question__c> parsedQuestions = (List<Clarity_Form_Question__c>)JSON.deserialize(sQuestions, List<Clarity_Form_Question__c>.class);

        List<Database.SaveResult> results = Database.update(parsedQuestions, true); 

        for(Database.SaveResult sResult : results) {

            if(!sResult.isSuccess()) {
                System.debug('error');
            }

        }

        return parsedQuestions;
    }

    @RemoteAction 
    global static Map<String, List<sObject>> getQuestionEditDetails(String sQuestionId) {

        List<Clarity_Form_Question_Flow_Design__c> flowDesign = [SELECT Id, Active__c, Form_Submission__c, Clarity_Form_Question__c FROM Clarity_Form_Question_Flow_Design__c WHERE Clarity_Form_Question__c =: sQuestionId LIMIT 1];

        List<Clarity_Form_Question_Option__c> questionOptions = [SELECT Id, Order__c, Active_Flow__c, Choice_Image__c, Label__c FROM Clarity_Form_Question_Option__c WHERE Clarity_Form_Question__c =: sQuestionId];

        List<Clarity_Form_Question_Criteria__c> criteria = [SELECT Id, Field_Type__c, Field__c, Operator__c, Type__c, Value__c, Clarity_Form_Question__c FROM Clarity_Form_Question_Criteria__c WHERE Clarity_Form_Question__c =: sQuestionId];

        Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 

        results.put('Criteria', criteria);
        results.put('Options', questionOptions);
        results.put('FlowDesign', flowDesign);

        return results;

    }

    @RemoteAction
    global static Map<String, List<sObject>> saveQuestionWithCriteria(String sQuestion, String sCriteria) {

        Clarity_Form_Question__c parsedQuestion = (Clarity_Form_Question__c)JSON.deserialize(sQuestion, Clarity_Form_Question__c.class);

        Database.SaveResult resultQuestion = Database.update(parsedQuestion, true); 

        if(!resultQuestion.isSuccess()) {
            System.debug('error');
        }

        List<Clarity_Form_Question_Criteria__c> currentCriteria = [SELECT Id FROM Clarity_Form_Question_Criteria__c WHERE Clarity_Form_Question__c =: parsedQuestion.Id];

        List<Database.DeleteResult> resultCriteriaDelete = Database.delete(currentCriteria, true); 

        for(Database.DeleteResult criteriaDelete : resultCriteriaDelete) {

            if(!criteriaDelete.isSuccess()) {

                System.debug('error: ' + criteriaDelete.getErrors());

            }

        }

        List<Clarity_Form_Question_Criteria__c> parsedCriteria = (List<Clarity_Form_Question_Criteria__c>)JSON.deserialize(sCriteria, List<Clarity_Form_Question_Criteria__c>.class);

        List<Database.SaveResult> resultCriteria = Database.insert(parsedCriteria, true); 

        for(Database.SaveResult newCriteria : resultCriteria) {

            if(!newCriteria.isSuccess()) {

                System.debug('error: ' + newCriteria.getErrors());

            }

        }

        Map<String, List<sObject>> results = new Map<String, List<sObject>>(); 

        results.put('Criteria', parsedCriteria);
        results.put('Question', new List<sObject> { parsedQuestion });

        return results;
        
    }

    @RemoteAction
    global static List<String> getSObjectsAvailable() {

        List<String> lookups = new List<String>(); 

        Map<String, Schema.SObjectType> sObjectsAvailable = Schema.getGlobalDescribe();

        for(Schema.SObjectType so : sObjectsAvailable.values()) {
			//checkfls
            lookups.add(so.getDescribe().getName());
        
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

            if(!isFieldReq && isFieldCreateable && !isDefaultedOnCreate) {

                requiredFields.get('Required').put('' + field, new Map<String, String>{ '' + type => '' + referenceName });

            } else if(isFieldCreateable && !isDefaultedOnCreate) {

                requiredFields.get('NotRequired').put('' + field, new Map<String, String>{ '' + type => '' + referenceName });

            }

        }

        return requiredFields; 

    }

    @RemoteAction
    global static List<Clarity_Form_Question__c> saveRecordGroupFields(String sRecordGroupFields, String relatedRecordGroupId) {

        List<Clarity_Form_Question__c> recordFieldsToDelete = [SELECT Id FROM Clarity_Form_Question__c WHERE Record_Group__c =: relatedRecordGroupId]; 

        List<Database.DeleteResult> deleteResults = Database.delete(recordFieldsToDelete, true);

        for(Database.DeleteResult deleteResult : deleteResults) {
            
            if(!deleteResult.isSuccess()) {
                System.debug('error: ' + deleteResult.getErrors());
            }

        }

        List<Clarity_Form_Question__c> parsedRecordGroupFields = (List<Clarity_Form_Question__c>)JSON.deserialize(sRecordGroupFields, List<Clarity_Form_Question__c>.class);

        List<Database.UpsertResult> resultRecordFields = Database.upsert(parsedRecordGroupFields, true); 

        for(Database.UpsertResult result : resultRecordFields) {

            if(!result.isSuccess()) {
                System.debug('error: ' + result.getErrors());
            }

        }

        return parsedRecordGroupFields; 

    }

    @RemoteAction
    global static List<Clarity_Form_Connection__c> getConnections(String formId){

        List<Clarity_Form_Connection__c> connections = [SELECT Id, New__c, Salesforce_Object__c FROM Clarity_Form_Connection__c WHERE Clarity_Form__c =: formId];

        return connections; 
        
    }

    @RemoteAction
    global static Map<String, List<Object>> getConnectionFieldMapping(String connectionId, String objectType) {

        Map<String, List<Object>> fieldMapping = new Map<String, List<Object>>(); 

        List<Clarity_Form_Connection_Field__c> connectionFields = [SELECT Id, Clarity_Form_Connection__c, Custom_Value__c, 
            Salesforce_Field__c, Clarity_Form_Question__c, PreFill__c 
            FROM Clarity_Form_Connection_Field__c WHERE Clarity_Form_Connection__c =: connectionId];

        List<Clarity_Form_Connection_Field__c> mappingFields = new List<Clarity_Form_Connection_Field__c>(); 
        List<Clarity_Form_Connection_Field__c> prefillFields = new List<Clarity_Form_Connection_Field__c>(); 

        for(Clarity_Form_Connection_Field__c connectionField : connectionFields) {
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
    global static List<Clarity_Form_Connection__c> saveConnections(List<String> connect) {

        String sConnections = connect[0];
        String formId = connect[1]; 
        String sRemoved = connect[2];

        List<Clarity_Form_Connection__c> removedParsedConnections = (List<Clarity_Form_Connection__c>)JSON.deserialize(sRemoved, List<Clarity_Form_Connection__c>.class);

        if(removedParsedConnections.size() > 0) {

            List<Database.DeleteResult> deleteResults = Database.delete(removedParsedConnections, true); 

            for(Database.DeleteResult deleteResult : deleteResults) {

                if(!deleteResult.isSuccess()) {

                    System.debug('error: ' + deleteResult.getErrors());

                }

            }

        }

        List<Clarity_Form_Connection__c> parsedConnections = (List<Clarity_Form_Connection__c>)JSON.deserialize(sConnections, List<Clarity_Form_Connection__c>.class);

        List<Database.UpsertResult> results = Database.upsert(parsedConnections, true); 

        for(Database.UpsertResult result : results) {

            if(!result.isSuccess()) {

                System.debug('error: ' + result.getErrors());

            }

        }

        return parsedConnections; 

    }

    @RemoteAction
    global static Map<String, List<Object>> saveActiveFieldConnections(String sActiveConnectionFields, String connectionId) {

        Map<String, List<Object>> fieldMapping = new Map<String, List<Object>>(); 

        List<Clarity_Form_Connection_Field__c> connection = [SELECT Id FROM Clarity_Form_Connection_Field__c WHERE Clarity_Form_Connection__c =: connectionId];

        List<Database.DeleteResult> resultConnectionDelete = Database.delete(connection, true); 

        for(Database.DeleteResult connectionDelete : resultConnectionDelete) {

            if(!connectionDelete.isSuccess()) {

                System.debug('error: ' + connectionDelete.getErrors());

            }

        }

        List<Clarity_Form_Connection_Field__c> parsedConnectionFields = (List<Clarity_Form_Connection_Field__c>)JSON.deserialize(sActiveConnectionFields, List<Clarity_Form_Connection_Field__c>.class);
    
        if(parsedConnectionFields.size() > 0) {

            List<Database.UpsertResult> results = Database.upsert(parsedConnectionFields, true); 

            for(Database.UpsertResult result : results) {

                if(!result.isSuccess()) {

                    System.debug('error: ' + result.getErrors());

                }
            }

        }

        List<Clarity_Form_Connection_Field__c> mappingFields = new List<Clarity_Form_Connection_Field__c>(); 
        List<Clarity_Form_Connection_Field__c> prefillFields = new List<Clarity_Form_Connection_Field__c>(); 

        for(Clarity_Form_Connection_Field__c connectionField : parsedConnectionFields) {
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
    global static Map<String, Object> updateStatus(String formId, String status) {

        Map<String, Object> result = new Map<String, Object>(); 

        Clarity_Form__c form = [SELECT Id, Status__c FROM Clarity_Form__c WHERE Id =: formId]; 

        form.Status__c = status;

        Database.SaveResult formResult = Database.update(form, true);

        if(formResult.isSuccess()) {
            result.put('Status', 'Success'); 
        } else {
            result.put('Status', 'Error'); 
        }

        result.put('Form', form); 

        return result;
    }

}