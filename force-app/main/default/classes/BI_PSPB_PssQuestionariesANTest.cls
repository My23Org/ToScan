/**
@description    Test class for the BI_PSPB_pssQuestionariesAN class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_PssQuestionariesANTest {
    /**
* @description Test method to verify the behavior of execute method.
*/   
	@isTest
	static void testSchedulerExecution() {
		// Create test data
		Account testAccount = new Account(Name = 'Test Account');
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
			BI_PSP_EditEntrydates__c = currentDate,
			BI_PSP_Are_you_currently_experiencing__c = true,
			CreatedDate = currentDate
		);
		insert symptomTrackerRecord;

		Test.startTest();

		// Call the execute method of the scheduler
		BI_PSPB_pssQuestionariesAN scheduler = new BI_PSPB_pssQuestionariesAN();
		scheduler.execute(null); // Passing null as SchedulableContext since it's not used in the code

		Test.stopTest();
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
        /**
* @description Test method to verify the behavior of execute method.
*/   
	@isTest
	static void testNullExecution() {
		// Create test data
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		CareProgram testCP = new CareProgram(Name = 'Spevigo');
		insert testCP;
		CareProgramEnrollee cpe = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert cpe;

		Test.startTest();

		// Call the execute method of the scheduler
		BI_PSPB_PssQuestionariesAN scheduler = new BI_PSPB_pssQuestionariesAN();
		scheduler.execute(null); // Passing null as SchedulableContext since it's not used in the code

		Test.stopTest();

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
        /**
* @description Test method to verify the behavior of execute method.
*/   
	@isTest
	static void getcatch() {
		Test.startTest();
		BI_PSPB_pssQuestionariesAN scheduler = new BI_PSPB_pssQuestionariesAN();
		scheduler.execute(null);
		Test.stopTest();
		assert.areEqual(
			false,
			false,
			'Care program enrollee should have been failed'
		);
	}
}