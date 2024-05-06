/*
* @description   This class provides methods for fetching caregiver ID, patient details, 
                 and updating patient information.and return a list of gender options. 
* History:
* Version	Author			Date			Detail				Description
* 1.0		NandhaKumar	    05-01-2024  	Created				Initial development
* 1.1		NandhaKumar 	04-Apr-2023		Updated				Catch log added
*/

public with sharing class BI_PSPB_PatientFormCtrl {
	// Custom Error message label
	private static String recordcannotfound = System.Label.BI_PSP_record_not_found_error_message;
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System

	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**
*  @description  Retrieves patient details based on the current user's ID. 
                 return in lwc biPspbCgPatientinfo,biPspbPatientProfiledetails.
* @return A retrun account value .
*/
	@AuraEnabled(cacheable=true)
	public static Account getPatientInfo() {
		String useremail = UserInfo.getUserEmail();
		string username = UserInfo.getName();
		try {
			List<Account> AccList = [
				SELECT
					Id,
					FirstName,
					LastName,
					PersonEmail,
					BI_PSPB_Selected_Patient_ID__c
				FROM Account
				WHERE Name = :username AND PersonEmail = :useremail
				WITH USER_MODE
				LIMIT 1
			];

			if (!AccList.isEmpty()) {
				List<Account> Accvalue = [
					SELECT
						Id,
						FirstName,
						LastName,
						PersonEmail,
						BI_PSP_Birthdate__c,
						BI_PSP_Age__c,
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
					WHERE Id = :AccList[0].BI_PSPB_Selected_Patient_ID__c
					WITH USER_MODE
					LIMIT 1
				];
				if (!Accvalue.isEmpty()) {
					return Accvalue[0];
				} else {
					throw new AuraHandledException(recordcannotfound);
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PatientFormCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(recordcannotfound);
		}
		return null;
	}

}