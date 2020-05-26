public class TestDataFactory {

    public static Form__c generateForm(){

        Form__c form = new Form__c(Label__c = 'Clarity Form', Status__c = 'Draft'); 

        insert form; 

        return form; 

    }

	public static List<Form__c> generateForms(Integer count) {
		
		List<Form__c> forms = new List<Form__c>(); 

		for (Integer i = 0; i < count; i++) {
			 
			Form__c form = new Form__c(Label__c = 'Clarity Form ' + i, Status__c = 'Draft'); 
			forms.add(form); 

		}

		insert forms; 

		return forms; 
	}

    public static void publishForm(Form__c form) {

        form.Status__c = 'Published'; 

        update form; 

    }

    public static List<Question__c> generateQuestions(List<Form__c> forms){

        List<Question__c> questions = new  List<Question__c>();

        Integer order = 0; 

		for(Form__c form : forms) {

			for(String type : Types) {

				Question__c question = new Question__c(
					Form__c = form.Id, 
					Title__c        = 'Title: ' + type, 
					Type__c         = type,
					Order__c        = order
				);

				questions.add(question);

				order++; 
			}

		}

        insert questions;

        return questions;

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

	public static Question__c generateRecordGroup(Form__c form) {

		Question__c question = new Question__c(
			Form__c 	 = form.Id, 
			Title__c        	 = 'Title: RecordGroup', 
			Type__c         	 = 'RecordGroup',
			Salesforce_Object__c = 'Opportunity',
			Order__c		     = 0
		);

		insert question; 

		return question; 

	}

    public static List<Form_Connection__c> generateConnections(Boolean newConnection, Form__c form, List<String> connectionObjects){

        List<Form_Connection__c> connections = new List<Form_Connection__c>();

        for (String salesForceObject : connectionObjects) {
            
            Form_Connection__c connection = new Form_Connection__c(
                Form__c      = form.Id, 
                Salesforce_Object__c = salesForceObject, 
                Type__c              = 'Create', 
                New__c               = newConnection, 
                Result_Holder__c     = '{Connection_' + salesForceObject + '}'
            );

            connections.add(connection);

        }

        insert connections;

        return connections;
    }

    public static List<Form_Connection_Field__c> generateConnectionFields(Form_Connection__c connection, Map<String, Id> mappingFieldNames){

        List<Form_Connection_Field__c> connectionFields = new List<Form_Connection_Field__c>();

        for(String field : mappingFieldNames.keySet()) {
            
            Id questionId = mappingFieldNames.get(field);

            Form_Connection_Field__c connectionField = new Form_Connection_Field__c(
                Form_Connection__c = connection.Id, 
                Salesforce_Field__c        = '' + field, 
                Question__c   =  questionId
            );

            connectionFields.add(connectionField);

        }

        insert connectionFields; 

        return connectionFields;

    }

    public static List<Form_Connection_Field__c> generateCustomConnectionFields(Form_Connection__c connection, Map<String, String> mappingFieldNames){

        List<Form_Connection_Field__c> connectionFields = new List<Form_Connection_Field__c>();

        for(String field : mappingFieldNames.keySet()) {
            
            String customValue = mappingFieldNames.get(field);

            Form_Connection_Field__c connectionField = new Form_Connection_Field__c(
                Form_Connection__c = connection.Id, 
                Salesforce_Field__c        = '' + field, 
                Custom_Value__c            =  customValue
            );

            connectionFields.add(connectionField);

        }

        insert connectionFields; 

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

		insert newConnections; 

		return newConnections;
	}

    public static Response__c generateResponse(Form__c form){

        Response__c response = new Response__c(Status__c = 'New', Form__c = form.Id, OwnerId__c = UserInfo.getUserId());

        insert response;

        return response; 

    }

    public static void generateAnswers(Response__c response, List<Question__c> questions){

        List<Answer__c> answers = new List<Answer__c>();

        for(Question__c question : questions) {

            Answer__c answer = new Answer__c(
                Response__c = response.Id,
                Question__c = question.Id,
                Answer__c                = 'Answer for: ' + question.Title__c
            );

			if(question.Type__c == 'Attachments') {
				answer.ContentVersion__c = '123456789';

				//Add second attachment
				Answer__c answer2 = new Answer__c(
					Response__c = response.Id,
					Question__c = question.Id,
					Answer__c                = 'Answer for: ' + question.Title__c,
					ContentVersion__c 	     = '123456789'
				);
				
				answers.add(answer2);

			}

            answers.add(answer);

        }

        insert answers; 

    }

	public static void generateRecordGroupAnswers(Response__c response, List<Question__c> questions){

		List<Answer__c> answers = new List<Answer__c>();

        for(Question__c question : questions) {

            Answer__c answer = new Answer__c(
                Response__c = response.Id,
                Question__c = question.Id,
                Answer__c                = 'Answer for: ' + question.Title__c
            );

            answers.add(answer);

        }

        insert answers; 

	}
    
    public static void updateAnswer(Response__c response, Question__c question){

        Answer__c answer = [SELECT Id FROM Answer__c WHERE Question__c =: question.Id LIMIT 1];

        answer.Answer__c = 'Answer for: ' + question.Title__c;

        update answer; 

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
