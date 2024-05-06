/*
* @description   This class is used for getting Account Id, Creating Contact,Creating Enrollee caregiver,grand access
*                Reason for using whithout sharing lead converted can only be accessed by admin user and can't be
*                accessed by external users,Enrolee caregiver contains a lookup field to a Care Program Enrollee, 
				 which is a Health Cloud object; hence, we cannot utilize user mode here.
*                
* History:
* Version	Author			Date			Detail				Description
* 1.0		NandhaKumar	    05-01-2024  	Created				Initial development
* 1.1		NandhaKumar 	01-Dec-2023		Updated				Updated the Caregiver record 
* 1.2		NandhaKumar 	04-Apr-2023		Updated				Catch log added
*/

public without sharing class BI_PSPB_exuserGetAccid {
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
	
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	//common variable
	private static String errorMsg = '';
	// Custom Error message label
	private static String recordcannotfound = System.Label.BI_PSP_record_not_found_error_message;
	private static String recordcannotupdate = System.Label.BI_PSP_record_update_error_message;
	// enrollee Caregiver status value
	private static String Active = System.Label.BI_PSPB_enrolleeCaregiverStatus;
	private static String Inactive = System.Label.BI_PSPB_enrolleeCaregiverStatusInactive;
	//logged user Id and email get
	private static String username = UserInfo.getName();
	private static String useremail = UserInfo.getUserEmail();
	/**
*  @description :Retrieves caregiver details based on the current user's ID
				 return in lwc biPspbCaregiverProfile.Enrolee caregiver contains a lookup field to a Care Program Enrollee, 
				 which is a Health Cloud object; hence, we cannot utilize user mode here.
* @param        :none.
* @return       :List of Account records representing caregivers.
*/
	@AuraEnabled(cacheable=true)
	public static List<Account> UserCaregiver() {
		String contactIds;

		try {
           
			list<Account> acc = [
				SELECT Id, Name
				FROM Account
				WHERE Name = :username 
				LIMIT 1
			];
            if(!acc.isEmpty()){
		   //Enrolee caregiver contains a lookup field to a Care Program Enrollee,which is a Health Cloud object; 
		   //hence, we cannot utilize user mode here.
			BI_PSPB_Enrollee_Caregiver__c caregiverList = [
				SELECT
					Id,
					Name,
					BI_PSPB_Patient__r.Id,
					BI_PSPB_Contact_Id__c,
					BI_PSPB_Caregiver__c
				FROM BI_PSPB_Enrollee_Caregiver__c
				WHERE BI_PSPB_Caregiver__c = :acc[0].Id
				LIMIT 1
			];

			if (
				caregiverList != null &&
				caregiverList.BI_PSPB_Caregiver__c != null
			) {
				contactIds = caregiverList.BI_PSPB_Caregiver__c;
				List<Account> accfinal = [
					SELECT
						Id,
						FirstName,
						LastName,
						BI_PSP_Birthdate__c,
						PersonEmail,
						Phone,
						BI_PSPB_Preferred_Communication_Method__c,
						BI_PSPB_Relationship_to_Patient__c
					FROM Account
					WHERE id = :contactIds
				    LIMIT 1
				];
				return accfinal;
			} else {
				throw new AuraHandledException(recordcannotfound);
			}
            }else {
				throw new AuraHandledException(recordcannotfound);
			}
            
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_exusergetaccid.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(recordcannotfound);
		}
	}

	/**
	 * @description Updates caregiver details in the Salesforce database.return in lwc biPspbCaregiverProfile 
	 * all the wrapper class parameters null check in lwc 
	 * @param accountId The ID of the account to update.
	 * @param firstName The updated first name of the caregiver.
	 * @param lastName The updated last name of the caregiver.
	 * @param birthdate The updated birth date of the caregiver.
	 * @param relationshipVal The updated relationship of the caregiver to the patient.
	 * @param personEmailVal The updated email of the caregiver.
	 * @param phoneVal The updated phone number of the caregiver.
	 * @param communicationMode The updated preferred communication method of the caregiver.
	 * @return A success message if the update is successful, otherwise an error message.
	 */

	@AuraEnabled
	public static void updateCaregiverDetails(
		BI_PSPB_CaregiverDetailsWrapper cgprofile
	) {
		try {
            if(cgprofile !=null){
			List<Account> accountToUpdate = new List<Account>();
			List<Account> accValues = [
				SELECT
					Id,
					FirstName,
					LastName,
					PersonEmail,
					BI_PSP_Birthdate__c,
					BI_PSPB_Relationship_to_Patient__c,
					Phone,
					BI_PSPB_Preferred_Communication_Method__c
				FROM Account
				WHERE Id = :cgprofile.accountId
				 LIMIT 1
			];

			if (!accValues.isEmpty()) {
				Account accToUpdate = accValues[0];

				accToUpdate.FirstName = cgprofile.FirstName;
				accToUpdate.LastName = cgprofile.LastName;
				accToUpdate.BI_PSP_Birthdate__c = Date.valueOf(
					cgprofile.PersonBirthdate
				);
				accToUpdate.BI_PSPB_Relationship_to_Patient__c = cgprofile.relations;
				accToUpdate.PersonEmail = cgprofile.PersonEmail;
				accToUpdate.Phone = cgprofile.phone;
				accToUpdate.BI_PSPB_Preferred_Communication_Method__c = cgprofile.PreferredMethodofContact;

				accountToUpdate.add(accToUpdate);
				Database.SaveResult[] saveResults = Database.update(
					accountToUpdate,
					false
				);

				for (Database.SaveResult saveResult : saveResults) {
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
							errorMsg +=
								'Error ' + error.getFields() + '--' +
								error.getMessage() + '\n';
						}
					}
				}

				if (String.isNotBlank(errorMsg)) {
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResults,
						BI_PSPB_exuserGetAccid.class.toString(),
						System.now()
					);
					throw new AuraHandledException(recordcannotupdate);
				}
			} else {
				throw new AuraHandledException(recordcannotfound);
			}
		} else {
				throw new AuraHandledException(recordcannotfound);
			}
        }catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_exusergetaccid.class.toString(),
				null,System.now()
			);
            throw new AuraHandledException(recordcannotfound);
		}
	}
	/**
* @description  :Updates the status and related records based on the checkbox selection,
				 Retrieves caregiver details based on the current user's ID,Enrolee caregiver contains a lookup field to a Care Program Enrollee, 
				 which is a Health Cloud object; hence, we cannot utilize user mode here. return in lwc biPspbaddcaregiver
* @param        :isChecked A boolean value indicating whether the checkbox is checked or not.True: Checkbox is checked.False: Checkbox is not checked.
* @return       :none
*/

	@AuraEnabled
	public static void updateContactFromCheckbox(Boolean isChecked) {
		try {
            if(isChecked != null){
			BI_PSPB_Enrollee_Caregiver__c ecRecord;
            //Enrolee caregiver contains a lookup field to a Care Program Enrollee,which is a Health Cloud object; 
		   //hence, we cannot utilize user mode here.
			List<BI_PSPB_Enrollee_Caregiver__c> ecList = [
				SELECT
					Id,
					BI_PSPB_Patient__r.Id,
					BI_PSPB_Caregiver__c,
					BI_PSPB_Contact_Id__r.BI_PSPB_GrantAccess__c,
					BI_PSPB_Patient__r.Name,
					BI_PSPB_Contact_Id__c,
					BI_PSPB_Status__c
				FROM BI_PSPB_Enrollee_Caregiver__c
				WHERE
					BI_PSPB_Patient__r.Name = :username
					AND BI_PSPB_Patient__r.PersonEmail = :useremail
			];

			if (!ecList.isEmpty()) {
				ecRecord = ecList[0];
				ecRecord.BI_PSPB_Status__c = isChecked ? Active : Inactive;
				Database.SaveResult[] saveResulton = Database.update(
					new List<BI_PSPB_Enrollee_Caregiver__c>{ ecRecord },
					false
				);

				for (Database.SaveResult saveResult : saveResulton) {
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
							errorMsg +='Error ' +error.getFields() +
								'--' +error.getMessage() +'\n';
						}
					}
				}

				if (String.isNotBlank(errorMsg)) {
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResulton,
						BI_PSPB_exuserGetAccid.class.toString(),
						System.now()
					);
					throw new AuraHandledException(recordcannotupdate);
				}

				List<Contact> contactList = [
					SELECT
						Id,
						FirstName,
						LastName,
						Email,
						BI_PSPB_GrantAccess__c
					FROM Contact
					WHERE Id = :ecList[0].BI_PSPB_Contact_Id__c
					LIMIT 1
				];

				Contact con;
				if (!contactList.isEmpty()) {
					con = new contact(id = contactList[0].id);

					con.BI_PSPB_GrantAccess__c = isChecked;
				} else {
					throw new AuraHandledException(recordcannotfound);
				}

				List<Account> accLists = [
					SELECT
						Id,
						FirstName,
						LastName,
						PersonEmail,
						BI_PSPB_GrantCaregiverAccess__c
					FROM Account
					WHERE Id = :ecList[0].BI_PSPB_Caregiver__c
					LIMIT 1
				];
				Account acc;
				if (!accLists.isEmpty()) {
					acc = new Account(id = accLists[0].id);

					acc.BI_PSPB_GrantCaregiverAccess__c = isChecked;
				}

				Database.SaveResult[] saveResultstw = Database.update(
					new List<SObject>{ con, acc },
					false
				);

				for (Database.SaveResult saveResult : saveResultstw) {
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
							errorMsg +='Error ' +
								error.getFields() +'--' +error.getMessage() +
								'\n';
						}
					}
				}
				if (String.isNotBlank(errorMsg)) {
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResultstw,
						BI_PSPB_exuserGetAccid.class.toString(),
						System.now()
					);
					throw new AuraHandledException(recordcannotupdate);
				}
			}
            }else {
					throw new AuraHandledException(recordcannotfound);
				}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_exusergetaccid.class.toString(),
				null,System.now()
			);
            throw new AuraHandledException(recordcannotfound);
		}
	}

	/**
* @description : Retrieves the list of caregiver records with their access permissions based on the logged-in user's email.
				 Enrolee caregiver contains a lookup field to a Care Program Enrollee,which is a Health Cloud object; 
				 hence, we cannot utilize user mode here.return in lwc biPspbaddcaregiver
* @return      : List of BI_PSPB_Enrollee_Caregiver__c records representing caregivers and their access permissions.
*/
	@AuraEnabled(cacheable=true)
	public static List<BI_PSPB_Enrollee_Caregiver__c> grandAccessButton() {
		try {
			//Enrolee caregiver contains a lookup field to a Care Program Enrollee,which is a Health Cloud object; 
		   //hence, we cannot utilize user mode here.
			List<BI_PSPB_Enrollee_Caregiver__c> ecList = [
				SELECT
					Id,
					BI_PSPB_Contact_Id__c,
					BI_PSPB_Contact_Id__r.BI_PSPB_GrantAccess__c,
					BI_PSPB_Status__c
				FROM BI_PSPB_Enrollee_Caregiver__c
				WHERE BI_PSPB_Patient__r.PersonEmail = :useremail
				LIMIT 1
			];
			if (!ecList.isEmpty()) {
				return ecList;
			} else {
               
				throw new AuraHandledException(recordcannotfound);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_exusergetaccid.class.toString(),
				null,
				System.now()
			);
            
			throw new AuraHandledException(recordcannotfound);
		}
	}

	/**
* @description: Retrieves a list of BI_PSPB_Enrollee_Caregiver__c records based on the current user's ID.
*               This method queries the BI_PSPB_Enrollee_Caregiver__c object to retrieve records related to the user's account.
				Enrolee caregiver contains a lookup field to a Care Program Enrollee,which is a Health Cloud object; 
				hence, we cannot utilize user mode here.return in lwc biPspbaddcaregiver
* @param      : none
* @return     : A list of BI_PSPB_Enrollee_Caregiver__c records associated with the user's account. 

*/
	@AuraEnabled(cacheable=true)
	public static List<BI_PSPB_Enrollee_Caregiver__c> getCaregiverDataView() {
		List<BI_PSPB_Enrollee_Caregiver__c> caregiverListData = new List<BI_PSPB_Enrollee_Caregiver__c>();
		try {
			Account acc = [
				SELECT Id, Name, PersonEmail
				FROM Account
				WHERE Name = :username AND PersonEmail = :useremail
				LIMIT 1
			];
            
			Id accountId = acc != null ? acc.Id : null;
           //Enrolee caregiver contains a lookup field to a Care Program Enrollee,which is a Health Cloud object; 
		   //hence, we cannot utilize user mode here.
			if (accountId != null) {
				caregiverListData = [
					SELECT
						Id,
						Name,
						BI_PSPB_Patient__r.Id,
						BI_PSPB_Contact_Id__c,
						BI_PSPB_Contact_Id__r.FirstName,
						BI_PSPB_Contact_Id__r.LastName,
						BI_PSPB_Contact_Id__r.Phone,
						BI_PSPB_Contact_Id__r.Email,
						BI_PSPB_Contact_Id__r.BI_PSPB_Relationship_To_Patient__c,
						BI_PSPB_Contact_Id__r.BI_PSPB_Birthdate__c,
						BI_PSPB_Caregiver__c
					FROM BI_PSPB_Enrollee_Caregiver__c
					WHERE BI_PSPB_Patient__c = :accountId
				];
			}
			if(!caregiverListData.isEmpty())
			{
				return caregiverListData;
			}else{
				throw new AuraHandledException(recordcannotfound);
			}
			
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_exusergetaccid.class.toString(),
				null,System.now()
			);
			throw new AuraHandledException(recordcannotfound);
		}
	}

	/**
* @description :This method retrieves the contact record associated with the caregiverId and updates the specified fields
				return in lwc biPspbaddcaregiver,all the wrapper class parameters null check in lwc 
* @param       :caregiverId The ID of the caregiver contact record to update.
* @param       :firstName The new first name of the caregiver.
* @param       :lastName The new last name of the caregiver.
* @param       :relationship The new relationship to the patient of the caregiver.
* @param       :phone The new phone number of the caregiver.
* @param       :email The new email address of the caregiver.
* @return      :A list containing the updated Contact record, or an empty list if the update fails.
*/

	@AuraEnabled
	public static list<Contact> updateCaregivers(
		BI_PSPB_CaregiverDetailsWrapper caregiverwrapper
	) {
		List<Contact> contactsToUpdate = new List<Contact>();
		try {
            if(caregiverwrapper !=null){
			// Retrieve the contact record to update
			Contact contactToUpdate = [
				SELECT
					Id,
					FirstName,
					LastName,
					Phone,
					BI_PSPB_Birthdate__c,
					Email,
					BI_PSPB_Relationship_To_Patient__c
				FROM Contact
				WHERE Id = :caregiverwrapper.accountId 
				LIMIT 1
			];

			contactToUpdate.FirstName = caregiverwrapper.FirstName;
			contactToUpdate.LastName = caregiverwrapper.LastName;
			contactToUpdate.BI_PSPB_Relationship_To_Patient__c = caregiverwrapper.relations;
			contactToUpdate.Phone = caregiverwrapper.phone;
			contactToUpdate.BI_PSPB_Birthdate__c = Date.valueOf(
				caregiverwrapper.PersonBirthdate
			);
			contactToUpdate.Email = caregiverwrapper.PersonEmail;
			contactsToUpdate.add(contactToUpdate);
			// Update the contact record

			Database.SaveResult[] saveResultthree = Database.update(
				contactsToUpdate,
				false
			);

			for (Database.SaveResult saveResult : saveResultthree) {
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +='Error ' +error.getFields() +'--' +
							error.getMessage() +'\n';
					}
				}
			}
			if (String.isNotBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
					saveResultthree,
					BI_PSPB_exuserGetAccid.class.toString(),
					System.now()
				);
				throw new AuraHandledException(recordcannotupdate);
			}
			if (!contactsToUpdate.isEmpty()) {
			return contactsToUpdate;
		} else {
			throw new AuraHandledException(recordcannotfound);
		}
            }else {
			throw new AuraHandledException(recordcannotfound);
		}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_exusergetaccid.class.toString(),
				null,System.now()
			);
			throw new AuraHandledException(recordcannotfound);
		}

		
	}
	/**

* @description This method updates various fields of the patient account identified by the accountId parameter
			   return in lwc biPspbCgPatientinfo all the wrapper class parameters null check in lwc 
* @param accountId The ID of the patient account to update.
* @param firstname The new first name of the patient.
* @param lastname The new last name of the patient.
* @param personEmail The new email address of the patient.
* @param personbirthdate The new birthdate of the patient.
* @param personGender The new gender of the patient.
* @param preferredmethodofcontact The new preferred method of contact for the patient.
* @param street The new street address of the patient.
* @param city The new city of the patient.
* @param state The new state of the patient.
* @param country The new country of the patient.
* @param postalCode The new postal code of the patient.
* @param phone The new phone number of the patient.
* @throws AuraHandledException if the account record with the specified accountId is not found.
*/
	@AuraEnabled
	public static void updatePatientExcistInfo(
		BI_PSPB_CaregiverDetailsWrapper wrapper
	) {
		try {
            if(wrapper !=null){
			List<Account> accountToUpdate = new List<Account>();
			// Query the account record
			List<Account> accValues = [
				SELECT
					Id,
					FirstName,
					LastName,
					PersonEmail,
					BI_PSP_Birthdate__c,
					BI_PSP_Age__c,
					PersonMobilePhone,
					Phone,
					HealthCloudGA__Gender__pc,
					BI_PSPB_Preferred_Communication_Method__c,
					PersonMailingAddress,
					PersonMailingCity,
					PersonMailingCountryCode,
					PersonMailingPostalCode,
					PersonMailingStateCode,
					PersonMailingStreet
				FROM Account
				WHERE Id = :wrapper.accountId 
				LIMIT 1
			];

			// Check if the account record exists
			if (!accValues.isEmpty()) {
				Account accValue = accValues[0]; // Get the first (and only) account record from the query result
				// Update the fields with new values
				accValue.FirstName = wrapper.FirstName;
				accValue.LastName = wrapper.LastName;
				accValue.PersonEmail = wrapper.PersonEmail;
				accValue.BI_PSP_Birthdate__c = wrapper.PersonBirthDate;
				accValue.HealthCloudGA__Gender__pc = wrapper.PersonGender;
				accValue.BI_PSPB_Preferred_Communication_Method__c = wrapper.PreferredMethodofContact;
				accValue.PersonMailingStreet = wrapper.street;
				accValue.PersonMailingCity = wrapper.city;
				accValue.PersonMailingStateCode = wrapper.state;
				accValue.PersonMailingCountryCode = wrapper.country;
				accValue.PersonMailingPostalCode = wrapper.postalCode;
				accValue.Phone = wrapper.phone;
				accountToUpdate.add(accValue); // Add the updated account to the list
			} else {
				// Handle the case where the account record is not found
				throw new AuraHandledException(recordcannotfound);
			}

			Database.SaveResult[] saveResultfour = Database.update(
				accountToUpdate,
				false
			);
			for (Database.SaveResult saveResult : saveResultfour) {
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg += 'Error ' + error.getFields() +
							'--' +error.getMessage() +'\n';
					}
				}
			}
			if (String.isNotBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
					saveResultfour,
					BI_PSPB_exuserGetAccid.class.toString(),
					System.now()
				);
				throw new AuraHandledException(recordcannotupdate);
			}
		}else {
			throw new AuraHandledException(recordcannotfound);
		}
        }catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,
				BI_PSPB_exusergetaccid.class.toString(),
				null,System.now()
			);
            throw new AuraHandledException(recordcannotfound);
		} // Date and time when the errors occurred
	}

	/**
*  @description This method updates various fields of the patient or caregiver account identified by the accountId parameter
                return in lwcbiPspbPatientProfiledetails all the wrapper class parameters null check in lwc 
* @param accountId The ID of the patient or caregiver account to update.
* @param firstname The new first name of the patient or caregiver.
* @param lastname The new last name of the patient or caregiver.
* @param personemail The new email address of the patient or caregiver.
* @param personbirthdate The new birthdate of the patient or caregiver.
* @param persongender The new gender of the patient or caregiver.
* @param preferredmethodofcontact The new preferred method of contact for the patient or caregiver.
* @param street The new street address of the patient or caregiver.
* @param city The new city of the patient or caregiver.
* @param state The new state of the patient or caregiver.
* @param country The new country of the patient or caregiver.
* @param postalCode The new postal code of the patient or caregiver.
* @param phone The new phone number of the patient or caregiver.
* @throws AuraHandledException if the account record with the specified accountId is not found.
*/
	@AuraEnabled
	public static void updatePatientorCargiverInfo(
		BI_PSPB_CaregiverDetailsWrapper wrapper
	) {
		try {
            if(wrapper !=null){
			List<Account> patientcargiverToUpdate = new List<Account>();
			// Query the account record
			List<Account> accountValues = [
				SELECT
					Id,
					FirstName,
					LastName,
					PersonEmail,
					BI_PSP_Birthdate__c,
					BI_PSP_Age__c,
					Phone,
					PersonMobilePhone,
					HealthCloudGA__Gender__pc,
					BI_PSPB_Preferred_Communication_Method__c,
					PersonMailingAddress,
					PersonMailingCity,
					PersonMailingCountryCode,
					PersonMailingPostalCode,
					PersonMailingStateCode,
					PersonMailingStreet
				FROM Account
				WHERE Id = :wrapper.accountId 
				LIMIT 1
			];
			// Check if the account record exists
			if (!accountValues.isEmpty()) {
				Account accValue = accountValues[0]; // Get the first (and only) account record from the query result
				// Update the fields with new values
				accValue.FirstName = wrapper.FirstName;
				accValue.LastName = wrapper.LastName;
				accValue.PersonEmail = wrapper.PersonEmail;
				accValue.BI_PSP_Birthdate__c = wrapper.PersonBirthDate;
				accValue.HealthCloudGA__Gender__pc = wrapper.PersonGender;
				accValue.BI_PSPB_Preferred_Communication_Method__c = wrapper.PreferredMethodofContact;
				accValue.PersonMailingStreet = wrapper.street;
				accValue.PersonMailingCity = wrapper.city;
				accValue.PersonMailingStateCode = wrapper.state;
				accValue.PersonMailingCountryCode = wrapper.country;
				accValue.PersonMailingPostalCode = wrapper.postalCode;
				accValue.Phone = wrapper.phone;
				patientcargiverToUpdate.add(accValue); // Add the updated account to the list
			} else {
				// Handle the case where the account record is not found
				throw new AuraHandledException(recordcannotfound);
			}
			Database.SaveResult[] saveResultfive = Database.update(
				patientcargiverToUpdate,
				false
			);
			for (Database.SaveResult saveResult : saveResultfive) {
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +=
							'Error ' + error.getFields() +
							'--' + error.getMessage() + '\n';
					}
				}
			}
			if (String.isNotBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
					saveResultfive,
					BI_PSPB_exuserGetAccid.class.toString(),
					System.now()
				);
				throw new AuraHandledException(recordcannotupdate);
			}
		} else {
			throw new AuraHandledException(recordcannotfound);
		}
        }catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_exusergetaccid.class.toString(),
				null,System.now()
			);
            throw new AuraHandledException(recordcannotfound);
		}
	}
	/**
* @description  Wrapper classes are used to hold a group of related data fields together.used to updateCaregivers,
                updateCaregiverDetails,updatePatientExcistInfo,updatePatientorCargiverInfo
* @param        accountId The ID of the patient or caregiver account to update.
* @param        firstname The new first name of the patient or caregiver.
* @param        lastname The new last name of the patient or caregiver.
* @param        personemail The new email address of the patient or caregiver.
* @param        personbirthdate The new birthdate of the patient or caregiver.
* @param        persongender The new gender of the patient or caregiver.
* @param        preferredmethodofcontact The new preferred method of contact for the patient or caregiver.
* @param        street The new street address of the patient or caregiver.
* @param        city The new city of the patient or caregiver.
* @param        state The new state of the patient or caregiver.
* @param        country The new country of the patient or caregiver.
* @param        postalCode The new postal code of the patient or caregiver.
* @param        phone The new phone number of the patient or caregiver.

*/
	public class BI_PSPB_CaregiverDetailsWrapper {
		@AuraEnabled
		public String accountId { get; set; }
		@AuraEnabled
		public String FirstName { get; set; }
		@AuraEnabled
		public String LastName { get; set; }
		@AuraEnabled
		public String PersonEmail { get; set; }
		@AuraEnabled
		public Date PersonBirthdate { get; set; }
		@AuraEnabled
		public String PersonGender { get; set; }
		@AuraEnabled
		public String PreferredMethodofContact { get; set; }
		@AuraEnabled
		public String street { get; set; }
		@AuraEnabled
		public String city { get; set; }
		@AuraEnabled
		public String state { get; set; }
		@AuraEnabled
		public String country { get; set; }
		@AuraEnabled
		public String postalCode { get; set; }
		@AuraEnabled
		public String phone { get; set; }
		@AuraEnabled
		public String relations { get; set; }
	}
}