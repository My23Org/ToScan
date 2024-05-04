public class BI_PSPB_GetMethodSMSBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	// Variable to store the SMS response body
	private static String smsBodyrespose;
    //varibale that holds the application name retrieved from Custom Settings.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //A variable That holds the name of our application to be used in catch exception handler.
    private static string applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
        : '';
    private static String errorMsg ;
    private static String smsGetmethod = System.Label.BI_PSPB_SmsGetmethod;
	public Database.QueryLocator start(Database.BatchableContext context) {
		// Assuming you're processing records that need their sms status updated
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
					AND BI_PSPB_SmsStatus__c =: statusqueued
				WITH USER_MODE
			]
		);
	}

	public void execute(
		Database.BatchableContext context,
		List<BI_PSPB_OmnichannelLog__c> scope
	) {
		// Reuse your existing getMethodCallout logic here to process each record in scope
		// This will include the callout and updating of records as previously defined in the @future method
		// Prepare lists to collect updates
		BI_PSPB_GetMethodOmnichannel__mdt filteredSetting = null;
		String statusqueued = BI_PSPB_constantsClass.queued;
		String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
		if (accessToken != null) {
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
						BI_PSPB_constantsClass.queued &&
						smsLog.BI_PSPB_SmsMessageId__c != null
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
						req.setHeader('Authorization', 'Bearer ' + accessToken);
						Http http = new Http();
						HttpResponse res = http.send(req);

						// Check if the request was successful
						if (res.getStatusCode() == 200) {
							// Parse the response JSON
							Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
								res.getBody()
							);
							smsBodyrespose = String.valueof(
                                (String) responseMap.get(
								'status')
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
				if (!smsLogsIdsToUpdate.isEmpty()) {
					updatesmsLogs(smsLogsIdsToUpdate, smsBodyrespose);
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),'',
					System.now(),BI_PSPB_constantsClass.errorMsgUpdate,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),'',
				System.now(),BI_PSPB_constantsClass.errorMsgMetaDataCountNotFound,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
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
	}

	public void finish(Database.BatchableContext context) {
        BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_GetMethodSMSBatch.class.toString(),
				'',
				System.now(),
				'Batch Finished',
				BI_SFCOE_LOG_Util.LOG_SEVERITY_INFO);
    }

	public static void updatesmsLogs(
		List<Id> logIds,
		String smsBodyrespose
	) {
		try {
			if (logIds == null || logIds.isEmpty()) {
				return;
			}
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
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(),'',
				System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				DmlException e = new DmlException();
				e.setMessage(errorMsg);
				throw e;
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_GetMethodSMSBatch.class.toString(), //YourClassname
				null,System.now());
		}
	}

	public void execute(SchedulableContext schedulableContext) {
		BI_PSPB_GetMethodSMSBatch batchJob = new BI_PSPB_GetMethodSMSBatch();
		Database.executeBatch(batchJob, 90);
	}
}