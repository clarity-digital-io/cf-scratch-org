public class FLSUtility {

	public static List<String> isSet(sObject o) {

		List<String> fields = new List<String>(); 

		Schema.SObjectType type = o.getSObjectType();

		Map<String, Schema.SObjectField> sObjectFields = type.getDescribe().fields.getMap();

		for(String field : sObjectFields.keySet()) {
			if(o.isSet(field)) {
				fields.add(field); 
			}
		}

		return fields;
	}

	public static Boolean isUpdateable(sObject o) {

		Boolean hasPermission = true; 

		List<String> fields = isSet(o); 

		Schema.SObjectType type = o.getSObjectType();

		hasPermission = isUpdateable(type.getDescribe(), fields);

		return hasPermission; 

	}

	public static Boolean isUpdateable(Schema.DescribeSObjectResult type, List<String> fields) {

		Boolean hasPermission = true; 

		if(type.isUpdateable()) {

			Map<String, Schema.SObjectField> sObjectFields = type.fields.getMap();

			for(String field : fields) {

				Schema.DescribeFieldResult fieldResult = sObjectFields.get('forms__' + field).getDescribe();

				if(!fieldResult.isUpdateable()) {
					hasPermission = false; 
					break; 
				}

			}

		} else {
			hasPermission = false; 
		}

		return hasPermission; 

	}

	public static Boolean isCreateable(sObject o) {

		Boolean hasPermission = true; 

		List<String> fields = isSet(o); 

		Schema.SObjectType type = o.getSObjectType();

		hasPermission = isCreateable(type.getDescribe(), fields);

		return hasPermission; 

	}

	public static Boolean isCreateable(Schema.DescribeSObjectResult type, List<String> fields) {

		Boolean hasPermission = true; 

		if(type.isCreateable()) {

			Map<String, Schema.SObjectField> sObjectFields = type.fields.getMap();

			for(String field : fields) {

				Schema.DescribeFieldResult fieldResult = sObjectFields.get('forms__' + field).getDescribe();

				if(!fieldResult.isCreateable()) {
					hasPermission = false; 
					break; 
				}

			}

		} else {
			hasPermission = false; 
		}

		return hasPermission; 

	}

	public static Boolean isDeleteable(Schema.DescribeSObjectResult type) {

		Boolean hasPermission = true; 

		if(!type.isDeletable()) {
			hasPermission = false; 
		}

		return hasPermission; 

	}

}
