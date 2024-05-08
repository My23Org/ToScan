// This lightning web component is used to show the article content from Content Management System.
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
// To import Apex Classes
import retrieveNewsFromCMS from '@salesforce/apex/BI_PSPB_CmsCtrl.retrieveNewsFromCMS';
import showfilterresponse from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import testsite from '@salesforce/label/c.BI_PSPB_TestsiteName';
import articlecategoryone from '@salesforce/label/c.BI_PSPB_articleCategoryOne';
import articlecategorytwo from '@salesforce/label/c.BI_PSPB_articleCategoryTwo';
import articlecategorythree from '@salesforce/label/c.BI_PSPB_articleCategoryThree';
import articlecategoryfour from '@salesforce/label/c.BI_PSPB_articleCategoryFour';
import articlecategoryfive from '@salesforce/label/c.BI_PSPB_articleCategoryFive';
import statusacute from '@salesforce/label/c.BI_PSPB_Acute';
import statuschronic from '@salesforce/label/c.BI_PSPB_statusChronic';
import articlespcategorytwo from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryTwo';
import articlespcategoryone from '@salesforce/label/c.BI_PSPB_spArticleCategoryValOne';
import categorypage from '@salesforce/label/c.BI_PSPB_BRInfoCenterCategoryPage';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import references from '@salesforce/label/c.BI_PSPB_references';
import tagsval from '@salesforce/label/c.BI_PSPB_tags';
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
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbarticlecontentpage extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track article_content = '';
	@track reference_content = '';
	@track remaincontent = '';
	@track categorytreatmentnew;
	@track len = 0;
	@track titlear = articlefifteen;
	@track result;
	@track isContentVisible = false;
	@track taglist = [];
	@track showtwotag = false;
	@track showthreetag = false;
	@track tag1;
	@track tag2;
	@track tag3;
	@track tag4;
	@track showjustforme_sec = false;
	@track urlq;
	@track currentPageUrl;
	@track urlSegments;
	@track baseUrl;
	@track showbrandednav = true;
	@track touch = false;
	@track down = true;
	@track up = false;
	// Global variables(without @track does not trigger automatic re-renders)
	siteUrlq;
	userId = Id;
	channelName = testsite;
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
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// To set the icon up or down
	get iconName() {
		return this.isContentVisible ? "utility:chevronup" : "utility:chevrondown";
	}

	// To expand the reference content
	get iconAltText() {
		return this.isContentVisible ? "Collapse Content" : "Expand Content";
	}

	// To set the reference content visbile
	get contentClass() {
		return this.isContentVisible ? "content visible" : "content";
	}

	// To change the toggle content to visible
	toggleContent() {
		this.isContentVisible = !this.isContentVisible;
	}

	// Wire method to capture the current page reference and extract the state id value
	// We are unable to utilize "data" or "error" as CurrentPageReference is default API.
	@wire(CurrentPageReference)
	pageReference({ state }) {
		try {
			if (state && state.id) {
				this.result = state.id;
				this.titlear = state.id;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve news content from CMS
	@wire(retrieveNewsFromCMS, { channelName: "$channelName"})
	wiredData({ error, data }) {
		try {
			if (data) {
				let objStr = JSON.parse(data);

				for (let i = 0; i < objStr.length; i++) {
					if (objStr[i].title.toLowerCase() === this.titlear.toLowerCase()) {
						this.article_content = objStr[i].body; // Removed JSON.stringify
						this.article_content = this.article_content.substring(
							86,
							this.article_content.length - 2
						);

						this.len = this.article_content.length;

						// Replace newline characters with <br>
						this.article_content = this.article_content.replace(/\n/g, "<br>");

						let output1 = this.addStyleAfterTag(this.article_content, "li");
						let output = this.addStyleAfterTag(
							output1,
							"a",
							"color:#000000; text-decoration: underline;"
						);
						let output2 = this.addStyleAfterTag(
							output,
							"h3",
							"font-size:16px;"
						);
						let output3 = this.addStyleAfterTag(
							output2,
							"p",
							"font-size:14px;"
						);
						let output4 = this.addStyleAfterTag(
							output3,
							"h6",
							"font-size:16px; font-family:Eina-Regular; font-weight:400;"
						);

						let outputnew = this.addStyleAfterTag(
							output4,
							"strong",
							"color: #403A60;"
						);
						let newoutput = this.addStyleAfterTag(
							outputnew,
							"h1",
							"color: #403A60; font-size:32px;"
						);
						this.article_content = this.addStyleAfterTag(
							newoutput,
							"img",
							"width: 100% !important;"
						);
						let startIndex = this.article_content.indexOf(references);
						let tagIndex = this.article_content.indexOf(tagsval);

						if (startIndex !== -1) {
							const newstartIndex = this.article_content.indexOf(references);

							this.reference_content = this.article_content.substring(
								newstartIndex + 10
							);
							if (tagIndex !== -1) {
								let tags = this.article_content.substring(
									tagIndex + 5,
									this.article_content.length - 3
								);
								this.taglist = tags.split(",");
								if (this.taglist.length === 2) {
									this.showtwotag = true;
									this.tag1 = this.taglist[0];
									this.tag2 = this.taglist[1];
								} else if (this.taglist.length === 3) {
									this.showthreetag = true;
									this.tag1 = this.taglist[0];
									this.tag2 = this.taglist[1];
									this.tag3 = this.taglist[2];
								} else if (this.taglist.length === 4) {
									this.showthreetag = true;
									this.tag1 = this.taglist[0];
									this.tag2 = this.taglist[1];
									this.tag3 = this.taglist[2];
									this.tag4 = this.taglist[3];
								}
							}
							let taginreference = this.reference_content.indexOf(tagsval);
							if (taginreference !== -1) {
								this.reference_content = this.reference_content.substring(
									0,
									taginreference
								);
							}

							this.article_content = this.article_content.substring(
								0,
								startIndex
							);
						}

						let indexOfFirstH1 = this.article_content.indexOf("</h1>") + 5;

						// Split the string based on the index
						let firstPart = this.article_content.substring(0, indexOfFirstH1);
						let remainingPart = this.article_content.substring(indexOfFirstH1);
						this.article_content = firstPart;
						this.remaincontent = remainingPart;

						// Log the updated string
						break;
					}
				}

				this.error = undefined;
			} else if (error) {
				this.error = error;
				this.results = undefined;
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To add the style after the provided html tag like <P> or <h1> or <h5>
	addStyleAfterTag(input, tagName, style) {
		let regex = new RegExp("<\\s*" + tagName + "\\s*([^>]*)>", "gi");
		let replacement = "<" + tagName + ' style="' + style + '" $1>';
		return input.replace(regex, replacement);
	}

	// Generate a random number between 2 and 4 (inclusive)
	get dynamicProperty() {
		const readTime = this.topics[this.titlear];
		return readTime;
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

	// button labels
	standarItems = [
		{ id: 1, title: articlecategoryone },
		{ id: 2, title: articlecategorytwo },
		{ id: 3, title: articlecategorythree },
		{ id: 4, title: articlecategoryfour },
		{ id: 5, title: articlecategoryfive }
	];

	// To navigate to information center article category page
	handleButtonClicknew(event) {
		const finaltitle = event.currentTarget.dataset.name;
		const articlename = finaltitle;

		window.location.href =
			this.baseUrl + this.siteUrlq + categorypage + articlename;
	}

	/* If user having null assessment record then disabled the just for me navigation */
	// To retrieve letspersonalized assessment data
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
			} else if(data === null) {
				this.showjustforme_sec = false;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
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
					this.categorytreatmentnew = articlespcategorytwo;
				} else if (this.patientstatusval === statuschronic) {
					this.categorytreatmentnew = articlespcategoryone;
				} else if (this.urlq === brandedurl) {
					this.categorytreatmentnew = articlespcategoryone;
				} else {
					this.categorytreatmentnew = articlespcategorytwo;
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