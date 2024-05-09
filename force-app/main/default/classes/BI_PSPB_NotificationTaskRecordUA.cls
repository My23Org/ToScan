/*
* @description	this class used to get the ralated task for patient.
				The tasks are created in a Schedule Apex by System Admin. 
				The Community User (patient) needs access to these tasks to view them. 
				Hence we have used without sharing.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Joyal		05-Dec-2023		Created			Initial development
* 1.1		Joyal		01-Jan-2024		Updated			Update  Database Insert 
* 1.2		Joyal		04-Apr-2024		Updated			Catch log added
*/
public without sharing class BI_PSPB_NotificationTaskRecordUA {
	public static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String newContentValue = System.Label.BI_PSPB_Newcontentupdate;
	private static String notificationError = System.Label.BI_PSPB_Error_For_Getting_Task;
	private static String errorForAccount = System.Label.BI_PSPB_Error_For_Account;
	private static String errorForThrow = System.Label.BI_PSP_ConsoleError;
	/*
	@description	This method is used to get the related task based on certain 
					parameters for patient.   
	@param			accountId (string)- this parameter store the account id. 
	@param			notificatonType (string)-this parameter store the notification type. 
	@param			category(string)-this parameter store the task category. 
	@return			list return list of task record. 
	*/
	// Method to retrieve task records based on certain parameters
	// User mode is not applicable here as the sharing rule in task objects.
	@AuraEnabled(cacheable=true)
	public static List<Task> getTaskRecordAction(
		String enroleeId,
		String notificatonType,
		String category
	) {
		List<Task> relatedTasks = new List<Task>();
		try {
			// Retrieving tasks based on notification type and category
			// The values in the category may or may not be null.Hence null check is not done.
			if (
				String.isNotBlank(enroleeId) &&
				String.isNotBlank(notificatonType)
			) {
				if (
					notificatonType ==
					BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction
				) {
					// Retrieving tasks related to notification type action
					List<Task> relatedTasksChallenges = [
						SELECT
							ActivityDate,
							Description,
							WhoId,
							CreatedDate,
							WhatId,
							BI_PSP_Category__c,
							OwnerId,
							Priority,
							Status,
							Subject,
							Type,
							BI_PSP_Notification_Type__c
						FROM Task
						WHERE
							WhatId = :enroleeId
							AND BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_Action
							AND Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction
							AND (BI_PSP_Category__c = :BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker
							OR BI_PSP_Category__c = :BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires)
						LIMIT 100
					];
					relatedTasks.addAll(relatedTasksChallenges);
				} else if (
					category ==
					BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker
				) {
					// Retrieving tasks related to symptom tracker category
					relatedTasks = [
						SELECT
							ActivityDate,
							Description,
							WhoId,
							WhatId,
							OwnerId,
							CreatedDate,
							Priority,
							Status,
							Subject,
							Type,
							BI_PSP_Notification_Type__c,
							BI_PSP_Category__c
						FROM Task
						WHERE
							WhatId = :enroleeId
							AND BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_Action
							AND BI_PSP_Category__c = :BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker
							AND Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction
						LIMIT 100
					];
				} else if (
					category ==
					BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires
				) {
					// Retrieving tasks related to questionnaires category
					relatedTasks = [
						SELECT
							ActivityDate,
							Description,
							WhoId,
							WhatId,
							OwnerId,
							CreatedDate,
							Priority,
							Status,
							Subject,
							Type,
							BI_PSP_Notification_Type__c,
							BI_PSP_Category__c
						FROM Task
						WHERE
							WhatId = :enroleeId
							AND BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_Action
							AND BI_PSP_Category__c = :BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires
							AND Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction
						LIMIT 100
					];
				}
				return relatedTasks;
			} else {
				throw new AuraHandledException(errorForThrow);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_NotificationTaskRecordUA.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorForAccount);
		}
	}
	/*
@description	Used to get the list of task record based on Notification Type.
@param			accountId(string)- this parameter store the account id.
@param			notificatonType (string)- this parameter store the
				notification type. 
@return			list -return list of task recoeds.
*/
	// Method to retrieve task history based on certain parameters
	// User mode is not applicable here as the sharing rule in task objects.
	@AuraEnabled(cacheable=true)
	public static List<Task> getTaskHistory(
		String enroleeId,
		String notificatonType
	) {
		List<Task> relatedTasks = new List<Task>();
		try {
			String account;
			if (String.isNotBlank(enroleeId) && String.isNotBlank(notificatonType)) {
				List<CareProgramEnrollee> accid = new List<CareProgramEnrollee>();
				accid = [
					SELECT Id, AccountId
					FROM CareProgramEnrollee
					WHERE Id = :enroleeId
					LIMIT 1
				];
				if (!accid.isEmpty()) {
					account = accid[0].AccountId;
				} else {
					throw new AuraHandledException(errorForAccount);
				}
				if (
					notificatonType ==
					BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeHistory &&
					String.isNotBlank(notificatonType)
				) {
					// Retrieving all tasks related to notification type history
					List<Task> relatedTasksAll = [
						SELECT
							ActivityDate,
							Description,
							WhoId,
							WhatId,
							OwnerId,
							BI_PSP_Category__c,
							Priority,
							CreatedDate,
							Status,
							Subject,
							Type,
							BI_PSP_Notification_Type__c
						FROM Task
						WHERE
							WhatId = :enroleeId
							AND (BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_GENERAL
							OR BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_Action)
							AND (Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeCompleted
							OR Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeIncompleted
							OR Status = :BI_PSPB_constantsClass.ACTION_TYPE_Read
							OR Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificationTypeExpired)
						LIMIT 100
					];
					// Retrieving tasks related to new content updates
					List<Task> relatedTasksContent = [
						SELECT
							ActivityDate,
							Description,
							WhoId,
							BI_PSP_Category__c,
							WhatId,
							CreatedDate,
							OwnerId,
							Priority,
							Status,
							Subject,
							Type,
							BI_PSP_Notification_Type__c
						FROM Task
						WHERE
							WhatId = :account
							AND (BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_GENERAL
							OR BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_Action)
							AND (Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeCompleted
							OR Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeIncompleted
							OR Status = :BI_PSPB_constantsClass.ACTION_TYPE_Read
							OR Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificationTypeExpired)
							AND BI_PSP_Category__c = :newContentValue
						LIMIT 100
					];
					relatedTasks.addAll(relatedTasksContent);
					relatedTasks.addAll(relatedTasksAll);
				} else if (
					notificatonType ==
					BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeGeneral &&
					String.isNotBlank(notificatonType)
				) {
					// Retrieving tasks related to notification type general
					relatedTasks = [
						SELECT
							ActivityDate,
							Description,
							WhoId,
							WhatId,
							OwnerId,
							Priority,
							BI_PSP_Category__c,
							Status,
							CreatedDate,
							Subject,
							Type,
							BI_PSP_Notification_Type__c
						FROM Task
						WHERE
							WhatId = :enroleeId
							AND BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_GENERAL
							AND (Status = :BI_PSPB_constantsClass.ACTION_TYPE_Read
							OR Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificationTypeExpired)
						LIMIT 100
					];
					// Retrieving tasks related to new content updates
					List<Task> relatedTasksContent = [
						SELECT
							ActivityDate,
							Description,
							WhoId,
							BI_PSP_Category__c,
							WhatId,
							CreatedDate,
							OwnerId,
							Priority,
							Status,
							Subject,
							Type,
							BI_PSP_Notification_Type__c
						FROM Task
						WHERE
							WhatId = :account
							AND (BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_GENERAL
							OR BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_Action)
							AND (Status = :BI_PSPB_constantsClass.ACTION_TYPE_Read
							OR Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificationTypeExpired)
							AND BI_PSP_Category__c = :newContentValue
						LIMIT 100
					];
					relatedTasks.addAll(relatedTasksContent);
				} else if (
					notificatonType ==
					BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction &&
					String.isNotBlank(notificatonType)
				) {
					// Retrieving tasks related to notification type action
					relatedTasks = [
						SELECT
							ActivityDate,
							Description,
							WhoId,
							WhatId,
							OwnerId,
							Priority,
							BI_PSP_Category__c,
							CreatedDate,
							Status,
							Subject,
							Type,
							BI_PSP_Notification_Type__c
						FROM Task
						WHERE
							WhatId = :enroleeId
							AND BI_PSP_Notification_Type__c = :BI_PSPB_constantsClass.ACTION_TYPE_Action
							AND (Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeCompleted
							OR Status = :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeIncompleted)
							AND (BI_PSP_Category__c = :BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker
							OR BI_PSP_Category__c = :BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires)
						LIMIT 100
					];
				}
				return relatedTasks;
			} else {
				throw new AuraHandledException(notificationError);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_NotificationTaskRecordUA.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(notificationError);
		}
	}
}