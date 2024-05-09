//This components using  Main component connect all child components user date and recntactivty gpp symptoms
// To import Libraries
import { LightningElement, track, api, wire } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
// To import Apex Classes
import getAllergyIntolerancedata from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getAllergyIntolerancedata';
import recordInsertSTs from '@salesforce/apex/BI_PSP_SymptomTracker.recordInsertST';
import recordInsertSTupdate from '@salesforce/apex/BI_PSP_SymptomTracker.recordInsertSTupdate';
import checkUniqueDate from '@salesforce/apex/BI_PSP_SymptomTracker.checkUniqueDate';
import updateGPPValue from '@salesforce/apex/BI_PSP_SymptomTracker.updateGPPValue';
import updateRecentValue from '@salesforce/apex/BI_PSP_SymptomTracker.updateRecentValue';
import createContentDocumentLinks from '@salesforce/apex/BI_PSP_SymptomTracker.createContentDocumentLinks'
import getLast from '@salesforce/apex/BI_PSP_SymptomTracker.getLast';
import getsymptomrecorddata from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getsymptomrecorddata';
import getCaseImageURL from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getBase64Image';
import deleteContentDocumentLinks from '@salesforce/apex/BI_PSP_SymptomTracker.deleteContentDocumentLinks';
import fetchAccountDetails from '@salesforce/apex/BI_PSP_SymptomTracker.fetchAccountDetails';
import saveFiles from '@salesforce/apex/BI_PSP_SymptomTracker.saveFiles';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
// To import Static Resources
import Boxedicon from '@salesforce/resourceUrl/BI_PSP_Boxedicon';
import uploadimag from '@salesforce/resourceUrl/BI_PSP_Uploadimg';
import Symptomtickimg from '@salesforce/resourceUrl/BI_PSP_Symptomtickimg';
import itchinesscolorvarient from '@salesforce/resourceUrl/BI_PSP_itchinesscolorvarient';
import Rednesscolorvarient from '@salesforce/resourceUrl/BI_PSP_Rednesscolorvarient';
import Paincolorvarient from '@salesforce/resourceUrl/BI_PSP_Paincolorvarient';
import Pustulescolorvarient from '@salesforce/resourceUrl/BI_PSP_Pustulescolorvarient';
import Fatiguecolorvarient from '@salesforce/resourceUrl/BI_PSP_Fatiguecolorvarient';
import Moodcolorvarient from '@salesforce/resourceUrl/BI_PSP_Moodcolorvarient';
import Temperaturecolorvarient from '@salesforce/resourceUrl/BI_PSP_Temperaturecolorvarient';
import symptomtickicon from '@salesforce/resourceUrl/BI_PSP_Symptomtickicon';
import symptomimg from '@salesforce/resourceUrl/BI_PSPB_SymptomsImg';
import fileUploaderCSS from '@salesforce/resourceUrl/BI_PSPB_Symptomcss';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Custom Labels
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import symptomgraphpage from '@salesforce/label/c.BI_PSPB_symptomtrackergraphpage';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import Itchiness from '@salesforce/label/c.BI_PSPB_Itchiness';
import Redness from '@salesforce/label/c.BI_PSPB_Redness';
import Pain from '@salesforce/label/c.BI_PSPB_Pain';
import Pustules from '@salesforce/label/c.BI_PSPB_Pustules';
import fatique from '@salesforce/label/c.BI_PSPB_Fatique';
import Temperature from '@salesforce/label/c.BI_PSPB_Temperrature';
import Mood from '@salesforce/label/c.BI_PSPB_Mood';
import yes from '@salesforce/label/c.BI_PSP_SoftDelete';
import no from '@salesforce/label/c.BI_PSPB_No';
import female from '@salesforce/label/c.BI_PSP_female';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import labelus from '@salesforce/label/c.BI_PSPB_EN_US';
import dynamicValue from '@salesforce/label/c.BI_PSP_SomedynamicValue';
import dateinputpage from '@salesforce/label/c.BI_PSP_dateinputpage';
import UploadedFile from '@salesforce/label/c.BI_PSP_UploadedFile';
import UploadedFilepng from '@salesforce/label/c.BI_PSP_UploadedFilepng';
import getSymptomTrackerDetails from "@salesforce/apex/BI_PSP_SymptomTracker.getSymptomTrackerDetails";
export default class SymptomTracker extends NavigationMixin(LightningElement) {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@api variable declaration
	@api symptomrecord1;
	@api symptomTrackerId;
	@api recordId;
	//@track variable declaration
	@track symptomcompletetick = Symptomtickimg;
	@track itchinesscolorvarient = itchinesscolorvarient;
	@track Rednesscolorvarient = Rednesscolorvarient;
	@track Paincolorvarient = Paincolorvarient;
	@track Pustulescolorvarient = Pustulescolorvarient;
	@track Fatiguecolorvarient = Fatiguecolorvarient;
	@track Moodcolorvarient = Moodcolorvarient;
	@track Temperaturecolorvarient = Temperaturecolorvarient;
	@track symptomtickicon = symptomtickicon;
	@track lastedatedisplay = false;
	@track isDesktop = false;
	@track rednesschnage = false;
	@track painchnage = false;
	@track pustleschnage = false;
	@track fatiqueschnage = false;
	@track Moodchnage = false;
	@track Temperaturechnage = false;
	@track sliderValue = 8;
	@track whichvaluesone = 'Which of the below apply to your recent';
	@track Boxedicon = Boxedicon;
	@track Limtupload = uploadimag;
	@track accname;
	@track isPopupOpenundersatand = false;
	@track undersatnd = false;
	@track isPopupOpendisable = true;
	@track lastModifi = false;
	@track entryDate;
	 @track chsngedVal;
	@track isDateUnique = false;
	@track isGppExperiencing;
	@track lastEntryDate;
	@track accdate;
	@track gpp;
	@track editEntryDate = [];
	@track accgender = false;
	@track accgendercheck
	@track isDropdownVisible = false;
	@track isDropdownsymptom = false;
	@track isDropdownRecent = false;
	@track bodyparts = [];
	@track inputFieldValue = '';
	@track inputFieldColor = '';
	@track showFirstSVG = true;
	@track showFirstSVG1 = true;
	@track showFirstSVG2 = true;
	@track showFirstSVG3 = true;
	@track showFirstSVG4 = true;
	@track showFirstSVG5 = true;
	@track showFirstSVG6 = true;
	@track showFirstSVG7 = true;
	@track changevalue = '';
	@track storedData = '';
	@track isDropdownOpen = false;
	@track isPopupOpen = false;
	@track isDropdownOpen1 = false;
	@track isPopupOpen1 = false;
	@track isDropdownOpen2 = false;
	@track isPopupOpen2 = false;
	@track isDropdownOpen3 = false;
	@track isPopupOpen3 = false;
	@track isDropdownOpen4 = false;
	@track isPopupOpen4 = false;
	@track isDrop = false;
	@track result = '';
	@track currentDate;
	@track currentDate2;
	@track isFutureDateError = false;
	@track selectedValue;
	@track isDrop2 = false;
	@track colorchange = ''
	@track colorchange1 = ''
	@track colorchange2 = ''
	@track colorchange3 = ''
	@track colorchange4 = ''
	@track colorchange5 = ''
	@track colorchange6 = ''
	@track itchinesschnage1 = false;
	@track formattedLastModifiedDate
	@track lastModifiedtime
	@track accordcolor
	@track accordcolorsmptom;
	@track itchinesschnage = false;
	@track primarypage;
	@track extraimg
	@track submitModal = false;
	@track undersatand = false;
	@track showfiles = false;
	@track selectedLabels = [];
	@track dataLabel;
	@track recntbtn = []; // Initialize recntbtn as an empty array
	@track TEMPERATURE = 90;
	@track btncolorchange = 'dropdown3-activity-btn';
	@track isButtonDisabled = true;
	@track accordcolorbtn
	@track files = [];
	@track fileIds = [];
	@track latestImageBase64;
	@track uploadedFiles = [];
	@track isLimitReached = false;
	@track isLimitReachedupload = true;
	@track imageUrls = [];
	@track uploadedlarge = false;
	@track attachmentIdsvalues;
	@track filechnagecolour;
	@track filework = false;
	@track filemessage = false;
	@track isEditMode = false;
	@track resultId;
	@track datamantroy = false;
	@track datamantroydispable = true;
	@track currentlygpp = false;
	@track changeradiobtn;
	@track changeradiobtn1;
	@track formattedSymptomdata;
	@track symptomdata;
	@track symptomgpp;
	@track showMessage = false;
	@track options1 = [];
	@track recentactivity = false;
	@track datedisable = false;
	@track firsttime = false;
	@track recentimages = false;
	@track allergyIntoleranceData;
	@track itchbody;
	@track intensity
	@track carePlanTemplateNam;
	@track whichsymptom;
	@track fileTitle  = UploadedFile
	@track filePath   = UploadedFilepng
	dynamicValue = dynamicValue;
	// Variable declaration
	userId = Id;
	selectedOption = []
	accountId;
	personGendercheck;
	fileData;
	lastsymptomid
	receivedValue
	gppvaluesradio
	Image;
	Image1;
	Image2;
	Image3;
	Image4;
	Image5;
	Image6;
	userIddata;
	MAX_FILE_COUNT = 5;
	imageUrl;
	acceptedFormats = '.png, .jpg';
	showItchinessModal = false;
	showPainModal = false;
	showMoodModal = false;
	showFatigueModal = false;
	showTemperatureModal = false;
	showrednessModal = false;
	showPustulesModal = false;
	// popup end
	openrpopup() {
		this.ispoup = true;
	}
	closrpopup() {
		this.ispoup = false;
	}
	openPopup1() {
		this.isPopupOpen1 = true;
		this.undersatnd = true;
	}
	closePopup1() {
		this.isPopupOpen1 = false;
	}
	openPopup() {
		this.isPopupOpen = true;
	}
	closePopup() {
		this.isPopupOpen = false;
	}
	// lAST MODFIED START
	//Wire method to call the fetchAccountDetails Apex method
	@wire(fetchAccountDetails, { careProgramEnrolleeId: '$accountId' })
	wiredAccountDetails({ error, data }) {
		if (data && data.length > 0) {
			try {
				const enrollee = data[0];
				const personGenderIdentity = enrollee.Account.HealthCloudGA__Gender__pc;
				// Assign values to component properties if needed
				this.accgendercheck = personGenderIdentity;

				if (this.accgendercheck === female) {
					this.accgender = true;
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			// Handle any errors
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}

	options = [
		{ label: yes, value: yes },
		{ label: no, value: no }
		// Add more options as needed
	];
	toggleDropdown() {
		this.isDropdownVisible = !this.isDropdownVisible;
	}
	// end modified


	// Dropdown 2 state
	addEvents() {
		window.addEventListener('beforeunload', () => {
			sessionStorage.clear();
		});
	}
	handleChange(event) {
		this.selectedOption = event.target.value;
	}


	formatDate(date) {
		const options = {
			month: 'numeric',
			day: 'numeric',
			hour: 'numeric',
			minute: 'numeric',
			hour12: true,
		};
		return date.toLocaleString(labelus, options);
	}
	connectedCallback() {
			loadStyle(this, fileUploaderCSS);
		loadStyle(this, symptomimg);
		
		const queryParams = new URLSearchParams(window.location.search);
		// Get the value of the 'value' parameter
		this.receivedValue = queryParams.get('value');
		window.history.replaceState({}, document.title, window.location.pathname);
		// Check if the value is received
		if (this.receivedValue) {
			//The setTimeout with a small delay ensures UI updates occur after the current rendering tasks, preventing glitches.
			setTimeout(() => {
				try {
					this.lastModifi = false;
				} catch (error) {
					this.showToast(errormessage, error.message, errorvariant);
				}
			}, 3000);
			// You can use the value here as needed
		}
		//This code retrieves data labeled as 'recentactivity' from the session storage without altering custom labels.

		let recntbtn = sessionStorage.getItem('recentactivity')
		//The use of setInterval ensures optimal timing for thumb label position updates, enhancing animation smoothness and performance
		setInterval(() => {
			recntbtn?.forEach(item => {
				let element = this.template.querySelector(`[data-name='${item}']`);
				if (element) {
					element.style.backgroundColor = '#C6AA76';
				} else {
					console.warn(`Element with data-name='${item}' not found.`);
				}
				this.accordcolor = 'card-header-accord';
				this.accordcolorbtn = 'card-header-accord';
			});
		}, 1000);
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
	
		//This code retrieves data labeled as 'stopprcocess' from the session storage without altering custom labels.
		this.primarypage = localStorage.getItem('stopprcocess');
		if (this.primarypage === dateinputpage) {
			this.datamantroy = false;
		}
		//This code retrieves data labeled as 'symptomlastid' from the session storage without altering custom labels.
		this.lastsymptomid = localStorage.getItem('symptomlastid');
		try {
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
					// Handle any errors occurring during the promise chain
					this.showToast(errormessage, error.message, errorvariant);
				});
		} catch (error) {
			// Handle any synchronous errors outside the promise chain
			this.showToast(errormessage, error.message, errorvariant);
		}
		this.handleSaveDate();
		this.currentDate = new Date().toISOString().slice(0, 10);
		const today = new Date();
		this.maxDate = today.toISOString().slice(0, 10);
		window.addEventListener('beforeunload', this.handlePageRefresh);
		//The use of setInterval ensures optimal timing for thumb label position updates, enhancing animation smoothness and performance
		setInterval(() => {
			//This code retrieves data labeled as 'Time' from the session storage without altering custom labels.
			const localStorageValue = localStorage.getItem('Time', this.resultId)
				//This code retrieves data labeled as 'gppvalues' from the session storage without altering custom labels.
			this.sessionstrogegpp = sessionStorage.getItem('gppvalues', this.resultId)
			this.gppvaluesradio = this.sessionstrogegpp;
			this.time = localStorageValue
				//This code retrieves data labeled as 'myData' from the session storage without altering custom labels.
			const newChangeValue = sessionStorage.getItem('myData');
			//This code retrieves data labeled as 'redness' from the session storage without altering custom labels.
			const newChangeValue1 = sessionStorage.getItem('redness');
			//This code retrieves data labeled as 'Paindata' from the session storage without altering custom labels.
			const newChangeValue2 = sessionStorage.getItem('Paindata');
			//This code retrieves data labeled as 'Pustule' from the session storage without altering custom labels.
			const newChangeValue3 = sessionStorage.getItem('Pustule');
			//This code retrieves data labeled as 'fatigue' from the session storage without altering custom labels.
			const newChangeValue4 = sessionStorage.getItem('fatigue');
			//This code retrieves data labeled as 'temprature' from the session storage without altering custom labels.
			const newChangeValue5 = sessionStorage.getItem('temprature');
			//This code retrieves data labeled as 'mood' from the session storage without altering custom labels.
			const newChangeValue6 = sessionStorage.getItem('mood');
			if (newChangeValue) {
				this.isPopupOpendisable = false;
				this.colorchange = 'colorchange';
				this.accordcolorsmptom = 'card-header-accord'
				this.itchinesschnage = true;
				this.itchinesschnage1 = true;
			} else {
				this.colorchange = 'symptoms';
			}
			if (newChangeValue1) {
				this.isPopupOpendisable = false;
				this.colorchange1 = 'colorchange1';
				this.rednesschnage = true;
				this.itchinesschnage1 = true;
				this.accordcolorsmptom = 'card-header-accord';
			} else {
				this.colorchange1 = 'symptoms';
			}
			if (newChangeValue2) {
				this.isPopupOpendisable = false;
				this.colorchange2 = 'colorchange2';
				this.accordcolorsmptom = 'card-header-accord'
				this.painchnage = true;
				this.itchinesschnage1 = true;
			} else {
				this.colorchange3 = 'symptoms';
			}
			if (newChangeValue3) {
				this.isPopupOpendisable = false;
				this.colorchange3 = 'colorchange3';
				this.pustleschnage = true;
				this.itchinesschnage1 = true;
				this.accordcolorsmptom = 'card-header-accord'
			} else {
				this.colorchange3 = 'symptoms';
			}
			if (newChangeValue4) {
				this.isPopupOpendisable = false;
				this.colorchange4 = 'colorchange4';
				this.fatiqueschnage = true;
				this.itchinesschnage1 = true;
				this.accordcolorsmptom = 'card-header-accord'
			} else {
				this.colorchange4 = '';
			}
			if (newChangeValue5) {
				this.isPopupOpendisable = false;
				this.colorchange5 = 'colorchange5';
				this.accordcolorsmptom = 'card-header-accord'
				this.itchinesschnage1 = true;
				this.Temperaturechnage = true;
			} else {
				this.colorchange4 = '';
			}
			if (newChangeValue6) {
				this.isPopupOpendisable = false;
				this.Moodchnage = true;
				this.itchinesschnage1 = true;
				this.colorchange6 = 'colorchange6';
				this.accordcolorsmptom = 'card-header-accord'
			}
			else if (this.chsngedVal === no) {
				this.isPopupOpendisable = false;
			}

			else {
				this.colorchange4 = '';
			}

		}, 3000);
		this.currentDate = new Date().toISOString().slice(0, 10);
	}
	disconnectedCallback() {
		window.removeEventListener('beforeunload', this.handlePageRefresh);
	}
	handlePageRefresh(event) {
		sessionStorage.clear();
		event.returnValue = '';
	}
	handleEditDate() {
		this.isEditMode = true;
	}
	handleRegno() {
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				name: 'Itchinesspage__c'
			}
		});
	}
	handleRegno1() {
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				name: 'Rednessbodyparts__c'
			}
		});
	}
	handleRegno2() {
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				name: 'Painintersitybodyparts__c'
			}
		});
	}
	handleRegno3() {
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				name: 'pustuleBodyParts__c'
			}
		});
	}
	handleRegno4() {
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				name: 'Symptommood__c'
			}
		});
	}
	handleRegno5() {
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				name: 'fatiguepage__c'
			}
		});
	}
	handleRegno6() {
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				name: 'Temperaturepage__c'
			}
		});
	}
	get dropdownButtonClass() {
		return this.isDropdownOpen
			? 'dropdown-arrow-button dropdown-arrow-button-open'
			: 'dropdown-arrow-button';
	}
	get dropdownButtonClass1() {
		return this.isDropdownOpen1
			? 'dropdown-arrow-button dropdown-arrow-button-open'
			: 'dropdown-arrow-button';
	}
	get dropdownButtonClass2() {
		return this.isDropdownOpen2
			? 'dropdown-arrow-button dropdown-arrow-button-open'
			: 'dropdown-arrow-button';
	}
	get dropdownButtonClass3() {
		return this.isDropdownOpen3
			? 'dropdown-arrow-button dropdown-arrow-button-open'
			: 'dropdown-arrow-button';
	}
	get dropdownButtonClass4() {
		return this.isDropdownOpen4
			? 'dropdown-arrow-button dropdown-arrow-button-open'
			: 'dropdown-arrow-button';
	}

	toggleDropdown1() {
		this.isDropdownOpen1 = !this.isDropdownOpen1;
		this.isDropdownOpen2 = false;
		this.isDropdownOpen4 = false;
		this.isDropdownOpen3 = false;
	}
	toggleDropdown2() {
		this.isDropdownOpen2 = !this.isDropdownOpen2;
		this.isDropdownOpen3 = false;
		this.isDropdownOpen1 = false;
		this.isDropdownOpen4 = false;
	}
	toggleDropdown3() {
		this.isDropdownOpen3 = !this.isDropdownOpen3;
		this.isDropdownOpen2 = false;
		this.isDropdownOpen1 = false;
		this.isDropdownOpen4 = false;
		//The setTimeout with a small delay ensures UI updates occur after the current rendering tasks, preventing glitches.
		setTimeout(() => {
			try {
				if (this.recntbtn && this.recntbtn.length > 0) {
					this.recntbtn?.forEach(item => {
						let clickedElement = this.template.querySelector(`[data-name='${item}']`);
						if (clickedElement && (clickedElement.style.backgroundColor === '' || clickedElement.style.backgroundColor === 'white')) {
							// If the background color is white, it means it's not selected
							clickedElement.style.backgroundColor = '#C6AA76'; // Set to selected color
							// this.recntbtn.push(selectedOption);
						} else {
							// If the background color is not white, it means it's selected
							if (clickedElement) {
								clickedElement.style.backgroundColor = 'white'; // Reset to original color
							}
							// this.recntbtn = this.recntbtn.filter(option => option !== selectedOption);
						}
					});
				}
			} catch (error) {
				this.showToast(errormessage, error.message, errorvariant);
				// Handle the error as needed
			}
		}, 100);

	}
	toggleDropdown4() {
		this.isDropdownOpen4 = !this.isDropdownOpen4;
		this.isDropdownOpen3 = false;
		this.isDropdownOpen2 = false;
		this.isDropdownOpen1 = false;
	}
	handlechnagedropdown() {
//This code retrieves data labeled as from the session storage without altering custom labels using for all function.
		const changeValue = sessionStorage.getItem('myData');
		const changeValue1 = sessionStorage.getItem('redness');
		const changeValue2 = sessionStorage.getItem('Paindata');
		const changeValue3 = sessionStorage.getItem('Pustule');
		const changeValue6 = sessionStorage.getItem('mood');
		const changeValue7 = sessionStorage.getItem('fatigue');
		const changeValue8 = sessionStorage.getItem('temprature');
		if (
			!changeValue &&
			!changeValue1 &&
			!changeValue2 &&
			!changeValue3 &&
			!changeValue6 &&
			!changeValue7 &&
			!changeValue8 && this.chsngedVal === yes
		) {
			this.opensubmitModal();
		}

		else if (this.chsngedVal === no) {
			this.accordcolorsmptom = 'card-header-accord';
			this.itchinesschnage1 = true;
			this.isDropdownOpen3 = !this.isDropdownOpen3;
			this.isDropdownOpen2 = false;
			this.isDropdownOpen1 = false;
			this.isDropdownOpen4 = false;
		}
		else {
			this.isDropdownOpen3 = !this.isDropdownOpen3;
			this.isDropdownOpen2 = false;
			this.isDropdownOpen1 = false;
			this.isDropdownOpen4 = false;
		}
	}
	// 
	openItchinessModal() {
		this.submitModal = true;
		document.body.style.overflow = 'hidden';
	}
	closeItchinessModal() {
		this.submitModal = false;
		document.body.style.overflow = ''; // Reset to default
	}
	handleButtonClick() {
//This code retrieves data labeled as from the session storage without altering custom labels for all function.
		const changeValue = sessionStorage.getItem('myData');
		const changeValue1 = sessionStorage.getItem('redness');
		const changeValue2 = sessionStorage.getItem('Paindata');
		const changeValue3 = sessionStorage.getItem('Pustule');
		const changeValue6 = sessionStorage.getItem('mood');
		const changeValue7 = sessionStorage.getItem('fatigue');
		const changeValue8 = sessionStorage.getItem('temprature')
		if (
			!changeValue &&
			!changeValue1 &&
			!changeValue2 &&
			!changeValue3 &&
			!changeValue6 &&
			!changeValue7 &&
			!changeValue8 &&
			!this.lastsymptomid && this.chsngedVal === yes
		) {
			this.opensubmitModal();
			this.isPopupOpendisable = false;
		}


		else {
			this.openundersatand();
			this.isPopupOpendisable = false;
		}
	}
	opensubmitModal() {
		this.submitModal = true;
		document.body.style.overflow = 'hidden';
	}
	closesubmitModal() {
		this.submitModal = false;
		document.body.style.overflow = ''; // Reset to default
	}
	openundersatand() {
		this.undersatand = true;
		document.body.style.overflow = 'hidden';
		this.submitModal = false;
		localStorage.clear();
	}
	closeundersatand() {
		this.undersatand = false;
		document.body.style.overflow = ''; // Reset to default
	}
	addsymtom() {
		if (!this.isDropdownOpen) {
			this.isDropdownOpen2 = true;
			this.isDropdownOpen1 = false;
			this.submitModal = false;
			document.body.style.overflow = ''; // Reset to default
		} else {
			this.isDropdownOpen2 = false;
			this.isPopupOpen = false;

		}
	}

	async understand() {
		window.location.assign(this.urlq + symptomgraphpage + this.dynamicValue);
	}
	openItchinessModal() {
this.showItchinessModal = true;
document.body.style.overflow = 'hidden';
}
closeItchinessModal() {
this.showItchinessModal = false;
document.body.style.overflow = ''; // Reset to default

}
	// PainModal
	openPainModal() {
		this.showPainModal = true;
		document.body.style.overflow = 'hidden';
	}
	closePainModal() {
		this.showPainModal = false;
		document.body.style.overflow = ''; // Reset to default
		// Store data labeled as 'Paindatavalues' in the session storage without altering custom labels.
		sessionStorage.setItem('Paindatavalues', 0);
	}
	// RednessModal
	openRednessModal() {
		this.showrednessModal = true;
		document.body.style.overflow = 'hidden';
	}
	closeRednessModal() {
		this.showrednessModal = false;
		document.body.style.overflow = ''; // Reset to default
		// Store data labeled as 'rednessvalues' in the session storage without altering custom labels.
		sessionStorage.setItem('rednessvalues', 0);
	}
	// pustel model
	openPustulesModal() {
		this.showPustulesModal = true;
		document.body.style.overflow = 'hidden';
	}
	closePustulesModal() {
		this.showPustulesModal = false;
		document.body.style.overflow = ''; // Reset to default
		// Store data labeled as 'Pustulevalues' in the session storage without altering custom labels.
		sessionStorage.setItem('Pustulevalues', 0);
	}
	// Fatigue Modal
	openFatigueModal() {
		this.showFatigueModal = true;
		document.body.style.overflow = 'hidden';
	}
	closeFatigueModal() {
		this.showFatigueModal = false;
		document.body.style.overflow = ''; // Reset to default
		// Store data labeled as 'fatiguevalues' in the session storage without altering custom labels.
		sessionStorage.setItem('fatiguevalues', 0);
	}
	// Temperature Modal
	openTemperatureModal() {
		this.showTemperatureModal = true;
		document.body.style.overflow = 'hidden';
	}
	closeTemperatureModal() {
		this.showTemperatureModal = false;
		document.body.style.overflow = '';
	}
	// Mood Modal
	openMoodModal() {
		this.showMoodModal = true;
		document.body.style.overflow = 'hidden';
	}
	closeMoodModal() {
		this.showMoodModal = false;
		document.body.style.overflow = ''; // Reset to default
	}
	// files upload
	openfiles() {
		this.showfiles = true;
		document.body.style.overflow = 'hidden';
	}
	closefiles() {
		this.showfiles = false;
		document.body.style.overflow = ''; // Reset to default
	}
	handleClickactivites(event) {
		const clickedElement = event.target;
		const elementClass = clickedElement.classList.value;
		if (elementClass.includes(this.btncolorchange)) {
			const selectedOption = clickedElement.getAttribute('data-name');
			// Toggle the background color and update the selected values
			if (clickedElement.style.backgroundColor === '' || clickedElement.style.backgroundColor === 'white') {
				// If the background color is white, it means it's not selected
				clickedElement.style.backgroundColor = '#C6AA76'; // Set to selected color
				this.recntbtn.push(selectedOption);
			} else {
				// If the background color is not white, it means it's selected
				clickedElement.style.backgroundColor = 'white'; // Reset to original color
				this.recntbtn = this.recntbtn.filter(option => option !== selectedOption); // Remove the selected option from the array
			}
		}
	}
	updatedRecordId
	async handleClickForAccept() {
		// Close all dropdowns except the fourth one
		this.isDropdownOpen4 = true;
		this.isDropdownOpen3 = false;
		this.isDropdownOpen2 = false;
		this.isDropdownOpen1 = false;
		// Store data labeled as 'recentactivity' in the session storage without altering custom labels.
		sessionStorage.setItem('recentactivity', this.recntbtn);
		// Set the class based on the condition whether recntbtn has only one item or not
		this.accordcolorbtn = this.recntbtn ? 'card-header-accord' : 'another-class';
		try {
			this.recentactivity = true
			if (this.lastsymptomid) {
				this.updatedRecordId = await updateRecentValue({
					symptomTrackerId: this.lastsymptomid,
					valuesToUpdate: this.recntbtn
				});
				this.recentactivity = true
			}
			else {
				this.updatedRecordId = await updateRecentValue({
					symptomTrackerId: this.resultId,
					valuesToUpdate: this.recntbtn
				});
				this.recentactivity = true
			}
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	  @track totalSize = [];
handleFileInputChange(event) {
    const files = event.target.files;
    if (files && files.length > 0) {
        const newImageUrls = [...this.imageUrls];
		 const newtotalsizeimg = [...this.totalSize];
        const maxFileSize = 5 * 1024 * 1024; // 5MB in bytes
      
        const maxImagesAllowed = 4;

        if (newImageUrls.length + files.length > maxImagesAllowed) {
            // Trying to upload more than 5 images, show error message
            this.isLimitReached = true;

            
        }

        for (let i = 0; i < files.length; i++) {
            const file = files[i];
			console.log(file,"totalSize")
            if (file.type.includes('image')) {
				//   this.totalSize += file.size;

				  console.log( file.size,' file.size')
			
	               const reader = new FileReader();
                    reader.onload = () => {
                        newImageUrls.push(reader.result);
                        this.imageUrls = [...newImageUrls];
                    };
					  reader.readAsDataURL(file)


                if (file.size <= maxFileSize) {
				  console.log( maxFileSize,' maxFileSize')
                  newtotalsizeimg.push(file.size);
	         
				;
				 let sum = 0;
				 for(let j=0; j < this.totalSize.length; j++){
                    sum += this.totalSize[j];
					console.log(this.totalSiz,"sum")
					if(sum > maxFileSize){
						     this.uploadedlarge = true;
							 this.totalSize.splice(j, 1);
                    throw new Error('Image file size exceeds 5MB.');
					}
					else{
					    this.uploadedlarge = false;
					}

				 }
                    
                  
                } else {
                    // Individual file size exceeds 5MB, show error message
                    this.uploadedlarge = true;
					this.totalSize.pop()
                    throw new Error('Image file size exceeds 5MB.');
                 
                }
            } else {
                // Not an image file, show error message
                this.uploadedlarge = false;
                throw new Error('Only PNG, JPG, and PDF files are allowed.');
              
            }
        }
    } else {
        // No files selected or none of them are images
        // this.imageUrls = [];
        this.isLimitReached = false;
    }
}



	handleClickpdf() {
    //  this.imageUrls = [];
		
		console.log(this.imageUrls,'this.imageUrlsthis.imageUrls')
		
		this.filemessage = true;
		this.isDropdownOpen1 = false;
		this.isDropdownOpen2 = false;
		this.isDropdownOpen1 = false;
		this.isDropdownOpen4 = false;
		let newArray=[]
		// Get the file contents from imageUrls and save them
		for(let i=0; i< this.imageUrls.length;i++){
			if(!this.oldimageurl.includes(this.imageUrls[i])){
				newArray.push(this.imageUrls[i])
				this.oldimageurl=[...this.oldimageurl,this.imageUrls[i]]
			}
		}
		console.log(newArray,"newArray")
		const fileContents = newArray.map(imageUrl => imageUrl.split(',')[1]);
		this.recentimages = true;
		if (fileContents) {
			this.filechnagecolour = 'card-header-accord';
			this.filework = true;
		}
		if (this.resultId) {
			try {
				saveFiles({ fileContents, parentId: this.resultId ,fileTitle:this.fileTitle,filePath:this.filePath })
				// Null data is checked and AuraHandledException is thrown from the Apex
					.then(attachmentIds => {
						console.log(attachmentIds,'id')
						this.attachmentIdsvalues = attachmentIds;
						// Check the value of this.resultId
						try {
							createContentDocumentLinks({ fileIds: this.attachmentIdsvalues, symptomTrackerId: this.resultId })
						} catch (error) {
							this.showToast(errormessage, error.message, errorvariant);
						}
					})
					.catch(error => {
						// Handle error if needed
						this.showToast(errormessage, error.message, errorvariant);
					});
			} catch (error) {
				// Handle synchronous error if needed
				this.showToast(errormessage, error.message, errorvariant);
			}
		}
		if (this.resultId !== '') {
			try {
				saveFiles({ fileContents, parentId: this.lastsymptomid,fileTitle:this.fileTitle,filePath:this.filePath })
				// Null data is checked and AuraHandledException is thrown from the Apex
					.then(attachmentIds => {
						console.log(attachmentIds,'id')
						this.attachmentIdsvalues = attachmentIds;
						// Check the value of this.resultId
						try {
							createContentDocumentLinks({ fileIds: this.attachmentIdsvalues, symptomTrackerId: this.lastsymptomid })
						} catch (error) {
							this.showToast(errormessage, error.message, errorvariant);
						}
					})
					.catch(error => {
						// Handle error if needed
						this.showToast(errormessage, error.message, errorvariant);
					});
			} catch (error) {
				// Handle synchronous error if needed
				this.showToast(errormessage, error.message, errorvariant);
			}
		}
	}
	// Call this method to trigger the deletion
	removeImage(event) {
		try {
			deleteContentDocumentLinks({ symptomTrackerId: this.lastsymptomid });
		} catch (error) {
			// Handle synchronous error if needed
			this.showToast(errormessage, error.message, errorvariant);
		}
		const index = event.target.dataset.index;
		this.imageUrls.splice(index, 1);
		this.totalSize.splice(index, 1);
		let sum = 0;
		 const maxFileSize = 5 * 1024 * 1024;
		 for(let j=0; j < this.totalSize.length; j++){
		

                    sum += this.totalSize[j];
						console.log('jjjj',this.totalSize[j]);
					if(sum > maxFileSize){
						     this.uploadedlarge = true;
                    throw new Error('Image file size exceeds 5MB.');
					}
					else{
					    this.uploadedlarge = false;
					}
				 }
		if (this.imageUrls.length > 4) {
			this.isLimitReached = true;
		} else {
			this.isLimitReached = false;
		}
	}

	async handleSaveDate() {
	
			let accForInsert = this.accountId;
			let myBoolean = false;
			// Ensure isDateUnique is resolved before proceeding
			await this.checkDateUniqueness();
			if (this.isDateUnique === false) {
				if (!this.lastsymptomid) {
					this.resultId = await recordInsertSTs({ accId: accForInsert, gpp: myBoolean, editEntryDate: this.currentDate });
				} else {
					this.resultId = await recordInsertSTupdate({ symptomTrackerId: this.lastsymptomid, gpp: myBoolean, editEntryDate: this.currentDate2 });
				}
			}
			if (this.resultId) {
				// Store data labeled as 'Time' in the session storage without altering custom labels.
				localStorage.setItem('Time', this.resultId);
				// Store data labeled as 'gppvalues' in the session storage without altering custom labels.
				sessionStorage.setItem('gppvalues', this.resultId);
				this.datamantroy = true;
			}
	
	}
	async checkDateUniqueness() {
		try {
			if (this.currentDate) {
				this.result = await checkUniqueDate({ editedDate: this.currentDate, accountId: this.accountId });
				if (this.result) {
					this.isDateUnique = false;
				} else {
					this.isDateUnique = true;
					this.datamantroydispable = true;
				}
			}

		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	handleDateChange(event) {
		//localStorage.clear()
		this.currentDate = event.target.value;
		this.currentDate2 = event.target.value;
		this.datamantroydispable = false; // Enable the 'Submit' button
		const selectedDate = new Date(this.currentDate);
		const today = new Date();
		if (selectedDate > today) {
			this.showText = true; // Show the message
			this.futuredatedisable = true;
			this.datamantroydispable = true; // Show the future date error message
		} else {
			this.showText = false; // Hide the message
			this.futuredatedisable = false; // Hide the future date error message
		}
		// Call the checkDateUniqueness function
		this.checkDateUniqueness();
	}
	handleRadioChange(event) {
		this.chsngedVal = event.detail.value;
		this.gpp = this.chsngedVal;
		console.log(this.gpp,"gpp")
		
		// Assuming that this.chsngedVal is a string, use 'true' (string) instead of true (boolean)
		this.showMessage = this.chsngedVal === yes;
		console.log(this.showMessage,"ragav")
	}
	handleSavegpp() {
		// Check if sessionStorage values are empty
		//This code retrieves data labeled as  from the session storage without altering custom labels for all function.
		const changeValue = sessionStorage.getItem('myData');
		const changeValue1 = sessionStorage.getItem('redness');
		const changeValue2 = sessionStorage.getItem('Paindata');
		const changeValue3 = sessionStorage.getItem('Pustule');
		const changeValue6 = sessionStorage.getItem('mood');
		const changeValue7 = sessionStorage.getItem('fatigue');
		const changeValue8 = sessionStorage.getItem('temperature');
		if (
			!changeValue &&
			!changeValue1 &&
			!changeValue2 &&
			!changeValue3 &&
			!changeValue6 &&
			!changeValue7 &&
			!changeValue8 &&
			this.chsngedVal === yes
		) {
			this.opensubmitModal();
			this.accordcolor = 'card-header-gpp'
			// Save radio value
			this.changeradiobtn = true
			this.isPopupOpen = true;
			this.currentlygpp = true;

			try {
				updateGPPValue({ symptomTrackerId: this.gppvaluesradio ? this.gppvaluesradio : this.lastsymptomid, gpp: this.changeradiobtn })
				// Null data is checked and AuraHandledException is thrown from the Apex
					.then((result) => {
						if (result) {
							this.accordcolor = 'card-header-gpp';
						}
					})
					.catch((error) => {
						this.showToast(errormessage, error.message, errorvariant);
					})
					.finally(() => {
						this.isEditMode = false;
					});
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (this.lastsymptomid || this.chsngedVal === no) {
			this.currentlygpp = true
			this.isPopupOpenundersatand = true;
			this.isDropdownOpen2 = true;
			this.isDropdownOpen1 = false;
			this.accordcolor = 'card-header-gpp';
			this.changeradiobtn = false;
			try {
				updateGPPValue({ symptomTrackerId: this.lastsymptomid ? this.lastsymptomid : this.gppvaluesradio, gpp: this.changeradiobtn })
			}
			catch (error) {
				this.showToast(errormessage, error.message, errorvariant);
			}
		}
	}

	@wire(getLast)
	wiredLastEntryDate({ error, data }) {
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data) {
			try {
				if (data[0].BI_PSP_Symptom_image__c) {
					this.Image = data[0].BI_PSP_Symptom_image__c;
				}
				if (data[1].BI_PSP_Symptom_image__c) {
					this.Image1 = data[1].BI_PSP_Symptom_image__c;
				}
				if (data[2].BI_PSP_Symptom_image__c) {
					this.Image2 = data[2].BI_PSP_Symptom_image__c;
				}
				if (data[3].BI_PSP_Symptom_image__c) {
					this.Image3 = data[3].BI_PSP_Symptom_image__c;
				}
				if (data[4].BI_PSP_Symptom_image__c) {
					this.Image4 = data[4].BI_PSP_Symptom_image__c;
				}
				if (data[5].BI_PSP_Symptom_image__c) {
					this.Image5 = data[5].BI_PSP_Symptom_image__c;
				}
				if (data[6].BI_PSP_Symptom_image__c) {
					this.Image6 = data[6].BI_PSP_Symptom_image__c;
				}

				const desiredWidth = '100px';
				const desiredHeight = '100px';
				const imgTagRegex = /<img\s+[^>]*src='([^']+)'[^>]*>/gi;

				const formatImageContent = (image) => {
					return image.replace(imgTagRegex, (match, src) => {
						return `<img src='${src}' alt='' width='${desiredWidth}' height='${desiredHeight}'>`;
					});
				};

				this.Image = formatImageContent(this.Image);
				this.Image1 = formatImageContent(this.Image1);
				this.Image2 = formatImageContent(this.Image2);
				this.Image3 = formatImageContent(this.Image3);
				this.Image4 = formatImageContent(this.Image4);
				this.Image5 = formatImageContent(this.Image5);
				this.Image6 = formatImageContent(this.Image6);
			} catch (err) {
				//this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			//this.showToast(errormessage, error.body.message, errorvariant);
			// Handle error 
		}
	}
	@wire(getsymptomrecorddata, { symptomTrackerId: '$lastsymptomid' })
	wiredGetsymptomrecorddata({ error, data }) {
		if (data && data !== null){
			try {
				this.satrdate = false;
				this.symptomdata = data[0].BI_PSP_EditEntrydates__c;
				this.symptomgpp = data[0].BI_PSP_Are_you_currently_experiencing__c;
				this.chsngedVal = this.symptomgpp;
				if(this.chsngedVal == true){
                      this.chsngedVal =yes
				}
				else{
					this.chsngedVal =no

				}
				console.log(this.chsngedVal ,"ooooo",this.symptomgpp)
				this.currentlygpp = true;
				this.datedisable = true;

				if (this.symptomgpp === true) {
					this.showMessage = true;
				}

				if (this.symptomdata) {
					this.datamantroy = true;
				}

				this.symptomgpp = true;

				for (let symptomrecord of data) {
					let getsymtomdate = symptomrecord.BI_PSP_EditEntrydates__c;
					let getsymptomrecentbtn = symptomrecord.BI_PSP_Recent_Activities__c;
					this.currentDate2 = new Date(getsymtomdate).toISOString()?.split('T')[0];
					this.recntbtn = getsymptomrecentbtn?.split(';');
					this.recentactivity = true;
					this.accordcolor = 'card-header-gpp';
					this.accordcolorbtn = 'card-header-accord';
					//The use of setInterval ensures optimal timing for thumb label position updates, enhancing animation smoothness and performance
					setInterval(() => {
						this.recntbtn?.forEach(item => {
							let element = this.template.querySelector(`[data-name='${item}']`);
							if (element) {
								element.style.backgroundColor = '#C6AA76';
							} else {
								console.warn(`Element with data-name='${item}' not found.`);
							}
						});
					}, 1000);
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			 this.showToast(errormessage, error.body.message, errorvariant);
		}
	}


	@track oldimageurl= [];
	@wire(getCaseImageURL, { symptomTrackerId: '$lastsymptomid' })


	wiredgetCaseImageURL({ data, error }) {
		if (data && data !== null){
			try {
				this.caseImageURL = data;
				console.log(this.caseImageURL,'mmmmmmmmmmmmmmmmmmmmm')
				this.filemessage = true;
				this.filechnagecolour = 'card-header-accord';

				if (this.firsttime === false) {
					let splitArray = data?.map((obj) => obj.split('data:')[1]);
					for (let record of splitArray) {
						if (record !== '') {
							this.imageUrls = [...this.imageUrls, 'data:' + record];
							this.oldimageurl = [...this.oldimageurl, 'data:' + record];
							
						}
					}
					this.firsttime = true;
					this.recentimages = true;
				} else if (this.imageUrls.length < 0) {
					this.filechnagecolour = 'card-header-accord';
				}
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
				// Handle the error as needed
			}
		}
	
	}


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
	checksubmit() {
		if (this.carePlanTemplateName) {
			this.openundersatand();
		}
	}
	@wire(getAllergyIntolerancedata, { symptomTrackerId: '$lastsymptomid' })
	wiredAllergyIntoleranceData({ error, data }) {
		if (data && data !== null){
			try {
				this.isPopupOpendisable = false;
				this.whichsymptom = data;
				// ... (Previous code)
				for (let record of data) {
					// Access values of each record
					this.intensity = record.BI_PSP_Intensity__c;
					this.carePlanTemplateName = record?.BI_PSP_Symptoms__r?.HealthCloudGA__CarePlanTemplate__r?.Name;
					// Compare with the string 'Itchiness'
					if (this.carePlanTemplateName === Itchiness) {
						this.itchinesschnage = true;
						this.itchinesschnage1 = true;
						//As these are css class names, we haven't used custom label for this scenario
						this.accordcolorsmptom = 'card-header-accord';
					}
					if (this.carePlanTemplateName === Redness) {
						this.rednesschnage = true;
						//As these are css class names, we haven't used custom label for this scenario
						this.accordcolorsmptom = 'card-header-accord';
						this.itchinesschnage1 = true;
					}
					if (this.carePlanTemplateName === Pain) {
						this.painchnage = true;
						//As these are css class names, we haven't used custom label for this scenario
						this.accordcolorsmptom = 'card-header-accord';
						this.itchinesschnage1 = true;
					}
					if (this.carePlanTemplateName === Pustules) {
						this.pustleschnage = true;
						this.itchinesschnage1 = true;
						//As these are css class names, we haven't used custom label for this scenario
						this.accordcolorsmptom = 'card-header-accord';
					}
					if (this.carePlanTemplateName === fatique) {
						this.fatiqueschnage = true;
						this.itchinesschnage1 = true;
						//As these are css class names, we haven't used custom label for this scenario
						this.accordcolorsmptom = 'card-header-accord';
					}
					if (this.carePlanTemplateName === Temperature) {
						this.itchinesschnage1 = true;
						this.Temperaturechnage = true;
						//As these are css class names, we haven't used custom label for this scenario
						this.accordcolorsmptom = 'card-header-accord';
					}
					if (this.carePlanTemplateName === Mood) {
						this.itchinesschnage1 = true;
						this.Moodchnage = true;
						//As these are css class names, we haven't used custom label for this scenario
						this.accordcolorsmptom = 'card-header-accord';
					}
				}
				// ... (Rest of the code)
			} catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	handleFocus() {
		// Set maximum date to today
		let today = new Date().toISOString().split('T')[0];
		this.template.querySelector('.datepicker').max = today;
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



	lastModifiedDate;
		@wire(getSymptomTrackerDetails, { careProgramEnrolleeId: '$accountId' })
		wiredResult({ error, data }) {
			try {
					console.log(data,'datattata')
				if (data) {
				
					this.lastModifiedDate = data.lastModifiedDate;
					this.lastModifiedtime = data.lasttime;
							console.log(this.lastModifiedDate,'datattata')
					let newdate3 = this.lastModifiedtime.split(', ');
					const dateTime = new Date(newdate3);
					// Get the hours, minutes, and seconds from the Date object
					const hours = dateTime.getHours();
					const minutes = dateTime.getMinutes();
					const seconds = dateTime.getSeconds();
					// Format the time in HH:mm:ss format (24-hour format)
					const formattedTime = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
					this.lastModifi = true;
					// Get the current date and time
					let date = new Date(this.lastModifiedDate);
					let options = { month: '2-digit', day: '2-digit', hour: 'numeric', minute: 'numeric', hour12: true };
					let formattedDate = date.toLocaleString(undefined, options);
					let newdate = formattedDate.split(', ');
					this.formattedLastModifiedDate = `${newdate[0]} at ${formattedTime}`;
					// Log the extracted time
				}
			} catch (err) {
				console.error('An error occurred:', err);
			}			
		}
		formatDate(date) {
				const options = {
						month: 'numeric',
						day: 'numeric',
						hour: 'numeric',
						minute: 'numeric',
						hour12: true,
				};
				return date.toLocaleString('en-US', options);
		}
}