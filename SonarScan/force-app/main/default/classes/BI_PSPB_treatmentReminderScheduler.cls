/*
 * @description Implements a scheduled job to process reminders for treatment reminders.
				This class calculates target dates for reminders and sends notifications accordingly.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public with sharing class BI_PSPB_treatmentReminderScheduler implements Schedulable {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**
	 *@description Implements the execute method to process treatment reminders.
	 * @param sc The context passed to the scheduled job.
	 */
	public void execute(SchedulableContext sc) {
		try {
			Integer before1DayTreatmentCount;
			Integer before3DayTreatmentCount;
			Integer before7DayTreatmentCount;
			Integer before10DayTreatmentCount;
			Integer before14DayTreatmentCount;
			String before7DayTreatmentSubject;
			String before10DayTreatmentSubject;
			String before14DayTreatmentSubject;
			String before1DayTreatmentSubject;
			String before3DayTreatmentSubject;
			String checkBefore1DayTreatment;
			String checkBefore3DayTreatment;
			String checkBefore7DayTreatment;
			String checkBefore10DayTreatment;
			String checkBefore14DayTreatment;
			String subject;
			String category;
			String errorMsg = '';
			Datetime treatmentDate;
			Date dateOnly;
			String formattedDate;
			Date today = Date.today();
			List<Task> newTaskList = new List<Task>();
			List<Id> enrolleeRecIds = new List<Id>();
			//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
			List<BI_PSPB_Treatment_Reminder__c> reminders = [
				SELECT
					BI_PSPB_Care_Program_Enrollee__c,
					BI_PSPB_Care_Program_Enrollee__r.AccountId,
					BI_PSPB_Reminder_Date__c,
					BI_PSPB_Date_of_Treatment__c
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE
					BI_PSPB_Reminder_Date__c = :today
					AND BI_PSPB_Status__c = :BI_PSPB_constantsClass.ACTION_TYPE_Active
					AND BI_PSPB_Care_Program_Enrollee__r.BI_PSPB_Send_Notification__c 
					=: BI_PSPB_constantsClass.ACTION_RESPONSE_YES
					Limit 100
			];
			if (reminders.isEmpty()) {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_DlqiQuestionariesAN.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			} else {
				BI_PSPB_Days_Count__mdt mcs = BI_PSPB_Days_Count__mdt.getInstance(
					BI_PSPB_constantsClass.daysCountofTreatment
				);
				before1DayTreatmentCount = mcs
					.BI_PSPB_GTR_1_day_before_Day_of_Treatmen__c.intValue();
				before3DayTreatmentCount = mcs
					.BI_PSPB_GTR_3_days_before_Day_of_Treatme__c.intValue();
				before7DayTreatmentCount = mcs
					.BI_PSPB_PR_7_days_before_Treatment_Day__c.intValue();
				before10DayTreatmentCount = mcs
					.BI_PSPB_PR_10_days_before_Treatment_Day__c.intValue();
				before14DayTreatmentCount = mcs
					.BI_PSPB_PR14_days_before_Treatment_Day__c.intValue();
				BI_PSPB_InsiteNotification__mdt sub = BI_PSPB_InsiteNotification__mdt.getInstance(
					BI_PSPB_constantsClass.InsiteNotificationName
				);
				before7DayTreatmentSubject = sub
					.BI_PSPB_ActionPR_7DBDT_Subject__c;
				before10DayTreatmentSubject = sub
					.BI_PSPB_ActionPR_10DBT_Subject__c;
				before14DayTreatmentSubject = sub
					.BI_PSPB_ActionPR14DBDTSubject__c;
				before1DayTreatmentSubject = sub
					.BI_PSPB_GeneralTR1DBDTSubject__c;
				before3DayTreatmentSubject = sub
					.BI_PSPB_GeneralTR3DBDTSubject__c;
				// Process reminders for accounts with SMS enabled
				for (BI_PSPB_Treatment_Reminder__c reminder : reminders) {
					Integer daysDifference = reminder.BI_PSPB_Reminder_Date__c.daysBetween(
						reminder.BI_PSPB_Date_of_Treatment__c
					);
					if (daysDifference == before1DayTreatmentCount) {
						enrolleeRecIds.add(
							reminder.BI_PSPB_Care_Program_Enrollee__c
						);
						treatmentDate = reminders[0]
							.BI_PSPB_Date_of_Treatment__c;
						dateOnly = treatmentDate.date();
						formattedDate =
							String.valueOf(dateOnly.month()).leftPad(2, '0') +
							'/' +
							String.valueOf(dateOnly.day()).leftPad(2, '0') +
							'/' +
							String.valueOf(dateOnly.year());
						before1DayTreatmentSubject = +' ' + formattedDate;
						subject = before1DayTreatmentSubject;
						category = BI_PSPB_constantsClass.ACTION_TYPE_Treatment;
						checkBefore1DayTreatment = BI_PSPB_constantsClass.tr1;
					} else if (daysDifference == before3DayTreatmentCount) {
						enrolleeRecIds.add(
							reminder.BI_PSPB_Care_Program_Enrollee__c
						);
						treatmentDate = reminders[0]
							.BI_PSPB_Date_of_Treatment__c;
						dateOnly = treatmentDate.date();
						formattedDate =
							String.valueOf(dateOnly.month()).leftPad(2, '0') +
							'/' +
							String.valueOf(dateOnly.day()).leftPad(2, '0') +
							'/' +
							String.valueOf(dateOnly.year());
						before3DayTreatmentSubject = +' ' + formattedDate;
						subject = before3DayTreatmentSubject;
						category = BI_PSPB_constantsClass.ACTION_TYPE_Treatment;
						checkBefore3DayTreatment = BI_PSPB_constantsClass.tr3;
					} else if (daysDifference == before7DayTreatmentCount) {
						enrolleeRecIds.add(
							reminder.BI_PSPB_Care_Program_Enrollee__c
						);
						subject = before7DayTreatmentSubject;
						category = BI_PSPB_constantsClass.ACTION_TYPE_Prescription;
						checkBefore7DayTreatment = BI_PSPB_constantsClass.tr7;
					} else if (daysDifference == before10DayTreatmentCount) {
						enrolleeRecIds.add(
							reminder.BI_PSPB_Care_Program_Enrollee__c
						);
						subject = before10DayTreatmentSubject;
						category = BI_PSPB_constantsClass.ACTION_TYPE_Prescription;
						checkBefore10DayTreatment = BI_PSPB_constantsClass.tr10;
					} else if (daysDifference == before14DayTreatmentCount) {
						enrolleeRecIds.add(
							reminder.BI_PSPB_Care_Program_Enrollee__c
						);
						subject = before14DayTreatmentSubject;
						category = BI_PSPB_constantsClass.ACTION_TYPE_Prescription;
						checkBefore14DayTreatment = BI_PSPB_constantsClass.tr14;
					}
					Task newTask = new Task();
					// Create a new Task instance and set its fields
					newTask.Subject = subject;
					newTask.BI_PSP_Notification_Type__c = BI_PSPB_constantsClass.ACTION_TYPE_Action;
					newTask.BI_PSP_Category__c = category;
					newTask.BI_PSPB_Treatment_Type__c = '';
					newTask.Status = BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction;
					newTask.WhatId = reminder.Id;
					newTaskList.add(newTask);
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
				// Now update the status of CareProgramEnrollee records
				List<CareProgramEnrollee> enrolleesToUpdate = [SELECT Id, BI_PSPB_Send_Notification__c 
																FROM CareProgramEnrollee 
																WHERE Id IN :enrolleeRecIds];
				for(CareProgramEnrollee cpeToUpdate : enrolleesToUpdate) {
					cpeToUpdate.BI_PSPB_Send_Notification__c = BI_PSPB_constantsClass.ACTION_RESPONSE_NO;
				}
                if (!newTaskList.isEmpty()) {
						Database.SaveResult[] saveResults = Database.update(
							enrolleesToUpdate,
							false,
							AccessLevel.USER_MODE
						);
						for (Database.SaveResult saveResult : saveResults) {
							if (!saveResult.isSuccess()) {
								for (
									Database.Error error : saveResult.getErrors()
								) {
									errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
								}
							}
						}
						if (!String.isBlank(errorMsg)) {
							BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_DlqiQuestionariesAN.class.toString(),'',
								System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
						}
					}
				if (
					!enrolleeRecIds.isEmpty() &&
					checkBefore1DayTreatment == BI_PSPB_constantsClass.tr1
				) {
					BI_PSPB_smsAndEmailHandler.handleTrigger(
						enrolleeRecIds,
						BI_PSPB_constantsClass.tr1,
						''
					);
				}
				if (
					!enrolleeRecIds.isEmpty() &&
					checkBefore3DayTreatment == BI_PSPB_constantsClass.tr3
				) {
					BI_PSPB_smsAndEmailHandler.handleTrigger(
						enrolleeRecIds,
						BI_PSPB_constantsClass.tr3,
						''
					);
				}
				if (
					!enrolleeRecIds.isEmpty() &&
					checkBefore7DayTreatment == BI_PSPB_constantsClass.tr7
				) {
					BI_PSPB_smsAndEmailHandler.handleTrigger(
						enrolleeRecIds,
						BI_PSPB_constantsClass.tr7,
						''
					);
				}
				if (
					!enrolleeRecIds.isEmpty() &&
					checkBefore10DayTreatment == BI_PSPB_constantsClass.tr10
				) {
					BI_PSPB_smsAndEmailHandler.handleTrigger(
						enrolleeRecIds,
						BI_PSPB_constantsClass.tr10,
						''
					);
				}
				if (
					!enrolleeRecIds.isEmpty() &&
					checkBefore14DayTreatment == BI_PSPB_constantsClass.tr14
				) {
					BI_PSPB_smsAndEmailHandler.handleTrigger(
						enrolleeRecIds,
						BI_PSPB_constantsClass.tr14,
						''
					);
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_treatmentReminderScheduler.class.toString(),
				null,
				System.now()
			);
		}
	}
}