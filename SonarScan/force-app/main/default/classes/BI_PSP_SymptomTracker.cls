/**
				* @description This class provides functionalities related to caregivers and patients.
				* It includes methods for retrieving caregiver details, updating caregiver information,
				* managing access permissions, and handling patient data.When a class is declared with "without sharing," it allows the code in that class to access and manipulate records even if the user 
				running the code does not have the necessary permissions based on the organization's sharing settings or record-level security.	 

				* History
				* Version 	Author					Date			Detail		Description
				* 1.0		Karthikeyan.P		05-Jan-2024		Created		This was an intial development.
				* 1.1		Karthikeyan.P		06-Apr-2024		Updated		Code Review Changes.
				*/

				public without sharing class BI_PSP_SymptomTracker {
                    
				private static String error = System.Label.BI_PSP_ConsoleError;
                    
				private static String applicationName;
				private static String errorMsg = '';
				private static List<BI_PSP_Symptom_Tracker__c> existingRecords = new List<BI_PSP_Symptom_Tracker__c>();
				private static String inactive = System.Label.BI_PSP_Inactive;
				private static String checkvalues = System.Label.BI_PSP_Checkvalues;
				private static String Symptomerrormsg = System.Label.BI_PSP_Symptomtrackererrormsg;
				private static String Gpperrormsg = System.Label.BI_PSP_Gppvalueserrormsg;
				private static String Careprogramerrormsg = System.Label.BI_PSP_Careprogramerrormsg;
				private static String Careplanerrormsg = System.Label.BI_PSP_Careplanerrormsg;
				private static String Patienterrormsg = System.Label.BI_PSP_Patienterrormsg;
				private static String Contenterrormsg = System.Label.BI_PSP_Doucmentserrormsg;
				private static String Applicationphotomsg  = System.Label.BI_PSP_Applicationphotomsg;
				private static String Fileerrormsg  = System.Label.BI_PSP_Fileserrormsg;
				private static String Bodypartserrormsg  = System.Label.BI_PSP_Bodypartserrormsg;
				private static String checkUniqueDate  = System.Label.BI_PSP_Checkunquiedate;
				private static String Checkgender  = System.Label.BI_PSP_Gender;
				private static String Lastrecord  = System.Label.BI_PSP_Lastrecord;

                  

				/**
				@description   Checks if a record with a unique date already exists for a specific Account
					USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param         editedDate -old date or nwe date.
				@param         accountId - accountId The ID of the user.
				@return        editedDate checking with true or false values. This returns values to bipspbiPspbSymptomTracker this components 
				*/

				@AuraEnabled(cacheable=true)
				public static Boolean checkUniqueDate(Date editedDate, String accountId) {
				try {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
				applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c : '';

				if (editedDate == null || accountId == null) {
					throw new AuraHandledException(
					checkvalues
					);
				}

				else{
					List<BI_PSP_Symptom_Tracker__c> existingRecords = [
					SELECT Id, BI_PSP_Symptom_Staus__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE
						BI_PSP_Care_Program_Enrollee__r.Id = :accountId
						AND BI_PSP_EditEntrydates__c = :editedDate
                            AND (BI_PSP_Symptom_Staus__c = :inactive
                            OR BI_PSP_Symptom_Staus__c = NULL)
				]; //USER_MODE cannot be implemented here, as it is related to  health cloud object.

				if (!existingRecords.isEmpty()) {
				for (BI_PSP_Symptom_Tracker__c record : existingRecords) {
					if (record.BI_PSP_Symptom_Staus__c == inactive) {
						// If an 'Inactive' record with the same edit entry date is found, return true to allow insertion
						return true;
					}
				}
				// No 'Inactive' records found for the same edit entry date, but there are records with 'null' status, return false to disallow insertion
				return false;
				}
				}
				// No existing records. Proceed with insertion.
				return true;
				}  catch (Exception ex) {
				// Log the exception
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
									'PSPB');
				String applicationName = settings.BI_SFCOE_LOG_Application__c;
				BI_SFCOE_LOG_Util.handleException(
					ex,
					applicationName,
					BI_PSP_SymptomTracker.class.toString(),
					null,
					System.now()
				);
				// Return false in case of exception

				throw new AuraHandledException(checkUniqueDate);
				}
				}

				/**
				@description   Inserts a new Symptom Tracker record for a CareProgramEnrollee.
					USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param         accId Retrieves caregiver details based on the provided user ID
				@param         gpp user symptoms yes or NO
				@param         editEntryDate user entiry date
				@return        editEntryDate  return insert id symptomrecord id return .This return values pass to bipspbiPspbSymptomTracker this components 
				*/

				@AuraEnabled
				public static Id recordInsertST(
				String accId,
				Boolean gpp,
				Date editEntryDate
				) {
				try {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c
				: '';
					if (editEntryDate == null || accId == null || gpp == null) {
					throw new AuraHandledException(
					checkvalues
					);
				}

				else{
				List<CareProgramEnrollee> cpeList = [
					SELECT Id
					FROM CareProgramEnrollee
					WHERE Id = :accId
					LIMIT 1
				]; //USER_MODE cannot be implemented here, as it is querying health cloud object.

				// Check if CareProgramEnrollee record exists
				if (cpeList.isEmpty()) {
					// CareProgramEnrollee record not found. Cannot insert records.
					return null;
				}

				CareProgramEnrollee cpe = cpeList[0]; // Get the first record from the list

				// Check if a record with the same date already exists and is inactive
				List<BI_PSP_Symptom_Tracker__c> existingRecords = [
					SELECT Id
					FROM BI_PSP_Symptom_Tracker__c
					WHERE
						BI_PSP_Care_Program_Enrollee__c = :cpe.Id
						AND BI_PSP_EditEntrydates__c = :editEntryDate
						AND BI_PSP_Symptom_Staus__c = :'In active'
					LIMIT 1
				]; // USER_MODE cannot be implemented here, as it is related health cloud object.

				if (!existingRecords.isEmpty()) {
					// Record with the same date and 'Inactive' status exists. Cannot insert duplicate records.
					return null;
				}

				BI_PSP_Symptom_Tracker__c symptomTrackerToInsert = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Care_Program_Enrollee__c = cpe.Id,
					BI_PSP_EditEntrydates__c = editEntryDate,
					BI_PSP_Are_you_currently_experiencing__c = gpp
				);

				// Try to insert the new Symptom Tracker record

					Database.SaveResult[] saveResults = Database.insert(
						new List<BI_PSP_Symptom_Tracker__c>{
							symptomTrackerToInsert
						},
						false
					); // USER_MODE cannot be implemented here, as it is related health cloud object.
					if (saveResults[0].isSuccess()) {
						return saveResults[0].getId();
					} else {
						// Handle the error
					
						for (Database.SaveResult saveResult : saveResults) {
							if (!saveResult.isSuccess()) {
								for (
									Database.Error error : saveResult.getErrors()
								) {
									errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
								}
							}
						}
						if (!String.isBlank(errorMsg)) {
							BI_SFCOE_LOG_Util.logMessage(
								applicationName,BI_PSP_SymptomTracker.class.toString(),'Record cannot be inserted',
								System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
							throw new AuraHandledException(errorMsg); // Propagate combined errors after collecting from all records
						}
						return null;
					}
				}
				} catch (Exception ex) {
				// Log the exception for other errors
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c : '';
				BI_SFCOE_LOG_Util.handleException(
					ex,
					applicationName,
					BI_PSP_SymptomTracker.class.toString(),
					null,
					System.now()
				);
				throw new AuraHandledException(checkUniqueDate);
				}
				}

				/**

				@description   Updates an existing Symptom Tracker record
					USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param         symptomTrackerId Retrieves caregiver details based on the provided user ID.
				@param         gpp user symptoms yes or NO
				@param     		editEntryDate  To take the entry value from the user .

				*/

				@AuraEnabled
				public static void recordInsertSTupdate(
				String symptomTrackerId,
				Boolean gpp,
				Date editEntryDate
				) {
				BI_PSP_Symptom_Tracker__c symptomTrackerToUpdate;
				try {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c : '';
					if (symptomTrackerId == null || gpp == null || editEntryDate == null) {
					throw new AuraHandledException(
					checkvalues
					);
				}

				else{
				// Query for existing BI_PSP_Symptom_Tracker__c record
				List<BI_PSP_Symptom_Tracker__c> existingRecords = [
					SELECT Id, BI_PSP_Care_Program_Enrollee__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE Id = :symptomTrackerId
					LIMIT 1
				]; //USER_MODE cannot be implemented here, as it is related health cloud object.

				if (!existingRecords.isEmpty()) {
					// No existing record found to update

					symptomTrackerToUpdate = existingRecords[0];

					// Update the fields
					symptomTrackerToUpdate.BI_PSP_Are_you_currently_experiencing__c = gpp;
					symptomTrackerToUpdate.BI_PSP_EditEntrydates__c = editEntryDate;
				}

				//Database.SaveResult saveResult = Database.update(symptomTrackerToUpdate, false, AccessLevel.USER_MODE);

				Database.SaveResult[] saveResults = Database.insert(
					new List<BI_PSP_Symptom_Tracker__c>{ symptomTrackerToUpdate },
					false
				);
				// Check each save result
				for (Database.SaveResult saveResult : saveResults) {
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
				}
				if (!String.isBlank(errorMsg)) {
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResults,
						BI_PSP_SymptomTracker.class.toString(),
						System.now()
					);

					throw new AuraHandledException(errorMsg); // Propagate combined errors after collecting from all records
				}
				} 
				}
				catch (Exception ex) {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c : '';
				BI_SFCOE_LOG_Util.handleException(
					ex,
					applicationName,
					BI_PSP_SymptomTracker.class.toString(),
					null,
					System.now()
				);
				throw new AuraHandledException(checkvalues);
				}
				}

				/**

				@description  Updates the "Are you currently experiencing?" field in a Symptom Tracker record.
					USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param        symptomTrackerId Retrieves caregiver details based on the provided user ID.
				@param        gpp user symptoms yes or NO

				*/
				@AuraEnabled
				public static void updateGPPValue(String symptomTrackerId, Boolean gpp) {


				try {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c : '';
				if (symptomTrackerId == null || gpp == null) {
					throw new AuraHandledException(
						Gpperrormsg
					);
				}

				else{
				BI_PSP_Symptom_Tracker__c st = [
					SELECT Id, BI_PSP_Are_you_currently_experiencing__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE Id = :symptomTrackerId
					LIMIT 1
				];

				if (st != null) {
					st.BI_PSP_Are_you_currently_experiencing__c = gpp;

					// Perform the update operation
					List<Database.SaveResult> updateResults = Database.update(
						new List<BI_PSP_Symptom_Tracker__c>{ st },
						false
					);

					for (Database.SaveResult sr : updateResults) {
						if (!sr.isSuccess()) {
							for (Database.Error error : sr.getErrors()) {
								errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
							}
							if (!String.isBlank(errorMsg)) {
								BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
									updateResults,BI_PSP_SymptomTracker.class.toString(),System.now()
								);
							}
						}
					}
				} else {
					throw new AuraHandledException(
						Symptomerrormsg
					);
				}
				}
				}catch (Exception ex) {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
									'PSPB');
				applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c : '';
				BI_SFCOE_LOG_Util.handleException(
					ex,
					applicationName,
					BI_PSP_SymptomTracker.class.toString(),
					null,
					System.now()
				);
				throw new AuraHandledException(Gpperrormsg);
				}
				}

				/**
				@description   Updates recent activities in a Symptom Tracker record.
					USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param         valuesToUpdate user Recent activitios values add 
				@param         valuesToUpdate user Recent activitios values add 

				*/

				@AuraEnabled
				public static void updateRecentValue(
				String symptomTrackerId,
				List<String> valuesToUpdate
				) {
				try {
				if(symptomTrackerId == null || valuesToUpdate == null ){
                    throw new AuraHandledException(checkvalues);
				}

				else{
				BI_PSP_Symptom_Tracker__c st = [
					SELECT Id, BI_PSP_Recent_Activities__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE Id = :symptomTrackerId
					LIMIT 1
				]; //USER_MODE cannot be implemented here, as it is related to health cloud object.

				// Deselect existing values
				st.BI_PSP_Recent_Activities__c = null;

				// Select new values
				if (!valuesToUpdate.isEmpty()) {
					st.BI_PSP_Recent_Activities__c = String.join(
						valuesToUpdate,
						';'
					);
				}

				// Perform the update operation
				Database.SaveResult[] saveResults = Database.update(
					new List<BI_PSP_Symptom_Tracker__c>{ st },
					false
				); //USER_MODE cannot be implemented here, as it is related to health cloud object.

				// Check each save result
				for (Database.SaveResult saveResult : saveResults) {
					if (!saveResult.isSuccess()) {
						// Handle the error
						for (Database.Error error : saveResult.getErrors()) {
								errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
						}
					}
				}
				} 
				}catch (Exception ex) {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
									'PSPB');
										applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c
				: '';
				BI_SFCOE_LOG_Util.handleException(ex,
					applicationName,BI_PSP_SymptomTracker.class.toString(),
					null,System.now()
				);
				throw new AuraHandledException(checkvalues);
				}
				}

				/**

				@description   Updates recent activities in a Symptom Tracker record.
					USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param         bodyPart user  values  add  this param
				@param         itchinessallrecord  6 values 
				*/
	/**

@description   Updates recent activities in a Symptom Tracker record.
               USER_MODE cannot be implemented here, as it is querying health cloud object.
@param         bodyPart user  values  add  this param
@param         itchinessallrecord  6 values 
*/
	@AuraEnabled(cacheable=false)
public static Id recordInsertAllergyIntolerance(
BI_PSPB_Symptomtrackerwrapeermethod itchinessallrecordinsert,
List<String> bodyParts
) {
try {
	String itchinessCarePlan = itchinessallrecordinsert.Symptomname;
	// Retrieve CareProgramEnrollee based on accId
	CareProgramEnrollee cpes = [
	SELECT Id, AccountId
	FROM CareProgramEnrollee
	WHERE Id = :itchinessallrecordinsert.CareprogramId
	LIMIT 1
	];

	String accountId = cpes != null ? cpes.AccountId : null;

	if (accountId != null) {
	// Retrieve HealthCloudGA__CarePlanTemplate__c based on Name 'Itchiness'
	HealthCloudGA__CarePlanTemplate__c cpt = [
		SELECT Id
		FROM HealthCloudGA__CarePlanTemplate__c
		WHERE Name = :itchinessCarePlan
		LIMIT 1
	];

	if (cpt != null) {
		// Retrieve HealthCloudGA__CareProgramPlanTemplate__c based on HealthCloudGA__CarePlanTemplate__c
		HealthCloudGA__CareProgramPlanTemplate__c careProgram = [
		SELECT Id
		FROM HealthCloudGA__CareProgramPlanTemplate__c
		WHERE HealthCloudGA__CarePlanTemplate__c = :cpt.Id
		LIMIT 1
		];


		if (careProgram != null) {
		// Create new AllergyIntolerance record
		AllergyIntolerance ai = new AllergyIntolerance();
		ai.BI_PSP_Symptoms__c = careProgram.Id;
		ai.BI_PSP_Symptom_Name__c = itchinessallrecordinsert.SymptomId;

		if (bodyParts != null && !bodyParts.isEmpty()) {
			ai.BI_PSP_Bodyparts__c = String.join(bodyParts, ';');
		}

		if (
			itchinessallrecordinsert.SliderValue != null &&
			itchinessallrecordinsert.SliderValue != 0
		) {
			try {
			Decimal intensity = Decimal.valueOf(itchinessallrecordinsert.SliderValue);
			ai.BI_PSP_Intensity__c = intensity;
			} catch (Exception ex) {
			String applicationName = BI_SFCOE_LOG_App_Settings__c.getInstance()
				.BI_SFCOE_LOG_Application__c;
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSP_SymptomTracker.class.toString(),
				null,
				System.now()
			);
			}
		}
		if (
			itchinessallrecordinsert.ValoF != null &&
			String.valueOf(itchinessallrecordinsert.ValoF) != '0'
		) {
			ai.BI_PSP_Temperature__c = itchinessallrecordinsert.ValoF;
		} else {
			ai.BI_PSP_Temperature__c = null; // Assign null if ValoF is null or '0'
		}

		if (!String.isEmpty(itchinessallrecordinsert.Moodvalues)) {
			ai.BI_PSP_Mood__c = itchinessallrecordinsert.Moodvalues;
		}

		ai.PatientId = accountId;

		// Insert the record
		Database.SaveResult[] saveResults = Database.insert(
			new List<AllergyIntolerance>{ ai },
			false
		);
		for (Database.SaveResult saveResult : saveResults) {
			if (!saveResult.isSuccess()) {
			for (Database.Error error : saveResult.getErrors()) {
				BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSP_SymptomTracker.class.toString(),
				'',
				System.now(),
				'Error ' + error.getFields() + '--' + error.getMessage(),
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			} else {
			return ai.Id;
			}
		}
		} else {
			throw new AuraHandledException(Careprogramerrormsg);

		}
	} else {
			throw new AuraHandledException(Careplanerrormsg);
	}
	} else {
		throw new AuraHandledException(Patienterrormsg);
	}
} catch (Exception ex) {
	String applicationName = BI_SFCOE_LOG_App_Settings__c.getInstance()
	.BI_SFCOE_LOG_Application__c;
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSP_SymptomTracker.class.toString(),
	null,
	System.now()
	);
}
return null;
}


				/**

				@description   Updates an existing AllergyIntolerance record based on provided data.
					USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param         itchinessallrecord  6 values 
				@param         bodyPart user  values  add  this param
				@return 		existingRecord.Id this will return the AllergyIntolerance
				*/

				@AuraEnabled(cacheable=false)
				public static Id recordUpdateAllergyIntolerance(
				BI_PSPB_Symptomtrackerwrapeermethod itchinessallrecordupdate,
				List<String> bodyParts
				) {
				List<AllergyIntolerance> existingRecords;
				AllergyIntolerance existingRecord;
				try {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c : '';
						
				if (itchinessallrecordupdate == null || bodyParts == null) {
				throw new AuraHandledException(Bodypartserrormsg);
				} 
				else{
				CareProgramEnrollee cpes = [
					SELECT Id, AccountId
					FROM CareProgramEnrollee
					WHERE Id = :itchinessallrecordupdate.CareprogramId
					LIMIT 1
				];//USER_MODE cannot be implemented here, as it is querying health cloud object.
				String accountId = cpes != null ? cpes.AccountId : null;

				if (accountId != null && itchinessallrecordupdate.symptomname != null) {
					List<HealthCloudGA__CarePlanTemplate__c> cptList = [
						SELECT Id
						FROM HealthCloudGA__CarePlanTemplate__c
						WHERE Name = :itchinessallrecordupdate.symptomname
						LIMIT 1
					];

					if (!cptList.isEmpty()) {
						HealthCloudGA__CarePlanTemplate__c cpt = cptList[0];
						List<HealthCloudGA__CareProgramPlanTemplate__c> careProgrammList = [
							SELECT Id
							FROM HealthCloudGA__CareProgramPlanTemplate__c
							WHERE HealthCloudGA__CarePlanTemplate__c = :cpt.Id
							LIMIT 1
						];

						if (!careProgrammList.isEmpty()) {
							HealthCloudGA__CareProgramPlanTemplate__c careProgramm = careProgrammList[0];
							existingRecords = [
								SELECT
									Id,
									BI_PSP_Bodyparts__c,
									BI_PSP_Intensity__c,
									BI_PSP_Temperature__c,
									BI_PSP_Mood__c
								FROM AllergyIntolerance
								WHERE
									PatientId = :accountId
									AND BI_PSP_Symptoms__c = :careProgramm.Id
								ORDER BY CreatedDate DESC
								LIMIT 1
							];

							if (!existingRecords.isEmpty()) {
								existingRecord = existingRecords[0];
								existingRecord.BI_PSP_Symptom_Name__c = itchinessallrecordupdate.symptomId;

								if (bodyParts != null && !bodyParts.isEmpty()) {
									existingRecord.BI_PSP_Bodyparts__c = String.join(
										bodyParts,
										';'
									);
								}

								if (
									itchinessallrecordupdate.SliderValue != null &&
									itchinessallrecordupdate.SliderValue != 0
								) {
									try {
										Decimal intensity = Decimal.valueOf(
											itchinessallrecordupdate.SliderValue
										);
										existingRecord.BI_PSP_Intensity__c = intensity;
									} catch (Exception ex) {
										BI_SFCOE_LOG_Util.handleException(ex,applicationName
											,BI_PSP_SymptomTracker.class.toString(),null,System.now()
										);
									}
								}

								if (
									itchinessallrecordupdate.valoF != null &&
									String.valueOf(
										itchinessallrecordupdate.valoF
									) != '0'
								) {
									existingRecord.BI_PSP_Temperature__c = itchinessallrecordupdate.valoF;
								} else {
									existingRecord.BI_PSP_Temperature__c = null; // Assign null if valoF is null or '0'
								}

								if (
									!String.isEmpty(
										itchinessallrecordupdate.moodvalues
									)
								) {
									existingRecord.BI_PSP_Mood__c = itchinessallrecordupdate.moodvalues;
								}

								Database.SaveResult[] saveResults = Database.update(
									new List<AllergyIntolerance>{ existingRecord },
									false
								);
								
										for (
											Database.SaveResult saveResultget : saveResults
										) {
											if (!saveResultget.isSuccess()) {
												for (
													Database.Error error : saveResultget.getErrors()
												) {
													errorMsg +='Error'+error.getFields()+'--'+error.getMessage() +'\n';
												}
											}
										}
										if (!String.isBlank(errorMsg)) {
											BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
												saveResults,BI_PSP_SymptomTracker.class.toString(),System.now()
											);
											throw new AuraHandledException(errorMsg); 
										}									
									}
									
									
								
								
							
						}
					}
				}
				return existingRecord.Id;
				} 
				}
				catch (Exception ex) {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
				applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c : '';
				BI_SFCOE_LOG_Util.handleException(
					ex,
					applicationName,
					BI_PSP_SymptomTracker.class.toString(),
					null,
					System.now()
				);
				throw new AuraHandledException(Bodypartserrormsg);
				}

				}

				/**
				@description     Retrieves the last entry date for a specific Account
						USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param           accountId  details based on the provided user ID
				@return          editEntryDate  return insert id symptomrecord id return .This return values pass to bipspbiPspbSymptomTracker this components 
				*/

				@AuraEnabled(cacheable=true)
				public static Date getLastEntryDate(String accountId) {
				try {        
				if (accountId == null) {
				throw new AuraHandledException(Patienterrormsg);
				} 
				else{
				Date entryDate;
				List<BI_PSP_Symptom_Tracker__c> results = [
					SELECT BI_PSP_EditEntrydates__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE BI_PSP_Patient__c = :accountId
					ORDER BY BI_PSP_EditEntrydates__c
				];

				if (!results.isEmpty()) {
					entryDate = results[0].BI_PSP_EditEntrydates__c;
				}

				if (entryDate != null) {
					return entryDate;
				} else {
					throw new AuraHandledException(errorMsg);
				}
				} 
				}catch (Exception ex) {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c: '';
				BI_SFCOE_LOG_Util.handleException(
					ex,
					applicationName,
					BI_PSP_SymptomTracker.class.toString(),
					null,
					System.now()
				);
				throw new AuraHandledException(Patienterrormsg);
				}
				}

				/**

				@description    Retrieves the last 10 CarePlanTemplate records
						USER_MODE cannot be implemented here, as it is querying health cloud object.

				@return         last 10 record return .This return values pass to bipspbiPspbSymptomTracker this components 


				*/

				@AuraEnabled(cacheable=true)
				public static List<HealthCloudGA__CarePlanTemplate__c> getLast() {
				try {
				List<HealthCloudGA__CarePlanTemplate__c> results = [
					SELECT Id, BI_PSP_Symptom_image__c, RecordTypeId
					FROM HealthCloudGA__CarePlanTemplate__c
					WHERE RecordType.Name = 'BI_PSP_Symptom'
					ORDER BY CreatedDate DESC
					LIMIT 10
				];

				// Log the number of records retrieved
				if (!results.isEmpty()) {
					return results;
				} else {
					throw new AuraHandledException(errorMsg);
				}
				} catch (Exception ex) {
				// Log the exception

				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c: '';
				BI_SFCOE_LOG_Util.handleException(
					ex,
					applicationName,
					BI_PSP_SymptomTracker.class.toString(),
					null,
					System.now()
				);

				return new List<HealthCloudGA__CarePlanTemplate__c>();
				// Return an empty list in case of exception
				}
				}

				/** 
				@description     uploaded files as ContentVersion records.
						USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param          fileContents photos upload 
				@param			List<String> fileContents,
				@return         contentDocumentIds This return values pass to bipspbiPspbSymptomTracker this components   
				*/
				@AuraEnabled
				public static List<String> saveFiles(
				List<String> fileContents,
				String parentId,
				String fileTitle,
				String filePath
				) {
				List<String> contentDocumentIds = new List<String>();
				try {
				// Check if any of the parameters are null
				if (fileContents == null || parentId == null || fileTitle == null || filePath == null) {
				throw new AuraHandledException(Patienterrormsg);
				}
				else{
				List<ContentVersion> contentVersionsToInsert = new List<ContentVersion>();

				for (String fileContent : fileContents) {
				Blob fileBlob = EncodingUtil.base64Decode(fileContent);

				// Create ContentVersion instead of Attachment
				ContentVersion contentVersion = new ContentVersion();
				contentVersion.VersionData = fileBlob;
				contentVersion.Title = fileTitle; // Use provided file title
				contentVersion.PathOnClient = filePath; // Use provided file path
				contentVersion.FirstPublishLocationId = parentId;

				contentVersionsToInsert.add(contentVersion);
				}

				// Insert all ContentVersion records at once using Database.insert
				List<Database.SaveResult> insertResults = Database.insert(contentVersionsToInsert, false);

				// Retrieve the IDs of the inserted ContentVersion records
				for (Database.SaveResult result : insertResults) {
				if (result.isSuccess()) {
					contentDocumentIds.add(result.getId());
				} else {
					// Handle the case where insertion failed for a ContentVersion record
					for (Database.Error error : result.getErrors()) {
						errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
					}
				}
				}
				} 
				}catch (Exception ex) {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
				applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c: '';
				BI_SFCOE_LOG_Util.handleException(ex, applicationName, BI_PSP_SymptomTracker.class.toString(), null, System.now());
				throw new AuraHandledException(Fileerrormsg);
				}

				return contentDocumentIds;
				}
				/** 

				@description      uploaded files as ContentVersion records.
				@param           fileIds photos upload 
				@param           symptomTrackerId 

				*/

				// Creates ContentDocumentLink records to link files to Symptom Tracker records.
				@AuraEnabled(cacheable=true)
				public static void createContentDocumentLinks(
				List<String> fileIds,
				Id symptomTrackerId
				) {
				try {
					if (fileIds == null || symptomTrackerId == null) {
				throw new AuraHandledException(Fileerrormsg);
				}
				else{
				List<ContentDocumentLink> fileLinks = new List<ContentDocumentLink>();
				if (fileIds != null) {
					for (String fileId : fileIds) {
						ContentDocumentLink link = new ContentDocumentLink();
						link.ContentDocumentId = fileId;
						link.LinkedEntityId = symptomTrackerId;
						link.ShareType = 'I'; // 'I' represents Inferred permission
						fileLinks.add(link);
					}

					Database.SaveResult[] saveResults = Database.insert(
						fileLinks,
						false
					);
					for (Database.SaveResult saveResult : saveResults) {
						if (!saveResult.isSuccess()) {
							for (Database.Error error : saveResult.getErrors()) {
								errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
							}
						}
					}
					if (!String.isBlank(errorMsg)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
							saveResults,
							BI_PSPB_symptomTrackerTasksCtrl.class.toString(),
							System.now()
						);
						throw new AuraHandledException(errorMsg); // Propagate combined errors after collecting from all records
					}
				}
				} 
				}catch (Exception ex) {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
									'PSPB');
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c: '';
				BI_SFCOE_LOG_Util.handleException(
					ex,
					applicationName,
					BI_PSP_SymptomTracker.class.toString(),
					null,
					System.now()
				);
				throw new AuraHandledException(Fileerrormsg);
				}
				}

				/**

				@description    Deletes ContentDocumentLink records linked to Symptom Tracker records.
				@param         symptomTrackerId  details based on the provided user ID
				*/

				@AuraEnabled
				public static void deleteContentDocumentLinks(Id symptomTrackerId) {
				String errorMsg = ''; // Initialize errorMsg variable

				try {

				if(symptomTrackerId == null)
				{
					throw new AuraHandledException(Patienterrormsg); 
				}
				else{                  
				// Query for the first ContentDocumentLink related to the symptomTrackerId
				List<ContentDocumentLink> linksToDelete = [
				SELECT Id
				FROM ContentDocumentLink
				WHERE LinkedEntityId = :symptomTrackerId
				LIMIT 1
				];

				if (!linksToDelete.isEmpty()) {
				Database.DeleteResult deleteResult = Database.delete(linksToDelete[0], false);
					if (!deleteResult.isSuccess()) {
						// Handle the error
						for (Database.Error error : deleteResult.getErrors()) {
							errorMsg +='Error '+error.getFields()+'--'+error.getMessage()+'\n';
						}
					}

					if (!String.isBlank(errorMsg)) {
						// Log error message
						BI_SFCOE_LOG_Util.logMessage(
							applicationName,BI_PSP_SymptomTracker.class.toString(),'',System.now(),
							errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
						);

						throw new AuraHandledException(errorMsg); // Propagate the error
					}
				} else {
					throw new AuraHandledException(Contenterrormsg);
				}
				
				
				}
				} catch (Exception ex) {
				// Handle exception
			
				BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSP_SymptomTracker.class.toString(),
				null,
				System.now()
				);
				throw new AuraHandledException(Applicationphotomsg);
				}
				}


				/**
				@description      Retrieves details of the latest Symptom Tracker record for a CareProgramEnrollee.
							USER_MODE cannot be implemented here, as it is querying health cloud object.
				@param          careProgramEnrolleeId  
				@return         This return values pass to bipspbiPspbSymptomTracker this components 
				*/

				@AuraEnabled(cacheable=true)
				public static Map<String, Object> getSymptomTrackerDetails(
				Id careProgramEnrolleeId
				) {
				try {
						if (careProgramEnrolleeId==null) {
				throw new AuraHandledException(Careprogramerrormsg);
				}
				else{
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c
				: '';
				// Debug log to check the value of careProgramEnrolleeId

				// Query the most recent record based on the given careProgramEnrolleeId and status not 'inactive'
				BI_PSP_Symptom_Tracker__c record = [
					SELECT Id, BI_PSP_EditEntrydates__c, LastModifiedDate
					FROM BI_PSP_Symptom_Tracker__c
					WHERE
						BI_PSP_Care_Program_Enrollee__c = :careProgramEnrolleeId
						AND BI_PSP_Symptom_Staus__c != :inactive
					ORDER BY LastModifiedDate  DESC Limit 1
					
				];

				if (record != null) {
					// Create a map to store the result
					Map<String, Object> result = new Map<String, Object>();
					result.put('recordId',record.Id);
					result.put('lastModifiedDate',record.BI_PSP_EditEntrydates__c);
					result.put('lasttime',record.LastModifiedDate);

					// Return the result map
					return result;
				} else {
					// No records found for the given careProgramEnrolleeId and status not 'inactive'
					throw new AuraHandledException(errorMsg);
				}
				} 
				}catch (Exception ex) {
				// Log and handle the exception
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
									'PSPB');
				String applicationName = settings.BI_SFCOE_LOG_Application__c;
				BI_SFCOE_LOG_Util.handleException(ex,
					applicationName,BI_PSP_SymptomTracker.class.toString(),null,System.now()
				);
                     return null;
				// Return null in case of an exception
				//throw new AuraHandledException(Lastrecord);
				}
				}

				/**
				@description   fetchAccountDetails Person Gender Identity.
				@param         careProgramEnrolleeId
				@return        enrollees Person Gender Identity.This return values pass to bipspbiPspbSymptomTracker this components 
				*/

				@AuraEnabled(cacheable=true)
				public static List<CareProgramEnrollee> fetchAccountDetails(
				String careProgramEnrolleeId
				) {

				List<CareProgramEnrollee> enrollees = new List<CareProgramEnrollee>();
				try {

				if (careProgramEnrolleeId==null ||String.isBlank(careProgramEnrolleeId)) {
				throw new AuraHandledException(Careprogramerrormsg);
				}
				else{
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
					'PSPB'
				);
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c
				: '';
				// Perform SOQL query to fetch CareProgramEnrollee and related Account fields
				enrollees = [
					SELECT
						Id,
						AccountId,
						Account.Name,
						Account.HealthCloudGA__Gender__pc
					FROM CareProgramEnrollee
					WHERE Id = :careProgramEnrolleeId
					LIMIT 1
				];
				} 
				}catch (Exception ex) {
				BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
									'PSPB');
					applicationName = settings != null
				? settings.BI_SFCOE_LOG_Application__c
				: '';
				BI_SFCOE_LOG_Util.handleException(ex,
					applicationName,BI_PSP_SymptomTracker.class.toString(),null,System.now()
				);
				throw new AuraHandledException(Checkgender);
				}
				return enrollees;
				}
                 
                    
               // @description   Returns the Id of the current user..
               //  @return The Id of the current user as a string.

	@AuraEnabled(cacheable=true)
	public static String getCurrentUserId() {
		// Get the Id of the current user
		String userId = UserInfo.getUserId();

		// Return the user Id
		return userId;
	}    
                    
				/**
				 *@description Represents a wrapper class for symptom tracker data in Salesforce.
				*/
				public class BI_PSPB_Symptomtrackerwrapeermethod {
				@AuraEnabled
				public String CareprogramId { get; set; }
				@AuraEnabled
				public Integer SliderValue { get; set; }
				@AuraEnabled
				public Decimal valoF { get; set; }
				@AuraEnabled
				public String symptomId { get; set; }
				@AuraEnabled
				public String personGender { get; set; }
				@AuraEnabled
				public String moodvalues { get; set; }
				@AuraEnabled
				public String symptomname { get; set; }
				}
				}