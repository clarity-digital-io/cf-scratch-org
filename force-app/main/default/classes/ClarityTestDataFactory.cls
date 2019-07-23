public class ClarityTestDataFactory {
    
    public static void generateGroup() {

        // Group group = new Group(Name = 'Test Group');

        // insert group;

        // return group; 
        
    }

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

    public static Clarity_Form__c generateForm(){

        Clarity_Form__c form = new Clarity_Form__c(Name = 'Clarity Form', Status__c = 'Draft'); 

        insert form; 

        return form; 

    }

    public static void publishForm(Clarity_Form__c form) {

        form.Status__c = 'Published'; 

        update form; 

    }

    public static List<Clarity_Form_Question__c> generateQuestions(Clarity_Form__c form){

        List<Clarity_Form_Question__c> questions = new  List<Clarity_Form_Question__c>();

        Integer order = 0; 

        for(String type : Types) {

            Clarity_Form_Question__c question = new Clarity_Form_Question__c(
                Clarity_Form__c = form.Id, 
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

    public static void generateAutomation(Clarity_Form_Question__c question){

    }

    public static Clarity_Form_Assignment__c generateAssignment(Clarity_Form__c form, User u, String logic){

        Clarity_Form_Assignment__c assignment = new Clarity_Form_Assignment__c(
            Assign__c = u.Id,
            Default_Assign__c = u.Id,
            Logic__c = logic
        );

        insert assignment;

        form.Clarity_Form_Assignment__c = assignment.Id; 

        return assignment; 

    }

    public static void generateAssignmentRules(Id assignmentId, List<Clarity_Form_Question__c> questions, String type){

        List<Clarity_Form_Assignment_Rule__c> rules = new List<Clarity_Form_Assignment_Rule__c>();

        for(Clarity_Form_Question__c question : questions){

            if(question.Type__c == type) {

                Clarity_Form_Assignment_Rule__c rule = new Clarity_Form_Assignment_Rule__c(
                    Clarity_Form_Assignment__c = assignmentId,
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

    public static List<Clarity_Form_Connection__c> generateConnections(Clarity_Form__c form, List<String> connectionObjects){

        List<Clarity_Form_Connection__c> connections = new List<Clarity_Form_Connection__c>();

        for (String salesForceObject : connectionObjects) {
            
            Clarity_Form_Connection__c connection = new Clarity_Form_Connection__c(
                Clarity_Form__c      = form.Id, 
                Salesforce_Object__c = salesForceObject, 
                Type__c              = 'Create', 
                Active__c            = true, 
                Result_Holder__c     = '{Connection_' + salesForceObject + '}'
            );

            connections.add(connection);

        }

        insert connections;

        return connections;
    }

    public static List<Clarity_Form_Connection_Field__c> generateConnectionFields(Clarity_Form_Connection__c connection, Map<String, Id> mappingFieldNames){

        List<Clarity_Form_Connection_Field__c> connectionFields = new List<Clarity_Form_Connection_Field__c>();

        for(String field : mappingFieldNames.keySet()) {
            
            Id questionId = mappingFieldNames.get(field);

            Clarity_Form_Connection_Field__c connectionField = new Clarity_Form_Connection_Field__c(
                Clarity_Form_Connection__c = connection.Id, 
                Salesforce_Field__c        = '' + field, 
                Clarity_Form_Question__c   =  questionId
            );

            connectionFields.add(connectionField);

        }

        insert connectionFields; 

        return connectionFields;

    }

    public static List<Clarity_Form_Connection_Field__c> generateCustomConnectionFields(Clarity_Form_Connection__c connection, Map<String, String> mappingFieldNames){

        List<Clarity_Form_Connection_Field__c> connectionFields = new List<Clarity_Form_Connection_Field__c>();

        for(String field : mappingFieldNames.keySet()) {
            
            String customValue = mappingFieldNames.get(field);

            Clarity_Form_Connection_Field__c connectionField = new Clarity_Form_Connection_Field__c(
                Clarity_Form_Connection__c = connection.Id, 
                Salesforce_Field__c        = '' + field, 
                Custom_Value__c            =  customValue
            );

            connectionFields.add(connectionField);

        }

        insert connectionFields; 

        return connectionFields;

    }

    public static Clarity_Form_Response__c generateResponse(Clarity_Form__c form){

        Clarity_Form_Response__c response = new Clarity_Form_Response__c(Status__c = 'New', Clarity_Form__c = form.Id);

        insert response;

        return response; 

    }

    public static void generateAnswers(Clarity_Form_Response__c response, List<Clarity_Form_Question__c> questions){

        List<Clarity_Form_Answer__c> answers = new List<Clarity_Form_Answer__c>();

        for(Clarity_Form_Question__c question : questions) {

            Clarity_Form_Answer__c answer = new Clarity_Form_Answer__c(
                Clarity_Form_Response__c = response.Id,
                Clarity_Form_Question__c = question.Id,
                Answer__c                = 'Answer for: ' + question.Title__c
            );

            answers.add(answer);

        }

        insert answers; 

    }

    private static List<String> Types {
        get {

            if(Types == null) {

                Types = new List<String>();

               	Schema.DescribeFieldResult fieldResult = Clarity_Form_Question__c.Type__c.getDescribe();

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
