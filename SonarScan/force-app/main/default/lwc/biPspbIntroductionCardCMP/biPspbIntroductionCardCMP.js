//	This is Consolidate Component(LWC) this contains Avatar and Introduction Questionnaire to achieve mobile responsive.
//To import Libraries
import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getAssessmentCountsByCurrentUserName';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
//To import Custom labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import outStandingUrl from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import summaryUrl from '@salesforce/label/c.BI_PSPB_BRSummaryUrl';
import dlqiCompletedUrl from '@salesforce/label/c.BI_PSPB_BRDlqiCompletedUrl';
import pssCompletedUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisCompletedQuesUrl';
import wapiCompletedUrl from '@salesforce/label/c.BI_PSPB_BRWapiCompletedQuestionnaire';
import letsPersonalizeUrl from '@salesforce/label/c.BI_PSPB_BR_LetsPersonalizeUrl';
import qualitativeCompletedFourteenMonths from '@salesforce/label/c.BI_PSPB_BRQualitativefourteenweeksCompletedUrl';
import qualitativeCompletedtwoMonths from '@salesforce/label/c.BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl';
import qualitative_label from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';

export default class BiPspbIntroductionCardCMP extends LightningElement {
	//Global variables(without @track does not trigger automatic re-renders)
	showTabMenu;
	count;
	status;
	assessmentId;
	categoryname = qualitative_label;
	urlq;

	//To get total completed Questionnaire count for the particular user
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
		if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		} else if (data) {
			this.count = data;
			if (
			this.count[0] !== 0 ||
			this.count[1] !== 0 ||
			this.count[2] !== 0 ||
			this.count[3] !== 0
			) {
			this.showTabMenu = true;
			this.stwai = this.count[0];
			this.stpss = this.count[1];
			this.stdlq = this.count[2];
			this.stqsq = this.count[3];
			} else {
			this.showTabMenu = false;
			}
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//To get assessment and status by current User
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getAssessmentsByCurrentUserNamepss, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
		if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		} else if (data) {
			this.assessmentId = data.length > 0 ? data[0].Id : null;
			this.status = data.length > 0 ? data[0].AssessmentStatus : null;
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//Qualitative Date for topbar navigation
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
		if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		} else if (data) {
			this.threeMonthsVar = data.threeMonthsVar;
			this.forteenWeeks = data.forteenWeeks;
			this.target2monthsdate = data.target2monthsdate ?? null;
			this.target14wksdate = data.target14wksdate ?? null;
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//To get site url
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
			this.urlq = brandedUrlNavi;
		} else {
			this.urlq = unAssignedUrlNavi;
		}
		} catch (error) {
		this.showToast(consoleErrorMessage, error.message, errorvariant); // Catching Potential Error
		}
	}
	//Navigation methods to navigate to other Questionnaire

	openOutQuestionnaires() {
		window.location.assign(this.urlq + outStandingUrl);
	}
	openSummary() {
		window.location.assign(this.urlq + summaryUrl);
	}
	//Completed Questionnaire Navigation
	openComQuestionnaires() {
		if (this.stdlq > 0) {
		window.location.assign(this.urlq + dlqiCompletedUrl);
		} else if (this.stpss > 0) {
		window.location.assign(this.urlq + pssCompletedUrl);
		} else if (this.stwai > 0) {
		window.location.assign(this.urlq + wapiCompletedUrl);
		} else if (this.stqsq > 0) {
		if (this.target14wksdate != null) {
			if (this.status === completedLabel || this.status ===expired) {
			window.location.assign(
				this.urlq + qualitativeCompletedFourteenMonths
			);
			} else {
			window.location.assign(this.urlq + qualitativeCompletedtwoMonths);
			}
		} else {
			window.location.assign(this.urlq + qualitativeCompletedtwoMonths);
		}
		}
	}
	openPersonalize() {
		window.location.assign(this.urlq + letsPersonalizeUrl);
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