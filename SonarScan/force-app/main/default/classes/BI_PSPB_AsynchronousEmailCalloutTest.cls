/**
 * @description Test class for BI_PSPB_AsynchronousEmailCallout class.
 */
@isTest
public class BI_PSPB_AsynchronousEmailCalloutTest {
    private static String BIPSPBEndPoint;
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
    static void testSendEmailWithoutAccessToken() {
        // Prepare test data
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Phone = '1234567890'
        );
        insert testContact;
        List<Id> testContactListId = new List<Id>();
        if (testContact != null) {
            testContactListId.add(testContact.Id);
        }
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        //BI_PSPB_Omnichannel_API_Setting__mdt settings1 = getTestMethodSetting();
        //BI_PSPB_Notification__mdt notifications = getTestMethodSetting2();
        Test.startTest();
        BI_PSPB_AsynchronousEmailCallout.sendEmail(
            testContactListId,
            'BI_PSP_Enrollment',
            'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
            '',
            'Raja'
        );
        Test.stopTest();
        Assert.areEqual(
            1,
            Limits.getEmailInvocations(),
            'An email should have been sent'
        );
    }
    /* @description Test class verifies the functionality of sending emails to contacts, validating proper handling of HTTP callouts and metadata retrieval for email settings and notifications.*/
    @isTest
    static void testSendEmail() {
        // Prepare test data
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@gamil.com'
        );
        insert testContact;
        List<Id> testContactListId = new List<Id>();
        if (testContact != null) {
            testContactListId.add(testContact.Id);
        }
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;

        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        // Retrieve metadata records
        Test.startTest();
        // Ensure that the lists settings and notifications are not empty

        BI_PSPB_AsynchronousEmailCallout.sendEmail(
            testContactListId,
            'BI_PSP_Enrollment',
            'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
            '',
            'Raja'
        );
        Test.stopTest();
        Integer expectedSmsLogsCount = 1; // Expected count of email logs
        Integer actualSmsLogsCount = [
            SELECT COUNT()
            FROM BI_PSPB_OmnichannelLog__c
        ];
        Assert.areEqual(
            expectedSmsLogsCount,
            actualSmsLogsCount,
            'Email log record count should match'
        );
    }
    /* @description Test class includes a method to retrieve a test metadata setting for SMS endpoint, ensuring proper configuration for omnichannel API integration.*/

    private static BI_PSPB_Omnichannel_API_Setting__mdt getTestMethodSetting() {
        BI_PSPB_Omnichannel_API_Setting__mdt notificationSetting = new BI_PSPB_Omnichannel_API_Setting__mdt(
            DeveloperName = 'BI_PSPB_SmsEndpoint',
            BI_PSPB_EndPoint__c = 'Test End Point',
            BI_PSPB_ClientSecret__c = 'Test Client Secret',
            BI_PSPB_ClientId__c = 'Test Client Id'
        );
        return notificationSetting;
    }
    private static BI_PSPB_Notification__mdt getTestMethodSetting2() {
        BI_PSPB_Notification__mdt notificationSetting2 = new BI_PSPB_Notification__mdt(
            DeveloperName = 'BI_PSP_NewArticleSms',
            BI_PSPB_SmsBody__c = 'Test SMS Body',
            BI_PSPB_EventName__c = 'Test Event Name',
            BI_PSPB_EventType__c = 'Test Event Type',
            BI_PSPB_Subject__c = 'Test Subject'
        );
        return notificationSetting2;
    }
    /*@description Test class validates the sendEmail method with notification date for asynchronous email callouts, ensuring proper logging of email notifications in the system.*/
    @isTest
    static void testSendEmailWithNotificationDate() {
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Phone = '1234567890'
        );
        insert testContact;
        List<Id> testContactListId = new List<Id>();
        if (testContact != null) {
            testContactListId.add(testContact.Id);
        }
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        // String labelValue = System.Label.BI_PSPB_GetAccessToken;
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        //BI_PSPB_Omnichannel_API_Setting__mdt settings1 = getTestMethodSetting();
        // BI_PSPB_Notification__mdt notifications = getTestMethodSetting2();

        // Call the sendEmail method with test data
        Test.startTest();
        BI_PSPB_AsynchronousEmailCallout.sendEmail(
            testContactListId,
            'BI_PSP_Enrollment',
            'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
            '2024-02-28',
            ''
        );
        Test.stopTest();

        // Assert your expectations here
        // For example, check if email log record is inserted
        Integer expectedEmailLogsCount = 1;
        Integer actualEmailLogsCount = [
            SELECT COUNT()
            FROM BI_PSPB_OmnichannelLog__c
        ];
        Assert.areEqual(
            expectedEmailLogsCount,
            actualEmailLogsCount,
            'Email log record count should match'
        );
    }
    /* @descriptionTest class verifies the sendEmail method behavior when invoked without a notification date, ensuring proper handling of null values and logging of email notifications.
     */
    @isTest
    static void testSendEmailWithoutNotificationDate() {
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Phone = '1234567890'
        );
        insert testContact;
        List<Id> testContactListId = new List<Id>();
        if (testContact != null) {
            testContactListId.add(testContact.Id);
        }
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        //String labelValue = System.Label.BI_PSPB_GetAccessToken;
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        //BI_PSPB_Omnichannel_API_Setting__mdt settings1 = getTestMethodSetting();
        // BI_PSPB_Notification__mdt notifications = getTestMethodSetting2();

        // Call the sendEmail method with test data
        try {
            Test.startTest();
            BI_PSPB_AsynchronousEmailCallout.sendEmail(
                testContactListId,
                'BI_PSP_Enrollment',
                'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
                '', // Pass empty string to simulate null notificationDate
                ''
            );
            Test.stopTest();

            // Assert your expectations here
            // For example, check if email log record is inserted
            Integer expectedEmailLogsCount = 1;
            Integer actualEmailLogsCount = [
                SELECT COUNT()
                FROM BI_PSPB_OmnichannelLog__c
            ];
            Assert.areEqual(
                expectedEmailLogsCount,
                actualEmailLogsCount,
                'Email log record count should match'
            );
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
    }
    /*@description Test class verifies the logging functionality by inserting log entries with specified severity and scope, ensuring proper event emission and delivery even with non-200 HTTP responses. */
    @isTest
    static void testLogMessageInsertOKWithScope() {
        Test.startTest();
        BI_SFCOE_LOG_Util.push();
        BI_SFCOE_LOG_Util.logMessage(
            'BI_TM_Class',
            null,
            System.now(),
            'This is an INFO message',
            BI_SFCOE_LOG_Util.LOG_SEVERITY_INFO
        );
        BI_SFCOE_LOG_Util.pop();
        BI_SFCOE_LOG_Util.emit();
        Test.getEventBus().deliver(); // Force to send the platform events
        Test.stopTest();

        List<BI_SFCOE_LOG_Log_Entry__c> logEntryList = [
            SELECT BI_SFCOE_LOG_Class__c
            FROM BI_SFCOE_LOG_Log_Entry__c
        ];
        //Assert.areEqual(logEntryList.size(), 2);
        Assert.areEqual(
            2,
            logEntryList.size(),
            'Expected size of logEntryList is 2'
        );

        //System.assertEquals(logEntryList.get(0).BI_SFCOE_LOG_Class__c, 'BI_TM_Class');
    }
    /**
     *  @description    MockNon200HttpResponse is a mock HTTP callout class used to simulate a non-200 HTTP response.
     */
    public class MockNon200HttpResponse implements HttpCalloutMock {
        /**
         * @description Responds to the HTTP request with a non-200 status code and a JSON body.
         * @param req The HTTP request.
         * @return The HTTP response with a non-200 status code and a JSON body.
         */
        public HTTPResponse respond(HTTPRequest req) {
            // Create a new HTTPResponse object
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "failed"}');
            // Set the desired status code in the response
            res.setStatusCode(400);
            // Set the response body
            //res.setBody('{"status": "Success", "Message Id": "123"}');
            res.setBody('{"payload": "payload"}');
            // Return the response
            return res;
        }
    }

    /*@description Test class validates the email sending functionality, handling errors gracefully by simulating a non-200 HTTP response, and ensuring no email logs are created when encountering errors.*/
    @isTest
    static void testSendEmailcatch() {
        // Prepare test data
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Phone = '1234567890'
        );
        insert testContact;
        List<Id> testContactListId = new List<Id>();
        if (testContact != null) {
            testContactListId.add(testContact.Id);
        }
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;

        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockNon200HttpResponse());

        // Retrieve metadata records
        /*List<BI_PSPB_Omnichannel_API_Setting__mdt> settings = getTestMethodSetting();
         List<BI_PSPB_Notification__mdt> notifications = getTestMethodSettingss();*/

        Test.startTest();

        // Ensure that the lists settings and notifications are not empty

        BI_PSPB_AsynchronousEmailCallout.sendEmail(
            null,
            'BI_PSP_Enrollment',
            'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
            '2024-02-28',
            'Raja'
        );

        Test.stopTest();
        Integer expectedSmsLogsCount = 0; // Expected count of email logs
        Integer actualSmsLogsCount = [
            SELECT COUNT()
            FROM BI_PSPB_OmnichannelLog__c
        ];
        Assert.areEqual(
            expectedSmsLogsCount,
            actualSmsLogsCount,
            'Email log record count should match'
        );
    }
    /*@description  Test class verifies the behavior of sending SMS notifications, ensuring that no log records are created in case of a non-200 HTTP response.*/
    @isTest
    static void testSendSMSnegative() {
        // Prepare test data
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@gmail.com'
        );
        insert testContact;
        List<Id> testContactListId = new List<Id>{ testContact.Id };

        // Mock HTTP callout with non-200 status code
        Test.setMock(HttpCalloutMock.class, new MockNon200HttpResponse());

        Test.startTest();

        // Call the method under test
        BI_PSPB_AsynchronousEmailCallout.sendEmail(
            testContactListId,
            'BI_PSPB_Challenges',
            'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
            '29-2-2023',
            ''
        );

        Test.stopTest();

        // Verify that BI_PSPB_OmnichannelLog__c records are created
        List<BI_PSPB_OmnichannelLog__c> createdLogs = [
            SELECT Id
            FROM BI_PSPB_OmnichannelLog__c
        ];
        Assert.areEqual(
            0,
            createdLogs.size(),
            'BI_PSPB_OmnichannelLog__c records should be created'
        );
    }
    /* @description Test class verifies the behavior of sending email notifications when the contact is null, ensuring no log records are created in such scenarios. */
    @isTest
    static void testSendEmailContactNull() {
        // Prepare test data
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@gmail.com'
        );
        insert testContact;
        List<Id> testContactListId = new List<Id>{ testContact.Id };

        // Mock HTTP callout with non-200 status code
        Test.setMock(HttpCalloutMock.class, new MockNon200HttpResponse());

        Test.startTest();

        // Call the method under test
        BI_PSPB_AsynchronousEmailCallout.sendEmail(
            testContactListId,
            'BI_PSPB_Challenges',
            'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
            '2024-02-28',
            ''
        );

        Test.stopTest();

        // Verify that BI_PSPB_OmnichannelLog__c records are created
        List<BI_PSPB_OmnichannelLog__c> createdLogs = [
            SELECT Id
            FROM BI_PSPB_OmnichannelLog__c
        ];
        Assert.areEqual(
            0,
            createdLogs.size(),
            'BI_PSPB_OmnichannelLog__c records should be created'
        );
    }
}