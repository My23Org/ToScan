//This is footer componenet  for all unassigned  page .
//To import library
import { LightningElement } from 'lwc';
//To import static resource
import image from '@salesforce/resourceUrl/BI_PSP_BiFooter';
//To import custom labels
import PRIVACYNOTICE from '@salesforce/label/c.BI_PSPB_PrivacyNotice';
import TERMSOFUSE from '@salesforce/label/c.BI_PSPB_TermsOfUse';
import CONTACTUS from '@salesforce/label/c.BI_PSPB_ContactUs';
export default class PspBrFooterLogo extends LightningElement {
	img = image;
	// Variable Declaration
	privacyNotice = PRIVACYNOTICE;
	termsOfUse = TERMSOFUSE;
	contactUs = CONTACTUS;
}