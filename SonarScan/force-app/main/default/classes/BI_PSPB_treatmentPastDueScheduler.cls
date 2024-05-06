/*
* @description Implements a scheduled job to process reminders for treatment past due.
				This class calculates target dates for reminders and sends notifications accordingly.
* History
* Version	Author			Date		Detail		Description
* 59		Niyas		06-01-2024		Created		Initial Version
* 59		Niyas		18-04-2024		Updated		Code review changes
*/
public with sharing class BI_PSPB_treatmentPastDueScheduler implements Schedulable {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**
	 *@description Executes the scheduled job to process treatment past due reminders.
	 * This method calculates target dates for reminders and sends notifications to enrollees accordingly.
	 * If an error occurs during execution, it is logged for further analysis.
	 * @param sc The context information for the scheduled job.
	 */
	public void execute(SchedulableContext sc) {
		try {
			Integer[] intervals = new List<Integer>{ 0, -1, -3 }; // 0 for today, 1 for 24 hours, 3 for 72 hours
			Set<Date> targetDates = new Set<Date>();
			List<Id> enrolleeRecIds = new List<Id>();
			String subject;
			String category;
			String treatmentType;
			String errorMsg = '';
			String checkDateofTreatment;
			String checkpastdue24hrCount;
			String checkpastdue72hrCount;
			Integer pastdue24hrCount;
			Integer pastdue72hrCount;
			String dateOfTreatmentSubject;
			String pastdue24hrSubject;
			String pastdue72hrSubject;
			Integer daysDiff;
			List<Task> newTaskList = new List<Task>();
			// Calculate target dates based on the intervals
			for (Integer interval : intervals) {
				targetDates.add(Date.today().addDays(interval));
			}
			BI_PSPB_Days_Count__mdt mcs = BI_PSPB_Days_Count__mdt.getInstance(
				BI_PSPB_constantsClass.daysCountofTreatment
			);
			pastdue24hrCount = mcs.BI_PSPB_TR_Past_Due_24_hours__c.intValue();
			pastdue72hrCount = mcs.BI_PSB_TR_Past_Due_72_hours__c.intValue();
			BI_PSPB_InsiteNotification__mdt sub = BI_PSPB_InsiteNotification__mdt.getInstance(
				BI_PSPB_constantsClass.InsiteNotificationName
			);
			dateOfTreatmentSubject = sub
				.BI_PSPB_ActionTRDayofTreatmentSubject__c;
			pastdue24hrSubject = sub.BI_PSPB_ActionTRPastDue24HSubject__c;
			pastdue72hrSubject = sub.BI_PSPB_ActionTRPastDue72HSubject__c;
			//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
			List<BI_PSPB_Treatment_Reminder__c> getTreatmentRecords = [
				SELECT
					BI_PSPB_Care_Program_Enrollee__c,
					BI_PSPB_Date_of_Treatment__c
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Date_of_Treatment__c IN :targetDates
			];
			if (getTreatmentRecords.isEmpty()) {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_DlqiQuestionariesAN.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			} else {
				// Query Treatment Reminders where the Date of Treatment matches the target dates
				Map<Date, List<BI_PSPB_Treatment_Reminder__c>> remindersByDate = new Map<Date, List<BI_PSPB_Treatment_Reminder__c>>();
				for (
					BI_PSPB_Treatment_Reminder__c reminder : getTreatmentRecords
				) {
					if (
						!remindersByDate.containsKey(
							reminder.BI_PSPB_Date_of_Treatment__c
						)
					) {
						remindersByDate.put(
							reminder.BI_PSPB_Date_of_Treatment__c,
							new List<BI_PSPB_Treatment_Reminder__c>()
						);
					}
					remindersByDate.get(reminder.BI_PSPB_Date_of_Treatment__c)
						.add(reminder);
				}
				// Process reminders for each target date
				for (Date targetDate : targetDates) {
					if (remindersByDate.containsKey(targetDate)) {
						for (
							BI_PSPB_Treatment_Reminder__c reminder : remindersByDate.get(
								targetDate
							)
						) {
							daysDiff = targetDate.daysBetween(Date.today());
							if (daysDiff == 0) {
								enrolleeRecIds.add(
									reminder.BI_PSPB_Care_Program_Enrollee__c
								);
								subject = dateOfTreatmentSubject;
								category = BI_PSPB_constantsClass.dateOfTreatment;
								treatmentType = BI_PSPB_constantsClass.dayOfTreatment;
								checkDateofTreatment = BI_PSPB_constantsClass.pd0;
							} else if (daysDiff == pastdue24hrCount) {
								enrolleeRecIds.add(
									reminder.BI_PSPB_Care_Program_Enrollee__c
								);
								subject = dateOfTreatmentSubject;
								category = BI_PSPB_constantsClass.dateOfTreatment;
								treatmentType = BI_PSPB_constantsClass.pastDueDate;
								checkpastdue24hrCount = BI_PSPB_constantsClass.pd1;
							} else if (daysDiff == pastdue72hrCount) {
								enrolleeRecIds.add(
									reminder.BI_PSPB_Care_Program_Enrollee__c
								);
								subject = dateOfTreatmentSubject;
								category = BI_PSPB_constantsClass.dateOfTreatment;
								treatmentType = BI_PSPB_constantsClass.pastDueDate;
								checkpastdue72hrCount = BI_PSPB_constantsClass.pd3;
							}
							Task newTask = new Task();
							// Create a new Task instance and set its fields
							newTask.Subject = subject;
							newTask.BI_PSP_Notification_Type__c = BI_PSPB_constantsClass.ACTION_TYPE_Action;
							newTask.BI_PSP_Category__c = category;
							newTask.BI_PSPB_Treatment_Type__c = treatmentType;
							newTask.Status = BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction;
							newTask.WhatId = reminder.Id;
							newTaskList.add(newTask);
						}
					}
				}
				if (!newTaskList.isEmpty()) {
					Database.SaveResult[] saveResults = Database.insert(
						newTaskList,
						false,
						AccessLevel.USER_MODE
					);
					for (Database.SaveResult saveResult : saveResults) {
						if (!saveResult.isSuccess()) {
							for (
								Database.Error error : saveResult.getErrors()
							) {
								errorMsg +=
									'Error ' +
									error.getFields() +
									'--' +
									error.getMessage() +
									'\n';
							}
						}
					}
					if (!String.isBlank(errorMsg)) {
						BI_SFCOE_LOG_Util.logMessage(
							applicationName,
							BI_PSPB_DlqiQuestionariesAN.class.toString(),
							'',
							System.now(),
							errorMsg,
							BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
						);
					}
				}
				if (
					!enrolleeRecIds.isEmpty() &&
					checkDateofTreatment == BI_PSPB_constantsClass.pd0
				) {
					BI_PSPB_smsAndEmailHandler.handleTrigger(
						enrolleeRecIds,
						BI_PSPB_constantsClass.pd0,
						''
					);
				}
				if (
					!enrolleeRecIds.isEmpty() &&
					checkpastdue24hrCount == BI_PSPB_constantsClass.pd1
				) {
					BI_PSPB_smsAndEmailHandler.handleTrigger(
						enrolleeRecIds,
						BI_PSPB_constantsClass.pd1,
						''
					);
				}
				if (
					!enrolleeRecIds.isEmpty() &&
					checkpastdue72hrCount == BI_PSPB_constantsClass.pd3
				) {
					BI_PSPB_smsAndEmailHandler.handleTrigger(
						enrolleeRecIds,
						BI_PSPB_constantsClass.pd3,
						''
					);
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_treatmentPastDueScheduler.class.toString(),
				null,
				System.now()
			);
		}
	}
}