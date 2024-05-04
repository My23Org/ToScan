/*
*********************************************************
Apex Class Name    :BI_PSP_CurrentAndCaregiverUserTest
Created Date       : March 9  2024
@description       : To find caregiver or Patient
@author            : Harish
*********************************************************
*/

@isTest
private class BI_PSP_CurrentAndCaregiverUserTest {
	//To get Assessment by current user name
	@isTest
	static void testGetAssessmentsByCurrentUserName() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Your test data setup (if required)

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			//Creating profile for the User
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];
		//Creating Test User
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
		//Creating Person Account for the User
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();

		Account testAccount1 = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;

		//Creating Care program to insert careProgram Enrollee
		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;
		//To create Care Program Enrollee for Assessment
		CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccount1.Id,
			CareProgramId = cp.Id
		);
		insert testCpa1;

		Assessment testAssessment = new Assessment(
			Name = 'Psoriasis Symptom Scale (PSS)',
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
		// To check this Test User
		System.runAs(testUser) {
			Test.startTest();

			// Switch to the test user context
			List<Assessment> result = BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName(
				'Psoriasis Symptom Scale (PSS)'
			);
			// Your assertions based on the expected outcome
			Test.stopTest();
			Assert.areEqual(1, result.size(), 'One assessment returned');
		}
	}
	//To get Assessments for Caregiver
	@isTest
	static void testGetAssessmentsByCurrentUserNameCaregiver() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
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
		//Test user for caregiver
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
		//Person account
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();

		Account testAccount1 = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;
		//Person Account for Patient
		String currentUserName2 = 'Test User2';
		String currentUserEmail2 = 'testuser2new@example.com';
		Account testAccount2 = new Account(
			Lastname = currentUserName2,
			PersonEmail = currentUserEmail2,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
		);
		insert testAccount2;
		//Care Program for Patient to create careprogram Enrollee
		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;

		//careProgram Enrolle for Patient
		CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccount1.Id,
			CareProgramId = cp.Id
		);
		insert testCpa2;
		//Assessment created with Patient record
		Assessment testAssessment = new Assessment(
			Name = 'Psoriasis Symptom Scale (PSS)',
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

		//To run as test User
		System.runAs(testUser2) {
			Test.startTest();

			// Switch to the test caregiver context

			List<Assessment> result = BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName(
				'Psoriasis Symptom Scale (PSS)'
			);

			Test.stopTest();
			Assert.areEqual(
				1,
				result.size(),
				'assertion for caregiver scenario'
			);
		}

	}

	@isTest
	//To get the Patient Record in negative senario
	static void testGetAssessmentsNegative() {
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

		System.runAs(testUser) {
			Test.startTest();
			try {
				// Switch to the test caregiver context

				BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName(
					''
				);
				  //This is negative senario so there no need to check assert

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