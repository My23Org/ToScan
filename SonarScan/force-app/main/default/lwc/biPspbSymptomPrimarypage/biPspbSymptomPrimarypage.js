//This components using user body parts and intencity itchiness values store this lwc
// To import Libraries
import { LightningElement, wire, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import { refreshApex } from '@salesforce/apex';
import getLatestSymptomRecord from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getLatestSymptomRecord';
import deleteSymptomTrackerRecords from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.deleteSymptomTrackerRecords'
import getAllergyIntolerancedata from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getAllergyIntolerancedata';
import getsymptomrecorddata from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getsymptomrecorddata';
import getCaseImageURL from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getBase64Image';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Static Resources
import Itchesness from '@salesforce/resourceUrl/BI_PSPB_Itchiness';
import Redness from '@salesforce/resourceUrl/BI_PSPB_Redness';
import Pain from '@salesforce/resourceUrl/BI_PSPB_Pain';
import Pustules from '@salesforce/resourceUrl/BI_PSPB_Pustulesimg';
import Fatigue from '@salesforce/resourceUrl/BI_PSPB_Fatigue';
import Temperature from '@salesforce/resourceUrl/BI_PSPB_Temperatureimg';
import Happy from '@salesforce/resourceUrl/BI_PSPB_Happy';
import Calender from '@salesforce/resourceUrl/BI_PSPB_CalenderIcon';
import Vector from '@salesforce/resourceUrl/BI_PSPB_VectorIcon';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import Itchiness from '@salesforce/label/c.BI_PSPB_Itchiness';
import Rednes from '@salesforce/label/c.BI_PSPB_Redness';
import Painn from '@salesforce/label/c.BI_PSPB_Pain';
import Pusstules from '@salesforce/label/c.BI_PSPB_Pustules';
import fatique from '@salesforce/label/c.BI_PSPB_Fatique';
import Temperrature from '@salesforce/label/c.BI_PSPB_Temperrature';
import Mood from '@salesforce/label/c.BI_PSPB_Mood';
import yes from '@salesforce/label/c.BI_PSPB_YESS';
import no from '@salesforce/label/c.BI_PSPB_NOO';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import symptommainpage from '@salesforce/label/c.BI_PSPB_symptomtrackermainpage';
export default class symptomPrimarypage extends NavigationMixin(LightningElement) {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@api variable declaration

	@api symptomrecord;
	@api isedit;
	@api recordId;
	@api showeditbtn;
	 // The Account Id you want to pass to the Apex method
	//@track variable declaration
	@track symptomdata;
	@track moodreaction = ''
	@track symptomgpp;
	@track valuesymptom;
	@track isedit1;
	@track imageUrls = [];
	@track symptomrecorddata;
	@track deletbtn = false;
	@track lastedit = false;
	@track edit = false;
	//Variable declaration
	allergyIntoleranceData;
	latestRecord;
	accountId;
	itchnessimg = Itchesness;
	Rednessimg = Redness;
	Painimg = Pain;
	Pustulesimg = Pustules;
	Fatigueimg = Fatigue;
	Temperatureimg = Temperature;
	Happyimg = Happy;
	Vectorimg = Vector;
	userId = Id;
	Calenderimg = Calender;
	currentDate
	// Process retrieved allergy intolerance data, updating UI and properties, particularly for fatigue symptoms detection.
	@wire(getAllergyIntolerancedata, { symptomTrackerId: '$symptomrecord' })
	wiredAllergyIntoleranceData({ error, data }) {
		if (data && data !== null) {
			try {
				this.allergyIntoleranceData = data.map(obj =>
				({
					...obj,
					itchness: obj?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name === Itchiness,
					redn: obj?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name === Rednes,
					Pai: obj?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name === Painn,
					Fati: obj?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name === fatique,
					Pust: obj?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name === Pusstules,
					temp: obj?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name === Temperrature,
					moods: obj?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name === Mood,
				}));
				for (let record of data) {
					this.moodreaction = record.BI_PSP_Mood__c;
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	@wire(getsymptomrecorddata, { symptomTrackerId: '$symptomrecord' })
	wiredgetsymptomrecorddata({ error, data }) {
		if (data && data !== null) {
			try {
				// Split values using semicolon as the delimiter
				this.symptomdata = data[0].BI_PSP_EditEntrydates__c;
				this.symptomgpp = data[0].BI_PSP_Are_you_currently_experiencing__c;
				if (this.symptomgpp === true) {
					this.valuesymptom = yes;
				} else if (this.symptomgpp === false) {
					this.valuesymptom = no;
				}
				this.symptomrecorddata = data[0].BI_PSP_Recent_Activities__c
					?.split(';')
					.map(item => item.trim())
					.filter(item => item !== '');
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	//To fetch the latest symptom recordId
	@wire(getLatestSymptomRecord, { careProgramEnrolleeId: '$accountId' })
	wiredLatestRecord({ error, data }) {
		if (data && data !== null) {
			try {
				console.log(data,'eeeeeeee')
				this.latestRecord = data[0];
				this.errorMessage = ''; // Clear any previous error
			} catch (err) {
				this.latestRecord = null;
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.latestRecord = null;
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	// Used to fetch image URL
	@wire(getCaseImageURL, { symptomTrackerId: '$symptomrecord' })
	caseImageURL;
	get hasImage() {
		this.imageUrls = [];
		if (this.imageUrls.length === 0) {
			try {
				if (this.caseImageURL && this.caseImageURL.data && this.caseImageURL !== null) {
					let splitArray = this.caseImageURL.data?.map((obj) => obj?.split('data:')[1])
					for (let record of splitArray) {
						if (record !== '') {
							this.imageUrls = [...this.imageUrls, 'data:' + record]
						}
					}
				}
			} catch (error) {
				// Handle the error here
				this.showToast(errormessage, error.message, errorvariant);
			}
		}
		return true;
	}
	//It initializes component tasks, including edit button visibility, user data retrieval, URL parsing, setting URLs
	connectedCallback() {
		try {
			if(this.showeditbtn === false){
			this.showeditbtn = false;
		}
		else{
			this.showeditbtn = true;
		}

			getEnrolle({ userId: this.userId })
			// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => {
					if (result !== null) {
						if (result[0].patientEnrolle !== null) {
							this.accountId = result[0].patientEnrolle.Id;

						} else if (result[0].error !== null) {
							this.errorMessage = result[0].error;
						}
					}
				})
				.catch(error => {
					// Handle any errors occurring during the promise chain
					this.showToast(errormessage, error.message, errorvariant);
				});


			const currentURL = window.location.href;
			// Create a URL object
			const urlObject = new URL(currentURL);
			// Get the path
			const path = urlObject.pathname;
			// Split the path using '/' as a separator
			const pathComponents = path.split('/');
			// Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find(component =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
			);
			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedUrlNavi;
			}
			else {
				this.urlq = unAssignedUrlNavi;
			}
			this.symptomidgetid = this.symptomrecord;
			this.currentDate = new Date().toISOString().slice(0, 10);
			if (this.isedit === true) {
				this.isedit1 = false;
			} else {
				this.isedit1 = true;
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	// Manually refresh the wire adapter
	refreshWireAdapter() {
		return refreshApex(this.wiredAllergyIntoleranceData);
	}
	//function asynchronously reads a Blob object as a data URL and returns a Promise resolving with the data URL.
	readAsDataURL(blob) {
		return new Promise((resolve, reject) => {
			const reader = new FileReader();
			reader.onload = (event) => {
				const base64String = event.target.result;
				resolve(`data:image/${blob.type.split('/')[1]};base64,${base64String}`);
			};
			reader.onerror = (error) => {
				reject(error);
			};
			reader.readAsDataURL(blob);
		});
	}
	//To delete the entry or modify data
	handleDeleteClick() {
		this.opendeletbtn();
	}
	//This function deletes symptom tracker records and it disables a delete button.
	lastrecorddelete() {
		deleteSymptomTrackerRecords({ symptomTrackerId: this.symptomrecord })
			.then(result => {
				if(result){
					//Handle success
					location.reload();
				}
			})
			.catch(error => {
				// Handle error
				this.showToast(errormessage, error.message, errorvariant);
			});
		this.deletbtn = false;
	}
	// Open delete button and prevent scrolling on the body.
	opendeletbtn() {
		// Add your specific logic for opening the mood modal
		this.deletbtn = true;
		document.body.style.overflow = 'hidden';
		this.submitModal = false;
	}
	// Close delete button, restore scrolling, and perform last record deletion.
	closedeletbtn() {
		// Add your specific logic for closing the mood modal
		this.deletbtn = false;
		document.body.style.overflow = ''; // Reset to default
		this.lastrecorddelete();
	}
	// Close delete button and restore scrolling to default.
	closedeletbtnadd() {
		// Add your specific logic for closing the mood modal
		this.deletbtn = false;
		document.body.style.overflow = '';
		
		// Reset to default   
	}
	//This function opens the mood modal and disables scrolling on the page
	openlastedit() {
		// Add your specific logic for opening the mood modal      
		this.lastedit = true;
		document.body.style.overflow = 'hidden';
	}
	// Add your specific logic for closing the mood modal
	closelastedit() {
		this.lastedit = false;
		document.body.style.overflow = ''; // Reset to default
	}
	//Compares the latest record with the current symptom record
	navigatesymptom() {
		if (this.latestRecord !== this.symptomrecord) {
			this.openlastedit()
		} else if (this.latestRecord === this.symptomrecord) {
			// Redirect to a new page and set item in localStorage
			this.openedit();
		}
	}
	// Add your specific logic for opening the mood modal
	openedit() {
		this.edit = true;
		document.body.style.overflow = 'hidden';
	}
	// Add your specific logic for closing the mood modal
	closeedit() {
		this.edit = false;
		this.deletbtn = false;
		document.body.style.overflow = ''; // Reset to default
	}
	lastedtirdate() {
		if (this.latestRecord !== this.symptomrecord) {
			this.openlastedit();
			this.lastedit = false;
			document.body.style.overflow = '';
		} else if (this.latestRecord === this.symptomrecord) {
			// Redirect to a new page and set item in localStorage
			window.location.assign(this.urlq + symptommainpage);
			// Store data labeled as 'symptomlastid' in the session storage without altering custom labels.
			localStorage.setItem('symptomlastid', this.symptomrecord);
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