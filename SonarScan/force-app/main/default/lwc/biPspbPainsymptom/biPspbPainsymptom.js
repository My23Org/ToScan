//This components using user body parts and intencity itchiness values store this lwc
// To import Libraries
import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getAllergyIntolerancedata from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getAllergyIntolerancedata';
import recordInsertAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordInsertAllergyIntolerance';
import recordUpdateAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordUpdateAllergyIntolerance';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Custom Labels
import painvalues from '@salesforce/label/c.BI_PSPB_Pain';
import zero from '@salesforce/label/c.BI_PSPB_null';
import select from '@salesforce/label/c.BI_PSP_Bodypartsselectall';
import deselect from '@salesforce/label/c.BI_PSPB_deselect';
import blackvalue from '@salesforce/label/c.BI_PSP_Bodycolor';
import removeall from '@salesforce/label/c.BI_PSP_bodypartsRemove';
import zerovalue from '@salesforce/label/c.BI_PSP_Slidervaluestwodigit';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
export default class biPspbPain extends NavigationMixin(LightningElement) {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	// @api variable declaration
	@api resultId;
	// @track variable declaration
	@track redness = false;
	@track valoF;
	@track buttonText = select;
	@track clickCount = 0;
	@track totalElements = 0;
	@track sliderValue = 0;
	@track sliderValuetwo = zerovalue;
	@track isCheckedselectall = false;
	@track bodyparts = [] // Initialize the array
	@track moodvalues = ''
	@track painvalues = painvalues;
	@track insertcount;
	@track lastsymptomid;
	@track localStorageValueitchiness;
	@track clickedElement;
	@track isButtonDisabled = false;
	@track Fatiqueerrors = true;
	@track allergyIntoleranceData;
	@track itchbody;
	@track intensity
	@track carePlanTemplateName;
	@track itchinesserrors = false;
	// Variable declaration
	accountId;
	userId = Id
	recordInsertCount = 0;
	//Process retrieved allergy intolerance data, updating UI and properties, particularly for fatigue symptoms detection.
	@wire(getAllergyIntolerancedata, { symptomTrackerId: '$lastsymptomid' })
	wiredAllergyIntoleranceData({ error, data }) {
		if (data && data !== null){
			try {
				let itchbody = '';
				for (let record of data) {
					itchbody = record.BI_PSP_Bodyparts__c;
					this.intensity = record.BI_PSP_Intensity__c;
					let carePlanTempla = record?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name;
					//Check if care plan template name matches 'Temperature' and set corresponding values				
					if (carePlanTempla === painvalues) {
						this.carePlanTemplateName = painvalues;
					}
					if (this.carePlanTemplateName === painvalues) {
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
								this.bodyparts = [...bodyPartsArr];
								this.totalElements = bodyPartsArr.length;
								this.Itchinessvalues = false;
								this.itchinesserrors = this.totalElements <= 0;
								if (this.totalElements === 30) {
									this.isCheckedselectall = true;
									this.buttonText = removeall;
								}
							} catch (err) {
								this.showToast(errormessage, err.message, errorvariant);
								// Handle the error as needed
							}
						}, 0.111111);
						return;
					}
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	//Upon component connection, retrieves stored session data to initialize UI elements and component state
	connectedCallback() {
		try {
			//This code retrieves data labeled as 'countred' from the session storage without altering custom labels.
			this.insertcount = sessionStorage.getItem('countpain');
				//This code retrieves data labeled as 'redness' from the session storage without altering custom labels.
			let mybodyparts = sessionStorage.getItem('Paindata');
				//This code retrieves data labeled as 'myDataintensityredness' from the session storage without altering custom labels.
			let mybodyinternsity = sessionStorage.getItem('myDataintensity');
			if (mybodyparts && mybodyinternsity) {
				let bodyPartsArr = mybodyparts?.split(',');
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
						this.bodyparts = [...bodyPartsArr];
						this.totalElements = bodyPartsArr.length;
						this.sliderValue = mybodyinternsity;
						this.sliderValuetwo = mybodyinternsity;
						this.Itchinessvalues = false;
						if (this.totalElements === 30) {
							this.isCheckedselectall = true;
							this.buttonText = removeall;
						}
					} catch (error) {
						this.showToast(errormessage, error.message, errorvariant);
					}
				}, 0.111111);
			}
				//This code retrieves data labeled as 'symptomlastid' from the session storage without altering custom labels.
			this.lastsymptomid = localStorage.getItem('symptomlastid');
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
			this.updateThumbLabelPosition(this.sliderValue);
				//This code retrieves data labeled as 'Time' from the session storage without altering custom labels.
			this.localStorageValueitchiness = localStorage.getItem('Time', this.resultId);
			this.updateElementCount();
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	//Count the total number of elements and collect their data names
	updateElementCount() {
		const elements = this.template.querySelectorAll('.body-part');
		this.totalElements = elements.length;
		this.bodyparts = [];
		elements.forEach((ele) => {
			const dataNameValue = ele.getAttribute('data-name');
			this.bodyparts.push(dataNameValue);
		});
		elements.forEach((element) => {
			if (element.style.fill === blackvalue && this.buttonText === select) {
				this.totalElements = elements.length;
				element.style.fill = '';
			} else if (this.buttonText === deselect && element.style.fill === blackvalue) {
				element.style.fill = blackvalue;
			} else {
				this.totalElements = 0;
			}
		});
		this.isButtonDisabled = this.totalElements < 1;
		this.isButtonDisabled = this.sliderValue <= 0;
	}
	//Function to change color of body parts based on checkbox state
	changeColor(event) {
		const targetElements = this.template.querySelectorAll('.body-part');
		const checkbox = event.target;
		const isChecked = checkbox.checked;
		if (isChecked) {
			this.bodyparts = []
			this.isCheckedselectall = true;
			this.totalElements = 30;
			this.itchinesserrors = false;
			this.buttonText = removeall;
			targetElements.forEach((element) => {
				const dataNameValue = element.getAttribute('data-name');
				element.style.fill = '#8D89A5';
				//Add selected value to bodyparts array
				this.bodyparts.push(dataNameValue);
			});
		} else {
			this.totalElements = 0;
			this.isCheckedselectall = false;
			this.buttonText = select;
			targetElements.forEach((element) => {
				const dataNameValue = element.getAttribute('data-name');
				element.style.fill = '';
				//Remove unselected value from bodyparts array
				this.bodyparts = this.bodyparts.filter(item => item !== dataNameValue);
			});
		}
		this.clickCount++;
	}
	resetCount() {
		this.updateElementCount = 0;
	}
	// Disable button if any element is filled black or empty.
	handleAccept() {
		const elements = this.template.querySelectorAll('.body-part');
		elements.forEach((element) => {
			if (element.style.fill === blackvalue) {
				this.isButtonDisabled = true;
			} else if (element.style.fill === '') {
				this.isButtonDisabled = true;
			}
		});
	}
	//Handle the remove button click here
	handleRemove() {
		this.sliderValue = 0;
		this.sliderValuetwo = (zero + this.sliderValue).slice(-2)
	}
	//Some condition when you want to disable the button
	handleEmojiClick(event) {
		this.sliderValue = event.target.value
		this.sliderValuetwo = (zero + this.sliderValue).slice(-2);
		this.updateThumbLabelPosition(this.sliderValue);
	}
	//Function to handle click events based on body parts
	handleclick(event) {
		this.clickedElement = event.currentTarget;
		const selectedValue = this.clickedElement.getAttribute('data-name');
		const currentColor = this.clickedElement.style.fill;
		if (currentColor === 'rgb(141, 137, 165)') {
			this.clickedElement.style.fill = '';
			this.bodyparts = this.bodyparts.filter(item => item !== selectedValue);
			this.totalElements--; // Reset to original color
		} else {
			this.clickedElement.style.fill = '#8D89A5';
			this.bodyparts.push(selectedValue);
			this.totalElements++;
		}
		if (this.bodyparts?.length === 30) {
			this.isCheckedselectall = true;
			this.buttonText = removeall;
		} else {
			this.isCheckedselectall = false;
			this.buttonText = select;
		}
		this.itchinesserrors = this.totalElements <= 0;
		if (this.sliderValue !== 0 && this.totalElements > 0) {
			this.isButtonDisabled = false;
		} else {
			this.isButtonDisabled = true;
		}
	}
	//async function prepares data related to redness for insertion and update, while preserving the current state of body parts.
	async handleClickForAccept() {
		let itchinessallrecordinsert = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.localStorageValueitchiness || this.lastsymptomid, // Use default value if lastsymptomid is null
			Symptomname: this.painvalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.moodvalues || '', // Use default value if moodvalues is null
	};this.bodyparts = this.bodyparts;
		let itchinessallrecordupdate = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.lastsymptomid || this.localStorageValueitchiness, // Use default value if lastsymptomid is null
			Symptomname: this.painvalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.moodvalues || '', // Use default value if moodvalues is null
		};this.bodyparts = this.bodyparts;
		try {
				if (this.bodyparts.length > 0 && parseInt(this.sliderValue) > 0) {
				// If slider value is positive and insertcount is 1, update allergy intolerance records
				if (this.insertcount == 1) {
					await recordUpdateAllergyIntolerance({
						itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.bodyparts
					})
					// Null data is checked and AuraHandledException is thrown from the Apex
						.then(result => {
							if (result && result !== null) {
								// Store data labeled as 'redness' in the session storage without altering custom labels.
								sessionStorage.setItem('Paindata', this.bodyparts);
								// Store data labeled as 'myDataintensityredness' in the session storage without altering custom labels.
								sessionStorage.setItem('myDataintensity', this.sliderValue);
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
					if (this.lastsymptomid && this.carePlanTemplateName === painvalues) {
						await recordUpdateAllergyIntolerance({
							itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.bodyparts
						})
						// Null data is checked and AuraHandledException is thrown from the Apex
							.then(result => {
								if (result && result !== null) {
									// Store data labeled as 'redness' in the session storage without altering custom labels.
									sessionStorage.setItem('Paindata', this.bodyparts);
									// Store data labeled as 'myDataintensityredness' in the session storage without altering custom labels.
									sessionStorage.setItem('myDataintensity', this.sliderValue);
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
							itchinessallrecordinsert: itchinessallrecordinsert, bodyParts: this.bodyparts
						})
						// Null data is checked and AuraHandledException is thrown from the Apex
							.then(result => {
								if (result && result !== null) {
									// Store data labeled as 'redness' in the session storage without altering custom labels.
									sessionStorage.setItem('Paindata', this.bodyparts);
									// Store data labeled as 'myDataintensityredness' in the session storage without altering custom labels.
									sessionStorage.setItem('myDataintensity', this.sliderValue);
									const updateEvent = new CustomEvent('updatechildprop', {
										detail: false
									});
									this.dispatchEvent(updateEvent);
									this.recordInsertCount++;
									// Store data labeled as 'countfati' in the session storage without altering custom labels.
									sessionStorage.setItem('countpain', this.recordInsertCount);
								}
							})
							.catch(error => {
								this.showToast(errormessage, error.message, errorvariant);
							});
					}
				}
			}
			else {
				this.itchinesserrors = true;
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	// It used to display slider values in scroll
	updateThumbLabelPosition(sliderValue) {
		//Use requestAnimationFrame to wait for the next rendering cycle
		requestAnimationFrame(() => {
			const slider = this.template.querySelector('input');
			const thumbLabel = this.template.querySelector('.thumb-label');
			const thumbWidth = window.getComputedStyle(thumbLabel).width;
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