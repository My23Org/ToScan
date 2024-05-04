/*
* @description			This class is used to insert the files to the
						related cases.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Joyal		05-Dec-2023		Created			Initial development
* 1.1		Joyal		01-Jan-2024		Updated			Update  Database Insert 
* 1.2		Joyal		04-Apr-2024		Updated			Catch log added
*/
public with sharing class BI_PSPB_InsertUploadFileforUpdateRx {
//Static variable to store application settings.
private static BI_SFCOE_LOG_App_Settings__c settings = 
BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
//Static variable to store the application name.
private static String applicationName = settings != null
? settings.BI_SFCOE_LOG_Application__c
: '';
//Store the error message custom labels
private static String errorMsg ='';
private static  string errorMsgForInsert =
System.Label.BI_PSPB_Upload_File_Related_Caseid_Error;
private static String shareType =
System.Label.BI_PSPB_ShareType;
// Method to create ContentDocumentLinks for uploading files related to a record
/**
@description	Used to insert the case record.
@param			fileIds(List<String> )-  this string store the file ids. 
@param			leadCaseId(Id) this string store the related account ids.
This method used in BI_PSPB_InsertCaserecordforUpdateRx apex.
*/
public static void createContentDocumentLinks(
List<String> fileIds, 
string leadCaseId) {
	// List to hold ContentDocumentLink records to be inserted.
	List<ContentDocumentLink> fileLinks = new List<ContentDocumentLink>();
	try {
		// The values in the fileIds may or may not be null.Hence null check is not done.
			if(String.isNotBlank(leadCaseId)){
			// Loop through the list of fileIds provided.
				for (String fileId : fileIds) {
					// Create a ContentDocumentLink record for each fileId.
					ContentDocumentLink link = new ContentDocumentLink(
					ContentDocumentId = fileId, 
					LinkedEntityId = leadCaseId,
					ShareType = shareType // 'V' for sharing the file with the record.
					);
					fileLinks.add(link); // Add the ContentDocumentLink record to the list.
				}
			// Check if there are ContentDocumentLink records to be inserted.
					Database.SaveResult[] saveResults = Database.insert(
					new List<ContentDocumentLink>{ fileLinks[0] },
					false
					); 
				// Insert the ContentDocumentLink records.
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
							BI_PSPB_InsertUploadFileforUpdateRx.class.toString(),
							System.now()
						);
					}
			}
			else {
					BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_InsertUploadFileforUpdateRx.class.toString(),
					'',
					System.now(),
					errorMsg,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
		}
	catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,
			BI_PSPB_InsertUploadFileforUpdateRx.class.toString(),null,System.now());
		}
	}
}