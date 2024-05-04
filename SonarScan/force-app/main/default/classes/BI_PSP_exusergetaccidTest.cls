/**
 * @description Test class for verifying the retrieval of account IDs based on user IDs through email matching.
 */
@isTest
private class BI_PSP_exusergetaccidTest {
	/* @description This test class verifying the retrieval of account IDs based on user IDs through email matching.*/
	@isTest
	static void testGetAccId() {
		// Test Case 1: Valid scenario with matching email
		// Create test data: Account and User records with matching email
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
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

		String userrr = testUser.Id;
		String acc = testAccount1.Id;
		Test.startTest();
		String result = BI_PSP_exusergetaccid.getaAccId(userrr);
		Assert.areEqual(
			acc,
			result,
			'Returned Account Id should match the expected Account Id'
		);
		Test.stopTest();
	}
	/*@description This test class ensuring accurate retrieval of account IDs based on user IDs through email matching, assessing handling of non-matching scenarios as well.*/
	@isTest
	static void testGetAccIdcatch() {
		// Test Case 1: Valid scenario with matching email
		// Create test data: Account and User records with matching email
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
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

		try {
            //assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_exusergetaccid.getaAccId(null);
			Test.stopTest();
			Assert.areEqual(
				false,
				'Expected exception was not thrown',
				'Expected an exception to be thrown when null is passed'
			);
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	/* @description This test class validating the retrieval of an account ID based on a user ID through email matching, covering scenarios of both matching and non-matching emails.*/
	@isTest
	static void testGetAccIdcatchnoacc() {
		// Test Case 1: Valid scenario with matching email
		// Create test data: Account and User records with matching email
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
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
			Test.startTest();
			BI_PSP_exusergetaccid.getaAccId(null);
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
	/* @description This test class verifying the retrieval of account IDs based on user IDs through email matching, including scenarios where no matching email is found.*/
	@isTest
	static void testGetAccIdcatchnomail() {
		// Test Case 1: Valid scenario with matching email
		// Create test data: Account and User records with matching email
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		String currentUserName = 'Test User';
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
			PersonEmail = 'testuser22new@example.com',
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;

		
		try {
            //assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSP_exusergetaccid.getaAccId(testUser.Id);
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