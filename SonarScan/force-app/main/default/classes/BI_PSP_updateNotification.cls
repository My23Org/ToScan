/*
 * @description      This class is used to update and retrieve notification setting.
 * History:
 * Version   Author      Date            Detail          Description
 * 1.0       Adhish      05-Dec-2023     Created         Initial development
 * 1.1       Adhish      15-Apr-2024     Updated         changed the method name
 */

 public with sharing class BI_PSP_updateNotification {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String errorForThrow = System.Label.BI_PSP_ConsoleError;
	private static string errorMsg ='';
	private static String errorForAccount = System.Label.BI_PSPB_Error_For_Account;
	private static String errorForUpdate = System.Label.BI_PSP_record_update_error_message;
	/** 

@description	Method to update notification settings for a given account. 
@param			accid(String )-  This parameter pass the account  ids.
@param			Type(String )-  This parameter pass the notification type.
@param			isCheckedEmail(Boolean )-  This parameter pass the value whether email is enabled. 
@param			isCheckedSMS(Boolean )-  This parameter pass the value whether sms is enabled.  
@param			isCheckedInsite(Boolean )- This parameter pass the value whether insite notification is enabled. 
@param			isCheckedPhone(Boolean )-  This parameter pass the value whether phone is enabled. 
@return			Void .

*/
	@AuraEnabled
	public static void updateFieldInObject(
		String accid,
		BI_PSPB_notificationSettingParaWrapper Wrapper
	) {
		try {
			// Query notification settings based on the provided account ID and type.
			// The values in the wrapper can be null.Hence null check is not done.
			if (String.isNotBlank(accid)) {
				List<BI_PSP_Notification_Setting__c> notifyList = [
					SELECT
						Id,
						BI_PSP_Email__c,
						BI_PSP_SMS__c,
						BI_PSP_Insite_Notification__c,
						BI_PSP_Phone__c
					FROM BI_PSP_Notification_Setting__c
					WHERE
						BI_PSP_Notification_Type__c = :Wrapper.typeValue
						AND BI_PSP_Patient__c = :accid
					WITH USER_MODE
					LIMIT 1
				];
				if (!notifyList.isEmpty()) {
					// Iterate through the notification settings and update them.
					for (
						BI_PSP_Notification_Setting__c notification : notifyList
					) {
						notification.BI_PSP_Email__c = Wrapper.emailValue;
						notification.BI_PSP_SMS__c = Wrapper.smsValue;
						notification.BI_PSP_Insite_Notification__c = Wrapper.insiteValue;
						notification.BI_PSP_Phone__c = Wrapper.phoneValue;
					}
					// Perform bulk update of the notification settings.
					Database.SaveResult[] saveResults = Database.update(
						notifyList,
						false,
						AccessLevel.USER_MODE
					);
					// Iterate through save results and log any errors.
					for (Database.SaveResult saveResult : saveResults) {
						if (!saveResult.isSuccess()) {
							for (
									Database.Error error : saveResult.getErrors()) {
									errorMsg +='Error ' +
									error.getFields() +'--' +
									error.getMessage() +'\n';
							}
						}
					}
					if (String.isNotBlank(errorMsg)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveResults,
							BI_PSP_updateNotification.class.toString(),
							System.now()
						);
						throw new AuraHandledException(errorForUpdate); // Propagate combined errors after collecting from all records
					}
				} else {
					throw new AuraHandledException(errorForAccount);
				}
			} else {
				throw new AuraHandledException(errorForAccount);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSP_updateNotification.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorForUpdate);
		}
	}

	/**
@description	Method to retrieve notification settings for a given account and type.
@param			accid(ID )-  This parameter pass the account  ids.
@param			Type(String )-  This parameter pass the notification type. 
@return			Return the list of notifications to Notification Settings Component
*/

	@AuraEnabled(cacheable=true)
	public static List<BI_PSP_Notification_Setting__c> retrieveNotifications(
		Id accid,
		String Type
	) {
		List<BI_PSP_Notification_Setting__c> notifyList = new List<BI_PSP_Notification_Setting__c>();
		try {
			if (accid != null && String.isNotBlank(Type)) {
				// Query notification settings based on the provided account ID and type.

				notifyList = [
					SELECT
						Id,
						BI_PSP_Email__c,
						BI_PSP_SMS__c,
						BI_PSP_Insite_Notification__c,
						BI_PSP_Phone__c
					FROM BI_PSP_Notification_Setting__c
					WHERE
						BI_PSP_Notification_Type__c = :Type
						AND BI_PSP_Patient__c = :accid
					WITH USER_MODE
					LIMIT 1
				];
				if (notifyList.isEmpty()) {
					throw new AuraHandledException(errorForAccount);
				}
			} else {
				throw new AuraHandledException(errorForAccount);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSP_updateNotification.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorForAccount);
		}
		// Return the retrieved notification settings.
		return notifyList;
	}

	/** 

@description    This wrapper class used for notification value pass wrapper class.

*/
	public class BI_PSPB_notificationSettingParaWrapper {
		@AuraEnabled
		public Boolean emailValue { get; set; }
		@AuraEnabled
		public Boolean smsValue { get; set; }
		@AuraEnabled
		public Boolean insiteValue { get; set; }
		@AuraEnabled
		public Boolean phoneValue { get; set; }
		@AuraEnabled
		public String typeValue { get; set; }
	}
}