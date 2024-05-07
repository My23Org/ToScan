/**
@description			This class contains test methods to verify the functionality of
						methods related to BI_PSPB_NotificationTaskRecord
                        with valid and invalid inputs.
@author					Joyal christopher
@Last Modified On		04/23/2024
@Last Modified By		Joyal Christopher
*/
//test the getTaskRecordAction method
@isTest
private class BI_PSPB_NotificationTaskRecordUATest {
/**
 * @description The test method to check the action records in getTaskRecordAction.
 */
	@isTest
	static void testGetTaskRecordAction() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		//create profile and user
		Profile testProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
		];
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser@example.com',
			Username = 'testusereeee@example.com',
			ProfileId = testProfile.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			Alias = 'tuser'
		);
		insert testUser;
		// Create test data
		Account testAccount = new Account(Name = 'Test User');
		insert testAccount;
		// Create a Care Program record
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program'
		);
		insert testCareProgram;

		/* Create a Care Program Enrollee record associated
		 with the patient and care program*/
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			CareProgramId = testCareProgram.Id,
			Name = 'Test Enrollee'
		);
		insert testCPE;
		//Create task record
		Task testTasks = new Task(
			Subject = 'Testing Symptom',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Symptom Tracker',
			Status = 'Action Required',
			WhatId = testCPE.Id
		);
		insert testTasks;
		Test.startTest();
		System.runAs(testUser) {
			// Test when notificatonType is ACTION_TYPE_NotificatonTypeAction
			List<Task> tasks = BI_PSPB_NotificationTaskRecordUA.getTaskRecordAction(
				'SampleAccountId',
				BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction,
				null
			);
			// Assert that tasks are retrieved properly
			Assert.areEqual(
				0,
				tasks.size(),
				'Should be 0 tasks because accountId is not relevant'
			);

			// Test when category is ACTION_TYPE_SymptomTracker
			tasks = BI_PSPB_NotificationTaskRecordUA.getTaskRecordAction(
				testCPE.Id,
				'Action required',
				BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker
			);
			// Assert that tasks are retrieved properly
			Assert.areEqual(
				1,
				tasks.size(),
				'Should be 1 tasks because notificatonType is not relevant'
			);

			// Test when category is ACTION_TYPE_Questionnaires
			
		}
		Test.stopTest();
		// You can add more test cases as needed
	}
    

	/**
	 * @description The test method to check the history records in getTaskHistory.
	 */

	@isTest
	static void testGetTaskHistory() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'null',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		//insert user
		Profile testProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
		];
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser@example.com',
			Username = 'testusereeee@example.com',
			ProfileId = testProfile.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			Alias = 'tuser'
		);
		insert testUser;
		//Create Account
		Account testPatient = new Account(Name = 'Test User');
		insert testPatient;

		// Create a Care Program record
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program'
		);
		insert testCareProgram;

		/* Create a Care Program Enrollee record associated
		 with the patient and care program*/
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testPatient.Id,
			CareProgramId = testCareProgram.Id,
			Name = 'Test Enrollee'
		);
		insert testCPE;
		Test.startTest();
		System.runAs(testUser) {
			// Test when notificationType is ACTION_TYPE_NotificationTypeHistory
			List<Task> tasks = BI_PSPB_NotificationTaskRecordUA.getTaskHistory(
				testCPE.Id,
				BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeHistory
			);

			/*Assert that no tasks are retrieved because
			 accountId is not relevant for history type */
			Assert.areEqual(
				0,
				tasks.size(),
				'Should be 0 tasks because accountId is not relevant for history type'
			);

			// Test when notificationType is ACTION_TYPE_NotificationTypeGeneral
			tasks = BI_PSPB_NotificationTaskRecordUA.getTaskHistory(
				testCPE.Id,
				BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeGeneral
			);
			/* Assert that no tasks are retrieved because
			 accountId is not relevant for general type*/
			Assert.areEqual(
				0,
				tasks.size(),
				'Should be 0 tasks because accountId is not relevant for general type'
			);

			// Test when notificationType is ACTION_TYPE_NotificationTypeAction
			tasks = BI_PSPB_NotificationTaskRecordUA.getTaskHistory(
				testCPE.Id,
				BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction
			);
			/* Assert that no tasks are retrieved because
			 accountId is not relevant for action type */
			Assert.areEqual(
				0,
				tasks.size(),
				'Should be 0 tasks because accountId is not relevant for action type'
			);
		}
		Test.stopTest();
	}
	/**
	 *	@description The test method to check the history records in 
		getTaskHistory failed to retrieve any records
	 */

	@isTest
	static void testGetTaskHistoryNegative() {
		try {
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'null',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			//insert user
			Profile testProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'Standard User'
			];
			User testUser = new User(
				FirstName = 'Test',
				LastName = 'User',
				Email = 'testuser@example.com',
				Username = 'testusereeee@example.com',
				ProfileId = testProfile.Id,
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				Alias = 'tuser'
			);
			insert testUser;
			//Create Account
			Account testPatient = new Account(Name = 'Test User');
			insert testPatient;

			// Create a Care Program record
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Care Program'
			);
			insert testCareProgram;

			/* Create a Care Program Enrollee record associated
			 with the patient and care program*/
			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testPatient.Id,
				CareProgramId = testCareProgram.Id,
				Name = 'Test Enrollee'
			);
			insert testCPE;
			Test.startTest();
			System.runAs(testUser) {
				// Test when notificationType is ACTION_TYPE_NotificationTypeHistory
				List<Task> tasks = BI_PSPB_NotificationTaskRecordUA.getTaskHistory(
					testCPE.Id,
					BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeHistory
				);
				BI_PSPB_NotificationTaskRecordUA.getTaskHistory(
					null,
					BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeHistory
				);
				/*Assert that no tasks are retrieved because
				 accountId is not relevant for history type */
				Assert.areEqual(
					0,
					tasks.size(),
					'Should be 0 tasks because accountId is not relevant for history type'
				);

				// Test when notificationType is ACTION_TYPE_NotificationTypeGeneral
				tasks = BI_PSPB_NotificationTaskRecordUA.getTaskHistory(
					testCPE.Id,
					BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeGeneral
				);
				/* Assert that no tasks are retrieved because
				 accountId is not relevant for general type*/
				Assert.areEqual(
					0,
					tasks.size(),
					'Should be 0 tasks because accountId is not relevant for general type'
				);

				// Test when notificationType is ACTION_TYPE_NotificationTypeAction
				tasks = BI_PSPB_NotificationTaskRecordUA.getTaskHistory(
					testCPE.Id,
					BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction
				);
				/* Assert that no tasks are retrieved because
				 accountId is not relevant for action type */
			}
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
}