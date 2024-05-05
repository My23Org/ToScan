// This Lightning Web Component serves as the navigation and parent component for the caregiver profile
// To import Libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import caregiverprofile from '@salesforce/label/c.BI_PSPB_BRCaregiverProfile';
import caregiverpatient from '@salesforce/label/c.BI_PSPB_BRCaregiverPatient';
import caregiverselectavatar from '@salesforce/label/c.BI_PSPB_BRCaregiverSelectAvatar';
import caregivernotifications from '@salesforce/label/c.BI_PSPB_BRCaregiverNotification';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class BiPspbCaregiverProfileCmp extends LightningElement {
// Proper naming conventions with camel case for all the variable will be followed in the future releases
// Declaration of global variables
siteurlq;
urlq;

// Navigate to the caregiver profile page
openCarMyProfile() {
	window.location.assign(this.siteurlq + caregiverprofile);
}

// Navigate to the caregiver patient page
openCarMyCaregiver() {
	window.location.assign(this.siteurlq + caregiverpatient);
}

// Navigate to the caregiver select avatar page
openCarSelectAvatar() {
	window.location.assign(this.siteurlq + caregiverselectavatar);
}

// Navigate to the caregiver notifications page
openCarNotSettings() {
	window.location.assign(this.siteurlq + caregivernotifications);
}

// To reterieve the site url
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
		this.urlq = brandedurl;
		this.siteurlq = brandedsiteurl;
	} else {
		this.urlq = unassignedurl;
		this.siteurlq = unassignedsiteurl;
	}
	} catch (error) {
	// Handle error
	this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
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