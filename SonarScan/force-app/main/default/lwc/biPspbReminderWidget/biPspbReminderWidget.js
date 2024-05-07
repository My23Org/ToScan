//A Lightning Web Component displaying treatment timeline reminders for patients with dynamic date calculations and navigation features.
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Static Resources
import alarm from '@salesforce/resourceUrl/BI_PSPB_AlarmImg';
// To import Apex Classes
import getTasksWithDateOfTreatment from '@salesforce/apex/BI_PSPB_TreatmentReminder.getTasksWithDateOfTreatment';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
// To import Custom Labels
import Jan from '@salesforce/label/c.BI_PSPB_Jan';
import Feb from '@salesforce/label/c.BI_PSPB_Feb';
import March from '@salesforce/label/c.BI_PSPB_March';
import April from '@salesforce/label/c.BI_PSPB_April';
import May from '@salesforce/label/c.BI_PSPB_May';
import June from '@salesforce/label/c.BI_PSPB_June';
import July from '@salesforce/label/c.BI_PSPB_July';
import Aug from '@salesforce/label/c.BI_PSPB_Aug';
import Sep from '@salesforce/label/c.BI_PSPB_Sep';
import Oct from '@salesforce/label/c.BI_PSPB_Oct';
import Nov from '@salesforce/label/c.BI_PSPB_Nov';
import Dec from '@salesforce/label/c.BI_PSPB_Dec';
import Dec1 from '@salesforce/label/c.BI_PSPB_Dec1';
import Nov1 from '@salesforce/label/c.BI_PSPB_Nov1';
import Oct1 from '@salesforce/label/c.BI_PSPB_Oct1';
import Sep1 from '@salesforce/label/c.BI_PSPB_Sep1';
import Aug1 from '@salesforce/label/c.BI_PSPB_Aug1';
import Jul1 from '@salesforce/label/c.BI_PSPB_Jul1';
import Jun1 from '@salesforce/label/c.BI_PSPB_Jun1';
import May1 from '@salesforce/label/c.BI_PSPB_May1';
import Apr1 from '@salesforce/label/c.BI_PSPB_Apr1';
import Mar1 from '@salesforce/label/c.BI_PSPB_Mar1';
import Feb1 from '@salesforce/label/c.BI_PSPB_Feb1';
import Jan1 from '@salesforce/label/c.BI_PSPB_Jan1';
import Th from '@salesforce/label/c.BI_PSPB_TH';
import st from '@salesforce/label/c.BI_PSPB_ST';
import Nd from '@salesforce/label/c.BI_PSPB_nd';
import rd from '@salesforce/label/c.BI_PSPB_rd';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import reminderpageurl from '@salesforce/label/c.BI_PSPB_ReminderUrl';
import PrescriptionReminder1 from '@salesforce/label/c.BI_PSPB_Prescription_Reminder_1';
import PrescriptionReminder2 from '@salesforce/label/c.BI_PSPB_Prescription_Reminder_2';
import PrescriptionReminder3 from '@salesforce/label/c.BI_PSPB_Prescription_Reminder_3';
import TreatmentReminder1 from '@salesforce/label/c.BI_PSPB_Treatment_Reminder_1';
import TreatmentReminder2 from '@salesforce/label/c.BI_PSPB_Treatment_Reminder_2';
import NoUpcomingRemainders from '@salesforce/label/c.BI_PSPB_No_Upcoming_Remainders';
import labelus from '@salesforce/label/c.BI_PSPB_EN_US';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class biPspbReminderWidget extends NavigationMixin(LightningElement)
{
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	@track accname;
	@track timelineData = [];
	@track reminderDates = []; // Added reminderDates
	@track isDataAvailable = false;
	@track userId = Id;
	@track cpeId;
	//Variable declaration
	imgalarm = alarm;
	//It determines if there's any treatment data available and if the first treatment date has already passed.
	get isAvailable() {
		if (this.timelineData.length > 0) {
			const treatmentDate = new Date(this.timelineData[0]?.BI_PSPB_Date_of_Treatment__c);
			const currentDate = new Date();
			return !treatmentDate || treatmentDate < currentDate;
		}
		return false;
	}
	// To get the date of treatment of the careprogram enrolle and calculates the day difference
	@wire(getTasksWithDateOfTreatment, { accountId: '$cpeId' })
	wiredTasks({ data, error }) {
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data) {
			try {
				const treatmentDate = new Date(data[0].BI_PSPB_Date_of_Treatment__c);
				const currentDate = new Date();
				const timeDiff = treatmentDate.getTime() - currentDate.getTime();
				const daysDifference = Math.ceil(timeDiff / (1000 * 3600 * 24));
				// Calculate the card title and reminder dates based on days difference
				if (daysDifference > 14) {
					this.cardTitle = PrescriptionReminder1;
					this.reminderDates.push(this.getReminderDate(treatmentDate, 14));
					this.isDataAvailable = true;
				}
				else if (daysDifference > 10) {
					this.cardTitle = PrescriptionReminder2;
					this.reminderDates.push(this.getReminderDate(treatmentDate, 10));
					this.isDataAvailable = true;
				}
				else if (daysDifference > 7) {
					this.cardTitle = PrescriptionReminder3;
					this.reminderDates.push(this.getReminderDate(treatmentDate, 7));
					this.isDataAvailable = true;
				}
				else if (daysDifference > 3) {
					this.cardTitle = TreatmentReminder1;
					this.reminderDates.push(this.getReminderDate(treatmentDate, 3));
					this.isDataAvailable = true;
				}
				else if (daysDifference > 1) {
					this.cardTitle = TreatmentReminder2;
					this.reminderDates.push(this.getReminderDate(treatmentDate, 1));
					this.isDataAvailable = true;
				}
				else {
					this.cardTitle = NoUpcomingRemainders;
					this.reminderDates.push(this.getReminderDate(treatmentDate));
					this.isDataAvailable = false;
				}
				// Map retrieved data to timelineData
				this.timelineData = data.map(Remainder => {
					const daysLeft = this.calculateDaysLeft(Remainder.BI_PSPB_Reminder_Date__c);
					const additionalDates = this.calculateAdditionalDates(Remainder.BI_PSPB_Date_of_Treatment__c);
					return {
						Id: Remainder.Id,
						Subject: Remainder.BI_PSPB_Subject__c,
						Date_of_Treatment__c: Remainder.BI_PSPB_Date_of_Treatment__c,
						DayOfWeek: this.getDayOfWeek(Remainder.BI_PSPB_Date_of_Treatment__c),
						DaysLeft: daysLeft,
						AdditionalDates: additionalDates,
					};
				});
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant);
			}
		}
		else if (error) {
			this.error = error;
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}
	// Connected callback to retrieve additional data when the component is connected to the DOM
	connectedCallback() {
		// Retrieve the enrollment information of the patient
		try {
			getEnrolle({ userId: this.userId })
				// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => {
					if (result != null) {
						if (result[0].patientEnrolle != null) {
							this.cpeId = result[0].patientEnrolle.Id;
						}
						else if (result[0].error != null) {
							this.showError = true;
							this.errorMessage = result[0].error;
						}
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);
				});
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}
	// Rendered callback to perform DOM manipulations after the component is rendered
	renderedCallback() {
		// Iterate over each class name to add CSS classes or manipulate elements
		[Dec, Nov, Oct, Sep, Aug, July, June, May, April, March, Feb, Jan].forEach(className => {
			// Find all elements with the current class name
			const elements = this.template.querySelectorAll('.' + className);
			// Get the last element
			const lastElement = elements[elements.length - 1];
			// Change its background color to red
			if (lastElement) {
				lastElement.classList.add('red-background');
			}
		});
		[Dec1, Nov1, Oct1, Sep1, Aug1, Jul1, Jun1, May1, Apr1, Mar1, Feb1, Jan1].forEach(className => {
			// Find all elements with the current class name
			const elements = this.template.querySelectorAll('.' + className);
			// Get the last element
			const middleElement = elements[0];
			// Change its background color to red
			if (middleElement) {
				middleElement.textContent = className.substring(0, 3);
			}
		});
		['circlebutton'].forEach(className => {
			// Find all elements with the current class name
			const elements = this.template.querySelectorAll('.' + className);
			// Get the last element
			const lastElement = elements[elements.length - 1];
			// Change its background color to red
			if (lastElement) {
				lastElement.classList.add('treatmentDate');
			}
		});
	}
	// To display the Date with the suffix format
	getOrdinalNumber(number) {
		const suffixes = [Th, st, Nd, rd];
		const v = number % 100;
		return number + (suffixes[(v - 20) % 10] || suffixes[v] || suffixes[0]);
	}
	// To calculate the days left
	getReminderDate(treatmentDate, daysBefore) {
		const date = new Date(treatmentDate);
		date.setDate(treatmentDate.getDate() - daysBefore);
		const options = { month: 'short', day: 'numeric', weekday: 'short' };
		return date.toLocaleDateString(labelus, options);
	}
	// To get the day of week
	getDayOfWeek(date) {
		return new Date(date).toLocaleDateString(labelus, { weekday: 'long' });
	}
	// Method to calculate days left until the earliest date
	calculateDaysLeft(earliestDate) {
		const currentDate = new Date();
		// const pacificTime = new Date(today.toLocaleString(labelus, { timeZone: 'America/Los_Angeles' })); // Get PST time
		const treatmentDateTime = new Date(earliestDate); // Get treatment date
		treatmentDateTime.setHours(0, 0, 0, 0);
		currentDate.setHours(0, 0, 0, 0);
		// Calculate the time difference in milliseconds
		const timeDiff = treatmentDateTime.getTime() - currentDate.getTime();
		// Convert milliseconds to days
		const daysLeft = Math.ceil(timeDiff / (1000 * 3600 * 24));
		return daysLeft;
	}
	// Method to retrieve the day of the week from a given date
	// Method to calculate additional reminder dates based on treatment date
	calculateAdditionalDates(treatmentDate) {
		let additionalDates = [];
		const daysBefore = [14, 10, 7, 3, 1, 0];
		const treatmentDateTime = new Date(treatmentDate);
		daysBefore.forEach(days => {
			const date = new Date(treatmentDateTime);
			date.setDate(treatmentDateTime.getDate() - days);
			const month = date.toLocaleDateString(labelus, { month: 'short' });
			const day = date.getDate();
			const ordinalDay = this.getOrdinalNumber(day);
			const formattedDate = `${ordinalDay}`;
			additionalDates.push({ date: formattedDate, month: month, monthname: month + 1 });
		});
		return additionalDates;
	}
	// Method to handle adding a date
	handleAddDate() {
		// Navigate to the reminder page
		window.location.assign(brandedsiteurl + reminderpageurl);
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