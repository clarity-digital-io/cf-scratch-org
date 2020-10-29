public class ResponsesUnitofWorkHelper implements fflib_SObjectUnitOfWork.IDoWork
{       
    public Database.UpsertResult[] ResponseResults {get; private set;}
	public Database.UpsertResult ConnectionProcessResult {get; private set;}

	private sObject connection_record;
	private List<Response__c> responses;
	private Form_Connection_Process__c connection_status;
	private fflib_ISObjectUnitOfWork uow; 
	
	// need to create a service to handle these new uow can't use uow here
    public ResponsesUnitofWorkHelper(fflib_ISObjectUnitOfWork iuow)
    {  
		responses = new List<Response__c>();
		connection_record = null;
		connection_status = null;
		uow = iuow; 
    }
     
    public void registerResponseConnections(sObject srecord, List<Response__c> records, Form_Connection_Process__c connectionStatus)
    {
		System.debug('errors: ' + srecord);
		responses.addAll(records);
		connection_record = srecord;
		connection_status = connectionStatus;
	}
     
    public void doWork()
    {	
		if(connection_record == null) {

			connection_status.Status__c = 'Failed';
			connection_status.Description__c = connection_record.Id;
	
			ResponseProcessService.saveConnectionProcess(connection_status); 

			return; 

		}

		String genericObjectName = connection_record.getSObjectType().getDescribe().getName();

		Schema.SObjectType responseType = Schema.Response__c.getSObjectType();

		Map<String, Schema.SObjectField> responseSObjectFields = responseType.getDescribe().fields.getMap();

		String connectedName = genericObjectName + '__c'; 

		if(responseSObjectFields.containsKey(connectedName)) {

			List<Response__c> updateResponses = new List<Response__c>();

			for(Response__c response : responses) {
	
				Response__c newResponse = (Response__c)Schema.Response__c.getSObjectType().newSObject(response.Id); 
				newResponse.put(connectedName, connection_record.Id);
				updateResponses.add(newResponse);
	
			}
	
			ResponseProcessService.saveResponse(updateResponses); 
			
		}

		connection_status.Status__c = 'Success';
		connection_status.Salesforce_Connection_Object__c = connection_record.Id;

		ResponseProcessService.saveConnectionProcess(connection_status); 
               
    }
}