/**
 * @description Batch class for sending email notifications to a list of contacts.
 * This batch class retrieves contact information and sends email notifications using a specified API endpoint.
 * It logs the status of each email sent and handles exceptions gracefully.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		29-Apr-2024	Created		This was an intial development.
 * 1.1		Rajaa		03-May-2024		Updated		Code Review Changes.
 */
public class BI_PSPB_SendEmailBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    private List<Id> contactIds;
    private String notificationDeveloperName;
    private String desturl;
    private String notificationDate;
    private String uname;
    private static String endPoint = System.Label.BI_PSPB_Api_EndPoint;
    private static String privacyPolicysUrl = System.Label.BI_PSPB_PrivacyPolicysUrl;
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
    private static String app = settings != null? settings.BI_SFCOE_LOG_Application__c : '';
/**
 * @description	Constructs a new instance of the BI_PSPB_SendEmailBatch class with the provided parameters.
 * 
 * @param contactIds               A list of contact IDs to whom the email notifications will be sent.
 * @param notificationDeveloperName The developer name of the notification settings to be used.
 * @param desturl                  The destination URL to include in the email notification.
 * @param notificationDate         The date information to include in the email notification, if applicable.
 * @param uname                    The username associated with the email notifications.
 */
    public BI_PSPB_SendEmailBatch(List<Id> contactIds, String notificationDeveloperName, String desturl, String notificationDate, String uname) {
        this.contactIds = contactIds;
        this.notificationDeveloperName = notificationDeveloperName;
        this.desturl = desturl;
        this.notificationDate = notificationDate;
        this.uname = uname;
    }
/**
 *@description Returns a Database.QueryLocator instance containing the contacts specified by their IDs.
 * 
 * This method is invoked at the beginning of the batch execution to retrieve the contacts
 * based on the provided contact IDs for processing.
 * 
 * @param context The Database.BatchableContext object containing the execution context.
 * @return A Database.QueryLocator instance containing the contacts to be processed.
 */
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Name, Email
            FROM Contact
            WHERE Id IN :contactIds
        ]);
    }
/**
 * @description	Executes the batch job processing for sending emails to a list of contacts.
 * 
 * This method sends emails to the contacts specified in the provided scope list. It retrieves
 * necessary configurations such as endpoint settings, notification details, and privacy policy
 * URLs to construct the email payload. Each email is sent individually, and the response status
 * and message ID are logged for tracking purposes.
 * 
 * @param context The Database.BatchableContext object containing the execution context.
 * @param scope   A list of Contact records representing the contacts to which emails will be sent.
 */
    public void execute(Database.BatchableContext context, List<Contact> scope) {
        List<BI_PSPB_OmnichannelLog__c> emailLogList = new List<BI_PSPB_OmnichannelLog__c>();

        try {
            String accessToken = BI_PSPB_GetAccessToken.getAccessToken();
            if (accessToken != null) {
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

                        for (Contact targetContact : scope) {
                            String userEmail = targetContact.Email;
                            String userName = targetContact.Name;
                            String userId = targetContact.Id;

                            if (notificationDate != null && notificationDate.length() > 0) {
                                payload = '{' +
                                    '"emailId": "' + userEmail + '",' +
                                    '"body": {' +
                                    '"firstname": "' + userName + '",' +
                                    '"ubi-pspb-unsubscribe": "' + notificationsettings + '",' +
                                    '"ubi-pspb-termsofuse": "' + terms + '",' +
                                    '"ubi-pspb-privacynotice": "' + policy + '",' +
                                    '"date": "' + notificationDate + '",' +
                                    '"url": "' + desturl + '",' +
                                    '"Username": "' + uname + '"' +
                                    '},' +
                                    '"subject": "' + subject + '",' +
                                    '"templateID": "' + templateId + '"' +
                                    '}';
                            } else if (uname != null && uname.length() > 0) {
                                payload = '{' +
                                    '"emailId": "' + userEmail + '",' +
                                    '"body": {' +
                                    '"firstname": "' + userName + '",' +
                                    '"ubi-pspb-unsubscribe": "' + notificationsettings + '",' +
                                    '"ubi-pspb-termsofuse": "' + terms + '",' +
                                    '"ubi-pspb-privacynotice": "' + policy + '",' +
                                    '"url": "' + desturl + '",' +
                                    '"Username": "' + uname + '"' +
                                    '},' +
                                    '"subject": "' + subject + '",' +
                                    '"templateID": "' + templateId + '"' +
                                    '}';
                            } else {
                                payload = '{' +
                                    '"emailId": "' + userEmail + '",' +
                                    '"body": {' +
                                    '"firstname": "' + userName + '",' +
                                    '"ubi-pspb-unsubscribe": "' + notificationsettings + '",' +
                                    '"ubi-pspb-termsofuse": "' + terms + '",' +
                                    '"ubi-pspb-privacynotice": "' + policy + '",' +
                                    '"url": "' + desturl + '",' +
                                    '"Username": "' + uname + '"' +
                                    '},' +
                                    '"subject": "' + subject + '",' +
                                    '"templateID": "' + templateId + '"' +
                                    '}';
                            }

                            HttpRequest request = new HttpRequest();
                            request.setEndpoint(endpoint);
                            request.setMethod('POST');
                            request.setHeader('Authorization', 'Bearer ' + accessToken);
                            request.setHeader('Content-Type', 'application/json');
                            request.setBody(payload);

                            Http http = new Http();
                            HttpResponse response = http.send(request);

                            String status;
                            String messageId;

                            if (response.getStatusCode() == 200) {
                                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                                status = (String) jsonResponse.get('status');
                                messageId = (String) jsonResponse.get('messageId');
                                emailresponse = true;
                            } else {
                                emailresponse = false;
                                BI_PSPB_OmnichannelLog__c emailLog = new BI_PSPB_OmnichannelLog__c();
                                emailLog.BI_PSPB_ContactName__c = userId;
                                emailLog.BI_PSPB_UserEmail__c = userEmail;
                                emailLog.BI_PSPB_Subject__c = subject;
                                emailLog.BI_PSPB_Body__c = body;
                                emailLog.BI_PSPB_EventName__c = eventname;
                                emailLog.BI_PSPB_EventType__c = eventtype;
                                emailLog.BI_PSPB_EmailResponse__c = emailresponse;
                                emailLog.BI_PSPB_TemplateId__c = templateId;
                                emailLog.BI_PSPB_GetAccessTokenResponse__c = accessToken;
                                emailLog.BI_PSPB_Status__c = status;
                                emailLog.BI_PSPB_EmailMessageId__c = messageId;
                                emailLogList.add(emailLog);
                            }

                            BI_PSPB_OmnichannelLog__c emailLog = new BI_PSPB_OmnichannelLog__c();
                            emailLog.BI_PSPB_ContactName__c = userId;
                            emailLog.BI_PSPB_UserEmail__c = userEmail;
                            emailLog.BI_PSPB_Subject__c = subject;
                            emailLog.BI_PSPB_Body__c = body;
                            emailLog.BI_PSPB_EventName__c = eventname;
                            emailLog.BI_PSPB_EventType__c = eventtype;
                            emailLog.BI_PSPB_EmailResponse__c = emailresponse;
                            emailLog.BI_PSPB_TemplateId__c = templateId;
                            emailLog.BI_PSPB_GetAccessTokenResponse__c = accessToken;
                            emailLog.BI_PSPB_Status__c = status;
                            emailLog.BI_PSPB_EmailMessageId__c = messageId;
                            emailLogList.add(emailLog);
                        }

                        if (!emailLogList.isEmpty()) {
                            Database.SaveResult[] saveResults = Database.insert(emailLogList, false);
                            String errorMsg = '';

                            for (Database.SaveResult saveResult : saveResults) {
                                if (!saveResult.isSuccess()) {
                                    for (Database.Error error : saveResult.getErrors()) {
                                        errorMsg += 'Error ' + error.getFields() + '--' + error.getMessage() + '\n';
                                    }
                                }
                            }

                            if (!String.isBlank(errorMsg)) {
                                throw new DmlException(errorMsg);
                            }
                        }
                    } else {
                         BI_SFCOE_LOG_Util.logMessage(app,BI_PSPB_SendSmsBatch.class.toString(),
                         BI_PSPB_constantsClass.accessTokenError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                    }
                 
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                        app,
                        BI_PSPB_SendEmailBatch.class.toString(),                        
                        System.now(),
                        '',
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                     );
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                app,
                BI_PSPB_SendEmailBatch.class.toString(),                
                System.now()
            );
        }
    }
    /**
 *@description Handles the finishing tasks after the batch execution completes.
 * 
 * This method is invoked by the batch framework once all batches have been processed.
 * It logs a message indicating the completion of the batch process.
 * 
 * @param context The Database.BatchableContext object containing the execution context.
 */
    public void finish(Database.BatchableContext context) {
        BI_SFCOE_LOG_Util.logMessage(
				app,
				BI_PSPB_SendEmailBatch.class.toString(),
				'',
				System.now(),
				'Batch Finished',
				BI_SFCOE_LOG_Util.LOG_SEVERITY_INFO);
    
    }
}