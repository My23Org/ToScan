// This footer component provides additional information in questionnaire pages.
// To import Libraries
import { LightningElement } from 'lwc';
// To import Static Resources
import imageForFooter from '@salesforce/resourceUrl/BI_PSP_BiFooter';
// To import Custom Labels
import ContactUs from '@salesforce/label/c.BI_PSPB_ContactUs';
import TermsOfUse from '@salesforce/label/c.BI_PSPB_TermsOfUse';
import PrivacyNotice from '@salesforce/label/c.BI_PSPB_PrivacyNotice';
export default class BiPspbFooterLogoQuestionnaire extends LightningElement {
	// Declaration of Global variables
	imageOfLogo = imageForFooter;
	linkForContactUs = ContactUs;
	linkForTermsOfUse = TermsOfUse;
	linkForPrivacyNotie = PrivacyNotice;
}