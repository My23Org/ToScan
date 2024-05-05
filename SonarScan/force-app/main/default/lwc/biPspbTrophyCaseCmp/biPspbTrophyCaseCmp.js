//This is consolidated component for trophy case page,which have a trophy coponent as a child and Avatar navigation as a child
//To import libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//To import custom labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import errormessage from "@salesforce/label/c.BI_PSP_ConsoleError";
import errorvariant from "@salesforce/label/c.BI_PSPB_errorVariant";
import urlSlash from "@salesforce/label/c.BI_PSP_ChatterSlash";
import siteSlash from "@salesforce/label/c.BI_PSP_Slashsite";
import brChallengesSiteUrl from "@salesforce/label/c.BI_PSP_challengesURL";
import brtrophyCaseSiteUrl from "@salesforce/label/c.BI_PSP_trophyCaseURL";

export default class BiPspbTrophyCaseCmp extends LightningElement {
	//Declare the variables
	urlq;
	slashUrl = urlSlash;
	slashSite = siteSlash;
	siteChallengesUrlBranded = brChallengesSiteUrl;
	siteTrophyCaseUrlBranded = brtrophyCaseSiteUrl;

	//Used to get the current url and to process the url to fetch the site name accordingly
	connectedCallback() {
		try {
			const currentURL = window.location.href;
			const urlObject = new URL(currentURL); // Create a URL object
			const path = urlObject.pathname; // Get the path
			const pathComponents = path.split('/'); // Split the path using '/' as a separator
			const desiredComponent = pathComponents.find(component =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
			);  // Find the component you need (in this case, 'Branded')

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurl;
			}
			else {
				this.urlq = unassignedurl;
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	//this event is used for navigation to challenges page
	openChallenges() {
		window.location.assign(this.slashUrl + this.urlq + this.slashSite + this.siteChallengesUrlBranded);
	}
	//this event is used for navigation to Trophy page
	openTrophyCase() {
		window.location.assign(this.slashUrl + this.urlq + this.slashSite + this.siteTrophyCaseUrlBranded);
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