/*
* @description       This test class provides test methods to retrieve questionnaire questions for different categories
                     such as Work & Activity Impairment (WPAI), Introduction, Psoriasis Symptom Scale (PSS), 
                     Dermatology Life Quality Index (DLQI), and Qualitative satisfaction questionnaire.
                     It also includes test methods to handle the insertion of assessment records, including completed 
                     assessments and drafts, and test methods to get the status of assessments and counts of completed
                     assessments of the test user.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Sowmitha	05-Dec-2023		Created			Initial development.
* 1.1		Sowmitha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Sowmitha	04-Apr-2024		Updated			test cases added.
*/
@isTest
public class BI_PSP_AssessmentTest {
    public static String assessmentId;
    public static Date expireDatePss;
    public static Date expireDateWai;
    public static Date expireDateDlqi;
    public static string cpa1;
    public static String introduction = 'Introduction';
    public static String pss = System.Label.BI_PSP_PssCategory;
    public static String wapiCategory = ' (WPAI)';
    public static String dlqiCategory = System.Label.BI_PSP_DlqiCategory;
    public static String qualiCategory = System.Label.BI_PSP_QualitativeCategory;
    public static String inprogress = System.Label.BI_PSP_Inprogess;
    public static Integer expireDate = Integer.valueOf(
        System.Label.BI_PSP_ExpireDateForQualitative
    );
    //holds the error message.
    private static String errorMsg;
    //custom label for Assesssment Questions query when the result  is empty.
    private static String questionsNotavilable = System.Label.BI_PSP_QuestionsUnavailable;
    //Custom label for care givers patient.
    private static String caregiversPatientaccountErr = System.Label.BI_PSP_CaregiversPatient;
    //custom label that displays an error message when there is no account records for the selected patient.
    private static String caregiversSelectedpatienterrmsg = System.Label.BI_PSP_SelectedPatientAccount;
    // custom label that displays an error message when there is no careProgramEnrollee records for the selected patient.
    private static String selctdPatieintsenrolleeerrormsg = System.Label.BI_PSP_SelectedPatientEnrollee;
    // custom label that displays an error message when there is no Account records for the patient.
    private static String patientAccounterrormsg = System.Label.BI_PSP_PatientAccountErrormsg;
    // custom label that displays an error message when there is no care program enrollee records for the patient.
    private static String patientEnrolleeerrormsg = System.Label.BI_PSP_PatientEnrolleeErrormsg;
    // custom label that displays an error message when the submit functionality of the assessment fails.
    private static String submitErrormsg = System.Label.BI_PSP_SubmitErrorMsg;
    // custom label that displays an error message when there is no Assessmnet Record.
    private static String emptyAssesment = System.Label.BI_PSP_EmptyAssessment;
    // custom label that displays an error message when there is no AssessmnetQuestionResponse Record.
    private static String emptyQuestionaresponse = System.Label.BI_PSP_EmptyQuestionResponse;
    // custom label that displays an error message when there is no AssessmnetQuestionVersion Record.
    private static String emptyQuestionversion = System.Label.BI_PSP_EmptyQuestionVersion;
    // custom label that displays an error message when there is no rollout date present.
    private static String rolloutDateerrormessage = System.Label.BI_PSP_RolloutErrorMsg;

    // method retrieves the expected assessment question record from the database realated to the category of WAPI.
    @isTest
    static void testGetTheAssessmentQuestion() {
        // Create test data for AssessmentQuestion
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        AssessmentQuestion testQuestion = new AssessmentQuestion(
            Name = 'demofris',
            DataType = 'radio',
            DeveloperName = 'Sample_Question',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
            // Add any other required fields
        );
        insert testQuestion;

        // Create test data for AssessmentQuestionVersion
        AssessmentQuestionVersion testQuestionVersion = new AssessmentQuestionVersion(
            AssessmentQuestionId = testQuestion.Id,
            QuestionText = 'demo1',
            ResponseValues = 'noneOther',
            Name = 'blahsd'

            // Add any other required fields
        );
        insert testQuestionVersion;

        // Call the method to be tested
        try {
            Test.startTest();
            List<AssessmentQuestion> result = BI_PSP_Assessment.getTheAssesmentQuestion();
            Test.stopTest();

            // Add assertions to verify the results
            Assert.areEqual(
                1,
                result.size(),
                'Expected one AssessmentQuestion record'
            );
            // Add more assertions as needed
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Attempt to de-reference a null object',
                e.getMessage()
            );
        }
    }

    // method retrieves the expected assessment question record from the database realated to the category of WAPI.when an exception take place No questions should be returned.
    @isTest
    static void testGetTheAssesmentQuestionException() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Simulate an exception scenario
        // Assuming wapiCategory is a variable accessible in the test context

        AssessmentQuestion testQuestion = new AssessmentQuestion(
            Name = 'demofris',
            DataType = 'radio',
            DeveloperName = 'Sample_Question',
            QuestionCategory = 'Work & Activity Impairment (WPAI)'
            // Add any other required fields
        );
        insert testQuestion;

        // Create test data for AssessmentQuestionVersion
        AssessmentQuestionVersion testQuestionVersion = new AssessmentQuestionVersion(
            AssessmentQuestionId = testQuestion.Id,
            QuestionText = 'demo1',
            ResponseValues = 'noneOther',
            Name = 'blahsd'

            // Add any other required fields
        );
        insert testQuestionVersion;
        try {
            Test.startTest();

            List<AssessmentQuestion> result = BI_PSP_Assessment.getTheAssesmentQuestion();
            // Verify that an empty list is returned in case of an exception.
            Assert.areEqual(
                1,
                result.size(),
                'No questions should be returned in case of an exception'
            );

            Test.stopTest();
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Attempt to de-reference a null object',
                e.getMessage()
            );
        }
    }

    // method retrieves the expected assessment question record from the database realated to the category of Introduction.
    @isTest
    static void testGetTheAssessmentQuestionIntro() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create test data for AssessmentQuestion
        AssessmentQuestion testQuestion = new AssessmentQuestion(
            Name = 'demofris',
            DataType = 'radio',
            DeveloperName = 'Sample_Question',
            QuestionCategory = 'Introduction'
            // Add any other required fie
        );
        insert testQuestion;

        // Create test data for AssessmentQuestionVersion
        AssessmentQuestionVersion testQuestionVersion = new AssessmentQuestionVersion(
            AssessmentQuestionId = testQuestion.Id,
            QuestionText = 'demo1',
            ResponseValues = 'noneOther',
            Name = 'blahsd'

            // Add any other required fields
        );
        insert testQuestionVersion;

        // Call the method to be tested
        try {
            Test.startTest();
            List<AssessmentQuestion> result = BI_PSP_Assessment.getIntroductionAssesmentQues();
            Test.stopTest();

            // Add assertions to verify the results
            Assert.areEqual(
                1,
                result.size(),
                'Expected one AssessmentQuestion record'
            );
            // Add more assertions as needed
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Attempt to de-reference a null object',
                e.getMessage()
            );
        }
    }

    // method retrieves the expected assessment question record from the database realated to the category of Psoriasis Symptom Scale (PSS).
    @isTest
    static void testGetTheAssessmentQuestionPsoraisis() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create test data for AssessmentQuestion
        AssessmentQuestion testQuestion = new AssessmentQuestion(
            Name = 'demofris',
            DataType = 'radio',
            DeveloperName = 'Sample_Question',
            QuestionCategory = 'Psoriasis Symptom Scale (PSS)'
            // Add any other required fie
        );
        insert testQuestion;

        // Create test data for AssessmentQuestionVersion
        AssessmentQuestionVersion testQuestionVersion = new AssessmentQuestionVersion(
            AssessmentQuestionId = testQuestion.Id,
            QuestionText = 'demo1',
            ResponseValues = 'noneOther',
            Name = 'blahsd'

            // Add any other required fields
        );
        insert testQuestionVersion;
        try {
            // Call the method to be tested
            Test.startTest();
            List<AssessmentQuestion> result = BI_PSP_Assessment.getPsoriasisAssesmentQues();
            Test.stopTest();

            // Add assertions to verify the results
            Assert.areEqual(
                1,
                result.size(),
                'Expected one AssessmentQuestion record'
            );
            // Add more assertions as needed
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Attempt to de-reference a null object',
                e.getMessage()
            );
        }
    }

    // method retrieves the expected assessment question record from the database realated to the category of Dermatology Life Quality Index (DLQI).
    @isTest
    static void testGetTheAssessmentQuestionDermatology() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create test data for AssessmentQuestion
        AssessmentQuestion testQuestion = new AssessmentQuestion(
            Name = 'demofris',
            DataType = 'radio',
            DeveloperName = 'Sample_Question',
            QuestionCategory = 'Dermatology Life Quality Index (DLQI)'
            // Add any other required fie
        );
        insert testQuestion;

        // Create test data for AssessmentQuestionVersion
        AssessmentQuestionVersion testQuestionVersion = new AssessmentQuestionVersion(
            AssessmentQuestionId = testQuestion.Id,
            QuestionText = 'demo1',
            ResponseValues = 'noneOther',
            Name = 'blahsd'

            // Add any other required fields
        );
        insert testQuestionVersion;

        // Call the method to be tested
        try {
            Test.startTest();
            List<AssessmentQuestion> result = BI_PSP_Assessment.getDermatologyAssesmentQues();
            Test.stopTest();

            // Add assertions to verify the results
            Assert.areEqual(
                1,
                result.size(),
                'Expected one AssessmentQuestion record'
            );
            // Add more assertions as needed
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Attempt to de-reference a null object',
                e.getMessage()
            );
        }
    }

    // method retrieves the expected assessment question record from the database realated to the category of Qualitative satisfaction questionnaire.
    @isTest
    static void testGetQualitativeAssesmentQues() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create test data for AssessmentQuestion
        AssessmentQuestion testQuestion = new AssessmentQuestion(
            Name = 'demofris',
            DataType = 'radio',
            DeveloperName = 'Sample_Question',
            QuestionCategory = 'Qualitative satisfaction questionnaire'
            // Add any other required fie
        );
        insert testQuestion;

        // Create test data for AssessmentQuestionVersion
        AssessmentQuestionVersion testQuestionVersion = new AssessmentQuestionVersion(
            AssessmentQuestionId = testQuestion.Id,
            QuestionText = 'demo1',
            ResponseValues = 'noneOther',
            Name = 'blahsd'

            // Add any other required fields
        );
        insert testQuestionVersion;

        // Call the method to be tested
        Test.startTest();
        List<AssessmentQuestion> result = BI_PSP_Assessment.getQualitativeAssesmentQues();
        Test.stopTest();

        // Add assertions to verify the results
        Assert.areEqual(
            1,
            result.size(),
            'Expected one AssessmentQuestion record'
        );
        // Add more assertions as needed
    }

    //@Description this method is for inserting the responses of wapi,dlqi,pss Questionnaire Questions as user who is a care giver.
    @istest
    static void testRanswerOfTheQuestion2() {
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

        List<String> responseTexts = new List<String>{
            testResponse2.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionver.Id,
            questionversion2.Id
        };
        // Call the method under test
        System.runAs(testUser2) {
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method

            BI_PSP_Assessment.ranswerOfTheQuestion(questionIds, responseTexts);

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

    @isTest
    static void testranswerqncatch() {
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

        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        List<String> responseTexts = new List<String>();
        List<String> questionIds = new List<String>();
        try {
            // Ensure the test context
            Test.startTest();

            // Call the AuraEnabled method
            BI_PSP_Assessment.ranswerOfTheQuestion(questionIds, responseTexts);

            //we are using this test method to test the negative scenario so that we are not using assert in here.
            Test.stopTest();
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
    }
    //this method is for inserting the responses of wapi,dlqi,pss Questionnaire Questions as darft .
    @isTest
    static void multipleOfTheQuestion() {
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

        List<String> responseTexts = new List<String>{
            testResponse2.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionver.Id,
            questionversion2.Id
        };
        System.runAs(testUser) {
            // Call the method under test
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method
            BI_PSP_Assessment.mulitipleDraftRecordsInsertion(
                questionIds,
                responseTexts
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

    //this method is for saving the responses as drfat for dlqi.wapi,pss as a user who is a care giver.
    @isTest
    static void multipleOfTheQuestion2() {
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

        List<String> responseTexts = new List<String>{
            testResponse2.ResponseText,
            testResponse.ResponseText
        };
        List<String> questionIds = new List<String>{
            questionver.Id,
            questionversion2.Id
        };
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created

        System.runAs(testUser2) {
            // Call the method under test
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method
            BI_PSP_Assessment.mulitipleDraftRecordsInsertion(
                questionIds,
                responseTexts
            );
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            );

            Test.stopTest();
        }

    }
    //this method is for catching the responses of dlqi,wapi,pss as a user who is not a care giver.
    @isTest
    static void testmatchingcatch() {
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

        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        List<String> responseTexts = new List<String>();
        List<String> questionIds = new List<String>();
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created

        // Ensure the test context
        try {
            Test.startTest();

            // Call the AuraEnabled method
            BI_PSP_Assessment.mulitipleDraftRecordsInsertion(
                questionIds,
                responseTexts
            );
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            );
            // Ensure the test context is properly closed
            Test.stopTest();
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
    }

    //test method for retrieving the count of answered assessment questions associated with a specific assessment record.
    @istest
    static void testGetCategoryStatus() {
        try {
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
                Name = 'Work & Activity Impairment (WPAI)',
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
                QuestionCategory = 'Work & Activity Impairment (WPAI)'
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
            // Call the method under test
            Test.startTest();

            // Use the test Assessment Id in the method
            Integer result = BI_PSP_Assessment.getCategoryStatus(
                testAssessment.Id
            );

            Test.stopTest();

            // Add assertions to verify the expected behavior
            // For example, check if the count of answered questions matches the expected value

            Assert.areEqual(2, result, 'Expected 2 answered questions');
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }

        // You can add more assertions based on your specific use case and requirements
    }

    //test method for retrieving the total count of assessment questions belonging to a specified category, such as "Introduction".
    @istest
    static void testgetTotalquestionscount() {
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
        try {
            Test.startTest();

            // Use the test Assessment Id in the method
            Integer result = BI_PSP_Assessment.getTotalquestionscount(
                'Introduction'
            );

            Test.stopTest();

            // Add assertions to verify the expected behavior
            // For example, check if the count of answered questions matches the expected value
            Assert.areEqual(1, result, 'Expected 1 testtt answered questions');
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }

        // You can add more assertions based on your specific use case and requirements
    }

    //test method, which retrieves assessment counts for the current user. It ensures that the method returns the expected assessment count for the user within the specified context.
    @isTest
    static void testGetAssessmentCountsByCurrentUserName() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        // Retrieve the ProfileId for the desired profile (replace 'Your Profile Name' with the actual name)

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

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;

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

        Assessment testAssessment = new Assessment(
            Name = 'Work & Activity Impairment (WPAI)',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023',
            BI_PSP_CareProgramEnrollee__c = testCpa1.Id
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
        System.runAs(testUser) {
            // Call the method under test
            Test.startTest();

            // Use the test category name in the method
            List<Integer> result = BI_PSP_Assessment.getAssessmentCountsByCurrentUserName();

            Test.stopTest();

            // Add assertions to verify the expected behavior
            // For example, check if the result list has the expected size
            Assert.areEqual(4, result.size(), 'Expected 1 assessment count');
        }


        // You can add more assertions based on your specific use case and requirements
    }
    //this test method, ensuring it correctly retrieves assessment counts for the current user within a specific context.
    @isTest
    static void testGetAssessmentCountsByCurrentUserName2() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        // Retrieve the ProfileId for the desired profile (replace 'Your Profile Name' with the actual name)

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

        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Test Assessment',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023',
            BI_PSP_CareProgramEnrollee__c = testCpa2.Id
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

        System.runAs(testUser2) {
            // Call the method under test
            Test.startTest();

            // Use the test category name in the method
            List<Integer> result = BI_PSP_Assessment.getAssessmentCountsByCurrentUserName();

            Test.stopTest();

            // Add assertions to verify the expected behavior
            // For example, check if the result list has the expected size
            Assert.areEqual(4, result.size(), 'Expected 1 assessment count');
        }


        // You can add more assertions based on your specific use case and requirements
    }

    //test method for retrieving questionnaire setup records for a care program enrollee. It ensures that the method correctly returns the expected questionnaire setup records within the test context.
    @isTest
    static void testGetRolloutdateCaregiverTrue() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Test data setup

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

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;

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

        BI_PSP_Questionnaire_Setups__c qsq = new BI_PSP_Questionnaire_Setups__c(
            BI_PSP_CareProgramEnrollee__c = testCpa1.Id,
            Name = testCpa1.Name,
            BI_PSP_WAI_RollOutDate__c = Date.valueOf('2024-02-28'),
            BI_PSP_PSS_RollOutDate__c = Date.valueOf('2024-02-28'),
            BI_PSP_DLQI_RollOutDate__c = Date.valueOf('2024-02-28')
        );
        insert qsq;
        System.runAs(testUser) {
            // Ensure the test context
            Test.startTest();

            // Call the AuraEnabled method
            List<BI_PSP_Questionnaire_Setups__c> result = BI_PSP_Assessment.getRolloutdate();

            // Add assertions

            // Add more specific assertions based on your test data and expectations

            // Ensure the test context is properly closed
            Test.stopTest();
            Assert.areEqual(1, result.size(), 'returns qn setupss1');
        }
    }
    //test method for retrieving questionnaire setup records for a care program enrollee when the user is not a caregiver. It ensures that the method returns the expected questionnaire setup records within the test context.
    @isTest
    static void testGetRolloutdateCaregiverfalse() {
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

        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        BI_PSP_Questionnaire_Setups__c qsq = new BI_PSP_Questionnaire_Setups__c(
            BI_PSP_CareProgramEnrollee__c = testCpa2.Id,
            Name = testCpa2.Name,
            BI_PSP_WAI_RollOutDate__c = Date.valueOf('2024-02-28'),
            BI_PSP_PSS_RollOutDate__c = Date.valueOf('2024-02-28'),
            BI_PSP_DLQI_RollOutDate__c = Date.valueOf('2024-02-28')
        );

        insert qsq;
        System.runAs(testUser2) {
            // Ensure the test context
            Test.startTest();

            // Call the AuraEnabled method
            List<BI_PSP_Questionnaire_Setups__c> result = BI_PSP_Assessment.getRolloutdate();

            // Add assertions
            Assert.areEqual(1, result.size(), 'returns qn setupss2');
            // Add more specific assertions based on your test data and expectations

            // Ensure the test context is properly closed
            Test.stopTest();
        }
    }

    // test method functions when the user is not a caregiver and no questionnaire setup records are found for the care program enrollee. It ensures that the method correctly handles the scenario where no records are returned and asserts that the result list size is as expected within the test context.
    @isTest
    static void testGetRolloutdateCaregiverfalsecatch() {
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

        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        try {
            // Ensure the test context
            Test.startTest();

            // Call the AuraEnabled method
            List<BI_PSP_Questionnaire_Setups__c> result = BI_PSP_Assessment.getRolloutdate();

            // Add assertions
            Assert.areEqual(0, result.size(), 'returns qn setupss3');
            // Add more specific assertions based on your test data and expectations

            // Ensure the test context is properly closed
            Test.stopTest();
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
    }
    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username.
    @IsTest
    static void testGetCompletedAssessmentCountsByCurrentUserName() {
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

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;

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

        Assessment testAssessment = new Assessment(
            Name = 'Work & Activity Impairment (WPAI)',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023',
            BI_PSP_CareProgramEnrollee__c = testCpa1.Id
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
        // Call the method to be tested
        try {
            System.runAs(testUser) {
                Test.startTest();
                List<Integer> result = BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName();
                Test.stopTest();
                Assert.areEqual(4, result.size(), 'returns assess');
                // Assert the results
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
    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username, considering the user's caregiver status.
    @IsTest
    static void testGetCompletedAssessmentCountsByCurrentUserNameTwo() {
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

        CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccount1.Id,
            CareProgramId = cp.Id
        );
        insert testCpa2;

        Assessment testAssessment = new Assessment(
            Name = 'Work & Activity Impairment (WPAI)',
            OwnerId = testUser.Id,
            AssessmentStatus = 'Completed',
            BI_PSP_DateForCQ__c = 'Jan 2023',
            BI_PSP_CareProgramEnrollee__c = testCpa2.Id
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
        try {
            // Call the method to be tested
            System.runAs(testUser2) {
                Test.startTest();
                List<Integer> result = BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName();
                Test.stopTest();
                Assert.areEqual(4, result.size(), 'returns assess');
                // Assert the results
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

    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username, considering the user's caregiver status.
    @isTest
    static void testgetcompasscatch() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserEmail3 = 'testusernew@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser3 = new User(
            Email = 'testuser3new@example.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testuser3new@example.com',
            FirstName = 'Test3',
            LastName = 'User3',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser3;

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();
        Account testAccount3 = new Account(
            Lastname = 'test',
            PersonEmail = currentUserEmail3,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount3;
        try {
            System.runAs(testUser3) {
                // Ensure the test context
                Test.startTest();

                // Call the AuraEnabled method
                List<Integer> result = BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName();

                // Add assertions
                System.assertEquals(
                    0,
                    result.size(),
                    'No Assessment with completed State'
                );
                // Add more specific assertions based on your test data and expectations

                // Ensure the test context is properly closed
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

    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username, considering the user's caregiver status.
    @isTest
    static void testgetcompasscatchelse() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test3 User3';
        String currentUserEmail = 'testuser3new@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser3 = new User(
            Email = 'testuser3new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser3new@example.com',
            FirstName = 'Test3',
            LastName = 'User3',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser3;

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount1;

        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
        );
        insert testAccount2;
        try {
            System.runAs(testUser3) {
                // Ensure the test context
                Test.startTest();

                // Call the AuraEnabled method
                List<Integer> result = BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName();

                // Add assertions
                System.assertEquals(
                    0,
                    result.size(),
                    'No Assessment with completed State'
                );
                // Add more specific assertions based on your test data and expectations

                // Ensure the test context is properly closed
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

    //The test method ensures that the method correctly retrieves the count of completed assessments associated with the current user's username, considering the user's caregiver status.
    @isTest
    static void testgetcompasscatchelsecpe() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String currentUserName = 'Test3 User3';
        String currentUserEmail = 'testuser3new@example.com';
        Profile standardUserProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User testUser3 = new User(
            Email = 'testuser3new@example.com',
            BI_PSPB_Caregiver__c = true,
            Username = 'testuser3new@example.com',
            FirstName = 'Test3',
            LastName = 'User3',
            Alias = 'tesn',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser3;

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();
        String currentUserName2 = 'Test User2';
        String currentUserEmail2 = 'testuser2new@example.com';
        Account testAccount2 = new Account(
            Lastname = currentUserName2,
            PersonEmail = currentUserEmail2,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccount2;
        Account testAccount1 = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccount2.Id
        );
        insert testAccount1;

        try {
            System.runAs(testUser3) {
                // Ensure the test context
                Test.startTest();

                // Call the AuraEnabled method
                List<Integer> result = BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName();

                // Add assertions
                System.assertEquals(
                    0,
                    result.size(),
                    'No Assessment with completed State'
                );
                // Add more specific assertions based on your test data and expectations

                // Ensure the test context is properly closed
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

    //Each method in this test method ensures that the expected behavior is met by asserting the size of returned lists and the values of certain variables. If any assertion fails, it indicates a deviation from the expected behavior, prompting a review of the corresponding method's implementation.
    @isTest
    static void getcatch() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        Profile standardUserProfile = [
            //creating Profile
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        //user with patient
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
        try {
            System.runAs(testUser) {
                Test.startTest();
                List<AssessmentQuestion> result = BI_PSP_Assessment.getTheAssesmentQuestion();
                Test.stopTest();
                Assert.areEqual(
                    0,
                    result.size(),
                    'There should be no pss AssessmentQuestionResponse in the result'
                );
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
    //This test method evaluates the behavior of multiple assessment-related methods within the BI_PSP_Assessment class under the context of a standard user.
    @isTest
    static void getcatchone() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        Profile standardUserProfile = [
            //creating Profile
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        //user with patient
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
        try {
            System.runAs(testUser) {
                Test.startTest();
                List<AssessmentQuestion> result = BI_PSP_Assessment.getIntroductionAssesmentQues();

                Test.stopTest();
                Assert.areEqual(
                    0,
                    result.size(),
                    'There should be no Introduction AssessmentQuestion '
                );
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
    //To get cover the catch of caregiver after giving Response in negative
    @istest
    static void forElselogmessage() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

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

        List<String> responseTexts = new List<String>();
        List<String> questionIds = new List<String>();
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
        ];

        // Call the method under test
        try {
            System.runAs(testUser2) {
                Test.startTest();

                // Use the extracted questionIds and responseTexts in the method

                BI_PSP_Assessment.ranswerOfTheQuestion(
                    questionIds,
                    responseTexts
                );
                Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
                Assert.areEqual(
                    expectedDraftRecordCount,
                    draftRecords.size(),
                    'Expected characters after first two'
                );

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
    // Testing Log error for if condition in ranswerOfTheQuestion.
    @istest
    static void forCaregivertestingLogError() {
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
            AssessmentId = testAssessment.id,
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
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.id,
            AssessmentQuestionId = questionversion2.Id,
            CreatedDate = createddt
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
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created

        // Call the method under test
        try {
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method

            BI_PSP_Assessment.ranswerOfTheQuestion(questionIds, responseTexts);
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            );
            Test.stopTest();
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
    }

    //this method is for inserting the responses of wapi,dlqi,pss Questionnaire Questions as user who is a care giver.
    @istest
    static void testElse() {
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
            Name = 'Locked',
            ResponseText = 'Locked',
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
            ResponseText = 'Locked',
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
        List<AssessmentQuestionResponse> draftRecords = [
            SELECT Id
            FROM AssessmentQuestionResponse
            WHERE AssessmentId = :testAssessment.Id
        ];
        Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created

        // Call the method under test
        System.runAs(testUser) {
            Test.startTest();

            // Use the extracted questionIds and responseTexts in the method

            BI_PSP_Assessment.ranswerOfTheQuestion(questionIds, responseTexts);

            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            );
            Test.stopTest();
        }

    }
    //To cover the catch for Psoriasis Asessment Question
    @isTest
    static void getcatchPsoriasis() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        Profile standardUserProfile = [
            //creating Profile
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        //user with patient
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
        try {
            System.runAs(testUser) {
                Test.startTest();
                List<AssessmentQuestion> resultone = BI_PSP_Assessment.getPsoriasisAssesmentQues();
                Test.StopTest();
                Assert.areEqual(
                    0,
                    resultone.size(),
                    'There should be no pss AssessmentQuestion'
                );
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
    @isTest
    //To cover the catch for Dermatology Asessment Question
    static void getcatchDermatology() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        Profile standardUserProfile = [
            //creating Profile
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        //user with patient
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
        try {
            System.runAs(testUser) {
                Test.startTest();
                List<AssessmentQuestion> resulttwo = BI_PSP_Assessment.getDermatologyAssesmentQues();
                Test.StopTest();
                Assert.areEqual(
                    0,
                    resulttwo.size(),
                    'There should be no Dermatology AssessmentQuestion'
                );
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

    @isTest
    //To cover the catch for Qualitative Asessment Question
    static void getcatchQualitative() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        Profile standardUserProfile = [
            //creating Profile
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        //user with patient
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
        try {
            System.runAs(testUser) {
                Test.startTest();
                List<AssessmentQuestion> resultthree = BI_PSP_Assessment.getQualitativeAssesmentQues();
                Test.StopTest();
                Assert.areEqual(
                    0,
                    resultthree.size(),
                    'There should be no Qualitative AssessmentQuestion'
                );
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
    @isTest
    //To cover the catch for total Question counts
    static void getcatchTotalQuestions() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        Profile standardUserProfile = [
            //creating Profile
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        //user with patient
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

        System.runAs(testUser) {
            Test.startTest();
            Integer resultfive = BI_PSP_Assessment.getTotalquestionscount(null);
            Test.StopTest();
            Assert.areEqual(
                null,
                resultfive,
                'There should be no Qualitative AssessmentQuestion'
            );
        }
    }
    @isTest
    //To cover the catch for category status
    static void getcatchCategoryStatus() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        Profile standardUserProfile = [
            //creating Profile
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        //user with patient
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
        System.runAs(testUser) {
            Test.startTest();
            Integer result = BI_PSP_Assessment.getCategoryStatus('');
            Test.StopTest();
            Assert.areEqual(
                null,
                result,
                'There should be no Qualitative AssessmentQuestion'
            );
        }
    }
    @isTest
    static void testcaregiverdata() {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        try {
            //
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
                BI_PSP_Assessment.getAssessmentCountsByCurrentUserName();
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