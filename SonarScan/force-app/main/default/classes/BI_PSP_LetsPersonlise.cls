/*
 * @description       : Class for managing personalized assessments and questionnaire responses.
 *                      This class provides methods to handle the creation of new assessments,
 *                      association of responses to existing assessments, and deletion of draft responses.
 * History:
 * Version	Author		Date			Detail			Description
 * 1.0		Abinsha		05-Dec-2023		Created			Initial development.
 * 1.1		Abinsha 	01-Jan-2024		Updated			Updated for caregiver.
 * 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
 */

public with sharing class BI_PSP_LetsPersonlise {
    
    //A list variable for storing existing assessment response records.
     private static List<AssessmentQuestionResponse> listOFexistingresponses;
	//holds the assessment details of the user whose record is in progress status.
	private static List<Assessment> existingAssessments;
	//holds a assessment Question record.
	private static List<AssessmentQuestion> listOfAssQuVer;
	//holds the existing responses of Qustions.
	private static AssessmentQuestionResponse existingResponse;
	//holds the assesment details.
	private static List<Assessment> assessmentsToUpdate;
	//Custom label for care givers patient.
	private static String caregiversPatientaccountErr = System.Label.BI_PSP_CaregiversPatient;
	//custom label that displays an error message when there is no account records for the selected patient.
	private static String caregiversSelectedpatienterrmsg = System.Label.BI_PSP_SelectedPatientAccount;
	// custom label that displays an error message when there is no careProgramEnrollee records for the selected patient.
	private static String selctdPatieintsenrolleeerrormsg = System.Label.BI_PSP_SelectedPatientEnrollee;
	// custom label that displays an error message when there is no Account records for the patient.
	private static String patientAccounterrormsg = System.Label.BI_PSP_PatientAccountErrormsg;
	// custom label that displays an error message when there is no care program enrollee records for the patient.
	private static String patientEnrolleeerrormsg = System.Label.BI_PSP_PatientEnrolleeErrormsg;
	// ID of the care program enrollee.
	private static String idOfEnrollee;
	// ID of the care program enrollee used in Aura-enabled methods.
	private static string enrolleeId;
	// Value for picklist field used in assessment creation and update.
	private static String pickListValue;
	// Introduction category label retrieved from custom labels.
	private static String introduction = System.Label.BI_PSP_introductionCategory;
	//this string vraible holds the error message.
	private static String errorMsg = '';
	// In Progress category label retrieved from custom labels.
	private static String inprogress = System.Label.BI_PSP_Inprogess;
	//Varibale that holds the status for Personalisation.
	private static String complete = System.Label.BI_PSP_Complete;
	// Number of days until assessment expiration retrieved from custom labels.
	private static Integer expireDate = Integer.valueOf(
		System.Label.BI_PSP_ExpireDateForQualitative
	);
	//List Variable that holds the care giver account.
	private static Account caregiverAccount;
	//List Variable that holds the care giver account ID.
	private static List<Account> caregvrAccountid;
	//List Variable that holds the patinet Enrollee Record.
	private static List<CareProgramEnrollee> enrolleeRecord;
	//List Variable that holds the Existing Assesment Question Responses of the current user.
	private static List<AssessmentQuestionResponse> existingResponses;
	//This Variable Stores a Custom setting value ApplicationName.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	//this variable holds the apllication name to ne used in Catch and Throws.
	private static string applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	//holds the response Value of Questions.
	private static String responseText;
	//holds the id of Questions.
	private static String questionId;
	// custom label that displays an error message when there is no AssessmnetQuestionResponse Record.
	private static String emptyQuestionaresponse = System.Label.BI_PSP_EmptyQuestionResponse;
	// custom label that displays an error message when there is no Assessmnet Record.
	private static String emptyAssesment = System.Label.BI_PSP_EmptyAssessment;
	// custom label that displays an error message when there is no AssessmnetQuestionVersion Record.
	private static String emptyQuestionversion = System.Label.BI_PSP_EmptyQuestionVersion;
	//custom label for Assesssment Questions query when the result  is empty.
	private static String questionsNotavilable = System.Label.BI_PSP_QuestionsUnavailable;
	//This label states that the submission assessment has failed.
	private static String assessmentFalied = System.Label.BI_PSP_AssessmentSubFailed;
	//This label states that the selected response hasnt changed.
	private static String respnsNotdeltd = System.Label.BI_PSP_RespDelFailed;
    //This label states the parmeter that holds personalisation status caught with an exception.
	private static String perstnStatusErr = System.Label.BI_PSP_PersnlatnStatus;
    //This label states that the logged in user is not in the system.
	private static String undefinedUser = System.Label.BI_PSP_UndefinedUser;
    //An integer label that holds the personalisation status.
    private static integer PersonalizeStatus;
	/*
	* @Description Method for inserting multiple draft records.
	* This method checks for an existing 'In Progress' assessment for the user.
	* and either associates responses to it or creates a new assessment.
	* method is Used in biPspbIntroductionQuestionnaire,biPspbIntroductionPageone and biPspbIntroductionPagetwo LWCs.
	* @param darftQuestionIds    List of draft question IDs.
	* @param draftResponseTexts  List of draft response texts.
	* @param InprogressOrCompelete Integer indicating whether the assessment is in progress 
	  or complete.
	*/
	@AuraEnabled
	public static void mulitipleDraftRecordsInsertion(
		List<String> darftQuestionIds,
		List<String> draftResponseTexts,
		Integer InprogressOrCompelete
	) {
		try {
			List<CareProgramEnrollee> enrolledPatient = new List<CareProgramEnrollee>();
			// Step 1: Get the ID of the user performing the inserti.

			String currentUserName = UserInfo.getName();
			String currentUserEmail = UserInfo.getUserEmail();
            if(InprogressOrCompelete != null)
            {
                 PersonalizeStatus = InprogressOrCompelete;
            }
            else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						perstnStatusErr,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}

			if (PersonalizeStatus == 1) {
				pickListValue = complete;
			} else {
				pickListValue = inprogress;
			}
			//We are getting custom field from User Object. Hence we have to use SOQL.
			User currentUser = [
				SELECT Id, Name, BI_PSPB_Caregiver__c
				FROM User
				WHERE name = :currentUserName
				WITH USER_MODE
				LIMIT 1
			];
            
            if(currentUser !=null)
            {
			if (currentUser.BI_PSPB_Caregiver__c == true) {
				caregiverAccount = [
					SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
					FROM Account
					WHERE
						Name = :currentUserName
						AND PersonEmail = :currentUserEmail
						AND IsPersonAccount = TRUE
						AND BI_PSPB_Selected_Patient_ID__c != NULL
					WITH USER_MODE
				];
				if (caregiverAccount !=null ) {
					caregvrAccountid = [
						SELECT id, Name, PersonEmail
						FROM account
						WHERE
							id = :caregiverAccount
								.BI_PSPB_Selected_Patient_ID__c
						WITH USER_MODE
					];
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						caregiversPatientaccountErr,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
				if (!caregvrAccountid.isEmpty()) {
					// USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
					//object using Healthcare license.
					enrolleeRecord = [
						SELECT id, Name
						FROM CareProgramEnrollee
						WHERE AccountID = :caregvrAccountid[0].id
					];
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
						System.now(),caregiversSelectedpatienterrmsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}

				if (!enrolleeRecord.isEmpty()) {
					enrolleeId = enrolleeRecord[0].id;
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
						System.now(),selctdPatieintsenrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				List<Account> patientAccount = [
					SELECT id, Name, PersonEmail
					FROM account
					WHERE
						PersonEmail = :currentUserEmail
						AND Name = :currentUserName
					WITH USER_MODE
				];
				if (!patientAccount.isEmpty()) {
					// USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
					//object using Healthcare license.
					enrolledPatient = [
						SELECT Id, Name
						FROM CareProgramEnrollee
						WHERE AccountID = :patientAccount[0].Id
					];
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						patientAccounterrormsg,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}

				if (!enrolledPatient.isEmpty()) {
					enrolleeId = enrolledPatient[0].Id;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						patientEnrolleeerrormsg,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
					throw new AuraHandledException(patientEnrolleeerrormsg);
				}
			}
            }
             else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						undefinedUser,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			// Step 2: Check for an existing 'In Progress' assessment for the user.
			// USER_MODE is not used because Assessment is an Salesforce Industry object
			// using Healthcare license.
			if (enrolleeId != null && !String.isBlank(enrolleeId)) {
				existingAssessments = [
					SELECT Id, Name, AssessmentStatus
					FROM Assessment
					WHERE
						BI_PSP_CareProgramEnrollee__c = :enrolleeId
						AND AssessmentStatus = :inprogress
						AND Name = :introduction
					LIMIT 1
				];
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
					System.now(),patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			Assessment existingAssessment;

			if (existingAssessments.size() > 0) {
				existingAssessment = existingAssessments[0];
				// Use the existing assessment to associate responses.
				associateResponsesToExistingAssessment(
					existingAssessment.Id,
					darftQuestionIds,
					draftResponseTexts,
					pickListValue
				);
			} else {
				// Create a new assessment if no 'In Progress' assessment exists.
				createNewAssessment(
					darftQuestionIds,
					draftResponseTexts,
					pickListValue
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSP_LetsPersonlise.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(assessmentFalied);
		}
	}

	/*
	 * @Description Helper method to associate responses to an existing assessment.
	 * This method updates existing responses or inserts new responses for the provided assessment ID.
	 *
	 * @param existingAssessmentId   ID of the existing assessment.
	 * @param darftQuestionIds       List of draft question IDs.
	 * @param draftResponseTexts     List of draft response texts.
	 * @param pickListValue          Picklist value for assessment status.
	 */
	public static void associateResponsesToExistingAssessment(
		String existingAssessmentId,
		List<String> draftQuestionIds,
		List<String> draftResponseTexts,
		String pickListValue
	) {
		List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();
		List<AssessmentQuestionResponse> existingResponsesToUpdate = new List<AssessmentQuestionResponse>();
		Set<Id> assessmentIdsToUpdate = new Set<Id>(); // Set to store unique Assessment Ids.

		try {
			Map<String, AssessmentQuestionResponse> existingResponsesMap = new Map<String, AssessmentQuestionResponse>();

			if (
				(existingAssessmentId != null &&
				!String.isBlank(existingAssessmentId)) &&
				(!draftQuestionIds.isEmpty())
			) {
                 listOFexistingresponses=[
					SELECT
						Id,
						Assessment.Id,
						ResponseText,
						BI_PSP_ResponseOrder__c,
						AssessmentQuestionId
					FROM AssessmentQuestionResponse
					WHERE
						AssessmentQuestionId IN :draftQuestionIds
						AND AssessmentId = :existingAssessmentId
					ORDER BY BI_PSP_ResponseOrder__c ASC
				];
				// Retrieve existing responses outside the loop.
				if(!listOFexistingresponses.isEmpty())
                {
                    for (AssessmentQuestionResponse existingResponse : listOFexistingresponses) {
					existingResponsesMap.put(
						existingResponse.AssessmentQuestionId,
						existingResponse
					);
					assessmentIdsToUpdate.add(existingResponse.Assessment.Id);
				}
                }
      
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
					System.now(),emptyQuestionaresponse,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			// Process draft responses inside the loop.
			if (!draftResponseTexts.isEmpty()) {
				for (Integer i = 0; i < draftQuestionIds.size(); i++) {
					String questionId = draftQuestionIds[i];
					String responseText = draftResponseTexts[i];
					AssessmentQuestionResponse existingResponse = existingResponsesMap.get(
						questionId
					);

					if (existingResponse != null) {
						// Update existing response.
						existingResponse.ResponseText = responseText;
						existingResponsesToUpdate.add(existingResponse);
					} else {
						// Create new response.
						AssessmentQuestionResponse assRes = new AssessmentQuestionResponse();
						assRes.AssessmentQuestionId = questionId;
						assRes.ResponseText = responseText;
						assRes.AssessmentId = existingAssessmentId;
						assRes.Name = responseText;

						assResList.add(assRes);
					}
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
					System.now(),emptyQuestionaresponse,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			// Update existing responses using Database class method.
			if (!existingResponsesToUpdate.isEmpty() && !String.isBlank(pickListValue)) {
				Database.SaveResult[] updateResults = Database.update(
					existingResponsesToUpdate,false
				);
				for (Database.SaveResult responseSaveResult : updateResults) {
					if (!responseSaveResult.isSuccess()) {
						for (Database.Error error : responseSaveResult.getErrors()) {
							errorMsg +='Error ' +error.getFields() +'--' +
								error.getMessage() +'\n';
						}
						if (!String.isBlank(errorMsg)) {
							BI_SFCOE_LOG_Util.handleDatabaseSaveResults(updateResults,
                                BI_PSP_LetsPersonlise.class.toString(),System.now()
							);
							throw new DMLException(errorMsg);
						}
					}
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),
					'',System.now(),emptyQuestionaresponse,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}

			// Update Assessment records outside the loop.
			// USER_MODE is not used because Assessment is an Salesforce Industry object.
			//using Healthcare license.
			if (!assessmentIdsToUpdate.isEmpty()) {
				assessmentsToUpdate = [
					SELECT Id
					FROM Assessment
					WHERE Id IN :assessmentIdsToUpdate
				];
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
					System.now(),emptyAssesment,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			for (Assessment assessmentRecord : assessmentsToUpdate) {
				assessmentRecord.BI_PSP_StatusForPersonalization__c = pickListValue;
			}
			if (!assessmentsToUpdate.isEmpty()) {
				Database.SaveResult[] updateResults = Database.update(
					assessmentsToUpdate,
					false
				);
				for (Database.SaveResult responseSaveResult : updateResults) {
					if (!responseSaveResult.isSuccess()) {
						for (
							Database.Error error : responseSaveResult.getErrors()
						) {
							errorMsg +=
								'Error ' +
								error.getFields() +
								'--' +
								error.getMessage() +
								'\n';
						}
						if (!String.isBlank(errorMsg)) {
							BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
								updateResults,
								BI_PSP_LetsPersonlise.class.toString(),
								System.now()
							);
							throw new DMLException(errorMsg);
						}
					}
				}
			}
			// Insert new responses using Database class method.
			if (!assResList.isEmpty()) {
				Database.SaveResult[] insertResults = Database.insert(
					assResList,false
				);
				for (Database.SaveResult responseSaveResult : insertResults) {
					if (!responseSaveResult.isSuccess()) {
						for (Database.Error error : responseSaveResult.getErrors()) {
							errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
						}
						if (!String.isBlank(errorMsg)) {
							BI_SFCOE_LOG_Util.handleDatabaseSaveResults(insertResults,
								BI_PSP_LetsPersonlise.class.toString(),System.now()
							);
							throw new DMLException(errorMsg);
						}
					}
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
					System.now(),emptyAssesment,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
		} catch (System.DmlException ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSP_LetsPersonlise.class.toString(),
				null,System.now()
			);
			throw new System.DmlException(assessmentFalied + ex.getMessage());
		}
	}

	/*
	 *@Description Helper method to create a new assessment and associate responses.
	 * This method creates a new assessment record and associates responses to it.
	 *
	 * @param darftQuestionIds    List of draft question IDs.
	 * @param draftResponseTexts  List of draft response texts.
	 * @param pickListValue       Picklist value for assessment status.
	 */
	public static void createNewAssessment(
        List<String> darftQuestionIds,
		List<String> draftResponseTexts,
		String pickListValue
	) {
		try {
			String activeVersionId;
			String categoryName;

			// Loop through the draft question IDs to get the active version ID.
			if (!darftQuestionIds.isEmpty()) {
				for (Integer i = 0; i < darftQuestionIds.size(); i++) {
					activeVersionId = darftQuestionIds[i];
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSP_LetsPersonlise.class.toString(),
					'',
					System.now(),
					emptyQuestionversion,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}

			// Query the category name based on the active version ID.
			// USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object.
			//using Healthcare license.
			if (activeVersionId != null && !String.isBlank(activeVersionId)) {
				listOfAssQuVer = [
					SELECT Id, QuestionCategory
					FROM AssessmentQuestion
					WHERE ActiveVersionId = :activeVersionId
					LIMIT 1
				];
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSP_LetsPersonlise.class.toString(),
					'',
					System.now(),
					questionsNotavilable,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}

			if (!listOfAssQuVer.isEmpty()) {
				categoryName = listOfAssQuVer[0].QuestionCategory;

				// Create a new Assessment record.
				Assessment ass = new Assessment();
				// Set the ID of the user performing the insertion.

				ass.BI_PSP_CareProgramEnrollee__c = enrolleeId;
				ass.AssessmentStatus = inprogress;
				ass.Name = categoryName;
				ass.EffectiveDateTime = DateTime.now();
				ass.ExpirationDateTime = DateTime.now().addDays(expireDate);
				ass.BI_PSP_StatusForPersonalization__c = pickListValue;

				// Perform insert operation.
				Database.SaveResult saveResult = Database.insert(ass, false);
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
					}
					if (!String.isBlank(errorMsg)) {
						BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
							System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
						);
						throw new DMLException(errorMsg);
					}
				}

				if (saveResult.isSuccess()) {
					// Get the Assessment ID after insertion.
					String assId = ass.Id;

					// Create AssessmentQuestionResponse records for each draft response.
					List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();
					if (
						(assId != null && !String.isBlank(assId)) &&
						(!draftResponseTexts.isEmpty())
					) {
						for (Integer i = 0; i < darftQuestionIds.size(); i++) {
							String questionId = darftQuestionIds[i];
							String responseText = draftResponseTexts[i];

							AssessmentQuestionResponse assRes = new AssessmentQuestionResponse();
							assRes.AssessmentQuestionId = questionId;
							assRes.ResponseText = responseText;
							assRes.AssessmentId = assId;
							assRes.Name = responseText;

							assResList.add(assRes);
						}
					} else {
						BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
							System.now(),emptyAssesment,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
						);
					}

					// Perform insert operation for AssessmentQuestionResponse records.
					if (!assResList.isEmpty()) {
						Database.SaveResult[] assResSaveResults = Database.insert(
							assResList,false
						);

						// Check if all AssessmentQuestionResponse records were inserted successfully.
						for (Database.SaveResult sr : assResSaveResults) {
							if (!sr.isSuccess()) {
								// Handle any errors occurred during AssessmentQuestionResponse insertion.
								for (Database.Error error : saveResult.getErrors()) {
									errorMsg +='Error ' +error.getFields() +'--' +
										error.getMessage() +'\n';
								}
								if (!String.isBlank(errorMsg)) {
									BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),
										'',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
									);
									throw new DMLException(errorMsg);
								}
							}
						}
					}
				} else {
					// Handle the insert error for the Assessment record.
					for (Database.Error error : saveResult.getErrors()) {
						BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
							System.now(),'Error ' +error.getFields() +'--' +error.getMessage(),
							BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
						);
					}
				}
			} else {
				// Log an error if no active version was found.'
				BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_LetsPersonlise.class.toString(),
                    '',
					System.now(),
                    emptyAssesment,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR                             
				);
                throw new DMLException(errorMsg); 
			}
		} catch (System.DmlException ex) {
			BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_LetsPersonlise.class.toString(),
				null,
                System.now()
			);
			throw new System.DmlException(assessmentFalied + ex.getMessage());
		}
	}

	/*
	 * @Description Method for deleting the unselected response from Introduction questionnaire.
	 * This method deletes the unselected response identified by the provided response ID.
	 *This method is used in biPspbIntroductionPageone and biPspbIntroductionQuestionnaire
	 * @param idOfRes  ID of the response to be deleted.
	 */

	@AuraEnabled
	public static void draftRespoDeletion(String idOfRes) {
		List<AssessmentQuestionResponse> responseToDelete = new List<AssessmentQuestionResponse>();

		// Step 1: Get the ID of the user performing the inserting.
		try {
			List<CareProgramEnrollee> enrolleeRecord = new List<CareProgramEnrollee>();
			List<CareProgramEnrollee> enrolledPatient = new List<CareProgramEnrollee>();

			String currentUserName = UserInfo.getName();
			String currentUserEmail = UserInfo.getUserEmail();
			//We are getting custom field from User Object. Hence we have to use SOQL.
			User currentUser = [
				SELECT Id, Name, BI_PSPB_Caregiver__c
				FROM User
				WHERE name = :currentUserName
				WITH USER_MODE
				LIMIT 1
			]; //'0057Z00000D849fQAB' caregiverid for testing.
             if(currentUser !=null)
            {
			if (currentUser.BI_PSPB_Caregiver__c == true) {
				caregiverAccount = [
					SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
					FROM Account
					WHERE
						Name = :currentUserName
						AND PersonEmail = :currentUserEmail
						AND IsPersonAccount = TRUE
						AND BI_PSPB_Selected_Patient_ID__c != NULL
					WITH USER_MODE
				];
				if (caregiverAccount !=null ) {
					caregvrAccountid = [
						SELECT id, Name, PersonEmail
						FROM account
						WHERE
							id = :caregiverAccount
								.BI_PSPB_Selected_Patient_ID__c
						WITH USER_MODE
					];
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						caregiversPatientaccountErr,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}

				if (!caregvrAccountid.isEmpty()) {
					// USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object.
					//using Healthcare license
					enrolleeRecord = [
						SELECT id, Name
						FROM CareProgramEnrollee
						WHERE AccountID = :caregvrAccountid[0].id
					];
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
						System.now(),caregiversSelectedpatienterrmsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}

				if (!enrolleeRecord.isEmpty()) {
					enrolleeId = enrolleeRecord[0].id;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						selctdPatieintsenrolleeerrormsg,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				List<Account> patientAccount = [
					SELECT id, Name, PersonEmail
					FROM account
					WHERE
						PersonEmail = :currentUserEmail
						AND Name = :currentUserName
					WITH USER_MODE
				];
				if (!patientAccount.isEmpty()) {
					// USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object.
					//using Healthcare license
					enrolledPatient = [
						SELECT id, Name
						FROM CareProgramEnrollee
						WHERE AccountID = :patientAccount[0].id
					];
					if (!enrolledPatient.isEmpty()) {
						enrolleeId = enrolledPatient[0].id;
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_LetsPersonlise.class.toString(),'',
						System.now(),patientAccounterrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			}
            }
             else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						undefinedUser,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			// USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object.
			//using Healthcare license
			if (idOfRes != null && !String.isBlank(idOfRes)) {
				responseToDelete = [
					SELECT Id, Assessment.BI_PSP_CareProgramEnrollee__c
					FROM AssessmentQuestionResponse
					WHERE
						Id = :idOfRes
						AND Assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
				];
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSP_LetsPersonlise.class.toString(),
					'',
					System.now(),
					emptyQuestionaresponse,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			if (!responseToDelete.isEmpty()) {
				Database.DeleteResult[] deleteResults = Database.delete(
					responseToDelete,
					false
				);
				for (Database.DeleteResult result : deleteResults) {
					if (!result.isSuccess()) {
						for (Database.Error error : result.getErrors()) {
							errorMsg +=
								'Error ' +
								error.getFields() +
								'--' +
								error.getMessage() +
								'\n';
						}
						if (!String.isBlank(errorMsg)) {
							BI_SFCOE_LOG_Util.logMessage(
								applicationName,
								BI_PSP_LetsPersonlise.class.toString(),
								'',
								System.now(),
								errorMsg,
								BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
							throw new AuraHandledException(errorMsg);
						}
					}
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSP_LetsPersonlise.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(respnsNotdeltd);
		}
	}
}