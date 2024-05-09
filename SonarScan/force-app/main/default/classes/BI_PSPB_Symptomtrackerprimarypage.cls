/**
Apex Class Name   	BI_PSPB_Symptomtrackerprimarypage
Created Date         06.12.2023
@description        This class is used for inserting and updating symptom records such as allergy intolerance
				     and also deletin records in symptom records.
                      When a class is declared with "without sharing," it allows the code in that class to access and manipulate records even if the user 
	                  running the code does not have the necessary permissions based on the organization's sharing settings or record-level security.	 
       
@author             Karthikeyan.P
Modification Log
Ver   Date         Author                               Modification
59   08-04-2024   Karthikeyan.P.                     Initial Version
*/

public without sharing class BI_PSPB_Symptomtrackerprimarypage {
	private static String error = System.Label.BI_PSP_ConsoleError;
	private static String errorMsg = '';
	private static String Symptomerrormsg = System.Label.BI_PSP_Symptomtrackererrormsg;
	public static String symptomTrackerInactive = System.Label.BI_PSPB_enrolleeCaregiverStatusInactive;
	private static String Careprogramerrormsg = System.Label.BI_PSP_Careprogramerrormsg;
	private static String latestrecord = System.Label.BI_PSP_Latestrecord;
	private static String Deleterecord = System.Label.BI_PSP_Changeinactivestaus;
	private static String Applicationphotomsg = System.Label.BI_PSP_Applicationphotomsg;
	private static String Alleryrecord = System.Label.BI_PSP_Allerydatas;
    private static String Stauschange = System.Label.BI_PSP_SymptomUpdatestatus;
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
	private static string applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';

	/**
		
		@description     Method to retrieve symptom record data based on symptomTrackerId
                         USER_MODE cannot be implemented here, as it is querying health cloud object.
		@param           symptomTrackerId  The ID of the user for whom the symptoms are to be displayed.
		@return			 Returns all symptom tracking records for the current user.this values return pass to biPspbSymptomPrimarypage
		*/
	@AuraEnabled(cacheable=true)
	public static List<BI_PSP_Symptom_Tracker__c> getsymptomrecorddata(
		String symptomTrackerId
	) {
		List<BI_PSP_Symptom_Tracker__c> primaryPageSymptom = new List<BI_PSP_Symptom_Tracker__c>();
		try {
			if (String.isBlank(symptomTrackerId)) {
				return null;
			} else {
				primaryPageSymptom = [
					SELECT
						Id,
						BI_PSP_EditEntrydates__c,
						BI_PSP_Patient__c,
						BI_PSP_Recent_Activities__c,
						BI_PSP_Are_you_currently_experiencing__c,
						BI_PSP_Care_Program_Enrollee__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE Id = :symptomTrackerId
					LIMIT 1
				]; //USER_MODE cannot be implemented here, as it is querying health cloud object.
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_Symptomtrackerprimarypage.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorMsg);
		}
		if (primaryPageSymptom.isEmpty()) {
			throw new AuraHandledException(Symptomerrormsg);
		} else {
			return primaryPageSymptom;
		}
	}

	/**
		
		@description     Method to retrieve allergy intolerance data based on symptomTrackerId
		@param           symptomTrackerId  The ID of the user who currently logged in.
		@return          Returns all allergy intolerance records.this values return pass to biPspbItchiness,biPspbFatiguesymptom
		                 biPspbMood,biPspbTemperaturesymtom,biPspbPainsymptom,biPspbRednesssymptom,biPspbPustulessymptom
		*/
	@AuraEnabled(cacheable=true)
	public static List<AllergyIntolerance> getAllergyIntolerancedata(
		String symptomTrackerId
	) {
		List<AllergyIntolerance> primaryAllergyIntolerance = new List<AllergyIntolerance>();
		try {
			if (String.isBlank(symptomTrackerId)) {
				return null;
			} else {
				primaryAllergyIntolerance = [
					SELECT
						Id,
						BI_PSP_Bodyparts__c,
						BI_PSP_Mood__c,
						BI_PSP_Intensity__c,
						BI_PSP_Temperature__c,
						BI_PSP_Symptoms__r.HealthCloudGA__CarePlanTemplate__r.Name
					FROM AllergyIntolerance
					WHERE BI_PSP_Symptom_Name__c = :symptomTrackerId
				]; //USER_MODE cannot be implemented here, as it is querying health cloud object.
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_Symptomtrackerprimarypage.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorMsg);
		}
		if (primaryAllergyIntolerance.isEmpty()) {
			throw new AuraHandledException(Alleryrecord);
		}
		return primaryAllergyIntolerance;
	}
	/** 
		@description     Method to retrieve base64 image based on symptomTrackerId
                         USER_MODE cannot be implemented here, as it is querying health cloud object.
		@param           symptomTrackerId Id of the user to view image
		@return          Image base64 is being returned in this method  .this values return pass to biPspbSymptomPrimarypage
		*/
	@AuraEnabled(cacheable=true)
	public static List<String> getBase64Image(Id symptomTrackerId) {
		List<String> base64URLs = new List<String>();

		try {
			if (String.isBlank(symptomTrackerId)) {
				return null;
			} else {
				List<ContentDocumentLink> documentLinks = [
					SELECT ContentDocumentId
					FROM ContentDocumentLink
					WHERE
						LinkedEntityId = :symptomTrackerId
						AND ContentDocument.FileType IN ('jpg', 'png')
				];

				if (!documentLinks.isEmpty()) {
					Set<Id> contentDocumentIds = new Set<Id>();
					for (ContentDocumentLink docLink : documentLinks) {
						contentDocumentIds.add(docLink.ContentDocumentId);
					}

					List<ContentVersion> contentVersions = [
						SELECT VersionData, FileType
						FROM ContentVersion
						WHERE
							ContentDocumentId IN :contentDocumentIds
							AND FileType IN ('jpg', 'png')
						ORDER BY CreatedDate DESC
					];

					for (ContentVersion content : contentVersions) {
						String base64URL =
							'data:image/' +
							content.FileType +
							';base64,' +
							EncodingUtil.base64Encode(content.VersionData);
						base64URLs.add(base64URL);
					}
				} else {
					throw new AuraHandledException(Symptomerrormsg);
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_Symptomtrackerprimarypage.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(Applicationphotomsg);
		}

		return base64URLs;
	}

	/**
		@description     Method to delete symptom tracker records based on symptomTrackerId
                         USER_MODE cannot be implemented here, as it is querying health cloud object.
		@param           symptomTrackerId Id of the user who deletes the record 
	
		*/
	@AuraEnabled
	public static void deleteSymptomTrackerRecords(Id symptomTrackerId) {
		try {
			// Query for BI_PSP_Symptom_Tracker__c records related to the given symptomTrackerId
			List<BI_PSP_Symptom_Tracker__c> symptomTrackersToUpdate = [
				SELECT Id, BI_PSP_Symptom_Staus__c
				FROM BI_PSP_Symptom_Tracker__c
				WHERE Id = :symptomTrackerId
			];

			if (!symptomTrackersToUpdate.isEmpty()) {
				// Changes the status to "Inactive" for each record
				for (
					BI_PSP_Symptom_Tracker__c tracker : symptomTrackersToUpdate
				) {
					tracker.BI_PSP_Symptom_Staus__c = symptomTrackerInactive;
				}

				Database.SaveResult[] saveResults = Database.update(
					symptomTrackersToUpdate,
					false
				);
				for (Database.SaveResult saveResult : saveResults) {
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
							BI_SFCOE_LOG_Util.logMessage(
								applicationName,
								BI_PSPB_Symptomtrackerprimarypage.class
									.toString(),
								'',
								System.now(),
								'Error ' +
									error.getFields() +
									'--' +
									error.getMessage(),
								BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
						}
					}
				}
			} else {
				throw new AuraHandledException(
					Stauschange
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_Symptomtrackerprimarypage.class.toString(),
				null,
				System.now()
			);
		}
	}
	/**
	
		@description     Method to retrieve all latest record for the careprogram enrollee
                         USER_MODE cannot be implemented here, as it is querying health cloud object.
                         
		@param           careProgramEnrolleeId Id of the care program enrollee
		@return          returns the recently updated records.this values return pass to biPspbSymptomPrimarypage
		*/
	@AuraEnabled(cacheable=true)
	public static List<String> getLatestSymptomRecord(
		Id careProgramEnrolleeId
	) {
		List<String> result = new List<String>();

		try {
			if (String.isBlank(careProgramEnrolleeId)) {
				throw new AuraHandledException(Symptomerrormsg);
			} else {
				// Query for the latest record based on the entry date
				List<BI_PSP_Symptom_Tracker__c> latestRecords = [
					SELECT
						Id,
						BI_PSP_EditEntrydates__c,
						BI_PSP_Care_Program_Enrollee__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE
						BI_PSP_Care_Program_Enrollee__c = :careProgramEnrolleeId
						AND BI_PSP_Symptom_Staus__c != :symptomTrackerInactive
					ORDER BY BI_PSP_EditEntrydates__c DESC
					LIMIT 1
				]; //USER_MODE cannot be implemented here, as it is querying health cloud object.

				if (!latestRecords.isEmpty()) {
					// Access the fields of the latest record
					BI_PSP_Symptom_Tracker__c latestRecord = latestRecords[0];
					String recordId = latestRecord.Id;
					Datetime entryDate = latestRecord.BI_PSP_EditEntrydates__c;
					result.add(recordId);
					result.add(String.valueOf(entryDate));
				} else {
					result.add(errorMsg);
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_Symptomtrackerprimarypage.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(latestrecord);
		}

		return result; //result null check is handled in the LWC
	}
}