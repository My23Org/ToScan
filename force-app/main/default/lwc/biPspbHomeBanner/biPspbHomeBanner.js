//This LWC is designed for Account Manager which contains the profile details, avatar settings, notification settings and for logout functinality
//To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// Imports resourceUrl to reference external resources for proper rendering and functionality.
import sitelogo from '@salesforce/resourceUrl/BI_PSPB_SiteLogo';
import HmeIcon from '@salesforce/resourceUrl/BI_PSPB_Home_Icon';
import NotIcon from '@salesforce/resourceUrl/BI_PSPB_NotiIcon';
import MenIcon from '@salesforce/resourceUrl/BI_PSPB_MenuIcon';
import NotIconColor from '@salesforce/resourceUrl/BI_PSPB_NotIconColored';
import BannerImg from '@salesforce/resourceUrl/BI_PSPB_BannerImage';
import CroIcon from '@salesforce/resourceUrl/BI_PSP_CrossIcon';
import SIcon from '@salesforce/resourceUrl/BI_PSPB_SelectIcon';
import DIcon from '@salesforce/resourceUrl/BI_PSPB_downHeadIcon';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
import Id from '@salesforce/user/Id';
// Importing Apex classes to interact with Salesforce backend for data retrieval.
import userDetails from '@salesforce/apex/BI_PSPB_LoginCtrl.userDetails';
import profileDetails from '@salesforce/apex/BI_PSPB_LoginCtrl.profileDetails';
import getCaregiverAccounts from '@salesforce/apex/BI_PSPB_PatientDetailsCtrl.getCaregiverAccounts';
import checkCommunityUsername from '@salesforce/apex/BI_PSPB_CommunityUsername.checkCommunityUsername';
import updateSwitchSelectedPatientID from '@salesforce/apex/BI_PSPB_PatientDetailsCtrl.updateSwitchSelectedPatientID';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getAssessmentCountsByCurrentUserName';
import getUnreadCases from '@salesforce/apex/BI_PSPB_LoginCtrl.getUnreadCases';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
// Imports labels for descriptive text or identifiers, enhancing accessibility and user understanding.
import systemAdminProfile from '@salesforce/label/c.BI_PSP_SystemAdminProfile';
import patientProfiles from '@salesforce/label/c.BI_PSP_PatientProfile';
import caregiverProfiles from '@salesforce/label/c.BI_PSPB_CaregiverProfile';
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import brChallengesSiteUrl from '@salesforce/label/c.BI_PSP_challengesURL';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
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
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import expired from '@salesforce/label/c.BI_PSP_Expired';
export default class BiPspbHomeBanner extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@track showToLogin;
	@track activeData;
	@track desiredUrl;
	//Global variables(without @track does not trigger automatic re-renders)
	showWithoutMenu;
	siteUrlBranded = brSiteUrl;
	siteChallengesUrlBranded = brChallengesSiteUrl;
	systemAdmininstrator = systemAdminProfile;
	patientProfile = patientProfiles;
	caregiverProfile = caregiverProfiles;
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
	BGpp = BGpp;
	downHeadIcon = DIcon;
	BannerImgae = BannerImg;
	SelectIcon = SIcon;
	caregiverAMlist;
	isMenuOpen;
	openwithoutMenu;
	patientDashboardPage;
	navlogo = sitelogo;
	showMenu;
	HIcon = HmeIcon;
	NIcon = NotIcon;
	MenuIcon = MenIcon;
	NIconCol = NotIconColor;
	CrossIcon = CroIcon;
	showNavDetails;
	primaryLandingPage;
	userName;
	caregiver;
	patient;
	userInfo;
	currentUserIfo;
	patientOrCare;
	showCareGiverMenus;
	caregiverDeskMenu = false;
	patientDeskMenu = false;
	showPopup;
	showCommunitymenu;
	showChallengesmenu;
	showSupportmenu;
	showInformationCentermenu;
	showquestionnairemenu;
	currentPageUrl;
	urlSegments;
	baseUrl;
	showTabMenu;
	stwai;
	stpss;
	stdlq;
	stqsq;
	count;
	showuserSubmenu;
	showPrescriptionmenu;
	showNotificationCentermenu;
	notificationCount = 0;
	showforNotLoggedIn;
	//Qualitative Date for topbar navigation
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
		if (error) {
			this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		} else if (data) {
			this.threeMonthsVar = data.threeMonthsVar;
			this.forteenWeeks = data.forteenWeeks;
			this.target2monthsdate = data.target2monthsdate ?? null;
			this.target14wksdate = data.target14wksdate ?? null;
		}
		} catch (err) {
		this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}
	//Used to get the notification count using task
	taskInfo(id) {
		getUnreadCases({ userId: id })
			.then((user) => {//Null check has been handled in the respective apex method.
					this.notificationCount = user.length;
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//Used to get information regarding the loggedin caregiver
	patientInfo() {
		getCaregiverAccounts({ userId: Id })
			.then((patient) => {//Null check has been handled in the respective apex method.
					this.activeData = patient;
					if (this.activeData.length > 0) {
						this.showCareGiverMenus = true;
						this.updateFalse(false);
					}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//Used to get the user and profile information of the current loggedin user to render the components according to the details.
	connectedCallback() {
		try{
		this.currentPageUrl = window.location.href;
		this.urlSegments = this.currentPageUrl.split("/");
		this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
		if (Id != null || Id !== undefined) {
			this.taskInfo(Id);
			userDetails({ userId: Id })
				.then((user) => { // Null check for user record has been handled in its respective apex method.
					this.fetchAssessmentCount();
					this.currentUserIfo = user;
					if (this.currentUserIfo.BI_PSPB_Caregiver__c === true) {
						this.patientInfo();
					}
					this.userName = user.FirstName + '' + user.LastName;
					profileDetails({ profileId: user.ProfileId })
						.then((profile) => {// Null check for user record has been handled in its respective apex method.
							this.userInfo = profile;
							if (
								this.userInfo.Name === this.systemAdmininstrator ||
								this.userInfo.Name === this.patientProfile ||
								this.userInfo.Name === this.caregiverProfile
							) {
								this.showMenu = true;
								this.showNavDetails = true;
								this.patientDashboardPage = true;
								this.showWithMenu = false;
								if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
									this.showWithMenu = true;
									this.patientOrCare = true;
									this.caregiverDeskMenu = false;
									this.patientDeskMenu = true;
									this.showWithoutMenu = false;
									this.showforNotLoggedIn = false;
								} else {
									this.patientOrCare = false;
									this.caregiverDeskMenu = true;
									this.patientDeskMenu = false;
									this.showWithoutMenu = true;
									this.showWithMenu = false;
									this.showforNotLoggedIn = false;
								}
								this.primaryLandingPage = false;
								this.showToLogin = false;
								this.showforNotLoggedIn = false;
							} else {
								this.showMenu = false;
								this.showNavDetails = false;
								this.patientDashboardPage = false;
								this.primaryLandingPage = true;
								this.showToLogin = true;
								this.showWithoutMenu = false;
								this.showWithMenu = false;
								this.showforNotLoggedIn = true;
							}
						})
						.catch((error) => {
							this.showToast(errormessage, error.message, errorvariant);
						});
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant);
				});
		} else {
			this.showMenu = false;
			this.showNavDetails = false;
			this.patientDashboardPage = false;
			this.primaryLandingPage = true;
			this.showToLogin = true;
			this.showWithoutMenu = false;
			this.showWithMenu = false;
			this.showforNotLoggedIn = true;
		}
		}
		catch(error){
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	// This method is used t collect the assessment deatils.
	fetchAssessmentCount() {
		countAssessment()
			.then((result) => {
				if (result && result.length > 0) {
					this.count = result;
					if (
						this.count[0] !== 0 ||
						this.count[1] !== 0 ||
						this.count[2] !== 0 ||
						this.count[3] !== 0
					) {
						this.showTabMenu = true;
						this.stwai = this.count[0];
						this.stpss = this.count[1];
						this.stdlq = this.count[2];
						this.stqsq = this.count[3];
					} else {
						this.showTabMenu = false;
					}
				} else {
					this.showTabMenu = false;
				}
			})
			.catch((error) => {
				this.showTabMenu = false;
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//Used to decide the Navigation for community chatter
	openCommunity() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check has been handled in its respective apex method
					if (result === true) {
						window.location.assign(
							this.baseUrl + this.siteUrlBranded + this.siteUrlAllPost
						);
					}
					if (result === false) {
						window.location.assign(
							this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp
						);
					}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//Navigation
	openInformationCenter() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.siteUrlinfoCenterLandingPage
		);
	}
	openChallenges() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.siteChallengesUrlBranded
		);
	}
	openTrophycase() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.siteTrophyCaseUrlBranded
		);
	}
	//Used to render the components
	openchalenges2() {
		this.showMenu = false;
		this.showChallengesmenu = true;
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
	handleback() {
		this.showMenu = true;
		this.showquestionnairemenu = false;
	}
	//Navigation
	openSymptomTracker() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.sitesymptomTrackerLpBranded
		);
	}
	//Navigation for Caregiver/Patient
	userNavigation() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.PATIENTMYPROFILEURL
			);
		} else {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.CAREGIVERPROFILEURL
			);
		}
	}
	userNavigationMyprofile() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.PATIENTMYPROFILEURL
			);
		} else {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.CAREGIVERPROFILEURL
			);
		}
	}
	userNavigationMyCaregiver() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.MYCAREGIVERURL
			);
		} else {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.CAREGIVERPATINENTURL
			);
		}
	}
	userNavigationSelectAvatar() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.PATIENTSELECTAVATARURL
			);
		} else {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.CAREGIVERSELECTAVATARURL
			);
		}
	}
	userNavigationNotSettings() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.PATIENTNOTIFICATIONURL
			);
		} else {
			window.location.assign(
				this.baseUrl + this.siteUrlBranded + this.CAREGIVERNOTIFICATIONURL
			);
		}
	}
	//Navigation
	openUpdatePrescription() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.UPDATEPRESCRIPTIONURL
		);
	}
	checkUser() {
		this.showToLogin = false;
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.siteloginBranded
		);
	}
	openhome() {
		window.location.assign(this.baseUrl + this.siteUrlBranded);
	}
	openQuestions() {
		window.location.assign(
			this.baseUrl +
			this.siteUrlBranded +
			this.siteoutstandingQuestionnaireBranded
		);
	}
	//Used to render the components
	openCommunities() {
		this.showMenu = false;
		this.showCommunitymenu = true;
	}
	openInformationCenter2() {
		this.showMenu = false;
		this.showInformationCentermenu = true;
	}
	handlebackCommunity() {
		this.showMenu = true;
		this.showCommunitymenu = false;
	}
	//Navigation
	openSupport() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.sitesupportPageBranded
		);
	}
	//Used to render the components
	openSupport2() {
		this.showMenu = false;
		this.showSupportmenu = true;
	}
	openQuestions2() {
		this.showMenu = false;
		this.showquestionnairemenu = true;
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
			this.updateFalse(true);
		}
	}
	//This method is used for logout functionality
	updateFalse(navigation) {
		if (this.activeData.length > 0 && this.activeData !== undefined) {
			updateSwitchSelectedPatientID({
				UserID: this.activeData[0].CaregiveID,
				SelectedAccountId: null,
				check: false
			}) // Use newAvatarSrc
				.then(() => {// Null check has been handled in its respective apex method
					if (navigation === true) {
						window.location.assign(
							this.desiredUrl.replace(/\/s/g, '/') +
							'/secur/logout.jsp?retUrl=' +
							this.desiredUrl
						);
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant);
				});
		} else if (
			this.userInfo.Name === this.patientProfile ||
			this.userInfo.Name === this.systemAdmininstrator
		) {
			window.location.assign(
				this.desiredUrl.replace(/\/s/g, '/') +
				'/secur/logout.jsp?retUrl=' +
				this.desiredUrl
			);
		}
	}
	//Navigation
	openMyProfile() {
		window.location.assign(this.baseUrl + this.siteUrlBranded);
	}
	openHCPpage() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.IAMHCPURL);
	}
	openPATpage() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.IAMPATIENTURL
		);
	}
	//Used to render the components
	openMobMenu() {
		this.isMenuOpen = true;
		this.caregiverAMlist = false;
		this.patientAMlist = false;
		this.openwithoutMenu = false;
	}
	openMobWithoutMenu() {
		this.isMenuOpen = false;
		this.caregiverAMlist = false;
		this.patientAMlist = false;
		this.openwithoutMenu = true;
	}
	closeMobMenu() {
		this.isMenuOpen = false;
		this.showMenu = true;
		this.openwithoutMenu = false;
	}
	openAMlist() {
		this.caregiverAMlist = true;
		this.showMenu = false;
		this.openwithoutMenu = false;
	}
	userMenuNavigation() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			this.caregiverAMlist = false;
			this.patientAMlist = true;
			this.showMenu = false;
			this.showuserSubmenu = false;
			this.openwithoutMenu = false;
		} else {
			this.caregiverAMlist = true;
			this.patientAMlist = false;
			this.showMenu = false;
			this.showuserSubmenu = false;
			this.openwithoutMenu = false;
		}
	}
	/*--Patient Profile Links--*/
	openPatMyProfile() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.PATIENTMYPROFILEURL
		);
	}
	openPatMyCaregiver() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.MYCAREGIVERURL
		);
	}
	openPatSelectAvatar() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.PATIENTSELECTAVATARURL
		);
	}
	openPatNotSettings() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.PATIENTNOTIFICATIONURL
		);
	}
	/*--Patient Profile Links Ends--*/

	/*--Caregiver Profile Links--*/
	openCarMyProfile() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.CAREGIVERPROFILEURL
		);
	}
	openCarMyCaregiver() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.CAREGIVERPATINENTURL
		);
	}
	openCarSelectAvatar() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.CAREGIVERSELECTAVATARURL
		);
	}
	openCarNotSettings() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.CAREGIVERNOTIFICATIONURL
		);
	}
	/*--Caregiver Profile Links Ends--*/

	openArticles() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.siteUrlinfoCenterLandingPage
		);
	}
	openPTV() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.CHRONICPATIENTURL
		);
	}
	openSupportCenter() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.sitesupportPageBranded
		);
	}
	openMyCases() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.MYCASESPAGEURL
		);
	}
	//Used to navigate the components in community according to thr username
	openAllPosts() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check has been handled in its respective apex method
				if (result === true) {
					window.location.assign(
						this.baseUrl + this.siteUrlBranded + this.siteUrlAllPost
					);
				}
				if (result === false) {
					window.location.assign(
						this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp
					);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//Used to navigate the components in community according to thr username
	openMyPosts() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check has been handled in its respective apex method
				if (result === true) {
					window.location.assign(
						this.baseUrl + this.siteUrlBranded + this.MYPOSTSITEURL
					);
				}
				if (result === false) {
					window.location.assign(
						this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp
					);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//Used to navigate the components in community according to thr username
	openMyFollowers() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check has been handled in its respective apex method
				if (result === true) {
					window.location.assign(
						this.baseUrl + this.siteUrlBranded + this.FOLLOWERSSITEURL
					);
				}
				if (result === false) {
					window.location.assign(
						this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp
					);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//Used to navigate the components in community according to thr username
	openFollowing() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {// Null check has been handled in its respective apex method
				if (result === true) {
					window.location.assign(
						this.baseUrl + this.siteUrlBranded + this.FOLLOWINGSITEURL
					);
				}
				if (result === false) {
					window.location.assign(
						this.baseUrl + this.siteUrlBranded + this.siteUrlchatterSignUp
					);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	//Navigation
	openoutstandingquestionnaire() {
		window.location.assign(
			this.baseUrl +
			this.siteUrlBranded +
			this.siteoutstandingQuestionnaireBranded
		);
	}
	opensummary() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.SUMMARYPAGESITEURL
		);
	}
	opencompletedquestionnaire() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.DLQICOMPLETEDQUESTIONURL
		);
	}
	openletspersonalize() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.LETSPERSNOLISEURL
		);
	}
	openTreatmentRemaindersLink() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.REMINDERPAGEURL
		);
	}
	updatePrescriptionLink() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.UPDATEPRESCRIPTIONURL
		);
	}
	prescriptionStatusLink() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.PRESCRIPTIONSTATUSURL
		);
	}
	openGeneralNC() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.MESSAGECENTERURL
		);
	}
	openActionRequiredNC() {
		window.location.assign(this.baseUrl + this.siteUrlBranded + this.ACTIONURL);
	}
	openHistoryNC() {
		window.location.assign(
			this.baseUrl + this.siteUrlBranded + this.HISTORYURL
		);
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
	openComQuestionnaires() {
		if (this.stdlq > 0) {
		window.location.assign(this.urlq + dlqiCompletedUrl);
		} else if (this.stpss > 0) {
		window.location.assign(this.urlq + pssCompletedUrl);
		} else if (this.stwai > 0) {
		window.location.assign(this.urlq + wapiCompletedUrl);
		} else if (this.stqsq > 0) {
		if (this.target14wksdate != null) {
			if (this.status === completedLabel || this.status ===expired) {
			window.location.assign(
				this.urlq + qualitativeCompletedFourteenMonths
			);
			} else {
			window.location.assign(this.urlq + qualitativeCompletedtwoMonths);
			}
		} else {
			window.location.assign(this.urlq + qualitativeCompletedtwoMonths);
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