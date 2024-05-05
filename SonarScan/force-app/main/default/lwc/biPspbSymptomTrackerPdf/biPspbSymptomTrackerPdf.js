//This LWC is used UserSymptomTracker graph download in pdf - biPspbSymptomTrackerPdf
// To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Static Resources
import YellowEllipse from '@salesforce/resourceUrl/BI_PSP_ST_YellowEllipse';
import verticaline from '@salesforce/resourceUrl/BI_PSP_verticalline';
import DarkRedEllipse from '@salesforce/resourceUrl/BI_PSP_ST_DarkRedEllipse';
import BlueEllipse from '@salesforce/resourceUrl/BI_PSP_ST_BlueEllipse';
import GreenEllipse from '@salesforce/resourceUrl/BI_PSP_ST_GreenEllipse';
import VioletEllipse from '@salesforce/resourceUrl/BI_PSP_ST_VioletEllipse';
import RedEllipse from '@salesforce/resourceUrl/BI_PSP_ST_RedEllipse';
import DarkYellowEllipse from '@salesforce/resourceUrl/BI_PSP_ST_DarkYellowEllipse';
import sitelogo from '@salesforce/resourceUrl/BI_PSPB_SiteLogo';
// To import Apex Classes
import fetchSymptomErolle from '@salesforce/apex/BI_PSP_GraphCtrl.getSymptomTrackerDetails';
import userDetails from '@salesforce/apex/BI_PSPB_LoginCtrl.userDetails';
// To import Custom Labels
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
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import month from '@salesforce/label/c.BI_PSPB_month';
import Itchiness from '@salesforce/label/c.BI_PSPB_Itchiness';
import Rednes from '@salesforce/label/c.BI_PSPB_Redness';
import Painn from '@salesforce/label/c.BI_PSPB_Pain';
import Pusstules from '@salesforce/label/c.BI_PSPB_Pustules';
import fatique from '@salesforce/label/c.BI_PSPB_Fatique';
import Temperrature from '@salesforce/label/c.BI_PSPB_Temperrature';
import Mood from '@salesforce/label/c.BI_PSPB_Mood';
import erolls from '@salesforce/label/c.BI_PSPB_erolls';
import firstdateee from '@salesforce/label/c.BI_PSPB_firstdateee';
import lastdateee from '@salesforce/label/c.BI_PSPB_lastdateee';
import shorts from '@salesforce/label/c.BI_PSPB_shorts';
import numerics from '@salesforce/label/c.BI_PSPB_numerics';
import twothousand from '@salesforce/label/c.BI_PSPB_twothousand';
import Questionmark from '@salesforce/label/c.BI_PSP_Questionmark';


export default class BiPspbSymptomTrackerPdf extends LightningElement{
//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	@track dateWithAllery = [];
	@track remainingItems = [];
	@track highlight = false;
	@track showLine;
	@track dateWithAllerytwo = [];
	@track dateWithAllerythree = [];
	@track dateWithAlleryfour = [];
	@track dateWithAlleryfive = [];
	@track dateWithAlleryall = [];
	@track rightLess;
	@track nextSeven;
	@track nextSeven1;
	@track nextSeven2;
	@track nextSeven3;
	//Variable declaration
	monthName;
	selectedMonthValue;
	YellowEllipse = YellowEllipse;
	verticaline = verticaline;
	DarkRedEllipse = DarkRedEllipse;
	BlueEllipse = BlueEllipse;
	GreenEllipse = GreenEllipse;
	VioletEllipse = VioletEllipse;
	RedEllipse = RedEllipse;
	DarkYellowEllipse = DarkYellowEllipse;
	navlogo = sitelogo;
	userId = Id;
	errorMessage;
	userName;
	placeholder = month;
	showeditbtn = false;
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
	//Each bar represents a date entry and its height is proportional to the number of image URLs.
	get bars(){
		return this.dateWithAllery.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	//Each bar represents a date entry and its height is proportional to the number of image URLs.
	get barsone(){
		return this.dateWithAllerytwo.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	// Each bar represents a date entry and its height is proportional to the number of image URLs.
	get barstwo(){
		return this.dateWithAllerythree.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	//Each bar represents a date entry and its height is proportional to the number of image URLs.
	get barsthree(){
		return this.dateWithAlleryfour.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	//Each bar represents a date entry and its height is proportional to the number of image URLs.
	get barsfour(){
		return this.dateWithAlleryfive.map(entry => ({
			height: `${entry.imageUrls.length * 20}px`,
			dates: entry.dates,
			imageUrls: entry.imageUrls
		}));
	}
	//It retrieves URL parameters such as 'eroll', 'firstdate', and 'lastdate' to fetch symptom data for a specific enrollee within a given date range.
	connectedCallback(){
		try{
				let urlParams = new URLSearchParams(window.location.href.split(Questionmark)[1]);
				let eroll = urlParams.get(erolls);
				let firstdate = urlParams.get(firstdateee);
				let lastdate = urlParams.get(lastdateee);
				const date = new Date(firstdate);
				const monthNames = [January, February, March, april, May, June, July, August, September, October, November, December];
				this.monthName = monthNames[date.getMonth() + 1];
				this.getsymptomdatewithallergy(eroll, firstdate, lastdate);
				if(Id !== null && Id !== undefined){
					userDetails({ userId: Id })
					// Null data is checked and AuraHandledException is thrown from the Apex
						.then(user => {
							this.userName = user.FirstName + ' ' + user.LastName;
						})
						.catch(error => {
							this.showToast(errormessage, error.message, errorvariant);
						})
				}
			}
			catch(error){
				this.showToast(errormessage, error.message, errorvariant);
			}
		}
		//The formatted date string.		
	parsedDat(dateToFormat){
		const parsedDate = new Date(dateToFormat);
		const options = { month: shorts, day: numerics};
		this.formattedDate = parsedDate.toLocaleDateString(undefined, options);
		return this.formattedDate; 
	}
	// Handles the change event when the user selects a new month in the category dropdown.
	handleCategoryChange(event){
		this.dateWithAllery = [];
		this.remainingItems = [];
		this.selectedMonthValue = event.target.value;
		const currentDate = new Date();
		const selectedMonthIndex = new Date(Date.parse(this.selectedMonthValue + twothousand)).getMonth();
		if(selectedMonthIndex <= currentDate.getMonth()){
			const firstDate = new Date(currentDate.getFullYear(), selectedMonthIndex, 1, 18, 30, 0);
			const lastDate = new Date(currentDate.getFullYear(), selectedMonthIndex + 1, 0, 18, 30, 0);
			this.getsymptomdatewithallergy(this.enrolleId, firstDate.toISOString(), lastDate.toISOString());
		}else{
			const firstDate = new Date(currentDate.getFullYear() - 1, selectedMonthIndex, 1, 18, 30, 0);
			const lastDate = new Date(currentDate.getFullYear() - 1, selectedMonthIndex + 1, 0, 18, 30, 0);
			this.getsymptomdatewithallergy(this.enrolleId, firstDate.toISOString(), lastDate.toISOString());
		}
	}
	//Handles errors by displaying a toast message.
	getsymptomdatewithallergy(erolles, firstDate, lastDate){       
		try {
			fetchSymptomErolle({ erolleId: erolles, firstDate: firstDate, lastDate: lastDate })
			// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => {
					//If the result is not null, iterates through each item in the result array.
					if(result != null){
						result.forEach(item => {
						//Checks if there is an existing date entry in the dateWithAllery array matching the date of the current item.
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
						if(this.dateWithAllery.length > 7){
							this.rightLess = true;
						}else{
							this.rightLess = false;
						}
						this.dateWithAlleryall = this.dateWithAllery;
						this.dateWithAllery = this.dateWithAlleryall.slice(0, 7);
						//If there are entries in the dateWithAllery array after slicing, assigns a subset of the entries to the dateWithAllerytwo property.
						if(this.dateWithAllery.length > 0){
							this.dateWithAllerytwo = this.dateWithAlleryall.slice(7, 14);
							if(this.dateWithAllerytwo.length > 0){
								this.nextSeven = true;
							}else{
								this.nextSeven = false;
							}
						}
						//If there are entries in the dateWithAllery array after slicing, assigns a subset of the entries to the dateWithAllerythree property.
						if(this.dateWithAllery.length > 0){
							this.dateWithAllerythree = this.dateWithAlleryall.slice(14, 21);
							if(this.dateWithAllerythree.length > 0){
								this.nextSeven1 = true;
							}else{
								this.nextSeven1 = false;
							}
						}
						//If there are entries in the dateWithAllery array after slicing, assigns a subset of the entries to the dateWithAlleryfour property.
						if(this.dateWithAllery.length > 0){
							this.dateWithAlleryfour = this.dateWithAlleryall.slice(21, 28);
							if(this.dateWithAlleryfour.length > 0){
								this.nextSeven2 = true;
							}else{
								this.nextSeven2 = false;
							}
						}
						//If there are entries in the dateWithAllery array after slicing, assigns a subset of the entries to the dateWithAlleryfive property.
						if(this.dateWithAllery.length > 0){
							this.dateWithAlleryfive = this.dateWithAlleryall.slice(28, 35);
							if(this.dateWithAlleryfive.length > 0){
								this.nextSeven3 = true;
							}else{
								this.nextSeven3 = false;
							}
						}
						//If there are entries in the dateWithAllery array, sets the showLine property to true to display a line chart.
						try {
							if (this.dateWithAllery.length > 0) {
								this.showLine = true;
								setTimeout(() => {
									this.myFunction();
								}, 2000);
							} else {
								this.showLine = false;
							}
						} catch (error) {
							this.showToast(errormessage, error.message, errorvariant);
							// Handle the error as needed
						}
						
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);
				});
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
		
	}
	//This function is typically called to allow users to print the content of the page.
	myFunction(){
		window.print();
	}
	//The image URL corresponding to the symptom name.
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
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}