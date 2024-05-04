/*
 * @description We are using without sharing because, the task records are created by scheduled apex. 
				The status of the task is updated by patient user.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public without sharing class BI_PSPB_InsiteNotification {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String errorForThrow = System.Label.BI_PSP_ConsoleError;
	/**
	 * @description Retrieves task records related to notifications for different types of actions.
	 * Task is a not using sharing setting not allowed user mode. Hence we have not used USER_MODE.
	 * @param enroleeId The ID of the account associated with the tasks.
	 * @param notificatonType The type of notification (e.g., Action).
	 * @param category The category of the tasks (e.g., Symptom Tracker).
	 * @return A list of task records related to the specified criteria.
	 */
	@AuraEnabled(cacheable=true)
	public static List<Task> getTaskRecordAction(
		String enroleeId,
		String notificatonType,
		String category
	) {
		if (String.isBlank(enroleeId) || String.isBlank(notificatonType)) {
			throw new AuraHandledException(
				BI_PSPB_ConstantsClass.recordcannotfound
			);
		}
		List<Task> relatedTasks = new List<Task>();
		try {
			List<BI_PSPB_Treatment_Reminder__c> relatedTasksTreatmentRecords = [
				SELECT Id, Name, BI_PSPB_Care_Program_Enrollee__r.Id
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Care_Program_Enrollee__r.Id = :enroleeId
				LIMIT 1
			];
			set<id> treatmentReminderId = new Set<id>();
			for (
				BI_PSPB_Treatment_Reminder__c tr : relatedTasksTreatmentRecords
			) {
				treatmentReminderId.add(tr.Id);
			}
			if (
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
			) {
				List<Task> relatedTasksTreatment = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						CreatedDate,
						WhatId,
						OwnerId,
						BI_PSP_Category__c,
						BI_PSPB_Treatment_Type__c,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c
					FROM Task
					WHERE
						WhatId IN :treatmentReminderId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				relatedTasks.addAll(relatedTasksTreatment);
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
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				relatedTasks.addAll(relatedTasksChallenges);
			} 
            if (
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_SymptomTracker ||
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_Questionnaires
			) {
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
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND BI_PSP_Category__c = :category
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
			} 
            if (
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_Treatment
			) {
				relatedTasks = [
					SELECT
						CreatedDate,
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						OwnerId,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c,
						BI_PSPB_Treatment_Type__c,
						BI_PSP_Category__c
					FROM Task
					WHERE
						WhatId = :treatmentReminderId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
						AND (BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Treatment
						OR BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_DateOfTreatment
						OR BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Prescription)
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
			} else {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			//If this relatedTasks becomes null the error will be shown in biPspNotificationActionForm.
			return relatedTasks;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_InsiteNotification.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 *@description Retrieves task records related to general notifications based on the specified notification type.
	 * @param enroleeId The ID of the account associated with the tasks.
	 * @param notificatonType The type of notification (e.g., SymptomTracker, Challenges).
	 * @return A list of task records related to the specified notification type.
	 */
	@AuraEnabled(cacheable=true)
	public static List<Task> getTaskGeneral(
		String enroleeId,
		String notificatonType
	) {
		if (String.isBlank(enroleeId) || String.isBlank(notificatonType)) {
			throw new AuraHandledException(
				BI_PSPB_ConstantsClass.recordcannotfound
			);
		}
		string account;
		List<CareProgramEnrollee> accid = new List<CareProgramEnrollee>();
		accid = [
			SELECT id, AccountId
			FROM CareProgramEnrollee
			WHERE id = :enroleeId
			LIMIT 1
		];
		if (accid.size() > 0) {
			account = accid[0].AccountId;
		} else {
			throw new AuraHandledException(
				BI_PSPB_ConstantsClass.recordcannotfound
			);
		}

		List<Task> relatedTasks = new List<Task>();
		try {
			if (
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeGeneral
			) {
				relatedTasks = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						OwnerId,
						Priority,
						Status,
						BI_PSP_ChatterType__c,
						BI_PSP_Category__c,
						CreatedDate,
						Subject,
						BI_PSP_Notification_Type__c
					FROM Task
					WHERE
						WhatId = :enroleeId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_UnRead
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				List<Task> relatedTasksContent = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						CreatedDate,
						BI_PSP_Category__c,
						OwnerId,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c
					FROM Task
					WHERE
						WhatId = :account
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_UnRead
						AND BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeHistory
					ORDER BY CreatedDate DESC
					LIMIT 100
				];

				relatedTasks.addAll(relatedTasksContent);
			} else if (
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_SymptomTracker ||
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_Challenges ||
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_Questionnaires ||
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralCommunity
			) {
				relatedTasks = [
					SELECT
						Id,
						CreatedDate,
						WhatId,
						Status,
						Subject,
						BI_PSP_Category__c,
						Type,
						BI_PSP_Notification_Type__c
					FROM Task
					WHERE
						WhatId = :enroleeId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_UnRead
						AND BI_PSP_Category__c = :notificatonType
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
			} else if (
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralContent
			) {
				relatedTasks = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						CreatedDate,
						BI_PSP_Category__c,
						OwnerId,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c
					FROM Task
					WHERE
						WhatId = :account
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_UnRead
						AND BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralContent
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
			} else {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			//If this relatedTasks becomes null the error will be shown in biPspNotificationGeneralForm.
			return relatedTasks;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_InsiteNotification.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 *@description Retrieves task records related to historical notifications based on the specified notification type.
	 * @param enroleeId The ID of the account associated with the tasks.
	 * @param notificatonType The type of notification (e.g., NotificatonTypeGeneral, NotificatonTypeAction).
	 * @return A list of task records related to the specified notification type.
	 */
	@AuraEnabled(cacheable=true)
	public static List<Task> getTaskHistory(
		String enroleeId,
		String notificatonType
	) {
		try {
			if (String.isBlank(enroleeId) || String.isBlank(notificatonType)) {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			string account;
			List<CareProgramEnrollee> accid = new List<CareProgramEnrollee>();
			accid = [
				SELECT id, AccountId
				FROM CareProgramEnrollee
				WHERE id = :enroleeId
				LIMIT 1
			];
			if (accid.isEmpty()) {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			if (accid.size() > 0) {
				account = accid[0].AccountId;
			} else {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}

			List<Task> relatedTasks = new List<Task>();
			set<id> treatmentReminderId = new Set<id>();
			List<BI_PSPB_Treatment_Reminder__c> relatedTasksTreatmentRecords = [
				SELECT Id, Name, BI_PSPB_Care_Program_Enrollee__r.Id
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Care_Program_Enrollee__r.Id = :enroleeId
				LIMIT 1
			];
			for (
				BI_PSPB_Treatment_Reminder__c tr : relatedTasksTreatmentRecords
			) {
				treatmentReminderId.add(tr.Id);
			}
			if (
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeHistory
			) {
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
						AND (BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						OR BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action)
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeCompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeIncompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_Read
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificationTypeExpired)
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
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
						AND (BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						OR BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action)
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeCompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeIncompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_Read
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificationTypeExpired)
						AND BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralContent
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				relatedTasks.addAll(relatedTasksContent);
				relatedTasks.addAll(relatedTasksAll);
				List<Task> relatedTasksTreatment = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						CreatedDate,
						BI_PSP_Category__c,
						OwnerId,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c
					FROM Task
					WHERE
						WhatId IN :treatmentReminderId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeCompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeIncompleted)
						AND (BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Treatment
						OR BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_DateOfTreatment)
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				relatedTasks.addAll(relatedTasksTreatment);
				List<Task> relatedTasksPrescription = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						OwnerId,
						CreatedDate,
						BI_PSP_Category__c,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c
					FROM Task
					WHERE
						WhatId IN :treatmentReminderId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeCompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeIncompleted)
						AND BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Prescription
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				relatedTasks.addAll(relatedTasksPrescription);
			} else if (
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeGeneral
			) {
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
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_Read
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificationTypeExpired)
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
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
						AND (BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						OR BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action)
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_Read
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificationTypeExpired)
						AND BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralContent
					ORDER BY CreatedDate DESC
					LIMIT 100
				];

				relatedTasks.addAll(relatedTasksContent);
			} else if (
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
			) {
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
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeCompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeIncompleted)
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				List<Task> relatedTasksTreatment = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						CreatedDate,
						BI_PSP_Category__c,
						OwnerId,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c
					FROM Task
					WHERE
						WhatId IN :treatmentReminderId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeCompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeIncompleted)
						AND (BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Treatment
						OR BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_DayofTreatment)
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				relatedTasks.addAll(relatedTasksTreatment);
				List<Task> relatedTasksPrescription = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						BI_PSP_Category__c,
						OwnerId,
						CreatedDate,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c
					FROM Task
					WHERE
						WhatId IN :treatmentReminderId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeCompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeIncompleted)
						AND BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Prescription
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				relatedTasks.addAll(relatedTasksPrescription);
			} else {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			//If this relatedTasks becomes null the error will be shown in biPspNotificationHistoryForm.
			return relatedTasks;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_InsiteNotification.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 * @description Retrieves task records related to a specific category within the history section based on the specified notification type.
	 * @param enroleeId The ID of the account associated with the tasks.
	 * @param notificatonType The type of notification (e.g., SymptomTracker, Challenges).
	 * @param category The category of task records to retrieve (e.g., SymptomTracker, New Content Updates).
	 * @return A list of task records related to the specified category and notification type.
	 */
	@AuraEnabled(cacheable=true)
	public static List<Task> getTaskRecordHistoryCategory(
		String enroleeId,
		String notificatonType,
		String category
	) {
		if (String.isBlank(enroleeId) || String.isBlank(notificatonType)) {
			throw new AuraHandledException(
				BI_PSPB_ConstantsClass.recordcannotfound
			);
		}
		string account;
		List<CareProgramEnrollee> accid = new List<CareProgramEnrollee>();
		accid = [
			SELECT Id, AccountId
			FROM CareProgramEnrollee
			WHERE Id = :enroleeId
			LIMIT 1
		];
		if (accid.size() > 0) {
			account = accid[0].Id;
		} else {
			throw new AuraHandledException(
				BI_PSPB_ConstantsClass.recordcannotfound
			);
		}
		List<Task> relatedTasks = new List<Task>();
		try {
			set<id> treatmentReminderId = new Set<id>();
			List<BI_PSPB_Treatment_Reminder__c> relatedTasksTreatmentRecords = [
				SELECT Id, Name, BI_PSPB_Care_Program_Enrollee__r.Id
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Care_Program_Enrollee__r.Id = :enroleeId
				LIMIT 1
			];
			for (
				BI_PSPB_Treatment_Reminder__c tr : relatedTasksTreatmentRecords
			) {
				treatmentReminderId.add(tr.Id);
			}
			if (
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralContent &&
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeGeneral
			) {
				relatedTasks = [
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
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_Read
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificationTypeExpired)
						AND BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralContent
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
			} else if (
				(category ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralCommunity ||
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_Challenges) &&
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeGeneral
			) {
				relatedTasks = [
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
						WhatId = :enroleeId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_Read
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificationTypeExpired)
						AND BI_PSP_Category__c = :category
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
			} else if (
				(category ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_SymptomTracker ||
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_Treatment ||
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_Prescription) &&
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
			) {
				relatedTasks = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						CreatedDate,
						WhatId,
						OwnerId,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c,
						BI_PSP_Category__c
					FROM Task
					WHERE
						WhatId = :enroleeId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND BI_PSP_Category__c = :category
						AND (Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeIncompleted
						OR Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeCompleted)
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
			} else {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			//If this relatedTasks becomes null the error will be shown in biPspNotificationHistoryForm.
			return relatedTasks;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_InsiteNotification.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 * @description Retrieves task records related to a specific category within the history section based on the specified notification type and status.
	 * @param enroleeId The ID of the account associated with the tasks.
	 * @param notificatonType The type of notification (e.g., SymptomTracker, Challenges).
	 * @param category The category of task records to retrieve (e.g., SymptomTracker, New Content Updates).
	 * @param status The status of the task records to retrieve (e.g., Read, NotificationTypeExpired).
	 * @return A list of task records related to the specified category, notification type, and status.
	 */
	@AuraEnabled(cacheable=true)
	public static List<Task> getTaskRecordHistoryStatus(
		String enroleeId,
		String notificatonType,
		String category,
		String status
	) {
		try {
			if (String.isBlank(enroleeId) || String.isBlank(notificatonType)) {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			string account;
			List<CareProgramEnrollee> accid = new List<CareProgramEnrollee>();
			accid = [
				SELECT id, AccountId
				FROM CareProgramEnrollee
				WHERE id = :enroleeId
				LIMIT 1
			];
			if (accid.size() > 0) {
				account = accid[0].AccountId;
			} else {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			List<Task> relatedTasks = new List<Task>();
			set<id> treatmentReminderId = new Set<id>();
			List<BI_PSPB_Treatment_Reminder__c> relatedTasksTreatmentRecords = [
				SELECT Id, Name, BI_PSPB_Care_Program_Enrollee__r.Id
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Care_Program_Enrollee__r.Id = :enroleeId
				LIMIT 1
			];
			for (
				BI_PSPB_Treatment_Reminder__c tr : relatedTasksTreatmentRecords
			) {
				treatmentReminderId.add(tr.Id);
			}
			if (
				(category ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_SymptomTracker &&
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeGeneral) &&
				status == BI_PSPB_ConstantsClass.ACTION_TYPE_Read
			) {
				relatedTasks = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						OwnerId,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c,
						BI_PSP_Category__c,
						CreatedDate
					FROM Task
					WHERE
						WhatId = :enroleeId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						AND BI_PSP_Category__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_SymptomTracker
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_Read
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
			} else if (
				((category == BI_PSPB_ConstantsClass.ACTION_TYPE_Challenges ||
				category ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralCommunity ||
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_GeneralContent ||
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_SymptomTracker ||
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_Treatment ||
				category == BI_PSPB_ConstantsClass.ACTION_TYPE_Prescription) &&
				(notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeGeneral ||
				notificatonType ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction)) &&
				(status == BI_PSPB_ConstantsClass.ACTION_TYPE_Read ||
				status ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificationTypeExpired ||
				status ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeCompleted ||
				status ==
				BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeIncompleted)
			) {
				relatedTasks = [
					SELECT
						ActivityDate,
						Description,
						WhoId,
						WhatId,
						OwnerId,
						Priority,
						Status,
						Subject,
						Type,
						BI_PSP_Notification_Type__c,
						BI_PSP_Category__c,
						CreatedDate
					FROM Task
					WHERE
						WhatId = :enroleeId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
						AND BI_PSP_Category__c = :category
						AND Status = :status
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
			} else {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			//If this relatedTasks becomes null the error will be shown in biPspNotificationHistoryForm.
			return relatedTasks;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_InsiteNotification.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	@AuraEnabled(cacheable=true)
	public static List<Task> timeFrame(String enroleeId, String timeFrame) {
		try {
			if (String.isBlank(enroleeId) || String.isBlank(timeFrame)) {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			set<id> treatmentReminderId = new Set<id>();
			List<BI_PSPB_Treatment_Reminder__c> relatedTasksTreatmentRecords = [
				SELECT Id, Name, BI_PSPB_Care_Program_Enrollee__r.Id
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE BI_PSPB_Care_Program_Enrollee__r.Id = :enroleeId
				LIMIT 1
			];
			for (
				BI_PSPB_Treatment_Reminder__c tr : relatedTasksTreatmentRecords
			) {
				treatmentReminderId.add(tr.Id);
			}
			List<Task> relatedTasks = new List<Task>();
			if (
				timeFrame == BI_PSPB_ConstantsClass.twentyfourHours &&
				timeFrame == BI_PSPB_ConstantsClass.seventytwoHours
			) {
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
						WhatId IN :treatmentReminderId
						AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
						AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
						AND BI_PSPB_Treatment_Type__c = :timeFrame
					ORDER BY CreatedDate DESC
					LIMIT 100
				];
				relatedTasks.addAll(relatedTasksChallenges);
			} else {
				throw new AuraHandledException(
					BI_PSPB_ConstantsClass.recordcannotfound
				);
			}
			//If this relatedTasks becomes null the error will be shown in biPspNotificationActionForm.
			return relatedTasks;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_InsiteNotification.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
}