/*
 * @description This BI_PSPB_treatmentvideocmd class is retrieves video URLs and patient status (chronic/acute/unassigned) for the Information Center
 * History:
 * Version	Author			Date			Detail				Description
 * 1.0		Gokul Krishnan	05-Nov-2023		Created				Initial development
 * 1.1		Gokul Krishnan 	01-Dec-2023		Updated				Updated the patient status retrieve
 * 1.2		Gokul Krishnan	04-Apr-2024		Updated				Catch log added
 */
public with sharing class BI_PSPB_treatmentvideocmd {
	// Care program Enrollee Id of patient
	private static string careProgramEnrolleRecordId;
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
	private static string applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	// Custom Error message label

	// Custom label for chronic status
	private static String chronicStatus = System.Label.BI_PSPB_statusChronic;
	// Custom label for Unassigned status
	private static String unassignedStatus = System.Label.BI_PSP_Unassigned;
	// Custom label for Error message
	private static String errorTreatmentVideoRetrieve = System.Label.BI_PSP_TreatmentVideoRetrieveError;
	private static String errorPatientStatus = System.Label.BI_PSP_ErrorPatientStatusRetrieve;
	private static String enrolleNotFoundError = System.Label.BI_PSP_Enrollee_NF_NS;

	/*
 *@description   Retrieve the video Url from BI_PSPB_Treatment_videos__c custom object
				 It return in lwc biPspbtreatmentvideosprevention, biPspbtreatmentvideos
 *@param         none 
 *@return        return the url of video from BI_PSPB_Treatment_videos__c object as List<string>
					
 */
	@AuraEnabled(cacheable=true)
	public static List<BI_PSPB_Treatment_videos__c> getRecords() {
		try {
			List<BI_PSPB_Treatment_videos__c> treatmenturls = [
				SELECT Id, BI_PSPB_URL__c
				FROM BI_PSPB_Treatment_videos__c
				WITH USER_MODE
				LIMIT 10
			];
			if (!treatmenturls.isEmpty()) {
				return treatmenturls;
			} else {
				throw new AuraHandledException(errorTreatmentVideoRetrieve);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_treatmentvideocmd.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorTreatmentVideoRetrieve);
		}
	}

	/*
 *@description      Get the patient status value based on current user
					return in lwc biPspbarticlecontentpage, biPspbarticlenavlinksearch, biPspbarticlenavlinkspage,
					biPspbArticlesForDashboard, biPspbcategoryarticlecmp, biPspbcontentarticlecmp, biPspbcontentmessage,
					biPspbInformationcenterlanding, biPspblandinginfocentercmp, biPspblandingpagemessage,
					biPspbpersonalisationmessage, biPspbrecentarticles, biPspbsearcharticlecmp, biPspbsearchmessage,
					biPspbNavigationBar
 *@return           Return the patient status (chronic, acute, unassigned ) as String			  
 */
	@AuraEnabled(cacheable=true)
	public static String patientStatus() {
		try {
			Id careProgramEnrolleRecordId = BI_PSPB_PersonalizedMessagesCtrl.getCareProgramEnrolleId();
			// user mode is not enabled because careprogram Enrollee is health cloud object
			List<CareProgramEnrollee> careProgramEnrolleeRecord = [
				SELECT BI_PSPB_PatientStatus__c
				FROM CareProgramEnrollee
				WHERE Id = :careProgramEnrolleRecordId
				LIMIT 1
			];

			//Check if a record was found
			if (!careProgramEnrolleeRecord.isEmpty()) {
				//Return the value of BI_PSPB_PatientStatus__c
				if (
					careProgramEnrolleeRecord[0].BI_PSPB_PatientStatus__c !=
					null
				) {
					return careProgramEnrolleeRecord[0]
						.BI_PSPB_PatientStatus__c;
				} else {
					// Return unassigned or a default value if no record is found
					return unassignedStatus;
				}
			} else {
				throw new AuraHandledException(enrolleNotFoundError);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_treatmentvideocmd.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorPatientStatus);
		}
	}
}