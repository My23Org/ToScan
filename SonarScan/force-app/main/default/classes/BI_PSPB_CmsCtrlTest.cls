/*
* @description Test class validating CMS article, image, and news retrieval; includes methods for media,
 news, and exception handling. 
 In this test class, we're using SeeAllData=true. According to Salesforce documentation, the SeeAllData=false 
 annotation doesn't function when retrieving data from the ConnectAPI for test class. Hence, we're opting for 
 SeeAllData=true in the test method of the test class.
 [https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/connectAPI_TestingApex.htm]
 try catch is used to handle the negative scenarios in test methods.
* History:
* Version	Author			Date			Detail				Description
* 1.0		Gokul Krishnan	05-Nov-2023		Created				Initial development
* 1.1		Gokul Krishnan 	05-Feb-2024		Updated				Updated the patient status retrieve
* 1.2		Gokul Krishnan	22-Apr-2024		Updated				Updated cms retrieve test method
* 1.3		Gokul Krishnan	28-Apr-2024		Updated				test method try catch block added for 
																negative scenarios
* 1.4		Gokul Krishnan	02-May-2024		Updated				Test method added for article like
																response retrieve and update
*/
@isTest
private class BI_PSPB_CmsCtrlTest {
	/*
	 @description    : Test method used to check reterieve of cms media content from cms 
	 As per Salesforce docs, SeeAllData=false doesn't work for ConnectAPI data retrieval in test classes, 
	 so we're opting for SeeAllData=true in the test method */
	@isTest(SeeAllData=true)
	static void testRetrieveMediaFromCMS() {
		// Create test data
		String testChannelName = 'Testsite';

		// Call the method being tested
		Test.startTest();
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String result = BI_PSPB_CmsCtrl.retrieveMediaFromCMS(
				testChannelName
			);

			Test.stopTest();

			// Assert the results
			Assert.areNotEqual(null, result, 'Result should not be null');
			// Add more assertions as needed based on your logic
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms news content from cms 
	 As per Salesforce docs, SeeAllData=false doesn't work for ConnectAPI data retrieval in test classes, 
	 so we're opting for SeeAllData=true in the test method */

	@isTest(SeeAllData=true)
	static void testRetrieveNewsFromCMS() {
		// Create test data
		String testChannelName = 'Testsite';
		// Call the method being tested
		Test.startTest();
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String result = BI_PSPB_CmsCtrl.retrieveNewsFromCMS(
				testChannelName
			);

			Test.stopTest();

			// Assert the results
			Assert.areNotEqual(null, result, 'Result should not be null');
			// Add more assertions as needed based on your logic
		}
	}

	/*
	 @description    : Test method used to test reterieve of cms news content from cms 
	  As per Salesforce docs, SeeAllData=false doesn't work for ConnectAPI data retrieval in test classes, 
	  so we're opting for SeeAllData=true in the test method */

	@isTest(SeeAllData=true)
	static void testRetrieveMediaFromCMSNew() {
		// Create test data
		String testChannelName = 'Testsite';

		// Call the method being tested
		Test.startTest();
		System.runAs(new User(Id = UserInfo.getUserId())) {
			String result = BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews(
				testChannelName
			);

			Test.stopTest();

			// Assert the results
			Assert.areNotEqual(null, result, 'Result should not be null');
			// Add more assertions as needed based on your logic
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms content news, images and media urls 
	 from cms with null value */

	@isTest
	static void testExceptionHandlingcmsctrl() {
		// Simulate an exception by forcing an error
		Test.startTest();
		try {
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveMediaFromCMS(null);
				String resultnewsmedia = BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews(
					null
				);

				Assert.areEqual('Error', result, 'Expected one message');
				Assert.areEqual(
					'Error',
					resultnewsmedia,
					'Expected one message'
				);
			}
		} catch (Exception e) {
			// To assert error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
		Test.stopTest();
	}
	/*
	 @description    : Test method used to check reterieve of cms news content from cms with no channel */

	@isTest
	static void testRetrieveNewsWithNoChannel() {
		try {
			// Create test data
			String testChannelName = 'None';
			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveNewsFromCMS(
					testChannelName
				);

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To assert error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms media content from cms */

	@isTest
	static void testRetrieveMediaWithNoChannel() {
		try {
			// Create test data
			String testChannelName = 'None';

			// Call the method being tested
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveMediaFromCMS(
					testChannelName
				);

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To assert error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms news content from cms where channel name is
	 blank */

	@isTest
	static void testRetrieveNewsEmptyChannel() {
		try {
			// Create test data
			String testChannelName = '';
			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveNewsFromCMS(
					testChannelName
				);

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To assert error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms media content from cms where channel name is
	 blank */

	@isTest
	static void testRetrieveMediaEmptyChannel() {
		try {
			// Create test data
			String testChannelName = '';
			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews(
					testChannelName
				);

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To verify error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/*
	 @description    : Test method used to check reterieve of cms media content from cms where channel name is
	 not exist */

	@isTest
	static void testRetrieveMediaNoneChannel() {
		try {
			// Create test data
			String testChannelName = 'None';
			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				String result = BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews(
					testChannelName
				);

				Test.stopTest();

				// Assert the results
				Assert.areNotEqual(null, result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To verify error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	@isTest
	static void testReterieveLike() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Create test data
			String articleName = 'None';
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

			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(testUser) {
				String result = BI_PSPB_CmsCtrl.checkreaction(articleName);
				BI_PSPB_CmsCtrl.updatereaction('', '');

				Test.stopTest();

				// Assert the results
				Assert.areEqual('Dislike', result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To verify error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	/**
 * @description 
   This test method verifies the behavior of the BI_PSPB_CmsCtrl class in retrieving article like responses 
   for the current user and updating reactions. It tests the scenario where the article name is not provided 
   and ensures that the default response is 'Dislike'. Additionally, it tests the behavior when an exception 
   is thrown during the process.
 */
	@isTest
	static void testReterieveLikeNullUser() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Create test data
			String articleName = 'None';
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

			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(testUser2) {
				String result = BI_PSPB_CmsCtrl.checkreaction(articleName);
				BI_PSPB_CmsCtrl.updatereaction(articleName, 'Like');

				Test.stopTest();

				// Assert the results
				Assert.areEqual('Dislike', result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To verify error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	/**
 * @description 
   This test method verifies the behavior of the BI_PSPB_CmsCtrl class when the article name provided is empty. 
   It ensures that the default response is 'Dislike'. Additionally, it tests the behavior when an exception is 
   thrown during the process.
 */
	@isTest
	static void testCheckReactionEmptyArticle() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Create test data
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

			// Simulate an exception by forcing an error
			// Call the method being tested
			Test.startTest();
			System.runAs(testUser) {
				String result = BI_PSPB_CmsCtrl.checkreaction('  ');

				Test.stopTest();

				// Assert the results
				Assert.areEqual('Dislike', result, 'Result should not be null');
				// Add more assertions as needed based on your logic
			}
		} catch (Exception e) {
			// To verify error throw in apex for negative scenario
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	/**
 * @description 
   This test method verifies the behavior of the BI_PSPB_CmsCtrl class in scenarios where the user is enrolled 
   in a care program with an 'Acute' patient status and has reacted 'Like' to an article titled 'What is GPP?'.
   It tests the retrieval and update of the user's reaction to the article.
 */
	@isTest
	static void testWithAcuteUpdate() {
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
			BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
				Name = 'Testreaction',
				BI_PSPB_CareProgramEnrollee__c = testCpa1.Id,
				BI_PSPB_Reaction__c = 'Like',
				BI_PSPB_Article_name__c = 'What is GPP?'
			);
			insert likeReact;

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				String result = BI_PSPB_CmsCtrl.checkreaction('What is GPP?');
				BI_PSPB_CmsCtrl.updatereaction('What is GPP?', 'Like');
				Test.stopTest();

				// Assertions
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
 * @description 
   This test method verifies the behavior of the BI_PSPB_CmsCtrl class in scenarios where the user is enrolled 
   in a care program with an 'Acute' patient status and has reacted 'Like' to an article titled 'What is GPP?'. 
   It tests the retrieval and update of the user's reaction to the article, specifically checking the deletion 
   of the reaction record when the user changes their reaction to 'Dislike'.
 */
	@isTest
	static void testWithAcuteReactionDelete() {
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
			BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
				Name = 'Testreaction',
				BI_PSPB_CareProgramEnrollee__c = testCpa1.Id,
				BI_PSPB_Reaction__c = 'Like',
				BI_PSPB_Article_name__c = 'What is GPP?'
			);
			insert likeReact;

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				String result = BI_PSPB_CmsCtrl.checkreaction('What is GPP?');
				BI_PSPB_CmsCtrl.updatereaction('What is GPP?', 'Dislike');
				Test.stopTest();

				// Assertions
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
 * @description 
   This test method verifies the behavior of the BI_PSPB_CmsCtrl class in scenarios where the user dislikes 
   an article reaction and the associated reaction record is deleted. It tests the deletion of the reaction 
   record when the user's reaction to the article is changed to 'Dislike'.
 */
	@isTest
	static void testDislikeReactionDelete() {
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
				LastName = 'TestLikeuser',
				Email = 'testusertamil1237@example.com',
				UserName = 'testusertamil1237@example.com',
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
				Lastname = 'TestLikeuser',
				PersonEmail = 'testusertamil1237@example.com',
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
			BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
				BI_PSPB_CareProgramEnrollee__c = testCpa1.Id,
				BI_PSPB_Reaction__c = 'Like',
				BI_PSPB_Article_name__c = 'articletest'
			);
			insert likeReact;

			// Call the method to be tested
			System.runAs(testUser) {
				Test.startTest();
				BI_PSPB_CmsCtrl.updatereaction('articletest', 'articletest');
				Test.stopTest();
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
 * @description 
   This test method verifies the behavior of the BI_PSPB_CmsCtrl class when the user changes their reaction 
   to an article titled 'Manage flares' from 'Like' to 'Dislike'. It tests the update of the reaction record 
   to 'Dislike' and verifies that the record is deleted.
 */
	@isTest
	static void testDislikeReaction() {
		// Create test data for BI_SFCOE_LOG_App_Settings__c
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
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
			Email = 'testusertamil1237@example.com',
			UserName = 'testusertamil1237@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles'
		);
		insert testUser;

		// Create test Account and CareProgramEnrollee records
		Account testAccount1 = new Account(
			LastName = 'TestAccount1',
			PersonEmail = 'testusertamil1237@example.com',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId()
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

		// Insert a BI_PSPB_Article_like__c record
		BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
			BI_PSPB_Reaction__c = 'Dislike', // Initially set to Like for testing update
			BI_PSPB_Article_name__c = 'Manage flares',
			BI_PSPB_CareProgramEnrollee__c = testCpa1.Id,
			Name = 'testlikereaction'
		);
		insert likeReact;

		// Call the method to be tested - updating reaction to Dislike
		System.runAs(testUser) {
			Test.startTest();
			String articleName = 'Manage flares';
			String reactionLike = 'Like';
			BI_PSPB_CmsCtrl.updatereaction(articleName, reactionLike);
			Test.stopTest();
		}

		// Verify that the record is deleted
		List<BI_PSPB_Article_like__c> deletedRecords = [
			SELECT Id
			FROM BI_PSPB_Article_like__c
			WHERE BI_PSPB_Article_name__c = 'Manage flares'
		];
		Assert.areNotEqual(
			0,
			deletedRecords.size(),
			'Record should be deleted'
		);
	}
	/**
 * @description 
   This test method verifies the behavior of the BI_PSPB_CmsCtrl class when a caregiver user attempts 
   to update the reaction to an article titled 'Manage flares' from 'Like' to 'Dislike'. It inserts a 
   BI_PSPB_Article_like__c record initially set to 'Like' and attempts to update the reaction to 'Dislike'. 
   Since the user is a caregiver, the update operation should not be allowed, and the record should not be deleted.
 */
	@isTest
	static void testDislikeReactionCaregiver() {
		// Create a test user
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'System Administrator'
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

		// Insert a BI_PSPB_Article_like__c record
		BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
			BI_PSPB_Reaction__c = 'Dislike', // Initially set to Like for testing update
			BI_PSPB_Article_name__c = 'Manage flares',
			BI_PSPB_CareProgramEnrollee__c = testCpa1.Id,
			Name = 'testlikereaction',
			ownerId = testUser2.Id
		);
		insert likeReact;

		// Call the method to be tested - updating reaction to Dislike
		System.runAs(testUser) {
			Test.startTest();
			String articleName = 'Manage flares';
			String reactionLike = 'Like';
			BI_PSPB_CmsCtrl.updatereaction(articleName, reactionLike);
			Test.stopTest();
		}

		// Verify that the record is deleted
		List<BI_PSPB_Article_like__c> deletedRecords = [
			SELECT Id
			FROM BI_PSPB_Article_like__c
			WHERE BI_PSPB_Article_name__c = 'Manage flares'
		];
		Assert.areNotEqual(
			0,
			deletedRecords.size(),
			'Record should not be deleted'
		);
	}
	/**
 * @description 
   This test method verifies the behavior of the BI_PSPB_CmsCtrl class when a caregiver user attempts 
   to update the reaction to an article titled 'What is GPP?' from 'Like' to 'Dislike'. It inserts a 
   BI_PSPB_Article_like__c record initially set to 'Like' and attempts to update the reaction to 'Dislike'. 
   Since the user is a caregiver, the update operation should not be allowed, and the record should not be deleted.
 */
	@isTest
	static void testLikeReactionCaregiver() {
		// Create a test user
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'System Administrator'
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

		// Insert a BI_PSPB_Article_like__c record
		BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
			BI_PSPB_Reaction__c = 'Like', // Initially set to Like for testing update
			BI_PSPB_Article_name__c = 'What is GPP?',
			BI_PSPB_CareProgramEnrollee__c = testCpa1.Id,
			Name = 'testlikereaction',
			ownerId = testUser2.Id
		);
		insert likeReact;

		// Call the method to be tested - updating reaction to Dislike
		System.runAs(testUser) {
			Test.startTest();
			String articleName = 'What is GPP?';
			String reactionLike = 'Dislike';
			BI_PSPB_CmsCtrl.updatereaction(articleName, reactionLike);
			Test.stopTest();
		}

		// Verify that the record is deleted
		List<BI_PSPB_Article_like__c> deletedRecords = [
			SELECT Id
			FROM BI_PSPB_Article_like__c
			WHERE BI_PSPB_Article_name__c = 'Manage flares'
		];
		Assert.areEqual(0, deletedRecords.size(), 'Record should be deleted');
	}
}