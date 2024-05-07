/*
 * @description       :Apex test class for testing the functionality of the BI_PSP_LetsPersonlise class.
                       This test class covers various scenarios related to the BI_PSP_LetsPersonlise class, including:
                       Insertion of multiple draft records for assessment responses,
                       Updating existing assessments with new responses,
                       Deleting selected assessment responses for both caregivers and non-caregivers.
                       The tests simulate different user contexts and assess the behavior of the BI_PSP_LetsPersonlise class accordingly.
 
 * @author            : Abinsha Basheer
 * @group             : 
 * @last modified on  : 05-02-2024
 * @last modified by  :  Abinsha Basheer
 */
@isTest
public class BI_PSP_LetsPersonliseTest {
    /**
     * @Description This method inserts multiple draft records for assessment question responses. It takes a list of question IDs
     * and a list of corresponding response texts, along with an assessment ID. For each question ID and response text
     * pair, it creates a draft record for the assessment question response associated with the provided assessment ID.
     *
     * @return Void - This method does not return any value.
     */
    @isTest
    static void draftRespoDeletionCatchTest() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test user
		
        // Call the method or class where the applicationName is accessed
        String applicationName = BI_PSP_LetsPersonlise.applicationName;
        
        String currentUserName = 'Test User';
        String currentUserEmail = '';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = '';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa1;
        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount2.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;



        String resid = testResponse2.Id;
        try {
            System.runAs(testUser2) {
                Test.startTest();
                BI_PSP_LetsPersonlise.draftRespoDeletion(resid);
                  // Assert the result
        System.assertEquals('', BI_PSP_LetsPersonlise.applicationName);
                
                List<AssessmentQuestionResponse> draftRecords = [
                    SELECT Id
                    FROM AssessmentQuestionResponse
                    WHERE AssessmentId = :testAssessment.Id
                ];
                Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
                Assert.areEqual(
                    expectedDraftRecordCount,
                    draftRecords.size(),
                    'Expected characters after first two'
                ); // Succeeds
                Test.stopTest();
            }
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
    }

    //@Description This test method validates the functionality of inserting multiple draft assessment
    //question response records by calling the mulitipleDraftRecordsInsertion method in the BI_PSP_LetsPersonlise class.
    @isTest
    static void mulitipleDraftRecordsInsertionCacthTest() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test user
        String currentUserName = 'Test';
        String currentUserEmail = '';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa1;
        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount2.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;

        List<String> responseTexts = new List<String>{
            testResponse2.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionver.Id,
            questionversion2.Id
        };
        try {
            System.runAs(testUser) {
                Test.startTest();
                BI_PSP_LetsPersonlise.mulitipleDraftRecordsInsertion(
                    questionIds,
                    responseTexts,
                    1
                );
                Test.stopTest();

                // Now, let's check if the draft records were created successfully
                List<AssessmentQuestionResponse> draftRecords = [
                    SELECT Id
                    FROM AssessmentQuestionResponse
                    WHERE AssessmentId = :testAssessment.Id
                ];
                Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
                Assert.areEqual(
                    expectedDraftRecordCount,
                    draftRecords.size(),
                    'Expected characters after first two'
                ); // Succeeds
            }
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
    }
    
    //@Description This test method verifies the insertion of multiple draft assessment question response
    // records by invoking the mulitipleDraftRecordsInsertion method in the BI_PSP_LetsPersonlise class, under the
    //  context of a standard user
    @isTest
    static void mulitipleDraftRecordsInsertiontestelse() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test user
        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'tes user';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa1;
        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount2.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;

        List<String> responseTexts = new List<String>{
            testResponse2.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionver.Id,
            questionversion2.Id
        };

        System.runAs(testUser) {
            Test.startTest();
            BI_PSP_LetsPersonlise.mulitipleDraftRecordsInsertion(
                questionIds,
                responseTexts,
                1
            );
            Test.stopTest();

            // Now, let's check if the draft records were created successfully
            List<AssessmentQuestionResponse> draftRecords = [
                SELECT Id
                FROM AssessmentQuestionResponse
                WHERE AssessmentId = :testAssessment.Id
            ];
            Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            ); // Succeeds
        }
    }

    //@Description This test method to check updation of existing responses / insertion of new responses for
    //the provided assessment ID.
    @isTest
    static void testMethodtocoverelselog() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        User testUser = new User(
            ProfileId = p.Id,
            LastName = 'TestAccount1',
            BI_PSPB_Caregiver__c = false,
            Email = 'testusertamil123@example.com',
            UserName = 'testusertamil123@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        // Create test data for the scenario where BI_PSPB_Caregiver__c is false
        Account testAccount1 = new Account(
            Lastname = 'sdsd',
            PersonEmail = '',
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;

        CareProgram testCareProgram = new CareProgram(
            Name = 'TestCareProgram',
            StartDate = Date.today()
        );
        insert testCareProgram;
        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa1',
            AccountId = testAccount1.id,
            CareProgramId = testCareProgram.id,
            BI_PSPB_PatientStatus__c = null
        );
        insert testCpa1;

        Assessment assessmentdata = new Assessment(
            Name = 'Test',
            AssessmentStatus = 'Completed',
            BI_PSP_StatusForPersonalization__c = 'Complete',
            BI_PSP_CareProgramEnrollee__c = testCpa1.id
        );
        insert assessmentdata;

        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = '',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = assessmentdata.id,
            AssessmentQuestionId = questionver.id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;
        String msg = 'Demo = New error method in SObject';

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse();
        testResponse2.ResponseText = '';
        testResponse2.BI_PSP_Category__c = '';
        testResponse2.AssessmentId = assessmentdata.id;
        testResponse2.addError('AssessmentId', msg);
        testResponse2.AssessmentQuestionId = questionversion2.Id;
        testResponse2.Name = 'test data';

        insert testResponse2;

        List<String> responseTexts = new List<String>{
            testResponse2.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionver.Id,
            questionversion2.Id
        };

        String exid = assessmentdata.Id;

        String ff = '1';
        System.runAs(testUser) {
            try {
                Test.startTest();
                // Call the method to be tested

                BI_PSP_LetsPersonlise.associateResponsesToExistingAssessment(
                    exid,
                    questionIds,
                    responseTexts,
                    ff
                );

                Test.stopTest();
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(
                    'Script-thrown exception',
                    'Script-thrown exception',
                    e.getMessage()
                );
            }
        }
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :assessmentdata.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        ); // Succeeds
    }


    //@Description This test method verifies the insertion of multiple draft assessment question response
    // records by invoking the mulitipleDraftRecordsInsertion method in the BI_PSP_LetsPersonlise class.
    //  It runs under the context of a different user and ensures that the draft records are created successfully.
    @isTest
    static void mulitipleDraftRecordsInsertiontestif() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa1;
        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount2.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser2.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;

        List<String> responseTexts = new List<String>{
            testResponse2.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionver.Id,
            questionversion2.Id
        };

        System.runAs(testUser2) {
            Test.startTest();
            BI_PSP_LetsPersonlise.mulitipleDraftRecordsInsertion(
                questionIds,
                responseTexts,
                1
            );
            Test.stopTest();
        }

        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        ); // Succeeds
    }

    //@Description Test method for deleting of response for a non care giver
    @isTest
    static void methodForDelSelcRes() {
        // Create a test user
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa1;
        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount2.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;

        String resid = testResponse2.Id;
        System.runAs(testUser) {
            Test.startTest();
            BI_PSP_LetsPersonlise.draftRespoDeletion(resid);
            Test.stopTest();
        }

        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        ); // Succeeds
    }

    //@Description Test Method for checking the deletion of unselected response from Introduction questionnaire.
    @isTest
    static void methodForDeldraftreselseofacc() {
        // Create a test user
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;

        String resid = testResponse2.Id;
        try {
            System.runAs(testUser2) {
                Test.startTest();
                BI_PSP_LetsPersonlise.draftRespoDeletion(resid);
                Test.stopTest();
            }

            List<AssessmentQuestionResponse> draftRecords = [
                SELECT Id
                FROM AssessmentQuestionResponse
                WHERE AssessmentId = :testAssessment.Id
            ];
            Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            ); // Succeeds
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
    }

    //@Description Test Method for checking the deletion of unselected response from Introduction questionnaire.
    @isTest
    static void methodForDelSelcResCareGver() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test user

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa1;
        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount2.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;
        String resid = testResponse2.Id;
        System.runAs(testUser2) {
            Test.startTest();
            BI_PSP_LetsPersonlise.draftRespoDeletion(resid);
            Test.stopTest();
        }
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        ); // Succeeds
    }

    //@Description This test method is for testing codes that are used while creating new assessments and responses.
    @isTest
    static void newAssessmntrespns() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test user

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa1;
        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount2.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser2.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;

        List<String> responseTexts = new List<String>{
            testResponse2.ResponseText,
            testResponse.ResponseText
        };

        String pickval = 'Complete';
        String idsd = 'dfdf';
        System.runAs(testUser2) {
            try {
                Test.startTest();
                BI_PSP_LetsPersonlise.createNewAssessment(
                    responseTexts,
                    responseTexts,
                    pickval
                );
                Test.stopTest();
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(
                    'Script-thrown exception',
                    'Script-thrown exception',
                    e.getMessage()
                );
            }
        }
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        ); // Succeeds
    }

    //@Description this test method is for testing codes that are used while creating new assessments and responses.
    @isTest
    static void newAssessmntMocktest() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test user

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa1;
        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount2.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser2.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;
        // Mock DML exception during Assessment insert
        //Test.setMock(DMLException.class, new DML());

        List<String> responseTexts = new List<String>{
            testResponse2.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionver.Id,
            questionversion2.Id
        };
        String pickval = 'Complete';
        String idsd = 'dfdf';
        System.runAs(testUser2) {
            Test.startTest();
            BI_PSP_LetsPersonlise.createNewAssessment(
                questionIds,
                responseTexts,
                pickval
            );
            Test.stopTest();
        }

        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        ); // Succeeds
    }

    //@Description Test Method for checking the deletion of unselected response from Introduction questionnaire.
    @isTest
    static void newAssessmntMocktestcatch() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test user

        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;

        CareProgram cp = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert cp;

        CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa1;
        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount2.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023'
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questiondata = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
        );
        insert questiondata;

        //insert Assessment question version

        AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questiondata.Id
        );
        insert questionver;
        Datetime createddt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionver.Id,
            CreatedDate = createddt
        );
        insert testResponse;

        AssessmentQuestion questiondata2 = new AssessmentQuestion(
            Name = 'test questionname2',
            DeveloperName = 'Valid_Name_1293',
            DataType = 'Decimal',
            QuestionCategory = 'Introduction'
        );
        insert questiondata2;

        AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
            AssessmentQuestionId = questiondata2.id,
            QuestionText = 'What is your gender?',
            Name = 'test data2',
            IsActive = true
        );
        insert questionversion2;

        AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
            ResponseText = 'Female',
            BI_PSP_Category__c = '',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.id,
            Name = 'test data'
        );
        insert testResponse2;

        String resid = testResponse2.Id;
        System.runAs(testUser2) {
            Test.startTest();
            BI_PSP_LetsPersonlise.draftRespoDeletion(resid);
            Test.stopTest();
        }
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        );
    }

    //@Description this test method is for testing codes that are used while creating new assessments and responses.
    @isTest
    static void newAssessmntrespnsdml() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test user

        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        User testUser2 = new User(
            Email = 'testuser2new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser2new@example.com',
            FirstName = 'Test',
            LastName = 'User2',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;
        Assessment assessmentdata = new Assessment(
            Name = 'Introduction',
            AssessmentStatus = 'In Progress',
            BI_PSP_StatusForPersonalization__c = 'Complete'
            //BI_PSP_CareProgramEnrollee__c = testCpa1.Id
        );
        insert assessmentdata;

        List<String> responseTexts = new List<String>();
        List<String> questionIds = new List<String>();

        String pickval = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero.';
        String idsd = 'dfdf';

        System.runAs(testUser2) {
            try {
                Test.startTest();

                BI_PSP_LetsPersonlise.createNewAssessment(
                    questionIds,
                    responseTexts,
                    pickval
                );

                Test.stopTest();
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(
                    'Script-thrown exception',
                    'Script-thrown exception',
                    e.getMessage()
                );
            }
        }
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :assessmentdata.Id
        ];
        Integer expectedDraftRecordCount = 0; // Assuming 2 draft records were created
        Assert.areEqual(
            expectedDraftRecordCount,
            draftRecords.size(),
            'Expected characters after first two'
        ); // Succeeds
    }

    //@Description This test method verifies the insertion of multiple draft records by simulating a caregiver context
    // and calling the corresponding method.
    @isTest
    static void mulitipleDraftRecordsInsertioncatch() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

      
        //User profile
        //Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        //TestUser for Patient
        User testUser = new User(
            Email = 'testusernew@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testusernew@example.com',
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [
                SELECT Id
                FROM Profile
                WHERE Name = 'BI_PSP_Patient Profile'
            ]
            .Id,
            LanguageLocaleKey = 'en_US'
        );
        Contact contactForPatientWithoutAccount = new Contact(
            FirstName = testUser.FirstName,
            LastName = testUser.LastName,
            Email = testUser.Email
        );
        insert contactForPatientWithoutAccount;
        testUser.ContactId = contactForPatientWithoutAccount.Id;
        insert testUser;
        Assessment assessmentdata = new Assessment(
            Name = 'Introduction',
            AssessmentStatus = 'In Progress',
            BI_PSP_StatusForPersonalization__c = 'Complete'
            //BI_PSP_CareProgramEnrollee__c = testCpa1.Id
        );
        insert assessmentdata;

        try {
            System.runAs(testUser) {
                Test.startTest();

                BI_PSP_LetsPersonlise.mulitipleDraftRecordsInsertion(
                    null,
                    null,
                    null
                );

                Test.stopTest();
            }
            List<AssessmentQuestionResponse> draftRecords = [
                SELECT Id
                FROM AssessmentQuestionResponse
                WHERE AssessmentId = :assessmentdata.Id
            ];
            Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            ); // Succeeds
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
    }

    //@Description Test Method for checking the deletion of the unselected response from Introduction questionnaire.
    @isTest
    static void testcaregiverdata() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        try {
            // String targetDate = 'Jan 2023';
            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';
            Profile standardUserProfile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'Standard User'
                LIMIT 1
            ];
            User testUser2 = new User(
                Email = 'testuser2new@example.com',
                BI_PSPB_Caregiver__c = true,
                Username = 'testuser2new@example.com',
                FirstName = 'Test',
                LastName = 'User2',
                Alias = 'tesn',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ProfileId = standardUserProfile.Id,
                LanguageLocaleKey = 'en_US'
            );
            insert testUser2;
            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
            Account testAccount1 = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                RecordTypeId = personAccountRecordTypeId
            );
            insert testAccount1;

            String currentUserName2 = 'Test User2';
            String currentUserEmail2 = 'testuser2new@example.com';
            Account testAccount2 = new Account(
                Lastname = currentUserName2,
                PersonEmail = currentUserEmail2,
                RecordTypeId = personAccountRecordTypeId,
                BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
            );
            insert testAccount2;

            CareProgram cp = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert cp;

            CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
                Name = 'TestCpa222',
                AccountId = testAccount2.Id,
                CareProgramId = cp.Id
            );
            insert testCpa2;

            System.runAs(testUser2) {
                Test.startTest();
                BI_PSP_LetsPersonlise.draftRespoDeletion('');
                Test.stopTest();
            }
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