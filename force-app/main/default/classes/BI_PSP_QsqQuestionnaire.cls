/*
@description       This Apex class handles the creation and management of assessments and assessment question
                   responses related to a specific type of questionnaire within a care program. 
                   It provides methods for inserting responses, managing draft responses, and
                   handling assessments for both page one and page two of the questionnaire.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Abinsha		05-Dec-2023		Created			Initial development.
* 1.1		Abinsha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/

public with sharing class BI_PSP_QsqQuestionnaire {
    //This label states that the submission assessment has failed.
    private static String assessmentFalied = System.Label.BI_PSP_AssessmentSubFailed;
    //holds the id of inserted asssessment response record.
    private static String assId;
    //custom label for Assesssment Questions query when the result  is empty.
    private static String questionsNotavilable = System.Label.BI_PSP_QuestionsUnavailable;
    // custom label that displays an error message when there is no AssessmnetQuestionVersion Record.
    private static String emptyQuestionversion = System.Label.BI_PSP_EmptyQuestionVersion;
    //a list variable that holds an AssessmentQuestion record.
    private static List<AssessmentQuestion> listOfAssQuVer;
    // custom label that displays an error message when there is no rollout date present.
    private static String rolloutDateerrormessage = System.Label.BI_PSP_RolloutErrorMsg;
    // custom label that displays an error message when there is no AssessmnetQuestionResponse Record.
    private static String emptyQuestionaresponse = System.Label.BI_PSP_EmptyQuestionResponse;
    // custom label that displays an error message when there is no Assessmnet Record.
    private static String emptyAssesment = System.Label.BI_PSP_EmptyAssessment;
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
    // Holds the ID of the current enrollee.
    private static String idOfEnrollee;
    //holds the database error message.
    private static String errorMsg='';
    // Holds the Care Program Enrollee ID.
    private static String enrolleeId;
    // Holds the complete value.
    private static String complete = System.Label.BI_PSP_Complete;
    // Holds the timestamp of questionnaire enrollment
    private static DateTime timeOfQsqEnrllee;
    // Holds the category label for qualitative assessment
    private static String qualiCategory = System.Label.BI_PSP_QualitativeCategory;
    // Holds the category label for pageOne
    private static String pageOne = System.Label.BI_PSP_PageOne;
    // Holds the category label for pageTwo
    private static String pageTwo = System.Label.BI_PSP_PageTwo;
    // Holds the label for in-progress assessment status
    private static String inprogress = System.Label.BI_PSP_Inprogess;
    // Holds the label for completed assessment status
    private static String completed = System.Label.BI_PSP_Completed;
    // Holds the expiration date for qualitative assessments
    private static Integer expireDate = Integer.valueOf(
        System.Label.BI_PSP_ExpireDateForQualitative
    );
    // Holds the number of days for the two-month interval
    private static Integer twoMonthsInt = Integer.valueOf(
        System.Label.BI_PSP_twoMonthsQualitative
    );
    // Holds the number of days for the fourteen-week interval.
    private static Integer fourteenWeeksInt = Integer.valueOf(
        System.Label.BI_PSP_fourteenWeeksQualitative
    );
    //holds the acccount records.
    private static List<Account> caregiverAccountid;
    //holds the CareProgramEnrollee records.
    private static List<CareProgramEnrollee> caregiverEnrollee;
    //holds the CareProgramEnrollee records.
    private static List<CareProgramEnrollee> patientAccountId;
    //holds the Account records.
    private static List<Account> patientAccount;
    //holds the CareProgramEnrollee records.
    private static List<CareProgramEnrollee> lisOfCareEr;
    //holds the Applcation Name
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //varibale that holds the application name retrieved from Custom Settings.
    private static string applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
    //holds the Account details of care giver.
    private static list<Account> caregiverAccount;
    //this list variable carries assessment responses record.
    private static List<AssessmentQuestionResponse> liAssessRespon;
    //This variable holds a label that shows error when there is no care program enrollee record.
    private static String emptyEnrolleerecrd = System.Label.BI_PSP_EmptyCareProgramEnrl;

    /**
     * @description Inserts responses for page one of the questionnaire.
     * @param questionIds List of question IDs.
     * @param responseTexts List of response texts corresponding to question IDs.
     * we are using this method in LWCs such as biPspbQSQuestionnaire1,biPspbQSQuestionnaire2.
     */
    @AuraEnabled
    public static void ranswerOfTheQuestionForPageone(
        List<String> questionIds,
        List<String> responseTexts
    ) {
        try {
            // Step 1: Get the ID of the user performing the insertion

            String currentUserName = UserInfo.getName();
            String currentUserEmail = UserInfo.getUserEmail();
            //We are getting custom field from User Object. Hence we have to use SOQL
            User currentUser = [
                SELECT Id, Name, BI_PSPB_Caregiver__c
                FROM User
                WHERE Name = :currentUserName
                And email=:currentUserEmail
                WITH USER_MODE
                LIMIT 1
            ];

            if (currentUser.BI_PSPB_Caregiver__c == true) {
                // Handle caregiver logic
                handleCaregiverLogic(
                    currentUserName,
                    currentUserEmail,
                    questionIds,
                    responseTexts
                );
            } else {
                // Handle non-caregiver logic
                if ((!questionIds.isEmpty()) && (!responseTexts.isEmpty())) {
                    handleNonCaregiverLogic(
                        currentUserName,
                        currentUserEmail,
                        questionIds,
                        responseTexts
                    );
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        emptyQuestionaresponse,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                    throw new AuraHandledException(emptyQuestionaresponse);
                }
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_QsqQuestionnaire.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
    }
    //this method is for care giver logic that checkcks whether the loggedIn user is care giver or not
    public static void handleCaregiverLogic(
        String currentUserName,
        String currentUserEmail,
        List<String> questionIds,
        List<String> responseTexts
    ) {
        try {
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
                caregiverAccountid = [
                    SELECT Id, Name, PersonEmail
                    FROM Account
                    WHERE
                        Id = :caregiverAccount[0].BI_PSPB_Selected_Patient_ID__c
                    WITH USER_MODE
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    caregiversPatientaccountErr,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
			/*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
            if (!caregiverAccountid.isEmpty()) {
                /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                 using Healthcare license*/
                caregiverEnrollee = [
                    SELECT Id, Name, CreatedDate
                    FROM CareProgramEnrollee
                    WHERE AccountID = :caregiverAccountid[0].Id
                ];
						/*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverEnrollee.isEmpty()) {
                    enrolleeId = caregiverEnrollee[0].Id;
                    timeOfQsqEnrllee = caregiverEnrollee[0].CreatedDate;
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),selctdPatieintsenrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if ((!questionIds.isEmpty()) && (!responseTexts.isEmpty())) {
                createAssessmentAndResponses(
                    questionIds,
                    responseTexts,
                    enrolleeId,
                    timeOfQsqEnrllee
                );
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),emptyQuestionaresponse,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_QsqQuestionnaire.class.toString(),
                null,
                System.now()
            );
        }
    }
    //this method is for care giver logic that checkcks whether the loggedIn user is a Non care giver
    public static void handleNonCaregiverLogic(
        String currentUserName,
        String currentUserEmail,
        List<String> questionIds,
        List<String> responseTexts
    ) {
        try {
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
                /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                 using Healthcare license*/
                patientAccountId = [
                    SELECT Id, Name, CreatedDate
                    FROM CareProgramEnrollee
                    WHERE AccountID = :patientAccount[0].Id
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',System.now(),
                    patientAccounterrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
			/*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
            if (!patientAccountId.isEmpty()) {
                enrolleeId = patientAccountId[0].Id;
                timeOfQsqEnrllee = patientAccountId[0].CreatedDate;
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if ((!questionIds.isEmpty()) && (!responseTexts.isEmpty())) {
                createAssessmentAndResponses(
                    questionIds,
                    responseTexts,
                    enrolleeId,
                    timeOfQsqEnrllee
                );
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',System.now(),
                    emptyQuestionaresponse,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,applicationName,BI_PSP_QsqQuestionnaire.class.toString(), null,System.now()
            );
        }
    }

    /**
     * Creates an assessment record and corresponding assessment question responses.
     *
     * This method takes lists of question IDs and response texts along with other necessary parameters
     * to create an assessment record and its associated assessment question responses in Salesforce.
     * @param questionIds       List of question IDs.
     * @param responseTexts     List of response texts corresponding to the question IDs.
     * @param patinetEnrolleeId             Care program enrollee ID.
     * @param timeOfQsqEnrllee Time of care program enrollee's questionnaire enrollment.
     */
    public static void createAssessmentAndResponses(
        List<String> questionIds,
        List<String> responseTexts,
        String patinetEnrolleeId,
        Datetime timeOfQsqEnrllee
    ) {
        try {
            String activeVersionId = null;
            //we are checking user response is valid or not by checking yhe question id and and its response is empty or not.
            if ((!questionIds.isEmpty()) && (!responseTexts.isEmpty())) {
                for (Integer i = 0; i < questionIds.size(); i++) {
                    activeVersionId = questionIds[i];
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            String categoryName = null;
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            if (activeVersionId != null && !String.isBlank(activeVersionId)) {
                listOfAssQuVer = [
                    SELECT Id, QuestionCategory
                    FROM AssessmentQuestion
                    WHERE ActiveVersionId = :activeVersionId
                    LIMIT 1
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionversion,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            if (!listOfAssQuVer.isEmpty()) {
                for (AssessmentQuestion assVer : listOfAssQuVer) {
                    categoryName = assVer.QuestionCategory;
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),
                    '',System.now(),questionsNotavilable,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            Assessment ass = new Assessment();
            if (
                patinetEnrolleeId != null && !String.isBlank(patinetEnrolleeId)
            ) {
                ass.BI_PSP_CareProgramEnrollee__c = patinetEnrolleeId;
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),
                    '',System.now(),patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            ass.EffectiveDateTime = DateTime.now();
            ass.ExpirationDateTime = DateTime.now().addDays(expireDate);

            ass.AssessmentStatus = completed;
            ass.Name = categoryName;
            if (timeOfQsqEnrllee != null) {
                ass.BI_PSP_RolloutforCompletedQuestionnarie__c = timeOfQsqEnrllee.addDays(
                    twoMonthsInt
                );
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),rolloutDateerrormessage,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            // Perform the insert operation and store the result
            Database.SaveResult[] insertResults = Database.insert(
                new List<Assessment>{ ass },
                false
            );

            if (!insertResults[0].isSuccess()) {
                // Handle errors in inserting Assessment record
                for (Database.SaveResult sr : insertResults) {
                    for (Database.Error error : sr.getErrors()) {
                        errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                    }
                }

                if (!String.isBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                        insertResults,BI_PSP_QsqQuestionnaire.class.toString(),System.now()
                    );
                    throw new DMLException(errorMsg);
                }
            }

            if (!insertResults.isEmpty()) {
                assId = insertResults[0].getId();
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),emptyQuestionaresponse,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();

            for (Integer i = 0; i < questionIds.size(); i++) {
                String questionId = questionIds[i];
                String responseText = responseTexts[i];

                AssessmentQuestionResponse assRes = new AssessmentQuestionResponse();
                assRes.AssessmentQuestionId = questionId;
                assRes.ResponseText = responseText;
                assRes.BI_PSP_QsqAfter2months__c = pageOne;
                assRes.AssessmentId = assId;
                assRes.Name = responseText;

                assResList.add(assRes);
            }

            // Perform the insert operation for AssessmentQuestionResponse records and store the result
            Database.SaveResult[] insertAssResResults = Database.insert(
                assResList,
                false
            );
            for (Database.SaveResult responseSaveResult : insertAssResResults) {
                if (!responseSaveResult.isSuccess()) {
                    for ( Database.Error error : responseSaveResult.getErrors()) {
                        errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                    }if (!String.isBlank(errorMsg)) {
                        BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                            insertAssResResults,BI_PSP_QsqQuestionnaire.class.toString(),System.now()
                        );
                        throw new DMLException(errorMsg);
                    }
                }
            }
            if (ass.AssessmentStatus == completed && assId != null) {
                List<Assessment> previousAssessments = [
                    SELECT Id
                    FROM Assessment
                    WHERE
                        OwnerId = :UserInfo.getUserId()
                        AND AssessmentStatus = :inprogress
                        AND Name = :ass.Name
                ];
                Database.DeleteResult[] deleteResults = Database.delete(
                    previousAssessments,
                    false
                );
                for (Database.DeleteResult responseSaveResult : deleteResults) {
                    if (!responseSaveResult.isSuccess()) {
                        for (
                            Database.Error error : responseSaveResult.getErrors()) {
                            errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                        }
                        if (!String.isBlank(errorMsg)) {
                            BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),
                                '',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                            );
                            throw new DMLException(errorMsg);
                        }
                    }
                }
            }
        } catch (System.DmlException ex) {
            BI_SFCOE_LOG_Util.handleException(ex,applicationName,
                BI_PSP_QsqQuestionnaire.class.toString(),null,System.now()
            );
            throw new System.DmlException(assessmentFalied + ex.getMessage());
        }
    }
    /**
     * @description Inserts draft responses for page one of the questionnaire
     * @param darftQuestionIds List of draft question IDs
     * @param draftResponseTexts List of draft response texts corresponding to question IDs
     * We use this method in LWCs such as
     */
    @AuraEnabled
    public static void mulitipleDraftRecordsInsertionPageOne(
        List<String> darftQuestionIds,
        List<String> draftResponseTexts
    ) {
        try {
            // Step 1: Get the ID of the user performing the insertion
            String userId = UserInfo.getUserId();
            String currentUserName = UserInfo.getName();
            String currentUserEmail = UserInfo.getUserEmail();
            //We are getting custom field from User Object. Hence we have to use SOQL
            User currentUser = [
                SELECT Id, Name, BI_PSPB_Caregiver__c
                FROM User
                WHERE Name = :currentUserName
                And email=:currentUserEmail
                WITH USER_MODE
                LIMIT 1
            ];

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
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccount.isEmpty()) {
                    caregiverAccountid = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
			/*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccountid.isEmpty()) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    caregiverEnrollee = [
                        SELECT Id, Name, CreatedDate
                        FROM CareProgramEnrollee
                        WHERE AccountID = :caregiverAccountid[0].Id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                        System.now(), caregiversSelectedpatienterrmsg, BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
			/*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverEnrollee.isEmpty()) {
                    enrolleeId = caregiverEnrollee[0].Id;
                    timeOfQsqEnrllee = caregiverEnrollee[0].CreatedDate;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                        System.now(),selctdPatieintsenrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else {
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
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    patientAccountId = [
                        SELECT Id, Name, CreatedDate
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].Id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                        System.now(),patientAccounterrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
			/*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!patientAccountId.isEmpty()) {
                    enrolleeId = patientAccountId[0].Id;
                    timeOfQsqEnrllee = patientAccountId[0].CreatedDate;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                        System.now(),patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            String activeVersionId = null;
            if (
                (!darftQuestionIds.isEmpty()) && (!draftResponseTexts.isEmpty())
            ) {
                for (Integer i = 0; i < darftQuestionIds.size(); i++) {
                    activeVersionId = darftQuestionIds[i];
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),emptyQuestionaresponse,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(emptyQuestionaresponse);
            }

            String categoryName = null;
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            if (activeVersionId != null && !String.isBlank(activeVersionId)) {
                listOfAssQuVer = [
                    SELECT Id, QuestionCategory
                    FROM AssessmentQuestion
                    WHERE ActiveVersionId = :activeVersionId
                    LIMIT 1
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),emptyQuestionversion,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            if (!listOfAssQuVer.isEmpty()) {
                for (AssessmentQuestion assVer : listOfAssQuVer) {
                    categoryName = assVer.QuestionCategory;
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),questionsNotavilable,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            Assessment ass = new Assessment();
            ass.BI_PSP_CareProgramEnrollee__c = enrolleeId;
            ass.EffectiveDateTime = DateTime.now();

            ass.ExpirationDateTime = DateTime.now().addDays(expireDate);
            ass.AssessmentStatus = inprogress;
            ass.Name = categoryName;

            // Perform the insert operation and store the result
            Database.SaveResult[] insertResults = Database.insert(
                new List<Assessment>{ ass },
                false
            );

            if (!insertResults[0].isSuccess()) {
                // Handle errors in inserting Assessment record
                for (Database.SaveResult sr : insertResults) {
                    for (Database.Error error : sr.getErrors()) {
                        errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                    }
                }
                if (!String.isBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                        insertResults,BI_PSP_QsqQuestionnaire.class.toString(),System.now()
                    );
                    throw new AuraHandledException(errorMsg);
                }
            }

            String assId = insertResults[0].getId();

            List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();

            for (Integer i = 0; i < darftQuestionIds.size(); i++) {
                String questionId = darftQuestionIds[i];
                String responseText = draftResponseTexts[i];

                AssessmentQuestionResponse assRes = new AssessmentQuestionResponse();
                assRes.AssessmentQuestionId = questionId;
                assRes.ResponseText = responseText;
                assRes.BI_PSP_QsqAfter2months__c = pageOne;
                assRes.AssessmentId = assId;
                assRes.Name = responseText;
                assRes.OwnerId = userId;

                assResList.add(assRes);
            }

            // Perform the insert operation for AssessmentQuestionResponse records and store the result
            Database.SaveResult[] insertAssResResults = Database.insert(
                assResList,
                false
            );
            for (Database.SaveResult responseSaveResult : insertAssResResults) {
                if (!responseSaveResult.isSuccess()) {
                    for (Database.Error error : responseSaveResult.getErrors()) {
                        errorMsg +='Error ' +error.getFields() +'--' + error.getMessage() + '\n';
                    }
                    if (!String.isBlank(errorMsg)) {
                        BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                            insertAssResResults,BI_PSP_QsqQuestionnaire.class.toString(),System.now()
                        );
                        // Propagate combined errors after collecting from all records
                        throw new AuraHandledException(errorMsg);
                    }
                }
            }
            // Check if the insertion of AssessmentQuestionResponse records was successful
            if (
                !insertAssResResults.isEmpty() &&
                insertAssResResults[0].isSuccess()
            ) {
                // Delete previous assessments if necessary
                List<Assessment> previousAssessments = [
                    SELECT Id
                    FROM Assessment
                    WHERE
                        CreatedById = :userId
                        AND AssessmentStatus = :inprogress
                        AND Id != :assId
                        AND Name = :categoryName
                ];
                if (!previousAssessments.isEmpty()) {
                    Database.DeleteResult[] deleteResults = Database.delete(
                        previousAssessments, false
                    );
                    for (Database.DeleteResult responseSaveResult : deleteResults) {
                        if (!responseSaveResult.isSuccess()) {
                            for ( Database.Error error : responseSaveResult.getErrors()) {
                                errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                            }
                            if (!String.isBlank(errorMsg)) {
                                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),
                                    '',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                                );
                                // Propagate combined errors after collecting from all records
                                throw new AuraHandledException(errorMsg);
                            }
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),
                        '', System.now(), emptyAssesment,
                       BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                    }
            } else {
                // Handle errors in inserting AssessmentQuestionResponse records
                for (Database.SaveResult sr : insertAssResResults) {
                    for (Database.Error error : sr.getErrors()) {
                        // Log or handle the error as needed
                        BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                            insertAssResResults,BI_PSP_QsqQuestionnaire.class.toString(),System.now()
                        );
                    }
                }
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(ex,applicationName,
                BI_PSP_QsqQuestionnaire.class.toString(),null,
                System.now()
            );
            throw new AuraHandledException(assessmentFalied);
        }
    }

    /**
     * @description Inserts responses for page two of the questionnaire
     * @param questionIds List of question IDs
     * @param responseTexts List of response texts corresponding to question IDs
     * We use this method in LWCs such as biPspbQSQuestionnaire1,biPspbQSQuestionnaire2.
     */
    @AuraEnabled
    public static void ranswerOfTheQuestionForPageTwo(
        List<String> questionIds,
        List<String> responseTexts
    ) {
        try {
            // Step 1: Get the ID of the user performing the insertion
            String userId = UserInfo.getUserId();
            String currentUserName = UserInfo.getName();
            String currentUserEmail = UserInfo.getUserEmail();
            //We are getting custom field from User Object. Hence we have to use SOQL
            User currentUser = [
                SELECT Id, Name, BI_PSPB_Caregiver__c
                FROM User
                WHERE Name = :currentUserName
                And email=:currentUserEmail
                WITH USER_MODE
                LIMIT 1
            ];

            if (currentUser.BI_PSPB_Caregiver__c == true) {
                list<Account> caregiverAccount = [
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
                    caregiverAccountid = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
		    /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccountid.isEmpty()) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    caregiverEnrollee = [
                        SELECT Id, Name, CreatedDate
                        FROM CareProgramEnrollee
                        WHERE AccountID = :caregiverAccountid[0].Id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                        System.now(),caregiversSelectedpatienterrmsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
			/*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverEnrollee.isEmpty()) {
                    enrolleeId = caregiverEnrollee[0].Id;
                    timeOfQsqEnrllee = caregiverEnrollee[0].CreatedDate;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        selctdPatieintsenrolleeerrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else {
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
                    /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    patientAccountId = [
                        SELECT Id, Name, CreatedDate
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].Id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
			/*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!patientAccountId.isEmpty()) {
                    enrolleeId = patientAccountId[0].Id;
                    timeOfQsqEnrllee = patientAccountId[0].CreatedDate;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                        System.now(),patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            String activeVersionId = null;
            if ((!questionIds.isEmpty()) && (!responseTexts.isEmpty())) {
                for (Integer i = 0; i < questionIds.size(); i++) {
                    activeVersionId = questionIds[i];
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(emptyQuestionaresponse);
            }

            String categoryName = null;
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            if (activeVersionId != null && !String.isBlank(activeVersionId)) {
                listOfAssQuVer = [
                    SELECT Id, QuestionCategory
                    FROM AssessmentQuestion
                    WHERE ActiveVersionId = :activeVersionId
                    LIMIT 1
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage( applicationName, BI_PSP_QsqQuestionnaire.class.toString(), '',
                    System.now(),emptyQuestionversion,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            if (!listOfAssQuVer.isEmpty()) {
                for (AssessmentQuestion assVer : listOfAssQuVer) {
                    categoryName = assVer.QuestionCategory;
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),questionsNotavilable,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            Assessment ass = new Assessment();
            ass.BI_PSP_CareProgramEnrollee__c = enrolleeId;
            ass.EffectiveDateTime = DateTime.now();
            ass.BI_PSP_StatusForPersonalization__c = complete;
            ass.ExpirationDateTime = DateTime.now().addDays(expireDate);
            ass.AssessmentStatus = completed;
            ass.Name = categoryName;
            ass.BI_PSP_RolloutforCompletedQuestionnarie__c = timeOfQsqEnrllee.addDays(
                fourteenWeeksInt
            );

            // Perform the insert operation and store the result
            Database.SaveResult[] insertResults = Database.insert(
                new List<Assessment>{ ass },
                false
            );
            for (Database.SaveResult responseSaveResult : insertResults) {
                if (!responseSaveResult.isSuccess()) {
                    for (Database.Error error : responseSaveResult.getErrors()) {
                        errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                    }
                    if (!String.isBlank(errorMsg)) {
                        BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                            insertResults,BI_PSP_QsqQuestionnaire.class.toString(),System.now()
                        );
                         throw new AuraHandledException(errorMsg);
                    }
                }
            }

            String assId = insertResults[0].getId();
            String assName = ass.Name;
            String afterTwo;

            List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();

            for (Integer i = 0; i < questionIds.size(); i++) {
                String questionId = questionIds[i];
                String responseText = responseTexts[i];

                AssessmentQuestionResponse assRes = new AssessmentQuestionResponse();
                assRes.AssessmentQuestionId = questionId;
                assRes.ResponseText = responseText;
                assRes.BI_PSP_QsqAfterWeeks__c = pageTwo;
                assRes.AssessmentId = assId;
                assRes.Name = responseText;

                assResList.add(assRes);
                afterTwo = assRes.BI_PSP_QsqAfterWeeks__c;
            }

            // Perform the insert operation for AssessmentQuestionResponse records and store the result
            Database.SaveResult[] insertAssResResults = Database.insert(
                assResList,
                false
            );
            for (Database.SaveResult responseSaveResult : insertAssResResults) {
                if (!responseSaveResult.isSuccess()) {
                    for (Database.Error error : responseSaveResult.getErrors()) {
                        errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                    }
                    if (!String.isBlank(errorMsg)) {
                        BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                            insertAssResResults,BI_PSP_QsqQuestionnaire.class.toString(),System.now()
                        );
                          throw new AuraHandledException(errorMsg);
                    }
                }
            }
            if (
                ass.AssessmentStatus == completed &&
                assId != null &&
                afterTwo == pageTwo
            ) {
                /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object using Healthcare
                 *license.*/
                List<Assessment> previousAssessments = [
                    SELECT Id
                    FROM Assessment
                    WHERE
                        CreatedById = :userId
                        AND AssessmentStatus = :inprogress
                        AND Id != :assId
                        AND Name = :assName
                ];

                Database.DeleteResult[] deleteResults = Database.delete(
                    previousAssessments,
                    false
                );
                for (Database.DeleteResult responseSaveResult : deleteResults) {
                    if (!responseSaveResult.isSuccess()) {
                        for ( Database.Error error : responseSaveResult.getErrors() ) {
                            errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                        }
                        if (!String.isBlank(errorMsg)) {
                            BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),
                                '',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                            );
                              throw new AuraHandledException(errorMsg);
                        }
                    }
                }
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_QsqQuestionnaire.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(assessmentFalied);
        }
    }

    /**
     * @description Inserts draft responses for page two of the questionnaire
     * @param darftQuestionIds List of draft question IDs
     * @param draftResponseTexts List of draft response texts corresponding to question IDs
     * we use this method in LWCs such as biPspbQSQuestionnaire1,biPspbQSQuestionnaire2.
     */
    @AuraEnabled
    public static void mulitipleDraftRecordsInsertionPageTwo(
        List<String> darftQuestionIds,
        List<String> draftResponseTexts
    ) {
        try {
            // Step 1: Get the ID of the user performing the insertion
            String userId = UserInfo.getUserId();
            String currentUserName = UserInfo.getName();
            String currentUserEmail = UserInfo.getUserEmail();
            //We are getting custom field from User Object. Hence we have to use SOQL
            User currentUser = [
                SELECT Id, Name, BI_PSPB_Caregiver__c
                FROM User
                WHERE Name = :currentUserName
                And email=:currentUserEmail
                WITH USER_MODE
                LIMIT 1
            ];

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
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccount.isEmpty()) {
                    caregiverAccountid = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccountid.isEmpty()) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    caregiverEnrollee = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :caregiverAccountid[0].Id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                        System.now(),caregiversSelectedpatienterrmsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverEnrollee.isEmpty()) {
                    enrolleeId = caregiverEnrollee[0].Id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),
                        '',System.now(),
                        selctdPatieintsenrolleeerrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else {
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
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    patientAccountId = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].Id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
		    /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!patientAccountId.isEmpty()) {
                    enrolleeId = patientAccountId[0].Id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                        System.now(),patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            String activeVersionId = null;
            if (
                (!darftQuestionIds.isEmpty()) && (!draftResponseTexts.isEmpty())
            ) {
                for (Integer i = 0; i < darftQuestionIds.size(); i++) {
                    activeVersionId = darftQuestionIds[i];
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(emptyQuestionaresponse);
            }

            String categoryName = null;
            /* USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object
             using Healthcare license*/
            if (activeVersionId != null && !String.isBlank(activeVersionId)) {
                listOfAssQuVer = [
                    SELECT Id, QuestionCategory
                    FROM AssessmentQuestion
                    WHERE ActiveVersionId = :activeVersionId
                    LIMIT 1
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),emptyQuestionversion,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            if (!listOfAssQuVer.isEmpty()) {
                for (AssessmentQuestion assVer : listOfAssQuVer) {
                    categoryName = assVer.QuestionCategory;
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                    System.now(),questionsNotavilable,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            Assessment ass = new Assessment();
            ass.BI_PSP_CareProgramEnrollee__c = enrolleeId;
            ass.EffectiveDateTime = DateTime.now();

            ass.ExpirationDateTime = DateTime.now().addDays(expireDate);
            ass.AssessmentStatus = inprogress;
            ass.Name = categoryName;

            // Perform the insert operation and store the result
            Database.SaveResult[] insertResults = Database.insert(
                new List<Assessment>{ ass },
                false
            );
            for (Database.SaveResult responseSaveResult : insertResults) {
                if (!responseSaveResult.isSuccess()) {
                    for (Database.Error error : responseSaveResult.getErrors() ) {
                       errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() + '\n';
                    }
                    if (!String.isBlank(errorMsg)) {
                        BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                         insertResults,BI_PSP_QsqQuestionnaire.class.toString(),System.now()
                        );
                        throw new AuraHandledException(errorMsg);
                    }
                }
            }

            String assId = insertResults[0].getId();
            String catName = ass.Name;

            List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();

            for (Integer i = 0; i < darftQuestionIds.size(); i++) {
                String questionId = darftQuestionIds[i];
                String responseText = draftResponseTexts[i];

                AssessmentQuestionResponse assRes = new AssessmentQuestionResponse();
                assRes.AssessmentQuestionId = questionId;
                assRes.ResponseText = responseText;
                assRes.BI_PSP_QsqAfterWeeks__c = pageTwo;
                assRes.AssessmentId = assId;
                assRes.Name = responseText;

                assResList.add(assRes);
            }

            // Perform the insert operation for AssessmentQuestionResponse records and store the result
            Database.SaveResult[] insertAssResResults = Database.insert(
                assResList,
                false
            );

            if (
                !insertAssResResults.isEmpty() &&
                insertAssResResults[0].isSuccess()
            ) {
                // Delete previous assessments if necessary
                if (ass.AssessmentStatus == inprogress && assId != null) {
                    /*USER_MODE is not used because Assessment is an Salesforce Industry object using Healthcare
                     *license.*/
                    List<Assessment> previousAssessments = [
                        SELECT Id
                        FROM Assessment
                        WHERE
                            CreatedById = :userId
                            AND AssessmentStatus = :inprogress
                            AND Id != :assId
                            AND Name = :catName
                    ];
                    if (!previousAssessments.isEmpty()) {
                        Database.DeleteResult deleteInprogressRespo = Database.delete(
                            previousAssessments[0],false
                        );
                        if (!deleteInprogressRespo.isSuccess()) {
                            for (Database.Error error : deleteInprogressRespo.getErrors()) {
                                errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                            }
                            if (!String.isBlank(errorMsg)) {
                               BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),
                                    '',System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                                );
                                 throw new AuraHandledException(errorMsg);
                            }
                        }
                    }
                }
            } else {
                // Handle errors in inserting AssessmentQuestionResponse records
                for (Database.SaveResult sr : insertAssResResults) {
                    for (Database.Error error : sr.getErrors()) {
                        errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                    }
                }
                if (!String.isBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                        insertAssResResults, BI_PSP_QsqQuestionnaire.class.toString(), System.now()
                    );
                    throw new AuraHandledException(errorMsg);
                }
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_QsqQuestionnaire.class.toString(),
                null,
                System.now()
            );
            // Propagate combined errors after collecting from all records
            throw new AuraHandledException(assessmentFalied);
        }
    }

    /**
     * @description Retrieves draft responses for page one of the questionnaire.
     * we use this method in LWCs such as biPspbQSQuestionnaire1,biPspbQSQuestionnaire2.
     */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestionResponse> draftResponseOfIntroductionPageone() {
        try {
            //care give access code
            String currentUserName = UserInfo.getName();
			String currentUserEmail = UserInfo.getUserEmail();
            // Query for the user's Id based on the name
            User currentUser = [
                SELECT Id, Name, BI_PSPB_Caregiver__c
                FROM User
                WHERE name = :currentUserName
                And email=:currentUserEmail
                WITH USER_MODE
                LIMIT 1
            ];

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
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccount.isEmpty()) {
                    caregiverAccountid = [
                        SELECT id, Name, PersonEmail
                        FROM account
                        WHERE
                            id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccountid.isEmpty()) {
                    /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object using Healthcare
                     *license.*/
                    caregiverEnrollee = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :caregiverAccountid[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_QsqQuestionnaire.class.toString(),'',
                        System.now(),caregiversSelectedpatienterrmsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverEnrollee.isEmpty()) {
                    enrolleeId = caregiverEnrollee[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        selctdPatieintsenrolleeerrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else {
                list<Contact> caregiverAccountid = [
                    SELECT ownerid, Name, Account.Id
                    FROM Contact
                    WHERE Name = :currentUserName AND Email = :currentUserEmail
                    WITH USER_MODE
                ];
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccountid.isEmpty()) {
                    /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object using Healthcare
                     *license.*/
                    lisOfCareEr = [
                        SELECT Id, AccountId
                        FROM CareProgramEnrollee
                        WHERE AccountId = :caregiverAccountid[0].Account.Id
                        LIMIT 1
                    ];
		    /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                    if (!lisOfCareEr.isEmpty()) {
                        enrolleeId = lisOfCareEr[0].Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            /*USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object using Healthcare
             *license.*/
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                liAssessRespon = [
                    SELECT
                        Id,
                        ResponseText,
                        ResponseValue,
                        BI_PSP_Questionnaire_Name__c,
                        BI_PSP_ResponseOrder__c,
                        AssessmentQuestion.Id,
                        BI_PSP_QsqAfter2months__c,
                        Assessment.ownerid,
                        Assessment.Id,
                        Assessment.AssessmentStatus
                    FROM AssessmentQuestionResponse
                    WHERE
                        BI_PSP_Questionnaire_Name__c = :qualiCategory
                        AND assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND Assessment.AssessmentStatus = :inprogress
                        AND BI_PSP_QsqAfter2months__c = :pageOne
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
                    BI_PSP_QsqQuestionnaire.class.toString(),
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
                BI_PSP_QsqQuestionnaire.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return liAssessRespon;
    }
    /**
     * @description Retrieves draft responses for page two of the questionnaire
     * @return List of draft assessment question responses for page two
     * we use this method in LWCs such as biPspbQSQuestionnaire1,biPspbQSQuestionnaire2.
     */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestionResponse> draftResponseOfIntroductionPageTwo() {
        try {
            //care give access code
            String currentUserName = UserInfo.getName();
			String currentUserEmail = UserInfo.getUserEmail();
            // Query for the user's Id based on the name
            User currentUser = [
                SELECT Id, Name, BI_PSPB_Caregiver__c
                FROM User
                WHERE name = :currentUserName
                And email=:currentUserEmail
                WITH USER_MODE
                LIMIT 1
            ];

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
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccount.isEmpty()) {
                    caregiverAccountid = [
                        SELECT id, Name, PersonEmail
                        FROM account
                        WHERE
                            id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!caregiverAccountid.isEmpty()) {
                    /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object using Healthcare
                     *license.*/
                    caregiverEnrollee = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :caregiverAccountid[0].id
                    ];
		    /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                    if (!caregiverEnrollee.isEmpty()) {
                        enrolleeId = caregiverEnrollee[0].id;
                    } else {
                        BI_SFCOE_LOG_Util.logMessage(
                            applicationName,
                            BI_PSP_QsqQuestionnaire.class.toString(),
                            '',
                            System.now(),
                            selctdPatieintsenrolleeerrormsg,
                            BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                        );
                    }
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
            /*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                if (!patientAccount.isEmpty()) {
                    /*USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object using Healthcare
                     *license.*/
                    lisOfCareEr = [
                        SELECT Id, AccountId
                        FROM CareProgramEnrollee
                        WHERE AccountId = :patientAccount[0].id
                        LIMIT 1
                    ];
			/*A user will only have one Account therefore using list for a single record 
            can be negotiable and there may be a use for this in the future.*/
                    if (!lisOfCareEr.isEmpty()) {
                        enrolleeId = lisOfCareEr[0].Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_QsqQuestionnaire.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            //USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object using Healthcare license
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                liAssessRespon = [
                    SELECT
                        Id,
                        ResponseText,
                        ResponseValue,
                        BI_PSP_Questionnaire_Name__c,
                        BI_PSP_ResponseOrder__c,
                        AssessmentQuestion.Id,
                        BI_PSP_QsqAfterWeeks__c,
                        Assessment.ownerid,
                        Assessment.Id,
                        Assessment.AssessmentStatus
                    FROM AssessmentQuestionResponse
                    WHERE
                        BI_PSP_Questionnaire_Name__c = :qualiCategory
                        AND assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND Assessment.AssessmentStatus = :inprogress
                        AND BI_PSP_QsqAfterWeeks__c = :pageTwo
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
                    BI_PSP_QsqQuestionnaire.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
               /* we are not throwing any error here as it will allow one erro to get displayed even when
                 the user hasnt created one.*/
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_QsqQuestionnaire.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return liAssessRespon;
    }
}