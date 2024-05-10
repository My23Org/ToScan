// This component is used to retrieve caregiver data, access patient information, and create cases based on the account settings.
// To import Libraries
import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
// To import current user ID
import Id from '@salesforce/user/Id';
//  To import Apex Classes
import updatePatientDetails from '@salesforce/apex/BI_PSPB_exuserGetAccid.updatePatientExcistInfo';
import createCase from '@salesforce/apex/BI_PSPB_caseCtrl.createCase';
import createAccessCase from '@salesforce/apex/BI_PSPB_caseCtrl.createAccessCase';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getCheckboxValues from '@salesforce/apex/BI_PSPB_caseCtrl.checkboxPersonalAccess';
import getCheckboxValuestwo from '@salesforce/apex/BI_PSPB_caseCtrl.checkboxAccountDeletion';
import getpatientinfo from '@salesforce/apex/BI_PSPB_PatientFormCtrl.getPatientInfo';
// To import Custom Labels
import firstname from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_First_Name';
import lastname from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Last_Name';
import dob from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Date_of_birth';
import minor from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Date_fo_birth';
import futuredate from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Future_date';
import abovedate from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_major_date_of_birth';
import email from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Email';
import gender from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Gender';
import phone from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_phone_number';
import mobile from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Phone';
import preferredcontactmethod from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Preffered_contact_method';
import country from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Country';
import state from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_state';
import city from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_City';
import street from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_street';
import pincode from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Pincode';
import validPincode from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Pincode';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import smsstring from '@salesforce/label/c.BI_PSP_NotificationSMS';
import phonestring from '@salesforce/label/c.BI_PSPB_Phone';
import emailstring from '@salesforce/label/c.BI_PSP_NotificationEmail';
import Male from '@salesforce/label/c.BI_PSP_male';
import Female from '@salesforce/label/c.BI_PSP_female';
import Prefernot from '@salesforce/label/c.BI_PSP_prefernot_tosay';
import Others from '@salesforce/label/c.BI_PSP_Others';
// To import Static Resources
import warning from '@salesforce/resourceUrl/BI_PSPB_WarningIcon';
import righticon from '@salesforce/resourceUrl/BI_PSP_Deletetoastmsg';
import Boxedicon from '@salesforce/resourceUrl/BI_PSP_Boxedicon';
import textalign from '@salesforce/resourceUrl/BI_PSPB_TextAlignmentHcp';
//To import field from Account
import COUNTRY_FIELD from '@salesforce/schema/Account.PersonMailingCountryCode';
import STATE_FIELD from '@salesforce/schema/Account.PersonMailingStateCode';

export default class BiPspbCgPatientinfo extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @api

	@api isLoaded = false;
	@api account;
	@api caregiverForm;
	@api selectedValue;
	// Declaration of variables with @track
	@track patientFirstName = '';
	@track showDiv = false;
	@track showDiv1 = false;
	@track isFirstNameDisabled = true;
	@track isLastNameDisabled = true;
	@track isDOBDisabled = true;
	@track isEmailDisabled = true;
	@track isMobilePhoneDisabled = true;
	@track isGenderDisabled = true;
	@track isPOMDisabled = true;
	@track isMaillingCountryDisabled = true;
	@track isMaillingStateDisabled = true;
	@track isMaillingStreetDisabled = true;
	@track isMaillingPostalcodeDisabled = true;
	@track isMaillingCityDisabled = true;
	@track firstnameerrorMessage = false;
	@track lastnameerrorMessage = false;
	@track relationshiperrorMessage = false;
	@track doberrorMessage = false;
	@track emailerrorMessage = false;
	@track phoneerrorMessage = false;
	@track MobileerrorMessage = false;
	@track genderMessage = false;
	@track pmcMessage = false;
	@track countrycodeMessage = false;
	@track statecodeMessage = false;
	@track cityMessage = false;
	@track streetMessage = false;
	@track postalCodeMessage = false;

	@track isCaregiver = false;
	@track patientId;
	@track patientLastName = '';
	@track patientDOB = '';
	@track patientAge = '';
	@track patientGender = '';
	@track patientEmail = '';
	@track preferredCommunication = '';
	@track patientMobilePhone = '';
	@track patientCountry = '';
	@track patientState = '';
	@track patientCity = '';
	@track patientStreet = '';
	@track patientZipCode = '';
	@track PersonBirthDate = '';

	@track futureDobError;
	@track openModal = false;
	@track validerrorMessage = false;
	@track FirstName;
	@track accountId;
	@track result;
	@track isDeletePopupOpen = false;
	@track isAccessPopupOpen = false;
	@track isAdult = false;
	@track relation = [];
	@track selectedCountryCode = '';
	@track selectedStateCode = '';
	@track countryCode = [];

	@track relations = '';

	@track country;
	@track state;

	@track deletepopup;
	@track accesspopup;

	@track GendererrorMessage = false;
	@track DeleteMessage = false;
	@track accessmessage = false;
	@track colorchnage = 'outlined-button' //css class
	@track colorchanage = 'outlined-button' //css class
	@track Boxedicon = Boxedicon;
	@track minorerror = false;
    @track leadPmc = [{ label: Male, value: Male },
		{ label: Female, value: Female },
		{ label: Prefernot, value: Prefernot },
		{ label: Others, value: Others }
		];
	@track preffer = [
		{ label: smsstring, value: smsstring },
		{ label: phonestring, value: phonestring },
		{ label: emailstring, value: emailstring }
	];	
	@track phoneNumberMandatory = false;
	@track firstNameerrorMessag = false;
	@track updatePopup = false;
	@track touch = false;
	@track down = true;
	@track up = false;
	// Declaration of Global variables
	enrolleeids;
	isButtonDeleteDisabled = false;
	isAccessButtonDisabled = false;

	userId = Id;
	caregiverAccountIds;
	rightimg = righticon;
	label = { firstname, lastname, dob, email, abovedate, futuredate, gender, minor, phone, mobile, preferredcontactmethod, country, state, city, street, pincode, validPincode };
	Warningicon = warning;
	StateCode = [];
	checkbox1Value;
	checkbox2Value;



	// Wire method to retrieve object information for the Account object

	@wire(getObjectInfo, { objectApiName: 'Account' })
	objectInfo;

	//Wire method to retrieve country values
	@wire(getPicklistValues, {
		recordTypeId: '$objectInfo.data.defaultRecordTypeId',
		fieldApiName: COUNTRY_FIELD
	})
	CountryValues({ data, error }) {
		try {
			if (data) {

				this.countryCode = data.values.map(option => ({
					label: option.label,
					value: option.value
				}));
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}

	}

	// Wire method to retrieve picklist values for the State field based on the default record type ID,
	// field API name, and controlling field value (country)
	@wire(getPicklistValues, {
		recordTypeId: '$objectInfo.data.defaultRecordTypeId',
		fieldApiName: STATE_FIELD,
		controllingFieldValue: '$country'
	})
	StateValues({ data, error }) {
		try {
			if (data) {
				this.StateCode = data.values.map(option => ({
					label: option.label,
					value: option.value
				}));
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error 
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}

	}
	//getcurrunt enrollee

	connectedCallback() {
		loadStyle(this, textalign);
		try {
			getEnrolle({ userId: this.userId })

				.then(result => {


					if (result != null) {
						if (result[0].patientEnrolle != null) {
							this.enrolleeids = result[0].patientEnrolle.Id;

						} else if (result[0].error != null) {
							this.showError = true;
							this.errorMessage = result[0].error;
						}
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
				});
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //Catching Potential Error from LWC

		}

	}

	//wire method for prepopulating patient information
	@wire(getpatientinfo)
	wiredCaregiverAccounts({ error, data }) {
		try {
			if (data && data !== null) {
				this.accountId = data.Id;
				this.patientFirstName = data.FirstName;
				this.patientLastName = data.LastName;
				this.patientDOB = data.BI_PSP_Birthdate__c;
				this.patientAge = data.BI_PSP_Age__c;
				this.patientEmail = data.PersonEmail;
				this.patientMobilePhone = data.Phone;
				this.relations = data.HealthCloudGA__Gender__pc;
				this.preferredCommunication = data.BI_PSPB_Preferred_Communication_Method__c;
				this.country = data.PersonMailingCountryCode;
				this.state = data.PersonMailingStateCode;
				this.patientCity = data.PersonMailingCity;
				this.patientStreet = data.PersonMailingStreet;
				this.patientZipCode = data.PersonMailingPostalCode;


				if ((this.patientDOB !== null || this.patientDOB !== undefined) && this.patientAge <= 18) {
					this.phoneNumberMandatory = true;
					this.isFirstNameDisabled = false;
					this.isLastNameDisabled = false;
					this.isDOBDisabled = false;
					this.isGenderDisabled = false;
					this.isEmailDisabled = false;
					this.isMobilePhoneDisabled = false;
					this.isPOMDisabled = false;
					this.isMaillingCityDisabled = false;
					this.isMaillingCountryDisabled = false;
					this.isMaillingPostalcodeDisabled = false;
					this.isMaillingStateDisabled = false;
					this.isMaillingStreetDisabled = false;
					this.isMobilePhoneDisabled = false;
					this.isAdult = true;
				}
				else if ((this.patientDOB !== null || this.patientDOB !== undefined) && this.patientAge > 18) {
					this.isFirstNameDisabled = true;
					this.isLastNameDisabled = true;
					this.isDOBDisabled = true;
					this.isGenderDisabled = true;
					this.isEmailDisabled = true;
					this.isMobilePhoneDisabled = false;
					this.isPOMDisabled = false;
					this.isMaillingCityDisabled = false;
					this.isMaillingCountryDisabled = false;
					this.isMaillingPostalcodeDisabled = false;
					this.isMaillingStateDisabled = false;
					this.isMaillingStreetDisabled = false;
					this.isMobilePhoneDisabled = false;
					this.isAdult = false;
				}

			}

			else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
			else if (data === null) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //Catching Potential Error from LWC

		}
	}
	//Get the checkbox values from created cases for patient in account setting(Request access)
	@wire(getCheckboxValues, { relatedAccounts: '$accountId' })
	wiredCheckboxValues({ data, error }) {
		try {
			/*For a null check, the error is logged. It cannot be thrown as an Aura handled Exception because there may 
          be a possibility the user has no case records. The toast message can be disruptive to the UI/UX design.*/
			if (data) {

				this.checkbox1Value = data.BI_PSP_Personal_Information_Request__c;

				if (this.checkbox1Value === true) {
					this.isAccessButtonDisabled = false;
					this.colorchnage = 'outlined-button'

				}
				else {
					this.isAccessButtonDisabled = true;
					this.colorchnage = 'button-bttn'
					this.accessmessage = true;
				}
			}
			else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //Catching Potential Error from LWC

		}

	}
	//Get the checkbox values from created cases for patient in account setting (Delete Access)
	@wire(getCheckboxValuestwo, { relatedAccounts: '$accountId' })
	wiredCheckboxValuestwo({ data, error }) {
		try {
			/*For a null check, the error is logged. It cannot be thrown as an Aura handled Exception because there may 
          be a possibility the user has no case records. The toast message can be disruptive to the UI/UX design.*/
			if (data) {

				this.checkbox2Value = data.BI_PSP_Account_Deletion_Request__c;
				if (this.checkbox2Value === true) {
					this.isButtonDeleteDisabled = false;
					this.colorchanage = 'outlined-button'
				}
				else {
					this.isButtonDeleteDisabled = true;
					this.colorchanage = 'button-bttn'
					this.DeleteMessage = true;
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //Catching Potential Error from LWC

		}

	}

	//to validate the first name
	handleFieldChange(event) {
		// Assuming you're using event.target.value to get the value from the input field
		this.patientFirstName = event.target.value;
		this.patientFirstName = event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);

		this.firstNameerrorMessag = false;


		this.validateFirstName(); // Call the method to validate the first name
	}

	// to validate the first name
	validateFirstName() {
		if (!this.patientFirstName) {
			this.firstNameerrorMessag = true;
			// Add CSS classes to highlight the input field and label with an error
			//to get data field value from html
			this.template.querySelector('lightning-input[data-field="FirstName"]').classList.add('textInput-err');
			this.template.querySelector('label[data-field="FirstName"]').classList.add('input-error-label');
		} else {
			this.firstNameerrorMessag = false;
			// Remove CSS classes if the validation passes
			this.template.querySelector('lightning-input[data-field="FirstName"]').classList.remove('textInput-err');
			this.template.querySelector('label[data-field="FirstName"]').classList.remove('input-error-label');
		}
	}


	// to validate the last name
	handlelastname(event) {

		this.patientLastName = event.target.value;
		this.patientLastName = event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);

		this.lastnameerrorMessage = false;
		this.validatelastName();

	}

	// to validate the last name
	validatelastName() {
		if (!this.patientLastName) {
			this.lastnameerrorMessage = true;
			// Add CSS classes to highlight the input field and label with an error
			this.template.querySelector('lightning-input[data-field="LastName"]').classList.add('textInput-err');
			this.template.querySelector('label[data-field="LastName"]').classList.add('input-error-label');
		} else {
			this.lastnameerrorMessage = false;
			// Remove CSS classes if the validation passes
			this.template.querySelector('lightning-input[data-field="LastName"]').classList.remove('textInput-err');
			this.template.querySelector('label[data-field="LastName"]').classList.remove('input-error-label');
		}
	}

	// Validate that the date is not in the future
	agecalculationEvent(event) {
		this.patientDOB = event.target.value;
		this.doberrorMessage = false;
		this.validateDate();

	}

	// Validate that the date is not in the future
	validateDate() {


		const currentDate = new Date();
		const selectedDate = new Date(this.patientDOB);
		if (selectedDate > currentDate) {
			this.minorerror3 = true;
			this.minorerror2 = false;
			this.doberrorMessage = false;
			this.minorerror = false;
			this.template.querySelector('lightning-input[data-field="Birthdate"]').className = "textInput-err";
			this.template.querySelector('label[data-field="Birthdate"]').className = "input-error-label";
		}
		else {
			this.minorerror3 = false;
			this.template.querySelector('lightning-input[data-field="Birthdate"]').className = "textInput";
			this.template.querySelector('label[data-field="Birthdate"]').className = "input-label";
		}

		// Validate that the user is not a minor (you can set a minimum age)
		const minAge = 18;
		const userBirthYear = selectedDate.getFullYear();
		const currentYear = currentDate.getFullYear();

		if (currentYear - userBirthYear < minAge) {
			this.doberrorMessage = false;
			this.minorerror = true;
			this.minorerror3 = false;
			this.minorerror2 = false;
			this.doberrorMessage = false;
			this.template.querySelector('lightning-input[data-field="Birthdate"]').className = "textInput-err";
			this.template.querySelector('label[data-field="Birthdate"]').className = "input-error-label";
		}
		else {
			this.doberrorMessage = false;
			this.minorerror = false;
			this.minorerror2 = false;
			this.minorerror3 = false;
			this.template.querySelector('lightning-input[data-field="Birthdate"]').className = "textInput-err";
			this.template.querySelector('label[data-field="Birthdate"]').className = "input-error-label";
		}
		//get full year
		if (selectedDate < new Date('1900-01-01')) {
			this.minorerror2 = true;
			this.minorerror3 = false;
			this.doberrorMessage = false;
			this.minorerror = false;
			this.template.querySelector('lightning-input[data-field="Birthdate"]').className = "textInput-err";
			this.template.querySelector('label[data-field="Birthdate"]').className = "input-error-label";
		}
		else {
			this.minorerror2 = false;
			this.minorerror3 = false;
			this.doberrorMessage = false;
			this.minorerror = false;
			this.template.querySelector('lightning-input[data-field="Birthdate"]').className = "textInput";
			this.template.querySelector('label[data-field="Birthdate"]').className = "input-label";
		}


		// If both validations pass, clear the error message

		this.doberrorMessage = '';

		this.doberrorMessage = false;
	}

	//to validate phone field
	handleFielphone(event) {
		this.patientMobilePhone = event.target.value;
		this.phoneerrorMessage = false;
		this.template.querySelector('lightning-input[data-field="phone"]').className = "textInput";
		this.template.querySelector('label[data-field="phone"]').className = "input-label";

	}
	//to validate relationship field
	relationshipEvent(event) {
		this.relations = event.target.value;
		this.relationshiperrorMessage = false;
		this.template.querySelector('lightning-combobox[data-field="relationship"]').className = "textInput";
		this.template.querySelector('label[data-field="relationship"]').className = "input-label";

	}
	//to validate preferred communication method
	handlePmcChange(event) {
		this.preferredCommunication = event.target.value;
		this.conPmcErrorMessage = false;
		this.template.querySelector('lightning-combobox[data-field="conPmc"]').className = "textInput";
		this.template.querySelector('label[data-field="conPmc"]').className = "input-label";
	}
	//to validate country field
	handleFielcountry(event) {
		this.country = event.target.value;
		this.countrycodeMessage = false;
		this.template.querySelector('lightning-combobox[data-field="country"]').className = "textInput";
		this.template.querySelector('label[data-field="country"]').className = "input-label";
	}
	//to validate state field
	handleFieldstate(event) {
		this.state = event.target.value;
		this.statecodeMessage = false;
		this.template.querySelector('lightning-combobox[data-field="state"]').className = "textInput";
		this.template.querySelector('label[data-field="state"]').className = "input-label";
	}
	//to validate city field
	handleFieldCity(event) {
		this.patientCity = event.target.value;
		this.cityMessage = false;
		this.template.querySelector('lightning-input[data-field="city"]').className = "textInput";
		this.template.querySelector('label[data-field="city"]').className = "input-label";
	}
	//validate street field
	handleFieldstreet(event) {
		this.patientStreet = event.target.value;
		this.streetMessage = false;
		this.template.querySelector('lightning-input[data-field="street"]').className = "textInput";
		this.template.querySelector('label[data-field="street"]').className = "input-label";
	}
	//validate pincode field
	handleFieldcode(event) {
		this.patientZipCode = event.target.value;
		this.postalCodeMessage = false;
		this.template.querySelector('lightning-input[data-field="zipcode"]').className = "textInput";
		this.template.querySelector('label[data-field="zipcode"]').className = "input-label";


	}

	//validate phone field
	validatePhoneInput(event) {
		const charCode = event.which ? event.which : event.keyCode; // Get the ASCII code of the pressed key
		if (charCode !== 43 && (charCode < 48 || charCode > 57)) { // Allow only digits (48-57) and the plus symbol (43)
			event.preventDefault(); // Prevent the character from being entered
		}
	}

	//firstname and lastname regex
	handleKeyDown1(event) {
    const allowedCharacters = /^[A-Za-z]+$/;
    if (!allowedCharacters.test(event.key)) {
        event.preventDefault();
    }
}
// Not allow paste event in firstname and last name
	handlePaste(event) {
		// Prevent default paste behavior
		event.preventDefault();
	}
	//checks whether all fields have values and updates patient information
	handle_Success() {

		const FirstNameField = this.template.querySelector('lightning-input[data-field="FirstName"]');
		if (!this.patientFirstName) {

			this.firstNameerrorMessag = true;
			FirstNameField.className = 'textInput-err';
			this.template.querySelector('label[data-field="FirstName"]').className = "input-error-label";

		}
		else {
			this.firstNameerrorMessag = false;
			FirstNameField.className = 'textInput';
			this.template.querySelector('label[data-field="FirstName"]').className = "input-label";

		}
		if (!this.patientLastName) {

			this.lastnameerrorMessage = true;
			this.template.querySelector('lightning-input[data-field="LastName"]').className = "textInput-err";
			this.template.querySelector('label[data-field="LastName"]').className = "input-error-label";

		}
		else {
			this.lastnameerrorMessage = false;
			this.template.querySelector('lightning-input[data-field="LastName"]').className = "textInput";
			this.template.querySelector('label[data-field="LastName"]').className = "input-label";

		}
		if (!this.patientDOB) {
			this.doberrorMessage = true;
			this.template.querySelector('lightning-input[data-field="Birthdate"]').className = "textInput-err";
			this.template.querySelector('label[data-field="Birthdate"]').className = "input-error-label";

		}

		if (!this.relations) {
			this.relationshiperrorMessage = true;
			this.template.querySelector('lightning-combobox[data-field="relationship"]').className = "textInput-err";
			this.template.querySelector('label[data-field="relationship"]').className = "input-error-label";

		}

		if (!this.country) {
			this.countrycodeMessage = true;
			this.template.querySelector('lightning-combobox[data-field="country"]').className = "textInput-err";
			this.template.querySelector('label[data-field="country"]').className = "input-error-label";

		}

		if (!this.state) {
			this.statecodeMessage = true;
			this.template.querySelector('lightning-combobox[data-field="state"]').className = "textInput-err";
			this.template.querySelector('label[data-field="state"]').className = "input-error-label";

		}
		if (!this.patientCity) {
			this.cityMessage = true;
			this.template.querySelector('lightning-input[data-field="city"]').className = "textInput-err";
			this.template.querySelector('label[data-field="city"]').className = "input-error-label";

		}

		if (!this.patientStreet) {
			this.streetMessage = true;
			this.template.querySelector('lightning-input[data-field="street"]').className = "textInput-err";
			this.template.querySelector('label[data-field="street"]').className = "input-error-label";

		}

		if (!this.patientZipCode) {
			this.postalCodeMessage = true;
			this.template.querySelector('lightning-input[data-field="zipcode"]').className = "textInput-err";
			this.template.querySelector('label[data-field="zipcode"]').className = "input-error-label";

		}

		if (!this.patientMobilePhone) {
			this.phoneerrorMessage = true;
			this.template.querySelector('lightning-input[data-field="phone"]').className = "textInput-err";
			this.template.querySelector('label[data-field="phone"]').className = "input-error-label";

		}
		if (!this.preferredCommunication) {
			this.conPmcErrorMessage = true;
			this.template.querySelector('lightning-combobox[data-field="conPmc"]').className = "textInput-err";
			this.template.querySelector('label[data-field="conPmc"]').className = "input-error-label";

		}
		if (!this.patientEmail) {
			this.phoneerrorMessage = true;
			this.template.querySelector('lightning-input[data-field="email"]').className = "textInput-err";
			this.template.querySelector('label[data-field="email"]').className = "input-error-label";

		}

		else if (!this.doberrorMessage && !this.firstNameerrorMessag && !this.lastnameerrorMessage && !this.relationshiperrorMessage && !this.countrycodeMessage && !this.statecodeMessage && !this.cityMessage && !this.streetMessage && !this.postalCodeMessage && !this.phoneerrorMessage && !this.conPmcErrorMessage) {

			let caregiverDetails = {
				accountId: this.accountId, FirstName: this.patientFirstName, LastName: this.patientLastName, PersonEmail: this.patientEmail, PersonBirthdate: this.patientDOB, PersonGender: this.relations,
				PreferredMethodofContact: this.preferredCommunication, street: this.patientStreet, city: this.patientCity, state: this.state, country: this.country, postalCode: this.patientZipCode, phone: this.patientMobilePhone
			};


			updatePatientDetails({
				wrapper: caregiverDetails
			})
				.then(() => {
					this.updatePopup = true;
					window.scrollTo({ top: 0, behavior: 'smooth' });
				})
				.catch(error => {
					this.updatePopup = false;
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
				});
		}


	}



	// Now use this placeholderText in your template

	handleDeletPopup() {
		this.isDeletePopupOpen = !this.isDeletePopupOpen;

	}


	handleAccessPopup() {
		this.isAccessPopupOpen = !this.isAccessPopupOpen;
		this.accesspopup = false;
	}

	handleYesButtonClick() {

		this.isButtonDeleteDisabled = true;

		this.colorchanage = 'button-bttn'
		this.DeleteMessage = true;
		this.deletepopup = true;
		this.isDeletePopupOpen = false;
		this.showDiv1 = true;


		// Call the Apex method to create a case

		createCase()
			.then(() => {
				window.scrollTo({ top: 0, behavior: 'smooth' });
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
			});


		if (this.checkbox1Value.checked) {
			this.isButtonDeleteDisabled = false;
		}
		else {
			this.isButtonDeleteDisabled = true;
		}

	}

	showToast(title, message, variant) {
		const toastEvent = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant,
		});
		this.dispatchEvent(toastEvent);
	}

	handleYesButtonClick2() {

		this.isAccessPopupOpen = false;
		this.isAccessButtonDisabled = true;
		this.colorchnage = 'button-btn'
		this.accessmessage = true;
		this.accesspopup = true;

		this.showDiv = true;


		// Call the Apex method to create a case

		createAccessCase()
			.then(() => {
				window.scrollTo({ top: 0, behavior: 'smooth' });
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
			});


		if (this.checkbox2Value.checked) {
			this.isAccessButtonDisabled = false;
		}
		else {
			this.isAccessButtonDisabled = true;
		}
	}


	handleclose() {
		this.showDiv = false;
		this.showDiv1 = false;
		this.updatePopup = false;
	}

	click() {
		this.touch = true;
		this.down = false;
		this.up = true;
	}
	notclick() {
		this.touch = false;
		this.down = true;
		this.up = false;
	}


}