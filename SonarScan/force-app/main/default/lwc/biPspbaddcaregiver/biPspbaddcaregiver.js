// This component is used to create and update caregiver details as well as to check for unique emails
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
//  To import Apex Classes
import updateContactFromCheckbox from '@salesforce/apex/BI_PSPB_exuserGetAccid.updateContactFromCheckbox';
import createCaregiver from '@salesforce/apex/BI_PSPB_leadCreationCtrl.createCaregiverRecord';
import getExistingcaregivertest from '@salesforce/apex/BI_PSPB_leadCreationCtrl.getExistingAccounts';
import getcargiveruserdata from '@salesforce/apex/BI_PSPB_exuserGetAccid.getCaregiverDataView';
import updateCaregivers from '@salesforce/apex/BI_PSPB_exuserGetAccid.updateCaregivers';
import createenroleecargiver from '@salesforce/apex/BI_PSPB_leadCreationCtrl.createEnroleeCargiver';
import grandaccessbutton from '@salesforce/apex/BI_PSPB_exuserGetAccid.grandAccessButton';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
//To import contact fields
import Contact from '@salesforce/schema/Contact';
import COUNTRY_FIELD from '@salesforce/schema/Contact.BI_PSPB_Relationship_To_Patient__c';
// To import Static Resources
import deletetoastimage from '@salesforce/resourceUrl/BI_PSP_Deletetoastmsg';
import Boxedicon from '@salesforce/resourceUrl/BI_PSPB_yellowBox';
// To import Custom Labels
import firstname from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_First_Name';
import lastname from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Last_Name';
import dateofbirth from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Date_of_birth';
import phone from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_phone_number';
import minor from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Date_fo_birth';
import relationship from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Relationship';
import abovedate from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_major_date_of_birth';
import email from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Caregiver_Email';
import date from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Patient_Future_date';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import active from '@salesforce/label/c.BI_PSPB_Active';
import saveChanges from '@salesforce/label/c.BI_PSPB_Save_Changes';
import addCaregiver from '@salesforce/label/c.BI_PSPB_Add_Caregiver';
import SMS from '@salesforce/label/c.BI_PSP_NotificationSMS';
import Caregiver from '@salesforce/label/c.BI_PSPB_userType';
export default class biPspbaddcaregiver extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track FirstName;
	@track LastName;
	@track Email;
	@track MobilePhone;
	@track birth;
	@track uniqueEmail;
	@track relations;
	@track dobdate;
	@track uniqueFName;
	@track uniqueLname;
	@track uniqueDOB;
	@track uniqueusertype;
	@track newEmail = '';
	@track isEmailReadOnly = false;
	@track nonupdate;
	@track emailerrorMessage = false;
	@track mobileerrorMessage = false;
	@track relationshiperrorMessage = false;
	@track FirstNameerrorMessage = false;
	@track doberrorMessage = false;
	@track showContactNumber = false;
	@track savebutton = '';
	@track grandbutton;
	@track grantlabel = 'toggle-label';
	@track slider;
	@track showPrompt = false;
	@track errorMessage = '';
	@track relation;
	@track caregiverIds = '';
	@track minorerror; // Initialize to false
	@track minorerror2;
	@track minorerror3;
	@track error = false;
	@track dateOfBirth;
	@track age;
	@track dobErrorMessage = false;
	@track showdiv = false;
	@track updatepopup = false;
	// Declaration of Global variables
	Boxedicon = Boxedicon;
	label = {
		firstname, minor, abovedate,
		lastname, date, deletetoastimage,
		dateofbirth, relationship, phone, email
	};
	date = false;
	rightimg = deletetoastimage;
	userId = Id;
	accname;
	AccountId;
	recordTypeId;
	checkemail =false;
	cuurentemail;
	dob;
	enrolleeids;
	grantAccessDisabled = '';

	// wire to Check if grand access toggle is true or false
	@wire(grandaccessbutton)
	wiredGrantAccess({ error, data }) {
		try {
			//Null data is checked and AuraHandledException is thrown from the Apex
			if (data) {
				if (data[0].BI_PSPB_Status__c === active) {
					this.slider = true;
					this.showPrompt = true;

				} else {
					// If false, disable the checkbox
					this.slider = false;
					this.showPrompt = false;

				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);//Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //catching potential error from LWC

		}


	}




	handleclose() {
		this.showDiv = false;
		this.showdiv1 = false;
		this.updatepopup = false;
	}


	//to retrieve and prepopulate caregiver information 
	@wire(getcargiveruserdata)
	wiredUserCaregivers({ data, error }) {
		try {
			//null data is checked and Aurahandled exception is thrown from Apex
			if (data) {
				this.caregiverList = data;

				if (this.caregiverList.length > 0) {
					this.caregiverIds = this.caregiverList[0].BI_PSPB_Contact_Id__r.Id;
					this.FirstName = this.caregiverList[0].BI_PSPB_Contact_Id__r.FirstName;
					this.LastName = this.caregiverList[0].BI_PSPB_Contact_Id__r.LastName;
					this.MobilePhone = this.caregiverList[0].BI_PSPB_Contact_Id__r.Phone;
					this.Email = this.caregiverList[0].BI_PSPB_Contact_Id__r.Email;
					this.relations = this.caregiverList[0].BI_PSPB_Contact_Id__r.BI_PSPB_Relationship_To_Patient__c;
					this.dobdate = this.caregiverList[0].BI_PSPB_Contact_Id__r.BI_PSPB_Birthdate__c;
					this.savebutton = saveChanges;
					if (this.Email !== '') {
						this.isEmailReadOnly = true; // Set the email field as read-only

					}
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); //catching potential error from Apex
			}
			else {
				this.savebutton = addCaregiver; //this happens if there is no data
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //catching potential error from LWC
		}

	}

	@wire(getObjectInfo, { objectApiName: Contact })
	objectInfo;
	//wire to retrieve the relationship picklist values
	@wire(getPicklistValues,
		{
			recordTypeId: '$objectInfo.data.defaultRecordTypeId',
			fieldApiName: COUNTRY_FIELD


		}
	)
	RelationshipValues({ data, error }) {
		try {
			if (data) {
				this.relation = data.values;

			} else if (error) {
				this.relation = undefined;
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //catching potential error from LWC
		}


	}

	patientvalidateForm() {
		let isValid = true;
		return isValid;
	}

	//to validate preferred communication method
	handleCommunicationMethodChange(event) {
		const PSP_BR_PreferredMethodofCommunication = event.detail.value;
		this.PSP_BR_Preferred_Method_of_Communication = PSP_BR_PreferredMethodofCommunication;
		if (PSP_BR_PreferredMethodofCommunication === SMS) {
			this.showContactNumber = true;
		} else {
			this.showContactNumber = false;
		}
	}

	//firstname lastname regex
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



	//validate firstname field
	firstnamevalueget(event) {
		this.FirstName = event.target.value;
		this.FirstNameerrorMessage = false;
		//to get data field value from html
		this.template.querySelector('lightning-input[data-field="FirstName"]').className = "input-label";
		this.template.querySelector('label[data-field="FirstName"]').className = "input-label";


	}
	//validate lastname field
	Lastnamevalueget(event) {
		this.LastName = event.target.value;
		this.LastNameerrorMessage = false;
		this.template.querySelector('lightning-input[data-field="LastName"]').className = "input-label";
		this.template.querySelector('label[data-field="LastName"]').className = "input-label";

	}
	//validate age field
	agecalculationEvent(event) {
		this.dobdate = event.target.value;
		this.validateDate();
		this.doberrorMessage = false;

	}

	// Validate that the date is not in the future
	validateDate() {
		const currentDate = new Date();
		const selectedDate = new Date(this.dobdate);

		if (selectedDate > currentDate) {
			this.dobErrorMessage = date;
			this.applyErrorStyles();
			return;
		}

		// Validate that the user is not a minor (you can set a minimum age)
		const minAge = 18;
		const userBirthYear = selectedDate.getFullYear();
		const currentYear = currentDate.getFullYear();

		if (currentYear - userBirthYear < minAge) {
			//   this.dobErrorMessage = false;
			this.dobErrorMessage = minor;

			this.applyErrorStyles();
			return;
		}
		//get full year
		if (selectedDate < new Date('1900-01-01')) {
			this.dobErrorMessage = abovedate;

			this.applyErrorStyles();
			return;
		}


		// If both validations pass, clear the error message

		this.dobErrorMessage = '';
		this.clearErrorStyles();

	}
	applyErrorStyles() {
		this.template.querySelector('lightning-input[data-field="Birthdate"]').classList.add('textInput-err');
		this.template.querySelector('label[data-field="Birthdate"]').classList.add('input-error-label');
	}

	clearErrorStyles() {
		this.template.querySelector('lightning-input[data-field="Birthdate"]').classList.remove('textInput-err');
		this.template.querySelector('label[data-field="Birthdate"]').classList.remove('input-error-label');
	}

	//validate phone field
	phonenumberEvent(event) {
		this.MobilePhone = event.target.value;
		this.mobileerrorMessage = false;
		this.template.querySelector('lightning-input[data-field="phone"]').className = 'input-label';
		this.template.querySelector('label[data-field="phone"]').className = 'input-label';

	}

	//to validate email
	caremailevent(event) {
		this.Email = event.target.value;
		this.emailerrorMessage = false;
		this.template.querySelector('lightning-input[data-field="email"]').className = 'input-label';
		this.template.querySelector('label[data-field="email"]').className = 'input-label';

	}
	//to validate relationship
	relationshipEvent(event) {
		this.relations = event.target.value;
		this.relationshiperrorMessage = false;
		this.template.querySelector('label[data-field="relationship"]').className = 'input-label';
	}

	//phone regex
	validatePhoneInput(event) {
		const charCode = event.which ? event.which : event.keyCode; // Get the ASCII code of the pressed key
		if (charCode !== 43 && (charCode < 48 || charCode > 57)) { // Allow only digits (48-57) and the plus symbol (43)
			event.preventDefault(); // Prevent the character from being entered
		}
	}


	//-----get current enrollee

	connectedCallback() {
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

					this.showToast(errormessage, error.message, errorvariant); //catching potential error from Apex

				})
		} catch (err) {

			this.showToast(errormessage, err.message, errorvariant); //catching potential error from LWC
		}

	}


	checkemailvalid(event) {

		this.cuurentemail = event.target.value;


	}

	//caregiver information inserted and updated, email validated
	handlesave(event) {

		if (!this.FirstName) {
			this.FirstNameerrorMessage = true;
			this.template.querySelector('lightning-input[data-field="FirstName"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="FirstName"]').className = 'input-error-label';

		}
		if (!this.LastName) {
			this.LastNameerrorMessage = true;
			this.template.querySelector('lightning-input[data-field="LastName"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="LastName"]').className = 'input-error-label';

		}
		if (!this.relations) {
			this.relationshiperrorMessage = true;

			this.template.querySelector('label[data-field="relationship"]').className = 'input-error-label';


		}
		if (!this.dobdate) {
			this.doberrorMessage = true;

			this.template.querySelector('lightning-input[data-field="Birthdate"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="Birthdate"]').className = 'input-error-label';

		}

		if (!this.MobilePhone) {
			this.mobileerrorMessage = true;
			this.template.querySelector('lightning-input[data-field="phone"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="phone"]').className = 'input-error-label';

		}
		if (!this.Email) {

			this.emailerrorMessage = true;
			this.template.querySelector('lightning-input[data-field="email"]').className = 'textInput-err';
			this.template.querySelector('label[data-field="email"]').className = 'input-error-label';


			this.Email = event.target.value;

		}



		if (this.Email) {

			getExistingcaregivertest({ email: this.Email })
				.then(data => {
                  if(data){
					this.uniqueEmail = [];
					this.uniqueFName = [];
					this.uniqueLname = [];
					this.uniqueDOB = [];
					this.uniqueusertype = [];
					// Loop through retrieved data to extract unique values
					for (let record of data) {
						this.uniqueEmail.push(record.PersonEmail);
						this.uniqueFName.push(record.FirstName);
						this.uniqueLname.push(record.LastName);
						this.uniqueDOB.push(record.BI_PSP_Birthdate__c);
						this.uniqueusertype.push({ type: record.BI_PSPB_User_Type__c, email: record.PersonEmail });

					}
					}
					if (this.uniqueFName !== undefined && this.uniqueLname !== undefined && this.uniqueEmail !== undefined && this.uniqueDOB !== undefined && this.uniqueusertype !== undefined) {
						if (this.uniqueFName?.includes(this.FirstName) && this.uniqueLname?.includes(this.LastName) && this.uniqueEmail?.includes(this.Email) && this.uniqueusertype?.some(obj => obj.type === Caregiver && obj.email === this.Email) && this.savebutton !== saveChanges) {



							createenroleecargiver({ patientId: this.enrolleeids, firstName: this.FirstName, email: this.Email })
								.then(() => {
									// this.checkemail = false;
									window.scrollTo({ top: 0, behavior: 'smooth' });
									this.showdiv = true;

								})
								.catch(err => {
									this.showToast(errormessage, err.message, errorvariant); //catching potential error from APex 

								});


						}
					
                       
						else if (this.uniqueEmail.includes(this.Email)&& this.caregiverIds == '' ) {
                        
							this.checkemail = true;


						}
					
					}
					 else {
		

						let addcaregiverDetails = {
							caregiverId: this.enrolleeids, firstName: this.FirstName, lastName: this.LastName, email: this.Email, dob: this.dobdate, relation: this.relations, phone: this.MobilePhone,

						};

						createCaregiver({
							newcaregive: addcaregiverDetails
						})
							.then(() => {
								window.scrollTo({ top: 0, behavior: 'smooth' });
								this.showdiv = true;


							})
							.catch(err => {
								this.showToast(errormessage, err.message, errorvariant); //catching potential error from Apex

							});
					}

				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); //catching potential error from LWC

				});
		}
		

		if (this.caregiverIds !== '') {
			
			this.checkemail = false;
			let addcaregiverDetails = {
				accountId: this.caregiverIds, FirstName: this.FirstName, LastName: this.LastName, PersonEmail: this.Email, PersonBirthdate: this.dobdate, relations: this.relations, phone: this.MobilePhone,

			};

			updateCaregivers({
				caregiverwrapper: addcaregiverDetails
			})
				.then(() => {
					window.scrollTo({ top: 0, behavior: 'smooth' });
					this.updatepopup = true;

				})
				.catch(err => {
					this.showToast(errormessage, err.message, errorvariant); //catching potential error from Apex

				});
		}
		//Settimeout function used to close the spinner automatically few seconds after it displays
		setTimeout(function () {
			try {
				window.location.reload();
			}
			catch (error) {
				this.showToast(errormessage, error.message, errorvariant); //catching potential error from LWC
			}

		}, 3000); // Adjust the duration (in milliseconds) as needed


	}



	handlecontactsuccess(event) {
		this.contact__c = event.detail.id;
	}

	grantaccces() {

		updateContactFromCheckbox({ isChecked: this.slider })
			.then(() => {

			})
			.catch(err => {
				this.showToast(errormessage, err.message, errorvariant); //catching potential error from Apex
			});
	}


	//to make grant access button true
	handleCheckboxChange(event) {
		this.slider = event.target.checked;

		this.grantaccces();
		if (this.slider) {
			this.showPrompt = true;
		} else {
			this.showPrompt = false;
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