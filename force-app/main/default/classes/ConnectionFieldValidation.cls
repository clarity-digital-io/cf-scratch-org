/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 05/16/2019
*
* @group forms__Form_Connection_Field__c
*
* @description On update of forms__Form_Connection__c, if salesforce object was changed delete forms__Form_Connection_Field__c records
*/
public class ConnectionFieldValidation {

    private static Map<Id, List<forms__Form_Connection_Field__c>> ConnectionFields {
        get {

            if(ConnectionFields == null) {

                ConnectionFields = new Map<Id, List<forms__Form_Connection_Field__c>>(); 

                List<forms__Form_Connection_Field__c> fields = [SELECT Id, forms__Form_Connection__c FROM forms__Form_Connection_Field__c WHERE forms__Form_Connection__c IN :Trigger.newMap.keySet()];

                for(forms__Form_Connection_Field__c field : fields) {

                    if(ConnectionFields.get(field.forms__Form_Connection__c) == null) {
                        ConnectionFields.put(field.forms__Form_Connection__c, new List<forms__Form_Connection_Field__c>{ field });
                    } else {
                        ConnectionFields.get(field.forms__Form_Connection__c).add(field); 
                    }

                }

            }

            return ConnectionFields;

        }
        set;
    }

    public static void execute(List<forms__Form_Connection_Field__c> fieldsToBeDeleted, forms__Form_Connection__c oldConnection, forms__Form_Connection__c newConnection) {

        if(oldConnection.Salesforce_Object__c != newConnection.Salesforce_Object__c) {

            List<forms__Form_Connection_Field__c> fields = ConnectionFields.get(newConnection.Id);

            fieldsToBeDeleted.addAll(fields);

        }

    }

}