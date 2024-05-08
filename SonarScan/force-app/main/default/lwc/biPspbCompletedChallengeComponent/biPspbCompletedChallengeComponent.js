//The LWC displays a card that includes challenge title, description, reward points, and an optional link to an article based on challenge criteria
//To import Libraries
import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import apex classess
import getIndividualChallenges from '@salesforce/apex/BI_PSP_ChallengeCtrl.getIndividualChallenges';
//To import custom labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import chBookworm from '@salesforce/label/c.BI_PSP_ChallengeBookworm';
import chLevelOne from '@salesforce/label/c.BI_PSP_Challenge_Level1';
import chLevelTwo from '@salesforce/label/c.BI_PSP_Challenge_Level2';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import slashURL from '@salesforce/label/c.BI_PSP_ChatterSlash';
import IClandingPage from '@salesforce/label/c.BI_PSP_GppArticle';
import whyBeingActive from '@salesforce/label/c.BI_PSP_ActiveArticle';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';

export default class BiPspbCompletedChallengeComponent extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@api completechallengeid;
	challengeBookworm = chBookworm;
	challengeLevelOne = chLevelOne;
	challengeLevelTwo = chLevelTwo;
	siteUrlBranded = brSiteUrl;
	gppArticle = IClandingPage;
	beingActive = whyBeingActive;
	SLASHSITEURL = slashURL;
	Title;
	Description;
	RewardPoints;
	DateofCompletion;
	LinktoArticle;
	WhyBeingActive;
	Level;
	Image;
	urlq;

	//This method is used for getting the individuals records.
	@wire(getIndividualChallenges, { challengeId: "$completechallengeid" })
	wiredAccount({ error, data }) {// Null check has been handled in apex class for this data
		if (data) {
			try {
				if (data[0].Name) {
					this.Title = data[0].Name;
					this.Level = data[0].BI_PSP_Challenge_Level__c;
					if (
						this.Title.includes(this.challengeBookworm) &&
						this.Level === this.challengeLevelOne
					) {
						this.LinktoArticle = true;
						this.WhyBeingActive = false;
					} else if (
						this.Title.includes(this.challengeBookworm) &&
						this.Level === this.challengeLevelTwo
					) {
						this.WhyBeingActive = true;
						this.LinktoArticle = false;
					}
				}
				if (data[0].HealthCloudGA__Description__c) {
					this.Description = data[0].HealthCloudGA__Description__c.replace(
						/<[^>]*>/g,
						""
					);
				}
				if (data[0].BI_PSP_Challenge_Reward_Points__c) {
					this.RewardPoints = data[0].BI_PSP_Challenge_Reward_Points__c;
				}
				if (data[0].BI_PSP_Challenge_Image__c) {
					this.Image = data[0].BI_PSP_Challenge_Image__c;
					const desiredWidth = '135px';
					const desiredHeight = '70px';
					const imgTagRegex = /<img\s+[^>]*src="([^"]+)"[^>]*>/gi;
					const formattedContent = this.Image.replace(
						imgTagRegex,
						(match, src) => {
							return `<img src="${src}" alt="" width="${desiredWidth}" height="${desiredHeight}">`;
						}
					);
					this.Image = formattedContent;
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	connectedCallback() {
		try {
		const currentURL = window.location.href;
		const urlObject = new URL(currentURL);
		const path = urlObject.pathname;
		const pathComponents = path.split('/');
		const desiredComponent = pathComponents.find((component) =>
			[brandedurl, unassignedurl].includes(
			component
			)
		);

		if (desiredComponent === brandedurl) {
			this.urlq = brandedUrlNavi;
		} else {
			this.urlq = unAssignedUrlNavi;
		}
		} catch (error) {
		this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}
	//Navigation for articles
	openArticles() {
		window.location.assign(
			this.urlq + this.gppArticle
		);
	}
	openArticlesActive() {
		window.location.assign(
			this.urlq + this.beingActive
		);
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