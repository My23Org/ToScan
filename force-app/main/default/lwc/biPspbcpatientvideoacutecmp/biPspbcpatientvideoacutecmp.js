// This lightning web component is used for display the acute treatment video and acute avatar message
// To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import landingpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
import acutepage from '@salesforce/label/c.BI_PSPB_AcuteVideoPage';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class BiPspbcpatientvideoacutecmp extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track urlq;
	// Global variables(without @track does not trigger automatic re-renders)
	siteUrlq;
	currentPageUrl;
	urlSegments;
	baseUrl;

	// To navigate to information center landing page
	openAcute() {
		window.location.assign(this.siteUrlq + landingpage);
	}

	// To navigate to information center acute video page
	opencronic() {
		window.location.assign(this.siteUrlq + acutepage);
	}

	// To render the subheader
	renderedCallback() {
		try {
			const windowWidth = window.innerWidth;
			const displayvideotab = this.template.querySelector(
				'.grid-containerTabs'
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

	// To retrieve the site name based on current url to set navigation
	connectedCallback() {
		try {
			const currentURL = window.location.href; // Create a URL object
			const urlObject = new URL(currentURL); // Get the path
			const path = urlObject.pathname; // Split the path using '/' as a separator
			const pathComponents = path.split('/'); // Find the component you need (in this case, 'Branded')
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