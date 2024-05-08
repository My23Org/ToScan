/* @description Test class ensures correct retrieval of patient notifications, accommodating health cloud package constraints by using Care Program Enrolle Object and bypassing user mode restrictions with "without sharing".*/
@isTest
private class BI_PSPB_BellIconCountTest {
		@isTest
	static void testGetTaskCount() {
		// Test data setup
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		CareProgram testdrug = new CareProgram(
			Name = 'testprogram',
			StartDate = Date.Today()
		);
		insert testdrug;
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'testcpeaccount',
			CareProgramId = testdrug.Id
		);
		insert testCPE;

		Task testTasks = new Task(
			Subject = 'Test Task 1',
			WhatId = testCPE.Id,
			Status = 'Unread'
		);
		insert testTasks;

		Task testTaskC = new Task(
			Subject = 'Test Task 2',
			WhatId = testCPE.Id,
			Status = 'Action Required'
		);
		insert testTaskC;

		BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
			//Name = 'Test Reminder',
			BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
		);
		insert testReminder;

		Task testTaskSub = new Task(
			Subject = 'Test Task 3',
			WhatId = testReminder.Id,
			Status = 'Unread'
		);
		insert testTaskSub;

		Task testTaskRe = new Task(
			Subject = 'Test Task 4',
			WhatId = testReminder.Id,
			Status = 'Action Required'
		);
		insert testTaskRe;

		Test.startTest();

		// Call the method to test
		Integer result = BI_PSPB_BellIconCount.getTaskCount(testCPE.Id);

		Test.stopTest();

		// Verify the result
		Integer expectedCount = 4; // Both CPE-related and reminder-related tasks
		Assert.areEqual(
			expectedCount,
			result,
			'Task count should match expected value'
		);
	}
	/* @description Test class method validates the method for fetching the number of notifications for a patient, incorporating CareProgramEnrollee objects and ensuring proper handling of exceptions.*/
	@isTest
	static void testGetTaskCountcatch() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		CareProgram testdrug = new CareProgram(
			Name = 'testprogram',
			StartDate = Date.Today()
		);
		insert testdrug;
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'testcpeaccount',
			CareProgramId = testdrug.Id
		);
		insert testCPE;

		Task testTasks = new Task(
			Subject = 'Test Task 1',
			WhatId = testCPE.Id,
			Status = 'Unread'
		);
		insert testTasks;

		Task testTaskC = new Task(
			Subject = 'Test Task 2',
			WhatId = testCPE.Id,
			Status = 'Action Required'
		);
		insert testTaskC;

		BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
			//Name = 'Test Reminder',
			BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
		);
		insert testReminder;

		Task testTaskSub = new Task(
			Subject = 'Test Task 3',
			WhatId = testReminder.Id,
			Status = 'Unread'
		);
		insert testTaskSub;

		Task testTaskRe = new Task(
			Subject = 'Test Task 4',
			WhatId = testReminder.Id,
			Status = 'Action Required'
		);
		insert testTaskRe;
		try {
			Test.startTest();

			// Call the method to test
			Integer result = BI_PSPB_BellIconCount.getTaskCount(null);

			Test.stopTest();

			// Verify the result
			
			Assert.areEqual(
				NULL,
				result,
				'Task count should match expected value'
			);
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	/* @description
	 Test class verifies the method for fetching the number of notifications for a patient, ensuring accurate counting of unread and action-required tasks for the Care Program Enrollee.*/
	@isTest
	static void testGetTaskCountUA() {
		// Create test data
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		CareProgram testdrug = new CareProgram(
			Name = 'testprogram',
			StartDate = Date.Today()
		);
		insert testdrug;
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'testcpeaccount',
			CareProgramId = testdrug.Id
		);
		insert testCPE;

		Task testTasks = new Task(WhatId = testCPE.Id, Status = 'Unread');
		Task testTaskC = new Task(
			WhatId = testCPE.Id,
			Status = 'Action Required'
		);
		Task testTaskSub = new Task(WhatId = testCPE.Id, Status = 'Completed'); // This should not be counted
		insert new List<Task>{ testTasks, testTaskC, testTaskSub };

		// Call the method to be tested
		Test.startTest();
		Integer result = BI_PSPB_BellIconCount.getTaskCountUA(testCPE.Id);
		Test.stopTest();

		// Assert the result
		Assert.areEqual(2, result, 'Task count should be 2');
	}
	/* @description Test class validates the method for fetching the number of notifications for a patient, including a negative scenario to handle exceptions gracefully.*/
	@isTest
	static void testGetTaskCountUANegativeScenario() {
		// Create test data
		 

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		

		//  Mock an exception by passing an invalid AccountId
		try {
			Test.startTest();

			  BI_PSPB_BellIconCount.getTaskCountUA('0');

			Test.stopTest();
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
    /**
 * @description	Test method to verify behavior when AccountId is blank.
 */
    @isTest
    static void testGetTaskCountWithBlankAccountId() {
        // Test setup
        // Insert necessary test data
        CareProgramEnrollee testCPE = new CareProgramEnrollee(AccountId = null); // Blank accountId

        // Call the method with a blank accountId
        Test.startTest();
        Integer result = BI_PSPB_BellIconCount.getTaskCountUA(testCPE.Id);
        Test.stopTest();

        // Assert the result
        Assert.areEqual(null, result, 'Task count should be null for blank accountId');
    }
    
}