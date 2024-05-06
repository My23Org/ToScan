/**
 * @description 	This is class is used for getting the date from the LWC and generate a URL link add 
					reminder events in Google Calendar and outlook calender.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Anand S		30-Dec-2024		Created		This was an intial development.
 * 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */
public with sharing class BI_PSPB_ReminderCalendar {
	private static String GoogleCalendar = System.Label.BI_PSPB_GoogleCalendarURL;
	private static String OutlookCalendar = System.Label.BI_PSPB_OutlookCalendarURL;
	//varibale that holds the application name retrieved from Custom Settings.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	//A variable That holds the name of our application to be used in catch exception handler.
	private static String applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**

*@description  		This Method  is used to get URL for the Google Calender.
*@param    			Date eventDate  The Event Date for the patient.On the date of treatment.
*@return   			googleCalendarURL return the Url of Google Calender.
*					Returned in the LWC Component biPspbReminderSetup

**/
	@AuraEnabled(cacheable=true)
	public static String generateGoogleCalendarURL(Date eventDate) {
		try {
            if(eventDate!=null)
            {
                BI_PSPB_Notification__mdt notificationMetadata = BI_PSPB_Notification__mdt.getInstance(
                    BI_PSPB_ConstantsClass.Day_of_treatment
                );
                String title = notificationMetadata.BI_PSPB_CalenderTitle__c;
                DateTime startDateTime = DateTime.newInstanceGmt(
                    eventDate.year(),
                    eventDate.month(),
                    eventDate.day(),
                    0,
                    0,
                    0
                );
                DateTime endDateTime = DateTime.newInstanceGmt(
                    eventDate.year(),
                    eventDate.month(),
                    eventDate.day(),
                    23,
                    59,
                    59
                );
                String startDateTimeStr = startDateTime.formatGmt(
                    BI_PSPB_ConstantsClass.Time_Format
                );
                String endDateTimeStr = endDateTime.formatGmt(
                    BI_PSPB_ConstantsClass.Time_Format
                );
                String details = notificationMetadata.BI_PSPB_CalenderDescription__c;
                if (
                    String.isNotBlank(startDateTimeStr) &&
                    String.isNotBlank(startDateTimeStr) &&
                    String.isNotBlank(details) &&
                    String.isNotBlank(title)
                )
                 {
                    String googleCalendarURL =
                        GoogleCalendar +
                        '&text=' +
                        EncodingUtil.urlEncode(title, 'UTF-8') +
                        '&dates=' +
                        startDateTimeStr +
                        '/' +
                        endDateTimeStr +
                        '&details=' +
                        EncodingUtil.urlEncode(details, 'UTF-8') +
                        '&trp=true';
    
                    if ( String.isNotBlank(googleCalendarURL)){
                        return googleCalendarURL;
                    } else {
                        BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_ReminderCalendar.class.toString(),
                            BI_PSPB_constantsClass.googleUrlError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                            throw new AuraHandledException(BI_PSPB_ConstantsClass.googleUrlError);
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_ReminderCalendar.class.toString(),
                        BI_PSPB_ConstantsClass.stringError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                        throw new AuraHandledException(BI_PSPB_ConstantsClass.stringError);
                }
            }else{
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_ReminderCalendar.class.toString(),
            		BI_PSPB_constantsClass.parameterError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
          		throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
                
            }
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
                ex,
				applicationName,
                BI_PSPB_PatientDetailsCtrl.class.toString(),
				null,
                System.now()
            );
			throw new AuraHandledException(
				BI_PSPB_ConstantsClass.googleUrlError
			);
		}
	}

	/**
	
	 *@description  		This Method  is used to get URL for the  Outlook Calender.
	 *@param    			Date eventDate  The Event Date for the patient.On the date of treatment.
	 *@return   			caregiverAccounts List of Patients. Returned in the LWC Component 
	 *						Returned in the LWC Component biPspbReminderSetup
	
	 **/
	@AuraEnabled(cacheable=true)
	public static String generateOutlookCalendarURL(Date eventDate) {
		try {
            if(eventDate!=null)
            {
				BI_PSPB_Notification__mdt notificationMetadata = BI_PSPB_Notification__mdt.getInstance(
					BI_PSPB_ConstantsClass.Day_of_treatment
				);
				String title = notificationMetadata.BI_PSPB_CalenderTitle__c;
				DateTime startDateTime = DateTime.newInstanceGmt(
					eventDate.year(),
					eventDate.month(),
					eventDate.day(),
					0,
					0,
					0
				);
				DateTime endDateTime = DateTime.newInstanceGmt(
					eventDate.year(),
					eventDate.month(),
					eventDate.day(),
					23,
					59,
					59
				);
				String startDateTimeStr = startDateTime.formatGmt(
					BI_PSPB_ConstantsClass.Time_Format
				);
				String endDateTimeStr = endDateTime.formatGmt(
					BI_PSPB_ConstantsClass.Time_Format
				);
				String details = notificationMetadata.BI_PSPB_CalenderDescription__c;
				if (
					String.isNotBlank(startDateTimeStr) &&
					String.isNotBlank(startDateTimeStr) &&
					String.isNotBlank(details) &&
					String.isNotBlank(title)
				) {
					String outlookCalendarURL =
						OutlookCalendar +
						EncodingUtil.urlEncode(details, 'UTF-8') +
						'&subject=' +
						EncodingUtil.urlEncode(title, 'UTF-8') +
						'&startdt=' +
						startDateTimeStr +
						'&enddt=' +
						endDateTimeStr;

					if ( String.isNotBlank(outlookCalendarURL)) {
						return outlookCalendarURL;
					} else {
						BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_ReminderCalendar.class.toString(),
							BI_PSPB_ConstantsClass.outLookUrlError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
						throw new AuraHandledException(BI_PSPB_ConstantsClass.outLookUrlError);
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_ReminderCalendar.class.toString(),
						BI_PSPB_ConstantsClass.stringError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					throw new AuraHandledException(BI_PSPB_ConstantsClass.stringError);
				}
            }else{
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_ReminderCalendar.class.toString(),
            		BI_PSPB_constantsClass.parameterError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
          		throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
            }
		} 
        catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
                ex,
				applicationName,
                BI_PSPB_PatientDetailsCtrl.class.toString(),
				null,
                System.now()
            );
			throw new AuraHandledException(
                BI_PSPB_ConstantsClass.outLookUrlError
            );
		}
	}
}