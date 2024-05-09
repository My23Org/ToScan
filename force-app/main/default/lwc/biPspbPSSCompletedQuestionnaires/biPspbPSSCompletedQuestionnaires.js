//This is Psoriasis Symptom Scale (PSS) completed Questionnaire (LWC),this allows you to see Completed Questionnaire with submitted responses.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getRecordsForDate from '@salesforce/apex/BI_PSP_CompletedQuestionareS.getCompletedQuestionares';
import getPSScompletedQuestionares from '@salesforce/apex/BI_PSP_CompletedQuestionareS.getQstnrcurrentcompleteddate';
import getRolloutdate from '@salesforce/apex/BI_PSP_Assessment.getRolloutdate';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getAssessmentCountsByCurrentUserName';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
//To import Static Resource
import pss from '@salesforce/resourceUrl/BI_PSP_PSSimage';
import letpersonalize from '@salesforce/resourceUrl/BI_PSP_letspersonalizeimage';
import testimg from '@salesforce/resourceUrl/BI_PSP_DLQIimage';
import workandactivity from '@salesforce/resourceUrl/BI_PSP_WPAIimage';
import qualitative from '@salesforce/resourceUrl/BI_PSP_Qualitativeimage';
//To get UserId
import Id from '@salesforce/user/Id';
//To import Custom labels
import BI_PSP_introductionCategory from '@salesforce/label/c.BI_PSP_introductionCategory';
import BI_PSP_PssCategory from '@salesforce/label/c.BI_PSP_PssCategory';
import BI_PSP_WapiCategory from '@salesforce/label/c.BI_PSP_WapiCategory';
import BI_PSP_DlqiCategory from '@salesforce/label/c.BI_PSP_DlqiCategory';
import BI_PSP_QualitativeCategory from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import BI_PSP_Wapi from '@salesforce/label/c.BI_PSP_WAPI';
import BI_PSP_selectmonth from '@salesforce/label/c.BI_PSP_selectmonth';
import BI_PSP_completedquestionnaire from '@salesforce/label/c.BI_PSP_completedquestionnaire';
import BI_PSP_roll_out from '@salesforce/label/c.BI_PSP_roll_out';
import BI_PSP_expiredon from '@salesforce/label/c.BI_PSP_expiredon';
import completed from '@salesforce/label/c.BI_PSP_CompletedOn';
import BI_PSP_noassessmentsfound from '@salesforce/label/c.BI_PSP_noassessmentsfound';
import dlqi_category from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import BI_PSP_PSSbottomtext1 from '@salesforce/label/c.BI_PSP_PSSbottomtext1';
import BI_PSP_DLQIbottom3 from '@salesforce/label/c.BI_PSP_DLQIbottom3';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import wapiCompletedQuestionnaire from '@salesforce/label/c.BI_PSPB_BRWapiCompletedQuestionnaire';
import qualitativeCompletedFourteenMonths from '@salesforce/label/c.BI_PSPB_BRQualitativefourteenweeksCompletedUrl';
import qualitativeCompletedtwoMonths from '@salesforce/label/c.BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl';
import dlqiCompletedUrl from '@salesforce/label/c.BI_PSPB_BRDlqiCompletedUrl';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
export default class BiPspbPSSCompletedQuestionnaires extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track storedEffectiveDates = [];
	@track storedExpirationDates = [];
	@track htmlEffect;
	@track htmlExpirationDate;
	@track selectedValue;
	//Global variables(without @track does not trigger automatic re-renders)
	assessmentResponseses = [];
	categoryname = dlqi_category;
	urlq;
	records = [];
	stpss = 0;
	stwai = 0;
	stqsq = 0;
	stdlq = 0;
	userid = Id;
	assessments = []; // Updated to store a list of assessments
	selectedAssessment; // Added variable to store the selected assessment
	rolloutDate;
	expirationDate;
	expireDate;
	target14wksdate;
	target2monthsdate;
	forteenWeeks;
	threeMonthsVar;
	pssCategoryname = BI_PSP_PssCategory;
	introduction = BI_PSP_introductionCategory;
	pss = BI_PSP_PssCategory;
	dlqi = BI_PSP_DlqiCategory;
	wapi = BI_PSP_WapiCategory;
	qsq = BI_PSP_QualitativeCategory;
	workAPI = BI_PSP_Wapi;
	cardimage = letpersonalize;
	cardimage1 = testimg;
	cardimage2 = pss;
	cardimage3 = workandactivity;
	cardimage4 = qualitative;
	dateResponses = [];
	storedate;
	pssbottom1 = BI_PSP_PSSbottomtext1;
	pssbottom2 = BI_PSP_DLQIbottom3;
	selectmonth = BI_PSP_selectmonth;
	notfound = BI_PSP_noassessmentsfound;
	completedqn = BI_PSP_completedquestionnaire;
	rollout = BI_PSP_roll_out;
	expiredon = BI_PSP_expiredon;
	completedon = completed;
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
	//To get date for all pss completed assessment by current user
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getRecordsForDate, { targetDate: '$selectedAssessment', categoryName: '$pssCategoryname' })
	wiredRecords({ error, data }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); //Catching Potential Error Apex
			} else if (data) {
				this.records = data;
				this.assessmentResponsesesdate = data.map((response) => ({
					res: response.Assessment.EffectiveDateTime
				}));

				this.assessmentResponsesesdate1 = data.map((response) => ({
					res: response.Assessment.BI_PSP_RolloutforCompletedQuestionnarie__c
				}));

				const ds = this.assessmentResponsesesdate[0];
				const ds1 = this.assessmentResponsesesdate1[0];
				const thedate = ds.res;
				const thedate2 = ds1.res;
				//rolloutdate:
				const currentDate = new Date(thedate);

				this.expireDate = currentDate.toLocaleDateString('en-US', {
					year: 'numeric',
					month: 'short',
					day: 'numeric'
				});
				//expireDate:
				const currentDate1 = new Date(thedate2);
				this.rolloutDate = currentDate1.toLocaleDateString('en-US', {
					year: 'numeric',
					month: 'short',
					day: 'numeric'
				});
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); //Catching Potential Error LWC
		}
	}

	// Options for the assessment dropdown
	get assessmentOptions() {
		return this.assessments.map((assessment) => ({
			label: assessment.formattedDate,
			value: assessment.effectiveDate
		}));
	}
	//To get Qualitative date for side bar navigation
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); //Catching Potential Error Apex
			} else if (data) {
				this.threeMonthsVar = data.threeMonthsVar;
				this.forteenWeeks = data.forteenWeeks;
				this.target2monthsdate = data.target2monthsdate ?? null;
				this.target14wksdate = data.target14wksdate ?? null;
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); //Catching Potential Error LWC
		}
	}

	//To get existing assessment record and their status
	/*Null checks are not performed because if there is no Assessment with completed Status
	it will not navigate to this page.
    */
	@wire(getAssessmentsByCurrentUserNamepss, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); //Catching Potential Error Apex
			} else if (data) {
				this.assessmentId = data.length > 0 ? data[0].Id : null;
				this.status = data.length > 0 ? data[0].AssessmentStatus : null;
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); //Catching Potential Error LWC
		}
	}
	// To get rollout date for Questionnaire to display
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getRolloutdate)
	wiredQSPData({ error, data }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); //Catching Potential Error Apex
			} else if (data) {
				this.dateResponses = data;
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); //Catching Potential Error LWC
		}
	}

	//To get the completed Assessment record in pss
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getPSScompletedQuestionares, { categoryName: '$pssCategoryname' })
	wiredAssessmentResponses({ data, error }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); //Catching Potential Error Apex
			} else if (data) {
				// Map the assessments and format the date for each
				this.assessments = data.map((response) => ({
					effectiveDate: this.formatDate(response.EffectiveDateTime),
					expirationDate: this.formatDate(response.ExpirationDateTime),
					formattedDate: this.formatDate(response.EffectiveDateTime)
				}));

				this.someMethodOutsideWire();
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); //Catching Potential Error LWC
		}
	}

	// Utility method to format the date using Intl.DateTimeFormat
	formatDate(dateString) {
		const options = { year: 'numeric', month: 'long' };
		return new Date(dateString).toLocaleDateString(undefined, options);
	}

	// Handle assessment dropdown change
	handleAssessmentChange(event) {
		const selectedValues = event.target.value;
		this.selectedAssessment = selectedValues;
	}

	// Example of iterating through this.assessments and storing field values in other properties
	someMethodOutsideWire() {
		// Example: Store the field values in other properties
		this.storedEffectiveDates = this.assessments.map(
			(assessment) => assessment.effectiveDate
		);
		this.storedExpirationDates = this.assessments.map(
			(assessment) => assessment.expirationDate
		);
		this.storedFormattedDates = this.assessments.map(
			(assessment) => assessment.formattedDate
		);

		// Access the first record from the storedEffectiveDates and storedExpirationDates arrays
		if (
			this.storedEffectiveDates.length > 0 &&
			this.storedExpirationDates.length > 0
		) {
			const firstEffectiveDate = this.storedEffectiveDates[0];
			const firstExpirationDate = this.storedExpirationDates[0];
			// Log or use the retrieved values as needed
			this.htmlEffect = firstEffectiveDate;
			this.selectedAssessment = firstEffectiveDate;
			this.htmlExpirationDate = firstExpirationDate;
		}
	}
	//To get all completed Questionnaire count for tab navigation
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); //Catching Potential Error Apex
			} else if (data) {
				this.count = data;
				if (this.count.length > 0) {
					this.stwai = this.count[0];
					this.stpss = this.count[1];
					this.stdlq = this.count[2];
					this.stqsq = this.count[3];
				}
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); //Catching Potential Error LWC
		}
	}
	get checkdlqi() {
		return this.stdlq > 0 ? '' : 'disabled';
	}

	get checkwai() {
		return this.stwai > 0 ? '' : 'disabled';
	}
	get checkqsq() {
		return this.stqsq > 0 ? '' : 'disabled';
	}

	//navigation methods for all completed Questionnaire
	navigateToCategory2() {
		window.location.assign(this.urlq + dlqiCompletedUrl);
	}

	navigateToCategory4() {
		window.location.assign(this.urlq + wapiCompletedQuestionnaire);
	}
	navigateToCategory5() {
		if (this.target14wksdate != null) {
			if (this.status === completedLabel || this.status === expired) {
				window.location.assign(this.urlq + qualitativeCompletedFourteenMonths);
			} else {
				window.location.assign(this.urlq + qualitativeCompletedtwoMonths);
			}
		} else {
			window.location.assign(this.urlq + qualitativeCompletedtwoMonths);
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