// This LWC is used for prepopulating hcp patient information.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { loadStyle } from 'lightning/platformResourceLoader';
//To import Apex Classes
import createLeadRecord from '@salesforce/apex/BI_PSPB_getLead.updateLeadRecord';
import leadid from '@salesforce/apex/BI_PSPB_getLead.leadId';
//To import Static Resource
import OLD_GUY_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Patient_initiated_Avater';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
import Warningicon from '@salesforce/resourceUrl/BI_PSP_WarningIcon';
import textalign from '@salesforce/resourceUrl/BI_PSPB_TextAlignmentHcp';
//To import fields from Lead object
import COUNTRY_FIELD from '@salesforce/schema/Lead.CountryCode';
import STATE_FIELD from '@salesforce/schema/Lead.StateCode';
//To import Custom Labels
import pincode from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Pincode';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import female from '@salesforce/label/c.BI_PSP_female';
import male from '@salesforce/label/c.BI_PSP_male';
import other from '@salesforce/label/c.BI_PSP_other';
import phone from '@salesforce/label/c.BI_PSPB_Phone';
import sms from '@salesforce/label/c.BI_PSP_NotificationSMS';
import email from '@salesforce/label/c.BI_PSP_NotificationEmail';
import prefer from '@salesforce/label/c.BI_PSP_prefernot_tosay';
import thankformUrl from '@salesforce/label/c.BI_PSPB_BRPreThankForm';
import doberror from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Future_date';
import hcpenrollmsg from '@salesforce/label/c.BI_PSP_HCPtoenrollMsg';

export default class biPspbHcpPrepopulatePatientForm extends NavigationMixin(LightningElement) {
	// Declaration of variables with @track
	@track variable = false;
	@track clickmethod = true;
	@track mobilevalue2 = `Hello! Welcome to the Spevigo® patient ....`;
	@track Sldsprogree = false;
	@track phone = '';
	@track pmc = '';
	@track country = '';
	@track state = '';
	@track city = '';
	@track street = '';
	@track zipCode = '';
	@track phonerequire = false;
	@track pmcrequire = false;
	@track countryrequire = false;
	@track staterequire = false;
	@track cityrequire = false;
	@track streetrequire = false;
	@track zipCoderequire = false;
	@track leadId;
	@track leadFirstName;
	@track leadLastName;
	@track leadDob;
	@track selectedValue = '';
	@track leadEmail;
	@track lastName = '';
	@track firstName = '';
	@track dob = '';
	@track firstnamerequire = false;
	@track lastNameChangerequire = false;
	@track dateofbirthrequire = false;
	@track genderChangerequire = false;
	@track cityrequire1 = false;
	@track conZipCodeErrorMessage = false;
	@track dobErrorMessage = false;
	@track normalHeading = true;
	@track normalHeading1 = false;
	@track firstnamevalid = false;
	@track lastNameChangevalid = false;
	@track dateofbirthvaild = false;
	@track currentStep;
	@track selectedCountryCode = '';
	@track selectedStateCode = '';
	@track CountryCode = [];
	@track StateCode = [];
	@track gender = '';
	@track authorizeerrorMessage = false;
	@track ConsentFields = {};
	@track checkboxName = false;
	@track checkbox;
	@track leadGender = [
		{ label: male, value: male },
		{ label: female, value: female },
		{ label: prefer, value: prefer },
		{ label: other, value: other }
	];
	@track leadPmc = [
		{ label: sms, value: sms },
		{ label: phone, value: phone },
		{ label: email, value: email }
	];
	@track openModal = false;
	// Declaration of Global variables
	label = { pincode };
	selectedAvatarSrc = OLD_GUY_JPEG_URL;
	BGpp1 = BGpp;
	warningicons = Warningicon;
	selectedGender = '';

	//to store values of firstname, lastname, email, checkbox
	handleInputChange(event) {
		const fieldName = event.target.name;
		const fieldVal = event.target.value;
		this.selectedGender = event.detail.value;
		this.leadFields[fieldName] = fieldVal;
	}

	//to get style format
	connectedCallback() {

		loadStyle(this, textalign);

	}

	//to validate firstname
	handleFirstNameChange(event) {
		this.firstName = event.target.value;

		this.firstName = event.target.value;
		this.firstName =
			event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
		//to get data field value from html
		const firstNameField = this.template.querySelector(
			'lightning-input[data-field="FN"]'
		);
		if (this.firstName) {
			this.firstnamerequire = false;
			this.firstnamevalid = false;
			if (!/^[a-zA-Z]+$/.test(this.firstName)) {
				this.firstnamevalid = true;
				firstNameField.className = 'textInput-err'; //css classes for UI
				this.template.querySelector('label[data-field="FN"]').className =
					'input-error-label';
			} else {
				this.firstnamevalid = false;
				this.firstnamerequire = false;
				firstNameField.className = 'textInput';
				this.template.querySelector('label[data-field="FN"]').className =
					'input-label';
			}
		}
	}

	//to validate lastname
	handleLastNameChange(event) {
		this.lastName = event.target.value;

		this.lastName =
			event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);

		const lastNameField = this.template.querySelector(
			'lightning-input[data-field="LN"]'
		);
		if (this.lastName) {
			this.lastNameChangerequire = false;
			this.lastNameChangevalid = false;
			if (!/^[a-zA-Z]+$/.test(this.lastName)) {
				this.lastNameChangevalid = true;
				lastNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="LN"]').className =
					'input-error-label';
			} else {
				this.lastNameChangevalid = false;
				this.lastNameChangerequire = false;
				lastNameField.className = 'textInput';
				this.template.querySelector('label[data-field="LN"]').className =
					'input-label';
			}
		}
	}

	//to validate dateofbirth
	handleDobChange(event) {
		const dobField = this.template.querySelector(
			'lightning-input[data-field="dob"]'
		);
		this.dob = event.target.value;
		this.validateDate();
		if (this.dob) {
			this.dateofbirthvaild = false;
			this.dateofbirthrequire = false;
			dobField.className = 'textInput';
			this.template.querySelector('label[data-field="dob"]').className =
				'input-error';
		}
	}

	//to validate phone
	handlePhoneChange(event) {
		this.phone = event.target.value;

		const phoneField = this.template.querySelector(
			'lightning-input[data-field="PhoneNumber"]'
		);
		if (!/^\+?[0-9]+$/.test(this.phone)) {
			this.phonerequire = false;
			this.PhoneerrorMessagevalid = true;
			phoneField.className = 'textInput-err';
			this.template.querySelector('label[data-field="PhoneNumber"]').className =
				'input-error-label';
		} else {
			this.PhoneerrorMessagevalid = false;
			this.phonerequire = false;
			phoneField.className = 'textInput';
			this.template.querySelector('label[data-field="PhoneNumber"]').className =
				'input-label';
			if (this.phone === '') {
				this.phonerequire = true;
				this.PhoneerrorMessagevalid = false;
				phoneField.className = 'textInput-err';
				this.template.querySelector(
					'label[data-field="PhoneNumber"]'
				).className = 'input-error-label';
			} else {
				this.phonerequire = false;
				this.PhoneerrorMessagevalid = false;
				phoneField.className = 'textInput';
				this.template.querySelector(
					'label[data-field="PhoneNumber"]'
				).className = 'input-label';
			}
		}
	}

	//to validate Preferred method of communication
	handlePmcChange(event) {
		const mocField = this.template.querySelector(
			'lightning-combobox[data-field="Pmc"]'
		);
		this.pmc = event.target.value;
		if (this.pmc === '') {
			this.pmcrequire = true;
			mocField.className = 'textInput-err';
			this.template.querySelector('label[data-field="Pmc"]').className =
				'input-error-label';
		} else {
			this.pmcrequire = false;
			mocField.className = 'textInput';
			this.template.querySelector('label[data-field="Pmc"]').className =
				'input-label';
		}
	}

	//to validate country
	handleCountryChange(event) {
		this.country = event.target.value;
		const countryField = this.template.querySelector(
			'lightning-combobox[data-field="Country"]'
		);
		if (this.country === '') {
			this.countryrequire = true;
			countryField.className = 'textInput-err';
			this.template.querySelector('label[data-field="Country"]').className =
				'input-error-label';
		} else {
			this.countryrequire = false;
			countryField.className = 'textInput';
			this.template.querySelector('label[data-field="Country"]').className =
				'input-label';
		}
	}

	//to validate state
	handleStateChange(event) {
		this.state = event.target.value;
		const stateField = this.template.querySelector(
			'lightning-combobox[data-field="State"]'
		);
		if (this.state === '') {
			this.staterequire = true;
			stateField.className = 'textInput-err';
			this.template.querySelector('label[data-field="State"]').className =
				'input-error-label';
		} else {
			this.staterequire = false;
			stateField.className = 'textInput';
			this.template.querySelector('label[data-field="State"]').className =
				'input-label';
		}
	}

	//to validate city
	handleCityChange(event) {
		this.city = event.target.value;
		const cityField = this.template.querySelector(
			'lightning-input[data-field="City"]'
		);
		if (this.city === '') {
			this.cityrequire1 = false;
			this.cityrequire = true;
			cityField.className = 'textInput-err';
			this.template.querySelector('label[data-field="City"]').className =
				'input-error-label';
		} else {
			if (!/^[a-zA-Z]+$/.test(this.city)) {
				this.cityrequire = false;
				this.cityrequire1 = true;
				cityField.className = 'textInput-err';
				this.template.querySelector('label[data-field="City"]').className =
					'input-error-label';
			} else {
				this.cityrequire = false;
				this.cityrequire1 = false;
				cityField.className = 'textInput';
				this.template.querySelector('label[data-field="City"]').className =
					'input-label';
			}
		}
	}
	//to validate street
	handleStreetChange(event) {
		this.street = event.target.value;
		const streetField = this.template.querySelector(
			'lightning-input[data-field="Street"]'
		);
		if (this.street === '') {
			this.streetrequire = true;
			streetField.className = 'textInput-err';
			this.template.querySelector('label[data-field="Street"]').className =
				'input-error-label';
		} else {
			this.streetrequire = false;
			streetField.className = 'textInput';
			this.template.querySelector('label[data-field="Street"]').className =
				'input-label';
		}
	}
	//to validate zipcode
	handleZipCodeChange(event) {
		this.zipCode = event.target.value;
		const zipCode = this.template.querySelector(
			'lightning-input[data-field="ZipCode"]'
		);
		if (!/^\d+$/.test(this.zipCode)) {
			this.conZipCodeErrorMessage = false;
			this.zipCoderequire = true;
			zipCode.className = 'textInput-err';
			this.template.querySelector('label[data-field="ZipCode"]').className =
				'input-error-label';
		} else {
			if (this.zipCode === '') {
				this.conZipCodeErrorMessage = true;
				this.zipCoderequire = false;
				zipCode.className = 'textInput-err';
				this.template.querySelector('label[data-field="ZipCode"]').className =
					'input-error-label';
			} else {
				this.conZipCodeErrorMessage = false;
				this.zipCoderequire = false;
				zipCode.className = 'textInput';
				this.template.querySelector('label[data-field="ZipCode"]').className =
					'input-label';
			}
		}
	}

	//to validate all details filled while submitting
	contactvalidform() {
		let isValid = true;

		const phoneField = this.template.querySelector(
			'lightning-input[data-field="PhoneNumber"]'
		);
		if (this.phone === '') {
			this.phonerequire = true;
			this.PhoneerrorMessagevalid = false;
			phoneField.className = 'textInput-err';
			this.template.querySelector('label[data-field="PhoneNumber"]').className =
				'input-error-label';
			isValid = false;
		} else if (!/^\+?[0-9]+$/.test(this.phone)) {
			this.phonerequire = false;
			this.PhoneerrorMessagevalid = true;
			phoneField.className = 'textInput-err';
			this.template.querySelector('label[data-field="PhoneNumber"]').className =
				'input-error-label';
			isValid = false;
		} else {
			this.phonerequire = false;
			this.PhoneerrorMessagevalid = false;
			phoneField.className = 'textInput';
			this.template.querySelector('label[data-field="PhoneNumber"]').className =
				'input-label';
		}
		const mocField = this.template.querySelector(
			'lightning-combobox[data-field="Pmc"]'
		);
		if (this.pmc === '') {
			this.pmcrequire = true;
			mocField.className = 'textInput-err';
			this.template.querySelector('label[data-field="Pmc"]').className =
				'input-error-label';
			isValid = false;
		} else {
			this.pmcrequire = false;
			mocField.className = 'textInput';
			this.template.querySelector('label[data-field="Pmc"]').className =
				'input-label';
		}
		const countryField = this.template.querySelector(
			'lightning-combobox[data-field="Country"]'
		);
		if (this.country === '') {
			this.countryrequire = true;
			countryField.className = 'textInput-err';
			this.template.querySelector('label[data-field="Country"]').className =
				'input-error-label';
			isValid = false;
		} else {
			this.countryrequire = false;
			countryField.className = 'textInput';
			this.template.querySelector('label[data-field="Country"]').className =
				'input-label';
		}
		const stateField = this.template.querySelector(
			'lightning-combobox[data-field="State"]'
		);
		if (this.state === '') {
			this.staterequire = true;
			stateField.className = 'textInput-err';
			this.template.querySelector('label[data-field="State"]').className =
				'input-error-label';
			isValid = false;
		} else {
			this.staterequire = false;
			stateField.className = 'textInput';
			this.template.querySelector('label[data-field="State"]').className =
				'input-label';
		}
		const cityField = this.template.querySelector(
			'lightning-input[data-field="City"]'
		);
		if (this.city === '') {
			this.cityrequire = true;
			this.cityrequire1 = false;
			cityField.className = 'textInput-err';
			this.template.querySelector('label[data-field="City"]').className =
				'input-error-label';
			isValid = false;
		} else if (!/^[a-zA-Z]+$/.test(this.city)) {
			this.cityrequire = false;
			this.cityrequire1 = true;
			isValid = false;
			cityField.className = 'textInput-err';
			this.template.querySelector('label[data-field="City"]').className =
				'input-error-label';
		} else {
			this.cityrequire = false;
			this.cityrequire1 = false;
			cityField.className = 'textInput';
			this.template.querySelector('label[data-field="City"]').className =
				'input-label';
		}

		const streetField = this.template.querySelector(
			'lightning-input[data-field="Street"]'
		);
		if (this.street === '') {
			this.streetrequire = true;
			streetField.className = 'textInput-err';
			this.template.querySelector('label[data-field="Street"]').className =
				'input-error-label';
			isValid = false;
		} else {
			this.streetrequire = false;
			streetField.className = 'textInput';
			this.template.querySelector('label[data-field="Street"]').className =
				'input-label';
		}
		const zipCode = this.template.querySelector(
			'lightning-input[data-field="ZipCode"]'
		);
		if (this.zipCode === '') {
			this.zipCoderequire = false;
			this.conZipCodeErrorMessage = true;
			zipCode.className = 'textInput-err';
			this.template.querySelector('label[data-field="ZipCode"]').className =
				'input-error-label';
			isValid = false;
		} else if (!/^\d+$/.test(this.zipCode)) {
			this.conZipCodeErrorMessage = false;
			this.zipCoderequire = true;
			isValid = false;
			zipCode.className = 'textInput-err';
			this.template.querySelector('label[data-field="ZipCode"]').className =
				'input-error-label';
		} else {
			this.zipCoderequire = false;
			this.conZipCodeErrorMessage = false;
			zipCode.className = 'textInput';
			this.template.querySelector('label[data-field="ZipCode"]').className =
				'input-label';
		}
		if (!this.checkbox) {
			this.checkboxName = true;
		}
		return isValid;
	}

	//to update patient record
	handleCreateLead() {
		if (!this.contactvalidform()) {
			return;
		}
		//innerhtml is used to achieve mobile responsiveness
		this.template.querySelector('p.avatar-content').innerHTML =
			`Hello! Welcome to the Spevigo® patient support program. We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
<br>
<br>
Please continue by verifying your information. Click 'next' to proceed if the pre-filled information is correct. 
 <br>
	<br>
 If not, please correct the information and then click 'next'.`;

		this.mobilevalue2 = `Thank you for choosing Spevigo® for your patients with GPP.
To enroll your patients in the Beyond GPP: The Spevigo® Patient Support Program, please complete the form on this page.`;
		if (
			this.phone !== '' &&
			this.pmc !== '' &&
			this.country !== '' &&
			this.state !== '' &&
			this.city !== '' &&
			this.street !== '' &&
			this.zipCode !== '' &&
			this.checkbox
		) {
			let leadWrapper = {
				leadId: this.leadId,
				phone: this.phone,
				pmc: this.pmc,
				country: this.country,
				state: this.state,
				city: this.city,
				street: this.street,
				zipCode: this.zipCode
			};
			try {
				createLeadRecord({ leadWrapper: leadWrapper })
					.then(() => {
						localStorage.setItem('recordId', this.leadId);
						//Settimeout function used to close the spinner automatically few seconds after it displays
						setTimeout(() => {
							try {
								window.location.href = thankformUrl;
							} catch (error) {
								this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
							}
						}, 1000);
					})
					.catch((error) => {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
					});
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
			}
		}
	}

	//to validate that date is not future date
	validateDate() {
		// Validate that the date is not in the future
		const currentDate = new Date();
		const selectedDate = new Date(this.dob);
		this.doberrorMessage = false;
		if (selectedDate > currentDate) {
			this.dobErrorMessage = doberror;
			return;
		}

		// Validate that the user is not a minor (you can set a minimum age)
		const minAge = 18;
		const userBirthYear = selectedDate.getFullYear();
		const currentYear = currentDate.getFullYear();

		if (currentYear - userBirthYear < minAge) {
			//   this.dobErrorMessage = false;
			this.dobErrorMessage = hcpenrollmsg;
			return;
		}

		// If both validations pass, clear the error message
		this.dobErrorMessage = false;
	}

	//to go back to previous page - 1
	goBackToStepOne() {
		this.normalHeading1 = false;
		this.currentStep = '1';
		this.template.querySelector('div.stepTwo').classList.add('slds-hide');
		this.template.querySelector('div.stepOne').classList.remove('slds-hide');
		// Progress indicator
		this.template.querySelector('div.slds-progress').classList.add('slds-hide');
	}

	//to go back to previous page - 2
	goBackToStepTwo() {
		this.currentStep = '2';
		this.template.querySelector('div.stepThree').classList.add('slds-hide');
		this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
		// Progress indicator
		this.template.querySelector('li.li-two').classList.remove('slds-is-active');
		this.template
			.querySelector('li.li-one')
			.classList.remove('slds-is-completed');
		this.template.querySelector('li.li-one').classList.add('slds-is-active');
	}
	//to go back to previous page - 3
	goBackToStepThree() {
		this.currentStep = '3';
		this.template.querySelector('div.stepFour').classList.add('slds-hide');
		this.template.querySelector('div.stepThree').classList.remove('slds-hide');
		// Progress indicator
		this.template
			.querySelector('li.li-four')
			.classList.remove('slds-is-active');
		this.template
			.querySelector('li.li-three')
			.classList.remove('slds-is-completed');
		this.template.querySelector('li.li-three').classList.add('slds-is-active');
	}
	//to go back to previous page - 4
	goBackToStepFour() {
		this.currentStep = '4';
		this.template.querySelector('div.stepFive').classList.add('slds-hide');
		this.template.querySelector('div.stepFour').classList.remove('slds-hide');
	}

	//to go to next page
	goToStepTwo() {
		const firstNameField = this.template.querySelector(
			'lightning-input[data-field="FN"]'
		);
		const lastNameField = this.template.querySelector(
			'lightning-input[data-field="LN"]'
		);
		const dobField = this.template.querySelector(
			'lightning-input[data-field="dob"]'
		);
		if (this.dobErrorMessage) {
			return;
		}
		if (this.firstName !== '' && this.lastName !== '' && this.dob !== '') {
			try {
				leadid({
					firstName: this.firstName,
					lastName: this.lastName,
					dob: this.dob
				})
					.then((result) => {
						this.leadId = result.Id;
						this.leadFirstName = result.FirstName;
						this.leadLastName = result.LastName;
						this.leadDob = result.HealthCloudGA__BirthDate__c;
						this.selectedValue = result.HealthCloudGA__Gender__c;
						this.leadEmail = result.Email;
						this.phone = result.Phone;
						if (this.leadId !== '') {
							this.Sldsprogree = true;
							this.currentStep = '2';
							const stepOneDiv = this.template.querySelector('div.stepOne');
							if (stepOneDiv) {
								stepOneDiv.classList.add('slds-hide');
							}
							const stepTwoDiv = this.template.querySelector('div.stepTwo');
							if (stepTwoDiv) {
								stepTwoDiv.classList.remove('slds-hide');
							}
							const progressDiv = this.template.querySelector('div.slds-progress');
							if (progressDiv) {
								progressDiv.classList.remove('slds-hide');
							}

							this.template.querySelector('p.avatar-content').innerHTML =
								`Hello! Welcome to Beyond GPP: The Spevigo® Patient Support Program. We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
<br>
<br>
Please continue by verifying your information. Click 'next' to proceed if the pre-filled information is correct. 
 <br>
	<br>
 If not, please correct the information and then click 'next'.`;

							this.mobilevalue2 = `Hello! Welcome to Beyond GPP: The Spevigo® Patient....`;
						}
					})
					.catch((error) => {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex

						this.normalHeading = false;

						this.normalHeading1 = true;

						this.firstnamevalid = true;
						this.firstnamerequire = false;
						firstNameField.value = '';
						firstNameField.className = 'textInput-err';
						this.template.querySelector('label[data-field="FN"]').className =
							'input-error-label';
						this.firstname = '';

						this.lastNameChangevalid = true;
						this.lastNameChangerequire = false;
						lastNameField.value = '';
						lastNameField.className = 'textInput-err';
						this.template.querySelector('label[data-field="LN"]').className =
							'input-error-label';
						this.lastName = '';

						this.dateofbirthvaild = true;
						dobField.value = '';
						this.dateofbirthrequire = false;
						dobField.className = 'textInput-err';
						this.template.querySelector('label[data-field="dob"]').className =
							'input-error-label';
						this.dob = '';
						//innerhtml is used to achieve mobile responsiveness
						this.template.querySelector('p.avatar-content').innerHTML =
							`Hello! Welcome to the Spevigo® patient support program. We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
<br>
<br>
Please continue by verifying your information. Click 'next' to proceed if the pre-filled information is correct. 
<br>
	<br>
 If not, please correct the information and then click 'next'.`;

						this.mobilevalue2 = `Hello! Welcome to Beyond GPP: The Spevigo® Patient....`;
					});
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Apex
			}
		} else {
			if (this.firstName === '') {
				this.normalHeading1 = true;
				this.normalHeading = false;
				this.firstnamevalid = false;
				this.firstnamerequire = true;
				firstNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="FN"]').className =
					'input-error-label';
			}

			if (this.lastName === '') {
				this.normalHeading1 = true;
				this.normalHeading = false;
				this.lastNameChangevalid = false;
				this.lastNameChangerequire = true;
				lastNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="LN"]').className =
					'input-error-label';
			}

			if (this.dob === '') {
				this.normalHeading1 = true;
				this.normalHeading = false;
				this.dateofbirthvaild = false;
				this.dateofbirthrequire = true;
				dobField.className = 'textInput-err';
				this.template.querySelector('label[data-field="dob"]').className =
					'input-error-label';
			}
			//innerhtml is used to achieve mobile responsiveness
			this.template.querySelector('p.avatar-content').innerHTML =
				`Hello! Welcome to the Spevigo® patient support program. We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
<br>
<br>
Please continue by verifying your information. Click 'next' to proceed if the pre-filled information is correct. 
<br>
	<br>
 If not, please correct the information and then click 'next'.`;

			this.mobilevalue2 = `Hello! Welcome to Beyond GPP: The Spevigo® Patient....`;
		}

	}

	//assign the selected gender
	handleGenderChange(event) {
		this.selectedValue = event.target.value;
		this.genderChangerequire = false;
	}

	//to go to next page
	goToStepThree() {
		const lastNameField = this.template.querySelector(
			'lightning-combobox[data-field="GN"]'
		);
		if (this.selectedValue !== '') {
			this.currentStep = '3';
			this.template.querySelector('div.stepTwo').classList.add('slds-hide');
			this.template
				.querySelector('div.stepThree')
				.classList.remove('slds-hide');
			// Progress indicator
			this.template
				.querySelector('li.li-one')
				.classList.remove('slds-is-active');
			this.template
				.querySelector('li.li-one')
				.classList.add('slds-is-completed');
			this.template.querySelector('li.li-two').classList.add('slds-is-active');
		} else {
			if (this.selectedValue === '') {
				this.genderChangerequire = true;
				this.template.querySelector('label[data-field="GN"]').className = 'input-error-label';
				lastNameField.className = 'textInput-err';
			}
			//innerhtml is used to achieve mobile responsiveness
			this.template.querySelector('p.avatar-content').innerHTML =
				`Hello! Welcome to the Spevigo® patient support program. We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
<br>
<br>
Please continue by verifying your information. Click 'next' to proceed if the pre-filled information is correct. 
 <br>
	<br>
 If not, please correct the information and then click 'next'.`;

			this.mobilevalue2 = `Hello! Welcome to Beyond GPP: The Spevigo® Patient....`;
		}
	}

	//to get dependent records from Lead 
	@wire(getObjectInfo, { objectApiName: 'Lead' })
	objectInfo;

	//to get country values
	@wire(getPicklistValues, {
		recordTypeId: '$objectInfo.data.defaultRecordTypeId',
		fieldApiName: COUNTRY_FIELD
	})
	CountryValues({ data, error }) {
		try {
			if (data) {
				this.CountryCode = data.values.map((option) => ({
					label: option.label,
					value: option.value
				}));
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//to get state values
	@wire(getPicklistValues, {
		recordTypeId: '$objectInfo.data.defaultRecordTypeId',
		fieldApiName: STATE_FIELD,
		controllingFieldValue: '$country'
	})
	StateValues({ data, error }) {
		try {
			if (data) {
				this.StateCode = data.values.map((option) => ({
					label: option.label,
					value: option.value
				}));
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	// Reset selected state when country changes
	handleCountryCodeChange(event) {
		this.selectedCountryCode = event.detail.value;
		this.selectedStateCode = '';
	}


	//to make checkbox mandatory
	authorize() {
		let isValid = true;

		// authorize
		if (!this.ConsentFields.authorize) {
			this.authorizeerrorMessage = true;
			isValid = false;
		} else {
			this.authorizeerrorMessage = false;
		}
		return isValid;
	}

	//to check whether the checkbox is checked
	handleInputChange3(event) {
		this.checkbox = event.target.checked;
		this.checkboxName = false;
	}

	//to show toast message
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}

	//to get dependent lead record based on firstname, lastname and dob
	leadrecordget() {
		leadid({
			firstName: this.firstName,
			lastName: this.lastName,
			dob: this.dob
		})
			.then((result) => {
				this.leadId = result.Id;
				this.leadFirstName = result.FirstName;
				this.leadLastName = result.LastName;
				this.leadDob = result.HealthCloudGA__BirthDate__c;
				this.selectedValue = result.HealthCloudGA__Gender__c;
				this.leadEmail = result.Email;
				this.phone = result.Phone;
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
			});
	}

	//to display terms and condition popup 
	showModal() {
		this.openModal = true;
		this.template.querySelector('div.formContainer');
	}
	//to close terms and condition popup 
	closeModal() {
		this.openModal = false;
		this.template.querySelector('div.formContainer');
	}

	//to validate phone
	handleKeyDown(event) {
		const charCode = event.which ? event.which : event.keyCode; // Get the ASCII code of the pressed key
		if (charCode !== 43 && (charCode < 48 || charCode > 57)) {
			// Allow only digits (48-57) and the plus symbol (43)
			event.preventDefault(); // Prevent the character from being entered
		}
	}

	//to get avatar content
	click() {
		this.mobilevalue2 = `Hello! Welcome to Beyond GPP: The Spevigo® Patient Support Program. We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
Please continue by verifying your information. Click 'next' to proceed if the pre-filled information is correct. 
 If not, please correct the information and then click 'next'.`;
		this.clickmethod = false;
	}
	//to get avatar content in mobile view
	Xmark() {
		this.mobilevalue2 = `Hello! Welcome to Beyond GPP: The Spevigo® Patient....`;
		this.clickmethod = true;
	}
}