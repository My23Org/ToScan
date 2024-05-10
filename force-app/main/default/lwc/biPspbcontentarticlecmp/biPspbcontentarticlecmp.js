// This lightning web component is used for display the article detail content with all child components
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import landingpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
import acutepage from '@salesforce/label/c.BI_PSPB_AcuteVideoPage';
import chronicpage from '@salesforce/label/c.BI_PSPB_chronicVideoPage';
import statusacute from '@salesforce/label/c.BI_PSPB_Acute';
import statuschronic from '@salesforce/label/c.BI_PSPB_statusChronic';
import statusunassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbcontentarticlecmp extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track urlq;
	@track showvideo = true;
	@track patientstatusval = '';
	// Global variables(without @track does not trigger automatic re-renders)
	currentPageUrl;
	urlSegments;
	baseUrl;
	siteUrlq;
	userId = Id;

	// To navigate informationcenterlandingpage
	openArticlesPage() {
		window.location.assign(this.siteUrlq + landingpage);
	}

	// To navigate Acute and Chronic video page
	openPTVPage() {
		if (this.patientstatusval === statusacute) {
			window.location.assign(this.siteUrlq + acutepage);
		} else if (this.patientstatusval === statuschronic) {
			if (this.urlq === brandedurl) {
				window.location.assign(this.siteUrlq + chronicpage);
			} else {
				window.location.assign(this.siteUrlq + acutepage);
			}
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	//  To get patient status value of current logged in user
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;
				if (this.patientstatusval === statusunassigned) {
					this.showvideo = false;
				}
			} else if (error) {
				// Handle the error
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To get the site name from current site url
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

	// To render sub header of article detail page
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
			} else if (displayvideotab) {
					displayvideotab.style.display = '';
				}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
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