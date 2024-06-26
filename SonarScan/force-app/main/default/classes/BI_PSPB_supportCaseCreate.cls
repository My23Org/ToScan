/*
@description Apex class for creating and managing support cases related to the BI_PSPB module.
History
Version	Author			Date		Detail		Description
59		Niyas		06-01-2024		Created		Initial Version
59		Niyas		18-04-2024		Updated		Code review changes
*/
public with sharing class BI_PSPB_supportCaseCreate {
private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
'PSPB'
);
private static String applicationName = settings != null
? settings.BI_SFCOE_LOG_Application__c
: '';
private static String BI_PSPB_caseRecordTypeName = System.Label.BI_PSPB_Support_Center;
/*
@description  Creates a new support case.
@param accountId The ID of the associated account.
@param Type The type of the case.
@param subType The subtype of the case.
@param Description The description of the case.
@param fileIds The IDs of the files to be linked to the case.
@return The ID of the created case.
*/
@AuraEnabled(cacheable=false)
public static id createCase(LeadWrapper wrapper, List<String> fileIds) {
//We are not checking LeadWrapper because all fields are mandatory in UI.
Case supportCaseToInsert = new Case();
try {
	String errorMsg = '';
	//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
	CareProgramEnrollee cpeIds = [
	SELECT Id, AccountId
	FROM CareProgramEnrollee
	WHERE Id = :wrapper.accountId
	LIMIT 1
	];
	if (cpeIds != null) {
	String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
		.get(BI_PSPB_caseRecordTypeName)
		.getRecordTypeId();
	if (String.isBlank(recordTypeId)) {
		throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgRecordTypeNotFound
		); // Return null if leadId is blank
	}
	supportCaseToInsert.Type = wrapper.type;
	supportCaseToInsert.BI_PSPB_Sub_Type__c = wrapper.subType;
	supportCaseToInsert.Description = wrapper.description;
	supportCaseToInsert.BI_PSP_Patient__c = cpeIds.Id;
	supportCaseToInsert.AccountId = cpeIds.AccountId;
	supportCaseToInsert.RecordTypeId = recordTypeId;
	supportCaseToInsert.Status = BI_PSPB_constantsClass.submitted;
	Database.SaveResult[] saveResults = Database.insert(
		new List<Case>{ supportCaseToInsert },
		false,
		AccessLevel.USER_MODE
	);
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
	if (String.isNotBlank(errorMsg)) {
		BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
		saveResults,
		BI_PSPB_supportCaseCreate.class.toString(),
		System.now()
		);
		throw new AuraHandledException(BI_PSPB_constantsClass.errorMsgInsert);
	}
	if (supportCaseToInsert == null) {
		throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgCaseRecordNotFound
		);
	} else {
		linkFilesToCase(supportCaseToInsert.Id, fileIds);
		return supportCaseToInsert.id;
	}
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgRecordNotFound
	);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_supportCaseCreate.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}
/*
@description Associates files with a specified Case record by creating ContentDocumentLink records.
Each ContentDocumentLink associates a file with the Case.
@param caseId The Id of the Case record to which the files will be linked.
@param fileIds A List of file Ids (ContentDocumentIds) to be linked to the Case.
@throws Exception If an error occurs during the insertion of ContentDocumentLink records.
*/
@AuraEnabled(cacheable=false)
public static void linkFilesToCase(Id caseId, List<String> fileIds) {
try {
	String errorMsg = '';
	if (String.isBlank(caseId) || fileIds.isEmpty()) {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgCaseRecordNotFound
	);
	}
	List<ContentDocumentLink> fileLinks = new List<ContentDocumentLink>();
	for (String fileId : fileIds) {
	ContentDocumentLink link = new ContentDocumentLink();
	link.ContentDocumentId = fileId;
	link.LinkedEntityId = caseId;
	link.ShareType = 'I';
	fileLinks.add(link);
	}
	Database.SaveResult[] saveResults = Database.insert(fileLinks, false);
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
	if (String.isNotBlank(errorMsg)) {
	BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
		saveResults,
		BI_PSPB_supportCaseCreate.class.toString(),
		System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.errorMsgInsert);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_supportCaseCreate.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}
/*
@description  Updates a Case record with the provided information and links files to it.
@param recId The Id of the Case record to update.
@param Type The new Type value for the Case.
@param Description The new Description value for the Case.
@param fileIds A List of file Ids (ContentDocumentIds) to link to the Case.
@return The Id of the updated Case record.
*/
@AuraEnabled(cacheable=false)
public static Id updateCase(
String recId,
String Type,
String Description,
List<String> fileIds
) {
try {
	String errorMsg = '';
	Case supportCaseToUpdate = null; // Declare the variable outside the try block
	if (
	String.isBlank(recId) ||
	String.isBlank(Type) ||
	String.isBlank(Description)
	) {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgCaseRecordNotFound
	);
	}
	//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
	supportCaseToUpdate = [
	SELECT Id, Description
	FROM Case
	WHERE Id = :recId
	LIMIT 1
	];
	if (supportCaseToUpdate == null) {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgCaseRecordNotFound
	);
	}
	supportCaseToUpdate.Type = Type;
	supportCaseToUpdate.Description = Description;
	supportCaseToUpdate.Status = BI_PSPB_constantsClass.submitted;
	Database.SaveResult[] saveResults = Database.update(
	new List<Case>{ supportCaseToUpdate },
	false,
	AccessLevel.USER_MODE
	);
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
	if (String.isNotBlank(errorMsg)) {
	BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
		saveResults,
		BI_PSPB_supportCaseCreate.class.toString(),
		System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.errorMsgUpdate);
	}
	if (supportCaseToUpdate == null) {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgRecordNotFound
	);
	}
	linkFilesToCase(supportCaseToUpdate.Id, fileIds);
	return supportCaseToUpdate != null ? supportCaseToUpdate.Id : null;
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_supportCaseCreate.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}
/*
@description  Updates a Case record with the provided information and links files to it.
@param recId The Id of the Case record to update.
@param Type The new Type value for the Case.
@param Description The new Description value for the Case.
@param fileIds A List of file Ids (ContentDocumentIds) to link to the Case.
@return The Id of the updated Case record.
*/

@AuraEnabled(cacheable=false)
public static id caseDraft(LeadWrapper wrapper, List<String> fileIds) {
//We are not checking LeadWrapper because all fields are mandatory in UI.
Case supportCaseToUpdate = new Case();
try {
	String errorMsg = '';
	//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
	CareProgramEnrollee cpeIds = [
	SELECT Id, AccountId
	FROM CareProgramEnrollee
	WHERE Id = :wrapper.accountId
	LIMIT 1
	];
	if (cpeIds != null) {
	String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
		.get(BI_PSPB_caseRecordTypeName)
		.getRecordTypeId();
	if (String.isBlank(recordTypeId)) {
		throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgRecordTypeNotFound
		);
	}
	supportCaseToUpdate.Type = wrapper.type;
	supportCaseToUpdate.BI_PSPB_Sub_Type__c = wrapper.subType;
	supportCaseToUpdate.Description = wrapper.description;
	supportCaseToUpdate.BI_PSP_Patient__c = cpeIds.Id;
	supportCaseToUpdate.AccountId = cpeIds.AccountId;
	supportCaseToUpdate.RecordTypeId = recordTypeId;
	supportCaseToUpdate.Status = BI_PSPB_constantsClass.draft;
	Database.SaveResult[] saveResults = Database.insert(
		new List<Case>{ supportCaseToUpdate },
		false,
		AccessLevel.USER_MODE
	);
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
	if (String.isNotBlank(errorMsg)) {
		BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
		saveResults,
		BI_PSPB_supportCaseCreate.class.toString(),
		System.now()
		);
		throw new AuraHandledException(BI_PSPB_constantsClass.errorMsgInsert);
	}
	if (supportCaseToUpdate == null) {
		throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgCaseRecordNotFound
		);
	} else {
		linkFilesToCase(supportCaseToUpdate.Id, fileIds);
		return supportCaseToUpdate.id;
	}
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgRecordNotFound
	);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_supportCaseCreate.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}

/*
@description Retrieves the latest draft Case record related to a specified Care Program Enrollee.
@param accountId The Id of the Care Program Enrollee for which to retrieve the draft Case record.
@return The latest draft Case record related to the specified Care Program Enrollee, or null if no matching records are found.
*/

@AuraEnabled(cacheable=true)
public static List<Case> getPSPCaseRecordsMedical(String accountId) {
if (String.isBlank(accountId)) {
	throw new AuraHandledException(
	BI_PSPB_constantsClass.errorMsgPatientIdNotFound
	);
}
try {
	List<Case> relatedCases = new List<Case>();
	//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
	List<CareProgramEnrollee> enrollees = [
	SELECT Id, AccountId
	FROM CareProgramEnrollee
	WHERE Id = :accountId
	LIMIT 1
	];
	if (!enrollees.isEmpty()) {
	Id relatedCareProgramEnrolleeId = enrollees[0].AccountId;
	// Retrieve cases with Type = 'Medical Information Enquiry'
	//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
	relatedCases = [
		SELECT
		Id,
		BI_PSPB_Sub_Type__c,
		Description,
		BI_PSP_Patient__r.AccountId,
		CreatedDate
		FROM Case
		WHERE
		AccountId = :relatedCareProgramEnrolleeId
		AND (Status = :BI_PSPB_constantsClass.draft
		OR Status = :BI_PSPB_constantsClass.NeedMoreInfo)
		AND Type = :BI_PSPB_constantsClass.MedicalInfoEnquiry
		ORDER BY CreatedDate DESC
		LIMIT 1
	];
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgRecordNotFound
	);
	}
	if (relatedCases != null) {
	return relatedCases;
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.recordcannotfound
	);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_supportCaseCreate.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}

/*
@description  Retrieves the most recent Case record with specific criteria related to adverse events reporting.
@param accountId The Id of the CareProgramEnrollee record associated with the Case.
@return The most recent Case record meeting the criteria, or null if no matching record is found.
*/

@AuraEnabled(cacheable=true)
public static List<Case> getPSPCaseRecordsReport(String accountId) {
if (String.isBlank(accountId)) {
	throw new AuraHandledException(
	BI_PSPB_constantsClass.errorMsgPatientIdNotFound
	);
}
try {
	List<Case> relatedCases = new List<Case>();
	//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
	List<CareProgramEnrollee> enrollees = [
	SELECT Id, AccountId
	FROM CareProgramEnrollee
	WHERE Id = :accountId
	LIMIT 1
	];
	if (!enrollees.isEmpty()) {
	Id relatedCareProgramEnrolleeId = enrollees[0].AccountId;
	//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
	relatedCases = [
		SELECT
		Id,
		BI_PSPB_Sub_Type__c,
		Description,
		BI_PSP_Patient__r.AccountId,
		CreatedDate
		FROM Case
		WHERE
		AccountId = :relatedCareProgramEnrolleeId
		AND (Status = :BI_PSPB_constantsClass.draft
		OR Status = :BI_PSPB_constantsClass.NeedMoreInfo)
		AND Type = :BI_PSPB_constantsClass.ReportAdverseEvents
		ORDER BY CreatedDate DESC
		LIMIT 1
	];
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgRecordNotFound
	);
	}
	if (relatedCases.isEmpty()) {
	return relatedCases;
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.recordcannotfound
	);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_supportCaseCreate.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}
/*
@description  Retrieves a list of draft Case records related to a specified account.
@param accountId The Id of the account for which to retrieve related Case records.
@return A list of draft Case records related to the specified account.
*/

@AuraEnabled(cacheable=true)
public static List<Case> getPSPCaseRecordsPlatformSupport(String accountId) {
try {
	if (String.isBlank(accountId)) {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgPatientIdNotFound
	);
	}
	List<Case> relatedCases = new List<Case>();
	//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
	List<CareProgramEnrollee> enrollees = [
	SELECT Id, AccountId
	FROM CareProgramEnrollee
	WHERE Id = :accountId
	LIMIT 1
	];

	if (!enrollees.isEmpty()) {
	Id relatedCareProgramEnrolleeId = enrollees[0].AccountId;
	//Since Careprogramenrollee lookup field is used we cannot use USER_MODE here.
	relatedCases = [
		SELECT
		Id,
		BI_PSPB_Sub_Type__c,
		Description,
		BI_PSP_Patient__r.AccountId,
		CreatedDate
		FROM Case
		WHERE
		AccountId = :relatedCareProgramEnrolleeId
		AND (Status = :BI_PSPB_constantsClass.draft
		OR Status = :BI_PSPB_constantsClass.NeedMoreInfo)
		AND Type = :BI_PSPB_constantsClass.PlatformSupport
		ORDER BY CreatedDate DESC
		LIMIT 1
	];
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgRecordNotFound
	);
	}
	if (relatedCases != null) {
	return relatedCases;
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.recordcannotfound
	);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_supportCaseCreate.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}
/*
@description  Wrapper classes are used to hold a group of related data fields together.used to updateCaregivers,updateCaregiverDetails
updatePatientExcistInfo,updatePatientorCargiverInfo.
@param accountId The new accountId of the patient or caregiver.
@param type The new type of the patient or caregiver.
@param subType The new subtype address of the patient or caregiver.
@param description The new description of the patient or caregiver.
*/
public class LeadWrapper {
@AuraEnabled
public String accountId { get; set; }
@AuraEnabled
public String type { get; set; }
@AuraEnabled
public String subType { get; set; }
@AuraEnabled
public String description { get; set; }
}
}