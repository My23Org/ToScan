// This is consolidated component for unassigned notification setting page.
// To import Libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Custom Labels
import UNASSIGNEDSITEURL from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import CAREGIVERPROFILE from '@salesforce/label/c.BI_PSPB_BRCaregiverProfile';
import PATIENT_INFO from '@salesforce/label/c.BI_PSPB_BRCaregiverPatient';
import SELECTAVATAR from '@salesforce/label/c.BI_PSPB_BRCaregiverSelectAvatar';
import NOTIFICATION from '@salesforce/label/c.BI_PSPB_BRCaregiverNotification';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class BiPspbNotificationForCategiver extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of Global variables
	unAssignedUrl = UNASSIGNEDSITEURL;
	caregiverProfile = CAREGIVERPROFILE;
	patientInfo = PATIENT_INFO;
	selectAvatar = SELECTAVATAR;
	patientNotification = NOTIFICATION;
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
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
		}
	}



	// navigate unassigned site  home page 
	openhome() {
		window.location.assign(this.baseUrl + this.unAssignedUrl);
	}
	// navigate unassigned site caregiverprofile page 
	openCarMyProfile() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.caregiverProfile);
	}
	// navigate unassigned site caregiverpatient page 
	openCarMyCaregiver() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.patientInfo);
	}
	// navigate unassigned site caregiverselectavatar page
	openCarSelectAvatar() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.selectAvatar);
	}
	// navigate unassigned site caregivernotification page
	openCarNotSettings() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.patientNotification);
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