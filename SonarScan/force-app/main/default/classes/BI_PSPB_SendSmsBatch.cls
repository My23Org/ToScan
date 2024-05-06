/**
 * @description Batch class for sending SMS notifications to a list of contacts.
 * This batch class retrieves contact information and sends SMS notifications using a specified SMS endpoint.
 * It logs the status of each SMS sent and handles exceptions gracefully.
 *
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		29-Apr-2024		Created		This was an intial development.
 * 1.1		Rajaa		03-May-2024		Updated		Code Review Changes.
 */
public with sharing class BI_PSPB_SendSmsBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
	private List<Id> contactIds;
	private String notificationDeveloperName = '';
	private String desturl = '';
	private String notificationDate = '';
	private static String smsEndpoint = System.Label.BI_PSPB_SmsEndpoint;
	private static String contactError = System.Label.BI_PSPB_ContactRecordError;
	private static string recordError = System.Label.BI_PSPB_error;
	private static String concatenatedParams = '';
	private static String errorMsg = '';
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	private static String app = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**
	 *@description Constructs a new instance of the BI_PSPB_SendSmsBatch class with the provided parameters.
	 *
	 * @param contactIds               A list of contact IDs to whom the SMS notifications will be sent.
	 * @param notificationDeveloperName The developer name of the notification settings to be used.
	 * @param desturl                  The destination URL to include in the SMS notification.
	 * @param notificationDate         The date information to include in the SMS notification, if applicable.
	 */
	public BI_PSPB_SendSmsBatch(
		List<Id> contactIds,
		String notificationDeveloperName,
		String desturl,
		String notificationDate
	) {
		//notificationDeveloperName,desturl, notificationDate can be empty values
		if (
			!contactIds.isEmpty() &&
			notificationDeveloperName != null &&
			desturl != null &&
			notificationDate != null
		) {
			this.contactIds = contactIds;
			this.notificationDeveloperName = notificationDeveloperName;
			this.desturl = desturl;
			this.notificationDate = notificationDate;
		} else {
			BI_SFCOE_LOG_Util.logMessage(app,BI_PSPB_SendSmsBatch.class.toString(),BI_PSPB_constantsClass.parameterError,
				System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
		}
	}
	/**
	 * Returns a Database.QueryLocator instance containing the contacts specified by their IDs.
	 *
	 *@description This method is invoked at the beginning of the batch execution to retrieve the contacts
	 * based on the provided contact IDs for processing.
	 *
	 * @param context The Database.BatchableContext object containing the execution context.
	 * @return A Database.QueryLocator instance containing the contacts to be processed.
	 */
	public Database.QueryLocator start(Database.BatchableContext context) {
		try {
			return Database.getQueryLocator(
				[SELECT Id, Phone, Name FROM Contact WHERE Id IN :contactIds]
			);
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,app,BI_PSPB_SendSmsBatch.class.toString(),
				concatenatedParams,System.now()
			);
			return null;
		}
	}
	/**
	 * Executes the batch process for sending SMS notifications to the provided contacts.
	 *
	 *@description This method is invoked by the batch framework to process each batch of contacts.
	 * It retrieves the necessary access token, API settings, and notification details.
	 * For each contact, it constructs an SMS payload and sends it via HTTP POST request.
	 * It logs the status of each SMS sent and handles exceptions gracefully.
	 *
	 * @param context The Database.BatchableContext object containing the execution context.
	 * @param scope   The list of contacts to be processed in the current batch.
	 */
	public void execute(
		Database.BatchableContext context,
		List<Contact> scope
	) {
		List<BI_PSPB_OmnichannelLog__c> smsLogList = new List<BI_PSPB_OmnichannelLog__c>();
		try {
			String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
			if (
                String.isNotBlank(accessToken)
            ) {
				BI_PSPB_Omnichannel_API_Setting__mdt setting = BI_PSPB_Omnichannel_API_Setting__mdt.getInstance(
					smsEndpoint
				);
				BI_PSPB_Notification__mdt notification = BI_PSPB_Notification__mdt.getInstance(
					notificationDeveloperName
				);
				Boolean smsResponse = false;
				String endpoint = setting.BI_PSPB_EndPoint__c;
				String smsBody = notification.BI_PSPB_SmsBody__c;
				String eventName = notification.BI_PSPB_EventName__c;
				String eventType = notification.BI_PSPB_EventType__c;
				String smsBodyLink = '';
				String payload = '';
				String messageId = '';
				String status = '';
				if (String.isNotBlank(notificationDate)) {
					smsBodyLink =
						smsBody +
						' ' +
						notificationDate +
						' ' +
						desturl;
				} else {
					smsBodyLink = smsBody + ' ' + desturl;
				}
				if (!scope.isEmpty()) {
					for (Contact targetContacts : scope) {
						if (
							targetContacts.Phone != null ||targetContacts.Name != null
						) {
							String userPhoneNumber = targetContacts.Phone;
							Contact userName = targetContacts;

							payload =
								'{' +
								'"phoneNumber": "' +
								userPhoneNumber +
								'",' +
								'"body": "' +
								smsBodyLink +
								'"}';

							HttpRequest request = new HttpRequest();
							request.setEndpoint(endpoint);
							request.setMethod('POST');
							request.setHeader(
								'Authorization',
								'Bearer ' + 
                                accessToken
							);
							request.setHeader(
								'Content-Type',
								'application/json'
							);
							request.setBody(payload);
							Http http = new Http();
							HttpResponse response = http.send(request);

							if (response.getStatusCode() == 200) 
                            {
								if (response.getBody() != null) 
                                {
									Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(
										response.getBody()
									);
									status = (String) jsonResponse.get(
										'status'
									);
									messageId = (String) jsonResponse.get(
										'messageId'
									);

									smsResponse = true;
									BI_PSPB_OmnichannelLog__c smsLog = new BI_PSPB_OmnichannelLog__c();
									smsLog.BI_PSPB_ContactName__c = userName.Id;
									smsLog.BI_PSPB_SmsBody__c = smsBody;
									smsLog.BI_PSPB_MobilePhone__c = userPhoneNumber;
									smsLog.BI_PSPB_EventName__c = eventName;
									smsLog.BI_PSPB_EventType__c = eventType;
									smsLog.BI_PSPB_SMSResponse__c = smsResponse;
									smsLog.BI_PSPB_GetAccessTokenResponse__c = accessToken;
									smsLog.BI_PSPB_SMSMessageId__c = messageId;
									smsLog.BI_PSPB_SmsStatus__c = status;
									smsLogList.add(smsLog);
								}
							} else {
								smsResponse = false;
								BI_PSPB_OmnichannelLog__c smsLog = new BI_PSPB_OmnichannelLog__c();
								smsLog.BI_PSPB_ContactName__c = userName.Id;
								smsLog.BI_PSPB_SmsBody__c = smsBody;
								smsLog.BI_PSPB_MobilePhone__c = userPhoneNumber;
								smsLog.BI_PSPB_EventName__c = eventName;
								smsLog.BI_PSPB_EventType__c = eventType;
								smsLog.BI_PSPB_SMSResponse__c = smsResponse;
								smsLog.BI_PSPB_GetAccessTokenResponse__c = accessToken;
								smsLog.BI_PSPB_SMSMessageId__c = messageId;
								smsLog.BI_PSPB_SmsStatus__c = status;
								smsLogList.add(smsLog);
								concatenatedParams =targetContacts.Id +',' +userPhoneNumber +',' +
									notification.BI_PSPB_Subject__c +',' +smsBody +',' +smsBodyLink +
									',' +eventName +',' +eventType +',' +smsResponse +',' +accessToken +
									',' +messageId +',' +status;
								BI_SFCOE_LOG_Util.logMessage(app,BI_PSPB_AsynchronousSmsCallout.class.toString(),
									BI_PSPB_constantsClass.httpResponseError,System.now(),concatenatedParams,
									BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
								);
							}
						} else {
							BI_SFCOE_LOG_Util.logMessage(app,BI_PSPB_SendSmsBatch.class.toString(),contactError,
								System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
						}
					}
					if (!smsLogList.isEmpty()) {
						Database.SaveResult[] saveResults = Database.insert(
							smsLogList,
							false,
							AccessLevel.USER_MODE
						);
						for (Database.SaveResult saveResult : saveResults) {
							if (!saveResult.isSuccess()) {
								for (
									Database.Error error : saveResult.getErrors()
								) {
									errorMsg +=
										'Error ' +
										error.getFields() +
										'--' +
										error.getMessage() +
										'\n';
								}
							}
						}
						if (!String.isBlank(errorMsg)) {
							BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
								saveResults,
								BI_PSPB_SendSmsBatch.class.toString(),
								System.now()
							);
							DmlException e = new DmlException();
							e.setMessage(errorMsg);
							throw e;
						}
					} else {
						BI_SFCOE_LOG_Util.logMessage(app,BI_PSPB_SendSmsBatch.class.toString(),recordError,
							System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(app,BI_PSPB_SendSmsBatch.class.toString(),contactError,
                    	System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					app,
					BI_PSPB_SendSmsBatch.class.toString(),
					BI_PSPB_constantsClass.accessTokenError,
					System.now(),
					'',
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				app,
				BI_PSPB_SendSmsBatch.class.toString(),
				concatenatedParams,
				System.now()
			);
		}
	}
	/**
	 * Handles the finishing tasks after the batch execution completes.
	 *
	 *@description This method is invoked by the batch framework once all batches have been processed.
	 * It logs a message indicating the completion of the batch process.
	 *
	 * @param context The Database.BatchableContext object containing the execution context.
	 */
	public void finish(Database.BatchableContext context) {
		BI_SFCOE_LOG_Util.logMessage(
			app,
			BI_PSPB_SendSmsBatch.class.toString(),
			'',
			System.now(),
			'Batch Finished',
			BI_SFCOE_LOG_Util.LOG_SEVERITY_INFO
		);
	}
}