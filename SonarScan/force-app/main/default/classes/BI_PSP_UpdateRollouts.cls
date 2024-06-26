/* 
* @Description    : Schedulable Apex class for updating assessment records based on expiration dates and 
                   scheduling questionnaires.
* History:
* Version	Author		Date			Detail			Description.
* 1.0		Abinsha		05-Dec-2023		Created			Initial development.
* 1.1		Abinsha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/
public with sharing class BI_PSP_UpdateRollouts implements Schedulable {
    
    // custom label that displays an error message when there is no Assessmnet Record.
    private static String emptyAssesment = System.Label.BI_PSP_EmptyAssessment;

    /*this variable holds the value of a custom label that displays an error message when there is no completed assessment
     date present in the database.*/
    private static String emptyAssessmentdate = System.Label.BI_PSP_EmptycCompletedDate;

    //This Variable Stores a Custom setting value ApplicationName.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //this variable holds the apllication name to ne used in Catch and Throws.
    private static string applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
    //holds the Error message.
    private static String errorMsg='';
    //holds the label for expired text.
    private static String expiredLabel = System.Label.BI_PSP_Expired;
    // Holds the category label for qualitative assessment.
    private static String qualiCategory = System.Label.BI_PSP_QualitativeCategory;
    //Stores record information where the satatus of the assessment is expired.
    private static List<Assessment> matchingAssessments;
    /*@Description The execute method updates expired assessment records and adjusts expiration dates
  for qualifying assessments.
  *@param sc The context object that provides information about the scheduled job instance.
  */
    public void execute(SchedulableContext sc) {
        try {
            // Query for Assessment records that have passed their expiration date
                List<Assessment> assessmentsToUpdate = [
                SELECT Id, Name, ExpirationDateTime
                FROM Assessment
                WHERE ExpirationDateTime <= :DateTime.now()
                 WITH USER_MODE
            ];
			
            // Update Assessment records to mark them as expired
            if (!assessmentsToUpdate.isEmpty()) {
                for (Assessment assess : assessmentsToUpdate) {
                    assess.AssessmentStatus = expiredLabel;
                }
            }
            // Update the records using Database class method
            List<Database.SaveResult> updateResults = Database.update(
                assessmentsToUpdate,
                false
            );

            // Print the results of the update operation
            for (Database.SaveResult sr : updateResults) {
                if (!sr.isSuccess()) {
                    for (Database.Error error : sr.getErrors()) {
                      errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                    }
                    if (!String.isBlank(errorMsg)) {
                        BI_SFCOE_LOG_Util.handleDatabaseSaveResults(updateResults,
                            BI_PSP_UpdateRollouts.class.toString(),System.now()
                        );
                    }
                }
            }

         } catch (Exception ex) {
            // Handle any exceptions occurred during execution.

            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_UpdateRollouts.class.toString(),
                null,
                System.now()
            );
        }
    }
}