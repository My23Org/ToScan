//This lightningWebcomponent used for Create a lead for Guest User Created By HCP.
//To import libraries
import { LightningElement, wire, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

//To import Apex class
import createLeadRecord from '@salesforce/apex/BI_PSPB_leadCreationCtrl.createLead';
import Hcpcreate from '@salesforce/apex/BI_PSPB_leadCreationCtrl.hcpCreate';
import getExistingAccounts from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getExistingAccounts';
import createCaregiverRecord from '@salesforce/apex/BI_PSPB_leadCreationCtrl.caregiverCreate';
import createPrescriptionRecord from '@salesforce/apex/BI_PSPB_leadCreationCtrl.prescriptionrCreate';
import createConsentRecord from '@salesforce/apex/BI_PSPB_leadCreationCtrl.consentCreate';
import getValuesFromTable from '@salesforce/apex/BI_PSPB_getProductList.getProductList';
import getValuesFromTable1 from '@salesforce/apex/BI_PSPB_referringPractitioner.getPractitionerList';
import getprescritionData from '@salesforce/apex/BI_PSPB_getProductList.getprescritionData';
import getValuesFromTable2 from '@salesforce/apex/BI_PSPB_practitionerLicense.getPractitionerList';

//To import schema for object
import Lead from '@salesforce/schema/Lead';
import Contact from '@salesforce/schema/Contact';
import BI_PSPB_Practice_Type__c from '@salesforce/schema/Contact.BI_PSPB_Practice_Type__c';
import HealthCloudGA__Gender__c from '@salesforce/schema/Lead.HealthCloudGA__Gender__c';
import Frequency_Unit__c from '@salesforce/schema/BI_PSPB_Lead_Prescription__c.BI_PSPB_Frequency_Unit__c';
import Lead_Prescription__c from '@salesforce/schema/BI_PSPB_Lead_Prescription__c';
import Lead_caregiver__c from '@salesforce/schema/BI_PSPB_Lead_Caregiver__c';
import Relationship_to_Patient__c from '@salesforce/schema/BI_PSPB_Lead_Caregiver__c.BI_PSPB_Relationship_to_Patient__c';
import COUNTRY_FIELD from '@salesforce/schema/Contact.MailingCountryCode';
import STATE_FIELD from '@salesforce/schema/Contact.MailingStateCode';

//To import custom label
import ReferringPractice from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Referring_Practice';
import PhysicianFirstName from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_First_Name';
import PhysicianLastName from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_Last_Name';
import Licensenumber from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_License_number';
import Practice from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Practice_name';
import PracticeType from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_Practice_Type';
import PhysicianEmail from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_Email';
import Physicianphone from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_phone';
import PhysicianCountry from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_Country';
import PhysicianState from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_State';
import PhysicianCity from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_City';
import PhysicianStreet from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_Street';
import Physicianzipcode from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_zip_code';
import PatientFirstName from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_First_Name';
import PatientLastName from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Last_Name';
import PatientDateofbirth from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Date_of_birth';
import PatientGender from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Gender';
import PatientEmail from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Email';
import PatientFuturedate from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Future_date';
import CaregiverFirstName from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_First_Name';
import CaregiverLastName from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Last_Name';
import CaregiverDatefobirth from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Date_fo_birth';
import CaregiverRelationship from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Relationship';
import CaregiverEmail from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_Email';
import DrugName from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Drug_Name';
import Drugcode from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Drug_code';
import Dosage from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Dosage';
import Dosageunits from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Dosage_units';
import Frequency from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Frequency';
import Frequencyunits from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Frequency_units';
import Prescribed_date from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Prescribed_date';
import PrescribedFuturedate from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Prescribed_Future_date';
import BI_PSPB_HealthCloudGAGender from '@salesforce/label/c.BI_PSPB_HealthCloudGAGender';
import BI_PSPB_LastName from '@salesforce/label/c.BI_PSPB_LastName';
import BI_PSPB_FirstName from '@salesforce/label/c.BI_PSPB_FirstName';
import BI_PSPB_Phone from '@salesforce/label/c.BI_PSPB_Phone';
import BI_PSPB_PracticeName from '@salesforce/label/c.BI_PSPB_PracticeName';
import BI_PSPB_License_number_c from '@salesforce/label/c.BI_PSPB_License_number_c';
import BI_PSPB_MailingPostalCode from '@salesforce/label/c.BI_PSPB_MailingPostalCode';
import BI_PSPB_MailingStreet from '@salesforce/label/c.BI_PSPB_MailingCity';
import BI_PSPB_MailingCity from '@salesforce/label/c.BI_PSPB_MailingCity';
import BI_PSPB_MailingStateCode from '@salesforce/label/c.BI_PSPB_MailingStateCode';
import BI_PSPB_MailingCountryCode from '@salesforce/label/c.BI_PSPB_MailingCountryCode';
import BI_PSPB_Fax from '@salesforce/label/c.BI_PSPB_Fax';
import BI_PSPB_PracticeType from '@salesforce/label/c.BI_PSPB_PracticeType';
import BI_PSPB_hcpsummary from '@salesforce/label/c.BI_PSPB_hcpsummary';
import BI_PSPB_Refill from '@salesforce/label/c.BI_PSPB_Refill';
import BI_PSPB_Frequency from '@salesforce/label/c.BI_PSPB_Frequency';
import BI_PSPB_Dosage from '@salesforce/label/c.BI_PSPB_Dosage';
import BI_PSPB_Quantity from '@salesforce/label/c.BI_PSPB_Quantity';
import BI_PSPB_frequcncyunit from '@salesforce/label/c.BI_PSPB_frequcncyunit';
import BI_PSPB_DosageCode from '@salesforce/label/c.BI_PSPB_DosageCode';
import BI_PSPB_drug from '@salesforce/label/c.BI_PSPB_drug';
import BI_PSPB_CaregiverPhone from '@salesforce/label/c.BI_PSPB_CaregiverPhone';
import BI_PSPB_CaregiverEmail from '@salesforce/label/c.BI_PSPB_CaregiverEmail';
import BI_PSPB_CaregiverFirstName from '@salesforce/label/c.BI_PSPB_CaregiverFirstName';
import BI_PSPB_CaregiverLastName from '@salesforce/label/c.BI_PSPB_CaregiverLastName';
import BI_PSPB_CaregiverRelationship from '@salesforce/label/c.BI_PSPB_CaregiverRelationship';
import BI_PSPB_Email from '@salesforce/label/c.BI_PSP_NotificationEmail';
import Agree from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Agree';
import errorfound from '@salesforce/label/c.BI_PSP_record_not_found_error_message';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
import iconcss from '@salesforce/resourceUrl/BI_PSPB_InputsearchIcon';
import textalign from '@salesforce/resourceUrl/BI_PSPB_TextAlignmentHcp';
import warning from '@salesforce/resourceUrl/BI_PSPB_WarningIcon';
import HCP_Entrollment_patient_Avater from '@salesforce/resourceUrl/BI_PSPB_HCP_Entrollment_patient_Avater';

export default class BiPspbHcpEnrollment extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@track searchResults;
	@track searchResults1;
	@track searchResults3;
	@track searchResults2;
	@track MailingCountryCode;
	@track leadFields = {};
	@track CaregiverFields = {};
	@track HCpFields = {};
	@track PrescriptionFields = {};
	@track ConsentFields = {};
	@track feildmobile = false;
	@track Referring_Practitioner__c;
	@track referringerrorMessage = false;
	@track firstnameerrorMessage = false;
	@track lastnameerrorMessage = false;
	@track doberrorMessage = false;
	@track gendererrorMessage = false;
	@track emailerrorMessage = false;
	@track carefirstnameerrorMessage = false;
	@track carelastnameerrorMessage = false;
	@track caredoberrorMessage = false;
	@track careemailerrorMessage = false;
	@track oneninezerozeroerrors = false;
	@track careoneninezerzeroerrors = false;
	@track presoneninezerzeroerrors = false;
	@track code;
	@track unique = false;
	@track Matchemail = false;
	@track RPfirstnameerrorMessage = false;
	@track RPlastnameerrorMessage = false;
	@track RPstatelicenseerrorMessage = false;
	@track RPPracticenameerrorMessage = false;
	@track RPpracticetypeerrorMessage = false;
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
	@track RPemailerrorvalid = false;
	@track emailerrorvalid = false;
	@track cemailerrorvalid = false;
	@track error;
	@track errors;
	@track errorss;
	@track minorerror;
	@track isAddNew = false;
	@track physicianIdInputDisabled = false;
	@track Matchcaregiveremail = false;
	@track physicianNameInputDisabled = false;
	@track addNewHCPSectionClass = 'addNewHcpSection';
	@track searchValue1 = '';
	@track isSearch1Cleared = false;
	@track searchValue2 = '';
	@track isSearch2Cleared = false;
	@track Emailerror;
	@track searchValue = '';
	@track searchresultempty1 = '';
	@track searchresultempty2 = '';
	@track searchresultempty = '';
	@track isSafari = false;
	@track RPcityerrorMessagevalid = false;
	@track mobilevalue = `Thank you for choosing Spevigo® for your patients with GPP...`;
	@track divfalse = true;
	@track firstnameerrorMessagevaild = false;
	@track lastnameerrorMessagevaild = false;
	@track phnerrorvalid = false;
	@track RPfirstnameerrorMessagevaild = false;
	@track RPlastnameerrorMessagevalid = false;
	@track RPstatelicenseerrorMessagevalid = false;
	@track RPfaxerrorMessage = false;
	@track carefirstnameerrorMessagevalid = false;
	@track carelastnameerrorMessagevalid = false;
	@track isLoaded = false;
	@track popupClass = 'popup-hidden';
	@track currentStep;
	@track mobilevalue2 = `Thank you for choosing Spevigo® for your patients with GPP. 
To enroll your patients in the Beyond GPP: The Spevigo® Patient Support 
Program, please complete the form on this page.`;
	@track openModal = false;
	@track searchmain = true;
	@track searchmain2 = true;
	@track searchvaluelogo = true;
	@track selectedInitials = '';
	@track selectedName = '';
	@track isDropdownOpen = false;
	@track nameregex = /^[a-zA-Z]+$/;
	@track picklistOrdered2 = [];
	@track selectedOption = {
		src: HCP_Entrollment_patient_Avater,
		name: '',
	};


	label = {
		PhysicianFirstName,
		ReferringPractice,
		PhysicianLastName,
		Licensenumber,
		Practice,
		PracticeType,
		PhysicianEmail,
		Physicianphone,
		PhysicianCountry,
		PhysicianState,
		PhysicianCity,
		PhysicianStreet,
		PatientFirstName,
		Physicianzipcode,
		PatientLastName,
		PatientDateofbirth,
		PatientGender,
		PatientEmail,
		PatientFuturedate,
		CaregiverFirstName,
		CaregiverLastName,
		CaregiverDatefobirth,
		CaregiverRelationship,
		CaregiverEmail,
		DrugName,
		Drugcode,
		Dosage,
		Dosageunits,
		Frequency,
		Frequencyunits,
		Prescribed_date,
		PrescribedFuturedate,
		Agree
	};
	BGpp = BGpp;
	warning = warning;
	uniqueEmail;
	uniqueFName;
	uniqueLname;
	uniqueDOB;
	caregiverID;
	prescriptionID;
	consentID;
	selectedAvatarSrc = HCP_Entrollment_patient_Avater;
	
	selectedSearchResult2;
	hcpIdVariable;
	picklistOrdered = [];
	picklistOrdered1 = [];
	selectedSearchResult;
	selectedSearchResult1;
	picklistOrdered3 = [];
	selectedSearchResult3;

	get selectedValue() {
		return this.selectedSearchResult?.label || this.searchValue;
	}
	get selectedValue1() {
		return this.selectedSearchResult1?.label || this.searchValue1;
	}
	get selectedValue2() {
		return this.selectedSearchResult2?.label || this.searchValue2;
	}

	get selectedValue3() {
		return this.selectedSearchResult3?.label || this.searchValue3;
	}

	threeclick() {
		this.mobilevalue = this.mobilevalue2;
		this.divfalse = false;
		this.feildmobile = true;
	}
	handleClose() {
		this.divfalse = true;
		this.feildmobile = false;
		this.mobilevalue = `Thank you for choosing Spevigo® for your patients with GPP...`;

	}

	//To fetch the lead object data using schema
	@wire(getObjectInfo, { objectApiName: Lead })
	objectInfo;

	//To fetch the picklist values for Gender
	@wire(getPicklistValues,
		{
			recordTypeId: '$objectInfo.data.defaultRecordTypeId',
			fieldApiName: HealthCloudGA__Gender__c

		}
	)
	leadGenderValues({ data, error }) {

		try {
			if (data) {
				this.leadGender = data.values;
			}
			else if (error) {
				this.leadGender = undefined; //Since it's taken from the schema builder, error message will not be displayed and it will be undefined

			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}


	}

	//To fetch the contact object in schema 
	@wire(getObjectInfo, { objectApiName: Contact })
	objectInfocon;

	//To fetch the picklist values for Practice type
	@wire(getPicklistValues,
		{
			recordTypeId: '$objectInfo.data.defaultRecordTypeId',
			fieldApiName: BI_PSPB_Practice_Type__c

		})
	practicetypeValues({ error, data }) {
		try {
			if (data) {
				this.practicetype = data.values;
			}
			else if (error) {
				this.practicetype = undefined;//Since it's taken from the schema builder, error message will not be displayed and it will be undefined

				this.showToast(errormessage, error.body.message, errorvariant);

			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}



	}

	//To fetch Lead_Prescription__c object using schema
	@wire(getObjectInfo, { objectApiName: Lead_Prescription__c })
	objectInfolead;


	//To fetch the picklist values for Frequency_Unit__c 
	@wire(getPicklistValues,
		{
			recordTypeId: '$objectInfo.data.defaultRecordTypeId',
			fieldApiName: Frequency_Unit__c
		}
	)
	FrequencyUnitValues({ error, data }) {
		try {
			if (data) {
				this.FrequencyUnit = data.values;
			} else if (error) {
				this.FrequencyUnit = undefined;//Since it's taken from the schema builder, error message will not be displayed and it will be undefined

				this.showToast(errormessage, error.body.message, errorvariant);
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}


	}

	//To fetch Lead_caregiver__c object using schema
	@wire(getObjectInfo, { objectApiName: Lead_caregiver__c })
	objectInfocaregiver;

	//To fetch the picklist values for Relationship_to_Patient__c 
	@wire(getPicklistValues,
		{
			recordTypeId: '$objectInfo.data.defaultRecordTypeId',
			fieldApiName: Relationship_to_Patient__c
		}
	)
	RelationshipValues({ error, data }) {
		try {
			if (data) {
				this.Relationship = data.values;
			} else if (error) {
				this.Relationship = undefined;//Since it's taken from the schema builder, error message will not be displayed and it will be undefined

				this.showToast(errormessage, error.body.message, errorvariant);
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}


	}

	//This is Input onchange function for Patient details form in Hcp Enrollment
	handleInputChange(event) {
		if (event.target.name === BI_PSPB_HealthCloudGAGender) {
			this.selectedGender = event.detail.value;

		}
		else {
			const fieldName = event.target.name;
			const fieldVal = event.target.value;
			this.leadFields[fieldName] = fieldVal;
			if (fieldName === BI_PSPB_FirstName) {
				this.leadFields.FirstName = event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
				const firstNameField = this.template.querySelector('lightning-input[data-field="pFN"]');
				if (this.leadFields.FirstName === '') {
					this.firstnameerrorMessage = true;
					this.firstnameerrorMessagevaild = false;
					firstNameField.className = 'textInput-err';
					this.template.querySelector('label[data-field="pFN"]').className = 'input-error-label';
				} else {
					if (!/^[a-zA-Z]+$/.test(this.leadFields.FirstName)) {
						firstNameField.className = 'textInput-err';
						this.template.querySelector('label[data-field="pFN"]').className = 'input-error-label';
						this.firstnameerrorMessagevaild = true;
						this.firstnameerrorMessage = false;
					}
					else {
						this.firstnameerrorMessagevaild = false;
						this.firstnameerrorMessage = false;
						firstNameField.className = 'textInput';
						this.template.querySelector('label[data-field="pFN"]').className = 'input-label';
					}
				}
			}
			else if (fieldName === BI_PSPB_LastName) {
				this.leadFields.LastName = event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
				const LastName = this.template.querySelector('lightning-input[data-field="pLN"]');
				if (this.leadFields.LastName === '') {
					this.lastnameerrorMessage = true;
					this.lastnameerrorMessagevaild = false;
					LastName.className = 'textInput-err';
					this.template.querySelector('label[data-field="pLN"]').className = 'input-error-label';
				} else {
					if (!/^[a-zA-Z]+$/.test(this.leadFields.LastName)) {
						LastName.className = 'textInput-err';
						this.template.querySelector('label[data-field="pLN"]').className = 'input-error-label';
						this.lastnameerrorMessagevaild = true;
						this.lastnameerrorMessage = false;
					}
					else {
						this.lastnameerrorMessagevaild = false;
						this.lastnameerrorMessage = false;
						LastName.className = 'textInput';
						this.template.querySelector('label[data-field="pLN"]').className = 'input-label';
					}
				}
			}
			else if (fieldName === BI_PSPB_Phone) {
				this.leadFields.Phone = event.target.value;
				const PhoneField = this.template.querySelector('lightning-input[data-field="pPhone"]');



				if (!/^\+?[0-9]+$/.test(this.leadFields.Phone)) {
					this.phnerrorvalid = true;
					PhoneField.className = 'textInput-err';
					this.template.querySelector('label[data-field="pPhone"]').className = 'input-error-label';
				}
				else {
					this.phnerrorvalid = false;
					PhoneField.className = 'textInput';
					this.template.querySelector('label[data-field="pPhone"]').className = 'input-label';
					if (/^\+?[0-9]+$/.test(this.leadFields.Phone)) {
						this.phnerrorvalid = false;
						PhoneField.className = 'textInput';
						this.template.querySelector('label[data-field="pPhone"]').className = 'input-label';
					}
					if (this.leadFields.Phone === '') {
						this.phnerrorvalid = false;
						PhoneField.className = 'textInput';
						this.template.querySelector('label[data-field="pPhone"]').className = 'input-label';
					}
				}


			}

		}


	}

	//This is Input onchange function for Physician details form in Hcp Enrollment
	handleInputChangehcp(event) {
		const fieldName12 = event.target.name;
		const targetValue12 = event.target.value;

		if (fieldName12 === BI_PSPB_FirstName) {
			this.HCpFields.firstname = targetValue12;
			this.HCpFields.firstname = event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
			const firstNameField = this.template.querySelector('lightning-input[data-field="hFN"]');
			if (this.HCpFields.firstname === '') {
				this.RPfirstnameerrorMessage = true;
				this.RPfirstnameerrorMessagevaild = false;
				firstNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hFN"]').className = 'input-error-label';
			} else {
				if (!/^[a-zA-Z]+$/.test(this.HCpFields.firstname)) {
					firstNameField.className = 'textInput-err';
					this.template.querySelector('label[data-field="hFN"]').className = 'input-error-label';
					this.RPfirstnameerrorMessagevaild = true;
					this.RPfirstnameerrorMessage = false;
				}
				else {
					this.RPfirstnameerrorMessagevaild = false;
					this.RPfirstnameerrorMessage = false;
					firstNameField.className = 'textInput';
					this.template.querySelector('label[data-field="hFN"]').className = 'input-label';
				}
			}
		}
		else if (fieldName12 === BI_PSPB_LastName) {
			this.HCpFields.lastname = targetValue12;
			this.HCpFields.lastname = event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
			const lastNameField = this.template.querySelector('lightning-input[data-field="hLN"]');
			if (this.HCpFields.lastname === '') {
				this.RPlastnameerrorMessage = true;
				this.RPlastnameerrorMessagevalid = false;
				lastNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hLN"]').className = 'input-error-label';
			} else {
				if (!/^[a-zA-Z]+$/.test(this.HCpFields.lastname)) {
					lastNameField.className = 'textInput-err';
					this.template.querySelector('label[data-field="hLN"]').className = 'input-error-label';
					this.RPlastnameerrorMessagevalid = true;
					this.RPlastnameerrorMessage = false;
				}
				else {
					this.RPlastnameerrorMessagevalid = false;
					this.RPlastnameerrorMessage = false;
					lastNameField.className = 'textInput';
					this.template.querySelector('label[data-field="hLN"]').className = 'input-label';
				}
			}

		} else if (fieldName12 === BI_PSPB_PracticeName) {
			this.HCpFields.Practicename = targetValue12;
			this.HCpFields.Practicename = event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
			const Practicename = this.template.querySelector('lightning-input[data-field="hPN"]');
			if (this.HCpFields.Practicename === '') {
				this.RPPracticenameerrorMessage = true;
				this.RPPracticenameerrorMessagevalid = false;
				Practicename.className = 'textInput-err';
				this.template.querySelector('label[data-field="hPN"]').className = 'input-error-label';
			} else {
				if (!/^[a-zA-Z]+$/.test(this.HCpFields.Practicename)) {
					Practicename.className = 'textInput-err';
					this.template.querySelector('label[data-field="hPN"]').className = 'input-error-label';
					this.RPPracticenameerrorMessagevalid = true;
					this.RPPracticenameerrorMessage = false;
				}
				else {
					this.RPPracticenameerrorMessagevalid = false;
					this.RPPracticenameerrorMessage = false;
					Practicename.className = 'textInput';
					this.template.querySelector('label[data-field="hPN"]').className = 'input-label';
				}
			}
		}
		else if (fieldName12 === BI_PSPB_License_number_c) {
			this.HCpFields.license = targetValue12;
			const licenseField = this.template.querySelector('lightning-input[data-field="hLicense"]');


			if (!/^\d+$/.test(this.HCpFields.license)) {
				this.RPstatelicenseerrorMessage = false;
				this.RPstatelicenseerrorMessagevalid = true;
				licenseField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hLicense"]').className = 'input-error-label';
			}
			else {
				this.RPstatelicenseerrorMessagevalid = false;
				if (this.HCpFields.license === '') {
					this.RPstatelicenseerrorMessage = true;
					this.RPstatelicenseerrorMessagevalid = false;
					licenseField.className = 'textInput';
					this.template.querySelector('label[data-field="hLicense"]').className = 'input-label';

				}
				else {
					this.RPstatelicenseerrorMessage = false;
					this.RPstatelicenseerrorMessagevalid = false;
					licenseField.className = 'textInput';
					this.template.querySelector('label[data-field="hLicense"]').className = 'input-label';
				}

			}
		} else if (fieldName12 === BI_PSPB_PracticeType) {
			this.selectedtype = targetValue12;
		} else if (fieldName12 === BI_PSPB_Email) {
			this.HCpFields.email = targetValue12;


		} else if (fieldName12 === BI_PSPB_Phone) {
			this.HCpFields.phone = targetValue12;
			this.HCpFields.phone = event.target.value
			const PhoneField = this.template.querySelector('lightning-input[data-field="hPhone"]');
			if (!/^\+?[0-9]+$/.test(this.HCpFields.phone)) {
				this.RPphoneerrorMessage = true;
				PhoneField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hPhone"]').className = 'input-error-label';
			}
			else {
				this.RPphoneerrorMessage = false;
				PhoneField.className = 'textInput';
				this.template.querySelector('label[data-field="hPhone"]').className = 'input-label';
				if (/^\+?[0-9]+$/.test(this.HCpFields.phone)) {
					this.RPphoneerrorMessage = false;
					PhoneField.className = 'textInput';
					this.template.querySelector('label[data-field="hPhone"]').className = 'input-label';
				}
				if (this.HCpFields.phone === '') {
					this.RPphoneerrorMessage = false;
					PhoneField.className = 'textInput';
					this.template.querySelector('label[data-field="hPhone"]').className = 'input-label';
				}
			}


		}
		else if (fieldName12 === BI_PSPB_Fax) {
			this.HCpFields.fax = event.target.value
			this.HCpFields.fax = targetValue12;
			const faxField = this.template.querySelector('lightning-input[data-field="hFax"]');
			if (!/^\+?[0-9]+$/.test(this.HCpFields.fax)) {
				this.RPfaxerrorMessage = true;
				faxField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hFax"]').className = 'input-error-label';
			}
			else {
				this.RPfaxerrorMessage = false;
				faxField.className = 'textInput';
				this.template.querySelector('label[data-field="hFax"]').className = 'input-label';
				if (/^\+?[0-9]+$/.test(this.HCpFields.fax)) {
					this.RPfaxerrorMessage = false;
					faxField.className = 'textInput';
					this.template.querySelector('label[data-field="hFax"]').className = 'input-label';
				}
				if (this.HCpFields.fax === '') {
					this.RPfaxerrorMessage = false;
					faxField.className = 'textInput';
					this.template.querySelector('label[data-field="hFax"]').className = 'input-label';
				}
			}

		}
		else if (fieldName12 === BI_PSPB_MailingCountryCode) {
			this.selectedCountry = targetValue12;

		}
		else if (fieldName12 === BI_PSPB_MailingStateCode) {
			this.selectedstate = targetValue12;


		} else if (fieldName12 === BI_PSPB_MailingCity) {
			this.HCpFields.city = targetValue12;
			const cityField = this.template.querySelector('lightning-input[data-field="hc"]');

			if (this.HCpFields.city === '') {
				this.RPcityerrorMessage = true;
				this.RPcityerrorMessagevalid = false;
				cityField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hc"]').className = 'input-error-label';
			} else {

				if (!/^[a-zA-Z\s]+$/.test(this.HCpFields.city)) {
					this.RPcityerrorMessage = false;
					this.RPcityerrorMessagevalid = true;
					cityField.className = 'textInput-err';
					this.template.querySelector('label[data-field="hc"]').className = 'input-error-label';
				}
				else {
					this.RPcityerrorMessage = false;
					this.RPcityerrorMessagevalid = false;
					cityField.className = 'textInput';
					this.template.querySelector('label[data-field="hc"]').className = 'input-label';
				}
			}

		} else if (fieldName12 === BI_PSPB_MailingStreet) {
			this.HCpFields.street = targetValue12;

		} else if (fieldName12 === BI_PSPB_MailingPostalCode) {
			this.HCpFields.code = targetValue12;


		}
	}

	//This is Input onchange function for Caregiver details form in Hcp Enrollment
	handleInputChange1(event) {
		const fieldName1 = event.target.name;
		const targetValue = event.target.value;

		if (fieldName1 === BI_PSPB_CaregiverFirstName) {
			this.CaregiverFields.FirstName = targetValue;
			this.CaregiverFields.FirstName = event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
			if (this.CaregiverFields.FirstName === '') {
				this.carefirstnameerrorMessage = true;
				this.carefirstnameerrorMessagevalid = false;
				this.template.querySelector("lightning-input.cFN").className = 'textInput-err cFN';
				this.template.querySelector("label.cFN").className = 'input-error-label cFN';
			} else {

				if (!/^[a-zA-Z]+$/.test(this.CaregiverFields.FirstName)) {
					this.carefirstnameerrorMessagevalid = true;
					this.carefirstnameerrorMessage = false;
					this.template.querySelector("lightning-input.cFN").className = 'textInput-err cFN';
					this.template.querySelector("label.cFN").className = 'input-error-label cFN';
				}
				else {

					this.carefirstnameerrorMessagevalid = false;
					this.carefirstnameerrorMessage = false;
					this.template.querySelector("lightning-input.cFN").className = 'textInput cFN';
					this.template.querySelector("label.cFN").className = 'input-label cFN';
				}
			}

		} else if (fieldName1 === BI_PSPB_CaregiverLastName) {
			this.CaregiverFields.LastName = targetValue;
			this.CaregiverFields.LastName = event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
			if (this.CaregiverFields.LastName === '') {
				this.carelastnameerrorMessage = true;
				this.carelastnameerrorMessagevalid = false;
				this.template.querySelector("lightning-input.cLN").className = 'textInput-err cLN';
				this.template.querySelector("label.cLN").className = 'input-error-label cLN';
			} else {
				if (!/^[a-zA-Z]+$/.test(this.CaregiverFields.LastName)) {
					this.carelastnameerrorMessagevalid = true;
					this.carelastnameerrorMessage = false;
					this.template.querySelector("lightning-input.cLN").className = 'textInput-err cLN';
					this.template.querySelector("label.cLN").className = 'input-error-label cLN';
				}
				else {
					this.carelastnameerrorMessagevalid = false;
					this.carelastnameerrorMessage = false;
					this.template.querySelector("lightning-input.cLN").className = 'textInput cLN';
					this.template.querySelector("label.cLN").className = 'input-label cLN';
				}
			}



		} else if (fieldName1 === BI_PSPB_CaregiverEmail) {
			this.CaregiverFields.Email = targetValue;

		} else if (fieldName1 === BI_PSPB_CaregiverPhone) {
			this.CaregiverFields.Phone = targetValue;
			const PhoneField = this.template.querySelector('lightning-input[data-field="cPhone"]');
			if (!/^\+?[0-9]+$/.test(this.CaregiverFields.Phone)) {
				this.cphoneerrorvalid = true;
				PhoneField.className = 'textInput-err';
				this.template.querySelector('label[data-field="cPhone"]').className = 'input-error-label';
			}
			else {
				this.cphoneerrorvalid = false;
				PhoneField.className = 'textInput';
				this.template.querySelector('label[data-field="cPhone"]').className = 'input-label';
			}
			if (/^\+?[0-9]+$/.test(this.CaregiverFields.Phone)) {
				this.cphoneerrorvalid = false;
				PhoneField.className = 'textInput';
				this.template.querySelector('label[data-field="cPhone"]').className = 'input-label';
			}
			if (this.CaregiverFields.Phone === '') {
				this.cphoneerrorvalid = false;
				PhoneField.className = 'textInput';
				this.template.querySelector('label[data-field="cPhone"]').className = 'input-label';
			}



		} else if (fieldName1 === BI_PSPB_CaregiverRelationship) {
			this.selectedRelationship = targetValue;


		}
	}

	//This is Input onchange function for Prescription details form in Hcp Enrollment
	handleInputChange2(event) {
		const fieldName = event.target.name;
		const targetValue1 = event.target.value;


		if (fieldName === BI_PSPB_DosageCode) {
			this.PrescriptionFields.DosageCode = targetValue1;
		} else if (fieldName === BI_PSPB_frequcncyunit) {
			this.selectedunit = targetValue1;
		} else if (fieldName === BI_PSPB_Dosage) {
			this.PrescriptionFields.Dosage = targetValue1;
		} else if (fieldName === BI_PSPB_Quantity) {
			if (!this.isNumeric(targetValue1)) {
				// If not numeric, clear the input value
				this.PrescriptionFields.Quantity = '';
			} else {
				// If numeric, update the Quantity value
				this.PrescriptionFields.Quantity = targetValue1;
			}

			this.PrescriptionFields.Quantity = targetValue1;
		} else if (fieldName === BI_PSPB_Frequency) {
			this.PrescriptionFields.Frequency = targetValue1;
		} else if (fieldName === BI_PSPB_Refill) {
			this.PrescriptionFields.refill = targetValue1;
		} else if (fieldName === BI_PSPB_drug) {
			this.selectedValue = targetValue1;
		}


	}
	isNumeric(value) {
		return /^\d+$/.test(value);
	}

	//This is onchange function for term and conditions in Hcp Enrollment
	handleInputChange3(event) {

		const targetValue2 = event.target.checked;
		this.ConsentFields.authorize = targetValue2;
	}

	//This function is used for creating lead in hcp enrollment 
	handleCreateLead() {
		if (this.PrescriptionFieldsForm() && this.authorize() && this.errorss === false) {
			this.isLoaded = true;
			const Sex = this.selectedGender;
			const hcplicence = this.selectedValue2;
			const createid = this.hcpIdVariable;
			const { FirstName, LastName, Email, Phone, dob } = this.leadFields;
			let data = { firstName: FirstName, lastName: LastName, email: Email ? Email : '', dob: dob, phone: Phone ? Phone : '', sex: Sex };
			createLeadRecord({ data: data, HCPID: createid, licence: hcplicence, HCPName: this.selectedValue1 })
				// Null data is checked and AuraHandledException is thrown from the Apex
				.then(leadId => {

					localStorage.setItem('recordId', leadId);
					localStorage.setItem('count', 1);

					this.handlesuccess(leadId);
					this.resetForm();
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);
				});
		}
	}

	//This function is used for creating Caregiver and lead consent in hcp enrollment 
	handlesuccess(leadId) {
		// Destructure the caregiver fields from this.CaregiverFields
		if (this.isAdult !== true) {
			const relationshiptopatient = this.selectedRelationship;
			// Use the destructured variables in the createCaregiverRecord function

			let caregiverdata = { firstName: this.CaregiverFields.FirstName, lastName: this.CaregiverFields.LastName, email: this.CaregiverFields.Email, phone: this.CaregiverFields.Phone ? this.CaregiverFields.Phone : '', relation: relationshiptopatient, dob: this.CaregiverFields.dob }
			// Null data is checked and AuraHandledException is thrown from the Apex

			createCaregiverRecord({ caregiverdata: caregiverdata, LeadID: leadId })
				.then(careID => {
					// Further actions if needed
					this.caregiverID = careID;
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);
				});

		}
		const { Quantity, refill, date } = this.PrescriptionFields;
		let prescriptiondata = { drug: this.selectedValue, dob: date, unit: this.selectedunit ? this.selectedunit : '', frequency: this.PrescriptionFields.Frequency ? this.PrescriptionFields.Frequency : 0 }
		createPrescriptionRecord({ prescriptiondata: prescriptiondata, refill: refill ? refill : 0, LeadID: leadId, Quantity: Quantity ? Quantity : 0 })
			.then(prescriptionID => {
				// Further actions if needed
				this.prescriptionID = prescriptionID;
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant);
			});

		const { authorize } = this.ConsentFields;

		// Null data is checked and AuraHandledException is thrown from the Apex
		createConsentRecord({ firstName: authorize, LeadID: leadId })
			.then(consentID => {
				// Further actions if needed
				this.consentID = consentID;
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant);
			});
		// This setTimeout is used to retrieve the Prescription records after a delay.
		try {
			setTimeout(function () {
				window.location.href = brSiteUrl + BI_PSPB_hcpsummary;
			}, 1000);
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	descriptionData;
	resetForm() {
		// Clear form fields
		this.leadFields = {};
		this.CaregiverFields = {};
	}
	connectedCallback() {
		try {
			getValuesFromTable()
				// The error handle with null value throw from apex	
				.then((result) => {
					if (result !== null && result.length > 0) {
						loadStyle(this, iconcss);
						loadStyle(this, textalign);
						let i;
						for (i = 0; i < result.length; i++) {
							this.picklistOrdered.push({ label: result[i].Name, value: result[i].Id });
						}

						this.picklistOrdered = this.picklistOrdered.sort((a, b) => {
							if (a.label < b.label) {
								return -1;
							} else if (a.label > b.label) {
								return 1;
							}
							return 0; // If a.label is equal to b.label
						});
					} else if (result === null) {
						this.showToast(errormessage, errorfound, errorvariant);// Catching Potential Error from apex
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from lwc
				})

			getValuesFromTable1()
				// The error handle with null value throw from apex	
				.then((result) => {
					if (result !== null && result.length > 0) {
						let i;
						for (i = 0; i < result.length; i++) {
							this.picklistOrdered1.push({ label: result[i].Name, labelForSpecialist: result[i]?.BI_PSPB_Specialist__c, labelForCity: result[i]?.MailingCity, value: result[i].Id });
						}
						this.picklistOrdered1 = this.picklistOrdered1.sort((a, b) => {
							if (a.label < b.label) {
								return -1
							}
							else if (a.label > b.label) {
								return 1;
							}
							return 0;
						})
					} else if (result === null) {
						this.showToast(errormessage, errorfound, errorvariant);// Catching Potential Error from apex
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from lwc
				})
			getValuesFromTable2()
				// The error handle with null value throw from apex	
				.then((result) => {
					if (result !== null && result.length > 0) {
						this. picklistOrdered2 = result.map((item) => ({
							label: item.BI_PSPB_License_number__c,
							value: item.Id
						}));
						this.picklistOrdered2.sort((a, b) => {
							if (a.label < b.label) {
								return -1;
							}
							if (a.label > b.label) {
								return 1;
							}
							return 0;
						});

					} else if (result === null) {
						this.showToast(errormessage, errorfound, errorvariant);// Catching Potential Error from apex
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error from lwc
				})
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}

	openPopUp() {
		this.popupClass = 'popup-visible';
	}

	HCPSubmit() {
		if (!this.HCPvalidateForm()) {// To call the method
			//no need to return

		}
	}
	Cancel() {
		this.popupClass = 'popup-hidden';
	}

	goBackToStepOne() {
		this.handleClose();
		this.currentStep = '1';
		this.template.querySelector('div.stepTwo').classList.add('slds-hide');
		this.template.querySelector('div.stepOne').classList.remove('slds-hide');
		// Progress indicator      
		this.template.querySelector('li.li-two').classList.remove('slds-is-active');
		this.template.querySelector('li.li-one').classList.remove('slds-is-completed');
		this.template.querySelector('li.li-one').classList.add('slds-is-active');
		//To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
		//To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
		const avatarcontent = this.template.querySelector('p.avatar-content')
		avatarcontent.innerHTML =
			`Thank you for choosing Spevigo® for<br> your patients with GPP.
			<br>
			<br>
To enroll your patients in the Beyond
<br>
 GPP: The Spevigo® Patient Support<br> Program, please complete the form on<br> this page.`;
		this.mobilevalue2 = `Thank you for choosing Spevigo® for your patients with GPP.
To enroll your patients in the Beyond GPP: The Spevigo® Patient Support Program, please complete the form on this page.`;
	}
	goBackToStepTwo() {
		this.handleClose();
		this.currentStep = '2';
		this.template.querySelector('div.stepThree').classList.add('slds-hide');
		this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
		// Progress indicator
		this.template.querySelector('li.li-three').classList.remove('slds-is-active');
		this.template.querySelector('li.li-three').classList.add('slds-hide');
		this.template.querySelector('li.li-two').classList.remove('slds-is-completed');
		this.template.querySelector('li.li-two').classList.add('slds-is-active');
		const divElement = this.template.querySelector('div.prescription-label');
		divElement.textContent = "03 ";
		//To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
		//To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
		const avatarcontent = this.template.querySelector('p.avatar-content')
		avatarcontent.innerHTML =
			`Thank you for choosing Spevigo® for<br> your patients with generalized pustular <br>psoriasis (GPP).
<br>
<br>
To enroll your patients in the Beyond <br>GPP: The Spevigo®
Patient Support<br> Program, please
complete the form on <br>this page. If you
are enrolling a minor<br> patient, please
provide the caregiver's <br>information as
well.`;
		this.mobilevalue2 = `Thank you for choosing Spevigo® for your patients with generalized pustular psoriasis (GPP).
To enroll your patients in the Beyond GPP: The Spevigo®
Patient Support Program, please
complete the form on this page. If you
are enrolling a minor patient, please
provide the caregiver's information as
well.`;
	}
	goBackToStepThree() {
		this.Matchcaregiveremail = false;
	    this.Matchemail = false;
		if (this.isAdult === true) {
			this.handleClose();
			this.currentStep = '2';
			this.template.querySelector('div.stepFour').classList.add('slds-hide');
			this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
			// Progress indicator
			this.template.querySelector('li.li-four').classList.remove('slds-is-active');
			this.template.querySelector('li.li-two').classList.remove('slds-is-completed');
			this.template.querySelector('li.li-two').classList.add('slds-is-active');
			//To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
			//To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
			const avatarcontent = this.template.querySelector('p.avatar-content')
			avatarcontent.innerHTML = `Thank you for choosing Spevigo® for<br> your patients with generalized pustular <br>psoriasis (GPP).
<br>
<br>
To enroll your patients in the Beyond <br>GPP: The Spevigo®
Patient Support<br> Program, please
complete the form on <br>this page. If you
are enrolling a minor<br> patient, please
provide the caregiver's <br>information as
well.`;
			this.mobilevalue2 = `Thank you for choosing Spevigo® for your patients with generalized pustular psoriasis (GPP).
To enroll your patients in the Beyond GPP: The Spevigo®
Patient Support Program, please
complete the form on this page. If you
are enrolling a minor patient, please
provide the caregiver's information as
well.`;
		} else {
			this.handleClose();
			this.currentStep = '3';
			this.template.querySelector('div.stepFour').classList.add('slds-hide');
			this.template.querySelector('div.stepThree').classList.remove('slds-hide');
			// Progress indicator
			this.template.querySelector('li.li-four').classList.remove('slds-is-active');
			this.template.querySelector('li.li-three').classList.remove('slds-is-completed');
			this.template.querySelector('li.li-three').classList.add('slds-is-active');
			//To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
			//To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
			const avatarcontent = this.template.querySelector('p.avatar-content')
			avatarcontent.innerHTML = `Thank you for choosing Spevigo® for<br> your patients with generalized pustular <br>psoriasis (GPP).
<br>
<br>
To enroll your patients in the Beyond <br>GPP: The Spevigo®
Patient Support<br> Program, please
complete the form on <br>this page. If you
are enrolling a minor<br> patient, please
provide the caregiver's <br>information as
well.`;
		}
		this.mobilevalue2 = `Thank you for choosing Spevigo® for your patients with generalized pustular psoriasis (GPP).

To enroll your patients in the Beyond GPP: The Spevigo®
Patient Support Program, please
complete the form on this page. If you
are enrolling a minor patient, please
provide the caregiver's information as
well.`;
	}
	goBackToStepFour() {
		this.handleClose();
		this.currentStep = '4';
		this.template.querySelector('div.stepFive').classList.add('slds-hide');
		this.template.querySelector('div.stepFour').classList.remove('slds-hide');
	}
	goToStepTwo() {
		this.handleClose();
		if (!this.ReferringPracticeValidation()) return;

		if (this.physicianIdInputDisabled === true && this.physicianNameInputDisabled === true) {
			if (!this.HCPvalidateForm()) {
				return
			}
			let hcpData = { firstName: this.HCpFields.firstname, lastName: this.HCpFields.lastname, email: this.HCpFields.email, phone: this.HCpFields.phone, practice: this.HCpFields.Practicename, type: this.selectedtype, lisence: this.HCpFields.license, city: this.HCpFields.city, street: this.HCpFields.street, country: this.selectedCountry, state: this.selectedstate, code: this.HCpFields.code }

			Hcpcreate({ hcpData: hcpData })
				// Null data is checked and AuraHandledException is thrown from the Apex
				.then(hcpId => {

					// Further actions if needed
					this.hcpIdVariable = hcpId;
				});
		}
		this.currentStep = '2';
		this.template.querySelector('div.stepOne').classList.add('slds-hide');
		this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
		// Progress indicator
		this.template.querySelector('li.li-one').classList.remove('slds-is-active');
		this.template.querySelector('li.li-one').classList.add('slds-is-completed');
		this.template.querySelector('li.li-two').classList.add('slds-is-active');
		//To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
		//To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
		const avatarcontent = this.template.querySelector('p.avatar-content')
		avatarcontent.innerHTML = `Thank you for choosing Spevigo® for<br> your patients with generalized pustular <br>psoriasis (GPP).
<br>
<br>
To enroll your patients in the Beyond <br>GPP: The Spevigo®
Patient Support<br> Program, please
complete the form on <br>this page. If you
are enrolling a minor<br> patient, please
provide the caregiver's <br>information as
well.`;
		this.mobilevalue2 = `Thank you for choosing Spevigo® for your patients with generalized pustular psoriasis (GPP).

To enroll your patients in the Beyond GPP: The Spevigo®
Patient Support Program, please
complete the form on  this page. If you
are enrolling a minor patient, please
provide the caregiver's information as
well.`;
	}
	goToStepThree() {
		
		this.handleClose();
		getExistingAccounts({ email: this.leadFields.Email })
			// Null data is checked and AuraHandledException is thrown from the Apex
			.then(result => {
				if (result && result.length > 0 && result !== null) {
					this.uniqueEmail = result.map(item => item.PersonEmail);
					this.uniqueFName = result.map(item => item.FirstName);
					this.uniqueLname = result.map(item => item.LastName);
					this.uniqueDOB = result.map(item => item.BI_PSP_Birthdate__c);
					if (!this.UniqueValidation()) {//To call the method
						// No need for a return here 
					}

				}
				else {
					if (!this.patientvalidateForm()) {
						// No need for a return here

					} else if (!this.DOByearvalidationforPatient()) {

						// No need for a return here
					} else if (!this.DOBfuturevalidationforPatient()) {

						// No need for a return here

					}

					else if (this.isAdult === true) { // Use === for equality check
						this.currentStep = '4';
						this.template.querySelector('div.stepTwo').classList.add('slds-hide');
						this.template.querySelector('div.stepFour').classList.remove('slds-hide');
						// Progress indicator

						this.template.querySelector('li.li-two').classList.remove('slds-is-active');
						this.template.querySelector('li.li-two').classList.add('slds-is-completed');
						this.template.querySelector('li.li-four').classList.add('slds-is-active');
						//To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
						//To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
						const avatarcontent = this.template.querySelector('p.avatar-content')
						avatarcontent.innerHTML =
							`Thank you for choosing Spevigo® for<br> your patients with GPP.
<br>
<br>
To enroll your patients in the<br>Beyond
GPP: The Spevigo® <br>Patient Support
Program, please<br> complete the form on
this page.`;
						this.mobilevalue2 = `Thank you for choosing Spevigo® for your patients with GPP.
To enroll your patients in the Beyond
GPP: The Spevigo® Patient Support
Program, please complete the form on
this page.`;
					}
					else {
						this.handleClose();
						this.currentStep = '3';
						this.template.querySelector('div.stepTwo').classList.add('slds-hide');
						this.template.querySelector('div.stepThree').classList.remove('slds-hide');
						// Progress indicator
						this.template.querySelector('li.li-two').classList.remove('slds-is-active');
						this.template.querySelector('li.li-two').classList.add('slds-is-completed');
						this.template.querySelector('li.li-three').classList.remove('slds-hide');
						this.template.querySelector('li.li-three').classList.add('slds-is-active');
						const prescontent = this.template.querySelector('div.prescription-label')
						prescontent.textContent = '04&nbsp;'
						//To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
						//To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
						const avatarcontent = this.template.querySelector('p.avatar-content')
						avatarcontent.innerHTML =
							`Thank you for choosing Spevigo® for<br> your patients with generalized pustular <br>psoriasis (GPP).
<br>
<br>
To enroll your patients in the Beyond <br>GPP: The Spevigo®
Patient Support<br> Program, please
complete the form on <br>this page. If you
are enrolling a minor<br> patient, please
provide the caregiver's <br>information as
well.`;
						this.mobilevalue2 = `Thank you for choosing Spevigo® for your patients with generalized pustular psoriasis (GPP).
To enroll your patients in the Beyond GPP: The Spevigo®
Patient Support Program, please
complete the form on this page. If you
are enrolling a minor patient, please
provide the caregiver's information as
well.`;
					}

				}
			})
			.catch(error => {
				// Handle errors here
				this.showToast(errormessage, error.message, errorvariant);
			});

	}

	goToStepFour() {
		this.handleClose();
		getExistingAccounts({ email: this.CaregiverFields.Email })
			// Null data is checked and AuraHandledException is thrown from the Apex
			.then(result => {
				if (result && result.length > 0) {
					this.uniqueEmail = result.map(item => item.PersonEmail);
					this.uniqueFName = result.map(item => item.FirstName);
					this.uniqueLname = result.map(item => item.LastName);
					this.uniqueDOB = result.map(item => item.BI_PSP_Birthdate__c);
				  
					if (!this.UniquecaregiverValidation()) {// to call the method
						// No need for a return here
					}else{
						this.Caregivervalidation();
					}
		
				} 
				else {
					this.Caregivervalidation();
				}
			})
			.catch(error => {
				// Handle errors here
				this.showToast(errormessage, error.message, errorvariant);
			});

	}

	//This Function is used for check validation for Patient date of birth in hcp enrollment form
	agecalculationEvent(event) {
		const selectedDate = event.target.value;

		this.leadFields.dob = selectedDate;

		const currentDate = new Date();
		const selectedDateObj = new Date(selectedDate);
		if (selectedDate === '') {
			this.doberrorMessage = true;
			this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="pdob"]').className = 'input-error-label';
			this.error = false;
			this.oneninezerozeroerrors = false;
		} else {
			if (selectedDateObj.getFullYear() < 1900) {
				this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="pdob"]').className = 'input-error-label';
				this.error = false;
				this.oneninezerozeroerrors = true;
				this.doberrorMessage = false;
				this.isAdult = false;

			} else if (selectedDateObj > currentDate) {
				this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="pdob"]').className = 'input-error-label';
				this.error = true;
				this.doberrorMessage = false;
				this.isAdult = false;
				this.oneninezerozeroerrors = false;

			} else {
				this.error = false;
				this.oneninezerozeroerrors = false;
				this.doberrorMessage = false;
				this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput';
				this.template.querySelector('label[data-field="pdob"]').className = 'input-label';
				const age = Math.floor((currentDate - selectedDateObj) / (365.25 * 24 * 60 * 60 * 1000)); // Rounding down to the nearest whole year
				if (age >= 18) {
					this.isAdult = true;
					this.oneninezerozeroerrors = false;
				} else {
					this.isAdult = false;
					this.oneninezerozeroerrors = false;
				}
			}
		}

	}
	onClickCalendar() {
		this.template.querySelector('div.formContainer').style.zIndex = '1001';
	}

	onBlurCalendar() {
		this.template.querySelector('div.formContainer').style.zIndex = '0';
	}

	//This Function is used for check validation for Caregiver date of birth in hcp enrollment form
	careagecalculation(event) {
		const selectedDate = event.target.value;
		this.CaregiverFields.dob = selectedDate;

		const currentDate = new Date();
		const careselectedDateObj = new Date(selectedDate);
		if (selectedDate === '') {
			this.caredoberrorMessage = true;
			this.minorerror = false;
			this.careoneninezerzeroerrors = false;
			this.errors = false;
			this.template.querySelector('lightning-input.cDob').className = 'red cDob';
			this.template.querySelector('label.cDob').className = 'labelred cDob';

		} else {
			if (careselectedDateObj.getFullYear() < 1900) {
				this.template.querySelector('lightning-input.cDob').className = 'red cDob';
				this.template.querySelector('label.cDob').className = 'labelred cDob';
				this.careoneninezerzeroerrors = true;
				this.errors = false;
				this.isAdult = false;
				this.minorerror = false;
				this.caredoberrorMessage = false;
			} else if (careselectedDateObj > currentDate) {
				this.template.querySelector('lightning-input.cDob').className = 'red cDob';
				this.template.querySelector('label.cDob').className = 'labelred cDob';
				this.errors = true;
				this.minorerror = false;
				this.isAdult = false;
				this.careoneninezerzeroerrors = false;
				this.caredoberrorMessage = false;

			} else {
				this.errors = false;
				this.minorerror = false;
				this.careoneninezerzeroerrors = false;
				this.caredoberrorMessage = false;

				const age = Math.floor((currentDate - careselectedDateObj) / (365.25 * 24 * 60 * 60 * 1000)); // Rounding down to the nearest whole year
				if (age < 18) {
					this.minorerror = true;
					this.errors = false;
					this.template.querySelector('lightning-input.cDob').className = 'red cDob';
					this.template.querySelector('label.cDob').className = 'labelred cDob';
					this.careoneninezerzeroerrors = false;
					this.caredoberrorMessage = false;
				} else {
					this.minorerror = false;
					this.careoneninezerzeroerrors = false;
					this.caredoberrorMessage = false;
					this.errors = false;
					this.template.querySelector('lightning-input.cDob').className = 'textInput cDob';
					this.template.querySelector('label.cDob').className = 'input-label cDob';
				}
			}
		}
	}

	//This Function is used for check validation for Prescription date in hcp enrollment form
	datecalculation(event) {
		const selectedDate = event.target.value;
		this.PrescriptionFields.date = selectedDate;

		const currentDate = new Date();
		const presselectedDateObj = new Date(selectedDate);
		if (selectedDate === '') {
			this.dateerrorMessage = true;
			this.errorss = false;
			this.presoneninezerzeroerrors = false;
			this.template.querySelector('lightning-input.hpdate').className = 'textInput-err hpdate';
			this.template.querySelector('label.hpdate').className = 'input-error-label hpdate';
		} else {
			if (presselectedDateObj.getFullYear() < 1900) {
				this.template.querySelector('lightning-input.hpdate').className = 'textInput-err hpdate';
				this.template.querySelector('label.hpdate').className = 'input-error-label hpdate';
				this.errorss = false;
				this.presoneninezerzeroerrors = true;
				this.dateerrorMessage = false;

			} else if (presselectedDateObj > currentDate) {
				this.template.querySelector('lightning-input.hpdate').className = 'textInput-err hpdate';
				this.template.querySelector('label.hpdate').className = 'input-error-label hpdate';
				this.errorss = true;
				this.presoneninezerzeroerrors = false;
				this.dateerrorMessage = false;

			} else {
				this.errorss = false;
				this.presoneninezerzeroerrors = false;
				this.dateerrorMessage = false;
				this.template.querySelector('lightning-input.hpdate').className = 'textInput hpdate';
				this.template.querySelector('label.hpdate').className = 'input-label hpdate';
			}
		}
	}
	//This Function is used for check validation for Patient in hcp enrollment form
	patientvalidateForm() {
		// Add your validation logic here for each required field
		let isValid = true;

		// First Name
		if (!this.leadFields.FirstName) {
			this.template.querySelector('lightning-input[data-field="pFN"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="pFN"]').className = 'input-error-label';
			this.firstnameerrorMessage = true;

			isValid = false;
		} else {
			this.firstnameerrorMessage = false;
			if (this.firstnameerrorMessage === true || this.firstnameerrorMessagevaild === true) {
				this.template.querySelector('lightning-input[data-field="pFN"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="pFN"]').className = 'input-error-label';
				isValid = false;

			} else {
				this.template.querySelector('lightning-input[data-field="pFN"]').className = 'textInput';
				this.template.querySelector('label[data-field="pFN"]').className = 'input-label';
			}

		}
		// Last Name
		if (!this.leadFields.LastName) {
			this.template.querySelector('lightning-input[data-field="pLN"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="pLN"]').className = 'input-error-label';
			this.lastnameerrorMessage = true;
			isValid = false;
		} else {
			this.lastnameerrorMessage = false;
			if (this.lastnameerrorMessage === true || this.lastnameerrorMessagevaild === true) {
				this.template.querySelector('lightning-input[data-field="pLN"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="pLN"]').className = 'input-error-label';
				isValid = false;

			} else {
				this.template.querySelector('lightning-input[data-field="pLN"]').className = 'textInput';
				this.template.querySelector('label[data-field="pLN"]').className = 'input-label';
			}
		}

		// Date of Birth
		if (!this.leadFields.dob) {
			this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="pdob"]').className = 'input-error-label';
			this.doberrorMessage = true;
			isValid = false;
		} else {
			this.doberrorMessage = false;
			if (this.error === true || this.patientvalidateForm === true) {
				this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="pdob"]').className = 'input-error-label';
				isValid = false;

			} else {
				this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput';
				this.template.querySelector('label[data-field="pdob"]').className = 'input-label';
			}

		}

		// Gender
		if (!this.selectedGender) {
			this.gendererrorMessage = true;
			isValid = false;
			this.template.querySelector('lightning-combobox[data-field="pGender"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="pGender"]').className = 'input-error-label';
		} else {
			this.gendererrorMessage = false;
			this.template.querySelector('lightning-combobox[data-field="pGender"]').className = 'textInput';
			this.template.querySelector('label[data-field="pGender"]').className = 'input-label';
		}

		// Email
		if (this.isAdult === true) {
			if (!this.leadFields.Email) {
				this.template.querySelector('lightning-input[data-field="pEmail"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="pEmail"]').className = 'input-error-label';
				this.emailerrorMessage = true;
				this.emailerrorvalid = false;
				isValid = false;
			} else {
				this.emailerrorMessage = false;
				this.emailerrorvalid = false;
				this.template.querySelector('lightning-input[data-field="pEmail"]').className = 'textInput';
				this.template.querySelector('label[data-field="pEmail"]').className = 'input-label';

				const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

				if (!emailRegex.test(this.leadFields.Email)) {
					this.emailerrorvalid = true;
					this.template.querySelector('lightning-input[data-field="pEmail"]').className = 'textInput-err';
					this.template.querySelector('label[data-field="pEmail"]').className = 'input-error-label';
					isValid = false;
				} else {
					this.emailerrorvalid = false;
					this.template.querySelector('lightning-input[data-field="pEmail"]').className = 'textInput';
					this.template.querySelector('label[data-field="pEmail"]').className = 'input-label';
				}
			}
		}
		if (this.isAdult === true) {
			if (this.leadFields.Phone) {
				if (!/^\+?[0-9]+$/.test(this.leadFields.Phone)) {
					this.phnerrorvalid = true;
					this.template.querySelector('lightning-input[data-field="pPhone"]').className = 'textInput-err';
					this.template.querySelector('label[data-field="pPhone"]').className = 'input-error-label';
					isValid = false;
				}
				else {
					this.phnerrorvalid = false;
					this.template.querySelector('lightning-input[data-field="pPhone"]').className = 'textInput';
					this.template.querySelector('label[data-field="pPhone"]').className = "input-label";
				}
			}
		}
		return isValid;
	}

	//This Function is used for check validation for Caregiver in hcp enrollment form
	carevalidateForm() {
		// Add your validation logic here for each required field
		let isValid = true;

		// First Name
		if (!this.CaregiverFields.FirstName) {
			this.template.querySelector('lightning-input.cFN').className = 'textInput-err cFN';
			this.template.querySelector('label.cFN').className = 'input-error-label cFN';
			this.carefirstnameerrorMessage = true;
			isValid = false;
		} else {
			this.carefirstnameerrorMessage = false;

			if (this.carefirstnameerrorMessage === true || this.carefirstnameerrorMessagevalid === true) {
				this.template.querySelector('lightning-input[data-field="cFN"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="cFN"]').className = 'input-error-label';
				isValid = false;

			} else {
				this.template.querySelector('lightning-input.cFN').className = 'textInput cFN';
				this.template.querySelector('label.cFN').className = 'input-label cFN';
			}

		}

		// Last Name
		if (!this.CaregiverFields.LastName) {
			this.template.querySelector('lightning-input.cLN').className = 'textInput-err cLN';
			this.template.querySelector('label.cLN').className = 'input-error-label cLN';
			this.carelastnameerrorMessage = true;
			isValid = false;
		} else {
			this.carelastnameerrorMessage = false;


			if (this.carelastnameerrorMessage === true || this.carelastnameerrorMessagevalid === true) {
				this.template.querySelector('lightning-input[data-field="cLN"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="cLN"]').className = 'input-error-label';
				isValid = false;

			} else {
				this.template.querySelector('lightning-input.cLN').className = 'textInput cLN';
				this.template.querySelector('label.cLN').className = 'input-label cLN';
			}
		}

		// Date of Birth
		if (!this.CaregiverFields.dob) {
			this.template.querySelector('lightning-input.cDob').className = 'textInput-err cDob';
			this.template.querySelector('label.cDob').className = 'input-error-label cDob';
			this.caredoberrorMessage = true;
			isValid = false;
		} else {
			this.caredoberrorMessage = false;
			if (this.errors === true || this.minorerror === true) {
				this.template.querySelector('lightning-input.cDob').className = 'textInput-err cDob';
				this.template.querySelector('label.cDob').className = 'input-error-label cDob';
				isValid = false;


			} else {
				this.template.querySelector('lightning-input.cDob').className = 'textInput cDob';
				this.template.querySelector('label.cDob').className = 'input-label cDob';
			}

		}

		// Email
		if (!this.CaregiverFields.Email) {
			this.template.querySelector('lightning-input.cEmail').className = 'textInput-err cEmail';
			this.template.querySelector('label.cEmail').className = 'input-error-label cEmail';
			this.careemailerrorMessage = true;
			isValid = false;
		} else {
			this.careemailerrorMessage = false;
			const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

			if (!emailRegex.test(this.CaregiverFields.Email)) {
				this.cemailerrorvalid = true;
				this.template.querySelector('lightning-input.cEmail').className = 'textInput-err cEmail';
				this.template.querySelector('label.cEmail').className = 'input-error-label cEmail';
				isValid = false;
			} else {
				this.cemailerrorvalid = false;
				this.template.querySelector('lightning-input.cEmail').className = 'textInput cEmail';
				this.template.querySelector('label.cEmail').className = 'input-label cEmail';
			}
		}

		//Realtionship 
		if (!this.selectedRelationship) {
			this.template.querySelector('lightning-combobox.cRel').className = 'textInput-err cRel';
			this.template.querySelector('label.cRel').className = 'input-error-label cRel';
			this.RelationshiperrorMessage = true;
			isValid = false;
		} else {
			this.RelationshiperrorMessage = false;
			this.template.querySelector('lightning-combobox.cRel').className = 'textInput cRel';
			this.template.querySelector('label.cRel').className = 'input-label cRel';
		}
		if (this.CaregiverFields.Phone) {
			if (!/^\+?[0-9]+$/.test(this.CaregiverFields.Phone)) {
				this.cphoneerrorvalid = true;
				this.template.querySelector('lightning-input[data-field="cPhone"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="cPhone"]').className = 'input-error-label';
				isValid = false;
			}
			else {
				this.template.querySelector('lightning-input[data-field="cPhone"]').className = 'textInput';
				this.cphoneerrorvalid = false;
				this.template.querySelector('label[data-field="cPhone"]').className = 'input-label';
			}
		}
		return isValid;
	}

	//This Function is used for check validation for prescription in hcp enrollment form
	PrescriptionFieldsForm() {
		// Add your validation logic here for each required field
		let isValid = true;

		// drug
		if (!this.selectedValue || this.searchresultempty === true) {
			this.template.querySelector('lightning-input.hDrug').className = 'textInput-err hDrug';
			this.template.querySelector('label.hDrug').className = 'input-error-label hDrug';
			this.drugerrorMessage = true;
			isValid = false;
		} else {
			this.drugerrorMessage = false;
			this.template.querySelector('lightning-input.hDrug').className = 'textInput hDrug';
			this.template.querySelector('label.hDrug').className = 'input-label hDrug';
		}

		// Prescribed date
		if (!this.PrescriptionFields.date) {
			this.template.querySelector('lightning-input.hpdate').className = 'textInput-err hpdate';
			this.template.querySelector('label.hpdate').className = 'input-error-label hpdate';
			this.dateerrorMessage = true;
			isValid = false;
		} else {
			this.dateerrorMessage = false;
			this.template.querySelector('lightning-input.hpdate').className = 'textInput hpdate';
			this.template.querySelector('label.hpdate').className = 'input-label hpdate';
		} // authorize
		if (!this.ConsentFields.authorize || this.ConsentFields === undefined) {
			this.authorizeerrorMessage = true;
			this.template.querySelector('lightning-input.agree').className = 'agree';
			isValid = false;
		} else {
			this.authorizeerrorMessage = false;
		}
		return isValid;
	}

	HCPvalidateForm() {
		// Add your validation logic here for each required field
		let isValid = true;
		const firstNameField = this.template.querySelector('lightning-input[data-field="hFN"]');
		const lastNameField = this.template.querySelector('lightning-input[data-field="hLN"]');
		const ParticeNameField = this.template.querySelector('lightning-input[data-field="hPN"]');
		const licenseField = this.template.querySelector('lightning-input[data-field="hLicense"]');
		const FaxField = this.template.querySelector('lightning-input[data-field="hFax"]');
		const PhoneField = this.template.querySelector('lightning-input[data-field="hPhone"]');
		const EmailField = this.template.querySelector('lightning-input[data-field="hEmail"]');
		const MailingCountryCodeField = this.template.querySelector('lightning-combobox[data-field="hcc"]');
		const MailingStateCodeField = this.template.querySelector('lightning-combobox[data-field="hsc"]');
		const MailingCityField = this.template.querySelector('lightning-input[data-field="hc"]');
		const MailingStreetField = this.template.querySelector('lightning-input[data-field="hs"]');
		const MailingPostalCodeField = this.template.querySelector('lightning-input[data-field="hpc"]');
		const PracticenameField = this.template.querySelector('lightning-input[data-field="hPN"]');
		const practiceField = this.template.querySelector('lightning-combobox[data-field="hType"]');

		// First Name        
		if (!firstNameField.value) {
			this.RPfirstnameerrorMessage = true;
			isValid = false;
			firstNameField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hFN"]').className = 'input-error-label';

		} else {
			this.RPfirstnameerrorMessage = false;
			if (this.RPfirstnameerrorMessagevaild === true) {

				firstNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hFN"]').className = 'input-error-label';

				isValid = false;
			} else {
				firstNameField.className = 'textInput';
				this.template.querySelector('label[data-field="hFN"]').className = 'input-label';
			}

		}

		// Last Name        
		if (!lastNameField.value) {
			this.RPlastnameerrorMessage = true;
			lastNameField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hLN"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPlastnameerrorMessage = false;
			if (this.RPlastnameerrorMessagevalid === true) {
				lastNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hLN"]').className = 'input-error-label';
				isValid = false;
			} else {
				lastNameField.className = 'textInput';
				this.template.querySelector('label[data-field="hLN"]').className = 'input-label';
			}

		}

		if (!ParticeNameField.value) {
			this.RPPracticenameerrorMessage = true;
			ParticeNameField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hPN"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPPracticenameerrorMessage = false;
			if (this.RPPracticenameerrorMessagevalid === true) {
				ParticeNameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hPN"]').className = 'input-error-label';
				isValid = false;
			} else {
				ParticeNameField.className = 'textInput';
				this.template.querySelector('label[data-field="hPN"]').className = 'input-label';
			}

		}
		// state license
		if (!licenseField.value) {
			this.RPstatelicenseerrorMessage = true;
			this.RPstatelicenseerrorMessagevalid = false;
			licenseField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hLicense"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPstatelicenseerrorMessage = false;
			if (!/^\d+$/.test(licenseField.value)) {
				this.RPstatelicenseerrorMessage = false;
				this.RPstatelicenseerrorMessagevalid = true;
				licenseField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hLicense"]').className = 'input-error-label';
				isValid = false;
			} else {
				licenseField.className = 'textInput';
				this.template.querySelector('label[data-field="hLicense"]').className = 'input-label';
			}

		}

		if (PhoneField.value) {
			if (!/^\+?[0-9]+$/.test(PhoneField.value)) {
				this.RPphoneerrorMessage = true;
				PhoneField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hPhone"]').className = 'input-error-label';
				isValid = false;
			}
			else {
				PhoneField.className = 'textInput';
				this.RPphoneerrorMessage = false;
				this.template.querySelector('label[data-field="hPhone"]').className = 'input-label';
			}
		}
		if (FaxField.value) {
			if (!/^\+?[0-9]+$/.test(FaxField.value)) {
				this.RPfaxerrorMessage = true;
				FaxField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hFax"]').className = 'input-error-label';
				isValid = false;
			} else {
				FaxField.className = 'textInput';
				this.template.querySelector('label[data-field="hFax"]').className = 'input-label';
				this.RPfaxerrorMessage = false;
			}

		}
		// Email   
		if (!EmailField.value) {
			this.RPemailerrorvalid = false;
			EmailField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hEmail"]').className = 'input-error-label';
			this.RPemailerrorMessage = true;
			isValid = false;
		} else {
			this.RPemailerrorMessage = false;
			const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			if (!emailRegex.test(this.HCpFields.email)) {
				this.RPemailerrorvalid = true;
				EmailField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hEmail"]').className = 'input-error-label';
				isValid = false;
			} else {
				this.RPemailerrorvalid = false;
				EmailField.className = 'textInput';
				this.template.querySelector('label[data-field="hEmail"]').className = 'input-label';
			}
		}

		// MailingCountryCode
		if (!MailingCountryCodeField.value) {
			this.RPcountryerrorMessage = true;
			MailingCountryCodeField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hcc"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPcountryerrorMessage = false;
			MailingCountryCodeField.className = 'textInput';
			this.template.querySelector('label[data-field="hcc"]').className = 'input-label';
		}
		// MailingStateCode
		if (!MailingStateCodeField.value) {
			this.RPstatecodeerrorMessage = true;
			MailingStateCodeField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hsc"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPstatecodeerrorMessage = false;
			MailingStateCodeField.className = 'textInput';
			this.template.querySelector('label[data-field="hsc"]').className = 'input-label';
		}
		// MailingCity
		if (!MailingCityField.value) {
			this.RPcityerrorMessage = true;
			MailingCityField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hc"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPcityerrorMessage = false;
			if (this.RPcityerrorMessagevalid === true) {
				MailingCityField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hc"]').className = 'input-error-label';
			} else {
				MailingCityField.className = 'textInput';
				this.template.querySelector('label[data-field="hc"]').className = 'input-label';

			}
		}

		// MailingStreet
		if (!MailingStreetField.value) {
			this.RPstreeterrorMessage = true;
			MailingStreetField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hs"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPstreeterrorMessage = false;
			MailingStreetField.className = 'textInput';
			this.template.querySelector('label[data-field="hs"]').className = 'input-label';
		}
		// MailingPostalCode
		if (!MailingPostalCodeField.value) {
			this.RPpostalcodeerrorMessage = true;
			MailingPostalCodeField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hpc"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPpostalcodeerrorMessage = false;
			MailingPostalCodeField.className = 'textInput';
			this.template.querySelector('label[data-field="hpc"]').className = 'input-label';
		}

		if (!PracticenameField.value) {
			this.RPPracticenameerrorMessage = true;
			PracticenameField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hPN"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPPracticenameerrorMessage = false;
			if (this.RPlastnameerrorMessagevalid === true) {
				PracticenameField.className = 'textInput-err';
				this.template.querySelector('label[data-field="hPN"]').className = 'input-error-label';
			} else {
				PracticenameField.className = 'textInput';
				this.template.querySelector('label[data-field="hPN"]').className = 'input-label';
			}

		}

		// practice type
		if (!practiceField.value) {
			this.RPpracticetypeerrorMessage = true;
			practiceField.className = 'textInput-err';
			this.template.querySelector('label[data-field="hType"]').className = 'input-error-label';
			isValid = false;
		} else {
			this.RPpracticetypeerrorMessage = false;
			practiceField.className = 'textInput';
			this.template.querySelector('label[data-field="hType"]').className = 'input-label';
		}

		return isValid;
	}

	ReferringPracticeValidation() {

		// Add your validation logic here for each required field
		let isValid = true;

		// referring

		if (!this.physicianNameInputDisabled && (!this.selectedValue1 || this.searchresultempty1 === true)) {
			this.template.querySelector('lightning-input.searchHCPName').className = 'textInput-err searchHCPName';
			this.template.querySelector('label.searchHCPName').className = 'input-error-label searchHCPName';
			this.referringerrorMessage = true;
			isValid = false;
		} else {
			this.template.querySelector('lightning-input.searchHCPName').className = 'textInput searchHCPName';
			this.template.querySelector('label.searchHCPName').className = 'input-label-front searchHCPName';
			this.referringerrorMessage = false;
		}

		if (!this.physicianIdInputDisabled && (!this.selectedValue2 || this.searchresultempty2 === true)) {
			this.template.querySelector('lightning-input.searchHCPId').className = 'textInput-err searchHCPId';
			this.template.querySelector('label.searchHCPId').className = 'input-error-label searchHCPId';
			this.referringerrorMessage = true;
			isValid = false;
		} else {
			this.template.querySelector('lightning-input.searchHCPId').className = 'textInput searchHCPId';
			this.template.querySelector('label.searchHCPId').className = 'input-label-front searchHCPId';
			this.referringerrorMessage = false;
		}
		return isValid;
	}
	authorize() {
		// Add your validation logic here for each required field
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

	showError(message) {
		const errorMessage = {
			title: 'Error',
			message: message,
			variant: 'error',
		};
		this.dispatchEvent(new CustomEvent('showtoast', { detail: errorMessage }));
	}
	showModal() {
		this.openModal = true;
		this.template.querySelector('div.formContainer').style.zIndex = 1001;
	}
	closeModal() {
		this.openModal = false;
		this.template.querySelector('div.formContainer').style.zIndex = 1000;
	}
	expandAddNewForm() {
		if ((this.physicianIdInputDisabled === true || this.physicianNameInputDisabled === true) && this.isAddNew === false) {
			return;
		}
		if (this.isAddNew === false) {
			this.physicianNameInputDisabled = true;
			this.physicianIdInputDisabled = true;
			this.template.querySelector('lightning-input.searchHCPName').className = 'InputDisabled  searchHCPName';
			this.template.querySelector('lightning-input.searchHCPId').className = 'InputDisabled  searchHCPId';
			this.template.querySelector('label.searchHCPId').className = 'Disable searchHCPId';
			this.template.querySelector('label.searchHCPName').className = 'Disable searchHCPName';

			this.referringerrorMessage = false;
			this.isAddNew = true;
		} else {
			this.physicianNameInputDisabled = false;
			this.physicianIdInputDisabled = false;
			this.template.querySelector('label.searchHCPName').className = 'input-label-front searchHCPName';
			this.template.querySelector('label.searchHCPId').className = 'input-label-front searchHCPId';
			this.template.querySelector('lightning-input.searchHCPName').className = 'textInput searchHCPName';
			this.template.querySelector('lightning-input.searchHCPId').className = 'textInput searchHCPId';
			this.isAddNew = false;
		}
		this.RPfirstnameerrorMessage = false;
		this.RPfirstnameerrorMessagevalid = false;
		this.RPlastnameerrorMessage = false;
		this.RPlastnameerrorMessagevalid = false;
		this.RPstatelicenseerrorMessage = false;
		this.RPstatelicenseerrorMessagevalid = false;
		this.RPPracticenameerrorMessage = false;
		this.RPpracticetypeerrorMessage = false;
		this.RPemailerrorvalid = false;
		this.RPemailerrorMessage = false;
		this.RPpostalerrorMessagevalid = false;
		this.RPpostalerrorMessagevalid = false;
		this.RPpostalcodeerrorMessage = false;
		this.RPstreeterrorMessage = false;
		this.RPcityerrorMessagevalid = false;
		this.RPcityerrorMessage = false;
		this.RPstatecodeerrorMessage = false;
		this.RPcountryerrorMessage = false;
		this.RPphoneerrorMessage = false;
	}
	goToHome() {
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				name: 'Home'
			}
		});
	}

	// HCP Name Search box handling methods
	// Start

	showHcpNamePicklist() {
		if (!this.searchResults1 === 0) {

			this.searchResults1 = this.picklistOrdered1;
		}
	}
	hcpNameOnChange(event) {
		this.selectedSearchResult1 = "";
		this.searchmain = false;
		const input = event.detail.value.toLowerCase();
		this.searchValue1 = event.detail.value;
		if (this.searchValue1 === '') {
			this.searchmain = true;
		}

		if (input === "") {
			this.physicianIdInputDisabled = false;
			this.addNewHCPSectionClass = 'addNewHcpSection';
		}
		this.searchResults1 = this.picklistOrdered1.filter((picklistOption1) =>
			picklistOption1.label.toLowerCase().includes(input)
		);
		const searchedResult1 = this.picklistOrdered1.filter((picklistOption1) =>
			picklistOption1.label.toLowerCase().includes(input)
		);

		this.searchresultempty1 = searchedResult1.length === 0 ? true : false


		if (this.searchresultempty1 === true) {
			this.physicianIdInputDisabled = true;
		}
	}

	async handleHcpNameOptionClick(event) {
		const selectedValue1 = event.currentTarget.dataset.value;

		this.selectedSearchResult1 = this.picklistOrdered1.find(
			(picklistOption1) => picklistOption1.value === selectedValue1
		);
		const messageEvent = new CustomEvent('changes', { detail: selectedValue1 });
		await this.dispatchEvent(messageEvent);
		this.physicianIdInputDisabled = true;
		this.addNewHCPSectionClass = 'addNewHcpSection-disable';
	}
	// We are using setTimeout to search the combobox in the Physician name picklist field  to reset the searchResults variable to null.
	handleOnBlurForHCpName() {
		try {
			setTimeout(() => {
				this.searchResults1 = null;
			}, 300);
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}

	}
	//End
	// HCP Name Search box handling methods
	// Start
	hcpIdOnChange(event) {
		this.selectedSearchResult2 = "";
		this.searchmain2 = false;
		const input = event.detail.value;
		this.searchValue2 = event.detail.value;
		if (this.searchValue2 === '') {
			this.searchmain2 = true;
		}
		if (input === "") {
			this.physicianNameInputDisabled = false;
			this.addNewHCPSectionClass = 'addNewHcpSection';
		}

		this.searchResults2 = this.picklistOrdered2.filter(element => (
			element?.label !== null && element?.label !== undefined
		)).filter((picklistOption2) => (
			picklistOption2?.label.toString().includes(input)

		))

	this.searchResult2 = this.picklistOrdered2.filter(element => (
			element?.label != null && element?.label != undefined
		)).filter((picklistOption2) => (
			picklistOption2?.label.toString().includes(input)

		))

		this.searchresultempty2 = this.searchResult2.length === 0 ? true : false

		if (this.searchresultempty2 === true) {
			this.physicianNameInputDisabled = true;
		}
	}
	showHcpIdPicklist() {

		if (!this.searchResult2.length === 0) {
			this.searchResults2 = this.picklistOrdered2.filter(element => {
				return element?.label !== null && element?.label !== undefined
			})
		}

	}
	async handleHcpIdOptionClick(event) {
		const selectedValue2 = event.currentTarget.dataset.value;

		this.selectedSearchResult2 = this.picklistOrdered2.find(
			(picklistOption2) => picklistOption2.value === selectedValue2
		);
		const messageEvent = new CustomEvent('changes', { detail: selectedValue2 });
		await this.dispatchEvent(messageEvent);
		this.physicianNameInputDisabled = true;
		this.addNewHCPSectionClass = 'addNewHcpSection-disable';
	}
	// We are using setTimeout to search the combobox in the Physician Id picklist field  to reset the searchResults variable to null.
	handleOnBlurForHCpId() {
		try {
			setTimeout(() => {
				this.searchResults2 = null;
			}, 300);
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}
	//End
	// Drug Search box handling methods
	//Start

	showPicklistOptions() {
		if (!this.searchResults.length === 0) {
			this.searchResults = this.picklistOrdered;
		}
	}

	//This function is used to search the Drug code Fields
	search(event) {
		this.searchvaluelogo = false;
		this.searchValue = event.detail.value;
		if (this.searchValue === '') {
			this.searchvaluelogo = true;
		}
		this.selectedSearchResult = '';
		const input = event.detail.value.toLowerCase();

		this.searchResults = this.picklistOrdered.filter((picklistOption) =>
			picklistOption.label.toLowerCase().includes(input)
		);
		const searchedResult = this.picklistOrdered.filter((picklistOption) =>
			picklistOption.label.toLowerCase().includes(input)
		);
		this.searchresultempty = searchedResult.length === 0 ? true : false
		if (this.searchresultempty === true) {
			this.drugerrorMessage = false;
		}
	}

	async selectSearchResult(event) {
		const selectedValue = event.currentTarget.dataset.value;
		if (selectedValue) {
			getprescritionData({ productId: selectedValue })
				// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => {

					this.PrescriptionFields.DosageCode = result[0].BI_PSPB_Product_code__c;
					this.PrescriptionFields.Dosage = result[0].BI_PSPB_Dosage__c;
					this.PrescriptionFields.Unit = result[0].BI_PSPB_Unit__r.Name;

				})
				.catch(error => {
					// Handle any errors from the Apex call

					this.showToast(errormessage, error.message, errorvariant);

				});
		} else {
			this.code = '';
		}
		this.selectedSearchResult = this.picklistOrdered.find(
			(picklistOption) => picklistOption.value === selectedValue
		);
		const messageEvent = new CustomEvent('changes', { detail: selectedValue });
		await this.dispatchEvent(messageEvent);
	}

	// We are using setTimeout to search the combobox in the Drug picklist field  to reset the searchResults variable to null.
	handleOnBlurForDrug() {
		try {
			setTimeout(() => {
				this.searchResults = null;
			}, 300);
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	//To fetch picklistvalues for country fields
	@wire(getPicklistValues, {
		recordTypeId: '$objectInfo.data.defaultRecordTypeId',
		fieldApiName: COUNTRY_FIELD
	})
	CountryValues({ data, error }) {
		try {
			if (data) {
				this.CountryCode = data.values.map(option => ({
					label: option.label,
					value: option.value
				}));
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);
			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}

	//To fetch picklistvalues for state fields
	@wire(getPicklistValues, {
		recordTypeId: '$objectInfo.data.defaultRecordTypeId',
		fieldApiName: STATE_FIELD,
		controllingFieldValue: '$MailingCountryCode'
	})
	StateValues({ data, error }) {
		try {
			if (data) {
				this.StateCode = data.values.map(option => ({
					label: option.label,
					value: option.value
				}));
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);
			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}

	//This function is used to date validation in date of birth
	DOByearvalidationforPatient() {
		let isValid = true;
		if (this.oneninezerozeroerrors === true) {
			this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="pdob"]').className = 'input-error-label';
			this.oneninezerozeroerrors = true;
			isValid = false;
		} else {
			this.oneninezerozeroerrors = false;
			this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput';
			this.template.querySelector('label[data-field="pdob"]').className = 'input-label';
		}
		return isValid;

	}

	//This function is used to future date validation in date of birth
	DOBfuturevalidationforPatient() {
		let isValid = true;

		if (this.error === true) {

			this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="pdob"]').className = 'input-error-label';
			this.error = true;
			this.doberrorMessage = false;
			isValid = false;
		} else {
			this.error = false;
			this.template.querySelector('lightning-input[data-field="pdob"]').className = 'textInput';
			this.template.querySelector('label[data-field="pdob"]').className = 'input-label';
		}
		return isValid;

	}
	////This function is used to Number input fields
	handleKeyDown(event) {
		const charCode = event.which ? event.which : event.keyCode; // Get the ASCII code of the pressed key
		if (charCode !== 43 && (charCode < 48 || charCode > 57)) { // Allow only digits (48-57) and the plus symbol (43)
			event.preventDefault(); // Prevent the character from being entered
		}
	}

	//This function is used to Text input fields
	handleKeyDown1(event) {
		// Allow only letters, backspace, and delete
		if (!((event.keyCode >= 65 && event.keyCode <= 90) || // A-Z
			(event.keyCode >= 97 && event.keyCode <= 122) ||  // a-z
			event.keyCode === 8 ||  // Backspace
			event.keyCode === 46 ||  // Delete
			(event.keyCode >= 37 && event.keyCode <= 40) ||
			event.keyCode === 9 ||  // Tab
			(event.shiftKey && event.keyCode === 9)
		)) {
			event.preventDefault();
		}
	}
	handleKeyDown2(event) {
    // Allow only numbers, backspace, and delete
    if (!((event.keyCode >= 48 && event.keyCode <= 57) ||  // 0-9
	    (event.keyCode >= 96 && event.keyCode <= 105) ||
        event.keyCode === 8 ||  // Backspace
        event.keyCode === 46 ||  // Delete
        (event.keyCode >= 37 && event.keyCode <= 40) ||
        event.keyCode === 9 ||  // Tab
        (event.shiftKey && event.keyCode === 9)
    )) {
        event.preventDefault();
    }
    // Prevent input of special characters
    if (event.key.match(/[^a-zA-Z0-9]/)) {
        event.preventDefault();
    }
}


	//This function is used to check for Patient Validation
	UniqueValidation() {
		let isValid = true;
		if (this.isAdult === true) {
			if (
				this.uniqueEmail.includes(this.leadFields.Email) &&
				this.uniqueFName.includes(this.leadFields.FirstName) &&
				this.uniqueLname.includes(this.leadFields.LastName) &&
				this.uniqueDOB.includes(this.leadFields.dob)
			) {

				this.unique = true;
				isValid = false;
			} else {
				this.unique = false;
			}

			if (this.uniqueEmail.includes(this.leadFields.Email) && this.unique === false) {
				this.Matchemail = true;
				this.template.querySelector('lightning-input[data-field="pEmail"]').className = 'textInput-err';
				this.template.querySelector('label[data-field="pEmail"]').className = 'input-error-label';

				isValid = false;
			} else {
				this.Matchemail = false;
				this.template.querySelector('lightning-input[data-field="pEmail"]').className = 'textInput';
				this.template.querySelector('label[data-field="pEmail"]').className = 'input-label';
			}
		}
		return isValid;
	}
   
//The Caregivervalidation() function likely validates caregiver data for uniqueness 
//based on email and checks for existing caregiver records in the system.
	Caregivervalidation(){
			console.log('hh1')
					if (!this.carevalidateForm()) {
						// No need for a return here
					} else if (this.errors === true || this.minorerror === true) {
						this.template.querySelector('lightning-input.cDob').className = 'inputred cDob';
						this.template.querySelector('label.cDob').className = 'labelred cDob';
						// No need for a return here
					}
					else {
						// If none of the above conditions are met, execute the following code
						this.handleClose();
						this.currentStep = '4';
						this.template.querySelector('div.stepThree').classList.add('slds-hide');
						this.template.querySelector('div.stepFour').classList.remove('slds-hide');
						// Progress indicator
						this.template.querySelector('li.li-three').classList.remove('slds-is-active');
						this.template.querySelector('li.li-three').classList.add('slds-is-completed');
						this.template.querySelector('li.li-four').classList.add('slds-is-active');
						//To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
						//To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
						const avatarcontent = this.template.querySelector('p.avatar-content');
						avatarcontent.innerHTML = `Thank you for choosing Spevigo® for<br> your patients with GPP.
<br>
<br>
To enroll your patients in the  Beyond<br>
GPP: The Spevigo® <br>Patient Support
Program, please<br> complete the form on
this page.`;
						this.mobilevalue2 = `Thank you for choosing Spevigo® for your patients with GPP.
To enroll your patients in the Beyond
GPP: The Spevigo® Patient Support
Program, please complete the form on
this page.`;
					}
	}
  
	//This function is used to check for Caregiver Validation
	UniquecaregiverValidation() {
		let isValid = true;
		if (this.uniqueEmail[0].includes(this.CaregiverFields.Email) &&
			this.uniqueFName[0].includes(this.CaregiverFields.FirstName) &&
			this.uniqueLname[0].includes(this.CaregiverFields.LastName)) {
			// Assuming isValid is declared before this block
			
			isValid = true;
		} else {
			if (this.uniqueEmail.includes(this.CaregiverFields.Email)) {

				this.Matchcaregiveremail = true;
				this.template.querySelector('lightning-input.cEmail').className = 'inputred cEmail';
				this.template.querySelector('label.cEmail').className = 'labelred cEmail';
				isValid = false;
			} else {
				this.Matchcaregiveremail = false;
				this.unique = false;
			}
		}
		return isValid;
	}
	//Showtoast message for catch error
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}