/*
 * @description This BI_PSPB_ScheduleLeadConversion class used to Schedule to Lead convert
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023              Created             Initial development
 */
public with sharing class BI_PSPB_scheduleLeadConversion implements Schedulable {
	//custom Labels
	private static String patientQualified = System.Label.BI_PSPB_PatientQualified;
	private static String errormsg = System.Label.BI_PSPB_error;
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
	private static String applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';

/*
@description Define the cron expression within the execute method
@param SchedulableContext - Represents the parameter type of a method in a class that implements the Schedulable interface
*/
	public void execute(SchedulableContext SC) {
		try {
			// Fetch qualified leads with status 'PatientQualified'
			List<Lead> qualifiedLeads = [
				SELECT Id, Name, Status
				FROM Lead
				WHERE
					Status = :patientQualified
					AND IsConverted = FALSE
					AND CreatedDate = TODAY
				WITH USER_MODE
			];

			List<Id> qualifiedLeadsIds = new List<Id>();
			// Loop through the leads and collect their IDs
			for (Lead lead : qualifiedLeads) {
				qualifiedLeadsIds.add(lead.Id);
			}

			// Check if there are qualified leads before attempting to convert them
			if (!qualifiedLeadsIds.isEmpty()) {
				// Call the lead conversion handler to perform lead conversion
				BI_PSPB_LeadConvertMultiple.convertlead(qualifiedLeadsIds);
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_scheduleLeadConversion.class.toString(),
					'',
					System.now(),
					errorMsg,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_scheduleLeadConversion.class.toString(),null,
				System.now());
		}
	}
}