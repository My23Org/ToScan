//This lightning web component is used as parent component to display the recent articles and landing avatar message
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
// To import Static Resource
import landingdkimage from '@salesforce/resourceUrl/BI_PSPB_Landingimg';
import landingmbimage from '@salesforce/resourceUrl/BI_PSPB_Landingimgmb';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import landingpageinfocenter from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
import statusunassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import statusacute from '@salesforce/label/c.BI_PSPB_Acute';
import chronicvideopage from '@salesforce/label/c.BI_PSPB_chronicVideoPage';
import acutevideopage from '@salesforce/label/c.BI_PSPB_AcuteVideoPage';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspblandinginfocentercmp extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track patientstatusval = '';
	@track showtreatvideo = false;
	@track urlq;
	// Global variables(without @track does not trigger automatic re-renders)
	imagemob = landingmbimage;
	userId = Id;
	imagedesktop = landingdkimage;
	currentPageUrl;
	urlSegments;
	baseUrl;
	siteUrlq;

	// To navigate landing informaton center page
	openArticlesPage() {
		window.location.assign(this.siteUrlq + landingpageinfocenter);
	}

	// To navigate Acute or Chronic video page based on patient status
	openPTVPage() {
		if (this.urlq !== brandedurl) {
				window.location.assign(this.siteUrlq + acutevideopage);

		} else if (this.patientstatusval === statusacute) {
				window.location.assign(this.siteUrlq + acutevideopage);
			} else {
				window.location.assign(this.siteUrlq + chronicvideopage);
			}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the patient status (acute or chronic or unassigned)
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;

				if (this.patientstatusval === statusacute) {
					this.showtreatvideo = true;
				} else if (this.patientstatusval === statusunassigned) {
					this.showtreatvideo = false;
				} else {
					this.showtreatvideo = true;
				}
				// Handle the data
			} else if (error) {
				// Handle the error
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			} else {
				this.showtreatvideo = true;
				this.patientstatusval = statusacute;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To retrieve current site url
	connectedCallback() {
		try {
			const currentURL = window.location.href;

			// Create a URL object
			const urlObject = new URL(currentURL);

			// Get the path
			const path = urlObject.pathname;

			// Split the path using '/' as a separator
			const pathComponents = path.split('/');

			// Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find((component) =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
					component.toLowerCase()
				)
			);

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurl;
				this.siteUrlq = brandedsiteurl;
			} else {
				this.urlq = unassignedurl;
				this.siteUrlq = unassignedsiteurl;
			}
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split('/');
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// To render the subheader tab
	renderedCallback() {
		try {
			const windowWidth = window.innerWidth;
			const displayvideotab = this.template.querySelector(
				'.grid-containerNavTab'
			);

			if (windowWidth <= 1000) {
				if (displayvideotab) {
					displayvideotab.style.display = 'none';
				}
			} else {
				if (displayvideotab) {
					displayvideotab.style.display = '';
				}
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
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