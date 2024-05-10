//This Lightning web component is used User Fatiguesymptoms insert values
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation'
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Apex Classes
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getAllergyIntolerancedata from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getAllergyIntolerancedata';
import recordUpdateAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordUpdateAllergyIntolerance';
import recordInsertAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordInsertAllergyIntolerance';
// To import Custom Labels
import fatiguevalues from '@salesforce/label/c.BI_PSPB_Fatique';
import zerovalue from '@salesforce/label/c.BI_PSP_Slidervaluestwodigit';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class biPspFatiguesymptom extends NavigationMixin(LightningElement) {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	@track isButtonDisabled = false;
	@track fatiqueerrors = false;
	@track sliderValuetwo = zerovalue;
	@track valoF;
	@track humanparts = ''
	@track sliderValue = 0;
	@track fatiguevalues = fatiguevalues;
	// As this is a css property which changes dynamically so we can't use custom label for this scenario
	@track colorchange = 'symptoms'
	@track localStorageValueitchiness;
	@track insertcount
	@track moodvalues = '';
	@track allergyIntoleranceData;
	@track itchbody;
	@track intensity
	@track carePlanTemplateName;
	// Variable declaration
	recordInsertCount = 0;
	userId = Id;
	accountId;
	val = 0;
	// Process retrieved allergy intolerance data, updating UI and properties, particularly for fatigue symptoms detection.
	@wire(getAllergyIntolerancedata, { symptomTrackerId: '$lastsymptomid' })
	wiredAllergyIntoleranceData({ error, data }) {
		if (data && data !== null){
			try {
				// Initialize variables
				let itchbody = '';
				for (let record of data) {
					// Access values of each record
					itchbody = record.BI_PSP_Bodyparts__c;
					this.intensity = record.BI_PSP_Intensity__c;
					let carePlanTempla = record?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name
					if (carePlanTempla === fatiguevalues) {
						this.carePlanTemplateName = fatiguevalues;
					}
					// Compare with the string 'Itchiness'
					if (this.carePlanTemplateName === fatiguevalues) {
						this.sliderValue = this.intensity;
						this.sliderValuetwo = this.intensity;
						let bodyPartsArr = itchbody?.split(';');
						//Using this with a minimal delay ensures smooth UI updates by deferring DOM manipulation, preventing potential rendering issues.
						setTimeout(() => {
							try {
								bodyPartsArr.forEach(i => {
									let element = this.template.querySelector(`[data-name='${i}']`);
									if (element) {
										element.style.fill = '#8D89A5';
									} else {
										element.style.fill = '';
									}
								});
							} catch (innerErr) {
								this.showToast(errormessage, innerErr.message, errorvariant);
							}
						}, 0.111111);
					}
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	// To fetch enrolle Id and fatique data
	connectedCallback() {
		try {
	//This code retrieves data labeled as 'countfati' from the session storage without altering custom labels.
			this.insertcount = sessionStorage.getItem('countfati');
	//This code retrieves data labeled as 'fatigue' from the session storage without altering custom labels.
			let mybodyparts = sessionStorage.getItem('fatigue');
	//This code retrieves data labeled as 'fatigueintensity' from the session storage without altering custom labels.
			let mybodyinternsity = sessionStorage.getItem('fatigueintensity');
			if (mybodyinternsity) {
				let bodyPartsArr = mybodyparts?.split(',');
				//The setTimeout with a small delay ensures UI updates occur after the current rendering tasks, preventing glitches.
				setTimeout(() => {
					try {
						
						this.sliderValue = mybodyinternsity;
						this.sliderValuetwo = mybodyinternsity;
					} catch (error) {
						this.showToast(errormessage, error.message, errorvariant);
					}
				}, 0.111111);
			}
			//This code retrieves data labeled as 'symptomlastid' from the session storage without altering custom labels.
			this.lastsymptomid = localStorage.getItem('symptomlastid')
			//this.fatiqueerrors =true; 
			this.isButtonDisabled = true;
			//getAllergyIntolerancedata()	

			getEnrolle({ userId: this.userId })
			// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => {
					if (result != null) {
						if (result[0].patientEnrolle != null) {
							this.accountId = result[0].patientEnrolle.Id;
						} else if (result[0].error != null) {
							this.showError = true;
							this.errorMessage = result[0].error;
						}
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);
				});

			//Change this value based on your actual condition
			//This code retrieves data labeled as 'Time' from the session storage without altering custom labels.
			this.localStorageValueitchiness = localStorage.getItem('Time', this.resultId)
			// Get the initial count of elements with class 'body-part' on component load	
			this.currntmooderror = true;
			// Change this value based on your actual condition
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}


	}
	//Manages record updates or inserts based on slider input
	async onchangeAccept() {
				console.log(this.sliderValue,'cbcb',this.localStorageValueitchiness )
		let itchinessallrecordinsert = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.localStorageValueitchiness || this.lastsymptomid, // Use default value if lastsymptomid is null
			Symptomname: this.fatiguevalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.moodvalues || '', // Use default value if moodvalues is null
		};this.bodyparts = this.humanparts;
		let itchinessallrecordupdate = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.lastsymptomid || this.localStorageValueitchiness, // Use default value if lastsymptomid is null
			Symptomname: this.fatiguevalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.moodvalues || '', // Use default value if moodvalues is null
		};this.bodyparts = this.humanparts;
		try {
			if (this.sliderValue > 0) {
				// If slider value is positive and insertcount is 1, update allergy intolerance records
				if (this.insertcount == 1) {
					await recordUpdateAllergyIntolerance({
						itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.humanparts
					})
					// Null data is checked and AuraHandledException is thrown from the Apex
						.then(result => {			
							if (result && result !== null) {
							// Store data labeled as 'fatigue' in the session storage without altering custom labels.
								sessionStorage.setItem('fatigue', this.sliderValue);
							// Store data labeled as 'fatigueintensity' in the session storage without altering custom labels.
								sessionStorage.setItem('fatigueintensity', this.sliderValue);
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
					if (this.lastsymptomid && this.carePlanTemplateName === fatiguevalues) {
						await recordUpdateAllergyIntolerance({
							itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.humanparts
						})
						// Null data is checked and AuraHandledException is thrown from the Apex
							.then(result => {
								if (result && result !== null) {
				// Store data labeled as 'fatigue' in the session storage without altering custom labels
									sessionStorage.setItem('fatigue', this.sliderValue);
				// Store data labeled as 'fatigueintensity' in the session storage without altering custom labels
									sessionStorage.setItem('fatigueintensity', this.sliderValue);
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
						await recordInsertAllergyIntolerance({
							itchinessallrecordinsert: itchinessallrecordinsert, bodyParts: this.humanparts
						})
						// Null data is checked and AuraHandledException is thrown from the Apex
							.then(result => {
								if (result && result !== null) {
									sessionStorage.setItem('fatigue', this.sliderValue);
						// Store data labeled as 'fatigueintensity' in the session storage without altering custom labels.
									sessionStorage.setItem('fatigueintensity', this.sliderValue);
									const updateEvent = new CustomEvent('updatechildprop', {
										detail: false
									});
									this.dispatchEvent(updateEvent);
									this.recordInsertCount++;
						// Store data labeled as 'countfati' in the session storage without altering custom labels.
									sessionStorage.setItem('countfati', this.recordInsertCount);
								}
							})
							.catch(error => {
								this.showToast(errormessage, error.message, errorvariant);
							});
					}
				}
			}
			else {
				this.fatiqueerrors = true;
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	// When the value of the slider changes, it reflect the new value selected by the user.
	handleSliderChange(event) {
		this.sliderValue = event.target.value;
	}
	recentactivity = false;
	handleEmojiClick(event) {
		this.sliderValue = event.target.value;
		this.sliderValuetwo = ('0' + this.sliderValue).slice(-2);
		this.updateThumbLabelPosition(this.sliderValue);
		//Convert this.sliderValuetwo to a number for comparison
	}

	// used to display slider values
	//The use of requestAnimationFrame ensures optimal timing for thumb label position updates, enhancing animation smoothness and performance 
	updateThumbLabelPosition(sliderValue) {
		requestAnimationFrame(() => {
			const slider = this.template.querySelector('input');
			const thumbLabel = this.template.querySelector('.thumb-label');
			const thumbWidth = (window.getComputedStyle(thumbLabel).width);
			const sliderWidth = slider.offsetWidth;
			const thumbPosition = (sliderValue / slider.max) * (sliderWidth - thumbWidth);
			const newPosition = thumbPosition + (thumbWidth / 2) - (sliderWidth / 2);
			const maxPosition = sliderWidth - thumbWidth;
			thumbLabel.style.left = Math.min(maxPosition, Math.max(0, newPosition)) + 'px';
			thumbLabel.setAttribute('data-value', sliderValue);
		});
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