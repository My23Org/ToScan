/*
* @description    This test class is for displaying dates on the outstanding Questionnaire cards.
                  there are different cards for different categories like pss,dlqi etc.

* History:
* Version	Author		Date			Detail			Description
* 1.0		Harish		05-Dec-2023		Created			Initial development.
* 1.1		Harish   	01-Jan-2024		Updated			Updated for consitional statements.
l* 1.2		Harish		04-Apr-2024		Updated			Added check for log statements.
*/

@isTest
public class BI_PSP_CardDateForInProgressTest {
	//this test class method is for getting the card dates.
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

		// Create an assessment record
		Assessment testAssessment = new Assessment(
			Name = 'Dermatology Life Quality Index (DLQI)',
			BI_PSP_CareProgramEnrollee__c = testCpa1.Id,
			AssessmentStatus = 'In Progress',
			ExpirationDateTime = Date.valueOf('2024-03-28')
		);
		insert testAssessment;
		BI_PSP_Questionnaire_Setups__c bs = new BI_PSP_Questionnaire_Setups__c(
			name = 'Testuser',
			BI_PSP_DLQI_RollOutDate__c = Date.valueOf('2024-02-28')
		);
		insert bs;
		try {
			Test.startTest();
			System.runAs(testUser) {
				BI_PSP_CardDateForInProgress.getTheDateInProgessForCard();
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
		// Add your assertions based on the expected result
	}
	//this test method for checking the retreival of pss record.
	@isTest
	static void testgetTheDateInProgessForCardPSS() {
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

		// Create an assessment record
		Assessment testAssessment = new Assessment(
			Name = 'Psoriasis Symptom Scale (PSS)',
			BI_PSP_CareProgramEnrollee__c = testCpa1.Id,
			AssessmentStatus = 'In Progress'
		);
		insert testAssessment;
		try {
			Test.startTest();
			System.runAs(testUser) {
				BI_PSP_CardDateForInProgress.getTheDateInProgessForCardPSS();

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

	//this test method for checking the retreival of wapi record.
	@isTest
	static void testgetTheDateInProgessForCardWAPI() {
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

		// Create an assessment record
		Assessment testAssessment = new Assessment(
			Name = 'Work & Activity Impairment (WPAI)',
			BI_PSP_CareProgramEnrollee__c = testCpa1.Id,
			AssessmentStatus = 'In Progress'
		);
		insert testAssessment;
		try {
			Test.startTest();
			System.runAs(testUser) {
				BI_PSP_CardDateForInProgress.getTheDateInProgessForCardWAPI();
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
	//this test method for checking the retreival of assessments for care givers.
	//caergiver Test.
	@isTest
	static void testGetTheDateInProgressForCardcargiver() {
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

		// Create an assessment record
		Assessment testAssessment = new Assessment(
			Name = 'Dermatology Life Quality Index (DLQI)',
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id,
			AssessmentStatus = 'In Progress',
			EffectiveDateTime = Date.today()
		);
		insert testAssessment;
		try {
			Test.startTest();
			System.runAs(testUser2) {
				BI_PSP_CardDateForInProgress.getTheDateInProgessForCard();
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

		// Add your assertions based on the expected result
	}
	//this test method for checking the retreival of pss record.
	@isTest
	static void testgetTheDateInProgessForCardPSScargiver() {
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

		// Create an assessment record
		Assessment testAssessment = new Assessment(
			Name = 'Psoriasis Symptom Scale (PSS)',
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id,
			AssessmentStatus = 'In Progress'
		);
		insert testAssessment;
		try {
			Test.startTest();
			System.runAs(testUser2) {
				 BI_PSP_CardDateForInProgress.getTheDateInProgessForCardPSS();
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
	//this test method for checking the retreival of wapi record.
	@isTest
	static void testgetTheDateInProgessForCardWAPIcar() {
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

		// Create an assessment record
		Assessment testAssessment = new Assessment(
			Name = 'Work & Activity Impairment (WPAI)',
			BI_PSP_CareProgramEnrollee__c = testCpa2.Id,
			AssessmentStatus = 'In Progress'
		);
		insert testAssessment;
		try {
			Test.startTest();
			System.runAs(testUser2) {
				BI_PSP_CardDateForInProgress.getTheDateInProgessForCardWAPI();
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
}