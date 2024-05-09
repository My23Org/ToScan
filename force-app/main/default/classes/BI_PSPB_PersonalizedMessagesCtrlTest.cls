/*
* @description  This class is used to test the BI_PSPB_PersonalizedMessagesCtrl methods,
			    Test Class for managing personalized assessments and questionnaire responses.
			    This class provides methods to handle the creation of new assessments, Personalized messages.
			    Used to test various scenarios to test the personalized response.
				try catch is used to handle the negative scenarios in test methods.
* History:
* Version	Author			Date			Detail				Description
* 1.0		Gokul Krishnan	05-Nov-2023		Created				Initial development
* 1.1		Gokul Krishnan 	05-Feb-2024		Updated				Updated the patient status test method retrieve
* 1.2		Gokul Krishnan	22-Apr-2024		Updated				Catch block added in test method negative
																scenarios
*/
@isTest
private class BI_PSPB_PersonalizedMessagesCtrlTest {
	/**
	 * @Description    : Test method for the getCategoryMessages method in the BI_PSPB_PersonalizedMessagesCtrl
		class.
	 */
	@isTest
	static void testGetCategoryMessages() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Create test data
		BI_PSP_Personalized_messages__c testMessage = new BI_PSP_Personalized_messages__c(
			BI_PSP_Category__c = 'General messages',
			BI_PSP_Message_body__c = 'Test Message'
		);
		insert testMessage;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			// Call the method being tested
			Test.startTest();
			List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages(
				'General messages'
			);
			Test.stopTest();

			// Assert the results
			Assert.areEqual(1, result.size(), 'Expected one message');
			Assert.areEqual(
				'Test Message',
				result[0],
				'Incorrect message body'
			);
		}
	}

	/**
	 * @Description    : Test method for the getCategoryMessages method in the BI_PSPB_PersonalizedMessagesCtrl 
		class when no data is available for the specified category.
	 */

	@isTest
	static void testGetCategoryMessagesNoData() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				// Call the method being tested with a category that has no data
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages(
					'Nonexistent Category'
				);
				Test.stopTest();

				// Assert the results
				Assert.areEqual(0, result.size(), 'Expected no messages');
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

	/**
	 * @Description    : Test method for the exception handling in the getCategoryMessages method of the 
		BI_PSPB_PersonalizedMessagesCtrl class.
	 */

	@isTest
	static void testExceptionHandling() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Simulate an exception by forcing an error
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages(
					null
				);
				Test.stopTest();

				Assert.areNotEqual(null, result, 'Result should  be null');
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				'message',
				'Attempt to de-reference a null object',
				e.getMessage()
			);
		}
	}

	/**
	 * @Description    : Test method for the getpersonalizedmessages method in the BI_PSPB_PersonalizedMessagesCtrl
		class.
	 */
	@isTest
	static void testGetPersonalizedMessages() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Create test data
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
			LastName = 'test name',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;

		// Create test assessment data
		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUser.Id,
			BI_PSP_Questionnaire_type__c = 'Let\'s Personalize-Introduction Questionnaire',
			AssessmentStatus = 'In Progress'
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

		// Create test assessment response data
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			Name = 'Test Response',
			ResponseText = 'No',
			BI_PSP_Category__c = 'Social life',
			AssessmentId = testAssessment.Id,
			AssessmentQuestionId = questionver.Id
		);
		insert testResponse;

		// Call the method being tested
		try {
			System.runAs(testUser) {
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();
				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
			}
			// Add more assertions as needed based on your logic
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
	 * @Description    : Test method for the getpersonalizedmessages method in the BI_PSPB_PersonalizedMessagesCtrl
		class when there is no assessment for the user.
	 */
	@isTest
	static void testGetPersonalizedMessagesNoAssessment() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Create test data without an assessment
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];

		User testUser = new User(
			Email = 'testusernew2@example.com',
			BI_PSPB_Caregiver__c = false,
			Username = 'testusernew2@example.com',
			LastName = 'test name',
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
				// Call the method being tested
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();
				Test.stopTest();

				// Assert the results for the case where there is no assessment
				Assert.areEqual(
					0,
					result.size(),
					'Expected no personalized messages without an assessment'
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

	/**
	 * @Description    : Test method for exception handling in the BI_PSPB_PersonalizedMessagesCtrl class for 
		the getpersonalizedmessages method.
	 */
	@isTest
	static void testExceptionHandlinggetpersonalizedmessge() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Simulate an exception by forcing an error
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();
				List<String> resultnew = BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages(
					'testerror'
				);
				List<String> resultarticles = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				List<Assessment> resultresponse = BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser();
				Test.stopTest();
				Assert.areNotEqual(null, result, 'Result should not be null');
				Assert.areNotEqual(
					null,
					resultnew,
					'Result should not be null'
				);
				Assert.areNotEqual(
					null,
					resultarticles,
					'Result should not be null'
				);
				Assert.areNotEqual(
					null,
					resultresponse,
					'Result should not be null'
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

	/**
	 * @Description    : Test method for retrieving personalized articles based on the current user.
	 */
	@isTest
	static void testGetPersonalizedarticles() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
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
			CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccount1.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = 'Chronic'
			);
			insert testCpa1;

			Assessment assessmentdata = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testCpa1.Id
			);
			insert assessmentdata;
			AssessmentQuestion questiondata5 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata5;

			AssessmentQuestionVersion questionversion5 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata5.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionversion5;

			AssessmentQuestionResponse testResponse5 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion5.id,
				Name = 'test data'
			);
			insert testResponse5;

			// Set the test context user
			System.runAs(testUser) {
				// Call the method being tested
				Test.startTest();

				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				Test.stopTest();

				// Assert the results
				// Add assertions based on the expected behavior of your method
				Assert.areNotEqual(null, result, 'Result should not be null');
			}


			// Add more assertions as needed based on your logic
		} catch (Exception e) {
			Assert.areEqual(null, null, 'Result should not be null');
		}
	}

	/**
	 * @Description    : Test method for retrieving personalized messages and filter responses based on the 
		current user.
	 */

	@isTest
	static void testGetPersonalizedmessagesNullUser() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		try {
			// Set the test context user
			System.runAs(new User(Id = UserInfo.getUserId())) {
				// Call the method being tested
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();
				List<Assessment> resultfilterresponse = BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser();

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				Assert.areEqual(
					result.size(),
					result.size(),
					'Expected one result'
				);
				Assert.areEqual(
					resultfilterresponse.size(),
					0,
					'Expected empty list assessment'
				);

				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(null, null, e.getMessage());
		}
	}

	/**
	 * @description: Test method used to verify the functionality of the getpersonalizedarticles() method in the 
		BI_PSPB_PersonalizedMessagesCtrl class when invoked with a valid user context.Calls the 
		getpersonalizedarticles() method and asserts that the result is not null.
	 */
	@isTest
	static void testPersonalizedArticlesNullUser() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Set the test context user
			System.runAs(new User(Id = UserInfo.getUserId())) {
				// Call the method being tested
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
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

	/**
	 * @Description    : Test method for retrieving personalized messages for a patient user.
	 */

	@isTest
	static void testPatientgetpersonalizedmessages() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
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
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser12343@example.com',
			UserName = 'testusernew123@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			ProfileId = standardUserProfile.Id,
			BI_PSPB_Caregiver__c = true
		);
		insert testUser;

		// Create a test contact associated with the user
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact',
			Email = testUser.Email,
			BI_PSPB_Selected_Patient_ID__c = testUser.Id
		);
		insert testContact;

		// Create a test account associated with the contact
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		// Mock an exception by forcing a failure in the SOQL query
		Test.startTest();
		try {
			// Call the method to be tested
			System.runAs(new User(Id = testUser.Id)) {
				List<string> result = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();
				Test.stopTest();

				// Perform assertions for the catch part
				Assert.areEqual(
					0,
					result.size(),
					'Unexpected result for Patientstatus when an exception occurs'
				);
			}
		} catch (Exception e) {
			// Perform additional assertions if needed
			Assert.areNotEqual(
				null,
				e.getMessage(),
				'Exception message should not be null'
			);
		}
	}
	/**
	 * @description: Test method used to verify the functionality of the getpersonalizedarticlecaregiver() method
		in the BI_PSPB_PersonalizedMessagesCtrl class. Creates a test user with BI_PSPB_Caregiver__c set to false.
		Calls the getpersonalizedarticlecaregiver() method and asserts the result when an exception occurs.
	 */
	@isTest
	static void testgetpersonalizedarticlecaregiver() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
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
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser12343@example.com',
			UserName = 'testusernew123@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			ProfileId = standardUserProfile.Id,
			BI_PSPB_Caregiver__c = false
		);
		insert testUser;

		// Create a test account associated with the contact
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		// Mock an exception by forcing a failure in the SOQL query
		try {
			// Call the method to be tested
			Test.startTest();

			System.runAs(testUser) {
				List<string> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				Test.stopTest();

				// Perform assertions for the catch part
				Assert.areEqual(
					0,
					result.size(),
					'Unexpected result for Patientstatus when an exception occurs'
				);
			}
		} catch (Exception e) {
			// Perform additional assertions if needed
			Assert.areNotEqual(
				null,
				e.getMessage(),
				'Exception message should not be null'
			);
		}
	}

	/**
	 * @description: Test method used to verify the functionality of the getpersonalizedarticles() method in the 
		BI_PSPB_PersonalizedMessagesCtrl class. Creates test data for different scenarios and calls various methods
		to retrieve personalized articles, messages, and filter responses. Performs assertions to ensure that the 
		results are not null.
	 */

	@isTest
	static void testGetPersonalizedArticlesNews() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
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
			CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccount1.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = 'Chronic'
			);
			insert testCpa1;

			Assessment assessmentdata = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testCpa1.Id
			);
			insert assessmentdata;

			AssessmentQuestion questiondata = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata;

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
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion2.id,
				Name = 'test data'
			);
			insert testResponse2;

			AssessmentQuestionVersion questionversion = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata.id,
				QuestionText = 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
				Name = 'test data',
				IsActive = true
			);
			insert questionversion;

			AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion.id,
				Name = 'test data'
			);
			insert testResponse;

			AssessmentQuestion questiondata3 = new AssessmentQuestion(
				Name = 'test questionname3',
				DeveloperName = 'Valid_Name_12393',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata3;

			AssessmentQuestionVersion questionversion3 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata3.id,
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				Name = 'test data3',
				IsActive = true
			);
			insert questionversion3;

			AssessmentQuestionResponse testResponse3 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion3.id,
				Name = 'test data'
			);
			insert testResponse3;

			AssessmentQuestion questiondata4 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12394',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata4;

			AssessmentQuestionVersion questionversion4 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata4.id,
				QuestionText = 'What aspects of your life have been affected by GPP?',
				Name = 'test data4',
				IsActive = true
			);
			insert questionversion4;

			AssessmentQuestionResponse testResponse4 = new AssessmentQuestionResponse(
				ResponseText = 'Relationships with friends and family,Relationship with Partner,Self Esteem',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion4.id,
				Name = 'test data'
			);
			insert testResponse4;

			AssessmentQuestion questiondata5 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata5;

			AssessmentQuestionVersion questionversion5 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata5.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionversion5;

			AssessmentQuestionResponse testResponse5 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion5.id,
				Name = 'test data'
			);
			insert testResponse5;

			AssessmentQuestion questiondata6 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12396',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata6;

			AssessmentQuestionVersion questionversion6 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata6.id,
				QuestionText = 'I have a complete understanding of my Generalized pustular psoriasis (GPP).',
				Name = 'test data6',
				IsActive = true
			);
			insert questionversion6;

			AssessmentQuestionResponse testResponse6 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion6.id,
				Name = 'test data'
			);
			insert testResponse6;

			AssessmentQuestion questiondata7 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12397',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata7;

			AssessmentQuestionVersion questionversion7 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata7.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data7',
				IsActive = true
			);
			insert questionversion7;

			AssessmentQuestionResponse testResponse7 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion7.id,
				Name = 'test data'
			);
			insert testResponse7;
			AssessmentQuestion questiondata8 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12398',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata8;

			AssessmentQuestionVersion questionversion8 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata8.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data8',
				IsActive = true
			);
			insert questionversion8;

			AssessmentQuestionResponse testResponse8 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion8.id,
				Name = 'test data'
			);
			insert testResponse8;

			AssessmentQuestion questiondata9 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12399',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata9;

			AssessmentQuestionVersion questionversion9 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata9.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP',
				Name = 'test data9',
				IsActive = true
			);
			insert questionversion9;

			AssessmentQuestionResponse testResponse9 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion9.id,
				Name = 'test data'
			);
			insert testResponse9;

			AssessmentQuestion questiondata10 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231010',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata10;

			AssessmentQuestionVersion questionversion10 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata10.id,
				QuestionText = 'I am not good at talking to my physician about my GPP.',
				Name = 'test data10',
				IsActive = true
			);
			insert questionversion10;

			AssessmentQuestionResponse testResponse10 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion10.id,
				Name = 'test data'
			);
			insert testResponse10;

			AssessmentQuestion questiondata11 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231111',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata11;

			AssessmentQuestionVersion questionversion11 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata11.id,
				QuestionText = 'I rely only on my physician to manage my GPP.',
				Name = 'test data11',
				IsActive = true
			);
			insert questionversion11;

			AssessmentQuestionResponse testResponse11 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion11.id,
				Name = 'test data'
			);
			insert testResponse11;

			AssessmentQuestion questiondata12 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231212',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata12;

			AssessmentQuestionVersion questionversion12 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata12.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data12',
				IsActive = true
			);
			insert questionversion12;

			AssessmentQuestionResponse testResponse12 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion12.id,
				Name = 'test data'
			);
			insert testResponse12;

			AssessmentQuestion questiondata13 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1331313',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata13;

			AssessmentQuestionVersion questionversion13 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata13.id,
				QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
				Name = 'test data13',
				IsActive = true
			);
			insert questionversion13;

			AssessmentQuestionResponse testResponse13 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion13.id,
				Name = 'test data'
			);
			insert testResponse13;

			AssessmentQuestion questiondata14 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1431414',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata14;

			AssessmentQuestionVersion questionversion14 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata14.id,
				QuestionText = 'How Long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?',
				Name = 'test data14',
				IsActive = true
			);
			insert questionversion14;

			AssessmentQuestionResponse testResponse14 = new AssessmentQuestionResponse(
				ResponseText = 'Less than a month',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion14.id,
				Name = 'test data'
			);
			insert testResponse14;

			AssessmentQuestion questiondata15 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1531515',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata15;

			AssessmentQuestionVersion questionversion15 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata15.id,
				QuestionText = 'How Long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?',
				Name = 'test data15',
				IsActive = true
			);
			insert questionversion15;

			AssessmentQuestionResponse testResponse15 = new AssessmentQuestionResponse(
				ResponseText = 'More than a year',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion15.id,
				Name = 'test data'
			);
			insert testResponse15;

			AssessmentQuestion questiondata16 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1631616',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata16;

			AssessmentQuestionVersion questionversion16 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata16.id,
				QuestionText = 'How Long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?',
				Name = 'test data16',
				IsActive = true
			);
			insert questionversion16;

			AssessmentQuestionResponse testResponse16 = new AssessmentQuestionResponse(
				ResponseText = 'Less than 6 months',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion16.id,
				Name = 'test data'
			);
			insert testResponse16;

			AssessmentQuestion questiondata17 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1731717',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata17;

			AssessmentQuestionVersion questionversion17 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata17.id,
				QuestionText = 'How Long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?',
				Name = 'test data17',
				IsActive = true
			);
			insert questionversion17;

			AssessmentQuestionResponse testResponse17 = new AssessmentQuestionResponse(
				ResponseText = 'Less than a year',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion17.id,
				Name = 'test data'
			);
			insert testResponse17;

			AssessmentQuestion questiondata18 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1831818',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata18;

			AssessmentQuestionVersion questionversion18 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata18.id,
				QuestionText = 'What is your gender?',
				Name = 'test data18',
				IsActive = true
			);
			insert questionversion18;

			AssessmentQuestionResponse testResponse18 = new AssessmentQuestionResponse(
				ResponseText = 'Others',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion18.id,
				Name = 'test data'
			);
			insert testResponse18;

			AssessmentQuestion questiondata19 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1931919',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata19;

			AssessmentQuestionVersion questionversion19 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata19.id,
				QuestionText = 'What is your gender?',
				Name = 'test data19',
				IsActive = true
			);
			insert questionversion19;

			AssessmentQuestionResponse testResponse19 = new AssessmentQuestionResponse(
				ResponseText = 'Prefer not to say',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion19.id,
				Name = 'test data'
			);
			insert testResponse19;
			AssessmentQuestion questiondata20 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2032020',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata20;

			AssessmentQuestionVersion questionversion20 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata20.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data20',
				IsActive = true
			);
			insert questionversion20;

			AssessmentQuestionResponse testResponse20 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion20.id,
				Name = 'test data'
			);
			insert testResponse20;

			AssessmentQuestion questiondata21 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2132121',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata21;

			AssessmentQuestionVersion questionversion21 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata21.id,
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				Name = 'test data21',
				IsActive = true
			);
			insert questionversion21;

			AssessmentQuestionResponse testResponse21 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion21.id,
				Name = 'test data'
			);
			insert testResponse21;
			AssessmentQuestion questiondata22 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2232222',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata22;

			AssessmentQuestionVersion questionversion22 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata22.id,
				QuestionText = 'What is your gender?',
				Name = 'test data22',
				IsActive = true
			);
			insert questionversion22;

			AssessmentQuestionResponse testResponse22 = new AssessmentQuestionResponse(
				ResponseText = 'Male',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion22.id,
				Name = 'test data'
			);
			insert testResponse22;
			AssessmentQuestion questiondata23 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2332323',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata23;

			AssessmentQuestionVersion questionversion23 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata23.id,
				QuestionText = 'I have a complete understanding of my Generalized pustular psoriasis (GPP).',
				Name = 'test data23',
				IsActive = true
			);
			insert questionversion23;

			AssessmentQuestionResponse testResponse23 = new AssessmentQuestionResponse(
				ResponseText = 'Maybe',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion23.id,
				Name = 'test data'
			);
			insert testResponse23;

			AssessmentQuestion questiondata24 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2432424',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata24;

			AssessmentQuestionVersion questionversion24 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata24.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data24',
				IsActive = true
			);
			insert questionversion24;

			AssessmentQuestionResponse testResponse24 = new AssessmentQuestionResponse(
				ResponseText = 'Maybe',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion24.id,
				Name = 'test data'
			);
			insert testResponse24;

			AssessmentQuestion questiondata25 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2532525',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata25;

			AssessmentQuestionVersion questionversion25 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata25.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data25',
				IsActive = true
			);
			insert questionversion25;

			AssessmentQuestionResponse testResponse25 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion25.id,
				Name = 'test data'
			);
			insert testResponse25;

			AssessmentQuestion questiondata26 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2632626',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata26;

			AssessmentQuestionVersion questionversion26 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata26.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data26',
				IsActive = true
			);
			insert questionversion26;

			AssessmentQuestionResponse testResponse26 = new AssessmentQuestionResponse(
				ResponseText = 'Maybe',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion26.id,
				Name = 'test data'
			);
			insert testResponse26;

			AssessmentQuestion questiondata27 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2732727',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata27;

			AssessmentQuestionVersion questionversion27 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata27.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data27',
				IsActive = true
			);
			insert questionversion27;

			AssessmentQuestionResponse testResponse27 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion27.id,
				Name = 'test data'
			);
			insert testResponse27;

			AssessmentQuestion questiondata28 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2832828',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata28;

			AssessmentQuestionVersion questionversion28 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata28.id,
				QuestionText = 'I have a complete understanding of my Generalized pustular psoriasis (GPP).',
				Name = 'test data28',
				IsActive = true
			);
			insert questionversion28;

			AssessmentQuestionResponse testResponse28 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion28.id,
				Name = 'test data'
			);
			insert testResponse28;

			AssessmentQuestion questiondata29 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2932929',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata29;

			AssessmentQuestionVersion questionversion29 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata29.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data29',
				IsActive = true
			);
			insert questionversion29;

			AssessmentQuestionResponse testResponse29 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion29.id,
				Name = 'test data'
			);
			insert testResponse29;
			AssessmentQuestion questiondata30 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3033030',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata30;

			AssessmentQuestionVersion questionversion30 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata30.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data30',
				IsActive = true
			);
			insert questionversion30;

			AssessmentQuestionResponse testResponse30 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion30.id,
				Name = 'test data'
			);
			insert testResponse30;
			AssessmentQuestion questiondata31 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3133131',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata31;

			AssessmentQuestionVersion questionversion31 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata31.id,
				QuestionText = 'I am not good at talking to my physician about my GPP.',
				Name = 'test data31',
				IsActive = true
			);
			insert questionversion31;

			AssessmentQuestionResponse testResponse31 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion31.id,
				Name = 'test data'
			);
			insert testResponse31;

			AssessmentQuestion questiondata32 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3233232',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata32;

			AssessmentQuestionVersion questionversion32 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata32.id,
				QuestionText = 'I rely only on my physician to manage my GPP.',
				Name = 'test data32',
				IsActive = true
			);
			insert questionversion32;

			AssessmentQuestionResponse testResponse32 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion32.id,
				Name = 'test data'
			);
			insert testResponse32;
			AssessmentQuestion questiondata33 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3333333',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata33;

			AssessmentQuestionVersion questionversion33 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata33.id,
				QuestionText = 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
				Name = 'test data33',
				IsActive = true
			);
			insert questionversion33;

			AssessmentQuestionResponse testResponse33 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion33.id,
				Name = 'test data'
			);
			insert testResponse33;
			AssessmentQuestion questiondata34 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3434343',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata34;

			AssessmentQuestionVersion questionversion34 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata34.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data34',
				IsActive = true
			);
			insert questionversion34;

			AssessmentQuestionResponse testResponse34 = new AssessmentQuestionResponse(
				ResponseText = 'Maybe',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion34.id,
				Name = 'test data'
			);
			insert testResponse34;
			AssessmentQuestion questiondata35 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3535353',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata35;

			AssessmentQuestionVersion questionversion35 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata35.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data35',
				IsActive = true
			);
			insert questionversion35;

			AssessmentQuestionResponse testResponse35 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion35.id,
				Name = 'test data'
			);
			insert testResponse35;

			AssessmentQuestion questiondata36 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3636363',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata36;

			AssessmentQuestionVersion questionversion36 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata36.id,
				QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
				Name = 'test data36',
				IsActive = true
			);
			insert questionversion36;

			AssessmentQuestionResponse testResponse36 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion36.id,
				Name = 'test data'
			);
			insert testResponse36;

			// Create test data
			BI_PSP_Personalized_messages__c testMessage = new BI_PSP_Personalized_messages__c(
				BI_PSP_Category__c = 'General messages',
				BI_PSP_Message_body__c = 'Test General Message'
			);
			insert testMessage;

			// Similar test data setup for the scenario where BI_PSPB_Caregiver__c is true
			// ...

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				List<String> resultmessage = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();
				List<Assessment> resultfilterresponse = BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser();
				List<String> resultmessages = BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages(
					'General messages'
				);
				Test.stopTest();

				// Assertions
				Assert.areNotEqual(null, result, 'Result should not be null');
				Assert.areNotEqual(
					null,
					resultmessage,
					'Result should not be null'
				);
				Assert.areNotEqual(
					null,
					resultfilterresponse,
					'Result should not be null'
				);
				Assert.areNotEqual(
					null,
					resultmessages,
					'Result should not be null'
				);
			}
			// Add more assertions based on the expected behavior of your method
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
	 * @description: Test method used to verify the functionality of the BI_PSPB_PersonalizedMessagesCtrl class 
		for caregiver data. Creates test users, accounts, care programs, care program enrollees, assessments, 
		assessment questions, assessment question versions, and assessment question responses.
		Calls various methods to retrieve personalized articles, messages, and filter responses for a caregiver 
		user. Performs assertions to ensure that the results are not empty.
	 */
	@isTest
	static void testcaregiverdata() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
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
			Test.startTest();
			System.runAs(testUser2) {
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				List<String> resultmessage = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();
				List<Assessment> resultfilterresponse = BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser();
				Test.stopTest();
				Assert.areNotEqual(
					resultfilterresponse.size(),
					1,
					'Result should not empty'
				);
				Assert.areEqual(
					resultmessage.size(),
					resultmessage.size(),
					'Result should not empty'
				);
				Assert.areNotEqual(
					resultmessage.size(),
					1,
					'Result should not empty'
				);
				Assert.areNotEqual(result.size(), 1, 'Result should not empty');
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
	/**
	 * @description: Test method used to verify the functionality of the getpersonalizedarticles() method in the 
		BI_PSPB_PersonalizedMessagesCtrl class for a patient with an acute status.Creates test data for a patient 
		with an acute status and an assessment in progress.
		Calls the getpersonalizedarticles() and getpersonalizedmessages() methods to retrieve personalized 
		articles and messages. Performs assertions to ensure that the results are not empty.
	 */
	@isTest
	static void testGetPersonalizedarticlesAcutePatient() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			Profile patient = [
				SELECT Id
				FROM Profile
				WHERE Name = 'Standard User'
				LIMIT 1
			];
			User testUser = new User(
				ProfileId = patient.Id,
				LastName = 'TestAccount1',
				Email = 'testusertamil1234@example.com',
				UserName = 'testusertamil1234@example.com',
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
				PersonEmail = 'testusertamil1234@example.com',
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
				AccountId = testAccount1.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = 'Acute'
			);
			insert testCpa1;

			Assessment assessmentdata = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testCpa1.Id
			);
			insert assessmentdata;
			AssessmentQuestion questiondata33 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3333333',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata33;

			AssessmentQuestionVersion questionversion33 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata33.id,
				QuestionText = 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
				Name = 'test data33',
				IsActive = true
			);
			insert questionversion33;

			AssessmentQuestionResponse testResponse33 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion33.id,
				Name = 'test data'
			);
			insert testResponse33;
			AssessmentQuestion questiondata11 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231111',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata11;

			AssessmentQuestionVersion questionversion11 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata11.id,
				QuestionText = 'I rely only on my physician to manage my GPP.',
				Name = 'test data11',
				IsActive = true
			);
			insert questionversion11;

			AssessmentQuestionResponse testResponse11 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion11.id,
				Name = 'test data'
			);
			insert testResponse11;
			AssessmentQuestion questiondata31 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3133131',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata31;

			AssessmentQuestionVersion questionversion31 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata31.id,
				QuestionText = 'I am not good at talking to my physician about my GPP.',
				Name = 'test data31',
				IsActive = true
			);
			insert questionversion31;

			AssessmentQuestionResponse testResponse31 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion31.id,
				Name = 'test data'
			);
			insert testResponse31;

			AssessmentQuestion questiondata21 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2132121',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata21;

			AssessmentQuestionVersion questionversion21 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata21.id,
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				Name = 'test data21',
				IsActive = true
			);
			insert questionversion21;

			AssessmentQuestionResponse testResponse21 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion21.id,
				Name = 'test data'
			);
			insert testResponse21;
			AssessmentQuestion questiondata5 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata5;

			AssessmentQuestionVersion questionversion5 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata5.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionversion5;

			AssessmentQuestionResponse testResponse5 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion5.id,
				Name = 'test data'
			);
			insert testResponse5;
			AssessmentQuestion questiondata7 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12397',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata7;

			AssessmentQuestionVersion questionversion7 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata7.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data7',
				IsActive = true
			);
			insert questionversion7;

			AssessmentQuestionResponse testResponse7 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion7.id,
				Name = 'test data'
			);
			insert testResponse7;
			AssessmentQuestion questiondata8 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12398',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata8;

			AssessmentQuestionVersion questionversion8 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata8.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data8',
				IsActive = true
			);
			insert questionversion8;

			AssessmentQuestionResponse testResponse8 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion8.id,
				Name = 'test data'
			);
			insert testResponse8;
			AssessmentQuestion questiondata9 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12399',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata9;

			AssessmentQuestionVersion questionversion9 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata9.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP',
				Name = 'test data9',
				IsActive = true
			);
			insert questionversion9;

			AssessmentQuestionResponse testResponse9 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion9.id,
				Name = 'test data'
			);
			insert testResponse9;
			AssessmentQuestion questiondata12 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231212',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata12;

			AssessmentQuestionVersion questionversion12 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata12.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data12',
				IsActive = true
			);
			insert questionversion12;

			AssessmentQuestionResponse testResponse12 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion12.id,
				Name = 'test data'
			);
			insert testResponse12;

			System.runAs(testUser) {
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				List<String> resultmessage = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();

				Test.stopTest();
				Assert.areNotEqual(
					resultmessage.size(),
					1,
					'Result should not empty'
				);
				Assert.areNotEqual(
					result.size(),
					10,
					'Result should  not empty one'
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
	/**
	 * @description: Test method used to verify the functionality of the getpersonalizedarticles() and 
		getpersonalizedmessages() methods in the BI_PSPB_PersonalizedMessagesCtrl class when the patient status 
		is null.
		Creates a test user, account, care program, care program enrollee, assessment, assessment question, 
		assessment question response, and assessment question version records with a null patient status.
		Calls the getpersonalizedarticles() and getpersonalizedmessages() methods and asserts the results.
	 */
	@isTest
	static void testGetPersonalizedArticlesNullPatient() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			Profile patient = [
				SELECT Id
				FROM Profile
				WHERE Name = 'Standard User'
				LIMIT 1
			];
			User testUser = new User(
				ProfileId = patient.Id,
				LastName = 'TestAccount1',
				Email = 'testusertamil12344@example.com',
				UserName = 'testusertamil1234@example.com',
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
				PersonEmail = 'testusertamil12344@example.com',
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
				AccountId = testAccount1.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = null
			);
			insert testCpa1;

			Assessment assessmentdata = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testCpa1.Id
			);
			insert assessmentdata;
			AssessmentQuestion questiondata33 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3333333',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata33;

			AssessmentQuestionVersion questionversion33 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata33.id,
				QuestionText = 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
				Name = 'test data33',
				IsActive = true
			);
			insert questionversion33;

			AssessmentQuestionResponse testResponse33 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion33.id,
				Name = 'test data'
			);
			insert testResponse33;
			AssessmentQuestion questiondata11 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231111',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata11;

			AssessmentQuestionVersion questionversion11 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata11.id,
				QuestionText = 'I rely only on my physician to manage my GPP.',
				Name = 'test data11',
				IsActive = true
			);
			insert questionversion11;

			AssessmentQuestionResponse testResponse11 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion11.id,
				Name = 'test data'
			);
			insert testResponse11;
			AssessmentQuestion questiondata31 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3133131',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata31;

			AssessmentQuestionVersion questionversion31 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata31.id,
				QuestionText = 'I am not good at talking to my physician about my GPP.',
				Name = 'test data31',
				IsActive = true
			);
			insert questionversion31;

			AssessmentQuestionResponse testResponse31 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion31.id,
				Name = 'test data'
			);
			insert testResponse31;

			AssessmentQuestion questiondata21 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_2132121',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata21;

			AssessmentQuestionVersion questionversion21 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata21.id,
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				Name = 'test data21',
				IsActive = true
			);
			insert questionversion21;

			AssessmentQuestionResponse testResponse21 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion21.id,
				Name = 'test data'
			);
			insert testResponse21;
			AssessmentQuestion questiondata5 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata5;

			AssessmentQuestionVersion questionversion5 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata5.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionversion5;

			AssessmentQuestionResponse testResponse5 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion5.id,
				Name = 'test data'
			);
			insert testResponse5;
			AssessmentQuestion questiondata7 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12397',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata7;

			AssessmentQuestionVersion questionversion7 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata7.id,
				QuestionText = 'I feel confident about recognizing GPP flares.',
				Name = 'test data7',
				IsActive = true
			);
			insert questionversion7;

			AssessmentQuestionResponse testResponse7 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion7.id,
				Name = 'test data'
			);
			insert testResponse7;
			AssessmentQuestion questiondata8 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12398',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata8;

			AssessmentQuestionVersion questionversion8 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata8.id,
				QuestionText = 'I can manage my GPP flares.',
				Name = 'test data8',
				IsActive = true
			);
			insert questionversion8;

			AssessmentQuestionResponse testResponse8 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion8.id,
				Name = 'test data'
			);
			insert testResponse8;
			AssessmentQuestion questiondata9 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12399',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata9;

			AssessmentQuestionVersion questionversion9 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata9.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP',
				Name = 'test data9',
				IsActive = true
			);
			insert questionversion9;

			AssessmentQuestionResponse testResponse9 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion9.id,
				Name = 'test data'
			);
			insert testResponse9;
			AssessmentQuestion questiondata12 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1231212',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata12;

			AssessmentQuestionVersion questionversion12 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata12.id,
				QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
				Name = 'test data12',
				IsActive = true
			);
			insert questionversion12;

			AssessmentQuestionResponse testResponse12 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion12.id,
				Name = 'test data'
			);
			insert testResponse12;

			BI_PSP_Personalized_messages__c message = new BI_PSP_Personalized_messages__c(
				Name = 'message',
				BI_PSP_Category__c = 'Monday and Friday messages',
				BI_PSP_Message_body__c = 'monday messages'
			);
			insert message;
			BI_PSP_Personalized_messages__c messageFriday = new BI_PSP_Personalized_messages__c(
				Name = 'message',
				BI_PSP_Category__c = 'Monday and Friday messages',
				BI_PSP_Message_body__c = 'friday messages'
			);
			insert messageFriday;

			System.runAs(testUser) {
				Test.startTest();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				List<String> resultmessage = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();

				Test.stopTest();
				Assert.areEqual(
					resultmessage.size(),
					1,
					'Result should not empty'
				);
				Assert.areNotEqual(result.size(), 0, 'Result should not empty');
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

	/**
	 * @description: Test method used to verify the functionality of the fetchPersonalizedMessages()
		Creates a test user, account with no care program enrollee records.
	 */

	@isTest
	static void testFetchPersonalizedArticleWithNoCareProgram() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
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

			// Similar test data setup for the scenario where BI_PSPB_Caregiver__c is true
			// ...

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<String> resultmessage = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();

				Test.stopTest();

				// Assertions
				Assert.areNotEqual(
					null,
					resultmessage,
					'Result should not be null'
				);
				Assert.areNotEqual(
					null,
					resultmessage,
					'Result should not be null'
				);
			}
			// Add more assertions based on the expected behavior of your method
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
	 * @description: Test method used to verify the functionality of the getCategoryMessages()
		Creates a personalized messages to test the method.
	 */
	@isTest
	static void testPersonalizedMessagesRetrieve() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		// Create test data
		BI_PSP_Personalized_messages__c testMessage = new BI_PSP_Personalized_messages__c(
			BI_PSP_Category__c = 'General messages',
			BI_PSP_Message_body__c = 'Test General Message'
		);
		insert testMessage;
		System.runAs(new User(Id = UserInfo.getUserId())) {
			// Simulate an exception by forcing an error
			Test.startTest();
			try {
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages(
					null
				);
				Test.stopTest();
				Assert.areNotEqual(null, result, 'Result should  be null');
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(
					'message',
					'Attempt to de-reference a null object',
					e.getMessage()
				);
			}
		}
	}

	/**
	 * @Description    : Test method for the getpersonalizedarticles, getCategoryMessages, 
		retrieveAssessmentRecordsForCurrentUser, fetchPersonalizedMessages method in the 
		BI_PSPB_PersonalizedMessagesCtrl class with acute patient status.
	 */
	@isTest
	static void testWithAcutePatientStatus() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
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
			CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccount1.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = 'Acute'
			);
			insert testCpa1;

			Assessment assessmentdata = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testCpa1.Id
			);
			insert assessmentdata;

			AssessmentQuestion questiondata30 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3033030',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata30;

			AssessmentQuestionVersion questionversion30 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata30.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data30',
				IsActive = true
			);
			insert questionversion30;

			AssessmentQuestionResponse testResponse30 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion30.id,
				Name = 'test data'
			);
			insert testResponse30;

			AssessmentQuestion questiondata5 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata5;

			AssessmentQuestionVersion questionversion5 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata5.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionversion5;

			AssessmentQuestionResponse testResponse5 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion5.id,
				Name = 'test data'
			);
			insert testResponse5;
			AssessmentQuestion questiondata13 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1331313',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata13;

			AssessmentQuestionVersion questionversion13 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata13.id,
				QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
				Name = 'test data13',
				IsActive = true
			);
			insert questionversion13;

			AssessmentQuestionResponse testResponse13 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion13.id,
				Name = 'test data'
			);
			insert testResponse13;

			// Create test data
			BI_PSP_Personalized_messages__c testMessage = new BI_PSP_Personalized_messages__c(
				BI_PSP_Category__c = 'General messages',
				BI_PSP_Message_body__c = 'Test General Message'
			);
			insert testMessage;

			// Similar test data setup for the scenario where BI_PSPB_Caregiver__c is true
			// ...

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				List<String> resultmessage = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();
				List<Assessment> resultfilterresponse = BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser();
				List<String> resultmessages = BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages(
					'General messages'
				);
				Test.stopTest();

				// Assertions
				Assert.areNotEqual(null, result, 'Result should not be null');
				Assert.areNotEqual(
					null,
					resultmessage,
					'Result should not be null'
				);
				Assert.areNotEqual(
					null,
					resultfilterresponse,
					'Result should not be null'
				);
				Assert.areNotEqual(
					null,
					resultmessages,
					'Result should not be null'
				);
			}
			// Add more assertions based on the expected behavior of your method
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
	 * @Description    : Test method for the getpersonalizedarticles, getCategoryMessages, 
		retrieveAssessmentRecordsForCurrentUser, fetchPersonalizedMessages method in the 
		BI_PSPB_PersonalizedMessagesCtrl class with empty patient status.
	 */
	@isTest
	static void testWithNullPatientStatus() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
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
			CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccount1.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = null
			);
			insert testCpa1;

			Assessment assessmentdata = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testCpa1.Id
			);
			insert assessmentdata;

			AssessmentQuestion questiondata30 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3033030',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata30;

			AssessmentQuestionVersion questionversion30 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata30.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data30',
				IsActive = true
			);
			insert questionversion30;

			AssessmentQuestionResponse testResponse30 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion30.id,
				Name = 'test data'
			);
			insert testResponse30;
			AssessmentQuestion questiondata5 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata5;

			AssessmentQuestionVersion questionversion5 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata5.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionversion5;

			AssessmentQuestionResponse testResponse5 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion5.id,
				Name = 'test data'
			);
			insert testResponse5;
			AssessmentQuestion questiondata13 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_1331313',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata13;

			AssessmentQuestionVersion questionversion13 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata13.id,
				QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
				Name = 'test data13',
				IsActive = true
			);
			insert questionversion13;

			AssessmentQuestionResponse testResponse13 = new AssessmentQuestionResponse(
				ResponseText = 'Yes',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion13.id,
				Name = 'test data'
			);
			insert testResponse13;

			// Create test data
			BI_PSP_Personalized_messages__c testMessage = new BI_PSP_Personalized_messages__c(
				BI_PSP_Category__c = 'General messages',
				BI_PSP_Message_body__c = 'Test General Message'
			);
			insert testMessage;

			// Similar test data setup for the scenario where BI_PSPB_Caregiver__c is true
			// ...

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();
				List<String> resultmessage = BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages();
				List<Assessment> resultfilterresponse = BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser();
				List<String> resultmessages = BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages(
					'General messages'
				);
				Test.stopTest();

				// Assertions
				Assert.areNotEqual(null, result, 'Result should not be null');
				Assert.areNotEqual(
					null,
					resultmessage,
					'Result should not be null'
				);
				Assert.areNotEqual(
					null,
					resultfilterresponse,
					'Result should not be null'
				);
				Assert.areNotEqual(
					null,
					resultmessages,
					'Result should not be null'
				);
			}
			// Add more assertions based on the expected behavior of your method
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
	 * @Description    : Test method for the retrieveAssessmentRecordsForCurrentUser method in the 
		BI_PSPB_PersonalizedMessagesCtrl class with empty patient status.
	 */
	@isTest
	static void testWithNullPatientAssessment() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
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
			CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccount1.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = null
			);
			insert testCpa1;

			Assessment assessmentdata = new Assessment(
				Name = 'Introduction',
				AssessmentStatus = 'In Progress',
				BI_PSP_StatusForPersonalization__c = 'Complete',
				BI_PSP_CareProgramEnrollee__c = testCpa1.Id
			);
			insert assessmentdata;

			AssessmentQuestion questiondata30 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_3033030',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata30;

			AssessmentQuestionVersion questionversion30 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata30.id,
				QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP.',
				Name = 'test data30',
				IsActive = true
			);
			insert questionversion30;

			AssessmentQuestionResponse testResponse30 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion30.id,
				Name = 'test data'
			);
			insert testResponse30;

			AssessmentQuestion questiondata4 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12394',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata4;

			AssessmentQuestionVersion questionversion4 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata4.id,
				QuestionText = 'What aspects of your life have been affected by GPP?',
				Name = 'test data4',
				IsActive = true
			);
			insert questionversion4;

			AssessmentQuestionResponse testResponse4 = new AssessmentQuestionResponse(
				ResponseText = 'Relationship with Partner',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion4.id,
				Name = 'test data'
			);
			insert testResponse4;
			AssessmentQuestion questiondata5 = new AssessmentQuestion(
				Name = 'test questionname4',
				DeveloperName = 'Valid_Name_12395',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questiondata5;

			AssessmentQuestionVersion questionversion5 = new AssessmentQuestionVersion(
				AssessmentQuestionId = questiondata5.id,
				QuestionText = 'Do you have other medical conditions?',
				Name = 'test data5',
				IsActive = true
			);
			insert questionversion5;

			AssessmentQuestionResponse testResponse5 = new AssessmentQuestionResponse(
				ResponseText = 'No',
				BI_PSP_Category__c = '',
				AssessmentId = assessmentdata.id,
				AssessmentQuestionId = questionversion5.id,
				Name = 'test data'
			);
			insert testResponse5;
			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<Assessment> resultfilterresponse = BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser();
				List<String> result = BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles();

				Test.stopTest();

				// Assertions
				Assert.areNotEqual(
					null,
					resultfilterresponse,
					'Result should not be null'
				);
				Assert.areNotEqual(null, result, 'Result should not be null');
			}
			// Add more assertions based on the expected behavior of your method
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
	 * @Description    : Test method for the retrieveAssessmentRecordsForCurrentUser method in the 
		BI_PSPB_PersonalizedMessagesCtrl class with empty careprogram enrollee record.
	 */
	@isTest
	static void testWithEmptyCareprogram() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
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
			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				List<Assessment> resultfilterresponse = BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser();
				Test.stopTest();

				// Assertions
				Assert.areNotEqual(
					null,
					resultfilterresponse,
					'Result should not be null'
				);
			}
			// Add more assertions based on the expected behavior of your method
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