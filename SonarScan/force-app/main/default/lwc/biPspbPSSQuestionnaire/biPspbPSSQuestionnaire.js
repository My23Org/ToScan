//This Component enables users to assess the severity of their psoriasis condition using the Psoriasis Symptom Scale questionnaire.
//To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getAssessmentQuestions from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.getPsoriasisAssesmentQues';
import submitAssessmentResponse from '@salesforce/apex/BI_PSP_Assessment.ranswerOfTheQuestion';
import draftResponseSubmition from '@salesforce/apex/BI_PSP_Assessment.mulitipleDraftRecordsInsertion';
import draftResponseOfPsoriasis from '@salesforce/apex/BI_PSP_RetriveDraftResponse.draftResponseOfPsoriasis';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
import getDateInprogrsCard from '@salesforce/apex/BI_PSP_CardDateForInProgress.getTheDateInProgessForCardPSS';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName';
import getRolloutdate from '@salesforce/apex/BI_PSP_Assessment.getRolloutdate';
//To get UserId
import Id from '@salesforce/user/Id';
//To import Static Resource
import BI_PSP_PSSimage from '@salesforce/resourceUrl/BI_PSP_PSSimage';
import BI_PSP_letspersonalizeimage from '@salesforce/resourceUrl/BI_PSP_letspersonalizeimage';
import BI_PSP_DLQIimage from '@salesforce/resourceUrl/BI_PSP_DLQIimage';
import BI_PSP_WPAIimage from '@salesforce/resourceUrl/BI_PSP_WPAIimage';
import BI_PSP_Qualitativeimage from '@salesforce/resourceUrl/BI_PSP_Qualitativeimage';
//To import Custom labels
import BI_PSP_introductionCategory from '@salesforce/label/c.BI_PSP_introductionCategory';
import BI_PSP_PssCategory from '@salesforce/label/c.BI_PSP_PssCategory';
import BI_PSP_WapiCategory from '@salesforce/label/c.BI_PSP_WapiCategory';
import BI_PSP_DlqiCategory from '@salesforce/label/c.BI_PSP_DlqiCategory';
import BI_PSP_QualitativeCategory from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import BI_PSP_Wapi from '@salesforce/label/c.BI_PSP_WAPI';
import BI_PSP_outstandingquestionnaire from '@salesforce/label/c.BI_PSP_outstandingquestionnaire';
import BI_PSP_verysevere from '@salesforce/label/c.BI_PSP_verysevere';
import BI_PSP_severe from '@salesforce/label/c.BI_PSP_severe';
import BI_PSP_moderate from '@salesforce/label/c.BI_PSP_moderate';
import BI_PSP_mild from '@salesforce/label/c.BI_PSP_mild';
import BI_PSP_none from '@salesforce/label/c.BI_PSP_none';
import BI_PSP_answered from '@salesforce/label/c.BI_PSP_answered';
import BI_PSP_submit from '@salesforce/label/c.BI_PSP_submit';
import BI_PSP_saveasdraft from '@salesforce/label/c.BI_PSP_saveasdraft';
import BI_PSP_rolloutdate from '@salesforce/label/c.BI_PSP_rolloutdate';
import BI_PSP_expireson from '@salesforce/label/c.BI_PSP_expireson';
import BI_PSP_returnback from '@salesforce/label/c.BI_PSP_returnback';
import BI_PSP_confirm_submission from '@salesforce/label/c.BI_PSP_confirm_submission';
import BI_PSP_cancel from '@salesforce/label/c.BI_PSP_cancel';
import BI_PSP_confirm from '@salesforce/label/c.BI_PSP_confirm';
import pss_category from '@salesforce/label/c.BI_PSP_PssCategory';
import BI_PSP_PSSbottomtext1 from '@salesforce/label/c.BI_PSP_PSSbottomtext1';
import BI_PSP_DLQIbottom3 from '@salesforce/label/c.BI_PSP_DLQIbottom3';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import submitmessage from '@salesforce/label/c.BI_PSP_submittext';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import qualitativeTwoMonths from '@salesforce/label/c.BI_PSPB_BRQualitativeTwoMonths';
import qualitativeFourteenMonths from '@salesforce/label/c.BI_PSPB_BRQualitativeFourteenWeeks';
import dlqiUrl from '@salesforce/label/c.BI_PSPB_BRDlqiQuestionnaireUrl';
import wapiQuestionnaire from '@salesforce/label/c.BI_PSPB_BRWapiQuestionnaire';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import pssQuestionarrieUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisQuesUrl';
import outStandingPage from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import inProgress from '@salesforce/label/c.BI_PSP_Inprogess';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import confirmmessage from '@salesforce/label/c.BI_PSP_confirmmessage';
import completedAll from '@salesforce/label/c.BI_PSP_CompleteAll';
import popupmessage from '@salesforce/label/c.BI_PSP_Messagepopup';
export default class BiPspbPSSQuestionnaire extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track isBarRadioChecked = false;
	@track isNoneChecked = false;
	@track isDesktop = false;
	@track isConfirmationDialogOpen = false;
	@track customFormModal = false;
	@track message = completedAll;
	@track content1 = submitmessage;
	// Add a new boolean property to track if the draft saved popup is open
	@track isDraftSavedPopupOpen = false;
	@track draftSavedMessage = popupmessage;
	@track isMildChecked = false;
	@track isModerateChecked = false;
	@track isSevereChecked = false;
	@track isBarVerySeverChecked = false;
	//the draft number
	@track totalDraftResponses = 0;
	@track shouldFetchDraftResponses = true;
	@track secondNone = false;
	@track secondMild = false;
	@track secondModerate = false;
	@track secondSevere = false;
	@track secondVerySever = false;
	@track thirdNone = false;
	@track firstQuestionText;
	@track firstQuestionVersinId;
	@track secondQuestionText;
	@track secondQuestionVersinId;
	@track thirdQuestionText;
	@track thirdQuestionVersinId;
	@track fourthQuestionText;
	@track fourthQuestionVersinId;
	@track firstQuestionResponse = '';
	@track secondQuestionResponse = '';
	@track thirdQuestionResponse = '';
	@track fourthQuestionResponse = '';
	@track realAssesVerArra = [];
	@track realrespArray = [];
	@track arrayForPushResp = [];
	@track arrayForPushId = [];
	@track isPopupOpen = false;
	@track isPopupOpen1 = false;
	@track firstRspValue;
	@track firstRespVersId;
	@track secondRspValue;
	@track secondRespVersId;
	@track thirdRspValue;
	@track thirdVersionId;
	@track nameToDraftFirst;
	@track nameToDraftSecond;
	@track nameToDraftThird;
	@track nameToDraftFourth;
	@track fourthRspValue;
	@track fourthVersionId;
	@track selectedValues = {};
	@track firstResponseText;
	@track firstResponseVersinId;
	@track secondResponseText;
	@track secondResponseVersinId;
	@track thirdResponseText;
	@track thirdResponseVersinId;
	@track fourthResponseText;
	@track fourthResponseVersinId;
	//Global variables(without @track does not trigger automatic re-renders)
	drfatRecords = [];
	firstDraftResp;
	firstDraftVerionId;
	secondDraftResp;
	secondDraftVerionId;
	thirdDraftResp;
	thirdDraftVersionId;
	fourthDraftRes;
	fourthDraftVersionId;
	countquestion = 4;
	thirdMild = false;
	thirdModerate = false;
	thirdSevere = false;
	thirdVerySever = false;
	pssbottom1 = BI_PSP_PSSbottomtext1;
	pssbottom2 = BI_PSP_DLQIbottom3;
	fourthNone = false;
	fourthMild = false;
	fourthModerte = false;
	fourthSevere = false;
	fourthVerySevere = false;
	cardimage = BI_PSP_letspersonalizeimage;
	cardimage1 = BI_PSP_DLQIimage;
	cardimage2 = BI_PSP_PSSimage;
	cardimage3 = BI_PSP_WPAIimage;
	cardimage4 = BI_PSP_Qualitativeimage;
	introduction = BI_PSP_introductionCategory;
	pss = BI_PSP_PssCategory;
	dlqi = BI_PSP_DlqiCategory;
	wapi = BI_PSP_WapiCategory;
	qsq = BI_PSP_QualitativeCategory;
	workAPI = BI_PSP_Wapi;
	outstandingque = BI_PSP_outstandingquestionnaire;
	verysevere = BI_PSP_verysevere;
	severe = BI_PSP_severe;
	moderate = BI_PSP_moderate;
	mild = BI_PSP_mild;
	none = BI_PSP_none;
	answered = BI_PSP_answered;
	submit = BI_PSP_submit;
	saveasdraft = BI_PSP_saveasdraft;
	returnbackc = BI_PSP_returnback;
	rolloutdate = BI_PSP_rolloutdate;
	expireson = BI_PSP_expireson;
	confirmsub = BI_PSP_confirm_submission;
	cannotedit = confirmmessage;
	cancelbt = BI_PSP_cancel;
	confirmbt = BI_PSP_confirm;
	disablecmp;
	questionData = [];
	userid = Id;
	urlq;
	categoryname = pss_category;
	pssRollOutDate;
	expireDate;
	rolloutDate;
	draftResponses = [];
	assessmentId;
	target14wksdate;
	target2monthsdate;
	forteenWeeks;
	threeMonthsVar;
	dateResponses = [];
	storedate;
	popupmenu = false;
	rolloutdate1;
	isDataLoaded = false;
	//this method will get called once the component gets loaded in to the dom to get the current site url
	connectedCallback() {
		try {
		const currentURL = window.location.href;
		// Create a URL object
		const urlObject = new URL(currentURL);
		// Get the path
		const path = urlObject.pathname;
		// Split the path using '/' as a separator
		const pathComponents = path.split('/');
		// Find the component you need (in this case, 'Branded')
		const desiredComponent = pathComponents.find((component) =>
			[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
			component.toLowerCase()
			)
		);

		if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
			this.urlq = brandedUrlNavi;
		} else {
			this.urlq = unAssignedUrlNavi;
		}

		this.isDesktop = this.isDesktopView();
		window.addEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
		// Handle any errors that occur during the execution of the code above
		this.showToast(consoleErrorMessage, error.message, errorvariant); //Catching Potential Error
		}
	}

	// Define the function to execute when the custom element is disconnected from the document's DOM

	disconnectedCallback() {
		window.removeEventListener('resize', this.handleResize.bind(this));
	}
	// Define the function to handle window resize events
	handleResize() {
		this.isDesktop = this.isDesktopView();
	}

	// Define a helper function to determine if the current viewport width represents a desktop view

	isDesktopView() {
		// Retrieve the current viewport width
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

	// To retrieve assessment response 
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
		if (data) {
			this.count = data;

			// Check if count array has elements
			if (this.count.length > 0) {
			// Assign values to component properties
			this.stwai = this.count[0];
			this.stpss = this.count[1];
			this.stdlq = this.count[2];
			this.stqsq = this.count[3];
			}
		} else if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Getter method for checkdlqi property
	get checkdlqi() {
		// If stdlq is greater than 0, return 'disabled'; otherwise, return an empty string
		return this.stdlq > 0 ? 'disabled' : '';
	}

	// Getter method for checkpss property
	get checkpss() {
		// If stpss is greater than 0, return 'disabled'; otherwise, return an empty string
		return this.stpss > 0 ? 'disabled' : '';
	}

	// Getter method for checkwai property
	get checkwai() {
		// If stwai is greater than 0, return 'disabled'; otherwise, return an empty string
		return this.stwai > 0 ? 'disabled' : '';
	}

	// Getter method for checkqsq property
	get checkqsq() {
		// If target14wksdate and target2monthsdate are both null or stqsq is greater than 0, return 'disabled'
		if (
		(this.target14wksdate === null && this.target2monthsdate === null) ||
		this.stqsq > 0
		) {
		return 'disabled';
		}
		return '';
	}

	// Wire service to fetch data for in-progress cards
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getDateInprogrsCard)
	wiredDataForInprogress({ error, data }) {
		try {
		// Check if data is received and data loading flag is not set
		if (data && !this.isDataLoaded) {
			// Assign the received data to rolloutdate1
			this.rolloutdate1 = data;

			// Perform further processing if the status is 'In Progress' or 'Completed'
			if (this.status === inProgress || this.status === completedLabel) {
			// Set the expiration date based on the received rollout date
			this.expireApexdate = this.rolloutdate1;
			const currentDate = new Date(this.expireApexdate);
			this.rolloutDate = currentDate.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});

			// Calculate the expiration date
			const currentDate1 = new Date(this.rolloutDate);
			currentDate1.setDate(currentDate1.getDate() + 30);
			this.expireDate = currentDate1.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});

			// Calculate the number of days until expiration
			const todayMs = new Date().getTime();
			const expireDateMs = new Date(this.expireDate).getTime();
			const differenceInDays = Math.ceil(
				(expireDateMs - todayMs) / (1000 * 60 * 60 * 24)
			);

			// Set the expiresIn property
			this.expiresIn = differenceInDays;
			// Ensure expiresIn is capped at 30 days
			if (this.expiresIn > 30 || this.expiresIn < 0) {
				this.expiresIn = 30;
			}
			} else if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}

			// Set the data loading flag to true once data is loaded
			this.isDataLoaded = true;
		}
		} catch (err) {
		// Log any errors that occur during execution
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire service to fetch patient data after three months and fourteen weeks
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
		// Check if data is received successfully
		if (data) {
			// Assign the received data to respective properties
			this.threeMonthsVar = data.threeMonthsVar;
			this.forteenWeeks = data.forteenWeeks;

			// Assign target dates, defaulting to null if not present in the data
			this.target2monthsdate = data.target2monthsdate ?? null;
			this.target14wksdate = data.target14wksdate ?? null;
		} else if (error) {
			// Handle error if any
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		// Log any errors that occur during execution
		this.showToast(consoleErrorMessage, error.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire service to fetch assessments by current user name for PSS category
	/*Null checks are not performed because sometimes users may or may not have assessment records initially. 
    Even if there are no assessment records, we show the Questionaire page for the user to create assessment records. 
	The page will not be blank.
    */
	@wire(getAssessmentsByCurrentUserNamepss, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
		// Check if data is received successfully
		if (data) {
			// Assign assessmentId and status based on received data
			this.assessmentId = data.length > 0 ? data[0].Id : null;
			this.status = data.length > 0 ? data[0].AssessmentStatus : null;

			// Perform further processing if status is 'Expired'
			if (this.status === expired) {
			// Set expireApexdate based on received data
			this.expireApexdate =
				data.length > 0 ? data[0].ExpirationDateTime : null;

			// Convert expireApexdate to a readable format
			const currentDate = new Date(this.expireApexdate);
			this.rolloutDate = currentDate.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});

			// Calculate expiration date 30 days from rolloutDate
			const currentDate1 = new Date(this.rolloutDate);
			currentDate1.setDate(currentDate1.getDate() + 30);
			this.expireDate = currentDate1.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});

			// Calculate number of days until expiration
			const todayMs = new Date().getTime();
			const expireDateMs = new Date(this.expireDate).getTime();
			const differenceInDays = Math.ceil(
				(expireDateMs - todayMs) / (1000 * 60 * 60 * 24)
			);
			this.expiresIn = differenceInDays;
			}
		} else if (error) {
			// Handle error if any
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		// Log any errors that occur during execution
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire service to fetch rollout date
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getRolloutdate)
	wiredQSPData({ error, data }) {
		try {
		// Check if data is received successfully
		if (data) {
			// Assign dateResponses property based on received data
			this.dateResponses = data;
			// Perform further processing if assessmentId is not set
			if (!this.assessmentId) {
			// Loop through dateResponses and extract BI_PSP_PSS_RollOutDate__c
			this.dateResponses.forEach((item) => {
				this.storedate = item.BI_PSP_PSS_RollOutDate__c;
			});

			// Convert storedate to a readable format
			const currentDate = new Date(this.storedate);
			this.rolloutDate = currentDate.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});

			// Calculate expiration date 30 days from rolloutDate
			const currentDate1 = new Date(this.rolloutDate);
			currentDate1.setDate(currentDate1.getDate() + 30);
			this.expireDate = currentDate1.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});

			// Calculate number of days until expiration
			const todayMs = new Date().getTime();
			const expireDateMs = new Date(this.expireDate).getTime();
			const differenceInDays = Math.ceil(
				(expireDateMs - todayMs) / (1000 * 60 * 60 * 24)
			);
			this.expiresIn = differenceInDays;
			// Ensure expiresIn is capped at 30 days
			if (this.expiresIn > 30) {
				this.expiresIn = 30;
			}
			}
		} else if (error) {
			// Handle error if any
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		// Log any errors that occur during execution
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Getter for determining the CSS class of the main popup container
	get popupClass() {
		// If isPopupOpen is true, return 'popup-container', otherwise return 'popup-container hidden'
		return this.isPopupOpen ? 'popup-container' : 'popup-container hidden';
	}

	// Getter for determining the CSS class of the save draft popup container
	get popupClassSaveDraft() {
		// If isDraftSavedPopupOpen is true, return 'popup-containersaveasdr', otherwise return '.popup-containersaveasdr hidden'
		return this.isDraftSavedPopupOpen
		? 'popup-containersaveasdr'
		: 'popup-containersaveasdr hidden';
	}

	// Getter for determining the CSS class of the secondary popup container
	get popupClass1() {
		// If isPopupOpen1 is true, return 'popup2-container', otherwise return 'popup2-container hidden'
		return this.isPopupOpen1 ? 'popup2-container' : 'popup2-container hidden';
	}

	// Method to hide all modal popups
	customHideModalPopup() {
		// Set boolean properties to false to hide all popups
		this.customFormModal = false;
		this.isPopupOpen = false;
		this.isPopupOpen1 = false;
	}

	// Wire service to fetch draft responses of Psoriasis
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(draftResponseOfPsoriasis)
	wiredDraftResponses({ error, data }) {
		try {
		// Check if data is received successfully
		if (data) {
			this.drfatRecords = data;
			// Map the data to draftResponses array
			this.draftResponses = data.map((response) => ({
			id: response.Id,
			questionText: response.ResponseValue,
			activeVersionId: response.AssessmentQuestion
				? response.AssessmentQuestion.Id
				: null
			}));

			// Update the totalDraftResponses property
			this.totalDraftResponses = this.draftResponses.length;
			// If there are draft responses, extract data for first four questions
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
				}
				}
			}
			} else if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		}
		} catch (err) {
		// Log any errors that occur during execution
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//this method is for storing the draft response and its version id so that we can use these variables to save the draft response later ,also in this method we will be making the radio buttons as checked if the draft values matches with the values that are stored in to variables with their respective radio option values.

	getTheDraftEnabled() {
		//this for each  will go through each of the response record.
		this.drfatRecords.forEach((record) => {
		if (record.BI_PSP_ResponseOrder__c === 1) {
			if (
			record.ResponseValue === this.verysevere &&
			record.AssessmentQuestionId != null
			) {
			this.isBarVerySeverChecked = true;
			this.firstDraftResp = record.ResponseValue;
			this.firstDraftVerionId = record.AssessmentQuestionId;
			}
			if (
			record.ResponseValue === this.severe &&
			record.AssessmentQuestionId != null
			) {
			this.isSevereChecked = true;
			this.firstDraftResp = record.ResponseValue;
			this.firstDraftVerionId = record.AssessmentQuestionId;
			}
			if (
			record.ResponseValue === this.moderate &&
			record.AssessmentQuestionId != null
			) {
			this.isModerateChecked = true;
			this.firstDraftResp = record.ResponseValue;
			this.firstDraftVerionId = record.AssessmentQuestionId;
			}

			if (
			record.ResponseValue === this.mild &&
			record.AssessmentQuestionId != null
			) {
			this.isMildChecked = true;
			this.firstDraftResp = record.ResponseValue;
			this.firstDraftVerionId = record.AssessmentQuestionId;
			}

			if (
			record.ResponseValue === this.none &&
			record.AssessmentQuestionId != null
			) {
			this.isNoneChecked = true;
			this.firstDraftResp = record.ResponseValue;
			this.firstDraftVerionId = record.AssessmentQuestionId;
			}
		}

		if (record.BI_PSP_ResponseOrder__c === 2) {
			if (
			record.ResponseValue === this.verysevere &&
			record.AssessmentQuestionId != null
			) {
			this.secondVerySever = true;
			this.secondDraftResp = record.ResponseValue;
			this.secondDraftVerionId = record.AssessmentQuestionId;
			}
			if (
			record.ResponseValue === this.severe &&
			record.AssessmentQuestionId != null
			) {
			this.secondSevere = true;
			this.secondDraftResp = record.ResponseValue;
			this.secondDraftVerionId = record.AssessmentQuestionId;
			}
			if (
			record.ResponseValue === this.moderate &&
			record.AssessmentQuestionId != null
			) {
			this.secondModerate = true;
			this.secondDraftResp = record.ResponseValue;
			this.secondDraftVerionId = record.AssessmentQuestionId;
			}

			if (
			record.ResponseValue === this.mild &&
			record.AssessmentQuestionId != null
			) {
			this.secondMild = true;
			this.secondDraftResp = record.ResponseValue;
			this.secondDraftVerionId = record.AssessmentQuestionId;
			}

			if (
			record.ResponseValue === this.none &&
			record.AssessmentQuestionId != null
			) {
			this.secondNone = true;
			this.secondDraftResp = record.ResponseValue;
			this.secondDraftVerionId = record.AssessmentQuestionId;
			}
		}

		if (record.BI_PSP_ResponseOrder__c === 3) {
			if (
			record.ResponseValue === this.verysevere &&
			record.AssessmentQuestionId != null
			) {
			this.thirdVerySever = true;
			this.thirdDraftResp = record.ResponseValue;
			this.thirdDraftVersionId = record.AssessmentQuestionId;
			}
			if (
			record.ResponseValue === this.severe &&
			record.AssessmentQuestionId != null
			) {
			this.thirdSevere = true;
			this.thirdDraftResp = record.ResponseValue;
			this.thirdDraftVersionId = record.AssessmentQuestionId;
			}
			if (
			record.ResponseValue === this.moderate &&
			record.AssessmentQuestionId != null
			) {
			this.thirdModerate = true;
			this.thirdDraftResp = record.ResponseValue;
			this.thirdDraftVersionId = record.AssessmentQuestionId;
			}

			if (
			record.ResponseValue === this.mild &&
			record.AssessmentQuestionId != null
			) {
			this.thirdMild = true;
			this.thirdDraftResp = record.ResponseValue;
			this.thirdDraftVersionId = record.AssessmentQuestionId;
			}

			if (
			record.ResponseValue === this.none &&
			record.AssessmentQuestionId != null
			) {
			this.thirdNone = true;
			this.thirdDraftResp = record.ResponseValue;
			this.thirdDraftVersionId = record.AssessmentQuestionId;
			}
		}

		if (record.BI_PSP_ResponseOrder__c === 4) {
			if (
			record.ResponseValue === this.verysevere &&
			record.AssessmentQuestionId != null
			) {
			this.fourthVerySevere = true;
			this.fourthDraftRes = record.ResponseValue;
			this.fourthDraftVersionId = record.AssessmentQuestionId;
			}
			if (
			record.ResponseValue === this.severe &&
			record.AssessmentQuestionId != null
			) {
			this.fourthSevere = true;
			this.fourthDraftRes = record.ResponseValue;
			this.fourthDraftVersionId = record.AssessmentQuestionId;
			}
			if (
			record.ResponseValue === this.moderate &&
			record.AssessmentQuestionId != null
			) {
			this.fourthModerte = true;
			this.fourthDraftRes = record.ResponseValue;
			this.fourthDraftVersionId = record.AssessmentQuestionId;
			}

			if (
			record.ResponseValue === this.mild &&
			record.AssessmentQuestionId != null
			) {
			this.fourthMild = true;
			this.fourthDraftRes = record.ResponseValue;
			this.fourthDraftVersionId = record.AssessmentQuestionId;
			}

			if (
			record.ResponseValue === this.none &&
			record.AssessmentQuestionId != null
			) {
			this.fourthNone = true;
			this.fourthDraftRes = record.ResponseValue;
			this.fourthDraftVersionId = record.AssessmentQuestionId;
			}
		}
		});
	}

	// Wire service to fetch assessment questions
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getAssessmentQuestions)
	wiredAssessmentQuestion({ error, data }) {
		try {
		// Check if data is received successfully
		if (data) {
			// Call the method to enable draft saving
			this.getTheDraftEnabled();
			// Map the received data to questionData array
			this.questionData = data.map((question) => ({
			id: question.Id,
			questionText: question.QuestionText,
			activeVersionId: question.ActiveVersion
				? question.ActiveVersion.Id
				: null
			}));
			// Extract data for the first four questions and assign them to respective properties
			const firstQuestion = this.questionData[0];
			const secondQuestion = this.questionData[1];
			const thirdQuestion = this.questionData[2];
			const fourthQuestion = this.questionData[3];

			this.firstQuestionText = firstQuestion.questionText;

			this.firstQuestionVersinId = firstQuestion.activeVersionId;

			this.secondQuestionText = secondQuestion.questionText;

			this.secondQuestionVersinId = secondQuestion.activeVersionId;

			this.thirdQuestionText = thirdQuestion.questionText;

			this.thirdQuestionVersinId = thirdQuestion.activeVersionId;

			this.fourthQuestionText = fourthQuestion.questionText;
			this.fourthQuestionVersinId = fourthQuestion.activeVersionId;
		} else if (error ) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	// Handle user input for the first question
	handleFirstQuestionChange(event) {
		const cehckedval = event.target.value;
		if (cehckedval === this.verysevere) {
		this.isBarVerySeverChecked = true;
		} else {
		this.isBarVerySeverChecked = false;
		}

		if (cehckedval === this.severe) {
		this.isSevereChecked = true;
		} else {
		this.isSevereChecked = false;
		}

		if (cehckedval === this.moderate) {
		this.isModerateChecked = true;
		} else {
		this.isModerateChecked = false;
		}

		if (cehckedval === this.mild) {
		this.isMildChecked = true;
		} else {
		this.isMildChecked = false;
		}

		if (cehckedval === this.none) {
		this.isNoneChecked = true;
		} else {
		this.isNoneChecked = false;
		}

		// Get the name of the question from the event

		this.nameOfQuestion = event.target.name;

		// Check if the current question is the first question
		if (this.nameOfQuestion === 'firstQuestionResponse') {
		// Update the first question response with the user's input
		this.firstQuestionResponse = event.target.value;
		this.nameToDraftFirst = event.target.name;

		// Push the response and its version ID to arrays if the response is not empty
		if (this.firstQuestionResponse !== '') {
			this.arrayForPushResp.push(this.firstQuestionResponse);
			this.arrayForPushId.push(this.firstQuestionVersinId);
		}

		// Get the last response value and version ID separately
		this.firstRspValue = this.getLastRespValue();
		this.firstRespVersId = this.getLastIdValue();
		}
	}

	// Method to get the last response value from the array
	getLastRespValue() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}

	// Method to get the last version ID from the array
	getLastIdValue() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	// Methods to navigate to different questionnaire categories
	navigateToCategory2() {
		window.location.assign(this.urlq + dlqiUrl);
	}

	navigateToCategory3() {
		window.location.assign(this.urlq + pssQuestionarrieUrl);
	}

	navigateToCategory4() {
		window.location.assign(this.urlq + wapiQuestionnaire);
	}

	navigateToCategory5() {
		// Navigate to different questionnaire pages based on the target date
		if (this.target14wksdate != null) {
		window.location.assign(this.urlq + qualitativeFourteenMonths); // Navigate to page 2
		} else {
		window.location.assign(this.urlq + qualitativeTwoMonths); // Navigate to page 1
		}
	}

	// Handle user input for the second question
	handleSecondQuestionChange(event) {
		const cehckedval = event.target.value;
		if (cehckedval === this.verysevere) {
		this.secondVerySever = true;
		} else {
		this.secondVerySever = false;
		}

		if (cehckedval === this.severe) {
		this.secondSevere = true;
		} else {
		this.secondSevere = false;
		}

		if (cehckedval === this.moderate) {
		this.secondModerate = true;
		} else {
		this.secondModerate = false;
		}

		if (cehckedval === this.mild) {
		this.secondMild = true;
		} else {
		this.secondMild = false;
		}

		if (cehckedval === this.none) {
		this.secondNone = true;
		} else {
		this.secondNone = false;
		}

		// Get the name of the question from the event
		this.nameOfQuestion = event.target.name;

		// Check if the current question is the second question
		if (this.nameOfQuestion === 'secondQuestionResponse') {
		// Update the second question response with the user's input
		this.secondQuestionResponse = event.target.value;
		this.nameToDraftSecond = event.target.name;

		// Push the response and its version ID to arrays if the response is not empty
		if (this.secondQuestionResponse !== '') {
			this.arrayForPushResp.push(this.secondQuestionResponse);
			this.arrayForPushId.push(this.secondQuestionVersinId);
		}

		// Get the last response value and version ID separately
		this.secondRspValue = this.getLastRespValueTwo();
		this.secondRespVersId = this.getLastIdValueTwo();
		}
	}

	// Method to get the last response value from the array
	getLastRespValueTwo() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}

	// Method to get the last version ID from the array
	getLastIdValueTwo() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	// Handle user input for the third question
	handleThirdQuestionChange(event) {
		const cehckedval = event.target.value;
		if (cehckedval === this.verysevere) {
		this.thirdVerySever = true;
		} else {
		this.thirdVerySever = false;
		}

		if (cehckedval === this.severe) {
		this.thirdSevere = true;
		} else {
		this.thirdSevere = false;
		}

		if (cehckedval === this.moderate) {
		this.thirdModerate = true;
		} else {
		this.thirdModerate = false;
		}

		if (cehckedval === this.mild) {
		this.thirdMild = true;
		} else {
		this.thirdMild = false;
		}

		if (cehckedval === this.none) {
		this.thirdNone = true;
		} else {
		this.thirdNone = false;
		}

		// Get the name of the question from the event
		this.nameOfQuestion = event.target.name;

		// Check if the current question is the third question
		if (this.nameOfQuestion === 'thirdQuestionResponse') {
		// Update the third question response with the user's input
		this.thirdQuestionResponse = event.target.value;
		this.nameToDraftThird = event.target.name;

		// Push the response and its version ID to arrays if the response is not empty
		if (this.thirdQuestionResponse !== '') {
			this.arrayForPushResp.push(this.thirdQuestionResponse);
			this.arrayForPushId.push(this.thirdQuestionVersinId);
		}

		// Get the last response value and version ID separately
		this.thirdRspValue = this.getLastRespValueThree();
		this.thirdVersionId = this.getLastIdValueThree();
		}
	}

	// Method to get the last response value from the array
	getLastRespValueThree() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}

	// Method to get the last version ID from the array
	getLastIdValueThree() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	// Method to handle user input for the fourth question
	handleFourthQuestionChange(event) {
		const cehckedval = event.target.value;
		if (cehckedval === this.verysevere) {
		this.fourthVerySevere = true;
		} else {
		this.fourthVerySevere = false;
		}

		if (cehckedval === this.severe) {
		this.fourthSevere = true;
		} else {
		this.fourthSevere = false;
		}

		if (cehckedval === this.moderate) {
		this.fourthModerte = true;
		} else {
		this.fourthModerte = false;
		}

		if (cehckedval === this.mild) {
		this.fourthMild = true;
		} else {
		this.fourthMild = false;
		}

		if (cehckedval === this.none) {
		this.fourthNone = true;
		} else {
		this.fourthNone = false;
		}

		// Get the name of the question from the event
		this.nameOfQuestion = event.target.name;

		// Check if the current question is the fourth question
		if (this.nameOfQuestion === 'fourthQuestionResponse') {
		// Update the fourth question response with the user's input
		this.fourthQuestionResponse = event.target.value;
		this.nameToDraftFourth = event.target.name;

		// Push the response and its version ID to arrays if the response is not empty
		if (this.fourthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.fourthQuestionResponse);
			this.arrayForPushId.push(this.fourthQuestionVersinId);
		}

		// Get the last response value and version ID separately
		this.fourthRspValue = this.getLastRespValueFour();
		this.fourthVersionId = this.getLastIdValueFour();
		}
	}

	// Method to get the last response value from the array
	getLastRespValueFour() {
		return this.arrayForPushResp.length > 0
		? this.arrayForPushResp[this.arrayForPushResp.length - 1]
		: null;
	}

	// Method to get the last version ID from the array
	getLastIdValueFour() {
		return this.arrayForPushId.length > 0
		? this.arrayForPushId[this.arrayForPushId.length - 1]
		: null;
	}

	//when you click on the cancel button in the confirm popup message this mehtod will get invoked and enable all the radio buttons if the provided values in the if condition are matched.

	closePopup() {
		this.isConfirmationDialogOpen = false;
		this.disablecmp = false;

		this.dispatchEvent(
		new CustomEvent('disablevent', {
			detail: this.disablecmp
		})
		);

		document.body.style.overflow = '';
		this.isPopupOpen = false;
		this.isPopupOpen = false;
		this.popupmenu = false;

		if (this.firstQuestionResponse === this.severe) {
		this.isSevereChecked = true;
		} else if (this.firstQuestionResponse === this.mild) {
		this.isMildChecked = true;
		} else if (this.firstQuestionResponse === this.moderate) {
		this.isModerateChecked = true;
		} else if (this.firstQuestionResponse === this.none) {
		this.isNoneChecked = true;
		} else if (this.firstQuestionResponse === this.verysevere) {
		this.isBarVerySeverChecked = true;
		}

		if (this.secondQuestionResponse === this.severe) {
		this.secondSevere = true;
		} else if (this.secondQuestionResponse === this.mild) {
		this.secondMild = true;
		} else if (this.secondQuestionResponse === this.moderate) {
		this.secondModerate = true;
		} else if (this.secondQuestionResponse === this.none) {
		this.secondNone = true;
		} else if (this.secondQuestionResponse === this.verysevere) {
		this.secondVerySever = true;
		}

		if (this.thirdQuestionResponse === this.severe) {
		this.thirdSevere = true;
		} else if (this.thirdQuestionResponse === this.mild) {
		this.thirdMild = true;
		} else if (this.thirdQuestionResponse === this.moderate) {
		this.thirdModerate = true;
		} else if (this.thirdQuestionResponse === this.none) {
		this.thirdNone = true;
		} else if (this.thirdQuestionResponse === this.verysevere) {
		this.thirdVerySever = true;
		}

		if (this.fourthQuestionResponse === this.severe) {
		this.fourthSevere = true;
		} else if (this.fourthQuestionResponse === this.mild) {
		this.fourthMild = true;
		} else if (this.fourthQuestionResponse === this.moderate) {
		this.fourthModerte = true;
		} else if (this.fourthQuestionResponse === this.none) {
		this.fourthNone = true;
		} else if (this.fourthQuestionResponse === this.verysevere) {
		this.fourthVerySevere = true;
		}
	}

	//when you click on the return back  button in the complete all the Question popup message this mehtod will get invoked and enable all the radio buttons if the provided values in the if condition are matched.

	closePopup1() {
		this.disablecmp = false;
		this.customFormModal = false;
		this.dispatchEvent(
		new CustomEvent('disablevent', {
			detail: this.disablecmp
		})
		);

		document.body.style.overflow = '';
		this.isPopupOpen1 = false;
		this.isPopupOpen1 = false;
		this.popupmenu = false;

		if (this.firstQuestionResponse === this.severe) {
		this.isSevereChecked = true;
		} else if (this.firstQuestionResponse === this.mild) {
		this.isMildChecked = true;
		} else if (this.firstQuestionResponse === this.moderate) {
		this.isModerateChecked = true;
		} else if (this.firstQuestionResponse === this.none) {
		this.isNoneChecked = true;
		} else if (this.firstQuestionResponse === this.verysevere) {
		this.isBarVerySeverChecked = true;
		}

		if (this.secondQuestionResponse === this.severe) {
		this.secondSevere = true;
		} else if (this.secondQuestionResponse === this.mild) {
		this.secondMild = true;
		} else if (this.secondQuestionResponse === this.moderate) {
		this.secondModerate = true;
		} else if (this.secondQuestionResponse === this.none) {
		this.secondNone = true;
		} else if (this.secondQuestionResponse === this.verysevere) {
		this.secondVerySever = true;
		}

		if (this.thirdQuestionResponse === this.severe) {
		this.thirdSevere = true;
		} else if (this.thirdQuestionResponse === this.mild) {
		this.thirdMild = true;
		} else if (this.thirdQuestionResponse === this.moderate) {
		this.thirdModerate = true;
		} else if (this.thirdQuestionResponse === this.none) {
		this.thirdNone = true;
		} else if (this.thirdQuestionResponse === this.verysevere) {
		this.thirdVerySever = true;
		}

		if (this.fourthQuestionResponse === this.severe) {
		this.fourthSevere = true;
		} else if (this.fourthQuestionResponse === this.mild) {
		this.fourthMild = true;
		} else if (this.fourthQuestionResponse === this.moderate) {
		this.fourthModerte = true;
		} else if (this.fourthQuestionResponse === this.none) {
		this.fourthNone = true;
		} else if (this.fourthQuestionResponse === this.verysevere) {
		this.fourthVerySevere = true;
		}
	}
	//when you hit the submit button this method will get invoked and check if all the  questions has been submitted by the user or not if he has submitted then we will show him the confirm popup message if it is not then we will show a return back popup message.
	submitResponses() {
		//if the this.isDesktop is true whether it has view port that we have configured with then the page will become non scrollable.
		if (this.isDesktop) {
		document.body.style.overflow = 'hidden';
		} else {
		document.body.style.overflow = '';
		}
		this.popupmenu = true;
		//the below set of if conditions check if the draft responses are present for each of the questions if it is then we wil the name varaible of all the Questions to a particular value.

		if (
		this.firstDraftResp !== '' &&
		typeof this.firstDraftResp !== 'undefined'
		) {
		this.nameToDraftFirst = 'firstQuestionResponse';
		}
		if (
		this.secondDraftResp !== '' &&
		typeof this.secondDraftResp !== 'undefined'
		) {
		this.nameToDraftSecond = 'secondQuestionResponse';
		}
		if (
		this.thirdDraftResp !== '' &&
		typeof this.thirdDraftResp !== 'undefined'
		) {
		this.nameToDraftThird = 'thirdQuestionResponse';
		}
		if (
		this.fourthDraftRes !== '' &&
		typeof this.fourthDraftRes !== 'undefined'
		) {
		this.nameToDraftFourth = 'fourthQuestionResponse';
		}

		//this will check if all the quesions are submitted with responses or not
		if (
		this.nameToDraftFirst != null &&
		this.nameToDraftSecond != null &&
		this.nameToDraftThird != null &&
		this.nameToDraftFourth != null
		) {
		this.isPopupOpen = true;
		this.disablecmp = true;

		this.dispatchEvent(
			new CustomEvent('disablevent', {
			detail: this.disablecmp
			})
		);
		} else {
		this.customFormModal = true;
		this.isPopupOpen1 = true;
		this.isPopupOpen = false;

		this.disablecmp = true;
		// Dispatches a custom event named 'disablevent' with the detail of whether the component should be disabled
		this.dispatchEvent(
			new CustomEvent('disablevent', {
			detail: this.disablecmp
			})
		);
		}
	}
	// Make page disable
	get popuphide() {
		if (this.popupmenu === true) {
		return this.popupmenu === true ? 'disabled' : '';
		}
		return '';
	}

	//this method will get invoked when you click the save as draft button
	saveAsDraft() {
		if (this.isDesktop) {
		document.body.style.overflow = 'hidden';
		} else {
		document.body.style.overflow = '';
		}

		this.popupmenu = true;
		//this wil check whether the user has filled first Questions response or not if he hasnt then the else part we will push the draft response

		if (this.firstRspValue != null) {
		this.realrespArray.push(this.firstRspValue);
		} else {
		this.realrespArray.push(this.firstResponseText);
		}
		//this wil check whether the user has filled first Questions response or not if he hasnt then the else part we will push the draft response and this is for response ids

		if (this.firstRespVersId != null) {
		this.realAssesVerArra.push(this.firstRespVersId);
		} else {
		this.realAssesVerArra.push(this.firstResponseVersinId);
		}

		if (this.secondRspValue != null) {
		this.realrespArray.push(this.secondRspValue);
		} else {
		this.realrespArray.push(this.secondResponseText);
		}

		if (this.secondRespVersId != null) {
		this.realAssesVerArra.push(this.secondRespVersId);
		} else {
		this.realAssesVerArra.push(this.secondResponseVersinId);
		}

		if (this.thirdRspValue != null) {
		this.realrespArray.push(this.thirdRspValue);
		} else {
		this.realrespArray.push(this.thirdResponseText);
		}

		if (this.thirdVersionId != null) {
		this.realAssesVerArra.push(this.thirdVersionId);
		} else {
		this.realAssesVerArra.push(this.thirdResponseVersinId);
		}

		if (this.fourthRspValue != null) {
		this.realrespArray.push(this.fourthRspValue);
		} else {
		this.realrespArray.push(this.fourthResponseText);
		}

		if (this.fourthVersionId != null) {
		this.realAssesVerArra.push(this.fourthVersionId);
		} else {
		this.realAssesVerArra.push(this.fourthResponseVersinId);
		}

		// Filter out empty responses and their corresponding IDs
		const nonEmptyResponses = this.realrespArray.filter(
		(response) => response !== ''
		);
		const nonEmptyIds = this.realAssesVerArra.filter((id) => id !== '');

		//check whether realrespArray is greater or not than zero
		if (this.realrespArray.length > 0) {
		draftResponseSubmition({
			darftQuestionIds: nonEmptyIds,
			draftResponseTexts: nonEmptyResponses
		})
			.then(() => {
			this.customFormModal = false;
			this.closePopup1 = false;
			this.checkyesorno = false;
			//this method will call the asve as draft custom pop up method
			this.popUpMetod();
			})
			.catch((error) => {
			this.showToast(consoleErrorMessage, error.message, errorvariant); //Catching Potential Error
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
		this.showToast(consoleErrorMessage, error.message, errorvariant); //Catching Potential Error
		}
	}
	//this will close the custom save as draft popup message
	closeDraftSavedPopup() {
		this.isDraftSavedPopupOpen = false;
		window.location.assign(this.urlq + outStandingPage);
	}
	//this method is for Confirm Submission pop up message, when you click on the confim button this will get invoked.

	confirmSubmission() {
		// Redirect logic based on questionnaire completion status

		// If all questionnaires are completed, redirect to outstanding page

		//this will check whether the response is null or not if it is null the it will push the drfat response

		if (this.firstRspValue != null) {
		this.realrespArray.push(this.firstRspValue);
		} else {
		this.realrespArray.push(this.firstResponseText);
		}
		//this will check whether the response is null or not if it is null the it will push the drfat response version id

		if (this.firstRespVersId != null) {
		this.realAssesVerArra.push(this.firstRespVersId);
		} else {
		this.realAssesVerArra.push(this.firstResponseVersinId);
		}

		if (this.secondRspValue != null) {
		this.realrespArray.push(this.secondRspValue);
		} else {
		this.realrespArray.push(this.secondResponseText);
		}

		if (this.secondRespVersId != null) {
		this.realAssesVerArra.push(this.secondRespVersId);
		} else {
		this.realAssesVerArra.push(this.secondResponseVersinId);
		}

		if (this.thirdRspValue != null) {
		this.realrespArray.push(this.thirdRspValue);
		} else {
		this.realrespArray.push(this.thirdResponseText);
		}

		if (this.thirdVersionId != null) {
		this.realAssesVerArra.push(this.thirdVersionId);
		} else {
		this.realAssesVerArra.push(this.thirdResponseVersinId);
		}

		if (this.fourthRspValue != null) {
		this.realrespArray.push(this.fourthRspValue);
		} else {
		this.realrespArray.push(this.fourthResponseText);
		}

		if (this.fourthVersionId != null) {
		this.realAssesVerArra.push(this.fourthVersionId);
		} else {
		this.realAssesVerArra.push(this.fourthResponseVersinId);
		}

		//checks if the realrespArray greter than zero or not
		if (this.realrespArray.length > 0) {
		submitAssessmentResponse({
			questionIds: this.realAssesVerArra,
			responseTexts: this.realrespArray
		})
			.then(() => {
			window.location.assign(this.urlq + outStandingPage);
			})
			.catch((error) => {
			this.showToast(consoleErrorMessage, error.message, errorvariant); //Catching Potential Error
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