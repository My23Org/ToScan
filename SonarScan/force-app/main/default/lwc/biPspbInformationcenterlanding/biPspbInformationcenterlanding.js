// This Lightning web component is used to display the four most recent articles and is also utilized for category navigation.
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import retrieveMediaFromCMSNews from '@salesforce/apex/BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews';
import showfilterresponse from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
import { refreshApex } from '@salesforce/apex';
// To import Static Resource
import articlepic4 from '@salesforce/resourceUrl/BI_PSP_articlepic4';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import testsite from '@salesforce/label/c.BI_PSPB_TestsiteName';
import categoryone from '@salesforce/label/c.BI_PSPB_articleCategoryOne';
import categoryoneval from '@salesforce/label/c.BI_PSPB_articleCategoryValOne';
import categorytwo from '@salesforce/label/c.BI_PSPB_articleCategoryTwo';
import categorytwoval from '@salesforce/label/c.BI_PSPB_articleCategoryValTwo';
import categorythree from '@salesforce/label/c.BI_PSPB_articleCategoryThree';
import categorythreeval from '@salesforce/label/c.BI_PSPB_articleCategoryValThree';
import categoryfour from '@salesforce/label/c.BI_PSPB_articleCategoryFour';
import categoryfourval from '@salesforce/label/c.BI_PSPB_articleCategoryValFour';
import categoryfive from '@salesforce/label/c.BI_PSPB_articleCategoryFive';
import categoryfiveval from '@salesforce/label/c.BI_PSPB_articleCategoryValFive';
import articletwentyseven from '@salesforce/label/c.BI_PSPB_articleTwentySeven';
import articletwentynine from '@salesforce/label/c.BI_PSPB_articleTwentyNine';
import articletwentyfive from '@salesforce/label/c.BI_PSPB_articleTwentyFive';
import articletwentysix from '@salesforce/label/c.BI_PSPB_articleTwentySix';
import articletwentyeight from '@salesforce/label/c.BI_PSPB_articleTwentyEight';
import spcategoryone from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryOne';
import spcategorywo from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryTwo';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import statuschronic from '@salesforce/label/c.BI_PSPB_statusChronic';
import statusacute from '@salesforce/label/c.BI_PSPB_Acute';
import statusunassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import articlestring from '@salesforce/label/c.BI_PSPB_ArticleString';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import detailpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterDetailPage';
import searchpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterSearchPage';
import acutevideopage from '@salesforce/label/c.BI_PSPB_AcuteVideoPage';
import chronicvideopage from '@salesforce/label/c.BI_PSPB_chronicVideoPage';
import categorypage from '@salesforce/label/c.BI_PSPB_BRInfoCenterCategoryPage';
import evententer from '@salesforce/label/c.BI_PSP_EventEnter';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbInformationcenterlanding extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track userId = Id;
	@track urlq;
	@track showtreatvideo = true;
	@track image12 = [];
	@track showjustforme_sec = false;
	@track results = [];
	@track result = [];
	@track patientstatusval = '';
	@track categoryval = '';
	@track touch = false;
	@track down = true;
	@track up = false;
	// Global variables(without @track does not trigger automatic re-renders)
	image1;
	image2;
	image3;
	image4 = articlepic4;
	heading1;
	heading2;
	heading3;
	arheading1;
	arheading2;
	arheading3;
	channelName = testsite;
	description1;
	description2;
	description3;
	threeDifferentNumbers;
	submittedRecord;
	searchTerm = '';
	relatedItems = [];
	currentPageUrl;
	urlSegments;
	baseUrl;
	siteUrlq;

	searchitems = [];
	originalsearchitems = [];
	// button labels
	standarItems = [
		{ id: 1, title: categoryone, titleval: categoryoneval },
		{
			id: 2,
			title: categorytwo,
			titleval: categorytwoval
		},
		{
			id: 3,
			title: categorythree,
			titleval: categorythreeval
		},
		{
			id: 4,
			title: categoryfour,
			titleval: categoryfourval
		},
		{
			id: 5,
			title: categoryfive,
			titleval: categoryfiveval
		}
	];
	
	/* If user having null assessment record then disabled the just for me navigation */
	// To check whether the user has attended the LetsPersonalized questionnaires or not
	@wire(showfilterresponse)
	wiredfilterresponse({ error, data }) {
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
			} else if(data === null) {
				this.showjustforme_sec = false;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// Generate a random number between 2 and 4 (inclusive)
	get dynamicProperty() {
		const newRandomNumber = Math.floor(Math.random() * 3) + 2;
		return newRandomNumber;
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the CMS article based on the given channel name
	@wire(retrieveMediaFromCMSNews, { channelName: '$channelName' })
	wiredData({ error, data }) {
		try {
			if (data) {
				let objStr = JSON.parse(data);

				objStr.map((element) => {
					const timestamp = new Date().getTime();
					const cbValue = `cb=${timestamp}`;

					return (this.results = [
						...this.results,
						{
							image: element.url + '?' + cbValue,
							text: element.title,
							text2: element.subtitle,
							page: element.url
						}
					]);
				});
				if (this.results.length > 0) {
					this.image12 = this.results;

					if (this.urlq === unassignedurl) {
						if (this.patientstatusval === statusacute) {
							this.showtreatvideo = true;

							const filteredDataacute = this.image12.filter(
								(entry) =>
									entry.text !== articletwentyseven &&
									entry.text !== articletwentyeight
							);
							this.image12 = filteredDataacute;
						}
					}

					if (this.urlq !== brandedurl) {
						if (this.patientstatusval !== statusacute) {
							const filteredData = this.image12.filter(
								(entry) =>
									entry.text !== articletwentyseven &&
									entry.text !== articletwentyeight &&
									entry.text !== articletwentysix &&
									entry.text !== articletwentyfive &&
									entry.text !== articletwentynine
							);
							this.image12 = filteredData;
						}
						if (this.patientstatusval === statusunassigned) {
							this.showtreatvideo = false;
						}
					}
					if (this.urlq === brandedurl) {
						if (this.patientstatusval === statuschronic) {
							const filteredData = this.image12.filter(
								(entry) =>
									entry.text !== articletwentysix &&
									entry.text !== articletwentyfive
							);
							this.image12 = filteredData;
						}
						if (this.patientstatusval === statusunassigned) {
							this.showtreatvideo = false;
						}
					}

					this.threeDifferentNumbers = this.generateRandomNumbers();

					if (this.image12[this.threeDifferentNumbers[0]]) {
						this.image1 = this.image12[this.threeDifferentNumbers[0]].image;
						this.heading1 = this.image12[this.threeDifferentNumbers[0]].text;
						this.description1 =
							this.image12[this.threeDifferentNumbers[0]].text2;
					}

					if (this.image12[this.threeDifferentNumbers[1]]) {
						this.image2 = this.image12[this.threeDifferentNumbers[1]].image;
						this.heading2 = this.image12[this.threeDifferentNumbers[1]].text;
						this.description2 =
							this.image12[this.threeDifferentNumbers[1]].text2;
					}

					if (this.image12[this.threeDifferentNumbers[2]]) {
						this.image3 = this.image12[this.threeDifferentNumbers[2]].image;
						this.heading3 = this.image12[this.threeDifferentNumbers[2]].text;
						this.description3 =
							this.image12[this.threeDifferentNumbers[2]].text2;
					}
				}

				this.error = undefined;
				this.image12 = this.results;

				this.image12 = this.results;
				this.arheading1 = articlestring + ' ' + this.heading1;
				this.arheading2 = articlestring + ' ' + this.heading2;
				this.arheading3 = articlestring + ' ' + this.heading3;
			} else if (error) {
				this.error = error;
				this.results = undefined;
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To clear the search input
	clearinput() {
		const inputElement = this.template.querySelector('.search-bar');
		if (inputElement) {
			inputElement.value = '';
		}
	}

	// Generates numbers from 0 to 8
	generateRandomNumbers() {
		const numbers = new Set();
		while (numbers.size < 3) {
			const randomNumber = Math.floor(Math.random() * 8);
			numbers.add(randomNumber);
		}
		return Array.from(numbers);
	}

	// Refresh Apex data
	refreshData() {
		return refreshApex(this.wiredstatusofpatient);
	}

	// To retrieve the current site url
	connectedCallback() {
		try {
			this.refreshData();
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

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurl;
				this.siteUrlq = brandedsiteurl;
			} else {
				this.urlq = unassignedurl;
				this.siteUrlq = unassignedsiteurl;
			}
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split('/');
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;

			if (this.urlq === brandedurl) {
				this.showtreatvideo = true;
			} else {
				if (this.patientstatusval === statusacute) {
					this.showtreatvideo = true;
				} else {
					this.showtreatvideo = true;
				}
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	handleButtonClick(event) {
		const finaltitle = event.currentTarget.dataset.name;

		const articlename = finaltitle;

		window.location.href =
			this.baseUrl + this.siteUrlq + detailpage + articlename;
	}

	// To navigate to article category page
	handleButtonClicknew(event) {
		const finaltitle = event.currentTarget.dataset.name;
		const articlename = finaltitle;
		window.location.href =
			this.baseUrl + this.siteUrlq + categorypage + articlename;
	}

	handleSearch(event) {
		const searchTerm = event.target.value.toLowerCase();

		if (searchTerm) {
			// Filter related items based on the search term
			this.searchitems = this.originalsearchitems.filter((item) =>
				item.title.toLowerCase().includes(searchTerm)
			);
		} else {
			// If the search input is empty, reset to original items
			this.searchitems = [...this.originalsearchitems];
		}

		// Navigate to the next page when Enter key is pressed
		if (event.key === evententer && searchTerm) {
			window.location.href =
				this.baseUrl + this.siteUrlq + searchpage + searchTerm;
		}
	}

	handleSearchButtonClick() {
		// Implement your logic with the selected item

		this.handleSearch();
		// Add your navigation logic or any other actions here
	}

	handleSearchInputKeyUp(event) {
		if (event.key === evententer) {
			this.handleSearch(event);
		}
	}

	handleSearchBarFocus() {
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.borderColor = '#7B4D00';
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.borderWidth = '2px';
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.transition = '0.1s';
	}

	handleSearchBarBlur() {
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.borderColor = 'rgba(111, 81, 29, 1)';
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.borderWidth = '2px';
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.transition = '0.1s';
	}

	// To navigate to video page based on user status
	openPTVPage() {
		if (this.patientstatusval === statusacute) {
			if (this.urlq !== brandedurl) {
				window.location.assign(this.siteUrlq + acutevideopage);
			} else {
				window.location.assign(this.siteUrlq + acutevideopage);
			}
			this.categoryval = spcategorywo;
		} else if (
			this.patientstatusval === statuschronic &&
			this.urlq === brandedurl
		) {
			window.location.assign(this.siteUrlq + chronicvideopage);
			this.categoryval = spcategoryone;
		} else if (this.urlq === brandedurl) {
			window.location.assign(this.siteUrlq + chronicvideopage);
		} else {
			window.location.assign(this.siteUrlq + acutevideopage);
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the patient status
	wiredstatusofpatient;
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;

				// Handle the data
				if (this.patientstatusval === statusacute) {
					this.categoryval = spcategorywo;
				} else if (this.patientstatusval === statuschronic) {
					this.categoryval = spcategoryone;
				} else {
					if (this.urlq === brandedurl) {
						this.categoryval = spcategoryone;
					} else {
						this.categoryval = spcategorywo;
					}
				}
			} else if (error) {
				// Handle the error
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	click() {
		this.touch = true;
		this.down = false;
		this.up = true;
	}
	notclick() {
		this.touch = false;
		this.down = true;
		this.up = false;
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