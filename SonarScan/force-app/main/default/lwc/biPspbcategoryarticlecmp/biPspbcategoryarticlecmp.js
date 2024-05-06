// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
// To import Apex Classes
import retrieveMediaFromCMSNews from '@salesforce/apex/BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews';
import showfilterresponse from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
import getpersonalizedarticles from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles';
import { refreshApex } from '@salesforce/apex';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import statusunassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import statusuacute from '@salesforce/label/c.BI_PSPB_Acute';
import spcategoryone from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryOne';
import spcategorytwo from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryTwo';
import spcategoryoneval from '@salesforce/label/c.BI_PSPB_spArticleCategoryValOne';
import spcategorytwoval from '@salesforce/label/c.BI_PSPB_spArticleCategoryValTwo';
import statuschronic from '@salesforce/label/c.BI_PSPB_statusChronic';
import articlecategoryone from '@salesforce/label/c.BI_PSPB_articleCategoryOne';
import articlecategorytwo from '@salesforce/label/c.BI_PSPB_articleCategoryTwo';
import articlecategorythree from '@salesforce/label/c.BI_PSPB_articleCategoryThree';
import articlecategoryfour from '@salesforce/label/c.BI_PSPB_articleCategoryFour';
import articlecategoryfive from '@salesforce/label/c.BI_PSPB_articleCategoryFive';
import articlecategoryjustforme from '@salesforce/label/c.BI_PSPB_articleJustForMeCategory';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import categorypage from '@salesforce/label/c.BI_PSPB_BRInfoCenterCategoryPage';
import detailpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterDetailPage';
import searchpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterSearchPage';
import chronicpage from '@salesforce/label/c.BI_PSPB_chronicVideoPage';
import acutepage from '@salesforce/label/c.BI_PSPB_AcuteVideoPage';
import landingpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
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
import BI_PSPB_ArticleOneRT from '@salesforce/label/c.BI_PSPB_ArticleOneRT';
import BI_PSPB_ArticleTwoRT from '@salesforce/label/c.BI_PSPB_ArticleTwoRT';
import BI_PSPB_ArticleThreeRT from '@salesforce/label/c.BI_PSPB_ArticleThreeRT';
import BI_PSPB_ArticleFourRT from '@salesforce/label/c.BI_PSPB_ArticleFourRT';
import BI_PSPB_ArticleFiveRT from '@salesforce/label/c.BI_PSPB_ArticleFiveRT';
import BI_PSPB_ArticleSixRT from '@salesforce/label/c.BI_PSPB_ArticleSixRT';
import BI_PSPB_ArticleSevenRT from '@salesforce/label/c.BI_PSPB_ArticleSevenRT';
import BI_PSPB_ArticleEightRT from '@salesforce/label/c.BI_PSPB_ArticleEightRT';
import BI_PSPB_ArticleNineRT from '@salesforce/label/c.BI_PSPB_ArticleNineRT';
import BI_PSPB_ArticleTenRT from '@salesforce/label/c.BI_PSPB_ArticleTenRT';
import BI_PSPB_ArticleElevenRT from '@salesforce/label/c.BI_PSPB_ArticleElevenRT';
import BI_PSPB_ArticleTwelveRT from '@salesforce/label/c.BI_PSPB_ArticleTwelveRT';
import BI_PSPB_ArticleThirteenRT from '@salesforce/label/c.BI_PSPB_ArticleThirteenRT';
import BI_PSPB_ArticleFourteenRT from '@salesforce/label/c.BI_PSPB_ArticleFourteenRT';
import BI_PSPB_ArticleFifteenRT from '@salesforce/label/c.BI_PSPB_ArticleFifteenRT';
import BI_PSPB_ArticleSixteenRT from '@salesforce/label/c.BI_PSPB_ArticleSixteenRT';
import BI_PSPB_ArticleSeventeenRT from '@salesforce/label/c.BI_PSPB_ArticleSeventeenRT';
import BI_PSPB_ArticleEighteenRT from '@salesforce/label/c.BI_PSPB_ArticleEighteenRT';
import BI_PSPB_ArticleNineteenRT from '@salesforce/label/c.BI_PSPB_ArticleNineteenRT';
import BI_PSPB_ArticleTwentyRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyRT';
import BI_PSPB_ArticleTwentyOneRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyOneRT';
import BI_PSPB_ArticleTwentyTwoRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyTwoRT';
import BI_PSPB_ArticleTwentyThreeRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyThreeRT';
import BI_PSPB_ArticleTwentyFourRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyFourRT';
import BI_PSPB_ArticleTwentyFiveRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyFiveRT';
import BI_PSPB_ArticleTwentySixRT from '@salesforce/label/c.BI_PSPB_ArticleTwentySixRT';
import BI_PSPB_ArticleTwentySevenRT from '@salesforce/label/c.BI_PSPB_ArticleTwentySevenRT';
import BI_PSPB_ArticleTwentyEightRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyEightRT';
import BI_PSPB_ArticleTwentyNineRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyNineRT';
import articlestring from '@salesforce/label/c.BI_PSPB_ArticleString';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import testsitename from '@salesforce/label/c.BI_PSPB_TestsiteName';
import evententer from '@salesforce/label/c.BI_PSP_EventEnter';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspcategoryarticlecmp extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track showjustforme_sec = false;
	@track userId = Id;
	@track categorytreatmentnew;
	@track categorytreatmentnewadb;
	@track final = '';
	@track count = 1;
	@track finalresult = [];
	@track resulti = '';
	@track showsearch = false;
	@track styleofelement = '';
	@track category1;
	@track category2;
	@track category3;
	@track category4;
	@track category5;
	@track justformecategory;
	@track justformearticlelist = [];
	@track showloadmore = false;
	@track originalsearchitemsofsearch = [];
	@track currentlength;
	@track treatmentcategory;
	@track spevigoarticle;
	@track touch = false;
	@track down = true;
	@track up = false;
	@track patientstatusval = '';
	@track categorytreatment;
	@track image12 = [];
	@track searchitems = [];
	@track originalsearchitems = [];
	@track urlq;
	@track currentPageUrl;
	@track urlSegments;
	@track baseUrl;
	@track showbrandednav = true;
	@track spevigospace = false;
	@track results = [];
	@track result = [];
	// Global variables(without @track does not trigger automatic re-renders)
	image1;
	image2;
	image3;
	heading1;
	heading2;
	heading3;
	description1;
	description2;
	description3;
	threeDifferentNumbers;
	channelName = testsitename;
	siteurlq;
	topics = {
    [articleone]: [BI_PSPB_ArticleOneRT],
    [articletwo]: [BI_PSPB_ArticleTwoRT],
    [articlethree]: [BI_PSPB_ArticleThreeRT],
    [articlefour]: [BI_PSPB_ArticleFourRT],
    [articlefive]: [BI_PSPB_ArticleFiveRT],
    [articlesix]: [BI_PSPB_ArticleSixRT],
    [articleseven]: [BI_PSPB_ArticleSevenRT],
    [articleeight]: [BI_PSPB_ArticleEightRT],
    [articlenine]: [BI_PSPB_ArticleNineRT],
    [articleten]: [BI_PSPB_ArticleTenRT],
    [articleeleven]: [BI_PSPB_ArticleElevenRT],
    [articletwelve]: [BI_PSPB_ArticleTwelveRT],
    [articlethirteen]: [BI_PSPB_ArticleThirteenRT],
    [articlefourteen]: [BI_PSPB_ArticleFourteenRT],
    [articlefifteen]: [BI_PSPB_ArticleFifteenRT],
    [articlesixteen]: [BI_PSPB_ArticleSixteenRT],
    [articleseventeen]: [BI_PSPB_ArticleSeventeenRT],
    [articleeighteen]: [BI_PSPB_ArticleEighteenRT],
    [articlenineteen]: [BI_PSPB_ArticleNineteenRT],
    [articletwenty]: [BI_PSPB_ArticleTwentyRT],
    [articletwentyone]: [BI_PSPB_ArticleTwentyOneRT],
    [articletwentytwo]: [BI_PSPB_ArticleTwentyTwoRT],
    [articletwentythree]: [BI_PSPB_ArticleTwentyThreeRT],
    [articletwentyfour]: [BI_PSPB_ArticleTwentyFourRT],
    [articletwentyfive]: [BI_PSPB_ArticleTwentyFiveRT],
    [articletwentysix]: [BI_PSPB_ArticleTwentySixRT],
    [articletwentyseven]: [BI_PSPB_ArticleTwentySevenRT],
    [articletwentyeight]: [BI_PSPB_ArticleTwentyEightRT],
    [articletwentynine]: [BI_PSPB_ArticleTwentyNineRT]
}
	searchTerm = '';
	relatedItems = [];

	// To retrieve current site url
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
				this.siteurlq = brandedsiteurl;
			} else {
				this.urlq = unassignedurl;
				this.siteurlq = unassignedsiteurl;
			}
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split('/');
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;

			if (this.urlq === brandedurl) {
				if (
					this.patientstatusval === statusuacute ||
					this.patientstatusval === statuschronic
				) {
					this.showbrandednav = true;
				} else {
					this.showbrandednav = false;
				}
			} else {
				this.showbrandednav = true;

				if (this.patientstatusval === statusuacute) {
					this.showbrandednav = true;
				} else if (this.patientstatusval === statusunassigned) {
					this.showbrandednav = false;
				} else {
					this.showbrandednav = true;
				}
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// To navigate to information center landing page
	openArticlesPage() {
		window.location.assign(this.siteurlq + landingpage);
	}

	// To navigate to acute or chronic customized video page
	openPTVPage() {
		if (this.patientstatusval === statusuacute) {
			window.location.assign(this.siteurlq + acutepage);
			this.categorytreatmentnew = spcategorytwo;
			this.categorytreatmentnewadb = spcategorytwoval;
		} else if (this.patientstatusval === statuschronic) {
			if (this.urlq === brandedurl) {
				window.location.assign(this.siteurlq + chronicpage);
			} else {
				window.location.assign(this.siteurlq + acutepage);
			}
			this.categorytreatmentnew = spcategoryone;
			this.categorytreatmentnewadb = spcategoryoneval;
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve patient status (acute or chronic or unassigned)
	wiredstatusofpatient;
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;

				if (this.patientstatusval === statusuacute) {
					if (this.urlq !== brandedurl || this.urlq === brandedurl) {
						this.showbrandednav = true;
					}
					this.categorytreatmentnew = spcategorytwo;
					this.categorytreatmentnewadb = spcategorytwoval;
				} else if (this.patientstatusval === statuschronic) {
					this.showbrandednav = true;

					this.categorytreatmentnew = spcategoryone;
					this.categorytreatmentnewadb = spcategoryoneval;
				} else if (this.patientstatusval === statusunassigned) {
					this.showbrandednav = false;
				} else if (this.urlq === brandedurl) {
					if (this.patientstatusval === statuschronic) {
						this.showbrandednav = true;
						this.categorytreatmentnew = spcategoryone;
						this.categorytreatmentnewadb = spcategoryoneval;
					}
				} else {
					if (this.patientstatusval === statusunassigned) {
						this.showbrandednav = false;
					} else {
						this.showbrandednav = true;
						this.categorytreatmentnew = spcategorytwo;
						this.categorytreatmentnewadb = spcategorytwoval;
					}
				}

				// Handle the data
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			} else {
				this.patientstatusval = statusuacute;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	/* If user having null assessment record then disabled the just for me navigation */
	// To retrieve lets personalized questionaires assessment data
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

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the personalized articles based on letspersonalize questionaires
	@wire(getpersonalizedarticles, { channelName: '$channelName' })
	wiredarticleData({ error, data }) {
		try {
			if (data) {
				this.justformearticlelist = [articleeighteen];

				this.justformearticlelist = JSON.parse(JSON.stringify(data));
			} else if (error) {
				this.error = error;
				this.results = undefined;
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);// Catching Potential Error from Lwc
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the CMS article contents
	@wire(retrieveMediaFromCMSNews, { channelName: '$channelName' })
	wiredData({ error, data }) {
		try {
			if (data) {
				let objStr = JSON.parse(data);

				objStr.map((element) => {
					const timestamp = new Date().getTime();
					const cbValue = `cb=${timestamp}`;

					this.results = [
						...this.results,
						{
							image: element.url + '?' + cbValue,
							text: element.title,
							text2: element.subtitle,
							page: element.url,
							articlehe: articlestring + ' ' + element.title
						}
					];
					return this.results;
				});
				if (this.results.length > 0) {
					this.image12 = this.results;
					this.originalsearchitems = this.results;
					this.error = undefined;
					this.image12 = this.results;
					this.image12 = this.results;
					this.pageReferenceLogic();
				} else if (error) {
					this.error = error;
					this.results = undefined;
				}
			}
			else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Lwc
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);// Catching Potential Error
		}
	}

	// To refresh the status of patient
	refreshData() {
		return refreshApex(this.wiredstatusofpatient);
	}

	// Clear search input
	clearinput() {
		const inputElement = this.template.querySelector('.search-bar');
		if (inputElement) {
			inputElement.value = '';
		}
	}

	// Filter the articles without repetition
	getRandomElementsWithoutRepetition(arr, count, selectedTopics) {
		const shuffled = arr.sort(() => 0.5 - Math.random());
		const selectedQuestions = [];

		for (const question of shuffled) {
			const topic = question.split(' ')[0]; // Extract the first word as the topic

			selectedTopics.push(topic);
			selectedQuestions.push(question);

			if (selectedQuestions.length === count) {
				break; // Stop when the required number of questions is reached
			}
		}

		//Remove Spevigo articles if it is unassigned

		if (this.urlq === this.siteurlq) {
			if (this.patientstatusval !== statusuacute) {
				if (selectedQuestions.indexOf(articletwentyseven) !== -1) {
					selectedQuestions.splice(
						selectedQuestions.indexOf(articletwentyseven),
						1
					);
				}
				if (selectedQuestions.indexOf(articletwentyeight) !== -1) {
					this.searchitems.splice(
						selectedQuestions.indexOf(articletwentyeight),
						1
					);
				}
				if (selectedQuestions.indexOf(articletwentysix) !== -1) {
					selectedQuestions.splice(
						selectedQuestions.indexOf(articletwentysix),
						1
					);
				}
				if (selectedQuestions.indexOf(articletwentyfive) !== -1) {
					selectedQuestions.splice(
						selectedQuestions.indexOf(articletwentyfive),
						1
					);
				}
				if (selectedQuestions.indexOf(articletwentynine) !== -1) {
					selectedQuestions.splice(
						selectedQuestions.indexOf(articletwentynine),
						1
					);
				}
			}
		}

		return selectedQuestions;
	}

	// Filter the articles based on titles
	filterResultsByTitles(titlesToFilter) {
		let shuffledResults;

		if (this.resulti === articlecategoryjustforme) {
			shuffledResults = this.shuffleArray(this.results);
		} else {
			shuffledResults = this.results;
		}

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
				result.readtime=this.topics[result.text];
				filteredResults.push(result);
			}
		}

		return filteredResults;
	}

	shuffleArray(array) {
		const shuffled = array.slice(); // Create a copy of the original array
		for (let i = shuffled.length - 1; i > 0; i--) {
			const j = Math.floor(Math.random() * (i + 1));
			[shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]]; // Swap elements
		}
		return shuffled;
	}

	// To filter the articles and map their categories.
	pageReferenceLogic() {
		this.showsearch = false;
		this.searchitems = [];
		this.count = 1;
		const finaltitle = this.resulti;
		this.final = finaltitle;

		if (this.final === articlecategoryjustforme) {
			const selectedQuestions = this.getRandomElementsWithoutRepetition(
				this.justformearticlelist,
				this.justformearticlelist.length,
				[]
			);
			if (selectedQuestions) {
				this.searchitems = this.filterResultsByTitles(selectedQuestions);
				this.showsearch = true;
			}

			if (finaltitle === articlecategoryjustforme) {
				this.category1 = 'end-btn';
				this.category2 = 'end-btn';
				this.category3 = 'end-btn';
				this.category4 = 'end-btn';
				this.category5 = 'end-btn';
				this.justformecategory = 'end-btn-selected';
				this.treatmentcategory = 'end-btn';
			} else if (finaltitle === spcategorytwo || finaltitle === spcategoryone) {
				this.category1 = 'end-btn';
				this.category2 = 'end-btn';
				this.category3 = 'end-btn';
				this.category4 = 'end-btn';
				this.category5 = 'end-btn';
				this.justformecategory = 'end-btn';
				this.treatmentcategory = 'end-btn-selected';
			}

			this.showloadmore = true;

			this.currentlength = 3;
			this.originalsearchitemsofsearch = this.searchitems;
			this.searchitems = this.originalsearchitemsofsearch.slice(
				0,
				this.currentlength
			);

			if (this.currentlength < this.originalsearchitemsofsearch.length) {
				this.showloadmore = true;
			} else {
				this.showloadmore = false;
			}
		} else if (finaltitle === spcategorytwo || finaltitle === spcategoryone) {
			if (finaltitle === spcategorytwo) {
				this.spevigoarticle = [
					articletwentyfive,
					articletwentysix,
					articletwentynine
				];
			} else {
				this.spevigoarticle = [
					articletwentyseven,
					articletwentyeight,
					articletwentynine
				];
			}
			const selectedQuestions = this.getRandomElementsWithoutRepetition(
				this.spevigoarticle,
				this.spevigoarticle.length,
				[]
			);
			if (selectedQuestions) {
				this.searchitems = this.filterResultsByTitles(selectedQuestions);
				this.showsearch = true;

				this.showloadmore = true;

				this.currentlength = 3;
				this.originalsearchitemsofsearch = this.searchitems;
				this.searchitems = this.originalsearchitemsofsearch.slice(
					0,
					this.currentlength
				);

				if (this.currentlength < this.originalsearchitemsofsearch.length) {
					this.showloadmore = true;
				} else {
					this.showloadmore = false;
				}
			}

			this.category1 = 'end-btn';
			this.category2 = 'end-btn';
			this.category3 = 'end-btn';
			this.category4 = 'end-btn';
			this.category5 = 'end-btn';
			this.justformecategory = 'end-btn';
			this.treatmentcategory = 'end-btn-selected';
		} else {
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
				[articlecategoryjustforme]: []
			};

			if (finaltitle === articlecategoryone) {
				this.category1 = 'end-btn-selected';
				this.category2 = 'end-btn';
				this.category3 = 'end-btn';
				this.category4 = 'end-btn';
				this.category5 = 'end-btn';
				this.justformecategory = 'end-btn';
				this.treatmentcategory = 'end-btn';
			}

			if (finaltitle === articlecategorytwo) {
				this.category1 = 'end-btn';
				this.category2 = 'end-btn-selected';
				this.category3 = 'end-btn';
				this.category4 = 'end-btn';
				this.category5 = 'end-btn';
				this.justformecategory = 'end-btn';
				this.treatmentcategory = 'end-btn';
			}

			if (finaltitle === articlecategorythree) {
				this.category1 = 'end-btn';
				this.category2 = 'end-btn';
				this.category3 = 'end-btn-selected';
				this.category4 = 'end-btn';
				this.category5 = 'end-btn';
				this.justformecategory = 'end-btn';
				this.treatmentcategory = 'end-btn';
			}

			if (finaltitle === articlecategoryfour) {
				this.category1 = 'end-btn';
				this.category2 = 'end-btn';
				this.category3 = 'end-btn';
				this.category4 = 'end-btn-selected';
				this.category5 = 'end-btn';
				this.justformecategory = 'end-btn';
				this.treatmentcategory = 'end-btn';
			}

			if (finaltitle === articlecategoryfive) {
				this.category1 = 'end-btn';
				this.category2 = 'end-btn';
				this.category3 = 'end-btn';
				this.category4 = 'end-btn';
				this.category5 = 'end-btn-selected';
				this.justformecategory = 'end-btn';
				this.treatmentcategory = 'end-btn';
			}
			if (finaltitle === articlecategoryjustforme) {
				this.category1 = 'end-btn';
				this.category2 = 'end-btn';
				this.category3 = 'end-btn';
				this.category4 = 'end-btn';
				this.category5 = 'end-btn';
				this.justformecategory = 'end-btn-selected';
				this.treatmentcategory = 'end-btn';
			}

			if (finaltitle === spcategorytwo || finaltitle === spcategoryone) {
				this.category1 = 'end-btn';
				this.category2 = 'end-btn';
				this.category3 = 'end-btn';
				this.category4 = 'end-btn';
				this.category5 = 'end-btn';
				this.justformecategory = 'end-btn';
				this.treatmentcategory = 'end-btn-selected';
			}

			const titlesToFilter = titlesMap[finaltitle];
			if (titlesToFilter) {
				this.searchitems = this.filterResultsByTitles(titlesToFilter);
				this.showsearch = true;
			}
		}
	}

	// To load the category page based on current category
	// We are unable to utilize "data" or "error" as CurrentPageReference is default API.
	@wire(CurrentPageReference)
	pageReference({ state }) {
		try {
			if (state && state.id) {
				this.resulti = state.id;
				this.showsearch = false;
				this.searchitems = [];
				this.count = 1;
				const finaltitle = state.id;
				this.final = finaltitle;
				if (this.final === spcategorytwo || this.final === spcategoryone) {
					this.spevigospace = true;
				}
				if (
					finaltitle === articlecategoryone ||
					finaltitle === articlecategorythree ||
					finaltitle === articlecategorytwo ||
					finaltitle === articlecategoryfour
				) {
					this.styleofelement =
						'position: absolute; transform: translate(-40%, -40%); margin-left: 750px;';
				} else if (finaltitle === articlecategoryjustforme) {
					this.styleofelement =
						'position: absolute; transform: translate(-60%, -70%); margin-left: 900px;';
				} else {
					this.styleofelement =
						'position: absolute; transform: translate(-50%, -50%); margin-left: 800px;';
				}
				if (this.final === articlecategoryjustforme) {
					const selectedQuestions = this.getRandomElementsWithoutRepetition(
						this.justformearticlelist,
						this.justformearticlelist.length,
						[]
					);
					if (selectedQuestions) {
						this.searchitems = this.filterResultsByTitles(selectedQuestions);
						this.showsearch = true;
					}
					if (finaltitle === articlecategoryjustforme) {
						this.category1 = 'end-btn';
						this.category2 = 'end-btn';
						this.category3 = 'end-btn';
						this.category4 = 'end-btn';
						this.category5 = 'end-btn';
						this.justformecategory = 'end-btn-selected';
					} else if (
						finaltitle === spcategorytwo ||
						finaltitle === spcategoryone
					) {
						this.category1 = 'end-btn';
						this.category2 = 'end-btn';
						this.category3 = 'end-btn';
						this.category4 = 'end-btn';
						this.category5 = 'end-btn';
						this.justformecategory = 'end-btn';
						this.treatmentcategory = 'end-btn-selected';
					}
				} else {
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
						[articlecategoryjustforme]: []
					};

					if (finaltitle === articlecategoryone) {
						this.category1 = 'end-btn-selected';
						this.category2 = 'end-btn';
						this.category3 = 'end-btn';
						this.category4 = 'end-btn';
						this.category5 = 'end-btn';
						this.justformecategory = 'end-btn';
					}

					if (finaltitle === articlecategorytwo) {
						this.category1 = 'end-btn';
						this.category2 = 'end-btn-selected';
						this.category3 = 'end-btn';
						this.category4 = 'end-btn';
						this.category5 = 'end-btn';
						this.justformecategory = 'end-btn';
					}

					if (finaltitle === articlecategorythree) {
						this.category1 = 'end-btn';
						this.category2 = 'end-btn';
						this.category3 = 'end-btn-selected';
						this.category4 = 'end-btn';
						this.category5 = 'end-btn';
						this.justformecategory = 'end-btn';
					}

					if (finaltitle === articlecategoryfour) {
						this.category1 = 'end-btn';
						this.category2 = 'end-btn';
						this.category3 = 'end-btn';
						this.category4 = 'end-btn-selected';
						this.category5 = 'end-btn';
						this.justformecategory = 'end-btn';
					}

					if (finaltitle === articlecategoryfive) {
						this.category1 = 'end-btn';
						this.category2 = 'end-btn';
						this.category3 = 'end-btn';
						this.category4 = 'end-btn';
						this.category5 = 'end-btn-selected';
						this.justformecategory = 'end-btn';
					}
					if (finaltitle === articlecategoryjustforme) {
						this.category1 = 'end-btn';
						this.category2 = 'end-btn';
						this.category3 = 'end-btn';
						this.category4 = 'end-btn';
						this.category5 = 'end-btn';
						this.justformecategory = 'end-btn-selected';
					}

					if (finaltitle === spcategorytwo || finaltitle === spcategoryone) {
						this.category1 = 'end-btn';
						this.category2 = 'end-btn';
						this.category3 = 'end-btn';
						this.category4 = 'end-btn';
						this.category5 = 'end-btn';
						this.justformecategory = 'end-btn';
						this.treatmentcategory = 'end-btn-selected';
					}

					const titlesToFilter = titlesMap[finaltitle];
					if (titlesToFilter) {
						this.searchitems = this.filterResultsByTitles(titlesToFilter);
						this.showsearch = true;
					}
				}
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}
	}
	handleButtonClick(event) {
		const finaltitle = event.currentTarget.dataset.name;
		window.location.href =
			this.baseUrl + this.siteurlq + detailpage + finaltitle;
	}
	handleNavigation(event) {
		const searchiteml = event.currentTarget.dataset.name;

		window.location.href =
			this.baseUrl + this.siteurlq + searchpage + searchiteml;
	}
	handleSearch(event) {
		const searchTerm = event.target.value.toLowerCase();

		if (event.key === evententer && searchTerm) {
			window.location.href =
				this.baseUrl + this.siteurlq + searchpage + searchTerm;
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

	handlesubmit(event) {
		this.count = 1;
		const finaltitle = event.currentTarget.dataset.name;
		// this.final = finaltitle;
		const articlename = finaltitle;
		window.location.href =
			this.baseUrl + this.siteurlq + categorypage + articlename;
	}
	loadmore() {
		this.currentlength = this.currentlength + 3;
		this.searchitems = this.originalsearchitemsofsearch.slice(
			0,
			this.currentlength
		);
		if (this.currentlength < this.originalsearchitemsofsearch.length) {
			this.showloadmore = true;
		} else {
			this.showloadmore = false;
		}
	}

	handleSearchBarFocus() {
		if (window.innerWidth > 1115) {
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
	}

	handleSearchBarBlur() {
		if (window.innerWidth > 1115) {
			this.template.querySelector(
				'hr.search-bar-border-bottom'
			).style.borderColor = 'rgba(105, 105, 105, 1)';
			this.template.querySelector(
				'hr.search-bar-border-bottom'
			).style.borderWidth = '2px';
			this.template.querySelector(
				'hr.search-bar-border-bottom'
			).style.transition = '0.1s';
		}
	}

	// Rendering the category names of the articles for mobile responsiveness.
	renderedCallback() {
		try {
			// Check the condition

			const windowWidth = window.innerWidth;
			const displayvideotab = this.template.querySelector(
				'.grid-containerNavTab'
			);

			if (windowWidth <= 1000) {
				const category = this.template.querySelector('.subheading');
				const display_div = this.template.querySelector('.display');
				if (this.final === articlecategorytwo) {
					if (category !== null) {
						category.style.marginLeft = '-41px';
					}
					if (display_div) {
						display_div.style.width = '154%';
					}
				}
				if (this.final === articlecategorythree) {
					if (category) {
						category.style.marginLeft = '-72px';
					}
					if (display_div) {
						display_div.style.width = '166%';
					}
				}
				if (this.final === articlecategoryfour) {
					if (category) {
						category.style.marginLeft = '-74px';
					}
					if (display_div) {
						display_div.style.width = '166%';
					}
				}
				if (this.final === articlecategoryfive) {
					if (category) {
						category.style.marginLeft = '-38px';
					}
					if (display_div) {
						display_div.style.width = '151%';
					}
					if (category) {
						category.style.width = '62%';
					}
				}
				if (this.final === spcategorytwo) {
					if (category) {
						category.style.marginLeft = '-49px';
					}
					if (display_div) {
						display_div.style.width = '157%';
					}
				}
				if (this.final === spcategoryone) {
					if (category) {
						category.style.marginLeft = '-48px';
					}
					if (display_div) {
						display_div.style.width = '156%';
					}
				}
				if (this.final === articlecategoryone) {
					if (category) {
						category.style.marginLeft = '-103px';
					}
					if (display_div) {
						display_div.style.width = '178%';
					}
				}
				if (this.final === articlecategoryjustforme) {
					if (category) {
						category.style.marginLeft = '-111px';
					}
					if (display_div) {
						display_div.style.width = '182%';
					}
				}

				if (displayvideotab) {
					displayvideotab.style.display = 'none';
				}
			} else {
				if (displayvideotab) {
					displayvideotab.style.display = '';
				}
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
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