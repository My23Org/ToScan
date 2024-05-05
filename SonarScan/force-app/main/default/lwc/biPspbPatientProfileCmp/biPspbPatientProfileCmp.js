// To import Libraries
import { LightningElement } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Custom Labels
import brandedurl from "@salesforce/label/c.BI_PSPB_siteUrl";
import unassignedurl from "@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr";
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brandedUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedUrl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import PatientMyProfileUrl from '@salesforce/label/c.BI_PSPB_PatientMyProfileUrl';
import MyCaregiverUrl from '@salesforce/label/c.BI_PSPB_MyCaregiverUrl';
import PatientSelectAvatarUrl from '@salesforce/label/c.BI_PSPB_PatientSelectAvatarUrl';
import PatientNotificationUrl from '@salesforce/label/c.BI_PSPB_PatientNotificationUrl';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import letspersnoliseSiteUrl from '@salesforce/label/c.BI_PSPB_BR_LetsPersonalizeUrl';

export default class BiPspbPatientProfileCmp extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases

	PatientMyProfile = PatientMyProfileUrl;
	MyCaregiver = MyCaregiverUrl;
	PatientSelectAvatar = PatientSelectAvatarUrl;
	PatientNotification = PatientNotificationUrl;
	LETSPERSNOLISEURL = letspersnoliseSiteUrl;
	brandedUrl = brSiteUrl;
	openhome() {
		window.location.assign(this.brandedUrl);
		window.location.assign( this.urlq + this.LETSPERSNOLISEURL);
	}
	openPatMyProfile() {

		window.location.assign(this.urlq +this.PatientMyProfile);
	}
	openPatMyCaregiver() {

		window.location.assign(this.urlq +this.MyCaregiver);
	}

	openPatSelectAvatar() {

		window.location.assign(this.urlq +  this.PatientSelectAvatar);
	}
	openPatNotSettings() {

		window.location.assign(this.urlq + this.PatientNotification);
	}
	connectedCallback() {
		try {
			const currentURL = window.location.href;
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
		} catch (error) {
			// Handle error
			this.showToast(errormessage, error.message, errorvariant);
		}
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