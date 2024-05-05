//This Lightning Web Component fetches user enrollment, ranks, and completed challenges from Apex methods, dynamically updating the UI with pagination controls.
//To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//To get current user Id
import Id from "@salesforce/user/Id";
//To import apex classess
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getRandomChallenges from '@salesforce/apex/BI_PSP_ChallengeCtrl.getRandomChallenges';
import getRank from '@salesforce/apex/BI_PSP_ChallengeCtrl.getRank';
//To import static resources
import NoviceImage from '@salesforce/resourceUrl/BI_PSP_NoviceImage';
import BeginnerImage from '@salesforce/resourceUrl/BI_PSP_BeginnerImage';
import IntermediateImage from '@salesforce/resourceUrl/BI_PSP_IntermediateImage';
import ProficientImage from '@salesforce/resourceUrl/BI_PSP_ProficientImage';
import ExpertImage from '@salesforce/resourceUrl/BI_PSP_ExpertImage';
import Novicestar from '@salesforce/resourceUrl/BI_PSP_NoviceImage_Nostar';
import Beginnerstar from '@salesforce/resourceUrl/BI_PSP_BeginnerImage_Nostar';
import Intermediatestar from '@salesforce/resourceUrl/BI_PSP_IntermediateImage_Nostar';
import Proficientstar from '@salesforce/resourceUrl/BI_PSP_ProficientImage_Nostar';
import Expertstar from '@salesforce/resourceUrl/BI_PSP_ExpertImage_Nostar';
//To import custom labels
import Expert_Gpp from '@salesforce/label/c.BI_PSP_Expert_Gpp';
import Beginner_Gpp from '@salesforce/label/c.BI_PSP_Beginner_Gpp';
import Intermediate_Gpp from '@salesforce/label/c.BI_PSP_Intermediate_Gpp';
import Novice_Gpp from '@salesforce/label/c.BI_PSP_Novice_Gpp';
import Proficient_Gpp from '@salesforce/label/c.BI_PSP_Proficient_Gpp';
import errormessages from "@salesforce/label/c.BI_PSP_ConsoleError";
import errorvariant from "@salesforce/label/c.BI_PSPB_errorVariant";
import rankLevelTwo from "@salesforce/label/c.BI_PSP_RankLevelTwo";
import rankLevelThree from "@salesforce/label/c.BI_PSP_RankLevelThree";
import rankLevelFour from "@salesforce/label/c.BI_PSP_RankLevelFour";
import rankLevelFive from "@salesforce/label/c.BI_PSP_RankLevelFive";
import rankLevelSix from "@salesforce/label/c.BI_PSP_RankLevelSix";
import statusCompleted from "@salesforce/label/c.BI_PSP_Challenge_Completed";

export default class BiPspbTrophyCaseComponent extends LightningElement {
	@track completedChallenges = [];
	@track imageRanks = [];
	@track imageRanksToSend = [];
	showInfo;
	userId = Id;
	displayedRecords = 3;
	showMore;
	showLess;
	selectedAvatarSrc;
	novice;
	beginner;
	intermediate;
	proficient;
	expert;
	showError;
	errorMessage;
	enrolleId;
	//Used to format the passed date value
	formatDate(dateString) {
		const date = new Date(dateString);
		const month = (date.getMonth() + 1).toString().padStart(2, '0');
		const day = date.getDate().toString().padStart(2, '0');
		const year = date.getFullYear();
		return `${month}/${day}/${year}`;
	}
	//Used to get the patient's enrollee details, calulates the ranks to display the respective trophy
	connectedCallback() {
		try {
			getEnrolle({ userId: this.userId })
				.then(result => { // Null check has been handled in its respective apex method
					if (result[0].patientEnrolle !== null) {
						this.showError = false;
						this.enrolleId = result[0].patientEnrolle.Id;
						this.getRanks();
						this.getCompletedChallenge();
					} else if (result[0].error !== null) {
						this.showError = true;
						this.errorMessage = result[0].error;
					}
				})
				.catch(error => {
					this.showToast(errormessages, error.message, errorvariant);
				})
		}
		catch (error) {
			this.showToast(errormessages, error.message, errorvariant);
		}
	}

	// this event is used for get ranks in Trophy
	getRanks() {
		try {
			getRank({ personAccountId: this.enrolleId })
				.then(result => {// Null check has been handled in its respective apex method
					this.imageRanks = result;

					if (this.imageRanks[0].BI_PSP_DOC_Novice__c !== null) {
						const dateString = this.imageRanks[0].BI_PSP_DOC_Novice__c;
						this.novice = this.formatDate(dateString);
					}
					if (this.imageRanks[0].BI_PSP_DOC_Beginner__c !== null) {
						const dateString = this.imageRanks[0].BI_PSP_DOC_Beginner__c;
						this.beginner = this.formatDate(dateString);
					}

					if (this.imageRanks[0].BI_PSP_DOC_Intermediate__c !== null) {
						const dateString = this.imageRanks[0].BI_PSP_DOC_Intermediate__c;
						this.intermediate = this.formatDate(dateString);
					}

					if (this.imageRanks[0].BI_PSP_DOC_Proficient__c !== null) {
						const dateString = this.imageRanks[0].BI_PSP_DOC_Proficient__c;
						this.proficient = this.formatDate(dateString);
					}

					if (this.imageRanks[0].BI_PSP_DOC_Expert__c !== null) {
						const dateString = this.imageRanks[0].BI_PSP_DOC_Expert__c;
						this.expert = this.formatDate(dateString);
					}
					if (this.imageRanks[0].BI_PSP_Challenge_Rank__c === Novice_Gpp) {
						const imageData = { image: NoviceImage, date: this.novice, level: rankLevelTwo };
						this.imageRanksToSend.push(imageData);
						const imageData1 = { image: Beginnerstar, level: rankLevelThree };
						this.imageRanksToSend.push(imageData1);
						const imageData2 = { image: Intermediatestar, level: rankLevelFour };
						this.imageRanksToSend.push(imageData2);
						const imageData3 = { image: Proficientstar, level: rankLevelFive };
						this.imageRanksToSend.push(imageData3);
						const imageData5 = { image: Expertstar, level: rankLevelSix };
						this.imageRanksToSend.push(imageData5);
					} else if (this.imageRanks[0].BI_PSP_Challenge_Rank__c === Beginner_Gpp) {
						const imageData = { image: NoviceImage, date: this.novice, level: rankLevelTwo };
						this.imageRanksToSend.push(imageData);
						const imageData1 = { image: BeginnerImage, date: this.beginner, level: rankLevelThree };
						this.imageRanksToSend.push(imageData1);
						const imageData2 = { image: Intermediatestar, level: rankLevelFour };
						this.imageRanksToSend.push(imageData2);
						const imageData3 = { image: Proficientstar, level: rankLevelFive };
						this.imageRanksToSend.push(imageData3);
						const imageData5 = { image: Expertstar, level: rankLevelSix };
						this.imageRanksToSend.push(imageData5);
					} else if (this.imageRanks[0].BI_PSP_Challenge_Rank__c === Intermediate_Gpp) {
						const imageData = { image: NoviceImage, date: this.novice, level: rankLevelTwo };
						this.imageRanksToSend.push(imageData);
						const imageData1 = { image: BeginnerImage, date: this.beginner, level: rankLevelThree };
						this.imageRanksToSend.push(imageData1);
						const imageData2 = { image: IntermediateImage, date: this.intermediate, level: rankLevelFour };
						this.imageRanksToSend.push(imageData2);
						const imageData3 = { image: Proficientstar, level: rankLevelFive };
						this.imageRanksToSend.push(imageData3);
						const imageData5 = { image: Expertstar, level: rankLevelSix };
						this.imageRanksToSend.push(imageData5);
					} else if (this.imageRanks[0].BI_PSP_Challenge_Rank__c === Proficient_Gpp) {
						const imageData = { image: NoviceImage, date: this.novice, level: rankLevelTwo };
						this.imageRanksToSend.push(imageData);
						const imageData1 = { image: BeginnerImage, date: this.beginner, level: rankLevelThree };
						this.imageRanksToSend.push(imageData1);
						const imageData2 = { image: IntermediateImage, date: this.intermediate, level: rankLevelFour };
						this.imageRanksToSend.push(imageData2);
						const imageData3 = { image: ProficientImage, date: this.proficient, level: rankLevelFive };
						this.imageRanksToSend.push(imageData3);
						const imageData5 = { image: Expertstar, level: rankLevelSix };
						this.imageRanksToSend.push(imageData5);
					} else if (this.imageRanks[0].BI_PSP_Challenge_Rank__c === Expert_Gpp) {
						const imageData = { image: NoviceImage, date: this.novice, level: rankLevelTwo };
						this.imageRanksToSend.push(imageData);
						const imageData1 = { image: BeginnerImage, date: this.beginner, level: rankLevelThree };
						this.imageRanksToSend.push(imageData1);
						const imageData2 = { image: IntermediateImage, date: this.intermediate, level: rankLevelFour };
						this.imageRanksToSend.push(imageData2);
						const imageData3 = { image: ProficientImage, date: this.proficient, level: rankLevelFive };
						this.imageRanksToSend.push(imageData3);
						const imageData5 = { image: ExpertImage, date: this.expert, level: rankLevelSix };
						this.imageRanksToSend.push(imageData5);
					} else {
						const imageData = { image: Novicestar, level: rankLevelTwo };
						this.imageRanksToSend.push(imageData);
						const imageData1 = { image: Beginnerstar, level: rankLevelThree };
						this.imageRanksToSend.push(imageData1);
						const imageData2 = { image: Intermediatestar, level: rankLevelFour };
						this.imageRanksToSend.push(imageData2);
						const imageData3 = { image: Proficientstar, level: rankLevelFive };
						this.imageRanksToSend.push(imageData3);
						const imageData5 = { image: Expertstar, level: rankLevelSix };
						this.imageRanksToSend.push(imageData5);
					}
				})
				.catch(error => {
					this.showToast(errormessages, error.message, errorvariant);
				})
		}
		catch (error) {
			this.showToast(errormessages, error.message, errorvariant);
		}
	}
	recordcount = 0;
	// This event is used for get  Complete challenges record
	getCompletedChallenge() {
		try {
			let status = statusCompleted;
			getRandomChallenges({ personAccountId: this.enrolleId, status: status }).then(result => {
				result = result.filter(obj => Object.keys(obj).length !== 0)
				this.completedChallenges = result;
				this.recordcount = result.length;
				if (result.length > 3) {
					this.completedChallenges = result.slice(0, this.displayedRecords);

					this.showMore = true;
					this.displayedRecords += 3;
				} else {
					this.showMore = false;
					this.completedChallenges = result;
				}
				this.showInfos();

			}).catch(error => {
				this.showToast(errormessages, error.message, errorvariant);
			});
		}
		catch (error) {
			this.showToast(errormessages, error.message, errorvariant);
		}
	}
	showInfos() {
		if (Array.isArray(this.completedChallenges) && this.completedChallenges.length === 0) {
			this.showInfo = true;
		} else {
			this.showInfo = false;
		}
	}

	// this event is used for show morw button
	handleShowMoreClick() {
		let status = statusCompleted;
		getRandomChallenges({ personAccountId: this.enrolleId, status: status }).then(result => {
			result = result.filter(obj => Object.keys(obj).length !== 0);
			let filteredResult;
			if (result !== null || result !== '') {
				filteredResult = result;
				if (filteredResult.length < this.displayedRecords) {
					// If there are fewer than 3 records after filtering, set the initial 3 records
					this.completedChallenges = filteredResult;
					this.showMore = false;
					this.displayedRecords += 3;
				} else {
					// If there are 3 or more records after filtering, set the initial 3
					this.completedChallenges = filteredResult.slice(0, this.displayedRecords);
					this.showMore = true;
					this.displayedRecords += 3;
				}
				if (this.displayedRecords < this.completedChallenges.length) {
					// Increment the number of displayed records.
					this.displayedRecords += 3; // You can change this number as needed.
					this.showInfos();
				}
				if (filteredResult.length === this.completedChallenges.length) {
					this.showLess = true;
					this.showMore = false;
				} else {
					this.showLess = false;
					this.showMore = true;
				}
			}

		}).catch(error => {
			this.showToast(errormessages, error.message, errorvariant);
		});

	}
	//Used for show less button functionality
	handleShowLessClick() {
		this.showLess = false;
		this.completedChallenges = [];
		this.displayedRecords = 3;
		this.getCompletedChallenge();
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