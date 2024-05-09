// The lightning component is designed to retrieve and update caregiver details from the account object
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import UserCaregiver from '@salesforce/apex/BI_PSPB_exuserGetAccid.UserCaregiver';
import UserCaregivers from '@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver';
import updateCaregiverDetails from '@salesforce/apex/BI_PSPB_exuserGetAccid.updateCaregiverDetails';
//To import Static Resource
import righticon from '@salesforce/resourceUrl/BI_PSP_Deletetoastmsg';
import warning from '@salesforce/resourceUrl/BI_PSPB_WarningIcon';
// To get Current UserId
import Id from '@salesforce/user/Id';
// To import Custom Labels
import smsstring from '@salesforce/label/c.BI_PSP_NotificationSMS';
import phonestring from '@salesforce/label/c.BI_PSPB_Phone';
import emailstring from '@salesforce/label/c.BI_PSP_NotificationEmail';
import parentstring from '@salesforce/label/c.BI_PSP_NotificationParent';
import siblingstring from '@salesforce/label/c.BI_PSP_NotificationSibling';
import lovedone from '@salesforce/label/c.BI_PSP_NotificationLovedone';
import guardian from '@salesforce/label/c.BI_PSP_NotificationGuardian';
import friend from '@salesforce/label/c.BI_PSP_NotificationFriend';
import otherrelative from '@salesforce/label/c.BI_PSP_NotificationOtherRelative';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import firstnamel from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_First_Name';
import lastnamel from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Last_Name';
import dateofbirth from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Date_fo_birth';
import relationship from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Relationship';
import email from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Email';
import futuredate from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Future_date';
import pcm from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Preffered_contact_method';
import phonefield from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_phone_number';
import majordate from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_major_date_of_birth';
import dob from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Date_of_birth';
import caregiverprofiledoberror from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Date_fo_birth';
import undefinedvalue from '@salesforce/label/c.BI_PSP_Undefined';


export default class BiPspbCareGiverProfile extends LightningElement {

	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track updatePopup = false;
	@track Default_avatar_JPEG_URL = '';
	@track preffer = [
		{ label: smsstring, value: smsstring },
		{ label: phonestring, value: phonestring },
		{ label: emailstring, value: emailstring }
	];
	@track errorMessage = '';
	@track minorerror = false;
	@track accname;
	@track emailerrorMessage = false;
	@track phoneerrorMessage = false;
	@track pcmerrorMessage = false;
	@track relationshiperrorMessage = false;
	@track FirstNameerrorMessage = false;
	@track doberrorMessage = false;
	@track showContactNumber = false;
	@track LastNameerrorMessage = false;
	@track FirstName;
	@track LastName;
	@track Birthdate;
	@track Relationshipval;
	@track PersonEmailval;
	@track minorerror2;
	@track minorerror3;
	@track Phoneval;
	@track error = false;
	@track dateOfBirth;
	@track age;
	@track selectedAvatarSrc;
	@track futureerror = false;
	@track majorerror = false;
	@track communicationmode;
	@track phoneNumberMandatory = false;
	@track phoneNumberVisible = true;
	@track pmcrequire = false;
	@track accountidval;
	@track leadPmc = [
		{ label: parentstring, value: parentstring },
		{ label: siblingstring, value: siblingstring },
		{ label: lovedone, value: lovedone },
		{ label: guardian, value: guardian },
		{ label: friend, value: friend },
		{ label: otherrelative, value: otherrelative }
	];
	//Global variables(without @track does not trigger automatic re-renders)
	rightimg = righticon;
	label = {
		firstnamel,
		futuredate,
		majordate,
		dob,
		lastnamel,
		phonefield,
		pcm,
		dateofbirth,
		relationship,
		email
	};
	warning = warning;
	userId = Id;
	dob;
	name;

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To reterive the caregiver account details
	@wire(UserCaregiver)
	wiredUserCaregiver({ error, data }) {
		try {
			if (data && data.length > 0) {
				this.accname = data;
				this.accountidval = data[0]?.Id;
				this.FirstName = data[0]?.FirstName;
				this.LastName = data[0]?.LastName;
				this.Birthdate = data[0]?.BI_PSP_Birthdate__c;
				this.Relationshipval = data[0]?.BI_PSPB_Relationship_to_Patient__c;
				this.PersonEmailval = data[0]?.PersonEmail;
				this.Phoneval = data[0]?.Phone;
				this.communicationmode =
					data[0]?.BI_PSPB_Preferred_Communication_Method__c;

				if (typeof this.Phoneval === undefinedvalue) {
					this.Phoneval = '';
				}

				if (
					this.communicationmode === smsstring ||
					this.communicationmode === phonestring
				) {
					this.phoneNumberMandatory = true;
					this.phoneNumberVisible = false;
				}
			} else if (error) {
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To close popup and reload the page
	handleclose() {
		this.updatePopup = false;
		window.location.reload();
	}

	// To validate the date of birth
	validateDate() {
		// Validate that the date is not in the future
		const currentDate = new Date();
		const selectedDate = new Date(this.patientDOB);

		if (selectedDate > currentDate) {
			this.minorerror3 = true;
			this.minorerror2 = false;
			this.doberrorMessage = false;
			this.minorerror = false;
			this.template.querySelector(
				'lightning-combobox[data-field="Birthdate"]'
			).className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';

			return;
		}
		this.minorerror3 = false;
		this.template.querySelector(
			'lightning-combobox[data-field="Birthdate"]'
		).className = 'textInput';
		this.template.querySelector('label[data-field="Birthdate"]').className =
			'input-label';

		// Validate that the user is not a minor (you can set a minimum age)
		const minAge = 18;
		const userBirthYear = selectedDate.getFullYear();
		const currentYear = currentDate.getFullYear();

		if (currentYear - userBirthYear < minAge) {
			//   this.dobErrorMessage = false;

			this.doberrorMessage = false;
			this.minorerror = true;
			this.minorerror3 = false;
			this.minorerror2 = false;
			this.doberrorMessage = false;
			this.template.querySelector(
				'lightning-combobox[data-field="Birthdate"]'
			).className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';
			return;
		}
		this.doberrorMessage = false;
		this.minorerror = false;
		this.minorerror2 = false;
		this.minorerror3 = false;
		this.template.querySelector(
			'lightning-comboboxt[data-field="Birthdate"]'
		).className = 'textInput-err';
		this.template.querySelector('label[data-field="Birthdate"]').className =
			'input-error-label';

		//get full year
		if (selectedDate < new Date('1900-01-01')) {
			this.minorerror2 = true;
			this.minorerror3 = false;
			this.doberrorMessage = false;
			this.minorerror = false;
			this.template.querySelector(
				'lightning-combobox[data-field="Birthdate"]'
			).className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';

			return;
		}
		this.minorerror2 = false;
		this.minorerror3 = false;
		this.doberrorMessage = false;
		this.minorerror = false;
		this.template.querySelector(
			'lightning-combobox[data-field="Birthdate"]'
		).className = 'textInput';
		this.template.querySelector('label[data-field="Birthdate"]').className =
			'input-label';

		// If both validations pass, clear the error message

		this.doberrorMessage = '';
	}

	// To validate the Birth date
	validateBirthdate() {
		const birthdateField = this.template.querySelector(
			'lightning-input[data-field="Birthdate"]'
		);

		if (!this.Birthdate || this.Birthdate === null || this.Birthdate === '') {
			this.doberrorMessage = true;
			// Add CSS classes to highlight the input field and label with an error

			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';
			this.template.querySelector('[data-field="dob-error"]').textContent =
				'Date of birth field is required';
		} else {
			this.doberrorMessage = false;
			// Remove CSS classes if the validation passes
			birthdateField.classList.remove('textInput-err');
			this.template
				.querySelector('label[data-field="Birthdate"]')
				.classList.remove('input-error-label');

		}
		this.handlefinaldata();
	}

	// To validate the First Name
	validateFirstName() {
		if (!this.FirstName) {
			this.firstNameerrorMessage = true;
			// Add CSS classes to highlight the input field and label with an error
			this.template
				.querySelector('lightning-input[data-field="FirstName"]')
				.classList.add('textInput-err');
			this.template
				.querySelector('label[data-field="FirstName"]')
				.classList.add('input-error-label');
		} else {
			this.firstNameerrorMessage = false;
		}
	}

	// To validate the Last Name
	validatelastName() {
		if (!this.LastName) {
			this.LastNameerrorMessage = true;
			// Add CSS classes to highlight the input field and label with an error
			this.template
				.querySelector('lightning-input[data-field="LastName"]')
				.classList.add('textInput-err');
			this.template
				.querySelector('label[data-field="LastName"]')
				.classList.add('input-error-label');
		} else {
			this.LastNameerrorMessage = false;
		}
	}

	// All the event function to capture the event record
	handlenamechange(event) {
		this.FirstName = event.target.value;
		this.validateFirstName();
		this.patientvalidateForm();
	}

	handlelastnamechange(event) {
		this.LastName = event.target.value;
		this.validatelastName();
		this.patientvalidateForm();

	}
	changebirthdata(event) {
		this.Birthdate = event.target.value;
	}

	relationshipEvent(event) {
		this.Relationshipval = event.target.value;
	}

	validatephonechange() {
		if (
			this.communicationmode === smsstring ||
			this.communicationmode === phonestring
		) {
			if (
				!this.Phoneval ||
				this.Phoneval === '' ||
				this.Phoneval.length === 0
			) {
				this.phoneerrorMessage = true;
				this.template.querySelector(
					'lightning-input[data-field="MobilePhone"]'
				).className = 'textInput-err';
				this.template.querySelector(
					'label[data-field="MobilePhone"]'
				).className = 'input-error-label';
				this.template
					.querySelector('lightning-input[data-field="MobilePhone"]')
					.classList.add('textInput-err');
				this.template
					.querySelector('label[data-field="MobilePhone"]')
					.classList.add('input-error-label');
			} else {
				this.template
					.querySelector('lightning-input[data-field="MobilePhone"]')
					.classList.remove('textInput-err');
				this.template
					.querySelector('label[data-field="MobilePhone"]')
					.classList.remove('input-error-label');
				this.template
					.querySelector('lightning-input[data-field="MobilePhone"]')
					.classList.remove('textInput');
				this.template
					.querySelector('label[data-field="MobilePhone"]')
					.classList.remove('input-label');
				this.phoneerrorMessage = false;
			}
		} else {
			this.template
				.querySelector('lightning-input[data-field="MobilePhone"]')
				.classList.remove('textInput-err');
			this.template
				.querySelector('label[data-field="MobilePhone"]')
				.classList.remove('input-error-label');
			this.phoneerrorMessage = false;
		}
	}

	phonechangeevent(event) {
		this.Phoneval = event.target.value;

		if (
			this.communicationmode === smsstring ||
			this.communicationmode === phonestring
		) {
			if (
				!this.Phoneval ||
				this.Phoneval === '' ||
				this.Phoneval.length === 0
			) {
				this.phoneerrorMessage = true;
				this.template.querySelector(
					'lightning-input[data-field="MobilePhone"]'
				).className = 'textInput-err';
				this.template.querySelector(
					'label[data-field="MobilePhone"]'
				).className = 'input-error-label';
				this.template
					.querySelector('lightning-input[data-field="MobilePhone"]')
					.classList.add('textInput-err');
				this.template
					.querySelector('label[data-field="MobilePhone"]')
					.classList.add('input-error-label');
			} else {
				this.template
					.querySelector('lightning-input[data-field="MobilePhone"]')
					.classList.remove('textInput-err');
				this.template
					.querySelector('label[data-field="MobilePhone"]')
					.classList.remove('input-error-label');
				this.phoneerrorMessage = false;
			}
		}
	}

	// Validate and update input values
	patientvalidateForm() {
		let isValid = true;

		const emailField = this.template.querySelector(
			'lightning-input[data-field="email"]'
		);
		if (!emailField.value) {
			this.emailerrorMessage = true;
			isValid = false;
			emailField.className = 'textInput-err';
			this.template.querySelector('label[data-field="email"]').className =
				'input-error-label';
		} else {
			this.emailerrorMessage = false;

			emailField.className = 'textInput';
			this.template.querySelector('label[data-field="email"]').className =
				'input-label';
		}

		const FirstNameField = this.template.querySelector(
			'lightning-input[data-field="FirstName"]'
		);
		if (!FirstNameField.value) {
			this.FirstNameerrorMessage = true;
			isValid = false;
			FirstNameField.className = 'textInput-err';
			this.template.querySelector('label[data-field="FirstName"]').className =
				'input-error-label';
		} else {
			this.FirstNameerrorMessage = false;

			FirstNameField.className = 'textInput';
			this.template.querySelector('label[data-field="FirstName"]').className =
				'input-label';
		}
		const lastnameField = this.template.querySelector(
			'lightning-input[data-field="LastName"]'
		);
		if (!lastnameField.value) {
			this.LastNameerrorMessage = true;
			isValid = false;
			lastnameField.className = 'textInput-err';
			this.template.querySelector('label[data-field="LastName"]').className =
				'input-error-label';
		} else {
			this.LastNameerrorMessage = false;

			lastnameField.className = 'textInput';
			this.template.querySelector('label[data-field="LastName"]').className =
				'input-label';
		}
		const relationshipField = this.template.querySelector(
			'lightning-input[data-field="Relationship"]'
		);
		if (!relationshipField.value) {
			this.relationshiperrorMessage = true;
			isValid = false;
			relationshipField.className = 'textInput-err';
			this.template.querySelector(
				'label[data-field="Relationship"]'
			).className = 'input-error-label';
		} else {
			this.relationshiperrorMessage = false;

			relationshipField.className = 'textInput';
			this.template.querySelector(
				'label[data-field="Relationship"]'
			).className = 'input-label';
		}

		const BirthdateField = this.template.querySelector(
			'lightning-input[data-field="Birthdate"]'
		);
		const Phonefield = this.template.querySelector(
			'lightning-input[data-field="MobilePhone"]'
		);
		const Preferredmodefield = this.template.querySelector(
			'lightning-input[data-field="PreferredMethodofCommunication"]'
		);

		if (BirthdateField.value) {
			this.phoneerrorMessage = true;
			Phonefield.className = 'textInput-err';
			this.template.querySelector('label[data-field="MobilePhone"]').className =
				'input-error-label';
			if (Phonefield.value) {
				this.phoneerrorMessage = false;
				Phonefield.className = 'textInput';
				this.template.querySelector(
					'label[data-field="MobilePhone"]'
				).className = 'input-label';
			}
			this.pcmerrorMessage = true;
			Preferredmodefield.className = 'textInput-err';
			this.template.querySelector(
				'label[data-field="PreferredMethodofCommunication"]'
			).className = 'input-error-label';
			if (Preferredmodefield.value) {
				this.pcmerrorMessage = false;
				Preferredmodefield.className = 'textInput';
				this.template.querySelector(
					'label[data-field="PreferredMethodofCommunication"]'
				).className = 'input-label';
			}
			const dobDate = this.Birthdate;
			const today = new Date();
			const age = today.getFullYear() - dobDate.getFullYear();
			if (age <= 18) {
				this.minorerror = true;
				this.futureerror = false;
				this.majorerror = false;
				this.doberrorMessage = false;

				isValid = false;
				BirthdateField.className = 'textInput-err';
				this.template.querySelector('label[data-field="Birthdate"]').className =
					'input-error-label';
			} else {
				isValid = false;
				this.minorerror = false;
				this.futureerror = false;
				this.majorerror = false;
				this.doberrorMessage = false;
				BirthdateField.className = 'textInput';
				this.template.querySelector('label[data-field="Birthdate"]').className =
					'input-label';
			}
		} else {
			this.doberrorMessage = true;
			this.phoneerrorMessage = false;
			BirthdateField.className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';
		}

		if (!Phonefield.value) {
			this.phoneerrorMessage = true;
			isValid = false;
			Phonefield.className = 'textInput-err';
			this.template.querySelector('label[data-field="MobilePhone"]').className =
				'input-error-label';
		} else {
			this.phoneerrorMessage = false;

			Phonefield.className = 'textInput';
			this.template.querySelector('label[data-field="MobilePhone"]').className =
				'input-label';
		}

		if (!Preferredmodefield.value) {
			this.pcmerrorMessage = true;
			isValid = false;
			Preferredmodefield.className = 'textInput-err';
			this.template.querySelector(
				'label[data-field="PreferredMethodofCommunication"]'
			).className = 'input-error-label';
		} else {
			this.pcmerrorMessage = false;
			Preferredmodefield.className = 'textInput';
			this.template.querySelector(
				'label[data-field="PreferredMethodofCommunication"]'
			).className = 'input-label';
		}
		return isValid;
	}

	// Initialize to false

	agecalculationEvent(event) {
		this.Birthdate = event.target.value;
		if (!this.Birthdate || this.Birthdate === null || this.Birthdate === '') {
			this.doberrorMessage = true;
			this.template.querySelector(
				'lightning-input[data-field="Birthdate"]'
			).className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';
			return;
		}
		const dobDate = new Date(event.target.value);
		const today = new Date();
		const age = today.getFullYear() - dobDate.getFullYear();
		const BirthdateField = this.template.querySelector(
			'lightning-input[data-field="Birthdate"]'
		);

		if (age <= 18) {
			BirthdateField.className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';
			this.minorerror = true;
			this.futureerror = false;
			this.majorerror = false;
			this.doberrorMessage = false;
		} else {
			this.minorerror = false;
			this.futureerror = false;
			this.majorerror = false;
			this.doberrorMessage = false;
			BirthdateField.className = 'textInput';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-label';
		}
		if (dobDate > today) {
			this.futureerror = true;
			this.minorerror = false;
			this.majorerror = false;
			this.doberrorMessage = false;
		}
		if (dobDate.getFullYear() < 1900) {
			BirthdateField.className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';
			this.majorerror = true;
			this.futureerror = false;
			this.minorerror = false;
			this.doberrorMessage = false;
		}
		if (age >= 18 && age <= 100) {
			this.majorerror = false;
			this.futureerror = false;
			this.minorerror = false;
			this.doberrorMessage = false;
		}

		// Check if the selected date is in the future
		if (dobDate > today) {
			// Display the validation message
			const errorMessage = caregiverprofiledoberror;
			this.template.querySelector('[data-field="dob-error"]').textContent =
				errorMessage;

			// Clear the input field or take other appropriate actions as needed
			event.target.value = '';

			// You can also prevent the form from submitting if needed
			event.preventDefault();
		} else {
			// Clear the validation message if the date is valid
			this.template.querySelector('[data-field="dob-error"]').textContent = '';
		}
	}

	handleCommunicationMethodChange(event) {
		this.communicationmode = event.target.value;

		this.pmcrequire = false;
		if (this.communicationmode === emailstring) {
			this.emailMandatory = true;
			this.phoneNumberVisible = true;
			this.phoneNumberMandatory = false;
		} else {
			this.phoneNumberMandatory = false;
			this.phoneNumberVisible = true;
		}
		if (
			this.communicationmode === smsstring ||
			this.communicationmode === phonestring
		) {
			this.phoneNumberMandatory = true;
			this.phoneNumberVisible = false;
		} else {
			this.phoneNumberMandatory = false;
			this.phoneNumberVisible = true;
		}
		if (this.communicationmode === smsstring) {
			this.showContactNumber = false;
		} else {
			this.showContactNumber = true;
		}
		if (this.communicationmode === phonestring) {
			this.showContactNumber = true;
		} else {
			this.showContactNumber = false;
		}

		this.validatephonechange();
	}

	handleSubmitdetail() {
		this.validateFirstName();
		this.validatelastName();
		this.validateBirthdate();


	}

	handlefinaldata() {
		let validateform = false;

		if (!this.FirstName) {
			this.firstNameerrorMessage = true;
			this.template.querySelector(
				'lightning-input[data-field="FirstName"]'
			).className = 'textInput-err';
			this.template.querySelector('label[data-field="FirstName"]').className =
				'input-error-label';
			validateform = true;
		}
		if (!this.LastName) {
			this.LastNameerrorMessage = true;
			this.template.querySelector(
				'lightning-input[data-field="LastName"]'
			).className = 'textInput-err';
			this.template.querySelector('label[data-field="LastName"]').className =
				'input-error-label';
			validateform = true;
		}
		if (this.Birthdate === '') {
			this.doberrorMessage = true;
			this.template.querySelector(
				'lightning-input[data-field="Birthdate"]'
			).className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';

			validateform = true;
		}

		if (!this.communicationmode || this.communicationmode === null) {
			this.pcmerrorMessage = true;
			this.template.querySelector(
				'lightning-combobox[data-field="PreferredMethodofCommunication"]'
			).className = 'textInput-err';
			this.template.querySelector(
				'label[data-field="PreferredMethodofCommunication"]'
			).className = 'input-error-label';
			validateform = true;
		}

		if (
			this.communicationmode === smsstring ||
			this.communicationmode === phonestring
		) {
			if (
				!this.Phoneval ||
				this.Phoneval === '' ||
				this.Phoneval.length === 0
			) {
				this.phoneerrorMessage = true;
				this.template.querySelector(
					'lightning-input[data-field="MobilePhone"]'
				).className = 'textInput-err';
				this.template.querySelector(
					'label[data-field="MobilePhone"]'
				).className = 'input-error-label';
				this.template
					.querySelector('lightning-input[data-field="MobilePhone"]')
					.classList.add('textInput-err');
				this.template
					.querySelector('label[data-field="MobilePhone"]')
					.classList.add('input-error-label');
				validateform = true;
			}
		}
		if (this.communicationmode === emailstring) {
			if (this.Phoneval.length < 10 && this.Phoneval.length !== 0) {
				this.phoneerrorMessage = true;
				this.template.querySelector(
					'lightning-input[data-field="MobilePhone"]'
				).className = 'textInput-err';
				this.template.querySelector(
					'label[data-field="MobilePhone"]'
				).className = 'input-error-label';
				this.template
					.querySelector('lightning-input[data-field="MobilePhone"]')
					.classList.add('textInput-err');
				this.template
					.querySelector('label[data-field="MobilePhone"]')
					.classList.add('input-error-label');
				validateform = true;
			} else {
				this.phoneerrorMessage = false;
			}
		}
		if (!this.Relationshipval) {
			this.relationshiperrorMessage = true;
			this.template.querySelector(
				'lightning-combobox[data-field="relationship"]'
			).className = 'textInput-err';
			this.template.querySelector(
				'label[data-field="relationship"]'
			).className = 'input-error-label';
		}

		if (!this.Birthdate || this.Birthdate === null) {
			this.doberrorMessage = true;
			this.template.querySelector(
				'lightning-combobox[data-field="Birthdate"]'
			).className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className =
				'input-error-label';
		}

		if (validateform === true) {
			return;
		}

		if (this.Birthdate === '' || this.Birthdate === null) {
			this.doberrorMessage = true;
		}
		if (
			this.communicationmode === '' ||
			this.communicationmode === null ||
			this.communicationmode.length === 0 ||
			this.communicationmode === undefinedvalue
		) {
			this.pcmerrorMessage = true;
		}
		if (
			this.FirstName === '' ||
			this.FirstName === null ||
			this.FirstName.length === 0
		) {
			this.FirstNameerrorMessage = true;
		}

		if (
			this.LastName === '' ||
			this.LastName === null ||
			this.LastName.length === 0
		) {
			this.LastNameerrorMessage = true;
		}
		if (validateform === true) {
			return;
		}

		if (this.minorerror === true) {
			let addcaregiverDetails = {
				accountId: this.accountidval,
				FirstName: this.FirstName,
				LastName: this.LastName,
				PersonEmail: this.PersonEmailval,
				PersonBirthdate: this.Birthdate,
				relations: this.Relationshipval,
				phone: this.Phoneval,
				PreferredMethodofContact: this.communicationmode
			};

			updateCaregiverDetails({
				//   combinedString: combinedString
				cgprofile: addcaregiverDetails
			})
				.then(() => {
					this.updatePopup = true;

					window.scrollTo({ top: 0, behavior: 'smooth' });
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
					// Handle error, if needed
				});
		} else {
			let addcaregiverDetails = {
				accountId: this.accountidval,
				FirstName: this.FirstName,
				LastName: this.LastName,
				PersonEmail: this.PersonEmailval,
				PersonBirthdate: this.Birthdate,
				relations: this.Relationshipval,
				phone: this.Phoneval,
				PreferredMethodofContact: this.communicationmode
			};

			updateCaregiverDetails({
				cgprofile: addcaregiverDetails
			})
				.then(() => {
					this.updatePopup = true;
					window.scrollTo({ top: 0, behavior: 'smooth' });
					// Handle success, if needed
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
					// Handle error, if needed
				});
		}
	}

	handleCancel() {
		// Reload page if cancel action is clicked
		window.location.reload();
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To reterieve the caregiver name and avatar
	@wire(UserCaregivers)
	wiredavtList({ error, data }) {
		try {
			if (data && data.length > 0) {
				// Assign the data to the reactive property

				if (data.length > 0) {
					this.caregiver = true;
					this.name = data.length > 0 ? data[0]?.Name : '';

					if (data[0]?.PSP_BR_Patient__r?.PSP_BR_c__c) {
						this.selectedAvatarSrc = data[0]?.PSP_BR_Patient__r?.PSP_BR_c__c;
					} else {
						this.selectedAvatarSrc = this.Default_avatar_JPEG_URL;
					}
				} else if (error) {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
				}
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To allow only letters as input
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

	// Allow only numbers 0-9 and + symbol for mobile number
	handleKeyDown(event) {
		// Get the keycode of the pressed key
		const keyCode = event.keyCode || event.which;
	
		// Allow the backspace key (keyCode 8)
		if (keyCode === 8) {
			return;
		}
	
		// Define the allowed characters regex
		const allowedCharacters = /^[0-9\+]+$/;
	
		// Check if the pressed key matches the allowed characters
		if (!allowedCharacters.test(event.key)) {
			// If not, prevent the default action (input of the character)
			event.preventDefault();
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