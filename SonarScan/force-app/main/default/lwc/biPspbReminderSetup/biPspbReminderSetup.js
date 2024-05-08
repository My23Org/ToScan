//This Lightning web component facilitates setting up reminders and treatment schedules, allowing users to save and manage their healthcare appointments efficiently
// To import Libraries
import { LightningElement, track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import saveReminderDates from '@salesforce/apex/BI_PSPB_TreatmentReminder.createRemainderRecord';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import generateGoogleCalendarURL from '@salesforce/apex/BI_PSPB_ReminderCalendar.generateGoogleCalendarURL';
import generateOutlookCalendarURL from '@salesforce/apex/BI_PSPB_ReminderCalendar.generateOutlookCalendarURL';
import getLoggedInUserAccounts from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserAccount';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Static Resources
import OutcalIcon from '@salesforce/resourceUrl/BI_PSPB_outlookCalendar';
import gcalIcon from '@salesforce/resourceUrl/BI_PSPB_googleCalendar';
import Boxedicon from '@salesforce/resourceUrl/Boxedicon';
import Default_avatar_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Default_Avater_Navigation';
import tic from '@salesforce/resourceUrl/BI_PSP_Deletetoastmsg';
import warning from '@salesforce/resourceUrl/BI_PSPB_WarningIcon';
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
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
export default class BiPspbReminderSetup extends LightningElement 
{
//Proper naming conventions with camel case for all the variable will be followed in the future releases
//@track variable declaration
	@track Doberrormessage;
	@track showDiv = false;
	@track variable = true;
	@track selectedDate;
	@track selectedReminders = [];
	@track selectedTreatment = [];
	@track showMessage = false;
	@track showMessage2 = false;
	@track value = [];
	@track treatValue = [];
	@track formattedReminderDates = [];
	@track accname;
	@track cpeId;
	@track isPartVisible = false;
	@track googleCalendarURLs = [];
	@track outlookCalendarURLs = [];
	@track userId = Id;
	@track Boxedicon = Boxedicon;
	@track value1;
	@track value2;
	@track value3;
	@track treatvalue1;
	@track treatvalue2;
	@track disable14 = false;
	@track disable10 = false;
	@track disable7 = false;
	@track checked14 = false;
	@track checked10 = false;
	@track checked7 = false;
	@track checked3 = false;
	@track checked1 = false;
	@track showAfterSaveContent = true;
	@track caregiver = false;
	@track selectedOption = {
		src: Default_avatar_JPEG_URL,
		name: '',
	};
	//Variable declaration
	userAccounts;
	selectedAvatarSrc;
	rightimg = tic;
	googlecalIcon = gcalIcon;
	outlookCalIcon = OutcalIcon;
	doberrorMessage = false;
	warning = warning;
	name;
	rendered = false;
		// To fetch URLs of Google Calender
		@wire(generateGoogleCalendarURL, { eventDate: '$selectedDate' })
		wiredGoogleCalendarURL({ error, data }) 
		{
			// Null data is checked and AuraHandledException is thrown from the Apex
				if (data)
				{
					try 
					{
					this.googleCalendarURLs = data;				
					}
					catch (err) 
					{
					this.showToast(errormessage, err.message, errorvariant);
					}
				} 
				else if (error) 
				{
					this.showToast(errormessage, error.body.message, errorvariant);
				}
		}
		// To fetch URLs of Outlook Calender
		@wire(generateOutlookCalendarURL, { eventDate: '$selectedDate' })
		wiredOutlookCalendarURL({ error, data }) 
		{	
				if (data) 
				// Null data is checked and AuraHandledException is thrown from the Apex
				{
					try
					{
					this.outlookCalendarURLs = data;
					}
				catch (err) 
					{
					this.showToast(errormessage, err.message, errorvariant);
					}
				}
				else if (error) 
				{
					this.showToast(errormessage, error.body.message, errorvariant);
				}
		}
		// To fetch URL of Avatar image
		@wire(getLoggedInUserAccounts)
		wiredUserAccounts({ error, data }) 
		{
			if (data) 
			// Null data is checked and AuraHandledException is thrown from the Apex
			{
				try 
				{
					this.userAccounts = data;
					console.log('data',data);				
					if (!this.caregiver) 
					{
						this.name = this.userAccounts.length > 0 ? this.userAccounts[0]?.Name : '';
						this.selectedAvatarSrc = this.userAccounts[0]?.BI_PSP_AvatarUrl__c ? this.userAccounts[0]?.BI_PSP_AvatarUrl__c : Default_avatar_JPEG_URL;  	            
					}
				} catch (err) 
				{
					this.showToast(errormessage, err.message, errorvariant);
				}
			}	
			else if (error) 
			{
				this.showToast(errormessage, error.body.message, errorvariant);
			}	
		}
	// To fetch the ID of a Care Program Enrollee
	connectedCallback() 
	{
		try 
		{
			getEnrolle({ userId: this.userId })
			// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => 
					{
					if (result != null) 
					{
						if (result[0].patientEnrolle != null) 
						{
							this.cpeId = result[0].patientEnrolle.Id;
						} 
						else if (result[0].error != null) 
						{
							this.showError = true;
							this.errorMessage = result[0].error;
						}
					}
					})
				.catch(error => 
					{
					this.showToast(errormessage, error.message, errorvariant);
					});
				const today = new Date();
				const futureDate = new Date(today);
				futureDate.setDate(futureDate.getDate() + 7);
				this.minDate = futureDate.toISOString().slice(0, 10);
		} 
		catch (err) 
		{
			this.showToast(errormessage, err.message, errorvariant);
		}			
	}
	// To get the values of the check box enabled
	setCheckboxValues(callback) 
	{
		this.value = [];
		this.treatValue = [];
		if (!this.disable14) 
		{
			this.value.push(14);
		}
		if (!this.disable10) {
			this.value.push(10);
		}
		if (!this.disable7) {
			this.value.push(7);
		}
		if (this.treatvalue1 !== null) {
			this.treatValue.push(this.treatvalue1);
		}
		if (this.treatvalue2 !== null) {
			this.treatValue.push(this.treatvalue2);
		}
		if (callback && typeof callback === 'function') 
		{
			callback();
		}
	}
	// To display the Date with the suffix format
	getOrdinalNumber(number) 
	{
		const suffixes = [Th, st, Nd, rd];
		const v = number % 100;
		return number + (suffixes[(v - 20) % 10] || suffixes[v] || suffixes[0]);
	}
	// To close the modal box
	Xbtn() 
	{
		this.variable = false;
	}
	// To display the short names of the month
	renderedCallback() 
	{
		// Iterate over each class name
		[Dec, Nov, Oct, Sep, Aug, July, June, May, April, March, Feb, Jan].forEach(className => 
			{
			// Find all elements with the current class name
			const elements = this.template.querySelectorAll('.' + className)
			// Get the last element
			const lastElement = elements[elements.length - 1];
			// Change its background color to red
			if (lastElement) 
			{
				lastElement.classList.add('red-background');
			}
			});
		[Dec1, Nov1, Oct1, Sep1, Aug1, Jul1, Jun1, May1, Apr1, Mar1, Feb1, Jan1].forEach(className => 
			{
			// Find all elements with the current class name
			const elements = this.template.querySelectorAll('.' + className);
			// Get the last element
			const middleElement = elements[0];
			// Change its background color to red
			if (middleElement) 
			{
				middleElement.textContent = className.substring(0, 3);
			}
			});
		['circlebutton'].forEach(className => 
			{
			// Find all elements with the current class name
			const elements = this.template.querySelectorAll('.' + className);
			// Get the last element
			const lastElement = elements[elements.length - 1];
			// Change its background color to red
			if (lastElement) 
			{
				lastElement.classList.add('treatmentDate');
			}
			});
	}	
	// Handle change event when date is selected
	handleDateChange(event) 
	{
		this.selectedDate = event.target.value;
		// Calculate difference in days between selected date and current date  
		const currentDate = new Date();
		const selectedDate = new Date(this.selectedDate);
		const differenceInDays = Math.floor((selectedDate - currentDate) / (1000 * 60 * 60 * 24));
		// Update checkbox disable and checked properties based on date difference
		this.disable14 = differenceInDays < 14;
		this.disable10 = differenceInDays < 10;
		this.disable7 = differenceInDays < 7;
		// Set initial values for checkboxes
		this.checked14 = !this.disable14;
		this.checked10 = !this.disable10;
		this.checked7 = !this.disable7;
		this.checked1 = true;
		this.checked3 = true;
		// Manually fire change events for the checkboxes
		// Manually fire change events for checkboxes 14, 10, and 7
		this.dispatchEvent(new CustomEvent('change', { target: { value: true } }));
		this.dispatchEvent(new CustomEvent('change', { target: { value: true } }));
		this.dispatchEvent(new CustomEvent('change', { target: { value: true } }));
		// Call handlers directly for checkboxes 14, 10, and 7
		this.handle14({ target: { checked: true, value: 14 } });
		this.handle10({ target: { checked: true, value: 10 } });
		this.handle7({ target: { checked: true, value: 7 } });
		// Manually fire change events for checkboxes 3 and 1
		this.dispatchEvent(new CustomEvent('change', { target: { value: true } }));
		this.dispatchEvent(new CustomEvent('change', { target: { value: true } }));
		// Call handlers directly for checkboxes 3 and 1
		this.handle3({ target: { checked: true, value: 3 } });
		this.handle1({ target: { checked: true, value: 1 } });
		// Set initial values for checkboxes and trigger checkbox changes
		this.triggerCheckboxChanges();
	}
	//This function toggles checkbox states based on corresponding disable flags.
	triggerCheckboxChanges() 
	{
		this.checked14 = !this.disable14;
		this.checked10 = !this.disable10;
		this.checked7 = !this.disable7;
	}
	// Handle checkbox change for 14 days reminder
	handle14(event) 
	{
		// Update value1 based on checkbox state
		this.value1 = event.target.checked ? parseInt(event.target.value, 10) : null;		
		// Update value array based on checkbox state
		if (event.target.checked) 
		{
			this.value.push(this.value1);
		} 
		else 
		{
			let valueToRemove = 14;
			let index = this.value.findIndex(item => item === valueToRemove);
			if (index > -1) 
			{
				this.value.splice(index, 1);
			}
		}
	}
	// Handle checkbox change for 10 days reminder
	handle10(event) 
	{
		// Update value2 based on checkbox state
		this.value2 = event.target.checked ? parseInt(event.target.value, 10) : null;	
		// Update value array based on checkbox state
		if (event.target.checked) 
		{
			this.value.push(this.value2);
		}
		else 
		{
			let valueToRemove = 10;
			let index = this.value.findIndex(item => item === valueToRemove);
			if (index > -1) 
			{
				this.value.splice(index, 1);
			}
		}
	}
	// Handle checkbox change for 7 days reminder
	handle7(event) 
	{
		// Update value3 based on checkbox state
		this.value3 = event.target.checked ? parseInt(event.target.value, 10) : null;		
		// Update value array based on checkbox state
		if (event.target.checked) 
		{
			this.value.push(this.value3);
		} 
		else 
		{
			let valueToRemove = 7;
			let index = this.value.findIndex(item => item === valueToRemove);
			if (index > -1) 
			{
				this.value.splice(index, 1);
			}
		}
	}
	// Handle checkbox change for 3 days reminder
	handle3(event) 
	{
		// Update treatvalue1 based on checkbox state
		this.treatvalue1 = event.target.checked ? parseInt(event.target.value, 10) : null;
		this.disable3 = this.treatvalue1 === null;		
		// Update treatValue array based on checkbox state
		if (event.target.checked) 
		{
			this.treatValue.push(this.treatvalue1);
		} 
		else 
		{
			let valueToRemove = 3;
			let index = this.treatValue.findIndex(item => item === valueToRemove);
			if (index > -1) 
			{
				this.treatValue.splice(index, 1);
			}
		}
	}
	// Handle checkbox change for 1 day reminder
	handle1(event) 
	{
		// Update treatvalue2 based on checkbox state
		this.treatvalue2 = event.target.checked ? parseInt(event.target.value, 10) : null;
		this.disable1 = this.treatvalue2 === null;
		// Update treatValue array based on checkbox state		
		if (event.target.checked) 
		{
			this.treatValue.push(this.treatvalue2);
		} 
		else 
		{
			let valueToRemove = 1;
			let index = this.treatValue.findIndex(item => item === valueToRemove);
			if (index > -1) 
			{
				this.treatValue.splice(index, 1);
			}
		}
	}
	// Handle success after saving reminders
	handle_Success() 
	{
		// Check if any required fields are not filled
		this.showMessage = !this.selectedDate || this.value.length === 0;
		this.showMessage2 = this.treatValue.length === 0;
		this.showAddToCalendarBtn = true;
		// Log selected reminders and treatments		
		// Update selectedReminders and selectedTreatment arrays
		this.selectedReminders = this.value;
		this.selectedTreatment = this.treatValue;
		// Proceed if all required fields are filled
		const lastnameField = this.template.querySelector('input[data-field="DOB"]');
		if (!lastnameField.value) 
		{
			this.Doberrormessage = true;
			lastnameField.className = 'textInput-err';
			this.template.querySelector('label[data-field="DOB"]').className = 'input-error-label';
		} 
		else 
		{
			this.Doberrormessage = false;
			lastnameField.className = 'textInput';
			this.template.querySelector('label[data-field="DOB"]').className = 'input-label';
		}
		if (!this.showMessage2 && this.selectedDate && this.selectedReminders.length > 0) 
		{
			let allReminderDates = [];
			// Iterate over selectedReminders and selectedTreatment arrays
			this.value.concat(this.treatValue).forEach((days, index) => 
			{
				const selectedDateTime = new Date(this.selectedDate).getTime();
				const reminderDateTime = selectedDateTime - days * 24 * 60 * 60 * 1000;
				const reminderDate = new Date(reminderDateTime);
				// Format reminder date
				const formattedDate = this.formatDate(reminderDate);
				// Push formatted reminder date into allReminderDates array
				allReminderDates.push(
					{
					id: index,
					days: days,
					formattedDate,
					});
			});
			// Add next three days' reminders to allReminderDates
			for (let i = 1; i <= 3; i++) 
			{
				const selectedDateTime = new Date(this.selectedDate).getTime();
				const nextDate = new Date(selectedDateTime + i * 24 * 60 * 60 * 1000);
				// Format next date
				const formattedDate = this.formatDate(nextDate);
				allReminderDates.push(
					{
					id: `nextThreeDays-${i}`,
					formattedDate,
					});
			}
			// Add selectedDate reminder to allReminderDates
			const selectedDateFormatted = this.formatDate(new Date(this.selectedDate));
			allReminderDates.push(
				{
				id: 'selectedDate',
				days: 0,
				formattedDate: selectedDateFormatted,
				});
			// Sort allReminderDates by date
			allReminderDates.sort((a, b) => 
			{
				const dateA = new Date(a.formattedDate);
				const dateB = new Date(b.formattedDate);
				return dateA.getTime() - dateB.getTime();
			});
			// Update formattedReminderDates with filtered reminder dates
			this.formattedReminderDates = allReminderDates.filter(date => date.days !== undefined);
		}
		this.saveTaskRecords(); // Save task records
		this.showAfterSaveContent = false;
	}
	// Function to format date
	formatDate(date) 
	{
		const options = { day: 'numeric', month: 'short' };
		return date.toLocaleDateString(undefined, options);
	}
	// Save task records to Salesforce
	saveTaskRecords() 
	{
		const accountId = this.cpeId;	
		const selectedDate = this.selectedDate;
		const selectedReminders = this.selectedReminders;		
		const selectedTreatment = this.selectedTreatment;
		// Call Apex method to save reminder records
		saveReminderDates({ accountId, selectedDate, selectedReminders, selectedTreatment })
		// Null data is checked and AuraHandledException is thrown from the Apex
		.then(() => 
		{
			// Successful save
			this.showDiv = true;
			this.showAfterSaveContent = false;	
			// A delay is introduced to improve the user experience
			setTimeout(() => 
			{
				try 
				{
					this.showDiv = false;
				} catch (setTimeoutError) 
				{
					this.showToast(errormessage, setTimeoutError.message, errorvariant);
				}
			}, 3000);			
			}) .catch(error => 
			{
			// Error handling
			this.showToast(errormessage,error.message, errorvariant);
		});		
	}
	// Handler for clicking the 'Add to Calendar' button
	handleAddCalendarButtonClick() 
	{
		// Set the visibility of the calendar modal to true
		this.isPartVisible = true;
	}
	// Handler to close the calendar modal
	closeModal() 
	{
		this.isPartVisible = false;
	}
	// Open Google Calendar for adding reminders
	openGoogleCalendar() 
	{
		// Check if Google Calendar URLs are available
		if (this.googleCalendarURLs && this.googleCalendarURLs.length > 0) 
		{
			// Open each Google Calendar URL in a new tab
			for (let i = 0; i < this.googleCalendarURLs.length; i++) 
			{
				window.open(this.googleCalendarURLs[i], '_blank');
			}
		}
	}
	// Open Outlook Calendar for adding reminders
	openOutlookCalendar() 
	{
		// Check if Outlook Calendar URLs are available
		if (this.outlookCalendarURLs && this.outlookCalendarURLs.length > 0) 
		{
			// Open each Outlook Calendar URL in a new tab
			for (let i = 0; i < this.outlookCalendarURLs.length; i++) 
			{
				window.open(this.outlookCalendarURLs[i], '_blank');
			}
		}
	}
	showToast(title, message, variant) 
	{
		const event = new ShowToastEvent(
			{
			title: title,
			message: message,
			variant: variant
			});
		this.dispatchEvent(event);
	}
}