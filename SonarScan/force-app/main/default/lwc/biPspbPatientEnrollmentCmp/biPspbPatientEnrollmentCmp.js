// To import libraries
import { LightningElement } from 'lwc';
// To Import Static Resources 
import BI_PSPB_Header_Spevigo from '@salesforce/resourceUrl/BI_PSPB_Header_Spevigo';
import BI_PSPB_Footer_Copyright from '@salesforce/resourceUrl/BI_PSPB_Footer_Copyright';
export default class BiPspbPatientEnrollmentCmp extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	FooterSrc = BI_PSPB_Footer_Copyright;
	LOGOSrc = BI_PSPB_Header_Spevigo;
}