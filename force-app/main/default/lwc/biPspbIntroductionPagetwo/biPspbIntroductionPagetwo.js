// This introductory questionnaire allows you to provide information about yourself
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//  To import Apex Classes
import introductionQuestionare from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.getIntroductionAsQuesLastTen';
import patientstatusreturns from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.patientstatusreturn';
import draftResponseSubmition from '@salesforce/apex/BI_PSP_LetsPersonlise.mulitipleDraftRecordsInsertion';
import draftResponseOfIntroduction from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.draftResponseOfIntroduction';
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
import BI_PSP_meandgpp from '@salesforce/label/c.BI_PSP_meandgpp';
import BI_PSP_skip from '@salesforce/label/c.BI_PSP_skip';
import BI_PSP_next from '@salesforce/label/c.BI_PSP_next';
import BI_PSP_CompleteAll from '@salesforce/label/c.BI_PSP_CompleteAll';
import submitmessage from '@salesforce/label/c.BI_PSP_submittext';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import BI_PSP_Others from '@salesforce/label/c.BI_PSP_Others';
import BI_PSPB_UnassignedSiteURL from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import BI_PSPB_AcuteDashboard from '@salesforce/label/c.BI_PSPB_AcuteDashboard';
import BI_PSPB_BrandedSiteURL from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import BI_PSPB_Dashboad from '@salesforce/label/c.BI_PSPB_Dashboad';
import BI_PSP_Unassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import BI_PSPB_Acute from '@salesforce/label/c.BI_PSPB_Acute';
// To import current user ID
import Id from '@salesforce/user/Id';
export default class BiPspbIntroductionPagetwo extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track resultunassigned = '';
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
	@track numberOfResponses;
	@track checkyesorno = false;

	@track totalValu = [];
	@track selectMedic = [];
	@track draftResponses = [];

	@track checkBoxArray;

	@track records = [];

	@track savedArrayForPushResp = [];
	@track concatenatedValues;

	@track showSixteenthQuestion = false;
	@track isConfirmationDialogOpen = false;
	@track customFormModal = false;
	@track isPopupOpen = false;
	@track isPopupOpen1 = false;

	@track selectedValues = [];
	// Declaration of Global variables
	checkinc;
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
	userid = Id;
	answerquestion;
	acuteDashboard = BI_PSPB_AcuteDashboard;
	dashBoard = BI_PSPB_Dashboad;
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
	brandedSite = BI_PSPB_BrandedSiteURL;
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
	others = BI_PSP_Others;
	doyouagree = BI_PSP_doyouagree;
	maybe = BI_PSP_maybe;
	unAssignedSite = BI_PSP_Unassigned;
	meandgpp = BI_PSP_meandgpp;
	next = BI_PSP_next;
	skip = BI_PSP_skip;
	acute = BI_PSPB_Acute;
	answered = BI_PSP_answered;
	submit = BI_PSP_submit;
	saveasdraft = BI_PSP_saveasdraft;
	outstandingque = BI_PSP_outstandingquestionnaire;
	returnbackc = BI_PSP_returnback;

	confirmsub = BI_PSP_confirm_submission;
	cannotedit = BI_PSP_cannotbeedited;
	cancelbt = BI_PSP_cancel;
	confirmbt = BI_PSP_confirm;
	unAssigned = BI_PSPB_UnassignedSiteURL;
	checPrevoiusVal;
	unCheckedResVal;
	uncheckedArray = [];
	fifthWithoudNewVals;


	sixthDraftVal;
	sixthUncheckedVals;
	sixthUnchekedArray = [];

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
	message = BI_PSP_CompleteAll;
	content1 = submitmessage;


	//To get the viewpoint
	connectedCallback() {
		try {
			this.isDesktop = this.isDesktopView();
			window.addEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from LWC
		}
	}
	disconnectedCallback() {

		window.removeEventListener('resize', this.handleResize.bind(this));

	}

	handleResize() {
		this.isDesktop = this.isDesktopView();
	}

	isDesktopView() {
		const viewportWidth = window.innerWidth;
		// Adjust this threshold based on your design's breakpoints
		return viewportWidth >= 1024 || viewportWidth <= 400; // Example breakpoints at 1024 pixels and 400 pixels
	}



	//popup css
	get popupClass() {
		return this.isPopupOpen ? 'popup-container' : 'popup-container hidden';
	}


	//close popup css call
	get popupClass1() {
		return this.isPopupOpen1 ? 'popup2-container' : 'popup2-container hidden';
	}

	customHideModalPopup() {
		this.isPopupOpen = false;
		this.isPopupOpen1 = false;
		this.customFormModal = false;
	}

	//To get Response for current user
	@wire(draftResponseOfIntroduction)
	wiredDraftResponses({ error, data }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				this.records = data;

				this.cong();
				this.answerquestion = this.records.length;
			} else if (error) {
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//ordering the Response
	cong() {
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

		//submitting the response
		this.records.forEach((record) => {
			if (record.BI_PSP_ResponseOrder__c === 2) {
				if (
					record.ResponseValue === targetFemale &&
					record.AssessmentQuestion.Id !== null
				) {
					this.secQResForEach = record.ResponseValue;

					this.secQVersionResForEach = record.AssessmentQuestion.Id;

					// Perform your logic here
					this.iSfemale = true;

					// Additional logic goes here...
				}

				if (
					record.ResponseValue === targetMale &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.iSmale = true;
					this.secQResForEach = record.ResponseValue;
					this.secQVersionResForEach = record.AssessmentQuestion.Id;

					// Additional logic goes here...
				}
				if (
					record.ResponseValue === targetOther &&
					record.AssessmentQuestion.Id !== null
				) {
					this.secQResForEach = record.ResponseValue;

					this.secQVersionResForEach = record.AssessmentQuestion.Id;

					// Perform your logic here
					this.iSOther = true;

					// Additional logic goes here...
				}
				if (
					record.ResponseValue === prefferNotTosay &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
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
					// Perform your logic here
					this.firstQResForEach = record.ResponseValue;

					this.firstQVersionResForEach = record.AssessmentQuestion.Id;
					this.IsfirstLessThanMonth = true;
				}

				if (
					record.ResponseValue === firstLessThanSix &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here

					this.firstQResForEach = record.ResponseValue;

					this.firstQVersionResForEach = record.AssessmentQuestion.Id;
					this.IsfirstLessSix = true;

					// Additional logic goes here...
				}

				if (
					record.ResponseValue === firstLessThanYr &&
					record.AssessmentQuestion.Id !== null
				) {
					this.firstQResForEach = record.ResponseValue;

					this.firstQVersionResForEach = record.AssessmentQuestion.Id;
					// Perform your logic here
					this.IsfirstLessYear = true;
				}

				if (
					record.ResponseValue === firstMoreThan &&
					record.AssessmentQuestion.Id !== null
				) {
					this.firstQResForEach = record.ResponseValue;

					this.firstQVersionResForEach = record.AssessmentQuestion.Id;
					// Perform your logic here
					this.IsfirstMoreYear = true;
				}
				//second ends here
			}

			if (record.BI_PSP_ResponseOrder__c === 4) {
				if (
					record.ResponseValue.includes(thirdAnswerRF) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fourthCheckRelatFam = true;
					this.fourQResForEach = record.ResponseValue; //fourQResForEach POINS oUT THE ACTUTAL QUEST NUMBER

					this.fourQVersionResForEach = record.AssessmentQuestion.Id;

					// Additional logic goes here...
				}

				if (
					record.ResponseValue.includes(thirdRWP) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fourthCheckWithPartner = true;
					this.fourQResForEach = record.ResponseValue; //fourQResForEach POINS oUT THE ACTUTAL QUEST NUMBER

					this.fourQVersionResForEach = record.AssessmentQuestion.Id;
				}

				if (
					record.ResponseValue.includes(thirdSelEstee) &&
					record.AssessmentQuestion.Id !== null
				) {
					this.fourthCheckSelfEsteem = true;
					this.fourQResForEach = record.ResponseValue; //fourQResForEach POINS oUT THE ACTUTAL QUEST NUMBER

					this.fourQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			//fifth Stads here
			if (record.BI_PSP_ResponseOrder__c === 6) {
				if (
					record.ResponseValue.includes(asthmaVar) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckAsthma = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
					// Additional logic goes here...
				}
				if (
					record.ResponseValue.includes(duabetesVar) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckDiabetes = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;

					// Additional logic goes here...
				}
				if (
					record.ResponseValue.includes(depressionVar) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckDepression = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;

					// Additional logic goes here...
				}
				if (
					record.ResponseValue.includes(hayFever) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckHayFever = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(highBp) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckBp = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(highChol) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckHighChol = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(Obesity) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckObesity = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(Osteoporosis) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckOsteo = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(peptic) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckPeptic = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(plaque) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckplaque = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(psoriasiArthritis) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckpsoriatic = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue.includes(Others) &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.tenthCheckOthers = true;
					this.sixthQResForEach = record.ResponseValue;
					this.sixthQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}

			if (record.BI_PSP_ResponseOrder__c === 3) {
				////sixth starts here
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
					// Perform your logic here
					this.thirdQResForEach = record.ResponseValue;
					this.thirdQVersionResForEach = record.AssessmentQuestion.Id;
					this.thirdisno = true;
				}
			}

			//seventh ends here
			if (record.BI_PSP_ResponseOrder__c === 5) {
				if (
					record.ResponseValue === seventhYes &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.fifthQResForEach = record.ResponseValue;
					this.fifthQVersionResForEach = record.AssessmentQuestion.Id;
					this.fifthRadYes = true;
					this.sixthQuestionVisible = this.fifthQResForEach === this.yes;

					// Additional logic goes here...
				}
				if (
					record.ResponseValue === seventhNo &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.fifthRadNo = true;
					this.fifthQResForEach = record.ResponseValue;
					this.fifthQVersionResForEach = record.AssessmentQuestion.Id;
					// Additional logic goes here...
				}
			}

			////sixth starts here

			//seventh ends here

			if (record.BI_PSP_ResponseOrder__c === 7) {
				//eight starts here I completely understand my generalized 7
				if (
					record.ResponseValue === eigthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.sevenQResForEach = record.ResponseValue;
					if (this.sevenQResForEach !== null) {
						this.aftersixthrades = true;
					}

					this.sevenQVersionResForEach = record.AssessmentQuestion.Id;

					// Additional logic goes here...
				}
				if (
					record.ResponseValue === eigthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.sevenQResForEach = record.ResponseValue;
					this.sevenQVersionResForEach = record.AssessmentQuestion.Id;

					this.aftersixthRadNo = true;

					// Additional logic goes here...
				}
				if (
					record.ResponseValue === eigthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					this.sevenQResForEach = record.ResponseValue;
					this.sevenQVersionResForEach = record.AssessmentQuestion.Id;

					this.aftersixthRadMaybe = true;
				}
				//eigth ends here
			}

			if (record.BI_PSP_ResponseOrder__c === 9) {
				if (
					record.ResponseValue === tenthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.nineQResForEach = record.ResponseValue;
					this.nineQVersionResForEach = record.AssessmentQuestion.Id;

					// Perform your logic here
					this.eleventhRadYes = true;
				}
				if (
					record.ResponseValue === tenthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
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
					// Perform your logic here
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
					// Perform your logic here
					this.sixthRadYes = true;
				}
				if (
					record.ResponseValue === ninthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
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
					// Perform your logic here
					this.sixthRadMayBe = true;
				}
			}
			//ninth starts here  8

			if (record.BI_PSP_ResponseOrder__c === 10) {
				//eleventh starts here 10
				if (
					record.ResponseValue === eleventhYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.tenthQResForEach = record.ResponseValue;
					this.tenthQVersionResForEach = record.AssessmentQuestion.Id;
					// Perform your logic here
					this.secondRadYes = true;

					// Additional logic goes here...
				}
				if (
					record.ResponseValue === eleventhNo &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.secondRadNo = true;
					this.tenthQResForEach = record.ResponseValue;
				}
				if (
					record.ResponseValue === eleventhMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.secondRadMaybe = true;
					this.tenthQResForEach = record.ResponseValue;
					this.tenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				//eleventh ends here
			}

			if (record.BI_PSP_ResponseOrder__c === 11) {
				//  11
				if (
					record.ResponseValue === twelthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.eleventhQResForEach = record.ResponseValue;
					this.eleventhQVersionResForEach = record.AssessmentQuestion.Id;
					// Perform your logic here
					this.thirdRadYes = true;
				}
				if (
					record.ResponseValue === twelthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.thirdRadNo = true;
					this.eleventhQResForEach = record.ResponseValue;
					this.eleventhQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === twelthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.thirdRadMaybe = true;
					this.eleventhQResForEach = record.ResponseValue;
					this.eleventhQVersionResForEach = record.AssessmentQuestion.Id;
				}
				//twelth ends here
			}

			if (record.BI_PSP_ResponseOrder__c === 12) {
				//12
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
					// Perform your logic here
					this.fourthRadNo = true;
					this.twelthQResForEach = record.ResponseValue;
					this.twelthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === thirteenthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.fourthRadMaybe = true;
					this.twelthQResForEach = record.ResponseValue;
					this.twelthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				//thirteenth ends here
			}

			if (record.BI_PSP_ResponseOrder__c === 13) {
				//fourteenth starts here 13
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
					// Perform your logic here
					this.seventhRadNo = true;
					this.thirteenthQResForEach = record.ResponseValue;
					this.thirteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === fourteenthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.seventhRadMaybe = true;
					this.thirteenthQResForEach = record.ResponseValue;
					this.thirteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				//fourteenth ends here
			}

			if (record.BI_PSP_ResponseOrder__c === 14) {
				//fifteenth starts here 14
				if (
					record.ResponseValue === fifteenthYes &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.fourteenthQResForEach = record.ResponseValue;
					this.fourteenthQVersionResForEach = record.AssessmentQuestion.Id;
					this.twelthRadYes = true;
				}
				if (
					record.ResponseValue === fifteenthNo &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.twelthRadNo = true;
					this.fourteenthQResForEach = record.ResponseValue;
					this.fourteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === fifteenthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.twelthRadMaybe = true;
					this.fourteenthQResForEach = record.ResponseValue;
					this.fourteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				//fifteenth ends here
			}

			if (record.BI_PSP_ResponseOrder__c === 15) {
				//sixteenth starts here 15
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
					// Perform your logic here
					this.thirteenththRadNo = true;
					this.fifteenthQResForEach = record.ResponseValue;
					this.fifteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === sixteenthMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.thirteenththRadMaybe = true;
					this.fifteenthQResForEach = record.ResponseValue;
					this.fifteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				//sixteenth ends here
			}

			if (record.BI_PSP_ResponseOrder__c === 16) {
				//16
				if (
					record.ResponseValue === seventeethYes &&
					record.AssessmentQuestion.Id !== null
				) {
					this.sixteenthQResForEach = record.ResponseValue;
					this.sixteenthQVersionResForEach = record.AssessmentQuestion.Id;
					// Perform your logic here
					this.forteenththRadYes = true;
				}
				if (
					record.ResponseValue === seventeethNo &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.forteenthRadNo = true;
					this.sixteenthQResForEach = record.ResponseValue;
					this.sixteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
				if (
					record.ResponseValue === seventeethMaybe &&
					record.AssessmentQuestion.Id !== null
				) {
					// Perform your logic here
					this.forteenthRadMaybe = true;
					this.sixteenthQResForEach = record.ResponseValue;
					this.sixteenthQVersionResForEach = record.AssessmentQuestion.Id;
				}
			}
		});
	}

	//To get the Introduction Questionnaire

	@wire(introductionQuestionare)
	wiredAssessmentQuestion({ error, data }) {
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
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//Getting response from event
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
				this.arrayForPushResp.push(this.firstQuestionResponse);
				this.arrayForPushId.push(this.firstQuestionVersinId);
			}
			// Get the last values separately
			this.firstRspValue = this.getLastRespValue();
			this.firstRespVersId = this.getLastIdValue();
		}
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

	//Getting response from event
	handleSecondQuestionChange(event) {
		this.nameOfQuestion = event.target.name;

		if (this.nameOfQuestion === 'secondQuestionResponse') {
			this.secondQuestionResponse = event.target.value;
			this.nameToDraftSecond = event.target.name;

			if (this.secondQuestionResponse !== '') {
				this.arrayForPushResp.push(this.secondQuestionResponse);
				this.arrayForPushId.push(this.secondQuestionVersinId);
			}
			// Get the last values separately
			this.secondRspValue = this.getSecondRespValue();
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

	//Getting response from event
	handleEigthQuestionChange(event) {
		this.nameOfQuestion = event.target.name;

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

	//Getting response from event
	handlethirdQuestionChange(event) {
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
			? this.arrayForPushResp[this.arrayForPushResp.length - 0]
			: null;
	}

	getThirdIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 0]
			: null;
	}

	//Getting response from event

	handleNinthQuestionChange(event) {
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

	//Getting response from event

	handleFifteenthQuestionChange(event) {
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

	//Getting response from event
	handleFourteenthQuestionChange(event) {
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

	//Getting response from event
	handleThirteenthQuestionChange(event) {
		this.thirteenthQuestionResponse = event.target.value;
		this.nameToDraftThirteenth = event.target.name;

		if (this.thirteenthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.thirteenthQuestionResponse);
			this.arrayForPushId.push(this.thirteeenthQuestionVersinId);
		}
		// Get the last values separately
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
		this.twelvthQuestionResponse = event.target.value;
		this.nameToDrafttwelvth = event.target.name;

		if (this.twelvthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.twelvthQuestionResponse);
			this.arrayForPushId.push(this.twelthQuestionVersinId);
		}
		// Get the last values separately
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

	//Getting response from event
	handleEleventhQuestionChange(event) {
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
			? this.arrayForPushResp[this.arrayForPushResp.length - 0]
			: null;
	}

	getEleventhIdValue() {
		return this.arrayForPushId.length > 0
			? this.arrayForPushId[this.arrayForPushId.length - 0]
			: null;
	}

	//Getting response from event
	handleTenthQuestionChange(event) {
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

	//Getting response from event
	handleSeventhQuestionChange(event) {
		this.seventhQuestionResponse = event.target.value;
		this.nameToDraftSeventh = event.target.name;
		if (this.seventhQuestionResponse !== '') {
			this.arrayForPushResp.push(this.seventhQuestionResponse);
			this.arrayForPushId.push(this.seventhQuestionVersinId);
		}
		// Get the last values separately
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

	//Getting response from event
	handleSixthQuestionchange(event) {
		this.sixthDraftVal = this.sixthQResForEach;

		const checkBoval = event.target.checked;
		if (!checkBoval) {
			this.sixthUncheckedVals = event.target.value;
			this.sixthUnchekedArray.push(this.sixthUncheckedVals);
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

	//Getting response from event
	handleSixteenthQuestionChange(event) {
		this.sixteenthQuestionResponse = event.target.value;
		this.nameToDraftSixteenth = event.target.name;

		if (this.sixteenthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.sixteenthQuestionResponse);
			this.arrayForPushId.push(this.sixteenthQuestionVersinId);
		}
		// Get the last values separately
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
		this.sixthQuestionResponse = '';
		this.sixthQResForEach = '';
		this.sixthQVersionResForEach = '';
		this.sixthResponseValue = '';
		this.sixthVersiD = '';
		this.selectMedic = '';
		this.sixthUnchekedArray = '';
	}

	handleFifthQuestionChange(event) {
		if (event.target.checked) {
			this.closePopup();
			const val = event.target.value;
			if (val === this.yes) {
				this.fifthRadYes = true;
				this.fifthRadNo = false;
				this.countquestion = 16;
			}

			if (val === this.no) {
				this.fifthRadNo = true;
				this.fifthRadYes = false;
				this.sixthQuestionVisible = false;
				this.deleteYesBasedRes();
				this.countquestion = 15;
			}
		}
		this.sixthQuestionVisible = event.target.value === this.yes;

		this.fifthQuestionresponse = event.target.value;
		this.nameToDraftFifth = event.target.name;

		if (this.fifthQuestionresponse !== '') {
			this.arrayForPushResp.push(this.fifthQuestionresponse);
			this.arrayForPushId.push(this.fifthQuestionVersinId);
		}
		// Get the last values separately
		this.fifthResonseValue = this.getFifthRespValue();
		this.fifthVersionId = this.getFifthIdValue();
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

		const checkBoval = event.target.checked;
		if (!checkBoval) {
			this.unCheckedResVal = event.target.value;
			this.uncheckedArray.push(this.unCheckedResVal);
		}
		this.fourthQuestionResponse = event.target.value;
		this.nameToDraftFourth = event.target.name;

		if (this.fourthQuestionResponse !== '') {
			this.arrayForPushResp.push(this.fourthQuestionResponse);
			this.arrayForPushId.push(this.fourthQuestionVersinId);
			this.totalValu.push(this.fourthQuestionResponse);
		}
		// Get the last values separately
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


	//close up methods
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
			if (
				concatenatedMedicValues.includes(highBp)
			) {
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
			if (
				concatenatedMedicValues.includes(highBp)
			) {
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
			if (
				concatenatedMedicValues.includes(highBp)
			) {
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
			if (
				concatenatedMedicValuesUnchecekd.includes(
					hayFever
				)
			) {
				this.tenthCheckHayFever = false;
			}
			if (
				concatenatedMedicValuesUnchecekd.includes(
					highBp
				)
			) {
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
			if (
				concatenatedMedicValuesUnchecekd.includes(
					peptic
				)
			) {
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
	//To submit reponse of all stored
	submitResponses() {
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = ''; // Reset to default
		}

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
			this.nameToDraftSixth = 'firstRes';
		}
		if (
			typeof this.sevenQResForEach !== 'undefined' &&
			this.sevenQResForEach !== ''
		) {
			this.nameToDraftSeventh = 'firstRes';
		}
		if (
			typeof this.eigthQResForEach !== 'undefined' &&
			this.eigthQResForEach !== ''
		) {
			this.nameToDraftEighth = 'firstRes';
		}
		if (
			typeof this.nineQResForEach !== 'undefined' &&
			this.nineQResForEach !== ''
		) {
			this.nameToDraftNinth = 'firstRes';
		}
		if (
			typeof this.tenthQResForEach !== 'undefined' &&
			this.tenthQResForEach !== ''
		) {
			this.nameToDrafttenth = 'firstRes';
		}
		if (
			typeof this.eleventhQResForEach !== 'undefined' &&
			this.eleventhQResForEach !== ''
		) {
			this.nameToDrafteEleventh = 'firstRes';
		}
		if (
			typeof this.twelthQResForEach !== 'undefined' &&
			this.twelthQResForEach !== ''
		) {
			this.nameToDrafttwelvth = 'firstRes';
		}
		if (
			typeof this.thirteenthQResForEach !== 'undefined' &&
			this.thirteenthQResForEach !== ''
		) {
			this.nameToDraftThirteenth = 'firstRes';
		}
		if (
			typeof this.fourteenthQResForEach !== 'undefined' &&
			this.fourteenthQResForEach !== ''
		) {
			this.nameToDraftFourteenth = 'firstRes';
		}
		if (
			typeof this.fifteenthQResForEach !== 'undefined' &&
			this.fifteenthQResForEach !== ''
		) {
			this.nameToDraftFifteenth = 'firstRes';
		}
		if (
			typeof this.sixteenthQResForEach !== 'undefined' &&
			this.sixteenthQResForEach !== ''
		) {
			this.nameToDraftSixteenth = 'firstRes';
		}

		if (
			typeof this.nameToDraftSeventh !== 'undefined' &&
			typeof this.nameToDraftEighth !== 'undefined' &&
			typeof this.nameToDraftNinth !== 'undefined' &&
			typeof this.nameToDrafttenth !== 'undefined' &&
			typeof this.nameToDrafteEleventh !== 'undefined' &&
			typeof this.nameToDrafttwelvth !== 'undefined' &&
			typeof this.nameToDraftThirteenth !== 'undefined' &&
			typeof this.nameToDraftFourteenth !== 'undefined' &&
			typeof this.nameToDraftFifteenth !== 'undefined' &&
			typeof this.nameToDraftSixteenth !== 'undefined'
		) {
			this.isPopupOpen = true;
		} else {
			this.customFormModal = true;
			this.isPopupOpen1 = true;
			this.isPopupOpen = false;
			this.checkyesorno = false;
		}
	}

	async navigationMethod() {
		try {
			this.resultunassigned = await patientstatusreturns();
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
		}

		if (this.resultunassigned === this.unAssignedSite) {
			window.location.assign(this.unAssigned);
		} else if (this.resultunassigned === this.acute) {
			window.location.assign(this.unAssigned + this.acuteDashboard);
		} else {
			window.location.assign(this.brandedSite + this.dashBoard);
		}
	}
	//To save the response
	async saveAsDraft() {
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
		// Concatenate the three values with a space in between, excluding duplicates
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
			this.realAssesVerArra.push(this.sixthVersiD);
		}

		if (this.seventhQuestionResponse === '' && this.sevenQResForEach !== '') {
			this.realrespArray.push(this.sevenQResForEach);
			this.realAssesVerArra.push(this.sevenQVersionResForEach);
		} else {
			this.realrespArray.push(this.seventhRespalue);
			this.realAssesVerArra.push(this.seventhVersiD);
		}

		if (this.eightQuestionResponse === '' && this.eigthQResForEach !== '') {
			this.realrespArray.push(this.eigthQResForEach);
			this.realAssesVerArra.push(this.eigthQVersionResForEach);
		} else {
			this.realrespArray.push(this.eghtResponseValue);
			this.realAssesVerArra.push(this.eightVersiId);
		}
		if (this.ninthQuestionResponse === '' && this.nineQResForEach !== '') {
			this.realrespArray.push(this.nineQResForEach);
			this.realAssesVerArra.push(this.nineQVersionResForEach);
		} else {
			this.realrespArray.push(this.ninthResponseValue);
			this.realAssesVerArra.push(this.ninthVersId);
		}

		if (this.tenthQuestionResponse === '' && this.tenthQResForEach !== '') {
			this.realrespArray.push(this.tenthQResForEach);
			this.realAssesVerArra.push(this.tenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.tenthResponseValue);
			this.realAssesVerArra.push(this.tenthVersId);
		}

		if (
			this.eleventhQuestionResponse === '' &&
			this.eleventhQResForEach !== ''
		) {
			this.realrespArray.push(this.eleventhQResForEach);
			this.realAssesVerArra.push(this.eleventhQVersionResForEach);
		} else {
			this.realrespArray.push(this.eleventhResponseValue);
			this.realAssesVerArra.push(this.eleventhVersiD);
		}

		if (this.twelvthQuestionResponse === '' && this.twelthQResForEach !== '') {
			this.realrespArray.push(this.twelthQResForEach);
			this.realAssesVerArra.push(this.twelthQVersionResForEach);
		} else {
			this.realrespArray.push(this.twelvthRespalue);
			this.realAssesVerArra.push(this.twelvthVersiD);
		}

		if (
			this.thirteenthQuestionResponse === '' &&
			this.thirteenthQResForEach !== ''
		) {
			this.realrespArray.push(this.thirteenthQResForEach);
			this.realAssesVerArra.push(this.thirteenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.thirteenthResponseValue);
			this.realAssesVerArra.push(this.thirteenthVersiId);
		}

		if (
			this.fourteenthQuestionResponse === '' &&
			this.fourteenthQResForEach !== ''
		) {
			this.realrespArray.push(this.fourteenthQResForEach);
			this.realAssesVerArra.push(this.fourteenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.fourteenthResponseValue);
			this.realAssesVerArra.push(this.fourteenthVersId);
		}
		if (
			this.fifteenthQuestionResponse === '' &&
			this.fifteenthQResForEach !== ''
		) {
			this.realrespArray.push(this.fifteenthQResForEach);
			this.realAssesVerArra.push(this.fifteenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.fifteenthResponseValue);
			this.realAssesVerArra.push(this.fifteenthVersId);
		}
		if (
			this.sixteenthQuestionResponse === '' &&
			this.sixteenthQResForEach !== ''
		) {
			this.realrespArray.push(this.sixteenthQResForEach);
			this.realAssesVerArra.push(this.sixteenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.sixteenthResponseValue);
			this.realAssesVerArra.push(this.sixteenthVersId);
		}
		try {
			this.resultunassigned = await patientstatusreturns();
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
		}

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
					if (this.resultunassigned === this.unAssignedSite) {
						window.location.assign(this.unAssigned);
					} else if (this.resultunassigned === this.acute) {
						window.location.assign(this.unAssigned + this.acuteDashboard);
					} else {
						window.location.assign(this.brandedSite + this.dashBoard);
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
				});
		}
	}

	//To confirm the popup
	confirmSubmission() {
		this.checkinc = 1;
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

		// Concatenate the three values with a space in between, excluding duplicates
		const concatenatedValues = [
			...new Set(
				[firstValue, secondValue, thirdValue].filter(
					(value) => value !== undefined
				)
			)
		].join(', ');
		// // Concatenate all values into a single variable
		this.fourthRspValue = '';
		this.fourthRspValue = concatenatedValues;

		// Create an array to store the values dynamically
		let medicValues = [];

		for (let i = 0; i < Math.min(12, this.selectMedic.length); i++) {
			// Add the value to the array
			medicValues.push(this.selectMedic[i]);
		}

		// Concatenate all values with a comma in between, excluding duplicates
		const concatenatedMedicValues = [
			...new Set(medicValues.filter((value) => value !== undefined))
		].join(', ');

		// let concatenatedValues = [firstValue, secondValue, thirdValue].join(' ');

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
			this.realAssesVerArra.push(this.sixthVersiD);
		}

		if (this.seventhQuestionResponse === '' && this.sevenQResForEach !== '') {
			this.realrespArray.push(this.sevenQResForEach);
			this.realAssesVerArra.push(this.sevenQVersionResForEach);
		} else {
			this.realrespArray.push(this.seventhRespalue);
			this.realAssesVerArra.push(this.seventhVersiD);
		}

		if (this.eightQuestionResponse === '' && this.eigthQResForEach !== '') {
			this.realrespArray.push(this.eigthQResForEach);
			this.realAssesVerArra.push(this.eigthQVersionResForEach);
		} else {
			this.realrespArray.push(this.eghtResponseValue);
			this.realAssesVerArra.push(this.eightVersiId);
		}

		if (this.ninthQuestionResponse === '' && this.nineQResForEach !== '') {
			this.realrespArray.push(this.nineQResForEach);
			this.realAssesVerArra.push(this.nineQVersionResForEach);
		} else {
			this.realrespArray.push(this.ninthResponseValue);
			this.realAssesVerArra.push(this.ninthVersId);
		}

		if (this.tenthQuestionResponse === '' && this.tenthQResForEach !== '') {
			this.realrespArray.push(this.tenthQResForEach);
			this.realAssesVerArra.push(this.tenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.tenthResponseValue);
			this.realAssesVerArra.push(this.tenthVersId);
		}

		if (
			this.eleventhQuestionResponse === '' &&
			this.eleventhQResForEach !== ''
		) {
			this.realrespArray.push(this.eleventhQResForEach);
			this.realAssesVerArra.push(this.eleventhQVersionResForEach);
		} else {
			this.realrespArray.push(this.eleventhResponseValue);
			this.realAssesVerArra.push(this.eleventhVersiD);
		}

		if (this.twelvthQuestionResponse === '' && this.twelthQResForEach !== '') {
			this.realrespArray.push(this.twelthQResForEach);
			this.realAssesVerArra.push(this.twelthQVersionResForEach);
		} else {
			this.realrespArray.push(this.twelvthRespalue);
			this.realAssesVerArra.push(this.twelvthVersiD);
		}

		if (
			this.thirteenthQuestionResponse === '' &&
			this.thirteenthQResForEach !== ''
		) {
			this.realrespArray.push(this.thirteenthQResForEach);
			this.realAssesVerArra.push(this.thirteenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.thirteenthResponseValue);
			this.realAssesVerArra.push(this.thirteenthVersiId);
		}

		if (
			this.fourteenthQuestionResponse === '' &&
			this.fourteenthQResForEach !== ''
		) {
			this.realrespArray.push(this.fourteenthQResForEach);
			this.realAssesVerArra.push(this.fourteenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.fourteenthResponseValue);
			this.realAssesVerArra.push(this.fourteenthVersId);
		}

		if (
			this.fifteenthQuestionResponse === '' &&
			this.fifteenthQResForEach !== ''
		) {
			this.realrespArray.push(this.fifteenthQResForEach);
			this.realAssesVerArra.push(this.fifteenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.fifteenthResponseValue);
			this.realAssesVerArra.push(this.fifteenthVersId);
		}

		if (
			this.sixteenthQuestionResponse === '' &&
			this.sixteenthQResForEach !== ''
		) {
			this.realrespArray.push(this.sixteenthQResForEach);
			this.realAssesVerArra.push(this.sixteenthQVersionResForEach);
		} else {
			this.realrespArray.push(this.sixteenthResponseValue);
			this.realAssesVerArra.push(this.sixteenthVersId);
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
			(response) => typeof response != 'undefined'
		).length;

		if (this.numberOfResponses <= 10) {
			const nonEmptyResponses = this.realrespArray.filter(
				(response) => response !== ''
			);
			const nonEmptyIds = this.realAssesVerArra.filter(
				(id) => id !== ''
			);
			const de = this.checkinc;
			if (this.realrespArray.length > 0) {
				draftResponseSubmition({
					questionIds: nonEmptyIds,
					responseTexts: nonEmptyResponses,
					InprogressOrCompelete: de
				})
					.then(() => {
						window.location.assign(this.brandedSite + this.dashBoard);

					})
					.catch((error) => {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
					});
			}
		}
	}
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}