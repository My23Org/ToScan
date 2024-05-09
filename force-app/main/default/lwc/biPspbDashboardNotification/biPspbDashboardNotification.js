//This Lightning Web Component retrieves and displays notification messages for patients from various sources within a Salesforce community.
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getEvents from '@salesforce/apex/BI_PSPB_TreatmentReminder.getEvents';
import createTaskIfNoAssessment from '@salesforce/apex/BI_PSPB_TreatmentReminder.createTaskIfNoAssessment';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Static Resources
import notifycomimg from '@salesforce/resourceUrl/BI_PSP_CommunityLogo';
import injectionimage from '@salesforce/resourceUrl/BI_PSP_InjectionImg';
import challengesimage from '@salesforce/resourceUrl/BI_PSPB_ChallengesImg';
import questionnaireimage from '@salesforce/resourceUrl/BI_PSP_Questionnaireimg';
import treatmentimage from '@salesforce/resourceUrl/BI_PSP_TreatmentRimg';
import symptomsimage from '@salesforce/resourceUrl/BI_PSP_SymtomsImg';
import newcontentimage from '@salesforce/resourceUrl/BI_PSP_newcontentimg';
import alarm from '@salesforce/resourceUrl/BI_PSP_Alarm';
import newimg from '@salesforce/resourceUrl/BI_PSP_New';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import outstandingurl from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import messagecenterurl from '@salesforce/label/c.BI_PSPB_messagecenterUrl';
import infocenterpageurl from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
import challengesurl from '@salesforce/label/c.BI_PSP_challengesURL';
import symptomurl from '@salesforce/label/c.BI_PSP_symptomTrackerLpUrl';
import symptom from '@salesforce/label/c.BI_PSP_symptomtracker';
import challenges from '@salesforce/label/c.BI_PSP_challenges';
import questionaire from '@salesforce/label/c.BI_PSPB_My_Questionnaires';
import newcontent from '@salesforce/label/c.BI_PSP_NotificationNewContent';
import general from '@salesforce/label/c.BI_PSPB_General';
import action from '@salesforce/label/c.BI_PSPB_Action';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class Notifications extends NavigationMixin(LightningElement) 
{
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//@track variable declaration
	@track accname;
	@track userId = Id;
	@track tasks = []; // Initialize tasks as an empty array
	@track contactIds;
	@track selectedTask = ' ';
	@track cpeId;
	//Variable declaration
	showModal = false;
	Alarm = alarm;
	New = newimg;
	comunityimg = notifycomimg;
	// Constructor to initialize variables
	constructor() 
	{
		super();
		this.statusMap = new Map();
	}
	// Image URLs
	treatimageurl = treatmentimage;
	injectionurl = injectionimage;
	challengeurl = challengesimage;
	questionaireurl = questionnaireimage;
	symtomurl = symptomsimage;
	newcontenturl = newcontentimage;
	timeElapsedMap = {}; // Map to store time elapsed for each task 
	// To return icons relatedd to the task
	get taskIcons() 
	{
		return this.tasks.map(task => (
			{
			taskId: task.Id,
			iconUrl: this.getTaskIcon(task)
			}));
	}
	// Method to calculate time elapsed for tasks
	get timeElapsedForTasks() 
	{
		if (Object.keys(this.timeElapsedMap).length === 0) 
		{
			this.calculateTimeElapsed();
		}
		return this.tasks.map(task => (
			{
			...task,
			timeElapsed: this.timeElapsedMap[task.Id] || 'Not calculated yet'
			}));
	}
	// Wire method to fetch events 
	@wire(getEvents, { accountId: '$cpeId' })
	wiredEvents({ error, data }) 
	{
		// Null data is checked and AuraHandledException is thrown from the Apex
		if (data) 
		{
			try 
			{
				this.tasks = data.map(task => 
					{
					return {
						Id: task.Id,
						Subject: task.Subject,
						CreatedDate: task.CreatedDate,
						BI_PSP_Category__c: task.BI_PSP_Category__c,
						BI_PSP_Notification_Type__c: task.BI_PSP_Notification_Type__c,
						showActionButton: task.BI_PSP_Notification_Type__c === action && !(task.BI_PSP_Category__c === questionaire && task.BI_PSP_Notification_Type__c === action),
						showGeneralMessage: task.BI_PSP_Notification_Type__c === general,
						showQuestion: task.BI_PSP_Category__c === questionaire && task.BI_PSP_Notification_Type__c === action,
						iconUrl: this.getTaskIcon(task)
							};
					});
				this.calculateTimeElapsed();
				if (this.tasks.length > 0) 
				{
					this.tasks.forEach(task => 
						{
						if (task.Notification_Type__c === general) 
						{
							task.showGeneralMessage = true;
						}
						});
				}
			} 
			catch (ex) 
			{
				this.showToast(errormessage, ex.message, errorvariant);
			}
		} 
		else if (error) 
		{
			this.showToast(errormessage, error.body.message, errorvariant);
		}		
	}
	// Fetch user's enrollment information
	connectedCallback() 
	{
		try 
		{
			//this.createTaskIfNoAssessment();
			getEnrolle({ userId: this.userId })
			// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result => 
					{
					if (result != null) 
					{
						if (result[0].patientEnrolle != null) 
						{
							this.cpeId = result[0].patientEnrolle.Id;
							this.createTaskIfNoAssessment(this.cpeId);						
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
			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) 
			{
				this.urlq = brandedUrlNavi;
			}
			else 
			{
				this.urlq = unAssignedUrlNavi;
			}
		} catch (error) 
		{
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	// If there is no assement records for this CPE new task for questionaries
	createTaskIfNoAssessment() 
	{
		// Null data is checked and AuraHandledException is thrown from the Apex
		try
		{
		createTaskIfNoAssessment({ enrolleeId: this.cpeId }); // Pass the CareProgramEnrollee Id
		}
		catch(error)
		{
			this.showToast(errormessage, error.message, errorvariant);
			// Optionally, you can handle the error if needed
		}
	} 
	// Method to get task icons
	// Method to get task icon based on category
	getTaskIcon(task) 
	{
		switch (task.BI_PSP_Category__c) 
		{
			case 'Challenges':
				return this.challengeurl;
			case 'Symptom Tracker':
				return this.symtomurl;
			case 'Injection Demonstration':
				return this.injectionurl;
			case 'My Questionnaires':
				return this.questionaireurl;
			case 'New Content Updates':
				return this.newcontenturl;
			case 'Prescription':
			case 'Treatment':
			case 'Date of Treatment':
				return this.treatimageurl;
			case 'Community':
				return this.comunityimg;
			// Add other cases for different categories as needed
			default:
				return null; // Return a default image or null if no match is found
		}
	}
	// Method to calculate time elapsed for each task
	calculateTimeElapsed() 
	{
		if (this.tasks.length > 0) 
		{
			this.tasks.forEach(task => 
				{
				const createdDate = new Date(task.CreatedDate);
				const currentTime = new Date();
				const timeDifference = currentTime.getTime() - createdDate.getTime();
				const hoursElapsed = Math.floor(timeDifference / (1000 * 60 * 60));
				const minutesElapsed = Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60));
				if (hoursElapsed >= 24) 
				{
					const daysElapsed = Math.floor(hoursElapsed / 24);
					const remainingHours = hoursElapsed % 24;
					this.timeElapsedMap[task.Id] = `${daysElapsed} days ${remainingHours} hrs ${minutesElapsed} mins ago`;
				} 
				else 
				{
					this.timeElapsedMap[task.Id] = `${hoursElapsed} hrs ${minutesElapsed} mins ago`;
				}
			});
		}
	}
	// Method to handle action response
	handleActionResponse() 
	{
		window.location.assign(this.urlq + messagecenterurl);
	}
	// Method to navigate to the message center
	handleNavigateAll() 
	{
		window.location.assign(this.urlq + messagecenterurl);
	}
	// Method to navigate to specific pages based on task category
	handleNavigate(event) 
	{
		const taskId = event.currentTarget.dataset.id;
		const selectedTask = this.tasks.find(task => task.Id === taskId);
		if (selectedTask) 
		{
			if (selectedTask.BI_PSP_Category__c === symptom) 
			{
				window.location.assign(this.urlq + symptomurl);
			} 
			else if (selectedTask.BI_PSP_Category__c === challenges) 
			{
				window.location.assign(this.urlq + challengesurl);
			} 
			else if (selectedTask.BI_PSP_Category__c === questionaire) 
			{
				window.location.assign(this.urlq + outstandingurl);
			} 
			else if (selectedTask.BI_PSP_Category__c === newcontent) 
			{
				window.location.assign(this.urlq + infocenterpageurl);
			} 
			else if (selectedTask.BI_PSP_Notification_Type__c === general) 
			{
				window.location.assign(this.urlq + messagecenterurl);
			}
		} 
		else 
		{
			window.location.assign(this.urlq + messagecenterurl);
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