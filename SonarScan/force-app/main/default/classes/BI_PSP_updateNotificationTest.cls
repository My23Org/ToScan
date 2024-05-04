/**
@description	This class contains test methods to verify the functionality of 
				methods related to Update Notification and retrieve the Notification records
@author					Adhish
@Last Modified On   	04/23/2024
@Last Modified By 		Adhish
*/
@isTest
private class BI_PSP_updateNotificationTest {
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description 	This class contains test methods to verify the functionality of 
					methods related to Update Notification
	*/
	@isTest
	static void testUpdateFieldInObject() {
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser@example.com',
			Username = 'testusereeee@example.com',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			Alias = 'tuser',
			ProfileId = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
			]
			.Id
		);

		Contact patientContact = new Contact(
			FirstName = testUser.FirstName,
			LastName = testUser.LastName,
			Email = testUser.Email
		);
		insert patientContact;

		testUser.ContactId = patientContact.Id;
		insert testUser;
		// Create test data
		Account testAccount = new Account(Name = 'Test User');
		insert testAccount;

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		//Create Notification record
		BI_PSP_Notification_Setting__c testNotification = new BI_PSP_Notification_Setting__c(
			BI_PSP_Patient__c = testAccount.Id,
			BI_PSP_Notification_Type__c = 'Challenges'
		);
		insert testNotification;

		// Create wrapper object
		BI_PSP_updateNotification.BI_PSPB_notificationSettingParaWrapper wrapper = new BI_PSP_updateNotification.BI_PSPB_notificationSettingParaWrapper();
		wrapper.emailValue = false;
		wrapper.smsValue = false;
		wrapper.insiteValue = true;
		wrapper.phoneValue = false;
		wrapper.typeValue = 'Challenges';

		Test.startTest();
		System.runAs(testUser) {
			// Test positive scenario
			BI_PSP_updateNotification.updateFieldInObject(
				testAccount.Id,
				wrapper
			);
		}
		// Query to assert the updates
		List<BI_PSP_Notification_Setting__c> updatedNotifications = [
			SELECT
				BI_PSP_Email__c,
				BI_PSP_SMS__c,
				BI_PSP_Insite_Notification__c,
				BI_PSP_Phone__c
			FROM BI_PSP_Notification_Setting__c
			WHERE BI_PSP_Patient__c = :testAccount.Id
		];

		Assert.areEqual(
			true,
			updatedNotifications.size() > 0,
			'Size of updatedNotification'
		);
		Assert.areEqual(
			false,
			updatedNotifications[0].BI_PSP_Email__c,
			'Value of Email'
		);
		Assert.areEqual(
			false,
			updatedNotifications[0].BI_PSP_SMS__c,
			'Value of Sms'
		);
		Assert.areEqual(
			true,
			updatedNotifications[0].BI_PSP_Insite_Notification__c,
			'Value of Insite'
		);
		Assert.areEqual(
			false,
			updatedNotifications[0].BI_PSP_Phone__c,
			'Value of Phone'
		);

		Test.stopTest();
	}
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description 	This class contains test methods to verify the Negative Scenario functionality of 
					methods related to Update Notification
	*/
	@isTest
	static void testUpdateFieldInObjectNegative() {
		try {
			User testUser = new User(
				FirstName = 'Test',
				LastName = 'User',
				Email = 'testuser@example.com',
				Username = 'testusereeee@example.com',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				Alias = 'tuser',
				ProfileId = [
					SELECT Id
					FROM Profile
					WHERE Name = 'BI_PSP_Patient Profile'
				]
				.Id
			);

			Contact patientContact = new Contact(
				FirstName = testUser.FirstName,
				LastName = testUser.LastName,
				Email = testUser.Email
			);
			insert patientContact;

			testUser.ContactId = patientContact.Id;
			insert testUser;
			// Create test data
			Account testAccount = new Account(Name = 'Test User');
			insert testAccount;

			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			// Create wrapper object
			BI_PSP_updateNotification.BI_PSPB_notificationSettingParaWrapper wrapper = new BI_PSP_updateNotification.BI_PSPB_notificationSettingParaWrapper();
			wrapper.emailValue = false;
			wrapper.smsValue = false;
			wrapper.insiteValue = true;
			wrapper.phoneValue = false;
			wrapper.typeValue = 'Challenges';

			Test.startTest();
			System.runAs(testUser) {
				// Test positive scenario
				BI_PSP_updateNotification.updateFieldInObject(
					testAccount.Id,
					wrapper
				);
				// Query to assert the updates
			}
			// Query to assert the updates
			Test.stopTest();
		} catch (Exception e) {
			/*  While running negative scenario, the flow goes to catch.
                Thus resulting in throwing exception and so assertion is done
                for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description 	This class contains test methods to verify the Negative Scenario functionality of 
					methods related to Update Notification
	*/
	@isTest
	static void testNegativeUpdateFieldInObject() {
		try {
			User testUser = new User(
				FirstName = 'Test',
				LastName = 'User',
				Email = 'testuser@example.com',
				Username = 'testusereeee@example.com',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				Alias = 'tuser',
				ProfileId = [
					SELECT Id
					FROM Profile
					WHERE Name = 'BI_PSP_Patient Profile'
				]
				.Id
			);

			Contact patientContact = new Contact(
				FirstName = testUser.FirstName,
				LastName = testUser.LastName,
				Email = testUser.Email
			);
			insert patientContact;

			testUser.ContactId = patientContact.Id;
			insert testUser;
			// Create test data
			Account testAccount = new Account(Name = 'Test User');
			insert testAccount;

			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			//Create Notification record
			BI_PSP_Notification_Setting__c testNotification = new BI_PSP_Notification_Setting__c(
				BI_PSP_Patient__c = testAccount.Id,
				BI_PSP_Notification_Type__c = 'Challenges'
			);
			insert testNotification;

			// Create wrapper object
			BI_PSP_updateNotification.BI_PSPB_notificationSettingParaWrapper wrapper = new BI_PSP_updateNotification.BI_PSPB_notificationSettingParaWrapper();
			wrapper.emailValue = false;
			wrapper.smsValue = false;
			wrapper.insiteValue = true;
			wrapper.phoneValue = false;
			wrapper.typeValue = 'Challenges';

			Test.startTest();
			// Test negative scenario - no account ID provided

			System.runAs(testUser) {
				BI_PSP_updateNotification.updateFieldInObject(null, wrapper);
			}

			Test.stopTest();
		} catch (Exception e) {
			/*  While running negative scenario, the flow goes to catch.
                Thus resulting in throwing exception and so assertion is done
                for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description 	This class contains test methods to verify the functionality of 
					methods related to retrieve the specific notification type records
	*/

	@isTest
	static void testRetrieveNotifications() {
		// Create test data
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser@example.com',
			Username = 'testusereeee@example.com',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			Alias = 'tuser',
			ProfileId = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
			]
			.Id
		);

		Contact patientContact = new Contact(
			FirstName = testUser.FirstName,
			LastName = testUser.LastName,
			Email = testUser.Email
		);
		insert patientContact;

		testUser.ContactId = patientContact.Id;
		insert testUser;
		// Create test data
		Account testAccount = new Account(Name = 'Test User');
		insert testAccount;

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		BI_PSP_Notification_Setting__c testNotification = new BI_PSP_Notification_Setting__c(
			BI_PSP_Patient__c = testAccount.Id,
			BI_PSP_Notification_Type__c = 'Challenges'
		);
		insert testNotification;

		Test.startTest();
		// Test positive scenario
		System.runAs(testUser) {
			List<BI_PSP_Notification_Setting__c> notify = BI_PSP_updateNotification.retrieveNotifications(
				testAccount.Id,
				'Challenges'
			);
			Assert.areEqual(1, notify.size(), 'List Of Notification');
		}
		// Test negative scenario - no account ID provided
		Boolean isExceptionThrown = false;
		try {
			System.runAs(testUser) {
				BI_PSP_updateNotification.retrieveNotifications(
					null,
					'Challenges'
				);
			}
		} catch (AuraHandledException ex) {
			isExceptionThrown = true;
		}
		Assert.areEqual(true, isExceptionThrown, 'Exception Thrown');

		Test.stopTest();
	}
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description	 This class contains test methods to verify the functionality of 
					methods related to negative scenerio for retrieve notification
	*/

	@isTest
	static void testRetrieveNotificationsNegativeScenarioNoMatchingType() {
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser@example.com',
			Username = 'testusereeee@example.com',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			Alias = 'tuser',
			ProfileId = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
			]
			.Id
		);

		Contact patientContact = new Contact(
			FirstName = testUser.FirstName,
			LastName = testUser.LastName,
			Email = testUser.Email
		);
		insert patientContact;

		testUser.ContactId = patientContact.Id;
		insert testUser;
		// Create test data
		Account testAccount = new Account(Name = 'Test User');
		insert testAccount;

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		Test.startTest();
		// Test positive scenario

		// Test negative scenario - no matching notification type provided
		Boolean isExceptionThrown = false;
		try {
			System.runAs(testUser) {
				List<BI_PSP_Notification_Setting__c> notify = BI_PSP_updateNotification.retrieveNotifications(
					testAccount.Id,
					'Challenges'
				);
				Assert.areEqual(0, notify.size(), 'List Of Notification');
			}
		} catch (AuraHandledException ex) {
			/*  While running negative scenario, the flow goes to catch.
                Thus resulting in throwing exception and so assertion is done
                for Exception only.*/
			isExceptionThrown = true;
			Assert.areEqual(true, isExceptionThrown, 'Exception Thrown');
		}

		Test.stopTest();
	}
}