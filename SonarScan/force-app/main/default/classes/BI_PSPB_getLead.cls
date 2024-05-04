/*
 * @description We are using without sharing because of the Lead records are created by guestuser 
				profile the Enrollment Form.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public without sharing class BI_PSPB_getLead {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String BI_PSPB_Physician = System.Label.BI_PSPB_PhysicianRecordtype;
	/**
	 * @description Retrieves a Lead Caregiver record based on the Lead Id.
	 * @param leadId The Id of the Lead record.
	 * @return The Lead Caregiver record.
	 */
	@AuraEnabled(cacheable=true)
	public static BI_PSPB_Lead_Caregiver__c getEnrolleeCaregiverId(string leadId) {
		if (String.isBlank(leadId)) {
			throw new AuraHandledException(
				BI_PSPB_constantsClass.errorMsgRecordNotFound
			); // Return null if leadId is blank
		}
		try {
			// This is regarding to guestuser so can't use User_mode.
			BI_PSPB_Lead_Caregiver__c leadCg = new BI_PSPB_Lead_Caregiver__c();
			leadCg = [
				SELECT
					Id,
					BI_PSPB_First_Name__c,
					BI_PSPB_Last_Name__c,
					BI_PSPB_Date_of_Birth__c,
					BI_PSPB_Preferred_Communication_Method__c,
					BI_PSPB_E_mail_ID__c,
					BI_PSPB_Phone_number__c,
					BI_PSPB_Lead__c,
					BI_PSPB_Lead__r.BI_PSPB_Do_you_have_an_HCP_Access_Code__c,
					BI_PSPB_Relationship_to_Patient__c,
					BI_PSPB_Lead__r.BI_PSPB_HCP_Access_Code__c
				FROM BI_PSPB_Lead_Caregiver__c
				WHERE BI_PSPB_Lead__r.Id = :leadId
				LIMIT 1
			];
			if (leadCg != null) {
				return leadCg;
			} else {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.recordcannotfound
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 *@description Retrieves a Lead record based on the first name, last name, and date of birth.
	 * @param firstName The first name of the Lead.
	 * @param lastName The last name of the Lead.
	 * @param dob The date of birth of the Lead.
	 * @return The Lead record matching the criteria, or null if not found.
	 */
	@AuraEnabled(cacheable=true)
	public static Lead leadId(String firstName, String lastName, Date dob) {
		if (
			String.isBlank(firstName) ||
			String.isBlank(lastName) ||
			dob == null
		) {
			throw new AuraHandledException(
				BI_PSPB_constantsClass.errorMsgRecordNotFound
			);
		}
		try {
			// This is regarding to guestuser so can't use User_mode.
			Lead leadRecord = new Lead();
			leadRecord = [
				SELECT
					Id,
					FirstName,
					LastName,
					HealthCloudGA__BirthDate__c,
					HealthCloudGA__Gender__c,
					Email,
					Phone
				FROM Lead
				WHERE
					FirstName = :firstName
					AND LastName = :lastName
					AND HealthCloudGA__BirthDate__c = :dob
				LIMIT 1
			];
			if (leadRecord != null) {
				return leadRecord;
			} else {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.recordcannotfound
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 *@description Retrieves a Lead record based on the Lead Id.
	 * @param leadId The Id of the Lead record to retrieve.
	 * @return The Lead record matching the provided Lead Id, or null if not found.
	 */
	@AuraEnabled(cacheable=true)
	public static Lead getLeadId(String leadId) {
		if (String.isBlank(leadId)) {
			throw new AuraHandledException(
				BI_PSPB_constantsClass.errorMsgRecordNotFound
			); // Return null if leadId is blank
		}
		try {
			// This is regarding to guestuser so can't use User_mode.
			return [
				SELECT
					Id,
					FirstName,
					LastName,
					HealthCloudGA__BirthDate__c,
					HealthCloudGA__Gender__c,
					Email
				FROM Lead
				WHERE Id = :leadId
				LIMIT 1
			];
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 *@description Retrieves a Lead Prescription record based on the Lead Id.
	 * @param leadId The Id of the Lead associated with the Lead Prescription record to retrieve.
	 * @return The Lead Prescription record matching the provided Lead Id, or null if not found.
	 */
	@AuraEnabled(cacheable=true)
	public static BI_PSPB_Lead_Prescription__c getLeadPresId(String leadId) {
		if (String.isBlank(leadId)) {
			throw new AuraHandledException(
				BI_PSPB_constantsClass.errorMsgRecordNotFound
			); // Return null if leadId is blank
		}
		try {
			// This is regarding to guestuser so can't use User_mode.
			return [
				SELECT
					Id,
					BI_PSPB_Prescribed_Date__c,
					BI_PSPB_Frequency_Unit__c,
					BI_PSPB_Lead__c
				FROM BI_PSPB_Lead_Prescription__c
				WHERE BI_PSPB_Lead__c = :leadId
				LIMIT 1
			];
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 * @description Updates the Lead Caregiver record with the preferred method of communication and inserts a new Lead Consent record.
	 * @param leadId The Id of the Lead Caregiver to update.
	 * @param PreferredMethodofCommunication The preferred method of communication for the Lead Caregiver.
	 * @param patientorcaregiver Indicates whether the consent is for the patient or caregiver.
	 */

	@AuraEnabled(cacheable=false)
	public static void updateLead(
		String leadId,
		String PreferredMethodofCommunication
	) {
		try {
			String errorMsg = '';
			if (
				String.isBlank(leadId) ||
				String.isBlank(PreferredMethodofCommunication)
			) {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgRecordNotFound
				);
			}
			// Update Lead Caregiver
			// This is regarding to guestuser so can't use User_mode.
			BI_PSPB_Lead_Caregiver__c leadCaregiverToUpdate = [
				SELECT
					Id,
					BI_PSPB_Preferred_Communication_Method__c,
					BI_PSPB_Lead__c
				FROM BI_PSPB_Lead_Caregiver__c
				WHERE BI_PSPB_Lead__c = :leadId
				LIMIT 1
			];
			if (leadCaregiverToUpdate != null) {
				// Insert Lead Consent
				BI_PSP_Lead_Consent__c leadConsentToInsert = new BI_PSP_Lead_Consent__c();
				leadConsentToInsert.BI_PSP_Lead__c = leadCaregiverToUpdate.BI_PSPB_Lead__c;
				leadCaregiverToUpdate.BI_PSPB_Preferred_Communication_Method__c = PreferredMethodofCommunication;
				leadConsentToInsert.BI_PSPB_Consent_Category__c = BI_PSPB_constantsClass.caregiver;
				// Perform the update operation
				Database.SaveResult saveResult = Database.update(
					leadCaregiverToUpdate,
					false
				);
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +=
							'Error ' +
							error.getFields() +
							'--' +
							error.getMessage() +
							'\n';
					}
				}
				if (String.isNotBlank(errorMsg)) {
					List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
					saveResultList.add(saveResult);
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResultList,
						BI_PSPB_getLead.class.toString(),
						System.now()
					);
					throw new AuraHandledException(
						BI_PSPB_constantsClass.errorMsgUpdate
					);
				}
				Database.SaveResult saveResults = Database.insert(
					leadConsentToInsert,
					false
				);
				if (!saveResults.isSuccess()) {
					for (Database.Error error : saveResults.getErrors()) {
						errorMsg +=
							'Error ' +
							error.getFields() +
							'--' +
							error.getMessage() +
							'\n';
					}
				}
				if (String.isNotBlank(errorMsg)) {
					List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
					saveResultList.add(saveResult);
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResultList,
						BI_PSPB_getLead.class.toString(),
						System.now()
					);
					throw new AuraHandledException(
						BI_PSPB_constantsClass.errorMsgInsert
					);
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}

	/**
	 *  @description Inserts a new Lead Consent record or updates an existing one.
	 * @param leadId The Id of the Lead associated with the consent.
	 * @param consentCategory The category of consent.
	 */
	@AuraEnabled(cacheable=false)
	public static void insertupdateLeadConsent(
		String leadId,
		String consentCategory
	) {
		try {
			String errorMsg = '';
			if (String.isBlank(leadId) || String.isBlank(consentCategory)) {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgRecordNotFound
				);
			}
			BI_PSP_Lead_Consent__c leadConsentToInsert = new BI_PSP_Lead_Consent__c();
			leadConsentToInsert.BI_PSP_Lead__c = leadId;
			leadConsentToInsert.BI_PSPB_Consent_Category__c = consentCategory;
			Database.SaveResult saveResult = Database.insert(
				leadConsentToInsert,
				false
			);
			if (!saveResult.isSuccess()) {
				for (Database.Error error : saveResult.getErrors()) {
					errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
				}
			}
			if (String.isNotBlank(errorMsg)) {
				List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
				saveResultList.add(saveResult);
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
					saveResultList,BI_PSPB_getLead.class.toString(),System.now()
				);
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgInsert
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 * @description Updates the Lead record and inserts a Lead Consent record.
	 * @param LeadWrapper A Wrapper class containing updated values for the Lead record.
	 */
	@AuraEnabled(cacheable=false)
	public static void updateLeadRecord(LeadWrapper leadWrapper) {
		//We are not checking LeadWrapper because all fields are mandatory in UI.
		String errorMsg = '';
		try {
			// This is regarding to guestuser so can't use User_mode.
			Lead leadToUpdate = [
				SELECT
					Id,
					Phone,
					BI_PSPB_Preferred_Communication_Method__c,
					Country,
					State,
					City,
					Street,
					PostalCode
				FROM Lead
				WHERE Id = :leadWrapper.leadId
				LIMIT 1
			];
			if (leadToUpdate != null) {
				leadToUpdate.Phone = leadWrapper.phone;
				leadToUpdate.BI_PSPB_Preferred_Communication_Method__c = leadWrapper.pmc;
				leadToUpdate.CountryCode = leadWrapper.country;
				leadToUpdate.StateCode = leadWrapper.state;
				leadToUpdate.City = leadWrapper.city;
				leadToUpdate.Street = leadWrapper.street;
				leadToUpdate.PostalCode = leadWrapper.zipCode;
				BI_PSP_Lead_Consent__c leadConsentToInsert = new BI_PSP_Lead_Consent__c(
					BI_PSP_Lead__c = leadToUpdate.Id,
					BI_PSP_I_agree__c = true,
					BI_PSPB_Consent_Category__c = BI_PSPB_constantsClass.patient,
					BI_PSPB_Conversion__c = true
				);
				Database.SaveResult saveResult = Database.update(
					leadToUpdate,
					false
				);
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +=
							'Error ' +
							error.getFields() +
							'--' +
							error.getMessage() +
							'\n';
					}
				}
				if (String.isNotBlank(errorMsg)) {
					List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
					saveResultList.add(saveResult);
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResultList,
						BI_PSPB_getLead.class.toString(),
						System.now()
					);
					throw new AuraHandledException(
						BI_PSPB_constantsClass.errorMsgUpdate
					);
				}
				Database.SaveResult saveResults = Database.insert(
					leadConsentToInsert,
					false
				);
				if (!saveResults.isSuccess()) {
					for (Database.Error error : saveResults.getErrors()) {
						errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
					}
				}
				if (String.isNotBlank(errorMsg)) {
					List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
					saveResultList.add(saveResult);
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResultList,BI_PSPB_getLead.class.toString(),System.now()
					);
					throw new AuraHandledException(
						BI_PSPB_constantsClass.errorMsgInsert
					);
				}
			} else {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgRecordNotFound
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 *  @description Updates the Lead record with caregiver information and inserts a Lead Consent record.
	 * @param LeadWrapper A Wrapper class containing updated values for the Lead record.
	 */

	@AuraEnabled
	public static void updateLeadCareRecord(LeadWrapper leadWrapper) {
		//We are not checking LeadWrapper because all fields are mandatory in UI.
		try {
			String errorMsg = '';
			// This is regarding to guestuser so can't use User_mode.
			Lead leadToUpdate = [
				SELECT
					Id,
					Phone,
					BI_PSPB_Preferred_Communication_Method__c,
					Country,
					State,
					City,
					Street,
					PostalCode
				FROM Lead
				WHERE Id = :leadWrapper.leadId
				LIMIT 1
			];
			if (leadToUpdate != null) {
				leadToUpdate.Id = leadWrapper.leadId;
				leadToUpdate.CountryCode = leadWrapper.country;
				leadToUpdate.StateCode = leadWrapper.state;
				leadToUpdate.City = leadWrapper.city;
				leadToUpdate.Street = leadWrapper.street;
				leadToUpdate.PostalCode = leadWrapper.zipCode;
				Database.SaveResult saveResult = Database.update(
					leadToUpdate,
					false
				);
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
					}
				}
				if (String.isNotBlank(errorMsg)) {
					List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
					saveResultList.add(saveResult);
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResultList,BI_PSPB_getLead.class.toString(),System.now()
					);
					throw new AuraHandledException(
						BI_PSPB_constantsClass.errorMsgInsert
					);
				}
			} else {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgRecordNotFound
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}

	/**
	 *  @description Creates a new Contact record for a healthcare professional (HCP).
	 * @param firstName The first name of the HCP.
	 * @param lastName The last name of the HCP.
	 * @param phone The phone number of the HCP.
	 * @param email The email address of the HCP.
	 * @return The Id of the newly created Contact record.
	 */
	@AuraEnabled
	public static Id hcpCreate(
		String firstName,
		String lastName,
		String phone,
		String email
	) {
		try {
			if (
				String.isBlank(firstName) ||
				String.isBlank(lastName) ||
				String.isBlank(phone) ||
				String.isBlank(email)
			) {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgRecordNotFound
				);
			}
			String createdContactId;
			String recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
				.get(BI_PSPB_Physician)
				.getRecordTypeId();
			String errorMsg = '';
			if (String.isBlank(recordTypeId)) {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgRecordNotFound
				); // Return null if leadId is blank
			}
			Contact newContact = new Contact(
				FirstName = firstName,
				LastName = lastName,
				Phone = phone,
				Email = email,
				RecordTypeId = recordTypeId // Set the appropriate Record Type Id
			);
			Database.SaveResult saveResult = Database.insert(newContact, false);
			if (saveResult.isSuccess()) {
				createdContactId = newContact.Id;
			} else {
				for (Database.Error error : saveResult.getErrors()) {
					errorMsg +=
						'Error ' +
						error.getFields() +
						'--' +
						error.getMessage() +
						'\n';
				}
			}
			if (String.isNotBlank(errorMsg)) {
				List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
				saveResultList.add(saveResult);
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
					saveResultList,
					BI_PSPB_getLead.class.toString(),
					System.now()
				);
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgInsert
				);
			}
			return createdContactId;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 * @description Retrieves the Contact record associated with the specified access code.
	 * @param accessCode The access code used to retrieve the Contact record.
	 * @return The Contact record matching the access code, or null if not found.
	 */
	@AuraEnabled(cacheable=true)
	public static Contact hcpAccessCode(String accessCode) {
		if (String.isBlank(accessCode)) {
			throw new AuraHandledException(
				BI_PSPB_constantsClass.errorMsgRecordNotFound
			); // Return null if leadId is blank
		}
		try {
			// This is regarding to guestuser so can't use User_mode.
			return [
				SELECT Id
				FROM Contact
				WHERE
					BI_PSPB_Access_Code__c = :accessCode
					AND HealthCloudGA__StatusGroup__c = :BI_PSPB_constantsClass.ACTION_TYPE_Active
				LIMIT 1
			];
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 * @description Retrieves a list of Care Program Enrollees based on the provided first name and last name of the account.
	 * @param firstName The first name of the account associated with the Care Program Enrollees.
	 * @param lastName The last name of the account associated with the Care Program Enrollees.
	 * @return A list of Care Program Enrollees matching the provided first name and last name, or an empty list if none are found.
	 */
	@AuraEnabled(cacheable=true)
	public static List<CareProgramEnrollee> verifyUnassign(
		String firstName,
		String lastName
	) {
		if (String.isBlank(firstName) || String.isBlank(lastName)) {
			throw new AuraHandledException(
				BI_PSPB_constantsClass.errorMsgRecordNotFound
			);
		}
		try {
			// This is regarding to guestuser so can't use User_mode.
			List<CareProgramEnrollee> enrollees = [
				SELECT
					Id,
					Account.FirstName,
					Account.LastName,
					Account.HealthCloudGA__Gender__pc,
					Account.PersonEmail,
					BI_PSP_User_Type__c,
					BI_PSPB_PatientStatus__c
				FROM CareProgramEnrollee
				WHERE
					Account.FirstName = :firstName
					AND Account.LastName = :lastName
			];
			if (enrollees.isEmpty()) {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgRecordNotFound
				); // Throw exception if newCase is null
			}
			return enrollees;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_getLead.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
 	 * @description  Wrapper classes are used to hold a group of related data fields together.used to updateCaregivers,updateCaregiverDetails
					updatePatientExcistInfo,updatePatientorCargiverInfo.
	 * @param leadId The upate leadId of the patient or caregiver.
	 * @param pmc The new preferred method of contact for the patient or caregiver.
	 * @param street The new street address of the patient or caregiver.
	 * @param city The new city of the patient or caregiver.
	 * @param state The new state of the patient or caregiver.
	 * @param country The new country of the patient or caregiver.
	 * @param zipCode The new postal code of the patient or caregiver.
	 * @param phone The new phone number of the patient or caregiver.
	 */
	public class LeadWrapper {
		@AuraEnabled
		public String leadId { get; set; }
		@AuraEnabled
		public String phone { get; set; }
		@AuraEnabled
		public String pmc { get; set; }
		@AuraEnabled
		public String country { get; set; }
		@AuraEnabled
		public String state { get; set; }
		@AuraEnabled
		public String city { get; set; }
		@AuraEnabled
		public String street { get; set; }
		@AuraEnabled
		public String zipCode { get; set; }
	}
}