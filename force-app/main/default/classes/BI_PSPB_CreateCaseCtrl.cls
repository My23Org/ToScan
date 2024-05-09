/*
@description This class is used to insert case records for CRM.
History
Version	Author			Date		Detail		Description
59		Niyas		06-01-2024		Created		Initial Version
59		Niyas		18-04-2024		Updated		Code review changes
*/
public with sharing class BI_PSPB_CreateCaseCtrl {
private static String BI_PSPB_caseRecordTypeName = System.Label.BI_PSPB_Support_Center;
private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
'PSPB'
);
private static String applicationName = settings != null
? settings.BI_SFCOE_LOG_Application__c
: '';
private static String spevigo = System.Label.BI_PSPB_Spevigo;
/*
@description Creates a new case with the provided information.
@param Type The type of the case.
@param subType The subtype of the case.
@param description The description of the case.
@param patient The patient associated with the case.
@return The Id of the newly created case.
*/
@AuraEnabled
public static Id createCase(
String Type,
String subType,
String description,
String patient
) {
try {
	String errorMsg = '';
	String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
	.get(BI_PSPB_caseRecordTypeName)
	.getRecordTypeId();
	if (
	String.isBlank(Type) &&
	String.isBlank(subType) &&
	String.isBlank(description) &&
	String.isBlank(patient) &&
	String.isBlank(recordTypeId)
	) {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgCaseRecordNotFound
	);
	}
	Case newCase = new Case(
	BI_PSP_Patient__c = patient,
	Type = Type,
	BI_PSPB_Sub_Type__c = subType,
	Description = description,
	Status = BI_PSPB_constantsClass.submitted,
	RecordTypeId = recordTypeId // Assuming the case origin is from a web source
	// Add more fields as needed
	);
	Database.SaveResult saveResult = Database.insert(
	newCase,
	false,
	AccessLevel.USER_MODE
	);
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
	if (String.isNotBlank(errorMsg)) {
	List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
	saveResultList.add(saveResult);
	BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
		saveResultList,
		BI_PSPB_CreateCaseCtrl.class.toString(),
		System.now()
	);
	throw new AuraHandledException(errorMsg);
	}
	if (newCase != null) {
	return newCase.Id;
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.recordcannotfound
	);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_CreateCaseCtrl.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}
/*
Creates a new draft case with the provided information.
@param Type The type of the case.
@param subType The subtype of the case.
@param description The description of the case.
@param patient The patient associated with the case.
@return The Id of the newly created draft case.
*/
@AuraEnabled
public static Id draftCase(
String Type,
String subType,
String description,
String patient
) {
try {
	String errorMsg = '';
	String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
	.get(BI_PSPB_caseRecordTypeName)
	.getRecordTypeId();
	if (
	String.isBlank(Type) &&
	String.isBlank(subType) &&
	String.isBlank(description) &&
	String.isBlank(patient) &&
	String.isBlank(recordTypeId)
	) {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.errorMsgCaseRecordNotFound
	);
	}
	Case newCase = new Case(
	BI_PSP_Patient__c = patient,
	Type = Type,
	BI_PSPB_Sub_Type__c = subType,
	Description = description,
	Status = BI_PSPB_constantsClass.draft,
	RecordTypeId = recordTypeId // Assuming the case origin is from a web source
	// Add more fields as needed
	);
	Database.SaveResult saveResult = Database.insert(
	newCase,
	false,
	AccessLevel.USER_MODE
	);
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
	if (String.isNotBlank(errorMsg)) {
	List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
	saveResultList.add(saveResult);
	BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
		saveResultList,
		BI_PSPB_CreateCaseCtrl.class.toString(),
		System.now()
	);
	throw new AuraHandledException(errorMsg);
	}
	if (newCase != null) {
	return newCase.Id;
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.recordcannotfound
	);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_CreateCaseCtrl.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}
/*
Retrieves a list of Enrollee records.
@return A list of CareProgramEnrollee records.
*/
@AuraEnabled(cacheable=true)
public static List<CareProgramEnrollee> getPractitionerList() {
try {
	//CareProgramEnrollee is a Healthcloud object. Hence we have not used USER_MODE.
	List<CareProgramEnrollee> cpeList = new List<CareProgramEnrollee>();
	cpeList = [
	SELECT Id, Name
	FROM CareProgramEnrollee
	WHERE CareProgram.Name = :spevigo
	];
	if (!cpeList.isEmpty()) {
	return cpeList;
	} else {
	throw new AuraHandledException(
		BI_PSPB_constantsClass.recordcannotfound
	);
	}
} catch (Exception ex) {
	BI_SFCOE_LOG_Util.handleException(
	ex,
	applicationName,
	BI_PSPB_createLeadRecord.class.toString(),
	null,
	System.now()
	);
	throw new AuraHandledException(BI_PSPB_constantsClass.recordcannotfound);
}
}
}