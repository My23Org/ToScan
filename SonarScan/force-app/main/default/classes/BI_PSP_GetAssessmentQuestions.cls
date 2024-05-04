/*
@description       : This Apex class retrieves assessment questions based on different categories 
                   and handles draft responses for introduction questionnaires. It also provides
				   methods to determine the patient status for enrolled care program participants.
				   This Apex class is used in biPspbIntroductionQuestionnaire,biPspbDLQIquestionnaire,
				   biPspbPSSQuestionnaire,biPspbWAPIQuestionnaire,biPspbQSQuestionnaire1,
				   biPspbQSQuestionnaire2,biPspbIntroductionPageone,biPspbIntroductionPagetwo.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Abinsha		05-Dec-2023		Created			Initial development.
* 1.1		Abinsha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/

public with sharing class BI_PSP_GetAssessmentQuestions {
    //this list varibale holds the CareProgramEnrollee  record details
    private static List<CareProgramEnrollee> cpelist;
    //This variable holds a label that shows error when there is no care program enrollee record.
    private static String emptyEnrolleerecrd = System.Label.BI_PSP_EmptyCareProgramEnrl;
    // custom label that displays an error message when there is no AssessmnetQuestionResponse Record.
    private static String emptyQuestionaresponse = System.Label.BI_PSP_EmptyQuestionResponse;
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
    //custom label for Assesssment Questions query when the result  is empty.
    private static String questionsNotavilable = System.Label.BI_PSP_QuestionsUnavailable;
    // Holds the Care Program Enrollee Id
    private static String enrolleeId;
    // Holds the expiration date for PSS assessment
    private static Date expireDatePss;
    // Holds the expiration date for WAI assessment
    private static Date expireDateWai;
    // Holds the expiration date for DLQI assessment
    private static Date expireDateDlqi;
    // Label for introduction category
    private static String introduction = System.Label.BI_PSP_introductionCategory;
    // Label for PSS category
    private static String pss = System.Label.BI_PSP_PssCategory;
    // Label for WAPI category
    private static String wapiCategory = System.Label.BI_PSP_WapiCategory;
    // Label for DLQI category
    private static String dlqiCategory = System.Label.BI_PSP_DlqiCategory;
    // Label for qualitative category
    private static String qualiCategory = System.Label.BI_PSP_QualitativeCategory;
    // Label for assessment status 'In Progress'
    private static String inprogress = System.Label.BI_PSP_Inprogess;
    // for Acute
    private static String acute = System.Label.BI_PSPB_Acute;
    // for unassigned
    private static String unassigned = System.Label.BI_PSP_Unassigned;
    //varibale that holds the application name retrieved from Custom Settings.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //A variable That holds the name of our application to be used in catch exception handler.
    private static string applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
    //variable that holds the Assessment Questions of deifferent Categories.
    private static List<AssessmentQuestion> assessmentQuestions;
    //variable that holds the care giver account details
    private static list<Account> caregiverAccount;
    //variable that holds the care givers selected patient account details.
    private static List<Account> caregiversPatient;
    /*variable that holds the information of care program enrollee record related to the selected patient.
     Account details*/
    private static List<CareProgramEnrollee> selectedPatientEnrollee;
    //variable that holds the account information of the patient.
    private static List<Account> patientAccount;
    //holds the enrolled patient record details.
    private static List<CareProgramEnrollee> enrolledPatient;
    //holds a list of AssessmentQuestionResponse  records.
    private static List<AssessmentQuestionResponse> liAssessRespon;
    /**
   * @description  : Retrieves assessment questions related to WAPI category and we are using this method
                    in an LWC component called biPspbWAPIQuestionnaire.
   * @return       : List of AssessmentQuestion records
   */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getTheAssesmentQuestion() {
        try {
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            assessmentQuestions = [
                SELECT
                    Id,
                    QuestionText,
                    BI_PSP_OrderNumber__c,
                    DeveloperName,
                    ActiveVersion.Id
                FROM AssessmentQuestion
                WHERE QuestionCategory = :wapiCategory
                ORDER BY BI_PSP_OrderNumber__c ASC
            ];
            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_GetAssessmentQuestions.class.toString(),
                    '',
                    System.now(),
                    questionsNotavilable,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(questionsNotavilable);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_GetAssessmentQuestions.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }

    /**
   * @description       : Retrieves Questions for the Questionnaire Lets Personalisation.
                        LWC components That are using this method are biPspbIntroductionQuestionnaire,
						biPspbIntroductionPageone,biPspbIntroductionPagetwo.
   * @return            : List of AssessmentQuestion records
   */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getIntroductionAsQuesLastTen() {
        try {
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            assessmentQuestions = [
                SELECT Id, QuestionText, DeveloperName, ActiveVersion.Id
                FROM AssessmentQuestion
                WHERE QuestionCategory = :introduction
                ORDER BY BI_PSP_OrderNumber__c ASC
            ];
            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_GetAssessmentQuestions.class.toString(),
                    '',
                    System.now(),
                    questionsNotavilable,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(questionsNotavilable);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_GetAssessmentQuestions.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }

    /**
   * @description    :Retrieves draft responses for introduction questionnaire.
                      LWC components That are using this method are biPspbIntroductionQuestionnaire,
					  biPspbIntroductionPageone,biPspbIntroductionPagetwo.
   * @return         :List of AssessmentQuestionResponse records
   */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestionResponse> draftResponseOfIntroduction() {
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
            ];

            String currentUserEmail = UserInfo.getUserEmail();
            if (currentUser.BI_PSPB_Caregiver__c == true) {
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
                    caregiversPatient = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (!caregiversPatient.isEmpty()) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedPatientEnrollee = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :caregiversPatient[0].Id
                        ];

                        if (!selectedPatientEnrollee.isEmpty()) {
                            enrolleeId = selectedPatientEnrollee[0].Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_GetAssessmentQuestions.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
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
                    /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
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
                        BI_PSP_GetAssessmentQuestions.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            //care give access code
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
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
                        Assessment.ownerid,
                        Assessment.Id,
                        Assessment.AssessmentStatus
                    FROM AssessmentQuestionResponse
                    WHERE
                        BI_PSP_Questionnaire_Name__c = :introduction
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
                    emptyEnrolleerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (liAssessRespon.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_GetAssessmentQuestions.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_GetAssessmentQuestions.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return liAssessRespon;
    }

    /**
   * @description Retrieves Questions for the Questionnaire PSS.and we use this method in an LWC 
    called biPspbPSSQuestionnaire.
   * @return List of draft assessment question  for the Psoriasis category.
   */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getPsoriasisAssesmentQues() {
        try {
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            assessmentQuestions = [
                SELECT
                    Id,
                    QuestionText,
                    BI_PSP_OrderNumber__c,
                    DeveloperName,
                    ActiveVersion.Id
                FROM AssessmentQuestion
                WHERE QuestionCategory = :pss
                ORDER BY BI_PSP_OrderNumber__c ASC
            ];
            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_GetAssessmentQuestions.class.toString(),
                    '',
                    System.now(),
                    questionsNotavilable,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(questionsNotavilable);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_GetAssessmentQuestions.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }

    /**
   * @description Retrieves Questions for the Questionnaire DLQI and the name of the LWC
     is biPspbDLQIquestionnaire.
   * @return List of draft assessment question  for the Dermatology category
   */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getDermatologyAssesmentQues() {
        try {
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            assessmentQuestions = [
                SELECT
                    Id,
                    QuestionText,
                    DeveloperName,
                    ActiveVersion.Id,
                    BI_PSP_OrderNumber__c
                FROM AssessmentQuestion
                WHERE QuestionCategory = :dlqiCategory
                ORDER BY BI_PSP_OrderNumber__c ASC
            ];
            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_GetAssessmentQuestions.class.toString(),
                    '',
                    System.now(),
                    questionsNotavilable,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(questionsNotavilable);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_GetAssessmentQuestions.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }
    /**
   * @description Retrieves Questions for the Questionnaire QSQ and the name of the LWC
     components that are using this method are biPspbQSQuestionnaire1,biPspbQSQuestionnaire2.
   * @return List of draft assessment question  for the Qualitative category
   */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getQualitativeAssesmentQues() {
        try {
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            assessmentQuestions = [
                SELECT
                    Id,
                    QuestionText,
                    BI_PSP_OrderNumber__c,
                    DeveloperName,
                    ActiveVersion.Id
                FROM AssessmentQuestion
                WHERE QuestionCategory = :qualiCategory
                ORDER BY BI_PSP_OrderNumber__c ASC
            ];
            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_GetAssessmentQuestions.class.toString(),
                    '',
                    System.now(),
                    questionsNotavilable,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(questionsNotavilable);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_GetAssessmentQuestions.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }

    /**
   * @description Retrieves the patient status for enrolled care program participants and we use 
     this method in LWCs such as biPspbIntroductionPageone,biPspbIntroductionPagetwo.
   * @return a string that returns Patient status (Unassigned, Acute, or null if not found)
   */
    @AuraEnabled(cacheable=true)
    public static String patientstatusreturn() {
        try {
            String isunassigned = '';
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
            ];

            String currentUserEmail = UserInfo.getUserEmail();

            if (currentUser.BI_PSPB_Caregiver__c == true) {
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
                    caregiversPatient = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (!caregiversPatient.isEmpty()) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedPatientEnrollee = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :caregiversPatient[0].Id
                        ];

                        if (!selectedPatientEnrollee.isEmpty()) {
                            enrolleeId = selectedPatientEnrollee[0].Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_GetAssessmentQuestions.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
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

                /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                 using Healthcare license*/
                if (!patientAccount.isEmpty()) {
                    enrolledPatient = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_GetAssessmentQuestions.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolledPatient.isEmpty()) {
                    enrolleeId = enrolledPatient[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_GetAssessmentQuestions.class.toString(),
                        '',
                        System.now(),
                        patientEnrolleeerrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
             using Healthcare license*/
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                cpelist = [
                    SELECT Id, BI_PSPB_PatientStatus__c
                    FROM CareProgramEnrollee
                    WHERE Id = :enrolleeId
                    LIMIT 1
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    emptyEnrolleerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            if (!cpelist.isEmpty()) {
                if (cpelist[0].BI_PSPB_PatientStatus__c == unassigned) {
                    isunassigned = unassigned;
                } else if (cpelist[0].BI_PSPB_PatientStatus__c == acute) {
                    isunassigned = acute;
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_GetAssessmentQuestions.class.toString(),
                    '',
                    System.now(),
                    patientEnrolleeerrormsg,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (isunassigned != null && !String.isBlank(isunassigned)) {
                return isunassigned;
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_GetAssessmentQuestions.class.toString(),
                    '',
                    System.now(),
                    emptyEnrolleerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(emptyEnrolleerecrd);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_GetAssessmentQuestions.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyEnrolleerecrd);
        }
    }
}