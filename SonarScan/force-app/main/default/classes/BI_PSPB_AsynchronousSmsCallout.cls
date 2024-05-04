/**
 * @description Sends an sms asynchronously to the specified contact using the provided notification details.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		08-Jan-2024		Created		This was an intial development.
 * 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */

 public with sharing class BI_PSPB_AsynchronousSmsCallout {
  //varibale that holds the application name retrieved from Custom Settings.
     private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
//A variable That holds the name of our application to be used in catch exception handler.
     private static String app = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';
     private static string concatenatedParams;
     private static String messageId;
      private static String errorMsg ='';
     private static String status = '';
     private static String smsEndpoint = System.Label.BI_PSPB_SmsEndpoint;
     private static String accessToken = BI_PSPB_GetAccessToken.getAccessToken();  
    // private static SmsLog ;
    /**
	 
	 * @description This method sends an SMS notification asynchronously to a specified contact
	 * based on the provided contact Id and notification developer name. It retrieves necessary
	 * metadata records such as SMS endpoint and notification details from Custom Metadata Types
	 * and performs callouts to send SMS messages.
	 *
	 * @param contactIds 		The Ids of the contact to whom the SMS will be sent.
	 * @param notificationDeveloperName The developer name of the notification to be sent.
	 * @param desturl                    The destination URL to be included in the email.
	 * @param notificationDate           The date of the notification.
	 *	 
	 */
    @future(callout=true)
    public static void sendSMS(
        List<Id> contactIds,
        String notificationDeveloperName,
        String desturl,
        String notificationDate) {
        try {
            String accessToken = BI_PSPB_GetAccessToken.getAccessToken();    
            if (!String.isEmpty(accessToken)) {
                List<Contact> targetContact = [
                    SELECT Id, Phone, Name
                    FROM Contact
                    WHERE Id = :contactIds
                    WITH USER_MODE
                    
                ];

                if (!targetContact.isEmpty()) {
					List<BI_PSPB_OmnichannelLog__c> smsLogList = new List<BI_PSPB_OmnichannelLog__c>();                    
					BI_PSPB_Omnichannel_API_Setting__mdt filteredSettings = BI_PSPB_Omnichannel_API_Setting__mdt.getInstance(smsEndpoint);           
					BI_PSPB_Notification__mdt filteredNotifications = BI_PSPB_Notification__mdt.getInstance(notificationDeveloperName);
						
                    Boolean smsResponse = false;

                    
                        BI_PSPB_Omnichannel_API_Setting__mdt setting = filteredSettings;                        
                        BI_PSPB_Notification__mdt notification = filteredNotifications;
                        if (setting.BI_PSPB_EndPoint__c != null) {
                            String endpoint = setting.BI_PSPB_EndPoint__c;
                            String smsBody = notification.BI_PSPB_SmsBody__c;
                            String eventName = notification.BI_PSPB_EventName__c;
                            String eventType = notification.BI_PSPB_EventType__c;
                            String smsBodyLink;
                            if (
                                notificationDate != null &&
                                String.valueOf(notificationDate).length() > 0
                            ) {
                                smsBodyLink =
                                    smsBody +
                                    ' ' +
                                    notificationDate +
                                    ' ' +
                                    desturl;
                            } 
                            else {
                                smsBodyLink = smsBody + ' ' + desturl;
                            }
                            String payload;                       
                            for (Contact targetContacts : targetContact) {
                                if (
                                    targetContacts != null &&
                                    targetContacts.Phone != null &&
                                    targetContacts.Name != null
                                ) {
                                    String userPhoneNumber = targetContacts.Phone;
                                    Contact userName = targetContacts;
                                    if (
                                        notificationDate != null &&
                                        String.valueOf(notificationDate)
                                            .length() > 0
                                    ) {
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
                                            'Bearer ' + accessToken
                                        );
                                        request.setHeader(
                                            'Content-Type',
                                            'application/json'
                                        );
                                        request.setBody(payload);
                                        Http http = new Http();
                                        HttpResponse response = http.send(
                                            request
                                        );                                       
                                        if (response.getStatusCode() == 200) {
                                            if (response.getBody() != null) {
                                                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(
                                                    response.getBody()
                                                );
                                                	status = (String) jsonResponse.get(
                                                    'status'
                                                );
                                               String messageId = (String) jsonResponse.get(
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
                                        } else if (response.getStatusCode() != 200){
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
                                            concatenatedParams =targetContacts.Id +',' 
                                                + userPhoneNumber +',' +notification.BI_PSPB_Subject__c +
                                                ',' +smsBody +',' +smsBodyLink +',' +eventName +',' +eventType +',' +
                                                smsResponse +',' +accessToken +',' +messageId +',' +status;
                                            BI_SFCOE_LOG_Util.logMessage(app,
                                                BI_PSPB_AsynchronousSmsCallout.class.toString(),
                                                BI_PSPB_constantsClass.httpResponseError,
                                                System.now(),concatenatedParams,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                                            );
                                            throw new CalloutException(
                                                BI_PSPB_constantsClass.httpResponseError +
                                                response.getStatusCode()
                                            );
                                        }
                                    }
                                }
                            }                           
                            if (smsLogList != null) {                          
                                Database.SaveResult[] saveResults = Database.insert(
                                    smsLogList,
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
                                        BI_PSPB_AsynchronousSmsCallout.class
                                            .toString(),
                                        System.now()
                                    );
                                    DmlException e = new DmlException();
                                    e.setMessage(errorMsg);
                                    throw e;
                                }
                            }
                        } else {
                             BI_SFCOE_LOG_Util.logMessage(
                                 app,BI_PSPB_AsynchronousSmsCallout.class.toString(),
                                 BI_PSPB_constantsClass.accessTokenError,System.now(),
                                 '',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                        }
                    
                } else {
                    
                     BI_SFCOE_LOG_Util.logMessage(app,
                        BI_PSPB_AsynchronousSmsCallout.class.toString(),
                        BI_PSPB_constantsClass.contactError,System.now(),
                        '',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                }
            } else {
                
                 BI_SFCOE_LOG_Util.logMessage(
                        app,
                        BI_PSPB_AsynchronousSmsCallout.class.toString(),
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
                BI_PSPB_AsynchronousSmsCallout.class.toString(),
                concatenatedParams,
                System.now()
            );
        }
    }
}