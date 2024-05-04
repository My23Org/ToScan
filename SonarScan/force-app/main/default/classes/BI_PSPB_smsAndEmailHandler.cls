/*
 * @description This class used for filter the SMS and Email notification for patient or caregiver.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public with sharing class BI_PSPB_smsAndEmailHandler {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**
	 * @description checking sms and email templates.
	 * @param recordId The recordId of the enrollee.
	 * @param notificationTypes The notificationTypes of the notification type.
	 * @param communityUserName The communityUserName of the community username.
	 */
	public static void handleTrigger(
		List<Id> recordId,
		String notificationTypes,
		String communityUserName
	) {
		if (recordId.isEmpty() || String.isBlank(notificationTypes)) {
			BI_SFCOE_LOG_Util.logMessage(
				applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
				BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
		}
		String enroid;
		String accID;
		String notificationSubject;
		String emailSubject;
		String bDestUrl;
		String uDestUrl;
		String urlPage;
		Datetime treatmentDate;
		Date dateOnly;
		String notificationType;
		String userType;
		String url;
		String followName;
		String formattedDate;
		try {
			BI_PSPB_Notification__mdt filteredNotifications = BI_PSPB_Notification__mdt.getInstance(
				BI_PSPB_constantsClass.siteUrl
			);
			bDestUrl = filteredNotifications.BI_PSPB_BrandedUrl__c;
			uDestUrl = filteredNotifications.BI_PSPB_UnAssignedUrl__c;
			//General Notification
			if (
				NotificationTypes ==
				BI_PSPB_constantsClass.generalSymptomTracker
			) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalChallengesSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalChallengesEmail
				);
				urlPage = BI_PSPB_constantsClass.urlSymptomTracker;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> symptomId = [
					SELECT id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId Limit 1
				];
				if (!symptomId.isEmpty()) {
					enroid = symptomId[0].Id;
					accID = symptomId[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker;
                } else{
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (
				NotificationTypes == BI_PSPB_constantsClass.generalChallenges
			) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalChallengesSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalChallengesEmail
				);
				urlPage = BI_PSPB_constantsClass.urlChallenges;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> symptomId = [
					SELECT id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId Limit 1
				];
				if (!symptomId.isEmpty()) {
					enroid = symptomId[0].Id;
					accID = symptomId[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Challenges;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.video) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalVideoSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalVideoEmail
				);
				urlPage = BI_PSPB_constantsClass.urlArticle;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> symptomId = [
					SELECT id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId
					LIMIT 1
				];
				if (!symptomId.isEmpty()) {
					enroid = symptomId[0].Id;
					accID = symptomId[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralContent;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.article) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalVideoSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalVideoEmail
				);
				urlPage = BI_PSPB_constantsClass.urlArticle;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> symptomId = [
					SELECT id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId Limit 1
				];
				if (!symptomId.isEmpty()) {
					enroid = symptomId[0].Id;
					accID = symptomId[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralContent;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.createPost) {
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalPostEmail
				);
				urlPage = BI_PSPB_constantsClass.urlAllPost;
				emailSubject = notificationsEmail.developername;
				followName = communityUserName;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> symptomId = [
					SELECT id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId Limit 1
				];
				if (!symptomId.isEmpty()) {
					enroid = symptomId[0].Id;
					accID = symptomId[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.comment) {
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalCommentEmail
				);
				urlPage = BI_PSPB_constantsClass.urlMyPost;
				emailSubject = notificationsEmail.developername;
				followName = communityUserName;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> symptomId = [
					SELECT id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId Limit 1
				];
				if (!symptomId.isEmpty()) {
					enroid = symptomId[0].Id;
					accID = symptomId[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.reaction) {
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalReactionEmail
				);
				urlPage = BI_PSPB_constantsClass.urlMyPost;
				emailSubject = notificationsEmail.developername;
				followName = communityUserName;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> symptomId = [
					SELECT id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId Limit 1
				];
				if (!symptomId.isEmpty()) {
					enroid = symptomId[0].Id;
					accID = symptomId[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.follow) {
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalFollowEmail
				);
				urlPage = BI_PSPB_constantsClass.urlFollower;
				emailSubject = notificationsEmail.developername;
				followName = communityUserName;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> symptomId = [
					SELECT id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId Limit 1
				];
				if (!symptomId.isEmpty()) {
					enroid = symptomId[0].Id;
					accID = symptomId[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			}
			//Action Notification
			else if (
				NotificationTypes == BI_PSPB_constantsClass.actionSymptomTracker
			) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionSymptomSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionSymptomEmail
				);
				urlPage = BI_PSPB_constantsClass.urlSymptomTracker;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker;
				List<BI_PSP_Symptom_Tracker__c> symptomId = [
					SELECT
						id,
						BI_PSP_Care_Program_Enrollee__r.AccountId,
						BI_PSP_Care_Program_Enrollee__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE id = :recordId
					ORDER BY CreatedDate ASC
					LIMIT 1
				];
				if (!symptomId.isEmpty()) {
					enroid = symptomId[0].BI_PSP_Care_Program_Enrollee__c;
					accID = symptomId[0]
						.BI_PSP_Care_Program_Enrollee__r.AccountId;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.tr1) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT3Sms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT3Email
				);
				urlPage = BI_PSPB_constantsClass.urlDashboard;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSPB_Treatment_Reminder__c> reminders = [
					SELECT
						BI_PSPB_Care_Program_Enrollee__c,
						BI_PSPB_Care_Program_Enrollee__r.AccountId,
						BI_PSPB_Reminder_Date__c,
						BI_PSPB_Date_of_Treatment__c
					FROM BI_PSPB_Treatment_Reminder__c
					WHERE BI_PSPB_Care_Program_Enrollee__c = :recordId
					Limit 1
				];
				if (!reminders.isEmpty()) {
					treatmentDate = reminders[0].BI_PSPB_Date_of_Treatment__c;
					dateOnly = treatmentDate.date();
					formattedDate =String.valueOf(dateOnly.month()).leftPad(2, '0') +'/' +
						String.valueOf(dateOnly.day()).leftPad(2, '0') +'/' +
						String.valueOf(dateOnly.year());
					enroid = reminders[0].BI_PSPB_Care_Program_Enrollee__c;
					accID = reminders[0]
						.BI_PSPB_Care_Program_Enrollee__r.AccountId;
					notificationType = BI_PSPB_constantsClass.treatmentandRx;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.tr3) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT3Sms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT3Email
				);
				urlPage = BI_PSPB_constantsClass.urlDashboard;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSPB_Treatment_Reminder__c> reminders = [
					SELECT
						BI_PSPB_Care_Program_Enrollee__c,
						BI_PSPB_Care_Program_Enrollee__r.AccountId,
						BI_PSPB_Reminder_Date__c,
						BI_PSPB_Date_of_Treatment__c
					FROM BI_PSPB_Treatment_Reminder__c
					WHERE id = :recordId Limit 1
				];
				if (!reminders.isEmpty()) {
					treatmentDate = reminders[0].BI_PSPB_Date_of_Treatment__c;
					dateOnly = treatmentDate.date();
					formattedDate =String.valueOf(dateOnly.month()).leftPad(2, '0') +'/' +
						String.valueOf(dateOnly.day()).leftPad(2, '0') +'/' +
						String.valueOf(dateOnly.year());
					enroid = reminders[0].BI_PSPB_Care_Program_Enrollee__c;
					accID = reminders[0]
						.BI_PSPB_Care_Program_Enrollee__r.AccountId;
					notificationType = BI_PSPB_constantsClass.treatmentandRx;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSPB_smsAndEmailHandler.class.toString(),
						'',
						System.now(),
						BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.tr7) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT7Sms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT7Email
				);
				urlPage = BI_PSPB_constantsClass.urlDashboard;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSPB_Treatment_Reminder__c> reminders = [
					SELECT
						BI_PSPB_Care_Program_Enrollee__c,
						BI_PSPB_Care_Program_Enrollee__r.AccountId,
						BI_PSPB_Reminder_Date__c,
						BI_PSPB_Date_of_Treatment__c
					FROM BI_PSPB_Treatment_Reminder__c
					WHERE BI_PSPB_Care_Program_Enrollee__c = :recordId
					Limit 1
				];
				if (!reminders.isEmpty()) {
					treatmentDate = reminders[0].BI_PSPB_Date_of_Treatment__c;
					dateOnly = treatmentDate.date();
					formattedDate =
						String.valueOf(dateOnly.month()).leftPad(2, '0') +
						'/' +
						String.valueOf(dateOnly.day()).leftPad(2, '0') +
						'/' +
						String.valueOf(dateOnly.year());
					enroid = reminders[0].BI_PSPB_Care_Program_Enrollee__c;
					accID = reminders[0]
						.BI_PSPB_Care_Program_Enrollee__r.AccountId;
					notificationType = BI_PSPB_constantsClass.treatmentandRx;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.tr10) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT10Sms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT10Email
				);
				urlPage = BI_PSPB_constantsClass.urlDashboard;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSPB_Treatment_Reminder__c> reminders = [
					SELECT
						BI_PSPB_Care_Program_Enrollee__c,
						BI_PSPB_Care_Program_Enrollee__r.AccountId,
						BI_PSPB_Reminder_Date__c,
						BI_PSPB_Date_of_Treatment__c
					FROM BI_PSPB_Treatment_Reminder__c
					WHERE BI_PSPB_Care_Program_Enrollee__c = :recordId
					Limit 1
				];
				if (!reminders.isEmpty()) {
					treatmentDate = reminders[0].BI_PSPB_Date_of_Treatment__c;
					dateOnly = treatmentDate.date();
					formattedDate =
						String.valueOf(dateOnly.month()).leftPad(2, '0') +
						'/' +
						String.valueOf(dateOnly.day()).leftPad(2, '0') +
						'/' +
						String.valueOf(dateOnly.year());
					enroid = reminders[0].BI_PSPB_Care_Program_Enrollee__c;
					accID = reminders[0]
						.BI_PSPB_Care_Program_Enrollee__r.AccountId;
					notificationType = BI_PSPB_constantsClass.treatmentandRx;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.tr14) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT14Sms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT14Email
				);
				urlPage = BI_PSPB_constantsClass.urlDashboard;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSPB_Treatment_Reminder__c> reminders = [
					SELECT
						BI_PSPB_Care_Program_Enrollee__c,
						BI_PSPB_Care_Program_Enrollee__r.AccountId,
						BI_PSPB_Reminder_Date__c,
						BI_PSPB_Date_of_Treatment__c
					FROM BI_PSPB_Treatment_Reminder__c
					WHERE BI_PSPB_Care_Program_Enrollee__c = :recordId
					Limit 1
				];
				if (!reminders.isEmpty()) {
					treatmentDate = reminders[0].BI_PSPB_Date_of_Treatment__c;
					dateOnly = treatmentDate.date();
					formattedDate =
						String.valueOf(dateOnly.month()).leftPad(2, '0') +
						'/' +
						String.valueOf(dateOnly.day()).leftPad(2, '0') +
						'/' +
						String.valueOf(dateOnly.year());
					enroid = reminders[0].BI_PSPB_Care_Program_Enrollee__c;
					accID = reminders[0]
						.BI_PSPB_Care_Program_Enrollee__r.AccountId;
					notificationType = BI_PSPB_constantsClass.treatmentandRx;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.pd0) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionPdSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionPdEmail
				);
				urlPage = BI_PSPB_constantsClass.urlDashboard;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSPB_Treatment_Reminder__c> reminders = [
					SELECT
						BI_PSPB_Care_Program_Enrollee__c,
						BI_PSPB_Care_Program_Enrollee__r.AccountId,
						BI_PSPB_Reminder_Date__c,
						BI_PSPB_Date_of_Treatment__c
					FROM BI_PSPB_Treatment_Reminder__c
					WHERE BI_PSPB_Care_Program_Enrollee__c = :recordId
					Limit 1
				];
				if (!reminders.isEmpty()) {
					treatmentDate = reminders[0].BI_PSPB_Date_of_Treatment__c;
					enroid = reminders[0].BI_PSPB_Care_Program_Enrollee__c;
					accID = reminders[0]
						.BI_PSPB_Care_Program_Enrollee__r.AccountId;
					notificationType = BI_PSPB_constantsClass.treatmentandRx;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.pd1) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionPd1Sms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionPd1Email
				);
				urlPage = BI_PSPB_constantsClass.urlDashboard;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSPB_Treatment_Reminder__c> reminders = [
					SELECT
						BI_PSPB_Care_Program_Enrollee__c,
						BI_PSPB_Care_Program_Enrollee__r.AccountId,
						BI_PSPB_Reminder_Date__c,
						BI_PSPB_Date_of_Treatment__c
					FROM BI_PSPB_Treatment_Reminder__c
					WHERE BI_PSPB_Care_Program_Enrollee__c = :recordId
					Limit 1
				];
				if (!reminders.isEmpty()) {
					treatmentDate = reminders[0].BI_PSPB_Date_of_Treatment__c;
					enroid = reminders[0].BI_PSPB_Care_Program_Enrollee__c;
					accID = reminders[0]
						.BI_PSPB_Care_Program_Enrollee__r.AccountId;
					notificationType = BI_PSPB_constantsClass.treatmentandRx;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.pd3) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionPd3Sms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionPd3Email
				);
				urlPage = BI_PSPB_constantsClass.urlDashboard;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
				List<BI_PSPB_Treatment_Reminder__c> reminders = [
					SELECT
						BI_PSPB_Care_Program_Enrollee__c,
						BI_PSPB_Care_Program_Enrollee__r.AccountId,
						BI_PSPB_Reminder_Date__c,
						BI_PSPB_Date_of_Treatment__c
					FROM BI_PSPB_Treatment_Reminder__c
					WHERE BI_PSPB_Care_Program_Enrollee__c = :recordId
					Limit 1
				];
				if (!reminders.isEmpty()) {
					treatmentDate = reminders[0].BI_PSPB_Date_of_Treatment__c;
					enroid = reminders[0].BI_PSPB_Care_Program_Enrollee__c;
					accID = reminders[0]
						.BI_PSPB_Care_Program_Enrollee__r.AccountId;
					notificationType = BI_PSPB_constantsClass.treatmentandRx;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgTreatmentRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.dlqi) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionDlqiSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionDlqiEmail
				);
				urlPage = BI_PSPB_constantsClass.urlQuestionnaires;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> enrolleeRecord = [
					SELECT Id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId
					Limit 1
				];
				if (!enrolleeRecord.isEmpty()) {
					enroid = enrolleeRecord[0].Id;
					accID = enrolleeRecord[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.pss) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionPssSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionPssEmail
				);
				urlPage = BI_PSPB_constantsClass.urlQuestionnaires;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> enrolleeRecord = [
					SELECT Id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId
					Limit 1
				];
				if (!enrolleeRecord.isEmpty()) {
					enroid = enrolleeRecord[0].Id;
					accID = enrolleeRecord[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.wpai) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionWpaiSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionWpaiEmail
				);
				urlPage = BI_PSPB_constantsClass.urlQuestionnaires;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> enrolleRecord = [
					SELECT Id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId
					Limit 1
				];
				if (!enrolleRecord.isEmpty()) {
					enroid = enrolleRecord[0].Id;
					accID = enrolleRecord[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else if (NotificationTypes == BI_PSPB_constantsClass.qsq) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionQsqSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionQsqEmail
				);
				urlPage = BI_PSPB_constantsClass.urlQuestionnaires;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
				List<CareProgramEnrollee> enrolleRecord = [
					SELECT Id, AccountId
					FROM CareProgramEnrollee
					WHERE id = :recordId
					Limit 1
				];
				if (!enrolleRecord.isEmpty()) {
					enroid = enrolleRecord[0].Id;
					accID = enrolleRecord[0].AccountId;
					notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
					BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			Account accountRecord;
			//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
			BI_PSPB_Enrollee_Caregiver__c enrolleeCaregiverRec;
			List<BI_PSP_Notification_Setting__c> settings = [
				SELECT
					Id,
					BI_PSP_Patient__c,
					BI_PSP_SMS__c,
					BI_PSP_Email__c,
					BI_PSP_Notification_Type__c
				FROM BI_PSP_Notification_Setting__c
				WHERE
					BI_PSP_Patient__c = :accID
					AND BI_PSP_Notification_Type__c = :NotificationType
				LIMIT 1
			];
			if (!settings.isEmpty()) {
				BI_PSP_Notification_Setting__c setting = settings[0];
				accountRecord = [
					SELECT Id, PersonContactId, BI_PSP_Birthdate__c
					FROM Account
					WHERE Id = :accID
					Limit 1
				];
				List<Id> contactIds = new List<Id>();
				if (accountRecord != null) {
					// Access fields directly from the accRecord variable
					Id personContactId = accountRecord.PersonContactId;
					Date birthdate = accountRecord.BI_PSP_Birthdate__c;
					if (birthdate != null) {
						// Calculate age based on birthdate
						Integer age = Date.today().year() - birthdate.year();
						//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
						CareProgramEnrollee enrolleeUserType = [
							SELECT id, AccountId, BI_PSPB_PatientStatus__c
							FROM CareProgramEnrollee
							WHERE id = :enroid
							Limit 1
						];
						if (enrolleeUserType == null) {
							BI_SFCOE_LOG_Util.logMessage(
								applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
								BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
						}
						UserType = enrolleeUserType.BI_PSPB_PatientStatus__c;
						if (userType == BI_PSPB_constantsClass.Unassigned) {
							url = uDestUrl + urlPage;
						} else {
							url = bDestUrl + urlPage;
						}
						if (age < 18) {
							String fName;
							String lName;
							//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
							enrolleeCaregiverRec = [
								SELECT
									Id,
									BI_PSPB_Contact_Id__c,
									BI_PSPB_Contact_Id__r.FirstName,
									BI_PSPB_Contact_Id__r.LastName
								FROM BI_PSPB_Enrollee_Caregiver__c
								WHERE BI_PSPB_Care_Program_Enrollee__c = :enroid
								Limit 1
							];
							if (enrolleeCaregiverRec != null) {
								fName = enrolleeCaregiverRec.BI_PSPB_Contact_Id__r.FirstName;
								lName = enrolleeCaregiverRec.BI_PSPB_Contact_Id__r.LastName;
								accountRecord = [
									SELECT
										Id,
										PersonContactId,
										BI_PSP_Birthdate__c
									FROM Account
									WHERE
										FirstName = :fName
										AND LastName = :lName
									LIMIT 1
								];
								if (accountRecord != null) {
									contactIds.add(
										accountRecord.PersonContactId
									);
									if (setting.BI_PSP_SMS__c == true) {
										BI_PSPB_AsynchronousSmsCallout.sendSMS(
											contactIds,
											notificationSubject,
											url,
											formattedDate
										);
									}
									if (setting.BI_PSP_Email__c == true) {
										BI_PSPB_AsynchronousEmailCallout.sendEmail(
											contactIds,
											emailSubject,
											url,
											formattedDate,
											followName
										);
									}
								} else {
									BI_SFCOE_LOG_Util.logMessage(
										applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
										BI_PSPB_constantsClass.errorMsgAccountRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
									);
								}
							} else {
								BI_SFCOE_LOG_Util.logMessage(
									applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
									BI_PSPB_constantsClass.errorMsgEnorlleeCaregiverRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
								);
							}
						} else if (age > 18) {
							accountRecord = [
								SELECT Id, PersonContactId, BI_PSP_Birthdate__c
								FROM Account
								WHERE Id = :accID
								LIMIT 1
							];
							if (accountRecord == null) {
								BI_SFCOE_LOG_Util.logMessage(
									applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
									BI_PSPB_constantsClass.errorMsgRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
								);
							}
							contactIds.add(accountRecord.PersonContactId);
							if (setting.BI_PSP_SMS__c == true) {
								BI_PSPB_AsynchronousSmsCallout.sendSMS(
									contactIds,
									notificationSubject,
									url,
									formattedDate
								);
							}
							if (setting.BI_PSP_Email__c == true) {
								BI_PSPB_AsynchronousEmailCallout.sendEmail(
									contactIds,
									emailSubject,
									url,
									formattedDate,
									followName
								);
							}
						}
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_smsAndEmailHandler.class.toString(),'',System.now(),
						BI_PSPB_constantsClass.errorMsgAccountRecordNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_smsAndEmailHandler.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.errorMsgNotificationSettingNotFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_InsiteNotification.class.toString(),
				null,
				System.now()
			);
		}
		return;
	}
}