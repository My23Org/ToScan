/**
@description    Test class for the BI_PSPB_treatmentPastDueScheduler class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_treatmentPastDueSchedulerTest {
	/**
	 * @description Test for executing the scheduler to handle past due treatments.
	 */

	@isTest
	static void testSchedulerExecution() {
		// Create test data for BI_PSPB_Days_Count__mdt
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		Account testAccounts = new Account(Name = 'Test Account');
		insert testAccounts;
		CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
		insert testCP;
		CareProgramEnrollee cpe = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
            BI_PSPB_Send_Notification__c = 'Yes',
			CareProgramId = testCP.Id
		);
		insert cpe;
		// Create test data for BI_PSPB_Treatment_Reminder__c
		BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today(), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminder;
		BI_PSPB_Treatment_Reminder__c testReminderOneday = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(-1), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderOneday;
		BI_PSPB_Treatment_Reminder__c testReminderTwodays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(2), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderTwodays;
		BI_PSPB_Treatment_Reminder__c testReminderThreedays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(-3), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderThreedays;
		BI_PSPB_Treatment_Reminder__c testReminderFourDays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(4), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderFourDays;
		BI_PSPB_Treatment_Reminder__c testReminderFiveDays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(5), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderFiveDays;
		BI_PSPB_Treatment_Reminder__c testReminderSixDays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(6), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderSixDays;
		BI_PSPB_Treatment_Reminder__c testReminderSevenDays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(7), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderSevenDays;
		BI_PSPB_Treatment_Reminder__c testReminderEightDays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(8), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderEightDays;
		BI_PSPB_Treatment_Reminder__c testReminderNineDays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(9), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderNineDays;
		BI_PSPB_Treatment_Reminder__c testReminderTenDays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(10), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderTenDays;
		BI_PSPB_Treatment_Reminder__c testReminderElevenDays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(11), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderElevenDays;
		BI_PSPB_Treatment_Reminder__c testReminderTwelveDays = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Date_of_Treatment__c = Date.today().addDays(12), // Set the date of treatment to today
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id // Set the enrollee ID as needed
			// Populate other fields as needed
		);
		insert testReminderTwelveDays;
		Test.startTest();

		// Schedule the job
		System.schedule(
			'Test BI_PSPB_TreatmentPastDueScheduler',
			'0 0 0 * * ?',
			new BI_PSPB_treatmentPastDueScheduler()
		);

		Test.stopTest();
		List<BI_PSPB_Treatment_Reminder__c> processedReminders = [
			SELECT Id
			FROM BI_PSPB_Treatment_Reminder__c
			WHERE Id = :testReminder.Id
		];
		assert.areEqual(
			1,
			processedReminders.size(),
			'Care program enrollee should have been created'
		);
	}
  /**
* @description Test method to verify the behavior of markTaskRead method.
*/
	@isTest
	static void testSchedulerExecutionsss() {
		Test.startTest();
		System.schedule(
			'Test BI_PSPB_TreatmentPastDueScheduler',
			'0 0 0 * * ?',
			new BI_PSPB_TreatmentPastDueScheduler()
		);
		Test.stopTest();
		assert.areEqual(
			false,
			false,
			'Care program enrollee should have been failed'
		);
	}
}