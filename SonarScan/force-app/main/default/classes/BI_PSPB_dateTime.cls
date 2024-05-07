/**
 * @description This class implements the Schedulable interface to perform scheduled actions related to date and time.This class is used for the
 * CRM Analytics in the CRM Analytics it should get date everyday that is the use of this class it will generate the date every day and insert the date in this
 * BI_PSPB_DateTimeMention__c object as a record .
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		01-Apr-2024		Created		This was an intial development.
 * 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */
public with sharing class BI_PSPB_dateTime implements Schedulable {
	private static String errorMsg = '';
	//varibale that holds the application name retrieved from Custom Settings.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	//A variable That holds the name of our application to be used in catch exception handler.
	private static String applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';
	/**
	 * @description  Executes the scheduled job to insert a record containing the current date into the BI_PSPB_DateTimeMention__c object.
	 * @param ctx The context in which the job is executed.
	 */

	public void execute(SchedulableContext ctx) {
		try {
			Datetime currentDateTime = System.now();
			Date currentDate = currentDateTime.date();
			List<BI_PSPB_DateTimeMention__c> dateObjsToInsert = new List<BI_PSPB_DateTimeMention__c>();
			BI_PSPB_DateTimeMention__c newObj = new BI_PSPB_DateTimeMention__c();
			newObj.Name = string.valueof(currentDate);
			newObj.BI_PSPB_Date__c = currentDate;
			dateObjsToInsert.add(newObj);
			//System.now value is stored in dateObjsToInsert list and so it can never be empty. So nullcheck is not done
			Database.SaveResult[] saveResults = Database.insert(
				dateObjsToInsert,
				false,
				AccessLevel.USER_MODE
			);
			for (Database.SaveResult saveResult : saveResults) {
				if (!saveResult.isSuccess()) {
					for (Database.Error error : saveResult.getErrors()) {
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
					BI_PSPB_dateTime.class.toString(),
					System.now()
				);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_dateTime.class.toString(),
				null,
				System.now()
			);
		}
	}
}