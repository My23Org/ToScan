// This component is consolidate component used for avatar,message and prepopulate form.
//To import Libraries
import { LightningElement, track } from 'lwc';
//To import Static Resource
import SPEVIGO_LOGO_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Header_Spevigo';
import BIfooter_LOGO_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Footer_Copyright';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
import OLD_GUY_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Patient_Entrollment_patient_Avater';
import caregiverImg from '@salesforce/resourceUrl/BI_PSPB_PrepopulatedAvatar';
export default class biPspbPrepopulatedSummaryCMP extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Declaration of variables with @track
	@track caregivervalue = false;
	// Declaration of Global variables
	BGpp = BGpp;
	FooterSrc = BIfooter_LOGO_JPEG_URL;
	LOGOSrc = SPEVIGO_LOGO_JPEG_URL;
	selectedAvatarSrc = OLD_GUY_JPEG_URL;
	selectAvatar = caregiverImg;
	//To change avatar content based on patient
	avatarvalue(event) {
		this.caregivervalue = event.detail;

	}

}