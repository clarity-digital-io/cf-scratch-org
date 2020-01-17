/**
* @author ben@clarityforms.io
* @company Clarity Forms
* @date 05/16/2019
*
* @group Clarity_Form_Connection_Field__c
*
* @description On update of Clarity_Form_Connection__c, if salesforce object was changed delete Clarity_Form_Connection_Field__c records
*/
@isTest
public class ConnectionFieldValidationTest {

    @testSetup
    public static void setup() {
        
        Clarity_Form__c form = ClarityTestDataFactory.generateForm();

        List<Clarity_Form_Question__c> questions = ClarityTestDataFactory.generateQuestions(form);

        Clarity_Form_Connection__c connection = new Clarity_Form_Connection__c(
            Clarity_Form__c = form.Id, 
            Salesforce_Object__c = 'Account',
            Type__c = 'Create'
        );

        insert connection; 

        Clarity_Form_Connection_Field__c field = new Clarity_Form_Connection_Field__c(
            Custom_Value__c = 'Testing',
            PreFill__c = true,
            Clarity_Form_Connection__c = connection.Id
        );

        insert field; 

    }

    @isTest
    public static void shouldDeleteFieldOnConnectionUpdate() {

        Clarity_Form_Connection__c connection = [SELECT Id FROM Clarity_Form_Connection__c];

        List<Clarity_Form_Connection_Field__c> beforeFields = [SELECT Id FROM Clarity_Form_Connection_Field__c];

        System.assertEquals(1, beforeFields.size());

        Test.startTest();   

            connection.Salesforce_Object__c = 'Case';     
            
            update connection; 
        
        Test.stopTest(); 

        List<Clarity_Form_Connection_Field__c> afterFields = [SELECT Id FROM Clarity_Form_Connection_Field__c];

        System.assertEquals(0, afterFields.size());

    }

}
