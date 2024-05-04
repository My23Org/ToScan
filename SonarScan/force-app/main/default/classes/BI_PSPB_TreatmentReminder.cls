/**
 * @description 	This is class is used for getting the data from Treatment Reminder object.
 * 					This class Contain Without Sharing Because we have to update tasks created by System Admin from Patient profile .
 * 					This class is without sharing, so we cannot use USER_MODE .
 * History
 * Version 	Author					Date				Detail		Description
 * 1.0		Anand S					16-Dec-2024			Created		This was an intial development.
 * 1.1		Rajaa					06-Apr-2024			Updated		Code Review Changes.
 */

 public without sharing class BI_PSPB_TreatmentReminder {
	//varibale that holds the application name retrieved from Custom Settings.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
	  'PSPB'
	);
	//A variable That holds the name of our application to be used in catch exception handler.
	private static String applicationName = settings != null
	  ? settings.BI_SFCOE_LOG_Application__c
	  : '';
	private static String errorMsg = '';
	private static String errorDml = System.Label.BI_PSPB_UnableToUpdateRecord;
	/**
	 
	 *@description This method is used for the Crreation of reminder records  in Treatment Reminders Objec.
	 *This method has CareProgramEnrollee object query were it won't support With User_Mode .
	 *@param    accountId - is the Patient Id .
	 *@param    Date selectedDate it is the date selected for the Date of tretment by the Patient .
	 *@param    List<String> selectedReminders to check the 14,10,7  checkboxes are checked or not.
	 *@param    List<String> selectedTreatment to check the 3,1 checkboxes are checked or not.
	 **/
	@AuraEnabled(cacheable=false)
	public static void createRemainderRecord(
	  String accountId,
	  Date selectedDate,
	  List<String> selectedReminders,
	  List<String> selectedTreatment
	) {
	  try {
		if (
		  !string.isBlank(accountId) &&
		  selectedDate != null &&
		  !selectedReminders.isEmpty() &&
		  !selectedTreatment.isEmpty()
		) {
		  List<String> checkboxes = new List<String>();
		  //This method has CareProgramEnrollee object query were it won't support With User_Mode
		  CareProgramEnrollee cpe = [
			SELECT Id, BI_PSPB_Selected_Checkboxes__c
			FROM CareProgramEnrollee
			WHERE Id = :accountId
			LIMIT 1
		  ];
  
		  if (cpe != null) {
			List<BI_PSPB_Treatment_Reminder__c> remaindersToInsert = new List<BI_PSPB_Treatment_Reminder__c>();
			//if (!remaindersToInsert.isEmpty()) {
			  //We have used the values in maps for getting subject and reminder days,
			  //so we are not able to change logic for this to avoid risk of functionality getting affected.
			  List<BI_PSPB_Notification__mdt> allRemindersMetadata = BI_PSPB_Notification__mdt.getAll()
				.values();
			  List<BI_PSPB_Notification__mdt> remindersMetadata = new List<BI_PSPB_Notification__mdt>();
			  //We have used the values in maps for getting subject and reminder days,
			  //so we are not able to change logic for this to avoid risk of functionality getting affected.
			  for (
				BI_PSPB_Notification__mdt notification : allRemindersMetadata
			  ) {
				if (
				  notification.DeveloperName ==
				  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_PR14daysbefore ||
				  notification.DeveloperName ==
				  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_PR10daysbefore ||
				  notification.DeveloperName ==
				  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_PR7daysbefore
				) {
				  remindersMetadata.add(notification);
				}
			  }
			  //We have used the values in maps for getting subject and reminder days,
			  //so we are not able to change logic for this to avoid risk of functionality getting affected.
			  List<BI_PSPB_Notification__mdt> allTreatmentsMetadata = BI_PSPB_Notification__mdt.getAll()
				.values();
			  List<BI_PSPB_Notification__mdt> treatmentsMetadata = new List<BI_PSPB_Notification__mdt>();
  
			  for (
				BI_PSPB_Notification__mdt notification : allTreatmentsMetadata
			  ) {
				if (
				  notification.DeveloperName ==
				  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_TR3DaysBefore ||
				  notification.DeveloperName ==
				  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_TR1daybefore
				) {
				  treatmentsMetadata.add(notification);
				}
			  }
			  //We have used the values in maps for getting subject and reminder days,
			  //so we are not able to change logic for this to avoid risk of functionality getting affected.
			  List<BI_PSPB_Notification__mdt> allDayofTreatMetadata = BI_PSPB_Notification__mdt.getAll()
				.values();
			  List<BI_PSPB_Notification__mdt> DayofTreatMetadata = new List<BI_PSPB_Notification__mdt>();
  
			  for (
				BI_PSPB_Notification__mdt notification : allDayofTreatMetadata
			  ) {
				if (
				  notification.DeveloperName ==
				  BI_PSPB_ConstantsClass.Day_of_treatment
				) {
				  DayofTreatMetadata.add(notification);
				}
			  }
  
			  // Map to store reminders and treatments dynamically
			  Map<Integer, String> reminderMap = new Map<Integer, String>();
			  Map<Integer, String> treatmentMap = new Map<Integer, String>();
			  if (!remindersMetadata.isEmpty()) {
				for (BI_PSPB_Notification__mdt reminder : remindersMetadata) {
				  reminderMap.put(
					Integer.valueOf(reminder.BI_PSPB_TreatmentDaysLeft__c),
					reminder.BI_PSPB_Subject__c
				  );
				}
			  }
			  if (!treatmentsMetadata.isEmpty()) {
				for (BI_PSPB_Notification__mdt treatment : treatmentsMetadata) {
				  treatmentMap.put(
					Integer.valueOf(treatment.BI_PSPB_TreatmentDaysLeft__c),
					treatment.BI_PSPB_Subject__c
				  );
				}
			  }
			  //This query has CareProgramEnrollee object query were it won't support With User_Mode
			  List<BI_PSPB_Treatment_Reminder__c> remindersToUpdate = [
				SELECT Id
				FROM BI_PSPB_Treatment_Reminder__c
				WHERE
				  BI_PSPB_Care_Program_Enrollee__c = :cpe.Id
				  AND BI_PSPB_Status__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Active
				WITH USER_MODE
			  ];
  
			  for (BI_PSPB_Treatment_Reminder__c reminder : remindersToUpdate) {
				reminder.BI_PSPB_Status__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Inactive;
			  }
			  //update remindersToUpdate;
			  Database.SaveResult[] remindersTo = Database.update(
				remindersToUpdate,
				false,
				AccessLevel.USER_MODE
			  );
  
			  for (Database.SaveResult saveResult : remindersTo) {
				if (!saveResult.isSuccess()) {
				  for (Database.Error error : saveResult.getErrors()) {
					errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
				  }
				}
			  }
			  if (!String.isBlank(errorMsg)) {
				BI_SFCOE_LOG_Util.logMessage(
				  applicationName,BI_PSPB_TreatmentReminder.class.toString(),
				  '',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				DmlException e = new DmlException();
				e.setMessage(errorMsg);throw e;
			  }
  
			  String dayOfTreatmentSubject = DayofTreatMetadata.isEmpty()
				? ''
				: DayofTreatMetadata[0].BI_PSPB_Subject__c;
  
			  for (String reminder : selectedReminders) {
				BI_PSPB_Treatment_Reminder__c reminderRecord = new BI_PSPB_Treatment_Reminder__c();
				reminderRecord.BI_PSPB_Care_Program_Enrollee__c = cpe.Id;
				reminderRecord.BI_PSPB_Date_of_Treatment__c = selectedDate;
				reminderRecord.BI_PSPB_Reminder_Date__c = selectedDate.addDays(
				  -Integer.valueOf(reminder)
				);
				reminderRecord.BI_PSPB_Reminder_Type__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Prescription;
				reminderRecord.BI_PSPB_Status__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Active;
				reminderRecord.BI_PSPB_Subject__c = reminderMap.get(
				  Integer.valueOf(reminder)
				);
				remaindersToInsert.add(reminderRecord);
				checkboxes.add(reminder);
			  }
  
			  for (String treatment : selectedTreatment) {
				BI_PSPB_Treatment_Reminder__c treatmentRecord = new BI_PSPB_Treatment_Reminder__c();
				treatmentRecord.BI_PSPB_Care_Program_Enrollee__c = cpe.Id;
				treatmentRecord.BI_PSPB_Date_of_Treatment__c = selectedDate;
				treatmentRecord.BI_PSPB_Reminder_Date__c = selectedDate.addDays(
				  -Integer.valueOf(treatment)
				);
				treatmentRecord.BI_PSPB_Reminder_Type__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Treatment;
				treatmentRecord.BI_PSPB_Status__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Active;
				treatmentRecord.BI_PSPB_Subject__c = treatmentMap.get(
				  Integer.valueOf(treatment)
				);
				remaindersToInsert.add(treatmentRecord);
				checkboxes.add(treatment);
			  }
  
			  // Adding an additional record for selectedDate under Remainder_Date__c and Date_of_Treatment__c
			  BI_PSPB_Treatment_Reminder__c additionalRecord = new BI_PSPB_Treatment_Reminder__c();
			  additionalRecord.BI_PSPB_Care_Program_Enrollee__c = cpe.Id;
			  additionalRecord.BI_PSPB_Date_of_Treatment__c = selectedDate;
			  additionalRecord.BI_PSPB_Reminder_Date__c = selectedDate;
			  additionalRecord.BI_PSPB_Reminder_Type__c = BI_PSPB_ConstantsClass.ACTION_TYPE_DateOfTreatment;
			  additionalRecord.BI_PSPB_Status__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Active;
			  additionalRecord.BI_PSPB_Subject__c = dayOfTreatmentSubject;
			  // Set other fields for this additional record if needed
  
			  remaindersToInsert.add(additionalRecord);
			  if (!remaindersToInsert.isEmpty()) {
				Database.SaveResult[] insertResults = Database.insert(
				  remaindersToInsert,
				  false,
				  AccessLevel.USER_MODE
				);
  
				for (Database.SaveResult saveResult : insertResults) {
				  if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
					  errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
					}
				  }
				}
				if (!String.isBlank(errorMsg)) {
				  BI_SFCOE_LOG_Util.logMessage(
					applicationName,BI_PSPB_TreatmentReminder.class.toString(),
					'',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				  DmlException e = new DmlException();
				  e.setMessage(errorMsg);throw e;
				}
			  } else {
				BI_SFCOE_LOG_Util.logMessage(
				  applicationName,BI_PSPB_TreatmentReminder.class.toString(),
				  BI_PSPB_ConstantsClass.error,System.now(),
				  '',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				throw new AuraHandledException(BI_PSPB_constantsClass.error);
			  }
			}
			cpe.BI_PSPB_Selected_Checkboxes__c = String.join(checkboxes, ';'); // Change the delimiter as needed
  
			// Update the CareProgramEnrollee record to save the selected checkboxes
			Database.SaveResult updateResult = Database.update(
			  cpe,
			  false,
			  AccessLevel.USER_MODE
			);
			if (!updateResult.isSuccess()) {
			  // Handle the error
			  for (Database.Error error : updateResult.getErrors()) {
				BI_SFCOE_LOG_Util.logMessage(applicationName,
				  BI_PSPB_TreatmentReminder.class.toString(),
				  '',System.now(),'Error ' + error.getFields() + '--' + error.getMessage(),
				  BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			  }
			} else {
			  BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_TreatmentReminder.class.toString(),
				BI_PSPB_ConstantsClass.stringError,
				System.now(),
				'',
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			  );
			  throw new AuraHandledException(BI_PSPB_ConstantsClass.stringError);
			}
		  } else {
			BI_SFCOE_LOG_Util.logMessage(applicationName,
			  BI_PSPB_TreatmentReminder.class.toString(),
			  BI_PSPB_ConstantsClass.stringError,System.now(),
			  '',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			throw new AuraHandledException(BI_PSPB_ConstantsClass.stringError);
		  }
		  // Set the Selected_Checkboxes__c field with the checkboxes list		
	  } catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(
		  ex,
		  applicationName,
		  BI_PSPB_TreatmentReminder.class.toString(),
		  null,
		  System.now()
		);
		throw new AuraHandledException(errorDml);
	  }
	}
  
	/**
	 
	 *@description		Creates treatment reminders for a specified account and date of treatment.
	 *					This method queries the CareProgramEnrollee object to retrieve selected checkboxes
	 * 					associated with the specified account ID. It then calculates reminder dates based
	 * 					on the selected checkboxes and inserts reminder records accordingly. Additionally,
	 * 					a reminder for the treatment date itself is inserted.
	 *					This method has CareProgramEnrollee object query were it won't support With User_Mode .
	 * @param 			accountId is the Patient Id .
	 * @param 			dateOfTreatment date of treatement the patient has successfully taken.
  
	 
	 */
	@AuraEnabled(cacheable=false)
	public static void createTreatmentReminders(
	  String accountId,
	  Date dateOfTreatment
	) {
		//This method has CareProgramEnrollee object query were it won't support With User_Mode
	  CareProgramEnrollee enrollee = new CareProgramEnrollee();
	  try {
		if (!String.isBlank(accountId)) {
		  enrollee = [
			SELECT Id, BI_PSPB_Selected_Checkboxes__c
			FROM CareProgramEnrollee
			WHERE Id = :accountId
			LIMIT 1
		  ];
		} else {
		  BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_TreatmentReminder.class.toString(),
			BI_PSPB_constantsClass.parameterError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
		  throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
		}
  
		if (enrollee != null && enrollee.BI_PSPB_Selected_Checkboxes__c != null) {
		  List<String> selectedCheckboxesStr = enrollee.BI_PSPB_Selected_Checkboxes__c.split(
			';'
		  );
		  List<Integer> selectedCheckboxes = new List<Integer>();
		  for (String checkbox : selectedCheckboxesStr) {
			selectedCheckboxes.add(Integer.valueOf(checkbox)); // Convert strings to integers
		  }
  
		  List<BI_PSPB_Treatment_Reminder__c> remindersToInsert = new List<BI_PSPB_Treatment_Reminder__c>();
		  //We have used the values in maps for getting subject and reminder days,
		  //so we are not able to change logic for this to avoid risk of functionality getting affected.
		  List<BI_PSPB_Notification__mdt> allRemindersMetadata = BI_PSPB_Notification__mdt.getAll()
			.values();
		  List<BI_PSPB_Notification__mdt> remindersMetadata = new List<BI_PSPB_Notification__mdt>();
  
		  for (BI_PSPB_Notification__mdt notification : allRemindersMetadata) {
			if (
			  notification.DeveloperName ==
			  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_PR14daysbefore ||
			  notification.DeveloperName ==
			  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_PR10daysbefore ||
			  notification.DeveloperName ==
			  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_PR7daysbefore
			) {
			  remindersMetadata.add(notification);
			}
		  }
		  //We have used the values in maps for getting subject and reminder days,
		  //so we are not able to change logic for this to avoid risk of functionality getting affected.
		  List<BI_PSPB_Notification__mdt> allNotifications = BI_PSPB_Notification__mdt.getAll()
			.values();
		  List<BI_PSPB_Notification__mdt> filteredNotifications = new List<BI_PSPB_Notification__mdt>();
  
		  for (BI_PSPB_Notification__mdt notification : allNotifications) {
			if (
			  notification.DeveloperName ==
			  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_TR3DaysBefore ||
			  notification.DeveloperName ==
			  BI_PSPB_ConstantsClass.Treatment_BI_PSPB_TR1daybefore
			) {
			  filteredNotifications.add(notification);
			}
		  }
		  //We have used the values in maps for getting subject and reminder days,
		  //so we are not able to change logic for this to avoid risk of functionality getting affected.
		  List<BI_PSPB_Notification__mdt> dayofTreatMetadata = BI_PSPB_Notification__mdt.getAll()
			.values();
		  List<BI_PSPB_Notification__mdt> filteredDayofTreatMetadata = new List<BI_PSPB_Notification__mdt>();
  
		  for (BI_PSPB_Notification__mdt notification : dayofTreatMetadata) {
			if (
			  notification.DeveloperName ==
			  BI_PSPB_ConstantsClass.Day_of_treatment
			) {
			  filteredDayofTreatMetadata.add(notification);
			}
		  }
  
		  // Map to store reminders and treatments dynamically
		  Map<Integer, String> reminderSubjectMap = new Map<Integer, String>();
		  Map<Integer, String> treatmentSubjectMap = new Map<Integer, String>();
  
		  if (!remindersMetadata.isEmpty()) {
			for (BI_PSPB_Notification__mdt reminder : remindersMetadata) {
			  reminderSubjectMap.put(
				Integer.valueOf(reminder.BI_PSPB_TreatmentDaysLeft__c),
				reminder.BI_PSPB_Subject__c
			  );
			}
		  } else {
			throw new AuraHandledException(BI_PSPB_constantsClass.metaDataError);
		  }
		  if (!filteredNotifications.isEmpty()) {
			for (BI_PSPB_Notification__mdt treatment : filteredNotifications) {
			  treatmentSubjectMap.put(
				Integer.valueOf(treatment.BI_PSPB_TreatmentDaysLeft__c),
				treatment.BI_PSPB_Subject__c
			  );
			}
		  } else {
			BI_SFCOE_LOG_Util.logMessage(applicationName,
			  BI_PSPB_TreatmentReminder.class.toString(),
			  BI_PSPB_constantsClass.metaDataError,System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			throw new AuraHandledException(BI_PSPB_constantsClass.metaDataError);
		  }
		  //This query has CareProgramEnrollee object query were it won't support With User_Mode
		  List<BI_PSPB_Treatment_Reminder__c> remindersToUpdate = [
			SELECT Id
			FROM BI_PSPB_Treatment_Reminder__c
			WHERE
			  BI_PSPB_Care_Program_Enrollee__c = :enrollee.Id
			  AND BI_PSPB_Status__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Active
			WITH USER_MODE
		  ];
		  if (!remindersToUpdate.isEmpty()) {
			for (BI_PSPB_Treatment_Reminder__c reminder : remindersToUpdate) {
			  reminder.BI_PSPB_Status__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Inactive;
			}
		  } else {
			BI_SFCOE_LOG_Util.logMessage(
			  applicationName,
			  BI_PSPB_TreatmentReminder.class.toString(),
			  BI_PSPB_constantsClass.metaDataError,
			  System.now(),
			  '',
			  BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
			throw new AuraHandledException(BI_PSPB_constantsClass.metaDataError);
		  }
		  //update remindersToUpdate;
		  Database.SaveResult[] updateResult = Database.update(
			remindersToUpdate,
			false,
			AccessLevel.USER_MODE
		  );
		  for (Database.SaveResult saveResult : updateResult) {
			if (!saveResult.isSuccess()) {
			  // Handle the error
			  for (Database.Error error : saveResult.getErrors()) {
				BI_SFCOE_LOG_Util.logMessage(applicationName,
				  BI_PSPB_TreatmentReminder.class.toString(),'',
				  System.now(),'Error ' + error.getFields() + '--' + error.getMessage(),
				  BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			  }
			}
		  }
		  String dayOfTreatmentSubject = filteredDayofTreatMetadata.isEmpty()
			? ''
			: filteredDayofTreatMetadata[0].BI_PSPB_Subject__c;
		  for (Integer days : selectedCheckboxes) {
			if (dateOfTreatment != null) {
			  Date reminderDate = dateOfTreatment.addDays(-days); // Calculate the reminder date based on selected checkboxes
			  BI_PSPB_Treatment_Reminder__c reminder = new BI_PSPB_Treatment_Reminder__c();
			  reminder.BI_PSPB_Care_Program_Enrollee__c = enrollee.Id;
			  reminder.BI_PSPB_Date_of_Treatment__c = dateOfTreatment;
			  reminder.BI_PSPB_Reminder_Date__c = reminderDate;
			  reminder.BI_PSPB_Status__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Active;
			  if (reminderSubjectMap.containsKey(days)) {
				reminder.BI_PSPB_Subject__c = reminderSubjectMap.get(days);
				reminder.BI_PSPB_Reminder_Type__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Prescription;
			  } else if (treatmentSubjectMap.containsKey(days)) {
				reminder.BI_PSPB_Subject__c = treatmentSubjectMap.get(days);
				reminder.BI_PSPB_Reminder_Type__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Treatment;
			  }
			  remindersToInsert.add(reminder);
			} else {
			  BI_SFCOE_LOG_Util.logMessage(applicationName,
				BI_PSPB_TreatmentReminder.class.toString(),
				BI_PSPB_constantsClass.metaDataError,System.now(),
				'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			  throw new AuraHandledException(BI_PSPB_constantsClass.error);
			}
		  }
		  BI_PSPB_Treatment_Reminder__c reminderForTreatmentDate = new BI_PSPB_Treatment_Reminder__c();
		  reminderForTreatmentDate.BI_PSPB_Care_Program_Enrollee__c = enrollee.Id;
		  reminderForTreatmentDate.BI_PSPB_Date_of_Treatment__c = dateOfTreatment;
		  reminderForTreatmentDate.BI_PSPB_Reminder_Date__c = dateOfTreatment;
		  reminderForTreatmentDate.BI_PSPB_Status__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Active;
		  reminderForTreatmentDate.BI_PSPB_Subject__c = dayOfTreatmentSubject;
		  remindersToInsert.add(reminderForTreatmentDate);
		  Database.SaveResult[] insertResults = Database.insert(
			remindersToInsert,
			false,
			AccessLevel.USER_MODE
		  );
		  for (Database.SaveResult saveResult : insertResults) {
			if (!saveResult.isSuccess()) {
			  for (Database.Error error : saveResult.getErrors()) {
				errorMsg += 'Error ' +error.getFields() +'--' +error.getMessage() +'\n';
			  }
			}
		  }
		  if (!String.isBlank(errorMsg)) {
			BI_SFCOE_LOG_Util.logMessage(applicationName,
			  BI_PSPB_TreatmentReminder.class.toString(),
			  '',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			throw new AuraHandledException(BI_PSPB_constantsClass.error);
		  }
		}
	  } catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(
		  ex,
		  applicationName,
		  BI_PSPB_TreatmentReminder.class.toString(),
		  null,
		  System.now()
		);
		throw new AuraHandledException(errorDml);
	  }
	}
	/**
  * @description	This method is used for  Reminder widget To show the Reminding of the 
					Treatment Starts and Treatment End Date and the Date of Treatment. 
					This method has CareProgramEnrollee object query were it won't support With User_Mode .
  * @param 			String accountId is the Patient Id .
  * @return  		tasks - Records from Treatment reminder.This return in the biPspbReminderWidget component 
  * @throws 		AuraHandledException if an error occurs during the reminder creation process.
  */
	@AuraEnabled(cacheable=true)
	public static List<BI_PSPB_Treatment_Reminder__c> getTasksWithDateOfTreatment(
	  String accountId
	) {
	  try {
		if (!string.isBlank(accountId)) {
		//This method has CareProgramEnrollee object query were it won't support With User_Mode
		  List<CareProgramEnrollee> cpeList = [
			SELECT Id
			FROM CareProgramEnrollee
			WHERE Id = :accountId
			LIMIT 1
		  ];
		  if (!cpeList.isEmpty()) {
			// Collect the Id values into a separate list
			Set<Id> cpeIds = new Set<Id>();
			for (CareProgramEnrollee cpe : cpeList) {
			  cpeIds.add(cpe.Id);
			}
			//This query has CareProgramEnrollee object query were it won't support With User_Mode
			List<BI_PSPB_Treatment_Reminder__c> tasks = [
			  SELECT
				Id,
				BI_PSPB_Subject__c,
				BI_PSPB_Date_of_Treatment__c,
				BI_PSPB_Status__c,
				BI_PSPB_Reminder_Date__c,
				BI_PSPB_Care_Program_Enrollee__c
			  FROM BI_PSPB_Treatment_Reminder__c
			  WHERE
				BI_PSPB_Care_Program_Enrollee__c IN :cpeIds
				AND BI_PSPB_Date_of_Treatment__c != NULL
				AND BI_PSPB_Reminder_Date__c > TODAY
				AND BI_PSPB_Reminder_Date__c != TODAY
				AND BI_PSPB_Status__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Active
			  ORDER BY BI_PSPB_Reminder_Date__c ASC
			  LIMIT 1
			];
			if (!tasks.isEmpty()) {
			  return tasks;
			} else {
			  BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_TreatmentReminder.class.toString(),
				BI_PSPB_constantsClass.errorMsgTaskIdNotFound,
				System.now(),
				'',
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			  );
			  throw new AuraHandledException(
				BI_PSPB_constantsClass.errorMsgTaskIdNotFound
			  );
			}
		  } else {
			BI_SFCOE_LOG_Util.logMessage(
			  	applicationName,
                BI_PSPB_TreatmentReminder.class.toString(),
			  	BI_PSPB_constantsClass.errorMsgTaskIdNotFound,
                System.now(),
			  	'',
                BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
            );
			throw new AuraHandledException(BI_PSPB_constantsClass.error);
		  }
		} else {
		  BI_SFCOE_LOG_Util.logMessage(
			applicationName,
			BI_PSPB_TreatmentReminder.class.toString(),
			BI_PSPB_constantsClass.parameterError,
			System.now(),
			'',
			BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
		  );
		  throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
		}
	  } catch (Exception e) {
		BI_SFCOE_LOG_Util.handleException(
		  e,
		  applicationName,
		  BI_PSPB_TreatmentReminder.class.toString(),
		  null,
		  System.now()
		);
	  }
	  throw new AuraHandledException(BI_PSPB_constantsClass.error);
	}
	/**
	 *@author          	Anand S
	 *@description		method to is used to get the date next upcoming treatment date .
	 *@param 			String accountId is the Patient Id .
	 *@return  			tasks - Records from Treatment reminder object.
	 *@throws 			AuraHandledException if an error occurs during the reminder creation process.
	 */
	@AuraEnabled(cacheable=true)
	public static List<BI_PSPB_Treatment_Reminder__c> getDateOfTreatment(
	  String accountId
	) {
	  try {
		if (!string.isBlank(accountId)) {
			//This query has CareProgramEnrollee object query were it won't support With User_Mode
		  List<BI_PSPB_Treatment_Reminder__c> tasks = [
			SELECT
			  Id,
			  BI_PSPB_Subject__c,
			  BI_PSPB_Date_of_Treatment__c,
			  BI_PSPB_Reminder_Date__c
			FROM BI_PSPB_Treatment_Reminder__c
			WHERE BI_PSPB_Care_Program_Enrollee__c = :accountId
		  ];
		  if (!tasks.isEmpty()) {
			return tasks;
		  } else {
			throw new AuraHandledException(BI_PSPB_ConstantsClass.error);
			//return null;
		  }
		} else {
		  BI_SFCOE_LOG_Util.logMessage(applicationName,
			BI_PSPB_TreatmentReminder.class.toString(),
			BI_PSPB_constantsClass.parameterError,System.now(),
			'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
		  throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
		}
	  } catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(
		  ex,
		  applicationName,
		  BI_PSPB_TreatmentReminder.class.toString(),
		  null,
		  System.now()
		);
		throw new AuraHandledException(
		  BI_PSPB_constantsClass.dateTreatmentError + ex.getMessage()
		);
	  }
	}
	/**
	 
	 *@description		This Method is used to show the top 3 notification in the widget.
	 *This method has Task,CareProgramEnrollee object query were it won't support With User_Mode .
	 *@param 			String accountId is the Patient Id .
	 *@return  			taskList - This retuen the related task records of the patient
	 					This reutrn in the biPspbDashboardNotification componen.
	 *@throws 			AuraHandledException Error fetching events.
	 */
	@AuraEnabled(cacheable=true)
	public static List<Task> getEvents(string accountId) {
	  List<Task> taskList = new List<Task>();
	  try {
		if (!string.isBlank(accountId)) {
		  // Fetch CareProgramEnrollee record for the specified Account
		  List<CareProgramEnrollee> cpeList = [
			SELECT Id
			FROM CareProgramEnrollee
			WHERE Id = :accountId
			LIMIT 1
		  ];
  
		  if (!cpeList.isEmpty()) {
			CareProgramEnrollee cpe = cpeList[0];
  
			// Query Treatment_Remainder__c record related to CareProgramEnrollee
			//This query has CareProgramEnrollee object query were it won't support With User_Mode
			List<BI_PSPB_Treatment_Reminder__c> trcList = [
			  SELECT Id
			  FROM BI_PSPB_Treatment_Reminder__c
			  WHERE BI_PSPB_Care_Program_Enrollee__c = :cpe.Id
			  ORDER BY BI_PSPB_Reminder_Date__c ASC
			  LIMIT 3
			];
			Set<Id> relatedIds = new Set<Id>();
			relatedIds.add(cpe.Id);
  
			for (BI_PSPB_Treatment_Reminder__c trc : trcList) {
			  relatedIds.add(trc.Id);
			}
  
			// Query Action Notification Tasks associated with related records
			List<Task> actionTasks = [
			  SELECT
				Id,
				Subject,
				CreatedDate,
				Status,
				BI_PSP_Category__c,
				BI_PSP_Notification_Type__c
			  FROM Task
			  WHERE
				WhatId IN :relatedIds
				AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_Action
				AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
			  ORDER BY CreatedDate DESC
			  LIMIT 1
			];
  
			// Add actionTasks to taskList
			taskList.addAll(actionTasks);
  
			// Query General Notification Tasks associated with related records
			List<Task> generalTasks = [
			  SELECT
				Id,
				Subject,
				CreatedDate,
				Status,
				BI_PSP_Category__c,
				BI_PSP_Notification_Type__c
			  FROM Task
			  WHERE
				WhatId IN :relatedIds
				AND BI_PSP_Notification_Type__c = :BI_PSPB_ConstantsClass.ACTION_TYPE_GENERAL
				AND Status = :BI_PSPB_ConstantsClass.ACTION_TYPE_UnRead
			  ORDER BY CreatedDate DESC
			  LIMIT 2
			];
			taskList.addAll(generalTasks);
		  } else {
			BI_SFCOE_LOG_Util.logMessage(applicationName,
			  BI_PSPB_TreatmentReminder.class.toString(),
			  BI_PSPB_constantsClass.cpeIdError,System.now(),
			  '',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			throw new AuraHandledException(BI_PSPB_constantsClass.cpeIdError);
		  }
		  if (taskList != null) {
			return taskList;
		  } else {
			BI_SFCOE_LOG_Util.logMessage(applicationName,
			  BI_PSPB_TreatmentReminder.class.toString(),
			  BI_PSPB_constantsClass.error,System.now(),
			  '',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			throw new AuraHandledException(BI_PSPB_constantsClass.error);
		  }
		} else {
		  BI_SFCOE_LOG_Util.logMessage(
			applicationName,
			BI_PSPB_TreatmentReminder.class.toString(),
			BI_PSPB_constantsClass.parameterError,
			System.now(),
			'',
			BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
		  );
		  throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
		}
	  } catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(
		  ex,
		  applicationName,
		  BI_PSPB_TreatmentReminder.class.toString(),
		  null,
		  System.now()
		);
		throw new AuraHandledException(
		  BI_PSPB_constantsClass.error + ex.getMessage()
		);
	  }
	}
	/**
  *@author          	Anand S
  *@description		This method is used to check the patient have the assessment or not. 
					  If there is no assessment record to the patient  this method will create a task record.
  *@param 			String enrolleeId is the Patient Id .
  
  */
	@AuraEnabled(cacheable=false)
	public static void createTaskIfNoAssessment(String enrolleeId) {
	  try {
		if (!string.isblank(enrolleeId)) {
		  // Query Assessments for the specified CareProgramEnrollee
		  //This method has CareProgramEnrollee object query were it won't support With User_Mode
		  List<Assessment> assessments = [
			SELECT Id
			FROM Assessment
			WHERE BI_PSP_CareProgramEnrollee__c = :enrolleeId
			LIMIT 1
		  ];
		  List<Task> existingTasks = [
			SELECT Id, Subject
			FROM Task
			WHERE
			  WhatId = :enrolleeId
			  AND Subject = :BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction
			LIMIT 1
		  ];
		  // If no Assessments found, create a Task
		  if (assessments.size() == 0 && existingTasks.isEmpty()) {
			Task newTask = new Task(
			  Subject = BI_PSPB_ConstantsClass.Assessment_Subject,
			  Status = BI_PSPB_ConstantsClass.ACTION_TYPE_NotificatonTypeAction, // Set status as needed
			  BI_PSP_Category__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Questionnaires, // Set category as needed
			  BI_PSP_Notification_Type__c = BI_PSPB_ConstantsClass.ACTION_TYPE_Action, // Set notification type as needed
			  WhatId = enrolleeId // Set related record as needed
			);
			// insert newTask;
  
			Database.SaveResult saveResult = Database.insert(
			  newTask,
			  false,
			  AccessLevel.USER_MODE
			);
  
			if (!saveResult.isSuccess()) {
			  for (Database.Error error : saveResult.getErrors()) {
				errorMsg +='Error '+error.getFields() +'--' +error.getMessage() + '\n';
			  }
			}
  
			if (!String.isBlank(errorMsg)) {
			  BI_SFCOE_LOG_Util.logMessage(	applicationName,
				BI_PSPB_TreatmentReminder.class.toString(),
				errorMsg,System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			  throw new AuraHandledException(BI_PSPB_constantsClass.error); // Propagate combined errors after collecting from all records
			}
		  } else {
			BI_SFCOE_LOG_Util.logMessage(
			  applicationName,
			  BI_PSPB_TreatmentReminder.class.toString(),
			  errorMsg,
			  System.now(),
			  '',
			  BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
			throw new AuraHandledException(BI_PSPB_constantsClass.error);
		  }
		} else {
		  BI_SFCOE_LOG_Util.logMessage(applicationName,
			BI_PSPB_TreatmentReminder.class.toString(),
			BI_PSPB_constantsClass.parameterError,System.now(),
			'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
		  throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
		}
	  } catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(
		  ex,
		  applicationName,
		  BI_PSPB_TreatmentReminder.class.toString(),
		  null,
		  System.now()
		);
		throw new AuraHandledException(errorMsg + ex.getMessage());
	  }
	}
	/**
	 * @author 			Anand S
	 * @description  	Updates the picklist field of a Task object based on the provided action value.
	 * @param 			recordId The ID of the Task record to be updated.
	 * @param 			actionValue The value indicating the action to be performed.
	 * @throws 			AuraHandledException Error updating.
	 */
	@AuraEnabled(cacheable=false)
	public static void updatePicklist(String recordId, String actionValue) {
	  try {
		if (!String.isBlank(recordId) && !String.isBlank(actionValue)) {
		  Task obj = [
			SELECT Id, Status
			FROM Task
			WHERE Id = :recordId
			LIMIT 1
		  ];
  
		  if (obj != null) {
			if (actionValue.equals(BI_PSPB_ConstantsClass.ACTION_RESPONSE_YES)) {
			  obj.Status = BI_PSPB_ConstantsClass.NOTIFICATION_STATUS_complete;
			} else if (
			  actionValue.equals(BI_PSPB_ConstantsClass.ACTION_RESPONSE_NO)
			) {
			  obj.Status = BI_PSPB_ConstantsClass.NOTIFICATION_STATUS_NOTCOMPLETE;
			}
			// Update the Task record
			Database.SaveResult saveResult = Database.update(obj, false);
			if (!saveResult.isSuccess()) {
			  for (Database.Error error : saveResult.getErrors()) {
				errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
			  }
			}
			if (!String.isBlank(errorMsg)) {
			  BI_SFCOE_LOG_Util.logMessage(applicationName,
				BI_PSPB_TreatmentReminder.class.toString(),
				'',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			  throw new AuraHandledException(BI_PSPB_constantsClass.error);
			}
		  } else {
			BI_SFCOE_LOG_Util.logMessage(
			  applicationName,BI_PSPB_TreatmentReminder.class.toString(),
			  BI_PSPB_constantsClass.parameterError,System.now(),'',
			  BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
		  }
		} else {
		  BI_SFCOE_LOG_Util.logMessage(applicationName,
			BI_PSPB_TreatmentReminder.class.toString(),BI_PSPB_constantsClass.parameterError,
			System.now(),'',BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
		  throw new AuraHandledException(BI_PSPB_constantsClass.parameterError);
		}
	  } catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(
		  ex,
		  applicationName,
		  BI_PSPB_TreatmentReminder.class.toString(),
		  System.now()
		);
		throw new AuraHandledException(errorMsg + ex.getMessage());
	  }
	}
  }