import { LightningElement, wire, track } from 'lwc';
// Imports resourceUrl to reference external resources for proper rendering and functionality.
import img from '@salesforce/resourceUrl/BI_PSP_Thankyouimg';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
// Importing Apex classes to interact with Salesforce backend for data retrieval.
import getlead from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getLead';
import getcaregiver from '@salesforce/apex/BI_PSPB_createLeadRecord.getHcpRecord';
// Imports labels for descriptive text or identifiers, enhancing accessibility and user understanding.
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
// Imports showToastEvent to display notification messages, informing users about component actions or events.
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class pspBrThankyoumessageforhcpCaregiverEnrollment extends LightningElement {

	@track age = true;
	@track recordDetails;
	@track caregiver;
	@track result;
	@track recordid;
	@track count;
	@track patientEmail;
	mailimg = img;
	BGpp = BGpp;

	//  get lead record from apex
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	//Therefore, null data won't be encountered.
	@wire(getlead, { createLeadId: '$recordid' })
	wiredRecordDetailsLead({ error, data }) {
		try {
			if (data && data.length > 0) {
				this.recordDetails = data;
				this.patientEmail=data[0].Email;

			}
			else if (error) {
				this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from apex
			}
		}
		catch (err) {
			// Handle any errors that occur within the try block

			this.showToast(errormessage, err.message, errorvariant);// Catching Potential Error from lwc

		}

	}
	// get hcp record from apex
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	//Therefore, null data won't be encountered.
	@wire(getcaregiver, { leadId: '$recordid' })
	wiredRecordDetailsCaregiver({ error, data }) {
		try {
			if (data && data.length > 0) {
				this.caregiver = data;
				
				this.age = true;

			}
			else if (error) {
				this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from apex
			
			}
		}
		catch (err) {
			// Handle any errors that occur within the try block

			this.showToast(errormessage, err.message, errorvariant);// Catching Potential Error from lwc

		}
	}

	connectedCallback() {
		try {
			// Retrieve the recordId from localStorage
			this.recordid = localStorage.getItem('recordId');
			this.count = localStorage.getItem('count');
			if (this.count !== 2) {
				localStorage.setItem('count', 2);


			}
		} catch (error) {
			// Handle any errors that occur within the try block

			this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from lwc



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