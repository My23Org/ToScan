// This LWC is used to create case records for Type - Medical Information Enquiry
// To import Libraries
import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { loadStyle } from 'lightning/platformResourceLoader';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Apex Classes
import insertupdateLeadConsent from '@salesforce/apex/BI_PSPB_supportCaseCreate.createCase';
import updateCase from '@salesforce/apex/BI_PSPB_supportCaseCreate.updateCase';
import caseDraft from '@salesforce/apex/BI_PSPB_supportCaseCreate.caseDraft';
import getCaseRecords from '@salesforce/apex/BI_PSPB_supportCaseCreate.getPSPCaseRecordsMedical';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
// To import Static Resources
import img from '@salesforce/resourceUrl/BI_PSPB_MedicalKit';
import emailimg from '@salesforce/resourceUrl/BI_PSPB_Mail';
import arrow from '@salesforce/resourceUrl/BI_PSPB_BackArrow';
import phnimg from '@salesforce/resourceUrl/BI_PSPB_Phone';
import Warning from '@salesforce/resourceUrl/BI_PSP_WarningIcon';
import caseradiobtn from '@salesforce/resourceUrl/BI_PSPB_UploadfileSupport';
import radiobtncolorchnage from '@salesforce/resourceUrl/BI_PSPB_Radiobtn';
import MY_ICON from '@salesforce/resourceUrl/BI_PSPB_uploadIocn';
import tic from '@salesforce/resourceUrl/BI_PSP_Deletetoastmsg';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import subtypeEroor from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_support_Type';
import descriptionEroor from '@salesforce/label/c.BI_PSPB_ERROR_Message_For_Description';
import descriptionEroor1000characters from '@salesforce/label/c.BI_PSPB_Morethan1000characters';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import supportPageUrl from '@salesforce/label/c.BI_PSPB_BRSupportPage';
import brandedurlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedurlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import Product from '@salesforce/label/c.BI_PSPB_Product_Information';
import Treatment from '@salesforce/label/c.BI_PSPB_Treatment';
import Symptom from '@salesforce/label/c.BI_PSPB_Symptoms';

export default class biPspbSupportCenter extends NavigationMixin(LightningElement) 
{
//Proper naming conventions with camel case for all the variable will be followed in the future releases
// Declaration of variables with @api
@api acceptedFormats = '.jpg,.jpeg,.png,.pdf'; // Set the accepted file formats
@api recordId; // Pass the record ID if applicable
// Declaration of variables with @track
@track back = false;
// to invoke CSS '' are useed
@track class1 = 'buttonbox';  
@track class2 = 'buttonbox';
@track class3 = 'buttonbox';
@track class4 = 'buttonbox';
@track class5 = 'desc';
@track class6 = 'desc';
@track class7 = 'desc';
@track urlq;
@track contact = true;
@track showcollectbutton = true;
@track caseType;
@track selectedOption;
@track userId = Id;
@track accname;
@track showDiv = false;
@track showDiv1 = false;
@track fileIcon = MY_ICON;
@track isFormVisible = false;
@track isFormVisible1 = false;
@track isFormVisible2 = false;
@track isFormVisible3 = false;
@track field1 = '';
@track field2 = '';
@track subtyperror = false;
@track descriptionerror = false;
@track subtyperror1 = false;
@track descriptionerror1 = false;
@track descriptionerror2 = false;
@track files = [];
@track caseRecord;
@track caseMedicalId;
@track medicalSubType;
@track medicalDescription;
@track selectedOptionvalues;
@track description = '';
@track getmedicaldata;
@track descriptionLengthError = false;
@track BandU = true;
@track fileNames;
@track showfileNames = false;
@track radiobtncolorchnage = '';
@track faultvalue = false;
@track filess = [];
@track fileDetails = [];
@track errorMessage;
@track caseSubType;
@track caseDescription;
// Declaration of variables
rightimg = tic;
iconwarning = Warning;
buttonImage = img;
backarrow = arrow;
Phnimg = phnimg;
Emailimg = emailimg;
subType = ''; // Initialize with an empty string
caseRecordId;
checkcaseradibtn = '';
// used in HTML file
label = { subtypeEroor, descriptionEroor, descriptionEroor1000characters };
subTypeOptions = [
{ label: Product, value: Product },
{ label: Treatment, value: Treatment },
{ label: Symptom, value: Symptom }
];

connectedCallback() 
{
try 
{
	loadStyle(this, caseradiobtn);
	loadStyle(this, radiobtncolorchnage);
	getEnrolle({ userId: this.userId })
	.then((result) => 
	{
		if (result != null) 
		{
		if (result[0].patientEnrolle != null) 
		{
			this.accname = result[0].patientEnrolle.Id;
		} 
		else if (result[0].error != null) 
		{
			this.showError = true;
			this.errorMessage = result[0].error;
		}
		}
	})
	// Null data is checked and AuraHandledException is thrown from the Apex
	.catch((error) => {
		this.showToast(errormessage, error.message, errorvariant);
	})
	const currentURL = window.location.href;
	// Create a URL object
	const urlObject = new URL(currentURL);
	// Get the path
	const path = urlObject.pathname;
	// Split the path using '/' as a separator
	const pathComponents = path.split('/');
	// Find the component you need (in this case, 'Branded')
	const desiredComponent = pathComponents.find((component) =>
	[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
		component.toLowerCase()
	)
	);
	if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) 
	{
	this.urlq = brandedurlNavi;
	} 
	else 
	{
	this.urlq = unassignedurlNavi;
	}
} catch (error) {
	this.showToast(errormessage, error.message, errorvariant);
}
}
handleclose() 
{
this.showDiv = false;
this.showDiv1 = false;
}
@wire(getCaseRecords, { accountId: '$accname' })
wiredCaseRecords({ error, data }) 
{
if (data) 
// Null data is checked and AuraHandledException is thrown from the Apex
{
	try 
	{
	this.caseRecord = data[0];
	this.caseMedicalId = data[0].Id;
	this.caseType = data[0].Type;
	this.description1 = data[0].Description;
	this.selectedOptionvalues = data[0].BI_PSPB_Sub_Type__c;
	this.selectedOption = this.selectedOptionvalues;
	this.description = this.description1;
	} catch (err) {
	// Handle any errors that occur within the try block
	this.showToast(errormessage, err.message, errorvariant);
	}
} else if (error) {
	this.showToast(errormessage, error.body.message, errorvariant);
}
}
getmedicalinformation(event) {
this.getmedicaldata = event.target.value;
}
handleRadioChange(event) {
this.selectedOption = event.target.value;
this.subtyperror = false;
this.radiobtncolorchnage = 'chnageradiobtn1'; // invoked in CSS file
}
handledescription(event) {
this.description = event.target.value;
if (this.description) {
	this.descriptionerror = false;
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector("label[data-field='Description']").className =
	'input-error';
	this.class5 = 'desc'; // invoked in CSS file
	this.descriptionLengthError = false;
}
this.descriptionerror = false;
}
handleUploadFinished(event) {
const uploadedFiles = event.detail.files;
this.files = uploadedFiles;
this.fileNames = this.files.map((file) => {
	const maxLength = 24; // Maximum length of displayed filename
	return file.name.length > maxLength
	? file.name.substring(0, maxLength) + '...'
	: file.name;
});
this.showfileNames = true;
this.BandU = false;
}
handleInsertUpdate(event) 
{
this.caseType = event.currentTarget.dataset.value;
const fileIds = this.files.map((file) => file.documentId);
const parameters = {
	accountId: this.accname,
	type: this.caseType,
	subType: this.selectedOption,
	description: this.description
};
if (!this.selectedOption && !this.description) 
{
	this.radiobtncolorchnage = 'chnageradiobtn'; // invoked in CSS file
	this.subtyperror = true;
	this.class5 = 'change'; // invoked in CSS file
	this.descriptionLengthError = false;
	this.descriptionerror = true;
	this.template.querySelector("label[data-field='Description']").className =
	'input-error-label';
	this.faultvalue = true;
}
if (this.selectedOption && !this.description) 
{
	this.class5 = 'change'; // invoked in CSS file
	this.descriptionerror = true;
	this.descriptionLengthError = false;
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector("label[data-field='Description']").className =
	'input-error-label';
	this.faultvalue = true;
}
if (!this.selectedOption && this.description) 
{
	this.radiobtncolorchnage = 'chnageradiobtn'; // invoked in CSS file
	this.subtyperror = true;
	this.class5 = 'desc'; // invoked in CSS file
	this.descriptionerror = false;
	this.faultvalue = true;
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector("label[data-field='Description']").className =
	'input-error';
	const maxLength = 1000;

	if (this.description.length > maxLength) 
	{
	this.descriptionerror = false;
	this.descriptionLengthError = true;
	this.class5 = 'change'; // invoked in CSS file
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector(
		"label[data-field='Description']"
	).className = 'input-error-label';
	this.faultvalue = true;
	}
}
if (this.selectedOption !== undefined && this.description !== '') 
{
	const maxLength = 1000;
	if (this.description.length > maxLength) 
	{
	this.descriptionerror = false;
	this.descriptionLengthError = true;
	this.class5 = 'change';
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector(
		"label[data-field='Description']"
	).className = 'input-error-label';
	this.faultvalue = true;
	} 
	else 
	{
	if (this.caseMedicalId === null) 
	{
		try 
		{
		insertupdateLeadConsent({ wrapper: parameters, fileIds: fileIds });
			this.showDiv = true;
			this.descriptionLengthError = false;
			this.caseType = '';
			this.selectedOption = '';
			this.description = '';
		}
		// Null data is checked and AuraHandledException is thrown from the Apex
		catch(error) 
		{
		this.showToast(errormessage, error.message, errorvariant);
		}
	} 
	else if (this.caseMedicalId != null) 
	{
		try 
		{
		updateCase({
			recId: this.caseMedicalId,
			Type: this.caseType,
			Description: this.description,
			fileIds: fileIds
		});
			this.showDiv = true;
			this.descriptionLengthError = false;
			this.caseType = '';
			this.selectedOption = '';
			this.description = '';
		}
		// Null data is checked and AuraHandledException is thrown from the Apex
		catch(error) 
		{
		this.showToast(errormessage,error.message,errorvariant);
		}     
	}
	}
}
}
handleInsertDraft(event) 
{
this.caseType = event.currentTarget.dataset.value;
const fileIds = this.files.map((file) => file.documentId);
const parameters = {
	accountId: this.accname,
	type: this.caseType,
	subType: this.selectedOption,
	description: this.description
};
if (!this.selectedOption && !this.description) 
{
	this.radiobtncolorchnage = 'chnageradiobtn';  // invoked in CSS file
	this.subtyperror = true;
	this.class5 = 'change'; // invoked in CSS file
	this.descriptionLengthError = false;
	this.descriptionerror = true;
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector("label[data-field='Description']").className =
	'input-error-label'; // invoked in CSS file
	this.faultvalue = true;
}
if (this.selectedOption && !this.description) 
{
	this.class5 = 'change'; // invoked in CSS file
	this.descriptionerror = true;
	this.descriptionLengthError = false;
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector("label[data-field='Description']").className =
	'input-error-label';
	this.faultvalue = true;
}
if (!this.selectedOption && this.description) 
{
	this.radiobtncolorchnage = 'chnageradiobtn'; // invoked in CSS file
	this.subtyperror = true;
	this.class5 = 'desc'; // invoked in CSS file
	this.descriptionerror = false;
	this.faultvalue = true;
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector("label[data-field='Description']").className =
	'input-error';
	const maxLength = 1000;
	if (this.description.length > maxLength) 
	{
	this.descriptionerror = false;
	this.descriptionLengthError = true;
	this.class5 = 'change'; // invoked in CSS file
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector(
		"label[data-field='Description']"
	).className = 'input-error-label';
	this.faultvalue = true;
	}
}
if (this.selectedOption !== undefined && this.description !== '') 
{
	const maxLength = 1000;
	if (this.description.length > maxLength) 
	{
	this.descriptionerror = false;
	this.descriptionLengthError = true;
	this.class5 = 'change';
	// Double quotes can't be avoided since it's invoked from CSS
	this.template.querySelector(
		"label[data-field='Description']"
	).className = 'input-error-label';
	} 
	else 
	{
	try 
	{
		caseDraft({ wrapper: parameters, fileIds: fileIds });
		this.showDiv1 = true;
		this.errorMessage = '';
		this.class5 = 'desc';
		this.descriptionLengthError = false;
	}
	// Null data is checked and AuraHandledException is thrown from the Apex
	catch(error) 
	{
		this.showToast(errormessage, error.message, errorvariant);
	}
	} 
}
}

handleBack() {
window.location.assign(this.urlq + supportPageUrl);
}
}