/**
@description	This class contains test methods to verify the functionality of 
				methods related to community usernames with valid and invalid inputs.
@author					Deepa
@Last Modified On   	04/28/2024
@Last Modified By 		Deepa
*/
@isTest
private class BI_PSPB_CommunityUsernameTest {
	// Test data Variables.
	public static User testUserCaregiver;
	public static User testUserPatient;
	public static User testUserPatientWithoutAvatar;
	public static User testUserWithoutAccount;
	public static Account testAccount;
	public static Account testAccountWithoutAvatar;
	public static Account testAccountWithoutCommunityUsername;
	public static Contact contactForPatient;
	public static Contact contactForPatientWithoutAvatar;
	public static Contact contactForCaregiver;
	public static Contact contactForPatientWithoutAccount;
	// Constructor to create test data.
	static {
		// User as a patient.
		testUserPatient = new User(
			FirstName = 'TestUser',
			LastName = 'Patient',
			Email = 'testuser12@example.com',
			Username = 'testuser12@example.com',
			BI_PSPB_Caregiver__c = false,
			Alias = 'tuser1',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = [SELECT Id FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'].Id);
		// User as a patient without avatar.
		testUserPatientWithoutAvatar = new User(
			FirstName = 'TestUserWithoutAvatar',
			LastName = 'PatientWithoutAvatar',
			Email = 'testuser12WithoutAvatar@example.com',
			Username = 'testuser12WithoutAvatar@example.com',
			BI_PSPB_Caregiver__c = false,
			Alias = 'tuserWOA',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = [SELECT Id FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'].Id);
		// User as a caregiver.
		testUserCaregiver = new User(
			FirstName = 'TestUser',
			LastName = 'Caregiver',
			Email = 'testuser23@example.com',
			Username = 'testuser23@example.com',
			BI_PSPB_Caregiver__c = true,
			Alias = 'tuser2',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = [SELECT Id FROM Profile
			WHERE Name = 'BI_PSP_Caregiver Profile'].Id);
		// User as a caregiver without account.
		testUserWithoutAccount = new User(
			FirstName = 'TestUser',
			LastName = 'WithoutAccount',
			Email = 'testuserwithoutaccount@example.com',
			Username = 'testuserwithoutaccount@example.com',
			BI_PSPB_Caregiver__c = true,
			Alias = 'tuser2',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = [SELECT Id FROM Profile WHERE 
			Name = 'BI_PSP_Caregiver Profile'].Id);
		// Contact for patient user.
		contactForPatient = new Contact(
			FirstName = testUserPatient.FirstName,
			LastName = testUserPatient.LastName,
			Email = testUserPatient.Email);
		// Contact for patient without avatar.
		contactForPatientWithoutAvatar = new Contact(
			FirstName = testUserPatientWithoutAvatar.FirstName,
			LastName = testUserPatientWithoutAvatar.LastName,
			Email = testUserPatientWithoutAvatar.Email);
		// Contact for caregiver.
		contactForCaregiver = new Contact(
			FirstName = testUserCaregiver.FirstName,
			LastName = testUserCaregiver.LastName,
			Email = testUserCaregiver.Email);
		// Contact for patient without account.
		contactForPatientWithoutAccount = new Contact(
			FirstName = testUserWithoutAccount.FirstName,
			LastName = testUserWithoutAccount.LastName,
			Email = testUserWithoutAccount.Email);
		// Creating all contacts.
		insert contactForPatient;
		insert contactForPatientWithoutAvatar;
		insert contactForCaregiver;
		insert contactForPatientWithoutAccount;
		// Assigning contacts to the respective user.
		testUserPatient.ContactId = contactForPatient.Id;
		testUserPatientWithoutAvatar.ContactId =
			contactForPatientWithoutAvatar.Id;
		testUserCaregiver.ContactId = contactForCaregiver.Id;
		testUserWithoutAccount.ContactId = contactForPatientWithoutAccount.Id;
		// Creating all users.
		insert testUserCaregiver;
		insert testUserPatientWithoutAvatar;
		insert testUserPatient;
		insert testUserWithoutAccount;
		// Account for caregiver.
		testAccount = new Account(
			FirstName = 'TestUser', LastName = 'Patient',
			PersonEmail = 'testuser12@example.com',
			RecordTypeId = [SELECT Id FROM RecordType
			WHERE SObjectType = 'Account' AND Name = 'Person Account'].Id,
			OwnerId = testUserCaregiver.Id,
			BI_PSP_CommunityUsername__c = 'patient1',
			BI_PSP_AvatarUrl__c =
			'/Branded/resource/1702471083000/BI_PSPB_AfroMan_Adult');
		// Account for patient without avatar.
		testAccountWithoutAvatar = new Account(
			FirstName = 'TestUserWithoutAvatar',
			LastName = 'PatientWithoutAvatar',
			PersonEmail = 'testuser12WithoutAvatar@example.com',
			RecordTypeId = [SELECT Id FROM RecordType
			WHERE SObjectType = 'Account' AND Name = 'Person Account'].Id,
			OwnerId = testUserPatientWithoutAvatar.Id,
			BI_PSP_CommunityUsername__c = 'patient1WithoutAvatar',
			BI_PSP_AvatarUrl__c = null);
		// Account for patient.
		testAccountWithoutCommunityUsername = new Account(
			FirstName = 'TestUser',
			LastName = 'Caregiver',
			PersonEmail = 'testuser12@example.com',
			BI_PSPB_Selected_Patient_ID__c = testAccount.Id,
			RecordTypeId = [SELECT Id FROM RecordType
			WHERE SObjectType = 'Account' AND Name = 'Person Account'].Id,
			OwnerId = testUserPatient.Id,
			BI_PSP_AvatarUrl__c =
			'/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult');
		// Creating all accounts.
		insert testAccount;
		insert testAccountWithoutAvatar;
		insert testAccountWithoutCommunityUsername;
		// Creating mock BI_SFCOE_LOG_App_Settings__c record.
		BI_SFCOE_LOG_App_Settings__c settings =
			new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName', BI_SFCOE_LOG_Application__c = 'Spevigo');
		insert settings;
	}
	/**
	* @description The test includes scenarios where users have and do not have 
	community usernames. 
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testCheckCommunityUsername() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			Test.startTest();
						// Check if the community username exists for the test user patient.
				Boolean resultWithCommunityUsername =
				BI_PSPB_CommunityUsername.checkCommunityUsername(testUserPatient.Id);
							// Check if the community username exists for the test user caregiver.
				Boolean resultWithoutCommunityUsername =
				BI_PSPB_CommunityUsername.checkCommunityUsername(testUserCaregiver.Id);
			Test.stopTest();
			// Assert that the community username exists for the test user patient.
			Assert.areEqual(true, resultWithCommunityUsername,
				'Community Username exists');
			// Assert that the community username does not exist for the test user caregiver.
			Assert.areEqual(false, resultWithoutCommunityUsername,
				'Result is false');
		}
	}
	/**
	* @description The test includes scenario to throw exception 
	by passing null as paramter.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testCheckCommunityUsernameNull() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			Test.startTest();
			// Attempt to check community username with a null user ID.
			Boolean resultWithException =
				BI_PSPB_CommunityUsername.checkCommunityUsername(null);
			Test.stopTest();
			// Assert that the result is false since a null user ID would not fetch
			// a community username.
			Assert.areEqual(false, resultWithException,
				'Community username is not fetched.');
		}
	}
	/**
	* @description Test method to get the community username with valid input.
	* This method tests whether the correct account is returned 
	based on the user ID provided.
	*/
	@isTest
	static void testGetCommunityUsername() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			// Query the account with the expected community username.
			Account accountWithUsername = [SELECT Id, FirstName, LastName, PersonEmail,
				Phone, BI_PSP_CommunityUsername__c FROM Account WHERE 
				Id = : testAccount.Id];
			Test.startTest();
				// Call the method to get the community username for the test user patient.
				Account resultWithUsername =
				BI_PSPB_CommunityUsername.getCommunityUsername(testUserPatient.Id);
			Test.stopTest();
			// Assert that the retrieved account has the expected community username.
			Assert.areEqual(accountWithUsername, resultWithUsername,
				'The user has a community username');
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	getCommunityUsername method without username.
	* This method tests whether the correct account is returned 
	based on the user ID provided.
	*/
	@isTest
	static void testGetCommunityUsernameWithoutUsername() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
				BI_PSPB_CommunityUsername.getCommunityUsername(testUserCaregiver.Id);
				Test.stopTest();
			} catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	getCommunityUsername method with null value as input.
	* This method tests whether the correct account is returned 
	based on the user ID provided.
	*/
	@isTest
	static void testGetCommunityUsernameNegative() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			// Try to get the community username with an empty user ID.
			try {
				Test.startTest();
				BI_PSPB_CommunityUsername.getCommunityUsername('');
				Test.stopTest();
			} catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the
	insertCommunityUsername method with invalid input.
	* This method tests whether the community username is 
	inserted into the database.
	*/
	@isTest
	static void testInsertCommunityUsernameInvalidInput() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			// Try to insert a community username with invalid input.
			try {
				// Call the method to be tested.
				Test.startTest();
				BI_PSPB_CommunityUsername.insertCommunityUsername
					(testUserPatient.Id, 'Neededmorethantwentyfivecharacters');
				Test.stopTest();
			} catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	insertCommunityUsername method with valid input.
	* This method tests whether the community username is 
	correctly inserted into the database.
	*/
	@isTest
	static void testInsertCommunityUsernameValidInput() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
		// Query the account before the community username is updated.
			Account accountWithUsernameBeforeUpdation =
				[SELECT BI_PSP_CommunityUsername__c FROM Account 
				WHERE Id = : testAccount.Id Limit 1];
			// Call the method to insert a community username.
			Test.startTest();
			BI_PSPB_CommunityUsername.insertCommunityUsername
				(testUserPatient.Id, 'CommunityUsername');
			Test.stopTest();
			// Query the account after the community username is updated.
				Account accountUpdatedWithUsername =
				[SELECT BI_PSP_CommunityUsername__c FROM Account 
				WHERE Id = : testAccount.Id Limit 1];
			// Assert that the community username is updated.
			Assert.areNotEqual(accountWithUsernameBeforeUpdation,
				accountUpdatedWithUsername, 'Community username is updated');
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	insertCommunityUsername method with null value as input.
	* This method tests whether the community username is 
	not inserted into the database.
	*/
	@isTest
	static void testInsertCommunityUsernameNull() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
				// Try to insert a null community username.
				BI_PSPB_CommunityUsername.insertCommunityUsername
					(testUserPatient.Id, null);
				Test.stopTest();
			} catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	insertCommunityUsername method with invalid input to throw exception.
	* This method tests whether the community username is 
	not updated into the database.
	*/
	@isTest
	static void testInsertCommunityUsernameException() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
				// Try to insert a community username with an invalid user ID.
				BI_PSPB_CommunityUsername.insertCommunityUsername
					('invalidId', 'CarolineForbes');
				Test.stopTest();
			} catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the gettingAvatar method
	with valid input.
	* This method tests whether the correct avatar URLs are 
	retrieved for different users.
	*/
	@isTest
	static void testGettingAvatar() {
		// Query the account record with the expected avatar URL.
		List < Account > accountRecord =[SELECT Id, BI_PSP_AvatarUrl__c
			FROM Account WHERE Id = : testAccount.Id];
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			Test.startTest();
			// Call the method to get the avatar URL for the test user patient.
			List < Account > resultForPatient =
			BI_PSPB_CommunityUsername.gettingAvatar(testUserPatient.Id);
			Test.stopTest();
			// Assert that the returned account record has the expected avatar URL.
			Assert.areEqual(accountRecord, resultForPatient,
				'Account is returned with avatar');
		}
	}
	/**
	* @description Test method to verify the behavior of the gettingAvatar method
	with invalid inputs.
	* This method tests whether the correct avatar URLs are 
	retrieved for different users.
	*/
	@isTest
	static void testGettingAvatarForInvalidId() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			// Try to get the avatar URL with an invalid user ID.
			try {
				Test.startTest();
				// Call the method to get the avatar URL with an invalid user ID.
				BI_PSPB_CommunityUsername.gettingAvatar('InvalidId');
				Test.stopTest();
			} catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the gettingAvatar method
	with invalid input where no avatar is existing.
	* This method tests whether avatar URLs are 
	retrieved for the user.
	*/
	@isTest
	static void testGettingAvatarAvatarNull() {
		// Run the test as the test user patient without an avatar.
		System.runAs(testUserPatientWithoutAvatar) {
			// Try to get the avatar URL for a user without an avatar.
			try {
				Test.startTest();
				// Call the method to get the avatar URL for the user without an avatar.
				BI_PSPB_CommunityUsername.gettingAvatar(testUserPatientWithoutAvatar.Id);
				Test.stopTest();
			} catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the gettingAvatar method
	with null value as input.
	* This method tests whether no avatar URLs are retrieved.
	*/
	@isTest
	static void testGettingAvatarNegative() {
		// Run the test as the test user patient.
		System.runAs(testUserPatient) {
			// Try to get the avatar URL with a null user ID.
			try {
				// Call the method to get the avatar URL with a null user ID.
				Test.startTest();
				BI_PSPB_CommunityUsername.gettingAvatar(null);
				Test.stopTest();
			} catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
}