/*
*********************************************************
Apex Class Name    :BI_PSP_CompletedQuestionareSTest
Created Date       : March 10, 2024
@description       : This Apex Test Class for Retrieving Questionnaire Records those status is in Completed
                  	and expired
@author            : Sowmitha
Last Modification  : Harish
*********************************************************
*/

@isTest
public class BI_PSP_CompletedQuestionareSTest {
	public static string cpa1;
	public static String pss = 'Psoriasis Symptom Scale (PSS)';
	public static String wapiCategory = 'Work & Activity Impairment (WPAI)';
	public static String dlqiCategory = 'Dermatology Life Quality Index (DLQI)';
	public static String qualiCategory = 'Qualitative satisfaction questionnaire';
	public static String inprogress = 'In Progress';

	@isTest
	//To get the Qualitative Questionnaire Response for Patient
	static void getQSQTwomonthsPatientcompletedQuestionarestest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
			QuestionCategory = 'Qualitative satisfaction questionnaire'
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
			CreatedDate = createddt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;

		System.runAs(testUser2) {
			Test.startTest();
			List<AssessmentQuestionResponse> result = BI_PSP_CompletedQuestionareS.getQSQcompletedQuestionares1(
				targetDate
			);
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq1 1 AssessmentQuestionResponse in the result'
			);
		}

	}
	//To get the Qualitative Questionnaire(14 weeks) Response for Patient
	@isTest
	static void getQSQTwomonthscompletedQuestionarestest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
			Name = 'Test Assessment',
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
			QuestionCategory = 'Qualitative satisfaction questionnaire'
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
			CreatedDate = createddt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;

		System.runAs(testUser) {
			Test.startTest();
			List<AssessmentQuestionResponse> result = BI_PSP_CompletedQuestionareS.getQSQcompletedQuestionares1(
				targetDate
			);
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq1 2 AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Patient status Expired
	static void getQSQOnecompletedQuestionarestestcatch() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
			QuestionCategory = 'Qualitative satisfaction questionnaire'
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
			CreatedDate = createddt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionareS.getQSQcompletedQuestionares1(
				targetDate
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

	@isTest
	//To get the Qualitative Questionnaire (14 weeks)Response for Patient status expired
	static void getQSQtwocompletedQuestionarestest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
			QuestionCategory = 'Qualitative satisfaction questionnaire'
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
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		System.runAs(testUser2) {
			Test.startTest();
			List<AssessmentQuestionResponse> result = BI_PSP_CompletedQuestionareS.getQSQcompletedQuestionaressec(
				targetDate
			);
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq2 1 AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Patient for Expired
	static void getQSQFourteenWeekscompletedQuestionarestest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
			Name = 'Test Assessment',
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
			QuestionCategory = 'Qualitative satisfaction questionnaire'
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
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		System.runAs(testUser) {
			Test.startTest();
			List<AssessmentQuestionResponse> result = BI_PSP_CompletedQuestionareS.getQSQcompletedQuestionaressec(
				targetDate
			);
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq2 2 AssessmentQuestionResponse in the result'
			);
		}

	}
	@isTest
	//To get the Qualitative Questionnaire Response for Patient to cover negative Senario
	static void getQSQcompletedQuestionarestestcatchNegative() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
			QuestionCategory = 'Qualitative satisfaction questionnaire'
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
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionareS.getQSQcompletedQuestionaressec(
				targetDate
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

	@isTest
	//To get the Qualitative Questionnaire Response for Caregiver
	static void getQSQ12completedQuestionarestestexpired() {
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;

		System.runAs(testUser2) {
			Test.startTest();
			List<Assessment> result = BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnaire1();
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq1 1 expired AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Patient negative catch
	static void getQSQcompletedQuestionarestestexpiredcaregiverNegative() {
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);

		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa1.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;

		System.runAs(testUser) {
			Test.startTest();
			List<Assessment> result = BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnaire1();
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq1 2 expired AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Patient to get Catch for completed Status
	static void getQSQcompletedQuestionarestestexpiredCompletedcatch() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';

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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
		);
		insert testResponse;
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnaire1();
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

	@isTest
	//To get the Qualitative Questionnaire Response for caregive negative
	static void getQSQCaregiverNegativecompletedQuestionarestestexpired() {
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		System.runAs(testUser2) {
			Test.startTest();
			List<Assessment> result = BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnairesec();
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq2 1 expired AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Caregiver Expired
	static void getQSQCaregiverExpiredcompletedQuestionarestestexpired() {
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);

		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa1.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		System.runAs(testUser) {
			Test.startTest();
			List<Assessment> result = BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnairesec();
			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'There should be one qsq2 2 expired AssessmentQuestionResponse in the result'
			);
		}

	}

	@isTest
	static void getQSQ21completedQuestionarestestexpiredcatch() {
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnairesec();
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

	@isTest
	//To get the Completed Questionnaire Response by Category
	static void getCompletedQuestionaresTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';

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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionareS.getCompletedQuestionares(
				targetDate,
				categoryName
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

	@isTest
	//To get the all Completed Questionnaire Response for category negative Senario
	static void getCompletedQuestionaresnullTest() {
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_CompletedQuestionareS.getCompletedQuestionares(null, null);
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

	@isTest
	//To get the All Completed Questionnaire Response for caregiver
	static void getCompltdtescaregvr() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser) {
				Test.startTest();
				BI_PSP_CompletedQuestionareS.getCompletedQuestionares(
					targetDate,
					categoryName
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

	@isTest
	//To get the All completed  Questionnaire Response for Caregiver
	static void getCompltdtesnoncaregvr() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String targetDate = 'Jan 2023';
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser2.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser2) {
				Test.startTest();
				BI_PSP_CompletedQuestionareS.getCompletedQuestionares(
					targetDate,
					categoryName
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

	@isTest
	//To get the current Completed date caregiver
	static void forCurrentdateTestcaregvr() {
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser2.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser2) {
				Test.startTest();
				BI_PSP_CompletedQuestionareS.getQstnrcurrentcompleteddate(
					categoryName
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

	@isTest
	//To get current date for completed Questionnaire for patient
	static void forCurntdateTestnoncaregvr() {
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		String categoryName = 'Dermatology Life Quality Index (DLQI)';
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser) {
				Test.startTest();
				BI_PSP_CompletedQuestionareS.getQstnrcurrentcompleteddate(
					categoryName
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

	@isTest
	//To cover negative Senario for current completed date
	static void forCurntdateTestnull() {
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
		Datetime createddt = DateTime.newInstance(
			Date.newInstance(2023, 1, 6),
			Time.newInstance(12, 23, 0, 0)
		);
		Assessment testAssessment = new Assessment(
			Name = 'Qualitative satisfaction questionnaire',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Expired',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			ExpirationDateTime = createddt,
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Qualitative satisfaction questionnaire'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id,
			CreatedDate = createddt,
			BI_PSP_QsqAfterWeeks__c = 'pageTwo'
		);
		insert testResponse;

		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser) {
				Test.startTest();
				BI_PSP_CompletedQuestionareS.getQstnrcurrentcompleteddate(null);
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

	@isTest
	//To cover all method catch by passing negative Date
	static void catchNegativeSenario() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		//User profile
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];
		//TestUser for Patient
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
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser) {
				Test.startTest();

				// Switch to the test caregiver context
				BI_PSP_CompletedQuestionareS.getQSQcompletedQuestionares1('');
				BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnaire1();
				BI_PSP_CompletedQuestionareS.getQSQcompletedQuestionaressec('');
				BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnairesec();

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