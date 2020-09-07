public class TestDataFactory {

	public static User generateUserWithBuilderPermissions() {

		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User']; 

		User user = new User(
			Alias = 'test_cl', 
			Email= 'test@clarityforms.io',
			EmailEncodingKey='UTF-8', 
			LastName='Testing', 
			LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', 
			ProfileId = p.Id, 
			TimeZoneSidKey='America/New_York', 
			UserName= 'test_cl@clarityforms.io'
		); 

		insert user; 

		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Clarity_Forms_Builder' LIMIT 1];
		
		insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id);

		return user; 

	}

	public static User generateUserWithNoPermissions() {

		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User']; 

		User user = new User(
			Alias = 'test_cln', 
			Email= 'test_cln@clarityforms.io',
			EmailEncodingKey='UTF-8', 
			LastName='Testing', 
			LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', 
			ProfileId = p.Id, 
			TimeZoneSidKey='America/New_York', 
			UserName= 'test_cln@clarityforms.io'
		); 

		insert user; 

		return user; 

	}

    public static Form__c generateForm(){
		
		Form__c form = FormsService.updateForm(new Form__c(Title__c = 'Clarity Form', Status__c = 'Draft'));

		return form; 

    }

	public static List<Form__c> generateForms(Integer count) {
		
		List<Form__c> forms = new List<Form__c>(); 

		for (Integer i = 0; i < count; i++) {
			 
			Form__c form = generateForm();
			forms.add(form); 

		}

		return forms; 

	}

	public static List<Form__c> generateFormsWithGroup(List<Checklist_Group__c> groups) {
		
		List<Form__c> forms = new List<Form__c>(); 


		for (Checklist_Group__c checklistGroup : groups) {
			Form__c form = generateForm();
			form.Checklist_Group__c = checklistGroup.Id;
			forms.add(form); 
		}

		return forms; 

	}

	public static List<Checklist_Group__c> generateChecklistGroups(Integer count) {

		List<Checklist_Group__c> groups = new List<Checklist_Group__c>();

		for (Integer i = 0; i < count; i++) {
			Checklist_Group__c checklistGroup = new Checklist_Group__c();
			checklistGroup.Name = 'Small Assets: ' + i;
			checklistGroup.Standard__c = true;
			groups.add(checklistGroup);
		}
		
		return groups; 

	}

	public static List<Account> generateApps(List<Checklist_Group__c> groups) {

		List<Account> accounts = new List<Account>(); 

		for(Checklist_Group__c checklistGroup : groups)  {
			Account account = new Account(
				Name = 'Test',
				Checklist_Group__c = checklistGroup.Id
			);
			accounts.add(account);
		}

		return accounts; 

	}

    public static List<Question__c> generateQuestions(List<Form__c> forms){

        List<Question__c> newQuestions = new  List<Question__c>();

        Integer order = 0; 

		for(Form__c form : forms) {

			for(String type : Types) {

				Question__c question = new Question__c(
					Form__c = form.Id, 
					Title__c = 'Title: ' + type, 
					Type__c = type,
					Order__c = order
				);

				if(type == 'PICKLIST') {
					question.Salesforce_Object__c = 'Account';
					question.Salesforce_Field__c = 'Type';
				}

				newQuestions.add(question);

				order++; 
			}

		}

        return newQuestions;

	}

	public static List<Question__c> generateAttachmentQuestions(Form__c form, Integer count){

        List<Question__c> newQuestions = new  List<Question__c>();

		for (Integer i = 0; i < count; i++) {
			
			Question__c question = new Question__c(
				Form__c = form.Id, 
				Title__c = 'Attachment: ' + i, 
				Type__c = 'Attachments',
				Order__c = i
			);

			newQuestions.add(question);

		}

        return newQuestions;

	}

	public static List<Question_Option__c> generateQuestionOptions(List<Question__c> multiChoiceQuestions) {

		List<Question_Option__c> options = new List<Question_Option__c>(); 

		Integer count = 0; 

		for(Question__c question : multiChoiceQuestions) {

			Question_Option__c option = new Question_Option__c(
				Label__c = 'Test',
				Question__c = question.Id,
				Order__c = count
			);

			count = count + 1; 

			options.add(option); 
		}

		return options;
	}

	public static List<Question_Criteria__c> generateQuestionCriteria(List<Question__c> questions) {

		List<Question_Criteria__c> criteria = new List<Question_Criteria__c>(); 

		Question_Criteria__c criterion = new Question_Criteria__c(
			Question__c = questions[0].Id,
			Field__c = questions[1].Id, //controller
			Field_Type__c = questions[0].Type__c, 
			Operator__c = 'Equals', 
			Type__c = 'Number', 
			Value__c = '1' 
		);

		criteria.add(criterion); 

		Question_Criteria__c criterion2 = new Question_Criteria__c(
			Question__c = questions[0].Id,
			Field__c = questions[2].Id, //controller
			Field_Type__c = questions[0].Type__c, 
			Operator__c = 'Equals', 
			Type__c = 'Number', 
			Value__c = '10' 
		);

		criteria.add(criterion2); 

		return criteria;

	}

	public static Question__c generateRecordGroup(Form__c form) {

		Question__c question = new Question__c(
			Form__c = form.Id, 
			Title__c = 'Title: RecordGroup', 
			Type__c = 'RecordGroup',
			Salesforce_Object__c = 'Opportunity',
			Order__c = 0
		);

		return question; 

	}

	public static List<Question__c> generateRecordGroupFields(Question__c question){

        List<Question__c> newFields = new  List<Question__c>();

		List<String> fields = new List<String>{ 'Name', 'UnitPrice' };

		List<String> types = new List<String>{ 'STRING', 'DOUBLE' };

        Integer order = 0; 

		for(String field : fields) {

			Question__c newField = new Question__c(
				Form__c = question.Form__c, 
				Salesforce_Field__c = field,
				Title__c = 'Title: ' + types[order], 
				Type__c = types[order],
				Order__c = order
			);

			newFields.add(newField);

			order++; 
		}

        return newFields;

	}
	
    public static List<Form_Connection__c> generateConnections(Boolean newConnection, Id formId, List<String> connectionObjects){

        List<Form_Connection__c> connections = new List<Form_Connection__c>();

        for (String salesForceObject : connectionObjects) {
            
            Form_Connection__c connection = new Form_Connection__c(
                Form__c      = formId, 
                Salesforce_Object__c = salesForceObject, 
                Type__c              = 'Create', 
                New__c               = newConnection, 
                Result_Holder__c     = '{Connection_' + salesForceObject + '}'
            );

            connections.add(connection);

        }

        return connections;
    }

    public static List<Form_Connection_Field__c> generateConnectionFields(Id connectionId, Map<String, String> mappingFieldNames){

        List<Form_Connection_Field__c> connectionFields = new List<Form_Connection_Field__c>();

        for(String field : mappingFieldNames.keySet()) {
            
            String questionId = mappingFieldNames.get(field);

            Form_Connection_Field__c connectionField = new Form_Connection_Field__c(
                Form_Connection__c = connectionId, 
                Salesforce_Field__c = '' + field, 
                Question__c =  questionId
            );

            connectionFields.add(connectionField);

        }

        return connectionFields;

    }

    public static List<Form_Connection_Field__c> generateCustomConnectionFields(Id connectionId, Map<String, String> mappingFieldNames){

        List<Form_Connection_Field__c> connectionFields = new List<Form_Connection_Field__c>();

        for(String field : mappingFieldNames.keySet()) {
            
            String customValue = mappingFieldNames.get(field);

            Form_Connection_Field__c connectionField = new Form_Connection_Field__c(
                Form_Connection__c = connectionId, 
                Salesforce_Field__c = '' + field, 
                Custom_Value__c =  customValue
            );

            connectionFields.add(connectionField);

        }

        return connectionFields;

    }

	public static List<Response_Connection__c> generateResponseConnection(String responseId, List<Form_Connection__c> connections) {

        List<Response_Connection__c> newConnections = new List<Response_Connection__c>(); 
		
		for(Form_Connection__c con : connections) {
			
			Response_Connection__c connection = new Response_Connection__c(
                Form_Connection__c = con.Id,
                Response__c = responseId
            );

            newConnections.add(connection); 

		}

		return newConnections;
	}

    public static Response__c generateResponse(Form__c form){

        Response__c response = new Response__c(Status__c = 'New', Form__c = form.Id);

        return response; 

    }

    public static Map<String,String> generateAnswers(Response__c response, List<Question__c> questions){

        List<Answer__c> answers = new List<Answer__c>();

        for(Question__c question : questions) {

            Answer__c answer = new Answer__c(
                Response__c = response.Id,
                Question__c = question.Id,
                Answer__c = 'Answer for: ' + question.Title__c
            );

            answers.add(answer);

		}
		
		Map<String,String> mapAnswers = new Map<String,String>();

		for(Answer__c answer : answers) {
			mapAnswers.put(answer.Question__c, answer.Answer__c); 
		}
		
		return mapAnswers;

    }
      
    private static List<String> Types {
        get {

            if(Types == null) {

                Types = new List<String>();

               	Schema.DescribeFieldResult fieldResult = Question__c.Type__c.getDescribe();

                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
                for( Schema.PicklistEntry pickListVal : ple){
                    Types.add(pickListVal.getLabel());
                } 

            }
            return Types;
        }
        set; 
    }
}