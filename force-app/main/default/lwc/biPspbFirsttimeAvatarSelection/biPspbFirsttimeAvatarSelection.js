import { LightningElement, track, wire } from 'lwc';
// Importing Apex classes to interact with Salesforce backend for data retrieval.
import checkpatientstatus from '@salesforce/apex/BI_PSPB_avatarCtrl.checkPatientStatus';
import getLoggedInUserAccounts from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserAccount';
import getLoggedInUserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserCaregiver';
import LoggedUser from '@salesforce/apex/BI_PSPB_avatarCtrl.loggedUser';
import updateAccountAvatar from '@salesforce/apex/BI_PSPB_avatarCtrl.updateAccountAvatar';
import updateLoginAttempt from '@salesforce/apex/BI_PSPB_avatarCtrl.updateLoginAttempt';
import UserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver';
import updateLoginAttemptcaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.updateLoginAttemptcaregiver';
// Imports resourceUrl to reference external resources for proper rendering and functionality.
import BI_PSPB_Adult_afro_man from '@salesforce/resourceUrl/BI_PSPB_AfroMan_Adult';
import BI_PSPB_Adult_afro_Woman from '@salesforce/resourceUrl/BI_PSPB_AfroWomen_Adult';
import BI_PSPB_Adult_arab_man from '@salesforce/resourceUrl/BI_PSPB_ArabMen_Adult';
import BI_PSPB_Adult_arab_woman from '@salesforce/resourceUrl/BI_PSPB_ArabWoman_Adult';
import BI_PSPB_Adult_asian_man from '@salesforce/resourceUrl/BI_PSPB_AsianMan_Adult';
import BI_PSPB_Adult_asian_woman from '@salesforce/resourceUrl/BI_PSPB_AsianWoman_Adult';
import BI_PSPB_Adult_caucasian_man from '@salesforce/resourceUrl/BI_PSPB_CaucasianMan_Adult';
import BI_PSPB_Adult_caucasian_woman from '@salesforce/resourceUrl/BI_PSPB_CaucasianWoman_Adult';
import BI_PSPB_Adult_indian_man from '@salesforce/resourceUrl/BI_PSPB_IndianMen_Adult';
import BI_PSPB_Adult_indian_woman from '@salesforce/resourceUrl/BI_PSPB_IndianWoman_Adult';
import BI_PSPB_Adult_latino_man from '@salesforce/resourceUrl/BI_PSPB_LatinoMan_Adult';
import BI_PSPB_Adult_latino_woman from '@salesforce/resourceUrl/BI_PSPB_LatinoWoman_Adult';
import BI_PSPB_Elder_adult_afro_man from '@salesforce/resourceUrl/BI_PSPB_AfroMan_ElderAdult';
import BI_PSPB_Elder_adult_afro_woman from '@salesforce/resourceUrl/BI_PSPB_AfroWomen_ElderAdult';
import BI_PSPB_Elder_adult_arab_man from '@salesforce/resourceUrl/BI_PSPB_ArabMen_ElderAdult';
import BI_PSPB_Elder_adult_arab_woman from '@salesforce/resourceUrl/BI_PSPB_ArabWoman_ElderAdult';
import BI_PSPB_Elder_adult_asian_man from '@salesforce/resourceUrl/BI_PSPB_AsianMan_ElderAdult';
import BI_PSPB_Elder_adult_asian_woman from '@salesforce/resourceUrl/BI_PSPB_AsianWoman_ElderAdult';
import BI_PSPB_Elder_adult_caucasian_man from '@salesforce/resourceUrl/BI_PSPB_CaucasianMan_ElderAdult';
import BI_PSPB_Elder_adult_caucasian_woman from '@salesforce/resourceUrl/BI_PSPB_CaucasianWoman_ElderAdult';
import BI_PSPB_Elder_adult_indian_men from '@salesforce/resourceUrl/BI_PSPB_IndianMen_ElderAdult';
import BI_PSPB_Elder_adult_indian_woman from '@salesforce/resourceUrl/BI_PSPB_IndianWoman_ElderAdult';
import BI_PSPB_Elder_adult_latino_man from '@salesforce/resourceUrl/BI_PSPB_LatinoMan_ElderAdult';
import BI_PSPB_Elder_adult_latino_woman from '@salesforce/resourceUrl/BI_PSPB_LatinoWoman_ElderAdult';
// Imports labels for descriptive text or identifiers, enhancing accessibility and user understanding.
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import Questionnaires1 from '@salesforce/label/c.BI_PSPB_Questionnaires1';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import UnassignedSiteURL from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import Unassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import Acute from '@salesforce/label/c.BI_PSPB_Acute';
import AcuteDashboard from '@salesforce/label/c.BI_PSPB_AcuteDashboard';
import dashboard from '@salesforce/label/c.BI_PSPB_Dashboad';

export default class biPspbFirsttimeAvatarSelection extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@track Avatareimg;
	@track Avatareimg1;
	@track isLoading = true;
	@track isLoading1 = true;
	@track loggedPatient;
	@track imageClass11 = [
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_afro_man, dataid: 1 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_afro_Woman, dataid: 2 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_arab_man, dataid: 3 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_arab_woman, dataid: 4 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_asian_man, dataid: 5 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_asian_woman, dataid: 6 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_caucasian_man, dataid: 7 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_caucasian_woman, dataid: 8 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_indian_man, dataid: 9 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_indian_woman, dataid: 10 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_latino_man, dataid: 11 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Adult_latino_woman, dataid: 12 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_afro_man, dataid: 13 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_afro_woman, dataid: 14 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_arab_man, dataid: 15 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_arab_woman, dataid: 16 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_asian_man, dataid: 17 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_asian_woman, dataid: 18 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_caucasian_man, dataid: 19 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_caucasian_woman, dataid: 20 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_indian_men, dataid: 21 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_indian_woman, dataid: 22 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_latino_man, dataid: 23 },
		{ avatarclass: 'avatar', avatarname: 'avatarName', image: BI_PSPB_Elder_adult_latino_woman, dataid: 24 },

	]
	cpe;
	results;
	status;
	userAccounts;
	AccountIds;
	//To fetch the data from user tatble 
	@wire(LoggedUser)
	wiredLoggedUser({ error, data }) {
		try {
		// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				this.loggedUserData = data;
				if (this.loggedUserData && this.loggedUserData[0]?.BI_PSPB_Caregiver__c === true) {
					this.loggedPatient = false;
				}
				if (this.loggedUserData && this.loggedUserData[0]?.BI_PSPB_Caregiver__c === false) {
					this.loggedPatient = true;
				}
			} else if (error) {

				this.showToast(errormessage, error.message, errorvariant);
			}
			const defaultSelectedAvatar = this.imageClass11.find(avatar => avatar.dataid == 1);

			// If found, set it as selected
			if (defaultSelectedAvatar) {
				defaultSelectedAvatar.avatarclass = 'selected';//class
				this.Avatareimg1 = defaultSelectedAvatar.image;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}

	handleavatare(event) {
		this.Avatareimg = event.target.getAttribute('data-id')
		for (let i = 0; i < this.imageClass11.length; i++) {
			this.imageClass11[i].avatarclass = 'avatar';//class
		}
		const clickedAvatar = this.imageClass11.find(avatar => avatar.dataid == this.Avatareimg);
		if (clickedAvatar) {
			clickedAvatar.avatarclass = 'selected';//class
			this.Avatareimg1 = clickedAvatar.image
			
		}
	}



	//To fetch the Patient data from  Account object    
	@wire(getLoggedInUserAccounts)
	wiredUserAccounts({ data }) {
		try {
		// Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				
				this.userAccounts = data;
				if (data[0]?.BI_PSP_Loginattempt__c === 0) {
					this.isLoading = false;
					this.caregiver = true;
					this.userAccounts = data;
				}
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}

	//To fetch the caregiver data from  Account object
	loginattempt
	@wire(UserCaregiver)
	wiredavtList({ error, data }) {
		try {
			if (data && data.length > 0) {
				// Assign the data to the reactive property
				if (data.length > 0) {
					this.loginattempt = data[0].BI_PSP_Loginattempt__c;
					this.isLoading = false;
				}
			} else if (error) {
				// Handle error appropriately
				this.showToast(errormessage, error.message, errorvariant);
			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}


	//To save the selected avatar url to patient in account object
	handleSave() {
		if (!this.Avatareimg1) {
			return;
		}
		if (this?.Avatareimg1 && this.userAccounts.length > 0) { // Use length property to check if there are user contacts
			const AccountId = this.userAccounts[0].Id; // Access the Id from the userContacts array
			const newAvatarSrc = this.Avatareimg1; // Corrected variable name
			if (this.loggedPatient === true) {
				updateAccountAvatar({ accountId: AccountId, avatarSrc: newAvatarSrc }) // Use newAvatarSrc
	// Null data is checked and AuraHandledException is thrown from the Apex
				updateLoginAttempt({ accountId: AccountId }) // Use newAvatarSrc
					.then(result => {
						try {
							setTimeout(function () {
								window.location.assign(brSiteUrl + Questionnaires1);
								this.results = result;
							}, 300);
						}
						catch (err) {
							this.showToast(errormessage, err.message, errorvariant);
						}


					})
					.catch(error => {
						// Handle error or show an error message
						this.showToast(errormessage, error.message, errorvariant);
					});
			}
		}
		//To save the selected avatar url to patient in account object
		if (!this.loggedPatient) {
			const newAvatarSrc = this.Avatareimg1;
			getLoggedInUserCaregiver({ avatarSrc: newAvatarSrc })
				// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => { // Use result instead of this.result
					this.AccountIds = result[0].BI_PSPB_Patient__c; // Assuming AccountId is available in the result
					updateLoginAttemptcaregiver({ accountId: this.AccountIds })
						// Null data is checked and AuraHandledException is thrown from the Apex
						.then(() => {
							try {
								setTimeout(function () {
									window.location.assign(brSiteUrl + Questionnaires1);
								}, 300);
							}
							catch (err) {
								this.showToast(errormessage, err.message, errorvariant);
							}

						})
						.catch(error => {
							this.showToast(errormessage, error.message, errorvariant);
						});
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);
				});
		}
	}

	//connectedcall back
	connectedCallback() {
		this.currentPageUrl = window.location.href;
		this.urlSegments = this.currentPageUrl.split('/');
		this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
		try {
			checkpatientstatus()
				// Null data is checked and AuraHandledException is thrown from the Apex
				.then(patientStatusResult => {
					if (patientStatusResult && patientStatusResult.length > 0) {
						this.cpe = patientStatusResult;
						this.status = patientStatusResult[0].BI_PSPB_PatientStatus__c;
						this.isLoading = true;
					}
				})
				.catch(patientStatusError => {
					this.showToast(errormessage, patientStatusError.message, errorvariant);
				});

			// Fetch logged-in user accounts
			getLoggedInUserAccounts()
				// Null data is checked and AuraHandledException is thrown from the Apex
				.then(userAccountsResult => {
					if (userAccountsResult && userAccountsResult.length > 0) {
						this.userAccounts = userAccountsResult;
						// Example logic without using @wire
						if (userAccountsResult[0]?.BI_PSP_Loginattempt__c === 0) {
							this.isLoading = false;
							this.caregiver = true;
							this.userAccounts = userAccountsResult;
						} else if (userAccountsResult[0]?.BI_PSP_Loginattempt__c === 1) {
							// Set loading to true
							this.isLoading = true;
							// Perform data assignment and navigation
							this.userAccounts = userAccountsResult;
							try {
								setTimeout(() => {
									this.isLoading = true;
									if (this.status === Unassigned) {
										window.location.assign(this.baseUrl + UnassignedSiteURL);
									} else if (this.status === Acute) {
										window.location.assign(this.baseUrl + UnassignedSiteURL + AcuteDashboard);
									}
									else {
										window.location.assign(this.baseUrl + brSiteUrl + dashboard);
									}

								}, 1000);
							} catch (error) {
								this.showToast(errormessage, error.message, errorvariant);
							}

						}
					}
				})
				.catch(userAccountsError => {
					this.showToast(errormessage, userAccountsError.message, errorvariant);
				});
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}