/**
@description    Test class for testing the execution of the BI_PSPB_NotificationTaskRecrod.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_InsiteNotificationTest {
	/**
@description Test method to verify the behavior of getTaskGeneral method.
*/
	@isTest
	static void testGetGeneralNotificationRecord() {
		// Create test data
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		Account testAccount1 = new Account(Name = 'Test Account');
		insert testAccount1;
		CareProgram testCP = new CareProgram(Name = 'Test Care Program');
		insert testCP;
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert testCPE;
		CareProgramEnrollee testCPE1 = new CareProgramEnrollee(
			AccountId = testAccount1.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert testCPE1;
		BI_PSPB_Treatment_Reminder__c testTreatmentReminder = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
		);
		insert testTreatmentReminder;

		Task testTask = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask;

		Task testTask1 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Category__c = 'Symptom Tracker',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask1;

		Task testTask122 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Category__c = 'Symptom Tracker',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask122;

		Task testTask2 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask2;

		Task testTask3 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask3;

		Task testTask4 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask4;

		Task testTask11 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask12 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		Task testTask13 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{ testTask11, testTask12, testTask13 };

		Task testTask21 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask22 = new Task(
			WhatId = testCPE.Id,
			Status = 'Incompleted',
			BI_PSP_Notification_Type__c = 'General'
		);
		Task testTask23 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask24 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask25 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert new List<Task>{
			testTask21,
			testTask22,
			testTask23,
			testTask24,
			testTask25
		};

		Task testTask31 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Challenges'
		);
		Task testTask32 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Symptom Tracker'
		);
		Task testTask33 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask35 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Treatment',
			BI_PSPB_Treatment_Type__c = 'Past Due Date'
		);
		Task testTask36 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Prescription'
		);
		Task testTask38 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{
			testTask31,
			testTask32,
			testTask33,
			testTask35,
			testTask36,
			testTask38
		};

		Task testTask41 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Challenges'
		);
		Task testTask42 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Symptom Tracker'
		);
		Task testTask43 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask45 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Treatment',
			BI_PSPB_Treatment_Type__c = 'Past Due Date2'
		);
		Task testTask46 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Incompleted',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Prescription'
		);
		Task testTask47 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask48 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{
			testTask41,
			testTask42,
			testTask43,
			testTask45,
			testTask46,
			testTask47,
			testTask48
		};

		Task testTask51 = new Task(
			ActivityDate = Date.today().addDays(-1),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Treatment'
		);
		Task testTask52 = new Task(
			ActivityDate = Date.today().addDays(-2),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Date of Treatment'
		);
		Task testTask53 = new Task(
			ActivityDate = Date.today().addDays(-3),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Treatment'
		);
		insert new List<Task>{ testTask51, testTask52, testTask53 };

		Task testTask54 = new Task(
			ActivityDate = Date.today().addDays(-1),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Treatment'
		);
		Task testTask55 = new Task(
			ActivityDate = Date.today().addDays(-2),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Date of Treatment'
		);
		Task testTask56 = new Task(
			ActivityDate = Date.today().addDays(-3),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Prescription'
		);
		insert new List<Task>{ testTask54, testTask55, testTask56 };

		try {
			// Call the method to test General Notification
			List<Task> resultTasks1 = BI_PSPB_InsiteNotification.getTaskGeneral(
				testCPE.Id,
				'General Notification'
			);
			BI_PSPB_InsiteNotification.getTaskGeneral(
				testCPE.Id,
				'Symptom Tracker'
			);
			BI_PSPB_InsiteNotification.getTaskGeneral(testCPE.Id, 'Challenges');
			BI_PSPB_InsiteNotification.getTaskGeneral(
				testCPE.Id,
				'New Content Updates'
			);
			BI_PSPB_InsiteNotification.getTaskGeneral(
				testCPE.Id,
				'My Questionnaires'
			);
			BI_PSPB_InsiteNotification.getTaskGeneral(testCPE.Id, 'Community');

			// Action Notification
			BI_PSPB_InsiteNotification.getTaskRecordAction(
				testCPE.Id,
				'Action required',
				'Symptom Tracker'
			);
			BI_PSPB_InsiteNotification.getTaskRecordAction(
				testCPE.Id,
				'',
				'Symptom Tracker'
			);
			BI_PSPB_InsiteNotification.getTaskRecordAction(
				testTreatmentReminder.Id,
				'',
				'Treatment'
			);
			BI_PSPB_InsiteNotification.getTaskRecordAction(
				testCPE.Id,
				'',
				'My Questionnaires'
			);
			BI_PSPB_InsiteNotification.getTaskRecordAction(
				testTreatmentReminder.Id,
				'',
				'Prescription'
			);

			// History Notification
			BI_PSPB_InsiteNotification.getTaskHistory(testCPE.Id, 'History');
			BI_PSPB_InsiteNotification.getTaskHistory(
				testCPE.Id,
				'General Notification'
			);
			BI_PSPB_InsiteNotification.getTaskHistory(
				testCPE.Id,
				'Action required'
			);

			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'Community'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'Challenges'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'My Questionnaires'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'New Content Updates'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'Action required',
				'Symptom Tracker'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'Action required',
				'Treatment'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'Action required',
				'Prescription'
			);

			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Community',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Community',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Challenges',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Challenges',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'New Content Updates',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'New Content Updates',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker',
				'Completed'
			);

			BI_PSPB_InsiteNotification.timeFrame(testCPE.Id, '24hr');
			BI_PSPB_InsiteNotification.timeFrame(testCPE.Id, '72hr');
			List<Task> taskRecord = [
				SELECT Id
				FROM Task
				WHERE Id = :resultTasks1[0].Id
			];
			assert.areEqual(
				1,
				taskRecord.size(),
				'Task should have been created'
			);
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of getTaskHistory method.
*/
	@isTest
	static void testGetHistoryNotificationRecord() {
		// Create test data
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		Account testAccount1 = new Account(Name = 'Test Account');
		insert testAccount1;
		CareProgram testCP = new CareProgram(Name = 'Test Care Program');
		insert testCP;
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert testCPE;
		CareProgramEnrollee testCPE1 = new CareProgramEnrollee(
			AccountId = testAccount1.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert testCPE1;
		BI_PSPB_Treatment_Reminder__c testTreatmentReminder = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
		);
		insert testTreatmentReminder;

		Task testTask = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask;

		Task testTask1 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Category__c = 'Symptom Tracker',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask1;

		Task testTask122 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Category__c = 'Symptom Tracker',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask122;

		Task testTask2 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask2;

		Task testTask3 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask3;

		Task testTask4 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask4;

		Task testTask11 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask12 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		Task testTask13 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{ testTask11, testTask12, testTask13 };

		Task testTask21 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask22 = new Task(
			WhatId = testCPE.Id,
			Status = 'Incompleted',
			BI_PSP_Notification_Type__c = 'General'
		);
		Task testTask23 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask24 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask25 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert new List<Task>{
			testTask21,
			testTask22,
			testTask23,
			testTask24,
			testTask25
		};

		Task testTask31 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Challenges'
		);
		Task testTask32 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Symptom Tracker'
		);
		Task testTask33 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask35 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Treatment',
			BI_PSPB_Treatment_Type__c = 'Past Due Date'
		);
		Task testTask36 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Prescription'
		);
		Task testTask38 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{
			testTask31,
			testTask32,
			testTask33,
			testTask35,
			testTask36,
			testTask38
		};

		Task testTask41 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Challenges'
		);
		Task testTask42 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Symptom Tracker'
		);
		Task testTask43 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask45 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Treatment',
			BI_PSPB_Treatment_Type__c = 'Past Due Date2'
		);
		Task testTask46 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Incompleted',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Prescription'
		);
		Task testTask47 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask48 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{
			testTask41,
			testTask42,
			testTask43,
			testTask45,
			testTask46,
			testTask47,
			testTask48
		};

		Task testTask51 = new Task(
			ActivityDate = Date.today().addDays(-1),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Treatment'
		);
		Task testTask52 = new Task(
			ActivityDate = Date.today().addDays(-2),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Date of Treatment'
		);
		Task testTask53 = new Task(
			ActivityDate = Date.today().addDays(-3),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Treatment'
		);
		insert new List<Task>{ testTask51, testTask52, testTask53 };

		Task testTask54 = new Task(
			ActivityDate = Date.today().addDays(-1),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Treatment'
		);
		Task testTask55 = new Task(
			ActivityDate = Date.today().addDays(-2),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Date of Treatment'
		);
		Task testTask56 = new Task(
			ActivityDate = Date.today().addDays(-3),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Prescription'
		);
		insert new List<Task>{ testTask54, testTask55, testTask56 };

		try {
			// History Notification
			List<Task> resultTasks12 = BI_PSPB_InsiteNotification.getTaskHistory(
				testCPE.Id,
				'History'
			);
			BI_PSPB_InsiteNotification.getTaskHistory(
				testCPE.Id,
				'General Notification'
			);
			BI_PSPB_InsiteNotification.getTaskHistory(
				testCPE.Id,
				'Action required'
			);

			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'Community'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'Challenges'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'My Questionnaires'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'General Notification',
				'New Content Updates'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'Action required',
				'Symptom Tracker'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'Action required',
				'Treatment'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory(
				testCPE.Id,
				'Action required',
				'Prescription'
			);

			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Community',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Community',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Challenges',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Challenges',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'New Content Updates',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'New Content Updates',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker',
				'Completed'
			);
			List<Task> taskRecord = [
				SELECT Id
				FROM Task
				WHERE Id = :resultTasks12[0].Id
			];
			assert.areEqual(
				1,
				taskRecord.size(),
				'Task Caregiver should have been created'
			);
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of getTaskRecordHistoryStatus method.
*/
	@isTest
	static void testGetPastdueActionNotificationRecord() {
		// Create test data
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		Account testAccount1 = new Account(Name = 'Test Account');
		insert testAccount1;
		CareProgram testCP = new CareProgram(Name = 'Test Care Program');
		insert testCP;
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert testCPE;
		CareProgramEnrollee testCPE1 = new CareProgramEnrollee(
			AccountId = testAccount1.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert testCPE1;
		BI_PSPB_Treatment_Reminder__c testTreatmentReminder = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
		);
		insert testTreatmentReminder;

		Task testTask = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask;

		Task testTask1 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Category__c = 'Symptom Tracker',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask1;

		Task testTask122 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Category__c = 'Symptom Tracker',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask122;

		Task testTask2 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask2;

		Task testTask3 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask3;

		Task testTask4 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask4;

		Task testTask11 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask12 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		Task testTask13 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{ testTask11, testTask12, testTask13 };

		Task testTask21 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask22 = new Task(
			WhatId = testCPE.Id,
			Status = 'Incompleted',
			BI_PSP_Notification_Type__c = 'General'
		);
		Task testTask23 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask24 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask25 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert new List<Task>{
			testTask21,
			testTask22,
			testTask23,
			testTask24,
			testTask25
		};

		Task testTask31 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Challenges'
		);
		Task testTask32 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Symptom Tracker'
		);
		Task testTask33 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask35 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Treatment',
			BI_PSPB_Treatment_Type__c = 'Past Due Date'
		);
		Task testTask36 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Prescription'
		);
		Task testTask38 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{
			testTask31,
			testTask32,
			testTask33,
			testTask35,
			testTask36,
			testTask38
		};

		Task testTask41 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Challenges'
		);
		Task testTask42 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Symptom Tracker'
		);
		Task testTask43 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask45 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Treatment',
			BI_PSPB_Treatment_Type__c = 'Past Due Date2'
		);
		Task testTask46 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Incompleted',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Prescription'
		);
		Task testTask47 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask48 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{
			testTask41,
			testTask42,
			testTask43,
			testTask45,
			testTask46,
			testTask47,
			testTask48
		};

		Task testTask51 = new Task(
			ActivityDate = Date.today().addDays(-1),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Treatment'
		);
		Task testTask52 = new Task(
			ActivityDate = Date.today().addDays(-2),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Date of Treatment'
		);
		Task testTask53 = new Task(
			ActivityDate = Date.today().addDays(-3),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Treatment'
		);
		insert new List<Task>{ testTask51, testTask52, testTask53 };

		Task testTask54 = new Task(
			ActivityDate = Date.today().addDays(-1),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Treatment'
		);
		Task testTask55 = new Task(
			ActivityDate = Date.today().addDays(-2),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Date of Treatment'
		);
		Task testTask56 = new Task(
			ActivityDate = Date.today().addDays(-3),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Prescription'
		);
		insert new List<Task>{ testTask54, testTask55, testTask56 };

		try {
			List<Task> resultTasks23 = BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Community',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Community',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Challenges',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Challenges',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'New Content Updates',
				'Read'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'New Content Updates',
				'Expired'
			);
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				testCPE.Id,
				'General Notification',
				'Symptom Tracker',
				'Completed'
			);
			List<Task> taskRecord = [
				SELECT Id
				FROM Task
				WHERE Id = :resultTasks23[0].Id
			];
			assert.areEqual(
				1,
				taskRecord.size(),
				'Task Caregiver should have been created'
			);
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of timeFrame method.
*/
	@isTest
	static void testGetActionNotificationRecord() {
		// Create test data
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		Account testAccount1 = new Account(Name = 'Test Account');
		insert testAccount1;
		CareProgram testCP = new CareProgram(Name = 'Test Care Program');
		insert testCP;
		CareProgramEnrollee testCPE = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert testCPE;
		CareProgramEnrollee testCPE1 = new CareProgramEnrollee(
			AccountId = testAccount1.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCP.Id
		);
		insert testCPE1;
		BI_PSPB_Treatment_Reminder__c testTreatmentReminder = new BI_PSPB_Treatment_Reminder__c(
			BI_PSPB_Care_Program_Enrollee__c = testCPE.Id
		);
		insert testTreatmentReminder;

		Task testTask = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask;

		Task testTask1 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Category__c = 'Symptom Tracker',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask1;

		Task testTask122 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Category__c = 'Symptom Tracker',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask122;

		Task testTask2 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask2;

		Task testTask3 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		insert testTask3;

		Task testTask4 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert testTask4;

		Task testTask11 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask12 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General'
		);
		Task testTask13 = new Task(
			WhatId = testCPE.Id,
			Status = 'Unread',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{ testTask11, testTask12, testTask13 };

		Task testTask21 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask22 = new Task(
			WhatId = testCPE.Id,
			Status = 'Incompleted',
			BI_PSP_Notification_Type__c = 'General'
		);
		Task testTask23 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask24 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask25 = new Task(
			WhatId = testCPE.Id,
			Status = 'Completed',
			BI_PSP_Notification_Type__c = 'Action'
		);
		insert new List<Task>{
			testTask21,
			testTask22,
			testTask23,
			testTask24,
			testTask25
		};

		Task testTask31 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Challenges'
		);
		Task testTask32 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Symptom Tracker'
		);
		Task testTask33 = new Task(
			WhatId = testCPE.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask35 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Treatment',
			BI_PSPB_Treatment_Type__c = 'Past Due Date'
		);
		Task testTask36 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Read',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Prescription'
		);
		Task testTask38 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{
			testTask31,
			testTask32,
			testTask33,
			testTask35,
			testTask36,
			testTask38
		};

		Task testTask41 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Challenges'
		);
		Task testTask42 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Symptom Tracker'
		);
		Task testTask43 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'Community'
		);
		Task testTask45 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Action required',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Treatment',
			BI_PSPB_Treatment_Type__c = 'Past Due Date2'
		);
		Task testTask46 = new Task(
			WhatId = testTreatmentReminder.Id,
			Status = 'Incompleted',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Prescription'
		);
		Task testTask47 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'General',
			BI_PSP_Category__c = 'New Content Updates'
		);
		Task testTask48 = new Task(
			WhatId = testCPE.Id,
			Status = 'Expired',
			BI_PSP_Notification_Type__c = 'Action',
			BI_PSP_Category__c = 'Community'
		);
		insert new List<Task>{
			testTask41,
			testTask42,
			testTask43,
			testTask45,
			testTask46,
			testTask47,
			testTask48
		};

		Task testTask51 = new Task(
			ActivityDate = Date.today().addDays(-1),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Treatment'
		);
		Task testTask52 = new Task(
			ActivityDate = Date.today().addDays(-2),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Date of Treatment'
		);
		Task testTask53 = new Task(
			ActivityDate = Date.today().addDays(-3),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Action required',
			BI_PSP_Category__c = 'Treatment'
		);
		insert new List<Task>{ testTask51, testTask52, testTask53 };

		Task testTask54 = new Task(
			ActivityDate = Date.today().addDays(-1),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Treatment'
		);
		Task testTask55 = new Task(
			ActivityDate = Date.today().addDays(-2),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Date of Treatment'
		);
		Task testTask56 = new Task(
			ActivityDate = Date.today().addDays(-3),
			WhatId = testTreatmentReminder.Id,
			BI_PSP_Notification_Type__c = 'Action',
			Status = 'Completed',
			BI_PSP_Category__c = 'Prescription'
		);
		insert new List<Task>{ testTask54, testTask55, testTask56 };

		try {
			List<Task> resultTasks31 = BI_PSPB_InsiteNotification.timeFrame(
				testCPE.Id,
				'24hr'
			);
			BI_PSPB_InsiteNotification.timeFrame(testCPE.Id, '72hr');
			List<Task> taskRecord = [
				SELECT Id
				FROM Task
				WHERE Id = :resultTasks31[0].Id
			];
			assert.areEqual(
				1,
				taskRecord.size(),
				'Task should have been created'
			);
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of getTaskHistory and
getTaskRecordHistoryStatus method with invalid input.
*/
	@isTest
	static void getCatchDraft() {
		try {
			Test.startTest();
			BI_PSPB_InsiteNotification.getTaskHistory('', '');
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				'',
				'',
				'',
				''
			);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of getTaskGeneral method
with invalid input.
*/
	@isTest
	static void getCatchGeneralPara() {
		try {
			Test.startTest();
			BI_PSPB_InsiteNotification.getTaskGeneral('', '');
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of timeFrame method
with invalid input.
*/
	@isTest
	static void getCatchDrafttime() {
		try {
			Test.startTest();
			BI_PSPB_InsiteNotification.timeFrame('', '');
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of getTaskRecordHistoryStatus method
with invalid input.
*/
	@isTest
	static void getCatchDrafttimewww() {
		try {
			Test.startTest();
			BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus(
				'',
				'',
				'',
				''
			);
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