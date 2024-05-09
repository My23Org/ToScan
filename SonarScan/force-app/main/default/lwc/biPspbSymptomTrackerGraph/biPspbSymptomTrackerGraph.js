//This LWC is Used for display allergy values and symptom values based on month wise  - biPspbSymptomTrackerGraph
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Static Resources
import YellowEllipse from '@salesforce/resourceUrl/BI_PSP_ST_YellowEllipse';
import DarkRedEllipse from '@salesforce/resourceUrl/BI_PSP_ST_DarkRedEllipse';
import BlueEllipse from '@salesforce/resourceUrl/BI_PSP_ST_BlueEllipse';
import GreenEllipse from '@salesforce/resourceUrl/BI_PSP_ST_GreenEllipse';
import VioletEllipse from '@salesforce/resourceUrl/BI_PSP_ST_VioletEllipse';
import RedEllipse from '@salesforce/resourceUrl/BI_PSP_ST_RedEllipse';
import verticaline from '@salesforce/resourceUrl/BI_PSP_verticalline';
import DarkYellowEllipse from '@salesforce/resourceUrl/BI_PSP_ST_DarkYellowEllipse';
import righticon from '@salesforce/resourceUrl/BI_PSP_Deletetoastmsg';
// To import Apex Classes
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import fetchSymptomErolle from '@salesforce/apex/BI_PSP_GraphCtrl.getSymptomTrackerDetails';
import getLatestSymptomRecord from '@salesforce/apex/BI_PSPB_Symptomtrackerprimarypage.getLatestSymptomRecord';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import January from '@salesforce/label/c.BI_PSPB_January';
import February from '@salesforce/label/c.BI_PSPB_February';
import March from '@salesforce/label/c.BI_PSPB_March';
import april from '@salesforce/label/c.BI_PSPB_April';
import May from '@salesforce/label/c.BI_PSPB_May';
import June from '@salesforce/label/c.BI_PSPB_June';
import July from '@salesforce/label/c.BI_PSPB_July';
import August from '@salesforce/label/c.BI_PSPB_August';
import September from '@salesforce/label/c.BI_PSPB_September';
import October from '@salesforce/label/c.BI_PSPB_October';
import November from '@salesforce/label/c.BI_PSPB_November';
import December from '@salesforce/label/c.BI_PSPB_December';
import errormessages from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import symptommainpageurl from '@salesforce/label/c.BI_PSPB_symptomtrackermainpage';
import symptomtrackerpdf from '@salesforce/label/c.BI_PSPB_symptomtrackerpdf';
import unexpectederror from '@salesforce/label/c.BI_PSPB_unexpectederror';
import latestrecord from '@salesforce/label/c.BI_PSPB_latestrecord';
import month from '@salesforce/label/c.BI_PSPB_month';
import Itchiness from '@salesforce/label/c.BI_PSPB_Itchiness';
import Rednes from '@salesforce/label/c.BI_PSPB_Redness';
import Painn from '@salesforce/label/c.BI_PSPB_Pain';
import Pusstules from '@salesforce/label/c.BI_PSPB_Pustules';
import fatique from '@salesforce/label/c.BI_PSPB_Fatique';
import Temperrature from '@salesforce/label/c.BI_PSPB_Temperrature';
import Mood from '@salesforce/label/c.BI_PSPB_Mood';
import symptomTrackers from '@salesforce/label/c.BI_PSPB_symptomTrackers';
import pdf from '@salesforce/label/c.BI_PSPB_pdf';
import highlightBack from '@salesforce/label/c.BI_PSPB_highlightBack';
import erolls from '@salesforce/label/c.BI_PSPB_erolls';
import firstdateee from '@salesforce/label/c.BI_PSPB_firstdateee';
import lastdateee from '@salesforce/label/c.BI_PSPB_lastdateee';
import shorts from '@salesforce/label/c.BI_PSPB_shorts';
import numerics from '@salesforce/label/c.BI_PSPB_numerics';
import primarypages from '@salesforce/label/c.BI_PSPB_primarypages';
import months from '@salesforce/label/c.BI_PSPB_months';
import firstdategraph from '@salesforce/label/c.BI_PSPB_firstdategraph';
import lastdategraph from '@salesforce/label/c.BI_PSPB_lastdategraph';
import zero from '@salesforce/label/c.BI_PSPB_zero';
import valuess from '@salesforce/label/c.BI_PSPB_valuess';
import zeroone from '@salesforce/label/c.BI_PSPB_zeroone';
import Slash from '@salesforce/label/c.BI_PSPB_Slash';
import Slashlatter from '@salesforce/label/c.BI_PSP_Slashlatter';
import Questionmark from '@salesforce/label/c.BI_PSP_Questionmark';


export default class BiPspbSymptomTrackerGraph extends LightningElement{
//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	@track receivedValue;
	@track dateWithAllery = [];
	@track highlight = false;
	@track showDiv = false;
	@track remainingItems = [];
	@track pdfname;
	@track firstdate;
	@track lastDate;
	@track symptomidget
	@track checkvalue = false;
	@track showLine;
	@track currentDisplayIndex = 0;
	@track dateWithAllery2 = [];
	@track dateWithAllery3 = [];
	@track dateWithAllery4 = [];
	@track leftLess;
	@track rightLess;
	@track showChart = false;
	@track updatevalue = false;
	@track undersatand = false;
	@track latestRecord;
	//Variable declaration
	enrolleId
	montss;
	YellowEllipse = YellowEllipse;
	rightimg = righticon;
	DarkRedEllipse = DarkRedEllipse;
	BlueEllipse = BlueEllipse;
	verticaline = verticaline;
	GreenEllipse = GreenEllipse;
	VioletEllipse = VioletEllipse;
	RedEllipse = RedEllipse;
	DarkYellowEllipse = DarkYellowEllipse;
	bubbles = '';
	userId = Id;
	errorMessage;
	showError;
	currentIndex = 0;
	showPopup;
	placeholder = month;
	selectedMonthValue;
	picklistOptions = [
		{ label: January, value: January },
		{ label: February, value: February },
		{ label: March, value: March },
		{ label: april, value: april },
		{ label: May, value: May },
		{ label: June, value: June },
		{ label: July, value: July },
		{ label: August, value: August },
		{ label: September, value: September },
		{ label: October, value: October },
		{ label: November, value: November },
		{ label: December, value: December }
	];
	// Handles the response from the getLatestSymptomRecord Apex method. 
	@wire(getLatestSymptomRecord, { careProgramEnrolleeId: '$enrolleId' })
	wiredLatestRecord({ error, data }) {
		if (data && data !== null)
		 {
			try {
				this.latestRecord = data[0];
				this.errorMessage = ''; // Clear any previous error
			} catch (ex) {
				this.showToast(errormessages, ex.message, errorvariant);
				// Handle the error accordingly, such as displaying an error message to the user
				this.errorMessage = unexpectederror;
				this.latestRecord = null;
			}
		} else if (error) {
			this.showToast(errormessages, error.body.message, errorvariant);
			this.latestRecord = null;
			this.errorMessage = latestrecord;
		}
	}
	// Determines the current URL and sets a navigation URL based on certain path components.
	connectedCallback(){
		this.throwerrormessage=false;
	const queryParams = new URLSearchParams(window.location.search);
// Get the value of the 'valuess' parameter
this.receivedValue = queryParams.get('value');
// Check if the value is received
if (this.receivedValue) {
    this.showDiv = true;
    setTimeout(() => {
        try {
            // Delete the 'valuess' parameter from the URL
            queryParams.delete('value');
            // Replace the current URL with the modified URL (without 'valuess' parameter)
            window.history.replaceState({}, document.title, window.location.pathname + '?' + queryParams.toString());
            this.showDiv = false;
        } catch (error) {
            this.showToast('Error', error.message, 'error');
            // Handle the error as needed
        }
    }, 3000);
}		
					// You can use the value here as needed
				
				const currentURL = window.location.href;
				// Create a URL object
				const urlObject = new URL(currentURL);
				// Get the path
				const path = urlObject.pathname;
				// Split the path using '/' as a separator
				const pathComponents = path.split(Slash);
				// Find the component you need (in this case, 'Branded')
				const desiredComponent = pathComponents.find(component =>
					[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
				);
				if(desiredComponent.toLowerCase() === brandedurl.toLowerCase()){
					this.urlq = brandedUrlNavi;
				}
				else{
					this.urlq = unAssignedUrlNavi;
				}
				let primarypopup = sessionStorage.getItem(primarypages);
				if(primarypopup){
					this.openundersatand()
				}
				try {
					getEnrolle({ userId: this.userId })
					// Null data is checked and AuraHandledException is thrown from the Apex
						.then(result => {
							if (result[0].patientEnrolle != null) {
								this.enrolleId = result[0].patientEnrolle.Id;
								var urlParams = new URLSearchParams(window.location.href.split(Questionmark)[1]);
								let eroll = urlParams.get(erolls);
								let firstdate1 = urlParams.get(firstdateee);
								let lastdate1 = urlParams.get(lastdateee);
								this.firstdate = firstdate1;
								this.lastDate = lastdate1;
								let month = urlParams.get(months);
								this.selectedMonthValue = month;
								if (eroll != null && firstdate1 != null && lastdate1 != null) {
									const selectElement = this.template.querySelector('.selectWidth');//This is the querySelector which uses html class 
									selectElement.value = month;
									this.getsymptomdatewithallergy(eroll, firstdate1, lastdate1);
								}
							} else if (result[0].error != null) {
								this.showError = true;
								this.errorMessage = result[0].error;
							}
						})
						.catch(error => {
							// Handle any errors occurring during the promise chain
							this.showToast(errormessages, error.message, errorvariant);
						});
				} catch (error) {
					// Handle any synchronous errors outside the promise chain
					this.showToast(errormessages, error.message, errorvariant);
				}				
			}	
			//Returns the formatted date string.	
parsedDat(dateToFormat){
		const parsedDate = new Date(dateToFormat);
		const options = { month: shorts, day: numerics };
		return this.formattedDate = parsedDate.toLocaleDateString(undefined, options);
	}
	//Captures the current state of the component and generates a PDF report
	captureComponent(){
		if (this.selectedMonthValue != null && this.dateWithAllery != null){
			let currenturl = window.location.href.split(Slashlatter)[0];
			window.open(currenturl + symptomtrackerpdf + this.enrolleId + firstdategraph + this.firstdate + lastdategraph + this.lastDate);
		}
	}
	handleclose(){
		this.showDiv = false;
	}
	//To Updates the selectedMonthValue property with the value of the selected category.
	handleCategoryChange(event){
		this.showChart = false;
		this.checkvalue = false;
		this.currentDisplayIndex = 0;
		this.dateWithAllery = [];
		this.dateWithAllery2 = [];
		this.dateWithAllery3 = [];
		this.dateWithAllery4 = [];
		this.remainingItems = [];
		this.rightLess = false;
		this.leftLess = false;
		this.selectedMonthValue = event.target.value;		
		this.pdfname = symptomTrackers + this.selectedMonthValue + pdf;
		const selectedDate = new Date(this.selectedMonthValue + zeroone);
		const selectedMonthIndex = selectedDate.getMonth();
		const selectedYear = selectedDate.getFullYear();
		const currentDate = new Date();
		const currentYear = currentDate.getFullYear();
		if(selectedYear < currentYear || (selectedYear === currentYear && selectedMonthIndex <= currentDate.getMonth())){
			// Calculate first date of next month
			this.montss = this.getDatesOfMonth();
			const firstDateOfNextMonth = new Date(currentYear, selectedMonthIndex + 1, 1);
			firstDateOfNextMonth.setHours(18, 30, 0, 0); // Set time to 18:30:00.000
			// Calculate last date of previous month
			const lastDateOfPreviousMonth = new Date(currentYear, selectedMonthIndex, 0);
			lastDateOfPreviousMonth.setHours(18, 30, 0, 0); // Set time to 18:30:00.000
 // Assign values to this.firstdate and this.lastDate
			this.firstdate = lastDateOfPreviousMonth.toISOString();
			this.lastDate = firstDateOfNextMonth.toISOString();
			// Call your function with the desired date range
			this.getsymptomdatewithallergy(this.enrolleId, this.firstdate, this.lastDate);
		}else{
			this.montss = this.getDatesOfMonth();
			// Calculate first date of current month
			const firstDateOfCurrentMonth = new Date(currentYear, selectedMonthIndex, 1);
			firstDateOfCurrentMonth.setHours(18, 30, 0, 0); // Set time to 18:30:00.000
			// Calculate last date of previous month
			const lastDateOfPreviousMonth = new Date(currentYear, selectedMonthIndex - 1, 0);
			lastDateOfPreviousMonth.setHours(18, 30, 0, 0); // Set time to 18:30:00.000
 // Assign values to this.firstdate and this.lastDate
			this.firstdate = lastDateOfPreviousMonth.toISOString();
			this.lastDate = firstDateOfCurrentMonth.toISOString();
			// Call your function with the desired date range
			this.getsymptomdatewithallergy(this.enrolleId, this.firstdate, this.lastDate);
		}
	}
	openundersatand(){
		// Add your specific logic for opening the mood modal
		this.undersatand = true;
		this.submitModal = false;
	}
	closeundersatand(){
		// Add your specific logic for closing the mood modal
		this.undersatand = false;
	}	
	formatDate(inputDate){
		// Regular expression pattern for "Month Day" format, e.g., "Aug 27"
		const pattern = /^[A-Za-z]{3}\s\d{1,2}$/;
		// Use test method of the regular expression to check if the format matches
		let checkFormat = pattern.test(inputDate);
		if(!checkFormat){
			// Split the input date string into month and day parts
			let [day, month] = inputDate.split(' ');
			// Return the formatted date string with day first and month second
			return `${month} ${day}`;
		}
		else{
			return inputDate;
		}   
	}
	@track throwerrormessage=false;
	//Fetches symptom and allergy data for the specified enrollee and date range using the fetchSymptomErolle method.
	getsymptomdatewithallergy(erolles, firstDate, lastDate){
		fetchSymptomErolle({ erolleId: erolles, firstDate: firstDate, lastDate: lastDate })
		// Null data is checked and AuraHandledException is thrown from the Apex
			.then(result => {
				if(result != null){
					result.forEach(item => {
						const existingDate = this.dateWithAllery.find(entry => entry.dates === this.parsedDat(item.dates));
						if(existingDate){
							existingDate.imageUrls.push(this.getImagesForName(item.name));
						}else{
							this.dateWithAllery.push({
								dates: this.parsedDat(item.dates),
								imageUrls: [this.getImagesForName(item.name)],
								symptom: item.symptom
							});
						}
					});
					this.dateWithAllery.sort((a, b) => new Date(a.dates) - new Date(b.dates));
					
					if (this.dateWithAllery.length > 7) {
						this.rightLess = true;
					}
					else if (window.innerWidth <= 600 && this.dateWithAllery.length > 2) {
	this.rightLess = true;
}
					else{
						this.rightLess = false;
					}
					this.dateWithAllery2 = this.dateWithAllery;
					//this.generatePdf(JSON.stringify(this.dateWithAllery2), null, null);
					this.dateWithAllery3 = this.dateWithAllery;
					this.dateWithAllery4 = this.dateWithAllery;
					this.dateWithAllery = this.dateWithAllery.slice(0, 7);
					if(this.dateWithAllery.length > 0){
						this.throwerrormessage = true;
						this.showLine = true;
						this.showChart = true;
						
					}else{
						this.showLine = false;
						this.showChart = false;
						this.throwerrormessage =false;
						
					}
				}else{
					this.showChart = false;
					this.checkvalue = false;
					this.throwerrormessage =false;
				}			
					this.dateWithAllery = this.dateWithAllery.filter(item => {
						// Check if the item's date is included in the selectedDates array                        
						let isMar1Available = false;
						for(let i = 0; i < this.montss.length; i++){
							if(this.montss[i] === this.formatDate(item.dates)){
								isMar1Available = true;
								break;
							}
						}                      
						return isMar1Available;
					});
			})
			.catch(error => {
				this.errormessage=error;
			});
	}
	// Function to generate an array of dates for the selected month
	getDatesOfMonth(){
		const monthNames = [
			January, February, March, april, May, June,
			July, August, September, October, November, December
		];
		const selectedMonthIndex = monthNames.indexOf(this.selectedMonthValue);
		const numberOfDays = new Date(new Date().getFullYear(), selectedMonthIndex + 1, 0).getDate();
		const datesOfMonth = [];
		for (let day = 1; day <= numberOfDays; day++) {
			datesOfMonth.push(`${this.selectedMonthValue.substr(0, 3)} ${day}`);
		}
		return datesOfMonth;
	}
	// Returns an array of formatted dates like "Jan 1", "Jan 2", ...
	get bars(){
		return this.dateWithAllery.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	// Function to return the appropriate image URL based on the given symptom name
	getImagesForName(name){
		switch (name){
			case Rednes:
				return RedEllipse;
			case Itchiness:
				return DarkYellowEllipse;
			case Painn:
				return VioletEllipse;
			case Pusstules:
				return GreenEllipse;
			case fatique:
				return BlueEllipse;
			case Temperrature:
				return DarkRedEllipse;
			case Mood:
				return YellowEllipse;
			default:
				return DarkRedEllipse;
		}
	}
	// Function to toggle the CSS class for highlighting background
	highlightbackground(){
		if(this.bubbles === ''){
			this.bubbles = highlightBack;
		}else{
			this.bubbles = '';
		}
	}

//Function to highlight the selected bar and update related properties
	showHighlighter(event){
		let clickedKey = event.target.dataset.item;
		let bars = this.template.querySelectorAll('.bar');//This is the css property of overflow so this can't be through customlabel
		bars.forEach((bar) => {
			if(bar.dataset.item === clickedKey){
				bar.style.backgroundColor = '#ECDCA8';//This is the css property of overflow so this can't be through customlabel
				bar.style.borderRadius = '12px';//This is the css property of overflow so this can't be through customlabel
			}else{
				bar.style.backgroundColor = '';
			}
		});
		const existingDate = this.dateWithAllery4.find(entry => entry.dates === clickedKey);
		this.symptomidget = existingDate.symptom;
		if(this.symptomidget){
			this.checkvalue = true;
		}
		else{
			this.checkvalue = false;
		}
	}
// Function to update the displayed data to the next seven days
 changeNextSeven(){
		this.dateWithAllery2 = this.dateWithAllery4;
		this.currentDisplayIndex += 7;
		this.updateBars();
	}
// Function to update the displayed data to the previous seven days
	changePreviousSeven(){
		this.dateWithAllery3 = this.dateWithAllery4;
		this.currentDisplayIndex -= 7;
		if(JSON.stringify(this.currentDisplayIndex) === zero){
			this.leftLess = false;
		}
		this.updateBars1();
	}
	// Function to update the displayed bars based on the current display index
	updateBars1(){
		let endIndex = this.currentDisplayIndex + 7;
		if(endIndex === -(this.currentDisplayIndex)){
			this.currentDisplayIndex = 0;
			this.rightLess = true;
		}else{
			this.rightLess = true;
		}
		this.dateWithAllery3 = this.dateWithAllery3.slice(this.currentDisplayIndex, endIndex);
		this.dateWithAllery = this.dateWithAllery3;
		if(this.dateWithAllery.length > 0){
			this.showLine = true;
			this.bars();
		}else{
			this.showLine = false;
		}
		this.dateWithAllery3 = this.dateWithAllery4;
	}
//Calculates end index for the displayed data and adjusts if it exceeds the length of the data array
	updateBars(){
		let endIndex = this.currentDisplayIndex + 7;
		if(endIndex > this.dateWithAllery2.length){
			endIndex = this.dateWithAllery2.length;
			this.rightLess = false;
			this.leftLess = true;
		}else{
			this.leftLess = false;
		}
		this.dateWithAllery2 = this.dateWithAllery2.slice(this.currentDisplayIndex, endIndex);
		this.dateWithAllery = this.dateWithAllery2;
		if(this.dateWithAllery.length > 0){
			this.showLine = true;
			this.bars();
		}else{
			this.showLine = false;
		}
		this.dateWithAllery2 = this.dateWithAllery4;
	}

	updatesymptom(){
		// window.location.assign('/' + this.urlq + '/s/bi-pspb-symptomtrackerlandingpage?edit=true');
		window.location.assign(this.urlq + symptommainpageurl);
		localStorage.clear();
}
	doNotLogout(){
		this.showPopup = false;
		document.body.style.overflow = ''; // Reset to default
	}
	openShowPopUp(){
		this.showPopup = true;
		document.body.style.overflow = 'hidden'; //This is the css property of overflow so this can't be through customlabel
	}
	// Function to move the selection in a dropdown menu upwards
 moveSelectionUp(){
		const selectElement = this.template.querySelector('select');//This is the querySelector which uses html class 
		const currentIndex = selectElement.selectedIndex;
		if (currentIndex > 0) {
			selectElement.selectedIndex = currentIndex - 1;
			this.handleSelectionChange();
		}
	}
	// Function to move the selection in a dropdown menu downwards
	moveSelectionDown(){
		const selectElement = this.template.querySelector('select');//This is the querySelector which uses html class 
		const currentIndex = selectElement.selectedIndex;
		if (currentIndex < selectElement.options.length - 1){
			selectElement.selectedIndex = currentIndex + 1;
			this.handleSelectionChange();
		}
	}
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}