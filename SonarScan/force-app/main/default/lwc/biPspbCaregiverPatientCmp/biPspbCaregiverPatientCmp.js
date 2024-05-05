//This  consolidates component the functionality for caregivers to view patient information and perform updates when logged in
//To import Libraries
import { LightningElement } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//To import Static resources
import brandedurl from "@salesforce/label/c.BI_PSPB_siteUrl";
import unassignedurl from "@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr";
import brandedUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedUrl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
//To import The Custom labels
import BI_PSPB_CaregiverNotification from '@salesforce/label/c.BI_PSPB_CaregiverNotification';
import BI_PSPB_CaregiverProfileSite from '@salesforce/label/c.BI_PSPB_CaregiverProfileSite';
import BI_PSPB_CaregiverPatient from '@salesforce/label/c.BI_PSPB_CaregiverPatient';
import BI_PSPB_CaregiverSelectAvatar from '@salesforce/label/c.BI_PSPB_CaregiverSelectAvatar';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class BiPspbCaregiverPatientCmp extends LightningElement {

	connectedCallback() {
		try {
			const currentURL = window.location.href;
			// Create a URL object
			const urlObject = new URL(currentURL); // Get the path
			const path = urlObject.pathname; // Split the path using '/' as a separator
			const pathComponents = path.split("/"); // Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find((component) =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
					component.toLowerCase()
				)
			);
			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedUrl;
			} else {
				this.urlq = unassignedUrl;
			}
		}
		catch (err) {
			// Handle error
			this.showToast(errormessage, err.message, errorvariant);
		}
	}

	//These are caregiver account manager Navigation
	openCarMyProfile() {
		window.location.assign(this.urlq + BI_PSPB_CaregiverProfileSite);
	}
	openCarMyCaregiver() {
		window.location.assign(this.urlq + BI_PSPB_CaregiverPatient);
	}
	openCarSelectAvatar() {
		window.location.assign(this.urlq + BI_PSPB_CaregiverSelectAvatar);
	}
	openCarNotSettings() {
		window.location.assign(this.urlq + BI_PSPB_CaregiverNotification);
	}

	//this ShowToast message is used for Error
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}

}