public class ClarityTestDataFactory {
    
    public static Clarity_Form__c generateForm(){

        Clarity_Form__c form = new Clarity_Form__c(Name = 'Clarity Form', Status__c = 'Draft'); 

        insert form; 

        return form; 

    }

    public static void publishForm(Clarity_Form__c form) {

        form.Status__c = 'Published'; 

        update form; 

    }

    public static List<Clarity_Form_Question__c> generateQuestions(Clarity_Form__c form, Integer quantity){

        List<Clarity_Form_Question__c> questions = new  List<Clarity_Form_Question__c>();

        for(Integer q = 0; q < quantity; q++) {
            
            Clarity_Form_Question__c question = new Clarity_Form_Question__c(
                Clarity_Form__c = form.Id, 
                Title__c        = 'Title: ' + q, 
                Type__c         = 'Comment',
                Order__c        = q
            );

            questions.add(question);

        }

        insert questions;

        return questions;

    }

    public static void generateAutomation(Clarity_Form_Question__c question){

    }

    public static void generateAssignments(Clarity_Form__c form){

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
                Custom_Value__c             =  customValue
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

}
