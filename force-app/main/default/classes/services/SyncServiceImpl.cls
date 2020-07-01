public class SyncServiceImpl implements ISyncService {

	public static String registerUsers() {

		Organization organization = [Select Id, IsSandbox, Name FROM Organization Limit 1]; 

		//query salesforce users
		List<String> users = new List<String>();

		List<PermissionSetAssignment> psas = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Clarity_Forms_Mobile'];

		for(PermissionSetAssignment psa : psas) {
			//probably can remove sandbox notice
			users.add(psa.AssigneeId); 
		}
		
		HttpResponse response = Sync.registerUsers(users, organization.Id);

		return response.getBody();

	}

	public static String connectOrganization() {

		Organization organization = [Select Id, Name FROM Organization Limit 1]; 

		List<Form> preparedForms = new List<Form>(); 

		List<Form__c> forms = FormsService.getFormsByStatus('Published');

		List<Question__c> questions = QuestionsService.getQuestions();

		List<Form_Connection__c> connections = FormConnectionsService.getConnectionsByFormStatus('Published');

		Map<Id, List<Question__c>> formQuestions = new Map<Id, List<Question__c>>();

		Map<Id, List<Form_Connection__c>> formConnections = new Map<Id, List<Form_Connection__c>>();

		for(Question__c question : questions) {
			if(formQuestions.get(question.Form__c) != null) {
				formQuestions.get(question.Form__c).add(question);
			} else {
				formQuestions.put(question.Form__c, new List<Question__c>{ question });
			}
		}

		for(Form_Connection__c connection : connections) {
			if(formConnections.get(connection.Form__c) != null) {
				formConnections.get(connection.Form__c).add(connection);
			} else {
				formConnections.put(connection.Form__c, new List<Form_Connection__c>{ connection });
			}
		}
		
		for(Form__c form : forms) {
			Form preparedForm = new Form();
			preparedForm.form = form; 
			preparedForm.questions = formQuestions.get(form.Id) != null ? formQuestions.get(form.Id) : new List<Question__c>();
			preparedForm.connections = formConnections.get(form.Id) != null ? formConnections.get(form.Id) : new List<Form_Connection__c>();
			preparedForms.add(preparedForm);
		}

		Connect connect = new Connect(); 

		connect.org = organization;
		connect.forms =  preparedForms;

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		HttpResponse response = Sync.connectOrganization(connect, organization.Id);

		String body = response.getBody(); 

		Map<String, String> parsedBody = (Map<String, String>)JSON.deserialize(body, Map<String, String>.class);

		Log__c log = new Log__c(
			Job_Id__c = parsedBody.get('id'), 
			Status__c = 'In Progress',
			Type__c   = 'Connect'
		);

		uow.registerUpsert(log);

		uow.commitWork();	

		return response.getBody();

	}

	public static String getOrganizationInformation() {

		Organization organization = [Select Id, Name FROM Organization Limit 1]; 

		HttpResponse response = Sync.getOrganizationSetup(organization.Id);
		
		return response.getBody();

	}
	
	@future(callout=true) 
	public static void process(String userId) {

		Sync.process(userId); 

	}

}

