//This lightning web component helps the user to see the available challenges and gives the ability to make them as active challenge
//To import Libraries
import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex Classes
import getIndividualChallenges from '@salesforce/apex/BI_PSP_ChallengeCtrl.getIndividualChallenges';
//To import Custom labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import challengeLevel1 from '@salesforce/label/c.BI_PSP_Challenge_Level1';
import challengeLevel2 from '@salesforce/label/c.BI_PSP_Challenge_Level2';
import chBookWorm from '@salesforce/label/c.BI_PSP_ChallengeBookworm';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import IClandingPage from '@salesforce/label/c.BI_PSP_GppArticle';
import whyBeingActive from '@salesforce/label/c.BI_PSP_ActiveArticle';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import slashURL from '@salesforce/label/c.BI_PSP_ChatterSlash';

export default class BiPspbAvailableChallenges extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Expose properties to parent components
	@api challengeid;
	@api challengeidtoupdate;
	level1 = challengeLevel1;
	level2 = challengeLevel2;
	challengeBookworm = chBookWorm;
	siteUrlBranded = brSiteUrl;
	gppArticle = IClandingPage;
	beingActive = whyBeingActive;
	SLASHSITEURL = slashURL;
	// Declare properties to store challenge details
	Title;
	Level;
	Description;
	RewardPoints;
	Image;
	LinktoArticle;
	WhyBeingActive;
	urlq;

	// Wire method to retrieve individual challenge details
	@wire(getIndividualChallenges, { challengeId: "$challengeid" })
	wiredAccount({ error, data }) {
		//Null check for the data has been handled in the apex class
		if (data) {
			try {
				// Extract challenge details from response
				if (data[0].Name) {
					this.Title = data[0].Name;
					this.Level = data[0].BI_PSP_Challenge_Level__c;
					// Determine if article link or reason for being active should be displayed
					if (
						this.Title.includes(this.challengeBookworm) &&
						this.Level === this.level1
					) {
						this.LinktoArticle = true;
						this.WhyBeingActive = false;
					} else if (
						this.Title.includes(this.challengeBookworm) &&
						this.Level === this.level2
					) {
						this.WhyBeingActive = true;
						this.LinktoArticle = false;
					}
				}
				// Set description, reward points, and image
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
					// Resize image if needed and double quotes is required for this formula and styles
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
	// Method to handle accepting a challenge
	afterAccept() {
		const messageEvent = new CustomEvent("acceptchallenge", {
			detail: {
				challengeid: this.challengeid,
				challengeidtoupdate: this.challengeidtoupdate
			}
		});
		this.dispatchEvent(messageEvent);
	}

	// Method to open articles
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