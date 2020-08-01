public class ResponsesServiceImpl implements IResponsesService {

	public List<Response__c> getResponses() {
		List<Response__c> responses = ResponsesSelector.newInstance().selectRecent();
		return responses; 
	}

	public Response__c getResponseWithDetailsById(String responseId) {
		List<Response__c> responses = ResponsesSelector.newInstance().selectWithAllDetailsByIds(new Set<Id>{ responseId });
		return responses[0]; 
	}

	public List<Response__c> getResponsesByFormId(String formId) {
		List<Response__c> responses = ResponsesSelector.newInstance().selectByFormId(new Set<Id>{ formId });
		return responses; 
	}

	public Response__c getResponseById(String responseId) {
		List<Response__c> responses = ResponsesSelector.newInstance().selectById(new Set<Id>{ responseId });
		return responses[0]; 
	}

	public List<Response__c> getResponsesByOwner(List<String> userIds) {
		List<Response__c> responses = ResponsesSelector.newInstance().selectResponsesByOwner(userIds);
		return responses; 
	}

	public static List<Response__c> getResponsesByConnectedId(String recordId) {

		Schema.SObjectType type = Id.valueOf(recordId).getSobjectType();

		Schema.DescribeSObjectResult result = type.getDescribe();

		String objectName = result.getName();

		String customQuery = objectName; 

		if(!result.isCustom()) {
			customQuery += '__c';
		}

		customQuery += ' = :recordId';

		List<Response__c> responses = ResponsesSelector.newInstance().selectResponsesByConnectedId(customQuery, recordId);
		return responses; 
	}

	public Response__c create(String formId) {
		//Doesn't meet UUID V4 Standards 
		Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		Response__c newResponse = new Response__c(
			Form__c = formId,
			Status__c = 'New',
			UUID__c = guid
		);

		uow.registerNew(newResponse);

		uow.commitWork();	

		return newResponse;
	}

	public Response__c create(String formId, Map<String, String> connectionRecordIds) {
		//Doesn't meet UUID V4 Standards 
		Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);

		Response__c newResponse = new Response__c(
			Form__c = formId,
			Status__c = 'New',
			UUID__c = guid
		);

		for(String connectionId : connectionRecordIds.keySet()) {

			String recordId = connectionRecordIds.get(connectionId);

			Schema.SObjectType type = Id.valueOf(recordId).getSobjectType();

			Schema.DescribeSObjectResult result = type.getDescribe();
	
			String objectName = result.getName();
	
			String fieldName = objectName; 
	
			if(!result.isCustom()) {
				fieldName += '__c';
			}

			newResponse.put(fieldName, recordId); 

		}

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerNew(newResponse);

		uow.commitWork();	

		return newResponse;
	}

	public Response__c save(List<Answer__c> newAnswers, String responseId, String status) {

		List<Response__c> responses = ResponsesSelector.newInstance().selectById(new Set<Id>{ responseId });
		Response__c response = responses[0];
		response.Status__c = status; 

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		IAnswers ans = Answers.newInstance(newAnswers);				

		ans.save(uow); 

		uow.registerUpsert(response);

		uow.commitWork();	

		return response; 
		
	}

	public List<Response__c> save(List<Response__c> responses, Schema.sObjectField uniqueExternalField) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerUpsert(responses, uniqueExternalField);

		uow.commitWork();	
		
		return responses; 
		
	}

	public List<Response_Connection__c> saveConnections(String responseId, List<Map<String, String>> parsedConnections) {

		List<Response__c> responses = ResponsesSelector.newInstance().selectById(new Set<Id>{ responseId });

		Response__c response = responses[0];

		List<Response_Connection__c> connections = new List<Response_Connection__c>(); 

		for(Map<String, String> parsedConnection : parsedConnections) {

            Response_Connection__c connection = new Response_Connection__c(
                Record__c = parsedConnection.get('key'),
                Form_Connection__c = parsedConnection.get('connectionId'),
                Response__c = responseId
            );

			connections.add(connection); 
			
			String fieldName = parsedConnection.containsKey('sObject') ? parsedConnection.get('sObject') : '';
			String recordId = parsedConnection.containsKey('key') ? parsedConnection.get('key') : '';
			Boolean fieldCheck = SObjectType.Response__c.fields.getMap().containsKey('forms__' + fieldName.toLowerCase() + '__c');
			
			if(fieldCheck) {
				response.put('forms__' + fieldName + '__c', recordId);
			}

        }

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerNew(connections);
		uow.registerUpsert(response); 
		uow.commitWork();	

		return connections;

	}

	public List<String> deleteResponsesByUUIDs(List<String> UUIDs) {

		Set<String> setUUIDS = new Set<String>(UUIDs);
		List<Response__c> responses = ResponsesSelector.newInstance().selectByUUIDs(setUUIDS);
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerDeleted(responses);
		uow.commitWork();	

		List<String> responseIds = new List<String>(); 

		for(Response__c response : responses) {
			responseIds.add(response.UUID__c);
		}

		return responseIds;

	}

	public Id deleteById(String responseId) {

		List<Response__c> responses = ResponsesSelector.newInstance().selectById(new Set<Id> {responseId});
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerDeleted(responses[0]);

		uow.commitWork();	
		
		return responses[0].Id; 

	}

	public Map<String, List<Map<String, String>>> getResultAnswersByFormId(String recordId, Integer offset) {

		List<Question__c> questions = QuestionsSelector.newInstance().selectWithAllDetailsByIds(new Set<Id> {recordId});

		Map<Id, List<Question_Option__c>> questionOptions = new Map<Id, List<Question_Option__c>>();

        for(Question__c question : questions) {

            if(question.Type__c == 'Checkbox' || question.Type__c == 'Dropdown' || question.Type__c == 'PictureChoice') {
                questionOptions.put(question.Id, question.Question_Options__r);
            }

        }

		Map<String, List<Map<String, String>>> table = new Map<String, List<Map<String, String>>>();

        List<Map<String, String>> columns = new List<Map<String, String>>();

        columns.add(new Map<String, String> { 'fieldName' => 'id' }); 

        for(Question__c question : questions) {

            if(question.Record_Group__c == null && question.Type__c != 'RecordGroup') {

                Map<String, String> column = ResultsHelper.buildColumn(question);
                if(column.size() > 0 ) {
                    columns.add(column); 
                }

            }

        }

		table.put('Columns', columns); 

		List<Map<String, String>> rows = new List<Map<String, String>>();
		
		List<Response__c> responses = ResponsesSelector.newInstance().selectWithAllDetailsByIds(new Set<Id> {recordId});

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

                    row.put(answer.Question__r.Name, ResultsHelper.buildAnswer(answer, questionOptions));

                }

            }

            rows.add(row); 

        }

        table.put('Data', rows); 

        return table;

	}

	public sObject upsertConnectionSObject(sObject record, Form_Connection_Process__c connectionStatus, Response__c response) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerUpsert(record);

		connectionStatus.Salesforce_Connection_Object__c = record.Id;
		connectionStatus.Status__c = 'Success';

		uow.registerUpsert(connectionStatus);

		String genericObjectName = record.getSObjectType().getDescribe().getName();
		
		Schema.SObjectType responseType = Schema.Response__c.getSObjectType();

		Map<String, Schema.SObjectField> responseSObjectFields = responseType.getDescribe().fields.getMap();

		String connectedName = genericObjectName + '__c'; 

		if(responseSObjectFields.containsKey('forms__' + connectedName)) {

			response.put(connectedName, record.Id);

			uow.registerUpsert(response);

		} 

		uow.commitWork();	
		
		return record; 
		
	}

	public void updateFormConnectionStatus(Form_Connection_Process__c connectionStatus) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerUpsert(connectionStatus);

		uow.commitWork();	

	}

}
