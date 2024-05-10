// This component is utilized for displaying a personalized message and patient's name.
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import fetchPersonalizedMessages from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.fetchPersonalizedMessages';
import UserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver';
import getLoggedInUserAccount from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserAccount';
import getCategoryMessages from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages';
// To import Static Resource
import testimg from '@salesforce/resourceUrl/ProfileAvatar';
import Default_avatar_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Default_Avater_Navigation';
// To get Current User Id
import Id from '@salesforce/user/Id';
// To import Custom Labels
import welcome from '@salesforce/label/c.BI_PSP_Welcome';
import gencategorymessages from '@salesforce/label/c.BI_PSPB_messageCategoryOne';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class BiPspbWelcomeAvatar extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@track assessmentresponse = [];
	@track currentUserName = '';
	@track currentUserId = '';
	@track userId = Id;
	@track newnum = 0;
	@track finalmessage;
	@track finalmessagelist = [];
	@track selectedValue;
	@track reassign;
	@track loggedPatient = false;
	@track caregiver = false;
	@track personalizemessage = false;
	@track message = '';
	@track personalizedMessages = [];
	@track generalMessages = [];
	@track genmessage = '';
	@track result = '';
	@track name = '';
	userContacts;
	selectedAvatarSrc = '';
	cardimage = testimg;
	userAccounts;
	loggedUserData;
	welcomestr = welcome;


	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To reterieve the personalized messages based on questionaire data
	@wire(fetchPersonalizedMessages)
	wiredpersonalizedmessages({ error, data }) {
		try {
			if (data && data.length > 0) {
				this.personalizedMessages = data;
				this.personalizemessage = true;
				if (this.personalizedMessages.length > 0) {
					this.result = this.getRandomNumber(
						0,
						this.personalizedMessages.length - 1
					);
					this.message = this.personalizedMessages[this.result];
					if (this.message) {
						if (this.message.includes('{!username}')) {
							if (this.name !== '') {
								this.message = this.message.replace(
									/{!username}/g,
									this.name
								);
							}
						}
						if (this.message.includes('XXX')) {
							if (this.name !== '') {
								this.message = this.message.replace(
									/XXX/g,
									this.name
								);
							}
						}
					}
				}
			} else if (error) {
				// Handle errors
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from lwc
		}
	}


	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To reterive the caregiver name and avatar
	@wire(UserCaregiver)
	wiredavtList({ error, data }) {
		try {
			if (data && data.length > 0) {
				// Assign the data to the reactive property
				if (data.length > 0) {
					this.caregiver = true;
					this.name = data.length > 0 ? data[0]?.Name : '';
					this.currentUserName = this.name;
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
	// To reterieve the logged in user name and selected avatar
	@wire(getLoggedInUserAccount)
	wiredUserAccounts({ error, data }) {
		try {
			if (data && data.length > 0) {
				this.userAccounts = data;
				if (this.caregiver === false) {
					this.name =
						this.userAccounts.length > 0 ? this.userAccounts[0]?.Name : '';
					this.currentUserName = this.name;
					if (this.userAccounts[0]?.BI_PSP_AvatarUrl__c) {
						this.selectedAvatarSrc = this.userAccounts[0]?.BI_PSP_AvatarUrl__c;
					} else {
						this.selectedAvatarSrc = Default_avatar_JPEG_URL;
					}
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from lwc
		}
	}



	// To render the personalized messages and name of the user
	renderedCallback() {
		try {
			if (this.message) {
				if (this.message.length !== 0) {
					this.finalmessagelist.push(this.message);
				}
			}
			if (this.genmessage) {
				if (this.genmessage.length !== 0) {
					this.finalmessagelist.push(this.genmessage);
				}
			}

			if (this.finalmessagelist) {
				if (this.finalmessagelist.length === 1) {
					this.finalmessage = this.finalmessagelist[0];
					if (this.finalmessage) {
						if (this.finalmessage.includes('{!username}')) {
							this.finalmessage = this.finalmessage.replace(
								/{!username}/g,
								this.name
							);
						}
						if (this.finalmessage.includes('XXX')) {
							this.finalmessage = this.finalmessage.replace(
								/XXX/g,
								this.name
							);
						}
					}
				}
				else {
					let finalans = this.getRandomNumber(0, 1);
					this.finalmessage = this.finalmessagelist[finalans];
					if (this.finalmessage) {
						if (this.finalmessage.includes('{!username}')) {
							this.finalmessage = this.finalmessage.replace(
								/{!username}/g,
								this.name
							);
						}

						if (this.finalmessage.includes('XXX')) {
							this.finalmessage = this.finalmessage.replace(
								/XXX/g,
								this.name
							);

						}
					}
				}
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}
	}


	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To reterieve the general category messages and monday, friday messages
	@wire(getCategoryMessages, { categoryval: gencategorymessages }) // getting generalmessages
	wiredGeneralMessages({ error, data }) {
		try {
			if (data && data.length > 0) {
				this.generalMessages = data;
				this.result = this.getRandomNumber(0, this.generalMessages.length - 1);
				this.genmessage = this.generalMessages[this.result];
				if (this.genmessage) {
					if (this.genmessage.includes('{!username}')) {
						if (this.name !== '') {
							this.genmessage = this.genmessage.replace(
								/{!username}/g,
								this.name
							);
						}
					}

					if (this.genmessage.includes('XXX')) {
						if (this.name !== '') {
							this.genmessage = this.genmessage.replace(
								/XXX/g,
								this.name
							);
						}
					}
				}

				if (this.genmessage === this.message) {
					this.genmessage = this.generalMessages[this.result - 1];
				}
				if (this.genmessage) {
					if (this.genmessage.includes('{!username}')) {
						if (this.name !== '') {
							this.genmessage = this.genmessage.replace(
								/{!username}/g,
								this.name
							);
						}
					}
					if (this.genmessage.includes('XXX')) {
						if (this.name !== '') {
							this.genmessage = this.genmessage.replace(
								/XXX/g,
								this.name
							);
						}
					}
				}
				if (this.message) {
					if (this.message.includes('{!username}')) {
						if (this.name !== '') {
							if (this.name !== '') {
								this.message = this.message.replace(
									/{!username}/g,
									this.name
								);
							}
						}
					}

					if (this.message.includes('XXX')) {
						if (this.name !== '') {
							this.message = this.message.replace(/XXX/g, this.name);
						}
					}
				}
			} else if (error) {
				// Handle errors
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from lwc
		}
	}

	handleclick() {
		this.personalizemessage = false;
	}
	handledotclick() {
		this.personalizemessage = false;
	}

	// To reterieve the general category messages and monday, friday messages
	connectedCallback() {
		//code
		try {
			getCategoryMessages({ categoryval: gencategorymessages })
				.then((result) => {
					this.generalMessages = result;
					this.result = this.getRandomNumber(
						0,
						this.generalMessages.length - 1
					);
					this.genmessage = this.generalMessages[this.result];
					if (this.genmessage) {
						if (this.genmessage.includes('{!username}')) {
							if (this.name !== '') {
								this.genmessage = this.genmessage.replace(
									/{!username}/g,
									this.name
								);
							}
						}
						if (this.genmessage.includes('XXX')) {
							if (this.name !== '') {
								this.genmessage = this.genmessage.replace(
									/XXX/g,
									this.name
								);
							}
						}
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from apex
				});
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from lwc
		}
	}

	// Generate a random decimal between 0 (inclusive) and 1 (exclusive)
	getRandomNumber(min, max) {
		const randomDecimal = Math.random();

		// Scale the random decimal to the range [min, max)
		const randomNumber = Math.floor(randomDecimal * (max - min + 1)) + min;

		return randomNumber;
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