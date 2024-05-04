/*
 * @description Send Reminder to patients to inform QSQ questionnaire has to be filled.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public with sharing class BI_PSPB_QsqQuestionariesAN implements Schedulable {
	/**
	 * Executes the scheduled job.
	 *@description Queries symptom records, checks if enrollees are due for qualitative satisfaction
	 * questionnaires, and triggers notifications and tasks accordingly.
	 * @param ctx The context in which this scheduled job is executed.
	 */
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String spevigo = System.Label.BI_PSPB_Spevigo;
	public void execute(SchedulableContext ctx) {
		try {
			Integer qsqCount;
			String errorMsg = '';
			String subject;
			Set<Id> enrolleeIds = new Set<Id>();
			//Notifications have to be sent for all enrolles, Hence we have not used LIMIT or Where consitions.
			//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
			List<CareProgramEnrollee> getEnrolleeRecords = [
				SELECT Id, AccountId, CreatedDate
				FROM CareProgramEnrollee
				Where BI_PSPB_Send_Notification__c =: BI_PSPB_constantsClass.ACTION_RESPONSE_YES
				AND CareProgram.Name =: spevigo
				Limit 100
			];
			if (getEnrolleeRecords.isEmpty()) {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_QsqQuestionariesAN.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.errorMsgRecordNotFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			} else {
				BI_PSPB_Days_Count__mdt mcs = BI_PSPB_Days_Count__mdt.getInstance(
					BI_PSPB_constantsClass.daysCountofTreatment
				);
				qsqCount = mcs.BI_PSPB_QSQ__c.intValue();
				BI_PSPB_InsiteNotification__mdt sub = BI_PSPB_InsiteNotification__mdt.getInstance(
					BI_PSPB_constantsClass.InsiteNotificationName
				);
				subject = sub.BI_PSPB_ActionNFQ_QSQ_Subject__c;
				List<Task> newTaskList = new List<Task>();
				List<Id> enrolleeRecIds = new List<Id>();
				// Collect Enrollee Ids
				for (CareProgramEnrollee cpe : getEnrolleeRecords) {
					enrolleeIds.add(cpe.Id);
					Date enrolleeCreatedDate = cpe.CreatedDate.date();
					if (enrolleeCreatedDate == System.today().addDays(0)) {
						enrolleeRecIds.add(cpe.Id);
						Task newTask = new Task();
						// Create a new Task instance and set its fields
						newTask.Subject = subject;
						newTask.BI_PSP_Notification_Type__c = BI_PSPB_constantsClass.ACTION_TYPE_Action;
						newTask.BI_PSP_Category__c = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
						newTask.BI_PSPB_Treatment_Type__c = '';
						newTask.Status = BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction;
						newTask.WhatId = cpe.Id;
						newTaskList.add(newTask);
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
							applicationName,BI_PSPB_QsqQuestionariesAN.class.toString(),'',
							System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
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
				if (!enrolleeRecIds.isEmpty()) {
					BI_PSPB_smsAndEmailHandler.handleTrigger(
						enrolleeRecIds,
						BI_PSPB_constantsClass.qsq,
						''
					);
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_QsqQuestionariesAN.class.toString(),null,System.now()
			);
		}
	}
}