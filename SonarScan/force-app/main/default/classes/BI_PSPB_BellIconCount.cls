/**
 * @description This class is used for getting the Number of Notifications for that Patient.
 * we have used without sharing  for this class beacuse of task object.
 * This class we have used the Care Program Enrolle Object which is a   health cloud package so we can't use the user mode .
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Anand S		30-Dec-2024		Created		This was an intial development.
 * 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */
public without sharing class BI_PSPB_BellIconCount {
  //varibale that holds the application name retrieved from Custom Settings.
  private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
	  'PSPB'
  );
  //A variable That holds the name of our application to be used in catch exception handler.
  private static String applicationName = settings != null
	  ? settings.BI_SFCOE_LOG_Application__c
	  : '';
  /**

*@description  Method to get the Number of Notifications for the Patient for the Branded. 
*This class contain CareProgramEnrollee object query it won't support the User mode. 
*@param    	accountId  This is a Patient Id .
*@return   	taskCount -Number of Notifications Unread for the patient.this is used in the biPspbNavBar component

**/
  @AuraEnabled(cacheable=true)
  public static Integer getTaskCount(string accountId) {
	  Integer taskCount = 0;
	  try {
		//This query has CareProgramEnrollee object query were it won't support With User_Mode
		  List<CareProgramEnrollee> cpeList = [
			  SELECT Id
			  FROM CareProgramEnrollee
			  WHERE Id = :accountId
			  LIMIT 1
		  ];
		  if (!cpeList.isEmpty()) {
			  CareProgramEnrollee cpeRecord = cpeList[0];
			  //This query has Task object query were it won't support With User_Mode
			  taskCount = [
				  SELECT COUNT()
				  FROM Task
				  WHERE
					  WhatId = :cpeRecord.Id
					  AND Status IN (
						  :BI_PSPB_constantsClass.ACTION_TYPE_UnRead,
						  :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction
					  )
			  ];
			  //This query has CareProgramEnrollee object query were it won't support With User_Mode
			  List<BI_PSPB_Treatment_Reminder__c> remindertask = [
				  SELECT Id
				  FROM BI_PSPB_Treatment_Reminder__c
				  WHERE BI_PSPB_Care_Program_Enrollee__c = :cpeRecord.Id
			  ];
			  taskCount += [
				  SELECT COUNT()
				  FROM Task
				  WHERE
					  WhatId IN :remindertask
					  AND Status IN (
						  :BI_PSPB_constantsClass.ACTION_TYPE_UnRead,
						  :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction
					  )
			  ];
		  }
		  else{
			BI_SFCOE_LOG_Util.logMessage(
			applicationName,
			BI_PSPB_BellIconCount.class
				.toString(),
			BI_PSPB_ConstantsClass.stringError,
			System.now(),
			'',
			BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
		);
			throw new AuraHandledException(BI_PSPB_constantsClass.error);
		  }

		  return taskCount;
	  } catch (Exception ex) {
		  BI_SFCOE_LOG_Util.handleException(
			  ex,
			  applicationName,
			  BI_PSPB_BellIconCount.class.toString(),
			  null,
			  System.now()
		  );
		  throw new AuraHandledException(BI_PSPB_constantsClass.error);
	  }
  }

  /**
   *@description 	Method to get the Number of Notifications for the Patient for unassigned .
   *This class contain CareProgramEnrollee object query it won't support the User mode.
   *@param    	accountId  This is a Patient Id .
   *@return   	taskCount -Number of Notifications Unread for the patient.this is used in the biPspbNavBar component
   **/
  @AuraEnabled(cacheable=true)
  public static Integer getTaskCountUA(string accountId) {
	  Integer taskCount = 0;
	  try {
		  List<CareProgramEnrollee> cpeList = [
			  SELECT Id
			  FROM CareProgramEnrollee
			  WHERE Id = :accountId
			  LIMIT 1
		  ];
		  if (!cpeList.isEmpty()) {
			
			  CareProgramEnrollee cpeRecord = cpeList[0];
			  // Query for related tasks
			  //This query has Task object query were it won't support With User_Mode
			  taskCount = [
				  SELECT COUNT()
				  FROM Task
				  WHERE
					  WhatId = :cpeRecord.Id
					  AND Status IN (
						  :BI_PSPB_constantsClass.ACTION_TYPE_UnRead,
						  :BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction
					  )
			  ];
		   }
		   else{
			BI_SFCOE_LOG_Util.logMessage(
			applicationName,
			BI_PSPB_BellIconCount.class
				.toString(),
			BI_PSPB_ConstantsClass.stringError,
			System.now(),
			'',
			BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
		);
			throw new AuraHandledException(BI_PSPB_constantsClass.error);
		  }

		  return taskCount;
	  } catch (Exception ex) {
		  BI_SFCOE_LOG_Util.handleException(
			  ex,
			  applicationName,
			  BI_PSPB_BellIconCount.class.toString(),
			  null,
			  System.now()
		  );
		  throw new AuraHandledException(BI_PSPB_constantsClass.error);
	  }
  }
}