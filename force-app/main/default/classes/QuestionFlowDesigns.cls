/**
* @author efigenio.ben@clarityforms.io
* @company Clarity Forms
* @date 05/16/2019
*
* @group Clarity_Form_Question_Flow_Design__c
*
* @description 1 record of object Clarity_Form_Question_Flow_Design__c for each question - Currently No Checks
*/
public class QuestionFlowDesigns {

    public static void execute(List<Clarity_Form_Question_Flow_Design__c> flowDesignsToBeCreated, Clarity_Form_Question__c cf) {

        Clarity_Form_Question_Flow_Design__c flow = new Clarity_Form_Question_Flow_Design__c(
            Clarity_Form_Question__c = cf.Id, 
            Form_Submission__c       = false, 
            Active__c                = false
        );

        flowDesignsToBeCreated.add(flow); 

    }

}
