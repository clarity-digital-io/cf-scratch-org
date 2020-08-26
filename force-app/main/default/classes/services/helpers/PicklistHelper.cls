public class PicklistHelper {
	
	public static List<Picklist> getValues(List<Question__c> questions) {

		List<Picklist> allPicklists = new List<Picklist>(); 

		Map<String, List<String>> picklistQuestions = new Map<String, List<String>>(); 

		for(Question__c question : questions) {

			if(question.Type__c == 'PICKLIST') {

				if(picklistQuestions.containsKey(question.Salesforce_Object__c)) {
					picklistQuestions.get(question.Salesforce_Object__c).add(question.Salesforce_Field__c);
				} else {
					picklistQuestions.put(question.Salesforce_Object__c, new List<String>{  question.Salesforce_Field__c });
				}
			}

		}
		

		for(String sObjectName : picklistQuestions.keySet()) {

			SObjectType sObjType = ((SObject)Type.forName(objectType).newInstance()).getSObjectType();

			Schema.DescribeSObjectResult result = sObjType.getDescribe();
	
			Map<String, Schema.SObjectField> fields = result.fields.getMap();

			List<String> picklists = picklistQuestions.get(sObjectName); 

			for(String picklist: picklists) {

				Picklist pl = new Picklist(); 

				pl.sObject = sObjectName;
				pl.Name = picklist; 
				pl.PicklistValues = new List<PicklistValue>();

				Schema.DescribeFieldResult fieldResult = fields.get(picklist).getDescribe();

				List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

				for(Schema.PicklistEntry pickListVal : ple){

					PicklistValue plv = new Picklist(); 

					plv.Label = pickListVal.getLabel();
					plv.APIName = pickListVal.getValue();
					
					pl.PicklistValues.add(plv); 
					
				}

				allPicklists.add(pl); 

			}

		}

		return allPicklists; 

	}
	
}
