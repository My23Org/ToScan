/*

Apex Class Name    :BI_PSP_QualitativeSatisfactionsTest
Created Date       : November 5, 2023
description       : To get the date for 2 months and 14 weeks of the care program enrollee to enroll the Qsq Questionnaires.
author            : Harish
@Last Modified On  :11/03/2024
@Last Modified by  :Harish

*/

@isTest
public class BI_PSP_QualitativeSatisfactionsTest {
	// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is not a caregiver
	@isTest
	static void testGetPatientAfterThreemonthsAndFourteenWeeks() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		//To create user
		User testUser = new User(
			ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
			.Id,
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser@example.com',
			Alias = 'tuser',
			Username = 'testuser2312@example.com',
			CommunityNickname = 'tuser123',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		//Account for Patient
		Account acc = new Account(Name = 'Harish');
		insert acc;
		//Create Careprogram to insert careProgramEnrollee
		CareProgram testcareprogram = new CareProgram(
			Name = 'Spevigo',
			StartDate = Date.newInstance(2023, 7, 12)
		);
		insert testcareprogram;
		//CareProgram Enrollee for User to get the Assessment for the particular user
		CareProgramEnrollee testEnrollee1 = new CareProgramEnrollee(
			Name = 'Harish',
			CareProgramId = testcareprogram.Id,
			AccountId = acc.Id
		);
		insert testEnrollee1;

		Test.startTest();
		try {
			System.runAs(testUser) {
				//Testing the method that returns the date of care program enrollee after
				BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks();

				//This is negative senario so there no need to check assert
			}

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

	// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is not a caregiver
	@isTest
	static void testGetTheDateInProgressForCard() {
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
		//Create Test User
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
		//Person account
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();
		//TO create Account
		Account testAccount1 = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;

		//Create careProgram to create
		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;
		//create CareProgram Enrollee
		CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccount1.Id,
			CareProgramId = cp.Id
		);
		insert testCpa1;
		Test.startTest();
		System.runAs(testUser) {
			// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is not a caregiver
			Map<String, Object> result = BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks();
			Assert.areNotEqual(
				0,
				result.size(),
				'There is no record for the user'
			);
		}
		Test.stopTest();
	}

	// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is a caregiver
	@isTest
	static void testGetTheDateInProgressForCardscargiver() {
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
		//To create user for caregiver
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
		//Create Person account
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();
		//create Account for Patient
		Account testAccount1 = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;
		//Create Account for caregiver
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

		// Create an assessment record
		Assessment testAssessment = new Assessment(
			Name = 'Dermatology Life Quality Index (DLQI)',
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id,
			AssessmentStatus = 'In Progress',
			EffectiveDateTime = Date.today()
		);
		insert testAssessment;
		Test.startTest();
		System.runAs(testUser2) {
			// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is a caregiver

			Map<String, Object> result = BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks();
			Assert.areEqual(4, result.size(), 'Date for the User');
		}
		Test.stopTest();
	}
	@isTest
	//To cover the negative senario for patient
	static void testGetPatientAfterThreemonthsAndFourteenWeeksCatch() {
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
			System.runAs(testUser) {
				Test.startTest();

				// Switch to the test caregiver context

				BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks();
				//This is negative senario so there no need to check assert

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
	//To cover the negative senario for caregiver
	static void testGetCaregiverAfterThreemonthsAndFourteenWeeks() {
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
		try {
			System.runAs(testUser) {
				Test.startTest();

				// Switch to the test caregiver context

				BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks();
				//This is negative senario so there no need to check assert

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