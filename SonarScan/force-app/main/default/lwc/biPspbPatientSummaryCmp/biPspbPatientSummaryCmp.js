// To import libraries
import { LightningElement } from "lwc";
// To Import Static Resources 
import SPEVIGO_LOGO_JPEG_URL from "@salesforce/resourceUrl/BI_PSPB_Header_Spevigo";
import BIfooter_LOGO_JPEG_URL from "@salesforce/resourceUrl/BI_PSPB_Footer_Copyright";
import BGpp from "@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo";
import OLD_GUY_JPEG_URL from "@salesforce/resourceUrl/BI_PSPB_Patient_Entrollment_patient_Avater";
export default class BiPspbThankyouHcp extends LightningElement {
	BGpp = BGpp;
	FooterSrc = BIfooter_LOGO_JPEG_URL;
	LOGOSrc = SPEVIGO_LOGO_JPEG_URL;
	selectedAvatarSrc = OLD_GUY_JPEG_URL;
}