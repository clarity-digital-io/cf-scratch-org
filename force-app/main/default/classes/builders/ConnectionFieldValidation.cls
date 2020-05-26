/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 05/16/2019
*
* @group Form_Connection_Field__c
*
* @description On update of Form_Connection__c, if salesforce object was changed delete Form_Connection_Field__c records
*/
public class ConnectionFieldValidation {

    private static Map<Id, List<Form_Connection_Field__c>> ConnectionFields {
        get {

            if(ConnectionFields == null) {

                ConnectionFields = new Map<Id, List<Form_Connection_Field__c>>(); 

                List<Form_Connection_Field__c> fields = [SELECT Id, Form_Connection__c FROM Form_Connection_Field__c WHERE Form_Connection__c IN :Trigger.newMap.keySet()];

                for(Form_Connection_Field__c field : fields) {

                    if(ConnectionFields.get(field.Form_Connection__c) == null) {
                        ConnectionFields.put(field.Form_Connection__c, new List<Form_Connection_Field__c>{ field });
                    } else {
                        ConnectionFields.get(field.Form_Connection__c).add(field); 
                    }

                }

            }

            return ConnectionFields;

        }
        set;
    }

    public static void execute(List<Form_Connection_Field__c> fieldsToBeDeleted, Form_Connection__c oldConnection, Form_Connection__c newConnection) {

        if(oldConnection.Salesforce_Object__c != newConnection.Salesforce_Object__c) {

            List<Form_Connection_Field__c> fields = ConnectionFields.get(newConnection.Id);

            fieldsToBeDeleted.addAll(fields);

        }

    }

}