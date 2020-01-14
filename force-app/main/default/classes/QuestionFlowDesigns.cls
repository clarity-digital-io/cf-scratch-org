/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 05/16/2019
*
* @group forms__Form_Question_Flow_Design__c
*
* @description 1 record of object forms__Form_Question_Flow_Design__c for each question - Currently No Checks
*/
public class QuestionFlowDesigns {

    public static void execute(List<forms__Form_Question_Flow_Design__c> flowDesignsToBeCreated, forms__Form_Question__c cf) {

        forms__Form_Question_Flow_Design__c flow = new forms__Form_Question_Flow_Design__c(
            forms__Form_Question__c = cf.Id, 
            Form_Submission__c       = false, 
            Active__c                = false
        );

        flowDesignsToBeCreated.add(flow); 

    }

}