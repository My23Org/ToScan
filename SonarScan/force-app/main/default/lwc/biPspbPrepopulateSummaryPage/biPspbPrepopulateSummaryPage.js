// This component is consolidate component used to update hcp patient information enrollment form main page.
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Static Resources
import img from '@salesforce/resourceUrl/BI_PSP_Thankyouimg';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
//  To import Apex Classes
import getlead from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getLead';
import getcaregiver from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getCaregiver';
import getphysician from '@salesforce/apex/BI_PSPB_createLeadRecord.getHcpRecord';
import getcothanks from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getcothanks';
// To import Custom Label
import toActiveMsg from '@salesforce/label/c.BI_PSPB_ThankYouMsgthree';
import emailsentmsg from '@salesforce/label/c.BI_PSPB_ThankYouMsgfour';
import checkmailmsg from '@salesforce/label/c.BI_PSPB_ThankYouMsgone';
import existingAccountmsg from '@salesforce/label/c.BI_PSPB_ThankYouMsgtwo';
import sendavatarmsg from '@salesforce/label/c.BI_PSP_sendavatarmsg';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class biPspbPrepopulateSummaryPage extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track age = false;
	@track recordDetails;
	@track caregiver;
	@track cargivers
	@track result;
	@track recordid;
	@track count;
	@track email;
	@track messagecontent;
	@track messagecontent2;
	@track contdata;
	@track valueAvatar = false;
	// Declaration of Global variables
	BGpp = BGpp;
	mailimg = img;
	cothanksWiredResult;

	//to get Lead's Physician record
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
			getphysician({ leadId: this.recordid })
				.then((result) => {
					// Assuming result is an array of physician records
					// Assigning the result to a trackable property for further usage
					this.physicianData = result;
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
				});
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//to get lead records using recordId
	@wire(getlead, { createLeadId: '$recordid' })
	wiredRecordDetailsLead({ error, data }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				this.recordDetails = data;
				this.email = data[0].Email;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//to get caregiver records using recordid
	@wire(getcaregiver, { CaregivercreateId: '$recordid' })
	wiredRecordDetailsCaregiver({ error, data }) {
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data && data.length > 0) {
			try {
				this.caregiver = data;

				this.age = true;
				this.email = data[0].BI_PSPB_E_mail_ID__c;
				this.valueAvatar = true;
				this.dispatchEvent(
					new CustomEvent(sendavatarmsg, { detail: this.valueAvatar })
				);
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
			}
		} else if (error && data.length > 0) {
			this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
		}
	}


	//to get physician records using recordid
	@wire(getphysician, { leadId: '$recordid' })
	wiredRecordDetailsCaregivers({ error, data }) {
		try {
			// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				this.caregivers = data;

				this.messagecontent = toActiveMsg;
				this.messagecontent2 = emailsentmsg + this.email;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//to display caregiver mail in thank you message
	@wire(getcothanks, { CaregivercreateId: '$recordid' })
	wiredRecordDetailcontact({ error, data }) {

		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data && data.length > 0) {
			try {
				this.contdata = data;

				if (this.contdata === true) {
					this.messagecontent =
						checkmailmsg + this.email;
					this.messagecontent2 = existingAccountmsg;
				} else {
					this.messagecontent = toActiveMsg;
					this.messagecontent2 = emailsentmsg + this.email;
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
			}
		} else if (error && data.length > 0) {
			this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
		}

	}

	// Function to refresh wired data
	refreshCoThanks() {
		refreshApex(this.cothanksWiredResult);
	}
	renderedCallback() {
		this.refreshCoThanks();
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