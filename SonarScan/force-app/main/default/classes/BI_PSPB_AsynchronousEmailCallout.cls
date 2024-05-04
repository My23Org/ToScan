/**
 * @description Sends an email asynchronously to the specified contact using the provided notification details.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		08-Jan-2024		Created		This was an intial development.
 * 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */
public with sharing class BI_PSPB_AsynchronousEmailCallout {
	//varibale that holds the application name retrieved from Custom Settings.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	//A variable That holds the name of our application to be used in catch exception handler.
	private static String applicationName = settings != null ? settings.BI_SFCOE_LOG_Application__c
		: '';
	private static string concatenatedParams;
	private static String status;
	private static String messageId;
    private static String errorMsg ='';
	private static String endPoint = System.Label.BI_PSPB_Api_EndPoint;
	private static String privacyPolicysUrl = System.Label.BI_PSPB_PrivacyPolicysUrl;
	/**
 
	 * @description Sends an email asynchronously to the specified contact using the provided notification details.
	 * @param List<Id> contactIds 	The Id of the contact to whom the email will be sent.
	 * @param notificationDeveloperName 	The developer name of the notification metadata record containing email details.
	 * @param desturl                    The destination URL to be included in the email.
	 * @param notificationDate           The date of the notification.
	 * @param uname                      The username of the recipient.
	 
	 */
	@future(callout=true)
	public static void sendEmail(
		List<Id> contactIds,
		String notificationDeveloperName,
		String desturl,
		String notificationDate,
		String uname
	) {
		try {
			String accesstoken = BI_PSPB_GetAccessToken.getAccessToken();
			if (!String.isBlank(accessToken)) {
				List<Contact> targetContacts = [
					SELECT Id, Name, Email
					FROM Contact
					WHERE Id IN :contactIds
					WITH USER_MODE
				];
				List<BI_PSPB_OmnichannelLog__c> emailLogList = new List<BI_PSPB_OmnichannelLog__c>();
				if (!targetContacts.isEmpty()) {
					BI_PSPB_Omnichannel_API_Setting__mdt filteredSettings = BI_PSPB_Omnichannel_API_Setting__mdt.getInstance(
						endPoint
					);
					BI_PSPB_Notification__mdt filteredNotifications = BI_PSPB_Notification__mdt.getInstance(
						notificationDeveloperName
					);
					BI_PSPB_PrivacyPolicy__mdt privacyPolicyList = BI_PSPB_PrivacyPolicy__mdt.getInstance(
						privacyPolicysUrl
					);
					Boolean emailresponse;
					
						BI_PSPB_Omnichannel_API_Setting__mdt setting = filteredSettings;
						if (
							filteredNotifications != null &&
							privacyPolicyList != null
						) {
							BI_PSPB_Notification__mdt notification = filteredNotifications;
							BI_PSPB_PrivacyPolicy__mdt privacyPolicyUrl = privacyPolicyList;
							if (setting.BI_PSPB_EndPoint__c != null) {
								String endpoint = setting.BI_PSPB_EndPoint__c;
								String subject = notification.BI_PSPB_Subject__c;
								String body = notification.BI_PSPB_EmailBody__c;
								String eventname = notification.BI_PSPB_EventName__c;
								String eventtype = notification.BI_PSPB_EventType__c;
								String templateId = notification.BI_PSPB_TemplateId__c;
								String policy = privacyPolicyUrl.BI_PSPB_PrivacyPolicyUrlEndpoint__c;
								String terms = privacyPolicyUrl.BI_PSPB_TermsofuseUrlEndPoint__c;
								String notificationsettings = privacyPolicyUrl.BI_PSPB_Url__c;
								String payload;
								//EmailLogWrapper wrapper = null;
								for (Contact targetContact : targetContacts) {
									String userEmail = targetContact.Email;
									Contact userName = targetContact;

									if (
										notificationDate != null &&
										String.isNotBlank(notificationDate)
											
									) {
										payload =
											'{' +
											'"emailId": "' +
											userEmail +
											'",' +
											'"body": {' +
											'"firstname": "' +
											userName +
											'",' +
											'"ubi-pspb-unsubscribe": "' +
											notificationsettings +
											'",' +
											'"ubi-pspb-termsofuse": "' +
											terms +
											'",' +
											'"ubi-pspb-privacynotice": "' +
											policy +
											'",' +
											'"date": "' +
											notificationDate +
											'",' + // Corrected date format
											'"url": "' +
											desturl +
											'",' + // Removed an extra comma here
											'"Username": "' +
											uname +
											'"' +
											'},' +
											'"subject": "' +
											subject +
											'",' +
											'"templateID": "' +
											templateId +
											'"' + // Corrected variable name
											'}';
									} else if (
										uname != null &&
										String.isNotBlank(uname)
									) {
										payload =
											'{' +
											'"emailId": "' +
											userEmail +
											'",' +
											'"body": {' +
											'"firstname": "' +
											userName +
											'",' +
											'"ubi-pspb-unsubscribe": "' +
											notificationsettings +
											'",' +
											'"ubi-pspb-termsofuse": "' +
											terms +
											'",' +
											'"ubi-pspb-privacynotice": "' +
											policy +
											'",' +
											'"url": "' +
											desturl +
											'",' + // Removed an extra comma here
											'"Username": "' +
											uname +
											'"' +
											'},' +
											'"subject": "' +
											subject +
											'",' +
											'"templateID": "' +
											templateId +
											'"' + // Corrected variable name
											'}';
									} else {
										payload =
											'{' +
											'"emailId": "' +
											userEmail +
											'",' +
											'"body": {' +
											'"firstname": "' +
											userName +
											'",' +
											'"ubi-pspb-unsubscribe": "' +
											notificationsettings +
											'",' +
											'"ubi-pspb-termsofuse": "' +
											terms +
											'",' +
											'"ubi-pspb-privacynotice": "' +
											policy +
											'",' +
											//'"date": "' + notificationdate + '",' +// Corrected date format
											'"url": "' +
											desturl +
											'",' + // Removed an extra comma here
											'"Username": "' +
											uname +
											'"' +
											'},' +
											'"subject": "' +
											subject +
											'",' +
											'"templateID": "' +
											templateId +
											'"' + // Corrected variable name
											'}';
									}
									HttpRequest request = new HttpRequest();
									request.setEndpoint(endpoint);
									request.setMethod('POST');
									request.setHeader(
										'Authorization',
										'Bearer ' + accesstoken
									);
									request.setHeader(
										'Content-Type',
										'application/json'
									);
									request.setBody(payload);

									Http http = new Http();
									HttpResponse response = http.send(request);

									if (response.getStatusCode() == 200) {
										Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(
											response.getBody()
										);
									string	status = (String) jsonResponse.get(
											'status'
										);
										messageId = (String) jsonResponse.get(
											'messageId'
										);
										emailresponse = true;
										BI_PSPB_OmnichannelLog__c emailLog = new BI_PSPB_OmnichannelLog__c();
										emailLog.BI_PSPB_ContactName__c = userName.Id;

										emailLog.BI_PSPB_UserEmail__c = userEmail;
										emailLog.BI_PSPB_Subject__c = subject;
										emailLog.BI_PSPB_Body__c = body;
										emailLog.BI_PSPB_EventName__c = eventname;
										emailLog.BI_PSPB_EventType__c = eventtype;
										emailLog.BI_PSPB_EmailResponse__c = emailresponse;
										emailLog.BI_PSPB_TemplateId__c = templateId;
										emailLog.BI_PSPB_GetAccessTokenResponse__c = accesstoken;
										emailLog.BI_PSPB_Status__c = status;
										emailLog.BI_PSPB_EmailMessageId__c = messageId;
										emailLogList.add(emailLog);
									} else {
										emailresponse = false;
										BI_PSPB_OmnichannelLog__c emailLog = new BI_PSPB_OmnichannelLog__c();
										emailLog.BI_PSPB_ContactName__c = userName.Id;
                                        emailLog.BI_PSPB_UserEmail__c = userEmail;
										emailLog.BI_PSPB_Subject__c = subject;
										emailLog.BI_PSPB_Body__c = body;
										emailLog.BI_PSPB_EventName__c = eventname;
										emailLog.BI_PSPB_EventType__c = eventtype;
										emailLog.BI_PSPB_EmailResponse__c = emailresponse;
										emailLog.BI_PSPB_TemplateId__c = templateId;
										emailLog.BI_PSPB_GetAccessTokenResponse__c = accesstoken;
										emailLog.BI_PSPB_Status__c = status;
										emailLog.BI_PSPB_EmailMessageId__c = messageId;
										emailLogList.add(emailLog);
										concatenatedParams =targetContact.Id +',' +userEmail +
											',' +notification.BI_PSPB_Subject__c +',' +
											body +',' +',' +',' +eventName +',' +
											eventType +',' +emailresponse +',' +
											accessToken +',' +messageId +',' +status;
										BI_SFCOE_LOG_Util.logMessage(applicationName,
											BI_PSPB_AsynchronousEmailCallout.class
												.toString(),BI_PSPB_constantsClass.httpResponseError,
											System.now(),concatenatedParams,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
										throw new CalloutException(
											BI_PSPB_constantsClass.httpResponseError +response.getStatusCode());
									}
								}
								if (emailLogList != null) {
									//insert emailLogList;
									Database.SaveResult[] saveResults = Database.insert(
										emailLogList,
										false,
										AccessLevel.USER_MODE
									);									
									for (
										Database.SaveResult saveResult : saveResults
									) {
										if (!saveResult.isSuccess()) {
											for (
												Database.Error error : saveResult.getErrors()
											) {
												errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
											}
										}
									}
									if (!String.isBlank(errorMsg)) {
										BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
											saveResults,BI_PSPB_AsynchronousEmailCallout.class.toString(),System.now());
										DmlException e = new DmlException();
										e.setMessage(errorMsg);
                                     
									}
								}
							} else {
								BI_SFCOE_LOG_Util.logMessage(
								applicationName,BI_PSPB_AsynchronousEmailCallout.class
									.toString(),BI_PSPB_constantsClass.metaDataError,
								System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
								
								
							}
						} else {
							BI_SFCOE_LOG_Util.logMessage(
								applicationName,BI_PSPB_AsynchronousEmailCallout.class
									.toString(),BI_PSPB_constantsClass.metaDataError,
								System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
						}
					} else {
						BI_SFCOE_LOG_Util.logMessage(
							applicationName,BI_PSPB_AsynchronousEmailCallout.class.toString(),
							BI_PSPB_constantsClass.emailStatusError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,BI_PSPB_AsynchronousEmailCallout.class.toString(),
						BI_PSPB_constantsClass.contactError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			
		} catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(ex,applicationName, BI_PSPB_AsynchronousEmailCallout.class.toString(),concatenatedParams,System.now());
		}
	}
}