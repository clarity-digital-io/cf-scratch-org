global with sharing class FormBuilder {
	
	@RemoteAction
    global static List<String> save(String sQuestions){

        List<Question__c> parsedQuestions = (List<Question__c>)JSON.deserialize(sQuestions, List<Question__c>.class);
		
		List<String> saved = QuestionsService.saveQuestions(parsedQuestions);

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
    global static List<Question__c> getQuestions(String recordId){

		List<Question__c> questions = QuestionsService.getFormQuestions((Id)recordId); 
		
        return questions; 

    }

	@RemoteAction
    global static String saveQuestion(String sQuestion) {

		Question__c parsedQuestion = (Question__c)JSON.deserialize(sQuestion, Question__c.class);
		
		List<String> saved = QuestionsService.saveQuestions(new List<Question__c> { parsedQuestion });

		return saved[0]; 

	}

	@RemoteAction
	global static Map<String, List<sObject>> saveQuestionWithPictureOptions(List<String> optionValues) {

		String sQuestion = optionValues[0];
		String sQuestionOptions = optionValues[1];
		String sQuestionOptionImages = optionValues[2];

		Map<String, Question_Option__c> parsedOptions = (Map<String, Question_Option__c>)JSON.deserialize(sQuestionOptions, Map<String, Question_Option__c>.class);

		List<Question_Option__c> options = new List<Question_Option__c>();

		for(Question_Option__c option : parsedOptions.values()) {
			options.add(option);
		}

		String sQuestionOptionsList = JSON.serialize(options);
		Map<String, List<sObject>> savedOptions = saveQuestionWithOptions(sQuestion, sQuestionOptionsList);

		Map<String, Question_Option__c> savedParsedOptions = new Map<String, Question_Option__c>();
		for(String result : savedOptions.keySet()) {
			if(result == 'Options') {
				List<sObject> recentlySavedOptions = savedOptions.get(result);
				for(Question_Option__c so : (List<Question_Option__c>)recentlySavedOptions) {
					Integer order = so.Order__c.intValue(); 
					savedParsedOptions.put(order.format(), so); 
				}
			}
		}

		Map<String, String> parsedOptionImages = (Map<String, String>)JSON.deserialize(sQuestionOptionImages, Map<String, String>.class);

		if(parsedOptionImages.size() > 0) {

			Question__c parsedQuestion = (Question__c)JSON.deserialize(sQuestion, Question__c.class);
	
			Map<String, ContentVersion> contents = new Map<String, ContentVersion>();

			for(String optionId : parsedOptionImages.keySet()) {
				
				String img = parsedOptionImages.get(optionId); 
				
				ContentVersion content = new ContentVersion(
					ContentLocation = 'S', 
					PathOnClient    = 'Image.jpeg',
					Origin          = 'H', 
					Title           = 'Image',
					Form__c = parsedQuestion.forms__Form__c,
					VersionData     = EncodingUtil.base64Decode(img) // converting your binary string to Blob
				);

				contents.put(optionId, content);
			}

			List<ContentVersion> cvSaves = new List<ContentVersion>();

			for(ContentVersion cv : contents.values()) {
				cvSaves.add(cv);
			}

			Boolean hasPermission = FLSUtility.isCreateable(cvSaves[0]);

			if(hasPermission) {

				List<Database.SaveResult> contentResults = Database.insert(cvSaves, true); 

				for(Database.SaveResult contentResult : contentResults) {
		
					if(!contentResult.isSuccess()) {
						System.debug('error');
					}
		
				}

			}

			List<Question_Option__c> updateOptions = new List<Question_Option__c>();

			for(String optionId : contents.keySet()) {
				ContentVersion cv = contents.get(optionId); 

				if(savedParsedOptions.get(optionId) != null) {
					Question_Option__c option = savedParsedOptions.get(optionId);

					option.Choice_Image__c = cv.Id; 
	
					updateOptions.add(option); 
				}
				
			}


			Boolean hasPermission2 = FLSUtility.isUpdateable(updateOptions[0]);

			if(hasPermission2) {
				List<Database.SaveResult> optionsResults = Database.update(updateOptions, true); 

				for(Database.SaveResult optionsResult : optionsResults) {
		
					if(!optionsResult.isSuccess()) {
						System.debug('error');
					}
		
				}
			}

			List<ContentVersion> cvUpdates = new List<ContentVersion>();

			Set<Id> cvIds = new Set<Id>();

			for(ContentVersion cv : cvSaves) {
				cv.OwnerId = UserInfo.getUserId();
				cvUpdates.add(cv); 
				cvIds.add(cv.Id); 
			}

			Boolean hasPermission3 = FLSUtility.isUpdateable(cvUpdates[0]);

			if(hasPermission3) {

				List<Database.SaveResult> updateContentResults = Database.update(cvUpdates, true); 

				for(Database.SaveResult updateContentResult : updateContentResults) {
		
					if(!updateContentResult.isSuccess()) {
						System.debug('error');
					}
		
				}
			}

			Map<Id, ContentVersion> createdContentVersions = new Map<Id, ContentVersion>([SELECT Id, Title, ContentSize, ContentDocumentId FROM ContentVersion WHERE Id IN :cvIds]);

			List<ContentDocumentLink> links = new List<ContentDocumentLink>(); 

			for(Id cvId : createdContentVersions.keySet()) {
			
				ContentVersion cv = createdContentVersions.get(cvId); 

				ContentDocumentLink formLink = new ContentDocumentLink(
					ContentDocumentId   = cv.ContentDocumentId, //Add ContentDocumentId
					LinkedEntityId      = parsedQuestion.Form__c, //Add attachment parentId
					ShareType           = 'V', //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
					Visibility          = 'AllUsers' //AllUsers, InternalUsers, SharedUsers
				);
	
				links.add(formLink); 

			}
	

			Boolean hasPermission4 = FLSUtility.isCreateable(links[0]);

			if(hasPermission4) {

				List<Database.SaveResult> formLinkResults = Database.insert(links, true); 

				for(Database.SaveResult formLinkResult : formLinkResults) {
					if(!formLinkResult.isSuccess()) {
						System.debug('error');
					}
				}

			}
			
		} 

		return savedOptions; 

	}

	@RemoteAction
    global static Map<String, List<sObject>> saveQuestionWithOptions(String sQuestion, String sQuestionOptions) {

		Map<String, Object> mapSObject = (Map<String, Object>) JSON.deserializeUntyped( sQuestion );

		mapSObject.remove( 'forms__Question_Options__r' );

		Question__c parsedQuestion = (Question__c)JSON.deserialize(JSON.serialize(mapSObject), Question__c.class);
		//need to delete previous options
		List<Question_Option__c> parsedQuestionOptions = (List<Question_Option__c>)JSON.deserialize(sQuestionOptions, List<Question_Option__c>.class);

        Map<String, List<sObject>> results = QuestionsService.saveQuestionWithDetails(parsedQuestion, parsedQuestionOptions);
		
		return results;

	}

    @RemoteAction 
    global static List<Question__c> pageDelete(String sQuestions, String formId) {

        List<Id> deleteQuestions = (List<Id>)JSON.deserialize(sQuestions, List<String>.class);

		List<Question__c> questionsToDelete = [SELECT Id FROM Question__c WHERE Form__c =: formId AND Id IN :deleteQuestions];
		
		Boolean hasPermission = FLSUtility.isDeleteable(Schema.SObjectType.Question_Option__c);

		if(hasPermission) {

			List<Database.DeleteResult> deleteResults = Database.delete(questionsToDelete, true); 

			for(Database.DeleteResult result : deleteResults) {
				if(!result.isSuccess()) {
					System.debug('delete fail');
				}
			}

		}
			
		return getQuestions(formId);
    
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
    global static Map<String, List<sObject>> saveQuestionWithCriteria(String sQuestion, String sCriteria) {

		Map<String, Object> mapSObject = (Map<String, Object>) JSON.deserializeUntyped( sQuestion );

		mapSObject.remove( 'forms__Question_Criteria__r' );

		Question__c parsedQuestion = (Question__c)JSON.deserialize(JSON.serialize(mapSObject), Question__c.class);

        List<Question_Criteria__c> parsedCriteria = (List<Question_Criteria__c>)JSON.deserialize(sCriteria, List<Question_Criteria__c>.class);

        Map<String, List<sObject>> results = QuestionsService.saveQuestionWithCriteriaDetails(parsedQuestion, parsedCriteria);
		
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
    global static List<Question__c> saveRecordGroupFields(String sRecordGroupFields, String relatedRecordGroupId) {

		List<Question__c> recordFieldsToDelete = [SELECT Id FROM Question__c WHERE Record_Group__c =: relatedRecordGroupId]; 
		
		Boolean hasPermission = FLSUtility.isDeleteable(Schema.SObjectType.Question__c);

		if(hasPermission) {

			List<Database.DeleteResult> deleteResults = Database.delete(recordFieldsToDelete, true);

			for(Database.DeleteResult deleteResult : deleteResults) {
				
				if(!deleteResult.isSuccess()) {
					System.debug('error: ' + deleteResult.getErrors());
				}

			}
			
		}

        List<Question__c> parsedRecordGroupFields = (List<Question__c>)JSON.deserialize(sRecordGroupFields, List<Question__c>.class);

        List<Database.UpsertResult> resultRecordFields = Database.upsert(parsedRecordGroupFields, true); 

        for(Database.UpsertResult result : resultRecordFields) {

            if(!result.isSuccess()) {
                System.debug('error: ' + result.getErrors());
            }

        }

        return parsedRecordGroupFields; 

    }

    @RemoteAction
    global static List<Form_Connection__c> getConnections(String formId){

        List<Form_Connection__c> connections = [SELECT Id, New__c, Salesforce_Object__c FROM Form_Connection__c WHERE Form__c =: formId];

        return connections; 
        
    }

    @RemoteAction
    global static Map<String, List<Object>> getConnectionFieldMapping(String connectionId, String objectType) {

        Map<String, List<Object>> fieldMapping = new Map<String, List<Object>>(); 

        List<Form_Connection_Field__c> connectionFields = [SELECT Id, Form_Connection__c, Custom_Value__c, 
            Salesforce_Field__c, Question__c, PreFill__c 
            FROM Form_Connection_Field__c WHERE Form_Connection__c =: connectionId];

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

        List<Form_Connection__c> removedParsedConnections = (List<Form_Connection__c>)JSON.deserialize(sRemoved, List<Form_Connection__c>.class);

        if(removedParsedConnections.size() > 0) {

			Boolean hasPermission = FLSUtility.isDeleteable(Schema.SObjectType.Form_Connection__c);

			if(hasPermission) {

				List<Database.DeleteResult> deleteResults = Database.delete(removedParsedConnections, true); 

				for(Database.DeleteResult deleteResult : deleteResults) {

					if(!deleteResult.isSuccess()) {

						System.debug('error: ' + deleteResult.getErrors());

					}

				}
				
			}

        }

		List<Form_Connection__c> parsedConnections = (List<Form_Connection__c>)JSON.deserialize(sConnections, List<Form_Connection__c>.class);
		
		List<Form_Connection__c> validatedConnections = new List<Form_Connection__c>();

		for(Form_Connection__c parsedConnection : parsedConnections) {
			if(parsedConnection.Salesforce_Object__c != '') {
				validatedConnections.add(parsedConnection);
			}
		}

        List<Database.UpsertResult> results = Database.upsert(validatedConnections, true); 

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

        List<Form_Connection_Field__c> connection = [SELECT Id FROM Form_Connection_Field__c WHERE Form_Connection__c =: connectionId];

		Boolean hasPermission = FLSUtility.isDeleteable(Schema.SObjectType.Form_Connection_Field__c);

		if(hasPermission) {

			List<Database.DeleteResult> resultConnectionDelete = Database.delete(connection, true); 

			for(Database.DeleteResult connectionDelete : resultConnectionDelete) {

				if(!connectionDelete.isSuccess()) {

					System.debug('error: ' + connectionDelete.getErrors());

				}

			}
			
		}

        List<Form_Connection_Field__c> parsedConnectionFields = (List<Form_Connection_Field__c>)JSON.deserialize(sActiveConnectionFields, List<Form_Connection_Field__c>.class);
    
        if(parsedConnectionFields.size() > 0) {

            List<Database.UpsertResult> results = Database.upsert(parsedConnectionFields, true); 

            for(Database.UpsertResult result : results) {

                if(!result.isSuccess()) {

                    System.debug('error: ' + result.getErrors());

                }
            }

        }

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
    global static Map<String, Object> updateStatus(String formId, String status) {

        Map<String, Object> result = new Map<String, Object>(); 

        Form__c form = [SELECT Id, Status__c FROM Form__c WHERE Id =: formId]; 

        form.Status__c = status;

		Boolean hasPermission = FLSUtility.isUpdateable(form);

		if(hasPermission) {
			
			Database.SaveResult formResult = Database.update(form, true);

			if(formResult.isSuccess()) {
				result.put('Status', 'Success'); 
			} else {
				result.put('Status', 'Error'); 
			}

			result.put('Form', form); 
			
		}

        return result;
    }

}