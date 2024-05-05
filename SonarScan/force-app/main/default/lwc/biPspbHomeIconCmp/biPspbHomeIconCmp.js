// This lightning web component is used for Homeicon 
// To import Libraries
import { LightningElement } from 'lwc';
// To import Static Resources
import HmeIcon from '@salesforce/resourceUrl/BI_PSPB_Home_Icon';
import HmeIconMobile from '@salesforce/resourceUrl/BI_PSPB_HomeIconForMobile';
// To Import Custom Labels
import brandedsite from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';

export default class BiPspbHomeIconCmp extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of Global variables
	HIcon = HmeIcon;
	HIconMobile = HmeIconMobile;
	openModal;

	openhome() {
		this.openModal = true;
	}

	handleYes() {
		window.location.assign(brandedsite);
	}

	handleNo() {
		this.openModal = false;
	}
}