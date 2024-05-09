// This is consolidate component for unassigned patient notification
// To import Libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Custom Labels
import UNASSIGNEDSITEURL from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import MYPROFILE from '@salesforce/label/c.BI_PSPB_PatientMyProfileUrl';
import MYCAREGIVER from '@salesforce/label/c.BI_PSPB_MyCaregiverUrl';
import SELECTAVATAR from '@salesforce/label/c.BI_PSPB_PatientSelectAvatarUrl';
import NOTIFICATION from '@salesforce/label/c.BI_PSPB_PatientNotificationUrl';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class biPspbNotificationForPatient extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of Global variables
	unAssignedUrl = UNASSIGNEDSITEURL;
	myProfile = MYPROFILE;
	myCaregiver = MYCAREGIVER;
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

	// navigate unassigned site home page
	openhome() {
		window.location.assign(this.baseUrl + this.unAssignedUrl);
	}
	// navigate unassigned site patientprofile page
	openPatMyProfile() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.myProfile);
	}
	// navigate unassigned site patientcaregiver page
	openPatMyCaregiver() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.myCaregiver);
	}
	openPatSelectAvatar() {
		// navigate unassigned site patientselectavatar page
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.selectAvatar);
	}
	// navigate unassigned site patientnotificationt page
	openPatNotSettings() {
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