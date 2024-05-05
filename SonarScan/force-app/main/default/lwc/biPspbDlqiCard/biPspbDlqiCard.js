// This Card displays information related to the Dermatology Life Quality Index (DLQI) questionnaire, aiding in the presentation and understanding of its contents.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getCategoryStatus from '@salesforce/apex/BI_PSP_Assessment.getCategoryStatus';
import getDateInprogrsCard from '@salesforce/apex/BI_PSP_CardDateForInProgress.getTheDateInProgessForCard';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
import draftResponseOfDLQI from '@salesforce/apex/BI_PSP_RetriveDraftResponse.draftResponseOfDermatology';
import getRolloutdate from '@salesforce/apex/BI_PSP_Assessment.getRolloutdate';
//To import Static Resource
import testimg from '@salesforce/resourceUrl/BI_PSP_DLQIimage';
import imagearrow from '@salesforce/resourceUrl/BI_PSP_arrowImage';
//To import Custom labels
import dlqi_category from '@salesforce/label/c.BI_PSP_DlqiCategory';
import rolldateouttext from '@salesforce/label/c.BI_PSP_Rolloutdatetext';
import heading1 from '@salesforce/label/c.BI_PSP_DlqiHeading1';
import heading2 from '@salesforce/label/c.BI_PSP_DlqiHeading2';
import anslabel5 from '@salesforce/label/c.BI_PSP_AnsweredLabel';
import expirelab from '@salesforce/label/c.BI_PSP_Expirelabel';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import completed from '@salesforce/label/c.BI_PSP_CompletedOn';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import inProgress from '@salesforce/label/c.BI_PSP_Inprogess';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import resume from '@salesforce/label/c.BI_PSP_resumeLabel';
import startLabel from '@salesforce/label/c.BI_PSP_StartLabel';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import noLabel from '@salesforce/label/c.BI_PSP_no';
import dlqiUrl from '@salesforce/label/c.BI_PSPB_BRDlqiQuestionnaireUrl';
import dlqiCompletedUrl from '@salesforce/label/c.BI_PSPB_BRDlqiCompletedUrl';
//To get UserId
import Id from '@salesforce/user/Id';

export default class BiPspbDlqiCard extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track totalquestioncount = 10;
	@track rolloutdate1;
	@track answeredQuestions = 0;
	//Global variables(without @track does not trigger automatic re-renders)
	dateResponses = [];
	storedate;
	userid = Id;
	rolloutDate;
	expiresIn;
	assessementstatus;
	isStartLabel = true;
	showcompleteddate = false;
	categoryname = dlqi_category;
	assessmentId;
	status;
	dlqiRollOutDate;
	expireDate;
	expireApexdate;
	arrowimage = imagearrow;
	cardimage = testimg;
	rollout = rolldateouttext;
	dlqiheading = heading1;
	dlqiindexheading = heading2;
	answeredlabel = anslabel5;
	expirelabel = expirelab;
	urlq;
	completedondate;
	completedon = completed;
	// Variable to check if data is already loaded
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
			this.showToast(consoleErrorMessage, error.message, errorvariant); //Catching Potential Error
		}
	}

	// For Mobile Response 
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

	// To get rollout date by Current user
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getDateInprogrsCard)
	wiredDataForInprogress({ data, error }) {
		try {
			if (error ) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			} else if (data && !this.isDataLoaded ) {
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


	// To get existing assessment and their status by Current User
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
					this.isStartLabel = false;
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
	//TO get InitialRollout date for Current User
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getRolloutdate)
	wiredQSPData({ error, data }) {
		try {
			if (data) {
				this.dateResponses = data;

				if (!this.assessmentId) {
					this.dateResponses.forEach((item) => {
						this.storedate = item.BI_PSP_DLQI_RollOutDate__c;
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
			} else if (error ) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//To get total Response from Questionnaire to show the count
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(draftResponseOfDLQI)
	wiredDraftResponses({ error, data }) {
		try {
			if (data) {
				const objectsWithResponseOrder7 = data.filter(
					(item) => item.BI_PSP_ResponseOrder__c === 7
				);
				if (objectsWithResponseOrder7.length > 0) {
					if (objectsWithResponseOrder7[0].ResponseValue === noLabel) {
						this.totalquestioncount = 11;
					} else {
						this.totalquestioncount = 10;
					}
				}
			} else if (error ) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	// To get assessment and their status
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
				if (this.answeredQuestions > 10) {
					this.totalquestioncount = 11;
				}

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

	// Dynamic Button label according to Responses
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

	//Navigation to QUestionnarie
	handleButtonClick() {
		if (this.buttonLabel === startLabel) {
			const rolldate = new Date(this.rolloutDate);
			const currentDate = new Date();
			if (currentDate >= rolldate) {
				window.location.assign(this.urlq + dlqiUrl);
			} else {
				this.showToast(consoleErrorMessage, consoleErrorMessage, errorvariant); 
			}
		} else if (this.buttonLabel === resume) {
			window.location.assign(this.urlq + dlqiUrl);
		} else {
			window.location.assign(this.urlq + dlqiCompletedUrl); 
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