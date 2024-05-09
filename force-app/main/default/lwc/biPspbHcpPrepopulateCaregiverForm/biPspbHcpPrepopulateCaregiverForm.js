// This LWC is used for prepopulating hcp caregiver information.
// To import Libraries
import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { loadStyle } from 'lightning/platformResourceLoader';
//  To import Apex Classes
import createLeadRecord from '@salesforce/apex/BI_PSPB_getLead.updateLeadCareRecord';
import leadid from '@salesforce/apex/BI_PSPB_getLead.leadId';
import updateLead from '@salesforce/apex/BI_PSPB_getLead.updateLead';
import leadCaregiver from '@salesforce/apex/BI_PSPB_getLead.getEnrolleeCaregiverId';
// To import Static Resources
import OLD_GUY_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Patient_initiated_Avater';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
import Warningicon from '@salesforce/resourceUrl/BI_PSP_WarningIcon';
import textalign from '@salesforce/resourceUrl/BI_PSPB_TextAlignmentHcp';
//To import fields from Lead
import COUNTRY_FIELD from '@salesforce/schema/Lead.CountryCode';
import STATE_FIELD from '@salesforce/schema/Lead.StateCode';
// To import Custom Labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import thankformUrl from '@salesforce/label/c.BI_PSPB_BRPreThankForm';
import female from '@salesforce/label/c.BI_PSP_female';
import male from '@salesforce/label/c.BI_PSP_male';
import other from '@salesforce/label/c.BI_PSP_other';
import phone from '@salesforce/label/c.BI_PSPB_Phone';
import sms from '@salesforce/label/c.BI_PSP_NotificationSMS';
import email from '@salesforce/label/c.BI_PSP_NotificationEmail';
import parent from '@salesforce/label/c.BI_PSP_NotificationParent';
import sibiling from '@salesforce/label/c.BI_PSP_NotificationSibling';
import lovedOne from '@salesforce/label/c.BI_PSP_NotificationLovedone';
import guardian from '@salesforce/label/c.BI_PSP_NotificationGuardian';
import friend from '@salesforce/label/c.BI_PSP_NotificationFriend';
import relative from '@salesforce/label/c.BI_PSP_NotificationOtherRelative';
export default class biPspbHcpPrepopulateCaregiverForm extends NavigationMixin(
	LightningElement
) {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @api
	@api searchResults;
	@api searchResults1;
	// Declaration of variables with @track
	@track selectedCountryCode = '';
	@track selectedStateCode = '';
	@track CountryCode = [];
	@track StateCode = [];
	@track zipCodevalid = false;
	@track mobileview = ` Hello! Welcome to Beyond GPP: TheSpevigo® Patient...`;
	@track leadFields = {};
	@track CaregiverFields = {};
	@track PrescriptionFields = {};
	@track ConsentFields = {};
	@track firstnameerrorMessage = false;
	@track Referring_Practitioner__c;
	@track referringerrorMessage = false;
	@track lastnameerrorMessage = false;
	@track doberrorMessage = false;
	@track gendererrorMessage = false;
	@track emailerrorMessage = false;
	@track carefirstnameerrorMessage = false;
	@track carelastnameerrorMessage = false;
	@track caredoberrorMessage = false;
	@track careemailerrorMessage = false;
	@track code;
	@track RPfirstnameerrorMessage = false;
	@track RPlastnameerrorMessage = false;
	@track RPstatelicenseerrorMessage = false;
	@track RPPracticenameerrorMessage = false;
	@track RPpracticetypeerrorMessage = false;
	@track RPfaxerrorMessage = false;
	@track RPphoneerrorMessage = false;
	@track RPemailerrorMessage = false;
	@track RPstatecodeerrorMessage = false;
	@track RPcityerrorMessage = false;
	@track RPstreeterrorMessage = false;
	@track RPpostalcodeerrorMessage = false;
	@track drugerrorMessage = false;
	@track dateerrorMessage = false;
	@track frequencyrrorMessage = false;
	@track FrequencyUniterrorMessage = false;
	@track authorizeerrorMessage = false;
	@track error;
	@track errors;
	@track errorss;
	@track minorerror;
	@track isAddNew = false;
	@track physicianIdInputDisabled = false;
	@track physicianNameInputDisabled = false;
	@track Threedot = true;
	@track caregiverfirstname = false;
	@track caregiverLastName = false;
	@track caregiverdateofBirth = false;
	@track caregiverRelationship = false;
	@track caregiverEmail = false;
	@track caregiverPhoneNumber = false;
	@track caregiverPreferred = false;
	@track careRelationship;
	@track carephone;
	@track prefereedmode;
	@track checkboxName = false;
	@track checkbox;
	@track country = '';
	@track state = '';
	@track city = '';
	@track street = '';
	@track zipCode = '';
	@track leadId;
	@track showDetails = false;
	@track showForm = true;
	@track countryrequire = false;
	@track staterequire = false;
	@track cityrequire = false;
	@track streetrequire = false;
	@track zipCoderequire = false;
	@track clabelerror = false;
	@track clabelerrors = 'input-label';
	@track slabelerror = false;
	@track slabelerrors = 'input-label';
	@track cilabelerror = false;
	@track cilabelerrors = 'input-label';
	@track stlabelerror = false;
	@track stlabelerrors = 'input-label';
	@track zlabelerror = false;
	@track zlabelerrors = 'input-label';
	@track currentStep;
	@track dobErrorMessage = false;
	@track normalHeading = true;
	@track normalHeading1 = false;
	@track firstnamevalid = false;
	@track lastNameChangevalid = false;
	@track dateofbirthvaild = false;
	@track phoneNumber = '';
	@track pmocvalue = '';
	@track genderrequire = false;
	@track genderValue = '';
	@track openModal = false;
	@track leadGender = [
		{ label: male, value: male },
		{ label: female, value: female },
		{ label: other, value: other }
	];
	@track rswp = [
		{ label: parent, value: parent },
		{ label: sibiling, value: sibiling },
		{ label: lovedOne, value: lovedOne },
		{ label: guardian, value: guardian },
		{ label: friend, value: friend },
		{ label: relative, value: relative }
	];
	@track leadPmc = [
		{ label: sms, value: sms },
		{ label: phone, value: phone },
		{ label: email, value: email }
	];
	@track leadFirstName;
	@track leadLastName;
	@track leadDob;
	@track selectedValue;
	@track leadEmail;
	@track lastName = '';
	@track firstName = '';
	@track dob = '';
	@track rwp = '';
	@track firstnamerequire = false;
	@track lastNameChangerequire = false;
	@track dateofbirthrequire = false;
	@track rwprequire = false;
	@track phonerequire = false;
	@track pmocrequire = false;
	@track leadCareId;
	@track leadCareFirstName;
	@track leadCareLastName;
	@track leadCareDob;
	@track leadCareEmail;
	@track leadCarePhone;
	// Declaration of Global variables
	selectedGender = '';
	warningicons = Warningicon;
	selectedAvatarSrc = OLD_GUY_JPEG_URL;
	BGpp = BGpp;
	picklistOrdered = [];
	picklistOrdered1 = [];
	selectedSearchResult;
	selectedSearchResult1;

	// Importing wire adapters to retrieve object information and picklist values
	connectedCallback() {

		loadStyle(this, textalign);

	}
	@wire(getObjectInfo, { objectApiName: 'Lead' })
	objectInfo;
	// Wire adapter to retrieve picklist values for the Country field
	@wire(getPicklistValues, {
		recordTypeId: '$objectInfo.data.defaultRecordTypeId',
		fieldApiName: COUNTRY_FIELD
	})
	// get the country code
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
	// Wire adapter to retrieve picklist values for the State field, based on selected country

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

	//  store the CountryCode value in html
	handleCountryCodeChange(event) {
		this.selectedCountryCode = event.detail.value;
		this.selectedStateCode = ''; // Reset selected state when country changes
	}


	// Function to handle input changes related to caregiver information
	handleInputChangecaregiver(event) {
		this.careRelationship = event.target.value;
		this.carephone = event.target.value;
		this.prefereedmode = event.target.value;
		this.caregiverRelationship = false;
		this.caregiverPreferred = false;
		this.caregiverPhoneNumber = false;
	}

	handleInputChange3(event) {
		this.checkbox = event.target.checked;
		this.checkboxName = false;
	}

	//to validate country
	handleCountryChange(event) {
		// Get the selected country value
		this.country = event.target.value;
		const countryField = this.template.querySelector(
			'lightning-combobox[data-field="Country"]'
		);
		// Check if the country is empty
		if (this.country === '') {
			this.countryrequire = true;
			countryField.className = 'textInput-err';
			this.clabelerrors = 'input-error-label';
			this.clabelerror = true;
		} else {
			this.countryrequire = false;
			countryField.className = 'textInput';
			this.clabelerrors = 'input-label';
			this.clabelerror = false;
		}
	}

	//to validate state
	handleStateChange(event) {
		// Get the selected state value
		this.state = event.target.value;
		const stateField = this.template.querySelector(
			'lightning-combobox[data-field="State"]'
		);
		// Check if the state is empty
		if (this.state === '') {
			this.staterequire = true;
			stateField.className = 'textInput-err';
			this.slabelerrors = 'input-error-label';
			this.slabelerror = true;
		} else {
			this.staterequire = false;
			stateField.className = 'textInput';
			this.slabelerrors = 'input-label';
			this.slabelerror = false;
		}
	}

	//to validate city
	handleCityChange(event) {
		// Get the entered city value
		this.city = event.target.value;
		//to get data field value from html
		const cityField = this.template.querySelector(
			'lightning-input[data-field="City"]'
		);
		// Check if the city is empty
		if (this.city === '') {
			this.cityrequire1 = false;
			this.cityrequire = true;
			cityField.className = 'textInput-err'; //css classes for UI
			this.template.querySelector('label[data-field="City"]').className =
				'input-error-label';
		}
		// Check if city contains only alphabets
		else {
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
		// Get the entered street value
		this.street = event.target.value;
		const streetField = this.template.querySelector(
			'lightning-input[data-field="Street"]'
		);
		// Check if the street is empty
		if (this.street === '') {
			this.streetrequire = true;
			streetField.className = 'textInput-err';
			this.stlabelerrors = 'input-error-label';
			this.stlabelerror = true;
		} else {
			this.streetrequire = false;
			streetField.className = 'textInput';
			this.stlabelerrors = 'input-label';
			this.stlabelerror = false;
		}
	}
	//to validate zipcode
	handleZipCodeChange(event) {
		// Get the entered zip code value
		this.zipCode = event.target.value;
		const zipCode = this.template.querySelector(
			'lightning-input[data-field="ZipCode"]'
		);
		// Check if the zip code is not numeric
		if (!/^\d+$/.test(this.zipCode)) {
			this.zipCoderequire = false;
			this.zipCodevalid = true;
			zipCode.className = 'textInput-err';
			this.template.querySelector('label[data-field="ZipCode"]').className =
				'input-error-label';
		}
		// Check if the zip code is empty
		else {
			if (this.zipCode === '') {
				this.zipCoderequire = true;
				this.zipCodevalid = false;
				zipCode.className = 'textInput';
				this.template.querySelector('label[data-field="ZipCode"]').className =
					'input-label';
			}
			// Reset flags and update classes
			this.zipCoderequire = false;
			this.zipCodevalid = false;
			zipCode.className = 'textInput';
			this.template.querySelector('label[data-field="ZipCode"]').className =
				'input-label';
		}
	}

	// Function to validate the contact form
	Contactvalidform() {
		let isValid = true;
		const countryField = this.template.querySelector(
			'lightning-combobox[data-field="Country"]'
		);
		if (this.country === '') {
			this.countryrequire = true;
			countryField.className = 'textInput-err';
			this.clabelerrors = 'input-error-label';
			this.clabelerror = true;
			isValid = false;
		} else {
			this.countryrequire = false;
			countryField.className = 'textInput';
			this.clabelerrors = 'input-label';
			this.clabelerror = false;
		}
		const stateField = this.template.querySelector(
			'lightning-combobox[data-field="State"]'
		);
		if (this.state === '') {
			this.staterequire = true;
			stateField.className = 'textInput-err';
			this.slabelerrors = 'input-error-label';
			this.slabelerror = true;
			isValid = false;
		} else {
			this.staterequire = false;
			stateField.className = 'textInput';
			this.slabelerrors = 'input-label';
			this.slabelerror = false;
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
			this.cilabelerror = true;
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
			this.cilabelerror = false;
		}
		const streetField = this.template.querySelector(
			'lightning-input[data-field="Street"]'
		);
		if (this.street === '') {
			this.streetrequire = true;
			isValid = false;
			streetField.className = 'textInput-err';
			this.stlabelerrors = 'input-error-label';
			this.stlabelerror = true;
		} else {
			this.streetrequire = false;
			streetField.className = 'textInput';
			this.stlabelerrors = 'input-label';
			this.stlabelerror = false;
		}
		const zipCode = this.template.querySelector(
			'lightning-input[data-field="ZipCode"]'
		);
		if (this.zipCode === '') {
			this.zipCoderequire = true;
			this.zipCodevalid = false;
			zipCode.className = 'textInput-err';
			this.template.querySelector('label[data-field="ZipCode"]').className =
				'input-error-label';
			this.zlabelerror = true;
			isValid = false;
		} else if (!/^\d+$/.test(this.zipCode)) {
			this.zipCoderequire = false;
			this.zipCodevalid = true;
			isValid = false;
			zipCode.className = 'textInput-err';
			this.template.querySelector('label[data-field="ZipCode"]').className =
				'input-error-label';
		} else {
			this.zipCoderequire = false;
			this.zipCodevalid = false;
			zipCode.className = 'textInput';
			this.template.querySelector('label[data-field="ZipCode"]').className =
				'input-label';
			this.zlabelerror = false;
		}
		if (!this.checkbox) {
			this.checkboxName = true;
			isValid = false;
		}
		return isValid;
	}

	//to update lead record
	handleCreateLead() {
		if (!this.Contactvalidform()) {
			return;
		}

		let leadWrapper = {
			leadId: this.leadId,
			country: this.country,
			state: this.state,
			city: this.city,
			street: this.street,
			zipCode: this.zipCode
		};
		try {
			createLeadRecord({ leadWrapper: leadWrapper })
				.then((leadId) => {
					updateLead({
						leadId:this.leadId,
						PreferredMethodofCommunication: this.pmocvalue
					})
						.then(() => {
							localStorage.setItem('recordId', this.leadId);
						})
						.catch((error) => {
							this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
						});

					//Settimeout function used to close the spinner automatically few seconds after it displays
					setTimeout(function () {
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

	//to go to previous page - 1
	goBackToStepOne() {
		this.currentStep = '1';
		this.template.querySelector('div.stepTwo').classList.add('slds-hide');
		this.template.querySelector('div.stepOne').classList.remove('slds-hide');
		this.template.querySelector('div.slds-progress').classList.add('slds-hide');
	}

	//to go to previous page - 2
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
	//to go to previous page - 3
	goBackToStepThree() {
		this.currentStep = '3';
		this.template.querySelector('div.stepFour').classList.add('slds-hide');
		this.template.querySelector('div.stepThree').classList.remove('slds-hide');
		// Progress indicator
		this.template
			.querySelector('li.li-three')
			.classList.remove('slds-is-active');
		this.template
			.querySelector('li.li-two')
			.classList.remove('slds-is-completed');
		this.template.querySelector('li.li-two').classList.add('slds-is-active');
		//}
	}
	//to go to previous page - 4
	goBackToStepFour() {
		this.currentStep = '4';
		this.template.querySelector('div.stepFive').classList.add('slds-hide');
		this.template.querySelector('div.stepFour').classList.remove('slds-hide');
	}

	//to validate date
	validateDate() {
		this.doberrorMessage = false;
		this.dobErrorMessage = false;
	}

	//to go to next page by validating fields
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
					this.leadCaregiverecordget(result.Id);

					if (this.leadId !== '') {
						this.currentStep = '2';
						this.template
							.querySelector('div.stepOne')
							.classList.add('slds-hide');
						this.template
							.querySelector('div.stepTwo')
							.classList.remove('slds-hide');
						// Progress indicator
						this.template
							.querySelector('div.slds-progress')
							.classList.remove('slds-hide');
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
					this.normalHeading = false;
					this.normalHeading1 = true;
					this.firstnamevalid = true;
					firstNameField.value = '';
					firstNameField.className = 'textInput-err';
					this.template.querySelector('label[data-field="FN"]').className =
						'input-error-label';
					this.firstname = '';

					this.lastNameChangevalid = true;
					lastNameField.value = '';
					lastNameField.className = 'textInput-err';
					this.template.querySelector('label[data-field="LN"]').className =
						'input-error-label';
					this.lastName = '';

					this.dateofbirthvaild = true;
					dobField.value = '';
					dobField.className = 'textInput-err';
					this.template.querySelector('label[data-field="dob"]').className =
						'input-error-label';
					this.leadFields.dob = '';
				});
		} else {
			if (this.firstName === '') {
				this.firstnamerequire = true;
				this.firstnamevalid = false;
				firstNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="FN"]').className =
					'input-error-label';
				this.normalHeading1 = true;
				this.normalHeading = false;
			} else {
				this.firstnamerequire = false;
				this.firstnamevalid = false;
				firstNameField.className = 'textInput';
				this.template.querySelector('label[data-field="FN"]').className =
					'input-label';
				this.normalHeading1 = false;
				this.normalHeading = true;
			}
			if (this.lastName === '') {
				this.lastNameChangerequire = true;
				this.lastNameChangevalid = false;
				lastNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="LN"]').className =
					'input-error-label';
				this.normalHeading1 = true;
				this.normalHeading = false;
			} else {
				this.lastNameChangerequire = false;
				this.lastNameChangevalid = false;
				lastNameField.className = 'textInput';
				this.template.querySelector('label[data-field="LN"]').className =
					'input-label';
				this.normalHeading1 = false;
				this.normalHeading = true;
			}
			if (!this.dob) {
				this.dateofbirthrequire = true;
				dobField.className = 'textInput-err';
				this.template.querySelector('label[data-field="dob"]').className =
					'input-error-label';
				this.normalHeading1 = true;
				this.normalHeading = false;
			} else {
				this.dateofbirthrequire = false;
				dobField.className = 'textInput';
				this.template.querySelector('label[data-field="dob"]').className =
					'input-label';
				this.normalHeading1 = false;
				this.normalHeading = true;
			}
		}

	}

	//to store relationship with patient field
	handlerwcChange(event) {
		this.rwp = event.target.value;
		this.rwprequire = false;
	}

	//to store value in phone field
	handlephoneChange(event) {
		this.phoneNumber = event.target.value;
		this.phonerequire = false;
	}

	//to store preferred method of communication field
	handlepmocChange(event) {
		this.pmocvalue = event.target.value;
		const pmocField = this.template.querySelector(
			'lightning-combobox[data-field="pmoc"]'
		);
		if (this.pmocvalue === '') {
			this.pmocrequire = true;
			pmocField.className = 'textInput-err';
			this.template.querySelector('label[data-field="pmoc"]').className =
				'input-error-label';
		} else {
			this.pmocrequire = false;
			pmocField.className = 'textInput';
			this.template.querySelector('label[data-field="pmoc"]').className =
				'input-label';
		}
	}
	//to go to next page by validating fields
	goToStepThree() {
		const lastNameField = this.template.querySelector(
			'lightning-combobox[data-field="rwp"]'
		);
		const pmocField = this.template.querySelector(
			'lightning-combobox[data-field="pmoc"]'
		);
		const phoneField = this.template.querySelector(
			'lightning-input[data-field="phone"]'
		);

		// Reset error flags
		this.rwprequire = false;
		this.pmocrequire = false;
		this.phonerequire = false;

		if (this.rwp && this.phoneNumber && this.pmocvalue) {
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
			if (!this.rwp) {
				this.rwprequire = true;
				lastNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="rwp"]').className =
					'input-error-label';
			} else {
				this.rwprequire = false; // Reset error flag
				lastNameField.className = 'textInput'; // Remove error class
				this.template.querySelector('label[data-field="rwp"]').className =
					'input-label';
			}

			if (this.pmocvalue === '') {
				this.pmocrequire = true;
				pmocField.className = 'textInput-err';
				this.template.querySelector('label[data-field="pmoc"]').className =
					'input-error-label';
			} else {
				this.pmocrequire = false; // Reset error flag
				pmocField.className = 'textInput'; // Remove error class
				this.template.querySelector('label[data-field="pmoc"]').className =
					'input-label';
			}

			if (!this.phoneNumber) {
				this.phonerequire = true;
				phoneField.className = 'textInput-err';
				this.template.querySelector('label[data-field="phone"]').className =
					'input-error-label';
			} else {
				this.phonerequire = false; // Reset error flag
				phoneField.className = 'textInput'; // Remove error class
				this.template.querySelector('label[data-field="phone"]').className =
					'input-label';
			}
		}
	}

	//to store value in gender field
	handleGenderChange(event) {
		this.genderValue = event.target.value;
		this.genderrequire = false;
	}

	//to go to next page by validating fields
	goToStepFour() {
		const lastNameField = this.template.querySelector(
			'lightning-combobox[data-field="GN"]'
		);
		if (this.selectedValue !== '') {
			this.currentStep = '4';
			this.template.querySelector('div.stepThree').classList.add('slds-hide');
			this.template.querySelector('div.stepFour').classList.remove('slds-hide');
			// Progress indicator
			this.template
				.querySelector('li.li-two')
				.classList.remove('slds-is-active');
			this.template
				.querySelector('li.li-two')
				.classList.add('slds-is-completed');
			this.template
				.querySelector('li.li-three')
				.classList.add('slds-is-active');
			// }
		} else {
			if (this.genderValue === '') {
				this.genderrequire = true;
				lastNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="GN"]').className =
					'input-error-label';
			}
		}
	}

	//to go to next page
	goToStepFive() {
		if (!this.PrescriptionFieldsForm() || this.errorss === true) {
			return;
		}
		this.currentStep = '5';
		this.template.querySelector('div.stepFour').classList.add('slds-hide');
		this.template.querySelector('div.stepFive').classList.remove('slds-hide');
	}

	//to validate all fields while submitting
	patientvalidateForm() {
		let isValid = true;
		const firstNameField = this.template.querySelector(
			'lightning-input[data-field="FN"]'
		);
		if (!firstNameField.value) {
			this.firstnameerrorMessage = true;
			isValid = false;
			firstNameField.className = 'textInput-err';
			this.template.querySelector('label[data-field="FN"]').className =
				'input-error-label';
		} else {
			this.firstnameerrorMessage = false;
			firstNameField.className = 'textInput';
			this.template.querySelector('label[data-field="FN"]').className =
				'input-label';
		}


		// First Name
		if (!this.leadFields.FirstName) {
			this.firstnameerrorMessage = true;
			isValid = false;
		} else {
			this.firstnameerrorMessage = false;
		}
		// Last Name

		if (!this.leadFields.LastName) {
			this.lastnameerrorMessage = true;
			isValid = false;
		} else {
			this.lastnameerrorMessage = false;
		}

		// Date of Birth

		if (!this.leadFields.dob) {
			this.doberrorMessage = true;
			isValid = false;
		} else {
			this.doberrorMessage = false;
		}

		// Gender

		if (!this.selectedGender) {
			this.gendererrorMessage = true;
			isValid = false;
		} else {
			this.gendererrorMessage = false;
		}

		// Email

		if (this.isAdult === true && !this.leadFields.Email) {
			this.emailerrorMessage = true;
			isValid = false;
		} else {
			this.emailerrorMessage = false;
		}

		return isValid;
	}

	//to validate caregiver field values
	carevalidateForm() {
		let isValid = true;

		// First Name

		if (!this.CaregiverFields.FirstName) {
			this.carefirstnameerrorMessage = true;
			isValid = false;
		} else {
			this.carefirstnameerrorMessage = false;
		}

		// Last Name

		if (!this.CaregiverFields.LastName) {
			this.carelastnameerrorMessage = true;
			isValid = false;
		} else {
			this.carelastnameerrorMessage = false;
		}

		// Date of Birth

		if (!this.CaregiverFields.dob) {
			this.caredoberrorMessage = true;
			isValid = false;
		} else {
			this.caredoberrorMessage = false;
		}

		// Email

		if (!this.CaregiverFields.Email) {
			this.careemailerrorMessage = true;
			isValid = false;
		} else {
			this.careemailerrorMessage = false;
		}

		return isValid;
	}

	// to validate prescription details
	PrescriptionFieldsForm() {
		let isValid = true;

		// drug

		if (!this.selectedValue) {
			this.drugerrorMessage = true;
			isValid = false;
		} else {
			this.drugerrorMessage = false;
		}

		//Frequency

		if (!this.PrescriptionFields.Frequency) {
			this.frequencyrrorMessage = true;
			isValid = false;
		} else {
			this.frequencyrrorMessage = false;
		}

		// Date of Birth

		if (!this.PrescriptionFields.date) {
			this.dateerrorMessage = true;
			isValid = false;
		} else {
			this.dateerrorMessage = false;
		}
		// FrequencyUnit

		if (!this.selectedunit) {
			this.FrequencyUniterrorMessage = true;
			isValid = false;
		} else {
			this.FrequencyUniterrorMessage = false;
		}

		return isValid;
	}

	//to validate terms and condition checkbox
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

	//to show toast message
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
	//to display terms and condition popup 
	showModal() {
		this.openModal = true;
	}
	//to close terms and condition popup
	closeModal() {
		this.openModal = false;
	}

	//to validate firstname field
	handleFirstNameChange(event) {
		this.firstName = event.target.value;
		this.firstName =
			event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
		const firstNameField = this.template.querySelector(
			'lightning-input[data-field="FN"]'
		);
		if (this.firstName) {
			this.firstnamerequire = false;
			this.firstnamevalid = false;
			if (!/^[a-zA-Z]+$/.test(this.firstName)) {
				this.firstnamevalid = true;
				this.firstnamerequire = false;
				firstNameField.className = 'textInput-err';
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

	//to validate lastname field
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
				this.lastNameChangerequire = false;
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

	//to validate dob field
	handleDobChange(event) {
		const dobField = this.template.querySelector(
			'lightning-input[data-field="dob"]'
		);
		this.dob = event.target.value;
		this.validateDate();
		if (this.dob === '') {
			this.dateofbirthrequire = true;
			this.dateofbirthvaild = false;
			dobField.className = 'textInput-err';
			this.template.querySelector('label[data-field="dob"]').className =
				'input-error-label';
		} else {
			this.dateofbirthrequire = false;
			this.dateofbirthvaild = false;
			dobField.className = 'textInput';
			this.template.querySelector('label[data-field="dob"]').className =
				'input-label';
		}
	}

	//to get lead caregiver from leadid 
	leadCaregiverecordget(resuldId) {
		try {
			leadCaregiver({ leadId: resuldId })
				.then((result) => {
					this.leadCareFirstName = result.BI_PSPB_First_Name__c;
					this.leadCareLastName = result.BI_PSPB_Last_Name__c;
					this.leadCareDob = result.BI_PSPB_Date_of_Birth__c;
					this.leadCareEmail = result.BI_PSPB_E_mail_ID__c;
					this.phoneNumber = result.BI_PSPB_Phone_number__c;
					this.rwp = result.BI_PSPB_Relationship_to_Patient__c;
					this.pmocvalue = result.BI_PSPB_Preferred_Communication_Method__c;
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
				});
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
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
		this.Threedot = false;
		this.mobileview = `  Hello! Welcome to Beyond GPP: The
						Spevigo® Patient Support Program.
						We're excited to help your loved one
						manage their generalized pustular
						psoriasis (GPP) and make the most of
						their Spevigo therapy.
						As this user account is for a minor, we
						require verification of the patients
						information as well as your information
						as their caregiver. Click 'next' to
						proceed if the pre-filled information is
						correct.
						If not, please modify to the correct the
						information and then click 'next'.`;
	}
	//to get avatar content in mobile view
	Xmark() {
		this.mobileview = `Hello! Welcome to Beyond GPP: The Spevigo® Patient....`;
		this.Threedot = true;
	}
}