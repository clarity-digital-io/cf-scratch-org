public class AuditLogBuilderService {
    
    public static void execute(List<Audit_Log__c> logs, sObject newRecord, sObject oldRecord, String fieldId) {

            String sObjectType = newRecord.getSObjectType().getDescribe().getName();

            String userName = UserInfo.getName();

            String action = ''; 
            String actionTransform = ''; 
            String oldIdentifier = '';
            String newIdentifier = '';

            switch on Trigger.operationType {
                when AFTER_INSERT {
                    newIdentifier = (String)newRecord.get(fieldId);
                    action = 'Insert';
                    actionTransform = 'inserted';
                }
                when AFTER_UPDATE {
                    newIdentifier = (String)newRecord.get(fieldId);
                    oldIdentifier = (String)oldRecord.get(fieldId);
                    action = 'Update';
                    actionTransform = 'updated';
                }
                when AFTER_DELETE {
                    newIdentifier = (String)newRecord.get(fieldId);
                    action = 'Delete';
                    actionTransform = 'deleted';
                }
            }

            String logMessage = buildMessage(userName, action, sObjectType, actionTransform, oldIdentifier, newIdentifier); 

            Audit_Log__c log = new Audit_Log__c(
                Log__c      = logMessage, 
                sObject__c  = sObjectType, 
                Action__c   = action,
                Type__c     = 'Builder'
            );

            logs.add(log); 

    }

    public static String buildMessage(String userName, String action, String sObjectType, String actionTransform, String oldIdentifier, String newIdentifier) {

        if(action == 'Update') {
        
            return userName + ' ' + actionTransform + ' ' + sObjectType + '(' + oldIdentifier + ') to ' + sObjectType + '(' + newIdentifier + ').';

        }

        return userName + ' ' + actionTransform + ' ' + sObjectType + '(' + newIdentifier + ').';

    }

}
