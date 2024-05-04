/**
* @description 	This class is used for getting the data Enrollee Caregiver custom object with patient associated to the caregiver.
				
* History
* Version 	Author		Date			Detail		Description
* 1.0		Anand S		30-Dec-2024		Created		This was an intial development.
* 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
*/
public with sharing class BI_PSPB_PatientDetailsCtrl {
	//varibale that holds the application name retrieved from Custom Settings.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	//A variable That holds the name of our application to be used in catch exception handler.
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String errorMsg = '';
	// Custom labels
	private static String errorDml = System.Label.BI_PSPB_UnableToUpdateRecord;
	private static String errorReturn = System.Label.BI_PSPB_Error_Returning;
	private static String Accounterror = System.Label.BI_PSPB_Error_For_Account;
	/**
*@description  		method to is used to get the User Id of the caregiver during his/her login and show the 
					list of patients associated with that user.
*@param    			userId of the Caregiver.
*@return   			caregiverAccounts List of Patients.this return in the biPspbCaregiverpostlogin component
**/
	@AuraEnabled(cacheable=true)
	public static List<Map<String, String>> getCaregiverAccounts(
		)
    {
        List<Map<String, String>> caregiverAccounts = new List<Map<String, String>>();
		try {
			
			String currentUserName = UserInfo.getName();
			String currentUserEmail = UserInfo.getUserEmail();

			List<BI_PSPB_Enrollee_Caregiver__c> ecList = [
				SELECT
					Id,
					Name,
					BI_PSPB_Patient__r.Id,
					BI_PSPB_Caregiver__c,
					BI_PSPB_Patient__r.Name,
					BI_PSPB_Patient__r.BI_PSP_Loginattempt__c,
					BI_PSPB_Contact_Id__c,
					BI_PSPB_Status__c
				FROM BI_PSPB_Enrollee_Caregiver__c
				WHERE
					BI_PSPB_Caregiver__r.Name = :currentUserName
					AND BI_PSPB_Caregiver__r.PersonEmail = :currentUserEmail
					AND BI_PSPB_Status__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Active
					WITH USER_MODE
			];

			for (BI_PSPB_Enrollee_Caregiver__c ec : ecList) {
				Map<String, String> accountMap = new Map<String, String>();
				accountMap.put('Id', ec.BI_PSPB_Patient__r.Id);
				accountMap.put('Name', ec.BI_PSPB_Patient__r.Name);
				accountMap.put('Status', ec.BI_PSPB_Status__c);
				accountMap.put('CaregiveID', ec.BI_PSPB_Caregiver__c);
				caregiverAccounts.add(accountMap);
			}

			List<Account> accounts = [
				SELECT Id, Name, PersonEmail, BI_PSP_Loginattempt__c
				FROM Account
				WHERE
					Name = :currentUserName
					AND PersonEmail = :currentUserEmail
					AND IsPersonAccount = TRUE
				WITH USER_MODE
			];
			for (Account acc : accounts) {
				if (acc.PersonEmail != currentUserEmail) {
					// Exclude the user's account
					Map<String, String> accountMap = new Map<String, String>();
					accountMap.put('Id', acc.Id);
					accountMap.put('Name', acc.Name);
					caregiverAccounts.add(accountMap);
				}
			}

			
            
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PatientDetailsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AurahandledException(Accounterror);
		}
        return caregiverAccounts;
	}
	/**

*@description  		This method is used to store the selected patient record Id in the Database.
*@param    			userId of the Caregiver.

**/
	@AuraEnabled(cacheable=false)
	public static void updateSelectedPatientID(
		String UserID,
		String SelectedAccountId
	) {
		try {
			if (!String.isBlank(UserID) || !String.isBlank(SelectedAccountId)) {
				Account accountToUpdate = new Account(Id = UserID);
				// Set the selected patient ID and caregiver check fields
				accountToUpdate.BI_PSPB_Selected_Patient_ID__c = SelectedAccountId;
				accountToUpdate.BI_PSPB_CaregiverCheck__c = true;
				// Update the Account record

				//update accountToUpdate;
				Database.SaveResult updateResult = Database.update(
					accountToUpdate,
					false,
					AccessLevel.USER_MODE
				);
				if (!updateResult.isSuccess()) {
					for (Database.Error error : updateResult.getErrors()) {
						errorMsg +=
							'Error ' +
							error.getFields() +
							'--' +
							error.getMessage() +
							'\n';
					}
				}

				if (!String.isBlank(errorMsg)) {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSPB_PatientDetailsCtrl.class.toString(),
						'',
						System.now(),
						errorMsg,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
					DmlException e = new DmlException();
					e.setMessage(errorMsg);
					throw e;
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_PatientDetailsCtrl.class
					.toString(),
					BI_PSPB_constantsClass.parameterError,
				System.now(),
				'',
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
				throw new AuraHandledException(
					BI_PSPB_constantsClass.parameterError
				);
			}
		} catch (DmlException ex) {
			// Handle DML exceptions
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PatientDetailsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorDml);
		}
	}
	/**

*@description  		This method is used to store the selected patient record Id in the Database.
*@param    			userId of the Caregiver.
*@return   			Void.
**/

	@AuraEnabled
	public static Contact updateSelectedPatient(
		String UserID,
		String SelectedAccountId
	) {
		try {
			if (
				(UserID != null ||
				!String.isEmpty(UserID) ||
				(SelectedAccountId != null ||
				!String.isEmpty(SelectedAccountId)))
			) {
				Contact ContactToUpdate = new contact(Id = UserID);
				ContactToUpdate.BI_PSPB_Selected_Patient_ID__c = SelectedAccountId;
				// update ContactToUpdate;
				Database.SaveResult updateResult = Database.update(
					ContactToUpdate,
					false,
					AccessLevel.USER_MODE
				);
				if (!updateResult.isSuccess()) {
					for (Database.Error error : updateResult.getErrors()) {
						BI_SFCOE_LOG_Util.logMessage(applicationName,
							BI_PSPB_PatientDetailsCtrl.class.toString(),'',
							System.now(),errorMsg ='Error ' +error.getFields() +
								'--' +error.getMessage(),BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					}
				}
				if (!String.isBlank(errorMsg)) {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_PatientDetailsCtrl.class.toString(),
						'',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					DmlException e = new DmlException();
					e.setMessage(errorMsg);throw e;
				}
				if (ContactToUpdate != null) {
					return ContactToUpdate;
				} else {
				  throw new AuraHandledException(	BI_PSPB_constantsClass.error);
				}
			} else {
			  throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PatientDetailsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorReturn);
		}
	}
	/**
	 *@description  		This method is used to Show the number of patient for the user login.
	 *@param            	contactId The ID of the contact record for which caregiver information is retrieved.
	 *@return 			The caregiver contact record.this return in the biPspbCaregiverpostlogin component
	 **/
	@AuraEnabled(cacheable=true)
	public static Contact getcaregiverContact(String contactId) {
		try {
			if(!string.isblank(contactId)){
			return [
				SELECT id, BI_PSPB_Selected_Patient_ID__c
				FROM contact
				WHERE id = :contactId WITH USER_MODE
			];
			}
			else{
				BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_PatientDetailsCtrl.class
					.toString(),
					BI_PSPB_constantsClass.error,
				System.now(),
				'',
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
			throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PatientDetailsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorReturn);
		}
	}
	/**
	 * @description 	Retrieves the caregiver account for the specified account ID.
	 * @param 			accountId The ID of the account for which to retrieve the caregiver account.
	 * @return 			The caregiver account with specified ID, if found; otherwise, null.
	 * 					this return in the biPspbCaregiverpostlogin component
	 */
	@AuraEnabled(cacheable=true)
	public static Account getcaregiverAccountforSwitch(String accountId) {
		try {
			if (String.isBlank(accountId)) {		
			return [
				SELECT
					id,
					BI_PSPB_Selected_Patient_ID__c,
					BI_PSPB_CaregiverCheck__c
				FROM Account
				WHERE id = :accountId
				WITH USER_MODE
			];
		}
		else{
			BI_SFCOE_LOG_Util.logMessage(
			applicationName,
			BI_PSPB_PatientDetailsCtrl.class
				.toString(),
				BI_PSPB_constantsClass.error,
			System.now(),
			'',
			BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
		);
		throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
		}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PatientDetailsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorReturn);
		}
	}
	/**
	 * @description	 	Updates the selected patient ID and caregiver check for the specified user account.
	 * @param 			UserID The ID of the user account to update.
	 * @param 			SelectedAccountId The ID of the selected patient account.
	 * @return 			ContactToUpdate The user account that was updated.this return in the biPspbCaregiverpostlogin component
	 */

	@AuraEnabled(cacheable=false)
	public static Account updateSwitchSelectedPatientID(
		String UserID,
		String SelectedAccountId,
		Boolean check
	) {
		try {
			if (!String.isBlank(UserID)) {
			Account accountToUpdate = new Account(Id = UserID);
			if (SelectedAccountId != null) {
				accountToUpdate.BI_PSPB_Selected_Patient_ID__c = SelectedAccountId;
			}
			accountToUpdate.BI_PSPB_CaregiverCheck__c = check;
			Database.SaveResult updateResult = Database.update(
				accountToUpdate,
				false,
				AccessLevel.USER_MODE
			);
			if (!updateResult.isSuccess()) {
				for (Database.Error error : updateResult.getErrors()) {
					BI_SFCOE_LOG_Util.logMessage(applicationName,
						BI_PSPB_PatientDetailsCtrl.class.toString(),
						'',System.now(),errorMsg='Error ' + error.getFields() +'--' +
							error.getMessage(),BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			}
			if (!String.isBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,BI_PSPB_PatientDetailsCtrl.class.toString(),
					'',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				DmlException e = new DmlException();
				e.setMessage(errorMsg);throw e;
			}
			if (accountToUpdate != null) {
				return accountToUpdate;
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,
			BI_PSPB_PatientDetailsCtrl.class.toString(),
				errorReturn,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				throw new AuraHandledException(errorReturn);
			}
		}
		else{
			BI_SFCOE_LOG_Util.logMessage(
			applicationName,
			BI_PSPB_PatientDetailsCtrl.class
				.toString(),
				BI_PSPB_constantsClass.parameterError,
			System.now(),
			'',
			BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
		);
		throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
		}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PatientDetailsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorDml);
		}
	}
}