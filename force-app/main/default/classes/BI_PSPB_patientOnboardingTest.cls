/**
@description	       This class contains unit tests for the BI_PSPB_patientOnboarding 
                       Apex class, which is responsible for the creation
					   and management of user records linked to patient accounts.
@author					Divya Bharathi S
@Last Modified On   	04/23/2024
@Last Modified By 		Divya Bharathi S
*/
@isTest
private class BI_PSPB_patientOnboardingTest {
	/*@description  This method is used to create user from account and assign the Patient profile*/
	@isTest
	static void testCreateUser() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Create test data
		Account testAcc = new Account(
			FirstName = 'Mila',
			LastName = 'Thomas',
			PersonEmail = 'mila@example.com'
		);
		insert testAcc;

		Contact testCont = new Contact(
			FirstName = 'Mila',
			LastName = 'Thomas',
			Email = 'mila@example.com'
		);
		insert testCont;

		Profile portalProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];

		User testUser = new User(
			Email = 'mila@example.com',
			BI_PSPB_Caregiver__c = false,
			Username = 'testusernew@example.com',
			FirstName = 'Mila',
			LastName = 'Thomas',
			Alias = 'tesn',
			CommunityNickname = 'Mila',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = portalProfile.Id,
			LanguageLocaleKey = 'en_US',
			ContactId = testCont.Id
		);
		insert testUser;

		// Simulate a scenario where an error occurs during DML operations
		testAcc.FirstName = null; // Setting a required field to null to force an error
		try {
			update testAcc;
		} catch (DmlException ex) {
			// This catch block will execute, and you can handle the error here
			Assert.areEqual(
				+ex.getMessage(),
				testAcc,
				'REQUIRED_FIELD_MISSING'
			);
		}

		// Retrieve the profile
		Profile retrievedProfile = [
			SELECT Id
			FROM Profile
			WHERE Id = :portalProfile.Id
			LIMIT 1
		];

		// Verify the profile is not null
		Assert.arenotequal(null, retrievedProfile, 'Portal profile not found');

		Test.startTest();
		// Call the method to be tested
		BI_PSPB_patientOnboarding.createUser(new List<Id>{ testAcc.Id });
		Test.stopTest();

		// Verify user creation
		User createdUser = [
			SELECT
				Id,
				FirstName,
				LastName,
				Alias,
				Email,
				ContactId,
				ProfileId,
				CommunityNickname,
				TimeZoneSidKey,
				LocaleSidKey,
				LanguageLocaleKey
			FROM User
			WHERE ContactId = :testCont.Id
			LIMIT 1
		];

		Assert.areEqual(
			testUser.FirstName,
			createdUser.FirstName,
			'First name mismatch'
		);
		Assert.areEqual(
			testUser.LastName,
			createdUser.LastName,
			'Last name mismatch'
		);
		Assert.areEqual(testUser.Email, createdUser.Email, 'Email mismatch');
		Assert.areEqual(
			testCont.Id,
			createdUser.ContactId,
			'Contact Id mismatch'
		);
		Assert.areEqual(
			testUser.ProfileId,
			createdUser.ProfileId,
			'Profile Id mismatch'
		);
		Assert.areEqual(
			testUser.CommunityNickname,
			createdUser.CommunityNickname,
			'Community nickname mismatch'
		);
		Assert.areEqual(
			testUser.TimeZoneSidKey,
			createdUser.TimeZoneSidKey,
			'Time zone mismatch'
		);
		Assert.areEqual(
			testUser.LocaleSidKey,
			createdUser.LocaleSidKey,
			'Locale mismatch'
		);
		Assert.areEqual(
			testUser.LanguageLocaleKey,
			createdUser.LanguageLocaleKey,
			'Language locale mismatch'
		);
	}
	/*@description  This method is used for database error while create the user */
	@isTest
	static void testCreateUserWithDatabaseError() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Create test data
		Account testAccount = new Account(
			FirstName = 'Test',
			LastName = 'Account',
			PersonEmail = 'test@example.com'
		);
		insert testAccount;

		try {
			// Call the method to be tested
			Test.startTest();
			BI_PSPB_patientOnboarding.createUser(
				new List<Id>{ testAccount.Id }
			);
		} catch (DmlException ex) {
			// Check if the exception message is as expected
			Assert.areEqual(
				+ex.getMessage(),
				testAccount,
				'Incorrect DML exception type'
			);
		}
		Test.stopTest();
	}
	/*@description  This method is used for thrown empty list for exception*/
	@isTest
	static void testCreateUserExceptionThrownEmptyList() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		Test.startTest();
		try {
			BI_PSPB_patientOnboarding.createUser(new List<Id>());
		} catch (Exception ex) {
			Assert.areEqual(
				ex.getMessage(),
				'Empty List',
				'No Patient accounts found'
			);
		}
		Test.stopTest();
	}
	/*@description  This method is used for chcek the if account id is null*/
	@isTest
	static void testCreateUserNullAccountId() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
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
		// Test method invocation with null Account Id list
		Test.startTest();
		try {
			BI_PSPB_patientOnboarding.createUser(new List<Id>{ testUser.Id });
		} catch (Exception ex) {
			// Exception expected
			Assert.arenotequal(
				null,
				ex.getMessage(),
				'Exception message should not be null'
			);
		}
		Test.stopTest();
	}
}