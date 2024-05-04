/*
 * @description This is a class used for sms and email send Treatment video notification.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public with sharing class BI_PSPB_TreatmentVideoNotification {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String spevigo = System.Label.BI_PSPB_spevigo;
	/**
	 * @description   Test method to validate the BI_PSP_EmailAndSMS method of the BI_PSP_TreatmentVideoNotification class.
	 */
	public static void emailAndSMS() {
		try {
            String errorMsg = '';
			//Notifications have to be sent for all enrolles, Hence we have not used LIMIT or Where consitions.
			//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
			List<CareProgramEnrollee> getEnrolleeRecord = [
				SELECT Id, AccountId
				FROM CareProgramEnrollee
				WHERE 
                //BI_PSPB_Send_Notification__c =: BI_PSPB_constantsClass.ACTION_RESPONSE_YES
				//AND 
                CareProgram.Name =: spevigo
                //Limit 100
			];
			if (getEnrolleeRecord.isEmpty()) {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_DlqiQuestionariesAN.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.errorMsgRecordNotFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			} else {
                List<Task> newTaskList = new List<Task>();
				List<Id> enrolleeIds = new List<Id>();
				for (CareProgramEnrollee cpe : getEnrolleeRecord) {
					enrolleeIds.add(cpe.Id);
                    Task newTask = new Task();
					// Create a new Task instance and set its fields
					newTask.Subject = 'Treatment subject';
					newTask.BI_PSP_Notification_Type__c = BI_PSPB_constantsClass.ACTION_TYPE_GENERAL;
					newTask.BI_PSP_Category__c = BI_PSPB_constantsClass.ACTION_TYPE_Treatment;
					newTask.BI_PSPB_Treatment_Type__c = '';
					newTask.Status = BI_PSPB_constantsClass.ACTION_TYPE_UnRead;
					newTask.WhatId = cpe.Id;
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
                // Now update the status of CareProgramEnrollee records
				// List<CareProgramEnrollee> enrolleesToUpdate = [SELECT Id, BI_PSPB_Send_Notification__c FROM CareProgramEnrollee 
                //                                                WHERE Id IN :enrolleeIds];
				// for(CareProgramEnrollee cpeToUpdate : enrolleesToUpdate) {
    			// 	cpeToUpdate.BI_PSPB_Send_Notification__c = BI_PSPB_constantsClass.ACTION_RESPONSE_NO; // Update the status as needed
				// }
                // if (!newTaskList.isEmpty()) {
				// 		Database.SaveResult[] saveResults = Database.update(
				// 			enrolleesToUpdate,
				// 			false,
				// 			AccessLevel.USER_MODE
				// 		);
				// 		for (Database.SaveResult saveResult : saveResults) {
				// 			if (!saveResult.isSuccess()) {
				// 				for (
				// 					Database.Error error : saveResult.getErrors()
				// 				) {
				// 					errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
				// 				}
				// 			}
				// 		}
				// 		if (!String.isBlank(errorMsg)) {
				// 			BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_DlqiQuestionariesAN.class.toString(),'',
				// 				System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				// 			);
				// 		}
				// 	}
				if (!enrolleeIds.isEmpty()) { BI_PSPB_smsAndEmailHandlerdemoTest.handleTrigger(
						enrolleeIds, BI_PSPB_constantsClass.video, ''
					);
					System.debug('reeeeeee '+ enrolleeIds);
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_treatmentVideoNotification.class.toString(),null,System.now()
			);
		}
	}
}