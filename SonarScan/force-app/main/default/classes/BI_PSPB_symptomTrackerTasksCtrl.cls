/*
 * @description We are using without sharing and can't use User_Mode because, the task records are created by scheduled apex. 
				The status of the task updated by patient user.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public without sharing class BI_PSPB_symptomTrackerTasksCtrl {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**
	 *@description This method changes the status of General notification.
	 *Task to Read after patient views the notification.
	 * @param taskId The Id of the Task to mark as read.
	 */
	@AuraEnabled
	public static List<Task> markTaskRead(String taskId) {
		try {
			String errorMsg = '';
			if (String.isBlank(taskId)) {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgTaskIdNotFound
				); // Return null if leadId is blank
			}
			List<Task> tasksToUpdate = new List<Task>();
			tasksToUpdate = [
				SELECT
					Id,
					Status,
					BI_PSP_Category__c,
					BI_PSP_ChatterType__c,
					BI_PSP_ChatterFeedId__c
				FROM Task
				WHERE
					Id = :taskId
					AND Status != :BI_PSPB_constantsClass.ACTION_TYPE_Read
				LIMIT 1
			];
			if (!tasksToUpdate.isEmpty()) {
				for (Task taskToUpdate : tasksToUpdate) {
					taskToUpdate.Status = BI_PSPB_constantsClass.ACTION_TYPE_Read;
				}
				Database.SaveResult[] saveResults = Database.update(
					tasksToUpdate,
					false
				);
				for (Database.SaveResult saveResult : saveResults) {
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
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
						BI_PSPB_symptomTrackerTasksCtrl.class.toString(),
						'',
						System.now(),
						errorMsg,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
					throw new AuraHandledException(
						BI_PSPB_constantsClass.errorMsgInsert
					);
				}
			} else {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgTaskRecordNotFound
				);
			}
			if (tasksToUpdate != null) {
				return tasksToUpdate;
			} else {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.recordcannotfound
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_symptomTrackerTasksCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 *@description This method changes the status of Action notification Task to Complete.
	 *after patient takes action on the notification.
	 *@param taskId The Id of the Task to mark as completed.
	 */
	@AuraEnabled
	public static List<Task> markTaskCompleted(String taskId) {
		try {
			String errorMsg = '';
			if (String.isBlank(taskId)) {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgTaskIdNotFound
				); // Return null if leadId is blank
			}
			List<Task> tasksToUpdate = new List<Task>();
			tasksToUpdate = [
				SELECT Id, Status, BI_PSP_Category__c
				FROM Task
				WHERE
					Id = :taskId
					AND Status != :BI_PSPB_constantsClass.NOTIFICATION_STATUS_complete
				LIMIT 1
			];

			if (!tasksToUpdate.isEmpty()) {
				for (Task taskToUpdate : tasksToUpdate) {
					taskToUpdate.Status = BI_PSPB_constantsClass.NOTIFICATION_STATUS_complete;
				}
				Database.SaveResult[] saveResults = Database.update(
					tasksToUpdate,
					false
					
				);
				for (Database.SaveResult saveResult : saveResults) {
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
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
						BI_PSPB_symptomTrackerTasksCtrl.class.toString(),
						'',
						System.now(),
						errorMsg,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
					throw new AuraHandledException(
						BI_PSPB_constantsClass.errorMsgUpdate
					);
				}
			} else {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgTaskRecordNotFound
				);
			}
			if (tasksToUpdate != null) {
				return tasksToUpdate;
			} else {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.recordcannotfound
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_symptomTrackerTasksCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
}