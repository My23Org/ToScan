//This is Consolidate Component(LWC) this contains Avatar and Qualitative satisfaction questionnaire Completed Questionnaire to achieve mobile responsive.
//To import Libraries
import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex Class
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getAssessmentCountsByCurrentUserName';
//To import Custom labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import outStandingUrl from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import summaryUrl from '@salesforce/label/c.BI_PSPB_BRSummaryUrl';
import pssCompletedUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisCompletedQuesUrl';
import wapiCompletedUrl from '@salesforce/label/c.BI_PSPB_BRWapiCompletedQuestionnaire';
import letsPersonalizeUrl from '@salesforce/label/c.BI_PSPB_BR_LetsPersonalizeUrl';
import dlqiCompletedUrl from '@salesforce/label/c.BI_PSPB_BRDlqiCompletedUrl';

export default class BiPspbQualitativeCompletedQues2CMP extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Global variables(without @track does not trigger automatic re-renders)
	showTabMenu;
	urlq;
	count;
	stwai;
	stpss;
	stdlq;
	stqsq;
	//To get total Complete assessment for current user
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
		if (data) {
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
		} else if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//To get site url
	connectedCallback() {
		try {
		const currentURL = window.location.href;
		const urlObject = new URL(currentURL); // Get the path
		const path = urlObject.pathname; // Split the path using '/' as a separator
		const pathComponents = path.split('/'); // Find the component you need (in this case, 'Branded')
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

	//navigation methods for tab

	openOutQuestionnaires() {
		window.location.assign(this.urlq + outStandingUrl);
	}
	openSummary() {
		window.location.assign(this.urlq + summaryUrl);
	}
	openComQuestionnaires() {
		if (this.stdlq > 0) {
		window.location.assign(this.urlq + dlqiCompletedUrl);
		} else if (this.stpss > 0) {
		window.location.assign(this.urlq + pssCompletedUrl);
		} else if (this.stwai > 0) {
		window.location.assign(this.urlq + wapiCompletedUrl);
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