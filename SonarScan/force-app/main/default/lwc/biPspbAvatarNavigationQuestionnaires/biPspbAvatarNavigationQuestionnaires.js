//This Lightning web component purpose is Avatar Prompt message for all the navigation pages
//To import the Libraries
import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import the Apex class
import getLoggedInUserAccount from '@salesforce/apex/BI_PSPB_avatarCtrl.getLoggedInUserAccount';
import UserCaregiver from '@salesforce/apex/BI_PSPB_avatarCtrl.userCaregiver';
//To import the User Id
import Id from '@salesforce/user/Id';
//To Import The Static Resources
import Default_avatar_JPEG_URL from '@salesforce/resourceUrl/BI_PSPB_Default_Avater_Navigation';
//To Import the Custom Labels
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import BI_PSPB_CaregiverNotification from '@salesforce/label/c.BI_PSPB_CaregiverNotification';
import BI_PSPB_CaregiverProfileSite from '@salesforce/label/c.BI_PSPB_CaregiverProfileSite';
import BI_PSPB_CaregiverPatient from '@salesforce/label/c.BI_PSPB_CaregiverPatient';
import BI_PSPB_CaregiverSelectAvatar from '@salesforce/label/c.BI_PSPB_CaregiverSelectAvatar';
import BI_PSPB_PatientMyProfileUrl from '@salesforce/label/c.BI_PSPB_PatientMyProfileUrl';
import BI_PSPB_PatientNotificationUrl from '@salesforce/label/c.BI_PSPB_PatientNotificationUrl';
import BI_PSPB_PatientSelectAvatarUrl from '@salesforce/label/c.BI_PSPB_PatientSelectAvatarUrl';
import BI_PSPB_MyCaregiverUrl from '@salesforce/label/c.BI_PSPB_MyCaregiverUrl';
import BI_PSP_AvatarQuestionnaireTwoUrl from '@salesforce/label/c.BI_PSP_AvatarQuestionnaireTwoUrl';
import BI_PSP_AvatarQuestionnaireUrl from '@salesforce/label/c.BI_PSP_AvatarQuestionnaireUrl';
import BI_PSPB_UpdatePrescriptionUrl from '@salesforce/label/c.BI_PSPB_UpdatePrescriptionUrl';
import BI_PSPB_PrescriptionStatusUrl from '@salesforce/label/c.BI_PSPB_PrescriptionStatusUrl';
import BI_PSP_challengesURL from '@salesforce/label/c.BI_PSP_challengesURL';
import BI_PSP_trophyCaseURL from '@salesforce/label/c.BI_PSP_trophyCaseURL';
import BI_PSPB_BROutstandingQuestionnaireUrl from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import BI_PSPB_BR_LetsPersonalizeUrl from '@salesforce/label/c.BI_PSPB_BR_LetsPersonalizeUrl';
import BI_PSPB_BRDlqiQuestionnaireUrl from '@salesforce/label/c.BI_PSPB_BRDlqiQuestionnaireUrl';
import BI_PSPB_BRPsoriasisQuesUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisQuesUrl';
import BI_PSPB_BRWapiQuestionnaire from '@salesforce/label/c.BI_PSPB_BRWapiQuestionnaire';
import BI_PSPB_BRQualitativeTwoMonths from '@salesforce/label/c.BI_PSPB_BRQualitativeTwoMonths';
import BI_PSPB_BRWapiCompletedQuestionnaire from '@salesforce/label/c.BI_PSPB_BRWapiCompletedQuestionnaire';
import BI_PSPB_BRPsoriasisCompletedQuesUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisCompletedQuesUrl';
import BI_PSPB_BRDlqiCompletedUrl from '@salesforce/label/c.BI_PSPB_BRDlqiCompletedUrl';
import BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl from '@salesforce/label/c.BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl'
import BI_PSPB_BRQualitativefourteenweeksCompletedUrl from '@salesforce/label/c.BI_PSPB_BRQualitativefourteenweeksCompletedUrl'
import BI_PSPB_ActionUrl from '@salesforce/label/c.BI_PSPB_ActionUrl';
import BI_PSPB_messagecenterUrl from '@salesforce/label/c.BI_PSPB_messagecenterUrl';
import BI_PSPB_ReminderUrl from '@salesforce/label/c.BI_PSPB_ReminderUrl';
import BI_PSPB_BRPLSPage from '@salesforce/label/c.BI_PSPB_BRPLSPage'
import BI_PSPB_BRRAEPage from '@salesforce/label/c.BI_PSPB_BRRAEPage'
import BI_PSPB_BRMIEPage from '@salesforce/label/c.BI_PSPB_BRMIEPage'
import BI_PSPB_BRSupportPage from '@salesforce/label/c.BI_PSPB_BRSupportPage'
import BI_PSPB_SymptomTrackerMain from '@salesforce/label/c.BI_PSPB_SymptomTrackerMain'
import BI_PSP_symptomTrackerLpUrl from '@salesforce/label/c.BI_PSP_symptomTrackerLpUrl'
import BI_PSPB_HistoryUrl from '@salesforce/label/c.BI_PSPB_HistoryUrl'
import BI_PSPB_CaregiverFirstAvatar from '@salesforce/label/c.BI_PSPB_CaregiverFirstAvatar'
import BI_PSPB_PatientFirstAvatar from '@salesforce/label/c.BI_PSPB_PatientFirstAvatar'
import BI_PSPB_CompletedQuestionnaires from '@salesforce/label/c.BI_PSPB_CompletedQuestionnaires'
import BI_PSPB_symptomtrackergraphUrl from '@salesforce/label/c.BI_PSPB_symptomtrackergraphUrl'
import BI_PSP_DlqiCategory from '@salesforce/label/c.BI_PSP_DlqiCategory'
import BI_PSP_PssCategory from '@salesforce/label/c.BI_PSP_PssCategory'
import BI_PSP_WapiCategory from '@salesforce/label/c.BI_PSP_WapiCategory'
import BI_PSPB_XpValue from '@salesforce/label/c.BI_PSPB_XpValue'
import BI_PSPB_BRSummaryUrl from '@salesforce/label/c.BI_PSPB_BRSummaryUrl'
export default class BiPspbAvatarNavigationQuestionnaires extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Declaration of variables with @api
	@api
	get receivedxpvalue() {
		return this.xpvalue;
	}
	@api
	get receivederror() {
		return this.errormedical;
	}
	@api
	get receivederrorreport() {
		return this.errorreport;
	}
	@api
	get receivedcategory() {
		return this._receivedcategory;
	}
	// Declaration of variables with @track
	@track dermo = false;
	@track contentdot = true;
	@track content = false;
	@track summary = false;
	@track twocontent = false;
	@track challangecontent = false;
	@track mobilename;
	@track twomobilename;
	@track navigationcontentdot1;
	@track navigationcontent5 = 'navigationcontent5'; //css class
	@track selected;
	@track selectedName = '';
	@track selectedName1;
	@track selectedName3;
	@track selectedName2;
	@track selectedName4;
	@track selectedName5;
	@track reloaded = localStorage.getItem('reload')
	@track caregiver = false;
	@track main = true;
	@track showAllCmps = true;
	@track xpvalue;
	@track errormedical;
	@track errorreport;
	@track closevalue = 'close'; //css class
	@track closevaluesum = 'closesum'; //css class
	@track cuurenttab;
	@track isDropdownOpen = false;
	@track challangecontents = false;
	@track selectedOption = {
		src: Default_avatar_JPEG_URL,
		name: '',
	};
	@track selectedValue;
	@track contentdot1 = false;
	@track twocontentmobile = false;
	@track challangecontentmobile = false;
	@track submobile;
	@track submobilesummary;
	@track twocontentmobile1 = false;
	// Declaration of variables 
	userContacts;
	name;
	rendered = false;
	avtList;
	selectedAvatarSrc;
	seperateChallenge;
	userAccounts;
	challengeName1;
	challengeName2;
	userid = Id;


	set receivedxpvalue(value) {
		this.xpvalue = value;
		if (this.xpvalue === BI_PSPB_XpValue) {
			this.challangecontent = false;
		}
	}


	set receivederror(value) {
		this.errormedical = value;
		if (this.errormedical === true) {
			this.handleClose();
			//Strings are hardcoded for css responsiveness
			this.selectedName1 = `Do you a medical query?

Share your Medical information 
questions here and we'll ensure you 
hear back on your query.`
			this.mobilename = `Do you have a medical query?

Share your Medical information 
questions..`
		}
		else {
			this.selectedName1 = `Do you have a medical query?

Share your Medical Information 
questions here and we will get back to 
you.`
			this.mobilename = `Do you have a medical query?

Share your Medical information 
questions..`
		}
	}


	set receivederrorreport(value) {
		this.errorreport = value;
		if (this.errorreport === true) {
			this.handleClose();
			//Strings are hardcoded for css responsiveness
			this.selectedName1 = `Want to report an adverse event?

Use this form to report any suspected 
adverse reactions - and make sure to 
inform your doctor about then too.`
			this.mobilename = `Want to report an adverse event?

Use this form to report any..`
		}
		else {
			this.selectedName1 = `Want to report an adverse event?

Use this form to report any suspected 
adverse reactions or any side effects 
and make sure to inform your doctor 
about then too.`
			this.mobilename = `Want to report an adverse event?

Use this form to report any..`
		}
	}

	set receivedcategory(value) {
		const currentTabName = window.location.pathname.split('/').pop();
		this._receivedcategory = value;

		this.summary = true;
		this.dermo = true;
		this.main = false;

		if (value === BI_PSP_DlqiCategory) {
			this.content = false;
			this.contentdot = false;
		}

		if (value === BI_PSP_DlqiCategory) {
			this.content = false;
			this.contentdot1 = true;
			this.contentdot = false;
			if (currentTabName === BI_PSPB_BRSummaryUrl && value === BI_PSP_DlqiCategory) {
				this.content = false;
				this.twocontentmobile1 = false;
				this.navigationcontentdot1 = 'navigationcontentdot1';
				//Strings are hardcoded for css responsiveness
				this.mobilename = `The aim of the questionnaire is to... `
				this.selectedName6 = `Dermatology Life Quality Index (DLQI)`
				this.selectedName5 = `The aim of the questionnaire is to
measure how much your skin problem
has affected your life over a given
period.

The graphs on this page show your last
responses on a timeline graph.`
				this.selectedName4 = `You can download the responses by
clicking on the download button.`
				this.selectedName2 = `You can download the responses by
clicking on the download button.`

			}

		}
		else if (value === BI_PSP_WapiCategory) {
			this.content = false;
			this.contentdot1 = true;
			this.contentdot = false;
			if (currentTabName === BI_PSPB_BRSummaryUrl) {
				this.content = false;
				this.twocontentmobile1 = false;
				this.navigationcontentdot1 = 'navigationcontentdot1sub1';
				this.selectedName6 = `Work & Activity Impairment(WPAI)     `
				this.mobilename = `The WPAI measures the impact of generalized pustular... `
				this.selectedName5 = `The WPAI measures the impact of
generalized pustular psoriasis (GPP) on
work productivity and activity
impairment.

The graphs on this page show how your
responses have evolved over time.`
				this.selectedName4 = `You can download the responses by
clicking on the download button.`
				this.selectedName2 = `You can download the responses by
clicking on the download button.`
			}
		}
		else if (value === BI_PSP_PssCategory) {
			this.content = false;
			this.contentdot1 = true;
			this.contentdot = false;
			if (currentTabName === BI_PSPB_BRSummaryUrl) {
				this.content = false;
				this.twocontentmobile1 = false;
				this.navigationcontentdot1 = 'navigationcontentdot1sub2';
				this.mobilename = `Listed on this page is a set of problems that people with... `
				this.selectedName6 = `Psoriasis Symptom Scale (PSS)              `
				this.selectedName5 = `Listed on this page is a set of problems
that people with psoriasis have said are
important.

The graph on this page shows the
severity of those symptoms in 24 hours
prior to completing the Questionnaire.`
				this.selectedName4 = `You can download the responses by
clicking on the download button.`
				this.selectedName2 = `You can download the responses by
clicking on the download button.`

			}
		}

	}

	//To trigger Close icon in Avatar navigation
	handleClose() {

		const currentTabName = window.location.pathname.split('/').pop();
		this.contentdot = true;

		this.mobilename = this.submobile;
		if (currentTabName === BI_PSPB_BRSummaryUrl) {
			this.navigationcontent5 = 'navigationcontent5sub';
			this.contentdot1 = true;
			this.contentdot = false;
			this.mobilename = this.submobile;
		}
		if (currentTabName === BI_PSPB_BROutstandingQuestionnaireUrl) {
			this.twocontentmobile = false;

		}
		if (currentTabName === BI_PSPB_PatientFirstAvatar) {
			this.twocontentmobile = false;
		}
		if (currentTabName === BI_PSPB_BRSummaryUrl) {
			this.twocontentmobile1 = false;
		}
		if (currentTabName === BI_PSP_challengesURL) {
			this.challangecontentmobile = false;

		}

	}

	//To trigger three Dots in Avatar Navigation
	mobileclick() {
		const currentTabName = window.location.pathname.split('/').pop();
		this.submobile = this.mobilename;
		this.mobilename = this.selectedName1;
		this.closevalue = 'close1';
		this.contentdot = false;
		this.contentdot1 = false;
		if (currentTabName === BI_PSPB_BRSummaryUrl) {
			this.navigationcontent5 = 'navigationcontent5sub';

			this.mobilename = this.selectedName5;
		}
		if (currentTabName === BI_PSPB_BROutstandingQuestionnaireUrl) {
			this.twocontentmobile = true;
			this.twomobilename = this.selectedName2;
		}
		if (currentTabName === BI_PSPB_PatientFirstAvatar) {
			this.twocontentmobile = true;
			this.twomobilename = this.selectedName2;
		}
		if (currentTabName === BI_PSPB_BRSummaryUrl) {
			this.twocontentmobile1 = true;
			this.twomobilename = this.selectedName4;
		}
		if (currentTabName === BI_PSP_challengesURL) {
			this.challangecontentmobile = true;
			this.twomobilename = this.selectedName3;
			if (this.xpvalue === BI_PSPB_XpValue) {
				this.challangecontentmobile = false;
			}
		}

	}

	renderedCallback() {
		if (this._receivedcategory === BI_PSP_DlqiCategory) {
			this.content = false;
			this.contentdot = false;
		}

	}

	//To fetch the Caregiver details
	@wire(UserCaregiver)
	wiredavtList({ error, data }) {
		// When a patient logs in, caregiver data will be null.
		if (data) {
			try {
				const currentTabName = window.location.pathname.split('/').pop();
				this.name = data.length > 0 ? data[0]?.Name : '';
				this.selectedAvatarSrc = data[0]?.BI_PSP_AvatarUrl__c ? data[0]?.BI_PSP_AvatarUrl__c : Default_avatar_JPEG_URL;
				if (data[0]?.BI_PSP_AvatarUrl__c) {
					this.selectedAvatarSrc = data[0]?.BI_PSP_AvatarUrl__c

				}
				else {
					this.selectedAvatarSrc = Default_avatar_JPEG_URL;
				}

				//Mobile response
				if (currentTabName === BI_PSP_AvatarQuestionnaireUrl) {
					this.mobilename = `We want to learn more about you. 
	Personalise your experience by 
	answering a few..`;
					this.selectedName1 = `We want to learn more about you. 
Personalise your experience by 
answering a few simple questions 
about yourself.`;
				}

				if (currentTabName === BI_PSP_AvatarQuestionnaireTwoUrl) {
					this.mobilename = `We want to learn more about you. 
	Personalise your experience by 
	answering a few..`;
					this.selectedName1 = `We want to learn more about you. 
Personalise your experience by 
answering a few simple questions 
about yourself.`;
				}
				if (currentTabName === BI_PSPB_UpdatePrescriptionUrl) {
					this.mobilename = `Update your prescription status here!..`;
					this.selectedName1 = `Update your prescription status here!

Keep your prescription status updated
here to continue receiving product
related information and services.`;
				}
				if (currentTabName === BI_PSPB_PrescriptionStatusUrl) {
					this.mobilename = `Need help filling these forms? Check
	out the support section..`;
					this.selectedName1 = `Need help filling these forms? Check
out the support section on the top right 
of this page.`;
				}
				if (currentTabName === BI_PSPB_symptomtrackergraphUrl) {
					this.mobilename = `This is your self-symptom tracker, which
	is where you can track..`;
					this.selectedName1 = `This is your self-symptom tracker, which
is where you can track your symptoms,
your flares, and their intensity over time.
You can show the self-symptom
tracker's results to your doctor to
discuss, understand, and improve your
situation.`;

				}
				if (currentTabName === BI_PSPB_PatientMyProfileUrl) {
					this.mobilename = `Hi ${this.name}, you're doing great!
	We appreciate you sharing, it will`;
					this.selectedName1 = `Hi ${this.name}, you're doing great!
We appreciate you sharing, it will help 
us provide you with a better experience 
if we know more about you.

You can complete any missing personal 
information now!`

				}
				if (currentTabName === BI_PSPB_CaregiverPatient) {
					this.mobilename = `Hi ${this.name}, you're doing great!
	We appreciate you sharing, it will`;
					this.selectedName1 = `Hi ${this.name}, you're doing great!
We appreciate you sharing, it will help 
us provide you with a better experience 
if we know more about you.

You can complete any missing personal 
information now!`

				}
				if (currentTabName === BI_PSPB_CaregiverSelectAvatar) {
					this.mobilename = `Choose your avatar!
	You're about to embark on`;
					this.selectedName1 = `Choose your avatar!

You're about to embark on a journey 
and we want you to have a fun and 
engaging experience along the way.`

				}
				if (currentTabName === BI_PSPB_CaregiverNotification) {
					this.mobilename = `Stay in the loop.
	By choosing your notification settings`;
					this.selectedName1 = `Stay in the loop.
By choosing your notification settings, 
you can be sure to receive the 
information that is most important to 
you in the way that is most convenient 
for you.`

				}
				if (currentTabName === BI_PSPB_PatientFirstAvatar) {
					this.twocontent = true;
					this.mobilename = `Welcome to the Spevigo Support Program!

	We're excited to have you join us on 
	your journey to managing generalized 
	pustular psoriasis (GPP).`;
					this.selectedName1 = `  Welcome to the Spevigo Patient Support Program!
We're excited to have you join us on your journey
to managing generalized pustular psoriasis (GPP). 
This program is designed to help you learn more 
about your condition, track your progress, and
stay connected to your healthcare team. `
					this.selectedName2 = `Choose an avatar that best suits you `
				}
				if (currentTabName === BI_PSPB_CaregiverProfileSite) {
					this.mobilename = `Hi ${this.name}, you're doing great!
	We appreciate you sharing, it will ...`;
					this.selectedName1 = `Hi ${this.name}, you're doing great!
We appreciate you sharing, it will help 
us provide you with a better experience 
if we know more about you.

You can complete any missing personal 
information now! `

				}
				if (currentTabName === BI_PSP_challengesURL) {

					const windowWidth = window.innerWidth;
					this.challangecontents = windowWidth < 601;
					if (this.challangecontents === true) {
						this.seperateChallenge = false;
						this.main = true;
						this.mobilename = `Conquer challenges that await you!
	On this page, you will find different...`;
						this.selectedName1 = `Conquer challenges that await you!
On this page, you will find different
challenges for you to complete and
continue to take control of your GPP.`
						this.selectedName3 = `You can track your status for each
challenge, gain experience points as
you complete them and level up to win
trophies. `
					}
					else {
						this.seperateChallenge = true;
						this.main = false;
						this.challangecontent = true;
						this.mobilename = `Conquer challenges that await you!

	On this page, you will find different...`;
						this.challengeName1 = `Conquer challenges that await you!`

						this.challengeName2 = `On this page, you will find different
	challenges for you to complete and
	continue to take control of your GPP. `

						this.selectedName3 = `You can track your status for each
challenge, gain experience points as
you complete them and level up to win
trophies. `
					}

				}

				if (currentTabName === BI_PSP_trophyCaseURL) {
					const windowWidth = window.innerWidth;
					this.challangecontents = windowWidth < 601;
					if (this.challangecontents === true) {
						this.seperateChallenge = false;
						this.main = true;
						this.mobilename = `Here's your trophy cupboard!
	See the trophies and badges you have
	collected...`;
						this.selectedName1 = `Here's your trophy cupboard!
See the trophies and badges you have
collected along with a list of challenges
you have successfully completed.`

					}
					else {
						this.seperateChallenge = true;
						this.main = false;
						this.mobilename = `Here's your trophy cupboard!
	See the trophies and badges you have
	collected...`;
						this.challengeName1 = `Here's your trophy cupboard!`

						this.challengeName2 = `See the trophies and badges you have
	collected along with a list of challenges
	you have successfully completed. `
					}

				}

				if (currentTabName === BI_PSPB_BROutstandingQuestionnaireUrl) {
					this.twocontent = true;
					this.mobilename = `Know Your Health, Download Results
	and Share with Your ..`;
					this.selectedName1 = `Know Your Health, Download Results
and Share with Your Doctor

Learn more about your health and feel
confident talking to your doctor about it
with our science-based questionnaires.
By working together with your doctor,
you can create a treatment plan that is
tailored to your individual needs. 

Complete our scientific based 
questionnaires which allow you to track
your GPP symptoms as well as the 
impact that having GPP has on your
quality of life and your ability to work.`

					this.selectedName2 = `How did we do?

Please Share your feedback by 
completing our "Qualitative Satisfaction"
questionnaire.Your feedback will help
us better serve the GPP community 
in the future. `
				}
				if (currentTabName === BI_PSPB_CompletedQuestionnaires) {
					this.selectedName1 = `You can find your responses to the DLQI
	questionnaire here. `
				}
				if (currentTabName === BI_PSPB_BR_LetsPersonalizeUrl) {
					this.mobilename = `We want to learn more about you.
	Personalize your experience by ..`;
					this.selectedName1 = `We want to learn more about you.
Personalize your experience by
answering a few simple questions about
yourself. `
				}


				if (currentTabName === BI_PSPB_BRDlqiQuestionnaireUrl) {
					this.mobilename = `The DLQI is a specifically designed
	questionnaire. The ..`;
					this.selectedName1 = `The DLQI is a specifically designed
questionnaire. The aim of this
questionnaire is to measure how much
your skin problem has affected your life 
OVER THE LAST WEEK. Please tick  one
box for each question. `
				}
				if (currentTabName === BI_PSPB_BRPsoriasisQuesUrl) {
					this.mobilename = `On this page, are a set of problems that
	people with ..`;
					this.selectedName1 = `On this page, are a set of problems that
people with psoriasis have said are
important. For each question, click on
the circle that best describes the
severity of your symptoms during the
past 24 hours. Please answer every
question. `
				}
				if (currentTabName === BI_PSPB_BRWapiQuestionnaire) {
					this.mobilename = `Work Productivity and Activity
	Impairment Questionnaire (WPAI..`;
					this.selectedName1 = `Work Productivity and Activity
Impairment Questionnaire (WPAI)

This WPAI questionnaire is a self-report
questionnaire that measures the impact
of generalized pustular psoriasis (GPP)
on work productivity and activity
impairment.

Questions on this page ask about how
your GPP affects your ability to work
and perform regular activities. `
				}
				if (currentTabName === BI_PSPB_BRQualitativeTwoMonths) {
					this.mobilename = `Qualitative Satisfaction Questionnaire
	The aim of this questionnaire..`;
					this.selectedName1 = `Qualitative Satisfaction Questionnaire

The aim of this questionnaire is to
capture your feedback on the
experience you had in the last fourteen
weeks of interactions with the GPP&ME
program. `
				}
				if (currentTabName === BI_PSPB_messagecenterUrl) {
					this.mobilename = `Welcome!
	You will find all your general notifications..`;
					this.selectedName1 = `Welcome!
You will find all your general
notifications about recent updates or
new materials here. Read on. `
				}
				if (currentTabName === BI_PSPB_ActionUrl) {
					this.mobilename = `We need your response!

	Here are the notifications that you have
	not responded to, yet...`;
					this.selectedName1 = `We need your response!

Here are the notifications that you have
not responded to, yet.

We encourage you to check them out
and help us help you better. `
				}
				if (currentTabName === BI_PSPB_HistoryUrl) {
					this.mobilename = `All your notifications!

	You will find all your past notifications
	on this page...`;
					this.selectedName1 = `All your notifications!

You will find all your past notifications
on this page - just in case you want to
check them again or see if you missed
something. `
				}
				if (currentTabName === BI_PSPB_BRSupportPage) {
					this.mobilename = `Want to reach out to us?
	Here is the information on how to...`;
					this.selectedName1 = `Want to reach out to us?

Here is the information on how to reach
us in case of any questions or issue you
may be facing. `
				}
				if (currentTabName === BI_PSPB_BRMIEPage) {
					this.mobilename = `Do you have a medical query?

	Share your Medical information...`;
					this.selectedName1 = `Do you have a medical query?

Share your Medical Information 
questions here and we will get back to 
you.`
				}
				if (currentTabName === BI_PSPB_BRRAEPage) {
					this.mobilename = `Want to report an adverse event?

	Use this form to report any suspected...`;
					this.selectedName1 = `Want to report an adverse event?

Use this form to report any suspected 
adverse reactions or any side effects 
and make sure to inform your doctor 
about then too.`
				}
				if (currentTabName === BI_PSPB_BRPLSPage) {
					this.mobilename = `Facing an issue with platform? drop a
	note and we will fix it`;
					this.selectedName1 = `Facing an issue with platform? drop a
note and we will fix it`
				}
				if (currentTabName === BI_PSPB_ReminderUrl) {
					this.mobilename = `Set reminders!

	Use this page to record your treatment
	date and  ....`;
					this.selectedName1 = `Set reminders!

Use this page to record your treatment
date and notify us on your preferred
advance notification time.

Set it and leave it to us!`
				}
				if (currentTabName === BI_PSP_symptomTrackerLpUrl) {
					this.mobilename = `Your self symptom tracker is where you
	can enter and track your symptoms to ....`;
					this.selectedName1 = `Your self symptom tracker is where you
can enter and track your symptoms to
have visibility about your condition, and
show it to your doctor.`
				}
				if (currentTabName === BI_PSPB_SymptomTrackerMain) {
					this.mobilename = `Your self symptom tracker is where you
	can enter and track your symptoms to ....`;
					this.selectedName1 = `Your self symptom tracker is where you
can enter and track your symptoms to
have visibility about your condition, and
show it to your doctor. `
				}
				if (currentTabName === BI_PSPB_CaregiverFirstAvatar) {
					this.mobilename = `Let's take a moment to personalize your 
	experience....`;
					this.selectedName1 = `Let's take a moment to personalize your 
experience. . 
Choose an avatar best suits you`
				}
				if (currentTabName === BI_PSPB_BRWapiCompletedQuestionnaire) {
					this.mobilename = `You can find your responses to the WPAI 
	questionnaire here...`;
					this.selectedName1 = `You can find your responses to the WPAI 
questionnaire here.`
				}
				if (currentTabName === BI_PSPB_BRPsoriasisCompletedQuesUrl) {
					this.mobilename = `You can find your responses to the PSS
questionnaire here.`
					this.selectedName1 = `You can find your responses to the PSS
questionnaire here.`
				}
				if (currentTabName === BI_PSPB_BRDlqiCompletedUrl) {
					this.mobilename = `You can find your responses to the DLQI
	questionnaire here.`
					this.selectedName1 = `You can find your responses to the DLQI
questionnaire here.`
				}
				if (currentTabName === BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl) {
					this.mobilename = `You can find your responses to the
	Qualitative Satisfaction Questionnaire 
	here.`
					this.selectedName1 = `You can find your responses to the
Qualitative Satisfaction Questionnaire 
here.`
				}
				if (currentTabName === BI_PSPB_BRQualitativefourteenweeksCompletedUrl) {
					this.mobilename = `You can find your responses to the
	Qualitative Satisfaction Questionnaire 
	here.`
					this.selectedName1 = `You can find your responses to the
Qualitative Satisfaction Questionnaire 
here.`
				}
				if (data?.length > 0) {
					this.content = true;
					this.contentdot = true;
					this.caregiver = true;
					this.selectedAvatarSrc = data[0]?.BI_PSP_AvatarUrl__c ? data[0]?.BI_PSP_AvatarUrl__c : Default_avatar_JPEG_URL;
					if (data[0]?.BI_PSP_AvatarUrl__c) {
						this.selectedAvatarSrc = data[0]?.BI_PSP_AvatarUrl__c
					}
					else {
						this.selectedAvatarSrc = Default_avatar_JPEG_URL;
					}

					// Get the pathname from the URL
					let pathname = window.location.pathname;
					if (pathname === brSiteUrl || pathname === '') {
						this.mobilename = `Select the patient you would like to 
	manage...`
						this.selectedName1 = `Select the patient you would like to 
manage: 

Once you have chosen the patient,you 
will represent the patient and perform
actions on their behalf. `

					}
					if (currentTabName === BI_PSPB_CompletedQuestionnaires) {
						this.selectedName1 = `You can find your responses to the DLQI
	questionnaire here. `
					}
					else if (error) {
						this.content = false;
					}

				}
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Apex
			}

		}
		else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from LWC
		}

	}


	//To fetch the PAtient details
	@wire(getLoggedInUserAccount)
	wiredUserAccounts({ error, data }) {
		//When a caregiver logs in, patient data will be null.
		if (data) {
			try {
				this.userAccounts = data;
				if (this.caregiver === false) {
					this.content = true;
					this.name = this.userAccounts.length > 0 ? this.userAccounts[0]?.Name : '';
					this.selectedAvatarSrc = this.userAccounts[0]?.BI_PSP_AvatarUrl__c ? this.userAccounts[0]?.BI_PSP_AvatarUrl__c : Default_avatar_JPEG_URL;
					const currentTabName = window.location.pathname.split('/').pop();
					// Get the pathname from the URL
					let pathname = window.location.pathname;
					if (pathname === brSiteUrl || pathname === '') {
						this.selectedName1 = `Let's take a moment to personalize your 
experience. . 
Choose an avatar best suits you `
					}
					if (currentTabName === BI_PSP_AvatarQuestionnaireUrl) {
						this.selectedName1 = `We want to learn more about you. 
Personalise your experience by 
answering a few simple questions 
about yourself.`
					}
					else if (currentTabName === BI_PSP_AvatarQuestionnaireTwoUrl) {
						this.selectedName1 = `We want to learn more about you. 
Personalise your experience by 
answering a few simple questions 
about yourself.`

					}
					else if (currentTabName === BI_PSPB_PatientMyProfileUrl) {
						this.selectedName1 = `Hi ${this.name}, you're doing great!
We appreciate you sharing, it will help 
us provide you with a better experience 
if we know more about you.

You can complete any missing personal 
information now!`
					}
					else if (currentTabName === BI_PSPB_symptomtrackergraphUrl) {
						this.mobilename = `This is your self-symptom tracker, which
	is where you can track..`;
						this.selectedName1 = `This is your self-symptom tracker, which
is where you can track your symptoms,
your flares, and their intensity over time.
You can show the self-symptom
tracker's results to your doctor to
discuss, understand, and improve your
situation.`;
					}
					else if (currentTabName === BI_PSPB_MyCaregiverUrl) {
						this.mobilename = `Your caregiver can help manage your 
	meds, appointments, and health info. Fill 
	out the details and click...`
						this.selectedName1 = `Your caregiver can help manage your 
meds, appointments, and health info. Fill 
out the details and click "grant access" 
to get started. They can stay informed 
about your health and keep you 
connected to your healthcare team.`

					}

					else if (currentTabName === BI_PSPB_PatientSelectAvatarUrl) {
						this.mobilename = `Choose your avatar!
	You're about to embark on ...`
						this.selectedName1 = `Choose your avatar!
You're about to embark on a journey 
and we want you to have a fun and 
engaging experience along the way. `
					}
					else if (currentTabName === BI_PSPB_PatientNotificationUrl) {
						this.mobilename = `Stay in the loop.
	By choosing your notification settings...`

						this.selectedName1 = `Stay in the loop.           
By choosing your notification settings, 
you can be sure to receive the 
information that is most important to 
you in the way that is most convenient 
for you. `
					}
					else if (currentTabName === BI_PSP_challengesURL) {

						const windowWidth = window.innerWidth;
						this.challangecontents = windowWidth < 601;
						if (this.challangecontents === true) {
							this.seperateChallenge = false;
							this.main = true;
							this.mobilename = `Conquer challenges that await you!
	On this page, you will find different...`;
							this.selectedName1 = `Conquer challenges that await you!
On this page, you will find different
challenges for you to complete and
continue to take control of your GPP.`
							this.selectedName3 = `You can track your status for each
challenge, gain experience points as
you complete them and level up to win
trophies. `

						}
						else {
							this.seperateChallenge = true;
							this.main = false;
							this.challangecontent = true;
							this.mobilename = `Conquer challenges that await you!

	On this page, you will find different...`;
							this.challengeName1 = `Conquer challenges that await you!`

							this.challengeName2 = `On this page, you will find different
	challenges for you to complete and
	continue to take control of your GPP. `

							this.selectedName3 = `You can track your status for each
challenge, gain experience points as
you complete them and level up to win
trophies. `
						}
					}
					else if (currentTabName === BI_PSPB_UpdatePrescriptionUrl) {
						this.mobilename = `Update your prescription status here!..`;
						this.selectedName1 = `Update your prescription status here!

Keep your prescription status updated
here to continue receiving product
related information and services.`;

					}

					else if (currentTabName === BI_PSPB_PrescriptionStatusUrl) {
						this.mobilename = `Need help filling these forms? Check
	out the support section..`;
						this.selectedName1 = `Need help filling these forms? Check
out the support section on the top right 
of this page.`;

					}
					else if (currentTabName === BI_PSP_trophyCaseURL) {
						this.seperateChallenge = true;
						this.main = false;
						this.mobilename = `Here's your trophy cupboard!
	See the trophies and badges you have......`
						this.challengeName1 = `Here's your trophy cupboard!`

						this.challengeName2 = `See the trophies and badges you have
collected along with a list of challenges
you have successfully completed. `


					} else if (currentTabName === BI_PSPB_BROutstandingQuestionnaireUrl) {
						this.mobilename = `Know Your Health, Download Results
	and Share with Your Doctor

	Learn more about your health...`
						this.selectedName1 = `Know Your Health, Download Results
and Share with Your Doctor

Learn more about your health and feel
confident talking to your doctor about it
with our science-based questionnaires.
By working together with your doctor,
you can create a treatment plan that is
tailored to your individual needs. 

Complete our scientific based 
questionnaires which allow you to track
your GPP symptoms as well as the 
impact that having GPP has on your
quality of life and your ability to work.`
						this.selectedName2 = `How did we do?

Please Share your feedback by 
completing our "Qualitative Satisfaction"
questionnaire.Your feedback will help
us better serve the GPP community 
in the future. `
					}

					else if (currentTabName === BI_PSPB_CompletedQuestionnaires) {
						this.mobilename = `You can find your responses to the DLQI
	questionnaire here.`
						this.selectedName1 = `You can find your responses to the DLQI
questionnaire here. `
					} else if (currentTabName === BI_PSPB_BR_LetsPersonalizeUrl) {
						this.mobilename = `We want to learn more about you.
	Personalize your experience by..`
						this.selectedName1 = `We want to learn more about you.
Personalize your experience by
answering a few simple questions about
yourself. `

					} else if (currentTabName === BI_PSPB_BRDlqiQuestionnaireUrl) {
						this.mobilename = `The DLQI is a specifically designed
	questionnaire. The aim ..`
						this.selectedName1 = `The DLQI is a specifically designed
questionnaire. The aim of this
questionnaire is to measure how much
your skin problem has affected your life 
OVER THE LAST WEEK. Please tick  one
box for each question. `
					} else if (currentTabName === BI_PSPB_BRPsoriasisQuesUrl) {
						this.mobilename = `On this page, are a set of problems that
	people with psoriasis have said are
	important. For each question...`
						this.selectedName1 = `On this page, are a set of problems that
people with psoriasis have said are
important. For each question, click on
the circle that best describes the
severity of your symptoms during the
past 24 hours. Please answer every
question. `
					} else if (currentTabName === BI_PSPB_BRWapiQuestionnaire) {
						this.mobilename = `Work Productivity and Activity
	Impairment Questionnaire (WPAI...`
						this.selectedName1 = `Work Productivity and Activity
Impairment Questionnaire (WPAI)

This WPAI questionnaire is a self-report
questionnaire that measures the impact
of generalized pustular psoriasis (GPP)
on work productivity and activity
impairment.

Questions on this page ask about how
your GPP affects your ability to work
and perform regular activities. `
					} else if (currentTabName === BI_PSPB_BRQualitativeTwoMonths) {
						this.mobilename = `Qualitative Satisfaction Questionnaire

	The aim of this questionnaire is to
	capture your feedback..`
						this.selectedName1 = `Qualitative Satisfaction Questionnaire

The aim of this questionnaire is to
capture your feedback on the
experience you had in the last fourteen
weeks of interactions with the GPP&ME
program. `
					} else if (currentTabName === BI_PSPB_messagecenterUrl) {
						this.mobilename = `Welcome!
	You will find all your general
	notifications.. `
						this.selectedName1 = `Welcome!
You will find all your general
notifications about recent updates or
new materials here. Read on. `
					} else if (currentTabName === BI_PSPB_ActionUrl) {
						this.mobilename = `We need your response!

	Here are the notifications ...`
						this.selectedName1 = `We need your response!

Here are the notifications that you have
not responded to, yet.

We encourage you to check them out
and help us help you better. `
					} else if (currentTabName === BI_PSPB_HistoryUrl) {
						this.mobilename = `All your notifications!

	You will find all your past notifications...`
						this.selectedName1 = `All your notifications!

You will find all your past notifications
on this page - just in case you want to
check them again or see if you missed
something. `
					} else if (currentTabName === BI_PSPB_BRSupportPage) {
						this.mobilename = `Want to reach out to us?
	Here is the information on how to ..`
						this.selectedName1 = `Want to reach out to us?

Here is the information on how to reach
us in case of any questions or issue you
may be facing.
	`
					} else if (currentTabName === BI_PSPB_BRMIEPage) {
						this.mobilename = `Do you have a medical query?

	Share your Medical information...`
						this.selectedName1 = `Do you have a medical query?

Share your Medical Information 
questions here and we will get back to 
you.`
					}
					else if (currentTabName === BI_PSPB_BRRAEPage) {
						this.mobilename = `Want to report an adverse event?
	Use this form to report any..`
						this.selectedName1 = `Want to report an adverse event?

Use this form to report any suspected 
adverse reactions or any side effects 
and make sure to inform your doctor 
about then too.`
					} else if (currentTabName === BI_PSPB_BRPLSPage) {
						this.mobilename = `Facing an issue with platform? drop a
	note and we will fix it`
						this.selectedName1 = `Facing an issue with platform? drop a
note and we will fix it`
					} else if (currentTabName === BI_PSPB_ReminderUrl) {
						this.mobilename = `Set reminders!

	Use this page to record your treatment
	date ..`
						this.selectedName1 = `Set reminders!

Use this page to record your treatment
date and notify us on your preferred
advance notification time.

Set it and leave it to us!`
					} else if (currentTabName === BI_PSP_symptomTrackerLpUrl) {
						this.mobilename = `Your self symptom tracker is where you
	can enter and track your symptoms..`
						this.selectedName1 = `Your self symptom tracker is where you
can enter and track your symptoms to
have visibility about your condition, and
show it to your doctor.`
					} else if (currentTabName === BI_PSPB_SymptomTrackerMain) {
						this.mobilename = `Your self symptom tracker is where you
	can enter and track your symptoms to...`
						this.selectedName1 = `Your self symptom tracker is where you
can enter and track your symptoms to
have visibility about your condition, and
show it to your doctor. `
					} else if (currentTabName === BI_PSPB_BRWapiCompletedQuestionnaire) {
						this.mobilename = `You can find your responses to the WPAI 
	questionnaire here.`
						this.selectedName1 = `You can find your responses to the WPAI 
questionnaire here.`
					} else if (currentTabName === BI_PSPB_BRPsoriasisCompletedQuesUrl) {
						this.mobilename = `You can find your responses to the PSS
	questionnaire here.`
						this.selectedName1 = `You can find your responses to the PSS
questionnaire here.`
					} else if (currentTabName === BI_PSPB_BRDlqiCompletedUrl) {
						this.mobilename = `You can find your responses to the DLQI
	questionnaire here.`
						this.selectedName1 = `You can find your responses to the DLQI
questionnaire here.`
					}
					else if (currentTabName === BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl) {
						this.mobilename = `You can find your responses to the
	Qualitative Satisfaction Questionnaire 
	here.`
						this.selectedName1 = `You can find your responses to the
Qualitative Satisfaction Questionnaire 
here.`
					}
					else if (currentTabName === BI_PSPB_BRQualitativefourteenweeksCompletedUrl) {
						this.mobilename = `You can find your responses to the
	Qualitative Satisfaction Questionnaire 
	here..`
						this.selectedName1 = `You can find your responses to the
Qualitative Satisfaction Questionnaire 
here.`
					}
					else if (error) {
						this.content = false;
					}
				}
			}
			catch (err) {
				this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Apex
			}
		}
		else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from LWC
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