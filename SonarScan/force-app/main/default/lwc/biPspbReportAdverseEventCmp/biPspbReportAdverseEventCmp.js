// This LWC is designed for Adverse Event Main Page that contains consolidated components for avatar , message
// To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedurlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedurlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import 	supportPageUrl from '@salesforce/label/c.BI_PSPB_BRSupportPage';
import 	myCaseUrl from '@salesforce/label/c.BI_PSPB_BRMyCasePage';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
export default class BiPspbReportAdverseEventCmp extends LightningElement 
{
	// Declaration of variable with @track
	@track valueError;
	// To navigate the user to the respective Branded or Unassigned site
	connectedCallback() 
	{
		try
		{
			const currentURL = window.location.href;
			const urlObject = new URL(currentURL); // Get the path
			const path = urlObject.pathname; // Split the path using '/' as a separator
			const pathComponents = path.split('/'); // Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find(component =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
			);
			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) 
			{
				this.urlq = brandedurlNavi;
			}
			else 
			{
				this.urlq = unassignedurlNavi;
			}
		}
		catch(error)
		{
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	// To navigate to the My Support Page
	openSupportCenter() 
	{
		window.location.assign(this.urlq + supportPageUrl);
	}
	// To navigate to the My Cases Page
	openMyCases() 
	{
		window.location.assign(this.urlq + myCaseUrl);
	}
	showToast(title, message, variant) 
	{
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
	// The following event is used in the HTML file
	errorvalue(event) 
	{
		this.valueError = event.detail;
	}
}