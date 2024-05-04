/**
 * @description This class implements the Schedulable interface to handle scheduled SMS method calls.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		15-Feb-2024		Created		This was an intial development.
 * 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */
public with sharing class BI_PSPB_GetMethodSms implements Schedulable {
	
	//varibale that holds the application name retrieved from Custom Settings.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	//A variable That holds the name of our application to be used in catch exception handler.
	private static String applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';
    private static String smsBodyrespose;
	private static String errorMsg = '';
	public static String smsGetmethod = System.Label.BI_PSPB_SmsGetmethod;
	/**
	 * @description 		This method Executes the scheduled job. Calls the getMethodCallout method to retrieve SMS status.
	 * @param 				ctx The context information for the scheduled job.
	 */
	public void execute(SchedulableContext ctx) {
		try {
			BI_PSPB_GetMethodSms.getMethodCallout();
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,
				BI_PSPB_GetMethodSms.class.toString(),null,System.now()
			);
		}
	}
	/**
	 * @description 		This method Makes a callout to retrieve SMS status and updates corresponding records asynchronously.
	 */

	@future(callout=true)
	public static void getMethodCallout() {
		// Get the access token
		
		try {
			String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
			if (!String.isEmpty(accessToken)) {
				// Retrieve email log records that need to be updated
				List<BI_PSPB_OmnichannelLog__c> smsLogsToUpdate = getSmsLogsToUpdate();
				// Declare a list to store email log record Ids for update
				List<Id> smsLogsIdsToUpdate = new List<Id>();				
				BI_PSPB_GetMethodOmnichannel__mdt filteredSettings = BI_PSPB_GetMethodOmnichannel__mdt.getInstance(
					smsGetmethod
				);
				if (filteredSettings != null && !smsLogsToUpdate.isEmpty()) {
					String endpointUrl = filteredSettings.BI_PSPB_EndPoint__c;
					String configItem = filteredSettings.BI_PSPB_configItem__c;
					String country = filteredSettings.BI_PSPB_Country__c;
					String omnichannel = filteredSettings.BI_PSPB_omnichannelentapi__c;

					// Iterate through the list of EmailLogs__c records
					for (BI_PSPB_OmnichannelLog__c smsLog : smsLogsToUpdate) {
						// Make a GET request to the API endpoint to retrieve the status of the SMS message
						// Get the message ID from the Email Log record
						if (smsLog.BI_PSPB_SmsStatus__c ==
							BI_PSPB_constantsClass.queued &&
							smsLog.BI_PSPB_SMSMessageId__c != null
						) {
							String messageId = smsLog.BI_PSPB_SMSMessageId__c;

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
							if (res.getStatusCode() == 200) {
								// Parse the response JSON
								Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
									res.getBody()
								);
								Map<String, Object> outputMap = (Map<String, Object>) responseMap.get(
									'output'
								);
								// Update the EmailLogs__c record with the response data
								smsBodyrespose = String.valueOf(
									outputMap.get('status')
								);
								// Add the email log record Id to the collection for update
								smsLogsIdsToUpdate.add(smsLog.Id);
							} else {
								BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSms.class.toString(),
									BI_PSPB_constantsClass.httpResponseError,System.now(),'',
									BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
								);
							}
						} else {
							BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSms.class.toString(),
								'',System.now(),BI_PSPB_constantsClass.parameterError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
						}
					}
					if (!smsLogsIdsToUpdate.isEmpty()) {
						// Call a future method to perform DML operation asynchronously
						updateSmsLogs(smsLogsIdsToUpdate, smsBodyrespose);
					} else {
						BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSms.class.toString(),
							'',System.now(),BI_PSPB_constantsClass.errorMsgUpdate,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
						);
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_GetMethodSms.class.toString(),
						'',System.now(),BI_PSPB_constantsClass.errorMsgMetaDataCountNotFound,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_GetMethodSms.class.toString(),
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
				BI_PSPB_GetMethodSms.class.toString(),
				null,
				System.now()
			);
		}
	}

	/**
	 * @description 	Retrieves the list of BI_PSPB_OmnichannelLog__c records with status as queued.
	 * @return 			List<BI_PSPB_OmnichannelLog__c> The list of email log records to be updated.
	 */
	@TestVisible
	private static List<BI_PSPB_OmnichannelLog__c> getSmsLogsToUpdate() {
		try {
			String statusqueued = BI_PSPB_constantsClass.queued;
			return [
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
				WITH USER_MODE limit 100
			];
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,
				BI_PSPB_GetMethodSms.class.toString(),null,System.now()
			);
			return null;
		}
	}

	/**
	 * @description 	Updates Sms log records .
	 * @param 			logIds The list of email log record Ids to be updated.
	 * @param 			smsBodyResponse The SMS response body.
	 */
	public static void updateSmsLogs(List<Id> logIds, String smsBodyResponse) {
		try {
			if (logIds == null || logIds.isEmpty()) {
				return;
			}
			List<BI_PSPB_OmnichannelLog__c> smsLogsToUpdate = new List<BI_PSPB_OmnichannelLog__c>();
			// Retrieve the email log records using the provided Ids
			smsLogsToUpdate = [
				SELECT Id, BI_PSPB_SmsStatus__c, BI_PSPB_DateSent__c
				FROM BI_PSPB_OmnichannelLog__c
				WHERE Id IN :logIds
				WITH USER_MODE Limit 100
			];
			if (!smsLogsToUpdate.isEmpty()) {
				for (BI_PSPB_OmnichannelLog__c smsLog : smsLogsToUpdate) {
					smsLog.BI_PSPB_SmsStatus__c = smsBodyResponse;
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_GetMethodSms.class.toString(),
					'',
					System.now(),
					BI_PSPB_constantsClass.noRecordError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}

			Database.SaveResult[] saveResults = Database.update(
				smsLogsToUpdate,
				false,
				AccessLevel.USER_MODE
			);

			for (Database.SaveResult saveResult : saveResults) {
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
						errorMsg +='Error ' + error.getFields() +'--' +error.getMessage() +'\n';
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
			// Handle the exception
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_GetMethodSms.class.toString(),
				null,System.now()
			);
		}
	}
}