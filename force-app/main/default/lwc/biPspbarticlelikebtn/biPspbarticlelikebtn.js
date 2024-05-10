// This Lightning web component is used to display the like and unlike reactions on the article detail page
// To import Libraries
import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
// To import apex
import Checkreaction from "@salesforce/apex/BI_PSPB_CmsCtrl.checkreaction";
import updatereaction from "@salesforce/apex/BI_PSPB_CmsCtrl.updatereaction";
// To import Static Resource
import THUMBS_UP_ICON from '@salesforce/resourceUrl/BI_PSP_thumbsUpIcon';
import Thumbsresponse from '@salesforce/resourceUrl/BI_PSP_thumbsresponse';
// To import Custom Labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import likelabel from '@salesforce/label/c.BI_PSP_Like';
import dislikelabel from '@salesforce/label/c.BI_PSP_Dislike';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbarticlelikebtn extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Global variables(without @track does not trigger automatic re-renders)
	thumbsUpIcon = THUMBS_UP_ICON;
	thumbsresponse = Thumbsresponse;
	result;
	titlear = '';
	userId = Id;

	// To change the response to like and dislike
	handleclick() {
		if (this.thumbsUpIcon === Thumbsresponse) {
			this.thumbsUpIcon = THUMBS_UP_ICON;
			this.titlear = dislikelabel + ': ' + this.result;

			updatereaction({
				//   combinedString: combinedString
				articlename: this.result, reaction: dislikelabel
			})
				.then(() => {
					this.titlear = dislikelabel + ': ' + this.result;
				})
				.catch((error) => {
					this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error
					// Handle error, if needed
				});
		} else {
			this.thumbsUpIcon = Thumbsresponse;
			this.titlear = likelabel + ': ' + this.result;
			updatereaction({
				//   combinedString: combinedString
				articlename: this.result, reaction: likelabel
			})
				.then(() => {
					this.titlear = likelabel+ ': ' + this.result;
				})
				.catch((error) => {
					this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error
					// Handle error, if needed
				});
		}
	}

	// To retrieve the current state id from current url
	// We are unable to utilize "data" or "error" as CurrentPageReference is default API.
	@wire(CurrentPageReference)
	pageReference({ state }) {
		try {
			if (state && state.id) {
				this.result = state.id;
				this.titlear = '';
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
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

	// To retrieve the like response
	@wire(Checkreaction, { articlename: "$result" })
	wiredreactdata({ error, data }) {
		try {
			if (data) {
				// Assign the data to the reactive property
				if (data === likelabel) {
					this.thumbsUpIcon = Thumbsresponse;
				} else {
					this.thumbsUpIcon = THUMBS_UP_ICON;
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from apex
			}


		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from lwc
		}
	}
}