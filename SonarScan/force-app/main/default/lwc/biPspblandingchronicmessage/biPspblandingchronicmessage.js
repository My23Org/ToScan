// This lightning web component is used for display the chronic patient avatar treatment message
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import getLoggedInUserAccount from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserAccount';
import UserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver';
// To import Static Resource
import testimg from '@salesforce/resourceUrl/BI_PSPB_ProfileAvatar';
import Default_avatar_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Default_Avater_Navigation';
// To import Custom Labels
import chronicmessagemob from '@salesforce/label/c.BI_PSPB_chronicMessageMob';
import chronicmessagedesk from '@salesforce/label/c.BI_PSPB_chronicMessageDesk';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class Bipspblandingchronicmessage extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track selectedAvatarSrc;
	@track userAccounts;
	@track caregiver = false;
	// Global variables(without @track does not trigger automatic re-renders)
	cardimage = testimg;
	userid = Id;
	mbmessage1 = chronicmessagemob;

	// Method to display message for mobile
	displaymessage() {
		this.mbmessage1 = chronicmessagemob;
		this.template.querySelector('.paranew').style.display = 'block';
	}

	// Method to display message for desktop
	displayexpames() {
		this.mbmessage1 = chronicmessagedesk;
		this.template.querySelector('.paranew').style.display = 'none';
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve avatar selected by caregiver
	@wire(UserCaregiver)
	wiredavtList({ error, data }) {
		try {
			if (data) {
				if (data.length > 0) {
					this.caregiver = true;
					this.selectedAvatarSrc = data[0]?.BI_PSP_AvatarUrl__c
						? data[0]?.BI_PSP_AvatarUrl__c
						: Default_avatar_JPEG_URL;
					if (data[0]?.BI_PSP_AvatarUrl__c) {
						this.selectedAvatarSrc = data[0]?.BI_PSP_AvatarUrl__c;
					} else {
						this.selectedAvatarSrc = Default_avatar_JPEG_URL;
					}
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	
	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the avatar selected by patient
	@wire(getLoggedInUserAccount)
	wiredUserAccounts({ error, data }) {
		try {
			if (data) {
				this.userAccounts = data;
				if (this.caregiver === false) {
					if (this.userAccounts[0]?.BI_PSP_AvatarUrl__c) {
						this.selectedAvatarSrc = this.userAccounts[0]?.BI_PSP_AvatarUrl__c;
					} else {
						this.selectedAvatarSrc = Default_avatar_JPEG_URL;
					}
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// showToast used for all the error messages caught
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}