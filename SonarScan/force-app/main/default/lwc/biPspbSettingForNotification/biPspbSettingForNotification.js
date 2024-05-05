// This LWC is designed to display Notification Settings on clicking the Account Manager in the Dashboard
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Static Resources
import newcontentimg from '@salesforce/resourceUrl/BI_PSP_NewContent';
import challengeimg from '@salesforce/resourceUrl/BI_PSP_Challenges';
import questionnaireimg from '@salesforce/resourceUrl/BI_PSP_Questionnaires';
import treatmentimg from '@salesforce/resourceUrl/BI_PSPB_Treatmentimg';
import communityimg from '@salesforce/resourceUrl/BI_PSP_Community';
import symptomsimg from '@salesforce/resourceUrl/BI_PSP_SymptomTracker';
// To import Apex Classes
import getuserAccountId from '@salesforce/apex/BI_PSPB_FeedItemCtrl.getUserAccountId';
import updatenotify from '@salesforce/apex/BI_PSP_updateNotification.updateFieldInObject';
import updaterecentnotify from '@salesforce/apex/BI_PSP_updateNotification.retrieveNotifications';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Custom Labels
import treatment from "@salesforce/label/c.BI_PSPB_Treatmentremainders";
import symptom from "@salesforce/label/c.BI_PSP_symptomtracker";
import newcontent from "@salesforce/label/c.BI_PSP_NotificationNewContent";
import challenges from "@salesforce/label/c.BI_PSP_challenges";
import community from "@salesforce/label/c.BI_PSPB_Community";
import Questionnaires from "@salesforce/label/c.BI_PSP_NotificationQuestionnaires";
import Phone from "@salesforce/label/c.BI_PSPB_Phone";
import Email from "@salesforce/label/c.BI_PSP_NotificationEmail";
import Sms from "@salesforce/label/c.BI_PSP_NotificationSMS";
import Insite from "@salesforce/label/c.BI_PSP_NotificationInsiteNotification";
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';

export default class NotificSetting extends LightningElement 
{
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Variable Declaration with @track
	@track SympAll = false;
	@track isCheckboxSymp1 = false;
	@track isCheckboxSymp2 = false;
	@track isCheckboxSymp3 = false;
	@track isCheckboxSymp4 = false;
	@track QuestionAll = false;
	@track isCheckboxQues1 = false;
	@track isCheckboxQues2 = false;
	@track isCheckboxQues3 = false;
	@track isCheckboxQues4 = false;
	@track NewcontentAll = false;
	@track isCheckboxNew1 = false;
	@track isCheckboxNew2 = false;
	@track isCheckboxNew3 = false;
	@track isCheckboxNew4 = false;
	@track ChallengeAll = false;
	@track isCheckboxChal1 = false;
	@track isCheckboxChal2 = false;
	@track isCheckboxChal3 = false;
	@track isCheckboxChal4 = false;
	@track CommunityAll = false;
	@track iscommunity1 = false;
	@track iscommunity2 = false;
	@track treatAll = false;
	@track isCheckboxtret1 = false;
	@track isCheckboxtret2 = false;
	@track isCheckboxtret3 = true;
	@track isCheckboxtret4 = false;
	@track accname;
	// Variable Declaration
	userId = Id;
	community = communityimg;
	newcontentUrl = newcontentimg;
	symptomsUrl = symptomsimg;
	challengeUrl = challengeimg;
	questionnaireUrl = questionnaireimg;
	treatmentUrl = treatmentimg;
	// To fetch the Account IDs
	@wire(getuserAccountId, { userId: '$userId' })
	wiredAccId({ data, error }) 
	{
		if (data) 
		{
			try 
			{
				this.accname = data;
				this.treatfunc(this.accname);
				this.chalfunc(this.accname);
				this.Sympfunc(this.accname);
				this.Questfunc(this.accname);
				this.newfunc(this.accname);
				this.comfunc(this.accname);
			} catch (err) 
			{
				this.showToast(errormessage, err.message, errorvariant);//Catching Potential error 2
			}
		}
		else if (error) 
		{
			this.showToast(errormessage, error.message, errorvariant);//Catching Potential error 1
		}
	}
		
	// To fetch the treatment type records from Notification Settings object
	treatfunc(accidname) 
	{
		updaterecentnotify({ accid: accidname, Type: treatment })
			.then(data => 
			{
				this.isCheckboxtret1 = data[0].BI_PSP_Email__c;
				this.isCheckboxtret2 = data[0].BI_PSP_SMS__c;
				this.isCheckboxtret3 = true;
				this.isCheckboxtret4 = data[0].BI_PSP_Phone__c;
				if (this.isCheckboxtret1 === true && this.isCheckboxtret2 === true && this.isCheckboxtret3 === true && this.isCheckboxtret4 === true) 
				{
					this.treatAll = true;
				}
				else 
				{
					this.treatAll = false;
				}
			})
			.catch (error=> 
			{
				// Handle any errors that occur within the try block
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	// To fetch the Questionnaire records from Notification Settings object
	Questfunc(accidname) 
	{
		updaterecentnotify({ accid: accidname, Type: Questionnaires })
			.then(data => 
			{
				this.isCheckboxQues1 = data[0].BI_PSP_Email__c;
				this.isCheckboxQues2 = data[0].BI_PSP_SMS__c
				this.isCheckboxQues3 = data[0].BI_PSP_Insite_Notification__c;
				this.isCheckboxQues4 = data[0].BI_PSP_Phone__c;
				if (this.isCheckboxQues1 === true && this.isCheckboxQues2 === true && this.isCheckboxQues3 === true && this.isCheckboxQues4 === true) 
				{
					this.QuestionAll = true;
				}
				else 
				{
					this.QuestionAll = false;
				}
			})
			.catch (error=> 
			{
				// Handle any errors that occur within the try block
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	// To fetch the Symptom Tracker records from Notification Settings object
	Sympfunc(accidname) 
	{
		updaterecentnotify({ accid: accidname, Type: symptom })
			.then(data => 
			{
				this.isCheckboxSymp1 = data[0].BI_PSP_Email__c;
				this.isCheckboxSymp2 = data[0].BI_PSP_SMS__c
				this.isCheckboxSymp3 = data[0].BI_PSP_Insite_Notification__c;
				this.isCheckboxSymp4 = data[0].BI_PSP_Phone__c;
				if (this.isCheckboxSymp1 === true && this.isCheckboxSymp2 === true && this.isCheckboxSymp3 === true && this.isCheckboxSymp4 === true) 
				{
					this.SympAll = true;
				}
				else 
				{
					this.SympAll = false;
				}
			})
			.catch (error=> 
			{
				// Handle any errors that occur within the try block
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	// To fetch the Challenges records from Notification Settings object
	chalfunc(accidname) 
	{
		updaterecentnotify({ accid: accidname, Type: challenges })
			.then(data => 
			{
				this.isCheckboxChal1 = data[0].BI_PSP_Email__c;
				this.isCheckboxChal2 = data[0].BI_PSP_SMS__c
				this.isCheckboxChal3 = data[0].BI_PSP_Insite_Notification__c;
				this.isCheckboxChal4 = data[0].BI_PSP_Phone__c;
				if (this.isCheckboxChal1 === true && this.isCheckboxChal2 === true && this.isCheckboxChal3 === true && this.isCheckboxChal4 === true) 
				{
					this.ChallengeAll = true;
				}
				else 
				{
					this.ChallengeAll = false;
				}
			})
			.catch (error=> 
			{
				// Handle any errors that occur within the try block
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	// To fetch the Community records from Notification Settings object
	comfunc(accidname) 
	{
		updaterecentnotify({ accid: accidname, Type: community })
			.then(data => 
			{
				this.iscommunity1 = data[0].BI_PSP_Email__c;
				this.iscommunity2 = data[0].BI_PSP_Insite_Notification__c;
				if (this.iscommunity1 === true && this.iscommunity2 === true) 
				{
					this.CommunityAll = true;
				}
				else 
				{
					this.CommunityAll = false;
				}
			})
			.catch (error=> 
			{
				// Handle any errors that occur within the try block
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	// To fetch the Information center records from Notification Settings object
	newfunc(accidname) 
	{
		updaterecentnotify({ accid: accidname, Type: newcontent })
			.then(data => 
			{
				this.isCheckboxNew1 = data[0].BI_PSP_Email__c;
				this.isCheckboxNew2 = data[0].BI_PSP_SMS__c
				this.isCheckboxNew3 = data[0].BI_PSP_Insite_Notification__c;
				this.isCheckboxNew4 = data[0].BI_PSP_Phone__c;
				if (this.isCheckboxNew1 === true && this.isCheckboxNew2 === true && this.isCheckboxNew3 === true && this.isCheckboxNew4 === true) 
				{
					this.NewcontentAll = true;
				}
				else 
				{
					this.NewcontentAll = false;
				}
			})
			.catch (error=> 
			{
				// Handle any errors that occur within the try block
				this.showToast(errormessage, error.message, errorvariant);
			})

	}
	// To trigger the Check box for Symptom Tracker
	sympCheckboxChange(event) 
	{
		const checkbox = event.target;
		const label = checkbox.label;
		if (label === Email) 
		{
			this.isCheckboxSymp1 = checkbox.checked;
		} else if (label === Sms) 
		{
			this.isCheckboxSymp2 = checkbox.checked;
		} else if (label === Insite) 
		{
			this.isCheckboxSymp3 = checkbox.checked;
		}
		else if (label === Phone) 
		{
			this.isCheckboxSymp4 = checkbox.checked;
		}
		// Check the toggle switch if all checkboxes are checked.
		if (this.isCheckboxSymp1 && this.isCheckboxSymp2 && this.isCheckboxSymp3 && this.isCheckboxSymp4) 
		{
			this.SympAll = true;
		} 
		else 
		{
			this.SympAll = false;
		}
	}
	// To trigger the toggle for Symptom Tracker 
	handleSwitchChangeSymp(event) 
	{
		this.SympAll = event.target.checked;
		// If the toggle switch is checked, check all the checkboxes.
		if (this.SympAll) 
		{
			this.isCheckboxSymp1 = true;
			this.isCheckboxSymp2 = true;
			this.isCheckboxSymp3 = true;
			this.isCheckboxSymp4 = true;
		} 
		else 
		{
			// Otherwise, uncheck all the checkboxes.
			this.isCheckboxSymp1 = false;
			this.isCheckboxSymp2 = false;
			this.isCheckboxSymp3 = false;
			this.isCheckboxSymp4 = false;
		}
	}
	// To trigger the Check box for Articles
	NewCheckboxChange(event) 
	{
		const checkbox = event.target;
		const label = checkbox.label;
		if (label === Email) 
		{
			this.isCheckboxNew1 = checkbox.checked;
		} 
		else if (label === Sms) 
		{
			this.isCheckboxNew2 = checkbox.checked;
		} 
		else if (label === Insite) 
		{
			this.isCheckboxNew3 = checkbox.checked;
		}
		else if (label === Phone) 
		{
			this.isCheckboxNew4 = checkbox.checked;
		}
		if (this.isCheckboxNew1 && this.isCheckboxNew2 && this.isCheckboxNew3 && this.isCheckboxNew4) 
		{
			this.NewcontentAll = true;
		} 
		else 
		{
			this.NewcontentAll = false;
		}
	}
	// To trigger the toggle for Articles
	handleSwitchChangeNew(event) 
	{
		this.NewcontentAll = event.target.checked;
		// If the toggle switch is checked, check all the checkboxes.
		if (this.NewcontentAll) 
		{
			this.isCheckboxNew1 = true;
			this.isCheckboxNew2 = true;
			this.isCheckboxNew3 = true;
			this.isCheckboxNew4 = true;
		} 
		else 
		{
			// Otherwise, uncheck all the checkboxes.
			this.isCheckboxNew1 = false;
			this.isCheckboxNew2 = false;
			this.isCheckboxNew3 = false;
			this.isCheckboxNew4 = false;
		}
	}
	// To trigger the Check box for Community
	ComCheckboxChange(event) 
	{
		const checkbox = event.target;
		const label = checkbox.label;
		if (label === Email) 
		{
			this.iscommunity1 = checkbox.checked;

		} 
		else if (label === Insite) 
		{
			this.iscommunity2 = checkbox.checked;
		}
		if (this.iscommunity1 && this.iscommunity2) 
		{
			this.CommunityAll = true;
		} 
		else 
		{
			this.CommunityAll = false;
		}
	}
	// To trigger the toggle for Community
	handleSwitchChangeCommunity(event) 
	{
		this.CommunityAll = event.target.checked;
		// If the toggle switch is checked, check all the checkboxes.
		if (this.CommunityAll) 
		{
			this.iscommunity1 = true;
			this.iscommunity2 = true;
		} 
		else 
		{
			// Otherwise, uncheck all the checkboxes.
			this.iscommunity1 = false;
			this.iscommunity2 = false;
		}
	}
	// To trigger the Check box for Questionnaires
	QuesCheckboxChange(event) 
	{
		const checkbox = event.target;
		const label = checkbox.label;
		if (label === Email) 
		{
			this.isCheckboxQues1 = checkbox.checked;
		} 
		else if (label === Sms) 
		{
			this.isCheckboxQues2 = checkbox.checked;
		} 
		else if (label === Insite) 
		{
			this.isCheckboxQues3 = checkbox.checked;
		}
		else if (label === Phone) 
		{
			this.isCheckboxQues3 = checkbox.checked;
		}
		if (this.isCheckboxQues1 && this.isCheckboxQues2 && this.isCheckboxQues3 && this.isCheckboxQues4) 
		{
			this.QuestionAll = true;
		} 
		else 
		{
			this.QuestionAll = false;
		}
	}
	// To trigger the toggle for Questionnaires
	handleSwitchChangeQues(event) 
	{
		this.QuestionAll = event.target.checked;
		// If the toggle switch is checked, check all the checkboxes.
		if (this.QuestionAll) 
		{
			this.isCheckboxQues1 = true;
			this.isCheckboxQues2 = true;
			this.isCheckboxQues3 = true;
			this.isCheckboxQues4 = true;
		} 
		else 
		{
			// Otherwise, uncheck all the checkboxes.
			this.isCheckboxQues1 = false;
			this.isCheckboxQues2 = false;
			this.isCheckboxQues3 = false;
			this.isCheckboxQues4 = false;
		}
	}
	// To trigger the Check box for Challenges
	ChalCheckboxChange(event) 
	{
		const checkbox = event.target;
		const label = checkbox.label;
		if (label === Email) 
		{
			this.isCheckboxChal1 = checkbox.checked;
		} 
		else if (label === Sms) 
		{
			this.isCheckboxChal2 = checkbox.checked;
		} 
		else if (label === Insite) 
		{
			this.isCheckboxChal3 = checkbox.checked;
		}
		else if (label === Phone) 
		{
			this.isCheckboxChal4 = checkbox.checked;
		}
		if (this.isCheckboxChal1 && this.isCheckboxChal2 && this.isCheckboxChal3 && this.isCheckboxChal4) 
		{
			this.ChallengeAll = true;
		} 
		else 
		{
			this.ChallengeAll = false;
		}
	}
	// To trigger the toggle for Challenges
	handleSwitchChangeChal(event) 
	{
		this.ChallengeAll = event.target.checked;
		// If the toggle switch is checked, check all the checkboxes.
		if (this.ChallengeAll) 
		{
			this.isCheckboxChal1 = true;
			this.isCheckboxChal2 = true;
			this.isCheckboxChal3 = true;
			this.isCheckboxChal4 = true;
		} 
		else 
		{
			// Otherwise, uncheck all the checkboxes.
			this.isCheckboxChal1 = false;
			this.isCheckboxChal2 = false;
			this.isCheckboxChal3 = false;
			this.isCheckboxChal4 = false;
		}
	}
	// To trigger the Check box for Treatment Reminders
	tretCheckboxChange(event) 
	{
		const checkbox = event.target;
		const label = checkbox.label;
		if (label === Email) 
		{
			this.isCheckboxtret1 = checkbox.checked;
		} 
		else if (label === Sms) 
		{
			this.isCheckboxtret2 = checkbox.checked;
		} 
		else if (label === Phone) 
		{
			this.isCheckboxtret4 = checkbox.checked;
		}
		// Check the toggle switch if all checkboxes are checked.
		if (this.isCheckboxtret1 && this.isCheckboxtret2 && this.isCheckboxtret3 && this.isCheckboxtret4) 
		{
			this.treatAll = true;
		} 
		else 
		{
			this.treatAll = false;
		}
	}
	// To trigger the toggle for Treatment Reminders
	handleSwitchChangetreat(event) 
	{
		this.treatAll = event.target.checked;
		// If the toggle switch is checked, check all the checkboxes.
		if (this.treatAll) 
		{
			this.isCheckboxtret1 = true;
			this.isCheckboxtret2 = true;
			this.isCheckboxtret4 = true;
		} 
		else 
		{
			// Otherwise, uncheck all the checkboxes.
			this.isCheckboxtret1 = false;
			this.isCheckboxtret2 = false;
			this.isCheckboxtret4 = false;
		}
	}
	// To update the captured notification settings in Notification Settings object
	updatefunc(accids, type, email, sms, insite, phone) 
	{
		let caseupdate = 
		{
			typeValue: type,
			emailValue: email,
			smsValue: sms,
			insiteValue: insite,
			phoneValue: phone,
		};
		updatenotify({ accid: accids, Wrapper: caseupdate })
			.then(() => 
			{
				const evt = new ShowToastEvent({
					title: 'Success!',
					message: 'Your changes are updated',
					variant: 'success', // other options: error, warning, info
				});
				this.dispatchEvent(evt);
			})
			.catch (error=> 
			{
				// Handle any errors that occur within the try block
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	//To Save the changes in notification settings
	handleSave() 
	{
		this.updatefunc(this.accname, treatment, this.isCheckboxtret1, this.isCheckboxtret2, true, this.isCheckboxtret4);
		this.updatefunc(this.accname, symptom, this.isCheckboxSymp1, this.isCheckboxSymp2, this.isCheckboxSymp3, this.isCheckboxSymp4);
		this.updatefunc(this.accname, Questionnaires, this.isCheckboxQues1, this.isCheckboxQues2, this.isCheckboxQues3, this.isCheckboxQues4);
		this.updatefunc(this.accname, challenges, this.isCheckboxChal1, this.isCheckboxChal2, this.isCheckboxChal3, this.isCheckboxChal4);
		this.updatefunc(this.accname, newcontent, this.isCheckboxNew1, this.isCheckboxNew2, this.isCheckboxNew3, this.isCheckboxNew4);
		this.updatefunc(this.accname, community, this.iscommunity1, '', this.iscommunity2, '')	
	}
	//This showToast is used for error 
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