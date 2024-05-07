//This component is used to Display the Read,Complete,Expired notification based on  both General and Action Notification
//To import the Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import the User id
import Id from '@salesforce/user/Id';
//To import the Static resources
import notifyimg from '@salesforce/resourceUrl/BI_PSPB_ArticleImg';
import dotimg from '@salesforce/resourceUrl/BI_PSPB_Dotimg';
import notifychalimg from '@salesforce/resourceUrl/BI_PSPB_NotificationChallengesImg';
import notifysymimg from '@salesforce/resourceUrl/BI_PSPB_SymptomImg';
import notifyavatarimg from '@salesforce/resourceUrl/BI_PSPB_SymptomImg';
import notifytreatimg from '@salesforce/resourceUrl/BI_PSPB_ArticleImg';
import notifycomimg from '@salesforce/resourceUrl/BI_PSP_CommunityLogo';
//To import the Apex class
import historytask from '@salesforce/apex/BI_PSPB_InsiteNotification.getTaskHistory';
import historytaskUnassigned from '@salesforce/apex/BI_PSPB_NotificationTaskRecordUA.getTaskHistory';
import historyCat from '@salesforce/apex/BI_PSPB_InsiteNotification.getTaskRecordHistoryCategory';
import historystat from '@salesforce/apex/BI_PSPB_InsiteNotification.getTaskRecordHistoryStatus';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
//To import the Custom labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedUrl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import symptom from '@salesforce/label/c.BI_PSP_symptomtracker';
import newcontent from '@salesforce/label/c.BI_PSP_NotificationNewContent';
import challenges from '@salesforce/label/c.BI_PSP_challenges';
import community from '@salesforce/label/c.BI_PSPB_Community';
import notCompleted from '@salesforce/label/c.BI_PSPB_Not_Completed';
import BI_PSP_Completed from '@salesforce/label/c.BI_PSP_Completed';
import BI_PSPB_History from '@salesforce/label/c.BI_PSPB_History';
import BI_PSPB_My_Questionnaires from '@salesforce/label/c.BI_PSPB_My_Questionnaires';
import BI_PSP_AssessmentStatus_Expired from '@salesforce/label/c.BI_PSP_Expired';
import BI_PSP_General_Notification from '@salesforce/label/c.BI_PSPB_General_Notification';
import BI_PSPB_General from '@salesforce/label/c.BI_PSPB_General';
import BI_PSPB_Action_required from '@salesforce/label/c.BI_PSPB_Action_required';
import BI_PSPB_Action from '@salesforce/label/c.BI_PSPB_Action';
import BI_PSPB_Read from '@salesforce/label/c.BI_PSPB_Read';
import BI_PSPB_Treatment from '@salesforce/label/c.BI_PSPB_Treatment';
import BI_PSPB_Prescription from '@salesforce/label/c.BI_PSPB_Prescription';
import BI_PSPB_Prescription_reminder from '@salesforce/label/c.BI_PSPB_Prescription_reminder';
import BI_PSPB_TreatmentReminder from '@salesforce/label/c.BI_PSPB_TreatmentReminder';
import BI_PSP_Injection_Demonstration from '@salesforce/label/c.BI_PSP_Injection_Demonstration';
export default class biPspNotificationHistoryForm extends LightningElement {
//Proper naming conventions with camel case for all the variable will be followed in the future releases
// Declaration of variables with @track
@track historycatoptions = [];
@track historysoption = [];
@track accname;
@track userId = Id;
@track norecords;
@track historyvalue = [];
@track displayCount = 6;
@track showLoadMoreButton = true;
@track notifyType;
@track categorytype;
// Declaration of variables
contentimg = notifyimg;
dotimg = dotimg;
symptomimg = notifysymimg;
challengeimg = notifychalimg;
treatmentimg = notifytreatimg;
avatarimg = notifyavatarimg;
chatterimg = notifycomimg;
notifyTypeOptions = [
{ label: BI_PSP_General_Notification, value: BI_PSPB_General },
{ label: BI_PSPB_Action_required, value: BI_PSPB_Action }
];
statusoptions = [
{ label: BI_PSP_Completed, value: BI_PSP_Completed },
{ label: notCompleted, value: notCompleted },
{
	label: BI_PSP_AssessmentStatus_Expired,
	value: BI_PSP_AssessmentStatus_Expired
},
{ label: BI_PSPB_Read, value: BI_PSPB_Read }
];

// Initialize accname
connectedCallback() 
{
try 
{
	getEnrolle({ userId: this.userId })
	// Null data is checked and AuraHandledException is thrown from the Apex
	.then((result) => 
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
			const desiredComponent = pathComponents.find((component) =>
			[
				brandedurl.toLowerCase(),
				unassignedurl.toLowerCase()
			].includes(component.toLowerCase())
			);

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) 
			{
			this.urlq = brandedUrl;
			this.historysoption = [
				{ label: challenges, value: challenges },
				{ label: symptom, value: symptom },
				{
				label: BI_PSP_Injection_Demonstration,
				value: BI_PSP_Injection_Demonstration
				},
				{ label: newcontent, value: newcontent },
				{
				label: BI_PSPB_TreatmentReminder,
				value: BI_PSPB_TreatmentReminder
				},
				{
				label: BI_PSPB_My_Questionnaires,
				value: BI_PSPB_My_Questionnaires
				},
				{
				label: BI_PSPB_Prescription_reminder,
				value: BI_PSPB_Prescription_reminder
				},
				{ label: community, value: community }
			];
			this.getbrandedHistory(this.accname);
			} 
			else 
			{
				this.urlq = unassignedUrl;
				this.historysoption = [
					{ label: challenges, value: challenges },
					{ label: symptom, value: symptom },
					{ label: newcontent, value: newcontent },
					{
					label: BI_PSPB_My_Questionnaires,
					value: BI_PSPB_My_Questionnaires
					},
					{ label: community, value: community }
				];
				this.getunassignedHistory(this.accname);
			}
		} 
		else if (result[0].error != null) 
		{
			this.showError = true;
			this.errorMessage = result[0].error;
		}
		}
	})
	.catch((error) => 
	{
		this.showToast(errormessage, error.message, errorvariant);
	});
} 
catch (err) 
{
	this.showToast(errormessage, err.message, errorvariant);
}
}

//To fetch the Branded History notification
getbrandedHistory(acc) 
{
try 
{
	historytask({ enroleeId: acc, notificatonType: BI_PSPB_History })
	// Null data is checked and AuraHandledException is thrown from the Apex
	.then((data) => 
	{
		if (data) 
		{
		if (data && data.length > 6) 
		{
			this.showLoadMoreButton = true;
		} 
		else 
		{
			this.showLoadMoreButton = false;
		}
		if (data && data.length > 0) 
		{
			this.norecords = false;
		} 
		else 
		{
			this.norecords = true;
		}
		this.historyvalue = data.map((obj) => ({
			...obj,
			sympimg: obj.BI_PSP_Category__c === symptom,
			contentsimg: obj.BI_PSP_Category__c === newcontent,
			treatimg:
			obj.BI_PSP_Category__c === BI_PSPB_Treatment ||
			obj.BI_PSP_Category__c === BI_PSPB_Prescription,
			challimg: obj.BI_PSP_Category__c === challenges,
			chatterimg: obj.BI_PSP_Category__c === community,
			FormattedDate: this.formatDate(obj.CreatedDate)
		}));
		} 
	})
	.catch((errors) => 
	{
		this.showToast(errormessage, errors.message, errorvariant);
	});
} 
catch (err) 
{
	this.showToast(errormessage, err.message, errorvariant);
	// Handle the error as per your requirement
}
}

//To fetch the Unassigned History notification
getunassignedHistory(acc) 
{
try 
{
	historytaskUnassigned({
	enroleeId: acc,
	notificatonType: BI_PSPB_History
	})
	// Null data is checked and AuraHandledException is thrown from the Apex
	.then((data) => 
	{
		if (data) 
		{
		if (data && data.length > 6) 
		{
			this.showLoadMoreButton = true;
		} 
		else 
		{
			this.showLoadMoreButton = false;
		}
		if (data && data.length > 0) 
		{
			this.norecords = false;
		} 
		else 
		{
			this.norecords = true;
		}
		this.historyvalue = data.map((obj) => ({
			...obj,
			sympimg: obj.BI_PSP_Category__c === symptom,
			contentsimg: obj.BI_PSP_Category__c === newcontent,
			treatimg:
			obj.BI_PSP_Category__c === BI_PSPB_Treatment ||
			obj.BI_PSP_Category__c === BI_PSPB_Prescription,
			challimg: obj.BI_PSP_Category__c === challenges,
			chatterimg: obj.BI_PSP_Category__c === community,
			FormattedDate: this.formatDate(obj.CreatedDate)
		}));
		}
	})
	.catch((errors) => 
	{
		this.showToast(errormessage, errors.message, errorvariant);
	});
} 
catch (err) 
{
	this.showToast(errormessage, err.message, errorvariant);
	// Handle the error as per your requirement
}
}
// To display recent 3 records, on clicking Load More, shows all the records
get displayedHistoryValue() 
{
return this.historyvalue.slice(0, this.displayCount);
}
//This Function is used to load more notification
loadMore() 
{
this.displayCount = this.historyvalue.length;
this.showLoadMoreButton = false;
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

//To fetch the filter Branded History notification
historyfunc(type) 
{
try 
{
	historytask({ enroleeId: this.accname, notificatonType: type })
	.then((result) => 
	{
		if (result) 
		{
		if (result && result.length > 6) 
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

		this.historyvalue = result.map((obj) => ({
			...obj,
			sympimg: obj.BI_PSP_Category__c === symptom,
			contentsimg: obj.BI_PSP_Category__c === newcontent,
			treatimg:
			obj.BI_PSP_Category__c === BI_PSPB_Treatment ||
			obj.BI_PSP_Category__c === BI_PSPB_Prescription,
			challimg: obj.BI_PSP_Category__c === challenges,
			chatterimg: obj.BI_PSP_Category__c === community,
			FormattedDate: this.formatDate(obj.CreatedDate)
		}));
		}
	})
	.catch((errors) => 
	{
		this.showToast(errormessage, errors.message, errorvariant);
	});
} 
catch (err) 
{
	this.showToast(errormessage, err.message, errorvariant);
	// Handle the error as per your requirement
}
}
//To fetch the filter Unassigned History notification
historyfuncU(type) 
{
try 
{
	historytaskUnassigned({ enroleeId: this.accname, notificatonType: type })
	// Null data is checked and AuraHandledException is thrown from the Apex
	.then((result) => 
	{
		if (result) 
		{
		if (result && result.length > 6)
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

		this.historyvalue = result.map((obj) => ({
			...obj,
			sympimg: obj.BI_PSP_Category__c === symptom,
			contentsimg: obj.BI_PSP_Category__c === newcontent,
			treatimg:
			obj.BI_PSP_Category__c === BI_PSPB_Treatment ||
			obj.BI_PSP_Category__c === BI_PSPB_Prescription,
			challimg: obj.BI_PSP_Category__c === challenges,
			chatterimg: obj.BI_PSP_Category__c === community,
			FormattedDate: this.formatDate(obj.CreatedDate)
		}));
		} 
	})
	.catch((errors) => 
	{
		this.showToast(errormessage, errors.message, errorvariant);
	});
} 
catch (err) 
{
	this.showToast(errormessage, err.message, errorvariant);
	// Handle the error as per your requirement
}
}
//To fetch the History notification filter using Category
historyCatfunc(type, cate) 
{
try 
{
	historyCat({
	enroleeId: this.accname,
	notificatonType: type,
	category: cate
	})
	// Null data is checked and AuraHandledException is thrown from the Apex
	.then((result) => 
	{
		if (result) 
		{
		if (result && result.length > 6) 
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
		this.historyvalue = result.map((obj) => ({
			...obj,
			sympimg: obj.BI_PSP_Category__c === symptom,
			contentsimg: obj.BI_PSP_Category__c === newcontent,
			treatimg:
			obj.BI_PSP_Category__c === BI_PSPB_Treatment ||
			obj.BI_PSP_Category__c === BI_PSPB_Prescription,
			challimg: obj.BI_PSP_Category__c === challenges,
			chatterimg: obj.BI_PSP_Category__c === community,
			FormattedDate: this.formatDate(obj.CreatedDate)
		}));
		} 
	})
	.catch((errors) => 
	{
		this.showToast(errormessage, errors.message, errorvariant);
	});
} 
catch (err) 
{
	this.showToast(errormessage, err.message, errorvariant);
	// Handle the error as per your requirement
}
}
//To fetch the History notification filter using Status
historystatfunc(type, cate, stat) 
{
try 
{
	historystat({
	enroleeId: this.accname,
	notificatonType: type,
	category: cate,
	status: stat
	})
	// Null data is checked and AuraHandledException is thrown from the Apex
	.then((result) => 
	{
		if (result) {
		if (result && result.length > 6) 
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
		this.historyvalue = result.map((obj) => ({
			...obj,
			sympimg: obj.BI_PSP_Category__c === symptom,
			contentsimg: obj.BI_PSP_Category__c === newcontent,
			treatimg:
			obj.BI_PSP_Category__c === BI_PSPB_Treatment ||
			obj.BI_PSP_Category__c === BI_PSPB_Prescription,
			challimg: obj.BI_PSP_Category__c === challenges,
			chatterimg: obj.BI_PSP_Category__c === community,
			FormattedDate: this.formatDate(obj.CreatedDate)
		}));
		}
	})
	.catch((errors) => 
	{
		this.showToast(errormessage, errors.message, errorvariant);
	});
} 
catch (err) 
{
	this.showToast(errormessage, err.message, errorvariant);
	// Handle the error as per your requirement
}
}

//This Function is used for Onchange the notification Type
handletypeChange(event) 
{
this.notifyType = event.target.value;
if (this.notifyType === BI_PSPB_General) 
{
	if (this.categorytype === symptom &&this.notifyType === BI_PSPB_General) 
	{
	if (this.statusvalue === BI_PSPB_Read &&this.categorytype === symptom &&this.notifyType === BI_PSPB_General) 
		{
		this.historystatfunc(BI_PSP_General_Notification,symptom,BI_PSPB_Read);
	} 
	else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === symptom &&this.notifyType === BI_PSPB_General) 
	{
		this.historystatfunc(BI_PSP_General_Notification,symptom,BI_PSP_AssessmentStatus_Expired);
	} 
	else 
	{
		this.historyCatfunc(BI_PSP_General_Notification, symptom);
	}
	} 
	else if (this.categorytype === community &&this.notifyType === BI_PSPB_General) 
	{
	if (this.statusvalue === BI_PSPB_Read &&this.categorytype === community &&this.notifyType === BI_PSPB_General) 
	{
		this.historystatfunc(BI_PSP_General_Notification,community,BI_PSPB_Read);
	} 
	else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === community &&this.notifyType === BI_PSPB_General) 
	{
		this.historystatfunc(BI_PSP_General_Notification,community,BI_PSP_AssessmentStatus_Expired);
	} 
	else 
	{
		this.historyCatfunc(BI_PSP_General_Notification, community);
	}
	} 
	else if 
	(this.categorytype === challenges &&this.notifyType === BI_PSPB_General) 
	{
	if (this.statusvalue === BI_PSPB_Read &&this.categorytype === challenges &&this.notifyType === BI_PSPB_General) 
	{
		this.historystatfunc(BI_PSP_General_Notification,challenges,BI_PSPB_Read);
	} 
	else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === challenges &&this.notifyType === BI_PSPB_General) 
	{
		this.historystatfunc(BI_PSP_General_Notification,challenges,BI_PSP_AssessmentStatus_Expired);
	} 
	else 
	{
		this.historyCatfunc(BI_PSP_General_Notification, challenges);
	}
	}
	else if (this.categorytype === newcontent &&this.notifyType === BI_PSPB_General) 
	{
	if (this.statusvalue === BI_PSPB_Read &&this.categorytype === newcontent &&this.notifyType === BI_PSPB_General) 
	{
		this.historystatfunc(BI_PSP_General_Notification,newcontent,BI_PSPB_Read);
	} 
	else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === newcontent &&this.notifyType === BI_PSPB_General) 
	{
		this.historystatfunc(BI_PSP_General_Notification,newcontent,BI_PSP_AssessmentStatus_Expired );
	} 
	else 
	{
		this.historyCatfunc(BI_PSP_General_Notification, newcontent);
	}
	} 
	else 
	{
	if (this.urlq === brandedUrl) 
	{
		this.historyfunc(BI_PSP_General_Notification, '');
	} 
	else 
	{
		this.historyfuncU(BI_PSP_General_Notification, '');
	}
	}
} 
else if (this.notifyType === BI_PSPB_Action) 
{
	if (this.categorytype === symptom && this.notifyType === BI_PSPB_Action) 
	{
	if (this.statusvalue === BI_PSP_Completed &&this.categorytype === symptom &&this.notifyType === BI_PSPB_Action) 
	{
		this.historystatfunc(BI_PSPB_Action_required,symptom,BI_PSP_Completed);
	} 
	else if (this.statusvalue === notCompleted &&this.categorytype === symptom &&this.notifyType === BI_PSPB_Action) 
	{
		this.historystatfunc(BI_PSPB_Action_required, symptom, notCompleted);
	} 
	else 
	{
		this.historyCatfunc(BI_PSPB_Action_required, symptom);
	}
	} 
	else if ( this.categorytype === BI_PSPB_TreatmentReminder &&this.notifyType === BI_PSPB_Action) 
	{
	if (this.statusvalue === BI_PSP_Completed &&this.categorytype === BI_PSPB_TreatmentReminder &&this.notifyType === BI_PSPB_Action) 
	{
		this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Treatment,BI_PSP_Completed);
	} 
	else if ( this.statusvalue === notCompleted &&this.categorytype === BI_PSPB_TreatmentReminder &&this.notifyType === BI_PSPB_Action) {
		this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Treatment,notCompleted);
	} 
	else 
	{
		this.historyCatfunc(BI_PSPB_Action_required, BI_PSPB_Treatment);
	}
	} 
	else if (this.categorytype === BI_PSPB_Prescription_reminder &&this.notifyType === BI_PSPB_Action) {
	if (this.statusvalue === BI_PSP_Completed &&this.categorytype === BI_PSPB_Prescription_reminder &&this.notifyType === BI_PSPB_Action) 
	{
		this.historystatfunc( BI_PSPB_Action_required, BI_PSPB_Prescription, BI_PSP_Completed);
	} 
	else if (this.statusvalue === notCompleted &&this.categorytype === BI_PSPB_Prescription_reminder &&  this.notifyType === BI_PSPB_Action) 
	{
		this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Prescription,notCompleted);
	} 
	else 
	{
		this.historyCatfunc(BI_PSPB_Action_required, BI_PSPB_Prescription);
	}
	} 
	else 
	{
	if (this.urlq === brandedUrl) 
	{
		this.historyfunc(BI_PSPB_Action_required, '');
	} 
	else 
	{
		this.historyfuncU(BI_PSPB_Action_required, '');
	}
	}
}
}

//This Function is used for Onchange the Category Type
handleCatChange(event) 
{
this.categorytype = event.target.value;
if (this.categorytype === symptom && this.notifyType === BI_PSPB_General) 
{
	if (this.statusvalue === BI_PSPB_Read &&this.categorytype === symptom &&this.notifyType === BI_PSPB_General) 
	{
	this.historystatfunc(BI_PSP_General_Notification,symptom, BI_PSPB_Read);
	} 
	else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired && this.categorytype === symptom && this.notifyType === BI_PSPB_General) 
	{
	this.historystatfunc(BI_PSP_General_Notification,symptom,BI_PSP_AssessmentStatus_Expired);
	} 
	else 
	{
	this.historyCatfunc(BI_PSP_General_Notification, symptom);
	}
} 
else if (this.categorytype === newcontent &&this.notifyType === BI_PSPB_General) {
	if (this.statusvalue === BI_PSPB_Read &&this.categorytype === newcontent &&this.notifyType === BI_PSPB_General) 
	{
	this.historystatfunc(BI_PSP_General_Notification,newcontent,BI_PSPB_Read);
	} 
	else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === newcontent &&this.notifyType === BI_PSPB_General) 
	{
	this.historystatfunc(BI_PSP_General_Notification,newcontent,BI_PSP_AssessmentStatus_Expired);
	} 
	else 
	{
	this.historyCatfunc(BI_PSP_General_Notification, newcontent);
	}
} 
else if (this.categorytype === community &&this.notifyType === BI_PSPB_General) 
{
	if (this.statusvalue === BI_PSPB_Read &&this.categorytype === community &&this.notifyType === BI_PSPB_General) 
	{
	this.historystatfunc(BI_PSP_General_Notification,community,BI_PSPB_Read);
	} 
	else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === community &&this.notifyType === BI_PSPB_General) 
	{
	this.historystatfunc( BI_PSP_General_Notification,community,BI_PSP_AssessmentStatus_Expired);
	} 
	else 
	{
	this.historyCatfunc(BI_PSP_General_Notification, community);
	}
} 
else if (this.categorytype === challenges &&this.notifyType === BI_PSPB_General) 
{
	if (this.statusvalue === BI_PSPB_Read &&this.categorytype === challenges &&this.notifyType === BI_PSPB_General) 
	{
	this.historystatfunc( BI_PSP_General_Notification,challenges,BI_PSPB_Read);
	} 
	else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === challenges &&this.notifyType === BI_PSPB_General) 
	{
	this.historystatfunc(BI_PSP_General_Notification,challenges,BI_PSP_AssessmentStatus_Expired);
	} 
	else 
	{
	this.historyCatfunc(BI_PSP_General_Notification, challenges);
	}
} 
else if (this.categorytype === symptom &&this.notifyType === BI_PSPB_Action) 
{
	if (this.statusvalue === BI_PSP_Completed &&this.categorytype === symptom &&this.notifyType === BI_PSPB_Action) 
	{
	this.historystatfunc(BI_PSPB_Action_required,symptom, BI_PSP_Completed);
	} 
	else if (this.statusvalue === notCompleted &&this.categorytype === symptom &&this.notifyType === BI_PSPB_Action) 
	{
	this.historystatfunc(BI_PSPB_Action_required, symptom, notCompleted);
	} 
	else 
	{
	this.historyCatfunc(BI_PSPB_Action_required, symptom);
	}
} 
else if (this.categorytype === BI_PSPB_TreatmentReminder &&this.notifyType === BI_PSPB_Action) 
{
	if (this.statusvalue === BI_PSP_Completed &&this.categorytype === BI_PSPB_TreatmentReminder &&this.notifyType === BI_PSPB_Action) 
	{
	this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Treatment,BI_PSP_Completed);
	} 
	else if (this.statusvalue === notCompleted &&this.categorytype === BI_PSPB_TreatmentReminder &&this.notifyType === BI_PSPB_Action) 
	{
	this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Treatment,notCompleted);
	} 
	else 
	{
	this.historyCatfunc(BI_PSPB_Action_required, BI_PSPB_Treatment);
	}
} 
else if (this.categorytype === BI_PSPB_Prescription_reminder &&this.notifyType === BI_PSPB_Action) 
{
	if (this.statusvalue === BI_PSP_Completed &&this.categorytype === BI_PSPB_Prescription_reminder &&this.notifyType === BI_PSPB_Action) 
	{
	this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Prescription,BI_PSP_Completed);
	} 
	else if (this.statusvalue === notCompleted &&this.categorytype === BI_PSPB_Prescription_reminder &&this.notifyType === BI_PSPB_Action) 
	{
	this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Prescription,notCompleted);
	} 
	else 
	{
	this.historyCatfunc(BI_PSPB_Action_required, BI_PSPB_Prescription);
	}
}
}

//This Function is used for Onchange the Status Type
handleStatusChange(event) 
{
this.statusvalue = event.target.value;
if (this.statusvalue === BI_PSPB_Read &&this.categorytype === symptom &&this.notifyType === BI_PSPB_General) 
{
	this.historystatfunc(BI_PSP_General_Notification, symptom, BI_PSPB_Read);
} 
else if (this.statusvalue === BI_PSPB_Read &&this.categorytype === challenges &&this.notifyType === BI_PSPB_General) 
{
	this.historystatfunc(BI_PSP_General_Notification,challenges,BI_PSPB_Read);
} 
else if (this.statusvalue === BI_PSPB_Read &&this.categorytype === newcontent &&this.notifyType === BI_PSPB_General) 
{
	this.historystatfunc(BI_PSP_General_Notification,newcontent,BI_PSPB_Read);
} 
else if (this.statusvalue === BI_PSPB_Read &&this.categorytype === community &&this.notifyType === BI_PSPB_General) 
{
	this.historystatfunc(BI_PSP_General_Notification,community,BI_PSPB_Read);
} 
else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === community &&this.notifyType === BI_PSPB_General) 
{
	this.historystatfunc(BI_PSP_General_Notification,community,BI_PSP_AssessmentStatus_Expired);
} 
else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === symptom &&this.notifyType === BI_PSPB_General) 
{
	this.historystatfunc(BI_PSP_General_Notification,symptom,BI_PSP_AssessmentStatus_Expired);
} 
else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === challenges &&this.notifyType === BI_PSPB_General) 
{
	this.historystatfunc(BI_PSP_General_Notification,challenges,BI_PSP_AssessmentStatus_Expired);
} 
else if (this.statusvalue === BI_PSP_AssessmentStatus_Expired &&this.categorytype === newcontent &&this.notifyType === BI_PSPB_General) 
{
	this.historystatfunc(BI_PSP_General_Notification,newcontent,BI_PSP_AssessmentStatus_Expired);
} 
else if (this.statusvalue === BI_PSP_Completed &&this.categorytype === symptom && this.notifyType === BI_PSPB_Action) 
{
	this.historystatfunc(BI_PSPB_Action_required, symptom, BI_PSP_Completed);
} 
else if (this.statusvalue === notCompleted &&this.categorytype === symptom &&this.notifyType === BI_PSPB_Action) 
{
	this.historystatfunc(BI_PSPB_Action_required, symptom, notCompleted);
} 
else if (this.statusvalue === BI_PSP_Completed &&this.categorytype === BI_PSPB_TreatmentReminder &&this.notifyType === BI_PSPB_Action) 
{
	this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Treatment,BI_PSP_Completed);
} 
else if (this.statusvalue === notCompleted &&this.categorytype === BI_PSPB_TreatmentReminder &&this.notifyType === BI_PSPB_Action) 
{
	this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Treatment, notCompleted);
} 
else if (this.statusvalue === BI_PSP_Completed &&this.categorytype === BI_PSPB_Prescription_reminder &&this.notifyType === BI_PSPB_Action) 
{
	this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Prescription,BI_PSP_Completed);
} 
else if (this.statusvalue === notCompleted &&this.categorytype === BI_PSPB_Prescription_reminder &&this.notifyType === BI_PSPB_Action) 
{
	this.historystatfunc(BI_PSPB_Action_required,BI_PSPB_Prescription,notCompleted);
}
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