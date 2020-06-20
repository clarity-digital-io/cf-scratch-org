public with sharing class FormConnectionsService {

	public static List<Form_Connection__c> getConnectionsByResponseId(String responseId) {
		return service().getConnectionsByResponseId(responseId);
	}

	public static List<Form_Connection__c> getConnectionsByFormId(String formId) {
		return service().getConnectionsByFormId(formId);
	}

	public static List<Form_Connection__c> getConnectionsByFormName(String formName) {
		return service().getConnectionsByFormName(formName);
	}

	public static List<Form_Connection__c> save(List<Form_Connection__c> removedConnections, List<Form_Connection__c> newConnections) {
		return service().save(removedConnections, newConnections);
	}
	
	public static IFormConnectionsService service(){
		return (IFormConnectionsService) Application.service.newInstance(IFormConnectionsService.class);
	}

}

