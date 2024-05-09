/*

Apex Class Name    :BI_PSP_GetAssessmentQuestionsTest
Created Date       : November 5, 2023
description       : Get Assessment Questions
author            : Harish
@Last Modified On  :11/03/2024
@Last Modified by  :Sowmitha

*/

@isTest
private class BI_PSP_GetAssessmentQuestionsTest {
	//this test method is for checking the retreival assessment questions related to WAPI category.
	@isTest
	static void testGetTheAssessmentQuestion() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		//create Assessment Questions Work & Activity Impairment (WPAI)
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

		Test.startTest();
		// Call the method from BI_PSP_GetAssessmentQuestions
		List<AssessmentQuestion> questions = BI_PSP_GetAssessmentQuestions.getTheAssesmentQuestion();
		Assert.areEqual(1, questions.size(), 'Expected one WAPI question');
		Test.stopTest();
	}

	//this test method is for checking the retreival assessment questions related to Introduction category.
	@isTest
	static void testgetIntroductionAsQuesLastTen() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		//Create Assessment Question for Inroduction
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family intro last ten?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		Test.startTest();
		// Call the method from BI_PSP_GetAssessmentQuestions
		List<AssessmentQuestion> questions = BI_PSP_GetAssessmentQuestions.getIntroductionAsQuesLastTen();
		Assert.areEqual(
			1,
			questions.size(),
			'Expected one Introduction question'
		);
		Test.stopTest();
	}

	//this test method is for checking the retreival assessment questions related to PSS category.
	@isTest
	static void testgetPsoriasisAssesmentQues() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Psoriasis Symptom Scale (PSS)'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		Test.startTest();
		// Call the method from BI_PSP_GetAssessmentQuestions
		List<AssessmentQuestion> questions = BI_PSP_GetAssessmentQuestions.getPsoriasisAssesmentQues();
		Assert.areEqual(1, questions.size(), 'Expected one PSS question');
		Test.stopTest();
	}

	//this test method is for checking the retreival of draft responses of Introduction(caregiver).
	@isTest
	static void testdraftResponseOfIntroduction() {
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
		//create Test user
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
			Name = 'Introduction',
			OwnerId = testUser.Id,
			AssessmentStatus = 'In Progress',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			BI_PSP_CareProgramEnrollee__c = testCpa1.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
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

		Test.startTest();
		System.runAs(testUser2) {
			List<AssessmentQuestionResponse> responses = BI_PSP_GetAssessmentQuestions.draftResponseOfIntroduction();
			// Adjust the assertion based on your requirements
			Assert.areEqual(
				1,
				responses.size(),
				'Expected one draft assessment response of Introduction'
			);
		}

		Test.stopTest();

		// Add your assertions based on the expected result
	}

	//this test method is for checking the retreival of draft responses of Introduction(Patient).
	@isTest
	static void testdraftResponseOfIntroductionpatient() {
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
			Name = 'Introduction',
			OwnerId = testUser.Id,
			AssessmentStatus = 'In Progress',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			BI_PSP_CareProgramEnrollee__c = testCpa1.Id
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
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

		Test.startTest();
		System.runAs(testUser) {
			List<AssessmentQuestionResponse> responses = BI_PSP_GetAssessmentQuestions.draftResponseOfIntroduction();
			// Adjust the assertion based on your requirements
			Assert.areEqual(
				1,
				responses.size(),
				'Expected one draft assessment response of Introduction'
			);
		}
		Test.stopTest();

		// Add your assertions based on the expected result
	}

	//this test method is for checking the retreival of assessment questions related to Qualitative Satisfaction Questionnaire.
	@isTest
	static void testGetgetQualitativeAssesmentQues() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
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

		Test.startTest();
		// Call the method from BI_PSP_GetAssessmentQuestions
		List<AssessmentQuestion> questions = BI_PSP_GetAssessmentQuestions.getQualitativeAssesmentQues();
		Assert.areEqual(1, questions.size(), 'Expected one QSQ question');
		Test.stopTest();
	}

	//this test method is for checking the retreival of assessment questions related to DLQI category.
	@isTest
	static void testgetDermatologyAssesmentQues() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Dermatology Life Quality Index (DLQI)'
		);
		insert questiondata;

		//insert Assessment question version

		AssessmentQuestionVersion questionver = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questiondata.Id
		);
		insert questionver;

		Test.startTest();
		// Call the method from BI_PSP_GetAssessmentQuestions
		List<AssessmentQuestion> questions = BI_PSP_GetAssessmentQuestions.getDermatologyAssesmentQues();
		Assert.areEqual(1, questions.size(), 'Expected one DLQI question');
		Test.stopTest();
	}

	//this test method is for checking the retreival of Patient status (Unassigned).
	@isTest
	static void testPatientStatusReturnPatient() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user without caregiver access
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
			CareProgramId = cp.Id,
			BI_PSPB_PatientStatus__c = 'Unassigned'
		);
		insert testCpa1;

		// Call the method under test
		Test.startTest();
		System.runAs(testUser) {
			String result = BI_PSP_GetAssessmentQuestions.patientstatusreturn();
			Assert.areEqual(
				'Unassigned',
				result,
				'Expected status to be Unassigned'
			);
		}
		Test.stopTest();

		// Add assertions to verify the expected behavior
	}

	//this test method is for checking the retreival of Patient status (Acute).
	@isTest
	static void testPatientStatusReturnPatientAcute() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user without caregiver access
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
			CareProgramId = cp.Id,
			BI_PSPB_PatientStatus__c = 'Acute'
		);
		insert testCpa1;

		// Call the method under test
		Test.startTest();
		System.runAs(testUser) {
			String result = BI_PSP_GetAssessmentQuestions.patientstatusreturn();
			Assert.areEqual(
				'Acute',
				result,
				'Expected status to be Unassigned'
			);
		}
		Test.stopTest();

		// Add assertions to verify the expected behavior
	}
	//this test method is for checking the retreival of Caregiver status (Unassigned).
	@isTest
	static void testPatientStatusReturnCaregiver() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user with caregiver access
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

		CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccount1.Id,
			CareProgramId = cp.Id
		);
		insert testCpa1;
		CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccount2.Id,
			CareProgramId = cp.Id,
			BI_PSPB_PatientStatus__c = 'Unassigned'
		);
		insert testCpa2;

		// Call the method under test
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser2) {
				Test.startTest();
				BI_PSP_GetAssessmentQuestions.patientstatusreturn();
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

	//this test method is for checking the retreival of Caregiver status (Acute).
	@isTest
	static void testPatientStatusReturnCaregiveracute() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user with caregiver access
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

		CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccount1.Id,
			CareProgramId = cp.Id
		);
		insert testCpa1;
		CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccount2.Id,
			CareProgramId = cp.Id,
			BI_PSPB_PatientStatus__c = 'Acute'
		);
		insert testCpa2;

		// Call the method under test
		try {
			System.runAs(testUser2) {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();

				BI_PSP_GetAssessmentQuestions.patientstatusreturn();

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

		// Add assertions to verify the expected behavior
	}
	//Expection

	//this test method is for checking the retreival of draft responses of Introduction - negative.
	@isTest
	static void testGetTheAssessmentQuestionone() {
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

		try {
			//assertion is not done because this is for negative scenario and it goes inside catch
			Test.startTest();
			BI_PSP_GetAssessmentQuestions.draftResponseOfIntroduction();
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

	//this test method is for checking the retreival of Assessments questions of WAPI - negative.
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
			BI_PSPB_Caregiver__c = true,
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_GetAssessmentQuestions.getTheAssesmentQuestion();
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

	}

	//this test method is for checking the retreival of Assessments questions of Introduction - negative.
	@isTest
	static void getcatchtwo() {
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
			BI_PSPB_Caregiver__c = true,
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_GetAssessmentQuestions.getIntroductionAsQuesLastTen();
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
	}

	//this test method is for checking the retreival of draft responses of Introduction - negative.
	@isTest
	static void getcatchthree() {
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
			BI_PSPB_Caregiver__c = true,
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_GetAssessmentQuestions.draftResponseOfIntroduction();
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
	}

	//this test method is for checking the retreival of Assessments questions of PSS - negative.
	@isTest
	static void getcatchfour() {
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
			BI_PSPB_Caregiver__c = true,
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_GetAssessmentQuestions.getPsoriasisAssesmentQues();
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
	}

	//this test method is for checking the retreival of Assessments questions of DLQI - negative.
	@isTest
	static void getcatchfive() {
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
			BI_PSPB_Caregiver__c = true,
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_GetAssessmentQuestions.getDermatologyAssesmentQues();
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
	}
	//this test method is for checking the retreival of Assessments questions of QSQ - negative.
	@isTest
	static void getcatchsix() {
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
			BI_PSPB_Caregiver__c = true,
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
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_GetAssessmentQuestions.getQualitativeAssesmentQues();
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
	}
}