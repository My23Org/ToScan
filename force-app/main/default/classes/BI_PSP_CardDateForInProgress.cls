/*
@description       This class provides methods to retrieve dates for Assessment cards in progress for 
                   different categories like PSS, WAPI, and DLQI.It interacts with Assessment and custom objects 
                   to fetch relevant dates based on the current user's role and context.
* History:
* Version	Author		Date			Detail			Description.
* 1.0		Abinsha		05-Dec-2023		Created			Initial development.
* 1.1		Abinsha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/
public with sharing class BI_PSP_CardDateForInProgress {
    //this list vraibles holds theh initial dated for all the questionniares except introduction and Qsq.
    private static List<BI_PSP_Questionnaire_Setups__c> customObjectRecords;
    // custom label that displays an error message when there is no AssessmnetQuestionResponse Record.
    private static String emptyQuestionaresponse = System.Label.BI_PSP_EmptyQuestionResponse;
    //custom label for displaying an error message if the patinece enrollement details are null.
    private static String emptyEnrollerecrd = System.Label.BI_PSP_EmptyCareProgramEnrl;
    //Custom label for care givers patient.
    private static String emptyInitialrollout = System.Label.BI_PSP_EmptyIntialRollout;
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
    //varibale that holds the application name retrieved from Custom Settings.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //A variable That holds the name of our application to be used in catch exception handler.
    private static string applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
    // Stores the CareProgramEnrollee Id for the current user
    private static String enrolleeId;
    // Label for PSS category
    private static String pss = System.Label.BI_PSP_PssCategory;
    // Label for WAPI category
    private static String wapiCategory = System.Label.BI_PSP_WapiCategory;
    // Label for DLQI category.
    private static String dlqiCategory = System.Label.BI_PSP_DlqiCategory;
    // Label for 'In Progress' status.
    private static String inprogress = System.Label.BI_PSP_Inprogess;
    // Label for 'Expired' status.
    private static String expired = System.Label.BI_PSP_Expired;
    // Label for 'Completed' status.
    private static String completed = System.Label.BI_PSP_Completed;
    //holds the account record details of the patient whos logged in.
    private static List<Account> patientAccount;
    //holds the care program enrollee record details of the patinet.
    private static List<CareProgramEnrollee> enrolledPatient;
    //this list holds the Account details of a care giver who logged in on behalf of the patient.
    private static list<Account> caregiverAccount;
    //this list holds the account details of the selected patient.
    private static List<Account> selectedPatient;
    //holds the acre program enrolee record of the selected patient.
    private static List<CareProgramEnrollee> caregvrEnroledPatinet;

    /*@Description  Aura enabled method to get the date in progress for DLQI category.
     We uset this method in biPspbDlqiCard  LWC component.*/
    // Aura enabled method to get the date in progress for DLQI category
    @AuraEnabled(cacheable=true)
    public static Datetime getTheDateInProgessForCard() {
        try {
            String currentUserName = UserInfo.getName();
            String currentUserEmail = UserInfo.getUserEmail();

            //We are getting custom field from User Object. Hence we have to use SOQL.
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
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!patientAccount.isEmpty()) {
                    /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                     object using Healthcare license.*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].Id
                    ];
		    /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                    if (!enrolledPatient.isEmpty()) {
                        enrolleeId = enrolledPatient[0].Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,BI_PSP_CardDateForInProgress.class.toString(),
                        '',System.now(),patientAccounterrormsg,
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
		    /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccount.isEmpty()) {
                    selectedPatient = [
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
                    if (!selectedPatient.isEmpty()) {
                        /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                         object using Healthcare license.*/
                        caregvrEnroledPatinet = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatient[0].Id
                        ];
		     /*A user will only have one CareProgramEnrollee therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                        if (!caregvrEnroledPatinet.isEmpty()) {
                            enrolleeId = caregvrEnroledPatinet[0].Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CardDateForInProgress.class.toString(),
                        '',System.now(),caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            Assessment previousAssessment = null;

            try {
                // If there are records in listOfAss, query the previous assessment record with status Completed
                /* USER_MODE is not used because Assessment is an Salesforce Industry object
                 using Healthcare license*/

                previousAssessment = [
                    SELECT
                        Id,
                        Name,
                        AssessmentStatus,
                        ExpirationDateTime,
                        OwnerId
                    FROM Assessment
                    WHERE
                        BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND AssessmentStatus = :expired
                        AND Name = :dlqiCategory
                    ORDER BY CreatedDate DESC
                    LIMIT 1
                ];
            } catch (QueryException ex) {
                // Handle the exception (list has no rows)
                BI_SFCOE_LOG_Util.handleException(
                    ex,
                    applicationName,
                    BI_PSP_CardDateForInProgress.class.toString(),
                    null,
                    System.now()
                );
                /*we are not throwing any exception here since its presense cause an extra error message.we already are showing
                 one message in the outside try so there is no need for it.*/
            }

            if (previousAssessment != null) {
                // Process the previous assessment record
                return previousAssessment.ExpirationDateTime;
            } else {
                // If there are no records in listOfAss or no previous assessment found, query the date from another custom object
                // Replace 'BI_PSP_Questionnaire_Setups__c' with the API name of your custom object
                /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                 object using Healthcare license.*/
                if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                    customObjectRecords = [
                        SELECT Id, BI_PSP_DLQI_RollOutDate__c, OwnerId
                        FROM BI_PSP_Questionnaire_Setups__c
                        WHERE BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        ORDER BY CreatedDate DESC
                        LIMIT 1
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',System.now(),emptyEnrollerecrd,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!customObjectRecords.isEmpty()) {
                    // Process the custom object record
                    return customObjectRecords[0].BI_PSP_DLQI_RollOutDate__c;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CardDateForInProgress.class.toString(),
                        '',
                        System.now(),
                        emptyInitialrollout,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                    throw new AuraHandledException(emptyInitialrollout);
                }
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_CardDateForInProgress.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyInitialrollout);
        }
    }
    /*@Description Aura enabled method to get the date in progress for PSS category.
     * we use this method in biPspbPsoriasisCard LWC Component.*/
    @AuraEnabled(cacheable=true)
    public static Datetime getTheDateInProgessForCardPSS() {
        try {
            String currentUserName = UserInfo.getName();
            String currentUserEmail = UserInfo.getUserEmail();
            //We are getting custom field from User Object. Hence we have to use SOQL.
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
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!patientAccount.isEmpty()) {
                    /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                     object using Healthcare license.*/
                    List<CareProgramEnrollee> enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].Id
                    ];
		    /*A user will only have one CareProgramEnrollee therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                    if (!enrolledPatient.isEmpty()) {
                        enrolleeId = enrolledPatient[0].Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CardDateForInProgress.class.toString(),
                        '',System.now(),patientAccounterrormsg,
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
                /*A user will only have one Account therefore using list for a single record 
                can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccount.isEmpty()) {
                    selectedPatient = [
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
                    if (!selectedPatient.isEmpty()) {
                        /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                         object using Healthcare license.*/
                        caregvrEnroledPatinet = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatient[0].Id
                        ];
			   /*A user will only have one CareProgramEnrollee therefore using list for a single record 
               can be negotiable and there may be a use for this in the future.*/
                        if (!caregvrEnroledPatinet.isEmpty()) {
                            enrolleeId = caregvrEnroledPatinet[0].Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CardDateForInProgress.class.toString(),
                        '',System.now(),caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            Assessment previousAssessment = null;

            try {
                // If there are records in listOfAss, query the previous assessment record with status Completed
                /*USER_MODE is not used because Assessment is an Salesforce Industry
                 object using Healthcare license.*/
                previousAssessment = [
                    SELECT
                        Id,
                        Name,
                        AssessmentStatus,
                        ExpirationDateTime,
                        OwnerId
                    FROM Assessment
                    WHERE
                        BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND AssessmentStatus = :expired
                        AND Name = :pss
                    ORDER BY CreatedDate DESC
                    LIMIT 1
                ];
            } catch (QueryException ex) {
                // Handle the exception (list has no rows)
                BI_SFCOE_LOG_Util.handleException(
                    ex,
                    applicationName,
                    BI_PSP_CardDateForInProgress.class.toString(),
                    null,
                    System.now()
                );
                /*we are not throwing any exception here since its presense cause an extra error message.we already are showing
                 one message in the outside try so there is no need for it.*/
            }

            if (previousAssessment != null) {
                // Process the previous assessment record
                return previousAssessment.ExpirationDateTime;
            } else {
                // If there are no records in listOfAss or no previous assessment found, query the date from another custom object
                // Replace 'BI_PSP_Questionnaire_Setups__c' with the API name of your custom object
                /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                 object using Healthcare license.*/
                if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                    customObjectRecords = [
                        SELECT Id, BI_PSP_PSS_RollOutDate__c, OwnerId
                        FROM BI_PSP_Questionnaire_Setups__c
                        WHERE BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        ORDER BY CreatedDate DESC
                        LIMIT 1
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',System.now(),emptyEnrollerecrd,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }

                if (!customObjectRecords.isEmpty()) {
                    // Process the custom object record
                    return customObjectRecords[0].BI_PSP_PSS_RollOutDate__c;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CardDateForInProgress.class.toString(),
                        '',
                        System.now(),
                        emptyInitialrollout,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                    throw new AuraHandledException(emptyInitialrollout);
                }
            }
        } catch (Exception ex) {
            String applicationName = BI_SFCOE_LOG_App_Settings__c.getInstance()
                .BI_SFCOE_LOG_Application__c;
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_CardDateForInProgress.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyInitialrollout);
        }
    }
    //@Descrption Method to get the date in progress for WAPI category.Its used in biPspbWapiCard LWC component.
    @AuraEnabled(cacheable=true)
    public static Datetime getTheDateInProgessForCardWAPI() {
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
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!patientAccount.isEmpty()) {
                    /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                     object using Healthcare license.*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].Id
                    ];
		    /*A user will only have one CareProgramEnrollee therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                    if (!enrolledPatient.isEmpty()) {
                        enrolleeId = enrolledPatient[0].Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CardDateForInProgress.class.toString(),
                        '',System.now(),patientAccounterrormsg,
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
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccount.isEmpty()) {
                    selectedPatient = [
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
                    if (!selectedPatient.isEmpty()) {
                        /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                         object using Healthcare license.*/
                        caregvrEnroledPatinet = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatient[0].Id
                        ];
				/*A user will only have one CareProgramEnrollee therefore using list for a single record 
                can be negotiable and there may be a use for this in the future.*/
                        if (!caregvrEnroledPatinet.isEmpty()) {
                            enrolleeId = caregvrEnroledPatinet[0].Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CardDateForInProgress.class.toString(),
                        '',System.now(),caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            Assessment previousAssessment = null;

            try {
                // If there are records in listOfAss, query the previous assessment record with status Completed
                /*USER_MODE is not used because Assessment is an Salesforce Industry
                 object using Healthcare license.*/
                previousAssessment = [
                    SELECT
                        Id,
                        Name,
                        AssessmentStatus,
                        ExpirationDateTime,
                        OwnerId
                    FROM Assessment
                    WHERE
                        BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND AssessmentStatus = :expired
                        AND Name = :wapiCategory
                    ORDER BY CreatedDate DESC
                    LIMIT 1
                ];
            } catch (QueryException ex) {
                // Handle the exception (list has no rows)
                BI_SFCOE_LOG_Util.handleException(
                    ex,
                    applicationName,
                    BI_PSP_CardDateForInProgress.class.toString(),
                    null,
                    System.now()
                );
                /*we are not throwing any exception here since its presense cause an extra error message.we already are showing
                 one message in the outside try so there is no need for it.*/
            }

            if (previousAssessment != null) {
                // Process the previous assessment record
                return previousAssessment.ExpirationDateTime;
            } else {
                // If there are no records in listOfAss or no previous assessment found, query the date from another custom object
                // Replace 'BI_PSP_Questionnaire_Setups__c' with the API name of your custom object
                /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                 object using Healthcare license.*/
                if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                    customObjectRecords = [
                        SELECT Id, BI_PSP_WAI_RollOutDate__c, OwnerId
                        FROM BI_PSP_Questionnaire_Setups__c
                        WHERE BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        ORDER BY CreatedDate DESC
                        LIMIT 1
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',System.now(),emptyEnrollerecrd,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!customObjectRecords.isEmpty()) {
                    // Process the custom object record
                    return customObjectRecords[0].BI_PSP_WAI_RollOutDate__c;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CardDateForInProgress.class.toString(),
                        '',
                        System.now(),
                        emptyInitialrollout,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                    throw new AuraHandledException(emptyInitialrollout);
                }
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_CardDateForInProgress.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyInitialrollout);
        }
    }
}