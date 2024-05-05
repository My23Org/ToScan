// This lightning web component is used to display the landing avatar message in the Information Center Landing Page
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Static Resources
import testimg from '@salesforce/resourceUrl/BI_PSPB_ProfileAvatar';
//  To import Apex Classes
import UserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver';
import getLoggedInUserAccount from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserAccount';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import unassignedstatus from '@salesforce/label/c.BI_PSP_Unassigned';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class BiPspblandingpagemessage extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track urlq;
	@track currentPageUrl;
	@track urlSegments;
	@track baseUrl;
	@track showbrandednav = true;
	@track patientstatusval = '';
	@track userId = Id;
	@track caregiver = false;
	// Declaration of Global variables
	userAccounts;
	cardimage = '';

	
	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retirieve the staus value of a Patient
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To set the property of para element if the status is unassigned
	renderedCallback() {
		try {
			if (this.patientstatusval === unassignedstatus) {
				// Assuming you have a paragraph element with the class para
				let paraElement = this.template.querySelector(".para");
				// Check if the element with the class para exists
				if (paraElement) {
					if (window.innerWidth > 1115) {
						// Set the top property to 10%
						// Double quotes is used to render the CSS value - Unavoidable
						paraElement.style.marginTop = "-27px";
					}
				}
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// To retireve current URL, based on that navigation will be set
	connectedCallback() {
		try {
			const currentURL = window.location.href;

			// Create a URL object
			const urlObject = new URL(currentURL);

			// Get the path
			const path = urlObject.pathname;

			// Split the path using '/' as a separator
			const pathComponents = path.split("/");

			// Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find((component) =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
					component.toLowerCase()
				)
			);

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurl;
			} else {
				this.urlq = unassignedurl;
			}
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split("/");
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;

			if (this.urlq === brandedurl) {
				this.showbrandednav = true;
			} else {
				this.showbrandednav = false;
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	
	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retireve the Avatar of the Caregiver
	@wire(UserCaregiver)
	wiredavtList({ error, data }) {
		try {
			if (data) {
				if (data.length > 0) {
					this.caregiver = true;
					this.cardimage = data[0]?.BI_PSP_AvatarUrl__c
						? data[0]?.BI_PSP_AvatarUrl__c
						: testimg;
					if (data[0]?.BI_PSP_AvatarUrl__c) {
						this.cardimage = data[0]?.BI_PSP_AvatarUrl__c;
					} else {
						this.cardimage = testimg;
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
	// To retireve the Avatar of the Patient
	@wire(getLoggedInUserAccount)
	wiredUserAccounts({ error, data }) {
		try {
			if (data) {
				this.userAccounts = data;
				if (this.caregiver === false) {
					if (this.userAccounts[0]?.BI_PSP_AvatarUrl__c) {
						this.cardimage = this.userAccounts[0]?.BI_PSP_AvatarUrl__c;
					} else {
						this.cardimage = testimg;
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