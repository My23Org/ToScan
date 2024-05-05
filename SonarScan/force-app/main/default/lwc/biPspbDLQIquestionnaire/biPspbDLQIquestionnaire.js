//This DLQI questionnaire page(LWC) allows users to measure the impact of their skin problems on their quality of life over the past week.
//To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getAsmntQueFromDermatology from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.getDermatologyAssesmentQues';
import submitDraftDermatology from '@salesforce/apex/BI_PSP_Assessment.mulitipleDraftRecordsInsertion';
import submitConfirmedResponses from '@salesforce/apex/BI_PSP_Assessment.ranswerOfTheQuestion';
import draftResponseOfDermatology from '@salesforce/apex/BI_PSP_RetriveDraftResponse.draftResponseOfDermatology';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
import getDateInprogrsCard from '@salesforce/apex/BI_PSP_CardDateForInProgress.getTheDateInProgessForCard';
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
import BI_PSP_yes from '@salesforce/label/c.BI_PSP_yes';
import BI_PSP_no from '@salesforce/label/c.BI_PSP_no';
import BI_PSP_verymuch from '@salesforce/label/c.BI_PSP_verymuch';
import BI_PSP_alot from '@salesforce/label/c.BI_PSP_alot';
import BI_PSP_alittle from '@salesforce/label/c.BI_PSP_alittle';
import BI_PSP_notatall from '@salesforce/label/c.BI_PSP_notatall';
import BI_PSP_notrelevant from '@salesforce/label/c.BI_PSP_notrelevant';
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
import BI_PSP_DLQIbottom1 from '@salesforce/label/c.BI_PSP_DLQIbottom1';
import BI_PSP_DLQIbottom2 from '@salesforce/label/c.BI_PSP_DLQIbottom2';
import BI_PSP_DLQIbottom3 from '@salesforce/label/c.BI_PSP_DLQIbottom3';
import BI_PSP_dlqibottom4 from '@salesforce/label/c.BI_PSP_dlqibottom4';
import getRolloutdate from '@salesforce/apex/BI_PSP_Assessment.getRolloutdate';
import dlqi_category from '@salesforce/label/c.BI_PSP_DlqiCategory';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import popupmessage from '@salesforce/label/c.BI_PSP_Messagepopup';
import submitmessage from '@salesforce/label/c.BI_PSP_submittext';
import confirmmessage from '@salesforce/label/c.BI_PSP_confirmmessage';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import inProgress from '@salesforce/label/c.BI_PSP_Inprogess';
import completedAll from '@salesforce/label/c.BI_PSP_CompleteAll';
import outStandingPage from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import pssQuestionarrieUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisQuesUrl';
import qualitativeTwoMonths from '@salesforce/label/c.BI_PSPB_BRQualitativeTwoMonths';
import qualitativeFourteenMonths from '@salesforce/label/c.BI_PSPB_BRQualitativeFourteenWeeks';
import wapiQuestionnaire from '@salesforce/label/c.BI_PSPB_BRWapiQuestionnaire';
//To get UserId
import Id from '@salesforce/user/Id';
export default class BiPspbDLQIquestionnaire extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track eigthQuestionVisible = false;
	@track numberOfResponses;
	@track checkyesorno = false;
	@track firstQuestionText;
	@track firstQuestionVersinId;
	@track secondQuestionText;
	@track secondQuestionVersinId;
	@track thirdQuestionText;
	@track thirdQuestionVersinId;
	@track fourthQuestionText;
	@track fourthQuestionVersinId;
	@track fifthQuestionText;
	@track fifthQuestionVersinId;
	@track sixthQuestionText;
	@track sixthQuestionVersinId;
	@track seventhQuestionText;
	@track seventhQuestionVersinId;
	@track eightQuestionText;
	@track eightQuestionVersinId;
	@track ninthQuestionText;
	@track ninthQuestionVersinId;
	@track tenthQuestionText;
	@track tenthQuestionVersinId;
	@track eleventhQuestionText;
	@track eleventhQuestionVerionID;
	@track firstQuestionResponse = '';
	@track secondQuestionResponse = '';
	@track thirdQuestionResponse = '';
	@track fourthQuestionResponse = '';
	@track fifthQuestionresponse = '';
	@track sixthQuestionResponse = '';
	@track seventhQuestionResponse = '';
	@track eightQuestionResponse = '';
	@track ninthQuestionResponse = '';
	@track tenthQuestionResponse = '';
	@track eleventhQuestionResponse = '';
	@track totalDraftResponses = 0;
	@track realAssesVerArra = [];
	@track realrespArray = [];
	@track arrayForPushResp = [];
	@track arrayForPushId = [];
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
	@track seventhRespalue;
	@track seventhVersiD;
	@track eghtResponseValue;
	@track eightVersiId;
	@track ninthResponseValue;
	@track ninthVersId;
	@track tenthResponseValue;
	@track tenthVersId;
	@track eleventhResponseValue;
	@track eleventhVersId;
	@track firstResponseText;
	@track firstResponseVersinId;
	@track secondResponseText;
	@track secondResponseVersinId;
	@track thirdResponseText;
	@track thirdResponseVersinId;
	@track fourthResponseText;
	@track fourthResponseVersinId;
	@track fifthResponseText;
	@track fifthResponseVersionId;
	@track sixthResponseText;
	@track SixthResponseVersionId;
	@track seventhResponseText;
	@track SeventhResponseVersionId;
	@track eighthResponseText;
	@track EigthResponseVersionId;
	@track ninthResponseText;
	@track NinthResponseVersionId;
	@track tenthResponseText;
	@track tenthResponseVersionId;
	@track eleventhResponseText;
	@track eleventhResponseVersionId;
	@track isPopupOpen = false;
	@track isPopupOpen1 = false;
	@track nameToDraftFirst;
	@track nameToDraftSecond;
	@track nameToDraftThird;
	@track nameToDraftFourth;
	@track nameToDraftFifth;
	@track nameToDraftSixth;
	@track nameToDraftSeventh;
	@track nameToDraftEighth;
	@track nameToDraftNinth;
	@track nameToDrafttenth;
	@track nameToDraftEleventh;
	@track firstRadVerMuch = false;
	@track firstRadAlot = false;
	@track firstRadALittle = false;
	@track firstRadSevere = false;
	@track secondRadVerMch = false;
	@track secondRadAlot = false;
	@track secondRadAlittle = false;
	@track secondRadNotAtAll = false;
	@track thirdRadVerMch = false;
	@track thirdRadAlot = false;
	@track thirdRadAlittle = false;
	@track thirdRadNotAll = false;
	@track thirdRadNotReelevent = false;
	@track fourthRadVeryMch = false;
	@track fourthRadAlot = false;
	@track fourthRadVAlittle = false;
	@track fourthRadNotAtll = false;
	@track fourthRadNotRelevetn = false;
	@track fifthRadVeryMch = false;
	@track fifthRadAlot = false;
	@track fifthRadAlittle = false;
	@track fifthRadNotAtAll = false;
	@track fifthRadNotRelevent = false;
	@track sixthRadVeryMuch = false;
	@track sixthRadAlot = false;
	@track sixthRadAlittle = false;
	@track sixthRadNotAtAll = false;
	@track sixthRadNotRelevent = false;
	@track eighthRadNotAtAll = false;
	@track eighthRadAlot = false;
	@track eighthRadAlittle = false;
	@track ninthRadverMuch = false;
	@track ninthRadAlot = false;
	@track ninthRadAlittle = false;
	@track ninthRadNotAtAll = false;
	@track ninthRadNotRelevent = false;
	@track tenthRadverMuch = false;
	@track tenthRadAlot = false;
	@track tenthRadAlittle = false;
	@track tenthRadNotAtAll = false;
	@track tenthRadNotRelevent = false;
	@track isConfirmationDialogOpen = false;
	@track customFormModal = false;
	@track message = completedAll;
	@track content1 = submitmessage;
	@track rolloutdate1;
	@track isDraftSavedPopupOpen = false;
	@track draftSavedMessage = popupmessage;
	//Global variables(without @track does not trigger automatic re-renders)
	istenthTru = false;
	isFirstTrue = false;
	countquestion = 10;
	questionData = [];
	cardimage = BI_PSP_letspersonalizeimage;
	cardimage1 = BI_PSP_DLQIimage;
	cardimage2 = BI_PSP_PSSimage;
	cardimage3 = BI_PSP_WPAIimage;
	cardimage4 = BI_PSP_Qualitativeimage;
	userid = Id;
	introduction = BI_PSP_introductionCategory;
	pss = BI_PSP_PssCategory;
	dlqi = BI_PSP_DlqiCategory;
	wapi = BI_PSP_WapiCategory;
	qsq = BI_PSP_QualitativeCategory;
	workAPI = BI_PSP_Wapi;
	dlqib1 = BI_PSP_DLQIbottom1;
	dlqib2 = BI_PSP_DLQIbottom2;
	dlqib3 = BI_PSP_DLQIbottom3;
	dlqib4 = BI_PSP_dlqibottom4;
	verymuch = BI_PSP_verymuch;
	alot = BI_PSP_alot;
	alittle = BI_PSP_alittle;
	notatall = BI_PSP_notatall;
	notrelevant = BI_PSP_notrelevant;
	yes = BI_PSP_yes;
	no = BI_PSP_no;
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
	popupmenu = false;
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
	seventhDraftResp;
	seventhDraftVersionId;
	eigthDraftResp;
	eigthDraftVersionId;
	ninthDraftResp;
	ninthDraftVersionId;
	tenthDraftResp;
	tenthDraftVersionId;
	eleventhDraftResp;
	eleventhDraftVersionId;
	target14wksdate;
	target2monthsdate;
	forteenWeeks;
	threeMonthsVar;
	payload;
	draftResponse1 = 0;
	assessmentId;
	dateResponses = [];
	storedate;
	responsOfDLQI = [];
	categoryname = dlqi_category;
	dlqiRollOutDate;
	rolloutDate;
	expireDate;
	isDataLoaded = false;
	urlq;

	// This function is called when the component is connected to the DOM
	connectedCallback() {
		try {
			// Find the current URL of the page
			const currentURL = window.location.href;
			// Log the user ID
			// Create a URL object from the current URL
			const urlObject = new URL(currentURL);
			// Get the pathname from the URL object
			const path = urlObject.pathname;
			// Split the pathname into components using '/' as a separator
			const pathComponents = path.split('/');
			// Find the desired component ('Branded' or 'Unassigned') in the pathname
			const desiredComponent = pathComponents.find((component) =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
					component.toLowerCase()
				)
			);

			// Determine which URL component is currently active and assign it to 'this.urlq'
			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedUrlNavi;
			} else {
				this.urlq = unAssignedUrlNavi;
			}

			// Check if the current view is on desktop or not
			this.isDesktop = this.isDesktopView();

			// Add an event listener for window resize events and bind it to the 'handleResize' function
			window.addEventListener('resize', this.handleResize.bind(this));
		}
		catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from Apex
		}
	}

	// This function is called when the component is disconnected from the DOM
	disconnectedCallback() {
		// Remove the event listener for window resize events
		window.removeEventListener('resize', this.handleResize.bind(this));
	}

	// This function is called when the window is resized
	handleResize() {
		// Update the 'isDesktop' property based on the current viewport width
		this.isDesktop = this.isDesktopView();
	}

	// This function determines if the current view is on a desktop device
	isDesktopView() {
		// Get the current viewport width
		const viewportWidth = window.innerWidth;

		// Adjust this threshold based on your design's breakpoints
		// Example breakpoints at 1024, 400, 576, 769, 993, and 1200 pixels
		return (
			viewportWidth >= 1024 ||
			viewportWidth <= 400 ||
			viewportWidth <= 576 ||
			viewportWidth <= 769 ||
			viewportWidth <= 993 ||
			viewportWidth <= 1200
		);
	}

	// Wire method to fetch assessment count data from the countAssessment Apex method
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
			if (data) {
				// If data is received, update component properties
				this.count = data;

				// If there are records in the response, update component properties accordingly
				if (this.count.length > 0) {
					this.stwai = this.count[0];
					this.stpss = this.count[1];
					this.stdlq = this.count[2];
					this.stqsq = this.count[3];
				}
			} else if (error) {
				// Display error message to the user
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			// Catch any errors that occur during execution and log them
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Getter method to determine if the 'CheckDLQI' button should be disabled
	get checkdlqi() {
		return this.stdlq > 0 ? 'disabled' : '';
	}

	// Getter method to determine if the 'CheckPSS' button should be disabled
	get checkpss() {
		return this.stpss > 0 ? 'disabled' : '';
	}

	// Getter method to determine if the 'CheckWAI' button should be disabled
	get checkwai() {
		return this.stwai > 0 ? 'disabled' : '';
	}

	// Getter method to determine if the 'CheckQSQ' button should be disabled
	get checkqsq() {
		// Check if target dates are null and if QSQ count is greater than 0
		if (this.target14wksdate === null && this.target2monthsdate === null) {
			return 'disabled';
		} else if (this.stqsq > 0) {
			return 'disabled';
		}
		return '';
	}

	// Wire method to fetch data for in-progress cards from the getDateInprogrsCard Apex method
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getDateInprogrsCard)
	wiredDataForInprogress({ data, error }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			} else if (data && !this.isDataLoaded) {
				// If data is received and not already loaded, process and update component properties
				this.rolloutdate1 = data;

				// If status is 'In Progress' or 'Completed', calculate expiration date
				if (this.status === inProgress || this.status === completedLabel) {
					this.expireApexdate = this.rolloutdate1;

					const currentDate = new Date(this.expireApexdate);

					// Calculate rollout date
					this.rolloutDate = currentDate.toLocaleDateString('en-US', {
						year: 'numeric',
						month: 'short',
						day: 'numeric'
					});

					const currentDate1 = new Date(this.rolloutDate);

					// Calculate expiration date (30 days from rollout date)
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

					// Update expiresIn property
					this.expiresIn = differenceInDays;

					// If expiresIn is greater than 30 or less than 0, set it to 30
					if (this.expiresIn > 30 || this.expiresIn < 0) {
						this.expiresIn = 30;
					}
				}

				this.isDataLoaded = true; // Set to true once data is loaded
			}
		} catch (err) {
			// Catch any errors that occur during execution and log them
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire method to fetch assessments based on the current user's category name
	/*Null checks are not performed because sometimes users may or may not have assessment records initially. 
	Even if there are no assessment records, we show the Questionaire page for the user to create assessment records. 
	The page will not be blank.
	*/
	@wire(getAssessmentsByCurrentUserNamepss, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
			if (data) {
				// If data is received, process it
				this.assessmentId = data.length > 0 ? data[0].Id : null;
				this.status = data.length > 0 ? data[0].AssessmentStatus : null;

				// If the assessment status is 'Expired', calculate expiration date
				if (this.status === 'Expired') {
					this.expireApexdate =
						data.length > 0 ? data[0].ExpirationDateTime : null;
					const currentDate = new Date(this.expireApexdate);
					this.rolloutDate = currentDate.toLocaleDateString('en-US', {
						year: 'numeric',
						month: 'short',
						day: 'numeric'
					});

					// Calculate expiration date (30 days from rollout date)
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
				// Log error message if there's an error fetching assessments
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			// Catch any errors that occur during execution and log them
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire method to fetch data for patients after three months and fourteen weeks
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
			if (data) {
				// If data is received, update component properties
				this.threeMonthsVar = data.threeMonthsVar;
				this.forteenWeeks = data.forteenWeeks;
				this.target2monthsdate = data.target2monthsdate ?? null;
				this.target14wksdate = data.target14wksdate ?? null;
			} else if (error) {
				// Log error message if there's an error fetching data
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			// Catch any errors that occur during execution and log them
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire method to fetch rollout date data
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getRolloutdate)
	wiredQSPData({ error, data }) {
		try {
			// Process data if available
			if (data) {
				// Store the received data
				this.dateResponses = data;

				// Check if rollout date is not already set
				if (!this.rolloutDate) {
					// Loop through data to find the rollout date
					this.dateResponses.forEach((item) => {
						// Store the rollout date
						this.storedate = item.BI_PSP_DLQI_RollOutDate__c;
					});

					// Convert rollout date to a formatted string
					const currentDate = new Date(this.storedate);
					this.rolloutDate = currentDate.toLocaleDateString('en-US', {
						year: 'numeric',
						month: 'short',
						day: 'numeric'
					});

					// Calculate expiration date (30 days from rollout date)
					const currentDate1 = new Date(this.rolloutDate);
					currentDate1.setDate(currentDate1.getDate() + 30);
					this.expireDate = currentDate1.toLocaleDateString('en-US', {
						year: 'numeric',
						month: 'short',
						day: 'numeric'
					});

					// Calculate difference in days until expiration
					const todayMs = new Date().getTime();
					const expireDateMs = new Date(this.expireDate).getTime();
					const differenceInDays = Math.ceil(
						(expireDateMs - todayMs) / (1000 * 60 * 60 * 24)
					);
					this.expiresIn = differenceInDays;

					// Ensure expiresIn does not exceed 30 days
					if (this.expiresIn > 30) {
						this.expiresIn = 30;
					}
				}
			} else if (error) {
				// Log error if fetching data fails
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Getter method to determine the CSS class for the main popup container
	get popupClass() {
		return this.isPopupOpen ? 'popup-container' : 'popup-container hidden';
	}

	// Getter method to determine the CSS class for the save draft popup container
	get popupClassSaveDraft() {
		return this.isDraftSavedPopupOpen
			? 'popup-containersaveasdr'
			: ' .popup-containersaveasdr hidden';
	}

	// Getter method to determine the CSS class for the secondary popup container
	get popupClass1() {
		return this.isPopupOpen1 ? 'popup2-container' : 'popup2-container hidden';
	}

	// Method to hide all modal popups
	customHideModalPopup() {
		this.isPopupOpen = false;
		this.isPopupOpen1 = false;
		this.customFormModal = false;
	}

	// Wire method to fetch draft responses of Drmatology
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(draftResponseOfDermatology)
	wiredDraftResponses({ error, data }) {
		try {
			if (data) {
				const objectsWithResponseOrder7 = data.filter(
					(item) => item.BI_PSP_ResponseOrder__c === 7
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
				if (objectsWithResponseOrder7.length > 0) {
					if (
						this.draftResponses.length > this.countquestion ||
						objectsWithResponseOrder7[0].ResponseText === this.no
					) {
						this.countquestion = 11;
					} else {
						this.countquestion = 10;
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

								// Continue similarly for the fifth question
								if (this.draftResponses.length >= 5) {
									const fifthResponse = this.draftResponses[4];

									this.fifthResponseText = fifthResponse.questionText;

									this.fifthResponseVersionId = fifthResponse.activeVersionId;

									// Continue similarly for the sixth question
									if (this.draftResponses.length >= 6) {
										const sixthQuestion = this.draftResponses[5];

										this.sixthResponseText = sixthQuestion.questionText;

										this.SixthResponseVersionId = sixthQuestion.activeVersionId;

										// Continue similarly for the seventh question
										if (this.draftResponses.length >= 7) {
											const seventhQuestion = this.draftResponses[6];

											this.seventhResponseText = seventhQuestion.questionText;

											this.SeventhResponseVersionId =
												seventhQuestion.activeVersionId;

											// Continue similarly for the eigth question
											if (this.draftResponses.length >= 8) {
												const eighthQuestion = this.draftResponses[7];

												this.eighthResponseText = eighthQuestion.questionText;

												this.EigthResponseVersionId =
													eighthQuestion.activeVersionId;

												// Continue similarly for the ninth question
												if (this.draftResponses.length >= 9) {
													const ninthQuestion = this.draftResponses[8];

													this.ninthResponseText = ninthQuestion.questionText;

													this.NinthResponseVersionId =
														ninthQuestion.activeVersionId;

													// Continue similarly for the tenth question
													if (this.draftResponses.length >= 10) {
														const tenthQuestion = this.draftResponses[9];

														this.tenthResponseText = tenthQuestion.questionText;

														this.tenthResponseVersionId =
															tenthQuestion.activeVersionId;

														// Continue similarly for the elevnth question
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
			// Catch any errors that occur during processing
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//this method is for storing the draft response and its version id to class variables so that we can use these variables to save the draft response later ,also in this method we will be making the radio buttons as checked if the draft values matches with the values that are stored in to variables with their respective radio option values.
	draftResonsesForLaterSubmission() {
		const firstVeryMuch = this.verymuch;
		const firstradAlot = this.alot;
		const firstAlitle = this.alittle;
		const firstSevere = this.notatall;

		const secVeryMuch = this.verymuch;
		const secadAlot = this.alot;
		const secAlitle = this.alittle;
		const secNotAtAll = this.notatall;

		const thirVeryMuch = this.verymuch;
		const thirdadAlot = this.alot;
		const thirdAlitle = this.alittle;
		const thirdNotAtAll = this.notatall;
		const thirdNotRelevent = this.notrelevant;

		const fourthVeryMuch = this.verymuch;
		const fourthadAlot = this.alot;
		const fourthAlitle = this.alittle;
		const fourthNotAtAll = this.notatall;
		const fourthNotRelevent = this.notrelevant;

		const fifthVeryMuch = this.verymuch;
		const fifthhadAlot = this.alot;
		const fifthAlitle = this.alittle;
		const fifthNotAtAll = this.notatall;
		const fifthNotRelevent = this.notrelevant;

		const sixthVeryMuch = this.verymuch;
		const sixthhadAlot = this.alot;
		const sixthAlitle = this.alittle;
		const sixthNotAtAll = this.notatall;
		const sixthNotRelevent = this.notrelevant;

		const seventhYes = this.yes;
		const seventhNo = this.no;
		const seventhNotRel = this.notrelevant;

		const eigthVeryMuch = this.notatall;
		const eigthhadAlot = this.alot;
		const eigthAlitle = this.alittle;

		const ninthVeryMuch = this.verymuch;
		const ninthhadAlot = this.alot;
		const ninthAlitle = this.alittle;
		const ninthNotAtAll = this.notatall;
		const ninthNotRelevent = this.notrelevant;

		const tenthVeryMuch = this.verymuch;
		const tenthhadAlot = this.alot;
		const tenthAlitle = this.alittle;
		const tenthNotAtAll = this.notatall;
		const tenthNotRelevent = this.notrelevant;

		const eleventhVeryMuch = this.verymuch;
		const eleventhhadAlot = this.alot;
		const eleventhAlitle = this.alittle;
		const eleventhNotAtAll = this.notatall;
		const eleventhNotRelevent = this.notrelevant;

		this.responsOfDLQI.forEach((record) => {
			if (
				record.ResponseValue === firstVeryMuch &&
				record.AssessmentQuestionId !== null &&
				record.BI_PSP_ResponseOrder__c === 1
			) {
				this.firstRadVerMuch = true;

				this.firstDraftResp = record.ResponseValue;
				this.firstDraftVerionId = record.AssessmentQuestionId;
			}
			if (
				record.ResponseValue === firstradAlot &&
				record.AssessmentQuestionId !== null &&
				record.BI_PSP_ResponseOrder__c === 1
			) {
				this.firstRadAlot = true;

				this.firstDraftResp = record.ResponseValue;
				this.firstDraftVerionId = record.AssessmentQuestionId;
			}
			if (
				record.ResponseValue === firstAlitle &&
				record.AssessmentQuestionId !== null &&
				record.BI_PSP_ResponseOrder__c === 1
			) {
				this.firstRadALittle = true;

				this.firstDraftResp = record.ResponseValue;
				this.firstDraftVerionId = record.AssessmentQuestionId;
			}

			if (
				record.ResponseValue === firstSevere &&
				record.BI_PSP_ResponseOrder__c === 1
			) {
				this.firstRadSevere = true;
				this.firstDraftResp = record.ResponseValue;
				this.firstDraftVerionId = record.AssessmentQuestionId;
			}

			if (this.firstDraftResp !== null) {
				this.isFirstTrue = true;
			}

			if (
				record.ResponseValue === secVeryMuch &&
				record.AssessmentQuestionId !== null &&
				record.BI_PSP_ResponseOrder__c === 2
			) {
				this.secondRadVerMch = true;

				this.secondDraftResp = record.ResponseValue;

				this.secondDraftVerionId = record.AssessmentQuestionId;
			}
			if (
				record.ResponseValue === secadAlot &&
				record.AssessmentQuestionId !== null &&
				record.BI_PSP_ResponseOrder__c === 2
			) {
				this.secondRadAlot = true;

				this.secondDraftResp = record.ResponseValue;

				this.secondDraftVerionId = record.AssessmentQuestionId;
			}
			if (
				record.ResponseValue === secAlitle &&
				record.AssessmentQuestionId !== null &&
				record.BI_PSP_ResponseOrder__c === 2
			) {
				this.secondRadAlittle = true;

				this.secondDraftResp = record.ResponseValue;

				this.secondDraftVerionId = record.AssessmentQuestionId;
			}
			if (
				record.ResponseValue === secNotAtAll &&
				record.AssessmentQuestionId !== null &&
				record.BI_PSP_ResponseOrder__c === 2
			) {
				this.secondRadNotAtAll = true;

				this.secondDraftResp = record.ResponseValue;

				this.secondDraftVerionId = record.AssessmentQuestionId;
			}

			if (record.BI_PSP_ResponseOrder__c === 3) {
				if (
					record.ResponseValue === thirVeryMuch &&
					record.AssessmentQuestionId !== null
				) {
					this.thirdRadVerMch = true;

					this.thirdDraftResp = record.ResponseValue;

					this.thirdDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === thirdadAlot &&
					record.AssessmentQuestionId !== null
				) {
					this.thirdRadAlot = true;

					this.thirdDraftResp = record.ResponseValue;

					this.thirdDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === thirdAlitle &&
					record.AssessmentQuestionId !== null
				) {
					this.thirdRadAlittle = true;

					this.thirdDraftResp = record.ResponseValue;

					this.thirdDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === thirdNotAtAll &&
					record.AssessmentQuestionId !== null
				) {
					this.thirdRadNotAll = true;

					this.thirdDraftResp = record.ResponseValue;

					this.thirdDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === thirdNotRelevent &&
					record.AssessmentQuestionId !== null
				) {
					this.thirdRadNotReelevent = true;

					this.thirdDraftResp = record.ResponseValue;

					this.thirdDraftVersionId = record.AssessmentQuestionId;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 4) {
				if (
					record.ResponseValue === fourthVeryMuch &&
					record.AssessmentQuestionId !== null
				) {
					this.fourthRadVeryMch = true;

					this.fourthDraftRes = record.ResponseValue;

					this.fourthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === fourthadAlot &&
					record.AssessmentQuestionId !== null
				) {
					this.fourthRadAlot = true;

					this.fourthDraftRes = record.ResponseValue;

					this.fourthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === fourthAlitle &&
					record.AssessmentQuestionId !== null
				) {
					this.fourthRadVAlittle = true;

					this.fourthDraftRes = record.ResponseValue;

					this.fourthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === fourthNotAtAll &&
					record.AssessmentQuestionId !== null
				) {
					this.fourthRadNotAtll = true;

					this.fourthDraftRes = record.ResponseValue;

					this.fourthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === fourthNotRelevent &&
					record.AssessmentQuestionId !== null
				) {
					this.fourthRadNotRelevetn = true;

					this.fourthDraftRes = record.ResponseValue;

					this.fourthDraftVersionId = record.AssessmentQuestionId;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 5) {
				if (
					record.ResponseValue === fifthVeryMuch &&
					record.AssessmentQuestionId !== null
				) {
					this.fifthRadVeryMch = true;

					this.fifthDraftResp = record.ResponseValue;

					this.fifthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === fifthhadAlot &&
					record.AssessmentQuestionId !== null
				) {
					this.fifthRadAlot = true;

					this.fifthDraftResp = record.ResponseValue;

					this.fifthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === fifthAlitle &&
					record.AssessmentQuestionId !== null
				) {
					this.fifthRadAlittle = true;

					this.fifthDraftResp = record.ResponseValue;

					this.fifthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === fifthNotAtAll &&
					record.AssessmentQuestionId !== null
				) {
					this.fifthRadNotAtAll = true;

					this.fifthDraftResp = record.ResponseValue;

					this.fifthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === fifthNotRelevent &&
					record.AssessmentQuestionId !== null
				) {
					this.fifthRadNotRelevent = true;

					this.fifthDraftResp = record.ResponseValue;

					this.fifthDraftVersionId = record.AssessmentQuestionId;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 6) {
				if (
					record.ResponseValue === sixthVeryMuch &&
					record.AssessmentQuestionId != null
				) {
					this.sixthRadVeryMuch = true;

					this.sixthDraftResp = record.ResponseValue;

					this.sixthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === sixthhadAlot &&
					record.AssessmentQuestionId != null
				) {
					this.sixthRadAlot = true;

					this.sixthDraftResp = record.ResponseValue;

					this.sixthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === sixthAlitle &&
					record.AssessmentQuestionId != null
				) {
					this.sixthRadAlittle = true;

					this.sixthDraftResp = record.ResponseValue;

					this.sixthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === sixthNotAtAll &&
					record.AssessmentQuestionId != null
				) {
					this.sixthRadNotAtAll = true;

					this.sixthDraftResp = record.ResponseValue;

					this.sixthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === sixthNotRelevent &&
					record.AssessmentQuestionId != null
				) {
					this.sixthRadNotRelevent = true;

					this.sixthDraftResp = record.ResponseValue;

					this.sixthDraftVersionId = record.AssessmentQuestionId;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 7) {
				if (
					record.ResponseValue === seventhYes &&
					record.AssessmentQuestionId !== null
				) {
					this.seventhRadYes = true;

					this.seventhDraftResp = record.ResponseValue;

					// this.eigthQuestionVisible =  this.seventhDraftResp === this.yes;

					this.eigthQuestionVisible = false;
					this.seventhDraftVersionId = record.AssessmentQuestionId;
				}

				if (
					record.ResponseValue === seventhNo &&
					record.AssessmentQuestionId !== null
				) {
					this.seventhRadNo = true;
					this.eigthQuestionVisible = true;

					this.seventhDraftResp = record.ResponseValue;

					this.seventhDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === seventhNotRel &&
					record.AssessmentQuestionId !== null
				) {
					this.seventhRadNotRelevnt = true;

					this.eigthQuestionVisible = false;
					this.seventhDraftResp = record.ResponseValue;

					this.seventhDraftVersionId = record.AssessmentQuestionId;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 8) {
				if (
					record.ResponseValue === eigthVeryMuch &&
					record.AssessmentQuestionId !== null
				) {
					this.eighthRadNotAtAll = true;
					this.eigthDraftResp = record.ResponseValue;

					this.eigthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === eigthhadAlot &&
					record.AssessmentQuestionId !== null
				) {
					this.eighthRadAlot = true;

					this.eigthDraftResp = record.ResponseValue;

					this.eigthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === eigthAlitle &&
					record.AssessmentQuestionId !== null
				) {
					this.eighthRadAlittle = true;

					this.eigthDraftResp = record.ResponseValue;

					this.eigthDraftVersionId = record.AssessmentQuestionId;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 9) {
				if (
					record.ResponseValue === ninthVeryMuch &&
					record.AssessmentQuestionId !== null
				) {
					this.ninthRadverMuch = true;

					this.ninthDraftResp = record.ResponseValue;

					this.ninthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === ninthhadAlot &&
					record.AssessmentQuestionId !== null
				) {
					this.ninthRadAlot = true;

					this.ninthDraftResp = record.ResponseValue;

					this.ninthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === ninthAlitle &&
					record.AssessmentQuestionId !== null
				) {
					this.ninthRadAlittle = true;

					this.ninthDraftResp = record.ResponseValue;

					this.ninthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === ninthNotAtAll &&
					record.AssessmentQuestionId !== null
				) {
					this.ninthRadNotAtAll = true;

					this.ninthDraftResp = record.ResponseValue;

					this.ninthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === ninthNotRelevent &&
					record.AssessmentQuestionId !== null
				) {
					this.ninthRadNotRelevent = true;

					this.ninthDraftResp = record.ResponseValue;

					this.ninthDraftVersionId = record.AssessmentQuestionId;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 10) {
				if (
					record.ResponseValue === tenthVeryMuch &&
					record.AssessmentQuestionId !== null
				) {
					this.tenthRadverMuch = true;
					this.tenthDraftResp = record.ResponseValue;
					this.tenthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === tenthhadAlot &&
					record.AssessmentQuestionId !== null
				) {
					this.tenthRadAlot = true;
					this.tenthDraftResp = record.ResponseValue;
					this.tenthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === tenthAlitle &&
					record.AssessmentQuestionId !== null
				) {
					this.tenthRadAlittle = true;
					this.tenthDraftResp = record.ResponseValue;
					this.tenthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === tenthNotAtAll &&
					record.AssessmentQuestionId !== null
				) {
					this.tenthRadNotAtAll = true;

					this.tenthDraftResp = record.ResponseValue;
					this.tenthDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === tenthNotRelevent &&
					record.AssessmentQuestionId !== null
				) {
					this.tenthRadNotRelevent = true;

					this.tenthDraftResp = record.ResponseValue;
					this.tenthDraftVersionId = record.AssessmentQuestionId;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 11) {
				if (
					record.ResponseValue === eleventhVeryMuch &&
					record.AssessmentQuestionId != null
				) {
					this.eleventhRadverMuch = true;

					this.eleventhDraftResp = record.ResponseValue;

					this.eleventhDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === eleventhhadAlot &&
					record.AssessmentQuestionId != null
				) {
					this.eleventhRadAlot = true;

					this.eleventhDraftResp = record.ResponseValue;

					this.eleventhDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === eleventhAlitle &&
					record.AssessmentQuestionId != null
				) {
					this.eleventhRadAlittle = true;

					this.eleventhDraftResp = record.ResponseValue;

					this.eleventhDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === eleventhNotAtAll &&
					record.AssessmentQuestionId != null
				) {
					this.eleventhRadNotAtAll = true;

					this.eleventhDraftResp = record.ResponseValue;

					this.eleventhDraftVersionId = record.AssessmentQuestionId;
				}
				if (
					record.ResponseValue === eleventhNotRelevent &&
					record.AssessmentQuestionId != null
				) {
					this.eleventhRadNotRelevent = true;

					this.eleventhDraftResp = record.ResponseValue;

					this.eleventhDraftVersionId = record.AssessmentQuestionId;
				}
			}
		});
	}
	// Wire method to fetch assessment questions from dermatology
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getAsmntQueFromDermatology)
	wiredAssessmentQuestion({ error, data }) {
		try {
			if (data) {
				//we are calling this draft  method that we did for stioring the draft responses and question version ids.Also for making the radio buttons as checked.
				this.draftResonsesForLaterSubmission();

				this.questionData = data.map((question) => ({
					id: question.Id,
					questionText: question.QuestionText,
					activeVersionId: question.ActiveVersion
						? question.ActiveVersion.Id
						: null
				}));

				//here we will be storing the Questions to respective varaibles.
				const firstQuestion = this.questionData[0];
				const secondQuestion = this.questionData[1];
				const thirdQuestion = this.questionData[2];
				const fourthQuestion = this.questionData[3];
				const fifthQuestion = this.questionData[4];
				const sixthQuestion = this.questionData[5];
				const seventhQuestion = this.questionData[6];
				const eighthQuestion = this.questionData[7];
				const ninthQuestion = this.questionData[8];
				const tenthQuestion = this.questionData[9];
				const eleventhQuestion = this.questionData[10];

				this.firstQuestionText = firstQuestion.questionText;

				this.firstQuestionVersinId = firstQuestion.activeVersionId;

				this.secondQuestionText = secondQuestion.questionText;

				this.secondQuestionVersinId = secondQuestion.activeVersionId;

				this.thirdQuestionText = thirdQuestion.questionText;

				this.thirdQuestionVersinId = thirdQuestion.activeVersionId;

				this.fourthQuestionText = fourthQuestion.questionText;

				this.fourthQuestionVersinId = fourthQuestion.activeVersionId;

				this.fifthQuestionText = fifthQuestion.questionText;

				this.fifthQuestionVersinId = fifthQuestion.activeVersionId;

				this.sixthQuestionText = sixthQuestion.questionText;

				this.sixthQuestionVersinId = sixthQuestion.activeVersionId;

				this.seventhQuestionText = seventhQuestion.questionText;

				this.seventhQuestionVersinId = seventhQuestion.activeVersionId;

				this.eightQuestionText = eighthQuestion.questionText;

				this.eightQuestionVersinId = eighthQuestion.activeVersionId;

				this.ninthQuestionText = ninthQuestion.questionText;

				this.ninthQuestionVersinId = ninthQuestion.activeVersionId;

				this.tenthQuestionText = tenthQuestion.questionText;

				this.tenthQuestionVersinId = tenthQuestion.activeVersionId;

				this.eleventhQuestionText = eleventhQuestion.questionText;

				this.eleventhQuestionVerionID = eleventhQuestion.activeVersionId;
			} else if (error || data === null) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			// Catch any errors that occur during processing
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//this is a handler that we use to handle the responses of the First Question user input.
	handleFirstQuestionChange(event) {
		this.nameOfQuestion = event.target.name;

		const chekVal = event.target.value;
		if (chekVal === this.verymuch) {
			this.firstRadVerMuch = true;
		} else {
			this.firstRadVerMuch = false;
		}

		if (chekVal === this.alot) {
			this.firstRadAlot = true;
		} else {
			this.firstRadAlot = false;
		}

		if (chekVal === this.alittle) {
			this.firstRadALittle = true;
		} else {
			this.firstRadALittle = false;
		}

		if (chekVal === this.notatall) {
			this.firstRadSevere = true;
		} else {
			this.firstRadSevere = false;
		}

		if (this.nameOfQuestion === 'firstQuestionResponse') {
			this.firstQuestionResponse = event.target.value;
			this.nameToDraftFirst = event.target.name;

			if (this.firstQuestionResponse !== '') {
				this.arrayForPushResp.push(this.firstQuestionResponse);
				this.arrayForPushId.push(this.firstQuestionVersinId);
			}
			// Get the last values separately
			this.firstRspValue = this.getLastRespValue();
			this.firstRespVersId = this.getLastIdValue();
		}
	}
	//this is for getting the last checked response values seperately from the array
	getLastRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}
	//this is for getting the last checked response Id seperately from the array
	getLastIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	navigateToCategory3() {
		// Navigate to Category pss questionnaire
		window.location.assign(this.urlq + pssQuestionarrieUrl);
	}

	navigateToCategory4() {
		// Navigate to Category wapi questionnaire
		window.location.assign(this.urlq + wapiQuestionnaire);
	}

	navigateToCategory5() {
		// Check if target14wksdate is not null
		if (this.target14wksdate != null) {
			// Navigate to Category qsq 2 questionnaire - Page 2
			window.location.assign(this.urlq + qualitativeFourteenMonths); // Navigate to page 2
		} else {
			// Navigate to Category qsq 1 questionnaire - Page 1
			window.location.assign(this.urlq + qualitativeTwoMonths); // Navigate to page 1
		}
	}

	//this is a handler that we use to handle the responses of the Second Question user input.
	handleSecondQuestionChange(event) {
		// Get the name of the question from the event target
		this.nameOfQuestion = event.target.name;

		// Get the value of the selected option
		const chekVal = event.target.value;
		// Set boolean flags based on the selected option
		if (chekVal === this.verymuch) {
			this.secondRadVerMch = true;
		} else {
			this.secondRadVerMch = false;
		}

		if (chekVal === this.alot) {
			this.secondRadAlot = true;
		} else {
			this.secondRadAlot = false;
		}

		if (chekVal === this.alittle) {
			this.secondRadAlittle = true;
		} else {
			this.secondRadAlittle = false;
		}

		if (chekVal === this.notatall) {
			this.secondRadNotAtAll = true;
		} else {
			this.secondRadNotAtAll = false;
		}
		// Update the response value if the question name matches
		if (this.nameOfQuestion === 'secondQuestionResponse') {
			this.secondQuestionResponse = event.target.value;
			this.nameToDraftSecond = event.target.name;

			// Push the response and its corresponding version ID to arrays
			if (this.secondQuestionResponse !== '') {
				this.arrayForPushResp.push(this.secondQuestionResponse);
				this.arrayForPushId.push(this.secondQuestionVersinId);
			}
			// Get the last values separately
			this.secondRspValue = this.getLastRespValueTwo();
			this.secondRespVersId = this.getLastIdValueTwo();
		}
	}

	// Function to get the last response value from the array
	getLastRespValueTwo() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueTwo() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}
	//this is a handler that we use to handle the responses of the third Question user input.
	handleThirdQuestionChange(event) {
		// Get the name of the question from the event target
		this.nameOfQuestion = event.target.name;

		// Get the value of the selected option
		const chekVal = event.target.value;
		if (chekVal === this.verymuch) {
			this.thirdRadVerMch = true;
		} else {
			this.thirdRadVerMch = false;
		}

		if (chekVal === this.alot) {
			this.thirdRadAlot = true;
		} else {
			this.thirdRadAlot = false;
		}

		if (chekVal === this.alittle) {
			this.thirdRadAlittle = true;
		} else {
			this.thirdRadAlittle = false;
		}

		if (chekVal === this.notatall) {
			this.thirdRadNotAll = true;
		} else {
			this.thirdRadNotAll = false;
		}

		if (chekVal === this.notrelevant) {
			this.thirdRadNotReelevent = true;
		} else {
			this.thirdRadNotReelevent = false;
		}
		// Update the response value if the question name matches
		if (this.nameOfQuestion === 'thirdQuestionResponse') {
			this.thirdQuestionResponse = event.target.value;
			this.nameToDraftThird = event.target.name;

			// Push the response and its corresponding version ID to arrays
			if (this.thirdQuestionResponse !== '') {
				this.arrayForPushResp.push(this.thirdQuestionResponse);
				this.arrayForPushId.push(this.thirdQuestionVersinId);
			}
			// Get the last values separately
			this.thirdRspValue = this.getLastRespValueThree();
			this.thirdVersionId = this.getLastIdValueThree();
		}
	}
	// Function to get the last response value from the array
	getLastRespValueThree() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueThree() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}
	//this is a handler that we use to handle the responses of the Fourth Question user input.
	handleFourthQuestionChange(event) {
		// Get the name of the question from the event target
		this.nameOfQuestion = event.target.name;
		// Get the value of the selected option
		const chekVal = event.target.value;
		if (chekVal === this.verymuch) {
			this.fourthRadVeryMch = true;
		} else {
			this.fourthRadVeryMch = false;
		}

		if (chekVal === this.alot) {
			this.fourthRadAlot = true;
		} else {
			this.fourthRadAlot = false;
		}

		if (chekVal === this.alittle) {
			this.fourthRadVAlittle = true;
		} else {
			this.fourthRadVAlittle = false;
		}

		if (chekVal === this.notatall) {
			this.fourthRadNotAtll = true;
		} else {
			this.fourthRadNotAtll = false;
		}

		if (chekVal === this.notrelevant) {
			this.fourthRadNotRelevetn = true;
		} else {
			this.fourthRadNotRelevetn = false;
		}
		// Update the response value if the question name matches
		if (this.nameOfQuestion === 'fourthQuestionResponse') {
			this.fourthQuestionResponse = event.target.value;
			this.nameToDraftFourth = event.target.name;

			// Push the response and its corresponding version ID to arrays
			if (this.fourthQuestionResponse !== '') {
				this.arrayForPushResp.push(this.fourthQuestionResponse);
				this.arrayForPushId.push(this.fourthQuestionVersinId);
			}
			// Store the last response values to another varaible so that we can use it for draft submission and Confirm Submission.
			this.fourthRspValue = this.getLastRespValueFour();
			this.fourthVersionId = this.getLastIdValueFour();
		}
	}
	// Function to get the last response value from the array
	getLastRespValueFour() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueFour() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//this is a handler that we use to handle the responses of the Fifth Question user input.
	handleFifthQuestionChange(event) {
		// Get the name of the question from the event target
		this.nameOfQuestion = event.target.name;
		// Get the value of the selected option
		const chekVal = event.target.value;
		if (chekVal === this.verymuch) {
			this.fifthRadVeryMch = true;
		} else {
			this.fifthRadVeryMch = false;
		}

		if (chekVal === this.alot) {
			this.fifthRadAlot = true;
		} else {
			this.fifthRadAlot = false;
		}

		if (chekVal === this.alittle) {
			this.fifthRadAlittle = true;
		} else {
			this.fifthRadAlittle = false;
		}

		if (chekVal === this.notatall) {
			this.fifthRadNotAtAll = true;
		} else {
			this.fifthRadNotAtAll = false;
		}
		if (chekVal === this.notrelevant) {
			this.fifthRadNotRelevent = true;
		} else {
			this.fifthRadNotRelevent = false;
		}

		// Update the response value if the question name matches
		if (this.nameOfQuestion === 'fifthQuestionResponse') {
			this.fifthQuestionresponse = event.target.value;
			this.nameToDraftFifth = event.target.name;
			// Push the response and its corresponding version ID to arrays
			if (this.fifthQuestionresponse !== '') {
				this.arrayForPushResp.push(this.fifthQuestionresponse);
				this.arrayForPushId.push(this.fifthQuestionVersinId);
			}
			// Get the last values separately
			this.fifthResonseValue = this.getLastRespValueFive();
			this.fifthVersionId = this.getLastIdValueFive();
		}
	}
	// Function to get the last response value from the array
	getLastRespValueFive() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueFive() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//this is a handler that we use to handle the responses of the Sixth Question user input.
	handleSixthQuestionChange(event) {
		// Get the name of the question from the event target
		this.nameOfQuestion = event.target.name;
		// Get the value of the selected option
		const chekVal = event.target.value;
		if (chekVal === this.verymuch) {
			this.sixthRadVeryMuch = true;
		} else {
			this.sixthRadVeryMuch = false;
		}

		if (chekVal === this.alot) {
			this.sixthRadAlot = true;
		} else {
			this.sixthRadAlot = false;
		}

		if (chekVal === this.alittle) {
			this.sixthRadAlittle = true;
		} else {
			this.sixthRadAlittle = false;
		}

		if (chekVal === this.notatall) {
			this.sixthRadNotAtAll = true;
		} else {
			this.sixthRadNotAtAll = false;
		}
		if (chekVal === this.notrelevant) {
			this.sixthRadNotRelevent = true;
		} else {
			this.sixthRadNotRelevent = false;
		}

		// Update the response value if the question name matches
		if (this.nameOfQuestion === 'sixthQuestionResponse') {
			this.sixthQuestionResponse = event.target.value;
			this.nameToDraftSixth = event.target.name;
			// Push the response and its corresponding version ID to arrays
			if (this.sixthQuestionResponse !== '') {
				this.arrayForPushResp.push(this.sixthQuestionResponse);
				this.arrayForPushId.push(this.sixthQuestionVersinId);
			}
			// Get the last values separately
			this.sixthResponseValue = this.getLastRespValueSix();
			this.sixthVersiD = this.getLastIdValueSix();
		}
	}
	// Function to get the last response value from the array
	getLastRespValueSix() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueSix() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//delete response based on Selecting no as the option
	deletionOfResponseOnNo() {
		// Reset values when response is 'No'
		this.eightQuestionResponse = '';
		this.eghtResponseValue = '';
		this.eightVersiId = '';
		this.eigthDraftResp = '';
		this.eigthDraftVersionId = '';
	}
	//this is a handler that we use to handle the responses of the seventh Question user input.
	handleSevethQuestionChange(event) {
		// Check if the checkbox is checked
		if (event.target.checked) {
			const val = event.target.value;

			// Handle different values of the checkbox
			if (val === this.yes) {
				this.seventhRadYes = true;
				this.seventhRadNo = false;
				this.seventhRadNotRelevnt = false;
				this.countquestion = 10;
				this.payload = { countvalue: this.countquestion };
				this.deletionOfResponseOnNo(); // Reset values when 'No' is selected
				this.eighthRadAlot = false;
				this.eighthRadAlittle = false;
				this.eighthRadNotAtall = false;
			} else if (val === this.no) {
				this.seventhRadYes = false;
				this.seventhRadNo = true;
				this.seventhRadNotRelevnt = false;
				this.countquestion = 11;
			} else if (val === this.notrelevant) {
				this.seventhRadYes = false;
				this.seventhRadNo = false;
				this.seventhRadNotRelevnt = true;
			}
		}

		// Set visibility of eighth question based on the response
		this.eigthQuestionVisible = event.target.value === this.no;

		this.nameOfQuestion = event.target.name;

		// Update response and IDs for seventh question
		if (this.nameOfQuestion === 'seventhQuestionResponse') {
			this.seventhQuestionResponse = event.target.value;
			this.nameToDraftSeventh = event.target.name;

			if (this.seventhQuestionResponse !== '') {
				this.arrayForPushResp.push(this.seventhQuestionResponse);
				this.arrayForPushId.push(this.seventhQuestionVersinId);
			}

			// Get the last values separately
			this.seventhRespalue = this.getLastRespValueSeven();
			this.seventhVersiD = this.getLastIdValueSeven();
		}
	}

	// Function to get the last response value from the array
	getLastRespValueSeven() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueSeven() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//this is a handler that we use to handle the responses of the Eigth Question user input.
	handleEighthQuestionChange(event) {
		// Get the name of the question from the event
		this.nameOfQuestion = event.target.name;

		// Get the value of the selected option
		const checkVal = event.target.value;

		// Set boolean flags based on the selected option
		if (checkVal === this.alot) {
			this.eighthRadAlot = true;
		} else {
			this.eighthRadAlot = false;
		}

		if (checkVal === this.alittle) {
			this.eighthRadAlittle = true;
		} else {
			this.eighthRadAlittle = false;
		}

		if (checkVal === this.notatall) {
			this.eighthRadNotAtall = true;
		} else {
			this.eighthRadNotAtall = false;
		}

		// Update response and IDs for eighth question
		if (this.nameOfQuestion === 'eigthQuestionResponse') {
			// Set the response value and name for draft
			this.eightQuestionResponse = event.target.value;
			this.nameToDraftEighth = event.target.name;

			// Push response value and version ID to arrays if response is not empty
			if (this.eightQuestionResponse !== '') {
				this.arrayForPushResp.push(this.eightQuestionResponse);
				this.arrayForPushId.push(this.eightQuestionVersinId);
			}

			// Get the last values separately
			this.eghtResponseValue = this.getLastRespValueEight();
			this.eightVersiId = this.getLastIdValueEight();
		}
	}

	// Function to get the last response value from the array
	getLastRespValueEight() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueEight() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//this is a handler that we use to handle the responses of the Ninth Question user input.
	handleninthQuestionChange(event) {
		// Get the name of the question from the event
		this.nameOfQuestion = event.target.name;

		// Get the value of the selected option
		const checkVal = event.target.value;

		// Set boolean flags based on the selected option
		if (checkVal === this.verymuch) {
			this.ninthRadverMuch = true;
		} else {
			this.ninthRadverMuch = false;
		}

		if (checkVal === this.alot) {
			this.ninthRadAlot = true;
		} else {
			this.ninthRadAlot = false;
		}

		if (checkVal === this.alittle) {
			this.ninthRadAlittle = true;
		} else {
			this.ninthRadAlittle = false;
		}

		if (checkVal === this.notatall) {
			this.ninthRadNotAtAll = true;
		} else {
			this.ninthRadNotAtAll = false;
		}

		if (checkVal === this.notrelevant) {
			this.ninthRadNotRelevent = true;
		} else {
			this.ninthRadNotRelevent = false;
		}

		// Update response and IDs for ninth question
		if (this.nameOfQuestion === 'ninthQuestionResponse') {
			// Set the response value and name for draft
			this.ninthQuestionResponse = event.target.value;
			this.nameToDraftNinth = event.target.name;

			// Push response value and version ID to arrays if response is not empty
			if (this.ninthQuestionResponse !== '') {
				this.arrayForPushResp.push(this.ninthQuestionResponse);
				this.arrayForPushId.push(this.ninthQuestionVersinId);
			}

			// Get the last values separately
			this.ninthResponseValue = this.getLastRespValueNine();
			this.ninthVersId = this.getLastIdValueNine();
		}
	}

	// Function to get the last response value from the array
	getLastRespValueNine() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueNine() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//this is a handler that we use to handle the responses of the Tenth Question user input.
	handleTenthQuestionChange(event) {
		// Get the name of the question from the event
		this.nameOfQuestion = event.target.name;

		// Get the value of the selected option
		const checkVal = event.target.value;

		// Set boolean flags based on the selected option
		if (checkVal === this.verymuch) {
			this.tenthRadverMuch = true;
		} else {
			this.tenthRadverMuch = false;
		}

		if (checkVal === this.alot) {
			this.tenthRadAlot = true;
		} else {
			this.tenthRadAlot = false;
		}

		if (checkVal === this.alittle) {
			this.tenthRadAlittle = true;
		} else {
			this.tenthRadAlittle = false;
		}

		if (checkVal === this.notatall) {
			this.tenthRadNotAtAll = true;
		} else {
			this.tenthRadNotAtAll = false;
		}

		if (checkVal === this.notrelevant) {
			this.tenthRadNotRelevent = true;
		} else {
			this.tenthRadNotRelevent = false;
		}

		// Update response and IDs for tenth question
		if (this.nameOfQuestion === 'tenthQuestionResponse') {
			// Set the response value and name for draft
			this.tenthQuestionResponse = event.target.value;
			this.nameToDrafttenth = event.target.name;

			// Check if the draft name is not null, set istenthTru flag to true
			if (this.nameToDrafttenth !== null) {
				this.istenthTru = true;
			}

			// Push response value and version ID to arrays if response is not empty
			if (this.tenthQuestionResponse !== '') {
				this.arrayForPushResp.push(this.tenthQuestionResponse);
				this.arrayForPushId.push(this.tenthQuestionVersinId);
			}

			// Get the last values separately
			this.tenthResponseValue = this.getLastRespValueTen();
			this.tenthVersId = this.getLastIdValueTen();
		}
	}

	// Function to get the last response value from the array
	getLastRespValueTen() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueTen() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//this is a handler that we use to handle the responses of the eleventh Question user input.
	handleEleventhQuestionChange(event) {
		// Get the name of the question from the event
		this.nameOfQuestion = event.target.name;

		// Get the value of the selected option
		const checkVal = event.target.value;

		// Set boolean flags based on the selected option
		if (checkVal === this.verymuch) {
			this.eleventhRadverMuch = true;
		} else {
			this.eleventhRadverMuch = false;
		}

		if (checkVal === this.alot) {
			this.eleventhRadAlot = true;
		} else {
			this.eleventhRadAlot = false;
		}

		if (checkVal === this.alittle) {
			this.eleventhRadAlittle = true;
		} else {
			this.eleventhRadAlittle = false;
		}

		if (checkVal === this.notatall) {
			this.eleventhRadNotAtAll = true;
		} else {
			this.eleventhRadNotAtAll = false;
		}

		if (checkVal === this.notrelevant) {
			this.eleventhRadNotRelevent = true;
		} else {
			this.eleventhRadNotRelevent = false;
		}

		// Update response and IDs for eleventh question
		if (this.nameOfQuestion === 'eleventhQuestionResponse') {
			// Set the response value and name for draft
			this.eleventhQuestionResponse = event.target.value;
			this.nameToDraftEleventh = event.target.name;

			// Push response value and version ID to arrays if response is not empty
			if (this.eleventhQuestionResponse !== '') {
				this.arrayForPushResp.push(this.eleventhQuestionResponse);
				this.arrayForPushId.push(this.eleventhQuestionVerionID);
			}

			// Get the last values separately
			this.eleventhResponseValue = this.getLastRespValueEleven();
			this.eleventhVersId = this.getLastIdValueEleven();
		}
	}

	// Function to get the last response value from the array
	getLastRespValueEleven() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	// Function to get the last version ID from the array
	getLastIdValueEleven() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	@track popupvar = '';

	//when you click on the cancel button in the confirm popup message this mehtod will get invoked and enable all the radio buttons if the provided values in the if condition are matched.
	closePopup() {
		this.isConfirmationDialogOpen = false;
		this.customFormModal = false;

		document.body.style.overflow = '';
		this.isPopupOpen = false;
		this.isPopupOpen1 = false;
		if (this.isPopupOpen === false) {
			this.popupvar = this.yes;
		}
		this.popupmenu = false;

		if (this.firstQuestionResponse === this.verymuch) {
			this.firstRadVerMuch = true;
		} else if (this.firstQuestionResponse === this.alot) {
			this.firstRadAlot = true;
		} else if (this.firstQuestionResponse === this.alittle) {
			this.firstRadALittle = true;
		} else if (this.firstQuestionResponse === 'Severe') {
			this.firstRadSevere = true;
		}

		if (this.secondQuestionResponse === this.verymuch) {
			this.secondRadVerMch = true;
		} else if (this.secondQuestionResponse === this.alot) {
			this.secondRadAlot = true;
		} else if (this.secondQuestionResponse === this.alittle) {
			this.secondRadAlittle = true;
		} else if (this.secondQuestionResponse === this.notatall) {
			this.secondRadNotAtAll = true;
		}

		if (this.thirdQuestionResponse === this.verymuch) {
			this.thirdRadVerMch = true;
		} else if (this.thirdQuestionResponse === this.alot) {
			this.thirdRadAlot = true;
		} else if (this.thirdQuestionResponse === this.alittle) {
			this.thirdRadAlittle = true;
		} else if (this.thirdQuestionResponse === this.notatall) {
			this.thirdRadNotAll = true;
		} else if (this.thirdQuestionResponse === this.notrelevant) {
			this.thirdRadNotReelevent = true;
		}

		if (this.fourthQuestionResponse === this.verymuch) {
			this.fourthRadVeryMch = true;
		} else if (this.fourthQuestionResponse === this.alot) {
			this.fourthRadAlot = true;
		} else if (this.fourthQuestionResponse === this.alittle) {
			this.fourthRadVAlittle = true;
		} else if (this.fourthQuestionResponse === this.notatall) {
			this.fourthRadNotAtll = true;
		} else if (this.fourthQuestionResponse === this.notrelevant) {
			this.fourthRadNotRelevetn = true;
		}

		if (this.fifthQuestionresponse === this.verymuch) {
			this.fifthRadVeryMch = true;
		} else if (this.fifthQuestionresponse === this.alot) {
			this.fifthRadAlot = true;
		} else if (this.fifthQuestionresponse === this.alittle) {
			this.fifthRadAlittle = true;
		} else if (this.fifthQuestionresponse === this.notatall) {
			this.fifthRadNotAtAll = true;
		} else if (this.fifthQuestionresponse === this.notrelevant) {
			this.fifthRadNotRelevent = true;
		}

		if (this.sixthQuestionResponse === this.verymuch) {
			this.sixthRadVeryMuch = true;
		} else if (this.sixthQuestionResponse === this.alot) {
			this.sixthRadAlot = true;
		} else if (this.sixthQuestionResponse === this.alittle) {
			this.sixthRadAlittle = true;
		} else if (this.sixthQuestionResponse === this.notatall) {
			this.sixthRadNotAtAll = true;
		} else if (this.sixthQuestionResponse === this.notrelevant) {
			this.sixthRadNotRelevent = true;
		}

		if (this.seventhQuestionResponse === this.yes) {
			this.seventhRadYes = true;
		} else if (this.seventhQuestionResponse === this.no) {
			this.seventhRadNo = true;
		} else if (this.seventhQuestionResponse === this.notrelevant) {
			this.seventhRadNotRelevnt = true;
		}

		if (this.eightQuestionResponse === this.notatall) {
			this.eighthRadNotAtall = true;
		} else if (this.eightQuestionResponse === this.alot) {
			this.eighthRadAlot = true;
		} else if (this.eightQuestionResponse === this.alittle) {
			this.eighthRadAlittle = true;
		}

		if (this.ninthQuestionResponse === this.verymuch) {
			this.ninthRadverMuch = true;
		} else if (this.ninthQuestionResponse === this.alot) {
			this.ninthRadAlot = true;
		} else if (this.ninthQuestionResponse === this.alittle) {
			this.ninthRadAlittle = true;
		} else if (this.ninthQuestionResponse === this.notatall) {
			this.ninthRadNotAtAll = true;
		} else if (this.ninthQuestionResponse === this.notrelevant) {
			this.ninthRadNotRelevent = true;
		}

		if (this.tenthQuestionResponse === this.verymuch) {
			this.tenthRadverMuch = true;
		} else if (this.tenthQuestionResponse === this.alot) {
			this.tenthRadAlot = true;
		} else if (this.tenthQuestionResponse === this.alittle) {
			this.tenthRadAlittle = true;
		} else if (this.tenthQuestionResponse === this.notatall) {
			this.tenthRadNotAtAll = true;
		} else if (this.tenthQuestionResponse === this.notrelevant) {
			this.tenthRadNotRelevent = true;
		}

		if (this.eleventhQuestionResponse === this.verymuch) {
			this.eleventhRadverMuch = true;
		} else if (this.eleventhQuestionResponse === this.alot) {
			this.eleventhRadAlot = true;
		} else if (this.eleventhQuestionResponse === this.alittle) {
			this.eleventhRadAlittle = true;
		} else if (this.eleventhQuestionResponse === this.notatall) {
			this.eleventhRadNotAtAll = true;
		} else if (this.eleventhQuestionResponse === this.notrelevant) {
			this.eleventhRadNotRelevent = true;
		}
	}
	//when you click on the return back  button in the complete all the Question popup message this mehtod will get invoked and enable all the radio buttons if the provided values in the if condition are matched.
	async closePopup1() {
		this.customFormModal = false;
		//this will make the page scrollable again
		document.body.style.overflow = '';
		//this will close the save as draft popup message
		this.isPopupOpen1 = false;
		this.popupmenu = false;
		if (this.firstQuestionResponse === this.verymuch) {
			this.firstRadVerMuch = true;
		} else if (this.firstQuestionResponse === this.alot) {
			this.firstRadAlot = true;
		} else if (this.firstQuestionResponse === this.alittle) {
			this.firstRadALittle = true;
		} else if (this.firstQuestionResponse === this.notatall) {
			this.firstRadSevere = true;
		}

		if (this.secondQuestionResponse === this.verymuch) {
			this.secondRadVerMch = true;
		} else if (this.secondQuestionResponse === this.alot) {
			this.secondRadAlot = true;
		} else if (this.secondQuestionResponse === this.alittle) {
			this.secondRadAlittle = true;
		} else if (this.secondQuestionResponse === this.notatall) {
			this.secondRadNotAtAll = true;
		}

		if (this.thirdQuestionResponse === this.verymuch) {
			this.thirdRadVerMch = true;
		} else if (this.thirdQuestionResponse === this.alot) {
			this.thirdRadAlot = true;
		} else if (this.thirdQuestionResponse === this.alittle) {
			this.thirdRadAlittle = true;
		} else if (this.thirdQuestionResponse === this.notatall) {
			this.thirdRadNotAll = true;
		} else if (this.thirdQuestionResponse === this.notrelevant) {
			this.thirdRadNotReelevent = true;
		}

		if (this.fourthQuestionResponse === this.verymuch) {
			this.fourthRadVeryMch = true;
		} else if (this.fourthQuestionResponse === this.alot) {
			this.fourthRadAlot = true;
		} else if (this.fourthQuestionResponse === this.alittle) {
			this.fourthRadVAlittle = true;
		} else if (this.fourthQuestionResponse === this.notatall) {
			this.fourthRadNotAtll = true;
		} else if (this.fourthQuestionResponse === this.notrelevant) {
			this.fourthRadNotRelevetn = true;
		}

		if (this.fifthQuestionresponse === this.verymuch) {
			this.fifthRadVeryMch = true;
		} else if (this.fifthQuestionresponse === this.alot) {
			this.fifthRadAlot = true;
		} else if (this.fifthQuestionresponse === this.alittle) {
			this.fifthRadAlittle = true;
		} else if (this.fifthQuestionresponse === this.notatall) {
			this.fifthRadNotAtAll = true;
		} else if (this.fifthQuestionresponse === this.notrelevant) {
			this.fifthRadNotRelevent = true;
		}

		if (this.sixthQuestionResponse === this.verymuch) {
			this.sixthRadVeryMuch = true;
		} else if (this.sixthQuestionResponse === this.alot) {
			this.sixthRadAlot = true;
		} else if (this.sixthQuestionResponse === this.alittle) {
			this.sixthRadAlittle = true;
		} else if (this.sixthQuestionResponse === this.notatall) {
			this.sixthRadNotAtAll = true;
		} else if (this.sixthQuestionResponse === this.notrelevant) {
			this.sixthRadNotRelevent = true;
		}

		if (this.seventhQuestionResponse === this.yes) {
			this.seventhRadYes = true;
		} else if (this.seventhQuestionResponse === this.no) {
			this.seventhRadNo = true;
		} else if (this.seventhQuestionResponse === this.notrelevant) {
			this.seventhRadNotRelevnt = true;
		}

		if (this.eightQuestionResponse === this.notatall) {
			this.eighthRadNotAtall = true;
		} else if (this.eightQuestionResponse === this.alot) {
			this.eighthRadAlot = true;
		} else if (this.eightQuestionResponse === this.alittle) {
			this.eighthRadAlittle = true;
		}

		if (this.ninthQuestionResponse === this.verymuch) {
			this.ninthRadverMuch = true;
		} else if (this.ninthQuestionResponse === this.alot) {
			this.ninthRadAlot = true;
		} else if (this.ninthQuestionResponse === this.alittle) {
			this.ninthRadAlittle = true;
		} else if (this.ninthQuestionResponse === this.notatall) {
			this.ninthRadNotAtAll = true;
		} else if (this.ninthQuestionResponse === this.notrelevant) {
			this.ninthRadNotRelevent = true;
		}

		if (this.tenthQuestionResponse === this.verymuch) {
			this.tenthRadverMuch = true;
		} else if (this.tenthQuestionResponse === this.alot) {
			this.tenthRadAlot = true;
		} else if (this.tenthQuestionResponse === this.alittle) {
			this.tenthRadAlittle = true;
		} else if (this.tenthQuestionResponse === this.notatall) {
			this.tenthRadNotAtAll = true;
		} else if (this.tenthQuestionResponse === this.notrelevant) {
			this.tenthRadNotRelevent = true;
		}

		if (this.eleventhQuestionResponse === this.verymuch) {
			this.eleventhRadverMuch = true;
		} else if (this.eleventhQuestionResponse === this.alot) {
			this.eleventhRadAlot = true;
		} else if (this.eleventhQuestionResponse === this.alittle) {
			this.eleventhRadAlittle = true;
		} else if (this.eleventhQuestionResponse === this.notatall) {
			this.eleventhRadNotAtAll = true;
		} else if (this.eleventhQuestionResponse === this.notrelevant) {
			this.eleventhRadNotRelevent = true;
		}
	}

	//when you hit the submit button this method will get invoked and check if all the  questions has been submitted by the user or not if he has submitted then we will show him the confirm popup message if it is not then we will show a return back popup message.
	submitResponses() {
		//if the this.isDesktop is true whether it has view port that we have configured with then the page will become non scrollable.
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = ''; // Reset to default
		}
		this.popupmenu = true;
		//the below set of if conditions check if the draft responses are present for each of the questions if it is then we wil the name varaible of all the Questions to a particular value.
		if (this.firstDraftResp != null) {
			this.nameToDraftFirst = 'nameone';
		}
		if (this.secondDraftResp != null) {
			this.nameToDraftSecond = 'nametwo';
		}
		if (this.thirdDraftResp != null) {
			this.nameToDraftThird = 'namethree';
		}
		if (this.fourthDraftRes != null) {
			this.nameToDraftFourth = 'namefour';
		}
		if (this.fifthDraftResp != null) {
			this.nameToDraftFifth = 'namefive';
		}
		if (this.sixthDraftResp != null) {
			this.nameToDraftSixth = 'namesix';
		}
		if (this.seventhDraftResp != null) {
			this.nameToDraftSeventh = 'nameseven';
		}
		if (this.eigthDraftResp != null) {
			this.nameToDraftEighth = 'nameeigth';
		}
		if (this.ninthDraftResp != null) {
			this.nameToDraftNinth = 'nameninth';
		}
		if (this.tenthDraftResp != null) {
			this.nameToDrafttenth = 'nametenth';
		}
		if (this.eleventhDraftResp != null) {
			this.nameToDraftEleventh = 'nametenth';
		}

		//this will check if all the quesions are submitted with responses or not
		if (this.eigthQuestionVisible === true) {
			if (
				this.nameToDraftFirst != null &&
				this.nameToDraftSecond != null &&
				this.nameToDraftThird != null &&
				this.nameToDraftFourth != null &&
				this.nameToDraftFifth != null &&
				this.nameToDraftSixth != null &&
				this.nameToDraftSeventh != null &&
				this.nameToDraftEighth != null &&
				this.nameToDraftNinth != null &&
				this.nameToDrafttenth != null &&
				this.nameToDraftEleventh != null
			) {
				if (this.seventhRespalue === this.no || this.seventhDraftResp === this.no) {
					if (this.eghtResponseValue !== '') {
						this.isPopupOpen = true;
						this.isPopupOpen1 = false;
						this.checkyesorno = true;
					} else {
						this.customFormModal = true;
						this.isPopupOpen1 = true;
						this.isPopupOpen = false;
						this.checkyesorno = false;
					}
				} else {
					this.customFormModal = true;
					this.isPopupOpen1 = true;
					this.isPopupOpen = false;
					this.checkyesorno = false;
				}
			} else {
				this.customFormModal = true;
				this.isPopupOpen1 = true;
				this.isPopupOpen = false;
				this.checkyesorno = false;
			}
		}

		if (this.eigthQuestionVisible === false) {
			if (
				this.nameToDraftFirst != null &&
				this.nameToDraftSecond != null &&
				this.nameToDraftThird != null &&
				this.nameToDraftFourth != null &&
				this.nameToDraftFifth != null &&
				this.nameToDraftSixth != null &&
				this.nameToDraftSeventh != null &&
				this.nameToDraftNinth != null &&
				this.nameToDrafttenth != null &&
				this.nameToDraftEleventh != null
			) {
				if (
					this.seventhRespalue === this.yes ||
					this.seventhDraftResp === this.yes ||
					this.seventhRespalue === this.notrelevant ||
					this.seventhDraftResp === this.notrelevant
				) {
					this.isPopupOpen = true;
					this.isPopupOpen1 = false;
				}
			} else {
				this.customFormModal = true;
				this.isPopupOpen1 = true;
				this.isPopupOpen = false;
			}
		}
	}
	// If popupmenu is true, return 'disabled'; otherwise, return an empty string
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
			document.body.style.overflow = ''; // Reset to default
		}

		this.popupmenu = true;
		//this wil check whether the user has filled first Questions response or not if he hasnt then the else part we will push the draft response
		if (this.firstRspValue != null) {
			this.realrespArray.push(this.firstRspValue);
		} else {
			this.realrespArray.push(this.firstDraftResp);
		}
		//this wil check whether the user has filled first Questions response or not if he hasnt then the else part we will push the draft response and this is for response ids
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

		if (this.seventhRespalue != null) {
			this.realrespArray.push(this.seventhRespalue);
		} else {
			this.realrespArray.push(this.seventhDraftResp);
		}

		if (this.seventhVersiD != null) {
			this.realAssesVerArra.push(this.seventhVersiD);
		} else {
			this.realAssesVerArra.push(this.seventhDraftVersionId);
		}

		if (this.eghtResponseValue != null) {
			this.realrespArray.push(this.eghtResponseValue);
		} else {
			this.realrespArray.push(this.eigthDraftResp);
		}

		if (this.eightVersiId != null) {
			this.realAssesVerArra.push(this.eightVersiId);
		} else {
			this.realAssesVerArra.push(this.eigthDraftVersionId);
		}

		if (this.ninthResponseValue != null) {
			this.realrespArray.push(this.ninthResponseValue);
		} else {
			this.realrespArray.push(this.ninthDraftResp);
		}

		if (this.ninthVersId != null) {
			this.realAssesVerArra.push(this.ninthVersId);
		} else {
			this.realAssesVerArra.push(this.ninthDraftVersionId);
		}

		if (this.tenthResponseValue != null) {
			this.realrespArray.push(this.tenthResponseValue);
		} else {
			this.realrespArray.push(this.tenthDraftResp);
		}

		if (this.tenthVersId != null) {
			this.realAssesVerArra.push(this.tenthVersId);
		} else {
			this.realAssesVerArra.push(this.tenthDraftVersionId);
		}

		if (this.eleventhResponseValue != null) {
			this.realrespArray.push(this.eleventhResponseValue);
		} else {
			this.realrespArray.push(this.eleventhDraftResp);
		}

		if (this.eleventhVersId != null) {
			this.realAssesVerArra.push(this.eleventhVersId);
		} else {
			this.realAssesVerArra.push(this.eleventhDraftVersionId);
		}
		// Filter out non-empty responses from the realrespArray
		const nonEmptyResponses = this.realrespArray.filter(
			(response) => response !== ''
		);
		// Filter out non-empty IDs from the realAssesVerArra
		const nonEmptyIds = this.realAssesVerArra.filter((id) => id !== '');

		//check whether realrespArray is greater or not than zero
		if (this.realrespArray.length > 0) {
			submitDraftDermatology({
				darftQuestionIds: nonEmptyIds,
				draftResponseTexts: nonEmptyResponses
			})
				.then(() => {
					this.customFormModal = false;
					this.closePopup1 = false;
					this.checkyesorno = false;
					this.popUpMetod();
				})
				.catch((error) => {
					this.showToast(consoleErrorMessage, error.message, errorvariant); //Catching Potential Error
				});
		}
	}

	//this method is for the custom pop up message when clicked on the save as draft button.
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
	//this method will close the save as drfat custom pop up
	closeDraftSavedPopup() {
		this.isDraftSavedPopupOpen = false;
		window.location.assign(this.urlq + outStandingPage);
	}

	//this method is for Confirm Submission pop up message, when you click on the confim button this will get invoked.
	confirmSubmission() {
		// redirect to outstanding page

		window.location.assign(this.urlq + outStandingPage);

		//this will check whether the response is null or not if it is null the it will push the drfat response
		if (this.firstRspValue != null) {
			this.realrespArray.push(this.firstRspValue);
		} else {
			this.realrespArray.push(this.firstDraftResp);
		}
		//this will check whether the response is null or not if it is null the it will push the drfat response version id

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

		if (this.seventhRespalue != null) {
			this.realrespArray.push(this.seventhRespalue);
		} else {
			this.realrespArray.push(this.seventhDraftResp);
		}

		if (this.seventhVersiD != null) {
			this.realAssesVerArra.push(this.seventhVersiD);
		} else {
			this.realAssesVerArra.push(this.seventhDraftVersionId);
		}

		if (this.eghtResponseValue != null) {
			this.realrespArray.push(this.eghtResponseValue);
		} else {
			this.realrespArray.push(this.eigthDraftResp);
		}

		if (this.eightVersiId != null) {
			this.realAssesVerArra.push(this.eightVersiId);
		} else {
			this.realAssesVerArra.push(this.eigthDraftVersionId);
		}

		if (this.ninthResponseValue != null) {
			this.realrespArray.push(this.ninthResponseValue);
		} else {
			this.realrespArray.push(this.ninthDraftResp);
		}

		if (this.ninthVersId != null) {
			this.realAssesVerArra.push(this.ninthVersId);
		} else {
			this.realAssesVerArra.push(this.ninthDraftVersionId);
		}

		if (this.tenthResponseValue != null) {
			this.realrespArray.push(this.tenthResponseValue);
		} else {
			this.realrespArray.push(this.tenthDraftResp);
		}

		if (this.tenthVersId != null) {
			this.realAssesVerArra.push(this.tenthVersId);
		} else {
			this.realAssesVerArra.push(this.tenthDraftVersionId);
		}

		if (this.eleventhResponseValue != null) {
			this.realrespArray.push(this.eleventhResponseValue);
		} else {
			this.realrespArray.push(this.eleventhDraftResp);
		}

		if (this.eleventhVersId != null) {
			this.realAssesVerArra.push(this.eleventhVersId);
		} else {
			this.realAssesVerArra.push(this.eleventhDraftVersionId);
		}

		// Initialize empty arrays to store responses and version IDs
		const responseArray = [];
		const versionIdArray = [];

		// Iterate over the arrays
		for (let i = 0; i < this.realrespArray.length; i++) {
			// Get the response value at index i
			const responseValue = this.realrespArray[i];

			// Get the version ID at index i
			const versionId = this.realAssesVerArra[i];

			// Check if responseValue is not undefined
			if (typeof responseValue !== 'undefined') {
				// Push responseValue to responseArray
				responseArray.push(responseValue);
			}

			// Check if versionId is not undefined
			if (typeof versionId !== 'undefined') {
				// Push versionId to versionIdArray
				versionIdArray.push(versionId);
			}
		}

		//this will get the number of responses
		this.numberOfResponses = responseArray.filter(
			(response) => typeof response != 'undefined'
		).length;

		//this will get the number of responses and restrict any other entries other than the numberOfResponses 10 or 11
		if (this.numberOfResponses === 10 || this.numberOfResponses === 11) {
			// Filter out non-empty responses from realrespArray
			const nonEmptyResponses = this.realrespArray.filter(
				(response) => response !== ''
			);
			// Filter out non-empty IDs from realAssesVerArra
			const nonEmptyIds = this.realAssesVerArra.filter((id) => id !== '');

			if (this.realrespArray.length > 0) {
				//submit the response
				submitConfirmedResponses({
					questionIds: nonEmptyIds,
					responseTexts: nonEmptyResponses
				})
					.then(() => {
						window.location.assign(this.urlq + outStandingPage);
					})
					.catch((error) => {
						this.showToast(consoleErrorMessage, error.message, errorvariant); //Catching Potential Error
						// Handle any errors that occur during the response save
					});
			}
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