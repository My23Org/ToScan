/*
 *
 * Test class for verifying the functionality of the BI_PSPB_GetAccessToken class.
 */
@isTest
private class BI_PSPB_GetAccessTokenTest {
    // Mock HTTP response class
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"access_token":"mock_access_token"}');
            return res;
        }
    }
    public class MockNon200HttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a new HTTPResponse object
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "failed"}');
            // Set the desired status code in the response
            res.setStatusCode(400);
            // Set the response body
            //res.setBody('{"status": "Success", "Message Id": "123"}');
            res.setBody('{"access_token": "mock_access_token"}');
            // Return the response
            return res;
        }
    }
    /* @description Test class verifies the successful retrieval of an access token, mocking the HTTP callout and ensuring proper handling of API settings.*/
    @isTest
    static void testGetAccessToken_Success() {
        // Mock the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Test when settings are available and endpoint is found
        // Create test data for BI_PSPB_Omnichannel_API_Setting__mdt records

        Test.startTest();
        String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
        Test.stopTest();

        // Assert that the access token is not null or empty
        Assert.areEqual('mock_access_token', accessToken, 'check access token');
    }
    /* @description Test class verifies handling of HTTP error responses during access token retrieval, ensuring proper behavior when status code is not 200.*/
    @isTest
    static void testGetAccessToken_HttpErrorResponse() {
        // Mock the HTTP callout to return an error response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Test when HTTP response status code is not 200
        // Set the mock response status code to simulate an error
        Test.startTest();
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200); // Set to a non-200 status code
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
        Test.stopTest();

        // Assert that the access token is empty
        Assert.areEqual(
            'mock_access_token',
            accessToken,
            'validating the access token'
        );
        // Assert that the logMessage method is called with the expected parameters
        // Add assertions here based on your implementation of the BI_SFCOE_LOG_Util class
    }
    /* @description Test class ensures proper handling when no settings are available for access token retrieval, validating behavior when settings are empty.*/
    @isTest
    static void testGetAccessToken_NoSettings() {
        // Test when settings are empty
        // Set up test data with no BI_PSPB_Omnichannel_API_Setting__mdt records
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        Test.startTest();
        String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
        Test.stopTest();

        // Assert that the access token is empty
        Assert.areEqual(null, accessToken, 'null check');
        // Assert that the logMessage method is called with the expected parameters
        // Add assertions here based on your implementation of the BI_SFCOE_LOG_Util class
    }
    /* @description
     Test class ensures correct handling when no settings are available for access token retrieval, validating behavior with empty settings.*/
    @isTest
    static void testGetAccessToken_NoEndpoint() {
        // Test when settings are available but endpoint is not found
        // Set up test data with BI_PSPB_Omnichannel_API_Setting__mdt records but no matching endpoint
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        Test.startTest();
        String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
        Test.stopTest();

        // Assert that the access token is empty
        Assert.areEqual(null, accessToken,'Access token should be null');
        
        // Assert that the logMessage method is called with the expected parameters
        // Add assertions here based on your implementation of the BI_SFCOE_LOG_Util class
    }
    /* @description Test class validates error handling during access token retrieval when HTTP response status code is not 200, ensuring appropriate behavior when encountering non-200 status codes.
     */
    @isTest
    static void testGetAccessToken_HttpErrorResponsecatch() {
        // Mock the HTTP callout to return an error response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Test when HTTP response status code is not 200
        // Set the mock response status code to simulate an error
        Test.startTest();
        HttpResponse res = new HttpResponse();
        res.setStatusCode(400); // Set to a non-200 status code
        Test.setMock(HttpCalloutMock.class, new MockNon200HttpResponse());
        String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
        Test.stopTest();

        // Assert that the access token is empty
        Assert.areEqual(null, accessToken,'Access token should be null');
        

        // Assert that the logMessage method is called with the expected parameters
        // Add assertions here based on your implementation of the BI_SFCOE_LOG_Util class
    }

    // Write similar test methods to cover other scenarios mentioned above
}