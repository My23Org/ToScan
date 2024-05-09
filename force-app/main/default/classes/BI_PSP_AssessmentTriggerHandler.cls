/*
@description       :Apex class to handle triggers for Assessment object.
                    It provides functionality to format the EffectiveDateTime field 
                    and populate the custom field BI_PSP_DateForCQ__c with the formatted date.
* History:
* Version	Author		Date			Detail			Description
* 1.0		harish		05-Dec-2023		Created			Initial development.
* 1.1		harish 	    01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/

public with sharing class BI_PSP_AssessmentTriggerHandler {
    // custom label that displays an error message when there is no Assessmnet Record.
    private static String emptyAssesment = System.Label.BI_PSP_EmptyAssessment;

    //This Variable Stores a Custom setting value ApplicationName.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //this variable holds the apllication name to be used in Catch and Throws.
    private static string applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
    /*this variable holds the value of a custom label that displays an error message when there is no completed assessment
     date present in the database.*/
    private static String emptyAssessmentdate = System.Label.BI_PSP_EmptycCompletedDate;

    /**
     * @description Handles before insert trigger events for Assessment object.
     *              Formats the EffectiveDateTime field and populates the custom field BI_PSP_DateForCQ__c with the formatted date.
     * @param newRecords List of new Assessment records.
     */
    public static void handleBeforeInsert(List<Assessment> newRecords) {
        try {
            if (!newRecords.isEmpty()) {
                formatEffectiveDateTime(newRecords);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(ex,applicationName,
            BI_PSP_AssessmentTriggerHandler.class.toString(),null,System.now()
            );
        }
    }

    /**
     * @description Handles before update trigger events for Assessment object.
     *              Formats the EffectiveDateTime field and populates the custom field BI_PSP_DateForCQ__c with the formatted date.
     * @param updatedRecords List of updated Assessment records.
     */
    public static void handleBeforeUpdate(List<Assessment> updatedRecords) {
        try {
            if (!updatedRecords.isEmpty()) {
                formatEffectiveDateTime(updatedRecords);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(ex,applicationName,
            BI_PSP_AssessmentTriggerHandler.class.toString(),null,System.now()
            );
        }
    }

    /**
     * @description Formats the EffectiveDateTime field of Assessment records and populates the custom field BI_PSP_DateForCQ__c with the formatted date.
     * @param records List of Assessment records.
     */
    private static void formatEffectiveDateTime(List<Assessment> records) {
        try {
            for (Assessment record : records) {
                if (record.EffectiveDateTime != null) {
                    // Extract month and year values from EffectiveDateTime

                    Integer yearValue = record.EffectiveDateTime.year();
                    // Format month name
                    String monthName = record.EffectiveDateTime.format('MMMM');
                    String formattedDate = monthName + ' ' + yearValue;

                    record.BI_PSP_DateForCQ__c = formattedDate;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_AssessmentTriggerHandler.class.toString(),
                        '',
                        System.now(),
                        emptyAssessmentdate,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                    NullPointerException e = new NullPointerException();
                    throw e;
                }
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_AssessmentTriggerHandler.class.toString(),
                null,
                System.now()
            );
        }
    }
}