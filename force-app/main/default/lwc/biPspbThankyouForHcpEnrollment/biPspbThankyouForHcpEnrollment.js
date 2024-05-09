//This lightning web component consolidates for thankyou message summary page
//importing the Libraries
import { LightningElement, wire, track } from "lwc";
// Imports resourceUrl to reference external resources for proper rendering and functionality.
import img from "@salesforce/resourceUrl/BI_PSP_Thankyouimg";
import BGpp from "@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo";
// Importing Apex classes to interact with Salesforce backend for data retrieval.
import getlead from "@salesforce/apex/BI_PSPB_leadCreationCtrl.getLead";
import getcaregiver from "@salesforce/apex/BI_PSPB_leadCreationCtrl.getCaregiver";
import getpresinfo from "@salesforce/apex/BI_PSPB_leadCreationCtrl.getPresinfo";
import getcothanks from "@salesforce/apex/BI_PSPB_leadCreationCtrl.getcothanks";
// Imports labels for descriptive text or identifiers, enhancing accessibility and user understanding.
import errorvariant from "@salesforce/label/c.BI_PSPB_errorVariant";
import errormessage from "@salesforce/label/c.BI_PSP_ConsoleError";
import BI_PSPB_ThankYouMsgone from "@salesforce/label/c.BI_PSPB_ThankYouMsgone";
import BI_PSPB_ThankYouMsgtwo from "@salesforce/label/c.BI_PSPB_ThankYouMsgtwo";
import BI_PSPB_ThankYouMsgthree from "@salesforce/label/c.BI_PSPB_ThankYouMsgthree";
import BI_PSPB_ThankYouMsgfour from "@salesforce/label/c.BI_PSPB_ThankYouMsgfour";
// Imports showToastEvent to display notification messages, informing users about component actions or events.
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class pspBrThankyoumessageforhcpenrollment extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Declaration of variables with @track
	@track age = false;
	@track recordDetails;
	@track caregiver;
	@track presinfo;
	@track result;
	@track recordid;
	@track count;
	@track email;
	@track messagecontent;
	@track messagecontent2;
	@track contdata;
	// Declaration of variables
	BGpp = BGpp;
	mailimg = img;

	//To fetch the Patient details
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	//Therefore, null data won't be encountered.
	@wire(getlead, { createLeadId: "$recordid" })
	wiredRecordDetailsLead({ error, data }) {
		if (data) {
			try {
				this.recordDetails = data;
				this.email = data[0].Email;
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		}
		else if (error) {
			// Handle error
			this.showToast(errormessage, error.message, errorvariant);
		}
	}

	//To fetch the Caregiver details
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	//Therefore, null data won't be encountered.
	@wire(getcaregiver, { CaregivercreateId: "$recordid" })
	wiredRecordDetailsCaregiver({ error, data }) {
		if (data && data.length > 0) {
			try {
				this.caregiver = data;
				this.age = true;
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from lwc
			}
		}
		else if (error && data.length > 0) {
			//  Handle error
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from apex
		}
	}

	//To fetch the Prescription details
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	//Therefore, null data won't be encountered.
	@wire(getpresinfo, { PrescriptionrcreateId: "$recordid" })
	wiredRecordDetailsPresinfo({ error, data }) {
		if (data) {
			try {
				this.presinfo = data;
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant);// Catching Potential Error from lwc
			}
		}
		else if (error) {
			// Handle error
			this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from apex
		}
	}

	//To fetch the caregiver details
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	//Therefore, null data won't be encountered.
	@wire(getcothanks, { CaregivercreateId: "$recordid" })
	wiredRecordDetailcontact({ error, data }) {

		if (data && data.length > 0) {
			try {
				this.contdata = data;
				if (this.contdata === true) {
					this.messagecontent = BI_PSPB_ThankYouMsgone + this.email;
					this.messagecontent2 = BI_PSPB_ThankYouMsgtwo;
				}
				else {
					this.messagecontent = BI_PSPB_ThankYouMsgthree;
					this.messagecontent2 = BI_PSPB_ThankYouMsgfour + this.email;
				}
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant);// Catching Potential Error from lwc
			}
		}
		else if (error && data.length > 0) {
			// Handle error
			this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from apex
		}

	}
	connectedCallback() {
		try {
			// Retrieve the recordId from localStorage
			this.recordid = localStorage.getItem("recordId");
			this.count = localStorage.getItem("count");

			if (this.count !== 2) {
				localStorage.setItem("count", 2);
			}
			else {
				localStorage.setItem("count", 1);
			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant);// Catching Potential Error from lwc
		}
	}
	//This ShowToast Message is used For Error
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}