// This consolidated component is used to show avatar , message and selecting an avatar whenever user wants to change
// To import Libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brandedurlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedurlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import caregiverProfileUrl from '@salesforce/label/c.BI_PSPB_BRCaregiverProfile';
import caregiverPatientUrl from '@salesforce/label/c.BI_PSPB_BRCaregiverPatient';
import caregiverSelectUrl from '@salesforce/label/c.BI_PSPB_BRCaregiverSelectAvatar';
import caregiverNotifyUrl from '@salesforce/label/c.BI_PSPB_BRCaregiverNotification';
export default class BiPspbCaregiverSelectAvatarCmp extends LightningElement {
	//this method is used to navigating a user unassigned and branded
	connectedCallback() {
		try {
			const currentURL = window.location.href;
			// Create a URL object
			const urlObject = new URL(currentURL);        // Get the path
			const path = urlObject.pathname;        // Split the path using '/' as a separator
			const pathComponents = path.split('/');        // Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find(component =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
			);


			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurlNavi;
			}
			else {
				this.urlq = unassignedurlNavi;
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); //catching potential error in LWC
		}
	}
	// navigation for caregiver

	openCarMyProfile() {
		window.location.assign(this.urlq + caregiverProfileUrl);
	}
	openCarMyCaregiver() {
		window.location.assign(this.urlq + caregiverPatientUrl);
	}
	openCarSelectAvatar() {
		window.location.assign(this.urlq + caregiverSelectUrl);
	}
	openCarNotSettings() {
		window.location.assign(this.urlq + caregiverNotifyUrl);
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