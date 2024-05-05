// This lightning web component is used for display the related articles of selected articles category
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
import retrieveMediaFromCMSNews from '@salesforce/apex/BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews';
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
import statuschronic from '@salesforce/label/c.BI_PSPB_statusChronic';
import chroniccategory from '@salesforce/label/c.BI_PSPB_chronicCategory';
import acutecategory from '@salesforce/label/c.BI_PSPB_acuteCategory';
import testsite from '@salesforce/label/c.BI_PSPB_TestsiteName';
import statusacute from '@salesforce/label/c.BI_PSPB_Acute';
import articlestring from '@salesforce/label/c.BI_PSPB_ArticleString';
import sparticlecategorytwo from '@salesforce/label/c.BI_PSPB_spArticleCategoryValTwo';
import sparticlecategoryone from '@salesforce/label/c.BI_PSPB_spArticleCategoryValOne';
import articlecategoryvalone from '@salesforce/label/c.BI_PSPB_articleCategoryValOne';
import articlecategoryvaltwo from '@salesforce/label/c.BI_PSPB_articleCategoryValTwo';
import articlecategoryvalthree from '@salesforce/label/c.BI_PSPB_articleCategoryValThree';
import articlecategoryvalfour from '@salesforce/label/c.BI_PSPB_articleCategoryValFour';
import articlecategoryvalfive from '@salesforce/label/c.BI_PSPB_articleCategoryValFive';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import statusunassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import detailpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterDetailPage';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbrecentarticles extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track currentIndex = 0;
	@track isDisabledprev;
	@track isDisablednext;
	@track titlear;
	@track prevpage;
	@track nextpage;
	@track categoryval;
	@track categoryarticlelist = [];
	@track image12 = [];
	@track results = [];
	@track result = [];
	@track patientstatusval;
	@track categorytreatmentnew;
	@track articlenamedata = '';
	@track urlq;
	@track currentPageUrl;
	@track urlSegments;
	@track baseUrl;
	@track showbrandednav = true;
	// Global variables(without @track does not trigger automatic re-renders)
	siteUrlq;
	searchTerm = '';
	relatedItems = [];
	image1;
	image2;
	image3;
	image4;
	heading1;
	heading2;
	heading3;
	nextpagear;
	prevpagear;
	userid = Id;
	arheading1;
	arheading2;
	arheading3;
	description1;
	description2;
	description3;
	threeDifferentNumbers;
	submittedRecord;
	searchitems = [];
	originalsearchitems = [];
	standarItems = [];
	articletoincludespevigo = [];
	channelName = testsite;
	
	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the CMS article content
	@wire(retrieveMediaFromCMSNews, { channelName: '$channelName' })
	wiredData({ error, data }) {
		try {
			if (data) {
				let objStr = JSON.parse(data);

				const timestamp = new Date().getTime();
				const cbValue = `cb=${timestamp}`;

				objStr.map((element) => {
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

					if (this.titlear === articletwentynine) {
						if (this.patientstatusval === statusacute) {
							this.categoryarticlelist = [
								articletwentyfive,
								articletwentysix,
								articletwentynine
							];
						} else if (this.patientstatusval === statuschronic) {
							this.categoryarticlelist = [
								articletwentyseven,
								articletwentyeight,
								articletwentynine
							];
						}
					}

					let articleToRemove = this.titlear;

					let newList = [];
					this.categoryarticlelist.forEach((item) => {
						if (item !== articleToRemove) {
							newList.push(item);
						}
					});

					this.categoryarticlelist = newList;

					let testdata = this.filterResultsByTitles(this.categoryarticlelist);
					this.image12 = testdata;
					if (this.urlq !== brandedurl || this.urlq.length !== 0) {
						if (this.patientstatusval === statusunassigned) {
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
						if (this.patientstatusval === statusacute) {
							const filteredDataacute = this.image12.filter(
								(entry) =>
									entry.text !== articletwentyseven &&
									entry.text !== articletwentyeight
							);
							this.image12 = filteredDataacute;
						}
						if (this.patientstatusval === statuschronic) {
							const filteredDatachronic = this.image12.filter(
								(entry) =>
									entry.text !== articletwentysix &&
									entry.text !== articletwentyfive
							);
							this.image12 = filteredDatachronic;
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
					if (
						this.categoryval !== chroniccategory &&
						this.categoryval !== acutecategory
					) {
						if (this.image12[this.threeDifferentNumbers[2]]) {
							this.image3 = this.image12[this.threeDifferentNumbers[2]].image;
							this.heading3 = this.image12[this.threeDifferentNumbers[2]].text;
							this.description3 =
								this.image12[this.threeDifferentNumbers[2]].text2;
							this.arheading3 = articlestring + ' ' + this.heading3;
						}
					}
					this.arheading1 = articlestring + ' ' + this.heading1;
					this.arheading2 = articlestring + ' ' + this.heading2;
				}

				this.error = undefined;
				this.image12 = this.results;

				this.image12 = this.results;
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);  // Catching Potential Error from Apex
				this.results = [];
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);  // Catching Potential Error from Lwc
		}
	}

	// Getter function to determine whether to display the category value for Spevigo.
	get spevigocategoryval() {
		if (
			this.categoryval === chroniccategory ||
			this.categoryval === acutecategory
		) {
			return false;
		}
		return true;
	}

	// Getter method to determine the class of the button
	get classofbutton() {
		if (this.heading1 === articleeleven) {
			return "button-disable";
		}
		return "borderless-button";
	}

	// Method to generate random numbers based on length of the article list
	generateRandomNumbers() {
		const len = this.categoryarticlelist.length;

		const numbers = new Set();
		while (numbers.size < len) {
			const randomNumber = Math.floor(Math.random() * len); // Generates numbers from 0 to 8
			numbers.add(randomNumber);
		}
		return Array.from(numbers);
	}

	// To navigate article detail page
	handleButtonClick(event) {
		const finaltitle = event.currentTarget.dataset.name;

		const articlename = finaltitle;
		window.location.href =
			this.baseUrl + this.siteUrlq + detailpage + articlename;
	}

	// Generate a random number between 2 and 4 (inclusive)
	get dynamicProperty() {
		const newRandomNumber = Math.floor(Math.random() * 3) + 2;
		return newRandomNumber;
	}

	// Wire method to capture the current page reference and extract the state id value
	// We are unable to utilize "data" or "error" as CurrentPageReference is default API.
	@wire(CurrentPageReference)
	pageReference({ state }) {
		try {
			if (state && state.id) {
				this.articlenamedata = state.id;
				this.titlear = state.id;
				const titlesMap = {
					[articlecategoryvalone]: [
						articlethree,
						articletwo,
						articleone,
						articlesix,
						articlefour
					],
					[articlecategoryvaltwo]: [
						articletwentytwo,
						articletwentythree,
						articlefive,
						articleeight,
						articleseven
					],
					[articlecategoryvalthree]: [
						articletwelve,
						articletwenty,
						articlefourteen,
						articlefifteen,
						articletwentyone
					],
					[articlecategoryvalfour]: [
						articletwentyfour,
						articleten,
						articlenine,
						articlesixteen,
						articleeighteen
					],
					[articlecategoryvalfive]: [
						articlenineteen,
						articleeleven,
						articlethirteen,
						articleseventeen
					],
					[acutecategory]: [
						articletwentyfive,
						articletwentysix,
						articletwentynine
					],
					[chroniccategory]: [
						articletwentyseven,
						articletwentyeight,
						articletwentynine
					]
				};

				for (const key in titlesMap) {
					if (titlesMap[key].includes(this.titlear)) {
						this.categoryval = key;
						break;
					}
				}

				this.categoryarticlelist = titlesMap[this.categoryval];

				const topics = [
					articlethree,
					articletwo,
					articleone,
					articlesix,
					articlefour,
					articletwentytwo,
					articletwentythree,
					articlefive,
					articleeight,
					articleseven,
					articletwelve,
					articletwenty,
					articlefourteen,
					articlefifteen,
					articletwentyone,
					articletwentyfour,
					articleten,
					articlenine,
					articlesixteen,
					articleeighteen,
					articlenineteen,
					articleeleven,
					articlethirteen,
					articleseventeen
				];

				const index = topics.indexOf(this.titlear);
				if (index === 0) {
					this.isDisabledprev = "button-disable";
					this.isDisablednext = "borderless-button-next";

					this.nextpage = topics[index + 1];
				} else if (index === topics.length - 1) {
					this.isDisabledprev = "borderless-button";
					this.isDisablednext = "button-disable";
					this.prevpage = topics[index - 1];
				} else {
					this.isDisabledprev = "borderless-button";
					this.isDisablednext = "borderless-button-next";
					this.prevpage = topics[index - 1];
					this.nextpage = topics[index + 1];
				}
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);  // Catching Potential Error
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve patient status value
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;
				if (this.patientstatusval === statusacute) {
					this.categorytreatmentnew = sparticlecategorytwo;
				} else if (this.patientstatusval === statuschronic) {
					this.categorytreatmentnew = sparticlecategoryone;
				}

				if (this.articlenamedata) {
					this.titlear = this.articlenamedata;
					const topics = [
						articlethree,
						articletwo,
						articleone,
						articlesix,
						articlefour,
						articletwentytwo,
						articletwentythree,
						articlefive,
						articleeight,
						articleseven,
						articletwelve,
						articletwenty,
						articlefourteen,
						articlefifteen,
						articletwentyone,
						articletwentyfour,
						articleten,
						articlenine,
						articlesixteen,
						articleeighteen,
						articlenineteen,
						articleeleven,
						articlethirteen,
						articleseventeen
					];

					if (this.urlq === brandedurl) {
						if (this.categorytreatmentnew === sparticlecategorytwo) {
							topics.push(articletwentyfive);
							topics.push(articletwentysix);
							topics.push(articletwentynine);
						} else {
							topics.push(articletwentyseven);
							topics.push(articletwentyeight);
							topics.push(articletwentynine);
						}
					} else {
						if (this.patientstatusval === statusacute) {
							topics.push(articletwentyfive);
							topics.push(articletwentysix);
							topics.push(articletwentynine);
						}
						if (this.patientstatusval === statuschronic) {
							topics.push(articletwentyseven);
							topics.push(articletwentyeight);
							topics.push(articletwentynine);
						}
					}

					const index = topics.indexOf(this.titlear);
					if (index === 0) {
						this.isDisabledprev = "button-disable";
						this.isDisablednext = "borderless-button-next";

						this.nextpage = topics[index + 1];
					} else if (index === topics.length - 1) {
						this.isDisabledprev = "borderless-button";
						this.isDisablednext = "button-disable";
						this.prevpage = topics[index - 1];
					} else {
						this.isDisabledprev = "borderless-button";
						this.isDisablednext = "borderless-button-next";
						this.prevpage = topics[index - 1];
						this.nextpage = topics[index + 1];
					}
					this.nextpagear = articlestring + ' ' + this.nextpage;
					this.prevpagear = articlestring + ' ' + this.prevpage;
				}

				// Handle the data
			} else if (error) {
				// Handle the error
				this.showToast(errormessage, error.body.message, errorvariant);  // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);  // Catching Potential Error from Lwc
		}
	}

	// To get the site name from the Current site url
	connectedCallback() {
		try {
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
				this.showbrandednav = true;
			} else {
				this.showbrandednav = false;
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);  // Catching Potential Error
		}
	}

	// Filter the article by given title
	filterResultsByTitles(titlesToFilter) {
		let shuffledResults;

		shuffledResults = this.results;

		const filteredResults = [];
		let count = 1;

		for (let i = 0; i < shuffledResults.length; i++) {
			const result = shuffledResults[i];
			let titleFound = false;

			for (let j = 0; j < titlesToFilter.length; j++) {
				if (
					result.text.trim().toLowerCase() ===
					titlesToFilter[j].trim().toLowerCase()
				) {
					titleFound = true;
					break;
				}
			}

			if (titleFound) {
				result.count = count % 2 !== 0;
				count += 1;
				filteredResults.push(result);
			}
		}

		return filteredResults;
	}

	// To render the article previous button and next button 
	renderedCallback() {
		try {
			//code
			if (window.innerWidth < 1115) {
				if (this.titlear === articlethree) {
					let styleofprenbtn = this.template.querySelector(".prenxtutton");
					styleofprenbtn.style.marginLeft = "-20%";
				}
				if (this.isDisablednext === "button-disable") {
					let styleofnxbtn = this.template.querySelector(".button-disable");
					styleofnxbtn.style.marginLeft = "58%";
				}
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);  // Catching Potential Error
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