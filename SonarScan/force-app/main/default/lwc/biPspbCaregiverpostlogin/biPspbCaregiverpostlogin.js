//This lightning web component is used to select the patient for Caregiver
//to Import the Libraries
import { LightningElement, track, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//to Import the UserId
import USER_ID from "@salesforce/user/Id";
//to Import the Apex Class
import getCaregiverAccounts from "@salesforce/apex/BI_PSPB_PatientDetailsCtrl.getCaregiverAccounts";
import UserCaregiver from "@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver";
import checkcaregiverpatientstatus from "@salesforce/apex/BI_PSPB_avatarCtrl.checkCaregiverPatientStatus";
import updateSelectedPatientID from "@salesforce/apex/BI_PSPB_PatientDetailsCtrl.updateSelectedPatientID";
import NAME_FIELD from "@salesforce/schema/User.Name";
//To import the Custom Labels
import UnassignedSiteURL from "@salesforce/label/c.BI_PSPB_UnassignedSiteURL";
import brSiteUrl from "@salesforce/label/c.BI_PSPB_BrandedSiteURL";
import errormessage from "@salesforce/label/c.BI_PSP_ConsoleError";
import errorvariant from "@salesforce/label/c.BI_PSPB_errorVariant";
import Unassigned from "@salesforce/label/c.BI_PSP_Unassigned";
import Acute from "@salesforce/label/c.BI_PSPB_Acute";
import AcuteDashboard from "@salesforce/label/c.BI_PSPB_AcuteDashboard";
import dashboard from "@salesforce/label/c.BI_PSPB_Dashboad";
import CaregiverAvatarSelection from "@salesforce/label/c.BI_PSPB_CaregiverFirstAvatar";
import AccessBlocked from "@salesforce/label/c.BI_PSPB_Access_Blocked";
import CaregiverAccess from "@salesforce/label/c.BI_PSPB_CaregiverAccess";
import Active from "@salesforce/label/c.BI_PSP_Active";
const fields = [NAME_FIELD];
export default class BiPspbCaregiverpostlogin extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Declaration of varaiable with @track
	@track showDetails = false;
	@track showMessage = false;
	@track messageHeader = "";
	@track messageBody = "";
	@track showselect = false;
	@track showblock = false;
	@track selectedAccountId = "";
	@track cargiverId = "";
	@track Status;
	@track caregiverAccounts = [];
	//Declaration of varaiable
	statusMap = new Map();
	status;
	loginattempt;
	userId = USER_ID;
	// get user name
	@wire(getRecord, { recordId: "$userId", fields })
	user;

	get name() {
		return getFieldValue(this.user.data, NAME_FIELD);
	}

	//To fetch the data from caregivers patient
	@wire(getCaregiverAccounts, { userId: "$userId" })
	wiredCaregiverAccounts({ error, data }) {
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data) {
			try {
				this.caregiverAccounts = data.map((patient) => ({
					Id: patient.Id,
					Name: patient.Name,
					status: patient.Status,
					login: patient.BI_PSP_Loginattempt__c,
					caregiverId: patient.CaregiveID,
					initial:
						patient?.Name?.split(" ").map((name) => name[0]).length >= 2
							? (
								patient.Name.split(" ").map((name) => name[0])[0] +
								patient.Name.split(" ").map((name) => name[0])[1]
							).toUpperCase()
							: patient.Name.split(" ")
								.map((name) => name[0])[0]
								.toUpperCase(),
					showSelectButton: false,
					showBlockMessage: false,
					blockMessageHeader: AccessBlocked,
					blockMessageBody: CaregiverAccess
				}));
				this.caregiverAccounts.forEach((account) => {
					this.statusMap.set(account.Id, account.status);
				});

				if (this.caregiverAccounts.length > 0) {
					this.validateButtonDisplay();
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}

	// To fetch the data form caregiver data
	@wire(getCaregiverAccounts, { userId: "$userId" })
	wiredPatientDetails({ error, data }) {
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data) {
			try {
				this.caregiverAccounts = data.map((account) => ({
					Id: account.Id,
					Name: account.Name
				}));
				if (this.isSingleAccount) {
					this.selectedAccountId = this.caregiverAccounts[0].Id;
					this.showDetails = true;
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}

	// to fetch the data from caregiver
	@wire(UserCaregiver)
	wiredavtList({ error, data }) {
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data) {
			try {
				// Assign the data to the reactive property
				if (data.length > 0) {
					this.loginattempt = data[0].BI_PSP_Loginattempt__c;
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			// Handle error appropriately
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	// connect callback used for to check caregivers patient
	connectedCallback() {
		try {
			if (this.caregiverAccounts.length > 0) {
				this.selectedAccountId = this.caregiverAccounts[0].Id;
				this.showDetails = true;
				this.showPatientPrompt();
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}
	//Validate patient status
	validateButtonDisplay() {
		this.caregiverAccounts.forEach((account) => {
			const selectedAccountStatus = this.statusMap.get(account.Id);

			if (selectedAccountStatus === Active) {
				account.showSelectButton = true;
			} else {
				account.showBlockMessage = true;
			}
		});
	}

	async handleViewDetails(event) {
		this.selectedAccountId = event.target.dataset.id;
		this.cargiverId = this.caregiverAccounts[0]?.caregiverId;
		console.log(this.cargiverId)
		console.log(this.selectedAccountId)
		// update the
		updateSelectedPatientID({
			UserID: this.cargiverId,
			SelectedAccountId: this.selectedAccountId
		
		}) 
		// Null data is checked and AuraHandledException is thrown from the Apex
		// Use newAvatarSrc
			.then(() => { })
			.catch((error) => {
				// Handle error or show an error message
				this.showToast(errormessage, error.message, errorvariant);
			});

		UserCaregiver()
		// Null data is checked and AuraHandledException is thrown from the Apex
			.then((result) => {
				if (result && result.length > 0) {
					this.loginattempt = result[0].BI_PSP_Loginattempt__c;
					checkcaregiverpatientstatus()
					// Null data is checked and AuraHandledException is thrown from the Apex
						.then((patientStatusResult) => {
							if (patientStatusResult && patientStatusResult.length > 0) {
								this.status = patientStatusResult[0].BI_PSPB_PatientStatus__c;
								if (this.loginattempt === 0) {
									window.location.assign(brSiteUrl + CaregiverAvatarSelection);
								} else if (
									this.loginattempt === 1 &&
									this.status === Unassigned
								) {
									window.location.assign(UnassignedSiteURL);
								} else if (this.loginattempt === 1 && this.status === Acute) {
									window.location.assign(UnassignedSiteURL + AcuteDashboard);
								} else {
									window.location.assign(brSiteUrl + dashboard);
								}
							}
						})
						.catch((patientStatusError) => {
							this.showToast(
								errormessage,
								patientStatusError.message,
								errorvariant
							);
						});
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//This ShowToast Message is used for get error
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}