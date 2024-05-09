import { LightningElement } from "lwc";
//To import Static resources
import homeIcon from "@salesforce/resourceUrl/BI_PSPB_Home_Icon";
import spevigoLogo from "@salesforce/resourceUrl/BI_PSPB_Header_Spevigo";
import biFooterLogo from "@salesforce/resourceUrl/BI_PSPB_Footer_Copyright";
import beyondGpp from "@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo";

export default class PspBrPatientEnrollemtCmp extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	homeIcon = homeIcon;
	beyondGpp = beyondGpp;
	footerSrc = biFooterLogo;
	logoSrc = spevigoLogo;
}