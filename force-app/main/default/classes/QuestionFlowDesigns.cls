/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 05/16/2019
*
* @group Flow_Design__c
*
* @description 1 record of object Flow_Design__c for each question - Currently No Checks
*/
public class QuestionFlowDesigns {

    public static void execute(List<Flow_Design__c> flowDesignsToBeCreated, Question__c cf) {

        Flow_Design__c flow = new Flow_Design__c(
            Question__c = cf.Id, 
            Form_Submission__c       = false, 
            Active__c                = false
        );

        flowDesignsToBeCreated.add(flow); 

    }

}