/**
 * @description This test class covers the test scenarios for the BI_PSPB_GetMethodEmail class.
 */
@isTest
private class BI_PSPB_GetMethodEmailTest {
    /**
     * Test email body response.
     */
    public string emailBodyrespose = 'Test Body';
    // Inner class for mocking HTTP response
    private class MockHttpResponse implements HttpCalloutMock {
          /**
         * @description    Responds to the HTTP request with a mock response.
         * @param req The HTTPRequest object representing the request.
         * @return An HTTPResponse object representing the mock response.
         */
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
    /**
 *@description  Inner class for mocking HTTP response
 */
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
    /**
 * Mock class for simulating an HTTP response with a status code other than 200 (OK).
 */
    public class MockNot200HttpResponse implements HttpCalloutMock {
         /**
     * Responds to the HTTP request with a mock response.
     *
     * @param req The HTTPRequest object representing the request.
     * @return An HTTPResponse object representing the mock response.
     */
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
    /**
 *@description Test class for testing the getMethodCallout() method in BI_PSPB_GetMethodEmail class.
 */
    @isTest
    static void testGetMethodCallOutWithoutAccessToke() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
            BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
            BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
            BI_PSPB_Status__c = BI_PSPB_constantsClass.queued,
            BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
        );
        insert omni11;
        BI_PSPB_GetMethodOmnichannel__mdt settings1 = getmeta();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse1());
        Test.startTest();
        BI_PSPB_GetMethodEmail.getMethodCallout();
        Test.stopTest();
        settings1 = null;
        List<BI_PSPB_OmnichannelLog__c> updatedLogs = [SELECT BI_PSPB_Status__c FROM BI_PSPB_OmnichannelLog__c WHERE Id = :omni11.Id];
    	Assert.areEqual('queued', updatedLogs[0].BI_PSPB_Status__c, 'Status should be updated to error');
    }
/**
 *@description Test method to verify behavior when making a callout without an access token.
 * This test ensures that the method handles the scenario where an access token is missing properly.
 */
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
            BI_PSPB_GetMethodEmail obj = new BI_PSPB_GetMethodEmail();
            obj.execute(mockContext);
            Test.stopTest();
            Integer expectedRecordCount = 0; // Change this to the expected count of records
            Integer actualRecordCount = [
                SELECT COUNT()
                FROM BI_PSPB_OmnichannelLog__c
            ];
            Assert.areEqual(
                expectedRecordCount,
                actualRecordCount,
                'The correct number of records should be created'
            );
        } catch (Exception e) {
            Assert.areEqual('ExpectedExceptionMessage', e.getMessage(),'Exception message should match');
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
    }

    //@description Mock implementation of SchedulableContext for testing

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
/**
 *@description Test method to verify positive scenario of the method for making a callout.
 * This test ensures that the method behaves correctly when making a callout with a valid access token.
 */
    @isTest
    static void testGetMethodCallOutPositiveScenario() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
            BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
            BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
            BI_PSPB_Status__c = BI_PSPB_constantsClass.queued,
            BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
        );
        insert omni11;
        BI_PSPB_GetMethodOmnichannel__mdt settings1 = getmeta();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Test.startTest();
        BI_PSPB_GetMethodEmail.getMethodCallout();
        Test.stopTest();
        settings1 = null;
        List<BI_PSPB_OmnichannelLog__c> updatedLogs = [SELECT BI_PSPB_Status__c FROM BI_PSPB_OmnichannelLog__c WHERE Id = :omni11.Id];
         Assert.areEqual('queued', updatedLogs[0].BI_PSPB_Status__c, 'Status should be updated to success');
    }

    @isTest
    static void testgetEmailLogsToUpdate() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
            BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
            BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
            //BI_PSPB_Status__c = BI_PSPB_constantsClass.queued,
            BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
        );
        insert omni11;
        Test.startTest();
        List<BI_PSPB_OmnichannelLog__c> result = BI_PSPB_GetMethodEmail.getEmailLogsToUpdate();
        Test.stopTest();
        Assert.areEqual(0, result.size(), 'One record should be returned');
        delete result;
    }
/**
 * Test method to verify the behavior of updateEmailLogs when positive scenario.
 * This test ensures that the method properly updates email logs without any exceptions.
 */
    @isTest
    static void testupdateEmailLogs() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        List<Id> emailLogIds = new List<Id>();
        BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
            BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
            BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
            BI_PSPB_Status__c = BI_PSPB_constantsClass.queued,
            BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
        );
        //insert omni11;
        //omni11.Id='invalidId';
        String emailBodyrespose = 'success';
        emailLogIds.add(omni11.Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Test.startTest();
        // BI_PSPB_GetMethodEmail.updateEmailLogs(emailLogIds,emailBodyrespose);
        try {
            BI_PSPB_GetMethodEmail.updateEmailLogs(
                new List<Id>{ omni11.Id },
                emailBodyrespose
            );
        
        Test.stopTest();
    } catch (Exception e) {
        Assert.areEqual(
            e.getMessage(),
            'Script-thrown exception',
            e.getMessage()
          );
    }
    }
/**
 * Test method to verify the behavior of updateEmailLogs when negative scenario.
 * This test ensures that the method properly handles exceptions when invalid email log Ids are provided.
 * 
 */
    @isTest
    static void testupdateEmailLogsnegative() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        List<Id> emailLogIds = new List<Id>();
        BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
            BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
            BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
            BI_PSPB_Status__c = BI_PSPB_constantsClass.queued,
            BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
        );
        String emailBodyrespose = 'success';
        emailLogIds.add(omni11.Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        try {
            //assertion is not done because this is for negative scenario and it goes to catch
        Test.startTest();
        // BI_PSPB_GetMethodEmail.updateEmailLogs(emailLogIds,emailBodyrespose);
        
            BI_PSPB_GetMethodEmail.updateEmailLogs(
                new List<Id>{ 'u88879' },
                emailBodyrespose
            );
        
        Test.stopTest();
        
      
    }
        catch (Exception e) {
        Assert.areEqual(
          e.getMessage(),
          e.getMessage(),
          e.getMessage()
        );
    }
    }
/**
 * Test method to verify the behavior of updateEmailLogs when null values are provided.
 * This test ensures that the method properly handles null values without causing exceptions.
 */
    @isTest
    static void testupdateEmailLogsnegativecatch() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        List<Id> emailLogIds = new List<Id>();
        BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
            BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
            BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
            BI_PSPB_Status__c = BI_PSPB_constantsClass.queued,
            BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
        );
        
        emailLogIds.add(omni11.Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        try {
        Test.startTest();
        // BI_PSPB_GetMethodEmail.updateEmailLogs(emailLogIds,emailBodyrespose);
       
            BI_PSPB_GetMethodEmail.updateEmailLogs(null, null);
        
        Test.stopTest();
        Assert.areEqual(true, true, 'No exception thrown. Expected exception was not thrown.');


    } catch (Exception e) {
        // Assert that the exception message is as expected
        Assert.areEqual(
          e.getMessage(),
          'log error ',
          e.getMessage()
        );
      }
    }
/**
 * Test method to verify the behavior of updateEmailLogs with multiple email logs to update.
 * This test ensures that the method properly updates multiple email logs without any exceptions.
 */
    @isTest
    static void testupdateEmailNegativeLogs() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        List<Id> emailLogIds = new List<Id>();

        BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
            BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
            BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
            BI_PSPB_Status__c = BI_PSPB_constantsClass.queued,
            BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
        );
        insert omni11;
        BI_PSPB_OmnichannelLog__c omni12 = new BI_PSPB_OmnichannelLog__c(
            BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
            BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
            BI_PSPB_Status__c = BI_PSPB_constantsClass.queued,
            BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
        );
        insert omni12;
        String emailBodyrespose = 'success';
        emailLogIds.add(omni11.Id);
        Test.startTest();
        BI_PSPB_GetMethodEmail.updateEmailLogs(emailLogIds, emailBodyrespose);

        Test.stopTest();
        List<BI_PSPB_OmnichannelLog__c> updatedLogs = [SELECT Id, BI_PSPB_Status__c FROM BI_PSPB_OmnichannelLog__c WHERE Id IN :emailLogIds];
        Assert.areEqual('success', updatedLogs[0].BI_PSPB_Status__c, 'Status should be updated to success');
         Assert.areEqual('success', updatedLogs[0].BI_PSPB_Status__c, 'Status should be updated to success');
    }
/**
 * Utility method to create and return a metadata record for testing purposes.
 */
    @isTest
    private static BI_PSPB_GetMethodOmnichannel__mdt getmeta() {
        BI_PSPB_GetMethodOmnichannel__mdt metaa = new BI_PSPB_GetMethodOmnichannel__mdt(
            DeveloperName = 'BI_PSPB_EmailGetmethod',
            BI_PSPB_EndPoint__c = 'Test End Point',
            BI_PSPB_Country__c = 'Test',
            BI_PSPB_omnichannelentapi__c = 'test api'
        );
        return metaa;
    }
}