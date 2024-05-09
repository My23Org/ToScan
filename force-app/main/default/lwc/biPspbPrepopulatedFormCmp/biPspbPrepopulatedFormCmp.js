// This consolidated component is used for prepopulating a patient information
// To import Libraries
import { LightningElement } from 'lwc';
// To import Static Resources
import BI_PSPB_Header_Spevigo from '@salesforce/resourceUrl/BI_PSPB_Header_Spevigo';
import BI_PSPB_Footer_Copyright from '@salesforce/resourceUrl/BI_PSPB_Footer_Copyright';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
export default class BiPspbPrepopulatedFormCmp extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of Global variables
	BGpp = BGpp;
	FooterSrc = BI_PSPB_Footer_Copyright;
	LOGOSrc = BI_PSPB_Header_Spevigo;
}