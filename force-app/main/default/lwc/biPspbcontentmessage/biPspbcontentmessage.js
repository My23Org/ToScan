// This lightning web component is used for display the personalized messages based on category of the article selected
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
// To import Apex Classes
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
import getCategoryMessages from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.getCategoryMessages';
import UserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver';
import getLoggedInUserAccount from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserAccount';
// To import Static Resource
import testimg from '@salesforce/resourceUrl/BI_PSPB_ProfileAvatar';
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
import categorygenmessages from '@salesforce/label/c.BI_PSPB_messageCategoryOne';
import categorysociallife from '@salesforce/label/c.BI_PSPB_messageCategoryTwo';
import categorymanagement from '@salesforce/label/c.BI_PSPB_messageCategoryThree';
import categorymentalhealth from '@salesforce/label/c.BI_PSPB_messageCategoryFour';
import categoryhealthylifestyle from '@salesforce/label/c.BI_PSPB_messageCategoryFive';
import statusunassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import searchpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterSearchPage';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbcontentmessage extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track personalizemessage = false;
	@track message = '';
	@track personalizedMessages = [];
	@track generalMessages = [];
	@track genmessage = '';
	@track result = '';
	@track assessmentresponse = [];
	@track currentUserName = '';
	@track currentUserId = '';
	@track userId = Id;
	@track newnum = 0;
	@track titlear = '';
	@track categoryval = '';
	@track caregiver = false;
	@track name;
	@track urlq;
	@track currentPageUrl;
	@track urlSegments;
	@track baseUrl;
	@track showbrandednav = true;
	@track patientstatusval = '';
	// Global variables(without @track does not trigger automatic re-renders)
	selectedAvatarSrc;
	userAccounts;
	siteUrlq;
	cardimage = '';

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retirieve the staus value of a Patient
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;

				// Handle the data
			} else if (error) {
				// Handle the error
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To set the property of para element if the status is unassigned
	renderedCallback() {
		//code
		try {
			if (this.patientstatusval === statusunassigned) {
				// Assuming you have a paragraph element with the class 'para'
				let paraElement = this.template.querySelector(".para");

				// Check if the element with the class "para" exists
				if (paraElement) {
					if (window.innerWidth > 1115) {
						// Set the top property to 10%
						paraElement.style.top = "326px";
					}
				}
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

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

			if (this.urlq === brandedurl) {
				this.showbrandednav = true;
			} else {
				this.showbrandednav = false;
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// To clear the search input
	clearinput() {
		const inputElement = this.template.querySelector(".search-bar");
		if (inputElement) {
			inputElement.value = "";
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retireve the Avatar of the Caregiver
	@wire(UserCaregiver)
	wiredavtList({ error, data }) {
		try {
			if (data) {
				// Assign the data to the reactive property

				if (data.length > 0) {
					this.caregiver = true;
					this.name = data.length > 0 ? data[0].Name : "";
					this.currentUserName = this.name;

					if (this.genmessage.includes("{!username}")) {
						this.genmessage = this.genmessage.replace(
							/{!username}/g,
							this.currentUserName
						);
					}

					if (this.genmessage.includes("XXX")) {
						this.genmessage = this.genmessage.replace(
							/XXX/g,
							this.currentUserName
						);
					}
					this.cardimage = data[0]?.BI_PSP_AvatarUrl__c
						? data[0]?.BI_PSP_AvatarUrl__c
						: testimg;
					if (data[0]?.BI_PSP_AvatarUrl__c) {
						this.cardimage = data[0]?.BI_PSP_AvatarUrl__c;
					} else {
						this.cardimage = testimg;
					}
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retireve the Avatar of the Patient
	@wire(getLoggedInUserAccount)
	wiredUserAccounts({ error, data }) {
		try {
			if (data) {
				this.userAccounts = data;
				if (this.caregiver === false) {
					this.name =
						this.userAccounts.length > 0 ? this.userAccounts[0]?.Name : "";
					this.currentUserName = this.name;

					if (this.genmessage.includes("{!username}")) {
						this.genmessage = this.genmessage.replace(
							/{!username}/g,
							this.currentUserName
						);
					}

					if (this.genmessage.includes("XXX")) {
						this.genmessage = this.genmessage.replace(
							/XXX/g,
							this.currentUserName
						);
					}

					if (this.userAccounts[0]?.BI_PSP_AvatarUrl__c) {
						this.cardimage = this.userAccounts[0]?.BI_PSP_AvatarUrl__c;
					} else {
						this.cardimage = testimg;
					}
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// Generate a random decimal between 0 (inclusive) and 1 (exclusive)
	getRandomNumber(min, max) {
		const randomDecimal = Math.random();

		// Scale the random decimal to the range [min, max)
		const randomNumber = Math.floor(randomDecimal * (max - min + 1)) + min;

		return randomNumber;
	}

	// Wire method to capture the current page reference and extract the state id value
	@wire(CurrentPageReference)
	pageReference({ state }) {
		try {
			if (state && state.id) {
				this.titlear = state.id;
				this.findCategory();
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}
	}

	// Function to find the category of the given article
	findCategory() {
		try {
			let categoryArticles = {
				[categorygenmessages]: [
					articleone,
					articletwo,
					articlethree,
					articlefour,
					articlefive
				],
				[categorysociallife]: [
					articlesix,
					articleseven,
					articleeight,
					articlenine
				],
				[categorymanagement]: [
					articleten,
					articleeleven,
					articletwelve,
					articlethirteen,
					articlefourteen,
					articlefifteen,
					articlesixteen,
					articleseventeen,
					articleeighteen,
					articlenineteen,
					articletwenty,
					articletwentyone,
					articletwentyfive,
					articletwentysix,
					articletwentyseven,
					articletwentyeight,
					articletwentynine
				],
				[categorymentalhealth]: [articletwentytwo, articletwentythree],
				[categoryhealthylifestyle]: [articletwentyfour]
			};

			// Input article
			let article = this.titlear;
			for (const category in categoryArticles) {
				if (categoryArticles[category].includes(article)) {
					this.categoryval = category;
					break;
				}
			}
			if (this.categoryval.length === 0) {
				this.categoryval = categorygenmessages;
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
			// Handle the error as needed
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve personalized message based on given category
	@wire(getCategoryMessages, { categoryval: "$categoryval" }) // Use dynamic parameter
	wiredCategoryMessages({ error, data }) {
		try {
			if (data) {
				this.generalMessages = data;
				this.result = this.getRandomNumber(0, this.generalMessages.length - 1);
				this.genmessage = this.generalMessages[this.result];

				// Replace placeholders in message
				if (this.genmessage.includes("{!username}")) {
					if (this.currentUserName !== "") {
						this.genmessage = this.genmessage.replace(
							/{!username}/g,
							this.currentUserName
						);
					}
				}

				if (this.genmessage.includes("XXX")) {
					if (this.currentUserName !== "") {
						this.genmessage = this.genmessage.replace(
							/XXX/g,
							this.currentUserName
						);
					}
				}

				if (this.genmessage === this.message) {
					this.genmessage = this.generalMessages[this.result - 1];
				}

				// Handle other replacements as needed
			} else if (error) {
				// Handle errors
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To navigate information center search results page
	handleSearch(event) {
		const searchTerm = event.target.value.toLowerCase();
		this.searchitems = [];

		if (event.key === "Enter" && searchTerm) {
			window.location.href =
				this.baseUrl + this.siteUrlq + searchpage + searchTerm;
		}
	}

	// To load the search method
	handleSearchButtonClick() {
		this.handleSearch();
	}

	// Method to handle key up event for search input
	handleSearchInputKeyUp(event) {
		if (event.key === "Enter") {
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
		).style.borderColor = "rgba(111, 81, 29, 1)";
		this.template.querySelector(
			"hr.search-bar-border-bottom"
		).style.borderWidth = "2px";
		this.template.querySelector(
			"hr.search-bar-border-bottom"
		).style.transition = "0.1s";
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