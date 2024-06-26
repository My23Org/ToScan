/*
 * @description This class used for filter the SMS and Email notification for patient or caregiver.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 * 59		Niyas		08-05-2024		Updated		Code review changes
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
				applicationName,
				BI_PSPB_smsAndEmailHandler.class.toString(),
				'',
				System.now(),
				BI_PSPB_constantsClass.errorMsgRecordNotFound,
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
		}
		String notificationSubject;
		String emailSubject;
		String bDestUrl = '';
		String uDestUrl;
		String urlPage;
		String notificationType;
		String userType;
		String url = '';
		String followName = '';
		String formattedDate = '';
		List<Id> contactIdsToSendSMS = new List<Id>();
		List<Id> contactIdsToSendEmail = new List<Id>();
		List<Id> enrolIds = new List<Id>();
		List<Id> accountRec = new List<Id>();
		List<Id> notificationCare = new List<Id>();
		List<Id> notificationCareAcc = new List<Id>();
		try {
			BI_PSPB_Notification__mdt filteredNotifications = BI_PSPB_Notification__mdt.getInstance(
				BI_PSPB_constantsClass.siteUrl
			);
			url = filteredNotifications.BI_PSPB_BrandedUrl__c;
			uDestUrl = filteredNotifications.BI_PSPB_UnAssignedUrl__c;
			//General Notification
			if (
				NotificationTypes ==
				BI_PSPB_constantsClass.generalSymptomTracker
			) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalSymptomSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalSymptomEmail
				);
				urlPage = BI_PSPB_constantsClass.urlSymptomTracker;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker;
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
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Challenges;
			} else if (NotificationTypes == BI_PSPB_constantsClass.video || NotificationTypes == BI_PSPB_constantsClass.article) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalVideoSms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalVideoEmail
				);
				urlPage = BI_PSPB_constantsClass.urlArticle;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralContent;
			} else if (NotificationTypes == BI_PSPB_constantsClass.generalCreatePost) {
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalPostEmail
				);
				urlPage = BI_PSPB_constantsClass.urlAllPost;
				emailSubject = notificationsEmail.developername;
				followName = communityUserName;
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity;
			} else if (NotificationTypes == BI_PSPB_constantsClass.generalComment) {
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalCommentEmail
				);
				urlPage = BI_PSPB_constantsClass.urlMyPost;
				emailSubject = notificationsEmail.developername;
				followName = communityUserName;
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity;
			} else if (NotificationTypes == BI_PSPB_constantsClass.generalReaction) {
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalReactionEmail
				);
				urlPage = BI_PSPB_constantsClass.urlMyPost;
				emailSubject = notificationsEmail.developername;
				followName = communityUserName;
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity;
			} else if (NotificationTypes == BI_PSPB_constantsClass.generalFollow) {
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.generalFollowEmail
				);
				urlPage = BI_PSPB_constantsClass.urlFollower;
				emailSubject = notificationsEmail.developername;
				followName = communityUserName;
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_GeneralCommunity;
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
			} else if (NotificationTypes == BI_PSPB_constantsClass.tr1) {
				BI_PSPB_Notification__mdt notificationSms = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT1Sms
				);
				BI_PSPB_Notification__mdt notificationsEmail = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_constantsClass.actionT1Email
				);
				urlPage = BI_PSPB_constantsClass.urlDashboard;
				notificationSubject = notificationSms.developername;
				emailSubject = notificationsEmail.developername;
				notificationType = BI_PSPB_constantsClass.treatmentandRx;
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
				notificationType = BI_PSPB_constantsClass.treatmentandRx;
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
				notificationType = BI_PSPB_constantsClass.treatmentandRx;
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
				notificationType = BI_PSPB_constantsClass.treatmentandRx;
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
				notificationType = BI_PSPB_constantsClass.treatmentandRx;
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
				notificationType = BI_PSPB_constantsClass.treatmentandRx;
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
				notificationType = BI_PSPB_constantsClass.treatmentandRx;
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
				notificationType = BI_PSPB_constantsClass.treatmentandRx;
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
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
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
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
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
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
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
				notificationType = BI_PSPB_constantsClass.ACTION_TYPE_Questionnaires;
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_smsAndEmailHandler.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.errorMsgRecordNotFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			//This condition is working for the patient is major i will be send a email and sms.
			//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
			for (CareProgramEnrollee enrollee : [
				SELECT
					Id,
					AccountId,
					BI_PSPB_PatientStatus__c,
					Account.PersonContactId,
					Account.BI_PSP_Birthdate__c
				FROM CareProgramEnrollee
				WHERE Id IN :recordId
			]) {
				enrolIds.add(enrollee.Id);
				accountRec.add(enrollee.AccountId);
			}
			Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap = new Map<Id, List<BI_PSP_Notification_Setting__c>>();
			//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
			for (BI_PSP_Notification_Setting__c enrolleId : [
				SELECT
					Id,
					BI_PSP_Patient__c,
					BI_PSP_Patient__r.BI_PSP_Birthdate__c,
					BI_PSP_Patient__r.PersonContactId,
					BI_PSP_SMS__c,
					BI_PSP_Email__c,
					BI_PSP_Notification_Type__c
				FROM BI_PSP_Notification_Setting__c
				WHERE
					BI_PSP_Patient__c IN :accountRec
					AND BI_PSP_Notification_Type__c = :NotificationType
			]) {
				if (enrolleId.BI_PSP_Patient__c != null) {
					Id accountId = enrolleId.BI_PSP_Patient__c;
					if (!accountToNotificationsMap.containsKey(accountId)) {
						accountToNotificationsMap.put(
							accountId,
							new List<BI_PSP_Notification_Setting__c>()
						);
					}
					accountToNotificationsMap.get(accountId).add(enrolleId);
				}
			}
			Set<Id> notificationAccs = new Set<Id>();
			//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
			for (CareProgramEnrollee enrollee : [
				SELECT
					Id,
					AccountId,
					BI_PSPB_PatientStatus__c,
					Account.PersonContactId,
					Account.BI_PSP_Birthdate__c
				FROM CareProgramEnrollee
				WHERE AccountId IN :accountToNotificationsMap.keySet()
			]) {
				notificationAccs.add(enrollee.AccountId);
			}
			//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
			for (CareProgramEnrollee enrollee : [
				SELECT
					Id,
					AccountId,
					BI_PSPB_PatientStatus__c,
					Account.PersonContactId,
					Account.BI_PSP_Birthdate__c
				FROM CareProgramEnrollee
				WHERE AccountId IN :notificationAccs
			]) {
				List<BI_PSP_Notification_Setting__c> notificationss = accountToNotificationsMap.get(
					enrollee.AccountId
				);
				Date birthdate = enrollee.Account.BI_PSP_Birthdate__c;
				if (birthdate != null) {
					Integer age = Date.today().year() - birthdate.year();
					userType = enrollee.BI_PSPB_PatientStatus__c;
					if (userType == BI_PSPB_constantsClass.Unassigned) {
						url = uDestUrl + urlPage;
					} else {
						url = bDestUrl + urlPage;
					}
					if (age > 18) {
						for (
							BI_PSP_Notification_Setting__c notification : notificationss
						) {
							if (notification.BI_PSP_Email__c == true) {
								contactIdsToSendEmail.add(
									enrollee.Account.PersonContactId
								);
							}
							if (notification.BI_PSP_SMS__c == true) {
								contactIdsToSendSMS.add(
									enrollee.Account.PersonContactId
								);
							}
						}
					}
				}
			}

			//This condition is working for the patient is minor i will be send a email and sms.
			Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMaps = new Map<Id, List<BI_PSP_Notification_Setting__c>>();
			// Populate the map with Account Ids and notification settings
			//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
			for (CareProgramEnrollee enrollee : [
				SELECT
					Id,
					AccountId,
					BI_PSPB_PatientStatus__c,
					Account.PersonContactId,
					Account.BI_PSP_Birthdate__c
				FROM CareProgramEnrollee
				WHERE Id IN :enrolIds
			]) {
				accountToNotificationsMaps.put(
					enrollee.AccountId,
					new List<BI_PSP_Notification_Setting__c>()
				);
			}
			for (BI_PSP_Notification_Setting__c setting : [
    			SELECT Id, 
				BI_PSP_Patient__c, 
				BI_PSP_Email__c, 
				BI_PSP_SMS__c
    			FROM BI_PSP_Notification_Setting__c
    			WHERE BI_PSP_Patient__c IN :accountToNotificationsMaps.keySet() 
				AND BI_PSP_Notification_Type__c = :NotificationType
			]) {
    			if (accountToNotificationsMaps.containsKey(setting.BI_PSP_Patient__c)) {
        			accountToNotificationsMaps.get(setting.BI_PSP_Patient__c).add(setting);
    			}
			}
			// Iterate through BI_PSPB_Enrollee_Caregiver__c records
			//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
			for (BI_PSPB_Enrollee_Caregiver__c enrolleCaregiverId : [
				SELECT
					Id,
					BI_PSPB_Caregiver__c,
					BI_PSPB_Patient__c,
					BI_PSPB_Patient__r.PersonContactId,
					BI_PSPB_Caregiver__r.PersonContactId,
					BI_PSPB_Patient__r.BI_PSP_Birthdate__c,
					BI_PSPB_Care_Program_Enrollee__c
				FROM BI_PSPB_Enrollee_Caregiver__c
				WHERE BI_PSPB_Patient__c IN :accountRec
			]) {
				if (enrolleCaregiverId.BI_PSPB_Patient__c != null) {
					Date birthdate = enrolleCaregiverId.BI_PSPB_Patient__r.BI_PSP_Birthdate__c;
					if (birthdate != null) {
						Integer age = Date.today().year() - birthdate.year();
						if (age < 18) {
							notificationCare.add(enrolleCaregiverId.BI_PSPB_Caregiver__r.PersonContactId);
							notificationCareAcc.add(enrolleCaregiverId.BI_PSPB_Patient__r.Id);
						}
					}
				}
			}
			for (Id acccId : notificationCareAcc) {
				// Get notification settings for this Account Id
				List<BI_PSP_Notification_Setting__c> notificationSettings = accountToNotificationsMaps.get(acccId);
				if (notificationSettings != null) {
							for (
								BI_PSP_Notification_Setting__c notificationSetting : notificationSettings
							) {
								for (Id contactId : notificationCare) {
									if (notificationSettings[0].BI_PSP_Email__c == true) {
										contactIdsToSendEmail.add(contactId);
									}
								}
								for (Id contactId : notificationCare) {
									if (notificationSettings[0].BI_PSP_SMS__c == true) {
										contactIdsToSendSMS.add(contactId);
									}
								}
							}
						}
			}			
			if (!contactIdsToSendEmail.isEmpty()) {
				BI_PSPB_SendEmailBatch sendEmail = new BI_PSPB_SendEmailBatch(
					contactIdsToSendEmail,
					emailSubject,
					url,
					formattedDate,
					followName
				);
				database.executeBatch(sendEmail, 45);
			}
			if (!contactIdsToSendSMS.isEmpty()) {
				BI_PSPB_SendSmsBatch sendSms = new BI_PSPB_SendSmsBatch(
					contactIdsToSendSMS,
					notificationSubject,
					url,
					formattedDate
				);
				database.executeBatch(sendSms, 45);
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