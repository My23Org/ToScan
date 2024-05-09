// This component is consolidate component used for creating Case object records.
// To import Libraries
import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//  To import Apex Classes
import createCase from '@salesforce/apex/BI_PSPB_CreateCaseCtrl.createCase';
import getValuesFromTable1 from '@salesforce/apex/BI_PSPB_CreateCaseCtrl.getPractitionerList';
import draftCase from '@salesforce/apex/BI_PSPB_CreateCaseCtrl.draftCase';
// To import Custom Labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import draft from '@salesforce/label/c.BI_PSPB_Draft';
import lableMie from '@salesforce/label/c.BI_PSPB_MedicalInformationEnquiry';
import lableRae from '@salesforce/label/c.BI_PSPB_ReportAdverseEvents';
import lablePsp from '@salesforce/label/c.BI_PSPB_PSPPlatformSupport';
import productInfo from '@salesforce/label/c.BI_PSPB_Product_Information';
import treatment from '@salesforce/label/c.BI_PSPB_Treatment';
import symptoms from '@salesforce/label/c.BI_PSPB_Symptoms';
import suspectedSide from '@salesforce/label/c.BI_PSPB_Suspected_side_effect_of_spesolimab';
import unexpectedOutcome from '@salesforce/label/c.BI_PSPB_Unexpected_outcomes_of_spesolimab_treatments';
import other from '@salesforce/label/c.BI_PSPB_Other';
import submitted from '@salesforce/label/c.BI_PSPB_Submitted';
import needMoreInfo from '@salesforce/label/c.BI_PSPB_NeedmoreInformation';
import canceled from '@salesforce/label/c.BI_PSPB_Canceled';
import closed from '@salesforce/label/c.BI_PSPB_Closed';

export default class BiPspCreateCaseRecord extends NavigationMixin(LightningElement) {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @api
	@api recordId;
	@api selectedValue;
	@api selectedValue1;
	// Declaration of variables with @track
	@track searchResults;
	@track searchResults1;
	@track subject;
	@track description = '';
	@track status = draft;
	@track selectedType;
	@track selectedSubtype;
	@track subtypeOptions = [];
	@track isPatientEmpty = false;
	@track isTypeEmpty = false;
	@track isSubTypeEmpty = false;
	@track isDescriptionEmpty = false;
	@track selectedValues11 = '';
	// Declaration of Global variables
	picklistOrdered = [];
	picklistOrdered1 = [];
	selectedSearchResult;
	selectedSearchResult1;

	// Define options for Type picklist
	get typeOptions() {
		return [
			{ label: lableMie, value: lableMie },
			{ label: lableRae, value: lableRae },
			{ label: lablePsp, value: lablePsp }
		];
	}

	//to display enrollee record in dropdown
	connectedCallback() {
		try {
			getValuesFromTable1()
				.then((result) => {

					for (let i = 0; i < result.length; i++) {
						this.picklistOrdered1.push({ label: result[i].Name, value: result[i].Id });
					}
					this.picklistOrdered1 = this.picklistOrdered1.sort((a, b) => {
						if (a.label < b.label) {
							return -1;
						}
						return null;
					})
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); //catching potential error from Apex
				});
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}

	//to get relevant care program enrollee record
	search(event) {
		const input = event.detail.value.toLowerCase();
		const result = this.picklistOrdered.filter((picklistOption) => picklistOption.label.toLowerCase().includes(input));
		this.searchResults = result;
	}

	//to revoke careprogram enrollee records
	search1(event) {
		this.selectedSearchResult1 = '';
		this.searchValue1 = event.detail.value;
		const input = event.detail.value.toLowerCase();
		if (input === '') {
			this.isSearch1Cleared = true;
		}
		this.searchResults1 = this.picklistOrdered1.filter((picklistOption1) => picklistOption1.label.toLowerCase().includes(input));
		const searchedResult1 = this.picklistOrdered1.filter((picklistOption1) =>
			picklistOption1.label.toLowerCase().includes(input)
		);
		this.searchresultempty1 = searchedResult1.length === 0 ? true : false
	}

	//to handle when there are no Care Program Enrollee records
	handleOnBlur1() {
		//Settimeout function used to close the spinner automatically few seconds after it displays
		setTimeout(() => {
			try {
				if (this.isSearch1Cleared === false) {
					this.searchResults1 = null;
				}
			} catch (error) {
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
			}
		}, 300);
		this.isSearch1Cleared = false;
	}

	//to get search result
	selectSearchResult(event) {
		const selectedValue = event.currentTarget.dataset.value;
		this.selectedSearchResult = this.picklistOrdered.find((picklistOption) => picklistOption.value === selectedValue);
		const messageEvent = new CustomEvent('change', {
			detail: {
				selectedValue: this.selectedValue
			}
		});
		this.dispatchEvent(messageEvent);
		this.clearSearchResults();
	}

	//to revoke search result
	selectSearchResult1(event) {
		const selectedValue1 = event.currentTarget.dataset.value;
		this.selectedValues11 = event.currentTarget.dataset.value;
		this.selectedSearchResult1 = this.picklistOrdered1.find((picklistOption1) => picklistOption1.value === selectedValue1);
		const messageEvent = new CustomEvent('changes', {
			detail: {
				selectedValue1: this.selectedValue1
			}
		});
		this.dispatchEvent(messageEvent);
		this.clearSearchResults1();
	}

	clearSearchResults() {
		this.searchResults = null;
	}
	clearSearchResults1() {
		this.searchResults1 = null;
	}
	//to get selected option value
	showPicklistOptions1() {
		if (!this.searchResults1) {
			this.searchResults1 = this.picklistOrdered1;
		}
	}

	// Define options for Subtype picklist based on selected Type
	handleTypeChange(event) {
		this.selectedType = event.detail.value;
		this.updateSubtypeOptions();
	}

	//to display values in combobox
	updateSubtypeOptions() {
		if (this.selectedType === lableMie) {
			this.subtypeOptions = [
				{ label: productInfo, value: productInfo },
				{ label: treatment, value: treatment },
				{ label: symptoms, value: symptoms }
			];
		} else if (this.selectedType === lableRae) {
			this.subtypeOptions = [
				{ label: suspectedSide, value: suspectedSide },
				{ label: unexpectedOutcome, value: unexpectedOutcome },
				{ label: other, value: other }
			];
		} else {
			// Reset subtypeOptions if Type is changed to PSP Platform Support or any other value
			this.subtypeOptions = [];
		}
		this.selectedSubtype = undefined; // Reset selected subtype
	}
	// Define options for Status picklist
	get statusOptions() {
		return [
			{ label: draft, value: draft },
			{ label: submitted, value: submitted },
			{ label: needMoreInfo, value: needMoreInfo },
			{ label: canceled, value: canceled },
			{ label: closed, value: closed }
		];
	}

	handleStatusChange(event) {
		this.status = event.detail.value;
	}

	handleSubtypeChange(event) {
		this.selectedSubtype = event.detail.value;
	}

	handleSubjectChange(event) {
		this.subject = event.target.value;
	}

	handleDescriptionChange(event) {
		this.description = event.target.value;
	}

	//to create case record
	createCase() {

		// Validate if any of the required fields is empty
		if (!this.selectedType || !this.selectedSubtype || !this.description || !this.selectedValues11) {

			this.isPatientEmpty = true;
			this.isTypeEmpty = true;
			this.isSubTypeEmpty = true;
			this.isDescriptionEmpty = true;
			return;
		}
		try {
			createCase({
				Type: this.selectedType,
				subType: this.selectedSubtype,
				description: this.description,
				patient: this.selectedValues11
			})
				.then(result => {
					this.navigateToRecord(result);
					// Optionally, reset the input fields
					this.resetFields();
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); //catching potential error from Apex
				})
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); //catching potential error from LWC
		}

	}

	//inserts the case record with status as draft
	draftCase() {
		if (!this.selectedType || !this.selectedSubtype || !this.description || !this.selectedValues11) {
			this.isPatientEmpty = true;
			this.isTypeEmpty = true;
			this.isSubTypeEmpty = true;
			this.isDescriptionEmpty = true;
			return;
		}
		try {
			draftCase({
				Type: this.selectedType,
				subType: this.selectedSubtype,
				description: this.description,
				patient: this.selectedValues11
			})
				.then(result => {
					this.navigateToRecord(result);
					// Optionally, reset the input fields
					this.resetFields();
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); //catching potential error from APex
				});

		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	// Method to reset input fields
	resetFields() {
		this.subject = '';
		this.description = '';
		this.selectedType = '';
		this.selectedSubtype = '';
		this.selectedValues11 = '';
	}
	navigateToRecord(recordId) {
		// Navigate to the record page
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: recordId,
				objectApiName: 'Case', // Object of the record being navigated to
				actionName: 'view' // Action to be performed on the record page
			}
		});
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