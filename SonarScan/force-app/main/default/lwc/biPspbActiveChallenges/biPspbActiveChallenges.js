/**This Lightning web component helps to display the active challenges that has been chosen by the user**/
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
import IClandingPage from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';

export default class BiPspbActiveChallenges extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@api activechallengeid;
	@api challengeidtoupdate;
	level1 = challengeLevel1;
	level2 = challengeLevel2;
	challengeBookworm = chBookWorm;
	siteUrlBranded = brSiteUrl;
	informationCenterLandingPage = IClandingPage;
	Title;
	Level;
	Description;
	RewardPoints;
	LinktoArticle;
	WhyBeingActive;
	Image;

	//This wire method is used to get the individual challenges with the help of active challenges id
	@wire(getIndividualChallenges, { challengeId: "$activechallengeid" })
	wiredAccount({ error, data }) {
		//Null check for the data has been handled in the apex class
		if (data) {
			try {
				if (data[0].Name) {
					this.Title = data[0].Name;
					this.Level = data[0].BI_PSP_Challenge_Level__c;
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
	//Used for challenge cancel functionality
	aftercancel() {
		const messageEvent = new CustomEvent('cancelchallenge', {
			detail: {
				activechallengeid: this.activechallengeid,
				challengeidtoupdate: this.challengeidtoupdate
			}
		});
		this.dispatchEvent(messageEvent);
	}
	//Used for challenge complete functionality
	afterComplete() {
		const messageEvent = new CustomEvent('completechallenge', {
			detail: {
				activechallengeid: this.activechallengeid,
				challengeidtoupdate: this.challengeidtoupdate
			}
		});
		this.dispatchEvent(messageEvent);
	}
	//Used for navigating to articles
	openArticles() {
		window.location.assign(
			this.siteUrlBranded + this.informationCenterLandingPage
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