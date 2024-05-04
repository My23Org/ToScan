/*
@description      :Apex class to retrieve draft responses for different assessment categories such 
                  as Psoriasis, Work and Activity, and Dermatology. It handles the retrieval of 
				  draft assessment question responses based on the user's role and enrollment 
				  status in the care program.below are the LWCs where this class is used
				  biPspbIntroductionQuestionnaire, biPspbDLQIquestionnaire,biPspbPSSQuestionnaire,
				  biPspbWAPIQuestionnaire,biPspbQSQuestionnaire1,biPspbQSQuestionnaire2.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Abinsha		05-Dec-2023		Created			Initial development.
* 1.1		Abinsha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/

public with sharing class BI_PSP_RetriveDraftResponse {
    //custom label for displaying an error message if the patinece enrollement details are null.
    private static String emptyEnrollerecrd = System.Label.BI_PSP_EmptyCareProgramEnrl;
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
    // custom label that displays an error message when there is no AssessmnetQuestionResponse Record.
    private static String emptyQuestionaresponse = System.Label.BI_PSP_EmptyQuestionResponse;
    //varibale that holds the application name retrieved from Custom Settings.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //A variable That holds the name of our application to be used in catch exception handler.
    private static string applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
    // Holds the ID of the Care Program Enrollee.
    private static String idOfEnrollee;
    // Holds the Care Program Enrollee ID.
    private static String enrolleeId;
    // Holds the label for the introduction category.
    private static String introduction = System.Label.BI_PSP_introductionCategory;
    // Holds the label for the PSS category.
    private static String pss = System.Label.BI_PSP_PssCategory;
    // Holds the label for the WAPI category.
    private static String wapiCategory = System.Label.BI_PSP_WapiCategory;
    // Holds the label for the DLQI category.
    private static String dlqiCategory = System.Label.BI_PSP_DlqiCategory;
    // Holds the label for the qualitative category.
    private static String qualiCategory = System.Label.BI_PSP_QualitativeCategory;
    // Holds the label for in-progress assessment status.
    private static String inprogress = System.Label.BI_PSP_Inprogess;
    //holds the account details of the patient.
    private static List<Account> patientAccount;
    //holds the care program enrollee record details of the patient.
    private static List<CareProgramEnrollee> enrolledPatient;
    //holds the selected patient account details by the care giver.
    private static List<Account> caregiversPatientAcc;
    //holds the account details of the selected patient by care giver.
    private static List<Account> selectedPatientAcc;
    //holds the care program enrollee record of the patient.
    private static List<CareProgramEnrollee> selectedPatientId;
    //this list variable holds the assessment Question response.
    private static List<AssessmentQuestionResponse> liAssessRespon;

    /**
     * @description Retrieves draft responses for the Psoriasis category.this method is used in
     * biPspbPSSQuestionnaire  LWC component.
     * @return List of draft assessment question responses for the Psoriasis category.
     */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestionResponse> draftResponseOfPsoriasis() {
        try {
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
                    SELECT Id, Name, PersonEmail
                    FROM Account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];

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

                    if (!enrolledPatient.isEmpty()) {
                        enrolleeId = enrolledPatient[0].Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_RetriveDraftResponse.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            //to check whether it is care giver
            else if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiversPatientAcc = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];

                if (!caregiversPatientAcc.isEmpty()) {
                    selectedPatientAcc = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiversPatientAcc[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (!selectedPatientAcc.isEmpty()) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedPatientId = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatientAcc[0].Id
                        ];

                        if (!selectedPatientId.isEmpty()) {
                            enrolleeId = selectedPatientId[0].Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_RetriveDraftResponse.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            /* USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object
             using Healthcare license*/
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                liAssessRespon = [
                    SELECT
                        Id,
                        ResponseText,
                        ResponseValue,
                        BI_PSP_Questionnaire_Name__c,
                        BI_PSP_ResponseOrder__c,
                        AssessmentQuestion.Id,
                        Assessment.Id,
                        Assessment.AssessmentStatus
                    FROM AssessmentQuestionResponse
                    WHERE
                        BI_PSP_Questionnaire_Name__c = :pss
                        AND Assessment.AssessmentStatus = :inprogress
                        AND assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                    ORDER BY BI_PSP_ResponseOrder__c ASC
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    emptyEnrollerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (liAssessRespon.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_RetriveDraftResponse.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(emptyQuestionaresponse);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_RetriveDraftResponse.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return liAssessRespon;
    }

    /**
     * @description Retrieves draft responses for the Work and Activity category.we use this method in
     * biPspbWAPIQuestionnaire LWC Component.
     * @return List of draft assessment question responses for the Work and Activity category.
     */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestionResponse> draftResponseOfWorkAndActivty() {
        try {
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
                    SELECT Id, Name, PersonEmail
                    FROM Account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];

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

                    if (!enrolledPatient.isEmpty()) {
                        enrolleeId = enrolledPatient[0].Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_RetriveDraftResponse.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            //to check whether it is care giver
            else if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiversPatientAcc = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];

                if (!caregiversPatientAcc.isEmpty()) {
                    selectedPatientAcc = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiversPatientAcc[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (!selectedPatientAcc.isEmpty()) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedPatientId = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatientAcc[0].Id
                        ];

                        if (!selectedPatientId.isEmpty()) {
                            enrolleeId = selectedPatientId[0].Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_RetriveDraftResponse.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            /* USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object
             using Healthcare license*/
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                liAssessRespon = [
                    SELECT
                        Id,
                        ResponseText,
                        ResponseValue,
                        BI_PSP_Questionnaire_Name__c,
                        BI_PSP_ResponseOrder__c,
                        AssessmentQuestion.Id,
                        Assessment.Id,
                        Assessment.AssessmentStatus
                    FROM AssessmentQuestionResponse
                    WHERE
                        BI_PSP_Questionnaire_Name__c = :wapiCategory
                        AND Assessment.AssessmentStatus = :inprogress
                        AND assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                    ORDER BY BI_PSP_ResponseOrder__c ASC
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    emptyEnrollerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (liAssessRespon.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_RetriveDraftResponse.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );

                /*we are not throwing any error message here beacuse of irrespective of the status of the assessment
                 its showing messages.*/
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_RetriveDraftResponse.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return liAssessRespon;
    }

    /**
     * @description Retrieves draft responses for the Dermatology category.we use this method in
     * biPspbDLQIquestionnaire LWC Component.
     * @return List of draft assessment question responses for the Dermatology category.
     */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestionResponse> draftResponseOfDermatology() {
        try {
            //care give access code
            String currentUserName = UserInfo.getName();

            // Query for the user's Id based on the name
            //We are getting custom field from User Object. Hence we have to use SOQL
            User currentUser = [
                SELECT Id, Name, BI_PSPB_Caregiver__c
                FROM User
                WHERE name = :currentUserName
                WITH USER_MODE
                LIMIT 1
            ]; //'0057Z00000D849fQAB' caregiverid for testing
            String currentUserEmail = UserInfo.getUserEmail();

            if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiversPatientAcc = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];
                if (!caregiversPatientAcc.isEmpty()) {
                    selectedPatientAcc = [
                        SELECT id, Name, PersonEmail
                        FROM account
                        WHERE
                            id = :caregiversPatientAcc[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_RetriveDraftResponse.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                 using Healthcare license*/
                if (!selectedPatientAcc.isEmpty()) {
                    selectedPatientId = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :selectedPatientAcc[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_RetriveDraftResponse.class.toString(),
                        '',
                        System.now(),
                        caregiversSelectedpatienterrmsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!selectedPatientId.isEmpty()) {
                    enrolleeId = selectedPatientId[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_RetriveDraftResponse.class.toString(),
                        '',
                        System.now(),
                        selctdPatieintsenrolleeerrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else {
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
                     using Healthcare license.*/
                    enrolledPatient = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_RetriveDraftResponse.class.toString(),
                        '',
                        System.now(),
                        selctdPatieintsenrolleeerrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolledPatient.isEmpty()) {
                    enrolleeId = enrolledPatient[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_RetriveDraftResponse.class.toString(),
                        '',
                        System.now(),
                        selctdPatieintsenrolleeerrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            /* USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object
             using Healthcare license.*/
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                liAssessRespon = [
                    SELECT
                        Id,
                        ResponseText,
                        ResponseValue,
                        BI_PSP_ResponseOrder__c,
                        BI_PSP_Questionnaire_Name__c,
                        AssessmentQuestion.Id,
                        Assessment.Id,
                        Assessment.AssessmentStatus
                    FROM AssessmentQuestionResponse
                    WHERE
                        BI_PSP_Questionnaire_Name__c = :dlqiCategory
                        AND Assessment.AssessmentStatus = :inprogress
                        AND assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                    ORDER BY BI_PSP_ResponseOrder__c ASC
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    emptyEnrollerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (liAssessRespon.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_RetriveDraftResponse.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );

                //we are not throwing any error message here beacuse of irrespective of the status its showing messages.
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_RetriveDraftResponse.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return liAssessRespon;
    }
}