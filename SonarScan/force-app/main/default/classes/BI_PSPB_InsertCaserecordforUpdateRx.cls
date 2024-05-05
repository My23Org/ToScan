/*
* @description			This class is used to insert case records for 
						updating prescriptions
						and to display related cases in prescription status.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Joyal		05-Dec-2023		Created			Initial development
* 1.1		Joyal		01-Jan-2024		Updated			Update  Database Insert 
* 1.2		Joyal		04-Apr-2024		Updated			Catch log added
*/
public with sharing class BI_PSPB_InsertCaserecordforUpdateRx {
	public static BI_SFCOE_LOG_App_Settings__c settings = 
	BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
	private static String applicationName = settings != null
	? settings.BI_SFCOE_LOG_Application__c
	: '';
	private static String recordTypeName =
	System.Label.BI_PSPB_Update_Prescription_Record_Type;
	private static String errorForThrow =
	System.Label.BI_PSP_ConsoleError;
	private static String errorMsg ='';
	private static String errorForInsert =
	System.Label.BI_PSP_record_insert_error_message;
	private static String errorForAccount =
	System.Label.BI_PSPB_Error_For_Account;
	private static String errorForCase =
	System.Label.BI_PSPB_Error_For_Case;
	private static Id recordTypeId =
	Schema.SObjectType.Case.getRecordTypeInfosByName()
	.get(recordTypeName)
	.getRecordTypeId();
	/**
	@description	This method creates the Case record for the prescriptions
					that are updated for the patient.
	@param			patientId (Id) - Account lookupId  From  Care Program Enrolle.
	@param			Wrapper (class) - BI_PSPB_e_prescription__c,BI_PSPB_physical_copy__c,
					BI_PSPB_prescription_sent_to__c,BI_PSPB_Additional_Comments__c. 
	@param			fileIds (List<String>) - store the list of related case files.
	This method used in biPspbupdateRX component.
	*/
	@AuraEnabled(cacheable=false)
	public static void getcaseRecordWithFiles(String patientId,
	BI_PSPB_caseForUpdateRxWrapper Wrapper,List<String> fileIds){
		// The values in the wrapper may or may not be null.Hence null check is not done.
		// The values in the fileIds may or may not be null.Hence null check is not done.
	try {
		if(String.isNotBlank(patientId)){
			// Create a new Case instance and set its fields.
			Case newCase = new Case(
				RecordTypeId  = recordTypeId,
				AccountId = patientId,
				BI_PSPB_e_prescription__c = Wrapper.eprescription,
				BI_PSPB_physical_copy__c = Wrapper.physicalCopy,
				BI_PSPB_prescription_sent_to__c = Wrapper.prescriptionSentTo,
				BI_PSPB_Additional_Comments__c = Wrapper.additionalComments);	
				// Insert the new case record. 
				Database.SaveResult[] saveResults = Database.insert(
					new List<Case>{ newCase },false,
					AccessLevel.USER_MODE);
				for (Database.SaveResult saveResult : saveResults) {
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
							errorMsg += 'Error ' + error.getFields() + '--' + 
							error.getMessage() + '\n';
						}
					}
				}
				if (!String.isBlank(errorMsg)) {
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResults,
						BI_PSPB_InsertCaserecordforUpdateRx.class.toString(),
						System.now());
					throw new AuraHandledException(errorForInsert);
					// Propagate combined errors after collecting from all records
				}
				/**If there are fileIds provided, associate 
				them with the newly created case.*/
			BI_PSPB_InsertUploadFileforUpdateRx.createContentDocumentLinks
			(fileIds, newCase.Id);
		} else {
			throw new AuraHandledException(errorForAccount);
		}
	} 
	catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,
			BI_PSPB_InsertCaserecordforUpdateRx.class.toString(),null,System.now());
			throw new AuraHandledException(errorForInsert);
		}
	}
	/**
	@description	Used to show the case prescription status.
	@param			patientId (Id) -Account lookupId  From  Care Program Enrolle.
	@param			value (String) - store value of the  Status.
	@return			List<Case> return the list of case records in
					prescriptionStatus Component.
	*/
	@AuraEnabled(cacheable=true)
	public static List<Case> getCasesForPatient( String patientId, 
	String caseStatus) {
	List<Case> patientCases = new List<Case>();
	try {
		// Retrieve the CareProgramEnrollee related to the patient.
		if(String.isNotBlank(patientId)){
			Id cpeID = getCareProgramEnrolleeId(patientId);
			if (cpeID != null && cpeID!='') {
				if (String.isNotBlank(caseStatus)) {
				/**Retrieve cases for the patient with the specified status and record 
				type.USER_MODE could not be used because of the HealthCloud 
				Object limitation for CareProgramEnrollee which is the lookup object for 
				field BI_PSP_Patient__c.*/
					patientCases = [
					SELECT Id,CaseNumber,BI_PSP_Patient__c,
					AccountId,Status,BI_PSP_Type__c,BI_PSPB_Additional_Comments__c,
					CreatedDate FROM Case WHERE BI_PSP_Patient__c = :cpeID AND
					Status = :caseStatus AND RecordTypeId  = :recordTypeId];
				} else {
				/** Retrieve all cases for the patient with the specified record type.
				USER_MODE could not be used because of the HealthCloud Object 
				limitation for CareProgramEnrollee which is the lookup object for 
				field BI_PSP_Patient__c*/ 
					patientCases = [SELECT Id,CaseNumber,BI_PSP_Patient__c,
					AccountId,Status,BI_PSP_Type__c,BI_PSPB_Additional_Comments__c,CreatedDate
					FROM Case WHERE BI_PSP_Patient__c = :cpeID
					AND RecordTypeId  = :recordTypeId];
					}
			}	
			else {
				throw new AuraHandledException(errorForAccount);
			}
		}
		else {
			throw new AuraHandledException(errorForAccount);
		}
	}
	catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,
			BI_PSPB_InsertCaserecordforUpdateRx.class.toString(),null,System.now());
			throw new AuraHandledException(errorForCase);
	}
	return patientCases;
	}
		/**
		@description     Helper method to retrieve CareProgramEnrollee
						Id for a patient.
		@param           patientId (Id) - store the account lookupId in
						Care Program Enrolle.
		@return          Id- return the  lookupId in Care Program Enrolle.
		*/
	public static Id getCareProgramEnrolleeId(String patientId) {
	Id careProgramEnrolleeId = null;
	try {
		if(String.isNotBlank(patientId)){
		/**USER_MODE could not be used because of the 
		HealthCloud Object limitation for CareProgramEnrollee*/
		List<CareProgramEnrollee> cpeList = [
		SELECT Id FROM CareProgramEnrollee WHERE AccountId = :patientId LIMIT 1];
			if (!cpeList.isEmpty()) {
				careProgramEnrolleeId = cpeList[0].Id;
			} 
			else {
				BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_InsertCaserecordforUpdateRx.class.toString(),
				'',System.now(),errorForAccount,
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			}
		}
		else {
			BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_InsertCaserecordforUpdateRx.class.toString(),
				'',System.now(),errorForAccount,
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
		}
	}catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,
			BI_PSPB_InsertCaserecordforUpdateRx.class.toString(),null,System.now());
			throw new AuraHandledException(errorForInsert);
	}
	return careProgramEnrolleeId;
	}
	/*
	@description	this class for used to store the value of case insert fields
	*/
	public class BI_PSPB_caseForUpdateRxWrapper {
		@AuraEnabled
		public String eprescription { get; set; }
		@AuraEnabled
		public String physicalCopy { get; set; }
		@AuraEnabled
		public String prescriptionSentTo { get; set; }
		@AuraEnabled
		public String additionalComments { get; set; }
	}
}