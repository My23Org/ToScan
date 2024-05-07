/*
@description Class used for retrieving care programm erolle with challenges associated 
and updating challenges related values.
Reason for using whithout sharing is we use Care Program Enrollee, 
which is a Health Cloud object;
hence, we cannot utilize user mode here.
History:
Version    Author      Date              Detail         Description
1.0        Gowsic N    5-Dec-2023        Created        Initial development
1.1        Saran S     20-Apr-2024       Updated        Add log, null check, descriptions   
*/
public without sharing class BI_PSP_ChallengeCtrl {
private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
'PSPB'
);
private static string applicationName = settings != null
? settings.BI_SFCOE_LOG_Application__c
: '';
private static String errorMsg = '';
private static String BI_PSP_Enrollee_NF = System.Label.BI_PSP_Enrollee_NF;
private static String BI_PSP_Caregiver_NF = System.Label.BI_PSP_Caregiver_NF;
private static String BI_PSP_Enrollee_NF_NS = System.Label.BI_PSP_Enrollee_NF_NS;
private static String BI_PSP_Challenge_Active = System.Label.BI_PSPB_Active;
private static String BI_PSP_Challenge_Available = System.Label.BI_PSP_Challenge_Available;
private static String BI_PSP_Challenge_Completed = System.Label.BI_PSP_Challenge_Completed;
private static String BI_PSP_Challenge_Level1 = System.Label.BI_PSP_Challenge_Level1;
private static String BI_PSP_Challenge_Level2 = System.Label.BI_PSP_Challenge_Level2;
private static String BI_PSP_Challenge_Level3 = System.Label.BI_PSP_Challenge_Level3;
private static String BI_PSP_Complete1ST = System.Label.BI_PSP_Complete1ST;
private static String BI_PSP_Complete4ST = System.Label.BI_PSP_Complete4ST;
private static String BI_PSP_CurrentlyCompleted = System.Label.BI_PSP_CurrentlyCompleted;
private static String BI_PSP_Assessment_WPAI = System.Label.BI_PSP_Assessment_WPAI;
private static String BI_PSP_AssessmentStatus_Completed = System.Label.BI_PSP_Completed;
private static String BI_PSP_Complete_WPAI = System.Label.BI_PSP_Complete_WPAI;
private static String BI_PSP_Assessment_PSS = System.Label.BI_PSP_Assessment_PSS;
private static String BI_PSP_Complete_PSS = System.Label.BI_PSP_Complete_PSS;
private static String BI_PSP_Assessment_DLQI = System.Label.BI_PSP_Assessment_DLQI;
private static String BI_PSP_Complete_DLQI = System.Label.BI_PSP_Complete_DLQI;
private static String BI_PSP_Challenges_ErrorMessage = System.Label.BI_PSP_Challenges_ErrorMessage;
private static String BI_PSP_UserId_ErrorMessage = System.Label.BI_PSP_UserId_ErrorMessage;
private static String BI_PSP_CareProgramTemplate_ErrorMessage = System.Label.BI_PSP_CareProgramTemplate_ErrorMessage;
private static String BI_PSP_careProgramEnrollee_ErrorMessage = System.Label.BI_PSP_careProgramEnrollee_ErrorMessage;
private static String BI_PSP_EnrolleeCaregiver_ErrorMessage = System.Label.BI_PSP_EnrolleeCaregiver_ErrorMessage;

/*
@description Method to retrieve information about a patient enrollee based on the provided user Id.
Returns a list of EnrollWrapper objects containing patient enrollee information and any error messages.
This method is exposed to Aura-enabled components and is cacheable.
@param userId The Id of the user for whom to retrieve the patient enrollee information.
@return List of EnrollWrapper objects containing patient enrollee information and any error messages.
*/
@AuraEnabled(cacheable=true)
public static List<EnrollWrapper> getEnrolle(String userId) {
// List to hold the results
List<EnrollWrapper> successList = new List<EnrollWrapper>();

try {
	if (!String.isBlank(userId)) {
	// We are using SOQL to get the User details because we need a custom field from User
	User userRecord = [
		SELECT Id, Name, Email, BI_PSPB_Caregiver__c
		FROM User
		WHERE Id = :userId
		LIMIT 1
	];

	// Check if the user record exists
	if (userRecord != null) {
		// Create a new EnrollWrapper object
		EnrollWrapper successMessage = new EnrollWrapper();
		String recName = userRecord.Name;
		String email = userRecord.Email;

		// Check if the user is a caregiver
		if (!userRecord.BI_PSPB_Caregiver__c) {
		// Retrieve associated accounts for non-caregiver users
		List<Account> accounts = [
			SELECT Id, Name, PersonEmail
			FROM Account
			WHERE
			Name = :recName
			AND PersonEmail = :email
			AND IsPersonAccount = TRUE
		];

		// Check if accounts exist
		if (!accounts.isEmpty()) {
			// Retrieve patient enrollee information
			CareProgramEnrollee patientEnrolle = [
			SELECT
				Id,
				BI_PSP_Total_Reward_Points__c,
				BI_PSP_Challenge_Rank__c
			FROM CareProgramEnrollee
			WHERE AccountId = :accounts[0].Id
			];

			// Check if patient enrollee exists
			if (patientEnrolle != null) {
			successMessage.patientEnrolle = patientEnrolle;
			} else {
			successMessage.error = BI_PSP_Enrollee_NF;
			}
		} else {
			successMessage.error = BI_PSP_Enrollee_NF;
		}
		// Add the EnrollWrapper object to the success list
		successList.add(successMessage);
		} else if (userRecord.BI_PSPB_Caregiver__c) {
		// Retrieve associated accounts for caregiver users
		List<Account> accounts = [
			SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
			FROM Account
			WHERE
			Name = :recName
			AND PersonEmail = :email
			AND IsPersonAccount = TRUE
			AND BI_PSPB_Selected_Patient_ID__c != NULL
		];

		// Check if accounts exist
		if (!accounts.isEmpty()) {
			// Retrieve enrollee caregiver records
			List<BI_PSPB_Enrollee_Caregiver__c> ecList = [
			SELECT
				Id,
				Name,
				BI_PSPB_Patient__r.Id,
				BI_PSPB_Patient__r.Name,
				BI_PSPB_Contact_Id__c,
				BI_PSPB_Status__c,
				BI_PSPB_Contact_Id__r.BI_PSPB_Selected_Patient_ID__c,
				BI_PSPB_Care_Program_Enrollee__c
			FROM BI_PSPB_Enrollee_Caregiver__c
			WHERE
				BI_PSPB_Patient__r.ID = :accounts[0]
				.BI_PSPB_Selected_Patient_ID__c
				AND BI_PSPB_Status__c = :BI_PSP_Challenge_Active
			];

			// Check if enrollee caregiver records exist
			if (
			!ecList.isEmpty() &&
			ecList[0].BI_PSPB_Care_Program_Enrollee__c != null
			) {
			// Retrieve patient enrollee information
			CareProgramEnrollee patientEnrolle = [
				SELECT
				Id,
				BI_PSP_Total_Reward_Points__c,
				BI_PSP_Challenge_Rank__c
				FROM CareProgramEnrollee
				WHERE Id = :ecList[0].BI_PSPB_Care_Program_Enrollee__c
			];

			// Check if patient enrollee exists
			if (patientEnrolle != null) {
				successMessage.patientEnrolle = patientEnrolle;
			} else {
				successMessage.error = BI_PSP_Enrollee_NF;
			}
			} else {
			successMessage.error = BI_PSP_Enrollee_NF_NS;
			}
		} else {
			successMessage.error = BI_PSP_Caregiver_NF;
		}
		// Add the EnrollWrapper object to the success list
		successList.add(successMessage);
		}
	}
	if (!successList.isEmpty()) {
		return successList;
	}
	//We are not throwing the error because we have a showerror functionality, so the there will be user interface issue if we throw the exception.
	} else {
	throw new AuraHandledException(BI_PSP_UserId_ErrorMessage);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSP_ChallengeCtrl.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSP_UserId_ErrorMessage);
}
return successList;
//We are not throwing the error because we have a showerror functionality, so the there will be user interface issue if we throw the exception.
}

/*
@description Method to retrieve individual challenges based on the provided challengeId.
Returns a list of HealthCloudGA__CarePlanTemplate__c objects representing individual challenges.
This method is exposed to Aura-enabled components and is cacheable.
@param challengeId The Id of the challenge for which to retrieve individual challenges.
@return List of HealthCloudGA__CarePlanTemplate__c objects representing individual challenges.
*/
@AuraEnabled(cacheable=true)
public static List<HealthCloudGA__CarePlanTemplate__c> getIndividualChallenges(
String challengeId
) {
try {
	if (!String.isBlank(challengeId)) {
	// Retrieve the corresponding CareProgramPlanTemplate record for the provided challengeId
	HealthCloudGA__CareProgramPlanTemplate__c careProgramm = [
		SELECT
		Id,
		HealthCloudGA__CareProgram__c,
		HealthCloudGA__CarePlanTemplate__r.Id
		FROM HealthCloudGA__CareProgramPlanTemplate__c
		WHERE Id = :challengeId
	];
	Id carePlanTemplateRecordTypeId = Schema.SObjectType.HealthCloudGA__CarePlanTemplate__c.getRecordTypeInfosByName()
		.get(System.label.BI_PSP_Challenge)
		.getRecordTypeId();
	List<HealthCloudGA__CarePlanTemplate__c> carePlanTemplateRecords = new List<HealthCloudGA__CarePlanTemplate__c>();
	// Retrieve individual challenges related to the CarePlanTemplate associated with the CareProgramPlanTemplate
	// In lwc checked the null
	carePlanTemplateRecords = [
		SELECT
		Id,
		BI_PSP_Challenge_Reward_Points__c,
		Name,
		HealthCloudGA__Description__c,
		BI_PSP_Challenge_Level__c,
		BI_PSP_Challenge_Image__c
		FROM HealthCloudGA__CarePlanTemplate__c
		WHERE
		Id = :careProgramm.HealthCloudGA__CarePlanTemplate__r.Id
		AND Name != NULL
		AND RecordTypeId = :carePlanTemplateRecordTypeId
	];
	if (
		carePlanTemplateRecords.size() > 0 &&
		!carePlanTemplateRecords.isEmpty()
	) {
		return carePlanTemplateRecords;
	} else {
		throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
	}
	} else {
	throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSP_ChallengeCtrl.class.toString(),
	null,
	System.now()
	);
	throw new AurahandledException(BI_PSP_CareProgramTemplate_ErrorMessage);
}
}

/*
@description Method to retrieve the rank of a care program enrollee based on their ID.
This method returns a list of care program enrollees with their corresponding ranks.
@param personAccountId The ID of the care program enrollee.
@return List of care program enrollees with their ranks if found, otherwise null.
*/
@AuraEnabled(cacheable=true)
public static List<CareProgramEnrollee> getRank(String personAccountId) {
try {
	// Retrieve the care program enrollee information based on the given ID
	if (!String.isBlank(personAccountId)) {
	List<CareProgramEnrollee> patientEnrolle = [
		SELECT
		Id,
		BI_PSP_Total_Reward_Points__c,
		BI_PSP_DOC_Novice__c,
		BI_PSP_DOC_Intermediate__c,
		BI_PSP_DOC_Proficient__c,
		BI_PSP_DOC_Expert__c,
		BI_PSP_Challenge_Rank__c,
		BI_PSP_DOC_Beginner__c
		FROM CareProgramEnrollee
		WHERE Id = :personAccountId
	];

	// Check if any care program enrollee records were found
	if (patientEnrolle.size() > 0 && !patientEnrolle.isEmpty()) {
		// Return the list of care program enrollees with their ranks
		return patientEnrolle;
	} else {
		throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
		// If no care program enrollee records were found, return null
	}
	} else {
	throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSP_ChallengeCtrl.class.toString(),
	null,
	System.now()
	);
	throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
}
}

/*
@description Method to retrieve random challenges based on the given person account ID and status.
@param personAccountId The ID of the care program enrollee.
@param status The status of the challenges to retrieve (e.g., Active, Completed).
@return List of ChallengeWrapperCommon containing available challenges and their details, or null if no challenges found.
*/
@AuraEnabled(cacheable=true)
public static List<ChallengeWrapperCommon> getRandomChallenges(
String personAccountId,
String status
) {
List<ChallengeWrapperCommon> successList = new List<ChallengeWrapperCommon>();
try {
	// Initialize a list to store the retrieved challenges

	Id awardRecordTypeId = Schema.SObjectType.Award.getRecordTypeInfosByName()
	.get(System.label.BI_PSP_Challenge)
	.getRecordTypeId();
	CareProgramEnrollee patientEnrolle = new CareProgramEnrollee();
	// Retrieve the care program enrollee based on the given ID
	if (!String.isBlank(personAccountId)) {
	patientEnrolle = [
		SELECT Id, AccountId, BI_PSP_Challenge_Rank__c
		FROM CareProgramEnrollee
		WHERE Id = :personAccountId
	];
	}
	// Retrieve the list of challenges associated with the care program enrollee, ordered by last modified date
	List<Award> challengeList = [
	SELECT
		Id,
		BI_PSP_Care_Program_Plan_Template__r.Id,
		BI_PSP_Status__c,
		BI_PSP_Care_Program_Plan_Template__c
	FROM Award
	WHERE
		RecordTypeId = :awardRecordTypeId
		AND BI_PSP_Care_Program_Enrollee__c = :patientEnrolle.Id
	ORDER BY LastModifiedDate DESC
	];
	if (!challengeList.isEmpty() && !String.isBlank(status)) {
	// Loop through each retrieved challenge
	for (Award getAllChallenge : challengeList) {
		ChallengeWrapperCommon successMessage = new ChallengeWrapperCommon();
		// Check if the challenge is not null and has the specified status
		if (
		getAllChallenge.BI_PSP_Care_Program_Plan_Template__c != null &&
		getAllChallenge.BI_PSP_Status__c == status
		) {
		// Set the available challenge ID and the ID of the challenge to update in the successMessage
		successMessage.availableChallenge = getAllChallenge.BI_PSP_Care_Program_Plan_Template__r.Id;
		successMessage.challengeIdToUpdate = getAllChallenge.Id;
		// Check if the challenge status is 'Completed', and set the image rank accordingly
		if (
			getAllChallenge.BI_PSP_Status__c ==
			BI_PSP_AssessmentStatus_Completed
		) {
			successMessage.imageRank = patientEnrolle.BI_PSP_Challenge_Rank__c;
		}
		}
		// Add the successMessage to the successList
		successList.add(successMessage);
	}
	}
	// Check if any challenges were retrieved
	if (patientEnrolle != null || successList.size() > 0) {
	return successList; // Return the list of retrieved challenges
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSP_ChallengeCtrl.class.toString(),
	null,
	System.now()
	);
	throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
}
return successList; //we are having rendering functionality for null, so AurahandledException is not thrown
}

/*
@description Method to update challenges based on the provided challenge ID and status.
@param challenge The ID of the challenge to update.
@param activeAvailable The status to set for the challenge (Active, Available, Completed).
@return List of ChallengeWrapper containing details of the updated challenge, or an error message if an exception occurs.
*/
@AuraEnabled
public static list<ChallengeWrapper> updateChallenges(
String challenge,
string activeAvailable
) {
try {
	boolean validOne;
	boolean saverecord = true;
	list<Assessment> assesList;
	ChallengeWrapper successMessage = new ChallengeWrapper();
	Award challengetoUpdate = new Award();
	if (!String.isBlank(challenge)) {
	challengetoUpdate = [
		SELECT
		id,
		BI_PSP_Care_Program_Enrollee__r.Id,
		BI_PSP_Care_Program_Enrollee__c,
		BI_PSP_Care_Program_Plan_Template__r.id,
		BI_PSP_Status__c,
		BI_PSP_Care_Program_Plan_Template__c
		FROM Award
		WHERE id = :challenge
	];
	} else {
	throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
	}
	if (!String.isBlank(activeAvailable)) {
	if (activeAvailable == BI_PSP_Challenge_Active) {
		challengetoUpdate.BI_PSP_Status__c = BI_PSP_Challenge_Active;
	} else if (activeAvailable == BI_PSP_Challenge_Available) {
		challengetoUpdate.BI_PSP_Status__c = BI_PSP_Challenge_Available;
	} else if (activeAvailable == BI_PSP_Challenge_Completed) {
		challengetoUpdate.BI_PSP_Status__c = BI_PSP_Challenge_Completed;
	}
	} else {
	throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
	}
	list<HealthCloudGA__CareProgramPlanTemplate__c> careProgramm = [
	SELECT id, Name, HealthCloudGA__CarePlanTemplate__r.id
	FROM HealthCloudGA__CareProgramPlanTemplate__c
	WHERE id = :challengetoUpdate.BI_PSP_Care_Program_Plan_Template__r.id
	];
	if (careProgramm.Size() > 0 && !careProgramm.isEmpty()) {
	//Validation starts
	list<HealthCloudGA__CarePlanTemplate__c> carePlan = [
		SELECT
		id,
		Name,
		BI_PSP_Challenge_Level__c,
		HealthCloudGA__Description__c
		FROM HealthCloudGA__CarePlanTemplate__c
		WHERE
		id = :careProgramm[0].HealthCloudGA__CarePlanTemplate__r.id
		AND (HealthCloudGA__Description__c = :System.Label.BI_PSP_SymptomOne
		OR HealthCloudGA__Description__c = :System.Label.BI_PSP_SymptomTwo
		OR HealthCloudGA__Description__c = :System.Label.BI_PSP_QuestionnaireLevel1
		OR HealthCloudGA__Description__c = :System.Label.BI_PSP_QuestionnaireLevel2
		OR HealthCloudGA__Description__c = :System.Label.BI_PSP_QuestionnaireLevel3)
	];
	if (
		carePlan.size() > 0 &&
		!carePlan.isEmpty() &&
		activeAvailable == BI_PSP_Challenge_Completed
	) {
		assesList = [
		SELECT
			id,
			Name,
			AssessmentStatus,
			BI_PSP_DateForCQ__c,
			BI_PSP_CareProgramEnrollee__c
		FROM Assessment
		WHERE
			BI_PSP_CareProgramEnrollee__c = :challengetoUpdate.BI_PSP_Care_Program_Enrollee__r.Id
		];
		if (
		carePlan[0].HealthCloudGA__Description__c ==
		System.Label.BI_PSP_SymptomOne &&
		carePlan[0].BI_PSP_Challenge_Level__c == BI_PSP_Challenge_Level1
		) {
		List<BI_PSP_Symptom_Tracker__c> validateSymptom = [
			SELECT id, BI_PSP_Care_Program_Enrollee__c
			FROM BI_PSP_Symptom_Tracker__c
			WHERE
			BI_PSP_Care_Program_Enrollee__c = :challengetoUpdate.BI_PSP_Care_Program_Enrollee__r.Id
			AND CreatedDate = THIS_MONTH
		];
		if (validateSymptom.size() >= 1 && !validateSymptom.isEmpty()) {
			saverecord = true;
			//update challengetoUpdate;
			successMessage.challengeUpdated = challengetoUpdate;
			successMessage.percentage = 100;
		} else {
			saverecord = false;
			successMessage.error = BI_PSP_Complete1ST;
			successMessage.percentage = 0;
		}
		} else if (
		carePlan[0].HealthCloudGA__Description__c ==
		System.Label.BI_PSP_SymptomTwo &&
		carePlan[0].BI_PSP_Challenge_Level__c == BI_PSP_Challenge_Level2
		) {
		List<BI_PSP_Symptom_Tracker__c> validateSymptomMonth = [
			SELECT id, BI_PSP_Care_Program_Enrollee__c
			FROM BI_PSP_Symptom_Tracker__c
			WHERE
			BI_PSP_Care_Program_Enrollee__c = :challengetoUpdate.BI_PSP_Care_Program_Enrollee__r.Id
			AND CreatedDate = THIS_MONTH
		];
		if (
			validateSymptomMonth.size() >= 4 &&
			!validateSymptomMonth.isEmpty()
		) {
			saverecord = true;
			//update challengetoUpdate;
			successMessage.challengeUpdated = challengetoUpdate;
			successMessage.percentage = 100;
		} else {
			saverecord = false;
			successMessage.error =
			BI_PSP_Complete4ST +
			validateSymptomMonth.size() +
			BI_PSP_CurrentlyCompleted;
			successMessage.percentage =
			(Decimal) validateSymptomMonth.size() /
			4 *
			100;
		}
		} else if (
		carePlan[0].HealthCloudGA__Description__c ==
		System.Label.BI_PSP_SymptomThree &&
		carePlan[0].BI_PSP_Challenge_Level__c == BI_PSP_Challenge_Level3
		) {
		//update challengetoUpdate;
		saverecord = true;
		successMessage.challengeUpdated = challengetoUpdate;
		successMessage.percentage = 100;
		} else if (
		carePlan[0].HealthCloudGA__Description__c ==
		System.Label.BI_PSP_QuestionnaireLevel1 &&
		carePlan[0].BI_PSP_Challenge_Level__c == BI_PSP_Challenge_Level1
		) {
		if (assesList.size() > 0 && !assesList.isEmpty()) {
			for (Assessment asseloop : assesList) {
			if (
				asseloop.Name.contains(BI_PSP_Assessment_WPAI) &&
				asseloop.AssessmentStatus ==
				BI_PSP_AssessmentStatus_Completed &&
				asseloop.BI_PSP_DateForCQ__c != null
			) {
				validOne = true;
				break;
			} else {
				validOne = false;
			}
			}
			if (validOne) {
			saverecord = true;
			//update challengetoUpdate;
			successMessage.challengeUpdated = challengetoUpdate;
			successMessage.percentage = 100;
			} else {
			saverecord = false;
			successMessage.error = BI_PSP_Complete_WPAI;
			successMessage.percentage = 0;
			}
		} else {
			saverecord = false;
			successMessage.error = BI_PSP_Complete_WPAI;
			successMessage.percentage = 0;
		}
		} else if (
		carePlan[0].HealthCloudGA__Description__c ==
		System.Label.BI_PSP_QuestionnaireLevel2 &&
		carePlan[0].BI_PSP_Challenge_Level__c == BI_PSP_Challenge_Level2
		) {
		if (assesList.size() > 0 && !assesList.isEmpty()) {
			for (Assessment asseloop : assesList) {
			if (
				asseloop.Name.contains(BI_PSP_Assessment_PSS) &&
				asseloop.AssessmentStatus ==
				BI_PSP_AssessmentStatus_Completed &&
				asseloop.BI_PSP_DateForCQ__c != null
			) {
				validOne = true;
				break;
			} else {
				validOne = false;
			}
			}
			if (validOne) {
			saverecord = true;
			//update challengetoUpdate;
			successMessage.challengeUpdated = challengetoUpdate;
			successMessage.percentage = 100;
			} else {
			saverecord = false;
			successMessage.error = BI_PSP_Complete_PSS;
			successMessage.percentage = 0;
			}
		} else {
			saverecord = false;
			successMessage.error = BI_PSP_Complete_PSS;
			successMessage.percentage = 0;
		}
		} else if (
		carePlan[0].HealthCloudGA__Description__c ==
		System.Label.BI_PSP_QuestionnaireLevel3 &&
		carePlan[0].BI_PSP_Challenge_Level__c == BI_PSP_Challenge_Level3
		) {
		if (assesList.size() > 0 && !assesList.isEmpty()) {
			for (Assessment asseloop : assesList) {
			if (
				asseloop.Name.contains(BI_PSP_Assessment_DLQI) &&
				asseloop.AssessmentStatus ==
				BI_PSP_AssessmentStatus_Completed &&
				asseloop.BI_PSP_DateForCQ__c != null
			) {
				validOne = true;
				break;
			} else {
				validOne = false;
			}
			}
			if (validOne) {
			saverecord = true;
			//update challengetoUpdate;
			successMessage.challengeUpdated = challengetoUpdate;
			successMessage.percentage = 100;
			} else {
			saverecord = false;
			successMessage.error = BI_PSP_Complete_DLQI;
			successMessage.percentage = 0;
			}
		} else {
			saverecord = false;
			successMessage.error = BI_PSP_Complete_DLQI;
			successMessage.percentage = 0;
		}
		}
	} else {
		//update challengetoUpdate;
		saverecord = true;
		successMessage.challengeUpdated = challengetoUpdate;
		successMessage.percentage = 100;
	} //Validation ends
	if (saverecord) {
		Database.SaveResult[] saveResults4 = Database.update(
		new List<Award>{ challengetoUpdate },
		false
		);
		for (Database.SaveResult saveResults : saveResults4) {
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
		}
		if (String.isNotBlank(errorMsg)) {
		BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
			saveResults4,
			BI_PSP_ChallengeCtrl.class.toString(),
			System.now()
		);
		throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
		}
	}
	}

	List<ChallengeWrapper> successList = new List<ChallengeWrapper>{
	successMessage
	};
	if (!successList.isEmpty()) {
	return successList;
	} else {
	throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
	}
} catch (Exception ex) {
	ChallengeWrapper errorMessage = new ChallengeWrapper();
	errorMessage.error = ex.getMessage();
	List<ChallengeWrapper> errorList = new List<ChallengeWrapper>{
	errorMessage
	};
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSP_ChallengeCtrl.class.toString(),
	null,
	System.now()
	);
	if (!errorList.isEmpty()) {
	return errorList; // In LWC we are doing the null check for this error message list and there are some functionality that is dependent on this errorlist
	} else {
	throw new AurahandledException(BI_PSP_Challenges_ErrorMessage);
	}
}
}

/*
@description Method to retrieve the last active challenge for a given enrollee.
@param enrolleId The ID of the enrollee for whom to retrieve the last active challenge.
@return HealthCloudGA__CarePlanTemplate__c The last active challenge.
*/
@AuraEnabled(cacheable=true)
public static HealthCloudGA__CarePlanTemplate__c getLastActiveChallenges(
String enrolleId
) {
try {
	if (!String.isBlank(enrolleId)) {
	// Retrieve the record type ID for the Award object
	Id awardRecordType = Schema.SObjectType.Award.getRecordTypeInfosByName()
		.get(System.label.BI_PSP_Challenge)
		.getRecordTypeId();
	// Query the last active award for the given enrollee
	List<Award> lastActive = [
		SELECT
		Id,
		BI_PSP_Care_Program_Plan_Template__c,
		BI_PSP_Care_Program_Enrollee__c
		FROM Award
		WHERE
		RecordTypeId = :awardRecordType
		AND BI_PSP_Care_Program_Enrollee__c = :enrolleId
		AND BI_PSP_Status__c = :BI_PSP_Challenge_Active
		ORDER BY LastModifiedDate DESC
		LIMIT 1
	];
	// If a last active award is found
	if (lastActive.size() > 0 && !lastActive.isEmpty()) {
		// Retrieve the associated care program plan template
		HealthCloudGA__CareProgramPlanTemplate__c careProgramm = [
		SELECT
			Id,
			HealthCloudGA__CareProgram__c,
			HealthCloudGA__CarePlanTemplate__r.Id
		FROM HealthCloudGA__CareProgramPlanTemplate__c
		WHERE Id = :lastActive[0].BI_PSP_Care_Program_Plan_Template__c
		];

		// Retrieve the corresponding care plan template
		HealthCloudGA__CarePlanTemplate__c retrivedCarePlanTemplates = new HealthCloudGA__CarePlanTemplate__c();
		retrivedCarePlanTemplates = [
		SELECT
			Id,
			BI_PSP_Challenge_Reward_Points__c,
			Name,
			HealthCloudGA__Description__c,
			BI_PSP_Challenge_Level__c,
			BI_PSP_Challenge_Image__c
		FROM HealthCloudGA__CarePlanTemplate__c
		WHERE
			Id = :careProgramm.HealthCloudGA__CarePlanTemplate__r.Id
			AND Name != NULL
		];

		if (retrivedCarePlanTemplates != null) {
		return retrivedCarePlanTemplates;
		} else {
		throw new AuraHandledException(BI_PSP_Challenges_ErrorMessage);
		}
	} else {
		return null; //null has to be returned because the widget challenge first time start challenge requires null value to be returned
	}
	} else {
	BI_SFCOE_LOG_Util.logMessage(
		applicationName,
		BI_PSPB_LoginCtrl.class.toString(),
		'',
		System.now(),
		BI_PSP_EnrolleeCaregiver_ErrorMessage,
		BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
	);
	throw new AuraHandledException(BI_PSP_Challenges_ErrorMessage);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSP_ChallengeCtrl.class.toString(),
	null,
	System.now()
	);

	throw new AuraHandledException(BI_PSP_Challenges_ErrorMessage);
}
}

/*
@description Wrapper class to hold information about a patient enrollee and any error messages.
*/
public class EnrollWrapper {
/* The patient enrollee information.*/
@AuraEnabled
public CareProgramEnrollee patientEnrolle;

/* Any error message associated with the patient enrollee.*/
@AuraEnabled
public String error;
}

/* @description Wrapper class for Challenge details including the updated challenge, error message, and completion percentage.*/
public class ChallengeWrapper {
// AuraEnabled attributes to be exposed to the client side

// The updated challenge
@AuraEnabled
public Award challengeUpdated;

// Error message if an exception occurs
@AuraEnabled
public String error;

// Completion percentage of the challenge
@AuraEnabled
public Decimal percentage;
}
/*
@description Wrapper class to represent common attributes of a challenge.
This class is used to structure data related to challenges in Aura-enabled components.
*/
public class ChallengeWrapperCommon {
// Represents the available challenge Id
@AuraEnabled
public String availableChallenge;

// Represents the challenge Id to update
@AuraEnabled
public String challengeIdToUpdate;

// Represents the rank of the challenge image
@AuraEnabled
public String imageRank;
}
}