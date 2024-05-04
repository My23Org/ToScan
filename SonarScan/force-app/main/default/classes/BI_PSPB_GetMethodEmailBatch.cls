/**
 * @description Batchable Apex class for retrieving email status via GET method callouts and updating corresponding records.
 * Implements Database.Batchable, Database.AllowsCallouts, and Schedulable interfaces. 
 * This batch class queries email log records with queued status and makes GET requests to an API endpoint
 * to retrieve email status information. It then updates the email log records with the response status.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		30-Apr-2024	Created		This was an intial development.
 * 1.1		Rajaa		03-May-2024		Updated		Code Review Changes.
 */
public class BI_PSPB_GetMethodEmailBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	// Variable to store the SMS response body
	private static String emailBodyrespose;   
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //varibale that holds the application name retrieved from Custom Settings.
    private static string applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
        : '';
   
    private static String errorMsg ;
    private static String emailGetmethod = System.Label.BI_PSPB_EmailGetmethod;
    /**
     *@description The start method of the batch class. 
     * Queries email log records with queued status.
     * 
     * @param context The Database.BatchableContext object containing the execution context.
     * @return A Database.QueryLocator instance for the records to be processed.
     */
	public Database.QueryLocator start(Database.BatchableContext context) {
		// Assuming you're processing records that need their email status updated
		String statusqueued = BI_PSPB_constantsClass.queued;
		return Database.getQueryLocator(
			[
				SELECT
					Id,
					BI_PSPB_EmailMessageId__c,
					BI_PSPB_GetAccessTokenResponse__c,
					BI_PSPB_Body__c,
					BI_PSPB_Status__c
				FROM BI_PSPB_OmnichannelLog__c
				WHERE
					BI_PSPB_EmailMessageId__c != NULL
					AND BI_PSPB_GetAccessTokenResponse__c != NULL
					AND BI_PSPB_Status__c = :statusqueued
			]
		);
	}
/**
     *@description The execute method of the batch class.
     * 
     * Processes email log records, makes GET requests to API endpoint, and updates records accordingly.
     * 
     * @param context The Database.BatchableContext object containing the execution context.
     * @param scope   A list of BI_PSPB_OmnichannelLog__c records representing the email logs to be processed.
     */
	public void execute(
		Database.BatchableContext context,
		List<BI_PSPB_OmnichannelLog__c> scope
	) {
		// Reuse your existing getMethodCallout logic here to process each record in scope
		// This will include the callout and updating of records as previously defined in the @future method
		// Prepare lists to collect updates		
		String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
		System.Debug('Scope Size ' + scope.size());
		if (accessToken != null) {			
			// Declare a list to store email log record Ids for update
			List<Id> emailLogsIdsToUpdate = new List<Id>();
			// Retrieve setting from custom metadata type
			BI_PSPB_GetMethodOmnichannel__mdt filteredSettings = BI_PSPB_GetMethodOmnichannel__mdt.getInstance(
                    emailGetmethod
                );

			if (!scope.isEmpty()) {
				String endpointUrl = filteredSettings.BI_PSPB_EndPoint__c;
				String omnichannel = filteredSettings.BI_PSPB_omnichannelentapi__c;

				for (BI_PSPB_OmnichannelLog__c emailLog : scope) {
					// Insert callout logic here, adjust as necessary to handle batch context
					// Make a GET request to the API endpoint to retrieve the status of the SMS message
					// Get the message ID from the Email Log record
					if (
						emailLog.BI_PSPB_Status__c ==
						BI_PSPB_constantsClass.queued &&
						emailLog.BI_PSPB_EmailMessageId__c != null
					) {
						String messageId = emailLog.BI_PSPB_EmailMessageId__c;

						HttpRequest req = new HttpRequest();
						// Build the full URL with query parameters
						req.setEndpoint(
							endpointUrl +
								omnichannel +
								'message_ID=' +
								messageId
						);
						req.setMethod('GET');
						req.setHeader('Authorization', 'Bearer ' + accessToken);
						Http http = new Http();
						HttpResponse res = http.send(req);

						// Check if the request was successful
						if (res.getStatusCode() == 200) {
							// Parse the response JSON
							Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
								res.getBody()
							);
							
							emailBodyrespose = String.valueof(
								(String) responseMap.get(
								'status'
							)
							);
                     
							// Add the email log record Id to the collection for update
							emailLogsIdsToUpdate.add(emailLog.Id);
						} else {
							BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodEmailBatch.class.toString(),
							BI_PSPB_constantsClass.httpResponseError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
						}
					} else {
						BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodEmailBatch.class.toString(),'',
							System.now(),BI_PSPB_constantsClass.parameterError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					}
				}
				// Perform the DML operation to update the email log records outside the loop
				if (!emailLogsIdsToUpdate.isEmpty()) {
					updateEmailLogs(emailLogsIdsToUpdate, emailBodyrespose);
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodEmailBatch.class.toString(),'',
					System.now(),BI_PSPB_constantsClass.errorMsgUpdate,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodEmailBatch.class.toString(),'',
				System.now(),BI_PSPB_constantsClass.errorMsgMetaDataCountNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			}
		} else {
			BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_GetMethodEmailBatch.class.toString(),
				'',
				System.now(),
				BI_PSPB_constantsClass.accessTokenError,
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
		}
	}
/**
     *@description The finish method of the batch class.
     * 
     * Logs a message indicating the completion of the batch job.
     * 
     * @param context The Database.BatchableContext object containing the execution context.
     */
	public void finish(Database.BatchableContext context) {
        BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_GetMethodEmailBatch.class.toString(),
				'',
				System.now(),
				'Batch Finished',
				BI_SFCOE_LOG_Util.LOG_SEVERITY_INFO);
    }
/**
     *@description Updates the specified email log records with the given email response status.
     * 
     * @param logIds            The list of email log record Ids to update.
     * @param emailBodyrespose  The email response status to update.
     */
	public static void updateEmailLogs(
		List<Id> logIds,
		String emailBodyrespose
	) {
		try {
			if (logIds == null || logIds.isEmpty()&& !String.isBlank(emailBodyrespose)) {
				return;
			}
			List<BI_PSPB_OmnichannelLog__c> emailLogsToUpdate = new List<BI_PSPB_OmnichannelLog__c>();
			// Retrieve the email log records using the provided Ids
			emailLogsToUpdate = [
				SELECT Id, BI_PSPB_Status__c, BI_PSPB_DateSent__c
				FROM BI_PSPB_OmnichannelLog__c
				WHERE Id IN :logIds
				WITH USER_MODE
			];

			// Perform the update operation
			if (!emailLogsToUpdate.isEmpty()) {
				for (BI_PSPB_OmnichannelLog__c emailLog : emailLogsToUpdate) {
					// Update the fields as needed
					emailLog.BI_PSPB_Status__c = emailBodyrespose;
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodEmailBatch.class.toString(),'',
				System.now(),BI_PSPB_constantsClass.noRecordError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			}
			// Update the records
			//update emailLogsToUpdate;
			Database.SaveResult[] saveResults = Database.update(
				emailLogsToUpdate,
				false,
				AccessLevel.USER_MODE
			);

			// Check each save result
			String errorMsg;
			for (Database.SaveResult saveResult : saveResults) {
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
					}
				}
			}

			if (!String.isBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodEmailBatch.class.toString(),'',
				System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				DmlException e = new DmlException();
				e.setMessage(errorMsg);
				throw e;
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_GetMethodEmailBatch.class.toString(), 
				null,System.now()
			);
		}
	}
/**
     *@description The execute method for the Schedulable interface.
     * 
     * Initiates the batch job when the scheduler triggers it.
     * 
     * @param schedulableContext The SchedulableContext object containing the execution context.
     */
	public void execute(SchedulableContext schedulableContext) {
		BI_PSPB_GetMethodEmailBatch batchJob = new BI_PSPB_GetMethodEmailBatch();
		Database.executeBatch(batchJob, 100);
	}
}