/**
@description	       This class contains unit tests for the BI_PSPB_caregiverOnboarding 
                        Apex class, which is responsible for the creation
					    and management of user records linked to caregiver accounts.
@author					Divya Bharathi S
@Last Modified On   	04/23/2024
@Last Modified By 		Divya Bharathi S
*/
@isTest
private class BI_PSPB_caregiverOnboardingTest {
	/*@description This method used to create a user with caregiver profile  */
	@isTest
	static void testCreateUserNoExistingUser() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Create test data - Account with RecordType 'BI_PSP_Caregiver'
		RecordType rt = [
			SELECT Id
			FROM RecordType
			WHERE SObjectType = 'Account' AND DeveloperName = 'BI_PSP_Caregiver'
			LIMIT 1
		];
		// Verify the recordtype is not null
		Assert.arenotequal(null, rt, 'RecordType not found');
		Account acc = new Account(
			FirstName = 'Test',
			LastName = 'Acc',
			PersonEmail = 'testacc@example.com',
			RecordTypeId = rt.Id,
			// Ensure the Account has a Billing Address to avoid being treated as a Person Account
			BillingStreet = '123 Test St',
			BillingCity = 'Test City',
			BillingState = 'Alabama',
			BillingPostalCode = '12345',
			BillingCountry = 'United States'
		);

		insert acc;

		Profile portalProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Caregiver Profile'
			LIMIT 1
		];
		// Verify the profile is not null
		Assert.arenotequal(null, portalProfile, 'Portal profile not found');

		Test.startTest();
		// Call the method to be tested
		BI_PSPB_caregiverOnboarding.createUser(new List<Id>{ acc.Id });
		Test.stopTest();

		// Verify the user creation
		List<User> createdUsers = [
			SELECT Id
			FROM User
			WHERE AccountId = :acc.Id
		];
		Assert.areEqual(
			1,
			createdUsers.size(),
			'User should have been created'
		);
	}
	/**
	 @description This method is creating existing user for caregiver */
	@isTest
	static void testCreateUserExistingUser() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Create test data - Person Account with RecordType 'BI_PSP_Caregiver'
		RecordType rt = [
			SELECT Id
			FROM RecordType
			WHERE SObjectType = 'Account' AND DeveloperName = 'BI_PSP_Caregiver'
			LIMIT 1
		];
		// Verify the recordtype is not null
		Assert.arenotequal(null, rt, 'RecordType not found');

		Account acc = new Account(
			FirstName = 'Test',
			LastName = 'Account',
			RecordTypeId = rt.Id,
			BillingStreet = '123 Test St',
			BillingCity = 'Test City',
			BillingState = 'Alabama',
			BillingPostalCode = '12345',
			BillingCountry = 'United States'
		);
		insert acc;
		Profile portalProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Caregiver Profile'
			LIMIT 1
		];
		// Verify the profile is not null
		Assert.arenotequal(null, portalProfile, 'Portal profile not found');

		// Create a test Contact associated with the Person Account
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact'
		);
		insert testContact;

		// Create a user for the Person Account
		User existingUser = new User(
			UserName = 'testuser@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'TestUsr',
			Email = 'testuser@example.com',
			ProfileId = portalProfile.id,
			EmailEncodingKey = 'UTF-8',
			// Associate the User directly with the Contact
			ContactId = testContact.Id,
			CommunityNickname = 'testuser@example.com',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US'
		);
		insert existingUser;

		Test.startTest();
		// Call the method to be tested
		BI_PSPB_caregiverOnboarding.createUser(new List<Id>{ acc.Id });
		Test.stopTest();

		// Verify no new user is created
		List<User> createdUsers = [
			SELECT Id
			FROM User
			WHERE ContactId = :testContact.Id
		];
		Assert.areEqual(
			1,
			createdUsers.size(),
			'No new user should have been created'
		);
	}
	/*@description This method thrown null list for caregiver */
	@isTest
	static void testCreateUserExceptionThrownNullList() {
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
		Test.startTest();
		try {
			BI_PSPB_caregiverOnboarding.createUser(new List<Id>{ testUser.Id });
		} catch (Exception ex) {
			Assert.areEqual(
				'Attempt to de-reference a null object',
				ex.getMessage(),
				'Caregiver ID list is null'
			);
		}
		Test.stopTest();
	}
	/*@description This method thrown empty  list for caregiver accounts */

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
			BI_PSPB_caregiverOnboarding.createUser(new List<Id>());
		} catch (Exception ex) {
			Assert.areEqual(
				'No caregiver accounts found',
				ex.getMessage(),
				'Expected result found'
			);
		}
		Test.stopTest();
	}
}