// To import libraries
import { LightningElement } from "lwc";
// To Import Custom Labels
import UNASSIGNEDSITEURL from "@salesforce/label/c.BI_PSPB_UnassignedSiteURL";
import PRESCRIPTIONSTATUS from "@salesforce/label/c.BI_PSPB_PrescriptionStatusUrl";
import UPDATERX from "@salesforce/label/c.BI_PSPB_UpdatePrescriptionUrl";
import ERROR from "@salesforce/label/c.BI_PSPB_errorVariant";
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
export default class BiPspbUpdateRxcmp extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases

	unAssignedUrl = UNASSIGNEDSITEURL;
	updateRx = UPDATERX;
	prescription = PRESCRIPTIONSTATUS;
	baseUrl;
	currentPageUrl;
	urlSegments;
	connectedCallback() {
		try {
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split("/");
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
		} catch (error) {
			this.showToast(errormessage, error.message, ERROR);
		}
	}

	// navigate the user into the unassigned home page
	openhome() {
		window.location.assign(this.baseUrl + this.unAssignedUrl);
	}
	// navigate the user into the unassigned update prescription cmp page
	openupdaterx() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.updateRx);
	}
	// navigate the user into the unassigned priscription status  cmp page
	openstatus() {
		window.location.assign(
			this.baseUrl + this.unAssignedUrl + this.prescription
		);
	}
}