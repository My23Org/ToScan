// This Card displays information related to the Introduction, aiding in the presentation and understanding of its contents.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getCategoryStatus from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.draftResponseOfIntroduction';
import introduction_category from '@salesforce/label/c.BI_PSP_introductionCategory';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
//To import Static Resource
import letpersonalize from '@salesforce/resourceUrl/BI_PSP_letspersonalizeimage';
import imagearrow from '@salesforce/resourceUrl/BI_PSP_arrowImage';
//To import Custom labels
import letspersonlizetext from '@salesforce/label/c.BI_PSP_Letspersonlize';
import rolldateouttext from '@salesforce/label/c.BI_PSP_Rolloutdatetext';
import anslabel from '@salesforce/label/c.BI_PSP_AnwerLabel';
import anslabel1 from '@salesforce/label/c.BI_PSP_letspersonlizetextlongtext';
import anslabel2 from '@salesforce/label/c.BI_PSP_Letspersonlizelongtext1';
import anslabel3 from '@salesforce/label/c.BI_PSP_Letspersonlizelongtext2';
import anslabel4 from '@salesforce/label/c.BI_PSP_Letspersonlizelongtext3';
import anslabel5 from '@salesforce/label/c.BI_PSP_AnsweredLabel';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import inProgress from '@salesforce/label/c.BI_PSP_Inprogess';
import resume from '@salesforce/label/c.BI_PSP_resumeLabel';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import yesLabel from '@salesforce/label/c.BI_PSP_yes';
import noLabel from '@salesforce/label/c.BI_PSP_no';
import startLabel from '@salesforce/label/c.BI_PSP_StartLabel';
import letsPronslizeUrl from '@salesforce/label/c.BI_PSPB_BR_LetsPersonalizeUrl';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
//To get UserId
import Id from '@salesforce/user/Id';
export default class BiPspbIntroductionCard extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track answeredQuestions = 0;
	@track totalquestioncount = 15;
	//Global variables(without @track does not trigger automatic re-renders)
	userid = Id;
	assessmentId;
	categoryStatus;
	error;
	rolloutDate;
	expiresIn;
	categoryname = introduction_category;
	isStartLabel = true;
	showRolloutDate1 = false;
	showAnswerQuestionsText = true;
	cardimage = letpersonalize;
	arrowimage = imagearrow;
	letptext = letspersonlizetext;
	rolldate = rolldateouttext;
	answerlabel = anslabel;
	answerlabel1 = anslabel1;
	answerlabel2 = anslabel2;
	answerlabel3 = anslabel3;
	answerlabel4 = anslabel4;
	answeredlabel = anslabel5;
	urlq = brandedurl;

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
	// for mobile css call property
	get flexCard() {
		if (window.innerWidth <= 600) {
			return this.isStartLabel ? 'flexCard' : 'flexcard1';
		}
		return 'flexCard';
	}
	get bottomBar() {
		if (window.innerWidth <= 600) {
			return this.isStartLabel ? 'bottomBar' : 'bottomBar1';
		}
		return 'bottomBar';
	}
	get ans() {
		if (window.innerWidth <= 600) {
			return this.isStartLabel ? 'ans' : 'ans1';
		}
		return 'ans';
	}
	get image() {
		if (window.innerWidth <= 600) {
			return this.isStartLabel ? 'image' : 'image1';
		}
		return 'image';
	}
	get dlqi1() {
		if (window.innerWidth <= 600) {
			return this.isStartLabel ? 'dlqi1' : 'dlqi11';
		}
		return 'dlqi1';
	}

	/*Null checks are not performed because sometimes users may or may not have assessment records initially. 
    Even if there are no assessment records, we show the cards for the user to create assessment records. 
	The page will not be blank.
    */
	@wire(getAssessmentsByCurrentUserNamepss, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
			if (error ) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from apex
			} else if (data ) {
				this.assessmentId = data.length > 0 ? data[0].Id : null;
				this.status = data.length > 0 ? data[0].AssessmentStatus : null;
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	/*Null checks are not performed because sometimes users may or may not have assessment records initially. 
    Even if there are no assessment records, we show the cards for the user to create assessment records. 
	The page will not be blank.
    */
	@wire(getCategoryStatus, { assessmentId: '$assessmentId' })
	wiredCategoryStatus({ error, data }) {
		try {
			if (error ) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from apex
			} else if (data) {
				this.records = data;
				this.answeredQuestions = this.records.length;

				this.records.forEach((record) => {
					if (
						record.BI_PSP_ResponseOrder__c === 5 &&
						record.ResponseText === yesLabel
					) {
						this.totalquestioncount = 16;
						this.answeredQuestions = this.records.length;
					} else if (
						record.BI_PSP_ResponseOrder__c === 5 &&
						record.ResponseText === noLabel
					) {
						this.answeredQuestions = this.records.length;
					}
				});
				if (this.answeredQuestions > this.totalquestioncount) {
					this.totalquestioncount = 16;
				}
				if (!this.assessmentId) {
					this.showAnswerQuestionsText = true;
					this.showRolloutDate1 = false;
				} else if (
					this.totalquestioncount !== this.answeredQuestions &&
					this.answeredQuestions < this.totalquestioncount &&
					this.answeredQuestions > 0 &&
					this.status === inProgress
				) {
					this.showRolloutDate1 = false;
					this.showAnswerQuestionsText = true;
					this.isStartLabel = false;
				} else if (this.status === expired) {
					this.isStartLabel = true;
					this.showAnswerQuestionsText = true;
					this.showRolloutDate1 = false;
					this.answeredQuestions = 0;
				} else if (
					this.answeredQuestions === this.totalquestioncount &&
					this.status === inProgress
				) {
					this.showRolloutDate1 = false;
					this.showAnswerQuestionsText = true;
					this.isStartLabel = false;
				}
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// To update the dynamic button label arrow and button
	get buttonLabel() {
		if (!this.assessmentId) {
			this.isStartLabel = true;

			return startLabel;
		} else if (
			this.totalquestioncount !== this.answeredQuestions &&
			this.answeredQuestions < this.totalquestioncount &&
			this.answeredQuestions > 0
		) {
			this.isStartLabel = false;
			return resume;
		}
		this.isStartLabel = false;
		return resume;
	}
	//Navigation for Questionnaire
	handleButtonClick() {
		if (this.buttonLabel === startLabel) {
			window.location.assign(this.urlq + letsPronslizeUrl);

			this.showRolloutDate1 = false;
			this.showAnswerQuestionsText = true;
		} else if (this.buttonLabel === resume) {
			window.location.assign(this.urlq + letsPronslizeUrl);
		} else {
			window.location.assign(this.urlq + letsPronslizeUrl);
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