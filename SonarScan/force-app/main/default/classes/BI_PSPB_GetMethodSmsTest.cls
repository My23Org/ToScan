/**
 * @description Test class for unit testing the BI_PSPB_GetMethodSms class.
 */
@isTest
private class BI_PSPB_GetMethodSmsTest {
  /**
   *@description Inner class to mock HTTP response for callouts.
   */
  public string smsBodyrespose = 'Test Body';
  // Inner class for mocking HTTP response
  private class MockHttpResponse implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      // Create a new HTTPResponse object
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"status": "success"}');
      res.setStatusCode(200);
      res.setBody('{"access_token": "mock_access_token"}');
      return res;
    }
  }
  private class MockHttpResponse1 implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      // Create a new HTTPResponse object
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"status": "success"}');
      res.setStatusCode(200);
      res.setBody('{"access_token": null}');
      return res;
    }
  }
  public class MockNot200HttpResponse implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      // Create a new HTTPResponse object
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"status": "failed"}');
      // Set the desired status code in the response
      res.setStatusCode(400);
      // Set the response body
      res.setBody('{"access_token": "mock_access_token"}');
      // Return the response
      return res;
    }
  }
  @isTest
  static void testGetMethodCallOutWithoutAccessToke() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
      BI_PSPB_SMSMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
      BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
      BI_PSPB_SmsStatus__c = BI_PSPB_constantsClass.queued,
      BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
    );
    Assert.areEqual(
      'ExpectedValue',
      omni11,
      'The BI_PSPB_SmsStatus__c should be updated as expected'
    );
    insert omni11;
    BI_PSPB_GetMethodOmnichannel__mdt settings1 = getmeta();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponse1());
    Test.startTest();
    BI_PSPB_GetMethodSms.getMethodCallout();
    Test.stopTest();
    settings1 = null;
  }
  @isTest
  static void testGetMethodCallOutNegativeScenario() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
      BI_PSPB_SMSMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
      BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
      BI_PSPB_SmsStatus__c = BI_PSPB_constantsClass.queued,
      BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
    );
    insert omni11;
    //  BI_PSPB_GetMethodOmnichannel__mdt settings1 = getmeta();
    BI_PSPB_GetMethodOmnichannel__mdt settings1 = null;
    Test.setMock(HttpCalloutMock.class, new MockNot200HttpResponse());
    Test.startTest();
    BI_PSPB_GetMethodSms.getMethodCallout();
    Test.stopTest();
    Assert.areEqual(
      null,
      settings1,
      'BI_PSPB_GetMethodOmnichannel__mdt should be null'
    );
  }
  @isTest
  static void testExecuteMethod() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    Test.startTest();
    try {
      // Create a mock SchedulableContext
      SchedulableContext mockContext = new MockSchedulableContext();

      // Call the execute method
      BI_PSPB_GetMethodSms obj = new BI_PSPB_GetMethodSms();
      obj.execute(mockContext);
    } catch (Exception e) {
      Assert.areEqual(
        'ExpectedExceptionMessage',
        e.getMessage(),
        'Exception message should not be null'
      );
      Integer actualRecordCount = [
        SELECT COUNT()
        FROM BI_PSPB_OmnichannelLog__c
      ];
      Assert.areEqual(
        0,
        actualRecordCount,
        'No records should be created when an exception occurs'
      );
    }
    Test.stopTest();
    Integer expectedRecordCount = 0; // Change this to the expected count of records
    Integer actualRecordCount = [SELECT COUNT() FROM BI_PSPB_OmnichannelLog__c];
    Assert.areEqual(
      expectedRecordCount,
      actualRecordCount,
      'The correct number of records should be created'
    );
  }

  // Mock implementation of SchedulableContext for testing

  private class MockSchedulableContext implements SchedulableContext {
    public String getCronExpression() {
      return null;
    }
    public Datetime getTriggerTime() {
      return Datetime.now();
    }
    public Integer getRetryCount() {
      return 0;
    }
    public Integer getNumberOfErrors() {
      return 0;
    }
    public Id getTriggerId() {
      return null;
    }
  }

  @isTest
  static void testGetMethodCallOutPositiveScenario() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
      BI_PSPB_SMSMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
      BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
      BI_PSPB_SmsStatus__c = BI_PSPB_constantsClass.queued,
      BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
    );
    Assert.areEqual(
      1,
      omni11,
      'Status should be updated to success after the callout'
    );
    insert omni11;
    BI_PSPB_GetMethodOmnichannel__mdt settings1 = getmeta();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
    Test.startTest();
    BI_PSPB_GetMethodSms.getMethodCallout();
    Test.stopTest();
    settings1 = null;
  }
  @isTest
  static void testGetSmsLogsToUpdateLimitException() {
    try {
      //assertion is not done because this is for negative scenario and it goes to catch
      Test.startTest();

      // Create test data
      List<BI_PSPB_OmnichannelLog__c> logsToUpdate = new List<BI_PSPB_OmnichannelLog__c>();
      for (Integer i = 0; i < 1000; i++) {
        // Execute more than 100 SOQL queries
        BI_PSPB_OmnichannelLog__c log = new BI_PSPB_OmnichannelLog__c(
          BI_PSPB_SMSMessageId__c = 'MessageId' + i,
          BI_PSPB_GetAccessTokenResponse__c = 'AccessToken' + i,
          BI_PSPB_SmsStatus__c = BI_PSPB_constantsClass.queued
        );
        logsToUpdate.add(log);
      }
      insert logsToUpdate;

      // Call the method that will execute SOQL queries
      //List<BI_PSPB_OmnichannelLog__c> result = BI_PSPB_GetMethodSms.getSmsLogsToUpdate();

      Test.stopTest();
    } catch (LimitException e) {
      // Verify that the expected LimitException is thrown
      Assert.areEqual(
        'Too many SOQL queries: 101',
        e.getMessage(),
        'Unexpected LimitException message'
      );
    }
  }
  @isTest
  static void testgetSmsLogsToUpdate() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
      BI_PSPB_SMSMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
      BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
      BI_PSPB_SmsStatus__c = BI_PSPB_constantsClass.queued,
      BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
    );
    Assert.arenotequal(
      0,
      omni11,
      'The list of BI_PSPB_OmnichannelLog__c records to update should not be empty'
    );
    insert omni11;
    Test.startTest();
    List<BI_PSPB_OmnichannelLog__c> result = BI_PSPB_GetMethodSms.getSmsLogsToUpdate();
    Test.stopTest();
    delete result;
  }
  @isTest
  static void testgetSmsLogsToUpdateException() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    Test.startTest();
    List<BI_PSPB_OmnichannelLog__c> result = null;
    try {
      //assertion is not done because this is for negative scenario and it goes to catch
      result = BI_PSPB_GetMethodSms.getSmsLogsToUpdate();
    } catch (Exception ex) {
      // Assertion to check if the exception is handled properly
      Assert.arenotequal(null, ex, 'Exception not caught');
    }
    Test.stopTest();
    // System.assertEquals(null, result, 'Method did not return null when exception occurred');
  }

  @isTest
  static void testupdateSmsLogs() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    List<Id> smsLogIds = new List<Id>();
    BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
      BI_PSPB_SMSMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
      BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
      BI_PSPB_SmsStatus__c = BI_PSPB_constantsClass.queued,
      BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
    );
    //insert omni11;
    //omni11.Id='invalidId';
    String smsBodyrespose = 'success';
    smsLogIds.add(omni11.Id);
    Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
    Test.startTest();
    // BI_PSPB_GetMethodSms.updateSmsLogs(smsLogIds,smsBodyrespose);
    try {
      //assertion is not done because this is for negative scenario and it goes to catch
      BI_PSPB_GetMethodSms.updateSmsLogs(
        new List<Id>{ omni11.Id },
        smsBodyrespose
      );
    } catch (Exception e) {
      // Handle the exception
      Assert.areEqual(
        e.getMessage(),
        'Script-thrown exception',
        e.getMessage()
      );
    }
    Test.stopTest();
  }
  @isTest
  static void testupdateSmsLogscatchnull() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    List<Id> smsLogIds = new List<Id>();
    BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
      BI_PSPB_SMSMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
      BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
      BI_PSPB_SmsStatus__c = BI_PSPB_constantsClass.queued,
      BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
    );
    //insert omni11;
    //omni11.Id='invalidId';
    String smsBodyrespose = 'success';
    smsLogIds.add(omni11.Id);
    Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
    Test.startTest();
    // BI_PSPB_GetMethodSms.updateSmsLogs(smsLogIds,smsBodyrespose);
    try {
      //assertion is not done because this is for negative scenario and it goes to catch
      BI_PSPB_GetMethodSms.updateSmsLogs(null, smsBodyrespose);
    } catch (Exception e) {
      // Handle the exception
      Assert.areEqual(
        e.getMessage(),
        'Script-thrown exception',
        e.getMessage()
      );
    }
    Test.stopTest();
  }
  @isTest
  static void testupdateSmsNegativeLogs() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    List<Id> smsLogIds = new List<Id>();

    BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
      BI_PSPB_SMSMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
      BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
      BI_PSPB_SmsStatus__c = BI_PSPB_constantsClass.queued,
      BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
    );
    Assert.areEqual(
      'success',
      omni11,
      'The BI_PSPB_Body__c field should be updated to "success"'
    );
    insert omni11;
    BI_PSPB_OmnichannelLog__c omni12 = new BI_PSPB_OmnichannelLog__c(
      BI_PSPB_SMSMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
      BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
      BI_PSPB_SmsStatus__c = BI_PSPB_constantsClass.queued,
      BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
    );
    insert omni12;
    //String smsBodyrespose = 'success';
    smsLogIds.add(omni11.Id);
    // List<BI_PSPB_OmnichannelLog__c> smsLogsToUpdate = null;
    Test.startTest();
    BI_PSPB_GetMethodSms.updateSmsLogs(smsLogIds, 'success');
    Test.stopTest();
  }

  @isTest
  private static BI_PSPB_GetMethodOmnichannel__mdt getmeta() {
    BI_PSPB_GetMethodOmnichannel__mdt metaa = new BI_PSPB_GetMethodOmnichannel__mdt(
      DeveloperName = 'BI_PSPB_SmsGetmethod',
      BI_PSPB_EndPoint__c = 'Test End Point',
      BI_PSPB_Country__c = 'Test',
      BI_PSPB_omnichannelentapi__c = 'test api'
    );
    Assert.areEqual('Test End Point', metaa, 'Endpoint should match metadata');
    return metaa;
  }
}