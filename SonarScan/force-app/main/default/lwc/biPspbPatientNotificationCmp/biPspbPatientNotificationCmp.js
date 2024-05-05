// This consolidated component is used to show avatar, message and patient notification setting.
// To import Libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedUrl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import patientProfile from '@salesforce/label/c.BI_PSPB_PatientMyProfileUrl';
import patientNotification from '@salesforce/label/c.BI_PSPB_PatientNotificationUrl';
import patientAvatar from '@salesforce/label/c.BI_PSPB_PatientSelectAvatarUrl';
import patientCaregiver from '@salesforce/label/c.BI_PSPB_MyCaregiverUrl';
export default class BiPspbPatientNotificationCmp extends LightningElement {
	//this method is used to navigate a user to unassigned or branded
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
				this.urlq = brandedUrl;
			} else {
				this.urlq = unassignedUrl;
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from LWC
		}
	}

	// navigation for patient
	openPatMyProfile() {
		window.location.assign(this.urlq + patientProfile);
	}
	openPatMyCaregiver() {
		window.location.assign(this.urlq + patientNotification);
	}
	openPatSelectAvatar() {
		window.location.assign(this.urlq + patientAvatar);
	}
	openPatNotSettings() {
		window.location.assign(this.urlq + patientCaregiver);
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