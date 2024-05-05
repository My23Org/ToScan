// This LWC is designed for support center main page
// To import Libraries
import { LightningElement, track} from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Static Resources
import MedicalInformation from '@salesforce/resourceUrl/BI_PSP_Medical_Information_img';
import ReportAdverse from '@salesforce/resourceUrl/BI_PSP_Report_Adverse_img';
import platformsupport from '@salesforce/resourceUrl/BI_PSP_PSP_platform_support';
import emailimg from '@salesforce/resourceUrl/BI_PSPB_Mail';
import arrow from "@salesforce/resourceUrl/BI_PSPB_BackArrow";
import phnimg from '@salesforce/resourceUrl/BI_PSPB_Phone';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import miePage from '@salesforce/label/c.BI_PSPB_BRMIEPage';
import raePage from '@salesforce/label/c.BI_PSPB_BRRAEPage';
import pspPage from '@salesforce/label/c.BI_PSPB_BRPLSPage';
import brandedurlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedurlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class biPspbSupportCenter extends NavigationMixin(LightningElement)
{
//Proper naming conventions with camel case for all the variable will be followed in the future releases
// Declaration of variables with @track
@track isFormVisible = false;
@track isFormVisible1 = false;
@track isFormVisible2 = false;
@track isFormVisible3 = false;
@track buttonLabel = 'Show Form'; // Initial label
@track field1 = '';
@track field2 = '';
@track subtyperror =false;
@track descriptionerror =false;
@track subtyperror1 =false;
@track descriptionerror1 =false;
@track descriptionerror2  = false;
@track files = [];
@track back=false;
// The following are invoked from CSS
@track class1='buttonbox';
@track class2='buttonbox';
@track class3='buttonbox';
@track class4='buttonbox';
@track class5='desc';
@track class6='desc';
@track class7='desc';
@track contact = true;
@track showcollectbutton =true; 
@track caseType;
// Declaration of variables
MedicalInformation=MedicalInformation;
ReportAdverse=ReportAdverse;
platformsupport=platformsupport
backarrow=arrow;
Phnimg=phnimg;
Emailimg=emailimg;
/* This method is used to navigate a user to the respective Unassigned or Branded*/
connectedCallback() 
{
try
{
	const currentURL = window.location.href;
	// Create a URL object
	const urlObject = new URL(currentURL);

	// Get the path
	const path = urlObject.pathname;

	// Split the path using '/' as a separator
	const pathComponents = path.split('/');

	// Find the component you need (in this case, 'Branded')
	const desiredComponent = pathComponents.find(component =>
	[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
	);

	if(desiredComponent.toLowerCase()===brandedurl.toLowerCase())
	{
		this.urlq=brandedurlNavi;
	}
	else
	{
		this.urlq=unassignedurlNavi;
	}
}
catch(error)
{
	this.showToast(errormessage, error.message, errorvariant);
}
}
// To navigate to Medical Information Enquiry page
medicalInformationtoggle(event) 
{
this.caseType = event.currentTarget.dataset.value;
window.location.assign(this.urlq+miePage);
}
// To navigate to Report Adverse Event page
reportAdverseEventstoggle(event) 
{
this.caseType = event.currentTarget.dataset.value;
	window.location.assign(this.urlq+raePage);
}
// To navigate to Platform Support page
platformSupporttoggle(event) 
{
this.caseType = event.currentTarget.dataset.value;      
window.location.assign(this.urlq+pspPage);
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
}