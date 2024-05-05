//This is consolidated component for unassigned update prescription.
//To import Libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Custom labels
import UNASSIGNEDSITEURL from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import PRESCRIPTIONSTATUS from '@salesforce/label/c.BI_PSPB_PrescriptionStatusUrl';
import UPDATERX from '@salesforce/label/c.BI_PSPB_UpdatePrescriptionUrl';
import ERROR from '@salesforce/label/c.BI_PSPB_errorVariant';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';

export default class BiPspbPrescriptionStatuscmp extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Global variables(without @track does not trigger automatic re-renders)
	unAssignedUrl = UNASSIGNEDSITEURL;
	updateRx = UPDATERX;
	prescription = PRESCRIPTIONSTATUS;
	baseUrl;
	currentPageUrl;
	urlSegments;
	connectedCallback() {
		try {
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split('/');
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
		}
		catch (error) {
			this.showToast(consoleErrorMessage, error.message, ERROR); // Catching Potential Error
		}
	}
	// navigate  ubassigned site
	openhome() {
		window.location.assign(this.baseUrl + this.unAssignedUrl);
	}
	// navigate ubassigned updateprescription  page
	openupdaterx() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.updateRx);
	}
	// navigate ubassigned prescriptionstatus  page
	openstatus() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.prescription);
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