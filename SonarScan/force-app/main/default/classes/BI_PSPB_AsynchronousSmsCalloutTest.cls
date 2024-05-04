/*
*********************************************************
Apex Class Name    : BI_PSPB_AsynchronousSmsCalloutTest
Created Date       : 23.02.2024,
@description       : Test class for BI_PSPB_AsynchronousSmsCallout.
* This class contains unit tests for the methods in the BI_PSPB_AsynchronousSmsCallout class. 
* This test class provides unit tests for the functionality implemented in the BI_PSPB_AsynchronousSmsCallout class.
* It includes tests for sending SMS messages asynchronously and inserting email logs asynchronously.
@author            : Rajaa.s
Modification Log:
Ver   Date         Author                               Modification
59    29.02.2024   Rajaa.s                     Initial Version
*********************************************************
*/

/**
 * @description MockHttpResponse class to simulate HTTP callouts.
 */

 @isTest
 public class BI_PSPB_AsynchronousSmsCalloutTest {
     /**
      * @description MockHttpResponse class to simulate HTTP callouts.
      */
     public class MockHttpResponse implements HttpCalloutMock {
         /**
          * @description Responds to an HTTP request with a mock HTTP response.
          *
          * @param req The HTTP request.
          * @return The mock HTTP response.
          */
         public HTTPResponse respond(HTTPRequest req) {
             // Create a new HTTPResponse object
             HttpResponse res = new HttpResponse();
             res.setHeader('Content-Type', 'application/json');
             res.setBody('{"status": "success"}');
             // Set the desired status code in the response
             res.setStatusCode(200);
             // Set the response body
             //res.setBody('{"status": "Success", "Message Id": "123"}');
             res.setBody('{"access_token": "mock_access_token"}');
             // Return the response
             return res;
         }
     }
 
     /**
      * Test method to verify the behavior of the sendSMS method.
      *
      * @description This test method verifies that the sendSMS method correctly sends an SMS to a contact.
      */
     @isTest
     static void testSendSMS() {
         // Prepare test data
         Contact testContact = new Contact(
             FirstName = 'Test',
             LastName = 'Contact',
             Phone = '1234567890'
         );
         insert testContact;
         List<Id> testContactListId = new List<Id>{ testContact.Id };       
 
         // Mock HTTP callout
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
 
         Test.startTest();
 
         // Call the method under test
         BI_PSPB_AsynchronousSmsCallout.sendSMS(
             testContactListId,
             'BI_PSPB_ChallengesSms',
             'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
             '2024-02-28'
         );
 
         Test.stopTest();
 
         // Add assertions to verify the expected behavior
         Integer expectedSmsLogsCount = 0; // Expected count of SMS logs
         Integer actualSmsLogsCount = [
             SELECT COUNT()
             FROM BI_PSPB_OmnichannelLog__c
         ];
         Assert.areEqual(
             expectedSmsLogsCount,
             actualSmsLogsCount,
             'SMS log record count should match'
         );
     }
 
     // Helper method to create a test instance of BI_PSPB_Omnichannel_API_Setting__mdt
     private static BI_PSPB_Omnichannel_API_Setting__mdt getTestMethodSetting() {
         BI_PSPB_Omnichannel_API_Setting__mdt setting = new BI_PSPB_Omnichannel_API_Setting__mdt(
             DeveloperName = 'BI_PSPB_SmsEndpoint',
             BI_PSPB_EndPoint__c = 'Test End Point',
             BI_PSPB_ClientSecret__c = 'Test Client Secret',
             BI_PSPB_ClientId__c = 'Test Client Id'
         );
         return setting;
     }
 
     // Helper method to create a test instance of BI_PSPB_Notification__mdt
     private static BI_PSPB_Notification__mdt getTestMethodSetting2() {
         BI_PSPB_Notification__mdt notification = new BI_PSPB_Notification__mdt(
             DeveloperName = 'BI_PSP_NewArticleSms',
             BI_PSPB_SmsBody__c = 'Test SMS Body',
             BI_PSPB_EventName__c = 'Test Event Name',
             BI_PSPB_EventType__c = 'Test Event Type',
             BI_PSPB_Subject__c = 'Test Subject'
         );
         return notification;
     }
     @isTest
     static void testSendSMSnegative() {
         // Prepare test data
         Contact testContact = new Contact(
             FirstName = 'Test',
             LastName = 'Contact',
             Phone = '1234567890'
         );
         insert testContact;
         List<Id> testContactListId = new List<Id>{ testContact.Id };
 
         // Mock HTTP callout with non-200 status code
         Test.setMock(HttpCalloutMock.class, new MockNon200HttpResponse());
 
         Test.startTest();
 
         // Call the method under test
         BI_PSPB_AsynchronousSmsCallout.sendSMS(
             testContactListId,
             'BI_PSPB_ChallengesSms',
             'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
             '2024-02-28'
         );
 
         Test.stopTest();
 
         // Verify that BI_PSPB_OmnichannelLog__c records are created
         List<BI_PSPB_OmnichannelLog__c> createdLogs = [
             SELECT Id
             FROM BI_PSPB_OmnichannelLog__c
         ];
         Assert.areEqual(
             1,
             createdLogs.size(),
             'BI_PSPB_OmnichannelLog__c records should be created'
         );
     }
 
     // Nested class for mock HTTP response with status code other than 200
     public class MockNon200HttpResponse implements HttpCalloutMock {
         public HTTPResponse respond(HTTPRequest req) {
             // Create a new HTTPResponse object
             HttpResponse res = new HttpResponse();
             res.setStatusCode(400); // Set any status code other than 200 for testing
             return res;
         }
     }
 }