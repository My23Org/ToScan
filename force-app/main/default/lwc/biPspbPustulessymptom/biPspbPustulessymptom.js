//This components using user body parts and intencity itchiness values store this lwc
//To import library
import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import apex classes
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getAllergyIntolerancedata from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getAllergyIntolerancedata';
import recordInsertAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordInsertAllergyIntolerance';
import recordUpdateAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordUpdateAllergyIntolerance';
//To import current userId
import Id from '@salesforce/user/Id';
//To import custom labels
import pustulesvalue from '@salesforce/label/c.BI_PSPB_Pustules';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import zerovalue from '@salesforce/label/c.BI_PSP_Slidervaluestwodigit';
import blackvalue from '@salesforce/label/c.BI_PSP_Bodycolor';
import zero from '@salesforce/label/c.BI_PSPB_null';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import bodypartsRemove from '@salesforce/label/c.BI_PSP_bodypartsRemove';
import bodypartsselectall from '@salesforce/label/c.BI_PSP_Bodypartsselectall';

export default class biPspbpustulessymptom extends NavigationMixin(LightningElement) {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Define a variable to track the number of record insertions
	@api resultId
	//@track variable declaration
	@track valoF = ''
	@track buttonText = bodypartsselectall;
	@track clickCount = 0;
	@track totalElements = 0;
	@track sliderValue = 0;
	@track sliderValuetwo = zerovalue;
	@track isCheckedselectall = false;
	@track bodyparts = []
	@track itchinessvalues = pustulesvalue
	@track itchinesserrors = false;
	@track lastsymptomid
	@track localStorageValueitchiness;
	@track insertcount
	@track Fatiqueerrors = true;
	@track moodvalues = '';
	@track clickedElement;
	@track allergyIntoleranceData;
	@track itchbody;
	@track intensity;
	@track carePlanTemplateName;
	@track isButtonDisabled = false;
	//Variable declaration
	accountId;
	recordInsertCount = 0;
	userId = Id;
	// Process retrieved allergy intolerance data, updating UI and properties, particularly for Itchiness symptoms detection.
	@wire(getAllergyIntolerancedata, { symptomTrackerId: '$lastsymptomid' })
	wiredAllergyIntoleranceData({ error, data }) {
		if (data && data !== null) {
			try {
				let itchbody = '';
				for (let record of data) {
					itchbody = record.BI_PSP_Bodyparts__c;
					this.intensity = record.BI_PSP_Intensity__c;
					let carePlanTempla = record?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name;

					if (carePlanTempla === pustulesvalue) {
						this.carePlanTemplateName = pustulesvalue;

						if (this.carePlanTemplateName === pustulesvalue) {
							this.sliderValue = this.intensity;
							this.sliderValuetwo = this.intensity;
							let bodyPartsArr = itchbody?.split(';');
							//Using this with a minimal delay ensures smooth UI updates by deferring DOM manipulation, preventing potential rendering issues.
							setTimeout(() => {
								try {
									bodyPartsArr.forEach(i => {
										let element = this.template.querySelector(`[data-name="${i}"]`);
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
										this.buttonText = bodypartsRemove;
									}
								} catch (err) {
									this.showToast(errormessage, err.message, errorvariant);
									// Handle the error as needed
								}
							}, 0.111111);
							return;
						}
					}
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
				// Handle the error as needed
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	// page rendere call back all values display 
	connectedCallback() {
		try {
			//This code retrieves data labeled as 'getItem' from the session storage without altering custom labels.
			let mybodyparts = sessionStorage.getItem('Pustule');
			this.insertcount = sessionStorage.getItem('countpush');
			let mybodyinternsity = sessionStorage.getItem('myDataintensity');
			if (mybodyparts && mybodyinternsity) {
				let bodyPartsArr = mybodyparts?.split(',');
				//Using this with a minimal delay ensures smooth UI updates by deferring DOM manipulation, preventing potential rendering issues.
				setTimeout(() => {
					try {
						bodyPartsArr.forEach(i => {
							let element = this.template.querySelector(`[data-name="${i}"]`);
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
						this.Fatiqueerrors = false;
						this.Itchinessvalues = false;
						this.isButtonDisabled = false;
						if (this.totalElements === 30) {
							this.isCheckedselectall = true;
							this.buttonText = bodypartsRemove;
						}
					} catch (error) {
						this.showToast(errormessage, error.message, errorvariant);
					}
				}, 0.111111);

			}
					//This code retrieves data labeled as 'getItem' from the session storage without altering custom labels.
			this.lastsymptomid = localStorage.getItem('symptomlastid')

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
					// Handle any errors occurring during the getEnrolle call or its subsequent promise chain
					this.showToast(errormessage, error.message, errorvariant);
				});

			this.updateThumbLabelPosition(this.sliderValue);
					//This code retrieves data labeled as 'getItem' from the session storage without altering custom labels.
			this.localStorageValueitchiness = localStorage.getItem('Time', this.resultId)
			this.updateElementCount();
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);

		}
	}
	// all body parts select values this function call 
	updateElementCount() {
		const elements = this.template.querySelectorAll('.body-part');
		this.totalElements = elements.length;
		this.bodyparts = [];
		elements.forEach((ele) => {
			const dataNameValue = ele.getAttribute('data-name');
			this.bodyparts.push(dataNameValue);
		});
		elements.forEach((element) => {
			if (element.style.fill === blackvalue && this.buttonText === bodypartsselectall) {
				this.totalElements = elements.length;
				element.style.fill = '';
			} else if (this.buttonText === bodypartsRemove && element.style.fill === blackvalue) {
				element.style.fill = blackvalue;
			} else {
				this.totalElements = 0;
			}
		});
		this.isButtonDisabled = this.totalElements < 1;
		this.isButtonDisabled = this.sliderValue <= 0;
	}
	// all body parts select values this function call 
	changeColor(event) {
		const targetElements = this.template.querySelectorAll('.body-part');
		const checkbox = event.target;
		const isChecked = checkbox.checked;
		if (isChecked) {
			this.bodyparts = []
			this.isCheckedselectall = true;
			this.totalElements = 30;
			this.itchinesserrors = false;
			if (this.sliderValue !== 0) {
				this.isButtonDisabled = false;
			} else {
				this.isButtonDisabled = true;
			}
			this.buttonText = bodypartsRemove;
			targetElements.forEach((element) => {
				const dataNameValue = element.getAttribute('data-name');
				element.style.fill = '#8D89A5';
				this.bodyparts.push(dataNameValue);
			});
		} else {
			this.totalElements = 0;
			this.isCheckedselectall = false;
			this.isButtonDisabled = true;
			this.buttonText = bodypartsselectall;
			targetElements.forEach((element) => {
				const dataNameValue = element.getAttribute('data-name');
				element.style.fill = '';
				this.bodyparts = this.bodyparts.filter(item => item !== dataNameValue);
			});
		}
		this.clickCount++;
	}
	resetCount() {
		this.updateElementCount = 0;
	}
	//fill color to determine if button should be disabled based on user interaction
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
	// Function to handle emoji click event
	handleEmojiClick(event) {
		this.sliderValue = event.target.value
		this.sliderValuetwo = (zero + this.sliderValue).slice(-2)
		this.updateThumbLabelPosition(this.sliderValue);
	}
	//toggle fill color and update body parts array based on user interaction
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
	}
	// used to display slider values
	async handleClickForAccept() {
			console.log(this.bodyparts,'cbcb', this.lastsymptomid)
		let itchinessallrecordinsert = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.localStorageValueitchiness || this.lastsymptomid, // Use default value if lastsymptomid is null
			Symptomname: this.itchinessvalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.moodvalues || '', // Use default value if moodvalues is null
		};this.bodyparts = this.bodyparts;
		let itchinessallrecordupdate = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.lastsymptomid || this.localStorageValueitchiness, // Use default value if lastsymptomid is null
			Symptomname: this.itchinessvalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.moodvalues || '', // Use default value if moodvalues is null
		};this.bodyparts = this.bodyparts;
		try {
			if (this.bodyparts.length > 0 && this.sliderValue > 0) {
				if (this.insertcount == 1) {
					await recordUpdateAllergyIntolerance({
						itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.bodyparts
					})
					// Null data is checked and AuraHandledException is thrown from the Apex
						.then(result => {
							// Store data labeled as 'myData' in the session storage without altering custom labels.
							if (result && result !== null) {
											// Store data labeled as 'Pustule' in the session storage without altering custom labels.

									sessionStorage.setItem('Pustule', this.bodyparts);
								// Store data labeled as 'myDataintensity' in the session storage without altering custom labels.
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

					if (this.lastsymptomid && this.carePlanTemplateName === pustulesvalue) {
						await recordUpdateAllergyIntolerance({
							itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.bodyparts
						})
						// Null data is checked and AuraHandledException is thrown from the Apex
							.then(result => {
								// Store data labeled as 'Pustule' in the session storage without altering custom labels.
								if (result && result !== null) {
											// Store data labeled as 'Pustule' in the session storage without altering custom labels.

									sessionStorage.setItem('Pustule', this.bodyparts);
								// Store data labeled as 'myDataintensity' in the session storage without altering custom labels.
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
								// Store data labeled as 'Pustule' in the session storage without altering custom labels.

									sessionStorage.setItem('Pustule', this.bodyparts);
								// Store data labeled as 'myDataintensity' in the session storage without altering custom labels.
									sessionStorage.setItem('myDataintensity', this.sliderValue);
									const updateEvent = new CustomEvent('updatechildprop', {
										detail: false
									});
									this.dispatchEvent(updateEvent);
									this.recordInsertCount++;
									sessionStorage.setItem('countpush', this.recordInsertCount);
								}

							})
							.catch(error => {
								this.showToast(errormessage, error.message, errorvariant);
							});
					}
				}
			} else {
				this.itchinesserrors = true;
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	// Update the position of the thumb label relative to the slider based on the current slider value
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