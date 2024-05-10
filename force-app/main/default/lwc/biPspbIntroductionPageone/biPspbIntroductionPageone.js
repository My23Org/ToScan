// This introductory questionnaire allows you to provide information about yourself
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//  To import Apex Classes
import introductionQuestionare from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.getIntroductionAsQuesLastTen';
import submitAssessmentResponse from '@salesforce/apex/BI_PSP_LetsPersonlise.mulitipleDraftRecordsInsertion';
import draftResponseOfIntroduction from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.draftResponseOfIntroduction';
import deleteSelectedResponse from '@salesforce/apex/BI_PSP_LetsPersonlise.draftRespoDeletion';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getCompletedAssessmentCountsByCurrentUserName';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
// To import Static Resources
import BI_PSP_PSSimage from '@salesforce/resourceUrl/BI_PSP_PSSimage';
import BI_PSP_letspersonalizeimage from '@salesforce/resourceUrl/BI_PSP_letspersonalizeimage';
import BI_PSP_DLQIimage from '@salesforce/resourceUrl/BI_PSP_DLQIimage';
import BI_PSP_WPAIimage from '@salesforce/resourceUrl/BI_PSP_WPAIimage';
import BI_PSP_Qualitativeimage from '@salesforce/resourceUrl/BI_PSP_Qualitativeimage';
// To import Custom Labels
import BI_PSP_intropageonebottom from '@salesforce/label/c.BI_PSP_intropageonebottom';
import BI_PSP_introductionCategory from '@salesforce/label/c.BI_PSP_introductionCategory';
import BI_PSP_PssCategory from '@salesforce/label/c.BI_PSP_PssCategory';
import BI_PSP_WapiCategory from '@salesforce/label/c.BI_PSP_WapiCategory';
import BI_PSP_DlqiCategory from '@salesforce/label/c.BI_PSP_DlqiCategory';
import BI_PSP_QualitativeCategory from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import BI_PSP_Wapi from '@salesforce/label/c.BI_PSP_WAPI';
import BI_PSP_lessthan_a_month from '@salesforce/label/c.BI_PSP_lessthan_a_month';
import BI_PSP_sixmonths from '@salesforce/label/c.BI_PSP_sixmonths';
import BI_PSP_lessthanyear from '@salesforce/label/c.BI_PSP_lessthanyear';
import BI_PSP_morethanyear from '@salesforce/label/c.BI_PSP_morethanyear';
import BI_PSP_male from '@salesforce/label/c.BI_PSP_male';
import BI_PSP_female from '@salesforce/label/c.BI_PSP_female';
import BI_PSP_other from '@salesforce/label/c.BI_PSP_other';
import BI_PSP_prefernot_tosay from '@salesforce/label/c.BI_PSP_prefernot_tosay';
import BI_PSP_yes from '@salesforce/label/c.BI_PSP_yes';
import BI_PSP_no from '@salesforce/label/c.BI_PSP_no';
import BI_PSP_relationshipwith_ff from '@salesforce/label/c.BI_PSP_relationshipwith_ff';
import BI_PSP_relationshipwith_partner from '@salesforce/label/c.BI_PSP_relationshipwith_partner';
import BI_PSP_selfesteem from '@salesforce/label/c.BI_PSP_selfesteem';
import BI_PSP_selectall from '@salesforce/label/c.BI_PSP_selectall';
import BI_PSP_aboutmyself from '@salesforce/label/c.BI_PSP_aboutmyself';
import BI_PSP_next from '@salesforce/label/c.BI_PSP_next';
import BI_PSP_skip from '@salesforce/label/c.BI_PSP_skip';
import BI_PSP_asthma from '@salesforce/label/c.BI_PSP_asthma';
import BI_PSP_diabetesmellitus from '@salesforce/label/c.BI_PSP_diabetesmellitus';
import BI_PSP_depression from '@salesforce/label/c.BI_PSP_depression';
import BI_PSP_hayfever from '@salesforce/label/c.BI_PSP_hayfever';
import BI_PSP_hypertension from '@salesforce/label/c.BI_PSP_hypertension';
import BI_PSP_highcholesterol from '@salesforce/label/c.BI_PSP_highcholesterol';
import BI_PSP_Obesity from '@salesforce/label/c.BI_PSP_Obesity';
import BI_PSP_Osteoporosis from '@salesforce/label/c.BI_PSP_Osteoporosis';
import BI_PSP_ulcer from '@salesforce/label/c.BI_PSP_ulcer';
import BI_PSP_psoriasis from '@salesforce/label/c.BI_PSP_psoriasis';
import BI_PSP_Psoriaticarthritis from '@salesforce/label/c.BI_PSP_Psoriaticarthritis';
import BI_PSP_doyouagree from '@salesforce/label/c.BI_PSP_doyouagree';
import fifthquestion from '@salesforce/label/c.BI_PSP_IntroductionfifthQuestion';
import sixthquestion from '@salesforce/label/c.BI_PSP_IntroductionsixthQuestion';
import BI_PSP_maybe from '@salesforce/label/c.BI_PSP_maybe';
import BI_PSP_answered from '@salesforce/label/c.BI_PSP_answered';
import BI_PSP_submit from '@salesforce/label/c.BI_PSP_submit';
import BI_PSP_saveasdraft from '@salesforce/label/c.BI_PSP_saveasdraft';
import BI_PSP_outstandingquestionnaire from '@salesforce/label/c.BI_PSP_outstandingquestionnaire';
import BI_PSP_returnback from '@salesforce/label/c.BI_PSP_returnback';
import BI_PSP_confirm_submission from '@salesforce/label/c.BI_PSP_confirm_submission';
import BI_PSP_cannotbeedited from '@salesforce/label/c.BI_PSP_cannotbeedited';
import BI_PSP_cancel from '@salesforce/label/c.BI_PSP_cancel';
import BI_PSP_confirm from '@salesforce/label/c.BI_PSP_confirm';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import popupmessage from '@salesforce/label/c.BI_PSP_Messagepopup';
import submitmessage from '@salesforce/label/c.BI_PSP_submittext';
import letsPersonlizeurl from '@salesforce/label/c.BI_PSPB_BRLetsPersonalizePageTwo';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import BI_PSP_CompleteAll from '@salesforce/label/c.BI_PSP_CompleteAll';
import BI_PSP_Others from '@salesforce/label/c.BI_PSP_Others';
// To import current user ID
import Id from '@salesforce/user/Id';

export default class BiPspbIntroductionPageone extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track countquestion = 15;
	@track iSmale = false;
	@track iSfemale = false;
	@track iSOther = false;
	@track iSPrefferNottosay = false;

	@track IsfirstLessThanMonth = false;
	@track IsfirstLessSix = false;
	@track IsfirstLessYear = false;
	@track IsfirstMoreYear = false;

	@track thirdisno = false;
	@track thirdisyes = false;

	@track eighthRadYes = false;
	@track eighthRadNo = false;

	@track fourthCheckRelatFam = false;
	@track fourthCheckWithPartner = false;
	@track fourthCheckSelfEsteem = false;

	@track ninthRadYes = false;
	@track ninthRadNo = false;

	@track tenthCheckAsthma = false;
	@track tenthCheckDiabetes = false;
	@track tenthCheckDepression = false;
	@track tenthCheckHayFever = false;
	@track tenthCheckBp = false;
	@track tenthCheckHighChol = false;
	@track tenthCheckObesity = false;
	@track tenthCheckOsteo = false;
	@track tenthCheckPeptic = false;
	@track tenthCheckplaque = false;
	@track tenthCheckpsoriatic = false;
	@track tenthCheckOthers = false;

	@track aftersixthrades = false;
	@track aftersixthRadMaybe = false;
	@track aftersixthRadNo = false;

	@track sixthRadYes = false;
	@track sixthRadMayBe = false;
	@track sixthRadNo = false;

	@track eleventhRadYes = false;
	@track eleventhRadMaybe = false;
	@track eleventhRadNo = false;

	@track secondRadYes = false;
	@track secondRadMaybe = false;
	@track secondRadNo = false;

	@track thirdRadYes = false;
	@track thirdRadMaybe = false;
	@track thirdRadNo = false;

	@track fourthRadYes = false;
	@track fourthRadMaybe = false;
	@track fourthRadNo = false;

	@track seventhRadYes = false;
	@track seventhRadMaybe = false;
	@track seventhRadNo = false;

	@track twelthRadYes = false;
	@track twelthRadMaybe = false;
	@track twelthRadNo = false;

	@track thirteenththRadYes = false;
	@track thirteenththRadMaybe = false;
	@track thirteenththRadNo = false;

	@track forteenththRadYes = false;
	@track forteenthRadMaybe = false;
	@track forteenthRadNo = false;
	@track sixthQuestionVisible = false;

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
	@track eleventhQuestionVersinId;
	@track twelthQuestionText;
	@track twelthQuestionVersinId;
	@track thirteeenthQuestionText;
	@track thirteeenthQuestionVersinId;
	@track foteenthQuestionText;
	@track foteenthQuestionVersinId;
	@track fifteenthQuestionText;
	@track fifteenthQuestionVersinId;
	@track sixteenthQuestionText;
	@track sixteenthQuestionVersinId;
	@track seventeethQuestionText;
	@track seventeethQuestionVersinId;
	@track eighteenthQuestionText;
	@track eighteenthQuestionVersinId;

	@track selectedDateRange = '';
	@track selectedGender = '';
	@track selectedGppDiscussion = '';
	@track selectedGppImpact = [];
	@track hasMedicalConditions = '';
	@track showMedicalConditions = false;
	@track selectedMedicalConditions = [];

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

	@track twelvthQuestionResponse = '';
	@track thirteenthQuestionResponse = '';
	@track fourteenthQuestionResponse = '';
	@track fifteenthQuestionResponse = '';
	@track sixteenthQuestionResponse = '';

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
	@track eleventhVersiD;
	@track twelvthRespalue;
	@track twelvthVersiD;
	@track thirteenthResponseValue;
	@track thirteenthVersiId;
	@track fourteenthResponseValue;
	@track fourteenthVersId;
	@track fifteenthResponseValue;
	@track fifteenthVersId;
	@track sixteenthResponseValue;
	@track sixteenthVersId;

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
	@track nameToDrafteEleventh;
	@track nameToDrafttwelvth;
	@track nameToDraftThirteenth;
	@track nameToDraftFourteenth;
	@track nameToDraftFifteenth;
	@track nameToDraftSixteenth;
	@track nameToDraftSeventeeth;
	@track eventcheck = false;
	@track numberOfResponses;
	@track checkyesorno = false;

	@track totalValu = [];
	@track selectMedic = [];
	@track draftResponses = [];

	@track checkBoxArray;

	@track records = [];
	@track customClass='nds-form-element nds-form-containerthree';
	@track savedArrayForPushResp = [];
	@track concatenatedValues;

	@track showSixteenthQuestion = false;
	@track isConfirmationDialogOpen = false;
	@track customFormModal = false;

	@track selectedValues = [];

	@track isDraftSavedPopupOpen = false;
	@track draftSavedMessage = popupmessage;

	@track isPopupOpen = false;
	@track isPopupOpen1 = false;

	// Declaration of Global variables
	uniqueUncheckedCount = '';
	uniqueCheckedCount = '';
	itsTrue = false;
	content1 = submitmessage;
	message = BI_PSP_CompleteAll;
	aboutmyself = BI_PSP_aboutmyself;
	skip = BI_PSP_skip;
	next = BI_PSP_next;
	otherss = BI_PSP_Others;
	trueOrnOt;
	userid = Id;
	propertyProcessedMap = {};
	storefifthId;
	idoFfORU;
	storeid5;
	knowTheUnchecked;
	fourthCheck;
	knowSixthChecked;
	toShowSixth;
	sixthCheckedArray = [];
	filteredArray = [];
	fe;
	isEqualLength = false;
	filterArr = '';
	popupmenu = false;
	theLab = '';
	checkedboleaan;
	uncheckedBoolean;
	urlq;
	questionData = [];
	cardimage = BI_PSP_letspersonalizeimage;
	cardimage1 = BI_PSP_DLQIimage;
	cardimage2 = BI_PSP_PSSimage;
	cardimage3 = BI_PSP_WPAIimage;
	cardimage4 = BI_PSP_Qualitativeimage;
	introbottom = BI_PSP_intropageonebottom;
	introduction = BI_PSP_introductionCategory;
	pss = BI_PSP_PssCategory;
	dlqi = BI_PSP_DlqiCategory;
	wapi = BI_PSP_WapiCategory;
	qsq = BI_PSP_QualitativeCategory;
	workAPI = BI_PSP_Wapi;
	fifthquestion1 = fifthquestion;
	sixthquestion1 = sixthquestion;

	answerquestion = 0;
	lessthanamonth = BI_PSP_lessthan_a_month;
	lessthan6months = BI_PSP_sixmonths;
	lessthanyear = BI_PSP_lessthanyear;
	morethanyear = BI_PSP_morethanyear;
	male = BI_PSP_male;
	female = BI_PSP_female;
	other = BI_PSP_other;
	prefernot = BI_PSP_prefernot_tosay;
	yes = BI_PSP_yes;
	no = BI_PSP_no;
	relationshipwithff = BI_PSP_relationshipwith_ff;
	relationshipwithpartner = BI_PSP_relationshipwith_partner;
	selfesteem = BI_PSP_selfesteem;
	selectall = BI_PSP_selectall;

	others = BI_PSP_Others;
	asthma = BI_PSP_asthma;
	diabetes = BI_PSP_diabetesmellitus;
	depression = BI_PSP_depression;
	hayfever = BI_PSP_hayfever;
	hypertension = BI_PSP_hypertension;
	highcholestrol = BI_PSP_highcholesterol;
	obesityc = BI_PSP_Obesity;
	osteoporosisc = BI_PSP_Osteoporosis;
	ulcer = BI_PSP_ulcer;
	psoriasis = BI_PSP_psoriasis;
	psoriaticarthritis = BI_PSP_Psoriaticarthritis;

	doyouagree = BI_PSP_doyouagree;
	maybe = BI_PSP_maybe;

	answered = BI_PSP_answered;
	submit = BI_PSP_submit;
	saveasdraft = BI_PSP_saveasdraft;
	outstandingque = BI_PSP_outstandingquestionnaire;
	returnbackc = BI_PSP_returnback;

	confirmsub = BI_PSP_confirm_submission;
	cannotedit = BI_PSP_cannotbeedited;
	cancelbt = BI_PSP_cancel;
	confirmbt = BI_PSP_confirm;

	checPrevoiusVal;
	unCheckedResVal;
	uncheckedArray = [];
	fifthWithoudNewVals;
	uncheckVar;

	sixthDraftVal;
	sixthUncheckedVals;
	sixthUnchekedArray = [];
	checkedResVal;

	firstQResForEach;
	secQResForEach;
	secQRes;
	secQVersionResForEach;

	thirdQResForEach;
	thirdQVersionResForEach;

	fourQResForEach;
	fourQVersionResForEach;

	fifthQResForEach;
	sixthQResForEach;

	sevenQResForEach;
	sevenQVersionResForEach;

	eigthQResForEach;
	nineQResForEach;
	tenthQResForEach;
	eleventhQResForEach;
	twelthQResForEach;
	thirteenthQResForEach;
	fourteenthQResForEach;
	fifteenthQResForEach;
	sixteenthQResForEach;

	//Below defined getter method to determine the CSS class for the  popup container based on its visibility
	get popupClass() {
		return this.isPopupOpen ? 'popup-container' : 'popup-container hidden';
	}

	get popupClassSaveDraft() {
		return this.isDraftSavedPopupOpen
			? 'popup-containersaveasdr'
			: '.popup-containersaveasdr hidden';
	}

	get popupClass1() {
		return this.isPopupOpen1 ? 'popup2-container' : 'popup2-container hidden';
	}

	// Method to hide both main and secondary popups
	customHideModalPopup() {
		this.customFormModal = false;
		this.isPopupOpen = false;
		this.isPopupOpen1 = false;
	}

	//to check whether the page is in Brandd or unassigned.Also to check the desktop view
	connectedCallback() {
		try {
			const currentURL = window.location.href;

			const urlObject = new URL(currentURL);

			const path = urlObject.pathname;

			const pathComponents = path.split('/');

			const desiredComponent = pathComponents.find((component) =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
					component.toLowerCase()
				)
			);

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurl;
			} else {
				this.urlq = unassignedurl;
			}

			this.isDesktop = this.isDesktopView();

			window.addEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	disconnectedCallback() {
		// Remove the resize event listener when the component is disconnected
		window.removeEventListener('resize', this.handleResize.bind(this));

	}

	handleResize() {
		// Handle the resize event by updating the isDesktop property
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

	// Wire adapter to fetch patient data after three months and fourteen weeks
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ data, error }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				// Assign fetched data to component properties
				this.threeMonthsVar = data.threeMonthsVar;
				this.forteenWeeks = data.forteenWeeks;
				this.targetDate2 = data.targetDate2 ?? null;
				this.targetDate14 = data.targetDate14 ?? null;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Wire adapter to count assessment responses
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				// Assign fetched data to component properties
				this.count = data;

				if (this.count.length > 0) {
					// Assign count values to component properties
					this.stwai = this.count[0];
					this.stpss = this.count[1];
					this.stdlq = this.count[2];
					this.stqsq = this.count[3];
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//below are  Getter methods to determine if dlqi ,pss,wapi check is enabled
	get checkdlqi() {
		return this.stdlq > 0 ? 'disabled' : '';
	}

	get checkpss() {
		return this.stpss > 0 ? 'disabled' : '';
	}

	get checkwai() {
		return this.stwai > 0 ? 'disabled' : '';
	}

	// Getter method to determine if qsq check is enabled
	get checkqsq() {
		if (this.targetDate14 === null && this.targetDate2 === null) {
			return 'disabled';
		} else if (this.stqsq > 0) {
			return 'disabled';
		}
		return '';
	}

	// Wire adapter to fetch draft responses of introduction
	@wire(draftResponseOfIntroduction)
	wiredDraftResponses({ data, error }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				this.records = data;
				this.answerquestion = this.records.length;
				this.draftResponsesforlater();

				this.sixthresponsetruefalse = this.records[4].ResponseText === this.no;

				// Loop through each record to check conditions
				this.records.forEach((record) => {
					if (
						record.BI_PSP_ResponseOrder__c === 5 &&
						record.ResponseText === this.yes
					) {
						this.countquestion = 16;
						this.answerquestion = this.records.length;
					} else if (
						record.BI_PSP_ResponseOrder__c === 5 &&
						record.ResponseText === this.no
					) {
						this.answerquestion = this.records.length;
					}
				});

				// Check if the answer question count exceeds a certain threshold
				if (this.answerquestion > this.countquestion) {
					this.countquestion = 16;
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//this method is for storing the draft response and its version id so that we can use these variables to save the draft response later ,also in this method we will be making the radio buttons as checked if the draft values matches with the values that are stored in to variables with their respective radio option values.

	draftResponsesforlater() {
		const targetFemale = this.female;
		const targetMale = this.male;
		const targetOther = this.other;
		const prefferNotTosay = this.prefernot;

		const firstLessThanMonth = this.lessthanamonth;
		const firstLessThanSix = this.lessthan6months;
		const firstLessThanYr = this.lessthanyear;
		const firstMoreThan = this.morethanyear;

		const thirdAnswerRF = this.relationshipwithff;
		const thirdRWP = this.relationshipwithpartner;
		const thirdSelEstee = this.selfesteem;

		const asthmaVar = this.asthma;
		const duabetesVar = this.diabetes;
		const depressionVar = this.depression;
		const hayFever = this.hayfever;
		const highBp = this.hypertension;
		const highChol = this.highcholestrol;
		const Obesity = this.obesityc;
		const Osteoporosis = this.osteoporosisc;
		const peptic = this.ulcer;
		const plaque = this.psoriasis;
		const psoriasiArthritis = this.psoriaticarthritis;
		const Others = this.others;

		const thirdYes = this.yes;
		const thirdNo = this.no;

		const seventhYes = this.yes;
		const seventhNo = this.no;

		const eigthYes = this.yes;
		const eigthNo = this.no;
		const eigthMaybe = this.maybe;

		const ninthYes = this.yes;
		const ninthNo = this.no;
		const ninthMaybe = this.maybe;

		const tenthYes = this.yes;
		const tenthNo = this.no;
		const tenthMaybe = this.maybe;

		const eleventhYes = this.yes;
		const eleventhNo = this.no;
		const eleventhMaybe = this.maybe;

		const twelthYes = this.yes;
		const twelthNo = this.no;
		const twelthMaybe = this.maybe;

		const thirteenthYes = this.yes;
		const thirteenthNo = this.no;
		const thirteenthMaybe = this.maybe;

		const fourteenthYes = this.yes;
		const fourteenthNo = this.no;
		const fourteenthMaybe = this.maybe;

		const fifteenthYes = this.yes;
		const fifteenthNo = this.no;
		const fifteenthMaybe = this.maybe;

		const sixteenthYes = this.yes;
		const sixteenthNo = this.no;
		const sixteenthMaybe = this.maybe;

		const seventeethYes = this.yes;
		const seventeethNo = this.no;
		const seventeethMaybe = this.maybe;
		//the below for each will iterate through each of the response and stores the response and id if criteria gets matched.
		this.records.forEach((record) => {
			if (record.BI_PSP_ResponseOrder__c === 2) {
				if (
					record.ResponseValue === targetFemale &&
					record.AssessmentQuestion.Id !== null
				) {
					this.secQResForEach = record.ResponseValue;
					this.secQVersionResForEach = record.AssessmentQuestion.Id;
					this.iSfemale = true;
				}

				if (
					record.ResponseValue === targetMale &&
					record.AssessmentQuestion.Id !== null
				) {
					this.iSmale = true;
					this.secQResForEach = record.ResponseValue;
					this.secQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === targetOther &&
					record.AssessmentQuestion.Id !== null
				) {
					this.secQResForEach = record.ResponseValue;
					this.secQVersionResForEach = record.AssessmentQuestion.Id;
					this.iSOther = true;
				}
				if (
					record.ResponseValue === prefferNotTosay &&
					record.AssessmentQuestion.Id !== null
				) {
					this.iSPrefferNottosay = true;
					this.secQVersionResForEach = record.AssessmentQuestion.Id;
					this.secQResForEach = record.ResponseValue;
				}
			}
			if (record.BI_PSP_ResponseOrder__c === 1) {
				if (
					record.ResponseValue === firstLessThanMonth &&
					record.AssessmentQuestion.Id !== null
				) {
					this.firstQResForEach = record.ResponseValue;

					this.firstQVersionResForEach = record.AssessmentQuestion.Id;
					this.IsfirstLessThanMonth = true;
				}

				if (
					record.ResponseValue === firstLessThanSix &&
					record.AssessmentQuestion.Id !== null
				) {
					this.firstQResForEach = record.ResponseValue;
					this.firstQVersionResForEach = record.AssessmentQuestion.Id;
					this.IsfirstLessSix = true;
				}

				if (
					record.ResponseValue === firstLessThanYr &&
					record.AssessmentQuestion.Id !== null
				) {
					this.firstQResForEach = record.ResponseValue;
					this.firstQVersionResForEach = record.AssessmentQuestion.Id;

					this.IsfirstLessYear = true;
				}

				if (
					record.ResponseValue === firstMoreThan &&
					record.AssessmentQuestion.Id !== null
				) {
					this.firstQResForEach = record.ResponseValue;

					this.firstQVersionResForEach = record.AssessmentQuestion.Id;

					this.IsfirstMoreYear = true;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 4) {
				this.idoFfORU = record.Id;
				if (
					record.ResponseValue.includes(thirdAnswerRF) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fourthCheckRelatFam = true;
					this.fourQResForEach = record.ResponseValue;

					this.fourQVersionResForEach = record.AssessmentQuestion.Id;
				}

				if (
					record.ResponseValue.includes(thirdRWP) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fourthCheckWithPartner = true;
					this.fourQResForEach = record.ResponseValue;

					this.fourQVersionResForEach = record.AssessmentQuestion.Id;
				}

				if (
					record.ResponseValue.includes(thirdSelEstee) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fourthCheckSelfEsteem = true;
					this.fourQResForEach = record.ResponseValue;

					this.fourQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 6) {
				this.storeid5 = record.Id;

				if (
					record.ResponseValue.includes(asthmaVar) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckAsthma = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(duabetesVar) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckDiabetes = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(depressionVar) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckDepression = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(hayFever) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckHayFever = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(highBp) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckBp = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(highChol) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckHighChol = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(Obesity) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckObesity = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(Osteoporosis) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckOsteo = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(peptic) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckPeptic = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(plaque) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckplaque = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(psoriasiArthritis) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckpsoriatic = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(Others) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthCheckOthers = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 3) {
				if (
					record.ResponseValue === thirdYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.thirdQResForEach = record.ResponseValue;
					this.thirdQVersionResForEach = record.AssessmentQuestion.Id;
					this.thirdisyes = true;
				}
				if (
					record.ResponseValue === thirdNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.thirdQResForEach = record.ResponseValue;
					this.thirdQVersionResForEach = record.AssessmentQuestion.Id;
					this.thirdisno = true;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 5) {
				if (
					record.ResponseValue === seventhYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fifthQResForEach = record.ResponseValue;
					this.fifthQVersionResForEach = record.AssessmentQuestion.Id;
					this.fifthRadYes = true;
					this.sixthQuestionVisible = this.fifthQResForEach === this.yes;
				}
				if (
					record.ResponseValue === seventhNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fifthRadNo = true;
					this.fifthQResForEach = record.ResponseValue;
					this.fifthQVersionResForEach = record.AssessmentQuestion.Id;
					if (this.fifthQResForEach === this.no) {
						this.sixthQResForEach = '';
						this.sixthQVersionResForEach = '';
					}
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 7) {
				if (
					record.ResponseValue === eigthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.sevenQResForEach = record.ResponseValue;
					if (this.sevenQResForEach !== null) {
						this.aftersixthrades = true;
					}

					this.sevenQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === eigthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.sevenQResForEach = record.ResponseValue;
					this.sevenQVersionResForEach = record.AssessmentQuestion.Id;

					this.aftersixthRadNo = true;
				}
				if (
					record.ResponseValue === eigthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.sevenQResForEach = record.ResponseValue;
					this.sevenQVersionResForEach = record.AssessmentQuestion.Id;

					this.aftersixthRadMaybe = true;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 9) {
				if (
					record.ResponseValue === tenthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.nineQResForEach = record.ResponseValue;
					this.nineQVersionResForEach = record.AssessmentQuestion.Id;

					this.eleventhRadYes = true;
				}
				if (
					record.ResponseValue === tenthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.eleventhRadNo = true;
					this.nineQResForEach = record.ResponseValue;
					this.nineQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === tenthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.nineQResForEach = record.ResponseValue;
					this.nineQVersionResForEach = record.AssessmentQuestion.Id;

					this.eleventhRadMaybe = true;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 8) {
				if (
					record.ResponseValue === ninthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.eigthQResForEach = record.ResponseValue;
					this.eigthQVersionResForEach = record.AssessmentQuestion.Id;

					this.sixthRadYes = true;
				}
				if (
					record.ResponseValue === ninthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.eigthQResForEach = record.ResponseValue;
					this.eigthQVersionResForEach = record.AssessmentQuestion.Id;
					this.sixthRadNo = true;
				}
				if (
					record.ResponseValue === ninthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.eigthQResForEach = record.ResponseValue;
					this.eigthQVersionResForEach = record.AssessmentQuestion.Id;

					this.sixthRadMayBe = true;
				}
			}
			if (record.BI_PSP_ResponseOrder__c === 10) {
				if (
					record.ResponseValue === eleventhYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthQResForEach = record.ResponseValue;
					this.tenthQVersionResForEach = record.AssessmentQuestion.Id;

					this.secondRadYes = true;
				}
				if (
					record.ResponseValue === eleventhNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.secondRadNo = true;
					this.tenthQResForEach = record.ResponseValue;
					this.tenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === eleventhMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.secondRadMaybe = true;
					this.tenthQResForEach = record.ResponseValue;
					this.tenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 11) {
				if (
					record.ResponseValue === twelthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.eleventhQResForEach = record.ResponseValue;
					this.eleventhQVersionResForEach = record.AssessmentQuestion.Id;

					this.thirdRadYes = true;
				}
				if (
					record.ResponseValue === twelthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.thirdRadNo = true;
					this.eleventhQResForEach = record.ResponseValue;
					this.eleventhQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === twelthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.thirdRadMaybe = true;
					this.eleventhQResForEach = record.ResponseValue;
					this.eleventhQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 12) {
				if (
					record.ResponseValue === thirteenthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.twelthQResForEach = record.ResponseValue;
					this.twelthQVersionResForEach = record.AssessmentQuestion.Id;

					this.fourthRadYes = true;
				}
				if (
					record.ResponseValue === thirteenthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fourthRadNo = true;
					this.twelthQResForEach = record.ResponseValue;
					this.twelthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === thirteenthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fourthRadMaybe = true;
					this.twelthQResForEach = record.ResponseValue;
					this.twelthQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 13) {
				if (
					record.ResponseValue === fourteenthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.thirteenthQResForEach = record.ResponseValue;
					this.thirteenthQVersionResForEach = record.AssessmentQuestion.Id;

					this.seventhRadYes = true;
				}
				if (
					record.ResponseValue === fourteenthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.seventhRadNo = true;
					this.thirteenthQResForEach = record.ResponseValue;
					this.thirteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === fourteenthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.seventhRadMaybe = true;
					this.thirteenthQResForEach = record.ResponseValue;
					this.thirteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 14) {
				if (
					record.ResponseValue === fifteenthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fourteenthQResForEach = record.ResponseValue;
					this.fourteenthQVersionResForEach = record.AssessmentQuestion.Id;
					this.twelthRadYes = true;
				}
				if (
					record.ResponseValue === fifteenthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.twelthRadNo = true;
					this.fourteenthQResForEach = record.ResponseValue;
					this.fourteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === fifteenthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.twelthRadMaybe = true;
					this.fourteenthQResForEach = record.ResponseValue;
					this.fourteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 15) {
				if (
					record.ResponseValue === sixteenthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fifteenthQResForEach = record.ResponseValue;
					this.fifteenthQVersionResForEach = record.AssessmentQuestion.Id;

					this.thirteenththRadYes = true;
				}
				if (
					record.ResponseValue === sixteenthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.thirteenththRadNo = true;
					this.fifteenthQResForEach = record.ResponseValue;
					this.fifteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === sixteenthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.thirteenththRadMaybe = true;
					this.fifteenthQResForEach = record.ResponseValue;
					this.fifteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 16) {
				//16
				if (
					record.ResponseValue === seventeethYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.sixteenthQResForEach = record.ResponseValue;

					this.sixteenthQVersionResForEach = record.AssessmentQuestion.Id;

					this.forteenththRadYes = true;
				}
				if (
					record.ResponseValue === seventeethNo &&
					record.AssessmentQuestion.Id !== null
				) {
					this.forteenthRadNo = true;
					this.sixteenthQResForEach = record.ResponseValue;
					this.sixteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === seventeethMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.forteenthRadMaybe = true;
					this.sixteenthQResForEach = record.ResponseValue;
					this.sixteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}
		});
	}

	//this wire method is for retrieving the introduction Questions and storing them to different variables one by one
	@wire(introductionQuestionare)
	wiredAssessmentQuestion({ data, error }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				this.questionData = data.map((question) => ({
					id: question.Id,
					questionText: question.QuestionText ? question.QuestionText : null,
					activeVersionId: question.ActiveVersion
						? question.ActiveVersion.Id
						: null
				}));
				//the below set of varibales holds the Questions of introduction Questionnaire
				const firstQuestion = this.questionData[0];
				const secondQuestion = this.questionData[1];
				const thirdQuestion = this.questionData[2];
				const fourthQuestion = this.questionData[3];
				const FifthQuestion = this.questionData[4];
				const SixthQuestion = this.questionData[5];
				const SeventhQuestion = this.questionData[6];
				const EighthQuestion = this.questionData[7];
				const NinthQuestion = this.questionData[8];
				const TenthQuestion = this.questionData[9];
				const EleventhQuestion = this.questionData[10];
				const TwelthQuestion = this.questionData[11];
				const ThirteenthQuestion = this.questionData[12];
				const FourteenthQuestion = this.questionData[13];
				const FifteenththQuestion = this.questionData[14];
				const SixteenthQuestion = this.questionData[15];

				this.firstQuestionText = firstQuestion.questionText;

				this.firstQuestionVersinId = firstQuestion.activeVersionId;

				this.secondQuestionText = secondQuestion.questionText;

				this.secondQuestionVersinId = secondQuestion.activeVersionId;

				this.thirdQuestionText = thirdQuestion.questionText;

				this.thirdQuestionVersinId = thirdQuestion.activeVersionId;

				this.fourthQuestionText = fourthQuestion.questionText;

				this.fourthQuestionVersinId = fourthQuestion.activeVersionId;

				this.fifthQuestionText = FifthQuestion.questionText;

				this.fifthQuestionVersinId = FifthQuestion.activeVersionId;

				this.sixthQuestionText = SixthQuestion.questionText;

				this.sixthQuestionVersinId = SixthQuestion.activeVersionId;

				this.seventhQuestionText = SeventhQuestion.questionText;

				this.seventhQuestionVersinId = SeventhQuestion.activeVersionId;

				this.eightQuestionText = EighthQuestion.questionText;

				this.eightQuestionVersinId = EighthQuestion.activeVersionId;

				this.ninthQuestionText = NinthQuestion.questionText;

				this.ninthQuestionVersinId = NinthQuestion.activeVersionId;

				this.tenthQuestionText = TenthQuestion.questionText;

				this.tenthQuestionVersinId = TenthQuestion.activeVersionId;

				this.eleventhQuestionText = EleventhQuestion.questionText;
				this.eleventhQuestionVersinId = EleventhQuestion.activeVersionId;

				this.twelthQuestionText = TwelthQuestion.questionText;

				this.twelthQuestionVersinId = TwelthQuestion.activeVersionId;

				this.thirteeenthQuestionText = ThirteenthQuestion.questionText;

				this.thirteeenthQuestionVersinId = ThirteenthQuestion.activeVersionId;

				this.foteenthQuestionText = FourteenthQuestion.questionText;

				this.foteenthQuestionVersinId = FourteenthQuestion.activeVersionId;

				this.fifteenthQuestionText = FifteenththQuestion.questionText;

				this.fifteenthQuestionVersinId = FifteenththQuestion.activeVersionId;
				this.sixteenthQuestionText = SixteenthQuestion.questionText;
				this.sixteenthQuestionVersinId = SixteenthQuestion.activeVersionId;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//below are the handlers that handles the resposnes from user input(16 hhandlers)
	handleFirstQuestionChange(event) {
		this.nameOfQuestion = event.target.name;
		const chekVal = event.target.value;
		if (chekVal === this.lessthanamonth) {
			this.IsfirstLessThanMonth = true;
		} else {
			this.IsfirstLessThanMonth = false;
		}

		if (chekVal === this.lessthan6months) {
			this.IsfirstLessSix = true;
		} else {
			this.IsfirstLessSix = false;
		}

		if (chekVal === this.lessthanyear) {
			this.IsfirstLessYear = true;
		} else {
			this.IsfirstLessYear = false;
		}

		if (chekVal === this.morethanyear) {
			this.IsfirstMoreYear = true;
		} else {
			this.IsfirstMoreYear = false;
		}

		if (this.nameOfQuestion === 'firstQuestionResponse') {
			this.firstQuestionResponse = event.target.value;
			this.nameToDraftFirst = event.target.name;

			if (this.firstQuestionResponse !== '') {
				//pushes the responses and version ids to arrays
				this.arrayForPushResp.push(this.firstQuestionResponse);
				this.arrayForPushId.push(this.firstQuestionVersinId);
			}
			this.firstRspValue = this.getLastRespValue();
			this.firstRespVersId = this.getLastIdValue();
		}
	}
	//getLastRespValue will extract the last input response of the user, its the same for remaining hanler
	getLastRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}
	//getLastIdValue will extract the last input response version  id of the user, its the same for remaining hanler
	getLastIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleSecondQuestionChange(event) {
		const checkedVal = event.target.value;
		if (checkedVal === this.male) {
			this.iSmale = true;
		} else {
			this.iSmale = false;
		}

		if (checkedVal === this.female) {
			this.iSfemale = true;
		} else {
			this.iSfemale = false;
		}

		if (checkedVal === this.other) {
			this.iSOther = true;
		} else {
			this.iSOther = false;
		}

		if (checkedVal === this.prefernot) {
			this.iSPrefferNottosay = true;
		} else {
			this.iSPrefferNottosay = false;
		}

		this.nameOfQuestion = event.target.name;

		if (this.nameOfQuestion === 'secondQuestionResponse') {
			this.secondQuestionResponse = event.target.value;
			this.nameToDraftSecond = event.target.name;
			if (this.secondQuestionResponse !== '') {
				this.arrayForPushResp.push(this.secondQuestionResponse);
				this.arrayForPushId.push(this.secondQuestionVersinId);
			}
			// Get the last response value
			this.secondRspValue = this.getSecondRespValue();
			// Get the last response version id
			this.secondRespVersId = this.getSecondIdValue();
		}
	}

	getSecondRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getSecondIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleEigthQuestionChange(event) {
		this.nameOfQuestion = event.target.name;

		const checkedVal = event.target.value;
		if (checkedVal === this.yes) {
			this.sixthRadYes = true;
		} else {
			this.sixthRadYes = false;
		}

		if (checkedVal === this.no) {
			this.sixthRadNo = true;
		} else {
			this.sixthRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.sixthRadMayBe = true;
		} else {
			this.sixthRadMayBe = false;
		}

		this.eightQuestionResponse = event.target.value;
		this.nameToDraftEighth = event.target.name;
		if (this.eightQuestionResponse !== '') {
			this.arrayForPushResp.push(this.eightQuestionResponse);
			this.arrayForPushId.push(this.eightQuestionVersinId);
		}
		// Get the last values separately
		this.eghtResponseValue = this.getEigthRespValue();
		this.eightVersiId = this.getEigthIdValue();
	}

	getEigthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getEigthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//this handler handles the user input
	handlethirdQuestionChange(event) {
		const checkedval = event.target.value;
		if (checkedval === this.yes) {
			this.thirdisyes = true;
		} else {
			this.thirdisyes = false;
		}

		if (checkedval === this.no) {
			this.thirdisno = true;
		} else {
			this.thirdisno = false;
		}

		this.nameOfQuestion = event.target.name;

		if (this.nameOfQuestion === 'thirdQuestionRespo') {
			this.thirdQuestionResponse = event.target.value;
			this.nameToDraftThird = event.target.name;
			if (this.thirdQuestionResponse !== '') {
				this.arrayForPushResp.push(this.thirdQuestionResponse);
				this.arrayForPushId.push(this.thirdQuestionVersinId);
			}
			// Get the last values separately
			this.thirdRspValue = this.getThirdRespValue();
			this.thirdVersionId = this.getThirdIdValue();
		}
	}

	getThirdRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getThirdIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//this handler handles the user input Response
	handleNinthQuestionChange(event) {
		const checkedVal = event.target.value;
		if (checkedVal === this.yes) {
			this.eleventhRadYes = true;
		} else {
			this.eleventhRadYes = false;
		}

		if (checkedVal === this.no) {
			this.eleventhRadNo = true;
		} else {
			this.eleventhRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.eleventhRadMaybe = true;
		} else {
			this.eleventhRadMaybe = false;
		}

		this.ninthQuestionResponse = event.target.value;
		this.nameToDraftNinth = event.target.name;
		if (this.ninthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.ninthQuestionResponse);
			this.arrayForPushId.push(this.ninthQuestionVersinId);
		}
		// Get the last values separately
		this.ninthResponseValue = this.getNinthRespValue();
		this.ninthVersId = this.getNinthIdValue();
	}

	getNinthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getNinthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleFifteenthQuestionChange(event) {
		const checkedVal = event.target.value;
		//the below if conditions checks the value if it is true then set the radion buttons as checked otherwise unchecked.
		if (checkedVal === this.yes) {
			this.thirteenththRadYes = true;
		} else {
			this.thirteenththRadYes = false;
		}

		if (checkedVal === this.no) {
			this.thirteenththRadNo = true;
		} else {
			this.thirteenththRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.thirteenththRadMaybe = true;
		} else {
			this.thirteenththRadMaybe = false;
		}

		this.fifteenthQuestionResponse = event.target.value;
		this.nameToDraftFifteenth = event.target.name;

		if (this.fifteenthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.fifteenthQuestionResponse);
			this.arrayForPushId.push(this.fifteenthQuestionVersinId);
		}

		// Get the last values separately
		this.fifteenthResponseValue = this.getFifteenthRespValue();
		this.fifteenthVersId = this.getFifteenthIdValue();
	}

	getFifteenthRespValue() {
		return this.checkBoxArray.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getFifteenthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleFourteenthQuestionChange(event) {
		const checkedVal = event.target.value;
		if (checkedVal === this.yes) {
			this.twelthRadYes = true;
		} else {
			this.twelthRadYes = false;
		}

		if (checkedVal === this.no) {
			this.twelthRadNo = true;
		} else {
			this.twelthRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.twelthRadMaybe = true;
		} else {
			this.twelthRadMaybe = false;
		}

		this.fourteenthQuestionResponse = event.target.value;
		this.nameToDraftFourteenth = event.target.name;

		if (this.fourteenthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.fourteenthQuestionResponse);
			this.arrayForPushId.push(this.foteenthQuestionVersinId);
		}
		// Get the last values separately
		this.fourteenthResponseValue = this.getFourteenthRespValue();
		this.fourteenthVersId = this.getFourteenthIdValue();
	}

	getFourteenthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getFourteenthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleThirteenthQuestionChange(event) {
		const checkedVal = event.target.value;
		if (checkedVal === this.yes) {
			this.seventhRadYes = true;
		} else {
			this.seventhRadYes = false;
		}

		if (checkedVal === this.no) {
			this.seventhRadNo = true;
		} else {
			this.seventhRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.seventhRadMaybe = true;
		} else {
			this.seventhRadMaybe = false;
		}

		this.thirteenthQuestionResponse = event.target.value;
		this.nameToDraftThirteenth = event.target.name;

		if (this.thirteenthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.thirteenthQuestionResponse);
			this.arrayForPushId.push(this.thirteeenthQuestionVersinId);
		}

		this.thirteenthResponseValue = this.getThirteenthRespValue();
		this.thirteenthVersiId = this.getThirteenthIdValue();
	}

	getThirteenthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getThirteenthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleTwelthQuestionChange(event) {
		const checkedVal = event.target.value;
		if (checkedVal === this.yes) {
			this.fourthRadYes = true;
		} else {
			this.fourthRadYes = false;
		}

		if (checkedVal === this.no) {
			this.fourthRadNo = true;
		} else {
			this.fourthRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.fourthRadMaybe = true;
		} else {
			this.fourthRadMaybe = false;
		}

		this.twelvthQuestionResponse = event.target.value;
		this.nameToDrafttwelvth = event.target.name;

		if (this.twelvthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.twelvthQuestionResponse);
			this.arrayForPushId.push(this.twelthQuestionVersinId);
		}

		this.twelvthRespalue = this.getTwelthRespValue();
		this.twelvthVersiD = this.getTwelthIdValue();
	}

	getTwelthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getTwelthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleEleventhQuestionChange(event) {
		const checkedVal = event.target.value;
		if (checkedVal === this.yes) {
			this.thirdRadYes = true;
		} else {
			this.thirdRadYes = false;
		}

		if (checkedVal === this.no) {
			this.thirdRadNo = true;
		} else {
			this.thirdRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.thirdRadMaybe = true;
		} else {
			this.thirdRadMaybe = false;
		}

		this.eleventhQuestionResponse = event.target.value;
		this.nameToDrafteEleventh = event.target.name;

		if (this.eleventhQuestionResponse !== '') {
			this.arrayForPushResp.push(this.eleventhQuestionResponse);
			this.arrayForPushId.push(this.eleventhQuestionVersinId);
		}
		// Get the last values separately
		this.eleventhResponseValue = this.getEleventhRespValue();
		this.eleventhVersiD = this.getEleventhIdValue();
	}

	getEleventhRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getEleventhIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleTenthQuestionChange(event) {
		const checkedVal = event.target.value;
		if (checkedVal === this.yes) {
			this.secondRadYes = true;
		} else {
			this.secondRadYes = false;
		}

		if (checkedVal === this.no) {
			this.secondRadNo = true;
		} else {
			this.secondRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.secondRadMaybe = true;
		} else {
			this.secondRadMaybe = false;
		}

		this.tenthQuestionResponse = event.target.value;
		this.nameToDrafttenth = event.target.name;
		if (this.tenthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.tenthQuestionResponse);
			this.arrayForPushId.push(this.tenthQuestionVersinId);
		}

		this.tenthResponseValue = this.getTenthRespValue();
		this.tenthVersId = this.getTenthIdValue();
	}

	getTenthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getTenthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleSeventhQuestionChange(event) {
		const checkedVal = event.target.value;
		if (checkedVal === this.yes) {
			this.aftersixthrades = true;
		} else {
			this.aftersixthrades = false;
		}

		if (checkedVal === this.no) {
			this.aftersixthRadNo = true;
		} else {
			this.aftersixthRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.aftersixthRadMaybe = true;
		} else {
			this.aftersixthRadMaybe = false;
		}
		this.seventhQuestionResponse = event.target.value;
		this.nameToDraftSeventh = event.target.name;

		if (this.seventhQuestionResponse !== '') {
			this.arrayForPushResp.push(this.seventhQuestionResponse);
			this.arrayForPushId.push(this.seventhQuestionVersinId);
		}

		this.seventhRespalue = this.getSeventhRespValue();
		this.seventhVersiD = this.getSeventhIdValue();
	}

	getSeventhRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getSeventhIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleSixthQuestionchange(event) {
		this.sixthDraftVal = this.sixthQResForEach;
		const checkBoval = event.target.checked;
		//this will check what are the check boxs that been checked
		if (checkBoval) {
			this.checkedboleaan = true;
			this.knowSixthChecked = checkBoval;

			const vals = event.target.value;
			//we will be using this array later to extract the checked values
			this.sixthCheckedArray.push(vals);

			//we are explicitly making the check boxes as checked.this is needed.
			if (vals === this.asthma) {
				this.tenthCheckAsthma = true;
			}

			if (vals === this.diabetes) {
				this.tenthCheckDiabetes = true;
			}

			if (vals === this.depression) {
				this.tenthCheckDepression = true;
			}

			if (vals === this.hayfever) {
				this.tenthCheckHayFever = true;
			}

			if (vals === this.hypertension) {
				this.tenthCheckBp = true;
			}

			if (vals === this.highcholestrol) {
				this.tenthCheckHighChol = true;
			}

			if (vals === this.obesityc) {
				this.tenthCheckObesity = true;
			}

			if (vals === this.osteoporosisc) {
				this.tenthCheckOsteo = true;
			}

			if (vals === this.ulcer) {
				this.tenthCheckPeptic = true;
			}

			if (vals === this.psoriasis) {
				this.tenthCheckplaque = true;
			}

			if (vals === this.psoriaticarthritis) {
				this.tenthCheckpsoriatic = true;
			}

			if (vals === this.others) {
				this.tenthCheckOthers = true;
			}
		} else {
			this.uncheckedBoolean = true;
			this.knowSixthChecked = checkBoval;
			this.uncheckVar = this.yes;
			this.sixthUncheckedVals = event.target.value;
			//We will be using this unchecked array later
			this.sixthUnchekedArray.push(this.sixthUncheckedVals);
			//we need to make the check boxes as uncheckd
			const jos = event.target.value;
			if (jos === this.asthma) {
				this.tenthCheckAsthma = false;
			}

			if (jos === this.diabetes) {
				this.tenthCheckDiabetes = false;
			}

			if (jos === this.depression) {
				this.tenthCheckDepression = false;
			}

			if (jos === this.hayfever) {
				this.tenthCheckHayFever = false;
			}

			if (jos === this.hypertension) {
				this.tenthCheckBp = false;
			}

			if (jos === this.highcholestrol) {
				this.tenthCheckHighChol = false;
			}

			if (jos === this.obesityc) {
				this.tenthCheckObesity = false;
			}

			if (jos === this.osteoporosisc) {
				this.tenthCheckOsteo = false;
			}

			if (jos === this.ulcer) {
				this.tenthCheckPeptic = false;
			}

			if (jos === this.psoriasis) {
				this.tenthCheckplaque = false;
			}

			if (jos === this.psoriaticarthritis) {
				this.tenthCheckpsoriatic = false;
			}

			if (jos === this.others) {
				this.tenthCheckOthers = false;
			}
		}

		this.sixthQuestionResponse = event.target.value;

		this.nameToDraftSixth = event.target.name;

		if (this.sixthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.sixthQuestionResponse);
			this.arrayForPushId.push(this.sixthQuestionVersinId);
			this.selectMedic.push(this.sixthQuestionResponse);
		}
		// Get the last values separately
		this.sixthResponseValue = this.getSixthRespValue();

		this.sixthVersiD = this.getSixthIdValue();

		if (typeof this.sixthQResForEach !== 'undefined' && this.filterArr === '') {
			const qResArray = this.sixthQResForEach.split(',');
			this.filteredArray = qResArray.filter((value) => value.trim() !== '');

			if (this.filteredArray && this.filteredArray.length > 0) {
				// Add elements of filteredArray to sixthCheckedArray
				this.sixthCheckedArray = [
					...this.sixthCheckedArray,
					...this.filteredArray
				];
			}
		}

		//we will be checking that  the sixth checked and unchecked array has the same count or not to make a decision on showing popup message later.
		const uniqueUnchekedArray = Array.from(new Set(this.sixthUnchekedArray));
		this.uniqueUncheckedCount = uniqueUnchekedArray.length;

		const uniqueCheckedArray = Array.from(new Set(this.sixthCheckedArray));

		this.uniqueCheckedCount = uniqueCheckedArray.length;

		if (this.uniqueUncheckedCount === this.uniqueCheckedCount) {
			this.isEqualLength = true;
		} else {
			this.isEqualLength = false;
		}
	}

	getSixthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getSixthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleSixteenthQuestionChange(event) {
		const checkedVal = event.target.value;
		if (checkedVal === this.yes) {
			this.forteenththRadYes = true;
		} else {
			this.forteenththRadYes = false;
		}

		if (checkedVal === this.no) {
			this.forteenthRadNo = true;
		} else {
			this.forteenthRadNo = false;
		}
		if (checkedVal === this.maybe) {
			this.forteenthRadMaybe = true;
		} else {
			this.forteenthRadMaybe = false;
		}

		this.sixteenthQuestionResponse = event.target.value;
		this.nameToDraftSixteenth = event.target.name;

		if (this.sixteenthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.sixteenthQuestionResponse);
			this.arrayForPushId.push(this.sixteenthQuestionVersinId);
		}

		this.sixteenthResponseValue = this.getSixteenthRespValue();
		this.sixteenthVersId = this.getSixteenthIdValue();
	}

	getSixteenthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getSixteenthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	deleteYesBasedRes() {
		this.sixthQResForEach = '';
		this.sixthQVersionResForEach = '';
	}

	handleFifthQuestionChange(event) {
		this.sixthQuestionVisible = event.target.value === this.yes;
		this.fifthQuestionresponse = event.target.value;
		this.nameToDraftFifth = event.target.name;
		if (this.fifthQuestionresponse !== '') {
			this.arrayForPushResp.push(this.fifthQuestionresponse);
			this.arrayForPushId.push(this.fifthQuestionVersinId);
		}

		this.fifthResonseValue = this.getFifthRespValue();

		this.fifthVersionId = this.getFifthIdValue();

		const val = event.target.value;
		//if the value of the fifth Question is yes then total number of question will be 16 otherwise 15.
		if (val === this.yes) {
			this.fifthRadYes = true;
			this.fifthRadNo = false;
			this.countquestion = 16;
			this.customClass='nds-form-element nds-form-containertwo';
		}

		if (val === this.no) {
			this.fifthRadNo = true;
			this.fifthRadYes = false;
			this.sixthQuestionVisible = false;
			this.customClass='nds-form-element nds-form-containerthree';
			this.deleteYesBasedRes();
			//if the response value is No then we will delete the repsones of sixth Questions and also make the checkboxes as unchecked.
			const fifthIdStore = this.storeid5;
			deleteSelectedResponse({ idOfRes: fifthIdStore })
				.then(() => {
					this.tenthCheckAsthma = false;
					this.tenthCheckDiabetes = false;
					this.tenthCheckDepression = false;
					this.tenthCheckHayFever = false;
					this.tenthCheckBp = false;
					this.tenthCheckHighChol = false;
					this.tenthCheckObesity = false;
					this.tenthCheckOsteo = false;
					this.tenthCheckPeptic = false;
					this.tenthCheckplaque = false;
					this.tenthCheckpsoriatic = false;
					this.tenthCheckOthers = false;

					this.sixthQResForEach = '';
					this.sixthQVersionResForEach = '';
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
				});

			this.countquestion = 15;
		}
	}

	getFifthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getFifthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	handleFourthQuestionChange(event) {
		this.checPrevoiusVal = this.fourQResForEach;

		const checkval = event.target.value;

		if (checkval === this.relationshipwithff) {
			this.fourthCheckRelatFam = true;
		}

		if (checkval === this.relationshipwithpartner) {
			this.fourthCheckWithPartner = true;
		}

		if (checkval === this.selfesteem) {
			this.fourthCheckSelfEsteem = true;
		}

		const checkBoval = event.target.checked;

		if (checkBoval) {
			this.fourthCheck = this.yes;
		} else {
			this.unCheckedResVal = event.target.value;
			this.uncheckedArray.push(this.unCheckedResVal);

			const unchVal = event.target.value;

			this.knowTheUnchecked = this.yes;
			if (unchVal === this.relationshipwithff) {
				this.fourthCheckRelatFam = false;
			}

			if (unchVal === this.relationshipwithpartner) {
				this.fourthCheckWithPartner = false;
			}

			if (unchVal === this.selfesteem) {
				this.fourthCheckSelfEsteem = false;
			}
		}

		this.fourthQuestionResponse = event.target.value;
		this.nameToDraftFourth = event.target.name;

		if (this.fourthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.fourthQuestionResponse);
			this.arrayForPushId.push(this.fourthQuestionVersinId);
			this.totalValu.push(this.fourthQuestionResponse);
		}

		this.fourthRspValue = this.getFourthRespValue();
		this.fourthVersionId = this.getFourthIdValue();
	}

	getFourthRespValue() {
		return this.arrayForPushResp.length > 0
			? this.arrayForPushResp[this.arrayForPushResp.length - 1]
			: null;
	}

	getFourthIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 1]
			: null;
	}

	//When clicked on Return back to Question buttton.This will close the popup and show you the page with all the previous response selection just before clicking the button.
	closePopup1() {
		if (this.isEqualLength === true) {
			this.sixthCheckedArray = [];

			this.sixthUnchekedArray = [];

			this.filteredArray = [];
			this.filterArr = 'true';
		}

		this.customFormModal = false;
		document.body.style.overflow = '';
		this.isPopupOpen1 = false;
		this.isPopupOpen1 = false;
		this.popupmenu = false;
		const fam = this.relationshipwithff;
		const partner = this.relationshipwithpartner;
		const selfEsteem = this.selfesteem;

		const asthmaVar = this.asthma;
		const duabetesVar = this.diabetes;
		const depressionVar = this.depression;
		const hayFever = this.hayfever;
		const highBp = this.hypertension;
		const highChol = this.highcholestrol;
		const Obesity = this.obesityc;
		const Osteoporosis = this.osteoporosisc;
		const peptic = this.ulcer;
		const plaque = this.psoriasis;
		const psoriasiArthritis = this.psoriaticarthritis;
		const Others = this.others;

		let firstValue, secondValue, thirdValue;

		for (let i = 0; i < Math.min(3, this.totalValu.length); i++) {
			if (i === 0) {
				firstValue = this.totalValu[i];
			} else if (i === 1) {
				secondValue = this.totalValu[i];
			} else if (i === 2) {
				thirdValue = this.totalValu[i];
			}
		}

		const concatenatedValues = [
			...new Set(
				[firstValue, secondValue, thirdValue].filter(
					(value) => value !== undefined
				)
			)
		].join(', ');

		let medicValues = [];

		for (let i = 0; i < Math.min(12, this.selectMedic.length); i++) {
			medicValues.push(this.selectMedic[i]);
		}

		const concatenatedMedicValues = [
			...new Set(medicValues.filter((value) => value !== undefined))
		].join(', ');

		if (this.knowTheUnchecked === '' && this.fourthCheck !== '') {
			if (concatenatedValues.includes(fam)) {
				this.fourthCheckRelatFam = true;
			}
			if (concatenatedValues.includes(partner)) {
				this.fourthCheckWithPartner = true;
			}
			if (concatenatedValues.includes(selfEsteem)) {
				this.fourthCheckSelfEsteem = true;
			}
		}

		if (this.knowTheUnchecked !== '' && this.fourthCheck === '') {
			if (concatenatedValues.includes(fam)) {
				this.fourthCheckRelatFam = false;
			}
			if (concatenatedValues.includes(partner)) {
				this.fourthCheckWithPartner = false;
			}
			if (concatenatedValues.includes(selfEsteem)) {
				this.fourthCheckSelfEsteem = false;
			}
		}

		if (this.fifthQuestionresponse === this.yes) {
			this.fifthRadYes = true;
		} else if (this.fifthQuestionresponse === this.no) {
			this.fifthRadNo = true;
		}

		if (this.secondQuestionResponse === this.male) {
			this.iSmale = true;
		} else if (this.secondQuestionResponse === this.female) {
			this.iSfemale = true;
		} else if (this.secondQuestionResponse === this.other) {
			this.iSOther = true;
		} else if (this.secondQuestionResponse === this.prefernot) {
			this.iSPrefferNottosay = true;
		}

		if (this.eightQuestionResponse === this.yes) {
			this.sixthRadYes = true;
		} else if (this.eightQuestionResponse === this.no) {
			this.sixthRadNo = true;
		} else if (this.eightQuestionResponse === this.maybe) {
			this.sixthRadMayBe = true;
		}

		if (this.sixteenthQuestionResponse === this.yes) {
			this.forteenththRadYes = true;
		} else if (this.sixteenthQuestionResponse === this.no) {
			this.forteenthRadNo = true;
		} else if (this.sixteenthQuestionResponse === this.maybe) {
			this.forteenthRadMaybe = true;
		}

		if (this.fifteenthQuestionResponse === this.yes) {
			this.thirteenththRadYes = true;
		} else if (this.fifteenthQuestionResponse === this.no) {
			this.thirteenththRadNo = true;
		} else if (this.fifteenthQuestionResponse === this.maybe) {
			this.thirteenththRadMaybe = true;
		}

		if (this.ninthQuestionResponse === this.yes) {
			this.eleventhRadYes = true;
		} else if (this.ninthQuestionResponse === this.no) {
			this.eleventhRadNo = true;
		} else if (this.ninthQuestionResponse === this.maybe) {
			this.eleventhRadMaybe = true;
		}
		if (this.tenthQuestionResponse === this.yes) {
			this.secondRadYes = true;
		} else if (this.tenthQuestionResponse === this.no) {
			this.secondRadNo = true;
		} else if (this.tenthQuestionResponse === this.maybe) {
			this.secondRadMaybe = true;
		}

		if (this.knowSixthChecked === true) {
			if (concatenatedMedicValues.includes(asthmaVar)) {
				this.tenthCheckAsthma = true;
			}
			if (concatenatedMedicValues.includes(duabetesVar)) {
				this.tenthCheckDiabetes = true;
			}
			if (concatenatedMedicValues.includes(depressionVar)) {
				this.tenthCheckDepression = true;
			}
			if (concatenatedMedicValues.includes(hayFever)) {
				this.tenthCheckHayFever = true;
			}
			if (concatenatedMedicValues.includes(highBp)) {
				this.tenthCheckBp = true;
			}
			if (concatenatedMedicValues.includes(highChol)) {
				this.tenthCheckHighChol = true;
			}
			if (concatenatedMedicValues.includes(Obesity)) {
				this.tenthCheckObesity = true;
			}
			if (concatenatedMedicValues.includes(Osteoporosis)) {
				this.tenthCheckOsteo = true;
			}
			if (concatenatedMedicValues.includes(peptic)) {
				this.tenthCheckPeptic = true;
			}
			if (concatenatedMedicValues.includes(plaque)) {
				this.tenthCheckplaque = true;
			}
			if (concatenatedMedicValues.includes(psoriasiArthritis)) {
				this.tenthCheckpsoriatic = true;
			}
			if (concatenatedMedicValues.includes(Others)) {
				this.tenthCheckOthers = true;
			}
		}

		if (this.knowSixthChecked === false) {
			if (concatenatedMedicValues.includes(asthmaVar)) {
				this.tenthCheckAsthma = false;
			}
			if (concatenatedMedicValues.includes(duabetesVar)) {
				this.tenthCheckDiabetes = false;
			}
			if (concatenatedMedicValues.includes(depressionVar)) {
				this.tenthCheckDepression = false;
			}
			if (concatenatedMedicValues.includes(hayFever)) {
				this.tenthCheckHayFever = false;
			}
			if (concatenatedMedicValues.includes(highBp)) {
				this.tenthCheckBp = false;
			}
			if (concatenatedMedicValues.includes(highChol)) {
				this.tenthCheckHighChol = false;
			}
			if (concatenatedMedicValues.includes(Obesity)) {
				this.tenthCheckObesity = false;
			}
			if (concatenatedMedicValues.includes(Osteoporosis)) {
				this.tenthCheckOsteo = false;
			}
			if (concatenatedMedicValues.includes(peptic)) {
				this.tenthCheckPeptic = false;
			}
			if (concatenatedMedicValues.includes(plaque)) {
				this.tenthCheckplaque = false;
			}
			if (concatenatedMedicValues.includes(psoriasiArthritis)) {
				this.tenthCheckpsoriatic = false;
			}
			if (concatenatedMedicValues.includes(Others)) {
				this.tenthCheckOthers = false;
			}
		}

		if (this.firstQuestionResponse === this.yes) {
			this.firstRadYes = true;
		} else if (this.firstQuestionResponse === this.maybe) {
			this.firstRadMaybe = true;
		} else if (this.firstQuestionResponse === this.no) {
			this.firstRadNo = true;
		}

		if (this.eleventhQuestionResponse === this.yes) {
			this.thirdRadYes = true;
		} else if (this.eleventhQuestionResponse === this.maybe) {
			this.thirdRadMaybe = true;
		} else if (this.eleventhQuestionResponse === this.no) {
			this.thirdRadNo = true;
		}

		if (this.secondQuestionResponse === this.yes) {
			this.secondRadYes = true;
		} else if (this.secondQuestionResponse === this.maybe) {
			this.secondRadMaybe = true;
		} else if (this.secondQuestionResponse === this.no) {
			this.secondRadNo = true;
		}
		///10
		if (this.thirdQuestionResponse === this.yes) {
			this.thirdisyes = true;
		} else if (this.thirdQuestionResponse === this.no) {
			this.thirdisno = true;
		}

		if (this.seventhQuestionResponse === this.yes) {
			this.aftersixthrades = true;
		} else if (this.seventhQuestionResponse === this.maybe) {
			this.aftersixthRadMaybe = true;
		} else if (this.seventhQuestionResponse === this.no) {
			this.aftersixthRadNo = true;
		}

		if (this.twelvthQuestionResponse === this.yes) {
			this.fourthRadYes = true;
		} else if (this.twelvthQuestionResponse === this.maybe) {
			this.fourthRadMaybe = true;
		} else if (this.twelvthQuestionResponse === this.no) {
			this.fourthRadNo = true;
		}

		if (this.thirteenthQuestionResponse === this.yes) {
			this.seventhRadYes = true;
		} else if (this.thirteenthQuestionResponse === this.maybe) {
			this.seventhRadMaybe = true;
		} else if (this.thirteenthQuestionResponse === this.no) {
			this.seventhRadNo = true;
		}

		if (this.fourteenthQuestionResponse === this.yes) {
			this.twelthRadYes = true;
		} else if (this.fourteenthQuestionResponse === this.maybe) {
			this.twelthRadMaybe = true;
		} else if (this.fourteenthQuestionResponse === this.no) {
			this.twelthRadNo = true;
		}
	}
	//When clicked on cancelbuttton.This will close the popup and show you the page with all the previous responses just before clicking the button.
	closePopup() {
		this.customFormModal = false;
		document.body.style.overflow = '';

		this.isPopupOpen = false;
		this.isPopupOpen1 = false;
		this.popupmenu = false;

		const fam = this.relationshipwithff;
		const partner = this.relationshipwithpartner;
		const selfEsteem = this.selfesteem;

		const asthmaVar = this.asthma;
		const duabetesVar = this.diabetes;
		const depressionVar = this.depression;
		const hayFever = this.hayfever;
		const highBp = this.hypertension;
		const highChol = this.highcholestrol;
		const Obesity = this.obesityc;
		const Osteoporosis = this.osteoporosisc;
		const peptic = this.ulcer;
		const plaque = this.psoriasis;
		const psoriasiArthritis = this.psoriaticarthritis;
		const Others = this.others;

		let firstValue, secondValue, thirdValue;

		for (let i = 0; i < Math.min(3, this.totalValu.length); i++) {
			if (i === 0) {
				firstValue = this.totalValu[i];
			} else if (i === 1) {
				secondValue = this.totalValu[i];
			} else if (i === 2) {
				thirdValue = this.totalValu[i];
			}
		}

		const concatenatedValues = [
			...new Set(
				[firstValue, secondValue, thirdValue].filter(
					(value) => value !== undefined
				)
			)
		].join(', ');

		let medicValues = [];

		for (let i = 0; i < Math.min(12, this.sixthCheckedArray.length); i++) {
			medicValues.push(this.sixthCheckedArray[i]);
		}

		const concatenatedMedicValues = [
			...new Set(medicValues.filter((value) => value !== undefined))
		].join(', ');

		let medicValuesUnchecked = [];

		for (let i = 0; i < Math.min(12, this.sixthUnchekedArray.length); i++) {
			medicValuesUnchecked.push(this.sixthUnchekedArray[i]);
		}

		const concatenatedMedicValuesUnchecekd = [
			...new Set(medicValuesUnchecked.filter((value) => value !== undefined))
		].join(', ');

		if (this.knowTheUnchecked === '' && this.fourthCheck !== '') {
			if (concatenatedValues.includes(fam)) {
				this.fourthCheckRelatFam = true;
			}
			if (concatenatedValues.includes(partner)) {
				this.fourthCheckWithPartner = true;
			}
			if (concatenatedValues.includes(selfEsteem)) {
				this.fourthCheckSelfEsteem = true;
			}
		}

		if (this.knowTheUnchecked !== '' && this.fourthCheck === '') {
			if (concatenatedValues.includes(fam)) {
				this.fourthCheckRelatFam = false;
			}
			if (concatenatedValues.includes(partner)) {
				this.fourthCheckWithPartner = false;
			}
			if (concatenatedValues.includes(selfEsteem)) {
				this.fourthCheckSelfEsteem = false;
			}
		}

		if (this.fifthQuestionresponse === this.yes) {
			this.fifthRadYes = true;
		} else if (this.fifthQuestionresponse === this.no) {
			this.fifthRadNo = true;
		}

		if (this.secondQuestionResponse === this.male) {
			this.iSmale = true;
		} else if (this.secondQuestionResponse === this.female) {
			this.iSfemale = true;
		} else if (this.secondQuestionResponse === this.other) {
			this.iSOther = true;
		} else if (this.secondQuestionResponse === this.prefernot) {
			this.iSPrefferNottosay = true;
		}

		if (this.eightQuestionResponse === this.yes) {
			this.sixthRadYes = true;
		} else if (this.eightQuestionResponse === this.no) {
			this.sixthRadNo = true;
		} else if (this.eightQuestionResponse === this.maybe) {
			this.sixthRadMayBe = true;
		}

		if (this.sixteenthQuestionResponse === this.yes) {
			this.forteenththRadYes = true;
		} else if (this.sixteenthQuestionResponse === this.no) {
			this.forteenthRadNo = true;
		} else if (this.sixteenthQuestionResponse === this.maybe) {
			this.forteenthRadMaybe = true;
		}

		if (this.fifteenthQuestionResponse === this.yes) {
			this.thirteenththRadYes = true;
		} else if (this.fifteenthQuestionResponse === this.no) {
			this.thirteenththRadNo = true;
		} else if (this.fifteenthQuestionResponse === this.maybe) {
			this.thirteenththRadMaybe = true;
		}

		if (this.ninthQuestionResponse === this.yes) {
			this.eleventhRadYes = true;
		} else if (this.ninthQuestionResponse === this.no) {
			this.eleventhRadNo = true;
		} else if (this.ninthQuestionResponse === this.maybe) {
			this.eleventhRadMaybe = true;
		}
		if (this.tenthQuestionResponse === this.yes) {
			this.secondRadYes = true;
		} else if (this.tenthQuestionResponse === this.no) {
			this.secondRadNo = true;
		} else if (this.tenthQuestionResponse === this.maybe) {
			this.secondRadMaybe = true;
		}

		if (this.checkedboleaan === true) {
			if (concatenatedMedicValues.includes(asthmaVar)) {
				this.tenthCheckAsthma = true;
			}
			if (concatenatedMedicValues.includes(duabetesVar)) {
				this.tenthCheckDiabetes = true;
			}
			if (concatenatedMedicValues.includes(depressionVar)) {
				this.tenthCheckDepression = true;
			}
			if (concatenatedMedicValues.includes(hayFever)) {
				this.tenthCheckHayFever = true;
			}
			if (concatenatedMedicValues.includes(highBp)) {
				this.tenthCheckBp = true;
			}
			if (concatenatedMedicValues.includes(highChol)) {
				this.tenthCheckHighChol = true;
			}
			if (concatenatedMedicValues.includes(Obesity)) {
				this.tenthCheckObesity = true;
			}
			if (concatenatedMedicValues.includes(Osteoporosis)) {
				this.tenthCheckOsteo = true;
			}
			if (concatenatedMedicValues.includes(peptic)) {
				this.tenthCheckPeptic = true;
			}
			if (concatenatedMedicValues.includes(plaque)) {
				this.tenthCheckplaque = true;
			}
			if (concatenatedMedicValues.includes(psoriasiArthritis)) {
				this.tenthCheckpsoriatic = true;
			}
			if (concatenatedMedicValues.includes(Others)) {
				this.tenthCheckOthers = true;
			}
		}

		if (this.uncheckedBoolean === true) {
			if (concatenatedMedicValuesUnchecekd.includes(asthmaVar)) {
				this.tenthCheckAsthma = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(duabetesVar)) {
				this.tenthCheckDiabetes = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(depressionVar)) {
				this.tenthCheckDepression = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(hayFever)) {
				this.tenthCheckHayFever = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(highBp)) {
				this.tenthCheckBp = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(highChol)) {
				this.tenthCheckHighChol = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(Obesity)) {
				this.tenthCheckObesity = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(Osteoporosis)) {
				this.tenthCheckOsteo = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(peptic)) {
				this.tenthCheckPeptic = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(plaque)) {
				this.tenthCheckplaque = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(psoriasiArthritis)) {
				this.tenthCheckpsoriatic = false;
			}
			if (concatenatedMedicValuesUnchecekd.includes(Others)) {
				this.tenthCheckOthers = false;
			}
		}

		if (this.firstQuestionResponse === this.yes) {
			this.firstRadYes = true;
		} else if (this.firstQuestionResponse === this.maybe) {
			this.firstRadMaybe = true;
		} else if (this.firstQuestionResponse === this.no) {
			this.firstRadNo = true;
		}

		if (this.eleventhQuestionResponse === this.yes) {
			this.thirdRadYes = true;
		} else if (this.eleventhQuestionResponse === this.maybe) {
			this.thirdRadMaybe = true;
		} else if (this.eleventhQuestionResponse === this.no) {
			this.thirdRadNo = true;
		}

		if (this.secondQuestionResponse === this.yes) {
			this.secondRadYes = true;
		} else if (this.secondQuestionResponse === this.maybe) {
			this.secondRadMaybe = true;
		} else if (this.secondQuestionResponse === this.no) {
			this.secondRadNo = true;
		}
		///10
		if (this.thirdQuestionResponse === this.yes) {
			this.thirdisyes = true;
		} else if (this.thirdQuestionResponse === this.no) {
			this.thirdisno = true;
		}

		if (this.seventhQuestionResponse === this.yes) {
			this.aftersixthrades = true;
		} else if (this.seventhQuestionResponse === this.maybe) {
			this.aftersixthRadMaybe = true;
		} else if (this.seventhQuestionResponse === this.no) {
			this.aftersixthRadNo = true;
		}

		if (this.twelvthQuestionResponse === this.yes) {
			this.fourthRadYes = true;
		} else if (this.twelvthQuestionResponse === this.maybe) {
			this.fourthRadMaybe = true;
		} else if (this.twelvthQuestionResponse === this.no) {
			this.fourthRadNo = true;
		}

		if (this.thirteenthQuestionResponse === this.yes) {
			this.seventhRadYes = true;
		} else if (this.thirteenthQuestionResponse === this.maybe) {
			this.seventhRadMaybe = true;
		} else if (this.thirteenthQuestionResponse === this.no) {
			this.seventhRadNo = true;
		}

		if (this.fourteenthQuestionResponse === this.yes) {
			this.twelthRadYes = true;
		} else if (this.fourteenthQuestionResponse === this.maybe) {
			this.twelthRadMaybe = true;
		} else if (this.fourteenthQuestionResponse === this.no) {
			this.twelthRadNo = true;
		}
	}

	//On click the PAGE will become static then it will show you the popup based on the criteria that gets matched.
	submitResponses() {
		if (this.isDesktop) {
			//this will make the page as static
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = '';
		}

		//below are if the conditions that checks if the draft responses are not null.if it is then assign a value to the name attribt of each handler.
		if (
			typeof this.firstQResForEach !== 'undefined' &&
			this.firstQResForEach !== ''
		) {
			this.nameToDraftFirst = 'firstRes';
		}
		if (
			typeof this.secQResForEach !== 'undefined' &&
			this.secQResForEach !== ''
		) {
			this.nameToDraftSecond = 'firstRes';
		}
		if (
			typeof this.thirdQResForEach !== 'undefined' &&
			this.thirdQResForEach !== ''
		) {
			this.nameToDraftThird = 'firstRes';
		}
		if (
			typeof this.fourQResForEach !== 'undefined' &&
			this.fourQResForEach !== ''
		) {
			this.nameToDraftFourth = 'firstRes';
		}
		if (
			typeof this.fifthQResForEach !== 'undefined' &&
			this.fifthQResForEach !== ''
		) {
			this.nameToDraftFifth = 'firstRes';
		}

		if (
			typeof this.sixthQResForEach !== 'undefined' &&
			this.sixthQResForEach !== ''
		) {
			this.nameToDraftSixth = 'emptied';
		}

		//the below if conditions will determine which pop up to show
		if (
			typeof this.nameToDraftSixth === 'undefined' &&
			typeof this.nameToDraftFirst === 'undefined' &&
			typeof this.nameToDraftSecond === 'undefined' &&
			typeof this.nameToDraftThird === 'undefined' &&
			typeof this.nameToDraftFifth === 'undefined'
		) {
			this.customFormModal = true;
			this.isPopupOpen1 = true;
			this.isPopupOpen = false;
			this.checkyesorno = false;
		}

		if (
			typeof this.nameToDraftSixth === 'undefined' &&
			typeof this.nameToDraftFirst !== 'undefined' &&
			typeof this.nameToDraftSecond !== 'undefined' &&
			typeof this.nameToDraftThird !== 'undefined' &&
			typeof this.nameToDraftFifth !== 'undefined'
		) {
			if (
				typeof this.fifthResonseValue === 'undefined' &&
				this.fifthQResForEach === this.no &&
				typeof this.sixthResponseValue === 'undefined' &&
				this.sixthQResForEach === ''
			) {
				this.customFormModal = true;
				this.isPopupOpen1 = false;
				this.isPopupOpen = true;
				this.checkyesorno = false;
			}
			if (
				this.fifthResonseValue === this.no &&
				(typeof this.sixthResponseValue === 'undefined' ||
					this.sixthResponseValue === '') &&
				(this.sixthQResForEach === '' ||
					typeof this.sixthQResForEach === 'undefined')
			) {
				this.customFormModal = true;
				this.isPopupOpen1 = false;
				this.isPopupOpen = true;
				this.checkyesorno = false;
			}

			if (
				this.fifthQResForEach === this.yes &&
				typeof this.sixthResponseValue === 'undefined' &&
				typeof this.sixthQResForEach === 'undefined'
			) {
				this.customFormModal = true;
				this.isPopupOpen1 = true;
				this.isPopupOpen = false;
				this.checkyesorno = false;
			}

			if (
				this.fifthResonseValue === this.yes &&
				(typeof this.sixthResponseValue === 'undefined' ||
					this.sixthResponseValue === '') &&
				(typeof this.sixthQResForEach === 'undefined' ||
					this.sixthQResForEach === '')
			) {
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

		if (
			typeof this.nameToDraftFirst !== 'undefined' &&
			typeof this.nameToDraftSecond !== 'undefined' &&
			typeof this.nameToDraftThird !== 'undefined' &&
			typeof this.nameToDraftFifth !== 'undefined' &&
			typeof this.nameToDraftSixth !== 'undefined'
		) {
			if (this.sixthQResForEach !== '') {
				if (
					(this.fifthResonseValue === this.yes ||
						this.fifthQResForEach === this.yes) &&
					this.isEqualLength === true
				) {
					this.customFormModal = true;

					this.isPopupOpen1 = true;
					this.isPopupOpen = false;
					this.checkyesorno = false;
				}

				if (
					this.fifthResonseValue === this.yes &&
					this.fifthQResForEach === this.no &&
					this.isEqualLength === false
				) {
					this.customFormModal = true;
					this.isPopupOpen1 = false;
					this.isPopupOpen = true;
					this.checkyesorno = false;
				}

				if (
					this.fifthQResForEach === this.yes &&
					this.isEqualLength === false
				) {
					this.customFormModal = true;
					this.isPopupOpen1 = false;
					this.isPopupOpen = true;
					this.checkyesorno = false;
				}

				if (this.fifthQResForEach === this.yes && this.isEqualLength === true) {
					this.customFormModal = true;
					this.isPopupOpen1 = true;
					this.isPopupOpen = false;
					this.checkyesorno = false;
				}
			}

			if (
				typeof this.sixthQResForEach === 'undefined' ||
				this.sixthQResForEach === ''
			) {
				if (
					(this.fifthResonseValue === this.yes ||
						this.fifthQResForEach === this.yes) &&
					typeof this.sixthResponseValue === 'undefined'
				) {
					this.customFormModal = true;

					this.isPopupOpen1 = false;
					this.isPopupOpen = true;
					this.checkyesorno = false;
				}

				if (
					this.fifthResonseValue === this.yes &&
					typeof this.sixthResponseValue !== 'undefined' &&
					this.isEqualLength === false
				) {
					this.customFormModal = true;

					this.isPopupOpen1 = false;
					this.isPopupOpen = true;
					this.checkyesorno = false;
				}

				if (
					(this.fifthResonseValue === this.yes ||
						this.fifthQResForEach === this.yes) &&
					this.isEqualLength === false &&
					this.knowSixthChecked === false
				) {
					this.customFormModal = true;
					this.isPopupOpen1 = false;
					this.isPopupOpen = true;
					this.checkyesorno = false;
				}

				if (
					this.fifthResonseValue === this.no &&
					(typeof this.sixthResponseValue === 'undefined' ||
						typeof this.sixthQResForEach === 'undefined' ||
						this.sixthQResForEach === '')
				) {
					this.customFormModal = true;
					this.isPopupOpen1 = false;
					this.isPopupOpen = true;
					this.checkyesorno = false;
				}
			}
		}
	}

	//hiding the popup
	get popuphide() {
		if (this.popupmenu === true) {
			return this.popupmenu === true ? 'disabled' : '';
		}
		return '';
	}

	//Navigation for second page
	navigationMethod() {
		window.location.assign(letsPersonlizeurl);
	}
	//on click of the confirm button the same process goes here for the same as in save as draft
	confirmSubmission() {
		this.checkinc = 0;

		let firstValue, secondValue, thirdValue;

		for (let i = 0; i < Math.min(3, this.totalValu.length); i++) {
			if (i === 0) {
				firstValue = this.totalValu[i];
			} else if (i === 1) {
				secondValue = this.totalValu[i];
			} else if (i === 2) {
				thirdValue = this.totalValu[i];
			}
		}

		const additionalValues = (this.checPrevoiusVal || '')
			.split(',')
			.map((value) => value.trim());

		const valuesToExclude = new Set(this.uncheckedArray);

		const concatenatedValues = [
			...new Set(
				[firstValue, secondValue, thirdValue, ...additionalValues].filter(
					(value) => value !== undefined && !valuesToExclude.has(value)
				)
			)
		].join(', ');

		this.fourthRspValue = '';

		this.fourthRspValue = concatenatedValues;

		let medicValues = [];

		for (let i = 0; i < Math.min(12, this.selectMedic.length); i++) {
			medicValues.push(this.selectMedic[i]);
		}

		const additionalValueses = (this.sixthDraftVal || '')
			.split(',')
			.map((value) => value.trim());

		medicValues = medicValues.concat(additionalValueses);

		const valuesToExcludeed = new Set(this.sixthUnchekedArray);

		const concatenatedMedicValues = [
			...new Set(
				medicValues.filter(
					(value) => value !== undefined && !valuesToExcludeed.has(value)
				)
			)
		].join(', ');

		this.sixthResponseValue = '';

		this.sixthResponseValue = concatenatedMedicValues;

		if (this.firstQuestionResponse === '' && this.firstQResForEach !== '') {
			this.realrespArray.push(this.firstQResForEach);
			this.realAssesVerArra.push(this.firstQVersionResForEach);
		} else {
			this.realrespArray.push(this.firstRspValue);
			this.realAssesVerArra.push(this.firstRespVersId);
		}

		if (this.secondQuestionResponse === '' && this.secQResForEach !== null) {
			this.realrespArray.push(this.secQResForEach);
			this.realAssesVerArra.push(this.secQVersionResForEach);
		} else {
			this.realrespArray.push(this.secondRspValue);
			this.realAssesVerArra.push(this.secondRespVersId);
		}

		if (this.thirdQuestionResponse === '' && this.thirdQResForEach !== '') {
			this.realrespArray.push(this.thirdQResForEach);
			this.realAssesVerArra.push(this.thirdQVersionResForEach);
		} else {
			this.realrespArray.push(this.thirdRspValue);
			this.realAssesVerArra.push(this.thirdVersionId);
		}

		if (this.fourthQuestionResponse === '' && this.fourQResForEach !== '') {
			this.realrespArray.push(this.fourQResForEach);
			this.realAssesVerArra.push(this.fourQVersionResForEach);
		} else {
			this.realrespArray.push(this.fourthRspValue);
			if (this.fourthRspValue === '') {
				this.fourthVersionId = '';

				this.realAssesVerArra.push(this.fourthVersionId);

				const dsds = this.idoFfORU;

				deleteSelectedResponse({ idOfRes: dsds })
					.then(() => {
						this.fourthCheckRelatFam = false;
						this.fourthCheckWithPartner = false;
						this.fourthCheckSelfEsteem = false;
					})
					.catch((error) => {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
					});
			}
			this.realAssesVerArra.push(this.fourthVersionId);
		}

		if (this.fifthQuestionresponse === '' && this.fifthQResForEach !== '') {
			this.realrespArray.push(this.fifthQResForEach);
			this.realAssesVerArra.push(this.fifthQVersionResForEach);
		} else {
			this.realrespArray.push(this.fifthResonseValue);
			this.realAssesVerArra.push(this.fifthVersionId);
		}
		if (this.sixthQuestionResponse === '' && this.sixthQResForEach !== '') {
			this.realrespArray.push(this.sixthQResForEach);

			this.realAssesVerArra.push(this.sixthQVersionResForEach);
		} else {
			this.realrespArray.push(this.sixthResponseValue);
			if (this.sixthResponseValue === '') {
				this.sixthVersiD = '';
				this.realAssesVerArra.push(this.sixthVersiD);

				const fifthIdStore = this.storeid5;
				deleteSelectedResponse({ idOfRes: fifthIdStore })
					.then(() => {
						this.tenthCheckAsthma = false;
						this.tenthCheckDiabetes = false;
						this.tenthCheckDepression = false;
						this.tenthCheckHayFever = false;
						this.tenthCheckBp = false;
						this.tenthCheckHighChol = false;
						this.tenthCheckObesity = false;
						this.tenthCheckOsteo = false;
						this.tenthCheckPeptic = false;
						this.tenthCheckplaque = false;
						this.tenthCheckpsoriatic = false;
						this.tenthCheckOthers = false;

						this.sixthQResForEach = '';
						this.sixthQVersionResForEach = '';
					})
					.catch((error) => {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
					});
			}
			this.realAssesVerArra.push(this.sixthVersiD);
		}

		const nonEmptyResponses = this.realrespArray.filter(
			(response) => response !== ''
		);
		const nonEmptyIds = this.realAssesVerArra.filter((id) => id !== '');

		const de = this.checkinc;

		if (this.realrespArray.length > 0) {
			submitAssessmentResponse({
				darftQuestionIds: nonEmptyIds,
				draftResponseTexts: nonEmptyResponses,
				InprogressOrCompelete: de
			})
				.then(() => {
					//naviagtion to other questionnaire based on avaliable Outatsnding Questionnaires.
					window.location.assign(letsPersonlizeurl);
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
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