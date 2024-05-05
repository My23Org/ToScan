//To design the Navigation bar that contains the required menus and submenus
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex Classes
import getTaskCount from '@salesforce/apex/BI_PSPB_BellIconCount.getTaskCount';
import userDetails from '@salesforce/apex/BI_PSPB_LoginCtrl.userDetails';
import profileDetails from '@salesforce/apex/BI_PSPB_LoginCtrl.profileDetails';
import getCaregiverAccounts from '@salesforce/apex/BI_PSPB_PatientDetailsCtrl.getCaregiverAccounts';
import checkCommunityUsername from '@salesforce/apex/BI_PSPB_CommunityUsername.checkCommunityUsername';
import updateSwitchSelectedPatientID from '@salesforce/apex/BI_PSPB_PatientDetailsCtrl.updateSwitchSelectedPatientID';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getAssessmentCountsByCurrentUserName';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
//To get Current UserId
import Id from '@salesforce/user/Id';
//To import Static Resource
import sitelogo from '@salesforce/resourceUrl/BI_PSPB_SiteLogo';
import HmeIcon from '@salesforce/resourceUrl/BI_PSPB_Home_Icon';
import NotIcon from '@salesforce/resourceUrl/BI_PSPB_NotiIcon';
import MenIcon from '@salesforce/resourceUrl/BI_PSPB_MenuIcon';
import NotIconColor from '@salesforce/resourceUrl/BI_PSPB_NotIconColored';
import CroIcon from '@salesforce/resourceUrl/BI_PSP_CrossIcon';
import SIcon from '@salesforce/resourceUrl/BI_PSPB_SelectIcon';
import DIcon from '@salesforce/resourceUrl/BI_PSPB_downHeadIcon';
//To import Custom labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import systemAdminProfile from '@salesforce/label/c.BI_PSP_SystemAdminProfile';
import patientProfiles from '@salesforce/label/c.BI_PSP_PatientProfile';
import caregiverProfiles from '@salesforce/label/c.BI_PSPB_CaregiverProfile';
import brandedDevUIProfiles from '@salesforce/label/c.BI_PSP_BrandedDevUIProfile';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import brChallengesSiteUrl from '@salesforce/label/c.BI_PSP_challengesURL';
import allpostSiteUrl from '@salesforce/label/c.BI_PSPB_ChatterAllPost';
import chatterSignUpSiteUrl from '@salesforce/label/c.BI_PSP_ChatterSignUpUrl';
import infoCenterLandingPageSiteUrl from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
import brtrophyCaseSiteUrl from '@salesforce/label/c.BI_PSP_trophyCaseURL';
import symptomTrackerLpSiteUrl from '@salesforce/label/c.BI_PSP_symptomTrackerLpUrl';
import loginSiteUrl from '@salesforce/label/c.BI_PSP_loginUrl';
import outstandingQuestionnaireSiteUrl from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import supportPageSiteUrl from '@salesforce/label/c.BI_PSPB_BRSupportPage';
import iamHCPSiteUrl from '@salesforce/label/c.BI_PSPB_IamHCPUrl';
import iamPatientSiteUrl from '@salesforce/label/c.BI_PSPB_IamPatientUrl';
import chronicVideoPageSiteUrl from '@salesforce/label/c.BI_PSPB_chronicVideoPage';
import myCasesPageSiteUrl from '@salesforce/label/c.BI_PSPB_BRMyCasePage';
import myPostPageSiteUrl from '@salesforce/label/c.BI_PSPB_ChatterMyPost';
import followersPageSiteUrl from '@salesforce/label/c.BI_PSPB_ChatterFollower';
import followingPageSiteUrl from '@salesforce/label/c.BI_PSPB_ChatterFollowing';
import summaryPageSiteUrl from '@salesforce/label/c.BI_PSPB_BRSummaryUrl';
import letspersnoliseSiteUrl from '@salesforce/label/c.BI_PSPB_BR_LetsPersonalizeUrl';
import reminderSiteUrl from '@salesforce/label/c.BI_PSPB_ReminderUrl';
import updatePrescriptionSiteUrl from '@salesforce/label/c.BI_PSPB_UpdatePrescriptionUrl';
import prescriptionStatusSiteUrl from '@salesforce/label/c.BI_PSPB_PrescriptionStatusUrl';
import messagecenterSiteUrl from '@salesforce/label/c.BI_PSPB_messagecenterUrl';
import actionSiteUrl from '@salesforce/label/c.BI_PSPB_ActionUrl';
import historySiteUrl from '@salesforce/label/c.BI_PSPB_HistoryUrl';
import wapiCompletedQuesSiteUrl from '@salesforce/label/c.BI_PSPB_BRWapiCompletedQuestionnaire';
import dlqiCompletedQuesSiteUrl from '@salesforce/label/c.BI_PSPB_BRDlqiCompletedUrl';
import pssCompletedQuesSiteUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisCompletedQuesUrl';
import qsq1completedqueseSiteUrl from '@salesforce/label/c.BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl';
import qsq2completedqueseSiteUrl from '@salesforce/label/c.BI_PSPB_BRQualitativefourteenweeksCompletedUrl';
import patientMyProfileSiteUrl from '@salesforce/label/c.BI_PSPB_PatientMyProfileUrl';
import caregiverProfileSiteUrl from '@salesforce/label/c.BI_PSPB_BRCaregiverProfile';
import myCaregiverSiteUrl from '@salesforce/label/c.BI_PSPB_MyCaregiverUrl';
import patientSelectAvatarSiteUrl from '@salesforce/label/c.BI_PSPB_PatientSelectAvatarUrl';
import patientNotificationSiteUrl from '@salesforce/label/c.BI_PSPB_PatientNotificationUrl';
import caregiverPatientSiteUrl from '@salesforce/label/c.BI_PSPB_BRCaregiverPatient';
import caregiverSelectAvatarSiteUrl from '@salesforce/label/c.BI_PSPB_BRCaregiverSelectAvatar';
import caregiverNotificationSiteUrl from '@salesforce/label/c.BI_PSPB_BRCaregiverNotification';
import articlecategorySiteUrl from '@salesforce/label/c.BI_PSPB_BRarticlecategoryUrl';
import searchResultsSiteUrl from '@salesforce/label/c.BI_PSPB_BRSearchResults';
import detailedArticleSiteUrl from '@salesforce/label/c.BI_PSPB_BRDetailedArticle';
import symptomtrackergraphSiteUrl from '@salesforce/label/c.BI_PSPB_symptomtrackergraphUrl';
import symptomtrackermainpageSiteUrl from '@salesforce/label/c.BI_PSPB_symptomtrackermainpage';
import psoriasisQuesSiteUrl from '@salesforce/label/c.BI_PSPB_BRPsoriasisQuesUrl';
import wapiQuestionnaireSiteUrl from '@salesforce/label/c.BI_PSPB_BRWapiQuestionnaire';
import qualitativeTwoMonthsSiteUrl from '@salesforce/label/c.BI_PSPB_BRQualitativeTwoMonths';
import qualitativeFourteenWeeksSiteUrl from '@salesforce/label/c.BI_PSPB_BRQualitativeFourteenWeeks';
import dashboadSiteUrl from '@salesforce/label/c.BI_PSPB_Dashboad';
import medicalinformationenquirySiteUrl from '@salesforce/label/c.BI_PSPB_BRMIEPage';
import reportadverseeventSiteUrl from '@salesforce/label/c.BI_PSPB_BRRAEPage';
import platformsupportSiteUrl from '@salesforce/label/c.BI_PSPB_BRPLSPage';
import createpostSiteUrl from '@salesforce/label/c.BI_PSPB_createpostUrl';
import BI_PSPB_Acute from '@salesforce/label/c.BI_PSPB_Acute';
import BI_PSP_Unassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import BI_PSPB_SecureLogout from '@salesforce/label/c.BI_PSPB_SecureLogout';
import BI_PSPB_Questionnaires1 from '@salesforce/label/c.BI_PSPB_Questionnaires1';
import BI_PSPB_Questionnaires2 from '@salesforce/label/c.BI_PSPB_Questionnaires2';

export default class BiPspbNavBarQuestionnaire extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@track patientstatusval = '';
	@track showtreatvideo;
	@track showToLogin;
	@track accname;
	@track taskCount;
	@track showToLoginpatient = 'loginbtn';
	@track desiredUrl;
	//Global variables(without @track does not trigger automatic re-renders)
	results;
	isMenuOpen;
	patientAMlist;
	caregiverAMlist;
	userName;
	showNavDetails;
	userInfo;
	currentUserIfo;
	showCareGiverMenus;
	activeData;
	currentPageUrl;
	urlSegments;
	baseUrl;
	showChallenge;
	showSymptomTracker;
	showInformationCenter;
	showQuestionnaires;
	showHomeLine;
	showSupport;
	showCommunity;
	lastSegment;
	showPopup;
	showCommunitymenu;
	showChallengesmenu;
	showSupportmenu;
	showInformationCentermenu;
	showquestionnairemenu;
	showTabMenu;
	count;
	showuserSubmenu;
	showPrescriptionmenu;
	showNotificationCentermenu;
	showMobileMenuIcons;
	stwai;
	stpss;
	stdlq;
	stqsq;
	showMenu;
	showForHcpPat;
	showOnlyForHcp;
	notificationCount = 0;
	caregiverDeskMenu = false;
	patientDeskMenu = false;
	variable = true;
	userId = Id;
	downHeadIcon = DIcon;
	SelectIcon = SIcon;
	navlogo = sitelogo;
	HIcon = HmeIcon;
	NIcon = NotIcon;
	MenuIcon = MenIcon;
	NIconCol = NotIconColor;
	CrossIcon = CroIcon;
	acute = BI_PSPB_Acute;
	unAssigned = BI_PSP_Unassigned;
	questionnairePageone=BI_PSPB_Questionnaires1;
	questionnairepagetwo=BI_PSPB_Questionnaires2;
	//Custom label variables for navigation urls
	siteUrlBranded = brSiteUrl;
	siteChallengesUrlBranded = brChallengesSiteUrl;
	systemAdmininstrator = systemAdminProfile;
	patientProfile = patientProfiles;
	caregiverProfile = caregiverProfiles;
	brandedDevProfile = brandedDevUIProfiles;
	siteUrlAllPost = allpostSiteUrl;
	siteUrlchatterSignUp = chatterSignUpSiteUrl;
	siteUrlinfoCenterLandingPage = infoCenterLandingPageSiteUrl;
	siteTrophyCaseUrlBranded = brtrophyCaseSiteUrl;
	sitesymptomTrackerLpBranded = symptomTrackerLpSiteUrl;
	siteloginBranded = loginSiteUrl;
	siteoutstandingQuestionnaireBranded = outstandingQuestionnaireSiteUrl;
	sitesupportPageBranded = supportPageSiteUrl;
	IAMHCPURL = iamHCPSiteUrl;
	IAMPATIENTURL = iamPatientSiteUrl;
	CHRONICPATIENTURL = chronicVideoPageSiteUrl;
	MYCASESPAGEURL = myCasesPageSiteUrl;
	MYPOSTSITEURL = myPostPageSiteUrl;
	FOLLOWERSSITEURL = followersPageSiteUrl;
	FOLLOWINGSITEURL = followingPageSiteUrl;
	SUMMARYPAGESITEURL = summaryPageSiteUrl;
	LETSPERSNOLISEURL = letspersnoliseSiteUrl;
	REMINDERPAGEURL = reminderSiteUrl;
	UPDATEPRESCRIPTIONURL = updatePrescriptionSiteUrl;
	PRESCRIPTIONSTATUSURL = prescriptionStatusSiteUrl;
	MESSAGECENTERURL = messagecenterSiteUrl;
	ACTIONURL = actionSiteUrl;
	HISTORYURL = historySiteUrl;
	WAPICOMPLETEDQUESTIONURL = wapiCompletedQuesSiteUrl;
	DLQICOMPLETEDQUESTIONURL = dlqiCompletedQuesSiteUrl;
	PSSCOMPLETEDQUESTIONURL = pssCompletedQuesSiteUrl;
	QSQ1COMPLETEDQUESTIONURL = qsq1completedqueseSiteUrl;
	QSQ2COMPLETEDQUESTIONURL = qsq2completedqueseSiteUrl;
	PATIENTMYPROFILEURL = patientMyProfileSiteUrl;
	CAREGIVERPROFILEURL = caregiverProfileSiteUrl;
	MYCAREGIVERURL = myCaregiverSiteUrl;
	PATIENTSELECTAVATARURL = patientSelectAvatarSiteUrl;
	PATIENTNOTIFICATIONURL = patientNotificationSiteUrl;
	CAREGIVERPATINENTURL = caregiverPatientSiteUrl;
	CAREGIVERSELECTAVATARURL = caregiverSelectAvatarSiteUrl;
	CAREGIVERNOTIFICATIONURL = caregiverNotificationSiteUrl;
	ARTICLECATEGORUURL = articlecategorySiteUrl;
	SEARCHRESULTSURL = searchResultsSiteUrl;
	DETAILEDARTICLEURL = detailedArticleSiteUrl;
	SYMPTOMTRACKERGRAPHURL = symptomtrackergraphSiteUrl;
	SYMPTOMTRACKERMAINPAGEURL = symptomtrackermainpageSiteUrl;
	PSORIASISQUESTIONNAIREURL = psoriasisQuesSiteUrl;
	WAPIQUESTIONNAIREURL = wapiQuestionnaireSiteUrl;
	QUALITATIVETWOMONTHSURL = qualitativeTwoMonthsSiteUrl;
	QUALITATIVEFOURTEENWEEKSSURL = qualitativeFourteenWeeksSiteUrl;
	DASHBOARDPAGEURL = dashboadSiteUrl;
	MEDICALINFORMATIONENQUIRYURL = medicalinformationenquirySiteUrl;
	REPORTADVERSEEVENTURL = reportadverseeventSiteUrl;
	PLATFORMSUPPORTPAGEURL = platformsupportSiteUrl;
	CREATEPOSTPAGEURL = createpostSiteUrl;
	SECURELOGOUT = BI_PSPB_SecureLogout;

	//This wire method is used to fetch the relative enrolle detials of the current user
	@wire(getEnrolle, { userId: '$userId' })
	wiredGetEnrolle({ error, data }) {// Null check has been handled in its respective apex method
		if (data) {
			try {
				if (data[0].patientEnrolle) {
					this.accname = data[0].patientEnrolle.Id;
				} else if (data[0].error) {
					this.showError = true;
					this.errorMessage = data[0].error;
				}
			} catch (err) {
				// Handle error
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}

	//This wire method is used to get the task count for the current logged in user
	@wire(getTaskCount, { accountId: '$accname' })
	wiredTaskCount({ error, data }) {
		if (data && data !== null) {
			try {
				this.taskCount = data;
			}
			catch (err) {
				// Handle error
				this.showToast(errormessage, err.message, errorvariant);
			}
		} else if (error) {
			this.showToast(errormessage, error.body.message, errorvariant);
		}
	}

	//Used to get information regarding the loggedin caregiver
	patientInfo() {
		getCaregiverAccounts({ userId: Id })
			.then(patient => {//Null check has been handled in the respective apex method.
				this.activeData = patient;
				if (this.activeData.length > 0) {
					this.showCareGiverMenus = true
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	//Navigation
	openUpdatePrescription() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.UPDATEPRESCRIPTIONURL);
	}
	//Used to get the user and profile information of the current loggedin user to render the navigation bar details.
	connectedCallback() {
		try {
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split('/');
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
			const regex = /\/([^/?#]+)(?:\?.*|)$/i;
			const match = regex.exec(this.currentPageUrl);
			this.lastSegment = match && match[1];
			if (this.lastSegment !== null && this.lastSegment !== '') {
				this.showUnderlineforMenus();
			}
			else {
				this.showHomeLine = true;
			}
			if (Id !== null && Id !== undefined) {
				
				userDetails({ userId: Id })
					.then(user => { // Null check for user record has been handled in its respective apex method.
						this.fetchAssessmentCount();
						this.currentUserIfo = user;
						if (this.currentUserIfo.BI_PSPB_Caregiver__c === true) {
							this.patientInfo();
						}
						this.userName = user.FirstName + ' ' + user.LastName;
						profileDetails({ profileId: user.ProfileId })
							.then(profile => { // Null check for user record has been handled in its respective apex method.
								this.userInfo = profile;
								if (this.userInfo.Name === this.systemAdmininstrator || this.userInfo.Name === this.patientProfile || this.userInfo.Name === this.caregiverProfile) {
									if (this.lastSegment != null && this.lastSegment !== '') {
										if (
											this.lastSegment === this.questionnairePageone ||
											this.lastSegment === this.questionnairepagetwo
										) {
											this.showMenu = false;
										} else {
											this.showMenu = true;
										}
									} else {
										this.showMenu = true;
									}
									this.retrievePatientStatus();
									this.showMenu = true;
									this.showNavDetails = true;
									this.showToLogin = false;
									this.showMobileMenuIcons = true;
									if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
										this.caregiverDeskMenu = false;
										this.patientDeskMenu = true;
									}
									else {
										this.caregiverDeskMenu = true;
										this.patientDeskMenu = false;
									}
								}
								else if (this.userInfo.Name === this.brandedDevProfile) {
									this.showMenu = false;
									this.showNavDetails = false;
									this.showToLogin = true;
								}

							})
							.catch(error => {
								this.showToast(errormessage, error.message, errorvariant);
							})
					})
					.catch(error => {
						this.showToast(errormessage, error.message, errorvariant);
					})
			} else {
				this.showMenu = false;
				this.showNavDetails = false;
				this.variable = false;
				this.showMobileMenuIcons = false;
				const currentTabName = window.location.pathname.split('/').pop();
				if (currentTabName === this.IAMHCPURL) {
					this.showToLogin = false;
				} else {
					this.showToLogin = true;
				}
				if (currentTabName === this.IAMHCPURL || currentTabName === this.IAMPATIENTURL) {
					this.showForHcpPat = true;
				} else {
					this.showForHcpPat = false;
				}
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}

	//This wire method is used to get the patient information of the current logged in user
	retrievePatientStatus() {
		Patientstatus({ userId: '$userId' })
			.then(result => {// Null check for user record has been handled in its respective apex method.
				if(result && result !== null){
				this.patientStatusVal = result;
				this.handlePatientStatus();
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//Used for rendering the modules according to the patient information
	handlePatientStatus() {
		if (this.patientStatusVal === this.acute) {
			this.showTreatVideo = true;
		} else if (this.patientStatusVal === this.unAssigned) {
			this.showTreatVideo = false;
		} else {
			this.showTreatVideo = true;
		}
	}

	// This method is used t collect the assessment deatils.
	fetchAssessmentCount() {
		countAssessment()
			.then(result => {
				if (result && result.length > 0) {
					this.count = result;
					if (this.count[0] !== 0 || this.count[1] !== 0 || this.count[2] !== 0 || this.count[3] !== 0) {
						this.showTabMenu = true;
						this.stwai = this.count[0];
						this.stpss = this.count[1];
						this.stdlq = this.count[2];
						this.stqsq = this.count[3];
					}
					else {
						this.showTabMenu = false;
					}
				}
				else {
					this.showTabMenu = false;
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant);
				this.showTabMenu = false;
			});
	}
	//This method is used to identify the current page and renders the highliged bar for menus
	showUnderlineforMenus() {
		if (this.lastSegment) {
			if (this.lastSegment === this.siteChallengesUrlBranded || this.lastSegment === this.siteTrophyCaseUrlBranded) {
				this.showChallenge = true;
			}
			else if (this.lastSegment === this.siteUrlinfoCenterLandingPage || this.lastSegment === this.ARTICLECATEGORUURL || this.lastSegment === this.SEARCHRESULTSURL || this.lastSegment === this.DETAILEDARTICLEURL) {
				this.showInformationCenter = true;
			}
			else if (this.lastSegment === this.sitesymptomTrackerLpBranded || this.lastSegment === this.SYMPTOMTRACKERGRAPHURL || this.lastSegment === this.SYMPTOMTRACKERMAINPAGEURL) {
				this.showSymptomTracker = true;
			}
			else if (this.lastSegment === this.siteoutstandingQuestionnaireBranded || this.lastSegment === this.SUMMARYPAGESITEURL || this.lastSegment === this.DLQICOMPLETEDQUESTIONURL || this.lastSegment === this.LETSPERSNOLISEURL || this.lastSegment === this.PSORIASISQUESTIONNAIREURL || this.lastSegment === this.WAPIQUESTIONNAIREURL || this.lastSegment === this.QUALITATIVETWOMONTHSURL || this.lastSegment === this.QUALITATIVEFOURTEENWEEKSSURL || this.lastSegment === this.WAPICOMPLETEDQUESTIONURL || this.lastSegment === this.DLQICOMPLETEDQUESTIONURL || this.lastSegment === this.PSSCOMPLETEDQUESTIONURL || this.lastSegment === this.QSQ1COMPLETEDQUESTIONURL || this.lastSegment === this.QSQ2COMPLETEDQUESTIONURL) {
				this.showQuestionnaires = true;
			}
			else if (this.lastSegment === this.DASHBOARDPAGEURL) {
				this.showHomeLine = true;
			}
			else if (this.lastSegment === this.sitesupportPageBranded || this.lastSegment === this.MEDICALINFORMATIONENQUIRYURL || this.lastSegment === this.REPORTADVERSEEVENTURL || this.lastSegment === this.PLATFORMSUPPORTPAGEURL || this.lastSegment === this.MYCASESPAGEURL) {
				this.showSupport = true;
			}
			else if (this.lastSegment === this.siteUrlAllPost || this.lastSegment === this.siteUrlchatterSignUp || this.lastSegment === this.MYPOSTSITEURL || this.lastSegment === this.CREATEPOSTPAGEURL || this.lastSegment === this.FOLLOWERSSITEURL || this.lastSegment === this.FOLLOWINGSITEURL) {
				this.showCommunity = true;
			}
			else {
				this.showChallenge = false;
				this.showInformationCenter = false;
				this.showSymptomTracker = false;
				this.showQuestionnaires = false;
				this.showHomeLine = false;
				this.showSupport = false;
				this.showCommunity = false;
			}
		}
	}
	//Used to decide the Navigation for community chatter
	openCommunity() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check for user record has been handled in its respective apex method.
				if (result === true) {
					window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteUrlAllPost);
				}
				if (result === false) {
					window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			})
	}
	//Navigation for Caregiver/Patient
	userNavigation() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.PATIENTMYPROFILEURL);
		}
		else {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.CAREGIVERPROFILEURL);
		}
	}
	userNavigationMyprofile() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.PATIENTMYPROFILEURL);
		}
		else {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.CAREGIVERPROFILEURL);
		}
	}
	userNavigationMyCaregiver() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.MYCAREGIVERURL);
		} else {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.CAREGIVERPATINENTURL);
		}
	}
	userNavigationSelectAvatar() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.PATIENTSELECTAVATARURL);
		} else {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.CAREGIVERSELECTAVATARURL);
		}
	}
	userNavigationNotSettings() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.PATIENTNOTIFICATIONURL);
		} else {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.CAREGIVERNOTIFICATIONURL);
		}
	}
	//Navigation
	checkUser() {
		this.showToLogin = false;
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteloginBranded);
	}
	openInformationCenter() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteUrlinfoCenterLandingPage);
	}
	openhome() {
		window.location.assign(this.baseUrl + this.siteUrlBranded);
	}
	openChallenges() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteChallengesUrlBranded);
	}
	openTrophycase() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteTrophyCaseUrlBranded);
	}
	openQuestions() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteoutstandingQuestionnaireBranded);
	}
	//Used to render the components
	openQuestions2() {
		this.showMenu = false;
		this.showquestionnairemenu = true;
	}
	openSupport2() {
		this.showMenu = false;
		this.showSupportmenu = true;
	}
	openchalenges2() {
		this.showMenu = false;
		this.showChallengesmenu = true;
	}
	openInformationCenter2() {
		this.showMenu = false;
		this.showInformationCentermenu = true;
	}
	openCommunities() {
		this.showMenu = false;
		this.showCommunitymenu = true;
	}
	//Navigation
	openSymptomTracker() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.sitesymptomTrackerLpBranded);
	}
	openSupport() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.sitesupportPageBranded);
	}
	logoutFunc() {
		this.showPopup = true;
	}
	doNotLogout() {
		this.showPopup = false;
	}
	//This method is used for logout functionality
	logoutfromSite() {
		this.showPopup = false;
		let currentUrl = window.location.href;
		let urlParts = currentUrl.split('/');
		let index = urlParts.indexOf('s');
		if (index !== -1) {
			this.desiredUrl = urlParts.slice(0, index + 1).join('/');
		}
		if (this.activeData !== null && this.activeData !== undefined) {
			updateSwitchSelectedPatientID({ UserID: this.activeData[0].CaregiveID, SelectedAccountId: null, check: false }) // Use newAvatarSrc
				.then(result => {
					window.location.assign(this.desiredUrl.replace(/\/s/g, '/') + this.SECURELOGOUT + this.desiredUrl);
					this.results = result;
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);
				});
		}
		else if (this.userInfo.Name === this.patientProfile || this.userInfo.Name === this.systemAdmininstrator) {
			window.location.assign(this.desiredUrl.replace(/\/s/g, '/') + this.SECURELOGOUT + this.desiredUrl);
		}
	}
	//Navigation
	openMyProfile() {
		window.location.assign(this.baseUrl + this.siteUrlBranded);
	}
	//used for rendering the components
	openMobMenu() {
		
if (this.lastSegment != null && this.lastSegment !== '') {
			if (
				this.lastSegment === this.questionnairePageone ||
				this.lastSegment === this.questionnairepagetwo
			) {
				this.isMenuOpen = false;
			} else {
				this.isMenuOpen = true;
			}
		} else {
			this.isMenuOpen = true;
		}

		this.isMenuOpen = true;
		this.caregiverAMlist = false;
		this.patientAMlist = false;
	}
	closeMobMenu() {
		this.isMenuOpen = false;
		this.showMenu = true;
	}
	openAMlist() {
		this.caregiverAMlist = true;
		this.showMenu = false;
		this.isMenuOpen = false;
	}
	userMenuNavigation() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			this.caregiverAMlist = false;
			this.patientAMlist = true;
			this.showMenu = false;
			this.showuserSubmenu = false;
		}
		else {
			this.caregiverAMlist = true;
			this.patientAMlist = false;
			this.showMenu = false;
			this.showuserSubmenu = false;
		}
	}
	/*   Patient Community SubMenu */
	openAllPosts() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check for user record has been handled in its respective apex method.
				if (result === true) {
					window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteUrlAllPost);
				}
				if (result === false) {
					window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	openMyPosts() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check for user record has been handled in its respective apex method.
				if (result === true) {
					window.location.assign(this.baseUrl + this.siteUrlBranded + this.MYPOSTSITEURL);
				}
				if (result === false) {
					window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	openMyFollowers() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check for user record has been handled in its respective apex method.
				if (result === true) {
					window.location.assign(this.baseUrl + this.siteUrlBranded + this.FOLLOWERSSITEURL);
				}
				if (result === false) {
					window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	openFollowing() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check for user record has been handled in its respective apex method.
				if (result !== null) {
					if (result === true) {
						window.location.assign(this.baseUrl + this.siteUrlBranded + this.FOLLOWINGSITEURL);
					}
					if (result === false) {
						window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp);
					}
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	/*showquestionnairemenu links*/
	openoutstandingquestionnaire() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteoutstandingQuestionnaireBranded);
	}
	opensummary() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.SUMMARYPAGESITEURL);
	}
	opencompletedquestionnaire() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.DLQICOMPLETEDQUESTIONURL);
	}
	openletspersonalize() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.LETSPERSNOLISEURL);
	}
	handleback() {
		this.showMenu = true;
		this.showquestionnairemenu = false;
	}
	handlebackCommunity() {
		this.showMenu = true;
		this.showCommunitymenu = false;
	}
	handlebackChallenges() {
		this.showMenu = true;
		this.showChallengesmenu = false;
	}
	handlebackSupport() {
		this.showMenu = true;
		this.showSupportmenu = false;
	}
	handlebackInformationCenter() {
		this.showMenu = true;
		this.showInformationCentermenu = false;
	}
	/*--Patient Profile Links--*/
	openPatMyProfile() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.PATIENTMYPROFILEURL);
	}
	openPatMyCaregiver() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.MYCAREGIVERURL);
	}
	openPatSelectAvatar() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.PATIENTSELECTAVATARURL);
	}
	openPatNotSettings() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.PATIENTNOTIFICATIONURL);
	}
	/*--Patient Profile Links Ends--*/

	/*--Caregiver Profile Links--*/
	openCarMyProfile() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.CAREGIVERPROFILEURL);
	}
	openCarMyCaregiver() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.CAREGIVERPATINENTURL);
	}
	openCarSelectAvatar() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.CAREGIVERSELECTAVATARURL);
	}
	openCarNotSettings() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.CAREGIVERNOTIFICATIONURL);
	}
	openCarNotSettings1() {
		window.location.assign(this.baseUrl + + this.siteUrlBranded + this.MESSAGECENTERURL);
	}
	/*--Caregiver Profile Links Ends--*/

	openArticles() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.siteUrlinfoCenterLandingPage);
	}
	openPTV() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.CHRONICPATIENTURL);
	}
	openSupportCenter() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.sitesupportPageBranded);
	}
	openMyCases() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.MYCASESPAGEURL);
	}
	updatePrescriptionLink() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.UPDATEPRESCRIPTIONURL);
	}
	prescriptionStatusLink() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.PRESCRIPTIONSTATUSURL);
	}
	openTreatmentRemaindersLink() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.REMINDERPAGEURL);
	}
	openGeneralNC() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.MESSAGECENTERURL);
	}
	openActionRequiredNC() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.ACTIONURL);
	}
	openHistoryNC() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.HISTORYURL);
	}
	//Used to render the components
	backtoMenu() {
		this.caregiverAMlist = false;
		this.patientAMlist = false;
		this.showMenu = false;
		this.showuserSubmenu = true;
	}
	backtoMainMenu() {
		this.showMenu = true;
		this.caregiverAMlist = false;
		this.patientAMlist = false;
		this.showuserSubmenu = false;
		this.showPrescriptionmenu = false;
		this.showNotificationCentermenu = false;
	}
	backtohomeMenu() {
		this.caregiverAMlist = false;
		this.patientAMlist = false;
		this.showMenu = false;
		this.showuserSubmenu = true;
		this.showPrescriptionmenu = false;
		this.showNotificationCentermenu = false;
	}
	openUserDetailmenu() {
		this.showMenu = false;
		this.showuserSubmenu = true;
	}
	openUpdatePrescriptionMenu() {
		this.showPrescriptionmenu = true;
		this.showuserSubmenu = false;
		this.showMenu = false;
	}
	openNotificationCenterMenu() {
		this.showNotificationCentermenu = true;
		this.showuserSubmenu = false;
		this.showMenu = false;
	}
	//Used to render the components
	openComQuestionnaires() {
		if (this.stdlq > 0) {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.DLQICOMPLETEDQUESTIONURL);
		}
		else if (this.stpss > 0) {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.PSSCOMPLETEDQUESTIONURL);
		}
		else if (this.stwai > 0) {
			window.location.assign(this.baseUrl + this.siteUrlBranded + this.WAPICOMPLETEDQUESTIONURL);
		}
		else if (this.stqsq > 0) {
			if (this.targetDate14 !== null) {
				window.location.assign(this.baseUrl + this.siteUrlBranded + this.QSQ2COMPLETEDQUESTIONURL);
			}
			else {
				window.location.assign(this.baseUrl + this.siteUrlBranded + this.QSQ1COMPLETEDQUESTIONURL);
			}
		}
	}
	// showToast used for all the error messages caught
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}