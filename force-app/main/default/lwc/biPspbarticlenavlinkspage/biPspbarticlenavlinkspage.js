// This lightning web component is used navigation of information center article categorypage
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
// To import Apex Classes
import showfilterresponse from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import articleone from '@salesforce/label/c.BI_PSPB_articleOne';
import articletwo from '@salesforce/label/c.BI_PSPB_articleTwo';
import articlethree from '@salesforce/label/c.BI_PSPB_articleThree';
import articlefour from '@salesforce/label/c.BI_PSPB_articleFour';
import articlefive from '@salesforce/label/c.BI_PSPB_articleFive';
import articlesix from '@salesforce/label/c.BI_PSPB_articleSix';
import articleseven from '@salesforce/label/c.BI_PSPB_articleSeven';
import articleeight from '@salesforce/label/c.BI_PSPB_articleEight';
import articlenine from '@salesforce/label/c.BI_PSPB_articleNine';
import articleten from '@salesforce/label/c.BI_PSPB_articleTen';
import articleeleven from '@salesforce/label/c.BI_PSPB_articleEleven';
import articletwelve from '@salesforce/label/c.BI_PSPB_articleTwelve';
import articlethirteen from '@salesforce/label/c.BI_PSPB_articleThirteen';
import articlefourteen from '@salesforce/label/c.BI_PSPB_articleFourteen';
import articlefifteen from '@salesforce/label/c.BI_PSPB_articleFifteen';
import articlesixteen from '@salesforce/label/c.BI_PSPB_articleSixteen';
import articleseventeen from '@salesforce/label/c.BI_PSPB_articleSeventeen';
import articleeighteen from '@salesforce/label/c.BI_PSPB_articleEighteen';
import articlenineteen from '@salesforce/label/c.BI_PSPB_articleNineteen';
import articletwenty from '@salesforce/label/c.BI_PSPB_articleTwenty';
import articletwentyone from '@salesforce/label/c.BI_PSPB_articleTwentyOne';
import articletwentytwo from '@salesforce/label/c.BI_PSPB_articleTwentyTwo';
import articletwentythree from '@salesforce/label/c.BI_PSPB_articleTwentyThree';
import articletwentyfour from '@salesforce/label/c.BI_PSPB_articleTwentyFour';
import articletwentyfive from '@salesforce/label/c.BI_PSPB_articleTwentyFive';
import articletwentysix from '@salesforce/label/c.BI_PSPB_articleTwentySix';
import articletwentyseven from '@salesforce/label/c.BI_PSPB_articleTwentySeven';
import articletwentyeight from '@salesforce/label/c.BI_PSPB_articleTwentyEight';
import articletwentynine from '@salesforce/label/c.BI_PSPB_articleTwentyNine';
import articlecategoryone from '@salesforce/label/c.BI_PSPB_articleCategoryOne';
import articlecategorytwo from '@salesforce/label/c.BI_PSPB_articleCategoryTwo';
import articlecategorythree from '@salesforce/label/c.BI_PSPB_articleCategoryThree';
import articlecategoryfour from '@salesforce/label/c.BI_PSPB_articleCategoryFour';
import articlecategoryfive from '@salesforce/label/c.BI_PSPB_articleCategoryFive';
import articlecategoryjustforme from '@salesforce/label/c.BI_PSPB_articleJustForMeCategory';
import spcategory from '@salesforce/label/c.BI_PSPB_articleSpevigoCategory';
import statusacute from '@salesforce/label/c.BI_PSPB_Acute';
import statuschronic from '@salesforce/label/c.BI_PSPB_statusChronic';
import statusunassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import spcategoryone from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryOne';
import spcategorytwo from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryTwo';
import spcategoryoneval from '@salesforce/label/c.BI_PSPB_spArticleCategoryValOne';
import spcategorytwoval from '@salesforce/label/c.BI_PSPB_spArticleCategoryValTwo';
import articlecategoryvalfive from '@salesforce/label/c.BI_PSPB_articleCategoryValFive';
import articlecategoryvalthree from '@salesforce/label/c.BI_PSPB_articleCategoryValThree';
import articlecategoryvalone from '@salesforce/label/c.BI_PSPB_articleCategoryValOne';
import articlecategoryvalfour from '@salesforce/label/c.BI_PSPB_articleCategoryValFour';
import searchpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterSearchPage';
import categorypage from '@salesforce/label/c.BI_PSPB_BRInfoCenterCategoryPage';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import evententer from '@salesforce/label/c.BI_PSP_EventEnter';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbarticlenavlinkspage extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track userId = Id;
	@track categorytreatmentnew;
	@track categorytreatmentnewdata;
	@track showjustforme_sec = false;
	@track searchitems = [];
	@track originalsearchitems = [];
	@track titlearticle;
	@track resultval;
	@track category1;
	@track category2;
	@track category3;
	@track category4;
	@track category5;
	@track category6 = 'end-btn';
	@track urlq;
	@track categoryval;
	@track showspevigocategory = true;
	@track touch = false;
	@track down = true;
	@track up = false;
	// Global variables(without @track does not trigger automatic re-renders)
	currentPageUrl;
	urlSegments;
	baseUrl;
	siteUrlq;
	showsearch = false;

	// To remove the search input value
	clearinput() {
		const inputElement = this.template.querySelector(".search-bar");
		if (inputElement) {
			inputElement.value = "";
		}
	}

	// To navigate the information center category page
	handleButtonClicknew(event) {
		const finaltitle = event.currentTarget.dataset.name;
		const articlename = finaltitle;
		window.location.href =
			this.baseUrl + this.siteUrlq + categorypage + articlename;
	}

	// To navigate search results page
	handleSearch(event) {
		const searchTerm = event.target.value.toLowerCase();
		this.searchitems = [];

		if (event.key === evententer && searchTerm) {
			window.location.href =
				this.baseUrl + this.siteUrlq + searchpage + searchTerm;
		}
	}

	// Wire method to capture the current page reference and extract the state id value
	// We are unable to utilize "data" or "error" as CurrentPageReference is default API.
	@wire(CurrentPageReference)
	pageReference({ state }) {
		try {
			if (state && state.id) {
				this.resultval = state.id;
				this.titlearticle = state.id;

				const titlesMap = {
					[articlecategoryone]: [
						articlethree,
						articletwo,
						articleone,
						articlesix,
						articlefour
					],
					[articlecategorytwo]: [
						articletwentytwo,
						articletwentythree,
						articlefive,
						articleeight,
						articleseven
					],
					[articlecategorythree]: [
						articletwelve,
						articletwenty,
						articlefourteen,
						articlefifteen,
						articletwentyone
					],
					[articlecategoryfour]: [
						articletwentyfour,
						articleten,
						articlenine,
						articlesixteen,
						articleeighteen
					],
					[articlecategoryfive]: [
						articlenineteen,
						articleeleven,
						articlethirteen,
						articleseventeen
					],
					[articlecategoryjustforme]: [],
					spevigocategory: [
						articletwentyseven,
						articletwentyeight,
						articletwentynine,
						articletwentyfive,
						articletwentysix
					]
				};

				for (const key in titlesMap) {
					if (titlesMap[key].includes(this.titlearticle)) {
						this.categoryval = key;
						break;
					}
				}

				if (this.categoryval === articlecategoryone) {
					this.category1 = "end-btn-selected";
					this.category2 = "end-btn";
					this.category3 = "end-btn";
					this.category4 = "end-btn";
					this.category5 = "end-btn";
				} else if (this.categoryval === articlecategorytwo) {
					this.category1 = "end-btn";
					this.category2 = "end-btn-selected";
					this.category3 = "end-btn";
					this.category4 = "end-btn";
					this.category5 = "end-btn";
				} else if (this.categoryval === articlecategorythree) {
					this.category1 = "end-btn";
					this.category2 = "end-btn";
					this.category3 = "end-btn-selected";
					this.category4 = "end-btn";
					this.category5 = "end-btn";
				} else if (this.categoryval === articlecategoryfour) {
					this.category1 = "end-btn";
					this.category2 = "end-btn";
					this.category3 = "end-btn";
					this.category4 = "end-btn-selected";
					this.category5 = "end-btn";
				} else if (this.categoryval === articlecategoryfive) {
					this.category1 = "end-btn";
					this.category2 = "end-btn";
					this.category3 = "end-btn";
					this.category4 = "end-btn";
					this.category5 = "end-btn-selected";
				} else if (this.categoryval === spcategory) {
					this.category1 = "end-btn";
					this.category2 = "end-btn";
					this.category3 = "end-btn";
					this.category4 = "end-btn";
					this.category5 = "end-btn";
					this.category6 = "end-btn-selected";
				}
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the patient status value
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;

				if (this.patientstatusval === statusacute) {
					this.showspevigocategory = true;
					this.categorytreatmentnew = spcategorytwo;
					this.categorytreatmentnewdata = spcategorytwoval;
				} else if (this.patientstatusval === statuschronic) {
					this.showspevigocategory = true;

					this.categorytreatmentnew = spcategoryone;
					this.categorytreatmentnewdata = spcategoryoneval;
				} else if (this.patientstatusval === statusunassigned) {
					this.showspevigocategory = false;
				} else {
					this.showspevigocategory = false;
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

	/* If user having null assessment record then disabled the just for me navigation */
	// To retrieve the letspersonalize assessment data
	@wire(showfilterresponse, { userId: "$userId" })
	wireddatashowfilterresponse({ error, data }) {
		try {
			if (data) {
				this.showjustforme_sec = false;

				let showresponsedata = data;
				if (showresponsedata.length === 1) {
					this.showjustforme_sec = true;
				} else if(data === null) {
					this.showjustforme_sec = false;
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			} else {
				this.showjustforme_sec = false;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// Method to set touch state to true and adjust down and up states accordingly
	click() {
		this.touch = true;
		this.down = false;
		this.up = true;
	}

	// Method to set touch state to false and adjust down and up states accordingly
	notclick() {
		this.touch = false;
		this.down = true;
		this.up = false;
	}

	// Method to handle key up event for search input
	handleSearchInputKeyUp(event) {
		// Check if the Enter key is pressed
		if (event.key === evententer) {
			// Call the method to handle search
			this.handleSearch(event);
		}
	}

	// Method to handle focus on the search bar
	handleSearchBarFocus() {
		this.template.querySelector(
			"hr.search-bar-border-bottom"
		).style.borderColor = "#7B4D00";
		this.template.querySelector(
			"hr.search-bar-border-bottom"
		).style.borderWidth = "2px";
		this.template.querySelector(
			"hr.search-bar-border-bottom"
		).style.transition = "0.1s";
	}

	// Method to handle blur event on the search bar
	handleSearchBarBlur() {
		this.template.querySelector(
			"hr.search-bar-border-bottom"
		).style.borderColor = "rgba(105, 105, 105, 1)";
		this.template.querySelector(
			"hr.search-bar-border-bottom"
		).style.borderWidth = "2px";
		this.template.querySelector(
			"hr.search-bar-border-bottom"
		).style.transition = "0.1s";
	}

	// button labels
	standarItems = [
		{ id: 1, title: articlecategoryone, titleval: articlecategoryvalone },
		{
			id: 2,
			title: articlecategorytwo,
			titleval: articlecategorytwo
		},
		{
			id: 3,
			title: articlecategorythree,
			titleval: articlecategoryvalthree
		},
		{
			id: 4,
			title: articlecategoryfour,
			titleval: articlecategoryvalfour
		},
		{
			id: 5,
			title: articlecategoryfive,
			titleval: articlecategoryvalfive
		}
	];

	// To retireve current URL, based on that navigation will be set
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
			if (this.urlq !== brandedurl) {
				this.showspevigocategory = false;
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
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