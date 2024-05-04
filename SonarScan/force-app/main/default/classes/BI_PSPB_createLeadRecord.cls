/*
 * @description We are using without sharing because of the Lead records are created by guestuser 
				profile the Enrollment Form.
 * History
 * Version	Author			Date		Detail		Description
 * 59		Niyas		06-01-2024		Created		Initial Version
 * 59		Niyas		18-04-2024		Updated		Code review changes
 */
public without sharing class BI_PSPB_createLeadRecord {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**
	 * @description Inserts a new lead record based on the provided values and creates a lead consent record.
	 * @param wrapper class A comma-separated string containing lead details.
	 * @param selectedValues The selected values for the lead's physician.
	 * @return The Id of the newly created lead record, or null if creation fails.
	 */
	@AuraEnabled
	public static Id insertLead(LeadWrapper leadWrapper) {
		//We are not checking LeadWrapper because all fields are mandatory in UI.
		try {
			String errorMsg = '';
			Lead leadToInsert = new Lead(
				FirstName = leadWrapper.firstName,
				LastName = leadWrapper.lastnamelll,
				HealthCloudGA__BirthDate__c = Date.valueOf(leadWrapper.dob),
				HealthCloudGA__Gender__c = leadWrapper.gender,
				Email = leadWrapper.email,
				Phone = leadWrapper.phone,
				BI_PSPB_Preferred_Communication_Method__c = leadWrapper.pmc,
				CountryCode = leadWrapper.country,
				StateCode = leadWrapper.state,
				City = leadWrapper.city,
				Street = leadWrapper.street,
				PostalCode = leadWrapper.zipCode,
				BI_PSPB_Physician_Name_c__c = leadWrapper.selectedPrescription,
				BI_PSPB_Enrolled_By__c = BI_PSPB_constantsClass.patientCaregiver
			);
			Database.SaveResult saveResult = Database.insert(
				leadToInsert,
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
					saveResultList,BI_PSPB_createLeadRecord.class.toString(),System.now()
				);
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgInsert
				);
			}
			BI_PSP_Lead_Consent__c leadConsentToInsert = new BI_PSP_Lead_Consent__c(
				BI_PSP_Lead__c =  leadToInsert.Id,
				BI_PSPB_Consent_Category__c = BI_PSPB_constantsClass.patient,
				BI_PSP_I_agree__c = true
			);
			Database.SaveResult consentSaveResult = Database.insert(
				leadConsentToInsert,
				false
			);
			if (!consentSaveResult.isSuccess()) {
				for (Database.Error error : consentSaveResult.getErrors()) {
					errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
				}
			}
			if (String.isNotBlank(errorMsg)) {
				List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
				saveResultList.add(consentSaveResult);
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
					saveResultList,BI_PSPB_createLeadRecord.class.toString(),System.now()
				);
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgInsert
				);
			}
			return leadToInsert.Id;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_createLeadRecord.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 * @description Retrieves a list of lead gender options.
	 * @return A list containing gender options for lead records: 'Email', 'Phone', 'SMS'.
	 */
	@AuraEnabled(cacheable=true)
	public static List<String> getCommunicationOptions() {
		try {
			return new List<String>{
				BI_PSPB_constantsClass.email,
				BI_PSPB_constantsClass.phone,
				BI_PSPB_constantsClass.sms
			};
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_createLeadRecord.class.toString(),
				null,System.now()
			);
			throw new AuraHandledException(
				BI_PSPB_constantsClass.recordcannotfound
			);
		}
	}
	/**
	 * @description Get HCP record prepopulate thankyou message form.
	 * @return The HCP record return value passing lwc form.
	 */
	@AuraEnabled(cacheable=true)
	public static list<Lead> getHcpRecord(String leadId) {
		try {
			if (String.isBlank(leadId)) {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgRecordNotFound
				); // Return null if leadId is blank
			}
			// This is regarding to guestuser so can't use User_mode.
			// Query the Lead records along with related Physician information
			List<Lead> leadRecords = [
				SELECT
					Id,
					BI_PSPB_Physician_Name_c__r.FirstName,
					BI_PSPB_Physician_Name_c__r.LastName,
					BI_PSPB_Physician_Name_c__r.BI_PSPB_Preferred_Communication_Method__c,
					BI_PSPB_Physician_Name_c__r.Email,
					BI_PSPB_Physician_Name_c__r.Phone,
					BI_PSPB_Physician_Name_c__r.BI_PSPB_Address_Line__c
				FROM Lead
				WHERE Id = :leadId
				LIMIT 1
			];
			if (leadRecords.isEmpty()) {
				throw new AuraHandledException(
					BI_PSPB_constantsClass.errorMsgRecordNotFound
				);
			}
			return leadRecords;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_createLeadRecord.class.toString(),
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
	 * updatePatientExcistInfo,updatePatientorCargiverInfo.
	 * @param firstname The new first name of the patient or caregiver.
	 * @param lastname The new last name of the patient or caregiver.
	 * @param email The new email address of the patient or caregiver.
	 * @param dob The new birthdate of the patient or caregiver.
	 * @param gender The new gender of the patient or caregiver.
	 * @param pmc The new preferred method of contact for the patient or caregiver.
	 * @param street The new street address of the patient or caregiver.
	 * @param city The new city of the patient or caregiver.
	 * @param state The new state of the patient or caregiver.
	 * @param country The new country of the patient or caregiver.
	 * @param postalCode The new postal code of the patient or caregiver.
	 * @param phone The new phone number of the patient or caregiver.
	 * @param selectedPrescription The new phone number of the patient or caregiver.
	 */
	public class LeadWrapper {
		@AuraEnabled
		public String firstName { get; set; }
		@AuraEnabled
		public String lastnamelll { get; set; }
		@AuraEnabled
		public String dob { get; set; }
		@AuraEnabled
		public String gender { get; set; }
		@AuraEnabled
		public String email { get; set; }
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
		@AuraEnabled
		public String selectedPrescription { get; set; }
	}
}