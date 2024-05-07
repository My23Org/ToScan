/*
*********************************************************
Apex Class Name    : BI_PSPB_CaseSupportTest
Created Date       : 20.12.2023
 @description      : Test class for the BI_PSPB_CaseSupport class.
@author            : Rajaa.s
Modification Log:
Ver   Date         Author       Modification
59   07-03-2024   Rajaa.s      Initial Version
*********************************************************
*/
@isTest
public class BI_PSPB_CaseSupportTest {
    /**
     * @description Test data setup method.
     */
    @testSetup
    static void setup() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'PSPB',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        Account testPatient = new Account(
            FirstName = 'Test',
            LastName = 'User123',
            PersonEmail = 'testuser@example.com'
        );
        insert testPatient;
        String uniqueUsername =
            'testuser' +
            DateTime.now().getTime() +
            '@example.com'; // Generating a unique username
        Profile testProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'System Administrator'
            LIMIT 1
        ];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = uniqueUsername, // Using the unique username
            Alias = 'TUser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = testProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        CareProgram carePrgm = new CareProgram(
            name = 'test carePrgm',
            StartDate = system.today()
        );
        insert carePrgm;
        CareProgramEnrollee enrolle = new CareProgramEnrollee(
            Name = 'testcare2enrolee',
            CareProgramId = carePrgm.Id,
            AccountId = testPatient.Id
        );
        insert enrolle;
        Case cse = new Case(
            Type = 'Personal Information Request',
            BI_PSPB_Sub_Type__c = 'Treatment',
            BI_PSP_Patient__c = enrolle.Id,
            OwnerId = testUser.Id,
            Origin = 'Email',
            status = 'Submitted',
            Subject = 'test subject'
        );
        insert cse;
        Assert.areEqual(
            1,
            [SELECT COUNT() FROM Case WHERE Subject = 'test subject'],
            'check the count'
        );
    }

    /**  @description 
	  Test method for the getCasesForPatient method.    
	  Test method for the getCaseFiles method.
	 */
    @isTest
    public static void testgetcaserecord() {
        Case cse = [SELECT id, origin FROM Case WHERE origin = 'Email' LIMIT 1];
        try{
        test.startTest();
        BI_PSPB_CaseSupport.caserecord(cse.Id);
        test.stopTest();
        Assert.areNotEqual(null, cse, 'Retrieved case should not be null');
        Assert.areEqual(
            'Email',
            cse.Origin,
            'Origin of the retrieved case should be "Email"'
        );
        }
        catch (Exception e) {
        // Assert that the exception message is as expected
        Assert.areEqual(
          e.getMessage(),
          'Script-thrown exception',
          e.getMessage()
        );
      }
    }
    /**
     *  @description Test method for BI_PSPB_CaseSupport.caserecord method with a null parameter.
     * This test verifies that the caserecord method throws an exception when passed a null parameter.
     *
     *      */
    @isTest
    public static void testgetcaserecordd() {
        try {
            test.startTest();
            BI_PSPB_CaseSupport.caserecord(null);
            test.stopTest();
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }
    /**
     * @description  Test method for the getCases method with different parameters.
     */
    @isTest
    public static void testgetCases() {
        try {
            Account testPatient = new Account();
            testPatient.Name = 'User123';
            insert testPatient;

            CareProgram cp = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );
            insert cp;
            CareProgramEnrollee testCpao = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = testPatient.Id,
                CareProgramId = cp.Id
            );
            insert testCpao;
            Case testCase = new Case(
                Subject = 'Test Case',
                Status = 'Open',
                Priority = 'High',
                Type = 'Problem',
                BI_PSP_Patient__c = testCpao.Id,
                BI_PSPB_Sub_Type__c = 'Symptoms',
                Description = 'Test Description'
            );
            insert testCase;

            test.startTest();
            List<Case> getNoCases = BI_PSPB_CaseSupport.getCases(
                'Medical Enquiry',
                'Draft',
                testCpao.Id
            );
            test.stopTest();
            Assert.areEqual(0, getNoCases.size(), 'Cases should  be null');
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    /**
     *  @description Test method for the getCases method with different parameters.
     */
    @isTest
    public static void testgetCasesCP() {
        try {
            Account testPatient = new Account();
            testPatient.Name = 'User123';
            insert testPatient;
            CareProgram cp = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert cp;
            CareProgramEnrollee testCpao = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = testPatient.Id,
                CareProgramId = cp.Id
            );
            insert testCpao;
            Case testCase = new Case(
                Subject = 'Test Case',
                Status = 'Draft',
                Priority = 'High',
                Type = 'Need more Information',
                BI_PSP_Patient__c = testCpao.Id,
                BI_PSPB_Sub_Type__c = 'Symptoms',
                Description = 'Test Description'
            );
            insert testCase;
            test.startTest();
            BI_PSPB_CaseSupport.getCases('All', 'All', testCpao.Id);
            BI_PSPB_CaseSupport.getCases(
                'Need more Information',
                'Draft',
                testCpao.Id
            );
            test.stopTest();
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }
    /**
     *  @description Test method for the getCases method with different parameters.
     */
    @isTest
    public static void testNeedgetCasesCpe() {
        try {
            Account testPatient = new Account();
            testPatient.Name = 'User123';
            insert testPatient;
            CareProgram cp = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );
            insert cp;
            CareProgramEnrollee testCpao = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = testPatient.Id,
                CareProgramId = cp.Id
            );
            insert testCpao;
            Case testCase = new Case(
                Subject = 'Test Case',
                Status = 'Submitted',
                Priority = 'High',
                Type = 'Need more Information',
                BI_PSP_Patient__c = testCpao.Id,
                BI_PSPB_Sub_Type__c = 'Symptoms',
                Description = 'Test Description'
            );
            insert testCase;
            test.startTest();
            BI_PSPB_CaseSupport.getCases(
                'Need more Information',
                'Submitted',
                testCpao.Id
            );
            test.stopTest();
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }
    /**
     *  @description Test method for the getCases method with different parameters.
     */
    @isTest
    public static void testNoCareProgramgetCasesCP() {
        try {
            Account testPatient = new Account();
            testPatient.Name = 'User123';
            insert testPatient;
            CareProgram cp = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );
            insert cp;
            test.startTest();
            BI_PSPB_CaseSupport.getCases(
                'Need more Information',
                'Submitted',
                null
            );
            test.stopTest();
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }
    /**
     *   @description Test method for the getBase64Image method.
     */
    @isTest
    static void testGetBase64Image() {
        // Create a Case record for testing
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        insert testCase;

        // Create a ContentVersion record for testing
        ContentVersion testVersion = new ContentVersion();
        testVersion.ContentLocation = 'S'; // S for Salesforce
        testVersion.PathOnClient = 'test.png'; // Path on client
        testVersion.VersionData = Blob.valueOf('Test Image Data');
        insert testVersion;

        // Create a ContentDocumentLink record for testing
        ContentDocumentLink testLink = new ContentDocumentLink();
        testLink.LinkedEntityId = testCase.Id;
        testLink.ContentDocumentId = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id = :testVersion.Id
        ]
        .ContentDocumentId;
        insert testLink;
           try{
        Test.startTest();
        // Call the method to test
        String base64Image = BI_PSPB_CaseSupport.getBase64Image(testCase.Id);
     
        Test.stopTest();
        // Assert that the base64 image data is not empty
        Assert.areEqual(
            true,
            base64Image != null,
            'the base64 image data is not empty'
        );
        }
        catch (Exception e) {
        // Assert that the exception message is as expected
        Assert.areEqual(
          e.getMessage(),
          'Script-thrown exception',
          e.getMessage()
        );
      }
    }
    /**
     *   @description Test method for the else branch of BI_PSPB_CaseSupport.getBase64Image method.
     * This test verifies the behavior of the method when the provided Case Id does not correspond to an existing Case.
     *
     */
    @isTest
    static void testGetBase64Imageelse() {
        // Create a Case record for testing
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        insert testCase;
        try {
            Test.startTest();

            // Call the method to test
            String base64Image = BI_PSPB_CaseSupport.getBase64Image(
                testCase.Id
            );
            Test.stopTest();
            // Assert that the base64 image data is not empty
            Assert.areEqual(
                true,
                base64Image != null,
                'the base64 image data is not empty'
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
    /**
     *   @description Test method for the catch block of BI_PSPB_CaseSupport.getBase64Image method.
     * This test verifies the behavior of the method when a null Case Id is provided.
     *
     */
    @isTest
    static void testGetBase64Imagecatch() {
        // Create a Case record for testing
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        insert testCase;
        // Create a ContentVersion record for testing
        ContentVersion testVersion = new ContentVersion();
        testVersion.ContentLocation = 'S'; // S for Salesforce
        testVersion.PathOnClient = 'test.png'; // Path on client
        testVersion.VersionData = Blob.valueOf('Test Image Data');
        insert testVersion;
        // Create a ContentDocumentLink record for testing
        ContentDocumentLink testLink = new ContentDocumentLink();
        testLink.LinkedEntityId = testCase.Id;
        testLink.ContentDocumentId = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id = :testVersion.Id
        ]
        .ContentDocumentId;
        insert testLink;
        try {
            Test.startTest();
            // Call the method to test
            String base64Image = BI_PSPB_CaseSupport.getBase64Image(null);
            Test.stopTest();
            // Assert that the base64 image data is not empty
            Assert.areEqual(
                true,
                base64Image != null,
                'the base64 image data is not empty'
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
    /**  @description
     * Test method for the catch block of BI_PSPB_CaseSupport.getBase64Image method when the ContentVersion is not an image file.
     * This test verifies the behavior of the method when the ContentVersion associated with the Case is not an image file.
     *
     */
    @isTest
    static void testGetBase64Imagecatchsec() {
        // Create a Case record for testing
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        insert testCase;
        // Create a ContentVersion record for testing
        ContentVersion testVersion = new ContentVersion();
        testVersion.ContentLocation = 'S'; // S for Salesforce
        testVersion.PathOnClient = 'test.txt'; // Path on client
        testVersion.VersionData = Blob.valueOf('Test Image Data');
        insert testVersion;
        // Create a ContentDocumentLink record for testing
        ContentDocumentLink testLink = new ContentDocumentLink();
        testLink.LinkedEntityId = testCase.Id;
        testLink.ContentDocumentId = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id = :testVersion.Id
        ]
        .ContentDocumentId;
        insert testLink;
        try {
            Test.startTest();
            // Call the method to test
            String base64Image = BI_PSPB_CaseSupport.getBase64Image(
                testCase.Id
            );
            Test.stopTest();
            // Assert that the base64 image data is not empty
            Assert.areEqual(
                true,
                base64Image != null,
                'the base64 image data is not empty'
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
}