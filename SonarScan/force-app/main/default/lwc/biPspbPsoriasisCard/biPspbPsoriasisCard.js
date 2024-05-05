//This Card displays information related to the Psoriasis Symptom Scale (PSS), aiding in the presentation and understanding of its contents.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getCategoryStatus from '@salesforce/apex/BI_PSP_Assessment.getCategoryStatus';
import getTotalquestionscount from '@salesforce/apex/BI_PSP_Assessment.getTotalquestionscount';
import getDateInprogrsCard from '@salesforce/apex/BI_PSP_CardDateForInProgress.getTheDateInProgessForCardPSS';
import getRolloutdate from '@salesforce/apex/BI_PSP_Assessment.getRolloutdate';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
//To import Static Resource
import pss from '@salesforce/resourceUrl/BI_PSP_PSSimage';
import imagearrow from '@salesforce/resourceUrl/BI_PSP_arrowImage';
//To import Custom labels
import heading1 from '@salesforce/label/c.BI_PSP_psoriasisLabel';
import heading2 from '@salesforce/label/c.BI_PSP_psoriasisLabel1';
import expirelab from '@salesforce/label/c.BI_PSP_Expirelabel';
import pss_category from '@salesforce/label/c.BI_PSP_PssCategory';
import rolldateouttext from '@salesforce/label/c.BI_PSP_Rolloutdatetext';
import anslabel5 from '@salesforce/label/c.BI_PSP_AnsweredLabel';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import completed from '@salesforce/label/c.BI_PSP_CompletedOn';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import pssQuestionarrieUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisQuesUrl';
import pssCompletedQuestionnaire from '@salesforce/label/c.BI_PSPB_BRPsoriasisCompletedQuesUrl';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import inProgress from '@salesforce/label/c.BI_PSP_Inprogess';
import resume from '@salesforce/label/c.BI_PSP_resumeLabel';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import startLabel from '@salesforce/label/c.BI_PSP_StartLabel';
//To get UserId
import Id from '@salesforce/user/Id';
export default class BiPspbPsoriasisCard extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track totalquestioncount = 4;
	@track answeredQuestions = 0;
	//Global variables(without @track does not trigger automatic re-renders)
	userid = Id;
	assessmentId;
	status;
	categoryStatus;
	rolloutDate;
	expiresIn;
	expireDate;
	showcompleteddate = false;
	isStartLabel = true;
	completedondate;
	categoryname = pss_category;
	completedon = completed;
	cardimage = pss;
	dateResponses = [];
	storedate;
	expireApexdate;
	arrowimage = imagearrow;
	psshead = heading1;
	psshead1 = heading2;
	anstext = anslabel5;
	expirelabel = expirelab;
	rollout = rolldateouttext;
	urlq;
	rolloutdate1;
	isDataLoaded = false;
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
		} catch (error) {
		this.showToast(consoleErrorMessage, error.message, errorvariant); // Catching Potential Error
		}
	}
	//for mobile view
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

	//getting date for inprogress and completed
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getDateInprogrsCard)
	wiredDataForInprogress({ error, data }) {
		try {
		if (error ) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex 
		} else if (data && !this.isDataLoaded) {
			this.rolloutdate1 = data;

			if (this.status === inProgress || this.status === completedLabel) {
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
			const todayMs = new Date().getTime();
			const expireDateMs = new Date(this.expireDate).getTime();

			const differenceInDays = Math.ceil(
				(expireDateMs - todayMs) / (1000 * 60 * 60 * 24)
			);

			this.expiresIn = differenceInDays;
			if (this.expiresIn > 30 || this.expiresIn < 0) {
				this.expiresIn = 30;
			}
			}

			this.isDataLoaded = true; // Set to true once data is loaded
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// getting records  for current and caregiver
	/*Null checks are not performed because sometimes users may or may not have assessment records initially. 
    Even if there are no assessment records, we show the cards for the user to create assessment records. 
	The page will not be blank.
    */
	@wire(getAssessmentsByCurrentUserNamepss, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
		if (error ) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex 
		} else if (data) {
			this.assessmentId = data.length > 0 ? data[0].Id : null;
			this.status = data.length > 0 ? data[0].AssessmentStatus : null;
			if (this.status === expired) {
			this.expireApexdate =
				data.length > 0 ? data[0].ExpirationDateTime : null;
			const currentDate = new Date(this.expireApexdate);

			this.rolloutDate = currentDate.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});
			//expire Part

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
			if (this.expiresIn > 30 || this.expiresIn < 0) {
				this.expiresIn = 30;
			}
			} else if (this.status === completedLabel) {
			this.isStartLabel = false;
			this.showcompleteddate = true;
			this.expireApexdate =
				data.length > 0 ? data[0].EffectiveDateTime : null;
			const currentDate = new Date(this.expireApexdate);

			this.completedondate = currentDate.toLocaleDateString('en-US', {
				year: 'numeric',
				month: 'short',
				day: 'numeric'
			});
			}
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//rollout date from setup
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getRolloutdate)
	wiredQSPData({ error, data }) {
		try {
		if (error ) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex 
		} else if (data) {
			this.dateResponses = data;

			if (!this.assessmentId) {
			this.dateResponses.forEach((item) => {
				this.storedate = item.BI_PSP_PSS_RollOutDate__c;
			});
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
			const todayMs = new Date().getTime();
			const expireDateMs = new Date(this.expireDate).getTime();

			const differenceInDays = Math.ceil(
				(expireDateMs - todayMs) / (1000 * 60 * 60 * 24)
			);
			this.expiresIn = differenceInDays;
			if (this.expiresIn > 30 || this.expiresIn < 0) {
				this.expiresIn = 30;
			}
			}
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// getting draft answers for the assessment
	/*Null checks are not performed because sometimes users may or may not have assessment records initially. 
    Even if there are no assessment records, we show the cards for the user to create assessment records. 
	The page will not be blank.
    */
	@wire(getCategoryStatus, { assessmentId: '$assessmentId' })
	wiredCategoryStatus({ error, data }) {
		try {
		if (error  ) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex 
		} else if (data) {
			this.answeredQuestions = data;

			if (
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
			this.isStartLabel = false;
			} else if (this.status === expired) {
			this.isStartLabel = true;
			this.answeredQuestions = 0;
			} else if (
			this.answeredQuestions === this.totalquestioncount &&
			this.status === completedLabel
			) {
			this.isStartLabel = false;
			}
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//geting total question count
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getTotalquestionscount, { categoryname: '$categoryname' })
	wiredCategorycount({ error, data }) {
		try {
		if (error ) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex 
		} else if (data) {
			this.totalquestioncount = data;
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	// to change the dynamic button as per label data
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

	//Navigation method
	handleButtonClick() {
		if (this.buttonLabel === startLabel) {
		const rolldate = new Date(this.rolloutDate);
		const currentDate = new Date();
		if (currentDate >= rolldate) {
			window.location.assign(this.urlq + pssQuestionarrieUrl);
		} else {
			this.showToast(consoleErrorMessage, consoleErrorMessage, errorvariant); // Catching Potential Error
		}
		} else if (this.buttonLabel === resume) {
		window.location.assign(this.urlq + pssQuestionarrieUrl);
		} else {
		window.location.assign(this.urlq + pssCompletedQuestionnaire);
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