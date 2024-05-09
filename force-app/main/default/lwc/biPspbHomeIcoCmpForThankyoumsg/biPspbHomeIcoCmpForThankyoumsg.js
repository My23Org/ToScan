// This lightning web component is used for Homeicon in Thankyou msg Page
// To import Libraries
import { LightningElement } from 'lwc';
// To import Static Resources
import HmeIcon from '@salesforce/resourceUrl/BI_PSPB_Home_Icon';
import HmeIconMobile from '@salesforce/resourceUrl/BI_PSPB_HomeIconForMobile';
import brandedurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
export default class biPspbHomeIcoCmpForThankyoumsg extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of Global variables
	HIcon = HmeIcon;
	HIconMobile = HmeIconMobile;
	openModal;

	openhome() {
		this.openModal = true;
	}

	handleYes() {
		window.location.assign(brandedurl);
	}

	handleNo() {
		this.openModal = false;
	}
}