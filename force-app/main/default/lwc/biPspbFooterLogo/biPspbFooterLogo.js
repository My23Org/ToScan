import { LightningElement } from 'lwc';
//To import an image for logo in footer.
import imageForFooter from '@salesforce/resourceUrl/BI_PSP_BiFooter';
//To import Links for ContactUs,TermsOfUse and PrivacyNotice pages.
import ContactUs from '@salesforce/label/c.BI_PSPB_ContactUs';
import TermsOfUse from '@salesforce/label/c.BI_PSPB_TermsOfUse';
import PrivacyNotice from '@salesforce/label/c.BI_PSPB_PrivacyNotice';
export default class PspBrFooterLogo extends LightningElement {
	//Assigning all imported variables to a variable to use in HTML.
	imageOfLogo = imageForFooter;
	linkForContactUs = ContactUs;
	linkForTermsOfUse = TermsOfUse;
	linkForPrivacyNotie = PrivacyNotice;
}