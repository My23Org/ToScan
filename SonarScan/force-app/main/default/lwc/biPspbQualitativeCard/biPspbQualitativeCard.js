//	This Card displays information related to the Qualitative satisfaction questionnaire,aiding in the presentation and understanding of its contents.
//To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getCategoryStatus from '@salesforce/apex/BI_PSP_Assessment.getCategoryStatus';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
import qualitative_label from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
//To import Static Resource
import qualitativeimg from '@salesforce/resourceUrl/BI_PSP_Qualitativeimage';
import imagearrow from '@salesforce/resourceUrl/BI_PSP_arrowImage';
//To import Custom labels
import expirelab from '@salesforce/label/c.BI_PSP_Expirelabel';
import rolldateouttext from '@salesforce/label/c.BI_PSP_Rolloutdatetext';
import anslabel5 from '@salesforce/label/c.BI_PSP_AnsweredLabel';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import qualitativeTwoMonths from '@salesforce/label/c.BI_PSPB_BRQualitativeTwoMonths';
import qualitativeFourteenoMonths from '@salesforce/label/c.BI_PSPB_BRQualitativeFourteenWeeks';
import qualitativeCompletedFourteenMonths from '@salesforce/label/c.BI_PSPB_BRQualitativefourteenweeksCompletedUrl';
import qualitativeCompletedtwoMonths from '@salesforce/label/c.BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import inProgress from '@salesforce/label/c.BI_PSP_Inprogess';
import resume from '@salesforce/label/c.BI_PSP_resumeLabel';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import startLabel from '@salesforce/label/c.BI_PSP_StartLabel';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
//To get UserId
import Id from '@salesforce/user/Id';
export default class BiPspbQualitativeCard extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track target2monthsdate;
	@track target14wksdate;
	@track categoryname = qualitative_label;
	@track totalquestioncount = 0;
	@track answeredQuestions = 0;
	//Global variables(without @track does not trigger automatic re-renders)
	userid = Id;
	assessmentId;
	categoryStatus;
	error;
	statusforDate14;
	rolloutDate;
	expiresIn;
	isStartLabel = false;
	threeMonthsVar = '';
	forteenWeeks = '';
	shouldShowComponent = false;
	showRolloutDate1 = true;
	showAnswerQuestionsText = false;
	cardimage = qualitativeimg;
	arrowimage = imagearrow;
	expirelabel = expirelab;
	rollout = rolldateouttext;
	answeredlabel = anslabel5;
	urlq;

	//For mobile Response
	get flexCard() {
		if (window.innerWidth <= 600) {
		return this.isStartLabel ? 'flexCard' : 'flexCard1';
		} 
		return 'flexCard';
		
	}

	get bottomBar() {
		if (window.innerWidth <= 600) {
		return this.isStartLabel ? 'bottomBar' : 'bottomBar1';
		} 
		return 'bottomBar';
		
	}
	get image() {
		if (window.innerWidth <= 600) {
		return this.isStartLabel ? 'image' : 'image1';
		} 
		return 'image1';
		
	}
	get dlqi2() {
		if (window.innerWidth <= 600) {
		return this.isStartLabel ? 'dlqi2' : 'dlqi22';
		} 
		return 'dlqi2';
		
	}
	get dlqi3() {
		if (window.innerWidth <= 600) {
		return this.isStartLabel ? 'dlqi3' : 'dlqi33';
		} 
		return 'dlqi3';
		
	}
	get ans() {
		if (window.innerWidth <= 600) {
		return this.isStartLabel ? 'ans' : 'ans1';
		} 
		return 'ans';
		
	}
	// To get site Url to find the Current SiteName
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
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error
		}
	}

	//Getting assessment records and status
	/*Null checks are not performed because sometimes users may or may not have assessment records initially. 
    Even if there are no assessment records, we show the cards for the user to create assessment records. 
	The page will not be blank.
    */
	@wire(getAssessmentsByCurrentUserNamepss, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
		if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		} else if (data) {
			this.assessmentId = data.length > 0 ? data[0].Id : null;
			this.status = data.length > 0 ? data[0].AssessmentStatus : null;
			this.statusforDate14 =
			data.length > 0 ? data[0].BI_PSP_StatusForPersonalization__c : null;
			if (this.status === completedLabel) {
			this.shouldShowComponent = false;
			}
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//To get Qualitative date for side bar navigation
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
		if (error ) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex 
		} else if (data) {
			this.threeMonthsVar = data.threeMonthsVar;
			this.forteenWeeks = data.forteenWeeks;
			this.target2monthsdate = data.target2monthsdate ?? null;
			this.target14wksdate = data.target14wksdate ?? null;
			
			if (this.target14wksdate != null) {
			this.shouldShowComponent = true;
			const currentDate = new Date(this.target14wksdate);
			this.totalquestioncount = 7;
			if (
				!this.assessmentId ||
				this.status === expired ||
				this.status === inProgress ||
				this.status === completedLabel
			) {
				if (this.status === inProgress) {
				this.isStartLabel = false;
				} else if (this.status === completedLabel) {
				this.shouldShowComponent = false;
				} else {
				this.isStartLabel = true;
				}
				if (this.statusforDate14 === completedLabel) {
				this.shouldShowComponent = false;
				}
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
				if (this.expiresIn > 30) {
				this.expiresIn = 30;
				}
			}
			} else if (this.target2monthsdate != null) {
			this.shouldShowComponent = true;
			const currentDate = new Date(this.target2monthsdate);
			this.totalquestioncount = 6;
			if (
				!this.assessmentId ||
				this.status === expired ||
				this.status === inProgress ||
				this.status === completedLabel
			) {
				if (this.status === inProgress) {
				this.isStartLabel = false;
				} else if (this.status === completedLabel) {
				this.shouldShowComponent = false;
				} else {
				this.isStartLabel = true;
				}
				if (this.status === expired && this.target14wksdate === null) {
				this.shouldShowComponent = false;
				}

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
				if (this.expiresIn > 30) {
				this.expiresIn = 30;
				}
			}
			}
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//get the assessment related assessment response by passing assessment
	/*Null checks are not performed because sometimes users may or may not have assessment records initially. 
    Even if there are no assessment records, we show the cards for the user to create assessment records. 
	The page will not be blank.
    */
	@wire(getCategoryStatus, { assessmentId: '$assessmentId' })
	wiredCategoryStatus({ error, data }) {
		try {
		if (error ) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex 
		} else if (data) {
			this.answeredQuestions = data;
			if (!this.assessmentId) {
			this.showAnswerQuestionsText = false;
			this.showRolloutDate1 = true;
			} else if (
			this.totalquestioncount === this.answeredQuestions &&
			this.status === inProgress
			) {
			this.isStartLabel = false;
			} else if (
			this.totalquestioncount !== this.answeredQuestions &&
			this.answeredQuestions < this.totalquestioncount &&
			this.answeredQuestions > 0 &&
			this.status === inProgress
			) {
			this.showRolloutDate1 = true;
			this.showAnswerQuestionsText = false;
			this.isStartLabel = false;
			} else if (this.status === expired) {
			this.isStartLabel = true;
			this.showAnswerQuestionsText = false;
			this.showRolloutDate1 = true;
			this.answeredQuestions = 0;
			} else if (
			this.answeredQuestions === this.totalquestioncount &&
			this.status === completedLabel
			) {
			this.showRolloutDate1 = true;

			this.isStartLabel = false;
			}
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//To change dynamic button by button label
	get buttonLabel() {
		if (!this.assessmentId) {
		this.isStartLabel = true;
		return startLabel;
		} else if (
		this.totalquestioncount === this.answeredQuestions &&
		this.status === inProgress
		) {
		this.isStartLabel = false;
		return resume;
		} else if (
		this.totalquestioncount !== this.answeredQuestions &&
		this.status === completedLabel
		) {
		this.isStartLabel = false;
		return completedLabel;
		} else if (
		this.totalquestioncount !== this.answeredQuestions &&
		this.answeredQuestions < this.totalquestioncount &&
		this.answeredQuestions > 0
		) {
		this.isStartLabel = false;
		return resume;
		} else if (this.status === expired) {
		this.isStartLabel = true;
		return startLabel;
		} 
		this.isStartLabel = false;
		return completedLabel;
		
	}

	//Navigation for Questionnaire
	handleButtonClick() {
		if (this.buttonLabel === startLabel) {
		if (this.target14wksdate != null) {
			window.location.assign(this.urlq + qualitativeFourteenoMonths);
		} else {
			window.location.assign(this.urlq + qualitativeTwoMonths);
		}
		} else if (this.buttonLabel === resume) {
		if (this.target14wksdate != null) {
			window.location.assign(this.urlq + qualitativeFourteenoMonths);
		} else {
			window.location.assign(this.urlq + qualitativeTwoMonths);
		}
		this.showRolloutDate1 = true;
		} else {
		this.showRolloutDate1 = true;

		if (this.target14wksdate != null) {
			window.location.assign(this.urlq + qualitativeCompletedFourteenMonths);
		} else {
			window.location.assign(this.urlq + qualitativeCompletedtwoMonths);
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