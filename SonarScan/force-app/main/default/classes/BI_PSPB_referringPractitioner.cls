/*
 * @description This class is used for guest users, which is why it is not shared. It is used to retrieve data from the Name from Contact objects.
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023     Created             Initial development
 * 1.1      Ashif  04-Apr-2024     Updated             Catch log added
 */
public without sharing class BI_PSPB_referringPractitioner {
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
private static String applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c: '';
	//custom
	private static String BI_PSPB_Physician = System.Label.BI_PSPB_PhysicianRecordtype;
	private static String Active = System.Label.BI_PSPB_Active;
	private static String errorForThrow = System.Label.BI_PSP_ConsoleError;

/*  
@description    	 Used to fecth the Physisan Name of the contact, return in lwc biPspbHcpEnrollement
@return         	 Return Physisan Name 
*/
	@AuraEnabled(cacheable=true)
	public static List<Contact> getPractitionerList() {
		List<Contact> practitionerList = new List<Contact>();
		try {
			Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(BI_PSPB_Physician).getRecordTypeId();
			// Since this object is invoked from a Guest User Profile which has limited access, User Mode cannot be used here
			// This is a searchable combo box. If the Aura Enabled Exception is thrown, for every character search, the error 
			// will be displayed that disrupts the screen design. 
            //In the respective LWC, the error message is displayed as 'Unable to find' below the combo box input field 
            //(that will be visible to the user)  if the record is not found.
			practitionerList = [
				SELECT Id, Name, BI_PSPB_Specialist__c, MailingCity FROM Contact WHERE RecordType.Id = :recordTypeId
					AND HealthCloudGA__StatusGroup__c = :Active
			];
            // This is a searchable combo box. If the Aura Enabled Exception is thrown, for every character search, the error 
			// will be displayed that disrupts the screen design. 
            //In the respective LWC, the error message is displayed as 'Unable to find' below the combo box input field 
            //(that will be visible to the user)  if the record is not found.
		} catch (Exception ex) {BI_SFCOE_LOG_Util.handleException
            (ex,applicationName,BI_PSPB_referringPractitioner.class.toString(),null,System.now());
            // Returning null if an exception occurs
			// Handling error in Lwc
			return null;
		}
		return practitionerList;
	}
}