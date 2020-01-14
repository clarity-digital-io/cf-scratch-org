public class ClarityTestDataFactory {

    public static User generateUser() {

        User u;

        User usr = [Select id from User where Id = :UserInfo.getUserId()];

        System.RunAs(usr) {

            UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');

            insert r;

            u = new User(
                ProfileId         = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                FirstName         ='Food',
                LastName          = 'Admin',
                Email             = 'admin@foodcompany.com',
                Username          = 'admin@foodcompany.com' + System.currentTimeMillis(),
                CompanyName       = 'Food Company',
                Title             = 'Clarity Response Admin',
                Alias             = 'admin',
                TimeZoneSidKey    = 'America/Los_Angeles',
                EmailEncodingKey  = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey      = 'en_US',
                UserRoleId        = r.Id
            );

            insert u; 

        }

        return u;

    }

    public static forms__Form__c generateForm(){

        forms__Form__c form = new forms__Form__c(Label__c = 'Clarity Form', Status__c = 'Draft'); 

        insert form; 

        return form; 

    }

    public static void publishForm(forms__Form__c form) {

        form.Status__c = 'Published'; 

        update form; 

    }

    public static List<forms__Form_Question__c> generateQuestions(forms__Form__c form){

        List<forms__Form_Question__c> questions = new  List<forms__Form_Question__c>();

        Integer order = 0; 

        for(String type : Types) {

            forms__Form_Question__c question = new forms__Form_Question__c(
                forms__Form__c = form.Id, 
                Title__c        = 'Title: ' + type, 
                Type__c         = type,
                Order__c        = order
            );

            questions.add(question);

            order++; 
        }

        insert questions;

        return questions;

    }

    public static forms__Form_Assignment__c generateAssignment(forms__Form__c form, User u, String logic){

        forms__Form_Assignment__c assignment = new forms__Form_Assignment__c(
            Assign__c = u.Id,
            Default_Assign__c = u.Id,
            Logic__c = logic
        );

        insert assignment;

        form.forms__Form_Assignment__c = assignment.Id; 

        return assignment; 

    }

    public static void generateAssignmentRules(Id assignmentId, List<forms__Form_Question__c> questions, String type){

        List<forms__Form_Assignment_Rule__c> rules = new List<forms__Form_Assignment_Rule__c>();

        for(forms__Form_Question__c question : questions){

            if(question.Type__c == type) {

                forms__Form_Assignment_Rule__c rule = new forms__Form_Assignment_Rule__c(
                    forms__Form_Assignment__c = assignmentId,
                    Field__c                   = question.Id,
                    Field_Type__c              = type,
                    Operator__c                = 'Is Not Null',
                    Type__c                    = 'String',
                    Value__c                   = 'Answer for: Title: ' + type
                );

                rules.add(rule);

            }

        }

        insert rules; 

    }

    public static List<forms__Form_Connection__c> generateConnections(forms__Form__c form, List<String> connectionObjects){

        List<forms__Form_Connection__c> connections = new List<forms__Form_Connection__c>();

        for (String salesForceObject : connectionObjects) {
            
            forms__Form_Connection__c connection = new forms__Form_Connection__c(
                forms__Form__c      = form.Id, 
                Salesforce_Object__c = salesForceObject, 
                Type__c              = 'Create', 
                New__c               = true, 
                Result_Holder__c     = '{Connection_' + salesForceObject + '}'
            );

            connections.add(connection);

        }

        insert connections;

        return connections;
    }

    public static List<forms__Form_Connection_Field__c> generateConnectionFields(forms__Form_Connection__c connection, Map<String, Id> mappingFieldNames){

        List<forms__Form_Connection_Field__c> connectionFields = new List<forms__Form_Connection_Field__c>();

        for(String field : mappingFieldNames.keySet()) {
            
            Id questionId = mappingFieldNames.get(field);

            forms__Form_Connection_Field__c connectionField = new forms__Form_Connection_Field__c(
                forms__Form_Connection__c = connection.Id, 
                Salesforce_Field__c        = '' + field, 
                forms__Form_Question__c   =  questionId
            );

            connectionFields.add(connectionField);

        }

        insert connectionFields; 

        return connectionFields;

    }

    public static List<forms__Form_Connection_Field__c> generateCustomConnectionFields(forms__Form_Connection__c connection, Map<String, String> mappingFieldNames){

        List<forms__Form_Connection_Field__c> connectionFields = new List<forms__Form_Connection_Field__c>();

        for(String field : mappingFieldNames.keySet()) {
            
            String customValue = mappingFieldNames.get(field);

            forms__Form_Connection_Field__c connectionField = new forms__Form_Connection_Field__c(
                forms__Form_Connection__c = connection.Id, 
                Salesforce_Field__c        = '' + field, 
                Custom_Value__c            =  customValue
            );

            connectionFields.add(connectionField);

        }

        insert connectionFields; 

        return connectionFields;

    }

    public static forms__Form_Response__c generateResponse(forms__Form__c form){

        forms__Form_Response__c response = new forms__Form_Response__c(Status__c = 'New', forms__Form__c = form.Id);

        insert response;

        return response; 

    }

    public static void generateAnswers(forms__Form_Response__c response, List<forms__Form_Question__c> questions){

        List<forms__Form_Answer__c> answers = new List<forms__Form_Answer__c>();

        for(forms__Form_Question__c question : questions) {

            forms__Form_Answer__c answer = new forms__Form_Answer__c(
                forms__Form_Response__c = response.Id,
                forms__Form_Question__c = question.Id,
                Answer__c                = 'Answer for: ' + question.Title__c
            );

            answers.add(answer);

        }

        insert answers; 

    }
    
    public static void updateAnswer(forms__Form_Response__c response, forms__Form_Question__c question){

        forms__Form_Answer__c answer = [SELECT Id FROM forms__Form_Answer__c WHERE forms__Form_Question__c =: question.Id LIMIT 1];

        answer.Answer__c = 'Answer for: ' + question.Title__c;

        update answer; 

    }
    
    private static List<String> Types {
        get {

            if(Types == null) {

                Types = new List<String>();

               	Schema.DescribeFieldResult fieldResult = forms__Form_Question__c.Type__c.getDescribe();

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
