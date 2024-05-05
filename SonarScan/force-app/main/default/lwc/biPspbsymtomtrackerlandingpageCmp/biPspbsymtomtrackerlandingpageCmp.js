// This LWC is used new entry page create  - biPspbsymtomtrackerlandingpageCmp
// To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Apex Classes
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import fetchSymptomErolle from '@salesforce/apex/BI_PSP_GraphCtrl.getSymptomTrackerDetails';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import symptomgraphurl from '@salesforce/label/c.BI_PSPB_symptomgraphpage';
import January from '@salesforce/label/c.BI_PSPB_January';
import February from '@salesforce/label/c.BI_PSPB_February';
import March from '@salesforce/label/c.BI_PSPB_March';
import april from '@salesforce/label/c.BI_PSPB_April';
import May from '@salesforce/label/c.BI_PSPB_May';
import June from '@salesforce/label/c.BI_PSPB_June';
import July from '@salesforce/label/c.BI_PSPB_July';
import August from '@salesforce/label/c.BI_PSPB_August';
import September from '@salesforce/label/c.BI_PSPB_September';
import October from '@salesforce/label/c.BI_PSPB_October';
import November from '@salesforce/label/c.BI_PSPB_November';
import December from '@salesforce/label/c.BI_PSPB_December';
import firstdategraph from '@salesforce/label/c.BI_PSPB_firstdategraph';
import lastdategraph from '@salesforce/label/c.BI_PSPB_lastdategraph';
import monthdate from '@salesforce/label/c.BI_PSPB_monthdate';
import edits from '@salesforce/label/c.BI_PSPB_edits';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import Slash from '@salesforce/label/c.BI_PSPB_Slash';
import Questionmark from '@salesforce/label/c.BI_PSP_Questionmark';

export default class BiPspbsymtomtrackerlandingpageCmp extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	@track isLoading = true;
	@track edits;
	//Variable declaration
	userId = Id;
	enrolleId;
	showSymptom = false;
	//It extracts the current URL and determines the desired component based on the URL path.
	connectedCallback() {
		const currentURL = window.location.href;
		const urlObject = new URL(currentURL);        // Get the path
		const path = urlObject.pathname;        // Split the path using '/' as a separator
		const pathComponents = path.split(Slash); // Find the component you need (in this case, 'Branded')
		const desiredComponent = pathComponents.find(component =>
			[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
		);
		if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
			this.urlq = brandedUrlNavi;
		}
		else {
			this.urlq = unAssignedUrlNavi;
		}
		try {
			getEnrolle({ userId: this.userId })
				.then(result => {// Null check has been handled in its respective apex method
					if (result[0].patientEnrolle != null) {
						this.enrolleId = result[0].patientEnrolle.Id;
						this.getsymptom();
					} else if (result[0].error != null) {
						this.showError = true;
						this.errorMessage = result[0].error;
					}
				})
				.catch(error => {
					// Handle any errors occurring during the promise chain
					this.showToast(errormessage, error.message, errorvariant);
				});
		} catch (error) {
			// Handle any synchronous errors outside the promise chain
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	//This function is responsible for fetching symptom data for the current month.
	getsymptom() {
		const currentDate = new Date();
		const currentYear = currentDate.getFullYear();
		const currentMonthIndex = currentDate.getMonth();
		const currentMonthName = [
			January, February, March, april, May, June,
			July, August, September, October, November, December
		][currentMonthIndex];
		const selectedMonthIndex = currentMonthIndex;        // Calculate first date (last date of previous month)
		const firstDate = new Date(currentYear, selectedMonthIndex, 0, 18, 30, 0);
		let lastDate = new Date(currentYear, selectedMonthIndex + 1, 1, 18, 30, 0);        // Adjust for next year if necessary
		if (selectedMonthIndex === 11) {
			lastDate.setFullYear(currentYear + 1);
		}
		this.firstdate = firstDate.toISOString();
		this.lastDate = lastDate.toISOString();
		this.getsymptomdatewithallergy(this.enrolleId, firstDate.toISOString(), lastDate.toISOString(), currentMonthName);
	}
	//This function is responsible for fetching symptom data for a specific enrollee within a given date range.
	getsymptomdatewithallergy(erolles, firstDate, lastDate, currentMonthName) {
		fetchSymptomErolle({ erolleId: erolles, firstDate: firstDate, lastDate: lastDate })
			.then(result => {
				if (result !== null) {
					let urlParams = new URLSearchParams(window.location.href.split(Questionmark)[1]);
					this.edits = urlParams.get(edits);
					if (!this.edits) {
						window.location.assign(this.urlq + symptomgraphurl + this.enrolleId + firstdategraph + this.firstdate + lastdategraph + this.lastDate + monthdate + currentMonthName);
					} else {
						this.showSymptom = true;
						this.isLoading = false;
					}
				} else {
					this.showSymptom = true;
					this.isLoading = false;
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant);
			});
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