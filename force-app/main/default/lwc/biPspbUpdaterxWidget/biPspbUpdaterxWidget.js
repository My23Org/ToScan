//This component for unassigned update prescription.
//To import Libraries
import { LightningElement } from 'lwc';
//To import static resource
import widgetIon from '@salesforce/resourceUrl/BI_PSPB_UpdateRXIcon';
//To import custom labels
import UNASSIGNEDSITEURL from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import UPDATERX from '@salesforce/label/c.BI_PSPB_UpdatePrescriptionUrl';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import ERROR from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class BiPspbUpdaterxWidget extends LightningElement {
	// navigation for update prescription component
	myUrl = widgetIon;
	unAssignedUrl = UNASSIGNEDSITEURL;
	updateRx = UPDATERX;
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
			this.showToast(consoleErrorMessage, error.message, ERROR);
		}
	}
	navigateUpdateRx() {
		//The setTimeout with a small delay ensures UI updates occur after the current rendering tasks, preventing glitches.
		window.location.href = this.baseUrl + this.unAssignedUrl + this.updateRx;
		setTimeout(function () {
			try {
				
			} catch (error) {
				this.showToast(consoleErrorMessage, error.message, ERROR);
			}
		}, 1000);
	}
}