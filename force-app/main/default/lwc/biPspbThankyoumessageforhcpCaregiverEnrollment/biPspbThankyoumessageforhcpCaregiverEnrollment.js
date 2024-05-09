// This Lightning web component is a thank you message template for healthcare professionals (HCPs) who have enrolled a patient or caregiver. It includes patient and caregiver information, enrollment summary, and prescription details.
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Static Resources
import img from '@salesforce/resourceUrl/BI_PSP_Thankyouimg';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
//  To import Apex Classes
import getcaregiver from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getCaregiver';
import getlead from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getLead';
import getpresinfo from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getPresinfo';
import getcothanks from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getcothanks';
// To import Custom Labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
export default class biPspbThankyoumessageforhcpCaregiverEnrollment extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track age = false;
	@track recordDetails;
	@track caregiver;
	@track presinfo;
	@track recordid;
	@track count;
	@track contdata;
	// Declaration of Global variables
	mailimg = img;
	BGpp = BGpp;

	connectedCallback() {
		try {
			// Retrieve the recordId from localStorage
			this.recordid = localStorage.getItem('recordId');
			this.count = localStorage.getItem('count');

			if (this.count !== 2) {
				localStorage.setItem('count', 2);
			} else {
				localStorage.setItem('count', 1);
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//to get patient record based on recordid
	@wire(getlead, { createLeadId: '$recordid' })
	wiredRecordDetailsLead({ error, data }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				this.recordDetails = data;
				this.age = false;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//to get caregiver record based on recordid
	@wire(getcaregiver, { CaregivercreateId: '$recordid' })
	wiredRecordDetailsCaregiver({ error, data }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				this.caregiver = data;
				this.age = true;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//to display patient email in than you message
	@wire(getcothanks, { CaregivercreateId: '$recordid' })
	wiredRecordDetailcontact({ error, data }) {
		try {
			if (data) {
				this.contdata = data;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//to get Lead's Prescription record
	@wire(getpresinfo, { PrescriptionrcreateId: '$recordid' })
	wiredRecordDetailsPresinfo({ error, data }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				this.presinfo = data;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
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