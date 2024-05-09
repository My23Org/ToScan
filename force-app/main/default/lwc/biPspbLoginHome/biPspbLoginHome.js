// This component is a Header in the Site's login page
// To import Libraries
import { LightningElement} from 'lwc';
// To import Static Resources
import HmeIcon from '@salesforce/resourceUrl/BI_PSPB_Home_Icon';
import HmeIconMobile from '@salesforce/resourceUrl/BI_PSPB_HomeIconForMobile';
//To import custom labels
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
export default class BiPspLoginHome extends LightningElement {
	// Variable Declaration
	HIcon = HmeIcon; // For Desktop 
	HIconMobile = HmeIconMobile; // For Mobile
	BRANDEDURL = brSiteUrl;
	handleYes() {
		window.location.assign(this.BRANDEDURL);
	}
}