// This Lwc is used for Parent component to display footer links
// To import Libraries
import { LightningElement } from 'lwc';
// To Import Custom Labels
import privacyUrl from '@salesforce/label/c.BI_PSPB_BRPrivacyUrl';
import termsUrl from '@salesforce/label/c.BI_PSPB_BRTermsUrl';
import contactUrl from '@salesforce/label/c.BI_PSPB_BRContactUrl';

export default class BiPspbFooterQuickLinks extends LightningElement {
	//navigation
	openPrivacyNotice() {
		window.location.assign(privacyUrl);
	}
	openTerms() {
		window.location.assign(termsUrl);
	}
	openContactUs() {
		window.location.assign(contactUrl);
	}
}