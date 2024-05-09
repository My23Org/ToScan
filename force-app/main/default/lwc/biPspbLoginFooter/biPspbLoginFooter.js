// To design the footer with copyright text and links in the login page
// To import Libraries
import { LightningElement } from 'lwc';
// To import Custom Labels
import PRIVACYNOTICE from '@salesforce/label/c.BI_PSPB_PrivacyNotice';
import TERMSOFUSE from '@salesforce/label/c.BI_PSPB_TermsOfUse';
import CONTACTUS from '@salesforce/label/c.BI_PSPB_ContactUs';
export default class BiPspbLoginFooter extends LightningElement {
	// Variable Declaration
	privacyNotice = PRIVACYNOTICE;
	termsOfUse = TERMSOFUSE;
	contactUs = CONTACTUS;
}