/**
 * @description        This class is used for getting Avatar Url and store the selected Avatar
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023     Created             Initial development
 * 1.1      Ashif  04-Apr-2024     Updated             Catch log added
 */

 public with sharing class BI_PSPB_avatarCtrl {
	private static Integer loginAttemptValue = 1;
	private static String userName = UserInfo.getName();
	private static String email = UserInfo.getUserEmail();
	//custom labels
	private static String errorGettingAccount = System.Label.BI_PSPB_ErrorGettingAccount;
	private static String errorGettingCPE = System.Label.BI_PSPB_ErrorGettingCPE;
	private static String errorUpdatingAccount = System.Label.BI_PSPB_ErrorUpdatingAccount;
	private static String errorUpdateCpe = System.Label.BI_PSPB_ErrorUpdateCpe;
	private static String errorGettingEcg = System.Label.BI_PSPB_ErrorGettingEcg;
	private static String errorMsg ='';
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
	private static String appName = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';
	/*
	@description     used to fetch the current user's account details, return in lwc bipspbAvatarSelection,bipspbAvatarNavigation,bipspbFirsttimeAvatarSelection.
	@return           userAccount Return Account record detail
	*/
	@AuraEnabled(cacheable=true)
	public static List<Account> getLoggedInUserAccount() {
		try {
			List<Account> userAccount = new List<Account>();
			userAccount = [
				SELECT
					Id,
					Name,
					BI_PSP_AvatarUrl__c,
					PersonEmail,
					BI_PSPB_Patient__c,
					BI_PSP_Loginattempt__c
				FROM Account
				WHERE Name = :userName AND PersonEmail = :email WITH USER_MODE
				LIMIT 1
			];
			if (!userAccount.isEmpty()) {
				return userAccount;
			} else {
           // Aura handled Exception cannot be thrown for this. When a caregiver logs in, Patient data should be returned as null.
				return null;
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,appName,BI_PSPB_avatarCtrl.class.toString(),null,System.now());
			throw new AurahandledException(errorGettingAccount);
            
		}
	}
	/*
	 * @description     Used to fecth the current user detail return in lwc bipspbAvatarSelection,    bipspbAvatarNavigation,bipspbFirsttimeAvatarSelection.
	 * @return          query Return User record detail
	 */
	@AuraEnabled(cacheable=true)
	//
	public static List<User> loggedUser() {
		try {
			List<User> userList = new List<User>();
			userList=[
				SELECT Id, Name, Email, BI_PSPB_Caregiver__c
				FROM User
				WHERE Id = :UserInfo.getUserId() WITH USER_MODE
				LIMIT 1
			];
			if(!userList.isEmpty()){
				return userList;
			}
			else{
				throw new AurahandledException(errorGettingAccount);
			}
			
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,appName,BI_PSPB_avatarCtrl.class.toString(),null,System.now());
			throw new AurahandledException(errorGettingAccount);
		}
	}
	/* 
	@description     Used to Update the Account record for current User return in lwc bipspbAvatarSelection,bipspbFirsttimeAvatarSelection.
	@param           accountId The ID of the account to update.
	@param           avatarSrc The URL of the new avatar.
	*/
	@AuraEnabled
	public static void updateAccountAvatar(String accountId, String avatarSrc) {
		try {
            if(String.isBlank(accountId) || String.isBlank(avatarSrc)){
                throw new AurahandledException(errorGettingAccount);
            }
			Account accountToUpdate = new Account(Id = accountId);
			accountToUpdate.BI_PSP_AvatarUrl__c = avatarSrc;
			accountToUpdate.BI_PSP_Loginattempt__c = loginAttemptValue;

			Database.SaveResult[] saveResults = Database.update(
				new List<Account>{ accountToUpdate },
				false
			);
			for (Database.SaveResult saveResult : saveResults) {
				// Handle the error
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
					}
				}
			}
			if (String.isNotBlank(errorMsg)) {
			BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveResults,BI_PSPB_avatarCtrl.class.toString(),System.now());
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,appName,BI_PSPB_avatarCtrl.class.toString(),null,System.now());
            throw new AurahandledException(errorGettingAccount);
		}
	}
	/*  
	@description     Used to Update the Account record for current User (check loginattempt)return in lwc bipspbFirsttimeAvatarSelection.
	@param           AccountId The ID of the account to update.
	*/
	@AuraEnabled
	public static void updateLoginAttempt(String accountId) {
		try {
            if(String.isBlank(accountId)){
             throw new AurahandledException(errorGettingAccount);   
            }
			Account accountToUpdate = new Account(Id = accountId);
			accountToUpdate.BI_PSP_Loginattempt__c = loginAttemptValue;
			Database.SaveResult[] saveResults = Database.update(
				new List<Account>{ accountToUpdate },
				false
			);
			for (Database.SaveResult saveResult : saveResults) {
				// Handle the error
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
					}
				}
			}
			if (String.isNotBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveResults,BI_PSPB_avatarCtrl.class.toString(),System.now());
			}
			// User mode is not enabled because CareProgramEnrollee is health cloud object not supported
			List<CareProgramEnrollee> cpeList = [
				SELECT Id, Name, BI_PSPB_FirstLoginDate__c, AccountId
				FROM CareProgramEnrollee
				WHERE AccountId = :accountId
				LIMIT 1
			];
			if (!cpeList.isEmpty()) {
				// Update the existing CareProgramEnrollee record
				cpeList[0].BI_PSPB_FirstLoginDate__c = Date.today();
				// Insert a new CareProgramEnrollee record
				Database.SaveResult[] saveResults1 = Database.update(
					new List<CareProgramEnrollee>{ cpeList[0] },
					false
				);
				// Iterate over each save result
				for (Database.SaveResult saveResult : saveResults1) {
					// Handle the error
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
							errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
						}
					}
				}
				if (String.isNotBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveResults,BI_PSPB_avatarCtrl.class.toString(),System.now());
				}
			} else {
				throw new AurahandledException(errorUpdateCpe);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,appName,BI_PSPB_avatarCtrl.class.toString(),null,System.now());
            throw new AurahandledException(errorUpdateCpe);
		}
	}
	/*  
	@description     Used to Update the Account record for Caregiver's patient return in lwc bipspbAvatarSelection,bipspbFirsttimeAvatarSelection.
	@param           avatarSrc The URL of the new avatar.
	@return          ecList List of BI_PSPB_Enrollee_Caregiver__c records.
	*/
	@AuraEnabled
	public static List<BI_PSPB_Enrollee_Caregiver__c> getLoggedInUserCaregiver(String avatarSrc) {
		// User mode is not enabled because BI_PSPB_Enrollee_Caregiver__c is lookup with CareProgramEnrollee.
		// CareProgramEnrollee is health cloud object not supported user mode
		try {
            if(String.isBlank(avatarSrc)){
                throw new AurahandledException(errorGettingAccount);
            }
			List<BI_PSPB_Enrollee_Caregiver__c> ecList = [
				SELECT
					Id,
					Name,
					BI_PSPB_Patient__r.Id,
					BI_PSPB_Contact_Id__r.Email,
					BI_PSPB_Patient__r.Name,
					BI_PSPB_Contact_Id__c,
					BI_PSPB_Caregiver__r.BI_PSPB_Selected_Patient_ID__c,
					BI_PSPB_Patient__c
				FROM BI_PSPB_Enrollee_Caregiver__c
				WHERE
					BI_PSPB_Caregiver__r.Name = :userName
					AND BI_PSPB_Caregiver__r.PersonEmail = :email
					AND BI_PSPB_Caregiver__r.BI_PSPB_Selected_Patient_ID__c != NULL
				LIMIT 1
			];
			if (!ecList.isEmpty()) {
				Account accountToUpdate = new Account(Id = ecList[0]
						.BI_PSPB_Caregiver__r.BI_PSPB_Selected_Patient_ID__c);
				accountToUpdate.BI_PSP_AvatarUrl__c = avatarSrc;
				Database.SaveResult[] saveResults = Database.update(new List<Account>{ accountToUpdate },false);
				for (Database.SaveResult saveResult : saveResults) {
					// Handle the error
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
							errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
						}
					}
				}
				if (String.isNotBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveResults,BI_PSPB_avatarCtrl.class.toString(),System.now());
				}
				return ecList;
			} else {
				throw new AurahandledException(errorUpdatingAccount);
			}
			
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,appName,BI_PSPB_avatarCtrl.class.toString(),null,System.now());
			throw new AurahandledException(errorUpdatingAccount);
		}
	}
	/*  
	@description     Used to Fetch the caregivers's Patient return in lwc bipspbAvatarSaelection,bipspbAvatarNavigation,bipspbFirsttimeAvatarSelection.
	@return          avtList The list of caregiver accounts.
	*/
	@AuraEnabled(cacheable=true)
	public static List<Account> userCaregiver() {
		try {
			// User mode is not enabled because BI_PSPB_Enrollee_Caregiver__c is lookup with CareProgramEnrollee.
			// CareProgramEnrollee is health cloud object not supported user mode
			List<BI_PSPB_Enrollee_Caregiver__c> avtLists = [
				SELECT
					Id,
					Name,
					BI_PSPB_Patient__r.Id,
					BI_PSPB_Contact_Id__r.Email,
					BI_PSPB_Patient__r.BI_PSP_Loginattempt__c,
					BI_PSPB_Caregiver__r.BI_PSPB_Patient__c,
					BI_PSPB_Patient__r.Name,
					BI_PSPB_Patient__r.BI_PSP_AvatarUrl__c,
					BI_PSPB_Contact_Id__c,
					BI_PSPB_Contact_Id__r.BI_PSPB_Selected_Patient_ID__c,
					BI_PSPB_Caregiver__r.BI_PSPB_Selected_Patient_ID__c
				FROM BI_PSPB_Enrollee_Caregiver__c
				WHERE
					BI_PSPB_Caregiver__r.Name = :userName
					AND BI_PSPB_Caregiver__r.PersonEmail = :email
					AND BI_PSPB_Caregiver__r.BI_PSPB_Selected_Patient_ID__c != NULL
				LIMIT 1
			];
			if (!avtLists.isEmpty()) {
				String patientId = avtLists[0].BI_PSPB_Caregiver__r.BI_PSPB_Selected_Patient_ID__c;
				List<Account> avtList = [
					SELECT Id, Name, BI_PSP_AvatarUrl__c, BI_PSP_Loginattempt__c
					FROM Account 
					WHERE Id = :patientId WITH USER_MODE
					LIMIT 1
				];
				return avtList;
			} else {
          // Aura handled Exception cannot be thrown for this. When a patient logs in, caregiver data should be returned as null.
				return null;
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,appName,BI_PSPB_avatarCtrl.class.toString(),null,System.now());
			throw new AurahandledException(errorGettingEcg);
		}
	}
	/* 
	@description     Used to Update the login attempt for caregiver's patient return in lwc bipspbFirsttimeAvatarSelection.
	@param           AccountId The ID of the caregiver's account.
	*/
	@AuraEnabled
	public static void updateLoginAttemptcaregiver(String accountId) {
		try {
            if(String.isBlank(accountId)){
                throw new AurahandledException(errorGettingAccount);
            }
			// User mode is not enabled because CareProgramEnrollee is health cloud object not supported
			List<CareProgramEnrollee> cpeList = [
				SELECT Id, Name, BI_PSPB_FirstLoginDate__c, AccountId
				FROM CareProgramEnrollee
				WHERE AccountId = :accountId
				LIMIT 1
			];
			if (!cpeList.isEmpty()) {
				// Update BI_PSPB_FirstLoginDate__c on the first item in cpeList
				cpeList[0].BI_PSPB_FirstLoginDate__c = Date.today();

				Database.SaveResult[] saveResult = Database.update(
					new List<CareProgramEnrollee>{ cpeList[0] },
                    false
				);
				for (Database.SaveResult saveResults : saveResult) {
					// Handle the error
					if (!saveResults.isSuccess()) {
						for (Database.Error error : saveResults.getErrors()) {
							errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
						}
					}
				}
				if (String.isNotBlank(errorMsg)) {
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveResult,
						BI_PSPB_avatarCtrl.class.toString(),System.now());
				}
			} else {
				throw new AurahandledException(errorUpdateCpe);
			}
            if (!cpeList.isEmpty()) {
			// Update BI_PSP_Loginattempt__c on the related Account
			Account accountToUpdateLoginAttempt = new Account(
				Id = cpeList[0].AccountId
			);
			accountToUpdateLoginAttempt.BI_PSP_Loginattempt__c = loginAttemptValue;
			Database.SaveResult[] saveResult = Database.update(
				new List<Account>{ accountToUpdateLoginAttempt },
				false
			);
			for (Database.SaveResult saveResults : saveResult) {
				if (!saveResults.isSuccess()) {
					for (Database.Error error : saveResults.getErrors()) {
						errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
					}
				}
			}
			if (String.isNotBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveResult,
				BI_PSPB_avatarCtrl.class.toString(),System.now());
			}
            }else{
                throw new AurahandledException(errorUpdateCpe);
            }
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,appName,BI_PSPB_avatarCtrl.class.toString(),null,System.now());
            throw new AurahandledException(errorUpdateCpe);
		}
	}
	/*  
	@description     Used to Check the patient status return in lwc bipspbFirsttimeAvatarSelection,bipspbCaregiverpostlogin
	@return          cpeList A list of CareProgramEnrollee records representing the patient's status.
	*/
	@AuraEnabled(cacheable=true)
	public static List<CareProgramEnrollee> checkPatientStatus() {
		try {
			Account acc = [
				SELECT
					Id,
					Name,
					BI_PSP_AvatarUrl__c,
					PersonEmail,
					BI_PSPB_Patient__c,
					BI_PSP_Loginattempt__c
				FROM Account
				WHERE Name = :userName AND PersonEmail = :email WITH USER_MODE
				LIMIT 1
			];
			if (acc == null) {
				throw new AurahandledException(errorGettingAccount);
			}
			List<CareProgramEnrollee> cpeList = [
				SELECT Id, Name, BI_PSPB_PatientStatus__c
				FROM CareProgramEnrollee
				WHERE AccountId = :acc.Id 
				LIMIT 1
			];
			if (!cpeList.isEmpty()) {
				return cpeList;
			} else {
				throw new AurahandledException(errorGettingCPE);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,appName,BI_PSPB_avatarCtrl.class.toString(),null,System.now());
			throw new AurahandledException(errorGettingAccount);
		}
	}
	/* 
	@description     Used to Check the caregiver's patient status return in lwc bipspbFirsttimeAvatarSelection,bipspbCaregiverpostlogin
	@return          cpeList A list of CareProgramEnrollee records representing the patient's status.	
	*/
	@AuraEnabled(cacheable=true)
	public static List<CareProgramEnrollee> checkCaregiverPatientStatus() {
		try {
			// User mode is not enabled because Account is lookup with CareProgramEnrollee.
			// CareProgramEnrollee is health cloud object not supported user mode
			Account acc = [
				SELECT
					Id,
					Name,
					BI_PSP_AvatarUrl__c,
					PersonEmail,
					BI_PSPB_Selected_Patient_ID__c,
					BI_PSPB_Patient__c,
					BI_PSP_Loginattempt__c
				FROM Account
				WHERE Name = :userName AND PersonEmail = :email WITH USER_MODE
				LIMIT 1
			];
			if (acc == null) {
				throw new AurahandledException(errorGettingAccount);
			}
			// CareProgramEnrollee is health cloud object not supported user mode
			List<CareProgramEnrollee> cpeList = [
				SELECT Id, Name, BI_PSPB_PatientStatus__c
				FROM CareProgramEnrollee
				WHERE AccountId = :acc.BI_PSPB_Selected_Patient_ID__c
				LIMIT 1
			];
			if (!cpeList.isEmpty()) {
				return cpeList;
			} else {
				throw new AurahandledException(errorGettingAccount);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,appName,BI_PSPB_avatarCtrl.class.toString(),null,System.now());
			throw new AurahandledException(errorGettingAccount);
		}
	}
}