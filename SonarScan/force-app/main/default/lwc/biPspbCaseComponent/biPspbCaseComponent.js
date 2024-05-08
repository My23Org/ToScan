// This Lightning Web Component in Salesforce manages case records, enables filtering and view case details.
// To import Library files
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
// To import Apex Classes
import getCases from '@salesforce/apex/BI_PSPB_CaseSupport.getCases';
import getCaseDetails from '@salesforce/apex/BI_PSPB_CaseSupport.caserecord';
import getCaseImageURL from '@salesforce/apex/BI_PSPB_CaseSupport.getBase64Image';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
// To import current user id
import Id from '@salesforce/user/Id';
// To import Static Resources
import draft from '@salesforce/resourceUrl/BI_PSPB_Draft';
import sldsclass from '@salesforce/resourceUrl/BI_PSPB_SldsClassCC';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import lableCaseNumber from '@salesforce/label/c.BI_PSPBCaseNumber';
import lableSubject from '@salesforce/label/c.BI_PSPB_Subject';
import lableStatus from '@salesforce/label/c.BI_PSPB_Status';
import lablePriority from '@salesforce/label/c.BI_PSPB_Priority';
import lableType from '@salesforce/label/c.BI_PSPB_Type';
import lableMie from '@salesforce/label/c.BI_PSPB_MedicalInformationEnquiry';
import lableRae from '@salesforce/label/c.BI_PSPB_ReportAdverseEvents';
import lablePsp from '@salesforce/label/c.BI_PSPB_PSPPlatformSupport';
import lableDraft from '@salesforce/label/c.BI_PSPB_Draft';
import lableSubmitted from '@salesforce/label/c.BI_PSPB_Submitted';
import lableAll from '@salesforce/label/c.BI_PSPB_All';
import lableNeedmoreInformation from '@salesforce/label/c.BI_PSPB_NeedmoreInformation';
import lableNeedInfo from '@salesforce/label/c.BI_PSPB_NeedInfo';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import miePage from '@salesforce/label/c.BI_PSPB_BRMIEPage';
import raePage from '@salesforce/label/c.BI_PSPB_BRRAEPage';
import plsPage from '@salesforce/label/c.BI_PSPB_BRPLSPage';
import brandedurlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedurlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
// To display the records in column view
const COLUMNS = [
	{ label: lableCaseNumber, fieldName: 'CaseNumber' },
	{ label: lableSubject, fieldName: 'Subject' },
	{ label: lableStatus, fieldName: 'Status' },
	{ label: lablePriority, fieldName: 'Priority' },
	{ label: lableType, fieldName: 'Type' }
];
// To filter records based on type
const typeOptions = [
	{ label: lableMie, value: lableMie },
	{ label: lableRae, value: lableRae },
	{ label: lablePsp, value: lablePsp }
];
// To filter records based on status
const statusOptions = [
	{ label: lableDraft, value: lableDraft },
	{ label: lableSubmitted, value: lableSubmitted }
];

export default class BiPspbCaseComponent extends NavigationMixin(LightningElement)
{
	// Declaration of variable with @track
	@track cases = [];
	@track caseImageURL;
	@track caseTypeFilter = '';
	@track typeFilter = lableAll;
	@track statusFilter = lableAll;
	@track casestatusFilter = '';
	@track showcase = false;
	@track selectedCase = {};
	@track displayform = true;
	@track displayrecordform = false;
	@track chnagestaus = '';
	@track labelbtn = '';
	@track stautusvarible;
	@track editimg = draft;
	@track showForm = false;
	@track urlq;
	@track imgfordraft = false;
	@track casessdate = []; //This variable is referred in the HTML file of this component
	@track draftstatus = '';
	@track draftstatusneed = '';
	@track draftstatusdraft = '';
	@track draftstatustf = false;
	@track draftstatusneedtf = false;
	@track draftstatusdrafttf = false;
	@track formattedDatenewone;
	@track recorddate;
	@track username;
	@track selectedCaseId;
	@track editicon = false;
	@track typevalue;
	@track hidesubtype = true;
	@track subTypePlatformFilter;
	@track subTypePlatformHide = true;
	@track touch;
	@track down;
	@track up;
	// Declaration of variables
	caseId;
	ifNotCase=false;
	columns = COLUMNS;
	typeOptions = typeOptions;
	statusOptions = statusOptions;
	userId = Id;
	accname = '';
	// get method to retrieve the date format
	get formattedCases() {
		return this.cases.map((flitercase) => ({
			...flitercase,
			FormattedDate: this.formatDate(flitercase.CreatedDate)
		}));
	}
	// get method to retrieve the image	
	get hasImage() {
		return this.caseImageURL;
	}

	// To retireve current URL, based on that navigation will be set
	connectedCallback() {
		try {
			loadStyle(this, sldsclass);
			const currentURL = window.location.href;
			// Get the path
			const urlObject = new URL(currentURL);
			// Split the path using '/' as a separator
			const path = urlObject.pathname;
			// Find the component you need (in this case, 'Branded')
			const pathComponents = path.split('/');
			const desiredComponent = pathComponents.find((component) =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
					component.toLowerCase()
				)
			);
			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurlNavi;
			}
			else {
				this.urlq = unassignedurlNavi;
			}
			this.count = localStorage.getItem('count');
			if (this.count !== 2) {
				localStorage.setItem('count', 2);
			}
			else {
				localStorage.setItem('count', 1);
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); //Error caught when current URL is not fetched
		}
	}

	// To check any case record is available for the current user
	@wire(getEnrolle, { userId: '$userId' })
	wiredGetEnrolle({ error, data }) {
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data) {
			try {
				if (data[0].patientEnrolle) {
					this.accname = data[0].patientEnrolle.Id;
					this.loadCases(this.typeFilter, this.statusFilter);
				}
				else if (data[0].error) {
					this.showError = true;
					this.errorMessage = data[0].error;
					this.showToast(errormessage, error.message, errorvariant);
				}
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant); //Error caught when data fetched is invalid
			}
		}
		else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant); //Error caught when data is not fetched
		}
	}
	// To retrieve images from case records
	@wire(getCaseImageURL, { caseId: '$caseId' })
	wiredGetCaseImageURL({ error, data }) {
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data) {
			try {
				this.caseImageURL = data;
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant); //Error caught for incorrect data fetch
			}
		}
		else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant); //Error caught when data is not fetched
		}
	}
	// To retieve the case records based on the type and status fields
	loadCases(typeFilter, statusFilter) {
		getCases({ cpeId: this.accname, type: typeFilter, status: statusFilter })
			// Null data is checked and AuraHandledException is thrown from the Apex
			.then((result) => {
				console.log(result,'result')
				console.log(result.length,'result233')
				if(result.length>0)
				{
					this.ifNotCase = true;
				}
				else{
					this.ifNotCase=false;
				}
				if (result[0].Type === lablePsp) {
					this.hidesubtype = false;
				}
				else {
					this.hidesubtype = true;
				}
				// To set the color code for the last inserted record, a time delay should be introduced
				setTimeout(() => {
					try {
						this.handleCaseClick1(result[0].Id);
					} catch (error) {
						this.showToast(errormessage, error.message, errorvariant); //Catching Potential Error

					}
				}, 1000);
				this.cases = result.map((caseRecord) => {
					let draftstatusneed = '';
					let draftstatusdraft = '';
					let draftstatus = '';
					let draftstatusneedtf = false;
					let draftstatusdrafttf = false;
					let draftstatustf = false;

					if (caseRecord.Status === lableNeedmoreInformation) {
						draftstatusneed = lableNeedInfo;
						draftstatusneedtf = true;
					}
					else if (caseRecord.Status === lableDraft) {
						draftstatusneedtf = false;
						draftstatusdraft = lableDraft;
						draftstatusdrafttf = true;
					}
					if (caseRecord.Status === lableSubmitted) {
						draftstatus = lableSubmitted;
						draftstatustf = true;
					}
					else {
						draftstatustf = false;
					}
					const imgfordraft1 = caseRecord.Status === lableDraft;
					const imgfordraft2 = caseRecord.Status === lableNeedmoreInformation;
					return {
						...caseRecord,
						down: true,
						up: false,
						touch: false,
						imgfordraft: imgfordraft1,
						imgfordraft1: imgfordraft2,
						draftstatusneed: draftstatusneed,
						draftstatusdraft: draftstatusdraft,
						draftstatus: draftstatus,
						draftstatusneedtf: draftstatusneedtf,
						draftstatusdrafttf: draftstatusdrafttf,
						draftstatustf: draftstatustf,
						FormattedDate: this.formatDate(caseRecord.CreatedDate)
					};
				});
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant); //Catching Potential Error 
			});
	}

	// To convert the date into formatted date
	formatDate(createdDate) {
		const dateObject = new Date(createdDate);
		const formattedDate = dateObject.toLocaleDateString();
		this.formattedDatenewone = dateObject.toLocaleDateString();
		return formattedDate;
	}

	// To display the records based on click event
	handleFilterChange(event) {
		if (event.target.label === lableType) {
			this.caseTypeFilter = event.target.value;
			this.typeFilter = this.caseTypeFilter;
		}
		else if (event.target.label === lableStatus) {
			this.casestatusFilter = event.target.value;
			this.statusFilter = this.casestatusFilter;
		}
		this.loadCases(this.typeFilter, this.statusFilter);
	}

	// To view the Case details, based on the case records clicked
	openForm() {
		// Display the form.
		this.showForm = true;
		this.displayform = false;
		this.displayrecordform = true;
		this.showcase = false;
	}

	// To display the newly created case from support center
	createCase() {
		// Find the form element and submit it to create the Case record
		const form = this.template.querySelector('lightning-record-edit-form');
		form.submit();
		this.displayform = true;
		this.displayrecordform = false;
	}

	// Handler to display case details with the required background on the detailed side(left)
	handleCaseClick(event) {
		this.selectedCaseId = event.currentTarget.dataset.caseId;
		const boxes = this.template.querySelectorAll('.large-screen-background');
		const boxeses = this.template.querySelectorAll('.small-screen-background');
		this.caseId = this.selectedCaseId;
		const clickedBox = event.currentTarget;

		// Remove all existing background classes from all boxes
		boxes.forEach(box => {
			box.classList.remove('small-screen-background', 'large-screen-background', 'white-background', 'resultDiv');//This values is used in the CSS
			box.classList.add('white-background');//This value is used in the CSS
		});
		boxeses.forEach(box => {
			box.classList.remove('small-screen-background', 'large-screen-background', 'white-background', 'resultDiv');//This values is used in the CSS
			box.classList.add('white-background');
		});

		// Add appropriate background class to the clicked box
		if (window.innerWidth < 600) {
			clickedBox.classList.remove('large-screen-background', 'white-background', 'resultDiv');//This values is used in the CSS
			clickedBox.classList.add('small-screen-background');//This value is used in the CSS
		}
		else {
			clickedBox.classList.remove('small-screen-background', 'white-background', 'resultDiv');//This values is used in the CSS
			clickedBox.classList.add('large-screen-background');//This value is used in the CSS
		}

		// To display the case records based on the filter criteria selected in the left side of the page
		getCaseDetails({ caseId: this.selectedCaseId })
			// Null data is checked and AuraHandledException is thrown from the Apex
			.then((result) => {
				this.caserecordidget = result.Id;
				localStorage.setItem('caserecordid', this.caserecordidget);
				this.selectedCase = result;
				this.typevalue = this.selectedCase.Type;
				this.subTypePlatformFilter = this.selectedCase.BI_PSPB_Sub_Type__c;
				this.stautusvarible = this.selectedCase.Status;
				this.username = this.selectedCase.CreatedBy.Name;
				if (this.typevalue === lablePsp) {
					this.subTypePlatformHide = false;
				}
				else {
					this.subTypePlatformHide = true;
				}
				if (this.stautusvarible === lableSubmitted) {
					this.chnagestaus = 'submittedClass';
					this.labelbtn = lableSubmitted;
					this.editicon = false;
				}
				else if (this.stautusvarible === lableDraft) {
					this.chnagestaus = 'draftClass';
					this.labelbtn = lableDraft;
					this.editicon = true;
					this.editimg = draft;

				}
				else if (this.stautusvarible === lableNeedmoreInformation) {
					this.chnagestaus = 'NeedClass';
					this.labelbtn = lableNeedInfo;
					this.editicon = true;
					this.editimg = draft;
				}
				this.showForm = false;
				this.showcase = true;
				if (this.selectedCase.Type === lablePsp) {
					this.hidesubtype = false;
				}
				else {
					this.hidesubtype = true;
				}
				const createdate = result.CreatedDate;
				this.recorddate = createdate.split('T')[0];
			})

			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant); //Catching Potential Error
			});
	}

	// Handler to display case details with the required background on the summary side (right)
	handleCaseClick1(id) {
		this.selectedCaseId = id;
		const boxes = this.template.querySelectorAll('.resultDiv');
		this.caseId = this.selectedCaseId;
		boxes.forEach((box) => {
			box.classList.remove('resultDiv')
			box.classList.add('white-background');
		});
		boxes.forEach((box) => {
			if (box.dataset.caseId === this.selectedCaseId) {
				box.classList.remove('white-background');
				box.classList.add('large-screen-background');
			}
		});

		// To display the case records based on the filter criteria selected in the right side of the page
		getCaseDetails({ caseId: this.selectedCaseId })
			// Null data is checked and AuraHandledException is thrown from the Apex
			.then((result) => {
				this.caserecordidget = result.Id;
				localStorage.setItem('caserecordid', this.caserecordidget);
				this.selectedCase = result;
				this.typevalue = this.selectedCase.Type;
				this.subTypePlatformFilter = this.selectedCase.BI_PSPB_Sub_Type__c;
				this.stautusvarible = this.selectedCase.Status;
				this.username = this.selectedCase.CreatedBy.Name;
				if (this.typevalue === lablePsp) {
					this.subTypePlatformHide = false;
				}
				else {
					this.subTypePlatformHide = true;
				}

				if (this.stautusvarible === lableSubmitted) {
					this.chnagestaus = 'submittedClass';//This value is used in the CSS
					this.labelbtn = lableSubmitted;
					this.editicon = false;
				}
				else if (this.stautusvarible === lableDraft) {
					this.chnagestaus = 'draftClass';//This value is used in the CSS
					this.labelbtn = lableDraft;
					this.editicon = true;
					this.editimg = draft;
				}
				else if (this.stautusvarible === lableNeedmoreInformation) {
					this.chnagestaus = 'NeedClass';//This value is used in the CSS
					this.labelbtn = lableDraft;
					this.editicon = true;
					this.editimg = draft;
				}
				this.showForm = false;
				this.showcase = true;
				const createdate = result.CreatedDate;
				this.recorddate = createdate.split('T')[0];
			})

			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error 
			});
	}

	// To convert the image to blob
	readAsDataURL(blob) {
		return new Promise((resolve, reject) => {
			const reader = new FileReader();
			reader.onload = (event) => {
				const base64String = event.target.result;
				resolve(`data:image/${blob.type?.split('/')[1]};base64,${base64String}`);
			};

			reader.onerror = (error) => {
				reject(error);
			};

			reader.readAsDataURL(blob);
		});
	}

	// To navigate to the File Preview
	previewHandler() {
		this[NavigationMixin.Navigate]({
			type: 'standard__namedPage',
			attributes: {
				pageName: 'filePreview'
			},
			state: {
				selectedRecordId: this.selectedCaseId
			}
		});
	}

	// Handler to pass the URL when edit icon is clicked
	// The following setTimeout() methods are used to show a success message or an error notification after a brief delay to improve the user experience
	handledraft() {
		if (this.typevalue === lableMie) {
			setTimeout(() => {
				try {
					window.location.assign(
						this.urlq + miePage
					);
				} catch (error) {
					this.showToast(errormessage, error.message, errorvariant); //Catching Potential Error 
				}
			}, 1000);
		}
		else if (this.typevalue === lableRae) {
			setTimeout(() => {
				try {
					window.location.assign(this.urlq + raePage);
				} catch (error) {
					this.showToast(errormessage, error.message, errorvariant); //Catching Potential Error 
				}
			}, 1000);
		}
		else if (this.typevalue === lablePsp) {
			setTimeout(() => {
				try {
					window.location.assign(this.urlq + plsPage);
				} catch (error) {
					this.showToast(errormessage, error.message, errorvariant);// Catching Potential Error 
				}
			}, 1000);
		}
	}

	// Record gets visible only if click event occurs
	click(event) {
		const caseId = event.currentTarget.dataset.caseId;
		this.updateCaseTouch(caseId, true);
	}

	// Record gets visible automatically without click event
	notclick(event) {
		const caseId = event.currentTarget.dataset.caseId;
		this.updateCaseTouch(caseId, false);
	}

	// To update the draft records
	updateCaseTouch(caseId, touchValue) {
		this.cases = this.cases.map((caseRecord) => ({
			...caseRecord,
			touch: caseRecord.Id === caseId ? touchValue : caseRecord.touch,
			down: caseRecord.Id === caseId ? !touchValue : caseRecord.down,
			up: caseRecord.Id === caseId ? touchValue : !touchValue,

			FormattedDate: this.formatDate(caseRecord.CreatedDate)
		}));
	}

	// Toast message declaration for error handling
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}