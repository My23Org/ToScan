//This components using user  Temperaturesymtom values stroe this component
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation'
// To import current user ID
import Id from '@salesforce/user/Id';
// To import static resource
import Boxedicon from '@salesforce/resourceUrl/BI_PSP_Boxedicon';
// To import Apex Classes
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getAllergyIntolerancedata from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getAllergyIntolerancedata';
import recordUpdateAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordUpdateAllergyIntolerance';
import recordInsertAllergyIntolerance from '@salesforce/apex/BI_PSP_SymptomTracker.recordInsertAllergyIntolerance';
// To import Custom Labels
import temperaturevalues from '@salesforce/label/c.BI_PSPB_Temperrature';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
export default class biPspTemperaturesymtom extends NavigationMixin(LightningElement) {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	@track Boxedicon = Boxedicon;
	@track bodyParts = ''
	@track valoF = 99.5;
	@track slider = 8
	@track formatedTextVal;
	@track showMessage = false;
	@track temperaturevalues = temperaturevalues;
	@track localStorageValueitchiness;
	@track insertcount
	@track sliderValue = 0;
	@track moodvalues = '';
	@track submitModal = false;
	@track allergyIntoleranceData;
	@track carePlanTemplateName;
	@track tempvaluesfill = true;
	// Variable declaration
	errorMessage
	recordInsertCount = 0;
	lastsymptomid
	accountId;
	userId = Id;
	//Wire method to retrieve allergy intolerance data based on symptomTrackerId
	@wire(getAllergyIntolerancedata, { symptomTrackerId: '$lastsymptomid' })
	wiredAllergyIntoleranceData({ error, data }) {
		if (data && data !== null){
			try {
				for (let record of data) {
					this.valoF = record.BI_PSP_Temperature__c;
					this.carePlanTemplateName = record?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name;
					//Check if care plan template name matches 'Temperature' and set corresponding values
					let carePlanTempla = record?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name;
					//Check if care plan template name matches 'Temperature' and set corresponding values				
					if (carePlanTempla === temperaturevalues) {
						this.carePlanTemplateName = temperaturevalues;
					}
					if (this.carePlanTemplateName === temperaturevalues) {
						this.valoF = record.BI_PSP_Temperature__c;
						this.tempvaluesfill = false;
					}
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
			//This code retrieves data labeled as 'myData' from the session storage without altering custom labels.
			this.insertcount = sessionStorage.getItem('counttemp');
			//This code retrieves data labeled as 'myData' from the session storage without altering custom labels.
			this.lastsymptomid = localStorage.getItem('symptomlastid')
			//This code retrieves data labeled as 'myData' from the session storage without altering custom labels.
			let temprtevalues = sessionStorage.getItem('temprature');
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
					//Handle any errors occurring during the promise chain
					this.showToast(errormessage, error.message, errorvariant);
					//Optionally, you can also rethrow the error if you want to handle it further upstream
					//throw error;
				});
			//Change this value based on your actual condition
			//This code retrieves data labeled as 'myData' from the session storage without altering custom labels.
			this.localStorageValueitchiness = localStorage.getItem('Time', this.resultId)
			//Get the initial count of elements with class 'body-part' on component load
			this.currntmooderror = true;
			//Change this value based on your actual condition
			this.valoF = temprtevalues;
		} catch (err) {
			// Handle any errors that occurred during the execution of the connectedCallback function
			this.showToast(errormessage, err.message, errorvariant);
			// Additional error handling if needed
		}
	}
	onchangeOfTempa(event) {
		this.valoF = parseFloat(event.target.value);
		if (this.valoF > 92) {
			this.tempvaluesfill = false; // Enable the button if temperature is above 92
			if (this.valoF > 100.4) {
				this.showMessage = true; // Show the regular message
				this.showButton = true; // Show the button if temperature is above 100.4
			} else {
				this.showMessage = false; // Hide the regular message
				this.showButton = false; // Hide the button if temperature is below 100.4
			}
		} else {
			//Disable the button if temperature is below or equal to 92
			this.tempvaluesfill = true;
			this.showMessage = false; // Hide the regular message
			this.showButton = false; // Hide the button
		}
	}
	//Async function to handle changes when accepting input
	async onchangeAccept() {
		let itchinessallrecordinsert = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.localStorageValueitchiness || this.lastsymptomid, // Use default value if lastsymptomid is null
			Symptomname: this.temperaturevalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.moodvalues || '', // Use default value if moodvalues is null
		};this.bodyparts = this.bodyparts;
		let itchinessallrecordupdate = {
			SliderValue: parseFloat(this.sliderValue), // Convert to float if SliderValue is numeric
			CareprogramId: this.accountId,
			ValoF: parseFloat(this.valoF) || 0, // Convert to float and handle null or invalid values
			SymptomId: this.lastsymptomid || this.localStorageValueitchiness, // Use default value if lastsymptomid is null
			Symptomname: this.temperaturevalues || '', // Use default value if itchinessvalues is null
			Moodvalues: this.moodvalues || '', // Use default value if moodvalues is null
		};this.bodyparts = this.bodyparts;
		try {
			if (this.insertcount == 1) {
				await recordUpdateAllergyIntolerance({
					itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.bodyparts
				})
				// Null data is checked and AuraHandledException is thrown from the Apex
					.then(result => {
						if (result && result !== null) {
							// Store data labeled as 'myData' in the session storage without altering custom labels.
							sessionStorage.setItem('temprature', this.valoF)
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
				if (this.lastsymptomid && this.carePlanTemplateName === temperaturevalues) {
					await recordUpdateAllergyIntolerance({
						itchinessallrecordupdate: itchinessallrecordupdate, bodyParts: this.bodyparts
					})
					// Null data is checked and AuraHandledException is thrown from the Apex
						.then(result => {
							if (result && result !== null) {
								// Store data labeled as 'myData' in the session storage without altering custom labels.
								sessionStorage.setItem('temprature', this.valoF)
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
								const updateEvent = new CustomEvent('updatechildprop', {
									detail: false
								});
								this.dispatchEvent(updateEvent);
								this.recordInsertCount++;
								// Store data labeled as 'myData' in the session storage without altering custom labels.
								sessionStorage.setItem('counttemp', this.recordInsertCount);
								// Store data labeled as 'myData' in the session storage without altering custom labels.
								sessionStorage.setItem('temprature', this.valoF)
							}
						})
						.catch(error => {
							this.showToast(errormessage, error.message, errorvariant);
						});
				}
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}
	opensubmitModal() {
		this.submitModal = true;
	}
	closesubmitModal() {
		this.submitModal = false;
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