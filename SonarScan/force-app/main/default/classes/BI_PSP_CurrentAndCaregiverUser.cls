/*
@description       This Apex class is responsible for retrieving assessments based on the 
				   current user's role (caregiver or patient).It determines the user's role based
				   on their profile and retrieves the latest assessment for the specified category.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Harish		05-Dec-2023		Created			Initial development.
* 1.1		Harish 	    01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/
public with sharing class BI_PSP_CurrentAndCaregiverUser {
    //custom label for displaying an error message if the patinece enrollement details are null.
    private static String emptyEnrollerecrd = System.Label.BI_PSP_EmptyCareProgramEnrl;
    // Holds the Care Program Enrollee ID.
    private static string enrolleeId;
    //holds the Account details of the patient.
    private static List<Account> patientAccount;
    //holds the Account details of the Enrolled patient.
    private static List<CareProgramEnrollee> enrolledPatient;
    //holds Account details of the care givers selected patient.
    private static List<Account> caregiverAccount;
    //holds Account details of the care givers selected patient .
    private static List<Account> selectedPatientAcnt;
    //holds care program enrollment details of the care givers selected patient.
    private static List<CareProgramEnrollee> selectedEnrollee;
    //varibale that holds the application name retrieved from Custom Settings.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //A variable That holds the name of our application to be used in catch exception handler.
    private static string applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
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
    // custom label that displays an error message when there is no Assessmnet Record.
    private static String emptyAssesment = System.Label.BI_PSP_EmptyAssessment;

    /**
     * @description Retrieves the latest assessment for the specified category based on the current
     * user's role (caregiver or patient).we are using this apex class in LWCs such as cards,Questionnaire
				  biPspbQualitativeCompletedQuestionnaire2,  biPspbQualitativeCompletedQuestionnaire,
				  biPspbWapiCompletedQuestionnaire,biPspbPSSCompletedQuestionnaires, 
				  biPspbDlqiCompletedQuestionnaire.
     * @param categoryname The name of the assessment category.
     * @return List of assessments matching the specified category for the current user
     */
    @AuraEnabled(cacheable=true)
    public static List<Assessment> getAssessmentsByCurrentUserName(
        string categoryname
    ) {
        List<Assessment> assessments = new List<Assessment>(); // Initialize outside the try block
        try {
            String currentUserName = UserInfo.getName();
            String currentUserEmail = UserInfo.getUserEmail();
            //We are getting custom field from User Object. Hence we have to use SOQL
            User currentUser = [
                SELECT Id, Name, BI_PSPB_Caregiver__c
                FROM User
                WHERE name = :currentUserName
                And email=:currentUserEmail
                WITH USER_MODE
                LIMIT 1
            ];

            if (currentUser.BI_PSPB_Caregiver__c == false) {
                patientAccount = [
                    SELECT Id, Name, PersonEmail
                    FROM Account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
				/*A user will only have one Account therefore using list for a single record 
                 can be negotiable and there may be a use for this in the future.*/
                if (!patientAccount.isEmpty()) {
                    // Retrieve the user's account information
                    Account firstAccount = patientAccount[0];
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :firstAccount.Id
                    ];
				/*A user will only have one CareProgramEnrollee therefore using list for a single record 
                can be negotiable and there may be a use for this in the future.*/
                    if (!enrolledPatient.isEmpty()) {
                        enrolleeId = enrolledPatient[0].Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CurrentAndCaregiverUser.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            //to check whether it is care giver
            else if (currentUser.BI_PSPB_Caregiver__c == true) {
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
				/*A user will only have one Account therefore using list for a single record 
                can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccount.isEmpty()) {
                    selectedPatientAcnt = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];
					/*A user will only have one Account therefore using list for a single record 
                    can be negotiable and there may be a use for this in the future.*/
                    if (!selectedPatientAcnt.isEmpty()) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedEnrollee = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatientAcnt[0].Id
                        ];
			/*A user will only have one CareProgramEnrollee therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                        if (!selectedEnrollee.isEmpty()) {
                            enrolleeId = selectedEnrollee[0].Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CurrentAndCaregiverUser.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            //Retrieve the Assessments related to the category
            /* USER_MODE is not used because AssesmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                assessments = [
                    SELECT
                        Id,
                        Name,
                        AssessmentStatus,
                        EffectiveDateTime,
                        ExpirationDateTime,
                        BI_PSP_StatusForPersonalization__c
                    FROM Assessment
                    WHERE
                        BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND Name = :categoryname
                    ORDER BY EffectiveDateTime DESC
                    LIMIT 1
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CurrentAndCaregiverUser.class.toString(),
                    '',
                    System.now(),
                    emptyEnrollerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(emptyEnrollerecrd);
            }
            if (assessments.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CurrentAndCaregiverUser.class.toString(),
                    '',
                    System.now(),
                    emptyAssesment,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_CurrentAndCaregiverUser.class.toString(),
                null,
                System.now()
            );

            throw new AuraHandledException(emptyAssesment);
        }
        return assessments;
    }
}