public class SyncServiceImpl implements ISyncService {
  public static String registerUsers() {
    Organization organization = [
      SELECT Id, IsSandbox, Name
      FROM Organization
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];

    //query salesforce users
    List<String> users = new List<String>();

    List<PermissionSetAssignment> psas = [
      SELECT Id, AssigneeId
      FROM PermissionSetAssignment
      WHERE PermissionSet.Name = 'Clarity_Forms_Mobile'
    ];

    for (PermissionSetAssignment psa : psas) {
      //probably can remove sandbox notice
      users.add(psa.AssigneeId);
    }

    HttpResponse response = Sync.registerUsers(users, organization.Id);

    return response.getBody();
  }

  public static String connectOrganization() {
    Organization organization = [
      SELECT Id, Name
      FROM Organization
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];

    List<Checklist_Group__c> groups = ChecklistGroupsService.getGroups();

    List<Form> preparedForms = new List<Form>();

    List<Form__c> forms = FormsService.getFormsByStatus('Published');

    List<Question__c> questions = QuestionsService.getQuestions();

    List<Picklist> preparedPicklist = PicklistHelper.getValues(questions);

    List<Form_Connection__c> connections = FormConnectionsService.getConnectionsByFormStatus(
      'Published'
    );

    Map<Id, List<Question__c>> formQuestions = new Map<Id, List<Question__c>>();

    Map<Id, List<Form_Connection__c>> formConnections = new Map<Id, List<Form_Connection__c>>();

    for (Question__c question : questions) {
      if (formQuestions.get(question.Form__c) != null) {
        formQuestions.get(question.Form__c).add(question);
      } else {
        formQuestions.put(question.Form__c, new List<Question__c>{ question });
      }
    }

    for (Form_Connection__c connection : connections) {
      if (formConnections.get(connection.Form__c) != null) {
        formConnections.get(connection.Form__c).add(connection);
      } else {
        formConnections.put(
          connection.Form__c,
          new List<Form_Connection__c>{ connection }
        );
      }
    }

    for (Form__c form : forms) {
      Form preparedForm = new Form();
      preparedForm.form = form;
      preparedForm.questions = formQuestions.containsKey(form.Id)
        ? formQuestions.get(form.Id)
        : new List<Question__c>();
      preparedForm.connections = formConnections.containsKey(form.Id)
        ? formConnections.get(form.Id)
        : new List<Form_Connection__c>();
      preparedForms.add(preparedForm);
    }

    Connect connect = new Connect();

    connect.org = organization;
    connect.forms = preparedForms;
    connect.picklists = preparedPicklist;
    connect.groups = groups;

    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    HttpResponse response = Sync.connectOrganization(connect, organization.Id);

    String body = response.getBody();

    Map<String, String> parsedBody = (Map<String, String>) JSON.deserialize(
      body,
      Map<String, String>.class
    );

    Log__c log = new Log__c(
      Job_Id__c = parsedBody.get('id'),
      Status__c = 'In Progress',
      Type__c = 'Connect'
    );

    uow.registerUpsert(log);

    uow.commitWork();

    return response.getBody();
  }

  public static String getOrganizationInformation() {
    Organization organization = [
      SELECT Id, Name
      FROM Organization
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];

    HttpResponse response = Sync.getOrganizationSetup(organization.Id);

    return response.getBody();
  }

  public static void connectOrganizationForms(Set<Id> formIds) {
    Organization organization = [
      SELECT Id, Name
      FROM Organization
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];

    List<Form> preparedForms = new List<Form>();

    List<Form__c> forms = FormsService.getFormByIds(formIds);

    List<Question__c> questions = QuestionsService.getFormsQuestions(formIds);

    List<Picklist> preparedPicklist = PicklistHelper.getValues(questions);

    List<Form_Connection__c> connections = FormConnectionsService.getConnectionsByFormIds(
      formIds
    );

    Map<Id, List<Question__c>> formQuestions = new Map<Id, List<Question__c>>();

    Map<Id, List<Form_Connection__c>> formConnections = new Map<Id, List<Form_Connection__c>>();

    for (Question__c question : questions) {
      if (formQuestions.get(question.Form__c) != null) {
        formQuestions.get(question.Form__c).add(question);
      } else {
        formQuestions.put(question.Form__c, new List<Question__c>{ question });
      }
    }

    for (Form_Connection__c connection : connections) {
      if (formConnections.get(connection.Form__c) != null) {
        formConnections.get(connection.Form__c).add(connection);
      } else {
        formConnections.put(
          connection.Form__c,
          new List<Form_Connection__c>{ connection }
        );
      }
    }

    for (Form__c form : forms) {
      Form preparedForm = new Form();
      preparedForm.form = form;
      preparedForm.questions = formQuestions.containsKey(form.Id)
        ? formQuestions.get(form.Id)
        : new List<Question__c>();
      preparedForm.connections = formConnections.containsKey(form.Id)
        ? formConnections.get(form.Id)
        : new List<Form_Connection__c>();
      preparedForms.add(preparedForm);
    }

    Connect connect = new Connect();

    connect.org = organization;
    connect.forms = preparedForms;
    connect.picklists = preparedPicklist;
    connect.groups = new List<Checklist_Group__c>();

    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(
      new fflib_SecureDML()
    );

    HttpResponse response = Sync.connectPublishedForms(
      connect,
      organization.Id
    );

    String body = response.getBody();

    Map<String, String> parsedBody = (Map<String, String>) JSON.deserialize(
      body,
      Map<String, String>.class
    );

    Log__c log = new Log__c(
      Job_Id__c = parsedBody.get('id'),
      Status__c = 'In Progress',
      Type__c = 'Form Update'
    );

    uow.registerUpsert(log);

    uow.commitWork();
  }

  //sObject - Connection as objects and fields
  public static List<sObject> getOfflineFromConnections() {
    Map<String, Set<String>> sObjectFields = new Map<String, Set<String>>();

    List<Form_Connection__c> connections = FormConnectionsSelector.newInstance()
      .selectConnectionsByFormStatus('Published');

    for (Form_Connection__c connection : connections) {
      if (sObjectFields.containsKey(connection.Salesforce_Object__c)) {
        Set<String> fields = sObjectFields.get(connection.Salesforce_Object__c);

        for (
          Form_Connection_Field__c field : connection.Form_Connection_Fields__r
        ) {
          fields.add(field.Salesforce_Field__c);
        }
      } else {
        Set<String> fields = new Set<String>();

        for (
          Form_Connection_Field__c field : connection.Form_Connection_Fields__r
        ) {
          fields.add(field.Salesforce_Field__c);
        }

        sObjectFields.put(connection.Salesforce_Object__c, fields);
      }
    }

    List<sObject> records = getRecords(sObjectFields);

    return records;
  }

  //sObject - These are from record group questions or lookup questions
  public static List<sObject> getOfflineFromQuestions() {
    Map<String, Set<String>> sObjectFields = new Map<String, Set<String>>();

    List<Form__c> forms = FormsSelector.newInstance()
      .selectByStatus('Published');

    Set<Id> formIds = new Set<Id>();

    for (Form__c form : forms) {
      formIds.add(form.Id);
    }

    List<Question__c> questions = QuestionsSelector.newInstance()
      .selectByFormIds(formIds);

    for (Question__c question : questions) {
      Set<String> fields = new Set<String>();

      if (question.Salesforce_Object__c == 'Case') {
        fields.add('Subject');
      } else {
        fields.add('Name');
      }

      sObjectFields.put(question.Salesforce_Object__c, fields);
    }

    List<sObject> records = getRecords(sObjectFields);

    return records;
  }

  //sObject - Latest Accounts
  public static List<sObject> getOfflineFromAccounts() {
    List<sObject> accounts = AccountsSelector.newInstance().selectOffline();

    return accounts;
  }

  public static List<sObject> getRecords(
    Map<String, Set<String>> sObjectFields
  ) {
    List<sObject> records = new List<sObject>();

    Integer MAX_RESULTS = 500;

    for (String sObjectName : sObjectFields.keySet()) {
      Set<String> fields = sObjectFields.get(sObjectName);

      String sFields = String.join(new List<String>(fields), ', ');

      List<sObject> sfRecords = Database.query(
        'SELECT Id, ' +
        sFields +
        ' FROM ' +
        sObjectName +
        ' WITH SECURITY_ENFORCED LIMIT :MAX_RESULTS'
      );

      records.addAll(sfRecords);
    }

    return records;
  }

  @future(callout=true)
  public static void process(String userId) {
    List<sObject> sObjectConnections = getOfflineFromConnections();

    List<sObject> sObjectQuestions = getOfflineFromQuestions();

    List<sObject> sObjectAccounts = getOfflineFromAccounts();

    List<sObject> records = new List<sObject>();

    records.addAll(sObjectConnections);
    records.addAll(sObjectQuestions);
    records.addAll(sObjectAccounts);

    Sync.process(userId, records);
  }
}
