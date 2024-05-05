//This Lightning Web Component allows users to input responses for qualitative questionnaire questions, enhancing the collection of subjective feedback and opinions.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex Classes
import getAssessmentQuestions from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.getQualitativeAssesmentQues';
import submitAssessmentResponse from '@salesforce/apex/BI_PSP_QsqQuestionnaire.ranswerOfTheQuestionForPageTwo';
import draftResponseSubmition from '@salesforce/apex/BI_PSP_QsqQuestionnaire.mulitipleDraftRecordsInsertionPageTwo';
import draftResponseOfPsoriasis from '@salesforce/apex/BI_PSP_QsqQuestionnaire.draftResponseOfIntroductionPageTwo';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName';
//To import Static Resource
import pss from '@salesforce/resourceUrl/BI_PSP_PSSimage';
import letpersonalize from '@salesforce/resourceUrl/BI_PSP_letspersonalizeimage';
import testimg from '@salesforce/resourceUrl/BI_PSP_DLQIimage';
import workandactivity from '@salesforce/resourceUrl/BI_PSP_WPAIimage';
import qualitative from '@salesforce/resourceUrl/BI_PSP_Qualitativeimage';
//To get Current UserId
import Id from '@salesforce/user/Id';
//To import Custom labels
import BI_PSP_introductionCategory from '@salesforce/label/c.BI_PSP_introductionCategory';
import BI_PSP_PssCategory from '@salesforce/label/c.BI_PSP_PssCategory';
import BI_PSP_WapiCategory from '@salesforce/label/c.BI_PSP_WapiCategory';
import BI_PSP_DlqiCategory from '@salesforce/label/c.BI_PSP_DlqiCategory';
import BI_PSP_QualitativeCategory from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import BI_PSP_Wapi from '@salesforce/label/c.BI_PSP_WAPI';
import BI_PSP_clickbelow from '@salesforce/label/c.BI_PSP_clickbelow';
import BI_PSP_outstandingquestionnaire from '@salesforce/label/c.BI_PSP_outstandingquestionnaire';
import BI_PSP_informationcentre from '@salesforce/label/c.BI_PSP_informationcentre';
import BI_PSP_symptomtracker from '@salesforce/label/c.BI_PSP_symptomtracker';
import BI_PSP_challenges from '@salesforce/label/c.BI_PSP_challenges';
import BI_PSP_Questionnaire from '@salesforce/label/c.BI_PSP_Questionnaire';
import BI_PSP_treatmentvideos from '@salesforce/label/c.BI_PSP_treatmentvideos';
import BI_PSP_support from '@salesforce/label/c.BI_PSP_support';
import BI_PSP_yes from '@salesforce/label/c.BI_PSP_yes';
import BI_PSP_no from '@salesforce/label/c.BI_PSP_no';
import BI_PSP_submit from '@salesforce/label/c.BI_PSP_submit';
import BI_PSP_saveasdraft from '@salesforce/label/c.BI_PSP_saveasdraft';
import BI_PSP_returnback from '@salesforce/label/c.BI_PSP_returnback';
import BI_PSP_confirm_submission from '@salesforce/label/c.BI_PSP_confirm_submission';
import BI_PSP_cancel from '@salesforce/label/c.BI_PSP_cancel';
import BI_PSP_confirm from '@salesforce/label/c.BI_PSP_confirm';
import BI_PSP_qsqtext from '@salesforce/label/c.BI_PSP_qsqtext';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import popupmessage from '@salesforce/label/c.BI_PSP_Messagepopup';
import submitmessage from '@salesforce/label/c.BI_PSP_submittext';
import confirmmessage from '@salesforce/label/c.BI_PSP_confirmmessage';
import BI_PSP_CompleteAll from '@salesforce/label/c.BI_PSP_CompleteAll';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import dlqiUrl from '@salesforce/label/c.BI_PSPB_BRDlqiQuestionnaireUrl';
import wapiQuestionnaire from '@salesforce/label/c.BI_PSPB_BRWapiQuestionnaire';
import pssQuestionarrieUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisQuesUrl';
import outStandingPage from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';

export default class BiPspbQSQuestionnaire1 extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track isBarRadioChecked = false;
	@track isNoneChecked = false;
	@track isMildChecked = false;
	@track isModerateChecked = false;
	@track isSevereChecked = false;
	@track isBarVerySeverChecked = false;
	//the draft number
	@track totalDraftResponses;
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
	@track fifthQuestionText;
	@track fifthQuestionVersinId;
	@track sixthQuestionText;
	@track sixthQuestionVersinId;
	@track seventhQuestionText;
	@track seventhQuestionVersinId;
	@track eightQuestionText;
	@track eightQuestionVersinId;
	@track firstQuestionResponse = '';
	@track secondQuestionResponse = '';
	@track thirdQuestionResponse = '';
	@track fourthQuestionResponse = '';
	@track fifthQuestionresponse = '';
	@track sixthQuestionResponse = '';
	@track seventhQuestionResponse = '';
	@track eightQuestionResponse = '';
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
	@track nameToDraftFirst;
	@track nameToDraftSecond;
	@track nameToDraftThird;
	@track nameToDraftFourth;
	@track nameToDraftFifth;
	@track sliderValuesec = 0;
	@track nameToDraftSixth;
	@track nameToDraftSeventh;
	@track nameToDraftEighth;
	@track responsOfDLQI = [];
	@track selectedValues = {};
	@track firstResponseText;
	@track firstResponseVersinId;
	@track secondResponseText;
	@track secondResponseVersinId;
	@track thirdResponseText;
	@track thirdResponseVersinId;
	@track fourthResponseText;
	@track fourthResponseVersinId;
	@track fifthResponseText;
	@track fifthResponseVersinId;
	@track sixthResponseText;
	@track sixthResponseVersinId;
	@track seventhResponseText;
	@track seventhResponseVersinId;
	@track eighthResponseText;
	@track eighthResponseVersinId;
	@track isConfirmationDialogOpen = false;
	@track customFormModal = false;
	@track message = BI_PSP_CompleteAll;
	@track content1 = submitmessage;
	@track isPopupOpen = false;
	@track isPopupOpen1 = false;
	@track sliderValue = 0;
	@track sliderValuethree = 0;
	@track isDraftSavedPopupOpen = false;
	@track draftSavedMessage = popupmessage;
	//Global variables(without @track does not trigger automatic re-renders)
	firstDraftResp;
	firstDraftVerionId;
	questionData = [];
	urlq;
	userid = Id;
	secondDraftResp;
	secondDraftVerionId;
	CheckBoxChecked;
	thirdDraftResp;
	thirdDraftVersionId;
	fourthDraftRes;
	fourthDraftVersionId;
	fifthDraftResp;
	fifthDraftVersionId;
	sixthDraftResp;
	sixthDraftVersionId;
	seventhDrafRes;
	seventhDrafResVersionId;
	eigthDrafRes;
	eigthDrafResVersionId;
	chekVal;
	checPrevoiusVal;
	unCheckedResVal;
	checkedResVal;
	fifthArray = [];
	uncheckedArray = [];
	fifthWithoudNewVals;
	popupmenu = false;
	thirdMild = false;
	thirdModerate = false;
	thirdSevere = false;
	thirdVerySever = false;
	isYesChecked = false;
	isNoChecked = false;
	fifthinfo = false;
	fifthSyTr = false;
	fifthChallenges = false;
	fifthQuestionnaire = false;
	fifthTreatmentVideo = false;
	fifthSupport = false;
	seventhYess = false;
	seventhNoo = false;
	eighthYess = false;
	eighthNoo = false;
	cardimage = letpersonalize;
	cardimage1 = testimg;
	cardimage2 = pss;
	cardimage3 = workandactivity;
	cardimage4 = qualitative;
	introduction = BI_PSP_introductionCategory;
	pss = BI_PSP_PssCategory;
	dlqi = BI_PSP_DlqiCategory;
	wapi = BI_PSP_WapiCategory;
	qsq = BI_PSP_QualitativeCategory;
	workAPI = BI_PSP_Wapi;
	clickbelow = BI_PSP_clickbelow;
	qsqtext = BI_PSP_qsqtext;
	outstandingque = BI_PSP_outstandingquestionnaire;
	informationcentre = BI_PSP_informationcentre;
	symptomtracker = BI_PSP_symptomtracker;
	challenges = BI_PSP_challenges;
	questionnaire = BI_PSP_Questionnaire;
	treatmentvideos = BI_PSP_treatmentvideos;
	support = BI_PSP_support;
	yes = BI_PSP_yes;
	no = BI_PSP_no;
	submit = BI_PSP_submit;
	saveasdraft = BI_PSP_saveasdraft;
	returnbackc = BI_PSP_returnback;
	confirmsub = BI_PSP_confirm_submission;
	cannotedit = confirmmessage;
	cancelbt = BI_PSP_cancel;
	confirmbt = BI_PSP_confirm;
	draftResponses = [];

	//To get site url
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

			this.updateThumbLabelPosition(this.sliderValue);
			this.updateThumbLabelPositionsec(this.sliderValuesec);
			this.updateThumbLabelPositionthree(this.sliderValuethree);

			this.isDesktop = this.isDesktopView();
			window.addEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
			this.showToast(consoleErrorMessage, error.message, errorvariant);// Catching Potential Error
		}
	}
	//To bind the variable to resize
	disconnectedCallback() {
		try {
			window.removeEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
			this.showToast(consoleErrorMessage, error.message, errorvariant);// Catching Potential Error
		}
	}

	handleResize() {
		this.isDesktop = this.isDesktopView();
	}

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



	//To get total compelete Count
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
			if (data) {
				this.count = data;
				if (this.count.length > 0) {
					this.stwai = this.count[0];
					this.stpss = this.count[1];
					this.stdlq = this.count[2];
					this.stqsq = this.count[3];
				}
			} else if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant);// Catching Potential Error from LWC
		}
	}
	//To disable the side bar navigation by certain conditions
	get checkdlqi() {
		return this.stdlq > 0 ? 'disabled' : '';
	}
	get checkpss() {
		return this.stpss > 0 ? 'disabled' : '';
	}

	get checkwai() {
		return this.stwai > 0 ? 'disabled' : '';
	}
	get checkqsq() {
		return this.stqsq > 0 ? 'disabled' : '';
	}

	// slider part 1



	renderedCallback() {
		try {
			this.addSliderEventListener();
		} catch (error) {
			this.showToast(consoleErrorMessage, error.message, errorvariant);// Catching Potential Error
		}
	}
	//Handling First Question
	handleInputChange(event) {
		this.sliderValue = event.target.value;
		this.updateThumbLabelPosition(this.sliderValue);
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

	getLastRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getLastIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}
	//To place the value in right position inside the slider 
	updateThumbLabelPosition(sliderValue) {
		// Use requestAnimationFrame to wait for the next rendering cycle
		requestAnimationFrame(() => {
			const slider = this.template.querySelector('input');
			const thumbLabel = this.template.querySelector('.thumb-label');

			const thumbWidth = parseInt(window.getComputedStyle(thumbLabel).width);
			const sliderWidth = slider.offsetWidth;
			const thumbPosition =
				(sliderValue / slider.max) * (sliderWidth - thumbWidth);

			const newPosition = thumbPosition + thumbWidth / 2 - sliderWidth / 2;
			const maxPosition = sliderWidth - thumbWidth;
			thumbLabel.style.left =
				Math.min(maxPosition, Math.max(0, newPosition)) + 'px';
			thumbLabel.setAttribute('data-value', sliderValue);
		});
	}

	addSliderEventListener() {
		var slidersec = this.template.querySelector('.slidersec');
		var slider = this.template.querySelector('.slider');
		var sliderthree = this.template.querySelector('.sliderthree');

		const updateThumbPosition1 = () => {
			this.updateThumbLabelPosition(slider.value);
		};
		const updateThumbPosition2 = () => {
			this.updateThumbLabelPositionsec(slidersec.value);
		};
		const updateThumbPosition3 = () => {
			this.updateThumbLabelPositionthree(sliderthree.value);
		};

		if (slider) {
			slider.addEventListener('input', updateThumbPosition1);
			slider.addEventListener('mousemove', updateThumbPosition1);
		}

		if (slidersec) {
			slidersec.addEventListener('input', updateThumbPosition2);
			slidersec.addEventListener('mousemove', updateThumbPosition2);
		}
		if (sliderthree) {
			sliderthree.addEventListener('input', updateThumbPosition3);
			sliderthree.addEventListener('mousemove', updateThumbPosition3);
		}
	}

	// slider part 2

	//Handle second Question

	handleInputChangesec(event) {
		this.sliderValuesec = event.target.value;
		this.updateThumbLabelPositionsec(this.sliderValuesec);
		this.thirdQuestionResponse = event.target.value;
		this.nameToDraftThird = event.target.name;
		if (this.thirdQuestionResponse !== '') {
			this.arrayForPushResp.push(this.thirdQuestionResponse);
			this.arrayForPushId.push(this.thirdQuestionVersinId);
		}
		// Get the last values separately
		this.thirdRspValue = this.getLastRespValueTwo();
		this.thirdVersionId = this.getLastIdValueTwo();
	}

	getLastRespValueTwo() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getLastIdValueTwo() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}
	//To place the value in right position inside the slider 
	updateThumbLabelPositionsec(sliderValuesec) {
		// Use requestAnimationFrame to wait for the next rendering cycle
		requestAnimationFrame(() => {
			const slidersec = this.template.querySelector('input');
			const thumbLabelsec = this.template.querySelector('.thumb-labelsec');

			const thumbWidthsec = parseInt(
				window.getComputedStyle(thumbLabelsec).width
			);
			const sliderWidthsec = slidersec.offsetWidth;
			const thumbPositionsec =
				(sliderValuesec / slidersec.max) * (sliderWidthsec - thumbWidthsec);

			const newPositionsec =
				thumbPositionsec + thumbWidthsec / 2 - sliderWidthsec / 2;
			const maxPositionsec = sliderWidthsec - thumbWidthsec;
			thumbLabelsec.style.left =
				Math.min(maxPositionsec, Math.max(0, newPositionsec)) + 'px';
			thumbLabelsec.setAttribute('data-value', sliderValuesec);
		});
	}

	// slider part 3
	//Handle Third Question
	handleInputChangethree(event) {
		this.sliderValuethree = event.target.value;
		this.updateThumbLabelPositionthree(this.sliderValuethree);
		this.fourthQuestionResponse = event.target.value;
		this.nameToDraftFourth = event.target.name;

		if (this.fourthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.fourthQuestionResponse);
			this.arrayForPushId.push(this.fourthQuestionVersinId);
		}
		// Get the last values separately
		this.fourthRspValue = this.getLastRespValueThree();
		this.fourthVersionId = this.getLastIdValueThree();
	}

	getLastRespValueThree() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getLastIdValueThree() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}
	//To place the value in right position inside the slider 
	updateThumbLabelPositionthree(sliderValuethree) {
		// Use requestAnimationFrame to wait for the next rendering cycle
		requestAnimationFrame(() => {
			const slidersec = this.template.querySelector('input');
			const thumbLabelsec = this.template.querySelector('.thumb-labelthree');

			const thumbWidthsec = parseInt(
				window.getComputedStyle(thumbLabelsec).width
			);
			const sliderWidthsec = slidersec.offsetWidth;
			const thumbPositionsec =
				(sliderValuethree / slidersec.max) * (sliderWidthsec - thumbWidthsec);

			const newPositionsec =
				thumbPositionsec + thumbWidthsec / 2 - sliderWidthsec / 2;
			const maxPositionsec = sliderWidthsec - thumbWidthsec;
			thumbLabelsec.style.left =
				Math.min(maxPositionsec, Math.max(0, newPositionsec)) + 'px';
			thumbLabelsec.setAttribute('data-value', sliderValuethree);
		});
	}
	//popup
	get popupClass() {
		return this.isPopupOpen ? 'popup-container' : 'popup-container hidden';
	}

	//Save as draft popup
	get popupClassSaveDraft() {
		return this.isDraftSavedPopupOpen
			? 'popup-containersaveasdr'
			: ' .popup-containersaveasdr hidden';
	}

	get popupClass1() {
		return this.isPopupOpen1 ? 'popup2-container' : 'popup2-container hidden';
	}

	customHideModalPopup() {
		this.customFormModal = false;
		this.isPopupOpen = false;
		this.isPopupOpen1 = false;
	}

	//To get Response for current Response for current user
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(draftResponseOfPsoriasis)
	wiredDraftResponses({ error, data }) {
		try {
			if (data) {
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
								if (this.draftResponses.length >= 5) {
									const fifthQuestion = this.draftResponses[4];
									this.fifthResponseText = fifthQuestion.questionText;
									this.fifthResponseVersinId = fifthQuestion.activeVersionId;
									if (this.draftResponses.length >= 6) {
										const sixthQuestion = this.draftResponses[5];
										this.sixthResponseText = sixthQuestion.questionText;
										this.secSixthRespTex = this.sixthResponseText;
										this.sixthResponseVersinId = sixthQuestion.activeVersionId;
									}
								}
							}
						}
					}
				}
			} else if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant);// Catching Potential Error from LWC
		}
	}

	//Assigning order number for response
	reposneModeeOn() {
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

		const secYes = this.yes;
		const secNo = this.no;

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

		const fourthVal0 = '0';
		const fourthVal1 = '1';
		const fourthVal2 = '2';
		const fourthVal3 = '3';
		const fourthVal4 = '4';
		const fourthVal5 = '5';
		const fourthVal6 = '6';
		const fourthVal7 = '7';
		const fourthVal8 = '8';
		const fourthVal9 = '9';
		const fourthVal10 = '10';
		//This value are hardcoded because to render the UI/UX design .If custom label's are used the value are not getting populated
		const fifth1 = this.informationcentre;
		const fifth2 = this.symptomtracker;
		const fifth3 = this.challenges;
		const fifth4 = this.questionnaire;
		const fifth5 = this.treatmentvideos;
		const fifth6 = this.support;

		// To show popup for submit or Return back

		this.responsOfDLQI.forEach((record) => {
			if (record.BI_PSP_ResponseOrder__c === 1) {
				if (
					record.ResponseValue === this.firstResponseText &&
					record.AssessmentQuestion.Id === this.firstResponseVersinId
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
					this.firstDraftResp = record.ResponseValue;
					this.sliderValue = this.firstDraftResp;
					this.updateThumbLabelPosition(this.sliderValue);
					this.firstDraftVerionId = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 2) {
				if (
					record.ResponseValue === this.secondResponseText &&
					record.AssessmentQuestion.Id === this.secondResponseVersinId
				) {
					if (record.ResponseValue === secYes) {
						this.isYesChecked = true;
					}
					if (record.ResponseValue === secNo) {
						this.isNoChecked = true;
					}
					this.secondDraftResp = record.ResponseValue;
					this.secondDraftVerionId = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 3) {
				if (
					record.ResponseValue === this.thirdResponseText &&
					record.AssessmentQuestion.Id === this.thirdResponseVersinId
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

					this.thirdDraftResp = record.ResponseValue;
					this.sliderValuesec = this.thirdDraftResp;
					this.updateThumbLabelPositionsec(this.sliderValuesec);
					this.thirdDraftVersionId = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 4) {
				if (
					record.ResponseValue === this.fourthResponseText &&
					record.AssessmentQuestion.Id === this.fourthResponseVersinId
				) {
					if (record.ResponseValue === fourthVal0) {
						this.sliderValuethree = 0;
					}
					if (record.ResponseValue === fourthVal1) {
						this.sliderValuethree = 1;
					}
					if (record.ResponseValue === fourthVal2) {
						this.sliderValuethree = 2;
					}
					if (record.ResponseValue === fourthVal3) {
						this.sliderValuethree = 3;
					}

					if (record.ResponseValue === fourthVal4) {
						this.sliderValuethree = 4;
					}
					if (record.ResponseValue === fourthVal5) {
						this.sliderValuethree = 5;
					}
					if (record.ResponseValue === fourthVal6) {
						this.sliderValuethree = 6;
					}
					if (record.ResponseValue === fourthVal7) {
						this.sliderValuethree = 7;
					}

					if (record.ResponseValue === fourthVal8) {
						this.sliderValuethree = 8;
					}
					if (record.ResponseValue === fourthVal9) {
						this.sliderValuethree = 9;
					}
					if (record.ResponseValue === fourthVal10) {
						this.sliderValuethree = 10;
					}
					this.fourthDraftRes = record.ResponseValue;
					this.sliderValuethree = this.fourthDraftRes;
					this.updateThumbLabelPositionthree(this.sliderValuethree);
					this.fourthDraftVersionId = record.AssessmentQuestion.Id;
				}
			}
			if (record.BI_PSP_ResponseOrder__c === 5) {
				if (
					record.ResponseValue === this.fifthResponseText &&
					record.AssessmentQuestion.Id !== null
				) {
					if (record.ResponseValue.includes(fifth1)) {
						this.fifthinfo = true;
					}
					if (record.ResponseValue.includes(fifth2)) {
						this.fifthSyTr = true;
					}
					if (record.ResponseValue.includes(fifth3)) {
						this.fifthChallenges = true;
					}
					if (record.ResponseValue.includes(fifth4)) {
						this.fifthQuestionnaire = true;
					}
					if (record.ResponseValue.includes(fifth5)) {
						this.fifthTreatmentVideo = true;
					}
					if (record.ResponseValue.includes(fifth6)) {
						this.fifthSupport = true;
					}

					this.fifthDraftResp = record.ResponseValue;
					this.fifthDraftVersionId = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 7) {
				if (
					record.ResponseValue !== null &&
					record.AssessmentQuestion.Id !== null
				) {
					if (record.ResponseValue === this.yes) {
						this.seventhYess = true;
					}
					if (record.ResponseValue === this.no) {
						this.seventhNoo = true;
					}

					this.seventhDrafRes = record.ResponseValue;
					this.seventhDrafResVersionId = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 8) {
				if (
					record.ResponseValue !== null &&
					record.AssessmentQuestion.Id !== null
				) {
					if (record.ResponseValue === this.yes) {
						this.eighthYess = true;
					}
					if (record.ResponseValue === this.no) {
						this.eighthNoo = true;
					}
					this.eigthDrafRes = record.ResponseValue;
					this.eigthDrafResVersionId = record.AssessmentQuestion.Id;
				}
			}
		});
	}

	//To get Assessment Questions
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getAssessmentQuestions)
	wiredAssessmentQuestion({ error, data }) {
		try {
			if (data) {
				this.reposneModeeOn();
				this.questionData = data.map((question) => ({
					id: question.Id,
					questionText: question.QuestionText,
					activeVersionId: question.ActiveVersion
						? question.ActiveVersion.Id
						: null
				}));

				const firstQuestion = this.questionData[0];
				const secondQuestion = this.questionData[1];
				const thirdQuestion = this.questionData[2];
				const fourthQuestion = this.questionData[3];
				const fifthQuestion = this.questionData[4];
				const sixthQuestion = this.questionData[5];
				const seventhQuestion = this.questionData[6];
				const eighthQuestion = this.questionData[7];

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
			} else if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant);// Catching Potential Error from LWC
		}
	}

	handleFirstQuestionChange(event) {
		this.nameOfQuestion = event.target.name;

		this.chekVal = event.target.value;

		if (this.chekVal === this.yes) {
			this.isYesChecked = true;
		} else {
			this.isYesChecked = false;
		}
		if (this.chekVal === this.no) {
			this.isNoChecked = true;
		} else {
			this.isNoChecked = false;
		}
		this.secondQuestionResponse = event.target.value;
		this.nameToDraftSecond = event.target.name;

		if (this.secondQuestionResponse !== '') {
			this.arrayForPushResp.push(this.secondQuestionResponse);
			this.arrayForPushId.push(this.secondQuestionVersinId);
		}
		// Get the last values separately
		this.secondRspValue = this.getLastRespValueFour();
		this.secondRespVersId = this.getLastIdValueFour();
	}

	getLastRespValueFour() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getLastIdValueFour() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}
	//Navigation methods for other Questionnaire

	navigateToCategory2() {
		window.location.assign(this.urlq + dlqiUrl);
	}
	navigateToCategory3() {
		window.location.assign(this.urlq + pssQuestionarrieUrl);
	}
	navigateToCategory4() {
		window.location.assign(this.urlq + wapiQuestionnaire);
	}
	handleSeve(event) {
		this.nameOfQuestion = event.target.name;
		this.checPrevoiusVal = this.fifthDraftResp;
		const checkedValOfBox = event.target.checked;
		if (checkedValOfBox) {
			const chekVal = event.target.value;
			if (chekVal === this.informationcentre) {
				this.fifthinfo = true;
			}

			if (chekVal === this.symptomtracker) {
				this.fifthSyTr = true;
			}

			if (chekVal === this.challenges) {
				this.fifthChallenges = true;
			}

			if (chekVal === this.questionnaire) {
				this.fifthQuestionnaire = true;
			}

			if (chekVal === this.treatmentvideos) {
				this.fifthTreatmentVideo = true;
			}

			if (chekVal === this.support) {
				this.fifthSupport = true;
			}
		}

		const checkBoval = event.target.checked;
		if (checkBoval) {
			this.checkedResVal = event.target.value;
		} else {
			this.unCheckedResVal = event.target.value;
			this.uncheckedArray.push(this.unCheckedResVal);
		}
		this.fifthQuestionresponse = event.target.value;
		this.nameToDraftFifth = event.target.name;

		if (this.fifthQuestionresponse !== '') {
			this.arrayForPushResp.push(this.fifthQuestionresponse);
			this.fifthArray.push(this.fifthQuestionresponse);
			this.arrayForPushId.push(this.fifthQuestionVersinId);
		}
		// Get the last values separately
		this.fifthResonseValue = this.getLastRespValueFive();
		this.fifthVersionId = this.getLastIdValueFive();

		const checke = event.target.checked;
		if (checke) {
			this.CheckBoxChecked = checke;
		} else {
			const uncheked = event.target.value;

			if (uncheked === this.informationcentre) {
				this.fifthinfo = false;
			}

			if (uncheked === this.symptomtracker) {
				this.fifthSyTr = false;
			}

			if (uncheked === this.challenges) {
				this.fifthChallenges = false;
			}

			if (uncheked === this.questionnaire) {
				this.fifthQuestionnaire = false;
			}

			if (uncheked === this.treatmentvideos) {
				this.fifthTreatmentVideo = false;
			}

			if (uncheked === this.support) {
				this.fifthSupport = false;
			}
		}
	}

	getLastRespValueFive() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getLastIdValueFive() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handlerealSeventhQuestionChange(event) {
		this.nameOfQuestion = event.target.name;

		const chekVal = event.target.value;
		if (chekVal === this.yes) {
			this.seventhYess = true;
		} else {
			this.seventhYess = false;
		}
		if (chekVal === this.no) {
			this.seventhNoo = true;
		} else {
			this.seventhNoo = false;
		}

		this.seventhQuestionResponse = event.target.value;
		this.nameToDraftSeventh = event.target.name;

		if (this.seventhQuestionResponse !== '') {
			this.arrayForPushResp.push(this.seventhQuestionResponse);

			this.arrayForPushId.push(this.seventhQuestionVersinId);
		}
		// Get the last values separately
		this.seventhRespalue = this.getLastRespValueSix();
		this.seventhVersiD = this.getLastIdValueSix();
	}

	getLastRespValueSix() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getLastIdValueSix() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleEigthQuestionChange(event) {
		this.nameOfQuestion = event.target.name;

		const chekVal = event.target.value;
		if (chekVal === this.yes) {
			this.eighthYess = true;
		} else {
			this.eighthYess = false;
		}
		if (chekVal === this.no) {
			this.eighthNoo = true;
		} else {
			this.eighthNoo = false;
		}

		this.eightQuestionResponse = event.target.value;
		this.nameToDraftEighth = event.target.name;

		if (this.eightQuestionResponse !== '') {
			this.arrayForPushResp.push(this.eightQuestionResponse);
			this.arrayForPushId.push(this.eightQuestionVersinId);
		}
		// Get the last values separately
		this.eghtResponseValue = this.getLastRespValueSeven();
		this.eightVersiId = this.getLastIdValueSeven();
	}

	getLastRespValueSeven() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getLastIdValueSeven() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	closePopup() {
		this.isPopupOpen = false;
		document.body.style.overflow = '';
		this.isPopupOpen = false;
		this.popupmenu = false;

		let firstValue,
			secondValue,
			thirdValue,
			fourthValue,
			fifthValue,
			sixthValue;

		for (let i = 0; i < Math.min(6, this.fifthArray.length); i++) {
			if (i === 0) {
				firstValue = this.fifthArray[i];
			} else if (i === 1) {
				secondValue = this.fifthArray[i];
			} else if (i === 2) {
				thirdValue = this.fifthArray[i];
			} else if (i === 3) {
				fourthValue = this.fifthArray[i];
			} else if (i === 4) {
				fifthValue = this.fifthArray[i];
			} else if (i === 5) {
				sixthValue = this.fifthArray[i];
			}
		}

		// Concatenate the three values with a space in between, excluding duplicates
		const concatenatedValues = [
			...new Set(
				[
					firstValue,
					secondValue,
					thirdValue,
					fourthValue,
					fifthValue,
					sixthValue
				].filter((value) => value !== undefined)
			)
		].join(', ');

		// // Concatenate all values into a single variable

		this.fifthResonseValue = concatenatedValues;

		if (typeof this.firstRspValue !== 'undefined') {
			this.sliderValue = this.firstRspValue;
			this.updateThumbLabelPosition(this.sliderValue);
		}

		if (typeof this.firstDraftResp !== 'undefined') {
			this.sliderValue = this.firstDraftResp;
			this.updateThumbLabelPosition(this.sliderValue);
		}

		if (this.secondQuestionResponse === this.yes) {
			this.isYesChecked = true;
		} else if (this.secondQuestionResponse === this.no) {
			this.isNoChecked = true;
		}

		if (typeof this.thirdRspValue !== 'undefined') {
			this.sliderValuesec = this.thirdRspValue;
			this.updateThumbLabelPositionsec(this.sliderValuesec);
		}

		if (typeof this.thirdDraftResp !== 'undefined') {
			this.sliderValuesec = this.thirdDraftResp;
			this.updateThumbLabelPositionsec(this.sliderValuesec);
		}

		if (typeof this.fourthRspValue !== 'undefined') {
			this.sliderValuethree = this.fourthRspValue;
			this.updateThumbLabelPositionthree(this.sliderValuethree);
		}

		if (typeof this.fourthDraftRes !== 'undefined') {
			this.sliderValuethree = this.fourthDraftRes;
			this.updateThumbLabelPositionthree(this.sliderValuethree);
		}

		if (concatenatedValues.includes(this.informationcentre)) {
			this.fifthinfo = true;
		}
		if (concatenatedValues.includes(this.symptomtracker)) {
			this.fifthSyTr = true;
		}
		if (concatenatedValues.includes(this.challenges)) {
			this.fifthChallenges = true;
		}
		if (concatenatedValues.includes(this.questionnaire)) {
			this.fifthQuestionnaire = true;
		}
		if (concatenatedValues.includes(this.treatmentvideos)) {
			this.fifthTreatmentVideo = true;
		}
		if (concatenatedValues.includes(this.support)) {
			this.fifthSupport = true;
		}

		if (this.seventhQuestionResponse === this.yes) {
			this.seventhYess = true;
		} else if (this.seventhQuestionResponse === this.no) {
			this.seventhNoo = true;
		}

		if (this.eightQuestionResponse === this.yes) {
			this.eighthYess = true;
		} else if (this.eightQuestionResponse === this.no) {
			this.eighthNoo = true;
		}
	}

	closePopup1() {
		this.customFormModal = false;
		document.body.style.overflow = '';
		this.isPopupOpen1 = false;
		this.popupmenu = false;

		let firstValue,
			secondValue,
			thirdValue,
			fourthValue,
			fifthValue,
			sixthValue;

		for (let i = 0; i < Math.min(6, this.fifthArray.length); i++) {
			if (i === 0) {
				firstValue = this.fifthArray[i];
			} else if (i === 1) {
				secondValue = this.fifthArray[i];
			} else if (i === 2) {
				thirdValue = this.fifthArray[i];
			} else if (i === 3) {
				fourthValue = this.fifthArray[i];
			} else if (i === 4) {
				fifthValue = this.fifthArray[i];
			} else if (i === 5) {
				sixthValue = this.fifthArray[i];
			}
		}

		// Concatenate the three values with a space in between, excluding duplicates
		const concatenatedValues = [
			...new Set(
				[
					firstValue,
					secondValue,
					thirdValue,
					fourthValue,
					fifthValue,
					sixthValue
				].filter((value) => value !== undefined)
			)
		].join(', ');

		// // Concatenate all values into a single variable

		this.fifthResonseValue = concatenatedValues;

		if (typeof this.firstRspValue !== 'undefined') {
			this.sliderValue = this.firstRspValue;

			this.updateThumbLabelPosition(this.sliderValue);
		}

		if (typeof this.firstDraftResp !== 'undefined') {
			this.sliderValue = this.firstDraftResp;
			this.updateThumbLabelPosition(this.sliderValue);
		}

		if (this.secondQuestionResponse === this.yes) {
			this.isYesChecked = true;
		} else if (this.secondQuestionResponse === this.no) {
			this.isNoChecked = true;
		}

		if (typeof this.thirdRspValue !== 'undefined') {
			this.sliderValuesec = this.thirdRspValue;
			this.updateThumbLabelPositionsec(this.sliderValuesec);
		}

		if (typeof this.thirdDraftResp !== 'undefined') {
			this.sliderValuesec = this.thirdDraftResp;
			this.updateThumbLabelPositionsec(this.sliderValuesec);
		}

		if (typeof this.fourthRspValue !== 'undefined') {
			this.sliderValuethree = this.fourthRspValue;
			this.updateThumbLabelPositionthree(this.sliderValuethree);
		}

		if (typeof this.fourthDraftRes !== 'undefined') {
			this.sliderValuethree = this.fourthDraftRes;
			this.updateThumbLabelPositionthree(this.sliderValuethree);
		}

		if (concatenatedValues.includes(this.informationcentre)) {
			this.fifthinfo = true;
		}
		if (concatenatedValues.includes(this.symptomtracker)) {
			this.fifthSyTr = true;
		}
		if (concatenatedValues.includes(this.challenges)) {
			this.fifthChallenges = true;
		}
		if (concatenatedValues.includes(this.questionnaire)) {
			this.fifthQuestionnaire = true;
		}
		if (concatenatedValues.includes(this.treatmentvideos)) {
			this.fifthTreatmentVideo = true;
		}
		if (concatenatedValues.includes(this.support)) {
			this.fifthSupport = true;
		}

		if (this.seventhQuestionResponse === this.yes) {
			this.seventhYess = true;
		} else if (this.seventhQuestionResponse === this.no) {
			this.seventhNoo = true;
		}

		if (this.eightQuestionResponse === this.yes) {
			this.eighthYess = true;
		} else if (this.eightQuestionResponse === this.no) {
			this.eighthNoo = true;
		}
	}
	//////////////////

	submitResponses() { // Set the flag to false before submitting responses
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = ''; // Reset to default
		}

		this.popupmenu = true;

		if (typeof this.firstDraftResp !== 'undefined') {
			this.nameToDraftFirst = 'firstQuestionResponse';
		}
		if (typeof this.secondDraftResp !== 'undefined') {
			this.nameToDraftSecond = 'secondQuestionResponse';
		}
		if (typeof this.thirdDraftResp !== 'undefined') {
			this.nameToDraftThird = 'thirdQuestionResponse';
		}
		if (typeof this.fourthDraftRes !== 'undefined') {
			this.nameToDraftFourth = 'fourthQuestionResponse';
		}
		if (typeof this.fifthDraftResp !== 'undefined') {
			this.nameToDraftFifth = 'fifthQuestionResponse';
		}
		if (typeof this.seventhDrafRes !== 'undefined') {
			this.nameToDraftSeventh = 'fifthQuestionResponse';
		}
		if (typeof this.eigthDrafRes !== 'undefined') {
			this.nameToDraftEighth = 'fifthQuestionResponse';
		}

		if (
			this.nameToDraftFirst != null &&
			this.nameToDraftSecond != null &&
			this.nameToDraftThird != null &&
			this.nameToDraftFourth != null &&
			this.nameToDraftSeventh != null &&
			this.nameToDraftEighth != null
		) {
			this.isPopupOpen = true;
			this.isPopupOpen1 = false;
		} else {
			this.customFormModal = true;
			this.isPopupOpen1 = true;
			this.isPopupOpen = false;
		}
	}

	get popuphide() {
		if (this.popupmenu === true) {
			return this.popupmenu === true ? 'disabled' : '';
		}
		return '';
	}

	saveAsDraft() {
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = ''; // Reset to default
		}
		this.popupmenu = true;

		let firstValue,
			secondValue,
			thirdValue,
			fourthValue,
			fifthValue,
			sixthValue;

		for (let i = 0; i < Math.min(6, this.fifthArray.length); i++) {
			if (i === 0) {
				firstValue = this.fifthArray[i];
			} else if (i === 1) {
				secondValue = this.fifthArray[i];
			} else if (i === 2) {
				thirdValue = this.fifthArray[i];
			} else if (i === 3) {
				fourthValue = this.fifthArray[i];
			} else if (i === 4) {
				fifthValue = this.fifthArray[i];
			} else if (i === 5) {
				sixthValue = this.fifthArray[i];
			}
		}

		const additionalValues = (this.checPrevoiusVal || '')
			.split(',')
			.map((value) => value.trim());

		const valuesToExclude = new Set(this.uncheckedArray);

		// Check if both arrays have the same elements
		const haveSameElements = additionalValues.every((value) =>
			valuesToExclude.has(value)
		);

		if (haveSameElements) {
			this.fifthDraftResp = '';
			this.fifthDraftVersionId = '';
			//this.fifthVersionId='';
		}

		// Concatenate the three values with a space in between, excluding duplicates
		const concatenatedValues = [
			...new Set(
				[
					firstValue,
					secondValue,
					thirdValue,
					fourthValue,
					fifthValue,
					sixthValue,
					...additionalValues
				].filter((value) => value !== undefined && !valuesToExclude.has(value))
			)
		].join(', ');

		this.fifthResonseValue = '';

		this.fifthResonseValue = concatenatedValues;
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
		//
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
		if (this.fifthResonseValue !== '') {
			this.realrespArray.push(this.fifthResonseValue);
		} else {
			this.realrespArray.push(this.fifthDraftResp);
		}

		if (this.fifthVersionId != null) {
			if (this.fifthResonseValue !== '') {
				this.realAssesVerArra.push(this.fifthVersionId);
			}
		} else {
			this.realAssesVerArra.push(this.fifthDraftVersionId);
		}
		if (this.seventhRespalue != null) {
			this.realrespArray.push(this.seventhRespalue);
		} else {
			this.realrespArray.push(this.seventhDrafRes);
		}

		if (this.seventhVersiD != null) {
			this.realAssesVerArra.push(this.seventhVersiD);
		} else {
			this.realAssesVerArra.push(this.seventhDrafResVersionId);
		}

		if (this.eghtResponseValue != null) {
			this.realrespArray.push(this.eghtResponseValue);
		} else {
			this.realrespArray.push(this.eigthDrafRes);
		}

		if (this.eightVersiId != null) {
			this.realAssesVerArra.push(this.eightVersiId);
		} else {
			this.realAssesVerArra.push(this.eigthDrafResVersionId);
		}

		// Filter out empty responses and their corresponding IDs
		const nonEmptyResponses = this.realrespArray.filter(
			(response) => response !== ''
		);
		const nonEmptyIds = this.realAssesVerArra.filter((id) => id !== '');

		if (this.realrespArray.length > 0) {
			draftResponseSubmition({
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
					this.showToast(consoleErrorMessage, error.message, errorvariant);// Catching Potential Error
					// Handle any errors that occur during the response save
				});
		}
	}
	//Save as draft popup
	popUpMetod() {
		this.isDraftSavedPopupOpen = true;
		window.scrollTo({ top: 0, behavior: 'smooth' });
	}
	//Navigation to outstanding Questionnaire
	closeDraftSavedPopup() {
		this.isDraftSavedPopupOpen = false;
		window.location.assign(this.urlq + outStandingPage);
	}
	//To Sumbit Response and Navigate to outstanding Questionnaire
	confirmSubmission() {
		window.location.assign(this.urlq + outStandingPage);

		let firstValue,
			secondValue,
			thirdValue,
			fourthValue,
			fifthValue,
			sixthValue;

		for (let i = 0; i < Math.min(6, this.fifthArray.length); i++) {
			if (i === 0) {
				firstValue = this.fifthArray[i];
			} else if (i === 1) {
				secondValue = this.fifthArray[i];
			} else if (i === 2) {
				thirdValue = this.fifthArray[i];
			} else if (i === 3) {
				fourthValue = this.fifthArray[i];
			} else if (i === 4) {
				fifthValue = this.fifthArray[i];
			} else if (i === 5) {
				sixthValue = this.fifthArray[i];
			}
		}

		const additionalValues = (this.checPrevoiusVal || '')
			.split(',')
			.map((value) => value.trim());
		const valuesToExclude = new Set(this.uncheckedArray);

		// Check if both arrays have the same elements
		const haveSameElements = additionalValues.every((value) =>
			valuesToExclude.has(value)
		);

		if (haveSameElements) {
			this.fifthDraftResp = '';
			this.fifthDraftVersionId = '';
		}

		// Concatenate the three values with a space in between, excluding duplicates
		const concatenatedValues = [
			...new Set(
				[
					firstValue,
					secondValue,
					thirdValue,
					fourthValue,
					fifthValue,
					sixthValue,
					...additionalValues
				].filter((value) => value !== undefined && !valuesToExclude.has(value))
			)
		].join(', ');

		// // Concatenate all values into a single variable

		this.fifthResonseValue = '';
		this.fifthResonseValue = concatenatedValues;

		//
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
		//
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
		//
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
			if (this.fifthResonseValue !== '') {
				this.realAssesVerArra.push(this.fifthVersionId);
			}
		} else {
			this.realAssesVerArra.push(this.fifthDraftVersionId);
		}
		if (this.seventhRespalue != null) {
			this.realrespArray.push(this.seventhRespalue);
		} else {
			this.realrespArray.push(this.seventhDrafRes);
		}

		if (this.seventhVersiD != null) {
			this.realAssesVerArra.push(this.seventhVersiD);
		} else {
			this.realAssesVerArra.push(this.seventhDrafResVersionId);
		}
		if (this.eghtResponseValue != null) {
			this.realrespArray.push(this.eghtResponseValue);
		} else {
			this.realrespArray.push(this.eigthDrafRes);
		}

		if (this.eightVersiId != null) {
			this.realAssesVerArra.push(this.eightVersiId);
		} else {
			this.realAssesVerArra.push(this.eigthDrafResVersionId);
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

		this.numberOfResponses = responseArray.filter(
			(response) => typeof response !== 'undefined'
		).length;

		if (this.numberOfResponses === 6 || this.numberOfResponses === 7) {
			const nonEmptyResponses = this.realrespArray.filter(
				(response) => response !== ''
			);
			const nonEmptyIds = this.realAssesVerArra.filter((id) => id !== '');

			if (this.realrespArray.length > 0) {
				submitAssessmentResponse({
					questionIds: nonEmptyIds,
					responseTexts: nonEmptyResponses
				})
					.then((result) => {
						console.log(result);
					})
					.catch((error) => {
						this.showToast(consoleErrorMessage, error.message, errorvariant);// Catching Potential Error
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