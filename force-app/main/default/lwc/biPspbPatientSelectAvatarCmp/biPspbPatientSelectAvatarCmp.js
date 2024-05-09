import { LightningElement } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//custom label
import brandedurl from "@salesforce/label/c.BI_PSPB_siteUrl";
import unassignedurl from "@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr";
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import slashURL from '@salesforce/label/c.BI_PSP_ChatterSlash';
import slashSiteUrl from '@salesforce/label/c.BI_PSP_Slashsite';
import PatientMyProfileUrl from '@salesforce/label/c.BI_PSPB_PatientMyProfileUrl';
import MyCaregiverUrl from '@salesforce/label/c.BI_PSPB_MyCaregiverUrl';
import PatientSelectAvatarUrl from '@salesforce/label/c.BI_PSPB_PatientSelectAvatarUrl';
import PatientNotificationUrl from '@salesforce/label/c.BI_PSPB_PatientNotificationUrl';

export default class BiPspbPatientSelectAvatarCmp extends LightningElement {

	SLASHSITEURL = slashURL;
	SLASHSITEPAGEURL = slashSiteUrl;
	PatientMyProfile = PatientMyProfileUrl;
	MyCaregiver = MyCaregiverUrl;
	PatientSelectAvatar = PatientSelectAvatarUrl;
	PatientNotification = PatientNotificationUrl;


	//connectedcallback is used for assign the url
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
				this.urlq = brandedurl;
			} else {
				this.urlq = unassignedurl;
			}
		} catch (error) {
			// Handle error
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	openPatMyProfile() {
		window.location.assign(this.SLASHSITEURL + this.urlq + this.SLASHSITEURL + this.PatientMyProfile);
	}
	openPatMyCaregiver() {
		window.location.assign(this.SLASHSITEURL + this.urlq + this.SLASHSITEURL + this.MyCaregiver);
	}
	openPatSelectAvatar() {
		window.location.assign(this.SLASHSITEURL + this.urlq + this.SLASHSITEURL + this.PatientSelectAvatar);
	}
	openPatNotSettings() {
		window.location.assign(this.SLASHSITEURL + this.urlq + this.SLASHSITEURL + this.PatientNotification);
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