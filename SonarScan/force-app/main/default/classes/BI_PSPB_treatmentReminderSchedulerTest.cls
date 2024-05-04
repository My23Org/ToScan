/**
@description    Test class for the BI_PSPB_treatmentReminderScheduler class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@IsTest
private class BI_PSPB_treatmentReminderSchedulerTest {
	/**
	 *@description Test method to validate the scheduler functionality.
	 */
	@IsTest
	static void testScheduler() {
		// Create test data - Treatment Reminder
		Date reminderDate = Date.today();
		Date treatmentDate = Date.today().addDays(7);
		Date treatmentDateOneday = Date.today().addDays(1);
		Date treatmentDateThreedays = Date.today().addDays(3);
		Date treatmentDateTenDays = Date.today().addDays(10);
		Date treatmentDateFourDays = Date.today().addDays(14); // Assuming treatment is scheduled for 7 days from today

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
		CareProgramEnrollee cpeo = new CareProgramEnrollee(
			AccountId = testAccounts.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert cpeo;
		BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Reminder_Date__c = reminderDate,
			BI_PSPB_Date_of_Treatment__c = treatmentDate,
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id,
			BI_PSPB_Status__c = 'Active'
		);
		insert testReminder;

		BI_PSPB_Treatment_Reminder__c testReminderDay = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Reminder_Date__c = reminderDate,
			BI_PSPB_Date_of_Treatment__c = treatmentDateOneday,
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id,
			BI_PSPB_Status__c = 'Active'
		);
		insert testReminderDay;

		BI_PSPB_Treatment_Reminder__c testReminderTday = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Reminder_Date__c = reminderDate,
			BI_PSPB_Date_of_Treatment__c = treatmentDateThreedays,
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id,
			BI_PSPB_Status__c = 'Active'
		);
		insert testReminderTday;

		BI_PSPB_Treatment_Reminder__c testReminderThday = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Reminder_Date__c = reminderDate,
			BI_PSPB_Date_of_Treatment__c = treatmentDateTenDays,
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id,
			BI_PSPB_Status__c = 'Active'
		);
		insert testReminderThday;

		BI_PSPB_Treatment_Reminder__c testReminderFday = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Reminder_Date__c = reminderDate,
			BI_PSPB_Date_of_Treatment__c = treatmentDateFourDays,
			BI_PSPB_Care_Program_Enrollee__c = cpe.Id,
			BI_PSPB_Status__c = 'Active'
		);
		insert testReminderFday;

		Test.startTest();
		// Schedule the job
		System.schedule(
			'Test BI_PSPB_TreatmentReminderScheduler',
			'0 0 0 * * ?',
			new BI_PSPB_treatmentReminderScheduler()
		);

		Test.stopTest();

		// Verify the treatment reminders were processed
		List<BI_PSPB_Treatment_Reminder__c> processedReminders = [
			SELECT Id
			FROM BI_PSPB_Treatment_Reminder__c
			WHERE Id = :testReminder.Id
		];
		assert.areEqual(
			1,
			processedReminders.size(),
			'Treatment Reminder should have been created'
		);
	}
}