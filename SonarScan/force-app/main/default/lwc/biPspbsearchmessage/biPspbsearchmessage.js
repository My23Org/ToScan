// This lightning web component is used to display the avatar message in the Information Center search article Page
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import UserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver';
import getLoggedInUserAccount from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserAccount';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
// To import Static Resource
import testimg from '@salesforce/resourceUrl/BI_PSPB_ProfileAvatar';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbsearchmessage extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track urlq;
	@track currentPageUrl;
	@track urlSegments;
	@track baseUrl;
	@track showbrandednav = true;
	@track patientstatusval = '';
	@track userId = Id;
	@track caregiver = false;
	// Global variables(without @track does not trigger automatic re-renders)
	userAccounts;
	cardimage = '';

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retirieve the staus value of a Patient
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
		if (data && data.length>0) {
			this.patientstatusval = data;
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		}
		} catch (err) {
		this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
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
		const pathComponents = path.split('/');

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
		this.urlSegments = this.currentPageUrl.split('/');
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
		if (data && data.length>0) {
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
		if (data && data.length>0) {
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