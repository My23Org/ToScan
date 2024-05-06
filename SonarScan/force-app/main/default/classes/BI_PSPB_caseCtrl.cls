/**
 * @description Case creation for account deletion request and account access request by patients
 * History:
 * Version    Author               Date              Detail         Description
 * 1.0        Divya Bharathi S     6-Dec-2023        Created        Initial development
 * 1.1        Divya Bharathi S     08-Apr-2024       Updated        Add null check
 * 1.2        Divya Bharathi S     18-Apr-2024       Updated        Add Log
 */
public with sharing class BI_PSPB_caseCtrl 
{
	private static string BI_PSPB_Case = System.Label.BI_PSPB_CaseRecordtype;
	private static string BI_PSPB_deletion = System.Label.BI_PSPB_Accdeletion;
	private static string BI_PSPB_request = System.Label.BI_PSPB_Accrequest;
	private static string BI_PSPB_med = System.Label.BI_PSPB_PriorityMed;
	private static string BI_PSPB_high = System.Label.BI_PSPB_PriorityHigh;
	private static string insertError = System.label.BI_PSP_record_insert_error_message;
	private static String errorMsg = '';
	private static BI_SFCOE_LOG_App_Settings__c settings = 
	BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
	private static string applicationName = settings != null
	? settings.BI_SFCOE_LOG_Application__c
			: '';
	private static string accountMesaage = System.label.BI_PSP_record_not_found_error_message;
	private static string caseAccess = System.label.BI_PSPB_CaseAccessError;
	private static string caseDelete = System.label.BI_PSPB_CaseRequestError;
	/**
	 * @description This method creates a case for each related account based on the user's role.
	 * Creates a case for account deletion by patients.
	 * This method is used in biPspbPatientProfiledetails and biPspbCgPatientinfo LWC component.
	 */
	@AuraEnabled
	public static void createCase() 
	{
		try 
		{
			// This class will be utilized only for the logged in user. So, definitely the Name and Email fields will not be null. Hence, the strings are not validated for isBlank or isNotBlank
			String currentUserName = UserInfo.getName();
			String currentUserEmail = UserInfo.getUserEmail();
			User currentUser = [
				SELECT Id, Name, Email, BI_PSPB_Caregiver__c
				FROM User
				WHERE Name = :currentUserName AND Email = :currentUserEmail
				WITH USER_MODE
				LIMIT 1
			];
			//We are using SOQL to get the User details because we need a custom field from User..
			// List to store related accounts.
			/* If the user is a caregiver, retrieve related 
				accounts based on BI_PSPB_Selected_Patient_ID__c*/
			List<Account> relatedAccounts = new List<Account>();
			if (currentUser.BI_PSPB_Caregiver__c == true) 
			{
				/* If the user is a caregiver, retrieve related 
				accounts based on BI_PSPB_Selected_Patient_ID__c*/
				List<Account> selectedPatientAccounts = [
					SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
					FROM Account
					WHERE
					Name = :currentUserName
					AND PersonEmail = :currentUserEmail
					AND IsPersonAccount = TRUE
					AND BI_PSPB_Selected_Patient_ID__c != NULL
					WITH USER_MODE
				];
				if (!selectedPatientAccounts.isEmpty()) 
				{
					relatedAccounts = [
						SELECT Id, Name, PersonEmail
						FROM Account
						WHERE
						Id = :selectedPatientAccounts[0]
						.BI_PSPB_Selected_Patient_ID__c
						WITH USER_MODE
					];
				}
			} 
			else 
			{
				// If the user is not a caregiver, retrieve accounts directly related to the user
				relatedAccounts = [
					SELECT Id, Name, PersonEmail
					FROM Account
					WHERE
					PersonEmail = :currentUserEmail
					AND Name = :currentUserName
					WITH USER_MODE
				];
			}
			Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
				.get('BI_PSPB_Case')
				.getRecordTypeId();
			List<Case> casesToInsert = new List<Case>();
			if (!relatedAccounts.isEmpty() && String.isNotBlank(recordTypeId)) 
			{
				// Create cases for each related account
				for (Account relatedAccount : relatedAccounts) 
				{
					Case newCase = new Case();
					newCase.Subject = BI_PSPB_deletion;
					newCase.Description = BI_PSPB_deletion;
					newCase.BI_PSP_Type__c = BI_PSPB_deletion;
					newCase.Status = '';
					newCase.Origin = '';
					newCase.Priority = BI_PSPB_high;
					// Assign the Case to the matched or selected Account
					newCase.AccountId = relatedAccount.Id;
					newCase.OwnerId = currentUser.Id;
					newCase.RecordTypeId = recordTypeId;
					casesToInsert.add(newCase);
				}
                if (!casesToInsert.isEmpty()) {
				Database.SaveResult[] saveResults = Database.insert(
					casesToInsert,
					false,
					AccessLevel.USER_MODE
				);
				for (Database.SaveResult saveResult : saveResults) 
				{
					if (!saveResult.isSuccess()) 
					{
						// Handle the error
						for (Database.Error error : saveResult.getErrors()) 
						{
							errorMsg +=
								'Error ' +
								error.getFields() +
								'--' +
								error.getMessage() +
								'\n';
						}
					}
				}
				if (String.isNotBlank(errorMsg)) 
				{
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResults,
						BI_PSPB_caseCtrl.class.toString(),
						System.now()
					);
					throw new AuraHandledException(insertError);
				}
			} 
            }
			else 
			{
				throw new AuraHandledException(accountMesaage);
			} //End if (!relatedAccounts.isEmpty() && String.isNotBlank(recordTypeId))
		} 
		catch (Exception ex) 
		{
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_caseCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(insertError);
		}
	}
	/**
	 * Creates a case for personal information request.
	 * @description This method creates a case for each related account based on the user's role.
	 * This method is used in biPspbPatientProfiledetails and biPspbCgPatientinfo LWC component.
	 */
	@AuraEnabled
	public static void createAccessCase() 
	{
		try 
		{
			// This class will be utilized only for the logged in user. So, definitely the Name and Email fields will not be null. Hence, the strings are not validated for isBlank or isNotBlank
			String currentUserName = UserInfo.getName();
			String currentUserEmail = UserInfo.getUserEmail();
			User currentUser = [
				SELECT Id, Name, Email, BI_PSPB_Caregiver__c
				FROM User
				WHERE Name = :currentUserName AND Email = :currentUserEmail
				WITH USER_MODE
				LIMIT 1
			];
			//We are using SOQL to get the User details because we need a custom field from User.
			// List to store related accounts
			/* If the user is a caregiver, retrieve related 
			accounts based on BI_PSPB_Selected_Patient_ID__c*/
			List<Account> relatedAccounts = new List<Account>();
			if (currentUser.BI_PSPB_Caregiver__c == true) 
			{
				/* If the user is a caregiver, retrieve related 
				accounts based on BI_PSPB_Selected_Patient_ID__c*/
				List<Account> selectedPatientAccounts = [
					SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
					FROM Account
					WHERE
					Name = :currentUserName
					AND PersonEmail = :currentUserEmail
					AND IsPersonAccount = TRUE
					AND BI_PSPB_Selected_Patient_ID__c != NULL
					WITH USER_MODE
				];
				if (!selectedPatientAccounts.isEmpty()) 
				{
					relatedAccounts = [
						SELECT Id, Name, PersonEmail
						FROM Account
						WHERE
						Id = :selectedPatientAccounts[0]
						.BI_PSPB_Selected_Patient_ID__c
						WITH USER_MODE
					];
				}
			} 
			else 
			{
				// If the user is not a caregiver, 
				//retrieve accounts directly related to the user
				relatedAccounts = [
					SELECT Id, Name, PersonEmail
					FROM Account
					WHERE
					PersonEmail = :currentUserEmail
					AND Name = :currentUserName
					WITH USER_MODE
				];
			}
			Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
				.get('BI_PSPB_Case')
				.getRecordTypeId();
			List<Case> casesToInsert = new List<Case>();
			if (!relatedAccounts.isEmpty() && String.isNotBlank(recordTypeId)) 
			{
				// Create a new Case record
				for (Account relatedAccount : relatedAccounts) 
				{
					Case newCase = new Case();
					newCase.Subject = BI_PSPB_request;
					newCase.Description = BI_PSPB_request;
					newCase.BI_PSP_Type__c = BI_PSPB_request;
					newCase.Priority = BI_PSPB_med;
					// Assign the case to the specified owner (the logged-in user)
					newCase.OwnerId = currentUser.Id;
					newCase.AccountId = relatedAccount.Id;
					newCase.RecordTypeId = recordTypeId;
					casesToInsert.add(newCase);
				}
                if (!casesToInsert.isEmpty()) {
				Database.SaveResult[] saveResults = Database.insert(
					casesToInsert,
					false,
					AccessLevel.USER_MODE
				);
				for (Database.SaveResult saveResult : saveResults)
				{
					if (!saveResult.isSuccess()) 
					{
						// Handle the error
						for (Database.Error error : saveResult.getErrors()) 
						{
							errorMsg +=
								'Error ' +
								error.getFields() +
								'--' +
								error.getMessage() +
								'\n';
						}
					}
				}
				if (String.isNotBlank(errorMsg)) 
				{
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResults,
						BI_PSPB_caseCtrl.class.toString(),
						System.now()
					);
					throw new AuraHandledException(insertError);
				}
			} 
            }
			else 
			{
				throw new AuraHandledException(accountMesaage);
			} //End if (!relatedAccounts.isEmpty() && String.isNotBlank(recordTypeId))
		} 
		catch (Exception ex) 
		{
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_caseCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(insertError);
		}
	}
	/**
	 * @description Retrieves the checkbox values for a given case record.
	 * This method is used in biPspbPatientProfiledetails 
	   and biPspbCgPatientinfo LWC component.
	 * @param accountId The Id of the related account.
	 * @return The Case record containing checkbox values.
	 */
	@AuraEnabled(cacheable=true)
	public static Case checkboxPersonalAccess(string relatedAccounts) 
	{
		try 
		{
			Case caseRecord;
			if (String.isNotBlank(relatedAccounts)) 
			{
				caseRecord = [
					SELECT
					Id,
					BI_PSP_Personal_Information_Request__c,
					BI_PSP_Account_Deletion_Request__c
					FROM Case
					WHERE
					AccountId = :relatedAccounts
					AND BI_PSP_Type__c = :BI_PSPB_request
					WITH USER_MODE
					ORDER BY CreatedDate DESC
					LIMIT 1
				];
			} 
			else 
			{
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_caseCtrl.class.toString(),
					'',
					System.now(),
					caseAccess,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			if (caseRecord != null) 
			{
				return caseRecord;
			} 
			else 
			{
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_caseCtrl.class.toString(),
					'',
					System.now(),
					caseAccess,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
				return null;
				/*For a null check, the error is logged. 
				It cannot be thrown as an Aura handled Exception because there may 
		  		be a possibility the user has no case records. 
		  		The toast message can be disruptive to the UI/UX design.*/
			}
		} 
		catch (Exception ex) 
		{
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_caseCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(caseAccess);
		}
	}
	/**
	 * @description Retrieves the checkbox values for a given case record.
	 * This method is used in biPspbPatientProfiledetails and biPspbCgPatientinfo LWC component.
	 * @param accountId The Id of the related account.
	 * @return The Case record containing checkbox values.
	 */
	@AuraEnabled(cacheable=true)
	public static Case checkboxAccountDeletion(string relatedAccounts) 
	{
		try 
		{
			Case casesRecord;
			if (String.isNotBlank(relatedAccounts)) 
			{
				casesRecord = [
					SELECT
					Id,
					BI_PSP_Personal_Information_Request__c,
					BI_PSP_Account_Deletion_Request__c
					FROM Case
					WHERE
					AccountId = :relatedAccounts
					AND BI_PSP_Type__c = :BI_PSPB_deletion
					WITH USER_MODE
					ORDER BY CreatedDate DESC
					LIMIT 1
				];
			} 
			else 
			{
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_caseCtrl.class.toString(),
					'',
					System.now(),
					caseDelete,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			if (casesRecord != null) 
			{
				return casesRecord;
			} 
			else 
			{
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_caseCtrl.class.toString(),
					'',
					System.now(),
					caseDelete,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
				return null;
				/*For a null check, the error is logged. 
				It cannot be thrown as an Aura handled Exception because there may 
				be a possibility the user has no case records. 
			   The toast message can be disruptive to the UI/UX design.*/
			}
		} 
		catch (Exception ex) 
		{
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_caseCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(caseDelete);
		}
	}
}