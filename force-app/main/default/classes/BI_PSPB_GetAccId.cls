/*
 * @description   This class is designed to retrieve the Account ID and return it.
 * History:
 * Version	Author			Date			Detail				Description
 * 1.0		NandhaKumar	    05-01-2024  	Created				Initial development
 * 1.1		NandhaKumar 	04-Apr-2023		Updated				Catch log added
 */
public with sharing class BI_PSPB_GetAccId {
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
	 * @description : Retrieves account details based on the current user's ID, return in lwc biPspbPatientProfiledetails
	 * @param       : none
	 * @return      : The Account record corresponding to the user, or null if the user is not found or if no matching account
	                  is found.
	 */
	@AuraEnabled(cacheable=true)
	public static Account getAccDetails() {
		String useremail = UserInfo.getUserEmail();
		string username = UserInfo.getName();
		try {
			Account accRecords = [
				SELECT
					Id,
					FirstName,
					LastName,
					BI_PSP_Birthdate__c,
					HealthCloudGA__Gender__pc,
					PersonEmail,
					BI_PSP_Age__c,
					Phone,
					BI_PSPB_Preferred_Communication_Method__c,
					PersonMailingCountryCode,
					PersonMailingStateCode,
					PersonMailingCity,
					PersonMailingStreet,
					PersonMailingPostalCode
				FROM Account
				WHERE Name = :username AND PersonEmail = :useremail
				WITH USER_MODE
				LIMIT 1
			];

			if (accRecords != null) {
				return accRecords;
			} else {
				throw new AuraHandledException(recordcannotfound);
			}
			// No matching user or account found
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_GetAccId.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(recordcannotfound);
		}
	}
}