/*
* @description       This class provides methods to retrieve questionnaire questions for different categories
                     such as Work & Activity Impairment (WPAI), Introduction, Psoriasis Symptom Scale (PSS), 
                     Dermatology Life Quality Index (DLQI), and Qualitative satisfaction questionnaire.
                     It also includes methods to handle the insertion of assessment records, including completed 
                     assessments and drafts, and methods to get the status of assessments and counts of completed
                     assessments of the current user.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Abinsha		05-Dec-2023		Created			Initial development.
* 1.1		Abinsha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/

public with sharing class BI_PSP_Assessment {
    // Holds the label for completed assessment status
    private static String completed = System.Label.BI_PSP_Completed;
    // Stores the ID of the assessment record.
    private static String assessmentId;
    // Stores the expiration date for the Psoriasis Symptom Scale (PSS) questionnaire.
    private static Date expireDatePss;
    // Stores the expiration date for the Work & Activity Impairment (WAI) questionnaire.
    private static Date expireDateWai;
    // Stores the expiration date for the Dermatology Life Quality Index (DLQI) questionnaire.
    private static Date expireDateDlqi;
    // Stores the ID of the Care Program Enrollee associated with the assessment.
    private static string enrolleeId;
    // Stores the introduction category label for the questionnaire.
    private static String introduction = System.Label.BI_PSP_introductionCategory;
    // Stores the Psoriasis Symptom Scale (PSS) category label for the questionnaire.
    private static String pss = System.Label.BI_PSP_PssCategory;
    // Stores the Work & Activity Impairment (WAI) category label for the questionnaire.
    private static String wapiCategory = System.Label.BI_PSP_WapiCategory;
    // Stores the Dermatology Life Quality Index (DLQI) category label for the questionnaire.
    private static String dlqiCategory = System.Label.BI_PSP_DlqiCategory;
    // Stores the Qualitative satisfaction questionnaire category label.
    private static String qualiCategory = System.Label.BI_PSP_QualitativeCategory;
    // Stores the label for the 'In Progress' status of an assessment.
    private static String inprogress = System.Label.BI_PSP_Inprogess;
    //holds the label for expired text.
    private static String expiredLabel = System.Label.BI_PSP_Expired;
    //holds the label for active text.
    private static String active = System.Label.BI_PSP_Active;
    // Stores the expiration date for the Qualitative satisfaction questionnaire.
    private static Integer expireDate = Integer.valueOf(
        System.Label.BI_PSP_ExpireDateForQualitative
    );
    //varibale that holds the application name retrieved from Custom Settings.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //A variable That holds the name of our application to be used in catch exception handler.
    private static string applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
    //holds the error message.
    private static String errorMsg='';
    //custom label for Assesssment Questions query when the result  is empty.
    private static String questionsNotavilable = System.Label.BI_PSP_QuestionsUnavailable;
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
    // custom label that displays an error message when the submit functionality of the assessment fails.
    private static String submitErrormsg = System.Label.BI_PSP_SubmitErrorMsg;
    // custom label that displays an error message when there is no Assessmnet Record.
    private static String emptyAssesment = System.Label.BI_PSP_EmptyAssessment;
    // custom label that displays an error message when there is no AssessmnetQuestionResponse Record.
    private static String emptyQuestionaresponse = System.Label.BI_PSP_EmptyQuestionResponse;
    // custom label that displays an error message when there is no AssessmnetQuestionVersion Record.
    private static String emptyQuestionversion = System.Label.BI_PSP_EmptyQuestionVersion;
    // custom label that displays an error message when there is no rollout date present.
    private static String rolloutDateerrormessage = System.Label.BI_PSP_RolloutErrorMsg;
    //List that holds Account Records
    private static List<Account> caregiverAccount;
    //List that holds Account Records
    private static List<Account> enrolleeAcount;
    //List that holds CareProgramEnrollee Records
    private static List<CareProgramEnrollee> enrolleeRecord;
    //List that holds Account Records
    private static List<Account> patientAccount;
    //List that holds CareProgramEnrollee Records
    private static List<CareProgramEnrollee> enrolledPatient;
    //List that holds AssessmentQuestion Records
    private static List<AssessmentQuestion> assessmentQuestions;
    //hold the Question id performed by the user
    private static String activeVersionId;
    //holds the Query result for getting the Assessment Question
    private static List<AssessmentQuestion> listOfAssQuVer;
    //holds the category name
    private static String categoryName;
    //variable that holds category
    private static String category;
    //varible that hold the count of answered Questions
    private static Integer answeredQuestions;
    //variable that holds active Questions
    private static Integer activeQuestionCount;
    //Variable that holds the number of assessments
    private static List<Integer> assessmentCounts;
    //Vraible that holds the initial rollout Questionnaire Dates
    private static List<BI_PSP_Questionnaire_Setups__c> questionnairesDate;
    //This variable holds the category name of the question.
    private static String emptyCategoryname = System.Label.BI_PSP_EmptyCategoryError;
    //This label states that the submission assessment has failed.
    private static String assessmentFalied = System.Label.BI_PSP_AssessmentSubFailed;
    //holds an assessment thats status is completed.
    private static List<Assessment> assessments;
    /**
     *@Description Queries the AssessmentQuestion object to fetch questions based on the provided category WAPI.This
     *method is used in biPspbWAPIQuestionnaire Lwc component.
     *@Returns a list of AssessmentQuestion records containing the question text, developer name,
     *and active version ID.
     */
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getTheAssesmentQuestion() {
        try {
            // USER_MODE is not used because AssesmentQuestion is an Salesforce Industry object using
            //Healthcare license.
            List<AssessmentQuestion> assessmentQuestions = [
                SELECT Id, QuestionText, DeveloperName, ActiveVersion.Id
                FROM AssessmentQuestion
                WHERE QuestionCategory = :wapiCategory
            ];
            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
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
                BI_PSP_Assessment.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }

    /**
     * @Description method to retrieve assessment questions for the Introduction category.
     * Queries the AssessmentQuestion object to fetch questions specifically for the Introduction category.
     * This method is used in biPspbIntroductionQuestionnaire LWC component.
     * @Returns a list of AssessmentQuestion records containing the question text, developer name, and active version ID.
     */

    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getIntroductionAssesmentQues() {
        try {
            // USER_MODE is not used because AssesmentQuestion is an Salesforce Industry object using
            //Healthcare license.
            List<AssessmentQuestion> assessmentQuestions = [
                SELECT Id, QuestionText, DeveloperName, ActiveVersion.Id
                FROM AssessmentQuestion
                WHERE QuestionCategory = :introduction
            ];
            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
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
                BI_PSP_Assessment.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }

    /**
     *@Description method to retrieve assessment questions for the Psoriasis category.
     *Queries the AssessmentQuestion object to fetch questions specifically for the Psoriasis category.
     *this method is used in biPspbPSSQuestionnaire LWC Component.
     *@ Returns a list of AssessmentQuestion records containing the question text, developer name, and active version ID.
     */

    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getPsoriasisAssesmentQues() {
        try {
            // USER_MODE is not used because AssesmentQuestion is an Salesforce Industry object using
            //Healthcare license.
            List<AssessmentQuestion> assessmentQuestions = [
                SELECT Id, QuestionText, DeveloperName, ActiveVersion.Id
                FROM AssessmentQuestion
                WHERE QuestionCategory = :pss
            ];
            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
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
                BI_PSP_Assessment.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }

    /**
     * @Description method to retrieve assessment questions for the Dermatology category.
     * Queries the AssessmentQuestion object to fetch questions specifically for the Dermatology category.
     * *this method is used in biPspbDLQIquestionnaire LWC Component.
     * @Returns a list of AssessmentQuestion records containing the question text, developer name, and active version ID.
     */

    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getDermatologyAssesmentQues() {
        try {
            // USER_MODE is not used because AssesmentQuestion is an Salesforce Industry object using
            //Healthcare license.
            List<AssessmentQuestion> assessmentQuestions = [
                SELECT Id, QuestionText, DeveloperName, ActiveVersion.Id
                FROM AssessmentQuestion
                WHERE QuestionCategory = :dlqiCategory
            ];
            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
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
                BI_PSP_Assessment.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }

    /**
     *@Description method to retrieve assessment questions for the Qualitative category.
     * Queries the AssessmentQuestion object to fetch questions specifically for the Qualitative category.
     *this method is used in biPspbQSQuestionnaire1,biPspbQSQuestionnaire2 LWC Components.
     *@ Returns a list of AssessmentQuestion records containing the question text, developer name, and active version ID.
     */

    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestion> getQualitativeAssesmentQues() {
        //  assessmentQuestions = new List<AssessmentQuestion>();
        try {
            // USER_MODE is not used because AssesmentQuestion is an Salesforce Industry object using
            //Healthcare license.
            assessmentQuestions = [
                SELECT Id, QuestionText, DeveloperName, ActiveVersion.Id
                FROM AssessmentQuestion
                WHERE QuestionCategory = :qualiCategory
            ];

            if (assessmentQuestions.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
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
                BI_PSP_Assessment.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(questionsNotavilable);
        }
        return assessmentQuestions;
    }

    /*@Description Method for Assessment Response insertion that are related to PSS DLQI AND Wapi Questionnaires.
     *This method is used in biPspbPSSQuestionnaire,biPspbDLQIquestionnaire and biPspbWAPIQuestionnaire LWC components.
     *@param  questionIds of AssessmentQuestion records containing the active version ID.
     *@param responseTexts  Assessment Questions Responses.The responses given by the user.
     */
    @AuraEnabled
    public static void ranswerOfTheQuestion(
        List<String> questionIds,
        List<String> responseTexts
    ) {
        // Step 1: Get the ID of the user performing the insertion
        try {
            String userId = UserInfo.getUserId();
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
                    enrolleeAcount = [
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
                        BI_PSP_Assessment.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolleeAcount.isEmpty()) {
                    // USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object using
                    //Healthcare license.
                    enrolleeRecord = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :enrolleeAcount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),caregiversSelectedpatienterrmsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                }
                if (!enrolleeRecord.isEmpty()) {
                    enrolleeId = enrolleeRecord[0].id;
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
                    enrolledPatient = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_Assessment.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolledPatient.isEmpty()) {
                    enrolleeId = enrolledPatient[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                }
            }

            String activeVersionId;
            //We are checking wether there is any data from the user response for submitting the responses.
            /*i have checked here the responseTexts  too since both has to be there of values beacuse it comes directly from user
             respsonses. */
            if ((!questionIds.isEmpty()) && (!responseTexts.isEmpty())) {
                for (Integer i = 0; i < questionIds.size(); i++) {
                    activeVersionId = questionIds[i];
                }
            } else {
                /*we are logging and throwing this exception since we need to both notify the user in ui level and system level
                 for meaningful information*/
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                System.now(),emptyQuestionaresponse,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                //we need to show the user that the responses are empty.
                throw new AuraHandledException(emptyQuestionaresponse);
            }
            String categoryName;
            if (activeVersionId != null && !String.isBlank(activeVersionId)) {
                listOfAssQuVer = [
                    SELECT Id, QuestionCategory
                    FROM AssessmentQuestion
                    WHERE ActiveVersionId = :activeVersionId
                    LIMIT 1
                ];
            } else {
                /*we are not throwing any exception to the in this null check LWC since we have already done it for questionIds
                 * in which both are related to the Assessment Question record*/
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                System.now(),emptyQuestionversion,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
            }
            if ((!listOfAssQuVer.isEmpty())) {
                for (AssessmentQuestion assVer : listOfAssQuVer) {
                    categoryName = assVer.QuestionCategory;
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                System.now(),emptyQuestionversion,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
            }
            Assessment ass = new Assessment();

            // Step 2: Set the ID of the user performing the insertion
            ass.BI_PSP_CareProgramEnrollee__c = enrolleeId;
            ass.AssessmentStatus = completed;
            ass.Name = categoryName;
            ass.EffectiveDateTime = DateTime.now();
            ass.ExpirationDateTime = DateTime.now().addDays(expireDate);

            Database.SaveResult saveResult = Database.insert(ass, false);
            if (!saveResult.isSuccess()) {
                for (Database.Error error : saveResult.getErrors()) {
                    errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                }
                if (!String.isBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                   
                }
            }

            // Step 3: Get the Assessment ID after insertion
            String assId = ass.Id;
            String assName = ass.Name;
            List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();

            for (Integer i = 0; i < questionIds.size(); i++) {
                String questionId = questionIds[i];
                String responseText = responseTexts[i];

                AssessmentQuestionResponse assRes = new AssessmentQuestionResponse();
                assRes.AssessmentQuestionId = questionId;
                assRes.ResponseText = responseText;
                assRes.AssessmentId = ass.Id;
                assRes.Name = responseText;

                assResList.add(assRes);
            }

            // Insert all records outside of the loop
            if (!assResList.isEmpty()) {
                Database.SaveResult[] responseSaveResults = Database.insert(
                    assResList,
                    false
                );
                for (
                    Database.SaveResult responseSaveResult : responseSaveResults
                ) {
                    if (!responseSaveResult.isSuccess()) {
                        for (Database.Error error : saveResult.getErrors()) {
                            errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                        }
                        if (!String.isBlank(errorMsg)) {
                            BI_SFCOE_LOG_Util.handleDatabaseSaveResults(responseSaveResults,
                                BI_PSP_Assessment.class.toString(),System.now()
                            );
                            // Propagate combined errors after collecting from all records
                        }
                    }
                }
            }
            /* Step 4: If the user tries to create another assessment record with status 'In Progress',
             delete the previously inserted assessment with status 'In Progress'*/
            if (
                (ass.AssessmentStatus == completed) &&
                (assId != null && !String.isBlank(assId))
            ) {
                List<Assessment> previousAssessments = [
                    SELECT Id
                    FROM Assessment
                    WHERE
                        OwnerId = :userId
                        AND AssessmentStatus = :inprogress
                        AND Name = :assName
                ];
                if (!previousAssessments.isEmpty()) {
                    Database.DeleteResult deleteResults = Database.delete(
                        previousAssessments[0],false
                    );

                    if (!deleteResults.isSuccess()) {
                   	  for (Database.Error error : deleteResults.getErrors()) {
                        errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                        }
                        if (!String.isBlank(errorMsg)) {
                            BI_SFCOE_LOG_Util.logMessage(applicationName,
                                BI_PSP_Assessment.class.toString(),'',System.now(),
                                errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                            );
                        }
                    }
                }
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_Assessment.class.toString(),
                null,
                System.now()
            );
            // Propagate combined errors after collecting from all records
            throw new AuraHandledException(assessmentFalied);
        }
    }

    /**
     * @Description AuraEnabled method to insert multiple draft assessment records.
     * Inserts draft assessment records based on the provided draft question IDs and draft response texts.
     * If the user is a caregiver, retrieves the corresponding care program enrollee ID.
     * Sets the assessment status to 'In Progress', assigns the assessment name based on the category,
     * sets the effective and expiration date times, and inserts the assessment record.
     * Inserts assessment question response records for each draft question ID and response text.
     * If an error occurs during insertion, logs the error and returns.
     * If the user attempts to create another assessment with status 'In Progress', deletes the previously
     * inserted assessment.
     * We use this method in biPspbDLQIquestionnaire,biPspbPSSQuestionnaire and biPspbWAPIQuestionnaire LWC Components.
     * @param darftQuestionIds List of draft question IDs.
     * @param draftResponseTexts List of draft response texts.
     */

    @AuraEnabled
    public static void mulitipleDraftRecordsInsertion(
        List<String> darftQuestionIds,
        List<String> draftResponseTexts
    ) {
        try {
            // Step 1: Get the ID of the user performing the inserti
            String userId = UserInfo.getUserId();
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
                    enrolleeAcount = [
                        SELECT id, Name, PersonEmail
                        FROM account
                        WHERE
                            id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                    ];
                } else {
                  BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',System.now(),
                        caregiversPatientaccountErr,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolleeAcount.isEmpty()) {
                    // USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object using
                    //Healthcare license.
                    enrolleeRecord = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :enrolleeAcount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),caregiversSelectedpatienterrmsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }

                if (!enrolleeRecord.isEmpty()) {
                    enrolleeId = enrolleeRecord[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),selctdPatieintsenrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
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
                    // USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object using
                    //Healthcare license.
                    enrolledPatient = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_Assessment.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }

                if (!enrolledPatient.isEmpty()) {
                    enrolleeId = enrolledPatient[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }

            // Step 1: Get the ID of the user performing the insertion
            /*i have checked here the responseTexts  too since both has to be there of values beacuse it comes directly from user
             respsonses. */
            if (
                (!darftQuestionIds.isEmpty()) && (!draftResponseTexts.isEmpty())
            ) {
                for (Integer i = 0; i < darftQuestionIds.size(); i++) {
                    activeVersionId = darftQuestionIds[i];
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                System.now(),emptyQuestionversion,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                throw new AuraHandledException(emptyQuestionaresponse);
            }
            // USER_MODE is not used because AssessmentQuestion is an Salesforce Industry object using
            //Healthcare license.
            listOfAssQuVer = [
                SELECT Id, QuestionCategory
                FROM AssessmentQuestion
                WHERE ActiveVersionId = :activeVersionId
                LIMIT 1
            ];
            if (!listOfAssQuVer.isEmpty()) {
                for (AssessmentQuestion assVer : listOfAssQuVer) {
                    categoryName = assVer.QuestionCategory;
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                System.now(),questionsNotavilable,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
            }

            Assessment ass = new Assessment();
            // Step 2: Set the ID of the user performing the insertion
            ass.BI_PSP_CareProgramEnrollee__c = enrolleeId;
            ass.AssessmentStatus = inprogress;
            ass.Name = categoryName;
            ass.EffectiveDateTime = DateTime.now();
            ass.ExpirationDateTime = DateTime.now().addDays(expireDate);

            Database.SaveResult saveResult = Database.insert(ass, false);
            if (!saveResult.isSuccess()) {
                for (Database.Error error : saveResult.getErrors()) {
                    errorMsg +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
                }
                if (!String.isBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                  
                }
            }

            // Step 3: Get the Assessment ID after insertion
            String assId = ass.Id;
            String catName = ass.Name;
            List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();

            for (Integer i = 0; i < darftQuestionIds.size(); i++) {
                String questionId = darftQuestionIds[i];
                String responseText = draftResponseTexts[i];

                AssessmentQuestionResponse assRes = new AssessmentQuestionResponse();
                assRes.AssessmentQuestionId = questionId;
                assRes.ResponseText = responseText;
                assRes.AssessmentId = ass.Id;
                assRes.Name = responseText;

                assResList.add(assRes);
            }
            //for (Database.Error error : responseSaveResult.getErrors()) {
            // Insert all records outside of the loop
            if (!assResList.isEmpty()) {
                Database.SaveResult[] responseSaveResults = Database.insert(
                    assResList,
                    false
                );
                for (
                    Database.SaveResult responseSaveResult : responseSaveResults
                ) {
                    if (!responseSaveResult.isSuccess()) {
                        for (
                            Database.Error error : responseSaveResult.getErrors()
                        ) {
                            errorMsg +='Error '+error.getFields() +'--' +error.getMessage() +'\n';
                        }
                        if (!String.isBlank(errorMsg)) {
                            BI_SFCOE_LOG_Util.handleDatabaseSaveResults(responseSaveResults,
                                BI_PSP_Assessment.class.toString(),System.now()
                            );
                        }
                    }
                }
            }

            /*Step 4: If the user tries to create another assessment record with status 'In Progress',
             delete the previously inserted assessment with status 'In Progress'.*/
            if (
                (ass.AssessmentStatus == inprogress) &&
                (assId != null && !String.isBlank(assId))
            ) {
                // USER_MODE is not used because Assessment is an Salesforce Industry object using
                //Healthcare license.
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
                        for (Database.Error error : saveResult.getErrors()) {
                            errorMsg +='Error ' +error.getFields() +'--' +
                                error.getMessage() +'\n';
                        }
                        if (!String.isBlank(errorMsg)) {
                            BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                            System.now(),errorMsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                            );
                        }
                    }
                }
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSP_Assessment.class.toString(),
                null,System.now());
            throw new AuraHandledException(assessmentFalied);
        }
    }

    /**
     * @Description AuraEnabled method to retrieve the count of answered questions in a category for a given assessment.
     * Retrieves the category name from the Assessment record based on the provided assessment ID.
     * Retrieves the count of answered questions in the category from the AssessmentQuestionResponse object.
     * We use this method in biPspbPSSCompletedQuestionnaires,biPspbPsoriasisCard,biPspbPSSQuestionnaire,biPspbQSQuestionnaire1,
     * biPspbQSQuestionnaire2,biPspbQualitativeCard,biPspbQualitativeCompletedQuestionnaire,
     * biPspbQualitativeCompletedQuestionnaire2,biPspbWapiCard,biPspbWapiCompletedQuestionnaire,biPspbWAPIQuestionnaire,
     * biPspbIntroductionCard,biPspbIntroductionPageone, biPspbIntroductionPagetwo biPspbIntroductionQuestionnaire,
     * biPspbDlqiCard,biPspbDlqiCompletedQuestionnaire,biPspbDLQIquestionnaire LWC components.
     * @param assessmentId The ID of the assessment
     * @return The count of answered questions in the category
     */

    @AuraEnabled(cacheable=true)
    public static Integer getCategoryStatus(String assessmentId) {
        try {
            // Query to get category from the AssessmentQuestionResponse
            if (assessmentId != null && !String.isBlank(assessmentId)) {
                // USER_MODE is not used because Assessment is an Salesforce Industry object using
                //Healthcare license.
                category = [
                    SELECT Name
                    FROM Assessment
                    WHERE Id = :assessmentId
                    LIMIT 1
                ][0]
                .Name;
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
                    '',
                    System.now(),
                    emptyAssesment,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            // Query to get the count of answered questions in the category
            if (category != null && !String.isBlank(category)) {
                // USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry
                //object using Healthcare license.
                answeredQuestions = [
                    SELECT COUNT()
                    FROM AssessmentQuestionResponse
                    WHERE
                        AssessmentId = :assessmentId
                        AND BI_PSP_Questionnaire_Name__c = :category
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
                    '',
                    System.now(),
                    emptyAssesment,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (answeredQuestions < 0 ) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(emptyQuestionaresponse);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSP_Assessment.class.toString(),
                null,System.now());
            throw new AuraHandledException(emptyCategoryname);
        }
        return answeredQuestions;
    }

    /**
     * @Description AuraEnabled method to retrieve the total count of active questions in a specified category.
     * Retrieves the count of active questions from the AssessmentQuestionVersion object.
     * Filters the questions by the provided category name and status 'Active'.
     * Returns the total count of active questions in the category.
     * We use this method in biPspbPSSQuestionnaire LWC component.
     * @param categoryname The name of the category.
     * @return The total count of active questions in the specified category.
     */

    @AuraEnabled(cacheable=true)
    public static Integer getTotalquestionscount(String categoryname) {
        try {
            // USER_MODE is not used because AssessmentQuestionVersion is an Salesforce Industry
            //object using Healthcare license.
            if (categoryname != null && !String.isBlank(categoryname)) {
                activeQuestionCount = [
                    SELECT COUNT()
                    FROM AssessmentQuestionVersion
                    WHERE
                        status = :active
                        AND AssessmentQuestion.QuestionCategory = :categoryname
                ];
            }
            if (activeQuestionCount < 0 ) {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),
                    '',System.now(),emptyQuestionversion,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                throw new AuraHandledException(emptyQuestionversion);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSP_Assessment.class.toString(),
                null,System.now()
            );
            throw new AuraHandledException(emptyCategoryname);
        }
        return activeQuestionCount;
    }

    /**
     * @Description AuraEnabled method to create a new Assessment record with predefined values.
     * Creates a new Assessment record with AssessmentStatus set to 'Completed'.
     * Name set to 'Introduction', and EffectiveDateTime and ExpirationDateTime set to current time and
     * future expiration date respectively.
     * Inserts the newly created Assessment record into the database.
     * If an exception occurs during the process, it is caught, logged, and handled gracefully.
     * We use this method in All of the Completed Questionnaire Components such as biPspbQualitativeCompletedQuestionnaire2,
     * biPspbQualitativeCompletedQuestionnaire,biPspbWapiCompletedQuestionnaire,biPspbPSSCompletedQuestionnaires,
     * biPspbDlqiCompletedQuestionnaire
     * @return this method returns a list of integers that has the count of number of assessments present for a specific user.
     */

    @AuraEnabled(cacheable=true)
    public static List<Integer> getAssessmentCountsByCurrentUserName() {
        try {
            String currentUserName = UserInfo.getName();
            String currentUserEmail = UserInfo.getUserEmail();
            //We are getting custom field from User Object. Hence we have to use SOQL.
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
                    // USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                    //object using Healthcare license.
                    enrolledPatient = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,
                        BI_PSP_Assessment.class.toString(),'',System.now(),
                        patientAccounterrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolledPatient.isEmpty()) {
                    enrolleeId = enrolledPatient[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,
                        BI_PSP_Assessment.class.toString(),'',System.now(),
                        patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
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
                    enrolleeAcount = [
                        SELECT id, Name, PersonEmail
                        FROM account
                        WHERE
                            id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,
                        BI_PSP_Assessment.class.toString(),'',System.now(),
                        caregiversPatientaccountErr,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolleeAcount.isEmpty()) {
                    // USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                    //object using Healthcare license.
                    enrolleeRecord = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :enrolleeAcount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,
                        BI_PSP_Assessment.class.toString(),'',System.now(),
                        caregiversSelectedpatienterrmsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolleeRecord.isEmpty()) {
                    enrolleeId = enrolleeRecord[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_Assessment.class.toString(),
                        '',
                        System.now(),
                        selctdPatieintsenrolleeerrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            // USER_MODE is not used because Assessment is an Salesforce Industry
            //object using Healthcare license.
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                assessments = [
                    SELECT
                        Id,
                        Name,
                        AssessmentStatus,
                        EffectiveDateTime,
                        ExpirationDateTime
                    FROM Assessment
                    WHERE
                        BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND (AssessmentStatus = :completed
                        OR AssessmentStatus = :expiredLabel)
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
                    '',
                    System.now(),
                    emptyEnrollerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            Map<String, Integer> assessmentCountMap = new Map<String, Integer>{
                'Work & Activity Impairment (WPAI)' => 0,
                'Psoriasis Symptom Scale (PSS)' => 0,
                'Dermatology Life Quality Index (DLQI)' => 0,
                'Qualitative satisfaction questionnaire' => 0
            };
            if (!assessments.isEmpty()) {
                for (Assessment ass : assessments) {
                    if (assessmentCountMap.containsKey(ass.Name)) {
                        assessmentCountMap.put(
                            ass.Name,
                            assessmentCountMap.get(ass.Name) + 1
                        );
                    }
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,
                    BI_PSP_Assessment.class.toString(),'',System.now(),
                    emptyAssesment,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            // Convert the map values to a list
            assessmentCounts = new List<Integer>(assessmentCountMap.values());
            if (assessmentCounts.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(applicationName,
                    BI_PSP_Assessment.class.toString(),'',System.now(),
                    emptyAssesment,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_Assessment.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return assessmentCounts;
    }

    /**
     * @Description Retrieves the counts of completed assessments for the current user.
     * Queries the database for assessments associated with the current user's Care Program Enrollee ID.
     * Counts the number of completed assessments for each predefined assessment type.
     * Returns a list of integers representing the counts of completed assessments for each type.
     * We use this method in All of the Outstanding Questionnaires.In Component such as biPspbIntroductionQuestionnaire,
     * biPspbDLQIquestionnaire,biPspbPSSQuestionnaire,biPspbWAPIQuestionnaire,biPspbQSQuestionnaire1,biPspbQSQuestionnaire2.
     * @return List<Integer> A list of integers representing the counts of completed assessments for each predefined
     * assessment type.
     */
    //Questionnaires
    @AuraEnabled(cacheable=true)
    public static List<Integer> getCompletedAssessmentCountsByCurrentUserName() {
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
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
                if (!patientAccount.isEmpty()) {
                    // USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                    //object using Healthcare license.
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].id
                    ];

                    if (!enrolledPatient.isEmpty()) {
                        enrolleeId = enrolledPatient[0].id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                       	BI_PSP_Assessment.class.toString(),
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
                    enrolleeAcount = [
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
                        BI_PSP_Assessment.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolleeAcount.isEmpty()) {
                    // USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                    //object using Healthcare license.
                    enrolleeRecord = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :enrolleeAcount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),caregiversSelectedpatienterrmsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
                }
                if (!enrolleeRecord.isEmpty()) {
                    enrolleeId = enrolleeRecord[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_Assessment.class.toString(),
                        '',
                        System.now(),
                        selctdPatieintsenrolleeerrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            // USER_MODE is not used because Assessment is an Salesforce Industry
            //object using Healthcare license.
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                assessments = [
                    SELECT
                        Id,
                        Name,
                        AssessmentStatus,
                        EffectiveDateTime,
                        ExpirationDateTime
                    FROM Assessment
                    WHERE
                        BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND AssessmentStatus = :completed
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_Assessment.class.toString(),
                    '',
                    System.now(),
                    emptyEnrollerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            Map<String, Integer> assessmentCountMap = new Map<String, Integer>{
                'Work & Activity Impairment (WPAI)' => 0,
                'Psoriasis Symptom Scale (PSS)' => 0,
                'Dermatology Life Quality Index (DLQI)' => 0,
                'Qualitative satisfaction questionnaire' => 0
            };
            if (!assessments.isEmpty()) {
                for (Assessment ass : assessments) {
                    if (assessmentCountMap.containsKey(ass.Name)) {
                        assessmentCountMap.put(
                            ass.Name,
                            assessmentCountMap.get(ass.Name) + 1
                        );
                    }
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),emptyAssesment,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
            }

            // Convert the map values to a list
            assessmentCounts = new List<Integer>(assessmentCountMap.values());
            if (assessmentCounts.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),emptyAssesment,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(emptyAssesment);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_Assessment.class.toString(),
                null,
                System.now()
            );

            throw new AuraHandledException(emptyAssesment);
        }
        return assessmentCounts;
    }

    /**
     * @Description Retrieves the rollout dates of questionnaires for the current user's care program enrollee.
     * Queries the database for the current user's care program enrollee ID based on whether the user is a caregiver or not.
     * Retrieves the rollout dates of questionnaires associated with the care program enrollee.
     * We use this method in All the Questionnaire Cards in the Outastnding Questionnaire Page.
     * @return List<BI_PSP_Questionnaire_Setups__c> A list of BI_PSP_Questionnaire_Setups__c records containing the rollout
     * dates of questionnaires.
     */

    @AuraEnabled(cacheable=true)
    public static List<BI_PSP_Questionnaire_Setups__c> getRolloutdate() {
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
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
                // USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                //object using Healthcare license.
                if (!patientAccount.isEmpty()) {
                    enrolledPatient = [
                        SELECT id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patientAccount[0].id
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_Assessment.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolledPatient.isEmpty()) {
                    enrolleeId = enrolledPatient[0].id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),patientEnrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
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
                    enrolleeAcount = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiverAccount[0]
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                    ];
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),caregiversPatientaccountErr,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
                if (!enrolleeAcount.isEmpty()) {
                    // USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry
                    //object using Healthcare license.
                    enrolleeRecord = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :enrolleeAcount[0].Id
                    ];
                }
                if (!enrolleeRecord.isEmpty()) {
                    enrolleeId = enrolleeRecord[0].Id;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                        System.now(),selctdPatieintsenrolleeerrormsg,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            if (enrolleeId != null && !String.isBlank(enrolleeId)) {
                /*USER_MODE is not used because we have populated a lookup field thats related to CareProgramEnrollee
                 * which is a Salesforce Industry object using Healthcare license.*/
                questionnairesDate = [
                    SELECT
                        Id,
                        Name,
                        BI_PSP_DLQI_RollOutDate__c,
                        BI_PSP_PSS_RollOutDate__c,
                        BI_PSP_WAI_RollOutDate__c
                    FROM BI_PSP_Questionnaire_Setups__c
                    WHERE BI_PSP_CareProgramEnrollee__c = :enrolleeId
                ];
            }
            if (questionnairesDate.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSP_Assessment.class.toString(),'',
                    System.now(),rolloutDateerrormessage,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_Assessment.class.toString(),
                null,
                System.now()
            );

            throw new AuraHandledException(rolloutDateerrormessage);
        }
        return questionnairesDate;
    }
}