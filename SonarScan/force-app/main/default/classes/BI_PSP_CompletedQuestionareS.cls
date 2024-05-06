/*
@description     :An Apex Class for Retrieving Questionnaire Records those status is in Completed
                  and expired.we are using this apex class in LWCs such as 
				  biPspbQualitativeCompletedQuestionnaire2,  biPspbQualitativeCompletedQuestionnaire,
				  biPspbWapiCompletedQuestionnaire,biPspbPSSCompletedQuestionnaires, 
				  biPspbDlqiCompletedQuestionnaire.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Abinsha		05-Dec-2023		Created			Initial development.
* 1.1		Abinsha 	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha		04-Apr-2024		Updated			Catch log added.
*/

public with sharing class BI_PSP_CompletedQuestionareS {
    //This label states that the logged in user is not in the system.
	private static String undefinedUser = System.Label.BI_PSP_UndefinedUser;
    //this variable holds a list of assessment response records.
    private static List<AssessmentQuestionResponse> listOFres;
    //This variable holds a label that shows error when there is no care program enrollee record.
    private static String emptyEnrolleerecrd = System.Label.BI_PSP_EmptyCareProgramEnrl;
    //This variable holds the category name of the question.
    private static String emptyCategoryname = System.Label.BI_PSP_EmptyCategoryError;
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
    // Static variable to store the Care Program Enrollee ID.
    private static string enrolleeId;
    //variable thats stores the name of Questionnaire Qualiatative Satisfaction Questionnaire(QSQ).
    private static String qualiCategory = System.Label.BI_PSP_QualitativeCategory;
    //vriable that holds the status value in progess of an assessment.
    private static String inprogress = System.Label.BI_PSP_Inprogess;
    // Holds the category label for pageOne.
    private static String pageOne = System.Label.BI_PSP_PageOne;
    // Holds the category label for pageTwo.
    private static String pageTwo = System.Label.BI_PSP_PageTwo;
    //This Variable holds the account details of the patient.
    private static Account patinetAccount;
    //This Variable holds the CareProgramEnrollee record details of the patient.
    private static CareProgramEnrollee enrolledPatient;
    /*this variable holds the information that the current user is a care giver operating on behalf
     of a patient*/
    private static Account caregiversPatient;
    //holds the account information of a patient who is selected by a caregiver.
    private static Account selectedPatient;
    //holds the CareProgramEnrollee record information of a patient who is selected by a caregiver.
    private static CareProgramEnrollee selectedEnrollee;
    //holds the responses of an assessment which got completed or expired.
    private static List<AssessmentQuestionResponse> assessmentResponses;
    // custom label that displays an error message when there is no AssessmnetQuestionResponse Record.
    private static String emptyQuestionaresponse = System.Label.BI_PSP_EmptyQuestionResponse;
    // custom label that displays an error message when there is no Assessmnet Record.
    private static String emptyAssesment = System.Label.BI_PSP_EmptyAssessment;

    /*@Description  we are using this method in LWCs such as  biPspbQualitativeCompletedQuestionnaire2,
     * biPspbQualitativeCompletedQuestionnaire, biPspbWapiCompletedQuestionnaire,biPspbPSSCompletedQuestionnaires,
     biPspbDlqiCompletedQuestionnaire.*/
    // @return A list of AssessmentQuestionResponse records representing completed DLQI questionnaires.
    /* @param targetDate this  is a string vriable that holds a date value in which we are using it to Query the
     *  records related tothat date value.*/
    //@param categoryName  holds the category name of the Questionnaire where user is currently operating in.
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestionResponse> getCompletedQuestionares(
        String targetDate,
        String categoryName
    ) {
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
			 if(currentUser !=null)
            {
            if (currentUser.BI_PSPB_Caregiver__c == false) {
                patinetAccount = [
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
                if (patinetAccount !=null) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patinetAccount.Id
                    ];

                    if (enrolledPatient !=null) {
                        enrolleeId = enrolledPatient.Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiversPatient = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];

                if (caregiversPatient !=null) {
                    selectedPatient = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiversPatient
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (selectedPatient !=null) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedEnrollee = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatient.Id
                        ];

                        if (selectedEnrollee !=null) {
                            enrolleeId = selectedEnrollee.Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            }
             else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						undefinedUser,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
            //list assessments responses
            /* USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object
             using Healthcare license*/
            if (
                (targetDate != null && !String.isBlank(targetDate)) &&
                (categoryName != null && !String.isBlank(categoryName))
            ) {
                assessmentResponses = [
                    SELECT
                        Id,
                        AssessmentId,
                        AssessmentQuestionId,
                        AssessmentQuestion.QuestionText,
                        ResponseText,
                        ResponseValue,
                        BI_PSP_Questionnaire_Name__c,
                        Assessment.Id,
                        Assessment.Name,
                        Assessment.AssessmentStatus,
                        Assessment.EffectiveDateTime,
                        Assessment.BI_PSP_RolloutforCompletedQuestionnarie__c,
                        Assessment.ownerid,
                        BI_PSP_ResponseOrder__c,
                        Assessment.BI_PSP_DateForCQ__c
                    FROM AssessmentQuestionResponse
                    WHERE
                        BI_PSP_Questionnaire_Name__c = :categoryName
                        AND Assessment.AssessmentStatus != :inprogress
                        AND Assessment.BI_PSP_DateForCQ__c = :targetDate
                        AND Assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                    ORDER BY CreatedDate DESC
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyAssesment,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (assessmentResponses.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
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
                BI_PSP_CompletedQuestionareS.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return assessmentResponses;
    }

    /*@Description :Method to retrieve  DLQI questionnaires  Assessment Record.
                We use this method in biPspbDlqiCompletedQuestionnaire LWC component.
    */
    //@param categoryName this vriable holds the name of the Questionnaire category where the user is currently operating in.
    // @return A list of Assessment records representing  DLQI  questionnaires.
    @AuraEnabled(cacheable=true)
    public static List<Assessment> getQstnrcurrentcompleteddate(
        String categoryName
    ) {
        List<Assessment> assessmentResponses = new List<Assessment>();
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
			 if(currentUser !=null)
            {
            if (currentUser.BI_PSPB_Caregiver__c == false) {
                patinetAccount = [
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
                if (patinetAccount !=null) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patinetAccount.Id
                    ];

                    if (enrolledPatient !=null) {
                        enrolleeId = enrolledPatient.Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiversPatient = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];

                if (caregiversPatient !=null) {
                    selectedPatient = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiversPatient
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (selectedPatient !=null) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedEnrollee = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatient.Id
                        ];

                        if (selectedEnrollee !=null) {
                            enrolleeId = selectedEnrollee.Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            }
             else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						undefinedUser,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
            //list assessments responses
            /* USER_MODE is not used because Assessment is an Salesforce Industry object
             using Healthcare license*/
            if (
                (categoryName != null && !String.isBlank(categoryName)) &&
                (enrolleeId != null && !String.isBlank(enrolleeId))
            ) {
                assessmentResponses = [
                    SELECT Id, Name, EffectiveDateTime, ExpirationDateTime
                    FROM Assessment
                    WHERE
                        Name = :categoryName
                        AND BI_PSP_CareProgramEnrollee__c = :enrolleeId
                    ORDER BY CreatedDate DESC
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyCategoryname,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }

            if (assessmentResponses.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyAssesment,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );

                throw new AuraHandledException(emptyAssesment);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_CompletedQuestionareS.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyAssesment);
        }
        return assessmentResponses;
    }

    /*@Description :Method to retrieve completed QSQ questionnaires based on target date.
                We have retrieved the completed assessment record of QSQ whos user is someone
				thats rolled in to the application after two months.
                We use this method in biPspbQualitativeCompletedQuestionnaire2 LWC component.
*/
    // @param targetDate The target date for which completed questionnaires are retrieved.
    // @return A list of AssessmentQuestionResponse records representing completed QSQ questionnaires.
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestionResponse> getQSQcompletedQuestionares1(
        String targetDate
    ) {
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
             if(currentUser !=null)
            {
            if (currentUser.BI_PSPB_Caregiver__c == false) {
                patinetAccount = [
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
                if (patinetAccount !=null) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patinetAccount.Id
                    ];

                    if (enrolledPatient !=null) {
                        enrolleeId = enrolledPatient.Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiversPatient = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];

                if (caregiversPatient !=null) {
                    selectedPatient = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiversPatient
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (selectedPatient !=null) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedEnrollee = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatient.Id
                        ];

                        if (selectedEnrollee !=null) {
                            enrolleeId = selectedEnrollee.Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            }
             else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						undefinedUser,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
            //list assessments responses
            if (
                (targetDate != null && !String.isBlank(targetDate)) &&
                (enrolleeId != null && !String.isBlank(enrolleeId))
            ) {
                /* USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object
                 using Healthcare license*/
                assessmentResponses = [
                    SELECT
                        Id,
                        AssessmentId,
                        AssessmentQuestionId,
                        AssessmentQuestion.QuestionText,
                        ResponseText,
                        ResponseValue,
                        BI_PSP_Questionnaire_Name__c,
                        Assessment.Id,
                        Assessment.Name,
                        Assessment.AssessmentStatus,
                        Assessment.BI_PSP_DateForCQ__c,
                        Assessment.EffectiveDateTime,
                        Assessment.BI_PSP_RolloutforCompletedQuestionnarie__c,
                        BI_PSP_QsqAfter2months__c,
                        BI_PSP_QsqAfterWeeks__c,
                        BI_PSP_ResponseOrder__c
                    FROM AssessmentQuestionResponse
                    WHERE
                        BI_PSP_Questionnaire_Name__c = :qualiCategory
                        AND Assessment.AssessmentStatus != :inprogress
                        AND Assessment.BI_PSP_DateForCQ__c = :targetDate
                        AND BI_PSP_QsqAfter2months__c = :pageOne
                        AND Assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                    ORDER BY CreatedDate DESC, BI_PSP_ResponseOrder__c ASC
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (assessmentResponses.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
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
                BI_PSP_CompletedQuestionareS.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return assessmentResponses;
    }
    /*@Description :Method to retrieve QSQ questionnaires.We have retrieved the completed assessment
                record of QSQ whos user is someone thats rolled in to the application after
				two months.We use this method in biPspbQualitativeCompletedQuestionnaire2 
				LWC component.
*/
    // @return A list of Assessment records representing completed QSQ Expired questionnaires.
    @AuraEnabled(cacheable=true)
    public static List<Assessment> getQSQExpiredQuestionnaire1() {
        List<Assessment> assessmentResponses = new List<Assessment>();
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
			 if(currentUser !=null)
            {
            if (currentUser.BI_PSPB_Caregiver__c == false) {
                patinetAccount = [
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
                if (patinetAccount !=null) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patinetAccount.Id
                    ];

                    if (enrolledPatient !=null) {
                        enrolleeId = enrolledPatient.Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiversPatient = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];

                if (caregiversPatient !=null) {
                    selectedPatient = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiversPatient
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (selectedPatient !=null) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedEnrollee = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatient.Id
                        ];

                        if (selectedEnrollee !=null) {
                            enrolleeId = selectedEnrollee.Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            }
             else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						undefinedUser,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
            // Query AssessmentQuestionResponses records
            /* USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object
             using Healthcare license*/

            listOFres = [
                SELECT Id, BI_PSP_QsqAfterWeeks__c, AssessmentId
                FROM AssessmentQuestionResponse
                WHERE BI_PSP_QsqAfter2months__c = :pageOne
            ];

            // Create a set to store the IDs of AssessmentQuestionResponses records
            Set<Id> responseIds = new Set<Id>();
            if (!listOFres.isEmpty()) {
                for (AssessmentQuestionResponse response : listOFres) {
                    responseIds.add(response.AssessmentId);
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            // Query Assessment records using the IDs of AssessmentQuestionResponses
            /* USER_MODE is not used because Assessment is an Salesforce Industry object
             using Healthcare license*/
            if (
                (enrolleeId != null && !String.isBlank(enrolleeId)) &&
                (responseIds != null && !responseIds.isEmpty())
            ) {
                assessmentResponses = [
                    SELECT Id, Name, EffectiveDateTime, ExpirationDateTime
                    FROM Assessment
                    WHERE
                        Name = :qualiCategory
                        AND Assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND Id IN :responseIds // Filter by the IDs of AssessmentQuestionResponses
                    ORDER BY CreatedDate DESC
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    patientEnrolleeerrormsg,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (assessmentResponses.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyAssesment,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );

                throw new AuraHandledException(emptyAssesment);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_CompletedQuestionareS.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyAssesment);
        }
        return assessmentResponses;
    }
    /*@Description :Method to retrieve completed QSQ questionnaires based on target date.
                We have retrieved the completed assessment record of QSQ whos user is someone
				thats rolled in to the application after 14 weeks.
                We use this method in biPspbQualitativeCompletedQuestionnaire LWC component.
*/
    // @param targetDate The target date for which completed questionnaires are retrieved.
    // @return A list of AssessmentQuestionResponse records representing completed QSQ questionnaires.
    @AuraEnabled(cacheable=true)
    public static List<AssessmentQuestionResponse> getQSQcompletedQuestionaressec(
        String targetDate
    ) {
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
			 if(currentUser !=null)
            {
            if (currentUser.BI_PSPB_Caregiver__c == false) {
                patinetAccount = [
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
                if (patinetAccount !=null) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patinetAccount.Id
                    ];

                    if (enrolledPatient !=null) {
                        enrolleeId = enrolledPatient.Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiversPatient = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];

                if (caregiversPatient !=null) {
                    selectedPatient = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiversPatient
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (selectedPatient !=null) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedEnrollee = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatient.Id
                        ];

                        if (selectedEnrollee !=null) {
                            enrolleeId = selectedEnrollee.Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            }
             else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						undefinedUser,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
            /* USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object
             using Healthcare license*/
            if (
                (targetDate != null && !String.isBlank(targetDate)) &&
                (enrolleeId != null && !String.isBlank(enrolleeId))
            ) {
                assessmentResponses = [
                    SELECT
                        Id,
                        AssessmentId,
                        AssessmentQuestionId,
                        AssessmentQuestion.QuestionText,
                        ResponseText,
                        ResponseValue,
                        BI_PSP_Questionnaire_Name__c,
                        Assessment.Id,
                        Assessment.Name,
                        Assessment.AssessmentStatus,
                        Assessment.BI_PSP_DateForCQ__c,
                        Assessment.EffectiveDateTime,
                        Assessment.BI_PSP_RolloutforCompletedQuestionnarie__c,
                        BI_PSP_QsqAfter2months__c,
                        BI_PSP_QsqAfterWeeks__c,
                        BI_PSP_ResponseOrder__c
                    FROM AssessmentQuestionResponse
                    WHERE
                        BI_PSP_Questionnaire_Name__c = :qualiCategory
                        AND Assessment.AssessmentStatus != :inprogress
                        AND Assessment.BI_PSP_DateForCQ__c = :targetDate
                        AND BI_PSP_QsqAfterWeeks__c = :pageTwo
                        AND Assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                    ORDER BY CreatedDate DESC, BI_PSP_ResponseOrder__c ASC
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (assessmentResponses.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
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
                BI_PSP_CompletedQuestionareS.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyQuestionaresponse);
        }
        return assessmentResponses;
    }

    /*@Description :Method to retrieve  QSQ questionnaires.We have retrieved the completed assessment 
               record of QSQ whos user is someonethats rolled in to the application after 14 weeks.
               We use this method in biPspbQualitativeCompletedQuestionnaire LWC component.
*/
    // @return A list of AssessmentQuestionResponse records representing  QSQ  questionnaires.
    @AuraEnabled(cacheable=true)
    public static List<Assessment> getQSQExpiredQuestionnairesec() {
        List<Assessment> assessmentResponses = new List<Assessment>();
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
			 if(currentUser !=null)
            {
            if (currentUser.BI_PSPB_Caregiver__c == false) {
                patinetAccount = [
                    SELECT id, Name, PersonEmail
                    FROM account
                    WHERE
                        PersonEmail = :currentUserEmail
                        AND Name = :currentUserName
                    WITH USER_MODE
                ];
                if (patinetAccount !=null) {
                    /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                     using Healthcare license*/
                    enrolledPatient = [
                        SELECT Id, Name
                        FROM CareProgramEnrollee
                        WHERE AccountID = :patinetAccount.Id
                    ];

                    if (enrolledPatient !=null) {
                        enrolleeId = enrolledPatient.Id;
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        patientAccounterrormsg,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            } else if (currentUser.BI_PSPB_Caregiver__c == true) {
                caregiversPatient = [
                    SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
                    FROM Account
                    WHERE
                        Name = :currentUserName
                        AND PersonEmail = :currentUserEmail
                        AND IsPersonAccount = TRUE
                        AND BI_PSPB_Selected_Patient_ID__c != NULL
                    WITH USER_MODE
                ];

                if (caregiversPatient !=null) {
                    selectedPatient = [
                        SELECT Id, Name, PersonEmail
                        FROM Account
                        WHERE
                            Id = :caregiversPatient
                                .BI_PSPB_Selected_Patient_ID__c
                        WITH USER_MODE
                        LIMIT 1
                    ];

                    if (selectedPatient !=null) {
                        /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
                         using Healthcare license*/
                        selectedEnrollee = [
                            SELECT Id, Name
                            FROM CareProgramEnrollee
                            WHERE AccountID = :selectedPatient.Id
                        ];

                        if (selectedEnrollee !=null) {
                            enrolleeId = selectedEnrollee.Id;
                        }
                    }
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSP_CompletedQuestionareS.class.toString(),
                        '',
                        System.now(),
                        caregiversPatientaccountErr,
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                }
            }
            }
             else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSP_LetsPersonlise.class.toString(),
						'',
						System.now(),
						undefinedUser,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
            /* USER_MODE is not used because AssessmentQuestionResponse is an Salesforce Industry object
             using Healthcare license*/

            listOFres = [
                SELECT Id, BI_PSP_QsqAfterWeeks__c, AssessmentId
                FROM AssessmentQuestionResponse
                WHERE BI_PSP_QsqAfterWeeks__c = :pageTwo
            ];

            // Create a set to store the IDs of AssessmentQuestionResponses records
            Set<Id> responseIds = new Set<Id>();
            if (!listOFres.isEmpty()) {
                for (AssessmentQuestionResponse response : listOFres) {
                    responseIds.add(response.AssessmentId);
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyQuestionaresponse,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            // Query Assessment records using the IDs of AssessmentQuestionResponses
            /* USER_MODE is not used because CareProgramEnrollee is an Salesforce Industry object
             using Healthcare license*/
            if (
                (enrolleeId != null && !String.isBlank(enrolleeId)) &&
                (responseIds != null && !responseIds.isEmpty())
            ) {
                assessmentResponses = [
                    SELECT Id, Name, EffectiveDateTime, ExpirationDateTime
                    FROM Assessment
                    WHERE
                        Name = :qualiCategory
                        AND Assessment.BI_PSP_CareProgramEnrollee__c = :enrolleeId
                        AND Id IN :responseIds // Filter by the IDs of AssessmentQuestionResponses
                    ORDER BY CreatedDate DESC
                ];
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyEnrolleerecrd,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
            }
            if (assessmentResponses.isEmpty()) {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSP_CompletedQuestionareS.class.toString(),
                    '',
                    System.now(),
                    emptyAssesment,
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );

                throw new AuraHandledException(emptyAssesment);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSP_CompletedQuestionareS.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(emptyAssesment);
        }
        return assessmentResponses;
    }
}