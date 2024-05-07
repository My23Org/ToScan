/*
@description Class used for fetching values from user, profile, task, Account, contact .
and CareProgramEnrollee objects.
Reason for using whithout sharing is we use Care Program Enrollee, which is a Health Cloud object;
hence, we cannot utilize user mode here and additionally these methods are used by guest users as
Guest users typically have limited object and field-level permission we haven't used user mode.
History:
Version    Author      Date              Detail         Description
1.0        Gowsic N    6-Dec-2023        Created        Initial development
1.1        Saran S     20-Apr-2024       Updated        Add log, null check, descriptions   
*/
public without sharing class BI_PSPB_LoginCtrl {
private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
'PSPB'
);
private static string applicationName = settings != null
? settings.BI_SFCOE_LOG_Application__c
: '';
private static String BI_PSP_Status_Unread = System.Label.BI_PSP_Status_Unread;
private static String BI_PSP_Status_Active = System.Label.BI_PSPB_Active;
private static String BI_PSP_TaskStatus_Unread = System.Label.BI_PSP_Status_Unread;
private static String BI_PSP_UserId_ErrorMessage = System.Label.BI_PSP_UserId_ErrorMessage;
private static String BI_PSP_ProfileId_ErrorMessage = System.Label.BI_PSP_ProfileId_ErrorMessage;
private static String BI_PSP_Account_ErrorMessage = System.Label.BI_PSP_Account_ErrorMessage;
private static String BI_PSP_careProgramEnrollee_ErrorMessage = System.Label.BI_PSP_careProgramEnrollee_ErrorMessage;
private static String BI_PSP_EnrolleeCaregiver_ErrorMessage = System.Label.BI_PSP_EnrolleeCaregiver_ErrorMessage;
private static String BI_PSP_Contact_ErrorMessage = System.Label.BI_PSP_Contact_ErrorMessage;
/*
@description Fetches user details based on the provided user ID.
@param userId The ID of the user whose details are to be fetched.
@return User object containing the user's ID, first name, last name, profile ID, and BI_PSPB_Caregiver__c field.
*/
@AuraEnabled(cacheable=true)
public static User userDetails(String userId) {
try {
	User userRecord = new User();
	if (!String.isBlank(userId)) {
	userRecord = [
		SELECT id, firstname, lastname, profileid, BI_PSPB_Caregiver__c
		FROM user
		WHERE Id = :userId
	];
	if (userRecord != null) {
		return userRecord;
	} else {
		throw new AuraHandledException(BI_PSP_UserId_ErrorMessage);
	}
	} else {
	BI_SFCOE_LOG_Util.logMessage(
		applicationName,
		BI_PSPB_LoginCtrl.class.toString(),
		'',
		System.now(),
		BI_PSP_UserId_ErrorMessage,
		BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
	);
	throw new AuraHandledException(BI_PSP_UserId_ErrorMessage);
	}
} catch (exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_LoginCtrl.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSP_UserId_ErrorMessage);
}
}

/*
@description Fetches profile details based on the provided profile ID.
@param profileId The ID of the profile whose details are to be fetched.
@return Profile object containing the profile's ID and name.
*/
@AuraEnabled(cacheable=true)
public static Profile profileDetails(String profileId) {
try {
	if (!String.isBlank(profileId)) {
	Profile profileRecord = new Profile();
	profileRecord = [SELECT id, name FROM Profile WHERE Id = :profileId];
	if (profileRecord != null) {
		return profileRecord;
	} else {
		throw new AuraHandledException(BI_PSP_ProfileId_ErrorMessage);
	}
	} else {
	BI_SFCOE_LOG_Util.logMessage(
		applicationName,
		BI_PSPB_LoginCtrl.class.toString(),
		'',
		System.now(),
		BI_PSP_ProfileId_ErrorMessage,
		BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
	);
	throw new AuraHandledException(BI_PSP_ProfileId_ErrorMessage);
	}
} catch (exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_LoginCtrl.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSP_ProfileId_ErrorMessage);
}
}

/*
@description Fetches unread cases associated with the provided user ID.
@param userId The ID of the user for whom unread cases are to be fetched.
@return List of Task objects representing unread cases owned by the specified user.
*/

@AuraEnabled(cacheable=true)
public static list<Task> getUnreadCases(string userId) {
try {
	if (!String.isBlank(userId)) {
	User userRecord = [
		SELECT Id, Name, Email, BI_PSPB_Caregiver__c
		FROM User
		WHERE Id = :userId
		LIMIT 1
	];
	if (userRecord != null) {
		String recName = userRecord.Name;
		String email = userRecord.Email;
		if (userRecord.BI_PSPB_Caregiver__c == false) {
		list<Task> assignedCase = [
			SELECT id, OwnerId, Status
			FROM Task
			WHERE OwnerId = :userId AND Status = :BI_PSP_Status_Unread
		];
		if (assignedCase.Size() > 0 && !assignedCase.isEmpty()) {
			return assignedCase;
		} else {
			throw new AuraHandledException(BI_PSP_UserId_ErrorMessage);
		}
		} else if (userRecord.BI_PSPB_Caregiver__c == true) {
		contact conCare = [
			SELECT id, BI_PSPB_Selected_Patient_ID__c
			FROM contact
			WHERE
			name = :recName
			AND Email = :email
			AND BI_PSPB_Selected_Patient_ID__c != NULL
			LIMIT 1
		];
		if (conCare != null) {
			List<BI_PSPB_Enrollee_Caregiver__c> ecList = [
			SELECT
				Id,
				name,
				BI_PSPB_Patient__r.Id,
				BI_PSPB_Patient__r.Name,
				BI_PSPB_Contact_Id__c,
				BI_PSPB_Status__c,
				BI_PSPB_Contact_Id__r.BI_PSPB_Selected_Patient_ID__c,
				BI_PSPB_Care_Program_Enrollee__c
			FROM BI_PSPB_Enrollee_Caregiver__c
			WHERE
				BI_PSPB_Patient__r.ID = :conCare.BI_PSPB_Selected_Patient_ID__c
				AND BI_PSPB_Contact_Id__c = :conCare.ID
				AND BI_PSPB_Status__c = :BI_PSP_Status_Active
			];
			if (
			!ecList.isEmpty() &&
			ecList.Size() > 0 &&
			ecList[0].BI_PSPB_Care_Program_Enrollee__c != null
			) {
			CareProgramEnrollee patientEnrolle = [
				SELECT
				Id,
				AccountID,
				BI_PSP_Total_Reward_Points__c,
				BI_PSP_Challenge_Rank__c
				FROM CareProgramEnrollee
				WHERE id = :ecList[0].BI_PSPB_Care_Program_Enrollee__c
			];

			if (patientEnrolle != null) {
				account acc = [
				SELECT id, Name, PersonEmail
				FROM account
				WHERE
					id = :patientEnrolle.AccountID
					AND ispersonaccount = TRUE
				];
				if (acc != null) {
				user singleUserId = [
					SELECT id
					FROM user
					WHERE email = :acc.PersonEmail AND name = :acc.name
				];
				if (singleUserId != null) {
					list<Task> assignedCase = [
					SELECT id, OwnerId, Status
					FROM Task
					WHERE
						OwnerId = :singleUserId.Id
						AND Status = :BI_PSP_TaskStatus_Unread
					];
					if (assignedCase.Size() > 0 && !assignedCase.isEmpty()) {
					return assignedCase;
					} else {
					throw new AuraHandledException(
						BI_PSP_UserId_ErrorMessage
					);
					}
				}
				}
			}
			}
		}
		}
	}
	} else {
	BI_SFCOE_LOG_Util.logMessage(
		applicationName,
		BI_PSPB_LoginCtrl.class.toString(),
		'',
		System.now(),
		BI_PSP_UserId_ErrorMessage,
		BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
	);
	throw new AuraHandledException(BI_PSP_UserId_ErrorMessage);
	}
} catch (exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_LoginCtrl.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSP_UserId_ErrorMessage);
}
throw new AuraHandledException(BI_PSP_UserId_ErrorMessage);
}
}