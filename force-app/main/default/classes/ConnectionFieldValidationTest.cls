/**
* @author ben@clarityforms.io
* @company Clarity Forms
* @date 05/16/2019
*
* @group Form_Connection_Field__c
*
* @description On update of Form_Connection__c, if salesforce object was changed delete Form_Connection_Field__c records
*/
@isTest
public class ConnectionFieldValidationTest {

    @testSetup
    public static void setup() {
        
        Form__c form = TestDataFactory.generateForm();

        List<Question__c> questions = TestDataFactory.generateQuestions(new List<Form__c>{ form });

        Form_Connection__c connection = new Form_Connection__c(
            Form__c = form.Id, 
            Salesforce_Object__c = 'Account',
            Type__c = 'Create'
        );

        insert connection; 

        Form_Connection_Field__c field = new Form_Connection_Field__c(
            Custom_Value__c = 'Testing',
            PreFill__c = true,
            Form_Connection__c = connection.Id
        );

        insert field; 

    }

    @isTest
    public static void shouldDeleteFieldOnConnectionUpdate() {

        Form_Connection__c connection = [SELECT Id FROM Form_Connection__c];

        List<Form_Connection_Field__c> beforeFields = [SELECT Id FROM Form_Connection_Field__c];

        System.assertEquals(1, beforeFields.size());

        Test.startTest();   

            connection.Salesforce_Object__c = 'Case';     
            
            update connection; 
        
        Test.stopTest(); 

        List<Form_Connection_Field__c> afterFields = [SELECT Id FROM Form_Connection_Field__c];

        System.assertEquals(0, afterFields.size());

    }

}
