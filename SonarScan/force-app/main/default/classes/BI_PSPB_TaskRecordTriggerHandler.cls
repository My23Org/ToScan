/*
 * @description Used for symptomtracker, challenges and community SMS,Email and Insite Notification.
 * History
 * Version		Date		 Author		Description
 * 59		06-01-2024		Niyas		Initial Version
 * 59		12-04-2024		Niyas		Code review changes
 */
public with sharing class BI_PSPB_TaskRecordTriggerHandler {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**
	 * @description This method is used general insite notificaton checking for send symptomtracker, challenges and
	 * community SMS,Email and Insite Notification.
	 * @param newTasks The list of Task records being inserted.
	 */
	public static void handleBeforeInsert(List<Task> newTasks) {
		try {
			String communityUserName;
			String category;
			String NotificationType;
			String ChatterType;
			List<Id> recordId = new List<Id>();
			if (!newTasks.isEmpty()) {
				Task singleTask = newTasks[0];
				recordId.add(singleTask.WhatId);
				communityUserName = singleTask.BI_PSPB_CommunityUserName__c;
				category = singleTask.BI_PSP_Category__c;
				notificationType = singleTask.BI_PSP_Notification_Type__c;
				chatterType = singleTask.BI_PSP_ChatterType__c;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> getEnrolleeRecord = [
					SELECT id, AccountId, Account.Name
					FROM CareProgramEnrollee
					WHERE id IN :recordId
					LIMIT 1
				];
				if (
					!getEnrolleeRecord.isEmpty() &&
					category ==
					BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity &&
					NotificationType ==
					BI_PSPB_constantsClass.ACTION_TYPE_GENERAL &&
					ChatterType == BI_PSPB_constantsClass.createPost
				) {
					BI_PSPB_SMSandEmailHandler.handleTrigger(
						recordId,
						BI_PSPB_constantsClass.generalCreatePost,
						communityUserName
					);
				} else if (
					!getEnrolleeRecord.isEmpty() &&
					category ==
					BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity &&
					NotificationType ==
					BI_PSPB_constantsClass.ACTION_TYPE_GENERAL &&
					ChatterType == BI_PSPB_constantsClass.comment
				) {
					BI_PSPB_SMSandEmailHandler.handleTrigger(
						recordId,
						BI_PSPB_constantsClass.generalComment,
						communityUserName
					);
				} else if (
					!getEnrolleeRecord.isEmpty() &&
					category ==
					BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity &&
					NotificationType ==
					BI_PSPB_constantsClass.ACTION_TYPE_GENERAL &&
					ChatterType == BI_PSPB_constantsClass.reaction
				) {
					BI_PSPB_SMSandEmailHandler.handleTrigger(
						recordId,
						BI_PSPB_constantsClass.generalReaction,
						communityUserName
					);
				} else if (
					!getEnrolleeRecord.isEmpty() &&
					category ==
					BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity &&
					NotificationType ==
					BI_PSPB_constantsClass.ACTION_TYPE_GENERAL &&
					ChatterType == BI_PSPB_constantsClass.follow
				) {
					BI_PSPB_SMSandEmailHandler.handleTrigger(
						recordId,
						BI_PSPB_constantsClass.generalFollow,
						communityUserName
					);
				} else if (
					!getEnrolleeRecord.isEmpty() &&
					category == BI_PSPB_constantsClass.ACTION_TYPE_Challenges &&
					NotificationType ==
					BI_PSPB_constantsClass.ACTION_TYPE_GENERAL
				) {
					BI_PSPB_smsAndEmailHandlerdemoTest.handleTrigger(
						recordId,
						BI_PSPB_constantsClass.generalChallenges,
						''
					);
				} else if (
					!getEnrolleeRecord.isEmpty() &&
					category ==
					BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker &&
					NotificationType ==
					BI_PSPB_constantsClass.ACTION_TYPE_GENERAL
				) {
					BI_PSPB_smsAndEmailHandlerdemoTest.handleTrigger(
						recordId,
						BI_PSPB_constantsClass.generalSymptomTracker,
						''
					);
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSPB_TaskRecordTriggerHandler.class.toString(),
						'',
						System.now(),
						BI_PSPB_constantsClass.errorMsgTaskRecordNotFound,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_TaskRecordTriggerHandler.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.errorMsgTaskRecordNotFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_taskRecordTriggerHandler.class.toString(),
				null,
				System.now()
			);
		}
	}
}