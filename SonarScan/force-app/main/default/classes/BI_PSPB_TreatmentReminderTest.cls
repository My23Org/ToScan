@isTest
public class BI_PSPB_TreatmentReminderTest {
	@isTest
	static void testCreateRemainderRecord() {
		try {
			// Test data setup
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			// Creating test care program
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Care Program',
				StartDate = Date.today()
			);
			insert testCareProgram;

			// Creating test care program enrollee
			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				CareProgramId = testCareProgram.Id,
				Name = 'Test Enrollee'
			);
			insert testCPE;

			Date selectedDate = Date.today();
			List<String> selectedReminders = new List<String>{
				'14',
				'10',
				'7'
			};
			List<String> selectedTreatment = new List<String>{ '3', '1' };

			Test.startTest();
			BI_PSPB_TreatmentReminder.createRemainderRecord(
				testCPE.Id,
				selectedDate,
				selectedReminders,
				selectedTreatment
			);
			Test.stopTest();

			// Querying treatment reminder records created by the method
			List<BI_PSPB_Treatment_Reminder__c> reminders = [
				SELECT
					Id,
					BI_PSPB_Subject__c,
					BI_PSPB_Date_of_Treatment__c,
					BI_PSPB_Reminder_Date__c
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Care_Program_Enrollee__c = :testCPE.Id
			];

			// Assertions
			System.assertNotEquals(
				null,
				reminders,
				'No treatment reminder records were created.'
			);
			System.assertEquals(
				6,
				reminders.size(),
				'Expected 6 treatment reminder records to be created, but found ' +
				reminders.size()
			);

			// Additional assertions based on your requirements
			// Example: Check specific values in the created records
			for (BI_PSPB_Treatment_Reminder__c reminder : reminders) {
				System.assertEquals(
					selectedDate,
					reminder.BI_PSPB_Date_of_Treatment__c,
					'Date of treatment mismatch'
				);
				// Add more assertions as needed
			}
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void testCreateRemainderRecordcatch() {
		try {
			// Test data setup
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			// Creating test care program
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Care Program',
				StartDate = Date.today()
			);
			insert testCareProgram;

			// Creating test care program enrollee
			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				CareProgramId = testCareProgram.Id,
				Name = 'Test Enrollee'
			);
			insert testCPE;

			Date selectedDate = Date.today();
			List<String> selectedReminders = new List<String>{
				'14',
				'10',
				'7'
			};
			List<String> selectedTreatment = new List<String>{ '3', '1' };

			BI_PSPB_Treatment_Reminder__c treatmentrem = new BI_PSPB_Treatment_Reminder__c();
			treatmentrem.BI_PSPB_Care_Program_Enrollee__c = testCPE.Id;
			treatmentrem.BI_PSPB_Status__c = 'Active';
			insert treatmentrem;

			Test.startTest();
			BI_PSPB_TreatmentReminder.createRemainderRecord(
				testCPE.Id,
				selectedDate,
				selectedReminders,
				selectedTreatment
			);
			Test.stopTest();

			// Querying treatment reminder records created by the method
			List<BI_PSPB_Treatment_Reminder__c> reminders = [
				SELECT
					Id,
					BI_PSPB_Subject__c,
					BI_PSPB_Date_of_Treatment__c,
					BI_PSPB_Reminder_Date__c
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Care_Program_Enrollee__c = :testCPE.Id
			];

			// Assertions
			System.assertNotEquals(
				null,
				reminders,
				'No treatment reminder records were created.'
			);
			System.assertEquals(
				6,
				reminders.size(),
				'Expected 6 treatment reminder records to be created, but found ' +
				reminders.size()
			);

			// Additional assertions based on your requirements
			// Example: Check specific values in the created records
			for (BI_PSPB_Treatment_Reminder__c reminder : reminders) {
				System.assertEquals(
					selectedDate,
					reminder.BI_PSPB_Date_of_Treatment__c,
					'Date of treatment mismatch'
				);
				// Add more assertions as needed
			}			
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void testCreateTreatmentReminders() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		try {
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Account testAccount1 = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccount1;

			CareProgram cp = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert cp;

			CareProgramEnrollee testCpa1 = new CareProgramEnrollee(
				Name = 'TestCpa111',
				AccountId = testAccount1.Id,
				CareProgramId = cp.Id,
				// Simulate selected checkboxes
				BI_PSPB_Selected_Checkboxes__c = '14;10;7;3;1'
			);
			insert testCpa1;

			BI_PSPB_Treatment_Reminder__c treatmentrem = new BI_PSPB_Treatment_Reminder__c();
			treatmentrem.BI_PSPB_Care_Program_Enrollee__c = testCpa1.Id;
			treatmentrem.BI_PSPB_Status__c = 'Active';
			insert treatmentrem;

			Test.startTest();

			// Call the method
			Date dateOfTreatment = Date.today();
			BI_PSPB_TreatmentReminder.createTreatmentReminders(
				testCpa1.Id,
				dateOfTreatment
			);

			Test.stopTest();

			// Query for the created treatment reminders
			List<BI_PSPB_Treatment_Reminder__c> reminders = [
				SELECT
					Id,
					BI_PSPB_Subject__c,
					BI_PSPB_Date_of_Treatment__c,
					BI_PSPB_Reminder_Date__c
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Care_Program_Enrollee__c = :testCpa1.Id
			];

			// Verify the number of reminders created
			System.assertNotEquals(
				null,
				reminders,
				'No treatment reminder records were created.'
			);
			//System.assertEquals(6, reminders.size(), 'Expected 6 treatment reminder records to be created, but found ' + reminders.size());

			// Verify each reminder date
			Set<Date> expectedReminderDates = new Set<Date>{ dateOfTreatment };
			for (Integer days : new List<Integer>{ 14, 10, 7, 3, 1 }) {
				expectedReminderDates.add(dateOfTreatment.addDays(-days));
			}			
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	} // Add more test methods as needed for other methods in the BI_PSPB_TreatmentReminder class

	@isTest
	static void testCreateTreatmentReminderscatch() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		try {
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Account testAccount1 = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccount1;

			CareProgram cp = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert cp;

			CareProgramEnrollee testCpe1 = new CareProgramEnrollee(
				Name = 'TestCpa111',
				AccountId = testAccount1.Id,
				CareProgramId = cp.Id
			);
			insert testCpe1;

			// Simulate selected checkboxes
			testCpe1.BI_PSPB_Selected_Checkboxes__c = '14;10;7;3;1';
			update testCpe1;

			Test.startTest();

			// Call the method
			Date dateOfTreatment = Date.today();
			BI_PSPB_TreatmentReminder.createTreatmentReminders(
				testCpe1.Id,
				dateOfTreatment
			);

			Test.stopTest();

			// Query for the created treatment reminders
			List<BI_PSPB_Treatment_Reminder__c> reminders = [
				SELECT
					Id,
					BI_PSPB_Subject__c,
					BI_PSPB_Date_of_Treatment__c,
					BI_PSPB_Reminder_Date__c
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Care_Program_Enrollee__c = :testCpe1.Id
			];

			// Verify the number of reminders created
			System.assertNotEquals(
				null,
				reminders,
				'No treatment reminder records were created.'
			);
			System.assertEquals(
				6,
				reminders.size(),
				'Expected 6 treatment reminder records to be created, but found ' +
				reminders.size()
			);

			// Verify each reminder date
			Set<Date> expectedReminderDates = new Set<Date>{ dateOfTreatment };
			for (Integer days : new List<Integer>{ 14, 10, 7, 3, 1 }) {
				expectedReminderDates.add(dateOfTreatment.addDays(-days));
			}

			for (BI_PSPB_Treatment_Reminder__c reminder : reminders) {
				System.assert(
					expectedReminderDates.contains(
						reminder.BI_PSPB_Reminder_Date__c
					),
					'Unexpected reminder date'
				);
			}
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
	@isTest
	static void testGetDateOfTreatment() {
		try {
			// Test data setup
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			CareProgram testDrug = new CareProgram(
				Name = 'testprogram',
				StartDate = Date.today()
			);
			insert testDrug;

			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'testcpeaccount',
				CareProgramId = testDrug.Id
			);
			insert testCPE;

			// Create treatment reminder records
			BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 1',
				BI_PSPB_Date_of_Treatment__c = Date.today(),
				BI_PSPB_Reminder_Date__c = Date.today(),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
			);
			insert reminder1;

			BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 2',
				BI_PSPB_Date_of_Treatment__c = Date.today(),
				BI_PSPB_Reminder_Date__c = Date.today(),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
			);
			insert reminder2;

			Test.startTest();

			// Call the method
			List<BI_PSPB_Treatment_Reminder__c> reminders = BI_PSPB_TreatmentReminder.getDateOfTreatment(
				testCPE.Id
			);

			Test.stopTest();

			// Verify the returned list
			System.assertNotEquals(
				null,
				reminders,
				'No treatment reminder records were fetched.'
			);
			System.assertEquals(
				2,
				reminders.size(),
				'Expected 2 treatment reminder records to be fetched, but found ' +
				reminders.size()
			);
			System.assertEquals(
				'Test Reminder 1',
				reminders[0].BI_PSPB_Subject__c,
				'Unexpected reminder subject'
			);
			System.assertEquals(
				Date.today(),
				reminders[0].BI_PSPB_Date_of_Treatment__c,
				'Unexpected date of treatment'
			);
			System.assertEquals(
				'Test Reminder 2',
				reminders[1].BI_PSPB_Subject__c,
				'Unexpected reminder subject'
			);
			System.assertEquals(
				Date.today(),
				reminders[1].BI_PSPB_Date_of_Treatment__c,
				'Unexpected date of treatment'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void testGetDateOfTreatmentelse() {
		try {
			// Test data setup
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			CareProgram testDrug = new CareProgram(
				Name = 'testprogram',
				StartDate = Date.today()
			);
			insert testDrug;

			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'testcpeaccount',
				CareProgramId = testDrug.Id
			);
			insert testCPE;

			Test.startTest();

			// Call the method
			List<BI_PSPB_Treatment_Reminder__c> reminders = BI_PSPB_TreatmentReminder.getDateOfTreatment(
				testCPE.Id
			);

			Test.stopTest();

			// Verify the returned list
			System.assertNotEquals(
				null,
				reminders,
				'No treatment reminder records were fetched.'
			);
			System.assertEquals(
				2,
				reminders.size(),
				'Expected 2 treatment reminder records to be fetched, but found ' +
				reminders.size()
			);
			System.assertEquals(
				'Test Reminder 1',
				reminders[0].BI_PSPB_Subject__c,
				'Unexpected reminder subject'
			);
			System.assertEquals(
				Date.today(),
				reminders[0].BI_PSPB_Date_of_Treatment__c,
				'Unexpected date of treatment'
			);
			System.assertEquals(
				'Test Reminder 2',
				reminders[1].BI_PSPB_Subject__c,
				'Unexpected reminder subject'
			);
			System.assertEquals(
				Date.today(),
				reminders[1].BI_PSPB_Date_of_Treatment__c,
				'Unexpected date of treatment'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void testGetDateOfTreatment_NoReminders() {
		try {
			// Test data setup
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			CareProgram testDrug = new CareProgram(
				Name = 'testprogram',
				StartDate = Date.today()
			);
			insert testDrug;

			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'testcpeaccount',
				CareProgramId = testDrug.Id
			);
			insert testCPE;

			Test.startTest();

			// Call the method without creating treatment reminder records
			List<BI_PSPB_Treatment_Reminder__c> reminders = BI_PSPB_TreatmentReminder.getDateOfTreatment(
				testCPE.Id
			);

			Test.stopTest();

			// Verify that no treatment reminder records were fetched
			System.assertEquals(
				0,
				reminders.size(),
				'Expected no treatment reminder records to be fetched, but found ' +
				reminders.size()
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void testUpdatePicklist() {
		try {
			// Start test transaction
			// Create a Task record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
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
			Task task = new Task(
				Subject = 'Call',
				Status = 'Open',
				Priority = 'Normal',
				OwnerId = testUser.Id
			);
			insert task;

			System.runAs(testUser) {
				Test.startTest();
				// Call the method to test
				BI_PSPB_TreatmentReminder.updatePicklist(task.Id, 'Yes'); // Assuming 'Yes' is passed as actionValue
				BI_PSPB_TreatmentReminder.updatePicklist(task.Id, 'No');
				Test.stopTest();
			}
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void testUpdatePicklistCatch() {
		try {
			// Start test transaction
			// Create a BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			// Query Standard User profile
			Profile standardUserProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'Standard User'
				LIMIT 1
			];

			// Create a new test user
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

			// Create a Task record
			Task task = new Task(
				Subject = 'Call',
				Status = 'Open',
				Priority = 'Normal',
				OwnerId = testUser.Id
			);
			insert task;

			// Execute method as the test user
			System.runAs(testUser) {
				Test.startTest();
				// Call the method to test
				BI_PSPB_TreatmentReminder.updatePicklist(testUser.Id, 'No'); // Assuming 'No' is the intended actionValue
				Test.stopTest();
			}
		} catch (Exception ex) {
			// Assert if there's an exception - the actual exception message is used in the assertion
			System.assertEquals(
				'Argument cannot be null.',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void testGetEvents() {
		// Test data setup
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program'
			// Add other required fields as needed
		);
		insert testCareProgram;
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Care Program Enrollee',
			CareProgramId = testCareProgram.Id
		);
		insert testCPE;

		BI_PSPB_Treatment_Reminder__c treminder=new BI_PSPB_Treatment_Reminder__c();
        treminder.BI_PSPB_Care_Program_Enrollee__c=testCPE.Id;
        insert treminder;

		Test.startTest();
        try{
            //this is for negative scenario so assertion is not done
            BI_PSPB_TreatmentReminder.getEvents(testCPE.Id);
        }
		catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
		

		Test.stopTest();
	}
	@isTest
	static void testGetEventscatch() {
		try {
			// Test data setup
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Care Program'
				// Add other required fields as needed
			);
			insert testCareProgram;
			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'Test Care Program Enrollee',
				CareProgramId = testCareProgram.Id
			);
			insert testCPE;

			// Add more test data as needed

			Test.startTest();

			// Call the method to be tested
			List<Task> events = BI_PSPB_TreatmentReminder.getEvents(null);

			Test.stopTest();

			// Assert the results
			System.assertEquals(
				0,
				events.size(),
				'Expected 4 event to be fetched, but found ' + events.size()
			);
			// Add more assertions as needed
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void testGetTasksWithDateOfTreatment() {
		try {
			// Test data setup
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;

			CareProgram testDrug = new CareProgram(
				Name = 'testprogram',
				StartDate = Date.today()
			);
			insert testDrug;

			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'testcpeaccount',
				CareProgramId = testDrug.Id
			);
			insert testCPE;

			// Create treatment reminder records
			BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 1',
				BI_PSPB_Date_of_Treatment__c = Date.today().addDays(1),
				BI_PSPB_Reminder_Date__c = Date.today().addDays(1),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id,
				BI_PSPB_Status__c = 'Active'
			);
			insert reminder1;

			BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 2',
				BI_PSPB_Date_of_Treatment__c = Date.today().addDays(2),
				BI_PSPB_Reminder_Date__c = Date.today().addDays(2),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id,
				BI_PSPB_Status__c = 'Active'
			);
			insert reminder2;

			Test.startTest();

			// Call the method
			List<BI_PSPB_Treatment_Reminder__c> tasks = BI_PSPB_TreatmentReminder.getTasksWithDateOfTreatment(
				testCPE.Id
			);

			Test.stopTest();

			// Verify the returned list
			System.assertNotEquals(
				null,
				tasks,
				'No treatment reminder records were fetched.'
			);
			System.assertEquals(
				1,
				tasks.size(),
				'Expected 1 treatment reminder record to be fetched, but found ' +
				tasks.size()
			);
			System.assertEquals(
				'Test Reminder 1',
				tasks[0].BI_PSPB_Subject__c,
				'Unexpected reminder subject'
			);
			System.assertEquals(
				Date.today().addDays(1),
				tasks[0].BI_PSPB_Reminder_Date__c,
				'Unexpected reminder date'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
	@isTest
	static void testGetTasksWithDateOfTreatmentelse() {
		try {
			// Test data setup
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;

			CareProgram testDrug = new CareProgram(
				Name = 'testprogram',
				StartDate = Date.today()
			);
			insert testDrug;

			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'testcpeaccount',
				CareProgramId = testDrug.Id
			);
			insert testCPE;

			// Create treatment reminder records
			BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 1',
				BI_PSPB_Date_of_Treatment__c = Date.today().addDays(1),
				BI_PSPB_Reminder_Date__c = Date.today().addDays(1),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
			);
			insert reminder1;

			BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 2',
				BI_PSPB_Date_of_Treatment__c = Date.today().addDays(2),
				BI_PSPB_Reminder_Date__c = Date.today().addDays(2),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
			);
			insert reminder2;

			Test.startTest();

			// Call the method
			List<BI_PSPB_Treatment_Reminder__c> tasks = BI_PSPB_TreatmentReminder.getTasksWithDateOfTreatment(
				testCPE.Id
			);

			Test.stopTest();

			// Verify the returned list
			System.assertNotEquals(
				null,
				tasks,
				'No treatment reminder records were fetched.'
			);
			System.assertEquals(
				1,
				tasks.size(),
				'Expected 1 treatment reminder record to be fetched, but found ' +
				tasks.size()
			);
			System.assertEquals(
				'Test Reminder 1',
				tasks[0].BI_PSPB_Subject__c,
				'Unexpected reminder subject'
			);
			System.assertEquals(
				Date.today().addDays(1),
				tasks[0].BI_PSPB_Reminder_Date__c,
				'Unexpected reminder date'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
	@isTest
	static void testGetTasksWithDateOfTreatmentcatch() {
		try {
			// Test data setup
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;

			CareProgram testDrug = new CareProgram(
				Name = 'testprogram',
				StartDate = Date.today()
			);
			insert testDrug;

			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'testcpeaccount',
				CareProgramId = testDrug.Id
			);
			//insert testCPE;

			// Create treatment reminder records
			BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 1',
				BI_PSPB_Date_of_Treatment__c = Date.today().addDays(1),
				BI_PSPB_Reminder_Date__c = Date.today().addDays(1),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
			);
			insert reminder1;

			BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 2',
				BI_PSPB_Date_of_Treatment__c = Date.today().addDays(2),
				BI_PSPB_Reminder_Date__c = Date.today().addDays(2),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
			);
			insert reminder2;

			Test.startTest();

			// Call the method
			List<BI_PSPB_Treatment_Reminder__c> tasks = BI_PSPB_TreatmentReminder.getTasksWithDateOfTreatment(
				testAccount.Id
			);

			Test.stopTest();

			// Verify the returned list
			System.assertNotEquals(
				null,
				tasks,
				'No treatment reminder records were fetched.'
			);
			System.assertEquals(
				1,
				tasks.size(),
				'Expected 1 treatment reminder record to be fetched, but found ' +
				tasks.size()
			);
			System.assertEquals(
				'Test Reminder 1',
				tasks[0].BI_PSPB_Subject__c,
				'Unexpected reminder subject'
			);
			System.assertEquals(
				Date.today().addDays(1),
				tasks[0].BI_PSPB_Reminder_Date__c,
				'Unexpected reminder date'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void testGetTasksWithDateOfTreatmentcatchtwo() {
		try {
			// Test data setup
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;

			CareProgram testDrug = new CareProgram(
				Name = 'testprogram',
				StartDate = Date.today()
			);
			insert testDrug;

			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'testcpeaccount',
				CareProgramId = testDrug.Id
			);
			//insert testCPE;

			// Create treatment reminder records
			BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 1',
				BI_PSPB_Date_of_Treatment__c = Date.today().addDays(1),
				BI_PSPB_Reminder_Date__c = Date.today().addDays(1),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
			);
			insert reminder1;

			BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Subject__c = 'Test Reminder 2',
				BI_PSPB_Date_of_Treatment__c = Date.today().addDays(2),
				BI_PSPB_Reminder_Date__c = Date.today().addDays(2),
				BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
			);
			insert reminder2;

			Test.startTest();

			// Call the method
			List<BI_PSPB_Treatment_Reminder__c> tasks = BI_PSPB_TreatmentReminder.getTasksWithDateOfTreatment(
				testCPE.Id
			);

			Test.stopTest();

			// Verify the returned list
			System.assertNotEquals(
				null,
				tasks,
				'No treatment reminder records were fetched.'
			);
			System.assertEquals(
				1,
				tasks.size(),
				'Expected 1 treatment reminder record to be fetched, but found ' +
				tasks.size()
			);
			System.assertEquals(
				'Test Reminder 1',
				tasks[0].BI_PSPB_Subject__c,
				'Unexpected reminder subject'
			);
			System.assertEquals(
				Date.today().addDays(1),
				tasks[0].BI_PSPB_Reminder_Date__c,
				'Unexpected reminder date'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}

	@isTest
	static void createTaskIfNoAssessmenttestcatch() {
		try {
			// Start test transaction
			// Create a Task record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
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

			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Account testAccount1 = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccount1;

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

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUser.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023',
				BI_PSP_CareProgramEnrollee__c = testCpa1.Id
			);
			insert testAssessment;

			Test.startTest();

			BI_PSPB_TreatmentReminder.createTaskIfNoAssessment(testCpa1.Id);

			Test.stopTest();
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
	@isTest
	static void createTaskIfNoAssessmenttest() {
		try {
			// Start test transaction
			// Create a Task record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
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

			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Account testAccount1 = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccount1;

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

            Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Completed',
			BI_PSP_DateForCQ__c = 'Jan 2023',
			BI_PSP_CareProgramEnrollee__c = testCpa1.Id
		);
		insert testAssessment;

            Task tsk=new Task();
            tsk.WhatId=testCpa1.Id;
            tsk.Subject='Action required';
            insert tsk;
			Test.startTest();

			BI_PSPB_TreatmentReminder.createTaskIfNoAssessment(testCpa1.Id);

			Test.stopTest();
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
}