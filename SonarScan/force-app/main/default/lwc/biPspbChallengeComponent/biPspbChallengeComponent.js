//This LWC dynamically renders error messages, challenges, and congratulatory messages based on various conditions, enhancing user engagement and interaction in challenges
//To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To get Current UserId
import Id from '@salesforce/user/Id';
//To import Apex Classes
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getRandomChallenges from '@salesforce/apex/BI_PSP_ChallengeCtrl.getRandomChallenges';
import getIndividualChallenges from '@salesforce/apex/BI_PSP_ChallengeCtrl.getIndividualChallenges';
import updateChallenges from '@salesforce/apex/BI_PSP_ChallengeCtrl.updateChallenges';
import getRank from '@salesforce/apex/BI_PSP_ChallengeCtrl.getRank';
//To import Static Resource
import NoviceImage from '@salesforce/resourceUrl/BI_PSP_NoviceImage';
import BeginnerImage from '@salesforce/resourceUrl/BI_PSP_BeginnerImage';
import IntermediateImage from '@salesforce/resourceUrl/BI_PSP_IntermediateImage';
import ProficientImage from '@salesforce/resourceUrl/BI_PSP_ProficientImage';
import ExpertImage from '@salesforce/resourceUrl/BI_PSP_ExpertImage';
import Celebration from '@salesforce/resourceUrl/BI_PSP_Celebration';
import CroIcon from '@salesforce/resourceUrl/BI_PSP_CrossIcon';
import ActiveNo from '@salesforce/resourceUrl/BI_PSP_Activeno';
import ChallengeArrowSmall from '@salesforce/resourceUrl/BI_PSP_ChallengeArrowSmall';
import ChallengeArrowLarge from '@salesforce/resourceUrl/BI_PSP_ChallengeArrowLarge';
//To import Custom labels
import lableStatusActive from '@salesforce/label/c.BI_PSPB_Active';
import lableStatusCompleted from '@salesforce/label/c.BI_PSP_Challenge_Completed';
import lableAvailable from '@salesforce/label/c.BI_PSP_AvailableLabel';
import rankLevelOne from '@salesforce/label/c.BI_PSP_RankLevelOne';
import rankLevelTwo from '@salesforce/label/c.BI_PSP_RankLevelTwo';
import rankLevelThree from '@salesforce/label/c.BI_PSP_RankLevelThree';
import rankLevelFour from '@salesforce/label/c.BI_PSP_RankLevelFour'
import rankLevelFive from '@salesforce/label/c.BI_PSP_RankLevelFive';
import rankLevelSix from '@salesforce/label/c.BI_PSP_RankLevelSix';
import chRankTwo from '@salesforce/label/c.BI_PSP_RankTwo';
import chRankThree from '@salesforce/label/c.BI_PSP_RankThree';
import chRankFour from '@salesforce/label/c.BI_PSP_RankFour';
import chRankFive from '@salesforce/label/c.BI_PSP_RankFive';
import chRankSix from '@salesforce/label/c.BI_PSP_RankSix';
import errormessages from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import brtrophyCaseSiteUrl from '@salesforce/label/c.BI_PSP_trophyCaseURL';
import errMssgPl from '@salesforce/label/c.BI_PSP_errorMssgPl';
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

export default class BiPspbChallengeComponent extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@track availableChallenges = [];
	@track acceptedChallenges = [];
	@track activeChallenges = [];
	@track percentage = 0;
	@track showChallenges;
	@track showCongrats;
	@track showCongratsPre;

	percentageCompleted;
	showQuestion = true;
	congrats = false;
	siteUrlBranded = brSiteUrl;
	siteTrophyCaseUrlBranded = brtrophyCaseSiteUrl;
	errorMessagePl = errMssgPl;
	resultSuccess = '';
	completedLabel = lableStatusCompleted;
	activeLabel = lableStatusActive;
	availableLabel = lableAvailable;
	levelOne = rankLevelOne;
	levelTwo = rankLevelTwo;
	levelThree = rankLevelThree;
	levelFour = rankLevelFour;
	levelFive = rankLevelFive;
	levelSix = rankLevelSix;
	rankTwo = chRankTwo;
	rankThree = chRankThree;
	rankFour = chRankFour;
	rankFive = chRankFive;
	rankSix = chRankSix;
	ChallengeArrowSmall = ChallengeArrowSmall;
	ChallengeArrowLarge = ChallengeArrowLarge;
	CrossIcon = CroIcon;
	Celebration = Celebration;
	ActiveNo = ActiveNo;
	ExpertImage = ExpertImage;
	ProficientImage = ProficientImage;
	IntermediateImage = IntermediateImage;
	BeginnerImage = BeginnerImage;
	NoviceImage = NoviceImage;
	activeCount = 0;
	updateChallenge = {};
	updating;
	showMore;
	updateChallenge2 = {};
	updateChallengeComplete = {};
	Title;
	Description;
	RewardPoints;
	Image;
	showmodal;
	showbutton;
	showInfo;
	showInfo1;
	showcong;
	isLoading = false;
	rankcompleted;
	currentXP = 0;
	nextrankxp;
	xpNextrank;
	rankLevel;
	rankLevels;
	variable;
	showMoreCount = 3;
	userId = Id;
	selectedAvatarSrc;
	selectedName;
	enrolleId;
	showError;
	errorMessage;
	tImage;
	completedpercentage;
	showfiveHund;
	showNoneFive;
	showLess;
	updateChallenge1 = {};
	availableCount = 0;

	//this function is used for navigating to trophycase page
	navigateTrophy() {
		window.location.assign(this.siteUrlBranded + this.siteTrophyCaseUrlBranded);
	}

	//connectedcallback is used for get the careprogram enrollee id
	connectedCallback() {
		try {
			getEnrolle({ userId: this.userId })
				.then((result) => {
					if (result.length > 0) {//result is returned as a list so we have used result.length
						if (result[0].patientEnrolle !== null) {
							this.enrolleId = result[0].patientEnrolle.Id;
							this.xpMethod();
							this.getActiveAndAvailableChallenge();
						} else if (result[0].error !== null) {
							this.showError = true;
							this.errorMessage = result[0].error;
						}
					} else {
						this.showError = true;
						this.errorMessage = this.errorMessagePl;
					}
				})
				.catch((error) => {
					this.showToast(errormessages, error.message, errorvariant);
				});
		} catch (error) {
			this.showToast(errormessages, error.message, errorvariant);
		}
	}

	//This method is used for get the active and available challenges.
	getActiveAndAvailableChallenge() {
		this.getRandomChallengesCommon();
		let status = this.activeLabel;
		getRandomChallenges({ personAccountId: this.enrolleId, status: status })
			.then((result) => {// Null pointer exception has been handled in apex class
				if (
					(Array.isArray(result) &&
						result.length === 1 &&
						Object.keys(result[0]).length === 0) ||
					result === null
				) {
					this.resultSuccess = result;
				}
				else {
					this.activeChallenges = result.filter(
						(obj) => Object.keys(obj).length !== 0
					);
					this.activeCount = this.activeChallenges.length;
				}
				this.showInfos();
			})
			.catch((error) => {
				this.showToast(errormessages, error.message, errorvariant);
			});
	}
	//This method is used for get the rank and xp values.
	xpMethod() {
		this.isLoading = true;
		getRank({ personAccountId: this.enrolleId })
			.then((result) => {
				if (result !== null) {
					this.variable = true;
					this.currentXP = result[0].BI_PSP_Total_Reward_Points__c;
					if (this.currentXP === undefined) {
						this.currentXP = 0;
					}
					if (this.currentXP < Novice_Gpps) {
						this.nextrankxp = Novice_Gpps;
						this.xpNextrank = Novice_Gpps - this.currentXP;
						this.rankLevel = this.levelOne;
						this.rankLevels = this.rankTwo;
						this.percentage = 100 * (this.currentXP / this.nextrankxp);
						this.percentage = Math.floor(this.percentage);
						this.rankcompleted = Novice_Gpp;
						this.tImage = NoviceImage;
					} else if (
						this.currentXP >= Novice_Gpps &&
						this.currentXP < Beginner
					) {
						this.nextrankxp = Beginner;
						this.xpNextrank = Beginner - this.currentXP;
						this.rankLevel = this.levelTwo;
						this.rankLevels = this.rankThree;
						this.percentage = 100 * (this.currentXP / this.nextrankxp);
						this.percentage = Math.floor(this.percentage);
						this.rankcompleted = Beginner_Gpp;
						this.tImage = BeginnerImage;
					} else if (
						this.currentXP >= Beginner &&
						this.currentXP < Intermediate
					) {
						this.nextrankxp = Intermediate;
						this.xpNextrank = Intermediate - this.currentXP;
						this.rankLevel = this.levelThree;
						this.rankLevels = this.rankFour;
						this.percentage = 100 * (this.currentXP / this.nextrankxp);
						this.percentage = Math.floor(this.percentage);
						this.rankcompleted = Intermediate_Gpp;
						this.tImage = IntermediateImage;
					} else if (
						this.currentXP >= Intermediate &&
						this.currentXP < Proficient
					) {
						this.nextrankxp = Proficient;
						this.xpNextrank = Proficient - this.currentXP;
						this.rankLevel = this.levelFour;
						this.rankLevels = this.rankFive;
						this.percentage = 100 * (this.currentXP / this.nextrankxp);
						this.percentage = Math.floor(this.percentage);
						this.rankcompleted = Proficient_Gpp;
						this.tImage = ProficientImage;
					} else if (this.currentXP >= Proficient && this.currentXP < Expert) {
						this.nextrankxp = Expert;
						this.xpNextrank = this.nextrankxp - this.currentXP;
						this.rankLevel = this.levelFive;
						this.rankLevels = this.rankSix;
						this.variable = false;
						this.percentage = 100 * (this.currentXP / this.nextrankxp);
						this.percentage = Math.floor(this.percentage);
						this.rankcompleted = Expert_Gpp;
						this.tImage = ExpertImage;
					}
					else if (this.currentXP >= Expert) {
						if (this.currentXP === 1500) {
							this.showfiveHund = true;
							this.showNoneFive = false;
						} else {
							this.showfiveHund = false;
							this.showNoneFive = true;
						}
						this.percentage = 100;
						this.tImage = ExpertImage;
						this.rankLevel = this.levelSix;
						let status = this.availableLabel;
						getRandomChallenges({
							personAccountId: this.enrolleId,
							status: status
						})
							.then((data) => {
								data = data.filter((obj) => Object.keys(obj).length !== 0);
								if (data.length === 0) {
									let activeStatus = this.activeLabel;
									getRandomChallenges({
										personAccountId: this.enrolleId,
										status: activeStatus
									})
										.then((resultData) => {
											resultData = resultData.filter(
												(obj) => Object.keys(obj).length !== 0
											);
											if (resultData.length === 0) {
												this.showCongratsPre = false;
											} else {
												this.showCongratsPre = true;
											}
										})
										.catch((error) => {
											this.showToast(
												errormessages,
												error.message,
												errorvariant
											);
										});
								} else {
									this.showCongratsPre = true;
								}
							})
							.catch((err) => {
								this.showToast(errormessages, err.message, errorvariant);
							});
					}
					this.getavailable();
				}
				this.isLoading = false;
				this.dispatchEvent(
					new CustomEvent('sendxp', { detail: this.currentXP })
				);
			})
			.catch((error) => {
				this.isLoading = false;
				this.showToast(errormessages, error.message, errorvariant);
			});
	}
	//This method is used for get Only available challenges.
	getavailable() {
		if (this.currentXP >= 1500) {
			let status = this.availableLabel;
			getRandomChallenges({ personAccountId: this.enrolleId, status: status })
				.then((result) => {// Null check for result has been handled in Apex class.
					result = result.filter((obj) => Object.keys(obj).length !== 0);
					if (result.length === 0) {
						this.showCongrats = true;
						this.showChallenges = false;
						this.percentage = 100;
						let localStatus = this.activeLabel;
						getRandomChallenges({
							personAccountId: this.enrolleId,
							status: localStatus
						})
							.then((resultValue) => {
								resultValue = resultValue.filter((obj) => Object.keys(obj).length !== 0);
								if (resultValue.length === 0) {
									this.showCongrats = true;
									this.showChallenges = false;
									this.percentage = 100;
								} else {
									this.showCongrats = false;
									this.showChallenges = true;
								}
							})
							.catch((error) => {
								this.showToast(errormessages, error.message, errorvariant);
							});
					} else {
						this.showCongrats = false;
						this.showChallenges = true;
					}
				})
				.catch((error) => {
					this.showToast(errormessages, error.message, errorvariant);
				});
		} else {
			this.showCongrats = false;
			this.showChallenges = true;
		}
	}
	//This is uesd for closing the completed challenge popup
	closeComplete() {
		this.showmodal = false;
		this.showbutton = "";
		this.updateChallengeComplete = {};
		this.showcong = true;
		this.showmodal = false;
		this.basicCannon();
	}
	//Functionality for after completing the challenge
	afterComplete() {
		this.showbutton = true;
		this.simpleUpdateChallenge(this.updateChallengeComplete);
	}
	//Navigation
	closeMobMenu1() {
		window.location.assign(window.location.href);
	}
	//Popup Functionalities
	closeMobMenu() {
		this.closeModal();
	}
	closeModal() {
		this.showmodal = false;
		this.percentageCompleted = 0;
		this.updateChallengeComplete = {};
		document.body.style.overflow = "auto";
	}
	afterClose() {
		this.showcong = false;
		window.location.assign(window.location.href);
	}
	//Functionality for completing the challenge
	completeChallenge(event) {
		const componentId1 = event.detail.activechallengeid;
		const componentId = event.detail.challengeidtoupdate;
		this.updateChallenge2 = this.activeChallenges.filter(
			(challenges) => challenges.challengeIdToUpdate === componentId
		);
		this.updateChallengeComplete = this.updateChallenge2;
		this.showmodal = true;
		this.showbutton = false;
		this.getActiveChallenge(componentId1);
		this.fromNavBar(event);
	}
	//This method is used to get the Active Challenges.
	getActiveChallenge(challengeIds) {
		getIndividualChallenges({ challengeId: challengeIds })
			.then((result) => {//Null check for the returned value has been handled in apex class.
				if (result[0].Name) {
					this.Title = result[0].Name;
				}
				if (result[0].HealthCloudGA__Description__c) {
					this.Description = result[0].HealthCloudGA__Description__c.replace(
						/<[^>]*>/g,
						""
					);
				}
				if (result[0].BI_PSP_Challenge_Reward_Points__c) {
					this.RewardPoints = result[0].BI_PSP_Challenge_Reward_Points__c;
				}
				if (result[0].BI_PSP_Challenge_Image__c) {
					this.Image = result[0].BI_PSP_Challenge_Image__c;
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
			})
			.catch((error) => {
				this.showToast(errormessages, error.message, errorvariant);
			});
	}
	//Dynamically modifies the overflow css property accorfing to active challenges
	fromNavBar(event) {
		if (event.detail.activechallengeid) {
			document.body.style.overflow = "hidden";
		} else {
			document.body.style.overflow = "auto";
		}
	}

	//This method is used to Update the Available Challenges.
	simpleUpdateChallenge(updatingChallenge) {
		this.updating = this.completedLabel;
		console.log('updatingChallenge[0].challengeIdToUpdate-->', updatingChallenge[0].challengeIdToUpdate);
		console.log('this.updating-->', this.updating);
		updateChallenges({
			challenge: updatingChallenge[0].challengeIdToUpdate,
			activeAvailable: this.updating,
			userId: Id
		})
			.then((result) => {
				console.log('result'+JSON.stringify(result))
				if (result[0].error === null || result[0].error === undefined) {
					const activeChallengeIds = new Set(
						this.updateChallenge2.map(
							(challenge) => challenge.challengeIdToUpdate
						)
					);
					this.activeChallenges = this.activeChallenges.filter(
						(challenge) =>
							!activeChallengeIds.has(challenge.challengeIdToUpdate)
					);
					this.showInfos();
					this.updateChallenge2 = {};
					this.isLoading = false;
					this.activeCount = this.activeChallenges.length;
					this.congrats = true;
				} else {
					this.showQuestion = false;
					this.isLoading = false;
					this.congrats = false;
					this.percentageCompleted = result[0].percentage;
					console.log('this.percentageCompleted'+JSON.stringify(this.percentageCompleted))
				}
			})
			.catch((error) => {
				this.isLoading = false;
				this.showToast(errormessages, error.message, errorvariant);
			});
	}

	//This method is used to remove the Active Challenges.
	removeActiveChallenge(event) {
		this.isLoading = true;
		const componentId = event.detail.challengeidtoupdate;
		this.updateChallenge1 = this.activeChallenges.filter(
			(challenges) => challenges.challengeIdToUpdate === componentId
		);
		this.updating = this.availableLabel;
		updateChallenges({ challenge: componentId, activeAvailable: this.updating, userId: Id })
			.then(() => {
				const activeChallengeIds = new Set(
					this.availableChallenges.map(
						(challenge) => challenge.challengeIdToUpdate
					)
				);
				const updatedChallenges = this.updateChallenge1.map((challenge) => {
					if (activeChallengeIds.has(challenge.challengeIdToUpdate)) {
						const existingChallengeIndex = this.availableChallenges.findIndex(
							(existingChallenge) =>
								existingChallenge.challengeIdToUpdate ===
								challenge.challengeIdToUpdate
						);
						if (existingChallengeIndex !== -1) {
							return challenge;
						}
					}
					return challenge;
				});


				this.availableChallenges = [
					...this.availableChallenges,
					...updatedChallenges
				];
				this.showinfo();
				this.updateChallenge1 = {};
				this.isLoading = false;
				this.availableCount = this.availableChallenges.length;
			})

			.catch((error) => {
				this.isLoading = false;
				this.showToast(errormessages, error.message, errorvariant);
			});
		this.activeChallenges = this.activeChallenges.filter(
			(challenge) => challenge.challengeIdToUpdate !== componentId
		);
		this.showInfos();
	}

	//This method is used to remove the Available Challenges.
	removeAvailableChallenge(event) {
		this.isLoading = true;
		const componentId = event.detail.challengeidtoupdate;
		this.updateChallenge = this.availableChallenges.filter(
			(challenges) => challenges.challengeIdToUpdate === componentId
		);
		this.updating = this.activeLabel;
		updateChallenges({ challenge: componentId, activeAvailable: this.updating, userId: Id })
			.then(() => {
				this.isLoading = false;
				window.location.assign(window.location.href);
			})
			.catch((error) => {
				this.isLoading = false;
				this.showToast(errormessages, error.message, errorvariant);
			});
		this.showinfo();
	}
	showinfo() {
		if (
			Array.isArray(this.availableChallenges) &&
			this.availableChallenges.length === 0
		) {
			this.showInfo1 = true;
		} else {
			this.showInfo1 = false;
		}
	}

	// This is used to get the Available random challlenges
	getRandomChallengesCommon() {
		let status = this.availableLabel;
		getRandomChallenges({ personAccountId: this.enrolleId, status: status })
			.then((result) => {
				if (result !== null) {
					result = result.filter((obj) => Object.keys(obj).length !== 0);
					if (
						(Array.isArray(result) &&
							result.length === 1 &&
							Object.keys(result[0]).length === 0) ||
						result === null
					) {
						this.showInfo1 = true;
						this.showMore = false;
						this.showLess = false;
					} else {
						let filteredResult;
						if (this.activeChallenges.length > 0) {
							filteredResult = result.filter((challenge) => {
								return !this.activeChallenges.some(
									(activeChallenge) =>
										activeChallenge.challengeIdToUpdate ===
										challenge.challengeIdToUpdate
								);
							});
						} else {
							filteredResult = result;
						}
						let filteredArray = filteredResult.filter(
							(obj) => Object.keys(obj).length !== 0
						);
						if (filteredArray.length < this.showMoreCount) {
							// If there are fewer than 4 records after filtering, set the initial 4 records
							if (filteredArray !== "" || filteredArray !== null) {
								this.availableChallenges = filteredArray;
							}
							this.showMore = false;
						} else {
							// If there are 4 or more records after filtering, set the initial 4
							if (filteredArray !== "" || filteredArray !== null) {
								this.availableChallenges = filteredArray.slice(
									0,
									this.showMoreCount
								);
							}
							if (filteredArray.length > 3) {
								this.showMore = true;
							}
						}
						if (
							filteredArray.length === this.availableChallenges.length &&
							filteredArray.length !== 0 &&
							filteredArray.length > 3
						) {
							this.showLess = true;
						} else {
							this.showLess = false;
						}
						if (result.length > 0) {
							this.showInfo1 = false;
							this.availableCount = filteredArray.length;
						} else {
							this.showInfo1 = true;
							this.showMore = false;
							this.showLess = false;
						}
					}
				} else {
					this.showInfo1 = true;
				}
			})
			.catch((error) => {
				this.showToast(errormessages, error.message, errorvariant);
			});
	}

	//Functionality for show less button
	handleShowLessClick() {
		this.showLess = false;
		this.availableChallenges = [];
		this.showMoreCount = 3;
		this.getRandomChallengesCommon();
	}

	//this method used for showing more Available challenges
	handleShowMoreClick() {
		let status = this.availableLabel;
		this.showMoreCount += 3;
		getRandomChallenges({ personAccountId: this.enrolleId, status: status })
			.then((result) => {
				result = result.filter((obj) => Object.keys(obj).length !== 0);
				if (result !== null) {
					this.showInfo1 = false;
					if (result.length > this.availableChallenges.length) {
						const newChallenges = result.slice(
							this.availableChallenges.length,
							this.showMoreCount
						);
						this.availableChallenges = [
							...this.availableChallenges,
							...newChallenges
						];
					}
					if (result.length === this.availableChallenges.length) {
						this.showLess = true;
						this.showMore = false;
					} else if (result.length > 3) {
						this.showLess = false;
						this.showMore = true;
					}
				} else {
					this.showInfo1 = true;
					this.showLess = false;
					this.showMore = false;
				}
			})
			.catch((error) => {
				this.showToast(errormessages, error.message, errorvariant);
			});
	}
	// Its shows the Infromation about active challenges
	showInfos() {
		if (this.activeChallenges === null || this.activeChallenges.length === 0) {
			this.showInfo = true;
		} else {
			this.showInfo = false;
		}
	}
	// showToast used for all the error messages caught
	showToast(title, message, variant, mode) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant,
			mode: mode
		});
		this.dispatchEvent(event);
	}
}