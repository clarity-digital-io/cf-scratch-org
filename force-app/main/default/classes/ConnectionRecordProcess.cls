/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 07/13/2019
*
* @group Clarity_Form_Response__c
*
* @description On update or insert of Clarity_Form_Response__c, find any related connections 
*/
public class ConnectionRecordProcess {

    private static Map<Id, List<Clarity_Form_Connection__c>> Connections {
        get {

            if(Connections == null) {

                Connections = new Map<Id, List<Clarity_Form_Connection__c>>(); 

                List<Id> formIds = new List<Id>(); 

                for(Clarity_Form_Response__c response : (List<Clarity_Form_Response__c>)Trigger.new) {
                    formIds.add(response.Clarity_Form__c);
                }
                
                List<Clarity_Form_Connection__c> formConnections = [SELECT Id, Result_Holder__c, Salesforce_Object__c, Clarity_Form__c FROM Clarity_Form_Connection__c WHERE Clarity_Form__c IN :formIds];

                for(Clarity_Form_Connection__c connection : formConnections) {

                    if(Connections.get(connection.Clarity_Form__c) == null) {
                        Connections.put(connection.Clarity_Form__c, new List<Clarity_Form_Connection__c>{ connection });
                    } else {
                        Connections.get(connection.Clarity_Form__c).add(connection); 
                    }

                }

            }

            return Connections;

        }
        set;
    }

    private static Map<Id, Map<Id, Clarity_Form_Answer__c>> ResponseAnswers {
        get {
            if(ResponseAnswers == null) {

                ResponseAnswers = new Map<Id, Map<Id, Clarity_Form_Answer__c>>(); 

                List<Clarity_Form_Answer__c> answers = [SELECT Id, Clarity_Form_Question__c, Clarity_Form_Response__c, Answer__c FROM Clarity_Form_Answer__c WHERE Clarity_Form_Response__c IN :Trigger.newMap.keySet()];

                for(Clarity_Form_Answer__c answer : answers) {

                    Map<Id, Clarity_Form_Answer__c> currentResponseAnswers = new Map<Id, Clarity_Form_Answer__c>(); 

                    if(ResponseAnswers.get(answer.Clarity_Form_Response__c) != null) {
                        
                        currentResponseAnswers = ResponseAnswers.get(answer.Clarity_Form_Response__c); 

                    } else {

                        currentResponseAnswers = new Map<Id, Clarity_Form_Answer__c>(); 

                    }

                    currentResponseAnswers.put(answer.Clarity_Form_Question__c, answer);

                    ResponseAnswers.put(answer.Clarity_Form_Response__c, currentResponseAnswers);
                }

            }
            return ResponseAnswers;
        }
        set; 
    }

    public static void execute(Clarity_Form_Response__c oldResponse, Clarity_Form_Response__c response) {
        
        if(oldResponse.Status__c == 'Submitted' || response.Status__c != 'Submitted') return; 
        
        if(Connections.get(response.Clarity_Form__c) == null) return; 
        
        List<Clarity_Form_Connection__c> connections = Connections.get(response.Clarity_Form__c);

        if(connections.size() == 0)
            return; 

        Map<Id, Clarity_Form_Answer__c> answersByQuestions = ResponseAnswers.get(response.Id);

        //System.enqueueJob(new CreateConnectionRecords(connections, answers));
        Map<String, Id> storedResults = new Map<String, Id>();
        
        createConnectionRecords(0, connections, answersByQuestions, storedResults); 

    }

    public static void createConnectionRecords(Integer order, List<Clarity_Form_Connection__c> connections, Map<Id, Clarity_Form_Answer__c> answersByQuestion, Map<String, Id> storedResults) {

        List<Clarity_Form_Connection_Field__c> fields = [SELECT Id, Clarity_Form_Connection__c, Custom_Value__c, Salesforce_Field__c, Clarity_Form_Question__c FROM Clarity_Form_Connection_Field__c WHERE Clarity_Form_Connection__c =: connections[order].Id];

        if(fields.size() > 0) {

            Schema.SObjectType convertType = Schema.getGlobalDescribe().get(connections[order].Salesforce_Object__c);
            
            Map<String, Schema.SObjectField> sObjectFields = convertType.getDescribe().fields.getMap();

            SObject genericObject = convertType.newSObject();

            for(Clarity_Form_Connection_Field__c field : fields) {

                String dirtyAnswer;

                if(field.Clarity_Form_Question__c != null) {

                    dirtyAnswer = answersByQuestion.get(field.Clarity_Form_Question__c) != null ? answersByQuestion.get(field.Clarity_Form_Question__c).Answer__c : ''; 


                } else if(field.Custom_Value__c != null) {

                    dirtyAnswer = field.Custom_Value__c;

                    if(storedResults.get((String)dirtyAnswer) != null) {

                        dirtyAnswer = Id.valueOf(storedResults.get((String)dirtyAnswer)); 

                    }

                }
                                    
                Schema.DisplayType display = sObjectFields.get(field.Salesforce_Field__c).getDescribe().getType();

                Object cleanType = cleanType(display, dirtyAnswer);

                genericObject.put(field.Salesforce_Field__c, cleanType);

            }

            Database.UpsertResult record = Database.upsert(genericObject, true); 

            if(record.isSuccess()) {

                storedResults.put(connections[order].Result_Holder__c, record.getId());

            } else {

                System.debug('error (Update Clarity_Form_Connection_Process__c to Failed or Sucess with Link to Record Id): ' + record.getErrors());

            }
            
        }

        if(connections.size() >= order + 1) 
            createConnectionRecords(order + 1, connections, answersByQuestion, storedResults);

    }

    public static Object cleanType(Schema.DisplayType display, String dirtyAnswer) {

        Object cleanValue;
        
        System.debug('Schema.DisplayType: ' + display); 

        System.debug('dirtyAnswer: ' + dirtyAnswer); 

        if(display == Schema.DisplayType.Boolean) {
            return Boolean.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Combobox) {
            return String.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Currency) {
            Decimal c = Decimal.valueOf(dirtyAnswer);
            return c.setScale(8, RoundingMode.HALF_EVEN);
        }
        if(display == Schema.DisplayType.Date) {
            return Date.parse(dirtyAnswer);  
        }
        if(display == Schema.DisplayType.DateTime) {
            return Datetime.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Double) {
            return Decimal.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Email) {
            return String.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.ID) {
            try {
                cleanValue = Id.valueOf(dirtyAnswer);
            } catch (Exception e) {}
            return cleanValue;
        }
        if(display == Schema.DisplayType.Integer) {
            return Integer.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Long) {
            return Long.valueOf(dirtyAnswer); 
        }
        if(display == Schema.DisplayType.MultiPicklist) {
            return String.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Percent) {
            return Double.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Phone) {
            return String.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Picklist) {
            return String.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Reference) {
            return Id.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.String) {
            return String.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.TextArea) {
            return String.valueOf(dirtyAnswer);
        }
        if(display == Schema.DisplayType.Time) {
            DateTime dt = Datetime.valueOf(dirtyAnswer);
            return Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
        }
        if(display == Schema.DisplayType.URL) {
            return String.valueOf(dirtyAnswer);
        }

        return String.valueOf(dirtyAnswer);

    
    }

}
