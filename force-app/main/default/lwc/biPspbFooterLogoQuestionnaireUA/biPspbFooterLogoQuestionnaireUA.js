// This footer component provides additional information in unassigned questionnaire pages.
// To import Libraries
import { LightningElement } from 'lwc';
// To import Static Resources
import image from '@salesforce/resourceUrl/BI_PSP_BiFooter';
// To import Custom Labels
import PRIVACYNOTICE from '@salesforce/label/c.BI_PSPB_PrivacyNotice';
import TERMSOFUSE from '@salesforce/label/c.BI_PSPB_TermsOfUse';
import CONTACTUS from '@salesforce/label/c.BI_PSPB_ContactUs';
export default class BiPspbFooterLogoQuestionnaireUA extends LightningElement {
	// Declaration of Global variables
	img = image;
	privacyNotice = PRIVACYNOTICE;
	termsOfUse = TERMSOFUSE;
	contactUs = CONTACTUS;
}