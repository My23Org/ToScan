/*
@description This class facilitates the creation of caregiver community users.
It eures that caregiver users are created for specific account types and associates them with the appropriate profiles.
This apex is invoked the flow
History:
Version    Author               Date              Detail         Description
1.0        Divya Bharathi S     6-Dec-2023        Created        Initial development
1.1        Divya Bharathi S     08-Apr-2024       Updated        Add null check
1.2        Divya Bharathi S     17-Apr-2024       Updated        Add log
*/
public with sharing class BI_PSPB_caregiverOnboarding {
private static String BI_PSPB_Caregiver = System.Label.BI_PSPB_CaregiveRecordType;
private static String BI_PSPB_Profile = System.Label.BI_PSPB_CaregiverProfile;
private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
'PSPB'
);
private static string applicationName = settings != null
? settings.BI_SFCOE_LOG_Application__c
: '';
private static String errorMsg = '';
private static String BI_PSPB_EmailEncode = System.Label.BI_PSPB_EmailEncodingKey;
private static String recordTypeError = System.Label.BI_PSPB_CaregiveRecordTypeError;
private static String BI_PSPB_Locales = System.Label.BI_PSPB_LocaleSidKey;
private static String BI_PSPB_Timezone = System.Label.BI_PSPB_TimeZoneSidKey;
private static string nullMesaage = System.label.BI_PSPB_CaregiverNullError;
private static string recordError = System.label.BI_PSP_record_not_found_error_message;
private static string profileError = System.label.BI_PSPB_ProfileError;
/*
@description Method to create caregiver community users from a list of account IDs.
It checks for existing users and creates new ones for accounts with caregiver record type.
@param lstCaregiverAccId The list of account IDs for which caregiver users need to be created.
*/
@InvocableMethod
public static void createUser(List<Id> lstCaregiverAccId) {
/*On invoking the if condition inside try / catch, it impacted
	the functionality. Hence, it's called outside and checked for null.*/
if (lstCaregiverAccId.isEmpty()) {
	BI_SFCOE_LOG_Util.logMessage(
	applicationName,
	BI_PSPB_caregiverOnboarding.class.toString(),
	'',
	System.now(),
	nullMesaage,
	BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
	);
} else {
	try {
	// Get the RecordTypeId for the Caregiver record type
	Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
		.get(BI_PSPB_Caregiver)
		.getRecordTypeId();
	if (String.isNotBlank(recordTypeId)) {
		// Query caregiver accounts
		List<Account> lstCaregiverAccounts = [
		SELECT
			Id,
			PersonEmail,
			FirstName,
			LastName,
			PersonContactId,
			BI_PSPB_GrantCaregiverAccess__c
		FROM Account
		WHERE Id IN :lstCaregiverAccId AND RecordTypeId = :recordTypeId
		WITH USER_MODE
		];
		if (lstCaregiverAccounts.isEmpty()) {
		BI_SFCOE_LOG_Util.logMessage(
			applicationName,
			BI_PSPB_caregiverOnboarding.class.toString(),
			'',
			System.now(),
			recordError,
			BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
		);
		} else {
		// Get the Portal Profile
		Profile portalProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = :BI_PSPB_Profile
			WITH USER_MODE
			LIMIT 1
		];
		if (portalProfile == null) {
			BI_SFCOE_LOG_Util.logMessage(
			applicationName,
			BI_PSPB_caregiverOnboarding.class.toString(),
			'',
			System.now(),
			profileError,
			BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
		} else {
			List<User> newUsers = new List<User>();
			for (Account caregiverAcc : lstCaregiverAccounts) {
			User newUser = new User(
				UserName = caregiverAcc.PersonEmail,
				FirstName = caregiverAcc.FirstName,
				LastName = caregiverAcc.LastName,
				Alias = caregiverAcc.FirstName,
				Email = caregiverAcc.PersonEmail,
				ContactId = caregiverAcc.PersonContactId,
				ProfileId = portalProfile.Id,
				EmailEncodingKey = BI_PSPB_EmailEncode,
				CommunityNickname = caregiverAcc.FirstName +
				' ' +
				caregiverAcc.LastName,
				TimeZoneSidKey = BI_PSPB_Timezone,
				LocaleSidKey = BI_PSPB_Locales,
				BI_PSPB_Caregiver__c = true,
				LanguageLocaleKey = BI_PSPB_Locales
			);
			newUsers.add(newUser);
			}

			if (!newUsers.isEmpty()) {
			// Insert the users
			List<Database.SaveResult> results = Database.insert(
				newUsers,
				false,
				AccessLevel.USER_MODE
			);
			for (Database.SaveResult result : results) {
				if (!result.isSuccess()) {
				for (Database.Error error : result.getErrors()) {
					errorMsg +=
					'Error ' +
					error.getFields() +
					'--' +
					error.getMessage() +
					'\n';
				}
				}
			}
			if (String.isNotBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
				results,
				BI_PSPB_caregiverOnboarding.class.toString(),
				System.now()
				);
			}
            else
            {
                List<Account> accountUpdate=[select id,HealthCloudGA__LowIncome__c from Account where Id IN:lstCaregiverAccId];
                for (Account acc : accountUpdate) {
   					 acc.HealthCloudGA__LowIncome__c = True;
				}
                update accountUpdate;
            }
			} //End if(portalProfile)
		} //End if (lstCaregiverAccounts)
		}
	} else {
		BI_SFCOE_LOG_Util.logMessage(
		applicationName,
		BI_PSPB_caregiverOnboarding.class.toString(),
		'',
		System.now(),
		recordTypeError,
		BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
		);
	} // End if (recordtypeId)
	} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
		ex,
		applicationName,
		BI_PSPB_caregiverOnboarding.class.toString(),
		null,
		System.now()
	);
	}
} // End if	(lstCaregiverAccId)
}
}