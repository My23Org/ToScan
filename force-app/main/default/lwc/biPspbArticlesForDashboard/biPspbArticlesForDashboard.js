// This Lightning Web Component is designed to display both 'Just for Me' articles and recent articles from the CMS
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
//To import Apex Classes
import retrieveMediaFromCMSNews from '@salesforce/apex/BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
import getpersonalizedarticles from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.getpersonalizedarticles';
import updatereaction from '@salesforce/apex/BI_PSPB_CmsCtrl.updatereaction';
//To import Static Resource
import CLIcon from '@salesforce/resourceUrl/BI_PSP_ClockIcon';
import CLNxIcon from '@salesforce/resourceUrl/BI_PSP_RoundNextIcon';
//To get Current UserId
import Id from '@salesforce/user/Id';
//To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import acute from '@salesforce/label/c.BI_PSPB_Acute';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import articletwentyseven from '@salesforce/label/c.BI_PSPB_articleTwentySeven';
import articletwentyeight from '@salesforce/label/c.BI_PSPB_articleTwentyEight';
import articletwentysix from '@salesforce/label/c.BI_PSPB_articleTwentySix';
import articletwentyfive from '@salesforce/label/c.BI_PSPB_articleTwentyFive';
import articletwentynine from '@salesforce/label/c.BI_PSPB_articleTwentyNine';
import unassignedval from '@salesforce/label/c.BI_PSP_Unassigned';
import spcategoryone from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryOne';
import spcategorytwo from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryTwo';
import chronicstatus from '@salesforce/label/c.BI_PSPB_statusChronic';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import testsite from '@salesforce/label/c.BI_PSPB_TestsiteName';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brandedsiteurlq from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurlq from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import detailpageinfocenter from '@salesforce/label/c.BI_PSPB_BRInfoCenterDetailPage';
import landingpageinfocenter from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
import articlestring from '@salesforce/label/c.BI_PSPB_ArticleString';
import viewlabel from '@salesforce/label/c.BI_PSPB_View';
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

export default class BiPspbArticlesForDashboard extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track urlq;
	@track showtreatvideo;
	@track patientstatusval;
	@track categoryval;
	@track justformearticlelist = [];
	@track results = [];
	//Global variables(without @track does not trigger automatic re-renders)
	userid = Id;
	ClockIcon = CLIcon;
	NextIcon = CLNxIcon;
	currentPageUrl;
	urlSegments;
	baseUrl;
	channelName = testsite;
	image1;
	image2;
	image3;
	image4;
	heading1;
	heading2;
	heading3;
	heading4;
	arheading1;
	arheading2;
	arheading3;
	arheading4;
	description1;
	description2;
	description3;
	description4;
	threeDifferentNumbers;
	submittedRecord;
	showarticle1 = true;
	showarticle2 = true;
	showarticle3 = true;
	showarticle4 = true;
	readtime1;
	readtime2;
	readtime3;
	readtime4;
	siteurl;
	titlear;
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

	// This renderedCallback function updates the dynamic images for backgrounds based on the articles being displayed.
	renderedCallback() {
		try {
			let imgele1 = this.template.querySelector('.backimg1');
			let imgele2 = this.template.querySelector('.backimg2');
			let imgele3 = this.template.querySelector('.backimg3');
			let imgele4 = this.template.querySelector('.backimg4');
			if (imgele1) {
				imgele1.style.backgroundImage = "url('" + this.image1 + "')";
			}
			if (imgele2) {
				imgele2.style.backgroundImage = "url('" + this.image2 + "')";
			}
			if (imgele3) {
				imgele3.style.backgroundImage = "url('" + this.image3 + "')";
			}
			if (imgele4) {
				imgele4.style.backgroundImage = "url('" + this.image4 + "')";
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}
	}
	// To generate the random number basded on article list length
	generateRandomNumbers() {
		const numbers = new Set();
		while (numbers.size < this.image12.length) {
			const randomNumber = Math.floor(Math.random() * this.image12.length); // Generates numbers from 0 to 8
			numbers.add(randomNumber);
		}
		return Array.from(numbers);
	}

	//To get site url
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
				this.siteurl = brandedsiteurlq;
			} else {
				this.urlq = unassignedurl;
				this.siteurl = unassignedsiteurlq;
			}
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split('/');
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	handleButtonClick(event) {
		const finaltitle = event.currentTarget.dataset.name;
		const articlename = finaltitle;
		updatereaction({
			articlename: articlename, reaction: viewlabel
		})
			.then(() => {
				this.titlear = viewlabel+ ': ' + articlename;
			})
			.catch((error) => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
				// Handle error, if needed
			});
		if (this.urlq === brandedurl) {
			window.location.assign(
				this.baseUrl + this.siteurl + detailpageinfocenter + articlename
			);
		} else {
			window.location.assign(
				this.baseUrl + this.siteurl + detailpageinfocenter + articlename
			);
		}
	}

	// Used for navigation to landing page of information center
	navtoinforcenter() {
		if (this.urlq === brandedurl) {
			window.location.assign(
				this.baseUrl + this.siteurl + landingpageinfocenter
			);
		} else {
			window.location.assign(
				this.baseUrl + this.siteurl + landingpageinfocenter
			);
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve the cms article names, images and descriptions based on given channelname
	@wire(retrieveMediaFromCMSNews, { channelName: '$channelName' })
	wiredData({ error, data }) {
		try {
			if (data && data.length > 0) {
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
							page: element.url,
							readtime: this.topics[element.title]
						}
					]);
				});
				if (this.results.length > 0) {
					if (this.justformearticlelist.length !== 0) {
						let finalresult = this.filterResultsByTitles(
							this.justformearticlelist
						);
						this.image12 = finalresult;
						if (this.image12.length === 1) {
							this.showarticle2 = false;
							this.showarticle3 = false;
							this.showarticle4 = false;
						}
						if (this.image12.length === 2) {
							this.showarticle3 = false;
							this.showarticle4 = false;
						}
						if (this.image12.length === 3) {
							this.showarticle4 = false;
						}
					} else {
						this.image12 = this.results;
					}

					if (this.urlq === unassignedsiteurl) {
						if (this.patientstatusval === acute) {
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
						if (this.patientstatusval !== acute) {
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
						if (this.patientstatusval === unassignedval) {
							this.showtreatvideo = false;
						}
					}
					if (this.urlq === brandedurl) {
						if (this.patientstatusval === chronicstatus) {
							const filteredData = this.image12.filter(
								(entry) =>
									entry.text !== articletwentysix &&
									entry.text !== articletwentyfive
							);
							this.image12 = filteredData;
						}
						if (this.patientstatusval === unassignedval) {
							this.showtreatvideo = false;
						}
					}

					this.threeDifferentNumbers = this.generateRandomNumbers();

					if (this.image12[this.threeDifferentNumbers[0]]) {
						this.image1 = this.image12[this.threeDifferentNumbers[0]].image;
						this.heading1 = this.image12[this.threeDifferentNumbers[0]].text;
						this.description1 =
							this.image12[this.threeDifferentNumbers[0]].text2;
						this.readtime1 = this.image12[this.threeDifferentNumbers[0]].readtime;
					}

					if (this.image12[this.threeDifferentNumbers[1]]) {
						this.image2 = this.image12[this.threeDifferentNumbers[1]].image;
						this.heading2 = this.image12[this.threeDifferentNumbers[1]].text;
						this.description2 =
							this.image12[this.threeDifferentNumbers[1]].text2;
						this.readtime2 = this.image12[this.threeDifferentNumbers[1]].readtime;

					}

					if (this.image12[this.threeDifferentNumbers[2]]) {
						this.image3 = this.image12[this.threeDifferentNumbers[2]].image;
						this.heading3 = this.image12[this.threeDifferentNumbers[2]].text;
						this.description3 =
							this.image12[this.threeDifferentNumbers[2]].text2;
						this.readtime3 = this.image12[this.threeDifferentNumbers[2]].readtime;

					}
					if (this.image12[this.threeDifferentNumbers[3]]) {
						this.image4 = this.image12[this.threeDifferentNumbers[3]].image;
						this.heading4 = this.image12[this.threeDifferentNumbers[3]].text;
						this.description4 =
							this.image12[this.threeDifferentNumbers[3]].text2;
						this.readtime4 = this.image12[this.threeDifferentNumbers[3]].readtime;

					}
				}

				this.error = undefined;
				this.image12 = this.results;

				this.image12 = this.results;
				this.arheading1 = articlestring + ' ' + this.heading1;
				this.arheading2 = articlestring + ' ' + this.heading2;
				this.arheading3 = articlestring + ' ' + this.heading3;
				this.arheading4 = articlestring + ' ' + this.heading4;
			} else if (error) {
				this.error = error;
				this.results = undefined;
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}


	get dynamicProperty() {
		// Generate a random number between 2 and 4 (inclusive)
		const newRandomNumber = Math.floor(Math.random() * 3) + 2;
		return newRandomNumber;
	}
	get dynamicsecond() {
		// Generate a random number between 0 and 60 (inclusive)
		const newRandomNumber = Math.floor(Math.random() * 61);
		return newRandomNumber;
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To reterive the patient status (acute or chronic or unassigned)
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data && data.length > 0) {
				this.patientstatusval = data;

				// Handle the data
				if (this.patientstatusval === acute) {
					this.categoryval = spcategorytwo;
				} else if (this.patientstatusval === chronicstatus) {
					this.categoryval = spcategoryone;
				} else {
					if (this.urlq === brandedurl) {
						this.categoryval = spcategoryone;
					} else {
						this.categoryval = spcategorytwo;
					}
				}
			} else if (error) {
				// Handle the error
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}
	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To reterieve the Just for me articles from cms based on given channelname
	@wire(getpersonalizedarticles, { channelName: '$channelName' })
	wiredarticleData({ error, data }) {
		try {
			if (data && data.length > 0) {
				this.justformearticlelist = [];

				this.justformearticlelist = JSON.parse(JSON.stringify(data));
								if (this.results.length > 0) {
					if (this.justformearticlelist.length !== 0) {
						let finalresult = this.filterResultsByTitles(
							this.justformearticlelist
						);
						this.image12 = finalresult;
						if (this.image12.length === 1) {
							this.showarticle2 = false;
							this.showarticle3 = false;
							this.showarticle4 = false;
						}
						if (this.image12.length === 2) {
							this.showarticle3 = false;
							this.showarticle4 = false;
						}
						if (this.image12.length === 3) {
							this.showarticle4 = false;
						}
					} else {
						this.image12 = this.results;
					}

					if (this.urlq === unassignedsiteurl) {
						if (this.patientstatusval === acute) {
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
						if (this.patientstatusval !== acute) {
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
						if (this.patientstatusval === unassignedval) {
							this.showtreatvideo = false;
						}
					}
					if (this.urlq === brandedurl) {
						if (this.patientstatusval === chronicstatus) {
							const filteredData = this.image12.filter(
								(entry) =>
									entry.text !== articletwentysix &&
									entry.text !== articletwentyfive
							);
							this.image12 = filteredData;
						}
						if (this.patientstatusval === unassignedval) {
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
					if (this.image12[this.threeDifferentNumbers[3]]) {
						this.image4 = this.image12[this.threeDifferentNumbers[3]].image;
						this.heading4 = this.image12[this.threeDifferentNumbers[3]].text;
						this.description4 =
							this.image12[this.threeDifferentNumbers[3]].text2;
					}
				}

				this.error = undefined;
				this.image12 = this.results;

				this.image12 = this.results;
				this.arheading1 = articlestring + ' ' + this.heading1;
				this.arheading2 = articlestring + ' ' + this.heading2;
				this.arheading3 = articlestring + ' ' + this.heading3;
				this.arheading4 = articlestring + ' ' + this.heading4;



			} else if (error) {
				this.error = error;
				this.results = undefined;
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// Filter the articles by titles
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