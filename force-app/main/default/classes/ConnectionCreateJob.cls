public class ConnectionCreateJob implements Queueable {

    @testVisible
    private static Boolean chainJob = true;

    private Integer order;

    private List<Clarity_Form_Connection__c> connections;

    private Map<Id, Clarity_Form_Answer__c> answersByQuestion;

    private Map<Id, Clarity_Form_Connection_Process__c> processByConnections;
    
    private Map<String, Id> storedResults;

    public ConnectionCreateJob(Integer order, List<Clarity_Form_Connection__c> connections, Map<Id, Clarity_Form_Answer__c> answersByQuestion, Map<Id, Clarity_Form_Connection_Process__c> processByConnections, Map<String, Id> storedResults) {
        this.order = order;
        this.connections = connections;
        this.answersByQuestion = answersByQuestion;
        this.processByConnections = processByConnections;
        this.storedResults = storedResults;
    }

    public void execute(QueueableContext context) {

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
                                    
                Schema.DescribeFieldResult fieldResult = sObjectFields.get(field.Salesforce_Field__c).getDescribe();

                Object cleanType = cleanType(fieldResult, dirtyAnswer);

                genericObject.put(field.Salesforce_Field__c, cleanType);

            }

            Database.UpsertResult record = Database.upsert(genericObject, false); 

            Clarity_Form_Connection_Process__c connectionStatus = processByConnections.get(connections[order].Id);

            if(record.isSuccess()) {

                storedResults.put(connections[order].Result_Holder__c, record.getId());
                
                connectionStatus.Salesforce_Connection_Object__c = record.getId();
                connectionStatus.Status__c = 'Success';

            } else {

                connectionStatus.Status__c = 'Failed';

            }
            
            update connectionStatus;

        }

        if((connections.size() > (order + 1)) && chainJob) 
            System.enqueueJob(new ConnectionCreateJob(order + 1, connections, answersByQuestion, processByConnections, storedResults));

        if((connections.size() > (order + 1)) && !chainJob) {
            ConnectionCreateJob job = new ConnectionCreateJob(order + 1, connections, answersByQuestion, processByConnections, storedResults);
            job.execute(null);
        }

    }

    public Object cleanType(Schema.DescribeFieldResult fieldResult, String dirtyAnswer) {
        
        Schema.DisplayType display = fieldResult.getType(); 
        
        Object cleanValue = null;

        try {
            if(display == Schema.DisplayType.Boolean) {
                cleanValue = Boolean.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Combobox) {
                cleanValue = String.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Currency) {
                Decimal c = Decimal.valueOf(dirtyAnswer);
                cleanValue = c.setScale(8, RoundingMode.HALF_EVEN);
            }
            if(display == Schema.DisplayType.Date) {
                cleanValue = Date.parse(dirtyAnswer);  
            }
            if(display == Schema.DisplayType.DateTime) {
                cleanValue = Datetime.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Double) {
                cleanValue = Decimal.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Email) {
                cleanValue = String.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.ID) {
                cleanValue = Id.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Integer) {
                cleanValue = Integer.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Long) {
                cleanValue = Long.valueOf(dirtyAnswer); 
            }
            if(display == Schema.DisplayType.MultiPicklist) {
                cleanValue = String.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Percent) {
                cleanValue = Double.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Phone) {
                cleanValue = String.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Picklist) {
                cleanValue = String.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Reference) {

                // Schema.SObjectType reference = fieldResult.getReferenceTo();

                // String referenceName = reference.getDescribe().getName(); 

                cleanValue = Id.valueOf(dirtyAnswer);

            }
            if(display == Schema.DisplayType.String) {
                cleanValue = String.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.TextArea) {
                cleanValue = String.valueOf(dirtyAnswer);
            }
            if(display == Schema.DisplayType.Time) {
                DateTime dt = Datetime.valueOf(dirtyAnswer);
                cleanValue = Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
            }
            if(display == Schema.DisplayType.URL) {
                cleanValue = String.valueOf(dirtyAnswer);
            }

        } catch (Exception e) {
            
        }

        return cleanValue; 

    }

}