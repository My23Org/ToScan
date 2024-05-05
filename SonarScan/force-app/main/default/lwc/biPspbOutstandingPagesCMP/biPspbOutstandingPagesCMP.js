//This is Consolidate Component this contains Avatar and Questionnaire Cards to achieve mobile responsive.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
//To import Custom labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getAssessmentCountsByCurrentUserName';
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
export default class BiPspbOutstandingPagesCMP extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track valuewin;
	//Global variables(without @track does not trigger automatic re-renders)
	showTabMenu;
	count;
	urlq;

	//To get total completed Assessments counts.
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
	//To get Qualitative  rolloutDate for side bar navigations
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
		if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		} else if (data) {
			this.threeMonthsVar = data.threeMonthsVar;
			this.forteenWeeks = data.forteenWeeks;
			this.targetDate2 = data.targetDate2 ?? null;
			this.targetDate14 = data.targetDate14 ?? null;
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

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
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error
		}
	}
	renderedCallback() {
		try {
		const windowWidth = window.innerWidth;

		if (windowWidth <= 1200) {
			this.valuewin = '12';
		} else {
			this.valuewin = '4';
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error
		}
	}

	openOutQuestionnaires() {
		window.location.assign(this.urlq + outStandingUrl);
	}
	openSummary() {
		window.location.assign(this.urlq + summaryUrl);
	}

	//Navigation methods for completed Questionnaries
	openComQuestionnaires() {
		if (this.stdlq > 0) {
		window.location.assign(this.urlq + dlqiCompletedUrl);
		} else if (this.stpss > 0) {
		window.location.assign(this.urlq + pssCompletedUrl);
		} else if (this.stwai > 0) {
		window.location.assign(this.urlq + wapiCompletedUrl);
		} else if (this.stqsq > 0) {
		if (this.targetDate14 != null) {
			window.location.assign(this.urlq + qualitativeCompletedFourteenMonths);
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