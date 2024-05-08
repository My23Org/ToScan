//This LWC is used for create patient detail record enrollment processs.
//Proper naming conventions with camel case for all the variable will be followed in the future releases
// To import Libraries
import { LightningElement, wire, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadStyle } from "lightning/platformResourceLoader";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import { NavigationMixin } from "lightning/navigation";

// To import current user ID
import Id from "@salesforce/user/Id";

// Importing Apex classes to interact with Salesforce backend for data retrieval.
import hcpAccessCode from "@salesforce/apex/BI_PSPB_getLead.hcpAccessCode";
import updateLeadPatientRecord from "@salesforce/apex/BI_PSPB_createLeadRecord.insertLead";
import hcpCreate from "@salesforce/apex/BI_PSPB_getLead.hcpCreate";
import getEnrolleeCaregiverId from "@salesforce/apex/BI_PSPB_getLead.getEnrolleeCaregiverId";
import getValuesFromTable1 from "@salesforce/apex/BI_PSPB_referringPractitioner.getPractitionerList";
import getLeadGenderOptions from "@salesforce/apex/BI_PSPB_createLeadRecord.getCommunicationOptions";
import getExistingAccounts from "@salesforce/apex/BI_PSPB_leadCreationCtrl.getExistingAccounts";
import verifyUnassign from "@salesforce/apex/BI_PSPB_getLead.verifyUnassign";

// Imports labels for descriptive text or identifiers, enhancing accessibility and user understanding.
import PatientFirstName from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_First_Name";
import PatientLastName from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Last_Name";
import PatientDateofbirth from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Date_of_birth";
import PatientGender from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Gender";
import PatientEmail from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Physician_Email";
import country from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Country";
import state from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_state";
import city from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_City";
import street from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_street";
import pincode from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Pincode";
import Patientphone from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_phone_number";
import preferredcontactmethod from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Preffered_contact_method";
import acute from "@salesforce/label/c.BI_PSPB_Acute";
import unbranded from "@salesforce/label/c.BI_PSP_Unbranded";
import chronic from "@salesforce/label/c.BI_PSPB_statusChronic";
import errormessage from "@salesforce/label/c.BI_PSP_ConsoleError";
import errorvariant from "@salesforce/label/c.BI_PSPB_errorVariant";
import doberror from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Future_date";
import agelessEighteen from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_patient_dob";
import psUrl from "@salesforce/label/c.BI_PSPB_BRPatientSummary";
import sms from "@salesforce/label/c.BI_PSP_NotificationSMS";
import phone from "@salesforce/label/c.BI_PSPB_Phone";
import yes from "@salesforce/label/c.BI_PSP_SoftDelete";
import requiredMsg from "@salesforce/label/c.BI_PSP_RequiredMsg";
import errorfound from "@salesforce/label/c.BI_PSP_record_not_found_error_message";
import showToast from "@salesforce/label/c.BI_PSP_Showtoast";

// Imports resourceUrl to reference external resources for proper rendering and functionality.
import BGpp from "@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo";
import textalign from "@salesforce/resourceUrl/BI_PSPB_TextAlignmentHcp";
import Warningicon from "@salesforce/resourceUrl/BI_PSP_WarningIcon";
import calendericon from "@salesforce/resourceUrl/BI_PSPB_CalenderIconSymp";
import iconcss from "@salesforce/resourceUrl/BI_PSPB_InputsearchIcon";
import OLD_GUY_JPEG_URL from "@salesforce/resourceUrl/BI_PSPB_Patient_Entrollment_patient_Avater";

// Imports scheme to define structured data exchange protocol within component for consistency and interoperability.
import Lead from "@salesforce/schema/Lead";
import HealthCloudGA__Gender__c from "@salesforce/schema/Lead.HealthCloudGA__Gender__c";
import COUNTRY_FIELD from "@salesforce/schema/Lead.CountryCode";
import STATE_FIELD from "@salesforce/schema/Lead.StateCode";

export default class PatientEnrollmentForm extends NavigationMixin(
  LightningElement
) {
  @api
  get selectedValueOne() {
    return this.selectedSearchResult1?.label || this.selectedSearchResult1;
  }
  @track isLoaded = false;
  @track selectedValue;
  @track searchResults1;
  @track searchResults;
  @track recordId;
  @track addNewHCPSectionClass = "addNewHcpSection"; // to invoke CSS class
  @track firstnameerrorMessage = false;
  @track physicianerrorMessage = false;
  @track physicianrequireMessage = false;
  @track lastnameerrorMessage = false;
  @track doberrorMessage = false;
  @track gendererrorMessage = false;
  @track emailerrorMessage = false;
  @track carefirstnameerrorMessage = false;
  @track carelastnameerrorMessage = false;
  @track caredoberrorMessage = false;
  @track hfirstnameerrorMessage = false;
  @track hlastnameerrorMessage = false;
  @track hphonenumbererrorMessage = false;
  @track hemailerrorMessage = false;
  @track haddresslineerrorMessage = false;
  @track searchValue1 = "";
  @track isSearch1Cleared = false;
  @track emailError = false;
  @track selectedCountryCode = "";
  @track selectedStateCode = "";
  @track CountryCode = [];
  @track StateCode = [];
  @track isUnbranded = false;
  @track showinfoquestion = true;
  @track oneninezerozeroerrors = false;
  @track RPcityerrorMessagevalid = false;
  @track FieldBox = false;
  @track variable = false;
  @track DoAccess = true;
  @track DoAccessHcp = false;
  @track careId;
  @track hidesearchicon = true;
  @track hideuparrow = "hideuparrow";
  @track Matchemail = false;
  @track currentStep = "";
  @track hcpFirstName = "";
  @track hcpLastName = "";
  @track hcpAccName = "";
  @track hcpPhone = "";
  @track hcpEmail = "";
  @track checbox;
  @track checkboxrequired = false;
  @track selectedReferringPractitioner = "";
  @track accessCodeId;
  @track searchresultempty1 = "";
  @track accessCode;
  @track openModal = false;
  @track dobErrorMessage = false;
  @track submitModal = false;
  @track divfalse = true;
  @track subvalue;
  @track uId;
  @track uFirstName;
  @track uLasrName;
  @track uGender;
  @track uEmail;
  @track userType;
  @track isModalOpen = false;
  @track phone = "";
  @track pmc = "";
  @track country = "";
  @track state = "";
  @track city = "";
  @track street = "";
  @track zipCode = "";
  @track firstName = "";
  @track gender = "";
  @track email = "";
  @track lastnamelll = "";
  @track firstnameerrorMessagevalid = false;
  @track lastnameerrorMessagevalid = false;
  @track phoneNumberMandatory = false;
  @track phoneNumberVisible = true;
  @track careDob;
  @track errorMessage = "";
  @track conPhoneErrorMessage = false;
  @track conPmcErrorMessage = false;
  @track conCountryErrorMessage = false;
  @track conStateErrorMessage = false;
  @track conCityErrorMessage = false;
  @track conStreetErrorMessage = false;
  @track conZipCodeErrorMessage = false;
  @track showUpdateForm = true;
  @track showInsertForm = true;
  @track isButtonDisabled = false;
  @track selectedValues11 = "";
  @track error = false;
  @track age;
  @track showAccessCode = false;
  @track showReferringPractitioner = false;
  @track accessCodeErrorMessage = false;
  @track accordionStatusclose = false;
  @track accordionStatus = false;
  @track minor = false; // Initialize to false
  @track dob; // Date of Birth attribute
  @track leadId;
  @track isAdult = false;
  @track popupClass = "popup-hidden";
  @track showContactNumber = false;
  @track careemailerrorMessage = false;
  // Custom Labels for the following 2 variables cannot be created since it truncates the content in mobile devices
  @track mobileview = `Hello! Welcome to Beyond GPP: The
							Spevigo® Patient...`;
  @track mobileviewsub =
    `Hello! Welcome to Beyond GPP: The Spevigo® Patient Support Program
						   We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
						   You need to be 18 or above for self enrollment.`;
  @track selectedOption = {
    src: OLD_GUY_JPEG_URL,
    name: ""
  };
  uniqueEmail;
  uniqueFName;
  uniqueLname;
  uniqueDOB;
  selectedAvatarSrc = OLD_GUY_JPEG_URL;
  leadGender;
  PreferredMethodofCommunication;
  account = "";
  leadids = "";
  clicon = calendericon;
  userId = Id;
  showDetailscg6 = false;
  showDetailscg5 = false;
  showDetailscg4 = false;
  showDetails1 = false;
  showDetailscg2 = false;
  showDetailscg3 = false;
  BGpp = BGpp;
  warningicons = Warningicon;
  label = {
    PatientFirstName,
    PatientLastName,
    PatientDateofbirth,
    PatientGender,
    PatientEmail,
    Patientphone,
    preferredcontactmethod,
    pincode,
    street,
    city,
    state,
    country
  };
  picklistOrdered = [];
  picklistOrdered1 = [];
  options = [];
  leadPmc = [];

  get selectedValues() {
    return this.selectedSearchResult ? this.selectedSearchResult.label : null;
  }
  // Fetches Lead object info and country picklist values, handles errors.

  @wire(getObjectInfo, { objectApiName: "Lead" })
  objectInfo;
  @wire(getPicklistValues, {
    recordTypeId: "$objectInfo.data.defaultRecordTypeId",
    fieldApiName: COUNTRY_FIELD
  })
  CountryValues({ data }) {
    try {
      if (data) {
        this.CountryCode = data.values.map((option) => ({
          label: option.label,
          value: option.value
        }));
      }
    } catch (error) {
      // Handle any errors that occur within the try block
      this.showToast(errormessage, error.message, errorvariant);
    }
  }
  // Fetches state picklist values based on the selected country, handles errors.

  @wire(getPicklistValues, {
    recordTypeId: "$objectInfo.data.defaultRecordTypeId",
    fieldApiName: STATE_FIELD,
    controllingFieldValue: "$country"
  })
  StateValues({ data }) {
    try {
      if (data) {
        this.StateCode = data.values.map((option) => ({
          label: option.label,
          value: option.value
        }));
      }
    } catch (error) {
      // Handle any errors that occur within the try block
      this.showToast(errormessage, error.message, errorvariant);
    }
  }

  // Loads styles and fetches values from Table 1, populating a picklist and handling errors.

  connectedCallback() {
    try {
      loadStyle(this, textalign);
      loadStyle(this, iconcss);
      getValuesFromTable1()
        // Null data is checked and AuraHandledException is thrown from the Apex
        .then((result) => {
          if (result !== null && result.length > 0) {
            let i;
            for (i = 0; i < result.length; i++) {
              this.picklistOrdered1.push({
                label: result[i].Name,
                labelForSpecialist: result[i]?.BI_PSPB_Specialist__c,
                labelForCity: result[i]?.MailingCity,
                value: result[i].Id
              });
            }
            this.picklistOrdered1 = this.picklistOrdered1.sort((a, b) => {
              if (a.label < b.label) {
                return -1;
              } else if (a.label > b.label) {
                return 1;
              }
              return 0;
            });
          } else if (result === null) {
            this.showToast(errormessage, errorfound, errorvariant);
          }
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant);
    }
  }

  // Call an Apex method to retrieve lead PicklistValues
  @wire(getObjectInfo, { objectApiName: Lead })
  objectsInfo;
  @wire(getPicklistValues, {
    recordTypeId: "$objectInfo.data.defaultRecordTypeId",
    fieldApiName: HealthCloudGA__Gender__c
  })
  wiredLeadGenderValues({ data, error }) {
    try {
      if (data) {
        this.leadGender = data.values;
      } else if (error) {
        this.showToast(errormessage, error.body.message, errorvariant);
      }
    } catch (err) {
      this.showToast(errormessage, err.message, errorvariant);
    }
  }
  leadGenderValues({ data, error }) {
    if (data) {
      this.leadGender = data.values;
    } else if (error) {
      this.leadGender = undefined; // Error for combo box undefined item
    }
  }

  // Call an Apex method to retrieve lead gender options
  @wire(getLeadGenderOptions)
  wiredLeadGenderOptions({ data, error }) {
    try {
      // Null data is checked and AuraHandledException is thrown from the Apex
      if (data) {
        // Map the Apex response to the format expected by lightning-combobox
        this.leadPmc = data.map((option) => ({ label: option, value: option }));
      } else if (error) {
        this.showToast(errormessage, error.body.message, errorvariant);
      }
    } catch (err) {
      this.showToast(errormessage, err.message, errorvariant);
    }
  }

  handleCountryCodeChange(event) {
    this.selectedCountryCode = event.detail.value;
    this.selectedStateCode = ""; // Reset selected state when country changes
  }

  goBackToStepOne() {
    this.currentStep = "1";
    this.handleBackProgressBar(2, 1);
    //To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
    //To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
    const avatarContent = this.template.querySelector("div.avatar-content");
    avatarContent.innerHTML = `Hello! Welcome to Beyond GPP: The Spevigo® Patient Support Program
			<br>
			<br>
			We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
			<br>
			You need to be 18 or above for self enrollment.`;
    this.handleClose();

    this.mobileview = `Hello! Welcome to Beyond GPP: The Spevigo® Patient Support Program...`;
    this.mobileviewsub = `Hello! Welcome to Beyond GPP: The Spevigo® Patient Support Program.
			We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
			You need to be 18 or above for self enrollment.`;
  }
  goBackToStepTwo() {
    this.currentStep = "2";
    this.handleBackProgressBar(3, 2);
    //To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
    //To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
    const avatarContent = this.template.querySelector("div.avatar-content");
    avatarContent.innerHTML = `Hello! Welcome to Beyond GPP: The Spevigo® Patient Support Program
		<br>
		<br>
		We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
		<br>
		You need to be 18 or above for self enrollment.`;
    this.handleClose();
    this.mobileview = `Hello! Welcome to Beyond GPP: The Spevigo® Patient Support Program...`;
    this.mobileviewsub = `Hello! Welcome to Beyond GPP: The Spevigo® Patient Support Program.
		We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
		You need to be 18 or above for self enrollment.`;
  }
  goBackToStepThree() {
    this.currentStep = "3";
    this.handleBackProgressBar(4, 3);
    //To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
    //To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
    const avatarContent = this.template.querySelector("div.avatar-content");
    avatarContent.innerHTML = `You can search for your physician details in our records.
		<br>
		If you are unable to locate them, click Add Physician Information to continue.`;
    this.handleClose();
    this.handleClose();
    this.mobileview = `You can search for your physician details in our records...`;
    this.mobileviewsub = `You can search for your physician details in our records.
		If you are unable to locate them, click Add Physician Information to continue.`;
  }
  goBackToStepThree1() {
    this.currentStep = "2";
    this.handleBackProgressBar(4, 2);
    //To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
    //To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
    const avatarContent = this.template.querySelector("div.avatar-content");
    avatarContent.innerHTML = `You can search for your physician details in our records.
		<br>	
		If you are unable to locate them, click Add Physician Information to continue.`;
    this.handleClose();
    this.handleClose();
    this.mobileview = `You can search for your physician details in our records...`;
    this.mobileviewsub = `You can search for your physician details in our records.
		If you are unable to locate them, click Add Physician Information to continue.`;
  }
  goBackToStepOne1() {
    this.currentStep = "1";
    this.template.querySelector("div.stepFour").classList.add("slds-hide");
    this.template.querySelector("div.stepOne").classList.remove("slds-hide");
  }
  goBackToStepFour() {
    this.currentStep = "4";
    this.template.querySelector("div.stepFive").classList.add("slds-hide");
    this.template.querySelector("div.stepFour").classList.remove("slds-hide");
  }
  goBackToStepFive() {
    this.currentStep = "5";
    this.template.querySelector("div.stepSix").classList.add("slds-hide");
    this.template.querySelector("div.stepFive").classList.remove("slds-hide");
  }
  goBackToStepSix() {
    this.currentStep = "6";
    this.template.querySelector("div.stepSeven").classList.add("slds-hide");
    this.template.querySelector("div.stepSix").classList.remove("slds-hide");
  }
  goBackToStepSeven() {
    this.currentStep = "7";
    this.template.querySelector("div.stepEight").classList.add("slds-hide");
    this.template.querySelector("div.stepSeven").classList.remove("slds-hide");
  }

  handleProgressBar(from, to) {
    this.template
      .querySelector(`li.li-${from}`)
      .classList.remove("slds-is-active");
    this.template
      .querySelector(`li.li-${from}`)
      .classList.add("slds-is-completed");
    this.template.querySelector(`li.li-${to}`).classList.add("slds-is-active");

    this.template.querySelector(`div.step-${from}`).classList.add("slds-hide");
    this.template.querySelector(`div.step-${to}`).classList.remove("slds-hide");
  }

  handleBackProgressBar(from, to) {
    this.template
      .querySelector(`li.li-${from}`)
      .classList.remove("slds-is-active");
    this.template
      .querySelector(`li.li-${from}`)
      .classList.remove("slds-is-completed");
    this.template
      .querySelector(`li.li-${to}`)
      .classList.remove("slds-is-completed");
    this.template.querySelector(`li.li-${to}`).classList.add("slds-is-active");

    this.template.querySelector(`div.step-${from}`).classList.add("slds-hide");
    this.template.querySelector(`div.step-${to}`).classList.remove("slds-hide");
  }

  async goToStepTwo() {
    getExistingAccounts({ email: this.email })
      .then((result) => {
        if (result) {
          this.uniqueEmail = result.map((item) => item.PersonEmail);
          this.uniqueFName = result.map((item) => item.FirstName);
          this.uniqueLname = result.map((item) => item.LastName);
          this.uniqueDOB = result.map((item) => item.BI_PSP_Birthdate__c);
          if (!this.UniqueValidation()) {
            //To call the method
            // No need for a return here
          }
        } else {
          if (this.dobErrorMessage) {
            return;
          }

          if (!this.patientvalidateForm()) {
            //To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
            //To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
            const avatarContent =
              this.template.querySelector("div.avatar-content");
            avatarContent.innerHTML = `Hello! Welcome to the Spevigo® patient support program
			<br>
			<br>
			We're excited to help you manage your generalized pustular psoriasis (GPP) and make the most of your Spevigo® therapy.
			<br>
			You need to be 18 or above for self enrollment.`;
            return;
          }

          this.handleVerify();
          if (this.userType === unbranded) {
            this.isUnbranded = true;
          } else if (this.userType === chronic || this.userType === acute) {
            this.submitModal = true;
            this.isUnbranded = false;
          } else {
            this.isUnbranded = false;
            this.Matchemail = false;
            this.handleProgressBar(1, 2);
            this.currentStep = "2";
            //To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
            //To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
            const avatarContent =
              this.template.querySelector("div.avatar-content");
            avatarContent.innerHTML = `You can search for your physician details in our records.
			<br>
			If you are unable to locate them, click Add Physician Information to continue.`;
            this.handleClose();
            this.mobileview = `You can search for your physician details in our records...`;
            this.mobileviewsub = `You can search for your physician details in our records.
			If you are unable to locate them, click Add Physician Information to continue.`;
          }
        }
      })
      .catch((error) => {
        this.showToast(errormessage, error.message, errorvariant);
      });
  }

  UniqueValidation() {
    let isValid = true;
    if (
      this.uniqueEmail.includes(this.email) &&
      this.uniqueFName.includes(this.firstName) &&
      this.uniqueLname.includes(this.lastnamelll) &&
      this.uniqueDOB.includes(this.dob)
    ) {
      this.submitModal = true;
      isValid = false;
    }

    if (this.uniqueEmail.includes(this.email)) {
      this.Matchemail = true;
      this.template.querySelector(
        'lightning-input[data-field="email"]'
      ).className = "textInput-err";
      this.template.querySelector('label[data-field="email"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.Matchemail = false;
      this.template.querySelector(
        'lightning-input[data-field="email"]'
      ).className = "textInput";
      this.template.querySelector('label[data-field="email"]').className =
        "input-label";
    }

    return isValid;
  }
  async goToStepThree() {
    if (!this.physicianvalidateForm()) {
      // No need for a return here
    } else {
      this.currentStep = "3";
      if (this.accordionStatus) {
        this.handleCreateHcp();
      } else {
        if (this.showAccessCode) {
          this.hcpAccessCodeChange();
        }
      }
      //To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
      //To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
      const avatarContent = this.template.querySelector("div.avatar-content");
      avatarContent.innerHTML = `You can search for your physician details in our records.
			If you are unable to locate them, click Add Physician Information to continue`;
      this.handleClose();
      this.mobileview = `You can search for your physician details in our records...`;
      this.mobileviewsub = `You can search for your physician details in our records.	
			If you are unable to locate them, click Add Physician Information to continue.`;
    }
  }

  async hcpAccessCodeChange() {
    try {
      // Null data is checked and AuraHandledException is thrown from the Apex
      let accessId = await hcpAccessCode({ accessCode: this.accessCode });
      this.accessCodeId = accessId.Id;
      this.selectedValues11 = this.accessCodeId;
    } catch (error) {
      this.error = error;
    }
  }

  async goToStepThree1() {
    if (!this.physicianvalidateForm()) {
      return;
    }

    let success = false;
    if (this.accordionStatus) {
      await this.handleCreateHcp();
      success = true;
    } else if (this.showAccessCode) {
      await this.hcpAccessCodeChange();
      if (!this.accessCodeId) {
        this.accessCodeErrorMessage = true;
      } else {
        this.accessCodeErrorMessage = false;
        success = true;
      }
    } else if (this.showReferringPractitioner) {
      success = true;
    }

    if (success === true) {
      this.currentStep = "4";
      this.handleProgressBar(2, 4);
      this.template.querySelector("div.avatar-content").innerHTML =
        `Please provide your contact details on this page`;
      this.mobileview = `Please provide your contact details on this page....`;
    }
  }

  goToStepFour() {
    if (!this.carevalidateForm() || this.minorerror === true) {
      // No need for a return here
    } else {
      this.currentStep = "4";
      this.template.querySelector("div.stepThree").classList.add("slds-hide");
      this.template.querySelector("div.stepFour").classList.remove("slds-hide");
      this.updateBtn();
    }
  }

  goToStepFive() {
    this.currentStep = "5";
    this.template.querySelector("div.stepFour").classList.add("slds-hide");
    this.template.querySelector("div.stepFive").classList.remove("slds-hide");
  }

  checkboxrequire(event) {
    this.checbox = event.target.checked;
    if (this.checbox === "") {
      this.checkboxrequired = true;
    } else {
      this.checkboxrequired = false;
    }
  }

  handleHcpFirstNameChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    const hcpFirstNameField = this.template.querySelector(
      'lightning-input[data-field="pFN"]'
    );
    this.hcpFirstName = event.target.value;
    if (!/^[a-zA-Z]+$/.test(this.hcpFirstName)) {
      this.firstnameerrorMessagevalid = true;
      this.hfirstnameerrorMessage = false;
      hcpFirstNameField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="pFN"]').className =
        "input-error-label";
    } else {
      this.hfirstnameerrorMessage = false;
      this.firstnameerrorMessagevalid = false;
      hcpFirstNameField.className = "textInput";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="pFN"]').className =
        "input-label";
      this.firstnameerrorMessagevalid = false;
      if (this.hcpFirstName === "") {
        this.hfirstnameerrorMessage = true;
        this.firstnameerrorMessagevalid = false;
        hcpFirstNameField.className = "textInput-err";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="pFN"]').className =
          "input-error-label";
      } else {
        this.hfirstnameerrorMessage = false;
        this.firstnameerrorMessagevalid = false;
        hcpFirstNameField.className = "textInput";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="pFN"]').className =
          "input-label";
      }
      this.hcpFirstName =
        event.target.value.charAt(0).toUpperCase() +
        event.target.value.slice(1);
    }
  }
  handleHcpLastNameChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    const hcpLastNameField = this.template.querySelector(
      'lightning-input[data-field="pLN"]'
    );
    this.hcpLastName = event.target.value;
    if (!/^[a-zA-Z]+$/.test(this.hcpLastName)) {
      this.lastnameerrorMessagevalid = true;
      this.hlastnameerrorMessage = false;
      hcpLastNameField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="pLN"]').className =
        "input-error-label";
    } else {
      this.lastnameerrorMessagevalid = false;
      if (this.hcpLastName === "") {
        this.hlastnameerrorMessage = true;
        this.lastnameerrorMessagevalid = false;
        hcpLastNameField.className = "textInput-err";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="pLN"]').className =
          "input-error-label";
      } else {
        this.hlastnameerrorMessage = false;
        this.lastnameerrorMessagevalid = false;
        hcpLastNameField.className = "textInput";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="pLN"]').className =
          "input-label";
      }
      this.hcpLastName =
        event.target.value.charAt(0).toUpperCase() +
        event.target.value.slice(1);
    }
  }
  handleHcpAccNameChange(event) {
    this.hcpAccName = event.target.value;
    // Double quotes can't be avoided since it's invoked from CSS
    const hcpAddressLineField = this.template.querySelector(
      'lightning-textarea[data-field="pAddressLine"]'
    );
    if (this.hcpAccName === "") {
      this.haddresslineerrorMessage = true;
      this.accordionStatusclose = true;
      this.hideuparrow = "hidearrowforclose";
      hcpAddressLineField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector(
        'label[data-field="pAddressLine"]'
      ).className = "input-error-label";
    } else {
      this.hideuparrow = "hideuparrow";
      this.accordionStatusclose = false;
      this.haddresslineerrorMessage = false;
      hcpAddressLineField.className = "textInput";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector(
        'label[data-field="pAddressLine"]'
      ).className = "input-label";
    }
  }
  handleHcpPhoneChange(event) {
    this.hcpPhone = event.target.value;
    // Double quotes can't be avoided since it's invoked from CSS
    const hcpPhoneNumberField = this.template.querySelector(
      'lightning-input[data-field="pPhone"]'
    );

    if (!/^\+?[0-9]+$/.test(this.hcpPhone)) {
      this.hphonenumbererrorMessage = false;
      this.PhoneerrorMessagevalid = true;
      hcpPhoneNumberField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="pPhone"]').className =
        "input-error-label";
    } else {
      this.PhoneerrorMessagevalid = false;
      hcpPhoneNumberField.className = "textInput";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="pPhone"]').className =
        "input-label";
      if (this.hcpPhone === "") {
        this.hphonenumbererrorMessage = true;
        this.PhoneerrorMessagevalid = false;
        hcpPhoneNumberField.className = "textInput";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="pPhone"]').className =
          "input-label";
      } else {
        this.hphonenumbererrorMessage = false;
        this.PhoneerrorMessagevalid = false;
        hcpPhoneNumberField.className = "textInput";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="pPhone"]').className =
          "input-label";
      }
    }
  }
  handleHcpEmailChange(event) {
    this.hcpEmail = event.target.value;
    // Double quotes can't be avoided since it's invoked from CSS
    const hcpEmailField = this.template.querySelector(
      'lightning-input[data-field="pEmail"]'
    );
    if (this.hcpEmail === "") {
      this.accordionStatusclose = true;
      this.hideuparrow = "hidearrowforclose";
      this.hemailerrorMessage = true;
      this.emailError = false;
      hcpEmailField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="pEmail"]').className =
        "input-error-label";
    } else {
      this.hemailerrorMessage = false;
      this.emailError = false;
      hcpEmailField.className = "textInput";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="pEmail"]').className =
        "input-label";
      if (!this.validateEmail(hcpEmailField.value)) {
        this.hemailerrorMessage = false;
        this.emailError = true;
        this.accordionStatusclose = true;
        this.hideuparrow = "hidearrowforclose";
        hcpEmailField.className = "textInput-err";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="pEmail"]').className =
          "input-error-label";
      } else {
        this.hideuparrow = "hideuparrow";
        this.accordionStatusclose = false;
        this.emailError = false;
        this.hemailerrorMessage = false;
        hcpEmailField.className = "textInput";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="pEmail"]').className =
          "input-label";
      }
    }
  }

  async handleCreateHcp() {
    try {
      // Null data is checked and AuraHandledException is thrown from the Apex
      const leadId = await hcpCreate({
        firstName: this.hcpFirstName,
        lastName: this.hcpLastName,
        phone: this.hcpPhone,
        email: this.hcpEmail
      });
      this.selectedValues11 = leadId;
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant);
    }
  }

  handleHcpAccessCode(event) {
    this.accessCode = event.detail.value;
  }

  handleChange(event) {
    this.selectedReferringPractitioner = event.detail.value;
  }

  showModal() {
    this.openModal = true;
  }
  closeModal() {
    this.openModal = false;
  }

  handleChange2() {
    this.showDetailscg2 = !this.showDetailscg2;
  }

  handleChange3() {
    this.showDetailscg3 = !this.showDetailscg3;
  }

  handleChange1(event) {
    if (event.detail.value === yes) {
      this.showDetails1 = true;
    } else {
      this.showDetails1 = false;
    }
  }

  handleChange4() {
    this.showDetailscg4 = !this.showDetailscg4;
  }

  handleChange5() {
    this.showDetailscg5 = !this.showDetailscg5;
  }

  handleChange6() {
    this.showDetailscg6 = !this.showDetailscg6;
  }

  handleContactSaveSuccess() {
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Enrollment Completed",
        message: "You have successfully enrolled in Patient Support Program!",
        variant: "success"
      })
    );
  }

  handleNavigation() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        name: "thankyou__c"
      }
    });
  }

  showToasts(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }

  showError(message) {
    const errorMessage = {
      title: "Error",
      message: message,
      variant: "error"
    };
    this.dispatchEvent(new CustomEvent(showToast, { detail: errorMessage }));
  }

  patientvalidateForm() {
    // Add your validation logic here for each required field
    let isValid = true;

    // First Name
    // Double quotes can't be avoided since it's invoked from CSS for the following
    const firstNameField = this.template.querySelector(
      'lightning-input[data-field="FN"]'
    );
    const lastNameField = this.template.querySelector(
      'lightning-input[data-field="LN"]'
    );
    const dobField = this.template.querySelector(
      'lightning-input[data-field="dob"]'
    );
    const genderField = this.template.querySelector(
      'lightning-combobox[data-field="gender"]'
    );
    const emailField = this.template.querySelector(
      'lightning-input[data-field="email"]'
    );

    if (!firstNameField.value) {
      this.firstnameerrorMessage = true;
      this.firstnameerrorMessagevalid = false;
      firstNameField.className = "textInput-err";
      this.template.querySelector('label[data-field="FN"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.firstnameerrorMessage = false;
      if (!/^[a-zA-Z]+$/.test(firstNameField.value)) {
        this.firstnameerrorMessagevalid = true;
        this.firstnameerrorMessage = false;
        firstNameField.className = "textInput-err";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="FN"]').className =
          "input-error-label";
        isValid = false;
      } else {
        this.firstnameerrorMessage = false;
        this.firstnameerrorMessagevalid = false;
        firstNameField.className = "textInput";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="FN"]').className =
          "input-label";
      }
    }

    // Last Name
    if (!lastNameField.value) {
      this.lastnameerrorMessage = true;
      this.lastnameerrorMessagevalid = false;
      lastNameField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="LN"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.lastnameerrorMessage = false;
      if (!/^[a-zA-Z]+$/.test(lastNameField.value)) {
        this.lastnameerrorMessagevalid = true;
        this.lastnameerrorMessage = false;
        lastNameField.className = "textInput-err";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="LN"]').className =
          "input-error-label";
        isValid = false;
      } else {
        this.lastnameerrorMessage = false;
        this.lastnameerrorMessagevalid = false;
        lastNameField.className = "textInput";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="LN"]').className =
          "input-label";
      }
    }

    // Date of Birth
    if (!dobField.value) {
      this.doberrorMessage = true;
      dobField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="dob"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.doberrorMessage = false;
      dobField.className = "textInput";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="dob"]').className =
        "input-label";
    }

    // Gender
    if (!genderField.value) {
      this.gendererrorMessage = true;
      genderField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="gender"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.gendererrorMessage = false;
      genderField.className = "textInput";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="gender"]').className =
        "input-label";
    }

    // Email
    if (!emailField.value) {
      isValid = false;
      this.emailerrorMessage = true;
      this.emailError = false;
      emailField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="email"]').className =
        "input-error-label";
    } else {
      if (!this.validateEmail(emailField.value)) {
        this.emailerrorMessage = false;
        this.emailError = true;
        isValid = false;
        emailField.className = "textInput-err";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="email"]').className =
          "input-error-label";
      } else {
        this.emailError = false;
        this.emailerrorMessage = false;
        emailField.className = "textInput";
        // Double quotes can't be avoided since it's invoked from CSS
        this.template.querySelector('label[data-field="email"]').className =
          "input-label";
      }
    }
    return isValid;
  }

  physicianvalidateForm() {
    let isValid = true;
    if (this.accordionStatus) {
      
      const hcpFirstNameField = this.template.querySelector(
        'lightning-input[data-field="pFN"]'
      );
      const hcpLastNameField = this.template.querySelector(
        'lightning-input[data-field="pLN"]'
      );
      const hcpPhoneNumberField = this.template.querySelector(
        'lightning-input[data-field="pPhone"]'
      );
      const hcpEmailField = this.template.querySelector(
        'lightning-input[data-field="pEmail"]'
      );
      const hcpAddressLineField = this.template.querySelector(
        'lightning-textarea[data-field="pAddressLine"]'
      );

      if (!hcpFirstNameField.value) {
        this.accordionStatusclose = true;
        this.DoAccessHcp = true;
        this.DoAccess = false;
        this.hideuparrow = " hidearrowforclose";
        this.hfirstnameerrorMessage = true;
        hcpFirstNameField.className = "textInput-err";
        this.template.querySelector('label[data-field="pFN"]').className =
          "input-error-label";
        isValid = false;
      } else {
        this.hideuparrow = "hideuparrow";
        this.accordionStatusclose = false;
        this.DoAccessHcp = false;
        this.DoAccess = true;
        this.hfirstnameerrorMessage = false;
        hcpFirstNameField.className = "textInput";
        this.template.querySelector('label[data-field="pFN"]').className =
          "input-label";
      }

      if (!hcpLastNameField.value) {
        this.accordionStatusclose = true;
        this.hideuparrow = " hidearrowforclose";
        this.hlastnameerrorMessage = true;
        this.lastnameerrorMessagevalid = false;
        hcpLastNameField.className = "textInput-err";
        this.template.querySelector('label[data-field="pLN"]').className =
          "input-error-label";
        isValid = false;
      } else {
        this.hideuparrow = "hideuparrow";
        this.accordionStatusclose = false;
        this.hlastnameerrorMessage = false;

        hcpLastNameField.className = "textInput";
        this.template.querySelector('label[data-field="pLN"]').className =
          "input-label";
      }

      if (!hcpPhoneNumberField.value) {
        this.accordionStatusclose = true;
        this.hideuparrow = " hidearrowforclose";
        this.hphonenumbererrorMessage = true;
        this.PhoneerrorMessagevalid = false;
        hcpPhoneNumberField.className = "textInput-err";
        this.template.querySelector('label[data-field="pPhone"]').className =
          "input-error-label";
        isValid = false;
      } else {
        this.hideuparrow = "hideuparrow";
        this.accordionStatusclose = false;
        this.hphonenumbererrorMessage = false;
        this.PhoneerrorMessagevalid = false;
        hcpPhoneNumberField.className = "textInput";
        this.template.querySelector('label[data-field="pPhone"]').className =
          "input-label";
      }

      if (!hcpEmailField.value) {
        this.accordionStatusclose = true;
        this.hideuparrow = " hidearrowforclose";
        isValid = false;
        this.hemailerrorMessage = true;
        this.emailError = false;
        hcpEmailField.className = "textInput-err";
        this.template.querySelector('label[data-field="pEmail"]').className =
          "input-error-label";
      } else {
        if (!this.validateEmail(hcpEmailField.value)) {
          this.hemailerrorMessage = false;
          this.emailError = true;
          this.accordionStatusclose = true;
          this.hideuparrow = " hidearrowforclose";
          isValid = false;
          hcpEmailField.className = "textInput-err";
          this.template.querySelector('label[data-field="email"]').className =
            "input-error-label";
        } else {
          this.hideuparrow = "hideuparrow";
          this.accordionStatusclose = false;
          this.emailError = false;
          this.hemailerrorMessage = false;
          hcpEmailField.className = "textInput";
          this.template.querySelector('label[data-field="pEmail"]').className =
            "input-label";
        }
      }

      if (!hcpAddressLineField.value) {
        this.haddresslineerrorMessage = true;
        this.accordionStatusclose = true;
        this.hideuparrow = " hidearrowforclose";
        hcpAddressLineField.className = "textInput-err";
        this.template.querySelector(
          'label[data-field="pAddressLine"]'
        ).className = "input-error-label";
        isValid = false;
      } else {
        this.hideuparrow = "hideuparrow";
        this.accordionStatusclose = false;
        this.haddresslineerrorMessage = false;
        hcpAddressLineField.className = "textInput";
        this.template.querySelector(
          'label[data-field="pAddressLine"]'
        ).className = "input-label";
      }
      
    } 
    else {
      const PhysicianField = this.template.querySelector(
        'lightning-input[data-field="physician"]'
      );
      const hcpAccessCodeField = this.template.querySelector(
        'lightning-input[data-field="hcpaccesscode"]'
      );
   

      if (!this.showAccessCode && !this.showReferringPractitioner) {
         // This window alert is used to display the toast message.
        window.alert(requiredMsg);
        isValid = false;
      }

      if (this.showAccessCode) {
        if (!hcpAccessCodeField.value) {
          this.accessCodeErrorMessage = true;
          hcpAccessCodeField.className = "textInput-err";
          isValid = false;
        } else {
          this.accessCodeErrorMessage = false;
          hcpAccessCodeField.className = "textInput";
        }
      }

      if (this.showReferringPractitioner) {
        if (!PhysicianField.value || this.searchresultempty1 === true) {
          this.physicianrequireMessage = true;
          this.physicianerrorMessage = false;
          this.hidesearchicon = false;
          PhysicianField.className = "textInput-err";
          this.template.querySelector(
            'label[data-field="physician"]'
          ).className = "input-error-label1";
          isValid = false;
        } else {
          this.physicianrequireMessage = false;
          this.physicianerrorMessage = false;
          PhysicianField.className = "textInput";
          this.template.querySelector(
            'label[data-field="physician"]'
          ).className = "input-label";
        }
      }
     
    }
    return isValid;
  }

  carevalidateForm() {
    // Add your validation logic here for each required field
    let isValid = true;

    // First Name
    const firstNameField = this.template.querySelector(
      'lightning-input-field[data-field="CFN"]'
    );
    if (!firstNameField.value) {
      this.carefirstnameerrorMessage = true;
      isValid = false;
    } else {
      this.carefirstnameerrorMessage = false;
    }

    // Last Name
    // Double quotes can't be avoided since it's invoked from CSS
    const lastNameField = this.template.querySelector(
      'lightning-input-field[data-field="CLN"]'
    );
    if (!lastNameField.value) {
      this.carelastnameerrorMessage = true;
      isValid = false;
    } else {
      this.carelastnameerrorMessage = false;
    }

    // Date of Birth
    // Double quotes can't be avoided since it's invoked from CSS
    const dobField = this.template.querySelector(
      'lightning-input-field[data-field="dob"]'
    );
    if (!dobField.value) {
      this.caredoberrorMessage = true;
      dobField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="dob"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.caredoberrorMessage = false;
      dobField.className = "textInput";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="dob"]').className =
        "input-label";
    }

    // Email
    // Double quotes can't be avoided since it's invoked from CSS
    const emailField = this.template.querySelector(
      'lightning-input-field[data-field="Cemail"]'
    );
    if (!emailField.value) {
      this.careemailerrorMessage = true;
      isValid = false;
    } else {
      this.careemailerrorMessage = false;
    }
    return isValid;
  }

  accordionBodyChange() {
    this.physicianrequireMessage = false;
    this.accordionStatus = !this.accordionStatus;
    if (this.accordionStatus === false) {
      this.DoAccessHcp = false;
      this.DoAccess = true;
      this.hidesearchicon = true;
      this.hideuparrow = "hideuparrow";
      this.accordionStatusclose = false;
      this.physicianvalidateFormerrorclear();
    } else {
      // Double quotes can't be avoided since it's invoked from CSS
      const PhysicianField = this.template.querySelector(
        'lightning-input[data-field="physician"]'
      );
      this.hidesearchicon = false;
      this.hideuparrow = "hideuparrow";
      this.physicianerrorMessage = false;
      PhysicianField.className = "textInput";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="physician"]').className =
        "input-label";
    }
  }
  physicianvalidateFormerrorclear() {
    // Double quotes can't be avoided since it's invoked from CSS for the following

    const hcpFirstNameField = this.template.querySelector(
      'lightning-input[data-field="pFN"]'
    );
    const hcpLastNameField = this.template.querySelector(
      'lightning-input[data-field="pLN"]'
    );
    const hcpPhoneNumberField = this.template.querySelector(
      'lightning-input[data-field="pPhone"]'
    );
    const hcpEmailField = this.template.querySelector(
      'lightning-input[data-field="pEmail"]'
    );
    const hcpAddressLineField = this.template.querySelector(
      'lightning-textarea[data-field="pAddressLine"]'
    );

    this.hfirstnameerrorMessage = false;
    hcpFirstNameField.className = "textInput";
    // Double quotes can't be avoided since it's invoked from CSS
    this.template.querySelector('label[data-field="pFN"]').className =
      "input-label";

    this.hlastnameerrorMessage = false;
    hcpLastNameField.className = "textInput";
    // Double quotes can't be avoided since it's invoked from CSS
    this.template.querySelector('label[data-field="pLN"]').className =
      "input-label";

    this.hphonenumbererrorMessage = false;
    hcpPhoneNumberField.className = "textInput";
    // Double quotes can't be avoided since it's invoked from CSS
    this.template.querySelector('label[data-field="pPhone"]').className =
      "input-label";

    this.emailError = false;
    this.hemailerrorMessage = false;
    hcpEmailField.className = "textInput";
    // Double quotes can't be avoided since it's invoked from CSS
    this.template.querySelector('label[data-field="pEmail"]').className =
      "input-label";

    this.haddresslineerrorMessage = false;
    hcpAddressLineField.className = "textInput";
    // Double quotes can't be avoided since it's invoked from CSS
    this.template.querySelector('label[data-field="pAddressLine"]').className =
      "input-label";
  }
  handleAccessCodeChange(event) {
    //To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
    //To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
    const selectedValue = event.target.value;
    if (selectedValue === yes) {
      this.showAccessCode = true;
      this.DoAccess = true;
      this.DoAccessHcp = false;
      this.accordionStatus = false;
      this.showReferringPractitioner = false;
      this.showinfoquestion = false;

      const avatarContent = this.template.querySelector("div.avatar-content");

      avatarContent.innerHTML = `Please provide us with your access code (you'll find it in your patient welcome kit) for us to find your physician details. If you do not have an access code, click 'no' and add your physician details on the next screen.`;
      this.handleClose();
      this.mobileview = `Please provide us with your access code (you'll find it in your...`;
      this.mobileviewsub = `Please provide us with your access code (you'll find it in your patient welcome kit) for us to find your physician details. If you do not have an access code, click 'no' and add your physician details on the next screen.`;
    } else {
      this.showAccessCode = false;
      this.showReferringPractitioner = true;
      this.showinfoquestion = true;
      //To achieve the mobile responsiveness, the following strings are hard coded. Custom Labels can't be used, since they truncate the strings.
      //To achieve mobile responsiveness, we are using innerHTML. However, when attempting to use textContent, it does not meet the design requirements
      const avatarContent = this.template.querySelector("div.avatar-content");
      avatarContent.innerHTML = `You can search for your physician details in our records.
			<br>
			If you are unable to locate them, click Add Physician Information to continue.`;
      this.handleClose();
      this.mobileview = `You can search for your physician details in our records.....`;
      this.mobileviewsub = `Please provide your contact details on this page`;
    }
  }

  handleCommunicationMethodChange(event) {
    const selectedValue = event.detail.value;
    this.PreferredMethodofCommunication = selectedValue;
    if (selectedValue === phone || selectedValue === sms) {
      this.showContactNumber = true;
    } else {
      this.showContactNumber = false;
    }
  }

  openPopUp() {
    this.popupClass = "popup-visible";
  }

  HCPSubmit() {
    // Double quotes can't be avoided since it's invoked from CSS
    let regForm = this.template.querySelector(
      'lightning-record-edit-form[data-id="regForm"]'
    );
    regForm.submit();
    this.popupClass = "popup-hidden";
    this.dispatchEvent(
      new ShowToastEvent({
        title: "New Practitioner Submitted",
        message: "You have successfully Submitted!",
        variant: "success"
      })
    );
  }

  Cancel() {
    this.popupClass = "popup-hidden";
  }

  agecalculationEvent(event) {
    const dobDate = new Date(event.target.value);
    const today = new Date();
    const age = today.getFullYear() - dobDate.getFullYear();

    // Check if the individual is under 18 years old
    this.minor = age < 18;

    // Check if the selected date is in the future
    if (dobDate > today) {
      // Display the validation message
      const errorMessage = doberror;
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('[data-field="dob-error"]').textContent =
        errorMessage;

      // Clear the input field or take other appropriate actions as needed
      event.target.value = "";

      // You can also prevent the form from submitting if needed
      event.preventDefault();
    } else {
      // Clear the validation message if the date is valid
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('[data-field="dob-error"]').textContent = "";
      if (age < 18) {
        this.patientorcaregiver = this.caregiver;
        this.consentName = this.consentNameCaregiver;
      } else {
        this.patientorcaregiver = this.patient;
        this.consentName = this.consentNamePatient;
      }
    }
  }

  handleLeadIdChange(event) {
    this.leadId = event.target.value;
  }

  updateBtn() {
    if (this.careId != null) {
      this.showUpdateForm = false;
      this.showInsertForm = true;
    } else {
      // Handle error
      this.showInsertForm = false;
      this.showUpdateForm = true;
    }
  }

  handleButtonClick() {
    try {
      getEnrolleeCaregiverId({ firstName: this.firstName })
        // Null data is checked and AuraHandledException is thrown from the Apex
        .then((result) => {
          this.recordId = result;
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant);
        });
    } catch (err) {
      this.showToast(errormessage, err.message, errorvariant);
    }
  }

  search(event) {
    const input = event.detail.value.toLowerCase();
    const result = this.picklistOrdered.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResults = result;
  }
  search1(event) {
    this.hidesearchicon = false;
    this.selectedSearchResult1 = "";
    this.selectedValueOne = event.detail.value;
    const input = event.detail.value.toLowerCase();
    if (input === "") {
      this.isSearch1Cleared = true;
      this.physicianrequireMessage = false;
      this.physicianerrorMessage = true;
      this.addNewHCPSectionClass = "addNewHcpSection";
      this.hidesearchicon = true;
    } else if (input) {
      this.physicianrequireMessage = false;
      this.physicianerrorMessage = false;
    }
    this.searchResults1 = this.picklistOrdered1.filter((picklistOption1) =>
      picklistOption1.label.toLowerCase().includes(input)
    );
    const searchedResult1 = this.picklistOrdered1.filter((picklistOption1) =>
      picklistOption1.label.toLowerCase().includes(input)
    );
    this.searchresultempty1 = searchedResult1.length === 0 ? true : false;
  }
  //this Settimeout is used for searching the physician name combo box to reset searchResults1 varaiable to null
  handleOnBlur1() {
    setTimeout(() => {
      try {
        if (this.isSearch1Cleared === false) {
          this.searchResults1 = null;
        }
      } catch (error) {
        this.showToast(errormessage, error.message, errorvariant); //Catching Potential Error
      }
    }, 300);
    this.isSearch1Cleared = false;
  }

  selectSearchResult(event) {
    const selectedValue = event.currentTarget.dataset.value;
    this.selectedSearchResult = this.picklistOrdered.find(
      (picklistOption) => picklistOption.value === selectedValue
    );
    const messageEvent = new CustomEvent("change", {
      detail: {
        selectedValue: this.selectedValue
      }
    });
    this.dispatchEvent(messageEvent);
    this.clearSearchResults();
  }
  selectSearchResult1(event) {
    this.hidesearchicon = false;
    const selectedValueOne = event.currentTarget.dataset.value;
    this.selectedValues11 = event.currentTarget.dataset.value;

    this.selectedSearchResult1 = this.picklistOrdered1.find(
      (picklistOption1) => picklistOption1.value === selectedValueOne
    );
    const messageEvent = new CustomEvent("changes", {
      detail: {
        selectedValueOne: selectedValueOne
      }
    });
    this.addNewHCPSectionClass = "addNewHcpSection-disable";
    this.dispatchEvent(messageEvent);
    this.clearSearchResults1();
  }
  clearSearchResults() {
    this.searchResults = null;
  }
  clearSearchResults1() {
    this.searchResults1 = null;
  }
  showPicklistOptions() {
    if (!this.searchResults) {
      this.searchResults = this.picklistOrdered;
    }
  }
  showPicklistOptions1() {
    if (!this.searchResults1) {
      this.searchResults1 = this.picklistOrdered1;
    }
  }

  careagecalculation(event) {
    const selectedDate = event.target.value;
    this.careDob = selectedDate;
    const currentDate = new Date();
    const careselectedDateObj = new Date(selectedDate);
    if (careselectedDateObj > currentDate) {
      this.errors = true;
      this.isAdult = false;
    } else {
      this.errors = false;
      const age = currentDate.getFullYear() - careselectedDateObj.getFullYear();
      if (age < 18) {
        this.minorerror = true;
      } else {
        this.minorerror = false;
      }
    }
  }

  ContactvalidateForm() {
    // Add your validation logic here for each required field
    // Double quotes can't be avoided since it's invoked from CSS
    let isValid = true;

    // Mode of Communication
    const mocField = this.template.querySelector(
      'lightning-combobox[data-field="conPmc"]'
    );
    if (!mocField.value) {
      this.conPmcErrorMessage = true;
      mocField.className = "textInput-err";
      this.template.querySelector('label[data-field="conPmc"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.conPmcErrorMessage = false;
      mocField.className = "textInput";
      this.template.querySelector('label[data-field="conPmc"]').className =
        "input-label";
    }

    // Country
    const countryField = this.template.querySelector(
      'lightning-combobox[data-field="conCountry"]'
    );
    if (!countryField.value) {
      this.conCountryErrorMessage = true;
      countryField.className = "textInput-err";
      this.template.querySelector('label[data-field="conCountry"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.conCountryErrorMessage = false;
      countryField.className = "textInput";
      this.template.querySelector('label[data-field="conCountry"]').className =
        "input-label";
    }

    // State
    const stateField = this.template.querySelector(
      'lightning-combobox[data-field="conState"]'
    );
    if (!stateField.value) {
      this.conStateErrorMessage = true;
      stateField.className = "textInput-err";
      this.template.querySelector('label[data-field="conState"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.conStateErrorMessage = false;
      stateField.className = "textInput";
      this.template.querySelector('label[data-field="conState"]').className =
        "input-label";
    }

    // City
    const cityField = this.template.querySelector(
      'lightning-input[data-field="conCity"]'
    );

    if (!cityField.value) {
      this.conCityErrorMessage = true;
      this.RPcityerrorMessagevalid = false;
      cityField.className = "textInput-err";
      this.template.querySelector('label[data-field="conCity"]').className =
        "input-error-label";
      isValid = false;
    } else if (!/^[a-zA-Z\s]+$/.test(this.city)) {
      this.conCityErrorMessage = false;
      this.RPcityerrorMessagevalid = true;
      cityField.className = "textInput-err";
      this.template.querySelector('label[data-field="conCity"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.conCityErrorMessage = false;
      this.RPcityerrorMessagevalid = false;
      cityField.className = "textInput";
      this.template.querySelector('label[data-field="conCity"]').className =
        "input-label";
    }

    // Street
    const streetField = this.template.querySelector(
      'lightning-textarea[data-field="conStreet"]'
    );
    if (!streetField.value) {
      this.conStreetErrorMessage = true;
      streetField.className = "textInput-err";
      this.template.querySelector('label[data-field="conStreet"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.conStreetErrorMessage = false;
      streetField.className = "textInput";
      this.template.querySelector('label[data-field="conStreet"]').className =
        "input-label";
    }
    // ZipCode
    const zipCode = this.template.querySelector(
      'lightning-input[data-field="conZipCode"]'
    );
    this.ZiperrorMessagevalid = false;
    if (!zipCode.value) {
      this.conZipCodeErrorMessage = true;
      this.ZiperrorMessagevalid = false;
      zipCode.className = "textInput-err";
      this.template.querySelector('label[data-field="conZipCode"]').className =
        "input-error-label";
      isValid = false;
    } else {
      this.conZipCodeErrorMessage = false;
      this.ZiperrorMessagevalid = false;
      zipCode.className = "textInput";
      this.template.querySelector('label[data-field="conZipCode"]').className =
        "input-label";
    }
    //checkbox

    if (!this.checbox) {
      this.checkboxrequired = true;
      isValid = false;
    } else {
      this.checkboxrequired = false;
    }

    if (this.phoneNumberMandatory === true) {
      // Phone
      const phoneField = this.template.querySelector(
        'lightning-input[data-field="conPhoneNumber"]'
      );
      if (!phoneField.value) {
        this.conPhoneErrorMessage = true;
        this.PhoneerrorMessagevalid = false;
        phoneField.className = "textInput-err";
        this.template.querySelector(
          'label[data-field="conPhoneNumber"]'
        ).className = "input-error-label";
        isValid = false;
      } else if (!/^\+?[0-9]+$/.test(this.phone)) {
        this.conPhoneErrorMessage = false;
        this.PhoneerrorMessagevalid = true;
        phoneField.className = "textInput-err";
        this.template.querySelector(
          'label[data-field="conPhoneNumber"]'
        ).className = "input-error-label";
        isValid = false;
      } else {
        this.conPhoneErrorMessage = false;
        phoneField.className = "textInput";
        this.template.querySelector(
          'label[data-field="conPhoneNumber"]'
        ).className = "input-label";
      }
    }

    return isValid;
  }

  handleFirstNameChange(event) {
    const firstNameField = this.template.querySelector(
      'lightning-input[data-field="FN"]'
    );
    this.firstName = event.target.value;
    if (!/^[a-zA-Z]+$/.test(this.firstName)) {
      this.firstnameerrorMessagevalid = true;
      this.firstnameerrorMessage = false;
      firstNameField.className = "textInput-err";
      this.template.querySelector('label[data-field="FN"]').className =
        "input-error-label";
    } else if (this.firstName === "") {
      this.firstnameerrorMessage = true;
      firstNameField.className = "textInput-err";
      this.template.querySelector('label[data-field="FN"]').className =
        "input-error-label";
      this.firstnameerrorMessagevalid = false;
    } else {
      this.firstnameerrorMessagevalid = false;
      this.firstnameerrorMessage = false;
      firstNameField.className = "textInput";
      this.template.querySelector('label[data-field="FN"]').className =
        "input-label";
    }

    this.firstName =
      event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
  }

  handlelastNameChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    const lastNameField = this.template.querySelector(
      'lightning-input[data-field="LN"]'
    );
    this.lastnamelll = event.target.value;
    if (!/^[a-zA-Z]+$/.test(this.lastnamelll)) {
      this.lastnameerrorMessagevalid = true;
      this.lastnameerrorMessage = false;
      lastNameField.className = "textInput-err";
      this.template.querySelector('label[data-field="LN"]').className =
        "input-error-label";
    } else {
      this.lastnameerrorMessagevalid = false;
      this.lastnameerrorMessage = false;
      lastNameField.className = "textInput";
      this.template.querySelector('label[data-field="LN"]').className =
        "input-label";

      if (this.lastnamelll === "") {
        this.lastnameerrorMessage = true;
        this.lastnameerrorMessagevalid = false;
        lastNameField.className = "textInput-err";
        this.template.querySelector('label[data-field="LN"]').className =
          "input-error-label";
      } else {
        this.lastnameerrorMessage = false;
        this.lastnameerrorMessagevalid = false;
        lastNameField.className = "textInput";
        this.template.querySelector('label[data-field="LN"]').className =
          "input-label";
      }
    }
    this.lastnamelll =
      event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1);
  }
  handleGenderChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    const genderField = this.template.querySelector(
      'lightning-combobox[data-field="gender"]'
    );
    this.gender = event.target.value;
    if (this.gender === "") {
      this.gendererrorMessage = true;
      this.lastnameerrorMessagevalid = false;
      genderField.className = "textInput-err";
      this.template.querySelector('label[data-field="gender"]').className =
        "input-error-label";
    } else {
      this.gendererrorMessage = false;
      this.lastnameerrorMessagevalid = false;
      genderField.className = "textInput";
      this.template.querySelector('label[data-field="gender"]').className =
        "input-label";
    }
  }
  handleDobChange(event) {
    this.dob = event.target.value;
    const dobField = this.template.querySelector(
      'lightning-input[data-field="dob"]'
    );
    if (!dobField.value) {
      this.doberrorMessage = true;
      dobField.className = "textInput-err";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="dob"]').className =
        "input-error-label";
    } else {
      this.doberrorMessage = false;
      dobField.className = "textInput";
      // Double quotes can't be avoided since it's invoked from CSS
      this.template.querySelector('label[data-field="dob"]').className =
        "input-label";
    }
    this.validateDate();
  }

  validateDate(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    const dobField = this.template.querySelector(
      'lightning-input[data-field="dob"]'
    );
    // Validate that the date is not in the future
    const currentDate = new Date();
    const selectedDate = new Date(this.dob);
    this.doberrorMessage = false;
    this.oneninezerozeroerrors = false;
    if (selectedDate > currentDate) {
      this.dobErrorMessage = doberror;
      dobField.className = "textInput-err";
      this.template.querySelector('label[data-field="dob"]').className =
        "input-error-label";
      return;
    }
    this.dobErrorMessage = false;

    const selectedDate1 = new Date(event.target.value);
    const year = selectedDate1.getFullYear();
    if (year < 1900) {
      this.oneninezerozeroerrors = true;
      dobField.className = "textInput-err";
      this.template.querySelector('label[data-field="dob"]').className =
        "input-error-label";
    } else {
      this.oneninezerozeroerrors = false;
      dobField.className = "textInput";
      this.template.querySelector('label[data-field="dob"]').className =
        "input-label";
    }
    // Validate that the user is not a minor (you can set a minimum age)
    const minAge = 18;
    const userBirthYear = selectedDate.getFullYear();
    const currentYear = currentDate.getFullYear();

    if (currentYear - userBirthYear < minAge) {
      this.dobErrorMessage = agelessEighteen;
      dobField.className = "textInput-err";
      this.template.querySelector('label[data-field="dob"]').className =
        "input-error-label";

      return;
    }
    // If both validations pass, clear the error message
    this.dobErrorMessage = false;
  }

  handleEmailChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    this.email = event.target.value;
    const emailField = this.template.querySelector(
      'lightning-input[data-field="email"]'
    );
    if (this.email === "") {
      this.emailerrorMessage = true;
      this.emailError = false;
      emailField.className = "textInput-err";
      this.template.querySelector('label[data-field="email"]').className =
        "input-error-label";
    } else {
      this.emailError = false;
      this.emailerrorMessage = false;
      emailField.className = "textInput";
      this.template.querySelector('label[data-field="email"]').className =
        "input-label";
      if (!this.validateEmail(this.email)) {
        this.emailerrorMessage = false;
        this.emailError = true;
        emailField.className = "textInput-err";
        this.template.querySelector('label[data-field="email"]').className =
          "input-error-label";
      } else {
        this.emailError = false;
        this.emailerrorMessage = false;
        emailField.className = "textInput";
        this.template.querySelector('label[data-field="email"]').className =
          "input-label";
      }
    }
  }

  handlePhoneChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    this.phone = event.target.value;
    const phoneField = this.template.querySelector(
      'lightning-input[data-field="conPhoneNumber"]'
    );
    if (this.phone === "") {
      this.conPhoneErrorMessage = true;
      this.PhoneerrorMessagevalid = false;
      phoneField.className = "textInput-err";
      this.template.querySelector(
        'label[data-field="conPhoneNumber"]'
      ).className = "input-error-label";
    } else if (!/^\+?[0-9]+$/.test(this.phone)) {
      this.conPhoneErrorMessage = false;
      this.PhoneerrorMessagevalid = true;
      phoneField.className = "textInput-err";
      this.template.querySelector(
        'label[data-field="conPhoneNumber"]'
      ).className = "input-error-label";
    } else {
      this.conPhoneErrorMessage = false;
      this.PhoneerrorMessagevalid = false;
      phoneField.className = "textInput";
      this.template.querySelector(
        'label[data-field="conPhoneNumber"]'
      ).className = "input-label";
    }
  }

  handlePmcChange(event) {
    this.pmc = event.target.value;
    const mocField = this.template.querySelector(
      'lightning-combobox[data-field="conPmc"]'
    );
    if (this.pmc === sms || this.pmc === phone) {
      this.phoneNumberMandatory = true;
      this.phoneNumberVisible = false;
      this.conPmcErrorMessage = false;
      mocField.className = "textInput";
      this.template.querySelector('label[data-field="conPmc"]').className =
        "input-label";
    } else {
      this.phoneNumberMandatory = false;
      this.phoneNumberVisible = true;
      this.conPmcErrorMessage = true;
      mocField.className = "textInput-err";
      this.template.querySelector('label[data-field="conPmc"]').className =
        "input-error-label";
      if (this.pmc === "") {
        this.conPmcErrorMessage = true;
        mocField.className = "textInput-err";
        this.template.querySelector('label[data-field="conPmc"]').className =
          "input-error-label";
      } else {
        this.conPmcErrorMessage = false;
        mocField.className = "textInput";
        this.template.querySelector('label[data-field="conPmc"]').className =
          "input-label";
      }
    }
  }

  handleCountryChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    this.country = event.target.value;
    const countryField = this.template.querySelector(
      'lightning-combobox[data-field="conCountry"]'
    );
    if (this.country === "") {
      this.conCountryErrorMessage = true;
      countryField.className = "textInput-err";
      this.template.querySelector('label[data-field="conCountry"]').className =
        "input-error-label";
    } else {
      this.conCountryErrorMessage = false;
      countryField.className = "textInput";
      this.template.querySelector('label[data-field="conCountry"]').className =
        "input-label";
    }
  }
  handleStateChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    this.state = event.target.value;
    const stateField = this.template.querySelector(
      'lightning-combobox[data-field="conState"]'
    );
    if (this.state === "") {
      this.conStateErrorMessage = true;
      stateField.className = "textInput-err";
      this.template.querySelector('label[data-field="conState"]').className =
        "input-error-label";
    } else {
      this.conStateErrorMessage = false;
      stateField.className = "textInput";
      this.template.querySelector('label[data-field="conState"]').className =
        "input-label";
    }
  }
  handleCityChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    this.city = event.target.value;
    const cityField = this.template.querySelector(
      'lightning-input[data-field="conCity"]'
    );
    if (this.city === "") {
      this.conCityErrorMessage = true;
      this.RPcityerrorMessagevalid = false;
      cityField.className = "textInput-err";
      this.template.querySelector('label[data-field="conCity"]').className =
        "input-error-label";
    } else {
      this.conCityErrorMessage = false;
      this.RPcityerrorMessagevalid = false;
      cityField.className = "textInput";
      this.template.querySelector('label[data-field="conCity"]').className =
        "input-label";
    }
    if (!/^[a-zA-Z\s]+$/.test(this.city)) {
      this.conCityErrorMessage = false;
      this.RPcityerrorMessagevalid = true;
      cityField.className = "textInput-err";
      this.template.querySelector('label[data-field="conCity"]').className =
        "input-error-label";
    } else {
      this.conCityErrorMessage = false;
      this.RPcityerrorMessagevalid = false;
      cityField.className = "textInput";
      this.template.querySelector('label[data-field="conCity"]').className =
        "input-label";
    }
  }
  handleStreetChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    this.street = event.target.value;
    const streetField = this.template.querySelector(
      'lightning-textarea[data-field="conStreet"]'
    );
    if (this.street === "") {
      this.conStreetErrorMessage = true;
      streetField.className = "textInput-err";
      this.template.querySelector('label[data-field="conStreet"]').className =
        "input-error-label";
    } else {
      this.conStreetErrorMessage = false;
      streetField.className = "textInput";
      this.template.querySelector('label[data-field="conStreet"]').className =
        "input-label";
    }
  }
  handleZipCodeChange(event) {
    // Double quotes can't be avoided since it's invoked from CSS
    this.zipCode = event.target.value;
    const zipCode = this.template.querySelector(
      'lightning-input[data-field="conZipCode"]'
    );

    if (this.zipCode === "") {
      this.conZipCodeErrorMessage = true;
      zipCode.className = "textInput-err";
      this.template.querySelector('label[data-field="conZipCode"]').className =
        "input-error-label";
    } else {
      this.conZipCodeErrorMessage = false;
      zipCode.className = "textInput";
      this.template.querySelector('label[data-field="conZipCode"]').className =
        "input-label";
    }
  }

  handleCreateLead() {
    if (!this.ContactvalidateForm()) {
      return;
    }
    let leadWrapper = {
      firstName: this.firstName,
      lastnamelll: this.lastnamelll,
      dob: this.dob,
      gender: this.gender,
      email: this.email,
      phone: this.phone,
      pmc: this.pmc,
      country: this.country,
      state: this.state,
      city: this.city,
      street: this.street,
      zipCode: this.zipCode,
      selectedPrescription: this.selectedValues11
    };

    try {
      updateLeadPatientRecord({ leadWrapper: leadWrapper })
        // Null data is checked and AuraHandledException is thrown from the Apex
        .then((leadId) => {
          this.leadids = leadId;

          localStorage.setItem("recordId", this.leadids);
          this.isLoaded = true;
          // This setTimeout is used to retrieve the Patient records after a delay.
          setTimeout(() => {
            try {
              window.location.href = psUrl;
            } catch (error) {
              this.showToast(errormessage, error.message, errorvariant); //Catching Potential Error
            }
          }, 1000);
          // Perform any additional actions on success
        })
        .catch((error) => {
          this.error = error;
          // Check if it's a specific Salesforce API error
          if (error.body && error.body.message) {
            this.showToast(errormessage, error.message, errorvariant);
            // Handle specific error cases if needed
          } else {
            this.showToast(errormessage, error.message, errorvariant);
            // Handle other types of errors
          }
        });
    } catch (err) {
      // Handle any unexpected errors
      this.showToast(errormessage, err.message, errorvariant);
    }
  }

  async handleVerify() {
    // Call the Apex method with the provided parameters
    try {
      // Null data is checked and AuraHandledException is thrown from the Apex
      let result = await verifyUnassign({
        firstName: this.firstName,
        lastName: this.lastnamelll
      });
      // Handle the result from the Apex method
      this.uId = result[0].Id;
      this.uFirstName = result[0].Account.FirstName;
      this.uLasrName = result[0].Account.LastName;
      this.uGender = result[0].Account.HealthCloudGA__Gender__pc;
      this.uEmail = result[0].Account.PersonEmail;
      this.userType = result[0].BI_PSPB_PatientStatus__c;
    } catch (err) {
      // Handle errors if needed
      this.showToast(errormessage, err.message, errorvariant);
    }
  }
  goToHome() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        name: "Home"
      }
    });
  }

  openModal1() {
    // Handle your submit logic here

    // Set the isModalOpen to true to show the modal
    this.isModalOpen = true;
  }

  closeModal1() {
    // Set the isModalOpen to false to hide the modal
    this.isModalOpen = false;
  }

  openItchinessModal() {
    this.submitModal = true;
  }
  closeItchinessModal() {
    this.submitModal = false;
  }

  validateEmail(email) {
    return String(email)
      .toLowerCase()
      .match(
        /^(([^<>()[\]\\.,;:\s@']+(\.[^<>()[\]\\.,;:\s@']+)*)|.('.+'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      );
  }

  handleKeyDown(event) {
    const charCode = event.which ? event.which : event.keyCode; // Get the ASCII code of the pressed key
    if (charCode !== 43 && (charCode < 48 || charCode > 57)) {
      // Allow only digits (48-57) and the plus symbol (43)
      event.preventDefault(); // Prevent the character from being entered
    }
  }

  click() {
    this.subvalue = this.mobileview;
    this.mobileview = this.mobileviewsub;
    this.divfalse = false;
    this.FieldBox = true;
  }
  handleClose() {
    this.divfalse = true;
    this.mobileview = this.subvalue;
    this.FieldBox = false;
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