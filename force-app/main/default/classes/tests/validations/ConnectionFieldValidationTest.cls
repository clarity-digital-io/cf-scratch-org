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
    User user = TestDataFactory.generateUserWithBuilderPermissions();

    System.runAs(user) {
      Form__c form = TestDataFactory.generateForm();

      List<Question__c> questions = TestDataFactory.generateQuestions(
        new List<Form__c>{ form }
      );

      List<Question__c> savedQuestions = QuestionsService.saveQuestions(
        questions
      );

      List<Form_Connection__c> connections = TestDataFactory.generateConnections(
        true,
        form.Id,
        new List<String>{ 'Account' }
      );

      List<Form_Connection__c> connectionsSaved = FormConnectionsService.save(
        new List<Form_Connection__c>(),
        connections
      );

      List<Form_Connection_Field__c> customFields = TestDataFactory.generateCustomConnectionFields(
        connections[0].Id,
        new Map<String, String>{ 'Name' => 'Testing' }
      );

      List<Form_Connection_Field__c> customFieldsSaved = FormConnectionFieldsService.updateFields(
        customFields,
        connections[0].Id
      );
    }

  }

  @isTest
  public static void shouldDeleteFieldOnConnectionUpdate() {
    User user = [
      SELECT Id
      FROM USER
      WHERE UserName = 'test_cl@clarityforms.io'
      LIMIT 1
    ];

    System.runAs(user) {
      Form_Connection__c connection = [SELECT Id FROM Form_Connection__c];

      List<Form_Connection_Field__c> beforeFields = [
        SELECT Id
        FROM Form_Connection_Field__c
      ];

      System.assertEquals(1, beforeFields.size());

      Test.startTest();

      connection.Salesforce_Object__c = 'Case';

      List<Form_Connection__c> connectionsSaved = FormConnectionsService.save(
        new List<Form_Connection__c>(),
        new List<Form_Connection__c>{ connection }
      );

      Test.stopTest();

      List<Form_Connection_Field__c> afterFields = [
        SELECT Id
        FROM Form_Connection_Field__c
      ];

      System.assertEquals(0, afterFields.size());
    }

  }
}
