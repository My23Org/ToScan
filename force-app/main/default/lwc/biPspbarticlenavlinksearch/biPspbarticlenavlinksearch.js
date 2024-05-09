//This lightning web component is used for navigation of article categorypage and spevigo article category page based on patient status
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import showfilterresponse from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
import getCareProgramEnrolleId from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.getCareProgramEnrolleId';

// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import spcategorytwo from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryTwo';
import spcategoryone from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryOne';
import spcategoryvalone from '@salesforce/label/c.BI_PSPB_spArticleCategoryValOne';
import spcategoryvaltwo from '@salesforce/label/c.BI_PSPB_spArticleCategoryValTwo';
import statusacute from '@salesforce/label/c.BI_PSPB_Acute';
import statuschronic from '@salesforce/label/c.BI_PSPB_statusChronic';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import categorypage from '@salesforce/label/c.BI_PSPB_BRInfoCenterCategoryPage';
import searchpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterSearchPage';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import nosearchresults from '@salesforce/label/c.BI_PSPB_searchNoResults';
import evententer from '@salesforce/label/c.BI_PSP_EventEnter';

// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbarticlenavlinksearch extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track userId = Id;
	@track showjustforme_sec = false;
	@track searchitems = [];
	@track originalsearchitems = [];
	@track patientstatusval = '';
	@track categorytreatment;
	@track categorytreatmentnew;
	@track categorytreatmentnewadb;
	@track urlq;
	@track currentPageUrl;
	@track urlSegments;
	@track baseUrl;
	@track showbrandednav = true;
	// Global variables(without @track does not trigger automatic re-renders)
	siteUrlq;
	showsearch = false;

	/* If user having null assessment record then disabled the just for me navigation */
	// To retrieve the letspersonalized assessment data
	@wire(showfilterresponse)
	wireddatashowfilterresponse({ error, data }) {
		try {
			if (data) {
				this.showjustforme_sec = false;

				let showresponsedata = data;
				if (showresponsedata.length === 1) {
					this.showjustforme_sec = true;
				} else {
					this.showjustforme_sec = false;
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			} else if (data === null) {
				this.showjustforme_sec = false;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To navigate article category  page
	handleButtonClicknew(event) {
		const finaltitle = event.currentTarget.dataset.name;
		const articlename = finaltitle;

		window.location.href =
			this.baseUrl + this.siteUrlq + categorypage + articlename;
	}

	// To navigate search result page
	handleSearch(event) {
		const searchTerm = event.target.value.toLowerCase();
		this.searchitems = [];

		for (let i = 0; i < this.originalsearchitems.length; i++) {
			const item = this.originalsearchitems[i];
			if (item.text.toLowerCase().includes(searchTerm)) {
				this.searchitems.push(item);
			}
		}

		if (this.searchitems.length === 0) {
			this.searchitems.push({ id: 100, text: nosearchresults });
		}
		if (event.key === evententer && searchTerm) {
			window.location.href =
				this.baseUrl + this.siteUrlq + searchpage + searchTerm;
		}
	}

	// To capture the enter event
	handleSearchInputKeyUp(event) {
		if (event.key === evententer) {
			this.handleSearch(event);
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retirieve the staus value of a Patient
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;

				if (this.patientstatusval === statusacute) {
					this.showbrandednav = true;
					this.categorytreatmentnew = spcategorytwo;
					this.categorytreatmentnewadb = spcategoryvaltwo;
				} else if (this.patientstatusval === statuschronic) {
					this.categorytreatmentnew = spcategoryone;
					this.categorytreatmentnewadb = spcategoryvalone;
				}

				// Handle the data
			} else if (error) {
				// Handle the error
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To get the Url based current site name
	connectedCallback() {
		try {
			const currentURL = window.location.href;

			// Create a URL object
			const urlObject = new URL(currentURL);

			// Get the path
			const path = urlObject.pathname;

			// Split the path using '/' as a separator
			const pathComponents = path.split("/");

			// Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find((component) =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
					component.toLowerCase()
				)
			);

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurl;
				this.siteUrlq = brandedsiteurl;
			} else {
				this.urlq = unassignedurl;
				this.siteUrlq = unassignedsiteurl;
			}
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split("/");
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;

			if (this.urlq === brandedurl) {
				this.showbrandednav = true;
			} else {
				this.showbrandednav = false;
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
			// Handle the error as needed
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the letspersonalized assessment data
	@wire(getCareProgramEnrolleId)
	wireddatacareprogramenrolleeid({ error, data }) {
		try {
			if (data) {
				this.showbrandednav = true;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			} else {
				this.showbrandednav = false;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
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