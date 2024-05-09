import { LightningElement } from 'lwc';
// Imports resourceUrl to reference external resources for proper rendering and functionality.
import OLD_GUY_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_HCP_Entrollment_patient_Avater';
import SPEVIGO_LOGO_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Header_Spevigo';
import BIfooter_LOGO_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Footer_Copyright';
import jqueryboots from '@salesforce/resourceUrl/BI_PSP_jquerybootsjs';
import Bootstrap from '@salesforce/resourceUrl/BI_PSP_Bootstrap';
import customStyles from '@salesforce/resourceUrl/BI_PSP_CustomStyle';
// Imports labels for descriptive text or identifiers, enhancing accessibility and user understanding.
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
// Imports showToastEvent to display notification messages, informing users about component actions or events.
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// Imports loadStyle to dynamically apply CSS stylesheets, facilitating component customization and styling updates without page reloads.
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class biPspbThankyoumsgAvatar extends LightningElement {

	selectedAvatarSrc = OLD_GUY_JPEG_URL;
	LOGOSrc = SPEVIGO_LOGO_JPEG_URL;
	FooterSrc = BIfooter_LOGO_JPEG_URL;
	//rendercall callback//
	renderedCallback() {
		Promise.all([
			loadScript(this, Bootstrap + '/bootstrap-5.0.2-dist/js/bootstrap.js'),
			loadScript(this, jqueryboots),
			loadStyle(this, Bootstrap + '/bootstrap-5.0.2-dist/css/bootstrap.css'),
			loadStyle(this, customStyles)
		]).then(() => {
		})
			.catch(err => {
				this.showToast(errormessage, err.message, errorvariant);
			});
	}
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}

}