//This component is to Select avatar in account manager.
//To import the libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//To import the Apex class
import getLoggedInUserAccounts from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserAccount';
import getLoggedInUserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserCaregiver';
import LoggedUser from '@salesforce/apex/BI_PSPB_avatarCtrl.loggedUser';
import UserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver';
import updateAccountAvatar from '@salesforce/apex/BI_PSPB_avatarCtrl.updateAccountAvatar';

//To import the Static resources
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

//To import the custom labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class biPspbAvatarSelection extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track caregiver = false;
	@track Avatareimg;
	@track Avatareimg1;
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

	// Declaration of Global variables
	userAccounts;
	loggedUserData;

	//To fetch the Logging user 
	@wire(LoggedUser)
	wiredLoggedUser({ error, data }) {
		try {
			//nullcheck is handled in apex
			if (data) {
				this.loggedUserData = data;
				if (this.loggedUserData && this.loggedUserData[0]?.BI_PSPB_Caregiver__c === true) {
					this.loggedPatient = false;
				}
				if (this.loggedUserData && this.loggedUserData[0]?.BI_PSPB_Caregiver__c === false) {
					this.loggedPatient = true;
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //catching potential error from LWC
		}
	}

	//This Function is used to get the selected Image
	handleavatare(event) {
		this.Avatareimg = event.target.getAttribute('data-id')
		for (let i = 0; i < this.imageClass11.length; i++) {
			this.imageClass11[i].avatarclass = 'avatar';
		}
		const clickedAvatar = this.imageClass11.find(avatar => avatar.dataid == this.Avatareimg);
		if (clickedAvatar) {
			clickedAvatar.avatarclass = 'selected'; //css class
			this.Avatareimg1 = clickedAvatar.image
		}
	}
	//To fetch the caregiver data from Apex class 
	@wire(UserCaregiver)
	wiredavtList({ error, data }) {
		try {
			//nullcheck is handled in apex
			if (data) {
				if (data.length > 0) {
					this.caregiver = true;
					if (data[0]?.BI_PSP_AvatarUrl__c) {
						for (let i = 0; i < this.imageClass11.length; i++) {
							this.imageClass11[i].avatarclass = 'avatar'; //css class
						}
						const clickedAvatar = this.imageClass11.find(avatar => avatar.image.toString() === data[0]?.BI_PSP_AvatarUrl__c.toString());
						if (clickedAvatar) {
							clickedAvatar.avatarclass = 'selected';
							this.Avatareimg1 = clickedAvatar.image;
						}
					}
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //catching potential error from LWC

		}
	}

	//To fetch the Account data from apex class
	@wire(getLoggedInUserAccounts)
	wiredUserAccounts({ error, data }) {
		try {
			//nullcheck is handled in apex
			if (data) {
				this.userAccounts = data;
				if (!this.caregiver && data && data[0]?.BI_PSP_AvatarUrl__c) {
					for (let i = 0; i < this.imageClass11.length; i++) {
						this.imageClass11[i].avatarclass = 'avatar';
					}
					const clickedAvatar = this.imageClass11.find(avatar => avatar.image.toString() === data[0]?.BI_PSP_AvatarUrl__c.toString());
					if (clickedAvatar) {
						clickedAvatar.avatarclass = 'selected';
						this.Avatareimg1 = clickedAvatar.image;
					}
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //catching potential error from LWC
		}
	}

	// Save the avatar url to patient in acount object 
	handleSave() {
		if (!this.Avatareimg1) {
			return;
		}
		if (this?.Avatareimg1 && this.userAccounts.length > 0) { // Use length property to check if there are user contacts
			const AccountId = this.userAccounts[0].Id; // Access the Id from the userContacts array
			const newAvatarSrc = this.Avatareimg1;
			if (this.loggedPatient === true) {
				updateAccountAvatar({ accountId: AccountId, avatarSrc: newAvatarSrc }) // Use newAvatarSrc
					.then(() => {
						window.location.reload();
					})
					.catch(error => {
						this.showToast(errormessage, error.message, errorvariant); //catching potential error from Apex
					});
			}
		}
		//Update the avatarurl to caregiver's patient in Account object
		if (this.loggedPatient === false) {
			const newAvatarSrc = this.Avatareimg1;
			getLoggedInUserCaregiver({ avatarSrc: newAvatarSrc }) // Use newAvatarSrc
				.then(() => {
					window.location.reload();
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); //catching potential error from Apex
				});
		}
	}

	//This showtoast message is used for get error
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}