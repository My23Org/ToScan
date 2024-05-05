//This lightning web component is used as a Widget that shows Challenges in dashboard
//To import Libraries
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To get Current UserId
import Id from '@salesforce/user/Id';
//To import Apex Classes
import getRank from '@salesforce/apex/BI_PSP_ChallengeCtrl.getRank';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getLastActiveChallenges from '@salesforce/apex/BI_PSP_ChallengeCtrl.getLastActiveChallenges';
import getRandomChallenges from '@salesforce/apex/BI_PSP_ChallengeCtrl.getRandomChallenges';
//To import Static Resource
import widget from '@salesforce/resourceUrl/BI_PSP_ChallengeWidget';
import NoviceImage from '@salesforce/resourceUrl/BI_PSP_NoviceImage';
import BeginnerImage from '@salesforce/resourceUrl/BI_PSP_BeginnerImage';
import IntermediateImage from '@salesforce/resourceUrl/BI_PSP_IntermediateImage';
import ProficientImage from '@salesforce/resourceUrl/BI_PSP_ProficientImage';
import ExpertImage from '@salesforce/resourceUrl/BI_PSP_ExpertImage';
//To import Custom labels
import Expert_Gpp from '@salesforce/label/c.BI_PSP_Expert_Gpp';
import Beginner_Gpp from '@salesforce/label/c.BI_PSP_Beginner_Gpp';
import Intermediate_Gpp from '@salesforce/label/c.BI_PSP_Intermediate_Gpp';
import Novice_Gpp from '@salesforce/label/c.BI_PSP_Novice_Gpp';
import Proficient_Gpp from '@salesforce/label/c.BI_PSP_Proficient_Gpp';
import Novice_Gpps from '@salesforce/label/c.BI_PSP_Novice';
import Beginner from '@salesforce/label/c.BI_PSP_Beginner';
import Intermediate from '@salesforce/label/c.BI_PSP_Intermediate';
import Proficient from '@salesforce/label/c.BI_PSP_Proficient';
import Expert from '@salesforce/label/c.BI_PSP_Expert';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import slashURL from '@salesforce/label/c.BI_PSP_ChatterSlash';
import slashSiteUrl from '@salesforce/label/c.BI_PSP_Slashsite';
import brChallengesSiteUrl from '@salesforce/label/c.BI_PSP_challengesURL';
import brtrophyCaseSiteUrl from '@salesforce/label/c.BI_PSP_trophyCaseURL';
import rankLevelOne from '@salesforce/label/c.BI_PSP_RankLevelOne';
import rankLevelTwo from '@salesforce/label/c.BI_PSP_RankLevelTwo';
import rankLevelThree from '@salesforce/label/c.BI_PSP_RankLevelThree';
import rankLevelFour from '@salesforce/label/c.BI_PSP_RankLevelFour';
import rankLevelSix from '@salesforce/label/c.BI_PSP_RankLevelSix';
import chRankTwo from '@salesforce/label/c.BI_PSP_RankTwo';
import chRankThree from '@salesforce/label/c.BI_PSP_RankThree';
import chRankFour from '@salesforce/label/c.BI_PSP_RankFour';
import chRankFive from '@salesforce/label/c.BI_PSP_RankFive';
import lableAvailable from '@salesforce/label/c.BI_PSP_AvailableLabel';

export default class WidgetChallenges extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	ExpertImage = ExpertImage;
	ProficientImage = ProficientImage;
	IntermediateImage = IntermediateImage;
	BeginnerImage = BeginnerImage;
	NoviceImage = NoviceImage;
	challenges = widget;
	firsttime;
	userId = Id;
	enrolleId;
	showError;
	errorMessage;
	Title;
	Description;
	RewardPoints;
	Image;
	currentXP;
	nextrankxp;
	xpNextrank;
	rankLevel;
	rankLevels;
	rankcompleted;
	tImage;
	onlyXp;
	xpValue = false;
	avaiChallenge = false;
	nullChallenge = false;
	SLASHSITEURL = slashURL;
	SLASHSITEPAGEURL = slashSiteUrl;
	siteChallengesUrlBranded = brChallengesSiteUrl;
	siteTrophyCaseUrlBranded = brtrophyCaseSiteUrl;
	levelOne = rankLevelOne;
	levelTwo = rankLevelTwo;
	levelThree = rankLevelThree;
	levelFour = rankLevelFour;
	levelSix = rankLevelSix;
	rankTwo = chRankTwo;
	rankThree = chRankThree;
	rankFour = chRankFour;
	rankFive = chRankFive;
	availableLabel = lableAvailable;

	//connectedcallback is used for get the careprogram enrollee id
	connectedCallback() {
		try {
			getEnrolle({ userId: this.userId })
				.then(result => {// Null check has been handled in its respective apex method
					if (result[0].patientEnrolle !== null) {
						this.enrolleId = result[0].patientEnrolle.Id;
						this.getActiveAndAvailableChallenge(result[0].patientEnrolle.BI_PSP_Challenge_Rank__c);
					} else if (result[0].error !== null) {
						this.showError = true;
						this.errorMessage = result[0].error;
					}
				})
				.catch(error => {
					console.log('getEnrolle-->', JSON.stringify(error));
					this.showToast(errormessage, error.message, errorvariant);
				})


			const currentURL = window.location.href;
			// Create a URL object
			const urlObject = new URL(currentURL);

			// Get the path
			const path = urlObject.pathname;

			// Split the path using '/' as a separator
			const pathComponents = path.split(this.SLASHSITEURL);

			// Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find(component =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
			);

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurl;
			}
			else {
				this.urlq = unassignedurl;
			}
		}
		catch (error) {
			console.log('Connected Callback-->', JSON.stringify(error));
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	//This method is used for get the active and available challenges.
	getActiveAndAvailableChallenge(rank) {
		if (rank !== Expert_Gpp) {
			console.log('enrollee Id-->',this.enrolleId);
			getLastActiveChallenges({ enrolleId: this.enrolleId }).then(result => {
				if (result !== null) {
					if (result.Name) {
						this.Title = result.Name;
					}
					if (result.HealthCloudGA__Description__c) {
						this.Description = result.HealthCloudGA__Description__c.replace(/<[^>]*>/g, '');
					}
					if (result.BI_PSP_Challenge_Reward_Points__c) {
						this.RewardPoints = result.BI_PSP_Challenge_Reward_Points__c;
					}
					if (result.BI_PSP_Challenge_Image__c) {
						this.Image = result.BI_PSP_Challenge_Image__c;
						const desiredWidth = '148px';
						const desiredHeight = '129px';
						const imgTagRegex = /<img\s+[^>]*src='([^']+)'[^>]*>/gi;
						const formattedContent = this.Image.replace(imgTagRegex, (match, src) => {
							return `<img src='${src}' alt='' width='${desiredWidth}' height='${desiredHeight}'>`;
						});
						this.tImage = formattedContent;
					}
					this.firsttime = false;
				} else {
					this.firsttime = true;
				}
				this.xpMethod();
			}).catch(error => {
				console.log('getLastActiveChallenges-->', JSON.stringify(error));
				this.showToast(errormessage, error.message, errorvariant);
			});
		} else {
			this.firsttime = true;
			this.xpMethod();
		}
	}
	//This method is used for get the rank and xp values.
	xpMethod() {
		getRank({ personAccountId: this.enrolleId })
			.then(result => {// Null check has been handled in its respective apex method
				if (this.firsttime === true) {
					this.xpValue = true;
				}
					this.currentXP = result[0].BI_PSP_Total_Reward_Points__c;
					if (this.currentXP === undefined) {
						this.currentXP = 0;
					}
					if (this.currentXP < Novice_Gpps) {
						this.nextrankxp = Novice_Gpps;
						this.xpNextrank = Novice_Gpps - this.currentXP;
						this.rankLevel = this.levelOne;
						this.rankLevels = this.rankTwo;
						this.rankcompleted = Novice_Gpp;
						if (this.firsttime === true) {
							this.tImage = NoviceImage;
						}
					} else if (this.currentXP >= Novice_Gpps && this.currentXP < Beginner) {
						this.nextrankxp = Beginner;
						this.xpNextrank = Beginner - this.currentXP;
						this.rankLevel = this.levelTwo;
						this.rankLevels = this.rankThree;
						this.rankcompleted = Beginner_Gpp;
						if (this.firsttime === true) {
							this.tImage = BeginnerImage;
						}
					} else if (this.currentXP >= Beginner && this.currentXP < Intermediate) {
						this.nextrankxp = Intermediate;
						this.xpNextrank = Intermediate - this.currentXP;
						this.rankLevel = this.levelThree;
						this.rankLevels = this.rankFour;
						this.rankcompleted = Intermediate_Gpp;
						if (this.firsttime === true) {
							this.tImage = IntermediateImage;
						}
					} else if (this.currentXP >= Intermediate && this.currentXP < Proficient) {
						this.nextrankxp = Proficient;
						this.xpNextrank = Proficient - this.currentXP;
						this.rankLevel = this.levelFour;
						this.rankLevels = this.rankFive;
						this.rankcompleted = Proficient_Gpp;
						if (this.firsttime === true) {
							this.tImage = ProficientImage;
						}
					} else if (this.currentXP >= Proficient && this.currentXP < Expert) {
						this.nextrankxp = Expert;
						this.xpNextrank = this.nextrankxp - this.currentXP;
						this.rankLevel = this.levelSix;
						this.rankcompleted = Expert_Gpp;
						if (this.firsttime === true) {
							this.tImage = ExpertImage;
						}
					} else if (this.currentXP >= Expert) {
						this.onlyXp = true;
						this.getavailable();
						this.tImage = ExpertImage;
						this.xpNextrank = this.currentXP;
						this.rankLevel = this.levelSix;
					}

				
			})
			.catch(error => {
				console.log('getRank-->', JSON.stringify(error));
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	//This method is used for get Only available challenges.
	getavailable() {
		let status = this.availableLabel;
		getRandomChallenges({ personAccountId: this.enrolleId, status: status })
			.then(result => {
				if (result === null) {
					this.nullChallenge = true;
					this.avaiChallenge = false;
					this.xpValue = false;
				} else {
					this.avaiChallenge = true;
					this.nullChallenge = false;
					this.xpValue = false;
				}
			})
			.catch(error => {
				console.log('getRandomChallenges-->', JSON.stringify(error));
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	//Navigation
	navigateChallenge() {
		window.location.assign(this.SLASHSITEURL + this.urlq + this.SLASHSITEPAGEURL + this.siteChallengesUrlBranded);
	}
	navigateTrophy() {
		window.location.assign(this.SLASHSITEURL + this.urlq + this.SLASHSITEPAGEURL + this.siteTrophyCaseUrlBranded);
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