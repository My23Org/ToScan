/**
 * @description Batchable Apex class for retrieving SMS status via GET method callouts and updating corresponding records.
 * Implements Database.Batchable, Database.AllowsCallouts, and Schedulable interfaces.
 * This batch class queries SMS log records with queued status and makes GET requests to an API endpoint
 * to retrieve SMS status information. It then updates the SMS log records with the response status.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		30-Apr-2024		Created		This was an intial development.
 * 1.1		Rajaa		05-May-2024		Updated		Code Review Changes.
 */
public class BI_PSPB_GetMethodSMSBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	// Variable to store the SMS response body
	private static String smsBodyrespose = '';
	//varibale that holds the application name retrieved from Custom Settings.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	//A variable That holds the name of our application to be used in catch exception handler.
	private static string applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static String errorMsg = '';
	private static String smsGetmethod = System.Label.BI_PSPB_SmsGetmethod;
    private static String contatcError = System.Label.BI_PSP_Contact_ErrorMessage;
	/**
	 *@description  The start method of the batch class.
	 * Queries SMS log records with queued status.
	 *
	 * @param context The Database.BatchableContext object containing the execution context.
	 * @return A Database.QueryLocator instance for the records to be processed.
	 */
	public Database.QueryLocator start(Database.BatchableContext context) {
		// Assuming you're processing records that need their sms status updated
		try {
			String statusqueued = BI_PSPB_constantsClass.queued;
			return Database.getQueryLocator(
				[
					SELECT
						Id,
						BI_PSPB_SMSMessageId__c,
						BI_PSPB_GetAccessTokenResponse__c,
						BI_PSPB_SmsStatus__c
					FROM BI_PSPB_OmnichannelLog__c
					WHERE
						BI_PSPB_SMSMessageId__c != NULL
						AND BI_PSPB_GetAccessTokenResponse__c != NULL
						AND BI_PSPB_SmsStatus__c = :statusqueued
					WITH USER_MODE
				]
			);
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),
				null,System.now()
			);
			return null;
		}
	}

	/**
	 *@description  The execute method of the batch class.
	 * Processes SMS log records, makes GET requests to API endpoint, and updates records accordingly.
	 * @param context The Database.BatchableContext object containing the execution context.
	 * @param scope   A list of BI_PSPB_OmnichannelLog__c records representing the SMS logs to be processed.
	 */
	public void execute(
		Database.BatchableContext context,
		List<BI_PSPB_OmnichannelLog__c> scope
	) {
		// Reuse your existing getMethodCallout logic here to process each record in scope
		// This will include the callout and updating of records as previously defined in the @future method
		// Prepare lists to collect updates
		try {
			String statusqueued = BI_PSPB_constantsClass.queued;
			String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
			if (!String.isBlank(accessToken)) {
				List<BI_PSPB_OmnichannelLog__c> logsToUpdate = new List<BI_PSPB_OmnichannelLog__c>();
				// Declare a list to store sms log record Ids for update
				List<Id> smsLogsIdsToUpdate = new List<Id>();
				// Retrieve setting from custom metadata type
				BI_PSPB_GetMethodOmnichannel__mdt filteredSettings = BI_PSPB_GetMethodOmnichannel__mdt.getInstance(
					smsGetmethod
				);

				if (!scope.isEmpty()) {
					String endpointUrl = filteredSettings.BI_PSPB_EndPoint__c;
					String omnichannel = filteredSettings.BI_PSPB_omnichannelentapi__c;
					String country = filteredSettings.BI_PSPB_Country__c;
					String configItem = filteredSettings.BI_PSPB_configItem__c;

					for (BI_PSPB_OmnichannelLog__c smsLog : scope) {
						// Insert callout logic here, adjust as necessary to handle batch context
						// Make a GET request to the API endpoint to retrieve the status of the SMS message
						// Get the message ID from the Sms Log record
						if (
							smsLog.BI_PSPB_SmsStatus__c ==
							BI_PSPB_constantsClass.queued
						) {
							String messageId = smsLog.BI_PSPB_SmsMessageId__c;
							HttpRequest req = new HttpRequest();
							// Build the full URL with query parameters
							req.setEndpoint(
								endpointUrl +
									omnichannel +
									'country=' +
									country +
									'&messageId=' +
									messageId +
									'&configItem=' +
									configItem
							);
							req.setMethod('GET');
							req.setHeader(
								'Authorization',
								'Bearer ' + accessToken
							);
							Http http = new Http();
							HttpResponse res = http.send(req);

							// Check if the request was successful
							if (res.getStatusCode() == 200) {
								// Parse the response JSON
								Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
									res.getBody()
								);
								smsBodyrespose = String.valueof(
									(String) responseMap.get('status')
								);
								// Add the sms log record Id to the collection for update
								smsLogsIdsToUpdate.add(smsLog.Id);
							} else {
								BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),
									BI_PSPB_constantsClass.httpResponseError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
							}
						} else {
							BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),'',
								System.now(),BI_PSPB_constantsClass.parameterError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
						}
					}
					// Perform the DML operation to update the sms log records outside the loop
					if (
						!smsLogsIdsToUpdate.isEmpty() &&
						String.isNotBlank(smsBodyrespose)
					) {
						updatesmsLogs(smsLogsIdsToUpdate, smsBodyrespose);
					} else {
						BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),'',
							System.now(),BI_PSPB_constantsClass.errorMsgUpdate,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),'',
						System.now(),contatcError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_GetMethodSMSBatch.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.accessTokenError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),
				null,System.now()
			);
		}
	}
	/**
	 * @description 	The finish method of the batch class.
	 * Logs a message indicating the batch has finished.
	 *
	 * @param context The Database.BatchableContext object containing the execution context.
	 */
	public void finish(Database.BatchableContext context) {
		BI_SFCOE_LOG_Util.logMessage(
			applicationName,
			BI_PSPB_GetMethodSMSBatch.class.toString(),
			'',
			System.now(),
			'Batch Finished',
			BI_SFCOE_LOG_Util.LOG_SEVERITY_INFO
		);
	}
	/**
	 * @description 	Updates SMS log records with the provided status.
	 *
	 * @param logIds          The list of SMS log record Ids to update.
	 * @param smsBodyrespose  The SMS response status to update.
	 */
	public static void updatesmsLogs(List<Id> logIds, String smsBodyrespose) {
		try {
			if (
                !logIds.isEmpty() && 
                !String.isBlank(smsBodyrespose)
            ) {
				List<BI_PSPB_OmnichannelLog__c> smsLogsToUpdate = new List<BI_PSPB_OmnichannelLog__c>();
				// Retrieve the sms log records using the provided Ids
				smsLogsToUpdate = [
					SELECT Id, BI_PSPB_SmsStatus__c, BI_PSPB_DateSent__c
					FROM BI_PSPB_OmnichannelLog__c
					WHERE Id IN :logIds
					WITH USER_MODE
				];

				// Perform the update operation
				if (!smsLogsToUpdate.isEmpty()) {
					for (BI_PSPB_OmnichannelLog__c smsLog : smsLogsToUpdate) {
						// Update the fields as needed
						smsLog.BI_PSPB_SmsStatus__c = smsBodyrespose;
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),'',
						System.now(),BI_PSPB_constantsClass.noRecordError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
				// Update the records
				//update smsLogsToUpdate;
				Database.SaveResult[] saveResults = Database.update(
					smsLogsToUpdate,
					false,
					AccessLevel.USER_MODE
				);

				for (Database.SaveResult saveResult : saveResults) {
					if (!saveResult.isSuccess()) {
						for (Database.Error error : saveResult.getErrors()) {
							errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
						}
					}
				}

				if (!String.isBlank(errorMsg)) {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),'',
						System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					DmlException e = new DmlException();
					e.setMessage(errorMsg);
					throw e;
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),
                    BI_PSPB_constantsClass.parameterError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_GetMethodSMSBatch.class.toString(), //YourClassname
				null,
				System.now()
			);
		}
	}
	/**
	 * @description 	The execute method for the Schedulable interface.
	 * 					Initiates the batch job when the scheduler triggers it.
	 *
	 * @param schedulableContext The SchedulableContext object containing the execution context.
	 */
	public void execute(SchedulableContext schedulableContext) {
		BI_PSPB_GetMethodSMSBatch batchJob = new BI_PSPB_GetMethodSMSBatch();
		Database.executeBatch(batchJob, 90);
	}
}