/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 05/16/2019
*
* @group Clarity_Form_Connection_Field__c
*
* @description On update of Clarity_Form_Connection__c, if salesforce object was changed delete Clarity_Form_Connection_Field__c records
*/
public class ConnectionFieldValidation {

    private static Map<Id, List<Clarity_Form_Connection_Field__c>> ConnectionFields {
        get {

            if(ConnectionFields == null) {

                ConnectionFields = new Map<Id, List<Clarity_Form_Connection_Field__c>>(); 

                List<Clarity_Form_Connection_Field__c> fields = [SELECT Id, Clarity_Form_Connection__c FROM Clarity_Form_Connection_Field__c WHERE Clarity_Form_Connection__c IN :Trigger.newMap.keySet()];

                for(Clarity_Form_Connection_Field__c field : fields) {

                    if(ConnectionFields.get(field.Clarity_Form_Connection__c) == null) {
                        ConnectionFields.put(field.Clarity_Form_Connection__c, new List<Clarity_Form_Connection_Field__c>{ field });
                    } else {
                        ConnectionFields.get(field.Clarity_Form_Connection__c).add(field); 
                    }

                }

            }

            return ConnectionFields;

        }
        set;
    }

    public static void execute(List<Clarity_Form_Connection_Field__c> fieldsToBeDeleted, Clarity_Form_Connection__c oldConnection, Clarity_Form_Connection__c newConnection) {

        if(oldConnection.Salesforce_Object__c != newConnection.Salesforce_Object__c) {

            List<Clarity_Form_Connection_Field__c> fields = ConnectionFields.get(newConnection.Id);

            fieldsToBeDeleted.addAll(fields);

        }

    }

}