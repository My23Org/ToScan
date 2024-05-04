/*
@description       This BI_PSP_QualitativeSatisfactions  class displays the  QSQ Questonnaire in
                   oustanding Questionnaires page based on the enrollment date of the current user.
				   we use this class in biPspbQualitativeCard.
* History:
* Version	Author		Date			Detail			Description
* 1.0		harish		05-Dec-2023		Created			Initial development.
* 1.1		harish   	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/
public with sharing class BI_PSP_QualitativeSatisfactions {
    //custom label for displaying an error message if the patinece enrollement details are null.
    private static String emptyEnrollerecrd = System.Label.BI_PSP_EmptyCareProgramEnrl;
    //used to store the care program enrollee id of the patient.
    private static string enrolleeId;
    //used to store the two months date.and it gets result from the custom label.the custom label holds two monhs value
    private static Integer twoMonthsInt = Integer.valueOf(
        System.Label.BI_PSP_twoMonthsQualitative
    );
    //used to store the fourteen weeks date.and it gets result from the custom label.the custom label holds the value for Fourteen weeks.
    private static Integer fourteenWeeksInt = Integer.valueOf(
        System.Label.BI_PSP_fourteenWeeksQualitative
    );
    //varibale that holds the application name retrieved from Custom Settings.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //A variable That holds the name of our application to be used in catch exception handler.
    private static string applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
    //this vriable holds the account record of the patient.
    private static List<Account> patientAccount;
    //this vriable holds the CareProgramEnrollee record of the patient.
    private static List<CareProgramEnrollee> enrolledPatient;
    //this vriable holds the record information of selected patient.
    private static list<Account> caregiverAccount;
    //this vriable holds the record information of selected patient Account.
    private static List<Account> selectedPatientAcc;
    //this vriable holds the record information of enrolled selected patients Account.
    private static List<CareProgramEnrollee> enrolledSelectdPatient;
    //Custom label for care givers patient.
    private static String caregiversPatientaccountErr = System.Label.BI_PSP_CaregiversPatient;
    //custom label that displays an error message when there is no account records for the selected patient.
    private static String caregiversSelectedpatienterrmsg = System.Label.BI_PSP_SelectedPatientAccount;
    // custom label that displays an error message when there is no careProgramEnrollee records for the selected patient.
    private static String selctdPatieintsenrolleeerrormsg = System.Label.BI_PSP_SelectedPatientEnrollee;
    // custom label that displays an error message when there is no Account records for the patient.
    private static String patientAccounterrormsg = System.Label.BI_PSP_PatientAccountErrormsg;
    // custom label that displays an error message when there is no care program enrollee records for the patient.
    private static String patientEnrolleeerrormsg = System.Label.BI_PSP_PatientEnrolleeErrormsg;
    /*custom label that displays an error message when there is no enrolled Date Registered in database for the
     / current patient.*/
    private static String errorForDates = System.Label.BI_PSP_QualitativeDateError;
    //holds care program enrollee record details.
    private static List<CareProgramEnrollee> listOfEnrollee;

    /*@Description this method essentially calculates the target dates based on the CreatedDate of
     *CareProgramEnrollee records and checks if those target dates have passed or not.
     *we use this method in biPspbQualitativeCard.*/

    /*@return this method essentially calculates the target dates based on the CreatedDate of
     *CareProgramEnrollee records and checks if those target dates have passed or not. Then,
     *it returns a map containing information about whether the target dates have passed and
     *the actual target dates themselves.*/

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getPatientAfterThreemonthsAndFourteenWeeks() {
        Map<String, Object> result = new Map<String, Object>();
        try {
            //care give access code
            String currentUserName = UserInfo.getName();
            String currentUserEmail = UserInfo.getUserEmail();

            //We are getting custom field from User Object. Hence we have to use SOQL
            User currentUser = [
                SELECT Id, Name, BI_PSPB_Caregiver__c
                FROM User
                WHERE name = :currentUserName
                WITH USER_MODE
                LIMIT 1
            ];

            if (currentUser.BI_PSPB_Caregiver__c == false) {
                patientAccount = [
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
                if (!patientAccount.isEmpty()) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].Id
                    ];

                    if (!enrolledPatient.isEmpty()) {
                        enrolleeId = enrolledPatient[0].Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QualitativeSatisfactions.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiverAccount = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];

                if (!caregiverAccount.isEmpty()) {
                    selectedPatientAcc = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (!selectedPatientAcc.isEmpty()) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        enrolledSelectdPatient = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatientAcc[0].Id
                        ];

                        if (!enrolledSelectdPatient.isEmpty()) {
                            enrolleeId = enrolledSelectdPatient[0].Id;
                        }
                    } else {
                        BI_SFCOE_LOG_Util.logMessage(
                            applicationName,
                            BI_PSP_QualitativeSatisfactions.class.toString(),
                            '',System.now(),caregiversPatientaccountErr,
                            BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                        );
                    }
                } else {
                    throw new AuraHandledException(errorForDates);
                }
            }
            // Query CareProgramEnrollee records
            /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
             using Healthcare license*/
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                listOfEnrollee = [
                    SELECT Id, Name, ownerid, CreatedDate
                    FROM CareProgramEnrollee
                    WHERE id = :enrolleeId
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QualitativeSatisfactions.class.toString(),
                    '',
                    System.now(),
                    emptyEnrollerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            result.put('afterTwomonths', '');
            result.put('after14wks', '');
            result.put('target2monthsdate', null);
            result.put('target14wksdate', null);

            // Iterate through the list of CareProgramEnrollee records
            if (!listOfEnrollee.isEmpty()) {
                for (CareProgramEnrollee enrollee : listOfEnrollee) {
                    // Calculate the target date for three months

                    DateTime targetDate2months = enrollee.CreatedDate.addDays(
                        twoMonthsInt
                    );

                    // Calculate the target date for fourteen weeks
                    DateTime targetDate14wks = enrollee.CreatedDate.addDays(
                        fourteenWeeksInt
                    );

                    // Check if the target date for three months has passed
                    if (targetDate2months <= DateTime.now()) {
                        //DateTime.now()
                        result.put('afterTwomonths', 'twoMonths');
                        result.put('target2monthsdate', targetDate2months);
                    }

                    // Check if the target date for fourteen weeks has passedDateTime.now()DateTime.now()
                    if (targetDate14wks <= DateTime.now()) {
                        result.put('after14wks', 'fourteenWeeks');
                        result.put('target14wksdate', targetDate14wks);
                    }
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,BI_PSP_QualitativeSatisfactions.class.toString(),
                    '',System.now(),emptyEnrollerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            if (result.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,BI_PSP_QualitativeSatisfactions.class.toString(),
                    '',System.now(),errorForDates,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(errorForDates);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_QualitativeSatisfactions.class.toString(),
                null,
                System.now()
            );

            throw new AuraHandledException(errorForDates);
        }
        return result;
    }
}