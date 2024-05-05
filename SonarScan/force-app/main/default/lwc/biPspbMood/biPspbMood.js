// This components using user reaction save values store this lwc
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation'
// To import Static Resources
import HAPPY from '@salesforce/resourceUrl/BI_PSP_Happymood';
import SAD from '@salesforce/resourceUrl/BI_PSP_sadmood';
import SPEECHLESS from '@salesforce/resourceUrl/BI_PSP_speechlessmood';
import WORRIED from '@salesforce/resourceUrl/BI_PSP_worriedmood';
import JOYFULL from '@salesforce/resourceUrl/BI_PSP_joyfullmood';
import replaceHapy from '@salesforce/resourceUrl/BI_PSP_HappyColouredReal';
import replaceJoyful from '@salesforce/resourceUrl/BI_PSP_Joyful';
import replaceSadL from '@salesforce/resourceUrl/BI_PSP_Sad';
import Boxedicon from '@salesforce/resourceUrl/BI_PSP_Boxedicon';
import replaceSpeechless from '@salesforce/resourceUrl/BI_PSP_Speechless';
import replaceSWorried from '@salesforce/resourceUrl/BI_PSP_Worried';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Apex Classes
import getAllergyIntolerancedata from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getAllergyIntolerancedata';
import recordUpdateAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordUpdateAllergyIntolerance';
import recordInsertAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordInsertAllergyIntolerance';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
// To import Custom Labels
import itchinessvalues from '@salesforce/label/c.BI_PSPB_Mood';
import sadmood from '@salesforce/label/c.BI_PSPB_Sad';
import happymood from '@salesforce/label/c.BI_PSPB_Happy';
import joyfullmood from '@salesforce/label/c.BI_PSPB_Joyfull';
import speechlessmood from '@salesforce/label/c.BI_PSPB_Speechless';
import wooriedmood from '@salesforce/label/c.BI_PSPB_Worried';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class biPspMood extends NavigationMixin(LightningElement) {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	@track currntmooderror = false;
	@track Boxedicon = Boxedicon;
	@track valoF;
	@track localStorageValueitchiness;
	@track lastsymptomid;
	@track emojiName = [];
	@track sliderValue = 0;
	@track currntmooderrorsad = false;
	@track insertcount;
	@track itchinessvalues = itchinessvalues;
	@track allergyIntoleranceData;
	@track carePlanTemplateName;
	//Variable declaration
	wooriedmood = wooriedmood;
	speechlessmood = speechlessmood;
	joyfullmood = joyfullmood;
	happymood = happymood;
	sadmood = sadmood;
	recordInsertCount = 0;
	accountId;
	userId = Id;
	selectedEmoji = null;
	imgUrlSad = SAD;
	imgUrlWorr = WORRIED;
	imgUrlSPEECHLESS = SPEECHLESS;
	imgUrlJOYFULL = JOYFULL;
	imgUrlHAPPY = HAPPY;
	isButtonDisabled = false;
	// Process retrieved allergy intolerance data, updating UI and properties, particularly for fatigue symptoms detection.
	@wire(getAllergyIntolerancedata, { symptomTrackerId: '$lastsymptomid' })
	wiredAllergyIntoleranceData({ error, data }) {
		if (data && data !== null) {
			try {
				// Initialize variables
				let moodsymptom;
				// ...(Previous code)
				for (let record of data) {
					// Access values of each record
					moodsymptom = record.BI_PSP_Mood__c;
					let carePlanTempla = record?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name;
					//Check if care plan template name matches 'Temperature' and set corresponding values				
					if (carePlanTempla === itchinessvalues) {
						this.carePlanTemplateName = itchinessvalues;
					}
					this.moodreaction = record.BI_PSP_Mood__c;
					if (this.carePlanTemplateName === itchinessvalues) {
						// Compare with the string 'Mood'
						this.carePlanTemplateName = itchinessvalues;
						if (moodsymptom?.toLowerCase() === sadmood) {
							this.imgUrlSad = replaceSadL;
						}
						if (moodsymptom?.toLowerCase() === happymood) {
							this.imgUrlHAPPY = replaceHapy;
						}
						if (moodsymptom?.toLowerCase() === joyfullmood) {
							this.imgUrlJOYFULL = replaceJoyful;
						}
						if (moodsymptom?.toLowerCase() === speechlessmood) {
							this.imgUrlSPEECHLESS = replaceSpeechless;
						}
						if (moodsymptom?.toLowerCase() === wooriedmood) {
							this.imgUrlWorr = replaceSWorried;
						}
						this.selectedEmoji = moodsymptom;
					}
				}
				// ...(Rest of the code)
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	// To Fetch enrolle Id and Moodsymptom data
	connectedCallback() {
		try {
//This code retrieves data labeled as 'myData' from the session storage without altering custom labels.			
			this.insertcount = sessionStorage.getItem('countmood');
			//Initialize button disabled state
			this.isButtonDisabled = true;
			//Retrieve mood symptom from session storage and set last symptom id
			//This code retrieves data labeled as 'myData' from the session storage without altering custom labels.			
			let moodsymptom = sessionStorage.getItem('mood', this.emojiName);
			//This code retrieves data labeled as 'myData' from the session storage without altering custom labels.			
			this.lastsymptomid = localStorage.getItem('symptomlastid')
			//Set image URLs based on mood symptom
			if (moodsymptom?.toLowerCase() === sadmood) {
				this.imgUrlSad = replaceSadL;
			}
			if (moodsymptom?.toLowerCase() === happymood) {
				this.imgUrlHAPPY = replaceHapy;
			}
			if (moodsymptom?.toLowerCase() === joyfullmood) {
				this.imgUrlJOYFULL = JOYFULL;
			}
			if (moodsymptom?.toLowerCase() === speechlessmood) {
				this.imgUrlSPEECHLESS = SPEECHLESS;
			}
			if (moodsymptom?.toLowerCase() === wooriedmood) {
				this.imgUrlWorr = replaceSadL;
			}
			//Set the selected emoji based on mood symptom
			this.selectedEmoji = moodsymptom;
	
			getEnrolle({ userId: this.userId })
			// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => {
					if (result != null) {
						if (result[0].patientEnrolle != null) {
							this.accountId = result[0].patientEnrolle.Id;
							//Additional processing if needed
						} else if (result[0].error != null) {
							this.showError = true;
							this.errorMessage = result[0].error;
						}
					}
				})
				.catch(error => {
					//Handle any errors that occurred during the promise chain
					this.showToast(errormessage, error.message, errorvariant);
					//Additional error handling if needed
				});
				//This code retrieves data labeled as 'myData' from the session storage without altering custom labels.			
			this.localStorageValueitchiness = localStorage.getItem('Time', this.resultId)
			this.currntmooderror = true;
		} catch (err) {
			// Handle any errors that occurred during the execution of the connectedCallback function
			this.showToast(errormessage, err.message, errorvariant);
			// Additional error handling if needed
		}
	}

	//Handle emoji click event to set the selected emoji name
	handleEmojiClick(event) {
		this.emojiName = event.currentTarget.getAttribute('data-name');
		this.isButtonDisabled = false;
		if (this.emojiName === sadmood) {
			this.currntmooderror = false;
			this.currntmooderrorsad = true;
			//Update image URLs based on the previously selected emoji
			switch (this.selectedEmoji) {
				case happymood:
					this.imgUrlHAPPY = HAPPY;
					break;
				case joyfullmood:
					this.imgUrlJOYFULL = JOYFULL;
					break;
				case speechlessmood:
					this.imgUrlSPEECHLESS = SPEECHLESS;
					break;
				case wooriedmood:
					this.imgUrlWorr = WORRIED;
					break;
				case sadmood:
					this.imgUrlSad = SAD;
					break;
				default:
					break;
			}
			//Update image URLs based on the newly selected emoji
			switch (this.emojiName) {
				case happymood:
					this.imgUrlHAPPY = replaceHapy;
					break;
				case joyfullmood:
					this.imgUrlJOYFULL = replaceJoyful;
					break;
				case speechlessmood:
					this.imgUrlSPEECHLESS = replaceSpeechless;
					break;
				case wooriedmood:
					this.imgUrlWorr = replaceSWorried;
					break;
				case sadmood:
					this.imgUrlSad = replaceSadL;
					break;
				default:
					break;
			}
			//Set the newly selected emoji as the current selectedEmoji
			this.selectedEmoji = this.emojiName;
		} else {
			this.currntmooderror = false;
			this.currntmooderrorsad = false;
			switch (this.selectedEmoji) {
				case happymood:
					this.imgUrlHAPPY = HAPPY;
					break;
				case joyfullmood:
					this.imgUrlJOYFULL = JOYFULL;
					break;
				case speechlessmood:
					this.imgUrlSPEECHLESS = SPEECHLESS;
					break;
				case wooriedmood:
					this.imgUrlWorr = WORRIED;
					break;
				case sadmood:
					this.imgUrlSad = SAD;
					break;
				default:
					break;
			}
			switch (this.emojiName) {
				case happymood:
					//Set image URL for happy emoji
					this.imgUrlHAPPY = replaceHapy;
					break;
				case joyfullmood:
					//Set image URL for joyful emoji
					this.imgUrlJOYFULL = replaceJoyful;
					break;
				case speechlessmood:
					//Set image URL for speechless emoji
					this.imgUrlSPEECHLESS = replaceSpeechless;
					break;
				case wooriedmood:
					//Set image URL for worried emoji
					this.imgUrlWorr = replaceSWorried;
					break;
				case sadmood:
					//Set image URL for sad emoji
					this.imgUrlSad = replaceSadL;
					break;
				default:
					break;
			}
			this.selectedEmoji = this.emojiName;
			this.isButtonDisabled = false;
			//Handle the error as needed (e.g., show an error message)
		}
	}
	//Async function to handle changes when accepting input
	async onchangeAccept() {
		let itchinessallrecordinsert = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.localStorageValueitchiness || this.lastsymptomid, // Use default value if lastsymptomid is null
			Symptomname: this.itchinessvalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.emojiName || '', // Use default value if moodvalues is null
		};this.bodyparts = this.bodyparts;
		let itchinessallrecordupdate = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.lastsymptomid || this.localStorageValueitchiness, // Use default value if lastsymptomid is null
			Symptomname: this.itchinessvalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.emojiName || '', // Use default value if moodvalues is null
		};this.bodyparts = this.bodyparts;
		//Try block to handle potential errors during record update or insertion
		try {
			if (this.insertcount == 1) {
				//Update existing record if insert count is 1             
				await recordUpdateAllergyIntolerance({
					itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.bodyparts
				})
				// Null data is checked and AuraHandledException is thrown from the Apex
					.then(result => {
		// Store data labeled as 'myData' in the session storage without altering custom labels.
						if (result && result !== null) {
							sessionStorage.setItem('mood', this.emojiName);
							const updateEvent = new CustomEvent('updatechildprop', {
								detail: false
							});
							this.dispatchEvent(updateEvent);
						}
					})
					.catch(error => {
						//Handle error if update fails
						this.showToast(errormessage, error.message, errorvariant);
					});
			}
			else {
				//Check condition for update or insert based on last symptom id and care plan template name
				if (this.lastsymptomid && this.carePlanTemplateName === itchinessvalues) {
					await recordUpdateAllergyIntolerance({
						itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.bodyparts
					})
					// Null data is checked and AuraHandledException is thrown from the Apex
						.then(result => {
					// Store data labeled as 'myData' in the session storage without altering custom labels.
							if (result && result !== null) {
								sessionStorage.setItem('mood', this.emojiName);
								const updateEvent = new CustomEvent('updatechildprop', {
									detail: false
								});
								this.dispatchEvent(updateEvent);
							}
						})
						.catch(error => {
							this.showToast(errormessage, error.message, errorvariant);
						});
				}
				else {
					//Insert new record if conditions don't match
					await recordInsertAllergyIntolerance({
						itchinessallrecordinsert: itchinessallrecordinsert, bodyParts: this.bodyparts
					})
					// Null data is checked and AuraHandledException is thrown from the Apex
						.then(result => {
					// Store data labeled as 'myData' in the session storage without altering custom labels.
							if (result && result !== null) {
							// Store data labeled as 'myData' in the session storage without altering custom labels.
								sessionStorage.setItem('mood', this.emojiName);
								const updateEvent = new CustomEvent('updatechildprop', {
									detail: false
								});
								this.dispatchEvent(updateEvent);
								this.recordInsertCount++;
								// Store data labeled as 'myData' in the session storage without altering custom labels.
								sessionStorage.setItem('countmood', this.recordInsertCount);
							}
						})
						.catch(error => {
							this.showToast(errormessage, error.message, errorvariant);
						});
				}
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	//Reset selected emoji to its default state if selected.
	handleClickForRemove() {
		if (this.selectedEmoji) {
			//Reset the selected emoji to its original state
			switch (this.selectedEmoji) {
				case happymood:
					this.imgUrlHAPPY = HAPPY;
					break;
				case joyfullmood:
					this.imgUrlJOYFULL = JOYFULL;
					break;
				case speechlessmood:
					this.imgUrlSPEECHLESS = SPEECHLESS;
					break;
				case wooriedmood:
					this.imgUrlWorr = WORRIED;
					break;
				case sadmood:
					this.imgUrlSad = SAD;
					break;
				default:
					break;
			}
			this.selectedEmoji = null; // Clear the selected emoji
			this.emojiName = null;
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