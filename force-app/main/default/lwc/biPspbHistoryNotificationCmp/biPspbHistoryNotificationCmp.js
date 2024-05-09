//This Consolidated component is used to display the History Notification For Patient on click of the notification icon in Dashboard
//To import the Libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import the Custom labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedUrl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import BI_PSPB_ActionUrl from '@salesforce/label/c.BI_PSPB_ActionUrl';
import BI_PSPB_messagecenterUrl from '@salesforce/label/c.BI_PSPB_messagecenterUrl';
import BI_PSPB_HistoryUrl from '@salesforce/label/c.BI_PSPB_HistoryUrl';
export default class BiPspbHistoryNotificationCmp extends LightningElement 
{
	// To fetch the URL path
	connectedCallback() 
	{
		try 
		{
			const currentURL = window.location.href;
			const urlObject = new URL(currentURL);   // Get the path
			const path = urlObject.pathname;   // Split the path using '/' as a separator
			const pathComponents = path.split('/');   // Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find(component =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
			);

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) 
			{
				this.urlq = brandedUrl;
			}
			else 
			{
				this.urlq = unassignedUrl;
			}
		}
		catch (error)
		{
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	// navigation for messagecenter page  
	openGeneral() 
	{
		window.location.assign( this.urlq + BI_PSPB_messagecenterUrl);
	}
	// navigation for action page 
	openActionReq() 
	{
		window.location.assign( this.urlq + BI_PSPB_ActionUrl);
	}
	// navigation for history
	openHistory() 
	{
		window.location.assign(this.urlq +BI_PSPB_HistoryUrl);
	}

	//This ShowToast message is used for get error
	showToast(title, message, variant) 
	{
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}