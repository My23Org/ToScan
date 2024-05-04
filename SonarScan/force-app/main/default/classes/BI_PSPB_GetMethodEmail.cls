/**
 *@description This class implements a scheduled job to retrieve email status asynchronously and update corresponding records.
 *History
 *Version 	Author		Date			Detail		Description
 *1.0		Rajaa		01-Mar-2024		Created		This was an intial development.
 *1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */
public with sharing class BI_PSPB_GetMethodEmail implements Schedulable {

	//varibale that holds the application name retrieved from Custom Settings.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	//A variable That holds the name of our application to be used in catch exception handler.
	private static String applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
        : '';
    // Variable to store the SMS response body
    private static String emailBodyrespose;
    private static String errorMsg = System.Label.BI_PSP_record_update_error_message;
    public static String emailGetmethod = System.Label.BI_PSPB_EmailGetmethod;
    
    /**
* @description 		This method Executes the scheduled job.Calls the getMethodCallout method to retrieve Email status.
* @param 				ctx The context information for the scheduled job.
*/
    public void execute(SchedulableContext ctx) {
        try {
            BI_PSPB_GetMethodEmail.getMethodCallout();
        } catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,
				BI_PSPB_GetMethodSms.class.toString(),null,System.now()
			);
		}
    }
    
    /**
* @description 		This method Makes a callout to retrieve Email status and updates corresponding records asynchronously.
*/
    
    @future(callout=true)
    public static void getMethodCallout() {
        // Get the access token
       
        try {
            String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
            if (!String.isEmpty(accessToken)) {
                // Retrieve email log records that need to be updated
                List<BI_PSPB_OmnichannelLog__c> emailLogsToUpdate = getEmailLogsToUpdate();				
                // Declare a list to store email log record Ids for update
                List<Id> emailLogsIdsToUpdate = new List<Id>();
                
                BI_PSPB_GetMethodOmnichannel__mdt filteredSettings = BI_PSPB_GetMethodOmnichannel__mdt.getInstance(
                    emailGetmethod
                );				
                if (filteredSettings != null && !emailLogsToUpdate.isEmpty()) {
                    String endpointUrl = filteredSettings.BI_PSPB_EndPoint__c;
                    String omnichannel = filteredSettings.BI_PSPB_omnichannelentapi__c;
                    // Iterate through the list of EmailLogs__c records
                    for (
                        BI_PSPB_OmnichannelLog__c emailLog : emailLogsToUpdate
                    ) {
                        // Make a GET request to the API endpoint to retrieve the status of the SMS message
                        // Get the message ID from the Email Log record
                        if (emailLog.BI_PSPB_Status__c ==
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
                                Map<String, Object> outputMap = (Map<String, Object>) responseMap.get(
                                    'body'
                                );
                                emailBodyrespose = String.valueof(
                                    outputMap.get('status')
                                );
                                // Add the email log record Id to the collection for update
                                emailLogsIdsToUpdate.add(emailLog.Id);
                            } else {
                                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodEmail.class.toString(),
								'',System.now(),BI_PSPB_constantsClass.parameterError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
                            }
                        } else {
                            BI_SFCOE_LOG_Util.logMessage(
                                applicationName,BI_PSPB_GetMethodEmail.class.toString(),
                                '',System.now(),BI_PSPB_constantsClass.parameterError,
                                BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                        }
                    }
                    
                    // Perform the DML operation to update the email log records outside the loop
                    if (!emailLogsIdsToUpdate.isEmpty()) {
                        updateEmailLogs(emailLogsIdsToUpdate, emailBodyrespose);
				} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodEmail.class.toString(),
				'',System.now(),BI_PSPB_constantsClass.errorMsgUpdate,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					}
				} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSms.class.toString(),
				'',System.now(),BI_PSPB_constantsClass.errorMsgMetaDataCountNotFound,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_GetMethodEmail.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.accessTokenError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_GetMethodEmail.class.toString(),
				null,
				System.now()
			);
		}
	}

	/**
	 * @description 	Retrieves the list of EmailLogs__c records with status as queued.
	 * @return 			List<BI_PSPB_EmailLog__c> The list of email log records to be updated.
	 */
	@TestVisible
	private static List<BI_PSPB_OmnichannelLog__c> getEmailLogsToUpdate() {
		try {
			String statusqueued = BI_PSPB_constantsClass.queued;
			return [
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
                WITH USER_MODE
                Limit 100
			];
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_GetMethodSms.class.toString(),null,System.now()
			);
			return null;
		}
	}

	/**
	 * @description 	Updates email log records.
	 * @param 			logIds The list of email log record Ids to be updated.
	 * @param 			emailBodyrespose The SMS response body.
	 */
	public static void updateEmailLogs(
		List<Id> logIds,
		String emailBodyrespose
	) {
		try {
			if (logIds == null || logIds.isEmpty()) {
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
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_GetMethodEmail.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.noRecordError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
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
			BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSms.class.toString(),
					'',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				DmlException e = new DmlException();
				e.setMessage(errorMsg);
				throw e;
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_GetMethodEmail.class.toString(),null,System.now());
		}
	}
}