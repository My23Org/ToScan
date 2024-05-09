/*
* @description This class is used to generate personalized messages based on
 Let's Personalize questionnaires and to retrieve personalized articles based on questionnaire responses.
The Account object do not have USER_MODE enabled due to their lookup relationship with Health Cloud objects.
* History:
* Version	Author			Date			Detail				Description
* 1.0		Gokul Krishnan	05-Nov-2023		Created				Initial development
* 1.1		Gokul Krishnan 	05-Feb-2024		Updated				Updated the patient status retrieve
* 1.2		Gokul Krishnan	04-Apr-2024		Updated				Catch log added
*/

public with sharing class BI_PSPB_PersonalizedMessagesCtrl {
	// Care program Enrolle Id of patient
	private static string careProgramEnrolleId;
	// Status of patient
	private static String statusOfPatient;
	// To retrieve the current user name and user email
	private static String currentUserName = UserInfo.getName();
	private static String currentUserEmail = UserInfo.getUserEmail();
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
	private static string applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	// General messages category custom label
	private static String generalmessagecategory = System.Label.BI_PSPB_messageCategoryOne;
	private static String mondayFridayCategory = System.Label.BI_PSP_MondayFridayMessageCategory;

	// Custom label for patient status
	private static String chronicStatus = System.Label.BI_PSPB_statusChronic;
	private static String acuteStatus = System.Label.BI_PSPB_Acute;
	// Custom label for articles
	// What is GPP?
	private static String articleOne = System.Label.BI_PSPB_articleOne;
	// Important facts about GPP
	private static String articleTwo = System.Label.BI_PSPB_articleTwo;
	// How rare is GPP?
	private static String articleThree = System.Label.BI_PSPB_articleThree;
	// Why do I have GPP?
	private static String articleFour = System.Label.BI_PSPB_articleFour;
	// Diagnosis and acceptance of GPP
	private static String articleFive = System.Label.BI_PSPB_articleFive;
	// Is GPP contagious?
	private static String articleSix = System.Label.BI_PSPB_articleSix;
	// Talking to friends and family
	private static String articleSeven = System.Label.BI_PSPB_articleSeven;
	// Feeling misunderstood and excluded
	private static String articleEight = System.Label.BI_PSPB_articleEight;
	// GPP and intimacy
	private static String articleNine = System.Label.BI_PSPB_articleNine;
	// GPP and pregnancy
	private static String articleTen = System.Label.BI_PSPB_articleTen;
	// How to manage a flare
	private static String articleEleven = System.Label.BI_PSPB_articleEleven;
	// GPP and comorbidities
	private static String articleTwelve = System.Label.BI_PSPB_articleTwelve;
	// How to manage your GPP symptoms
	private static String articleThirteen = System.Label.BI_PSPB_articleThirteen;
	// What to ask your doctor
	private static String articleFourteen = System.Label.BI_PSPB_articleFourteen;
	// When to seek medical care
	private static String articleFifteen = System.Label.BI_PSPB_articleFifteen;
	// When to seek emergency treatment
	private static String articleSixteen = System.Label.BI_PSPB_articleSixteen;
	// Managing your scars
	private static String articleSeventeen = System.Label.BI_PSPB_articleSeventeen;
	// How to avoid complications with GPP
	private static String articleEighteen = System.Label.BI_PSPB_articleEighteen;
	// Recognizing flares
	private static String articleNineteen = System.Label.BI_PSPB_articleNineteen;
	// Being prepared for a visit to your doctor
	private static String articleTwenty = System.Label.BI_PSPB_articleTwenty;
	// Teaming up with your dermatologist
	private static String articleTwentyOne = System.Label.BI_PSPB_articleTwentyOne;
	// How to talk about GPP
	private static String articleTwentyTwo = System.Label.BI_PSPB_articleTwentyTwo;
	// You're not alone
	private static String articleTwentyThree = System.Label.BI_PSPB_articleTwentyThree;
	// Making positive choices
	private static String articleTwentyFour = System.Label.BI_PSPB_articleTwentyFour;
	// Treating GPP flares with Spevigo®
	private static String articleTwentyFive = System.Label.BI_PSPB_articleTwentyFive;
	// SPEVIGO® (spesolimab) infusion: Patient guide on dosing and administration
	private static String articleTwentySix = System.Label.BI_PSPB_articleTwentySix;
	// Prevention of GPP flares with Spevigo®
	private static String articleTwentySeven = System.Label.BI_PSPB_articleTwentySeven;
	// SPEVIGO® (spesolimab) subcutaneous injection: Patient guide on dosing and administration
	private static String articleTwentyEight = System.Label.BI_PSPB_articleTwentyEight;
	// Spevigo®: How does it work in GPP?
	private static String articleTwentyNine = System.Label.BI_PSPB_articleTwentyNine;

	// Custom label for response
	private static String maybeResponse = System.Label.BI_PSP_maybe;
	private static String noResponse = System.Label.BI_PSP_no;
	private static String yesResponse = System.Label.BI_PSP_yes;

	// Custom label for message categories
	private static String managementCategory = System.Label.BI_PSPB_messageCategoryThree;
	private static String mentalHealthCategory = System.Label.BI_PSPB_messageCategoryFour;
	private static String socialLifeCategory = System.Label.BI_PSPB_messageCategoryTwo;
	private static String healthyLifeStyleCategory = System.Label.BI_PSPB_messageCategoryFive;

	// Custom label for personalize questions
	// Do you often discuss GPP with your friends and family?
	private static String questionOne = System.Label.BI_PSP_PersonalizeQuestionOne;
	// What aspects of your life have been affected by GPP?
	private static String questionTwo = System.Label.BI_PSP_PersonalizeQuestionTwo;
	// Do you have other medical conditions?
	private static String questionThree = System.Label.BI_PSP_PersonalizeQuestionThree;
	// I have a complete understanding of my Generalized pustular psoriasis (GPP).
	private static String questionFour = System.Label.BI_PSP_PersonalizeQuestionFour;
	// I feel confident about recognizing GPP flares.
	private static String questionFive = System.Label.BI_PSP_PersonalizeQuestionFive;
	// I can manage my GPP flares.
	private static String questionSix = System.Label.BI_PSP_PersonalizeQuestionSix;
	// I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP.
	private static String questionSeven = System.Label.BI_PSP_PersonalizeQuestionSeven;
	// I am not good at talking to my physician about my GPP.
	private static String questionEight = System.Label.BI_PSP_PersonalizeQuestionEight;
	// I rely only on my physician to manage my GPP.
	private static String questionNine = System.Label.BI_PSP_PersonalizeQuestionNine;
	// I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.
	private static String questionTen = System.Label.BI_PSP_PersonalizeQuestionTen;
	// GPP is affecting my mental health (e.g. leading to depression and/or anxiety).
	private static String questionEleven = System.Label.BI_PSP_PersonalizeQuestionEleven;
	// I have required support at home from my family members and/or caregiver to manage my GPP condition.
	private static String questionTwelve = System.Label.BI_PSP_PersonalizeQuestionTwelve;
	// I am able to afford my GPP treatment
	private static String questionThirteen = System.Label.BI_PSP_PersonalizeQuestionThirteen;
	// How Long you have been diagnosed with Generalized Pustular Psoriasis (GPP)?
	private static String questionFourteen = System.Label.BI_PSP_PersonalizeQuestionFourteen;
	// What is your gender?
	private static String questionFifteen = System.Label.BI_PSP_PersonalizeQuestionFifteen;

	// Custom label for question response
	private static String relationshipWithFriends = System.Label.BI_PSP_relationshipwith_ff;
	private static String relationshipWithPartner = System.Label.BI_PSP_relationshipwith_partner;
	private static String selfEsteen = System.Label.BI_PSP_selfesteem;
	private static String female = System.Label.BI_PSP_female;
	private static String male = System.Label.BI_PSP_male;
	private static String other = System.Label.BI_PSP_other;
	private static String preferNotToSay = System.Label.BI_PSP_prefernot_tosay;
	private static String lessThanMonth = System.Label.BI_PSP_lessthan_a_month;
	private static String moreThanYear = System.Label.BI_PSP_morethanyear;
	private static String sixMonths = System.Label.BI_PSP_sixmonths;
	private static String lessThanYear = System.Label.BI_PSP_lessthanyear;

	// Assessment query custom label
	private static String completeStatus = System.Label.BI_PSP_Complete;
	private static String introductionquestionaire = System.Label.BI_PSP_introductionCategory;
	private static String letsPersonalizeQuestionaire = System.Label.BI_PSP_LetsPersonalizeIntroductionQuestionaire;
	private static String friday = System.Label.BI_PSP_Friday;
	private static String monday = System.Label.BI_PSP_Monday;
	private static String mon = System.Label.BI_PSP_Mon;
	private static String fri = System.Label.BI_PSP_Fri;

	// Custom Error label
	private static String errorPersonalizedMessagesRetrieve = System.Label.BI_PSP_NoPersonalizedmessagesFound;
	private static String errorNoUserFound = System.Label.BI_PSP_NoUserFound;
	private static String errorNoAssessment = System.Label.BI_PSP_NoLetsPersonalizeAssessment;
	private static String errorRetrievePersonalizedArticles = 
	System.Label.BI_PSPB_ErrorRetrievePersonalizedArticles;
	private static String errorForAccount = System.Label.BI_PSPB_Error_For_Account;
	private static String caregiverNullError = System.Label.BI_PSPB_CaregiverNullError;
	private static String enrolleNotFoundError = System.Label.BI_PSP_Enrollee_NF_NS;

	/*
 * @description   Get the personalized messages by given category
  				  return in lwc biPspbcontentmessage, biPspbWelcomeAvatar
 * @param         categoryval - String indicating the category of messages to retrieve
 * @return        List<String> - List of personalized messages for the specified category
 */

	@AuraEnabled(cacheable=true)
	public static List<String> getCategoryMessages(String categoryval) {
		try {
			if (String.isBlank(categoryval)) {
				List<String> generalmessages = new List<String>();
				List<BI_PSP_Personalized_messages__c> messages = [
					SELECT BI_PSP_Message_body__c
					FROM BI_PSP_Personalized_messages__c
					WHERE BI_PSP_Category__c = :generalmessagecategory
					WITH USER_MODE
				];

				for (BI_PSP_Personalized_messages__c message : messages) {
					generalmessages.add(message.BI_PSP_Message_body__c);
				}
				return generalmessages;
			} else {
				List<String> generalmessages = new List<String>();

				List<BI_PSP_Personalized_messages__c> messages = [
					SELECT BI_PSP_Message_body__c
					FROM BI_PSP_Personalized_messages__c
					WHERE BI_PSP_Category__c = :categoryval
					WITH USER_MODE
				];

				for (BI_PSP_Personalized_messages__c message : messages) {
					generalmessages.add(message.BI_PSP_Message_body__c);
				}
				if (!generalmessages.isEmpty()) {
					return generalmessages;
				} else {
					throw new AuraHandledException(
						errorPersonalizedMessagesRetrieve
					);
				}
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorPersonalizedMessagesRetrieve);
		}
	}

	/*
	* @Description   Get personalized messages for the current user based on assessments and the day of the week
					 return in lwc biPspbWelcomeAvatar
	* @Return        List<String> containing personalized messages
	*/

	@AuraEnabled(cacheable=true)
	public static List<String> fetchPersonalizedMessages() {
		try {
			Id careProgramRecordId = BI_PSPB_PersonalizedMessagesCtrl.getCareProgramEnrolleId();
			// User mode is not enabled because Assessment is health cloud object
			List<Assessment> assessments = [
				SELECT Id, Name
				FROM Assessment
				WHERE
					BI_PSP_CareProgramEnrollee__c = :careProgramRecordId
					AND (BI_PSP_Questionnaire_type__c = :letsPersonalizeQuestionaire
					OR Name = :introductionquestionaire)
					AND BI_PSP_StatusForPersonalization__c = :completeStatus
				LIMIT 1
			];
			List<String> finalpersonalisedmessage = new List<String>();
			if (!assessments.isEmpty()) {
				DateTime todayDate = (DateTime) System.now();
				String dayOfWeek = todayDate.format('E');

				if (dayOfWeek == fri || dayOfWeek == mon) {
					List<String> finalpersonalisedmessagedays = new List<String>();

					List<BI_PSP_Personalized_messages__c> daymessages = [
						SELECT BI_PSP_Message_body__c
						FROM BI_PSP_Personalized_messages__c
						WHERE BI_PSP_Category__c = :mondayFridayCategory
						WITH USER_MODE
					];

					for (
						BI_PSP_Personalized_messages__c message : daymessages
					) {
						if (
							dayOfWeek == fri &&
							message.BI_PSP_Message_body__c.contains(friday)
						) {
							finalpersonalisedmessagedays.add(
								message.BI_PSP_Message_body__c
							);
						}
						if (
							dayOfWeek == mon &&
							message.BI_PSP_Message_body__c.containsIgnoreCase(
								monday
							)
						) {
							finalpersonalisedmessagedays.add(
								message.BI_PSP_Message_body__c
							);
						}
					}
					return finalpersonalisedmessagedays;
				} else {
					// User mode is not enabled because AssessmentQuestionResponse is health cloud object
					List<AssessmentQuestionResponse> assessmentresponse = [
						SELECT
							Name,
							ResponseText,
							BI_PSP_Category__c,
							AssessmentQuestion.Name,
							AssessmentQuestion.QuestionText
						FROM AssessmentQuestionResponse
						WHERE AssessmentId = :assessments[0].id
					];
					// User mode is not enabled because AssessmentQuestionResponse is health cloud object
					List<AssessmentQuestionResponse> re = [
						SELECT AssessmentQuestionId
						FROM AssessmentQuestionResponse
						WHERE AssessmentId = :assessments[0].id
					];
					Set<Id> assessmentQuestionIds = new Set<Id>();
					for (AssessmentQuestionResponse response : re) {
						assessmentQuestionIds.add(
							response.AssessmentQuestionId
						);
					}
					Integer n = 0;
					Set<String> filteredResponses = new Set<String>();
					for (
						AssessmentQuestionResponse response : assessmentresponse
					) {
						String questionName = response.AssessmentQuestion.QuestionText;
						n = n + 1;
						String answer = response.ResponseText;
						/* A deeply nested if statement has been implemented according to our business 
						requirements to check the questionnaire response. */
						// Categorize responses based on each question
						if (questionName == questionOne) {
							if (answer == noResponse) {
								filteredResponses.add(socialLifeCategory);
							}
						} else if (questionName == questionTwo) {
							if (
								answer.contains(relationshipWithFriends) ||
								answer.contains(relationshipWithPartner) ||
								answer.contains(selfEsteen)
							) {
								filteredResponses.add(socialLifeCategory);
							}
						} else if (questionName == questionFour) {
							if (
								answer == noResponse ||
								answer == maybeResponse
							) {
								filteredResponses.add(managementCategory);
							}
						} else if (questionName == questionFive) {
							if (
								answer == noResponse ||
								answer == maybeResponse
							) {
								filteredResponses.add(managementCategory);
							}
						} else if (questionName == questionSix) {
							if (
								answer == noResponse ||
								answer == maybeResponse
							) {
								filteredResponses.add(managementCategory);
							}
						} else if (questionName == questionSeven) {
							if (answer == noResponse) {
								filteredResponses.add(managementCategory);
							}
						} else if (questionName == questionEight) {
							if (answer == yesResponse) {
								filteredResponses.add(managementCategory);
							}
						} else if (questionName == questionNine) {
							if (answer == noResponse) {
								filteredResponses.add(managementCategory);
							}
						} else if (questionName == questionTen) {
							if (
								answer == yesResponse ||
								answer == maybeResponse
							) {
								filteredResponses.add(healthyLifeStyleCategory);
							}
						} else if (questionName == questionEleven) {
							if (answer == yesResponse) {
								filteredResponses.add(mentalHealthCategory);
							}
						} else if (questionName == questionTwelve) {
							if (answer == noResponse) {
								filteredResponses.add(socialLifeCategory);
							}
						} else if (questionName == questionThirteen) {
							// Handle 'NA' or other conditions if needed
							if (answer == '') {
								filteredResponses.add(
									response.BI_PSP_Category__c
								);
							}
						}
					}
					List<BI_PSP_Personalized_messages__c> personalizedMessages = [
						SELECT BI_PSP_Message_body__c
						FROM BI_PSP_Personalized_messages__c
						WHERE BI_PSP_Category__c IN :filteredResponses
						WITH USER_MODE
					];
					for (
						BI_PSP_Personalized_messages__c pers : personalizedMessages
					) {
						finalpersonalisedmessage.add(
							pers.BI_PSP_Message_body__c
						);
					}

					return finalpersonalisedmessage;
				}
			}
			return finalpersonalisedmessage;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorNoAssessment);
		}
	}

	/*
	* @description    Retrieve personalized articles for the current user based on assessments and their responses.
					  return in lwc biPspbArticlesForDashboard, biPspbcategoryarticlecmp
	* @Return         List<String> containing personalized articles
	*/

	@AuraEnabled(cacheable=true)
	public static List<String> getpersonalizedarticles() {
		try {
			Id careProgramRecordId = BI_PSPB_PersonalizedMessagesCtrl.getCareProgramEnrolleId();
			// User mode is not enabled because Assessment is health cloud object
			List<Assessment> assessments = [
				SELECT Id, Name
				FROM Assessment
				WHERE
					BI_PSP_CareProgramEnrollee__c = :careProgramRecordId
					AND (BI_PSP_Questionnaire_type__c = :letsPersonalizeQuestionaire
					OR Name = :introductionquestionaire)
					AND BI_PSP_StatusForPersonalization__c = :completeStatus
				LIMIT 1
			];

		if (!assessments.isEmpty()) {
			// User mode is not enabled because AssessmentQuestionResponse is health cloud object
			List<AssessmentQuestionResponse> assessmentresponse = [
					SELECT
						Name,
						ResponseText,
						BI_PSP_Category__c,
						AssessmentQuestion.Name,
						AssessmentQuestion.QuestionText,
						AssessmentQuestionId
					FROM AssessmentQuestionResponse
					WHERE AssessmentId = :assessments[0].id
				];
				// User mode is not enabled because CareProgramEnrollee is health cloud object
				List<CareProgramEnrollee> careProgramEnrolleeRecord = [
					SELECT BI_PSPB_PatientStatus__c
					FROM CareProgramEnrollee
					WHERE Id = :careProgramRecordId
					LIMIT 1
				];
				if (!careProgramEnrolleeRecord.isEmpty()) {
					statusOfPatient = careProgramEnrolleeRecord[0]
						.BI_PSPB_PatientStatus__c;
				}
				Integer responsefound = 0;
				// User mode is not enabled because AssessmentQuestionResponse is health cloud object
				List<AssessmentQuestionResponse> re = [
					SELECT AssessmentQuestionId
					FROM AssessmentQuestionResponse
					WHERE AssessmentId = :assessments[0].id
				];
				Set<Id> assessmentQuestionIds = new Set<Id>();
				for (AssessmentQuestionResponse response : re) {
					assessmentQuestionIds.add(response.AssessmentQuestionId);
				}

				Set<String> negativeResponses = new Set<String>();
				Set<String> positiveResponses = new Set<String>();
				Integer postivefound = 0;
				Integer negativefound = 0;
				Integer po = 0;
				Integer ne = 0;

				for (AssessmentQuestionResponse response : assessmentresponse) {
					String questionName = response.AssessmentQuestion.QuestionText;
					po = po + 1;
					String answer = response.ResponseText;
					/* A deeply nested if statement has been implemented according to our business
					 requirements to check the questionnaire response.*/
					if (questionName == questionFifteen) {
						if (
							answer == female ||
							answer == other ||
							answer == preferNotToSay
						) {
							negativeResponses.add(articleTen);
						}
						if (answer == male) {
							postivefound = 0;
						}
					} else if (questionName == questionOne) {
						if (answer == noResponse) {
							negativeResponses.add(articleSeven);
						} else {
							postivefound = 0;
						}
					} else if (questionName == questionTwo) {
						responsefound = 1;

						if (
							answer.containsIgnoreCase(relationshipWithFriends)
						) {
							negativeResponses.add(articleTwentyTwo);
						}

						if (
							answer.containsIgnoreCase(relationshipWithPartner)
						) {
							negativeResponses.add(articleNine);
						}
						if (answer.containsIgnoreCase(selfEsteen)) {
							negativeResponses.add(articleSeventeen);
						}
						if (answer == '') {
							negativeResponses.add('');
						}
					} else if (questionName == questionThree) {
						if (answer == yesResponse) {
							negativeResponses.add(articleTwelve);
						} else if (answer == noResponse) {
							postivefound = 0;
						}
					} else if (questionName == questionFour) {
						if (answer == noResponse) {
							negativeResponses.add(articleOne);
							negativeResponses.add(articleFifteen);
						}

						if (answer == maybeResponse) {
							negativeResponses.add(articleTwo);
							negativeResponses.add(articleSixteen);
						}
						if (answer == yesResponse) {
							postivefound = 0;
						}
					} else if (questionName == questionFive) {
						if (answer == noResponse) {
							negativeResponses.add(articleNineteen);
						}
						if (answer == maybeResponse) {
							negativeResponses.add(articleThirteen);
						}
						if (answer == yesResponse) {
							postivefound = 0;
						}
					} else if (questionName == questionSix) {
						if (answer == noResponse) {
							negativeResponses.add(articleEleven);
						}
						if (answer == maybeResponse) {
							negativeResponses.add(articleEighteen);
						}
						if (answer == yesResponse) {
							postivefound = 0;
						}
					} else if (questionName == questionSeven) {
						if (answer == noResponse || answer == maybeResponse) {
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									negativeResponses.add(articleTwentySeven);
									negativeResponses.add(articleTwentyEight);
									negativeResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									negativeResponses.add(articleTwentyFive);
									negativeResponses.add(articleTwentySix);
									negativeResponses.add(articleTwentyNine);
								}
							} else {
								negativeResponses.add(articleTwentySeven);
								negativeResponses.add(articleTwentyEight);
								negativeResponses.add(articleTwentyNine);
							}
						}
						if (answer == yesResponse) {
							postivefound = 0;
						}
					} else if (questionName == questionEight) {
						if (answer == yesResponse || answer == maybeResponse) {
							negativeResponses.add(articleFourteen);
							negativeResponses.add(articleTwenty);
						}
						if (answer == noResponse) {
							postivefound = 0;
						}
					} else if (questionName == questionNine) {
						if (answer == noResponse || answer == maybeResponse) {
							negativeResponses.add(articleTwentyOne);
						}
						if (answer == yesResponse) {
							postivefound = 0;
						}
					} else if (questionName == questionTen) {
						if (answer == yesResponse || answer == maybeResponse) {
							negativeResponses.add(articleTwentyFour);
						}
						if (answer == noResponse) {
							postivefound = 0;
						}
					} else if (questionName == questionEleven) {
						if (answer == yesResponse) {
							negativeResponses.add(articleEight);
						}

						if (answer == maybeResponse) {
							negativeResponses.add(articleTwentyThree);
						}
						if (answer == noResponse) {
							postivefound = 0;
						}
					} else if (questionName == questionTwelve) {
						if (answer == noResponse || answer == maybeResponse) {
							negativeResponses.add(articleSeven);
						}
						if (answer == yesResponse) {
							postivefound = 0;
						}
					}
				}

				//get positive response from assessment
				for (AssessmentQuestionResponse response : assessmentresponse) {
					String questionName = response.AssessmentQuestion.QuestionText;
					ne = ne + 1;
					String answer = response.ResponseText;
					/* A deeply nested if statement has been implemented according to 
					our business requirements to check the questionnaire response. */
					if (questionName == questionFourteen) {
						if (answer == lessThanMonth) {
							positiveResponses.add(articleFour);
						} else if (answer == moreThanYear) {
							positiveResponses.add(articleTwentyThree);
						} else if (answer == sixMonths) {
							positiveResponses.add(articleFive);
						} else if (answer == lessThanYear) {
							positiveResponses.add(articleTwo);
						}
					} else if (questionName == questionFifteen) {
						if (
							answer == female ||
							answer == other ||
							answer == preferNotToSay
						) {
							negativefound = 1;
						}
					} else if (questionName == questionTwo) {
						responsefound = 1;

						if (
							answer.containsIgnoreCase(relationshipWithFriends)
						) {
							negativefound = 1;
						}

						if (
							answer.containsIgnoreCase(relationshipWithPartner)
						) {
							negativefound = 1;
						}
						if (answer.containsIgnoreCase(selfEsteen)) {
							negativefound = 1;
						}
						if (answer == '') {
							negativeResponses.add('');
						}
					} else if (questionName == questionThree) {
						if (answer == yesResponse) {
							negativefound = 1;
						}
						if (answer == noResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
							positiveResponses.add(articleThree);
						}
                        
					} else if (questionName == questionFour) {
						if (answer == noResponse || answer == maybeResponse) {
							negativefound = 1;
						}
					} else if (questionName == questionOne) {
						if (answer == noResponse) {
							negativefound = 1;
						}
						if (answer == yesResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
						}
					} else if (questionName == questionFive) {
						if (answer == noResponse || answer == maybeResponse) {
							negativefound = 1;
						}

						if (answer == yesResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
						}
					} else if (questionName == questionSix) {
						if (answer == noResponse) {
							negativefound = 1;
						}
						if (answer == yesResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
							positiveResponses.add(articleFifteen);
						}
						if (answer == maybeResponse) {
							negativefound = 1;
						}
					} else if (questionName == questionSeven) {
						if (answer == noResponse || answer == maybeResponse) {
							negativefound = 1;
						}
						if (answer == yesResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
						}
					} else if (questionName == questionEight) {
						if (answer == yesResponse || answer == maybeResponse) {
							negativefound = 1;
						}
						if (answer == noResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
							positiveResponses.add(articleFourteen);
						}
					} else if (questionName == questionNine) {
						if (answer == noResponse || answer == maybeResponse) {
							negativefound = 1;
						} else if (answer == yesResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
							positiveResponses.add(articleTwentyOne);
						}
					} else if (questionName == questionTen) {
						if (answer == yesResponse || answer == maybeResponse) {
							negativefound = 1;
						} else if (answer == noResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
							positiveResponses.add(articleTwentyFour);
						}
					} else if (questionName == questionEleven) {
						if (answer == yesResponse) {
							negativefound = 1;
						}

						if (answer == maybeResponse) {
							negativefound = 1;
						}

						if (answer == noResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
						}
					} else if (questionName == questionTwelve) {
						if (answer == noResponse || answer == maybeResponse) {
							negativefound = 1;
						}
						if (answer == yesResponse) {
							positiveResponses.add(articleFifteen);
							positiveResponses.add(articleTwentyOne);
							positiveResponses.add(articleTwentyFour);
							positiveResponses.add(articleThree);
							if (statusOfPatient != null) {
								if (statusOfPatient == chronicStatus) {
									positiveResponses.add(articleTwentySeven);
									positiveResponses.add(articleTwentyEight);
									positiveResponses.add(articleTwentyNine);
								} else if (statusOfPatient == acuteStatus) {
									positiveResponses.add(articleTwentyFive);
									positiveResponses.add(articleTwentySix);
									positiveResponses.add(articleTwentyNine);
								}
							} else {
								positiveResponses.add(articleTwentySeven);
								positiveResponses.add(articleTwentyEight);
								positiveResponses.add(articleTwentyNine);
							}
						}
					}
				}

				if (negativefound == 0) {
					if (responsefound == 0) {
						positiveResponses.add(articleSix);
					}
					List<String> stringList = new List<String>(
						positiveResponses
					);
					return stringList;
				} else {
					List<String> stringList = new List<String>(
						negativeResponses
					);

					return stringList;
				}
			} else {
				return new List<String>(); 
				/* The absence of an assessment record will not result 
				in an error when accessing personalized articles. */
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorRetrievePersonalizedArticles);
		}
	}

	/*
	* @Description      Retrieve Assessment records based on the current user (caregiver or patient)
						return in lwc biPspbarticlecontentpage, biPspbarticlenavlinksearch,
						 biPspbarticlenavlinkspage, biPspbcategoryarticlecmp, biPspbInformationcenterlanding,
						biPspbsearcharticlecmp
	* @Return           List<Assessment> containing Assessment records
	*/
	@AuraEnabled(cacheable=true)
	public static List<Assessment> retrieveAssessmentRecordsForCurrentUser() {
		try {
			Id careProgramRecordId = BI_PSPB_PersonalizedMessagesCtrl.getCareProgramEnrolleId();
			// User mode is not enabled because Assessment is health cloud object
			List<Assessment> assessments = [
				SELECT Id, Name
				FROM Assessment
				WHERE
					BI_PSP_CareProgramEnrollee__c = :careProgramRecordId
					AND (BI_PSP_Questionnaire_type__c = :letsPersonalizeQuestionaire
					OR Name = :introductionquestionaire)
					AND BI_PSP_StatusForPersonalization__c = :completeStatus
				LIMIT 1
			];
			if (!assessments.isEmpty()) {
				return assessments;
			} else {
				return null;
				/* If the user attends the questionnaire only when they have an assessment, 
				otherwise if there's no assessment record, we don't need to throw an exception. */
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorNoAssessment);
		}
	}

	/*
	 * @Description   This public method is exposed to Lightning components and is cacheable for 
	 improved performance.It retrieves the Care Program Enrollee ID for the current user. It queries 
	 the User object to determine if the current user is a caregiver or a patient,and based on that, 
	 it calls specific methods to find the appropriate Care Program Enrollee ID.If no user is found, 
	 it logs an error message.
	 return in apex BI_PSPB_treatmentvideocmd and return in lwc biPspbarticlenavlinksearch
	 * @Return        Id of the Care Program Enrollee
	 */
	@AuraEnabled(cacheable=true)
	public static Id getCareProgramEnrolleId() {
		try {
			// Query current user
			List<User> currentUser = [
				SELECT Id, Name, BI_PSPB_Caregiver__c
				FROM User
				WHERE Name = :currentUserName
				WITH USER_MODE
				LIMIT 1
			];

			if (!currentUser.isEmpty()) {
				if (!currentUser[0].BI_PSPB_Caregiver__c) {
					// User is not a caregiver
					careProgramEnrolleId = findPatientEnrolleId();
				} else {
					// User is a caregiver
					careProgramEnrolleId = findCaregiverPatientEnrolleId();
				}
			} else {
				// No user found
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
					'',
					System.now(),
					errorNoUserFound,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			if (careProgramEnrolleId == null || careProgramEnrolleId == '') {
				throw new AuraHandledException(enrolleNotFoundError);
			}
			return careProgramEnrolleId;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(enrolleNotFoundError);
		}
	}
	/*
	 * @Description   This method retrieves the Care Program Enrollee ID for a patient based on 
	 the provided user information. It queries the Account object to find the patient's account
	  record using the current user's email and name. If a matching account record is found, it 
	  queries the CareProgramEnrollee object to find the corresponding Care Program Enrollee record
	   for the patient. If found, it returns the Care Program Enrollee ID. If no matching records are 
	   found or if an exception occurs, appropriate error messages are logged.
	 return in BI_PSPB_PersonalizedMessagesCtrl methods
	 * @Return        Id of the Care Program Enrollee for the patient
	 */
	private static Id findPatientEnrolleId() {
		try {
			// Query Account for patient
			List<Account> accountRecordPatient = [
				SELECT Id, Name, PersonEmail
				FROM Account
				WHERE
					PersonEmail = :currentUserEmail
					AND Name = :currentUserName
				WITH USER_MODE
				LIMIT 1
			];

			if (!accountRecordPatient.isEmpty()) {
				// Query CareProgramEnrollee for patient
				// User mode is not enabled because CareProgramEnrollee is health cloud object not supported
				List<CareProgramEnrollee> patientRecord = [
					SELECT Id
					FROM CareProgramEnrollee
					WHERE AccountId = :accountRecordPatient[0].Id
					LIMIT 1
				];

				if (!patientRecord.isEmpty()) {
					careProgramEnrolleId = patientRecord[0].Id;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
						'',
						System.now(),
						caregiverNullError,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
					'',
					System.now(),
					enrolleNotFoundError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			if (careProgramEnrolleId == null || careProgramEnrolleId == '') {
				return null;
			}
			return careProgramEnrolleId;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
				null,
				System.now()
			);
			return null; // Error throw in getCareProgramEnrolleId method
		}
	}
	/*
	 * @Description   This method retrieves the Care Program Enrollee ID for a caregiver's patient
	  based on the provided user information. It queries the Account object to find the caregiver's account 
	  record using the current user's email and name. If a matching account record is found and it has 
	  a selected patient ID, it queries the CareProgramEnrollee object to find the corresponding Care Program 
	  Enrollee record for the caregiver's patient. If found, it returns the Care Program Enrollee ID. 
	  If no matching records are found or if an exception occurs, appropriate error messages are logged. 
	  return in BI_PSPB_PersonalizedMessagesCtrl
	 methods
	 * @Return        Id of the Care Program Enrollee for the caregiver's patient
	 */

	private static Id findCaregiverPatientEnrolleId() {
		try {
			// Query Account for caregiver's patient
			List<Account> accounts = [
				SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
				FROM Account
				WHERE
					Name = :currentUserName
					AND PersonEmail = :currentUserEmail
					AND IsPersonAccount = TRUE
					AND BI_PSPB_Selected_Patient_ID__c != NULL
				WITH USER_MODE
				LIMIT 1
			];

			if (!accounts.isEmpty()) {
				// Query CareProgramEnrollee for caregiver's patient
				// User mode is not enabled because CareProgramEnrollee is health cloud object not supported
				List<CareProgramEnrollee> caregiverPatientRecord = [
					SELECT Id
					FROM CareProgramEnrollee
					WHERE
						AccountId = :accounts[0].BI_PSPB_Selected_Patient_ID__c
					LIMIT 1
				];

				if (!caregiverPatientRecord.isEmpty()) {
					careProgramEnrolleId = caregiverPatientRecord[0].Id;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
						'',
						System.now(),
						enrolleNotFoundError,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
					'',
					System.now(),
					errorForAccount,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			if (careProgramEnrolleId == null || careProgramEnrolleId == '') {
				return null;
			}

			return careProgramEnrolleId;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_PersonalizedMessagesCtrl.class.toString(),
				null,
				System.now()
			);
			return null; // Error throw in getCareProgramEnrolleId method
		}
	}
}