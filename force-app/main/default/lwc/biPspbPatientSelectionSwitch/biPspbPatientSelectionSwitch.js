/*This lightning web component displays which patient to select and navigate once caregiver logs in*/
//To import Libraries
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex Classes
import updateSwitchSelectedPatientID from '@salesforce/apex/BI_PSPB_PatientDetailsCtrl.updateSwitchSelectedPatientID';
import getcaregiverAccountforSwitch from '@salesforce/apex/BI_PSPB_PatientDetailsCtrl.getcaregiverAccountforSwitch';
//To import Custom labels
import switchIcon from '@salesforce/resourceUrl/BI_PSP_SwitchIcon';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class BiPspbPatientSelectionSwitch extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@api caregiverid;
	@api patientname;
	@api patientid;

	//Global variables(without @track does not trigger automatic re-renders)
	selectedAccountId;
	switchIcon = switchIcon;
	showSwitchIcon;
	currentPageUrl;
	urlSegments;
	baseUrl;
	showPopup;

	//To get the available patient for the logged in caregiver
	connectedCallback() {
		this.currentPageUrl = window.location.href;
		this.urlSegments = this.currentPageUrl.split('/');
		this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
		try {
			getcaregiverAccountforSwitch({ accountId: this.caregiverid }) // Use newAvatarSrc
				.then(result => {
					if (result != null) {
						if (result.BI_PSPB_Selected_Patient_ID__c === this.patientid && result.BI_PSPB_CaregiverCheck__c === true) {
							this.showSwitchIcon = true;
						}
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
				});
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//To add style for selected patient
	get getstyleforPatient() {
		return this.showSwitchIcon ? 'MenuProfile headMenu' : 'MenuProfile';
	}
	//To display the popup
	openShowPopup() {
		this.showPopup = true;
	}
	//To close the popup
	handleClose() {
		this.showPopup = false;
	}
	//To update the selected patient
	updateSwitchPatient() {
		this.selectedAccountId = this.patientid;

		updateSwitchSelectedPatientID({ UserID: this.caregiverid, SelectedAccountId: this.selectedAccountId, check: true }) // Use newAvatarSrc
			.then(() => {

			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
			});

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