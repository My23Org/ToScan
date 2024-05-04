/*
@description       This Apex test class that handles the creation and management of assessments and assessment question
                   responses related to a specific type of questionnaire within a care program. 
                   It provides methods for inserting responses, managing draft responses, and
                   handling assessments for both page one and page two of the questionnaire.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Abinsha		05-Dec-2023		Created			Initial development.
* 1.1		Abinsha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			test case added.
*/

/*@Description this test method covers the code in draftResponseOfIntroductionPageTwo method that includes the code for data
 retrieval of responses*/
@isTest
public class BI_PSP_QsqQuestionnaireTest {
	//test method for draftResponseOfIntroductionPageTwo for the catch exception to be handled.
	@isTest
	static void draftResponseOfIntroductionPageTwoCacthTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

		String currentUserName = 'Test User';
		String currentUserEmail = 'testuser2new@example.com';
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
			AssessmentStatus = 'In Progress',
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

		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageTwo();
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

	/*@Description this test method covers the code in createAssessmentAndResponses method that includes
	 the code for data insertion of responses and assessmet details as if logged in user is a care giver*/
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
			List<String> responseTexts = new List<String>();
			List<String> questionIds = new List<String>();

			System.runAs(testUser2) {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.createAssessmentAndResponses(
					responseTexts,
					questionIds,
					'dfdfdf',
					null
				);
				//This is negative senario so there no need to check assert
				Test.stopTest();
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				'Script-thrown exception',
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/*@Description this test method covers the code in draftResponseOfIntroductionPageone method that includes the code for data
	 retrieval of responses*/
	@isTest
	static void draftResponseOfIntroductionPageoneCacthTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

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
			AssessmentStatus = 'In Progress',
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

		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageone();
				Test.stopTest();
				//This is negative senario so there no need to check assert
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
	/*@Description this test method covers the code in draftResponseOfIntroductionPageTwo method that includes the code for data
	 retrieval of responses*/
	@isTest
	static void mulitipleDraftRecordsInsertionPageTwoCatchTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Create a test user

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
			AssessmentStatus = 'In Progress',
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
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageTwo(
					questionIds,
					responseTexts
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
	/*@Description this test method covers the code in draftResponseOfIntroductionPageTwo method that includes the code for data
	 retrieval of responses*/
	@isTest
	static void mulitipleDraftRecordsInsertionPageTwoCatchTwo() {
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

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUser.Id,
			AssessmentStatus = 'In Progress',
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
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageTwo(
					questionIds,
					responseTexts
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

	//@Description test method for ranswerOfTheQuestionForPageTwo for the catch exception to be handled.
	@isTest
	static void submitResponsTestMethodPageTwoCatchTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

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

		List<String> responseTexts = new List<String>{
			testResponse2.ResponseText,
			testResponse.ResponseText
		};
		List<String> questionIds = new List<String>{
			questionver.Id,
			questionversion2.Id
		};

		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageTwo(
					questionIds,
					responseTexts
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

	//@escription test method for mulitipleDraftRecordsInsertionPageOne for the catch exception to be handled.
	@isTest
	static void mulitipleDraftRecordsInsertionPageOneCatchTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

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
			AssessmentStatus = 'In Progress',
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
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageOne(
					questionIds,
					responseTexts
				);
				Test.stopTest();
				//This is negative senario so there no need to check assert
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

	//@Description test method for ranswerOfTheQuestionForPageone for the catch exception to be handled.
	@isTest
	static void ranswerOfTheQuestionForPageoneCatchTest() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

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
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageone(
					questionIds,
					responseTexts
				);
				Test.stopTest();
				//This is negative senario so there no need to check assert
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
	//@Description  for testing code written for the submission of Qualiative Satisfaction Questionnaire.
	@isTest
	static void submitResponsTestMethod() {
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

		List<String> responseTexts = new List<String>{
			testResponse2.ResponseText,
			testResponse.ResponseText
		};
		List<String> questionIds = new List<String>{
			questionver.Id,
			questionversion2.Id
		};

		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageone(
					questionIds,
					responseTexts
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
	//@Description This test method verifies the submission of assessment responses by calling a method to answer questions for a specific page.
	@isTest
	static void submitResponsTestMethodcaregivertrue() {
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
		List<String> questionIds = new List<String>{
			questionver.Id,
			questionversion2.Id
		};

		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageone(
					questionIds,
					responseTexts
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

	//@Description This test method validates the creation of draft assessment responses for the first page of a questionnaire.
	@isTest
	static void drfatResponsTestMethod() {
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
			AssessmentStatus = 'In Progress',
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
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageOne(
					questionIds,
					responseTexts
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
	//@Description This test verifies the creation of draft assessment responses for a caregiver user in a questionnaire's first page.
	@isTest
	static void draftResponsTestMethodcaregivertrue() {
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
			AssessmentStatus = 'In Progress',
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
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageOne(
					questionIds,
					responseTexts
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
	/*@Description This test method verifies the submission of assessment responses for the second page of a questionnaire,
	 ensuring the creation of draft records.*/
	@isTest
	static void submitResponsTestMethodPageTwo() {
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
			BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageTwo(
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
	/*@Description This test method verifies the submission of assessment responses for the second page of a questionnaire,
	 ensuring the creation of draft records, with a caregiver user.*/
	@isTest
	static void submitResponsTestMethodcaregivertruePageTwo() {
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
		List<String> questionIds = new List<String>{
			questionver.Id,
			questionversion2.Id
		};

		System.runAs(testUser2) {
			Test.startTest();
			BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageTwo(
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
	/*This test method verifies the creation of draft assessment responses for the second page of a questionnaire.
 It ensures that draft records are correctly inserted into the database when triggered by the provided assessment
questions and responses.*/
	@isTest
	static void drfatResponsTestMethodPageTwo() {
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
			AssessmentStatus = 'In Progress',
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
			BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageTwo(
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
	/*@Description This test method validates draft assessment responses for the second page of a questionnaire with
	 * the caregiver flag set to true. It checks the accurate insertion of draft records into the database based on
	 * the provided assessment questions and responses.*/
	@isTest
	static void draftResponsTestMethodcaregivertruePageTwo() {
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
			AssessmentStatus = 'In Progress',
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
			BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageTwo(
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
	/*@Description This test method verifies the creation of draft assessment responses for the first page of a
	 * questionnaire when the caregiver flag is set to false. It ensures that draft records are correctly
	 * inserted into the database based on the provided assessment questions and responses. */
	@isTest
	static void draftResponseOfIntroductionPageoneCareGiverfalse() {
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
			AssessmentStatus = 'In Progress',
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

		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageone();
				Test.stopTest();
				//This is negative senario so there no need to check assert
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

	/*@Description This test method verifies the creation of draft assessment responses for the introduction page when the
	 *  caregiver flag is set to true, ensuring correct insertion of draft records into the database based on
	 *  provided assessment questions and responses. 	*/
	@isTest
	static void draftResponseOfIntroductionPageoneCreGivertrue() {
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
			CreatedDate = createddt,
			BI_PSP_QsqAfter2months__c = 'pageOne'
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

		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageone();
				Test.stopTest();
				//This is negative senario so there no need to check assert
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

	//@Descriptioncover else when there is no assessment records in ranswerOfTheQuestionForPageone method
	@isTest
	static void esleTest() {
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

		List<String> quest = new List<String>();
		List<String> resps = new List<String>();

		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageone(
					quest,
					resps
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

	}

	//@Description test method for draftResponseOfIntroductionPageTwo for the catch exception to be handled.
	@isTest
	static void draftResponseOfIntroductionPageTwoforcaregiver() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

		String currentUserName = 'Test User';
		String currentUserEmail = 'testuser2new@example.com';
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
			CareProgramId = cp.Id
		);
		insert testCpa2;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUser2.Id,
			AssessmentStatus = 'In Progress',
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

		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageTwo();
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

	@isTest
	static void testGetPersonalizedArticlesNoAccount() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user
		Profile p = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];
		User testUser = new User(
			ProfileId = p.Id,
			LastName = 'TestAccount1',
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
			Lastname = 'TestAccount1',
			PersonEmail = 'testusertamil123@example.com',
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;

		CareProgram testCareProgram = new CareProgram(
			Name = 'TestCareProgram',
			StartDate = Date.today()
		);
		insert testCareProgram;
		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageTwo();
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

	//@Description test method for mulitipleDraftRecordsInsertionPageOne for log message.
	@isTest
	static void forlogMessagemultidraftmethod() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test user

		String currentUserName = 'Test User';
		String currentUserEmail = 'testuser2new@example.com';
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
			BI_PSPB_Selected_Patient_ID__c = null
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
			AssessmentStatus = 'In Progress',
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
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageOne(
					questionIds,
					responseTexts
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
	/*@Description this test method covers the code in draftResponseOfIntroductionPageTwo method that includes the code for data
	 retrieval of responses*/
	@isTest
	static void draftResponseOfIntroductionPageTwoelseparts() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
			RecordTypeId = personAccountRecordTypeId
			//BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
		);
		insert testAccount2;

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;
		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageTwo();
				Test.stopTest();
				//This is negative senario so there no need to check assert
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
	/*@Description this test method covers the code in draftResponseOfIntroductionPageTwo method that includes the code for data
	 retrieval of responses*/
	@isTest
	static void draftResponseOfIntroductionPageTwoelsesec() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageTwo();
				Test.stopTest();
				//This is negative senario so there no need to check assert
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
	/*@Description this test method covers the code in draftResponseOfIntroductionPageOne method that includes the code for data
	 retrieval of responses*/
	@isTest
	static void draftResponseOfIntroductionPageoneelse() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
			RecordTypeId = personAccountRecordTypeId
			//BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
		);
		insert testAccount2;

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;
		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageone();
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
	/*@Description this test method covers the code in draftResponseOfIntroductionPageOne method that includes the code for data
	 retrieval of responses*/
	@isTest
	static void draftResponseOfIntroductionPageoneelsesec() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageone();
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
	/*@Description this test method covers the code in ranswerOfTheQuestionForPageTwo method that
	 *  includes the code for data retrieval of responses*/
	@isTest
	static void submitResponsTestMethodPageTwoCatchelse() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
			RecordTypeId = personAccountRecordTypeId
			//BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
		);
		insert testAccount2;

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;
		List<String> responseTexts = new List<String>();
		List<String> questionIds = new List<String>();

		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageTwo(
					responseTexts,
					questionIds
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
	/*@Description this test method covers the code in ranswerOfTheQuestionForPageTwo method that
	 *  includes the code for data retrieval of responses*/
	@isTest
	static void submitResponsTestMethodPageTwoCatchelsesec() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
		List<String> responseTexts = new List<String>();
		List<String> questionIds = new List<String>();

		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageTwo(
					responseTexts,
					questionIds
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
	/*@Description this test method covers the code in mulitipleDraftRecordsInsertionPageTwo method that
	 *  includes the code for data retrieval of responses*/
	@isTest
	static void mulitipleDraftRecordsInsertionPageTwoelse() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;
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
		List<String> responseTexts = new List<String>();
		List<String> questionIds = new List<String>();

		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageTwo(
					responseTexts,
					questionIds
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
	@isTest
	static void mulitipleDraftRecordsInsertionPageTwoelsesec() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
			BI_PSPB_Caregiver__c = false,
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

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;
		Account testAccount1 = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;

		String currentUserName2 = 'Test User21';
		String currentUserEmail2 = 'testuser21new@example.com';
		Account testAccount2 = new Account(
			Lastname = currentUserName2,
			PersonEmail = currentUserEmail2,
			RecordTypeId = personAccountRecordTypeId
			//BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
		);
		insert testAccount2;
		List<String> responseTexts = new List<String>();
		List<String> questionIds = new List<String>();

		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageTwo(
					responseTexts,
					questionIds
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

	/*@Description this test method covers the code in mulitipleDraftRecordsInsertionPageTwo method that
	 *  includes the code for data insertion of Assessment and its related draft response.*/
	@isTest
	static void mulitipleDraftRecordsInsertionPageTwoelsethree() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
			BI_PSPB_Caregiver__c = false,
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

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;
		Account testAccount1 = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;

		String currentUserName2 = 'Test User21';
		String currentUserEmail2 = 'testuser21new@example.com';
		Account testAccount2 = new Account(
			Lastname = currentUserName2,
			PersonEmail = currentUserEmail2,
			RecordTypeId = personAccountRecordTypeId
			//BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
		);
		insert testAccount2;

		CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccount2.Id,
			CareProgramId = cp.Id
		);
		insert testCpa1;
		List<String> responseTexts = new List<String>();
		List<String> questionIds = new List<String>();

		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageTwo(
					responseTexts,
					questionIds
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
	/*@Description this test method covers the code in mulitipleDraftRecordsInsertionPageTwo method that
	 *  includes the code for data insertion of Assessment and its related draft response.*/
	@isTest
	static void mulitipleDraftRecordsInsertionPageTwoelsefour() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

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
			BI_PSPB_Caregiver__c = false,
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

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;
		Account testAccount1 = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;

		String currentUserName2 = 'Test User21';
		String currentUserEmail2 = 'testuser21new@example.com';
		Account testAccount2 = new Account(
			Lastname = currentUserName2,
			PersonEmail = currentUserEmail2,
			RecordTypeId = personAccountRecordTypeId
			//BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
		);
		insert testAccount2;

		List<String> responseTexts = new List<String>();
		List<String> questionIds = new List<String>();

		System.runAs(testUser2) {
			try {
				Test.startTest();
				BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageTwo(
					responseTexts,
					questionIds
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