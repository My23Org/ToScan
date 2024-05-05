// This LWC serves as a landing page for a symptom tracker, offering options to create new entries and displaying a happy face image. 
// It dynamically determines the URL based on the current page and navigates users accordingly.
// To import Libraries
import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Static Resources
import HAPPY from '@salesforce/resourceUrl/BI_PSP_Emptygraph';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import symptommainpageurl from '@salesforce/label/c.BI_PSPB_symptomtrackermainpage';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import Slash from '@salesforce/label/c.BI_PSPB_Slash';

export default class BiPspsymtomtrackerlandingpage extends NavigationMixin(LightningElement) {
//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	@track emptyGraph = HAPPY;
	//This method is called when the component is connected to the DOM.
	connectedCallback() {
		try{
		const currentURL = window.location.href;
		// Create a URL object
		const urlObject = new URL(currentURL);
		// Get the path
		const path = urlObject.pathname;
		// Split the path using '/' as a separator
		const pathComponents = path.split(Slash);
		// Find the component you need (in this case, 'Branded')
		const desiredComponent = pathComponents.find(component =>
			[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
		);
		if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
			this.urlq = brandedUrlNavi;
		}
		else {
			this.urlq = unAssignedUrlNavi;
		}
	}
	catch(error){
		this.showToast(errormessage, error.message, errorvariant);
	}
}
	openentrydate() {
		window.location.assign(this.urlq + symptommainpageurl)
		localStorage.clear()
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