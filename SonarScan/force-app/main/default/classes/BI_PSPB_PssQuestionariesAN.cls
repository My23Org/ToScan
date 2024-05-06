/*
 * @description Send Reminder to patients to inform PSS questionnaire has to be filled.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public with sharing class BI_PSPB_PssQuestionariesAN implements Schedulable {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String spevigo = System.Label.BI_PSPB_Spevigo;
	/**
	 * Executes the scheduled job to send reminders for PSS surveys.
	 *@description This method queries for Care Program Enrollees who need to receive reminders and sends notifications accordingly.
	 * If an error occurs during execution, it is logged for further analysis.
	 * @param ctx The context information for the scheduled job.
	 */
	public void execute(SchedulableContext ctx) {
		try {
			String errorMsg = '';
			String subject;
			Integer pssCount;
			//Notifications have to be sent for all enrolles, Hence we have not used LIMIT or Where consitions.
			//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
			List<CareProgramEnrollee> getEnrolleeRecords = [
				SELECT Id, 
				BI_PSPB_Send_Notification__c
				FROM CareProgramEnrollee
				Where CareProgram.Name =: spevigo
			];
			if (getEnrolleeRecords.isEmpty()) {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_PssQuestionariesAN.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.errorMsgRecordNotFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			} else {
				BI_PSPB_Days_Count__mdt mcs = BI_PSPB_Days_Count__mdt.getInstance(
					BI_PSPB_constantsClass.daysCountofTreatment
				);
				pssCount = mcs.BI_PSPB_PSS__c.intValue();
				BI_PSPB_InsiteNotification__mdt sub = BI_PSPB_InsiteNotification__mdt.getInstance(
					BI_PSPB_constantsClass.InsiteNotificationName
				);
				subject = sub.BI_PSPB_ActionNFQ_PSSSubject__c;
				// Collect Enrollee Ids
				Set<Id> enrolleeIds = new Set<Id>();
				for (CareProgramEnrollee cpe : getEnrolleeRecords) {
					enrolleeIds.add(cpe.Id);
				}
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSP_Symptom_Tracker__c> getSymptomRecord = [
					SELECT
						Id,
						BI_PSP_Care_Program_Enrollee__c,
						BI_PSP_Are_you_currently_experiencing__c,
						BI_PSP_EditEntrydates__c,
						CreatedDate
					FROM BI_PSP_Symptom_Tracker__c
					WHERE BI_PSP_Care_Program_Enrollee__c IN :enrolleeIds
					ORDER BY CreatedDate ASC
				];
				if (getSymptomRecord.isEmpty()) {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_PssQuestionariesAN.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgSymptomTrackerNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				} else {
					// Query and store the latest symptom record for each enrollee
					Map<Id, BI_PSP_Symptom_Tracker__c> latestSymptomMap = new Map<Id, BI_PSP_Symptom_Tracker__c>();
					for (BI_PSP_Symptom_Tracker__c symptom : getSymptomRecord) {
						latestSymptomMap.put(
							symptom.BI_PSP_Care_Program_Enrollee__c,
							symptom
						);
					}
					List<Task> newTaskList = new List<Task>();
					List<Id> enrolleeRecIds = new List<Id>();
					// Calculate date and trigger actions
					for (
						BI_PSP_Symptom_Tracker__c latestSymptom : latestSymptomMap.values()
					) {
						if (
							latestSymptom != null &&
							latestSymptom.BI_PSP_EditEntrydates__c != null
						) {
							Date sevenDaysLaterDate = latestSymptom.BI_PSP_EditEntrydates__c.addDays(
								pssCount
							);
							if (Date.today() == sevenDaysLaterDate) {
								enrolleeRecIds.add(
									latestSymptom.BI_PSP_Care_Program_Enrollee__c
								);
								Task newTask = new Task();
								// Create a new Task instance and set its fields
								newTask.Subject = subject;
								newTask.BI_PSP_Notification_Type__c = BI_PSPB_constantsClass.ACTION_TYPE_Action;
								newTask.BI_PSP_Category__c = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
								newTask.BI_PSPB_Treatment_Type__c = '';
								newTask.Status = BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction;
								newTask.WhatId = latestSymptom.BI_PSP_Care_Program_Enrollee__c;
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
									errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
								}
							}
						}
						if (!String.isBlank(errorMsg)) {
							BI_SFCOE_LOG_Util.logMessage(
								applicationName,BI_PSPB_PssQuestionariesAN.class.toString(),'',
								System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
						}
					}
					if (!enrolleeRecIds.isEmpty()) {
						BI_PSPB_smsAndEmailHandler.handleTrigger(
							enrolleeRecIds,
							BI_PSPB_constantsClass.pss,
							''
						);
					}
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_PssQuestionariesAN.class.toString(),null,System.now()
			);
		}
	}
}