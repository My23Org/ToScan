// This lightning web component is used for display the chronic patient customized video
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex classes
import getRecords from '@salesforce/apex/BI_PSPB_treatmentvideocmd.getRecords';
// To import Custom Labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPsptreatmentvideos extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track videoUrl = '';
	@track isContentVisible = false;
	// Global variables(without @track does not trigger automatic re-renders)
	userId = Id;

	
	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the video Url
	@wire(getRecords)
	wiredMetadata({ data, error }) {
		try {
			if (data) {
				// Assuming the data is an array with at least one record
				this.videoUrl = data[0].BI_PSPB_URL__c;
				if (
					this.userId === '' ||
					this.userId === null ||
					typeof this.userId === 'undefined'
				) {
					this.videoUrl = '';
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// Getter method to determine the icon name based on content visibility
	get iconName() {
		return this.isContentVisible ? 'utility:chevronup' : 'utility:chevrondown';
	}

	// Getter method to determine the icon alt text based on content visibility
	get iconAltText() {
		return this.isContentVisible ? 'Collapse Content' : 'Expand Content';
	}

	// Getter method to determine the content class based on content visibility
	get contentClass() {
		return this.isContentVisible ? 'content visible' : 'content';
	}

	// Method to toggle the content visibility
	toggleContent() {
		this.isContentVisible = !this.isContentVisible;
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