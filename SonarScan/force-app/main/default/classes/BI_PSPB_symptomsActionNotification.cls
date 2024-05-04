/*
 * @description Send Reminder to patients to inform Symptom Tracker has to be filled.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public with sharing class BI_PSPB_symptomsActionNotification implements Schedulable {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String spevigo = System.Label.BI_PSPB_Spevigo;
	/**
	 *@description  This method is called by the scheduler to execute the scheduled job.
	 * It processes symptom records for care program enrollees and triggers related actions.
	 * @param ctx The context passed to the scheduled job.
	 */
	public void execute(SchedulableContext ctx) {
		try {
			String errorMsg = '';
			String subject;
			List<Task> newTaskList = new List<Task>();
			List<Id> enrolleeRecIds = new List<Id>();
			Set<Id> enrolleeId = new Set<Id>();
			Date sevenDaysAgo = System.today().addDays(-7);
			BI_PSPB_InsiteNotification__mdt sub = BI_PSPB_InsiteNotification__mdt.getInstance(
				BI_PSPB_constantsClass.InsiteNotificationName
			);
			subject = sub.BI_PSPB_ActionARSTNSubject__c;
			//Notifications have to be sent for all enrolles, Hence we have not used LIMIT or Where consitions.
			//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
			List<CareProgramEnrollee> cpdRec = [
				SELECT Id, AccountId
				FROM CareProgramEnrollee
				Where BI_PSPB_Send_Notification__c =: BI_PSPB_constantsClass.ACTION_RESPONSE_YES
				AND CareProgram.Name =: spevigo
				Limit 100
			];
			if (cpdRec.isEmpty()) {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_DlqiQuestionariesAN.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.errorMsgRecordNotFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			} else {
				for (CareProgramEnrollee cpe : cpdRec) {
					enrolleeId.add(cpe.Id);
				}
				//Notifications have to be sent for all enrolles, Hence we have not used LIMIT or Where consitions.
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSP_Symptom_Tracker__c> symptomTrackers = [
					SELECT
						Id,
						BI_PSP_Care_Program_Enrollee__c,
						BI_PSP_Care_Program_Enrollee__r.AccountId,
						BI_PSP_Are_you_currently_experiencing__c,
						BI_PSP_EditEntrydates__c,
						CreatedDate
					FROM BI_PSP_Symptom_Tracker__c
					WHERE
						BI_PSP_Care_Program_Enrollee__c IN :enrolleeId
						AND BI_PSP_Are_you_currently_experiencing__c = TRUE
						AND BI_PSP_EditEntrydates__c >= :sevenDaysAgo
					ORDER BY BI_PSP_EditEntrydates__c ASC
				];
				if (symptomTrackers.isEmpty()) {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_DlqiQuestionariesAN.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgSymptomTrackerNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				} else {
					Map<Id, List<BI_PSP_Symptom_Tracker__c>> enrolleeSymptomTrackers = new Map<Id, List<BI_PSP_Symptom_Tracker__c>>();
					for (BI_PSP_Symptom_Tracker__c st : symptomTrackers) {
						if (
							!enrolleeSymptomTrackers.containsKey(
								st.BI_PSP_Care_Program_Enrollee__c
							)
						) {
							enrolleeSymptomTrackers.put(
								st.BI_PSP_Care_Program_Enrollee__c,
								new List<BI_PSP_Symptom_Tracker__c>()
							);
							enrolleeRecIds.add(
								st.BI_PSP_Care_Program_Enrollee__c
							);
							Task newTask = new Task();
							// Create a new Task instance and set its fields
							newTask.Subject = subject;
							newTask.BI_PSP_Notification_Type__c = BI_PSPB_constantsClass.ACTION_TYPE_Action;
							newTask.BI_PSP_Category__c = BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker;
							newTask.BI_PSPB_Treatment_Type__c = '';
							newTask.Status = BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction;
							newTask.WhatId = st.BI_PSP_Care_Program_Enrollee__c;
							newTaskList.add(newTask);
						}
						enrolleeSymptomTrackers.get(
								st.BI_PSP_Care_Program_Enrollee__c
							)
							.add(st);
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
								applicationName,BI_PSPB_symptomsActionNotification.class.toString(),'',
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
				update enrolleesToUpdate;
					if (!enrolleeRecIds.isEmpty()) {
						BI_PSPB_smsAndEmailHandler.handleTrigger(
							enrolleeRecIds,
							BI_PSPB_constantsClass.wpai,
							''
						);
					}
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_symptomsActionNotification.class.toString(),null,System.now()
			);
		}
	}
}