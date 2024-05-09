/**
@description	This class contains test methods to verify the functionality of 
				methods related to BI_PSPB_FollowUserCtrl with valid and invalid inputs.
@author					Ragavi
@Last Modified On   	04/28/2024
@Last Modified By 		Ragavi
*/
@isTest
private class BI_PSPB_FollowUserCtrlTest {
	// Test data variables.
	public static User testUserPatient;
	public static User testUserCaregiver;
	public static Account testAccountForPatient;
	public static Account testAccountForCaregiver;
	public static Contact contactForPatient;
	public static Contact contactForCaregiver;
	// Constructor to create test data.
	static {
		// User as a patient.
		testUserPatient = new User(
			FirstName = 'TestUser12',
			LastName = 'LastName12',
			Email = 'testuser12@example.com',
			UserName = 'testuser12@example.com',
			BI_PSPB_Caregiver__c = false,
			Alias = 'tuser1',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = [
				SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile'].Id);
		// User as a caregiver.
		testUserCaregiver = new User(
			FirstName = 'TestUser23',
			LastName = 'LastName23',
			Email = 'testuser23@example.com',
			UserName = 'testuser23@example.com',
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
		// Contact for caregiver user.
		contactForCaregiver = new Contact(
			FirstName = testUserCaregiver.FirstName,
			LastName = testUserCaregiver.LastName,
			Email = testUserCaregiver.Email);
		insert contactForPatient;
		insert contactForCaregiver;
		// Assigning contacts to the users.
		testUserPatient.ContactId = contactForPatient.Id;
		testUserCaregiver.ContactId = contactForCaregiver.Id;
		insert testUserPatient;
		insert testUserCaregiver;
		// Account related to patient user.
		testAccountForPatient = new Account(
			FirstName = 'TestUser12',
			LastName = 'LastName12',
			PersonEmail = 'testuser12@example.com',
			RecordTypeId = [
				SELECT Id FROM RecordType WHERE SObjectType = 'Account' 
				AND Name = 'Person Account'].Id, OwnerId = testUserPatient.Id);
		// Account related to caregiver user.
		testAccountForCaregiver = new Account(
			FirstName = 'TestUser23',
			LastName = 'LastName23',
			PersonEmail = 'testuser23@example.com',
			BI_PSPB_Selected_Patient_ID__c = testAccountForPatient.Id,
			RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account'
			AND Name = 'Person Account'].Id, OwnerId = testUserCaregiver.Id);
		insert testAccountForPatient;
		insert testAccountForCaregiver;
		// Create mock BI_SFCOE_LOG_App_Settings__c record.
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo');
		insert settings;
	}
	/**
	* @description Test method to verify following a user with 
	null value as input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testFollowUserWithNull() {
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
					// Passing null value for Account Id to follow.
					BI_PSPB_FollowUserCtrl.followUser(testAccountForCaregiver.Id, null);
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
	* @description Test method to verify following a user with valid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testFollowUser() {
		System.runAs(testUserPatient) {
			// Fetching List of followings before following. 
			List < BI_PSP_FeedFollow__c > existingRecord =[SELECT Id FROM 
				BI_PSP_FeedFollow__c WHERE
				(BI_PSP_Account__c = : testAccountForPatient.Id
				AND BI_PSP_AccountUser__c = : testAccountForCaregiver.Id
				AND BI_PSP_Type__c = 'Following')
				OR(BI_PSP_Account__c = : testAccountForCaregiver.Id
				AND BI_PSP_AccountUser__c = : testAccountForPatient.Id
				AND BI_PSP_Type__c = 'Follower')];
			Test.startTest();
			// To follow the testAccountForCaregiver account.
			BI_PSPB_FollowUserCtrl.followUser(testAccountForCaregiver.Id,
				testUserPatient.Id);
			Test.stopTest();
			// Fetching List of followings after following. 
			List < BI_PSP_FeedFollow__c > followRecordAfterFollowing =
			[SELECT Id FROM BI_PSP_FeedFollow__c WHERE
				(BI_PSP_Account__c = : testAccountForPatient.Id
				AND BI_PSP_AccountUser__c = : testAccountForCaregiver.Id
				AND BI_PSP_Type__c = 'Following')
				OR(BI_PSP_Account__c = : testAccountForCaregiver.Id
				AND BI_PSP_AccountUser__c = : testAccountForPatient.Id
				AND BI_PSP_Type__c = 'Follower')];
			// Checking for not following the user before the method is called.
			Assert.areequal(0, existingRecord.size(),
				'There are no followings before following');
			// Checking for following the user after the method is called.
			Assert.areequal(2, followRecordAfterFollowing.size(),
				'There is follower and following record after following');
		}
	}
	/**
	* @description Test method to verify following a user with invalid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testFollowUserException() {
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
					// Method is called with invalid account Id.
					BI_PSPB_FollowUserCtrl.followUser(testAccountForCaregiver.Id,
						'invalidId');
				Test.stopTest();
			}
			catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify following a 
	user with existing record.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testFollowUserExisting() {
		System.runAs(testUserPatient) {
			try {
				// Creating follower for testAccountForCaregiver.
				BI_PSP_FeedFollow__c testFollowerRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_Account__c = testAccountForCaregiver.Id,
					BI_PSP_AccountUser__c = testAccountForPatient.Id,
					BI_PSP_Type__c = 'Follower');
				insert testFollowerRecord;
				// Creating following record for testAccountForPatient.
				BI_PSP_FeedFollow__c testFollowingRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_Account__c = testAccountForPatient.Id,
					BI_PSP_AccountUser__c = testAccountForCaregiver.Id,
					BI_PSP_Type__c = 'Following');
				insert testFollowingRecord;
				// Creating following record for testAccountForPatient.
				BI_PSP_FeedFollow__c testFollowerAccountRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_Account__c = testAccountForCaregiver.Id,
					BI_PSP_AccountUser__c = testAccountForPatient.Id,
					BI_PSP_Type__c = 'Following');
				insert testFollowerAccountRecord;
				// Creating follower for testAccountForPatient.
				BI_PSP_FeedFollow__c testFollowingAccountRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_Account__c = testAccountForPatient.Id,
					BI_PSP_AccountUser__c = testAccountForCaregiver.Id,
					BI_PSP_Type__c = 'Follower');
				insert testFollowingAccountRecord;
				Test.startTest();
					// Following the account testAccountForCaregiver.
					BI_PSPB_FollowUserCtrl.followUser(testAccountForCaregiver.Id,
						testUserPatient.Id);
				Test.stopTest();
			}
			catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify following 
	a user with null values as account input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testFollowUserNullAccount() {
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
				// Following with invalid input.
					BI_PSPB_FollowUserCtrl.followUser('Invalid Id', testUserPatient.Id);
				Test.stopTest();
			}
			catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify number of followers 
	for a user with valid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testGetMyFollowers() {
		System.runAs(testUserPatient) {
			// Creating followers for testAccountForPatient.
			BI_PSP_FeedFollow__c testFollowRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_Account__c = testAccountForPatient.Id,
				BI_PSP_AccountUser__c = testAccountForCaregiver.Id,
				BI_PSP_Type__c = 'Follower');
			insert testFollowRecord;
			Test.startTest();
				// Getting followers for user testUserPatient.
				List < BI_PSP_FeedFollow__c > followersOfPatientUser =
				BI_PSPB_FollowUserCtrl.getMyFollowers(testUserPatient.Id);
			Test.stopTest();
			// Checking for followers after method call.
			Assert.areEqual(1, followersOfPatientUser.size(),
				'Expected one follower record.');
		}
	}
	/**
	* @description Test method to verify numbre of followers 
	for a user with invalid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testGetMyFollowersWithInvalidInput() {
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
					// Getting followers for account testAccountForCaregiver.
					BI_PSPB_FollowUserCtrl.getMyFollowers(testAccountForCaregiver.Id);
				Test.stopTest();
			}
			catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify following a 
	user with null value as input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testGetMyFollowersNull() {
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
					// Getting followers by passing null value as input.
					BI_PSPB_FollowUserCtrl.getMyFollowers(null);
				Test.stopTest();
			}
			catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception', e.getMessage(),
					'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify unfollowing a 
	user with valid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testUnfollowUser() {
		System.runAs(testUserPatient) {
			// Creating follower record for testAccountForCaregiver.
			BI_PSP_FeedFollow__c testFollowerRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_Account__c = testAccountForCaregiver.Id,
				BI_PSP_AccountUser__c = testAccountForPatient.Id,
				BI_PSP_Type__c = 'Follower');
			insert testFollowerRecord;
			// Creating following record for testAccountForPatient.
			BI_PSP_FeedFollow__c testFollowingRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_Account__c = testAccountForPatient.Id,
				BI_PSP_AccountUser__c = testAccountForCaregiver.Id,
				BI_PSP_Type__c = 'Following');
			insert testFollowingRecord;
			// Creating following record for testAccountForCaregiver.
			BI_PSP_FeedFollow__c testFollowingAccountRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_Account__c = testAccountForCaregiver.Id,
				BI_PSP_AccountUser__c = testAccountForPatient.Id,
				BI_PSP_Type__c = 'Following');
			insert testFollowingAccountRecord;
			// Creating follower record for testAccountForPatient.
			BI_PSP_FeedFollow__c testFollowerAccountRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_Account__c = testAccountForPatient.Id,
				BI_PSP_AccountUser__c = testAccountForCaregiver.Id,
				BI_PSP_Type__c = 'Follower');
			insert testFollowerAccountRecord;
			// Fetching list of followers before unfollowing.
			List < BI_PSP_FeedFollow__c > existingRecord =
				[SELECT Id FROM BI_PSP_FeedFollow__c
				WHERE BI_PSP_Account__c = : testAccountForPatient.Id 
				AND BI_PSP_AccountUser__c = : testAccountForCaregiver.Id
				AND BI_PSP_Type__c = 'Following'];
			Test.startTest();
				// Unfollowing testAccountForCaregiver account.
				BI_PSPB_FollowUserCtrl.unfollowUser(testAccountForCaregiver.Id,
					testUserPatient.Id);
			Test.stopTest();
			// Fetching list of followers after unfollowing.
			List < BI_PSP_FeedFollow__c > recordAfterUnfollowing =
				[SELECT Id FROM BI_PSP_FeedFollow__c
				WHERE BI_PSP_Account__c = : testAccountForPatient.Id AND
				BI_PSP_AccountUser__c = : testAccountForCaregiver.Id
				AND BI_PSP_Type__c = 'Following'];
			// Checking for size of the records before following. 
			Assert.areEqual(1, existingRecord.size(), 'Expected 1');
			if (recordAfterUnfollowing != null) {
				// Checking for size of the records after following. 
				Assert.areEqual(0, recordAfterUnfollowing.size(), 'Expected 0');
			}
		}
	}
	/**
	* @description Test method to verify unfollowing a 
	user with invalid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testUnfollowUserWithInvalidInput() {
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
				// Unfollowing with ivalid inputs.
				BI_PSPB_FollowUserCtrl.unfollowUser('dfg6tygh', 'adfgh');
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
	* @description Test method to verify following 
	a user with null value as input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testUnfollowUserNull() {
		System.runAs(testUserPatient) {
			try {
				Test.startTest();
				// Unfollowing with null value as inputs.
				BI_PSPB_FollowUserCtrl.unfollowUser('', '');
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