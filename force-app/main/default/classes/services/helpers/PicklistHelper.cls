public class PicklistHelper {
  public static List<Picklist> getValues(List<Question__c> questions) {
    List<Picklist> allPicklists = new List<Picklist>();

    Map<String, List<String>> picklistQuestions = new Map<String, List<String>>();

    for (Question__c question : questions) {
      if (question.Type__c == 'PICKLIST') {
        System.debug('question: ' + question);

        if (picklistQuestions.containsKey(question.Salesforce_Object__c)) {
          picklistQuestions.get(question.Salesforce_Object__c)
            .add(question.Salesforce_Field__c);
        } else {
          picklistQuestions.put(
            question.Salesforce_Object__c,
            new List<String>{ question.Salesforce_Field__c }
          );
        }
      }
    }

    System.debug('picklistQuestions: ' + picklistQuestions);

    for (String sObjectName : picklistQuestions.keySet()) {
      System.debug('sObjectName: ' + sObjectName);
      SObjectType sObjType = ((SObject) Type.forName(sObjectName).newInstance())
        .getSObjectType();

      Schema.DescribeSObjectResult result = sObjType.getDescribe();

      Map<String, Schema.SObjectField> fields = result.fields.getMap();

      List<String> picklists = picklistQuestions.get(sObjectName);

      for (String picklist : picklists) {
        Picklist pl = new Picklist();

        pl.sObjectName = sObjectName;
        pl.Name = picklist;
        pl.PicklistValues = new List<PicklistValue>();

        Schema.DescribeFieldResult fieldResult = fields.get(picklist)
          .getDescribe();

        Schema.SObjectField control = fieldResult.getController();

        if (control != null) {
          Schema.DescribeFieldResult controlField = control.getDescribe();
          pl.Controller = controlField.getName();
        }

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry pickListVal : ple) {
          if (pickListVal.isActive()) {
            PicklistValue plv = new PicklistValue();

            plv.Label = pickListVal.getLabel();
            plv.APIName = pickListVal.getValue();

            pl.PicklistValues.add(plv);
          }
        }

        allPicklists.add(pl);
      }
    }

    return allPicklists;
  }
}
