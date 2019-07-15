@isTest
public class ConnectionRecordProcessTest {

    @testSetup
    public static void setup(){
                
        Clarity_Form__c form = new Clarity_Form__c(Name = 'Clarity Form', Status__c = 'Draft'); 

        insert form; 

        List<Clarity_Form_Question__c> questions = new List<Clarity_Form_Question__c>();

        for(Integer q = 0; q < 10; q++) {
            
            Clarity_Form_Question__c question = new Clarity_Form_Question__c(
                Clarity_Form__c = form.Id, 
                Title__c        = 'Title: ' + q, 
                Type__c         = 'Comment',
                Order__c        = q
            );

            questions.add(question);

        }

        insert questions;

        List<String> salesForceObjects = new List<String>{ 'Opportunity', 'Case' };

        List<Clarity_Form_Connection__c> connections = new List<Clarity_Form_Connection__c>();

        for (String salesForceObject : salesForceObjects) {
            
            Clarity_Form_Connection__c connection = new Clarity_Form_Connection__c(
                Clarity_Form__c      = form.Id, 
                Salesforce_Object__c = salesForceObject, 
                Type__c              = 'Create', 
                Active__c            = true, 
                Result_Holder__c     = 'Connection_' + salesForceObject
            );

            connections.add(connection);

        }

        insert connections; 

        List<Clarity_Form_Connection_Field__c> connectionFields = new List<Clarity_Form_Connection_Field__c>();

        for(Clarity_Form_Connection__c connection : connections) {

            SObjectType sObjType = ((SObject)Type.forName(connection.Salesforce_Object__c).newInstance()).getSObjectType();

            Schema.DescribeSObjectResult result = sObjType.getDescribe();

            Map<String, Schema.SObjectField> fields = result.fields.getMap();

            for(Schema.SObjectField field : fields.values()) {

                Schema.DescribeFieldResult fieldResult = field.getDescribe();

                Schema.DisplayType display = fieldResult.getType();

                if(display == Schema.DisplayType.address || display == Schema.DisplayType.base64 || display == Schema.DisplayType.DataCategoryGroupReference) return; 

                Boolean isFieldReq  = fieldResult.isNillable();
                Boolean isFieldCreateable = fieldResult.isCreateable(); 

                if(isFieldCreateable) {

                    Clarity_Form_Connection_Field__c connectionField = new Clarity_Form_Connection_Field__c(
                        Clarity_Form_Connection__c = connection.Id, 
                        Salesforce_Field__c        = '' + field, 
                        Clarity_Form_Question__c   =  questions[0].Id
                    );

                    connectionFields.add(connectionField);

                }
            }

        }

        insert connectionFields; 

        //publish form 
        form.Status__c = 'Published'; 

        update form; 

        //create response

        Clarity_Form_Response__c response = new Clarity_Form_Response__c(Status__c = 'New', Clarity_Form__c = form.Id);

        insert response; 

        //create answers
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

    @isTest
    public static void should() {

        Clarity_Form_Response__c response = [SELECT Id, Status__c FROM Clarity_Form_Response__c Limit 1];

        Test.startTest();       
            
            response.Status__c = 'Submitted'; 

            update response; 
        
        Test.stopTest(); 


    }

}
