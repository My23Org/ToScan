//This Lightning Web Component facilitating user measurement of health problem effects on work and regular activities.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getTheAssesmentQuestion from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.getTheAssesmentQuestion';
import getTheDdraftResponse from '@salesforce/apex/BI_PSP_RetriveDraftResponse.draftResponseOfWorkAndActivty';
import submitResonse from '@salesforce/apex/BI_PSP_Assessment.ranswerOfTheQuestion';
import submitDraftResonse from '@salesforce/apex/BI_PSP_Assessment.mulitipleDraftRecordsInsertion';
import getDateInprogrsCard from '@salesforce/apex/BI_PSP_CardDateForInProgress.getTheDateInProgessForCardWAPI';
import getRolloutdate from '@salesforce/apex/BI_PSP_Assessment.getRolloutdate';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName';
//To import Static Resource
import BI_PSP_PSSimage from '@salesforce/resourceUrl/BI_PSP_PSSimage';
import BI_PSP_letspersonalizeimage from '@salesforce/resourceUrl/BI_PSP_letspersonalizeimage';
import BI_PSP_DLQIimage from '@salesforce/resourceUrl/BI_PSP_DLQIimage';
import BI_PSP_WPAIimage from '@salesforce/resourceUrl/BI_PSP_WPAIimage';
import BI_PSP_Qualitativeimage from '@salesforce/resourceUrl/BI_PSP_Qualitativeimage';
import BI_PSP_Alerticon from '@salesforce/resourceUrl/BI_PSP_Alerticon';
//To import Custom labels
import BI_PSP_introductionCategory from '@salesforce/label/c.BI_PSP_introductionCategory';
import BI_PSP_PssCategory from '@salesforce/label/c.BI_PSP_PssCategory';
import BI_PSP_WapiCategory from '@salesforce/label/c.BI_PSP_WapiCategory';
import BI_PSP_DlqiCategory from '@salesforce/label/c.BI_PSP_DlqiCategory';
import BI_PSP_QualitativeCategory from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import BI_PSP_Wapi from '@salesforce/label/c.BI_PSP_WAPI';
import BI_PSP_WAPIbottom1 from '@salesforce/label/c.BI_PSP_WAPIbottom1';
import BI_PSP_DLQIbottom3 from '@salesforce/label/c.BI_PSP_DLQIbottom3';
import BI_PSP_yes from '@salesforce/label/c.BI_PSP_yes';
import BI_PSP_no from '@salesforce/label/c.BI_PSP_no';
import BI_PSP_includetext from '@salesforce/label/c.BI_PSP_includetext';
import BI_PSP_wapialerttext from '@salesforce/label/c.BI_PSP_wapialerttext';
import BI_PSP_hours from '@salesforce/label/c.BI_PSP_chatterHours';
import BI_PSP_wapiskip from '@salesforce/label/c.BI_PSP_wapiskip';
import BI_PSP_wapisectext from '@salesforce/label/c.BI_PSP_wapisectext';
import BI_PSP_wapiworkleft from '@salesforce/label/c.BI_PSP_wapiworkleft';
import BI_PSP_wapiworkright from '@salesforce/label/c.BI_PSP_wapiworkright';
import BI_PSP_wapislider2 from '@salesforce/label/c.BI_PSP_wapislider2';
import BI_PSP_wapidailyleft from '@salesforce/label/c.BI_PSP_wapidailyleft';
import BI_PSP_wapidailyright from '@salesforce/label/c.BI_PSP_wapidailyright';
import BI_PSP_answered from '@salesforce/label/c.BI_PSP_answered';
import BI_PSP_submit from '@salesforce/label/c.BI_PSP_submit';
import BI_PSP_saveasdraft from '@salesforce/label/c.BI_PSP_saveasdraft';
import BI_PSP_rolloutdate from '@salesforce/label/c.BI_PSP_rolloutdate';
import BI_PSP_expireson from '@salesforce/label/c.BI_PSP_expireson';
import BI_PSP_outstandingquestionnaire from '@salesforce/label/c.BI_PSP_outstandingquestionnaire';
import BI_PSP_returnback from '@salesforce/label/c.BI_PSP_returnback';
import BI_PSP_confirm_submission from '@salesforce/label/c.BI_PSP_confirm_submission';
import BI_PSP_cancel from '@salesforce/label/c.BI_PSP_cancel';
import BI_PSP_confirm from '@salesforce/label/c.BI_PSP_confirm';
import BI_PSP_workingforpay from '@salesforce/label/c.BI_PSP_workingforpay';
import wpai_category from '@salesforce/label/c.BI_PSP_WapiCategory';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import submitmessage from '@salesforce/label/c.BI_PSP_submittext';
import qualitativeTwoMonths from '@salesforce/label/c.BI_PSPB_BRQualitativeTwoMonths';
import qualitativeFourteenMonths from '@salesforce/label/c.BI_PSPB_BRQualitativeFourteenWeeks';
import dlqiUrl from '@salesforce/label/c.BI_PSPB_BRDlqiQuestionnaireUrl';
import pssQuestionarrieUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisQuesUrl';
import outStandingPage from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import completedAll from '@salesforce/label/c.BI_PSP_CompleteAll';
import popupmessage from '@salesforce/label/c.BI_PSP_Messagepopup';
import confirmmessage from '@salesforce/label/c.BI_PSP_confirmmessage';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import inProgress from '@salesforce/label/c.BI_PSP_Inprogess';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbWAPIQuestionnaire extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables).
	@track yesOrNo;
	@track secondquestionvisible = false;
	@track sliderthumb = false;
	@track totalDraftResponses = 0;
	@track nameToDraftFirst;
	@track nameToDraftSecond;
	@track nameToDraftThird;
	@track nameToDraftFourth;
	@track nameToDraftFifth;
	@track nameToDraftSixth;
	@track firstNumberValue;
	@track secondNumberValue;
	@track thirdNumberValue;
	@track displayTotalMessage = false;
	@track totalValueToUi;
	@track errorFlag = false;
	@track responseValue;
	@track firstRspValue;
	@track firstRespVersId;
	@track secondRspValue;
	@track secondRespVersId;
	@track thirdRspValue;
	@track thirdVersionId;
	@track fourthRspValue;
	@track fourthVersionId;
	@track fifthResonseValue;
	@track fifthVersionId;
	@track sixthResponseValue;
	@track sixthVersiD;
	@track numberOfResponses;
	@track checkyesorno = false;
	@track firstQuestionResponse = '';
	@track secondQuestionResponse = '';
	@track thirdQuestionResponse = '';
	@track fourthQuestionResponse = '';
	@track fifthQuestionresponse = '';
	@track sixthQuestionResponse = '';
	@track realAssesVerArra = [];
	@track realrespArray = [];
	@track arrayForPushResp = [];
	@track arrayForPushId = [];
	@track isConfirmationDialogOpen = false;
	@track customFormModal = false;
	@track message = completedAll;
	@track content1 = submitmessage;
	@track isDraftSavedPopupOpen = false;
	@track draftSavedMessage = popupmessage;
	@track selectedOption;
	@track isPopupOpen = false;
	@track isPopupOpen1 = false;
	@track sliderValue = 0;
	@track sliderValuesec = 0;
	//Global variables(without @track does not trigger automatic re-renders)
	drfatNoCheck = false;
	noCheck;
	errorMessageCheck;
	popupmenu = false;
	userid = Id;
	firstQuestionText;
	secondQuestionText;
	thirdQuestionText;
	thirdQuestionVersionId;
	fourthQuestionText;
	fourthQuestionVersionId;
	fifthQuestionText;
	fifthQuestionVersionId;
	sixthQuestionText;
	sixthQuestionVerionId;
	urlq;
	firstDraftResp;
	firstDraftVerionId;
	secondDraftResp;
	secondDraftVerionId;
	thirdDraftResp;
	thirdDraftVersionId;
	fourthDraftRes;
	fourthDraftVersionId;
	fifthDraftResp;
	fifthDraftVersionId;
	sixthDraftResp;
	sixthDraftVersionId;
	dateResponses = [];
	storedate;
	categoryname = wpai_category;
	firstQuestionVersinId;
	secondQuestionVersinId;
	assVerId;
	assVerIdSlider;
	questionData;
	cardimage = BI_PSP_letspersonalizeimage;
	cardimage1 = BI_PSP_DLQIimage;
	cardimage2 = BI_PSP_PSSimage;
	cardimage3 = BI_PSP_WPAIimage;
	cardimage4 = BI_PSP_Qualitativeimage;
	alerticon1 = BI_PSP_Alerticon;
	wapibot1 = BI_PSP_WAPIbottom1;
	wapibot2 = BI_PSP_DLQIbottom3;
	introduction = BI_PSP_introductionCategory;
	pss = BI_PSP_PssCategory;
	dlqi = BI_PSP_DlqiCategory;
	wapi = BI_PSP_WapiCategory;
	qsq = BI_PSP_QualitativeCategory;
	workingforpay = BI_PSP_workingforpay;
	workAPI = BI_PSP_Wapi;
	yes = BI_PSP_yes;
	no = BI_PSP_no;
	includehelptext = BI_PSP_includetext;
	alerttext = BI_PSP_wapialerttext;
	hours = BI_PSP_hours;
	skiptext = BI_PSP_wapiskip;
	slidertext = BI_PSP_wapisectext;
	worksliderleft = BI_PSP_wapiworkleft;
	worksliderright = BI_PSP_wapiworkright;
	slidertext2 = BI_PSP_wapislider2;
	dailysliderleft = BI_PSP_wapidailyleft;
	dailysliderright = BI_PSP_wapidailyright;
	answered = BI_PSP_answered;
	submit = BI_PSP_submit;
	saveasdraft = BI_PSP_saveasdraft;
	rolloutdate = BI_PSP_rolloutdate;
	expireson = BI_PSP_expireson;
	outstandingque = BI_PSP_outstandingquestionnaire;
	returnbackc = BI_PSP_returnback;
	confirmsub = BI_PSP_confirm_submission;
	cannotedit = confirmmessage;
	cancelbt = BI_PSP_cancel;
	confirmbt = BI_PSP_confirm;
	target14wksdate;
	target2monthsdate;
	forteenWeeks;
	threeMonthsVar;
	lastIdVal;
	expireDate;
	rolloutDate;
	assessmentId;
	countquestion = 2;

	// Wire method to count assessment responses
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ error, data }) {
		try {
		// Check if data is available
		if (data) {
			// Assign data to the 'count' property
			this.count = data;

			// Check if the data array has elements
			if (this.count.length > 0) {
			// Assign specific elements of the data array to properties
			this.stwai = this.count[0];
			this.stpss = this.count[1];
			this.stdlq = this.count[2];
			this.stqsq = this.count[3];
			}
		} else if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		// Handle errors
		} catch (err) {
		// Log any errors that occur during the wire method execution
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Getter method to determine if DLQI responses are available
	get checkdlqi() {
		// Check if the number of DLQI responses is greater than 0
		return this.stdlq > 0 ? 'disabled' : ''; // Return 'disabled' if DLQI responses are available, otherwise return an empty string
	}

	// Getter method to determine if PSS responses are available
	get checkpss() {
		// Check if the number of PSS responses is greater than 0
		return this.stpss > 0 ? 'disabled' : ''; // Return 'disabled' if PSS responses are available, otherwise return an empty string
	}

	// Getter method to determine if WAI responses are available
	get checkwai() {
		// Check if the number of WAI responses is greater than 0
		return this.stwai > 0 ? 'disabled' : ''; // Return 'disabled' if WAI responses are available, otherwise return an empty string
	}

	// Getter method to determine if QSQ responses are available and if target dates are set
	get checkqsq() {
		// Check if either of the target dates is null and if QSQ responses are available
		if (this.target14wksdate === null && this.target2monthsdate === null) {
		return 'disabled'; // Return 'disabled' if target dates are not set
		} else if (this.stqsq > 0) {
		return 'disabled'; // Return 'disabled' if QSQ responses are available
		}
		// Return an empty string if none of the conditions are met
		return '';
	}

	// Wire method to fetch date in progress card
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getDateInprogrsCard)
	wiredDataForInprogress({ error, data }) {
		try {
		// Check if data is received and if data loading flag is false
		if (data && !this.isDataLoaded) {
			// Assign the received data to the rollout date
			this.rolloutdate1 = data;
			// Check if the status is 'In Progress' or 'Completed'
			if (this.status === inProgress || this.status === completedLabel) {
			// Calculate expiration date based on the rollout date
			this.expireApexdate = this.rolloutdate1;
			const currentDate = new Date(this.expireApexdate);
			this.rolloutDate = currentDate.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});
			const currentDate1 = new Date(this.rolloutDate);
			currentDate1.setDate(currentDate1.getDate() + 30);
			this.expireDate = currentDate1.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});
			// Calculate remaining days until expiration
			const todayMs = new Date().getTime();
			const expireDateMs = new Date(this.expireDate).getTime();
			const differenceInDays = Math.ceil(
				(expireDateMs - todayMs) / (1000 * 60 * 60 * 24)
			);
			this.expiresIn = differenceInDays;
			// Limit expiresIn to 30 days or less
			if (this.expiresIn > 30 || this.expiresIn < 0) {
				this.expiresIn = 30;
			}
			}
			// Set data loading flag to true once data is processed
			this.isDataLoaded = true;
		} else if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire method to fetch patient data after three months and fourteen weeks
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
		// Check if data is received
		if (data) {
			// Assign received data to corresponding variables
			this.threeMonthsVar = data.threeMonthsVar;
			this.forteenWeeks = data.forteenWeeks;
			// Assign target dates with null-coalescing operator to handle possible null values
			this.target2monthsdate = data.target2monthsdate ?? null;
			this.target14wksdate = data.target14wksdate ?? null;
		} else if (error) {
			// Log any errors if data retrieval fails
			this.showToast(consoleErrorMessage, error.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire method to fetch assessments by current user name
	/*Null checks are not performed because sometimes users may or may not have assessment records initially. 
    Even if there are no assessment records, we show the Questionaire page for the user to create assessment records. 
	The page will not be blank.
    */
	@wire(getAssessmentsByCurrentUserNamepss, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
		// Check if data is received
		if (data) {
			// Assign assessment ID and status based on data
			this.assessmentId = data.length > 0 ? data[0].Id : null;
			this.status = data.length > 0 ? data[0].AssessmentStatus : null;
			// Check if assessment status is 'Expired'
			if (this.status === expired) {
			// Set expiration date and calculate expire date and expiration difference
			this.expireApexdate =
				data.length > 0 ? data[0].ExpirationDateTime : null;
			const currentDate = new Date(this.expireApexdate);
			this.rolloutDate = currentDate.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});
			const currentDate1 = new Date(this.rolloutDate);
			currentDate1.setDate(currentDate1.getDate() + 30);
			this.expireDate = currentDate1.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});
			const todayMs = new Date().getTime();
			const expireDateMs = new Date(this.expireDate).getTime();
			const differenceInDays = Math.ceil(
				(expireDateMs - todayMs) / (1000 * 60 * 60 * 24)
			);
			this.expiresIn = differenceInDays;
			}
		} else if (error) {
			// Log any errors if data retrieval fails
			this.showToast(consoleErrorMessage, error.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		// Log any errors that occur during processing
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire method to fetch rollout date
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getRolloutdate)
	wiredQSPData({ error, data }) {
		try {
		// Check if data is received
		if (data) {
			// Assign received data to dateResponses property
			this.dateResponses = data;
			// Check if assessmentId is not set
			if (!this.assessmentId) {
			// Extract rollout date from data
			this.dateResponses.forEach((item) => {
				this.storedate = item.BI_PSP_WAI_RollOutDate__c;
			});
			// Calculate rollout and expiration dates
			const currentDate = new Date(this.storedate);
			this.rolloutDate = currentDate.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});
			const currentDate1 = new Date(this.rolloutDate);
			currentDate1.setDate(currentDate1.getDate() + 30);
			this.expireDate = currentDate1.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});
			// Calculate difference in days between expiration and current date
			const todayMs = new Date().getTime();
			const expireDateMs = new Date(this.expireDate).getTime();
			const differenceInDays = Math.ceil(
				(expireDateMs - todayMs) / (1000 * 60 * 60 * 24)
			);
			this.expiresIn = differenceInDays;
			// Ensure expiresIn is not greater than 30
			if (this.expiresIn > 30) {
				this.expiresIn = 30;
			}
			}
		} else if (error) {
			// Log any errors if data retrieval fails
			this.showToast(consoleErrorMessage, error.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		// Log any errors that occur during processing
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//the draft response wire method
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getTheDdraftResponse)
	wiredDraftResponses({ error, data }) {
		try {
		if (data) {
			const objectsWithResponseOrderSeven = data.filter(
			(item) => item.BI_PSP_ResponseOrder__c === 1
			);
			this.responsOfDLQI = data;
			this.draftResponses = data.map((response) => ({
			id: response.Id,
			questionText: response.ResponseValue,
			activeVersionId: response.AssessmentQuestion
				? response.AssessmentQuestion.Id
				: null
			}));

			// Update the totalDraftResponses property

			this.totalDraftResponses = this.draftResponses.length;
			if (objectsWithResponseOrderSeven.length > 0) {
			if (
				this.draftResponses.length > this.countquestion ||
				objectsWithResponseOrderSeven[0].ResponseValue === this.yes
			) {
				this.countquestion = 6;
			} else {
				this.countquestion = 2;
			}
			}
			if (this.draftResponses.length >= 1) {
				
			const firstQuestion = this.draftResponses[0];
			
			this.firstResponseText = firstQuestion.questionText;
			this.firstResponseVersinId = firstQuestion.activeVersionId;
			// Check if the array has the expected length before accessing the elements
			if (this.draftResponses.length >= 2) {
				const secondQuestion = this.draftResponses[1];
				this.secondResponseText = secondQuestion.questionText;
				this.secondResponseVersinId = secondQuestion.activeVersionId;
				// Continue similarly for the third question
				if (this.draftResponses.length >= 3) {
				const thirdQuestion = this.draftResponses[2];
				this.thirdResponseText = thirdQuestion.questionText;
				this.thirdResponseVersinId = thirdQuestion.activeVersionId;
				// Continue similarly for the fourth question
				if (this.draftResponses.length >= 4) {
					const fourthQuestion = this.draftResponses[3];
					this.fourthResponseText = fourthQuestion.questionText;
					this.fourthResponseVersinId = fourthQuestion.activeVersionId;
					// Continue similarly for the fourth question
					if (this.draftResponses.length >= 5) {
					const fifthResponse = this.draftResponses[4];
					this.fifthResponseText = fifthResponse.questionText;
					this.fifthResponseVersionId = fifthResponse.activeVersionId;
					if (this.draftResponses.length >= 6) {
						const sixthQuestion = this.draftResponses[5];
						this.sixthResponseText = sixthQuestion.questionText;
						this.SixthResponseVersionId = sixthQuestion.activeVersionId;
						if (this.draftResponses.length >= 7) {
						const seventhQuestion = this.draftResponses[6];
						this.seventhResponseText = seventhQuestion.questionText;
						this.SeventhResponseVersionId =
							seventhQuestion.activeVersionId;
						if (this.draftResponses.length >= 8) {
							const eighthQuestion = this.draftResponses[7];
							this.eighthResponseText = eighthQuestion.questionText;
							this.EigthResponseVersionId =
							eighthQuestion.activeVersionId;
							if (this.draftResponses.length >= 9) {
							const ninthQuestion = this.draftResponses[8];
							this.ninthResponseText = ninthQuestion.questionText;
							this.NinthResponseVersionId =
								ninthQuestion.activeVersionId;
							if (this.draftResponses.length >= 10) {
								const tenthQuestion = this.draftResponses[9];
								this.tenthResponseText = tenthQuestion.questionText;
								this.tenthResponseVersionId =
								tenthQuestion.activeVersionId;
								if (this.draftResponses.length >= 11) {
								const eleventhQuestion = this.draftResponses[10];
								this.eleventhResponseText =
									eleventhQuestion.questionText;
								this.eleventhResponseVersionId =
									tenthQuestion.activeVersionId;
								}
							}
							}
						}
						}
					}
					}
				}
				}
			}
			}
		} else if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		// Log any errors that occur during processing
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//the draft responses are stored on to js class variable so that we can use it later to submit or save as draft.Also change the status of the radio buttons as checked if the value are matched.
	reposneModeeOn() {
		const firstYes = this.yes;
		const firstNo = this.no;

		const firstVal0 = '0';
		const firstVal1 = '1';
		const firstVal2 = '2';
		const firstVal3 = '3';
		const firstVal4 = '4';
		const firstVal5 = '5';
		const firstVal6 = '6';
		const firstVal7 = '7';
		const firstVal8 = '8';
		const firstVal9 = '9';
		const firstVal10 = '10';

		const secVal0 = '0';
		const secVal1 = '1';
		const secVal2 = '2';
		const secVal3 = '3';
		const secVal4 = '4';
		const secVal5 = '5';
		const secVal6 = '6';
		const secVal7 = '7';
		const secVal8 = '8';
		const secVal9 = '9';
		const secVal10 = '10';

		//this for each will itearte through each of the Resoponse records and store the responses and their ids to respective variables for later usage
		this.responsOfDLQI.forEach((record) => {
		if (record.BI_PSP_ResponseOrder__c === 1) {
			if (
			record.ResponseValue === this.firstResponseText &&
			record.AssessmentQuestion.Id === this.firstResponseVersinId
			) {
			if (record.ResponseValue === firstYes) {
				this.firstQuesIsYes = true;
				this.secondquestionvisible = true;
				this.sliderthumb = true;
				this.updateThumbLabelPosition(this.sliderValue);
			}
			if (record.ResponseValue === firstNo) {
				this.firstQuesIsNo = true;
				this.sliderthumb = false;
			}
            
			this.firstDraftResp = record.ResponseValue;
            
			this.firstDraftVerionId = record.AssessmentQuestion.Id;

			if(this.yesOrNo ===true )
			{
				
				this.firstDraftResp='';
				this.firstDraftVerionId ='';
				this.firstQuesIsYes=false;
				this.firstQuesIsNo=true;
				this.secondquestionvisible = false;
				
			}
			else{
				if(record.ResponseValue === firstYes)
				{
					console.log('OUTPUT antoo : ');
				this.secondquestionvisible = true;
				}
				
			}
		
			}
		}

		if (record.BI_PSP_ResponseOrder__c === 2) {
			if (
			record.BI_PSP_ResponseOrder__c === 2 &&
			record.ResponseValue !== null &&
			record.AssessmentQuestion.Id !== null
			) {
			this.firstNumberValue = record.ResponseValue;
			this.secondDraftResp = record.ResponseValue;
			this.secondDraftVerionId = record.AssessmentQuestion.Id;

			if(this.yesOrNo ===true )
			{
				this.secondDraftResp='';
				this.secondDraftVerionId ='';
				this.firstNumberValue='';
				
			}
			}
		}

		if (record.BI_PSP_ResponseOrder__c === 3) {
			if (
			record.BI_PSP_ResponseOrder__c === 3 &&
			record.ResponseValue !== null &&
			record.AssessmentQuestion.Id !== null
			) {
			this.secondNumberValue = record.ResponseValue;
			this.thirdDraftResp = record.ResponseValue;
			this.thirdDraftVersionId = record.AssessmentQuestion.Id;

			if(this.yesOrNo ===true  )
			{
				this.thirdDraftResp='';
				this.thirdDraftVersionId ='';
				this.secondNumberValue='';
				
			}
			}
		}

		if (record.BI_PSP_ResponseOrder__c === 4) {
			if (
			record.BI_PSP_ResponseOrder__c === 4 &&
			record.ResponseValue !== null &&
			record.AssessmentQuestion.Id !== null
			) {
			this.thirdNumberValue = record.ResponseValue;
			this.fourthDraftRes = record.ResponseValue;
			this.fourthDraftVersionId = record.AssessmentQuestion.Id;

			if(this.yesOrNo ===true  )
			{
				this.fourthDraftRes='';
				this.fourthDraftVersionId ='';
				this.thirdNumberValue='';
				
			}
			}
		}

		if (record.BI_PSP_ResponseOrder__c === 5) {
			if (
			record.BI_PSP_ResponseOrder__c === 5 &&
			record.ResponseValue !== null &&
			record.AssessmentQuestion.Id !== null
			) {
			if (record.ResponseValue === firstVal0) {
				this.sliderValue = 0;
			}
			if (record.ResponseValue === firstVal1) {
				this.sliderValue = 1;
			}
			if (record.ResponseValue === firstVal2) {
				this.sliderValue = 2;
			}
			if (record.ResponseValue === firstVal3) {
				this.sliderValue = 3;
			}

			if (record.ResponseValue === firstVal4) {
				this.sliderValue = 4;
			}
			if (record.ResponseValue === firstVal5) {
				this.sliderValue = 5;
			}
			if (record.ResponseValue === firstVal6) {
				this.sliderValue = 6;
			}
			if (record.ResponseValue === firstVal7) {
				this.sliderValue = 7;
			}

			if (record.ResponseValue === firstVal8) {
				this.sliderValue = 8;
			}
			if (record.ResponseValue === firstVal9) {
				this.sliderValue = 9;
			}
			if (record.ResponseValue === firstVal10) {
				this.sliderValue = 10;
			}

			this.fifthDraftResp = record.ResponseValue;
			this.sliderValue = this.fifthDraftResp;
			this.updateThumbLabelPosition(this.sliderValue);
			this.fifthDraftVersionId = record.AssessmentQuestion.Id;
			} else {
			this.sliderValue = 0;
			this.updateThumbLabelPosition(this.sliderValue);
			}

			if(this.yesOrNo ===true  )
			{
				this.fifthDraftResp='';
				this.fifthDraftVersionId ='';
				this.sliderValue='';
				
			}
		}

		if (record.BI_PSP_ResponseOrder__c === 6) {
			if (
			record.BI_PSP_ResponseOrder__c === 6 &&
			record.ResponseValue !== null &&
			record.AssessmentQuestion.Id !== null
			) {
			if (record.ResponseValue === secVal0) {
				this.sliderValuesec = 0;
			}
			if (record.ResponseValue === secVal1) {
				this.sliderValuesec = 1;
			}
			if (record.ResponseValue === secVal2) {
				this.sliderValuesec = 2;
			}
			if (record.ResponseValue === secVal3) {
				this.sliderValuesec = 3;
			}

			if (record.ResponseValue === secVal4) {
				this.sliderValuesec = 4;
			}
			if (record.ResponseValue === secVal5) {
				this.sliderValuesec = 5;
			}
			if (record.ResponseValue === secVal6) {
				this.sliderValuesec = 6;
			}
			if (record.ResponseValue === secVal7) {
				this.sliderValuesec = 7;
			}

			if (record.ResponseValue === secVal8) {
				this.sliderValuesec = 8;
			}
			if (record.ResponseValue === secVal9) {
				this.sliderValuesec = 9;
			}
			if (record.ResponseValue === secVal10) {
				this.sliderValuesec = 10;
			}
			this.sixthDraftResp = record.ResponseValue;
			this.sliderValuesec = this.sixthDraftResp;
			this.updateThumbLabelPositionsec(this.sliderValuesec);
			this.sixthDraftVersionId = record.AssessmentQuestion.Id;
			}
		}
		});
	}

	// Lifecycle method called when the component is connected to the DOM
	connectedCallback() {
		try {
		// Get the current URL
		const currentURL = window.location.href;
		// Create a URL object from the current URL
		const urlObject = new URL(currentURL);
		// Get the path from the URL
		const path = urlObject.pathname;
		// Split the path using '/' as a separator
		const pathComponents = path.split('/');
		// Find the desired component in the path
		const desiredComponent = pathComponents.find((component) =>
			[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
			component.toLowerCase()
			)
		);

		// Determine the URL type based on the desired component
		if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
			this.urlq = brandedUrlNavi;
		} else {
			this.urlq = unAssignedUrlNavi;
		}

		// Update thumb label position for a slider
		this.updateThumbLabelPositionsec(this.sliderValuesec);

		// Check if the view is in desktop mode
		this.isDesktop = this.isDesktopView();

		// Add event listener for window resize
		window.addEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
		// Log any errors that occur during processing
		this.showToast(consoleErrorMessage, error.message, errorvariant); //Catching Potential Error
		}
	}

	/**
	 * Executes when the component is disconnected from the DOM.
	 * Removes the window resize event listener.
	 */
	disconnectedCallback() {
		window.removeEventListener('resize', this.handleResize.bind(this));
	}

	/**
	 * Handles the window resize event.
	 * Updates the isDesktop property based on the viewport width.
	 */
	handleResize() {
		this.isDesktop = this.isDesktopView();
	}

	/**
	 * Determines if the current viewport width represents a desktop view.
	 * @returns {boolean} True if the viewport width indicates a desktop view, otherwise false.
	 */
	isDesktopView() {
		const viewportWidth = window.innerWidth;

		// Adjust this threshold based on your design's breakpoints
		return (
		viewportWidth >= 1024 ||
		viewportWidth <= 400 ||
		viewportWidth <= 576 ||
		viewportWidth <= 769 ||
		viewportWidth <= 993 ||
		viewportWidth <= 1200
		); // Example breakpoints at 1024 pixels and 400 pixels
	}

	//when the page gets rendered
	renderedCallback() {
		this.addSliderEventListener();
	}

	/**
	 * Handles input change events from the slider.
	 * Updates the sliderValue property and invokes the method to update the thumb label position.
	 * Pushes the response value and version ID to arrays for further processing.
	 * Retrieves the last response value and version ID from the arrays.
	 * @param {Event} event - The input change event.
	 */
	handleInputChange(event) {
		// Update slider value and thumb label position
		this.sliderValue = event.target.value;
		this.updateThumbLabelPosition(this.sliderValue);

		// Update fifth question response value and name for draft
		this.fifthQuestionresponse = event.target.value;
		this.nameToDraftFifth = event.target.name;

		// Push response value and version ID to arrays
		if (this.fifthQuestionresponse !== '') {
		this.arrayForPushResp.push(this.fifthQuestionresponse);
		this.arrayForPushId.push(this.fifthQuestionVersionId);
		}

		// Get the last response value and version ID
		this.fifthResonseValue = this.getLastRespValue();
		this.fifthVersionId = this.getLastIdValue();
	}

	/**
	 * Retrieves the last response value from the array.
	 * @returns {string|null} The last response value, or null if the array is empty.
	 */
	getLastRespValue() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}

	/**
	 * Retrieves the last version ID from the array.
	 * @returns {string|null} The last version ID, or null if the array is empty.
	 */
	getLastIdValue() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	/**
	 * Updates the position of the thumb label based on the slider value.
	 * Uses requestAnimationFrame for smooth animation.
	 * @param {number} sliderValue - The current value of the slider.
	 */
	updateThumbLabelPosition(sliderValue) {
		requestAnimationFrame(() => {
		// Get slider and thumb label elements
		const slider = this.template.querySelector('.slider');
		const thumbLabel = this.template.querySelector('.thumb-label');

		// Calculate thumb label position
		const thumbWidth = parseInt(window.getComputedStyle(thumbLabel).width);
		const sliderWidth = slider.offsetWidth;
		const thumbPosition =
			(sliderValue / slider.max) * (sliderWidth - thumbWidth);

		// Calculate new thumb position
		const newPosition = thumbPosition + thumbWidth / 2 - sliderWidth / 2;
		const maxPosition = sliderWidth - thumbWidth;

		// Update thumb label position
		thumbLabel.style.left =
			Math.min(maxPosition, Math.max(0, newPosition)) + 'px';
		thumbLabel.setAttribute('data-value', sliderValue);
		});
	}

	/**
	 * Adds event listeners to slider elements to update thumb positions.
	 * Uses input and mousemove events for real-time updates.
	 */
	addSliderEventListener() {
		// Get primary slider element
		
		const slider = this.template.querySelector('.slider');

		// Define function to update thumb position for primary slider
		const updateThumbPosition1 = () => {
		this.updateThumbLabelPosition(slider.value);
		};

		// Add event listeners to primary slider
		if (slider) {
		slider.addEventListener('input', updateThumbPosition1);
		slider.addEventListener('mousemove', updateThumbPosition1);
		}

		// Get secondary slider element

		const slidersec = this.template.querySelector('.slidersec');

		// Define function to update thumb position for secondary slider
		const updateThumbPosition2 = () => {
		this.updateThumbLabelPositionsec(slidersec.value);
		};

		// Add event listeners to secondary slider
		if (slidersec) {
		slidersec.addEventListener('input', updateThumbPosition2);
		slidersec.addEventListener('mousemove', updateThumbPosition2);
		}
	}

	/**
	 * Handles input changes for the secondary slider.
	 * Updates the slider value and thumb position, as well as the corresponding question response.
	 */
	handleInputChangesec(event) {
		// Update slider value and thumb position
		this.sliderValuesec = event.target.value;
		this.updateThumbLabelPositionsec(this.sliderValuesec);

		// Update sixth question response and name for draft
		this.sixthQuestionResponse = event.target.value;
		this.nameToDraftSixth = event.target.name;

		// Push response and version ID to arrays if response is not empty
		if (this.sixthQuestionResponse !== '') {
		this.arrayForPushResp.push(this.sixthQuestionResponse);
		this.arrayForPushId.push(this.sixthQuestionVerionId);
		}

		// Get the last response value and version ID separately
		this.sixthResponseValue = this.getLastRespValueTwo();
		this.sixthVersiD = this.getLastIdValueTwo();
	}

	/**
	 * Retrieves the last response value from the array.
	 * @returns {string|null} The last response value or null if the array is empty.
	 */
	getLastRespValueTwo() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}

	/**
	 * Retrieves the last version ID value from the array.
	 * @returns {string|null} The last version ID value or null if the array is empty.
	 */
	getLastIdValueTwo() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	/**
	 * Updates the position of the thumb label for the secondary slider.
	 * @param {number} sliderValuesec - The current value of the secondary slider.
	 */
	updateThumbLabelPositionsec(sliderValuesec) {
		// Use requestAnimationFrame to wait for the next rendering cycle
		requestAnimationFrame(() => {
		const slider = this.template.querySelector('.slidersec');
		const thumbLabel = this.template.querySelector('.thumb-labelsec');

		// Calculate thumb position and label display
		const thumbWidth = parseInt(window.getComputedStyle(thumbLabel).width);
		const sliderWidth = slider.offsetWidth;
		const thumbPosition =
			(sliderValuesec / slider.max) * (sliderWidth - thumbWidth);
		const newPosition = thumbPosition + thumbWidth / 2 - sliderWidth / 2;
		const maxPosition = sliderWidth - thumbWidth;

		// Update thumb label position and data value attribute
		thumbLabel.style.left =
			Math.min(maxPosition, Math.max(0, newPosition)) + 'px';
		thumbLabel.setAttribute('data-value', sliderValuesec);
		});
	}

	/**
	 * Determines the CSS class for the popup container based on the state of the popup.
	 * @returns {string} - The CSS class for the popup container.
	 */
	get popupClass() {
		return this.isPopupOpen ? 'popup-container' : 'popup-container hidden';
	}

	/**
	 * Determines the CSS class for the save draft popup container based on the state of the popup.
	 * @returns {string} - The CSS class for the save draft popup container.
	 */
	get popupClassSaveDraft() {
		return this.isDraftSavedPopupOpen
		? 'popup-containersaveasdr'
		: 'popup-containersaveasdr hidden';
	}

	/**
	 * Determines the CSS class for the secondary popup container based on its state.
	 * @returns {string} - The CSS class for the secondary popup container.
	 */
	get popupClass1() {
		return this.isPopupOpen1 ? 'popup2-container' : 'popup2-container hidden';
	}

	/**
	 * Closes all popups.
	 */
	customHideModalPopup() {
		this.customFormModal = false;
		this.isPopupOpen = false;
		this.isPopupOpen1 = false;
	}

	//this eire method holds the Questions of Wapi Qustionnsire.
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getTheAssesmentQuestion)
	wiredAssessmentQuestion({ error, data }) {
		try {
		if (data) {
			this.questionData = data.map((question) => ({
			id: question.Id,
			questionText: question.QuestionText,
			activeVersionId: question.ActiveVersion
				? question.ActiveVersion.Id
				: null
			}));
			//the below variables holds the Questions one by one
			const firstQuestion = this.questionData[0];
			const secondQuestion = this.questionData[1];
			const thirdQuestion = this.questionData[2];
			const fourthQuestion = this.questionData[3];
			const fifthQuestion = this.questionData[4];
			const sixthQuestion = this.questionData[5];

			//the below class propertys holds the Questions one by one
			this.firstQuestionText = firstQuestion.questionText;

			this.firstQuestionVersinId = firstQuestion.activeVersionId;
			this.secondQuestionText = secondQuestion.questionText;
			this.secondQuestionVersinId = secondQuestion.activeVersionId;
			this.thirdQuestionText = thirdQuestion.questionText;
			this.thirdQuestionVersionId = thirdQuestion.activeVersionId;
			this.fourthQuestionText = fourthQuestion.questionText;
			this.fourthQuestionVersionId = fourthQuestion.activeVersionId;
			this.fifthQuestionText = fifthQuestion.questionText;
			this.fifthQuestionVersionId = fifthQuestion.activeVersionId;
			this.sixthQuestionText = sixthQuestion.questionText;
			this.sixthQuestionVerionId = sixthQuestion.activeVersionId;

			this.reposneModeeOn();
		} else if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant);
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant);
		}
	}
	//when the response value  for the first Question is no we will set the values of other radio fields as empty.
	noBasedResponseDeletion() {
        document.body.style.overflow = ''; // Reset to default
		
		this.secondQuestionResponse = '';
		
		this.thirdQuestionResponse = '';
		this.fourthQuestionResponse = '';
		this.fifthQuestionresponse = '';
        
		this.nameToDraftSecond='';
		this.nameToDraftThird='';
		this.nameToDraftFourth='';
		this.nameToDraftFifth='';

		this.secondDraftResp = '';
		this.secondDraftVerionId = '';
		this.thirdDraftResp = '';
		this.thirdDraftVersionId = '';
		this.fourthDraftRes = '';
		this.fourthDraftVersionId = '';

		this.fifthDraftResp = '';
		this.fifthDraftVersionId = '';

		this.secondRspValue = '';
		this.secondRespVersId = '';
		this.thirdRspValue = '';
		this.thirdVersionId = '';
		this.fourthRspValue = '';
		this.fourthVersionId = '';
		this.fifthResonseValue = '';
		this.fifthVersionId = '';

		this.firstNumberValue='';
		this.secondNumberValue='';
		this.thirdNumberValue='';
		this.sliderValue='';
	}

	/**
	 * Handles the click event from the first question checkbox.
	 * @param {Event} event - The click event object.
	 */
	onclickFronFirstQuestion(event) {
		const valueToSend = event.target.value; // Get the value of the checkbox

		sessionStorage.setItem('qustion', valueToSend);
		const sendValueEvent = new CustomEvent('sendvalue', {
		detail: { value: valueToSend }
		});
		this.dispatchEvent(sendValueEvent);

		if (event.target.checked) {
		const val = event.target.value;
		if (val === this.yes) {
			this.countquestion = 6;
			this.sliderValue=0;
			this.firstQuesIsYes = true;
			this.firstQuesIsNo = false;

			this.updateThumbLabelPosition(this.sliderValue);
		}

		if (val === this.no) {
			this.countquestion = 2;
			if (this.totalDraftResponses >= 6) {
			this.totalDraftResponses = 2;
			}

			this.firstQuesIsNo = true;
			this.firstQuesIsYes = false;
			this.noBasedResponseDeletion();
		}
		}
		this.secondquestionvisible = event.target.value === this.yes;

		this.nameToDraftFirst = event.target.name;

		this.firstQuestionResponse = event.target.value;

		if (this.firstQuestionResponse !== '') {
		this.arrayForPushResp.push(this.firstQuestionResponse);
		this.arrayForPushId.push(this.firstQuestionVersinId);
		}
		// Get the last values separately
		this.firstRspValue = this.getLastRespValueThree();
		this.firstRespVersId = this.getLastIdValueThree();
	}
	// Get the last response value separately
	getLastRespValueThree() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}
	// Get the last Question version id value separately
	getLastIdValueThree() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	/**
	* Handles the change event for the first number input field.
	* @param {Event} event - The change event object.
	*/
	oncahngeOfFirstNumber(event) {
		this.firstNumberValue = event.target.value;
		this.checkTotal();
		this.nameToDraftSecond = event.target.name;
		this.secondQuestionResponse = this.firstNumberValue;

		if (this.secondQuestionResponse !== '') {
		this.arrayForPushResp.push(this.secondQuestionResponse);
		this.arrayForPushId.push(this.secondQuestionVersinId);
		}
		// Get the last values separately
		this.secondRspValue = this.getLastRespValueFour();
		this.secondRespVersId = this.getLastIdValueFour();
	}

	/**
	* Retrieves the last response value from the array.
	* @returns {string|null} - The last response value or null if the array is empty.
	*/
	getLastRespValueFour() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}

	/**
	* Retrieves the last response ID from the array.
	* @returns {string|null} - The last response ID or null if the array is empty.
	*/
	getLastIdValueFour() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	/**
	* Handles the change event for the second number input field.
	* @param {Event} event - The change event object.
	*/
	oncahngeOfSecondNumber(event) {
		this.secondNumberValue = event.target.value;
		this.checkTotal();
		this.nameToDraftThird = event.target.name;
		this.thirdQuestionResponse = this.secondNumberValue;

		if (this.thirdQuestionResponse !== '') {
		this.arrayForPushResp.push(this.thirdQuestionResponse);
		this.arrayForPushId.push(this.thirdQuestionVersionId);
		}
		// Get the last values separately
		this.thirdRspValue = this.getLastRespValueFive();
		this.thirdVersionId = this.getLastIdValueFive();
	}

	/**
	* Retrieves the last response value from the array.
	* @returns {string|null} - The last response value or null if the array is empty.
	*/
	getLastRespValueFive() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}

	/**
	* Retrieves the last response ID from the array.
	* @returns {string|null} - The last response ID or null if the array is empty.
	*/
	getLastIdValueFive() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	/**
	* Handles the change event for the third number input field.
	* @param {Event} event - The change event object.
	*/
	oncahngeOfThirdNumber(event) {
		this.thirdNumberValue = event.target.value;
		this.checkTotal();

		this.nameToDraftFourth = event.target.name;
		this.fourthQuestionResponse = this.thirdNumberValue;

		if (this.fourthQuestionResponse !== '') {
		this.arrayForPushResp.push(this.fourthQuestionResponse);
		this.arrayForPushId.push(this.fourthQuestionVersionId);
		}
		// Get the last values separately
		this.fourthRspValue = this.getLastRespValueSix();
		this.fourthVersionId = this.getLastIdValueSix();
	}

	/**
	* Retrieves the last response value from the array.
	* @returns {string|null} - The last response value or null if the array is empty.
	*/
	getLastRespValueSix() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}

	/**
	* Retrieves the last response ID from the array.
	* @returns {string|null} - The last response ID or null if the array is empty.
	*/
	getLastIdValueSix() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	/**
	* Calculates the total value of the three input fields and checks if it exceeds 168.
	* If the total exceeds 168, sets an error flag and adds a red border to the input fields.
	* If the total is within the limit, clears any error messages and removes the red border.
	*/
	checkTotal() {
		const totalValue =
		parseInt(this.firstNumberValue, 10) +
		parseInt(this.secondNumberValue, 10) +
		parseInt(this.thirdNumberValue, 10);

		this.totalValueToUi = totalValue;
		const viewportWidth = window.innerWidth;
		// Css attribute call for Certain conditions
		if (totalValue >= 168) {
		// Set error flag and add red border to input fields
		this.errorFlag = true;
		this.template
			.querySelectorAll('.numbox')
			.forEach((input) => input.classList.add('red-border'));
		if (viewportWidth >= 320 && viewportWidth <= 399) {
			this.template
			.querySelectorAll('.qnouterbox')
			.forEach((box) => (box.style.height = '322px'));
			this.template
			.querySelectorAll('.qnouterbox1')
			.forEach((box) => (box.style.height = '258px'));
			this.template
			.querySelectorAll('.qnouterbox2')
			.forEach((box) => (box.style.height = '239px'));
		}
		if (viewportWidth >= 399 && viewportWidth <= 576) {
			this.template
			.querySelectorAll('.qnouterbox')
			.forEach((box) => (box.style.height = '303px'));
			this.template
			.querySelectorAll('.qnouterbox1')
			.forEach((box) => (box.style.height = '250px'));
			this.template
			.querySelectorAll('.qnouterbox2')
			.forEach((box) => (box.style.height = '227px'));
		}
		if (viewportWidth >= 1201 && viewportWidth <= 1360) {
			this.template
			.querySelectorAll('.qnouterbox')
			.forEach((box) => (box.style.height = '286px'));
			this.template
			.querySelectorAll('.qnouterbox1')
			.forEach((box) => (box.style.height = '237px'));
			this.template
			.querySelectorAll('.qnouterbox2')
			.forEach((box) => (box.style.height = '210px'));
		}
		} else {
		// Clear error messages and remove red border
		this.errorMessageCheck = '';
		this.errorFlag = false;
		this.template
			.querySelectorAll('.numbox')
			.forEach((input) => input.classList.remove('red-border'));
		if (viewportWidth >= 320 && viewportWidth <= 399) {
			this.template
			.querySelectorAll('.qnouterbox')
			.forEach((box) => (box.style.height = '278px'));
			this.template
			.querySelectorAll('.qnouterbox1')
			.forEach((box) => (box.style.height = '214px'));
			this.template
			.querySelectorAll('.qnouterbox2')
			.forEach((box) => (box.style.height = '195px'));
		}
		if (viewportWidth >= 399 && viewportWidth <= 576) {
			this.template
			.querySelectorAll('.qnouterbox')
			.forEach((box) => (box.style.height = '268px'));
			this.template
			.querySelectorAll('.qnouterbox1')
			.forEach((box) => (box.style.height = '216px'));
			this.template
			.querySelectorAll('.qnouterbox2')
			.forEach((box) => (box.style.height = '198px'));
		}
		if (viewportWidth >= 1201 && viewportWidth <= 1360) {
			this.template
			.querySelectorAll('.qnouterbox')
			.forEach((box) => (box.style.height = '266px'));
			this.template
			.querySelectorAll('.qnouterbox1')
			.forEach((box) => (box.style.height = '218px'));
			this.template
			.querySelectorAll('.qnouterbox2')
			.forEach((box) => (box.style.height = '198px'));
		}
		}

		// Display the error message only when the total exceeds 168 and at least one field has a value
	}

	/**
	* Navigates the user to the DLQI questionnaire page based on the current URL.
	*/
	navigateToCategory2() {
		window.location.assign(this.urlq + dlqiUrl);
	}

	/**
	* Navigates the user to the PSS questionnaire page based on the current URL.
	*/
	navigateToCategory3() {
		window.location.assign(this.urlq + pssQuestionarrieUrl);
	}

	/**
	* Navigates the user to the appropriate QSQ questionnaire page based on the presence of target dates.
	* If target14wksdate is not null, navigates to QSQ questionnaire page 2, else navigates to QSQ questionnaire page 1.
	*/
	navigateToCategory5() {
		if (this.target14wksdate != null) {
		window.location.assign(this.urlq + qualitativeFourteenMonths); // Navigate to page 2
		} else {
		window.location.assign(this.urlq + qualitativeTwoMonths); // Navigate to page 1
		}
	}

	//this method will get invoked when user clicks the return back to Question button to make sure that all the radio buttons other input fields states  are as it is like the previous state before clicking the retrun back Question button.
	closePopup1() {
		this.customFormModal = false;
		document.body.style.overflow = '';
		this.isPopupOpen1 = false;
		this.popupmenu = false;
        
		if (this.firstQuestionResponse === this.yes) {
		this.firstQuesIsYes = true;
		} else if (this.firstQuestionResponse === this.no) {
		this.firstQuesIsNo = true;
		}
        
		if (this.secondQuestionResponse !== null) {

		this.firstNumberValue = this.secondRspValue;

		if(typeof this.secondRspValue ==='undefined')
			{
			this.firstNumberValue = this.secondDraftResp;
			}
				
		}

		if (this.thirdQuestionResponse !== null) {
		this.secondNumberValue = this.thirdRspValue;
		
			if(typeof this.thirdRspValue ==='undefined')
			{
			this.secondNumberValue = this.thirdDraftResp;
			}
		
		}
        
		if (this.fourthQuestionResponse !== null) {
		this.thirdNumberValue = this.fourthRspValue;
			
			if(typeof this.fourthRspValue ==='undefined')
			{
			this.thirdNumberValue = this.fourthDraftRes;
			}
		
		}
		if (typeof this.fifthResonseValue !== 'undefined') {
		this.sliderValue = this.fifthResonseValue;
		this.sliderValue = this.fifthDraftResp;
		this.updateThumbLabelPosition(this.sliderValue);
		}

		if (typeof this.fifthDraftResp !== 'undefined') {
		this.sliderValue = this.fifthDraftResp;

		this.updateThumbLabelPosition(this.sliderValue);
		}

		if (typeof this.sixthResponseValue !== 'undefined') {
		this.sliderValuesec = this.sixthResponseValue;

		this.updateThumbLabelPositionsec(this.sliderValuesec);
		}

		if (typeof this.sixthDraftResp !== 'undefined') {
		this.sliderValuesec = this.sixthDraftResp;

		this.updateThumbLabelPosition(this.sliderValuesec);
		}
	}
	aMethodForYes() {
		if (this.fifthQuestionresponse === '') {
		this.sliderValue = 0;
		this.updateThumbLabelPosition(this.sliderValue);
		}
	}

	//this method will get invoked when user clicks the cancel button to make sure that all the radio buttons other input fields states  are as it is like the previous state before clicking the cancel button.

	closePopup() {
		document.body.style.overflow = '';
		this.isPopupOpen = false;
		this.popupmenu = false;

		if (this.firstQuestionResponse === this.yes) {
		this.firstQuesIsYes = true;
	this.yesOrNo=false;
		} else if (this.firstQuestionResponse === this.no) {
			this.yesOrNo=true;
		    this.firstRspValue=this.no;
			this.firstQuesIsYes = false;
		this.firstQuesIsNo = true;
			
		this.firstNumberValue='';
		
		this.secondNumberValue='';
		this.thirdNumberValue='';
		this.sliderValue='';
			
		this.secondDraftResp='';
		
		this.thirdDraftResp='';
		this.fourthDraftRes='';
		this.fifthDraftResp='';
		 }

		if (this.secondQuestionResponse !== null) {
		this.firstNumberValue = this.secondRspValue;
		this.reposneModeeOn();
		}

		if (this.thirdQuestionResponse !== null) {
		this.secondNumberValue = this.thirdRspValue;
		this.reposneModeeOn();
		}

		if (this.fourthQuestionResponse !== null) {
		this.thirdNumberValue = this.fourthRspValue;
		this.reposneModeeOn();
		}

		if (this.fifthQuestionresponse !== null) {
		this.sliderValue = this.fifthQuestionresponse;
		this.updateThumbLabelPosition(this.sliderValue);
		this.reposneModeeOn();
		}

		if (this.sixthQuestionResponse !== null) {
		this.sliderValuesec = this.sixthQuestionResponse;
		this.updateThumbLabelPositionsec(this.sliderValuesec);
		this.reposneModeeOn();
		}
	}

	//this method will get invoked when you click on the submit button.
	saveResponse() {
		/**
		* Adjusts the overflow style of the body element based on whether the view is in desktop mode.
		* If in desktop mode, sets overflow to 'hidden', otherwise resets it to default.
		*/
		 if(this.firstRspValue =='No')
	   {
	
		  this.isDesktop=false;
		  this.errorFlag=false;
	   }
		
		if (this.isDesktop) {
			
		document.body.style.overflow = 'hidden';
		} else {
			
		document.body.style.overflow = ''; // Reset to default
		}
      
		this.popupmenu = true;

		//the below if conditions check whether the darft responses are present for all the Questions.if it is then we will assign value to the name attribute of  respective Questions.
		if (
		typeof this.firstDraftResp !== 'undefined' &&
		this.firstDraftResp !== ''
		) {
		this.nameToDraftFirst = 'question1';
		}
		if (
		typeof this.secondDraftResp !== 'undefined' &&
		this.secondDraftResp !== ''
		) {
		this.nameToDraftSecond = 'firstNumberField';
		}
		if (
		typeof this.thirdDraftResp !== 'undefined' &&
		this.thirdDraftResp !== ''
		) {
		this.nameToDraftThird = 'secondNumberField';
		}
		if (
		typeof this.fourthDraftRes !== 'undefined' &&
		this.fourthDraftRes !== ''
		) {
		this.nameToDraftFourth = 'thirdNumberField';
		}
		if (
		typeof this.fifthDraftResp !== 'undefined' &&
		this.fifthDraftResp !== ''
		) {
		this.nameToDraftFifth = 'firstQuestionName';
		}
		if (
		typeof this.sixthDraftResp !== 'undefined' &&
		this.sixthDraftResp !== ''
		) {
		this.nameToDraftSixth = 'thestone';
		}
		//the below if conditions check if all the Responses are submitted or not.if they are submitted the we will show the confirmation popup other wise we will show them the return back to popup.

		if (
		(this.nameToDraftFirst === 'question1' &&
		this.nameToDraftSixth === 'thestone' &&
		typeof this.nameToDraftSecond === 'undefined' &&
		typeof this.nameToDraftThird === 'undefined' &&
		typeof this.nameToDraftFourth === 'undefined' &&
		typeof this.nameToDraftFifth === 'undefined') || 	(this.nameToDraftFirst === 'question1' &&
		this.nameToDraftSixth === 'thestone' &&
		 this.nameToDraftSecond === '' &&
		 this.nameToDraftThird === '' &&
		 this.nameToDraftFourth === '' &&
		 this.nameToDraftFifth === '')
		) {
		if (this.firstRspValue === this.no || this.firstDraftResp === this.no) {
		
			this.drfatNoCheck = true;
			this.isPopupOpen = true;
		}
		if (
			this.firstRspValue === this.yes ||
			(this.firstDraftResp === this.yes && this.firstRspValue !== this.no)
		) {
		
			this.customFormModal = true;
			this.isPopupOpen1 = true;
			this.isPopupOpen = false;
			this.checkyesorno = false;
		}
		}

		if (
		this.nameToDraftFirst === 'question1' &&
		this.nameToDraftSecond === 'firstNumberField' &&
		this.nameToDraftThird === 'secondNumberField' &&
		this.nameToDraftFourth === 'thirdNumberField' &&
		this.nameToDraftFifth === 'firstQuestionName' &&
		this.nameToDraftSixth === 'thestone'
		) {
		
		if (this.firstRspValue === this.yes || this.firstDraftResp === this.yes) {
			this.isPopupOpen = true;
		
		}
		} else {
		if (this.firstRspValue === this.no || this.firstDraftResp === this.no) {
			if (typeof this.sixthResponseValue !== 'undefined') {
			
			this.isPopupOpen = true;
			this.noCheck = 'true';
			} else {
			if (this.drfatNoCheck === false) {
				this.customFormModal = true;
				this.isPopupOpen1 = true;
				this.isPopupOpen = false;
			
			}
			}
		} else {
			this.customFormModal = true;
			this.isPopupOpen1 = true;
			this.isPopupOpen = false;
		
		}
		}

		//this if condition checks if the sum of all the three number field values exeeds 168 if it is then we wont show any kind of pop at all.and the user will get to see the error message too.
		if (this.errorFlag === true) {
		
		this.isPopupOpen = false;
		this.popupmenu = false;
		document.body.style.overflow = '';
		}
	}

	//Returns 'disabled' if the popup menu is visible, otherwise returns an empty string.

	get popuphide() {
		if (this.popupmenu === true) {
		return this.popupmenu === true ? 'disabled' : '';
		}
		return '';
	}

	//this method will get invoked when the user clicks the save as draft button and saves the responses as draft respoonses.Status of the assessment will be in progress.
	saveAsDraft() {
		//this will check if the sum of three number fields are not exceeding 168
		if (this.errorFlag !== true) {
		/**
		* Adjusts the overflow style of the body element based on whether the view is in desktop mode.
		* If in desktop mode, sets overflow to 'hidden', otherwise resets it to default.
		*/
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = ''; // Reset to default
		}
		this.popupmenu = true;
        
		//the below if conditions will check wther the responses and its version ids are present or not.If  it is we will push responses and its ids to the array else we will be pushing the draft responses and its version ids to theh array.
		if (this.firstRspValue != null) {
			this.realrespArray.push(this.firstRspValue);
		} else {
			this.realrespArray.push(this.firstDraftResp);
		}

		if (this.firstRespVersId != null) {
			this.realAssesVerArra.push(this.firstRespVersId);
		} else {
			this.realAssesVerArra.push(this.firstDraftVerionId);
		}

		if (this.secondRspValue != null) {
			this.realrespArray.push(this.secondRspValue);
		} else {
			this.realrespArray.push(this.secondDraftResp);
		}

		if (this.secondRespVersId != null) {
			this.realAssesVerArra.push(this.secondRespVersId);
		} else {
			this.realAssesVerArra.push(this.secondDraftVerionId);
		}

		if (this.thirdRspValue != null) {
			this.realrespArray.push(this.thirdRspValue);
		} else {
			this.realrespArray.push(this.thirdDraftResp);
		}

		if (this.thirdVersionId != null) {
			this.realAssesVerArra.push(this.thirdVersionId);
		} else {
			this.realAssesVerArra.push(this.thirdDraftVersionId);
		}

		if (this.fourthRspValue != null) {
			this.realrespArray.push(this.fourthRspValue);
		} else {
			this.realrespArray.push(this.fourthDraftRes);
		}

		if (this.fourthVersionId != null) {
			this.realAssesVerArra.push(this.fourthVersionId);
		} else {
			this.realAssesVerArra.push(this.fourthDraftVersionId);
		}

		if (this.fifthResonseValue != null) {
			this.realrespArray.push(this.fifthResonseValue);
		} else {
			this.realrespArray.push(this.fifthDraftResp);
		}

		if (this.fifthVersionId != null) {
			this.realAssesVerArra.push(this.fifthVersionId);
		} else {
			this.realAssesVerArra.push(this.fifthDraftVersionId);
		}

		if (this.sixthResponseValue != null) {
			this.realrespArray.push(this.sixthResponseValue);
		} else {
			this.realrespArray.push(this.sixthDraftResp);
		}

		if (this.sixthVersiD != null) {
			this.realAssesVerArra.push(this.sixthVersiD);
		} else {
			this.realAssesVerArra.push(this.sixthDraftVersionId);
		}
		// Filter out non-empty responses from the realrespArray
		const nonEmptyResponses = this.realrespArray.filter(
			(response) => response !== ''
		);
		// Filter out non-empty IDs from the realAssesVerArra
		const nonEmptyIds = this.realAssesVerArra.filter((id) => id !== '');
		//this will insert the draft responses  in to the database
		submitDraftResonse({
			darftQuestionIds: nonEmptyIds,
			draftResponseTexts: nonEmptyResponses
		})
			.then(() => {
			this.customFormModal = false;
			this.closePopup1 = false;
			this.checkyesorno = false;
			//this will open the custom pop up method when clicked on the save as draft button and also the after the operation being successfull.
			this.popUpMetod();
			})
			.catch((error) => {
			this.showToast(consoleErrorMessage, error.message, errorvariant);
			// Handle any errors that occur during the response save
			});
		}
	}

	//custom pop up method as per requirement it should be deplay for certain ms 
	popUpMetod() {
		try {
		window.scrollTo({ top: 0, behavior: 'smooth' });
		setTimeout(() => {
			this.isDraftSavedPopupOpen = true;
		}, 650);
		} catch (error) {
		// Handle any errors here
		this.showToast(consoleErrorMessage, error.message, errorvariant);
		}
	}

	//this will close the popup method and make a naviagtion
	closeDraftSavedPopup() {
		this.isDraftSavedPopupOpen = false;
		window.location.assign(this.urlq + outStandingPage);
	}

	//this method will get invoked when the user clicks the confirm button  and saves the responses as in completed.Status of the assessment will be in Completed state.
	confirmSubmission() {
		// Redirect to the OutStanding Questionnaire

		window.location.assign(this.urlq + outStandingPage);

		//the below if conditions will check whether the responses and its version ids are present or not.If  it is we will push responses and its ids to the array else we will be pushing the draft responses and its version ids to the array.

		if (this.firstRspValue != null) {
		this.realrespArray.push(this.firstRspValue);
		} else {
		this.realrespArray.push(this.firstDraftResp);
		}

		if (this.firstRespVersId != null) {
		this.realAssesVerArra.push(this.firstRespVersId);
		} else {
		this.realAssesVerArra.push(this.firstDraftVerionId);
		}

		if (this.secondRspValue != null) {
		this.realrespArray.push(this.secondRspValue);
		} else {
		this.realrespArray.push(this.secondDraftResp);
		}

		if (this.secondRespVersId != null) {
		this.realAssesVerArra.push(this.secondRespVersId);
		} else {
		this.realAssesVerArra.push(this.secondDraftVerionId);
		}

		if (this.thirdRspValue != null) {
		this.realrespArray.push(this.thirdRspValue);
		} else {
		this.realrespArray.push(this.thirdDraftResp);
		}

		if (this.thirdVersionId != null) {
		this.realAssesVerArra.push(this.thirdVersionId);
		} else {
		this.realAssesVerArra.push(this.thirdDraftVersionId);
		}

		if (this.fourthRspValue != null) {
		this.realrespArray.push(this.fourthRspValue);
		} else {
		this.realrespArray.push(this.fourthDraftRes);
		}

		if (this.fourthVersionId != null) {
		this.realAssesVerArra.push(this.fourthVersionId);
		} else {
		this.realAssesVerArra.push(this.fourthDraftVersionId);
		}
		//fifth resp and versin starts here

		if (this.fifthResonseValue != null) {
		this.realrespArray.push(this.fifthResonseValue);
		} else {
		this.realrespArray.push(this.fifthDraftResp);
		}

		if (this.fifthVersionId != null) {
		this.realAssesVerArra.push(this.fifthVersionId);
		} else {
		this.realAssesVerArra.push(this.fifthDraftVersionId);
		}
		//fifth resp and versin ends here

		//Sixth resp and versin starts here

		if (this.sixthResponseValue != null) {
		this.realrespArray.push(this.sixthResponseValue);
		} else {
		this.realrespArray.push(this.sixthDraftResp);
		}

		if (this.sixthVersiD != null) {
		this.realAssesVerArra.push(this.sixthVersiD);
		} else {
		this.realAssesVerArra.push(this.sixthDraftVersionId);
		}

		const responseArray = [];
		const versionIdArray = [];

		for (let i = 0; i <= this.realrespArray.length; i++) {
		const responseValue = this.realrespArray[i];

		const versionId = this.realAssesVerArra[i];

		if (typeof responseValue !== 'undefined') {
			responseArray.push(responseValue);
		}

		if (typeof versionId !== 'undefined') {
			versionIdArray.push(versionId);
		}
		}

		//gets the number ofresponses
		this.numberOfResponses = responseArray.filter(
		(response) => typeof response != 'undefined'
		).length;

		if (this.numberOfResponses === 2 || this.numberOfResponses === 6) {
		// Filter out non-empty responses from the realrespArray
		const nonEmptyResponses = this.realrespArray.filter(
			(response) => response !== ''
		);
		// Filter out non-empty IDs from the realAssesVerArra
		const nonEmptyIds = this.realAssesVerArra.filter((id) => id !== '');
		//this will insert the submit responses  in to the database
		submitResonse({
			questionIds: nonEmptyIds,
			responseTexts: nonEmptyResponses
		});
		}
	}
	// showToast used for all the error messages caught
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
		title: title,
		message: message,
		variant: variant
		});
		this.dispatchEvent(event);
	}
	}