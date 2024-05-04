/**
@description    Test class for the BI_PSPB_DlqiQuestionariesAN class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_DlqiQuestionariesANTest {
	/**
	 * Test method to verify the scheduler execution.
	 */
    private static   BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
    /**
@description Test method to verify the behavior of execute method.
*/
	@isTest
	static void testSchedulerExecution() {
		// Create test data
		Account testAccount = new Account(Name = 'Test Account Test');
		insert testAccount;
		CareProgram testCP = new CareProgram(Name = 'Spevigo');
		insert testCP;
		CareProgramEnrollee cpe = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Spevigo',
            BI_PSPB_Send_Notification__c = 'Yes',
			CareProgramId = testCP.Id
		);
		insert cpe;
		Date currentDate = Date.today().addDays(-1);
		BI_PSP_Symptom_Tracker__c symptomTrackerRecord = new BI_PSP_Symptom_Tracker__c(
			Name = 'Test Symptom',
			BI_PSP_Care_Program_Enrollee__c = cpe.Id,
			BI_PSP_Are_you_currently_experiencing__c = true,
			CreatedDate = currentDate
		);
		insert symptomTrackerRecord;

		Test.startTest();
		// Call the execute method of the scheduler
		BI_PSPB_DlqiQuestionariesAN scheduler = new BI_PSPB_DlqiQuestionariesAN();
		scheduler.execute(null); // Passing null as SchedulableContext since it's not used in the code
		Test.stopTest();

		// Query for the created CareProgramEnrollee record
		List<CareProgramEnrollee> careProgramRecords = [
			SELECT Id
			FROM CareProgramEnrollee
			WHERE CareProgramId = :testCP.Id
		];

		// Assert that the scheduler executed without errors
		assert.areEqual(
			1,
			careProgramRecords.size(),
			'Care program enrollee should have been created'
		);
	}
}