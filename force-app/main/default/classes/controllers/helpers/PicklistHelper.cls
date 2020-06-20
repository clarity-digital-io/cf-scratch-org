public with sharing class PicklistHelper {

	public static Map<String, List<String>> filterRecordGroupPicklist(List<Question__c> questions) {

        Map<String, List<String>> salesforceObjectFields = new Map<String, List<String>>(); 

        for(Question__c question : questions) {
            if(question.Record_Group__c != null && question.Type__c == 'PICKLIST') {

                if(salesforceObjectFields.get(question.Record_Group__r.Salesforce_Object__c) != null) {
                    salesforceObjectFields.get(question.Record_Group__r.Salesforce_Object__c).add(question.Salesforce_Field__c);
                } else {
                    salesforceObjectFields.put(question.Record_Group__r.Salesforce_Object__c, new List<String>{ question.Salesforce_Field__c });
                }

            }
        }

        return salesforceObjectFields;
    }

    public static Map<String, Map<String, Map<String, String>>> getSalesforcePicklistValues(Map<String, List<String>> salesforceObjectFields) {
        
        Map<String, Map<String, Map<String, String>>> values = new Map<String, Map<String, Map<String, String>>>(); 

        List<String> salesforceObjects = new List<String>(salesforceObjectFields.keySet());

        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(salesforceObjects);

        for(Schema.DescribeSobjectResult res : results) {

            List<String> fields = salesforceObjectFields.get(res.getName()); 

            Map<String, Map<String, String>> fieldPicklistValues = new Map<String, Map<String, String>>(); 

            for(String field : fields) {

                List<Schema.PicklistEntry> entries = res.fields.getMap().get(field).getDescribe().getPicklistValues();
                
                Map<String, String> picklistValues = new Map<String, String>();

                for(Schema.PicklistEntry entry : entries) {
	                if (entry.isActive()) {
                        picklistValues.put(entry.getValue(), entry.getLabel());
                    }
                }

                fieldPicklistValues.put(field, picklistValues);

            }

            values.put(res.getName(), fieldPicklistValues);

        }

        return values;

    }

}
