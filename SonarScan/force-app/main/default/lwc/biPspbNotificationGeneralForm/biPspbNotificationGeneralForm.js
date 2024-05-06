//This component is used to Display Tasks based on the General notification on clicking the Notification icon from the Dashboard.
//To import the libraries
import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import the User Id
import Id from '@salesforce/user/Id';
//To import the Static resources
import notifyimg from '@salesforce/resourceUrl/BI_PSPB_ArticleImg';
import notifychalimg from '@salesforce/resourceUrl/BI_PSPB_NotificationChallengesImg';
import notifysymimg from '@salesforce/resourceUrl/BI_PSPB_SymptomImg';
import notifyQuestimg from '@salesforce/resourceUrl/BI_PSP_QuestionnairesNotification';
import notifyavatarimg from '@salesforce/resourceUrl/BI_PSPB_SymptomImg';
import notifycomimg from '@salesforce/resourceUrl/BI_PSP_CommunityLogo';
//To import the Apex class
import generaltask from '@salesforce/apex/BI_PSPB_InsiteNotification.getTaskGeneral';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import taskupdate from '@salesforce/apex/BI_PSPB_symptomTrackerTasksCtrl.markTaskRead';
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
import BI_PSP_allPostUrl from '@salesforce/label/c.BI_PSPB_ChatterAllPost';
import BI_PSP_CHATTERMYPOST from '@salesforce/label/c.BI_PSPB_ChatterMyPost';
import BI_PSP_CHATTERFOLLOWER from '@salesforce/label/c.BI_PSPB_ChatterFollower';
import BI_PSP_Follow from '@salesforce/label/c.BI_PSP_Follow';
import BI_PSP_Reaction from '@salesforce/label/c.BI_PSP_Reaction';
import BI_PSP_CreatePost from '@salesforce/label/c.BI_PSP_CreatePost';
import BI_PSP_Comment from '@salesforce/label/c.BI_PSP_Comment';
import BI_PSP_General_Notification from '@salesforce/label/c.BI_PSPB_General_Notification';
import BI_PSP_Injection_Demonstration from '@salesforce/label/c.BI_PSP_Injection_Demonstration';
import BI_PSPB_SymptomTrackerMain from '@salesforce/label/c.BI_PSPB_SymptomTrackerMain';
import BI_PSPB_BROutstandingQuestionnaireUrl from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import BI_PSP_challengesURL from "@salesforce/label/c.BI_PSP_challengesURL";

export default class biPspNotificationGeneralForm extends NavigationMixin(LightningElement) 
{
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Declaration of variables with @track
	@track userId = Id;
	@track activeMenuItem = 'General';
	@track value;
	@track Alltask;
	@track trackbutton;
	@track viewbutton;
	@track general=true;
	@track accname;
	@track generalValue = [];
	@track displayCount = 3;
	@track showLoadMoreButton = true;
	@track norecords = false;
	@track catetype;
	@track chattertype;
	@track chatterfeedid;
	// Declaration of variables
	QuestionImg = notifyQuestimg;
	contentimg = notifyimg;
	symptomimg = notifysymimg;
	challengeimg = notifychalimg;
	comunityimg = notifycomimg;
	avatarimg = notifyavatarimg;
	// Initialize accname
	connectedCallback() 
	{
		try{
			getEnrolle({ userId: this.userId })
				.then(result => 
				{
					if (result != null) 
					{
						if (result[0].patientEnrolle != null) 
						{
							this.accname = result[0].patientEnrolle.Id;
							
						} 
						else if (result[0].error != null) 
						{
							this.showError = true;
							this.errorMessage = result[0].error;
						}
					}
				})
				// Null data is checked and AuraHandledException is thrown from the Apex
				.catch(error => 
				{
					this.showToast(errormessage, error.message, errorvariant);
				})
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
				this.urlq = brandedUrl;
				this.options = [
					{ label: challenges, value: challenges },
					{ label: symptom, value: symptom },
					{ label: BI_PSP_Injection_Demonstration, value: BI_PSP_Injection_Demonstration },
					{ label: newcontent, value: newcontent },
					{ label:community, value: community }
				];
			}
			else
			{
				this.urlq = unassignedUrl;
				this.options = [
					{ label: challenges, value: challenges },
					{ label: symptom, value: symptom },
					{ label: newcontent, value: newcontent },
					{ label:community, value: community }
				];
			}
		}
		catch (error)
		{
			this.showToast(errormessage, error.message, errorvariant);
		}
	}

 //To fetch the All general notification
	@wire(generaltask, { enroleeId: '$accname', notificatonType: BI_PSP_General_Notification })
	generaltask({ data, error })
	{
		if (data)
		// Null data is checked and AuraHandledException is thrown from the Apex
		{
			try 
			{
				if (data && data.length > 3) 
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
				
				this.generalValue = data.map(obj => ({
					...obj,
					trackbutton: obj.BI_PSP_Category__c === symptom,
					Readbutton: obj.BI_PSP_Category__c ===newcontent,
					contentsimg: obj.BI_PSP_Category__c ===newcontent,
					Comunityimage: obj.BI_PSP_Category__c === community,
					Combutton: obj.BI_PSP_Category__c === community && obj.BI_PSP_ChatterType__c === BI_PSP_CreatePost,
					Follwersbutton: obj.BI_PSP_Category__c === community && obj.BI_PSP_ChatterType__c === BI_PSP_Follow,
					Reactionbutton: obj.BI_PSP_Category__c === community && obj.BI_PSP_ChatterType__c === BI_PSP_Reaction,
					Commentsbutton: obj.BI_PSP_Category__c === community && obj.BI_PSP_ChatterType__c === BI_PSP_Comment,
					sympimg: obj.BI_PSP_Category__c === symptom,
					viewbutton: obj.BI_PSP_Category__c === challenges,
					challimg: obj.BI_PSP_Category__c === challenges,
					FormattedDate: this.formatDate(obj.CreatedDate)
				}));
			} 
			catch (err) 
			{
				this.showToast(errormessage, err.message, errorvariant);
				// Handle the error as per your requirement
			}
		}
		else if (error) 
		{
			this.showToast(errormessage, error.body.message, errorvariant);
			// Handle error if needed
		}
	}

	// To display recent 3 records, on clicking Load More, shows all the records
	get displayedGeneralValue() 
	{
		return this.generalValue.slice(0, this.displayCount);
	}
	//This Function is used to load more notification
	loadMore() 
	{
		this.displayCount = this.generalValue.length;
		this.showLoadMoreButton = false;
	}
	// To display the Date in the short format
	formatDate(createdDate) 
	{
		const dateObject = new Date(createdDate);
		// Get the day and month
		const day = dateObject.getDate();
		const month = dateObject.toLocaleString('default', { month: 'short' });

		// Get the year in a 2-digit format
		const year = dateObject.getFullYear().toString().slice(-2);

		// Format the date
		const formattedDate = `${day} ${month}’ ${year}`;

		return formattedDate;
	}

	//This function is used to trigger the fliter in general notification records
	funcgeneral(typevalue) 
	{
		try 
		{
			generaltask({ enroleeId: this.accname, notificatonType: typevalue })
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
					this.generalValue = result.map(obj => ({
						...obj,
						trackbutton: obj.BI_PSP_Category__c === symptom,
						Readbutton: obj.BI_PSP_Category__c ===newcontent,
						contentsimg: obj.BI_PSP_Category__c ===newcontent,
						Comunityimage: obj.BI_PSP_Category__c === community,
						Combutton: obj.BI_PSP_Category__c === community && obj.BI_PSP_ChatterType__c === BI_PSP_CreatePost,
						Follwersbutton: obj.BI_PSP_Category__c === community && obj.BI_PSP_ChatterType__c === BI_PSP_Follow,
						Reactionbutton: obj.BI_PSP_Category__c === community && obj.BI_PSP_ChatterType__c === BI_PSP_Reaction,
						Commentsbutton: obj.BI_PSP_Category__c === community && obj.BI_PSP_ChatterType__c === BI_PSP_Comment,
						sympimg: obj.BI_PSP_Category__c === symptom,
						viewbutton: obj.BI_PSP_Category__c === challenges,
						challimg: obj.BI_PSP_Category__c === challenges,
						FormattedDate: this.formatDate(obj.CreatedDate)
					}));
				})
				.catch(error => 
				{
					this.showToast(errormessage, error.message, errorvariant);
					// Handle the error as per your requirement
				});
		} 
		catch (err)
		{
			this.showToast(errormessage, err.message, errorvariant);
			// Handle the error as per your requirement
		}
	}

//This is onchange function for filter the general notification
	handleChange(event) 
	{
		this.value = event.target.value;
		this.displayCount = 3;
		if (this.value === symptom) 
		{
			this.funcgeneral(this.value);
		}
		else if (this.value === challenges) 
		{
			this.funcgeneral(this.value);
		}
		else if (this.value ===newcontent) 
		{
			this.funcgeneral(this.value);
		}
		else if (this.value === community) 
		{
			this.funcgeneral(this.value);
		}
	}

	//this function is used for check category record to navigation the specific page and also update as Read 
	updategeneraltask(event) 
	{
		try 
		{
			const selectedId = event.currentTarget.dataset.taskId;
			taskupdate({ taskId: selectedId })
			// Null data is checked and AuraHandledException is thrown from the Apex
				.then(result =>
					{
					this.catetype = result[0].BI_PSP_Category__c;
					this.chattertype = result[0].BI_PSP_ChatterType__c;
					this.chatterfeedid = result[0].BI_PSP_ChatterFeedId__c;
					if (this.catetype === symptom) 
					{
						this.navigatesymptom();
					} 
					else if (this.catetype === challenges) 
					{
						this.navigatetochallnge();
					} 
					else if (this.catetype === newcontent) 
					{
						this.navigatetonewcontent();
					}
					else if (this.catetype === community && this.chattertype === BI_PSP_Follow) 
					{
						this.navtofollow();
					} 
					else if (this.catetype === community && this.chattertype === BI_PSP_CreatePost) 
					{
						this.navtopost();
					} 
					else if (this.catetype === community && this.chattertype === BI_PSP_Comment) 
					{
						this.navtocomments();
					} 
					else if (this.catetype === community && this.chattertype === BI_PSP_Reaction) 
					{
						this.navtoreaction();
					}
				})
				.catch(error => 
				{
					this.showToast(errormessage, error.message, errorvariant);
					// Handle the error as per your requirement
				});
		} 
		catch (err) 
		{
			this.showToast(errormessage, err.message, errorvariant);
			// Handle the error as per your requirement
		}
	}

	//Community Button Navigations 
	navtofollow() 
	{
		window.location.assign( this.urlq + BI_PSP_CHATTERFOLLOWER);
	}
	navtopost() 
	{
		window.localStorage.setItem('selectedItemIdforCreatepost', this.chatterfeedid);
		window.location.assign(this.urlq + BI_PSP_allPostUrl);
	}
	navtocomments() 
	{
		window.localStorage.setItem('selectedItemIdforComment', this.chatterfeedid);
		window.location.assign(this.urlq + BI_PSP_CHATTERMYPOST);
	}
	navtoreaction() 
	{
		window.localStorage.setItem('selectedItemId', this.chatterfeedid);
		window.location.assign(this.urlq + BI_PSP_CHATTERMYPOST);
	}
	navigatesymptom() 
	{
		window.location.assign(this.urlq + BI_PSPB_SymptomTrackerMain);
	}
	navigatetonewcontent() 
	{
		window.location.assign(this.urlq + BI_PSPB_BROutstandingQuestionnaireUrl);
	}
	navigatetochallnge() 
	{
		window.location.assign(this.urlq + BI_PSP_challengesURL);
	}

	//This ShowToast message is used for get error
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}