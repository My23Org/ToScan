//This component is used to Display Tasks based on the Action notification on clicking the Notification icon from the Dashboard.
//To Import the Libraries
import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To Import the User Id
import Id from '@salesforce/user/Id';
//To import the Static resources
import notifyimg from '@salesforce/resourceUrl/BI_PSPB_ArticleImg';
import notifychalimg from '@salesforce/resourceUrl/BI_PSPB_NotificationChallengesImg';
import notifysymimg from '@salesforce/resourceUrl/BI_PSPB_SymptomImg';
import questionnaireimage from '@salesforce/resourceUrl/BI_PSP_Questionnaireimg';
import notifytreatimg from '@salesforce/resourceUrl/BI_PSPB_ArticleImg';
import deletetoastimage from '@salesforce/resourceUrl/BI_PSP_Deletetoastmsg';
//To import the Apex class
import actiontask from '@salesforce/apex/BI_PSPB_InsiteNotification.getTaskRecordAction';
import actiontaskUA from '@salesforce/apex/BI_PSPB_NotificationTaskRecordUA.getTaskRecordAction';
import taskupdate from '@salesforce/apex/BI_PSPB_symptomTrackerTasksCtrl.markTaskCompleted';
import updatePicklistValue from '@salesforce/apex/BI_PSPB_TreatmentReminder.updatePicklist';
import getDateOfTreatment from '@salesforce/apex/BI_PSPB_TreatmentReminder.getDateOfTreatment';
import createTreatmentReminders from '@salesforce/apex/BI_PSPB_TreatmentReminder.createTreatmentReminders';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import tasktime from '@salesforce/apex/BI_PSPB_InsiteNotification.timeFrame';
//To import The custom labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedUrl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import BI_PSPB_Treatment from '@salesforce/label/c.BI_PSPB_Treatment';
import BI_PSPB_Prescription from '@salesforce/label/c.BI_PSPB_Prescription';
import BI_PSPB_Prescription_reminder from '@salesforce/label/c.BI_PSPB_Prescription_reminder';
import BI_PSPB_TreatmentReminder from '@salesforce/label/c.BI_PSPB_TreatmentReminder';
import BI_PSPB_My_Questionnaires from '@salesforce/label/c.BI_PSPB_My_Questionnaires';
import symptom from '@salesforce/label/c.BI_PSP_symptomtracker';
import BI_PSPB_Action_required from '@salesforce/label/c.BI_PSPB_Action_required';
import BI_PSPB_Date_of_Treatment from '@salesforce/label/c.BI_PSPB_Date_of_Treatment';
import BI_PSPB_Past_Due_Date from '@salesforce/label/c.BI_PSPB_Past_Due_Date';
import 	BI_PSPB_Past_Due_Date_Two from '@salesforce/label/c.BI_PSPB_Past_Due_Date_Two';
import 	BI_PSPB_DayOfTreatment from '@salesforce/label/c.BI_PSPB_DayOfTreatment';
import 	BI_PSPB_72hr from '@salesforce/label/c.BI_PSPB_72hr';
import 	BI_PSPB_24hr from '@salesforce/label/c.BI_PSPB_24hr';
import BI_PSPB_SymptomTrackerMain from '@salesforce/label/c.BI_PSPB_SymptomTrackerMain';
import BI_PSPB_BROutstandingQuestionnaireUrl from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
export default class biPspNotificationActionForm extends LightningElement {
//Proper naming conventions with camel case for all the variable will be followed in the future releases
// Declaration of variables with @api
@api messageFromParent = '';
// Declaration of variables with @track
@track selectedWhatid;
@track taskselectedId;
@track showdeletetoastmsg = false;
@track selectedTask = ' ';
@track minDate;
@track maxDate;
@track selectedTaskCreatedDate;
@track TreatmentDate;
@track showModal = false;
@track norecords = false;
@track userId = Id;
@track accname;
@track hrsdisplay = false;
@track differentclass;
@track Actiontask = [];
@track displayCount = 3;
@track showLoadMoreButton = true;
@track hrsvalue;
@track selectedDate;
@track showdeletetoastdate = false;
@track responsevalue;
@track actioncategory;
@track actionvalue;
@track yesbut = false;
@track nobut = false;
@track submitbut = false;
@track SymptomtaskId;
// Declaration of variables
contentimg = notifyimg;
symptomimg = notifysymimg;
challengeimg = notifychalimg;
treatmentimg = notifytreatimg;
Questimg = questionnaireimage;
deletetoast = deletetoastimage; 
hoursOptions = [{ label: BI_PSPB_24hr, value: BI_PSPB_24hr }, { label: BI_PSPB_72hr, value: BI_PSPB_72hr }];
constructor() {
	super();
	this.statusMap = new Map();
}

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
						this.accname = result[0].patientEnrolle.Id;
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
							this.urlq = brandedUrl;
							this.actionOptions = [{ label: BI_PSPB_TreatmentReminder, value: BI_PSPB_TreatmentReminder }, { label: symptom, value: symptom }, { label: BI_PSPB_My_Questionnaires, value: BI_PSPB_My_Questionnaires }, { label: BI_PSPB_Prescription_reminder, value: BI_PSPB_Prescription_reminder }];
							this.hrsdisplay = true;
							this.getbrandedaction(this.accname);
						}
						else 
						{
							this.urlq = unassignedUrl;
							this.actionOptions = [{ label: symptom, value: symptom }, { label: BI_PSPB_My_Questionnaires, value: BI_PSPB_My_Questionnaires }];
							this.hrsdisplay = false;
							this.getUnassignedaction(this.accname);
						}
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
			})
	}
	catch (err) 
	{
		this.showToast(errormessage, err.message, errorvariant);
	}
}

//To fetch the Treatment Records
@wire(getDateOfTreatment, { accountId: '$accname' })
wiredgetDateOfTreatment({ data, error }) 
{   
		if (data) 
		// Null data is checked and AuraHandledException is thrown from the Apex
		{
			try 
			{
				this.TreatmentDate = data;
			} 
			catch (err) 
			{
				this.showToast(errormessage, err.message, errorvariant);
			// Handle the error as per your requirement
			}
			// Load cases once accname is available
		} 
		else if (error) 
		{
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	
}

//To fetch the Branded Action Notification
getbrandedaction(acc) 
{
	try 
	{
		actiontask({ enroleeId: acc, notificatonType: BI_PSPB_Action_required })
			.then(result => 
			{
				console.log('dtaa',result)
				// Null data is checked and AuraHandledException is thrown from the Apex
				if (result) 
				{
					if (result && result.length > 3) 
					{
						// this.norecords=false;
						this.showLoadMoreButton = true;
					} 
					else 
					{
						// this.norecords=true;
						this.showLoadMoreButton = false;
					}
					if (result && result.length > 0) 
					{
						this.norecords = false;
					} 
					else 
					{
						this.norecords = true;
					}
					this.Actiontask = result.map(obj => ({
						...obj,
						submitbutton: obj.BI_PSP_Category__c === symptom,
						Startbutton: obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
						QuestionImg: obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
						sympimg: obj.BI_PSP_Category__c === symptom,
						treatimg: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
						yesbutton: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
						nobutton: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
						voilet: obj.BI_PSP_Category__c === symptom || obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
						green: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_DayOfTreatment,
						amber: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date,
						red: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date_Two,
						FormattedDate: this.formatDate(obj.CreatedDate)
					}));
				}
			})
			.catch(errors=>
			{
				this.showToast(errormessage, errors.message, errorvariant);
			})
	} 
	catch (err) 
	{
		this.showToast(errormessage, err.message, errorvariant);
		// Handle the error as per your requirement
	}
}

//To fetch the Unassigned Action Notification
getUnassignedaction(acc) 
{
	try 
	{
		actiontaskUA({ enroleeId: acc, notificatonType: BI_PSPB_Action_required })
		// Null data is checked and AuraHandledException is thrown from the Apex
			.then(result => 
			{
				if (result) 
				{
					if (result && result.length > 0) 
					{
						// this.norecords=false;
						this.showLoadMoreButton = true;
					} 
					else 
					{
						// this.norecords=true;
						this.showLoadMoreButton = false;
					}
					if (result && result.length > 0) 
					{
						this.norecords = false;
					} 
					else 
					{
						this.norecords = true;
					}

					this.Actiontask = result.map(obj => ({
						...obj,
						submitbutton: obj.BI_PSP_Category__c === symptom,
						Startbutton: obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
						QuestionImg: obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
						sympimg: obj.BI_PSP_Category__c === symptom,
						treatimg: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
						yesbutton: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
						nobutton: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
						voilet: obj.BI_PSP_Category__c === symptom || obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
						green: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_DayOfTreatment,
						amber: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date,
						red: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date_Two,
						FormattedDate: this.formatDate(obj.CreatedDate)
					}));
				}
			})
			.catch(errors=>
			{
				this.showToast(errormessage, errors.message, errorvariant);
			})
	} 
	catch (err) 
	{
		this.showToast(errormessage, err.message, errorvariant);
		// Handle the error as per your requirement
	}
}

// To display recent 3 records, on clicking Load More, shows all the records
get displayedActionValue() 
{
	return this.Actiontask.slice(0, this.displayCount);
}
//This Function is used to load more notification
loadMore() 
{
	this.displayCount = this.Actiontask.length;
	this.showLoadMoreButton = false;
}
//This function is used for onchange in Hours filter
actionhrs(event) 
{
	this.hrsvalue = event.target.value;
	if (this.hrsvalue === BI_PSPB_24hr) 
	{
		this.actionhrsfunc(this.hrsvalue);
	}
	else if (this.hrsvalue === BI_PSPB_72hr) 
	{
		this.actionhrsfunc(this.hrsvalue);
	}
}
//To fetch the hour filter in Action notification records
actionhrsfunc(actionhrsvalue) 
{
	try
	{
		tasktime({ accountId: this.accname, timeFrame: actionhrsvalue })
		// Null data is checked and AuraHandledException is thrown from the Apex
			.then(data => 
			{
				this.Actiontask = data.map(obj => ({
				...obj,
				submitbutton: obj.BI_PSP_Category__c === symptom,
				Startbutton: obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
				QuestionImg: obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
				sympimg: obj.BI_PSP_Category__c === symptom,
				treatimg: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
				yesbutton: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
				nobutton: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
				voilet: obj.BI_PSP_Category__c === symptom || obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
				green: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_DayOfTreatment,
				amber: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date,
				red: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date_Two,
				FormattedDate: this.formatDate(obj.CreatedDate)

				}));
			})
			.catch(errors=>
			{
				this.showToast(errormessage, errors.message, errorvariant);
			})
	} 
	catch (err) 
	{
		this.showToast(errormessage, err.message, errorvariant);
		// Handle the error as per your requirement
	}
}

//This function is used for hide the modal in page
hideModalBox() 
{
	this.showModal = false;
}

handleDateChange(event) 
{
	this.selectedDate = event.target.value;
}

//This function is used to save the date of treatment and create the treatment records
handleSaveDate() 
{
	try 
	{
		const selectedDateObj = new Date();
		selectedDateObj.setDate(selectedDateObj.getDate() + 28); // Adding 28 days
		const newDate = selectedDateObj.toISOString();
		// Call the Apex method to create treatment reminders based on selected date
		createTreatmentReminders({ accountId: this.accname, dateOfTreatment: newDate })
		// Null data is checked and AuraHandledException is thrown from the Apex
			.then(() => 
			{
				this.showModal = false;
				updatePicklistValue({ recordId: this.taskselectedId, actionValue: this.responsevalue })
				// Null data is checked and AuraHandledException is thrown from the Apex
					.then(() => {
						this.Actiontask = this.Actiontask.filter(comment => comment.Id !== this.taskselectedId);
						// Perform any additional actions after the picklist update if needed
					})
					.catch(error=>
						{
							this.showToast(errormessage, error.message, errorvariant);
						})
				this.showdeletetoastdate = true;
			})
			.catch(errors=>
			{
				this.showToast(errormessage, errors.message, errorvariant);
			})
	} 
	catch (err) 
	{
		this.showToast(errormessage, err.message, errorvariant);
		// Handle the error as per your requirement
	}
}
// To display the Date in the short format
formatDate(createdDate) 
{
	const dateObject = new Date(createdDate);
	const year = dateObject.getFullYear().toString().slice(-2);
	const options = { day: 'numeric', month: 'short' };
	const formattedDate = dateObject.toLocaleDateString('en-us', options);
	return `${formattedDate}, ${year}`;
}
//
handleDateDay(taskId, resvalue) 
{
	try 
	{
		const today = new Date();
		today.setDate(today.getDate() + 28); // Adding 28 days
		const newDate = today.toISOString(); // Convert back to ISO string
		// Call the Apex method to create treatment reminders based on the calculated date
		createTreatmentReminders({ accountId: this.accname, dateOfTreatment: newDate })
			.then(() => 
			{
				updatePicklistValue({ recordId: taskId, actionValue: resvalue })
					.then(() => 
					{
						this.Actiontask = this.Actiontask.filter(comment => comment.Id !== taskId);
						// Perform any additional actions after the picklist update if needed
					})
					this.showdeletetoastdate = true;
					// To automatically close the custom Toast message, a delay is introduced
					try{
						setTimeout(() => {
							this.showdeletetoastdate = false;
						}, 5000);
					}
					catch (errs) 
					{
						this.showToast(errormessage, errs.message, errorvariant);
						// Handle the error as per your requirement
					}

			})
			.catch(errors=>
			{
				this.showToast(errormessage, errors.message, errorvariant);
			})
	} 
	catch (err) 
	{
		this.showToast(errormessage, err.message, errorvariant);
		// Handle the error as per your requirement
	}
}

//This function is used for close the popup
closetoastmsg() 
{
	this.showdeletetoastmsg = false;
}
//This function is used for close the date popup
closetoastmsgdate() 
{
	this.showdeletetoastdate = false;
}
//This function is used for Submit the date of treatment
handleComplete(event) 
{
	try 
	{
		const actionId = event.target.dataset.id;
		const actionValue = event.target.dataset.actionValue;
		const selectedTask = this.Actiontask.find(allactiontask => allactiontask.Id === actionId);

		if (selectedTask) 
		{
			const selectedTaskCreatedDate = selectedTask.CreatedDate.split('T')[0];
			this.selectedWhatid = selectedTask.WhatId;
			const selectedTreatment = this.TreatmentDate.find(item => item.Id === this.selectedWhatid);
			if (selectedTreatment) 
			{
				this.minDate = selectedTreatment.BI_PSPB_Date_of_Treatment__c;
			}
			this.maxDate = selectedTaskCreatedDate;
			if (selectedTask.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment && (selectedTask.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date || selectedTask.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date_Two)) 
			{
				this.showModal = true;
				this.taskselectedId = selectedTask.Id;
				this.responsevalue = actionValue;
			} 
			else if (selectedTask.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment && selectedTask.BI_PSPB_Treatment_Type__c === BI_PSPB_DayOfTreatment) 
			{
				this.taskselectedId = selectedTask.Id;
				this.responsevalue = actionValue;
				this.handleDateDay(this.taskselectedId, this.responsevalue);
			} 
			else if (selectedTask.BI_PSP_Category__c === BI_PSPB_Treatment || selectedTask.BI_PSP_Category__c === BI_PSPB_Prescription) 
			{

				this.showdeletetoastmsg = true;
				// To automatically close the custom Toast message, a delay is introduced
				try{
					setTimeout(() => {
						this.showdeletetoastmsg = false;
					}, 5000);
				}
				catch (errs) 
				{
					this.showToast(errormessage, errs.message, errorvariant);
					// Handle the error as per your requirement
				}
				updatePicklistValue({ recordId: selectedTask.Id, actionValue: actionValue })
					.then(() => 
					{
						this.Actiontask = this.Actiontask.filter(comment => comment.Id !== selectedTask.Id);
						// Perform any additional actions after the picklist update if needed
					})
					.catch(errors=>
					{
						this.showToast(errormessage, errors.message, errorvariant);
					})
			}
		}
	}
	catch (err) 
	{
		this.showToast(errormessage, err.message, errorvariant);
		// Handle the error as per your requirement
	}
}
//To get the onchange value in category type
actioncat(event) 
{
	this.actioncategory = event.target.value

	if (this.actioncategory === symptom) 
	{
		this.actionfunc(symptom);

	}
	if (this.actioncategory === BI_PSPB_TreatmentReminder) 
	{
		this.actionfunc(BI_PSPB_Treatment);
	}
	if (this.actioncategory === BI_PSPB_Prescription_reminder) 
	{
		this.actionfunc(BI_PSPB_Prescription);
	}
	if (this.actioncategory === BI_PSPB_My_Questionnaires) 
	{
		this.actionfunc(BI_PSPB_My_Questionnaires);
	}
}
//To fetch filter Action Records
actionfunc(cate) 
{
	try 
	{
		actiontask({ enroleeId: this.accname,notificatonType: BI_PSPB_Action_required, category: cate })
			.then(result => 
			{
				if (result && result.length > 3) 
				{
					this.showLoadMoreButton = true;
				} 
				else 
				{
					this.showLoadMoreButton = false;
				}
				if (result && result.length > 0) 
				{
					this.norecords = false;
				} 
				else 
				{
				
					this.norecords = true;
				}
				this.Actiontask = result.map(obj => ({
					...obj,
					submitbutton: obj.BI_PSP_Category__c === symptom,
					Startbutton: obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
					QuestionImg: obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
					sympimg: obj.BI_PSP_Category__c === symptom,
					treatimg: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
					yesbutton: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
					nobutton: obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_Date_of_Treatment,
					voilet: obj.BI_PSP_Category__c === symptom || obj.BI_PSP_Category__c === BI_PSPB_Treatment || obj.BI_PSP_Category__c === BI_PSPB_Prescription || obj.BI_PSP_Category__c === BI_PSPB_My_Questionnaires,
					green: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_DayOfTreatment,
					amber: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date,
					red: obj.BI_PSPB_Treatment_Type__c === BI_PSPB_Past_Due_Date_Two,
					FormattedDate: this.formatDate(obj.CreatedDate)
				}));
			})
			.catch(errors=>
			{
				this.showToast(errormessage, errors.message, errorvariant);
			})
	}
	catch (err) 
	{
		this.showToast(errormessage, err.message, errorvariant);
		// Handle the error as per your requirement
	}
}

//this Function is used for Update the Symptom Action records
updatesymptomcompleted(symptomActiontask) 
{
	try 
	{
		taskupdate({ taskId: symptomActiontask })
	} 
	// Null data is checked and AuraHandledException is thrown from the Apex
	catch (err) 
	{
		this.showToast(errormessage, err.message, errorvariant);
		// Handle the error as per your requirement
	}
}

//Onclick function for symptom reords
clickSymptom(event) 
{
	this.SymptomtaskId = event.target.dataset.id
	this.updatesymptomcompleted(this.SymptomtaskId);
	window.location.assign( this.urlq + BI_PSPB_SymptomTrackerMain);
}
//Onclick function for Questionnaires reords
clickQuestion(event) 
{
	this.SymptomtaskId = event.target.dataset.id
	this.updatesymptomcompleted(this.SymptomtaskId);
	window.location.assign(this.urlq + BI_PSPB_BROutstandingQuestionnaireUrl);

}

	//This ShowToast message is used for get error
	showToast(title, message, variant) 
	{
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}