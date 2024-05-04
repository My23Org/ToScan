/**
 * @description Retrieves the account ID associated with the given user ID based on email matching.
 * History
 * Version 	Author					Date			Detail		Description
 * 1.0		Divya Bharathi S		07-Dec-2024			Created		This was an intial development.
 * 1.1		Rajaa					06-Apr-2024			Updated		Code Review Changes.
 */

public with sharing class BI_PSP_exusergetaccid {
//varibale that holds the application name retrieved from Custom Settings.
private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
//A variable That holds the name of our application to be used in catch exception handler.
private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
  private static String errorUserName = System.Label.BI_PSPB_Error_For_UserName;
    
/**
 * @description Retrieves the account ID associated with the given user ID based on email matching.
 *
 * @param userid The ID of the user.
 * @return The ID of the associated account, if found; otherwise, null.
 */ 
	@AuraEnabled(cacheable=true)
	public static String getaAccId(string userid) {
		try {
			string Email;
			if(Email == null || String.isEmpty(Email)){				
			list<Account> acc = [SELECT id, Name, PersonEmail FROM Account];
			list<user> us = new List<user>(
				[SELECT name, Email FROM user WHERE id = :userid]
			);
			if (!acc.isEmpty()) {
				for (Account ac : acc) {
					if (!us.isEmpty()) {
						for (user u : us) {
							if (u.Email == ac.PersonEmail) {
								Email = ac.id;
							}
						}
					} else {
                        BI_SFCOE_LOG_Util.logMessage(
                            applicationName,
                            BI_PSP_exusergetaccid.class
                            .toString(),
                            BI_PSPB_constantsClass.error,
                            System.now(),
                            '',
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
						throw new AuraHandledException(                            
							BI_PSPB_constantsClass.error
						);
					}
				}
			} else {
                BI_SFCOE_LOG_Util.logMessage(
                            applicationName,
                            BI_PSP_exusergetaccid.class
                            .toString(),
                            BI_PSPB_constantsClass.error,
                            System.now(),
                            '',
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
				throw new AuraHandledException(BI_PSPB_constantsClass.error);
			}
			if (Email != null) {
				return Email;
			} else {
                BI_SFCOE_LOG_Util.logMessage(
                            applicationName,
                            BI_PSP_exusergetaccid.class
                            .toString(),
                            BI_PSPB_constantsClass.error,
                            System.now(),
                            '',
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
				throw new AuraHandledException(BI_PSPB_constantsClass.error);
			}
		} else{
            BI_SFCOE_LOG_Util.logMessage(applicationName,
                            BI_PSP_exusergetaccid.class.toString(),
                            BI_PSPB_constantsClass.stringError, System.now(), '',
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			throw new AuraHandledException(BI_PSPB_constantsClass.stringError);
		}
		} catch (Exception ex) {			
				BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PatientDetailsCtrl.class.toString(), 
				null,
				System.now()
			);
			throw new AuraHandledException(errorUserName);
		}
	}
}