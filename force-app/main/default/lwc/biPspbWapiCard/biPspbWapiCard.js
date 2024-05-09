//This Card displays information related to the Work & Activity Impairment (WPAI), aiding in the presentation and understanding of its contents.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getCategoryStatus from '@salesforce/apex/BI_PSP_Assessment.getCategoryStatus';
import getDateInprogrsCard from '@salesforce/apex/BI_PSP_CardDateForInProgress.getTheDateInProgessForCardWAPI';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
import getTheDdraftResponse from '@salesforce/apex/BI_PSP_RetriveDraftResponse.draftResponseOfWorkAndActivty';
//To import Static Resource
import workandactivity from '@salesforce/resourceUrl/BI_PSP_WPAIimage';
import imagearrow from '@salesforce/resourceUrl/BI_PSP_arrowImage';
//To import Custom labels
import getRolloutdate from '@salesforce/apex/BI_PSP_Assessment.getRolloutdate';
import wpai_category from '@salesforce/label/c.BI_PSP_WapiCategory';
import expirelab from '@salesforce/label/c.BI_PSP_Expirelabel';
import rolldateouttext from '@salesforce/label/c.BI_PSP_Rolloutdatetext';
import anslabel5 from '@salesforce/label/c.BI_PSP_AnsweredLabel';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import completed from '@salesforce/label/c.BI_PSP_CompletedOn';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import inProgress from '@salesforce/label/c.BI_PSP_Inprogess';
import resume from '@salesforce/label/c.BI_PSP_resumeLabel';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import yesLabel from '@salesforce/label/c.BI_PSP_yes';
import startLabel from '@salesforce/label/c.BI_PSP_StartLabel';
import wapiQuestionnaire from '@salesforce/label/c.BI_PSPB_BRWapiQuestionnaire';
import wapiCompletedQuestionnaire from '@salesforce/label/c.BI_PSPB_BRWapiCompletedQuestionnaire';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
//To get UserId
import Id from '@salesforce/user/Id';

export default class BiPspbWapiCard extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track categoryname = wpai_category;
	@track totalquestioncount = 2;
	@track answeredQuestions = 0;
	//Global variables(without @track does not trigger automatic re-renders)
	dateResponses = [];
	assessmentId;
	categoryStatus;
	rolloutDate;
	expiresIn;
	isStartLabel = true;
	userid = Id;
	cardimage = workandactivity;
	storedate;
	status;
	expireDate;
	expireApexdate;
	arrowimage = imagearrow;
	expiresIntext = expirelab;
	rollout = rolldateouttext;
	anstext = anslabel5;
	showcompleteddate = false;
	completedondate;
	completedon = completed;
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

	// Mobile responsive Layout
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
	//To get rollout date
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

	//Get Assessment record and status.
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

	//getting Response for diplaying in cards on particular senario
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getTheDdraftResponse)
	wiredDraftResponses({ error, data }) {
		try {
			if (error ) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			} else if (data) {
				const objectsWithResponseOrder = data.filter(
					(item) => item.BI_PSP_ResponseOrder__c === 1
				);
				if (objectsWithResponseOrder.length > 0) {
					if (objectsWithResponseOrder[0].ResponseValue === yesLabel) {
						this.totalquestioncount = 6;
					} else {
						this.totalquestioncount = 2;
					}
				}
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//To get the rollout date if there is no assessment record
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getRolloutdate)
	wiredQSPData({ error, data }) {
		try {
			if (error ) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
			if (data) {
				this.dateResponses = data;

				if (!this.assessmentId) {
					this.dateResponses.forEach((item) => {
						this.storedate = item.BI_PSP_WAI_RollOutDate__c;
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

	//To get the answered Response by passing Assessment
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
				if (this.answeredQuestions > this.totalquestioncount) {
					this.totalquestioncount = 6;
				}
				if (!this.assessmentId) {
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

					this.isStartLabel = false;
				} else if (this.status === expired) {
					this.isStartLabel = true;

					this.showRolloutDate1 = true;
					this.answeredQuestions = 0;
					this.totalquestioncount = 2;
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

	//To change dynamic button

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
	// Navigation for Questionnaire
	handleButtonClick() {
		if (this.buttonLabel === startLabel) {
			const rolldate = new Date(this.rolloutDate);
			const currentDate = new Date();

			if (currentDate >= rolldate) {
				window.location.assign(this.urlq + wapiQuestionnaire);
			}
			this.showRolloutDate1 = true;
		} else if (this.buttonLabel === resume) {
			window.location.assign(this.urlq + wapiQuestionnaire);
		} else {
			window.location.assign(this.urlq + wapiCompletedQuestionnaire);
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