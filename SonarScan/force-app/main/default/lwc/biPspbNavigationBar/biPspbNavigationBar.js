// This comppnent is used for navigating to one page to another page for all unassigned pages
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import Apex Classes
import getTaskCount from '@salesforce/apex/BI_PSPB_BellIconCount.getTaskCountUA';
import userDetails from '@salesforce/apex/BI_PSPB_LoginCtrl.userDetails';
import profileDetails from '@salesforce/apex/BI_PSPB_LoginCtrl.profileDetails';
import getCaregiverAccounts from '@salesforce/apex/BI_PSPB_PatientDetailsCtrl.getCaregiverAccounts';
import getUnreadCases from '@salesforce/apex/BI_PSPB_LoginCtrl.getUnreadCases';
import checkCommunityUsername from '@salesforce/apex/BI_PSPB_CommunityUsername.checkCommunityUsername';
import Patientstatus from "@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus";
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getAssessmentCountsByCurrentUserName';
import getEnrolle from '@salesforce/apex/BI_PSP_ChallengeCtrl.getEnrolle';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
// To import Static Resource
import sitelogo from '@salesforce/resourceUrl/BI_PSPB_SiteLogo';
import HmeIcon from '@salesforce/resourceUrl/BI_PSPB_Home_Icon';
import NotIcon from '@salesforce/resourceUrl/BI_PSPB_NotiIcon';
import MenIcon from '@salesforce/resourceUrl/BI_PSPB_MenuIcon';
import NotIconColor from '@salesforce/resourceUrl/BI_PSPB_NotIconColored';
import CroIcon from '@salesforce/resourceUrl/BI_PSP_CrossIcon';
import SIcon from '@salesforce/resourceUrl/BI_PSPB_SelectIcon';
import DIcon from '@salesforce/resourceUrl/BI_PSPB_downHeadIcon';
// To import Custom Labels
import ACUTEPATIENT from '@salesforce/label/c.BI_PSPB_Acute';
import BRANDEDDEVUI from '@salesforce/label/c.BI_PSP_BrandedDevUIProfile';
import ADMINPROFILE from '@salesforce/label/c.BI_PSP_SystemAdminProfile';
import PATIENTPROFILE from '@salesforce/label/c.BI_PSP_PatientProfile';
import CAREGIVERPROFILES from '@salesforce/label/c.BI_PSPB_CaregiverProfile';
import UNASSIGNEDSITEURL from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import CAREGIVERPROFILE from '@salesforce/label/c.BI_PSPB_BRCaregiverProfile';
import PATIENT_INFO from '@salesforce/label/c.BI_PSPB_BRCaregiverPatient';
import SELECTAVATAR from '@salesforce/label/c.BI_PSPB_BRCaregiverSelectAvatar';
import NOTIFICATION from '@salesforce/label/c.BI_PSPB_BRCaregiverNotification';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import MYPROFILE from '@salesforce/label/c.BI_PSPB_PatientMyProfileUrl';
import MYCAREGIVER from '@salesforce/label/c.BI_PSPB_MyCaregiverUrl';
import PATIENTAVATAR from '@salesforce/label/c.BI_PSPB_PatientSelectAvatarUrl';
import PATIENTNOTIFICATION from '@salesforce/label/c.BI_PSPB_PatientNotificationUrl';
import ALLPOST from '@salesforce/label/c.BI_PSPB_AllPostUrl';
import MYPOST from '@salesforce/label/c.BI_PSPB_ChatterMyPost';
import FOLLOWER from '@salesforce/label/c.BI_PSPB_ChatterFollower';
import FOLLOWING from '@salesforce/label/c.BI_PSPB_ChatterFollowing';
import UNASSIGNED from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import BI_PSP_UNASSIGNED from '@salesforce/label/c.BI_PSP_Unassigned';
import CHATTERSIGNUP from '@salesforce/label/c.BI_PSP_ChatterSignUpUrl';
import INFOLAND from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
import ACUTEDASHBOARD from '@salesforce/label/c.BI_PSPB_AcuteDashboard';
import CHALLENGES from '@salesforce/label/c.BI_PSP_challengesURL';
import TROPHY from '@salesforce/label/c.BI_PSP_trophyCaseURL';
import OUTSTANDINGQUESTIONAIRE from '@salesforce/label/c.BI_PSPB_BROutstandingQuestionnaireUrl';
import SUPPORTCASE from '@salesforce/label/c.BI_PSPB_BRSupportPage';
import MESSAGECENTER from '@salesforce/label/c.BI_PSPB_messagecenterUrl';
import SUPPORTCENTER from '@salesforce/label/c.BI_PSPB_BRSupportPage';
import MYCASE from '@salesforce/label/c.BI_PSPB_BRMyCasePage';
import SUMMARYQUESTIONNAIRE from '@salesforce/label/c.BI_PSPB_BRSummaryUrl';
import WAPICOMPLETED from '@salesforce/label/c.BI_PSPB_BRWapiCompletedQuestionnaire';
import DLQICOMPLETED from '@salesforce/label/c.BI_PSPB_BRDlqiCompletedUrl';
import PSSCOMPLETED from '@salesforce/label/c.BI_PSPB_BRPsoriasisCompletedQuesUrl';
import QSQONECOMPLETED from '@salesforce/label/c.BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl';
import QSQTWOCOMPLETED from '@salesforce/label/c.BI_PSPB_BRQualitativefourteenweeksCompletedUrl';
import LETPERSONALIZE from '@salesforce/label/c.BI_PSPB_BR_LetsPersonalizeUrl';
import PRESCRIPTIONSTATUS from '@salesforce/label/c.BI_PSPB_PrescriptionStatusUrl';
import ACTION from '@salesforce/label/c.BI_PSPB_ActionUrl';
import HISTORY from '@salesforce/label/c.BI_PSPB_HistoryUrl';
import SYMPTOMLANDING from '@salesforce/label/c.BI_PSP_symptomTrackerLpUrl';
import ARTICLECATEGORY from '@salesforce/label/c.BI_PSPB_BRarticlecategoryUrl';
import SEARCHRESULT from '@salesforce/label/c.BI_PSPB_BRSearchResults';
import DETAILEDARTICLE from '@salesforce/label/c.BI_PSPB_BRDetailedArticle';
import SYMPTOMTRACKERGRAPH from '@salesforce/label/c.BI_PSPB_symptomtrackergraphUrl';
import SYMPTOMTRACKERMAIN from '@salesforce/label/c.BI_PSPB_symptomtrackermainpage';
import PSSQUESTIONNAIRE from '@salesforce/label/c.BI_PSPB_BRPsoriasisQuesUrl';
import WAPIQUESTIONNAIRE from '@salesforce/label/c.BI_PSPB_BRWapiQuestionnaire';
import QUALITATIVETWOQUESTIONNAIRE from '@salesforce/label/c.BI_PSPB_BRQualitativeTwoMonths';
import QUALITATIVEFOURQUESTIONNAIRE from '@salesforce/label/c.BI_PSPB_BRQualitativeFourteenWeeks';
import MEDICALINFORMATION from '@salesforce/label/c.BI_PSPB_BRMIEPage';
import REPORTADVERSE from '@salesforce/label/c.BI_PSPB_BRRAEPage';
import CREATEPOST from '@salesforce/label/c.BI_PSPB_createpostUrl';
import BI_PSPB_Acute from '@salesforce/label/c.BI_PSPB_Acute';
import LOGINURL from '@salesforce/label/c.BI_PSP_loginUrl';
import BRANDEDURL from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import BI_PSPB_SecureLogout from '@salesforce/label/c.BI_PSPB_SecureLogout';
import UPDATERX from '@salesforce/label/c.BI_PSPB_UpdatePrescriptionUrl';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import acuteVideoPage from '@salesforce/label/c.BI_PSPB_AcuteVideoPage';

// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbNavigationBar extends LightningElement {

	// Track variable Declarations(re-render variables)
	@track accname;
	@track taskCount;
	@track patientstatusval;
	@track showtreatvideo = false;
	// Global variables(without @track does not trigger automatic re-renders)
	downHeadIcon = DIcon;
	SelectIcon = SIcon;
	navlogo = sitelogo;
	showMenu;
	showToLogin;
	HIcon = HmeIcon;
	NIcon = NotIcon;
	MenuIcon = MenIcon;
	NIconCol = NotIconColor;
	CrossIcon = CroIcon;
	isMenuOpen;
	patientAMlist;
	caregiverAMlist;
	userName;
	showNavDetails;
	userInfo;
	currentUserIfo;
	showCareGiverMenus;
	activeData;
	notificationCount = 0;
	caregiverDeskMenu = false;
	patientDeskMenu = false;
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
	showSupportmenu;
	showquestionnairemenu;
	showInformationCentermenu
	showChallengesmenu;
	showCommunitymenu;
	showTabMenu;
	targetDate14;
	stwai;
	stpss;
	stdlq;
	stqsq;
	count;
	userId = Id;
	showuserSubmenu;
	showPrescriptionmenu;
	showNotificationCentermenu;
	acutePatient = ACUTEPATIENT;
	brandedDevProfile = BRANDEDDEVUI;
	adminProfile = ADMINPROFILE;
	patientProfile = PATIENTPROFILE;
	caregiverProfiles = CAREGIVERPROFILES;
	myProfile = MYPROFILE;
	myCaregiver = MYCAREGIVER;
	patientAvatar = PATIENTAVATAR;
	patientNotification = PATIENTNOTIFICATION;
	unAssignedUrl = UNASSIGNEDSITEURL;
	caregiverProfilecaregiverProfile = CAREGIVERPROFILE;
	patientInformation = PATIENT_INFO;
	selectAvatar = SELECTAVATAR;
	caregiverNotification = NOTIFICATION;
	allPost = ALLPOST;
	myPost = MYPOST;
	follower = FOLLOWER;
	following = FOLLOWING;
	chatterSignUp = CHATTERSIGNUP;
	unAssigned = UNASSIGNED;
	infoLanding = INFOLAND;
	acuteDashboard = ACUTEDASHBOARD;
	challenges = CHALLENGES;
	trophy = TROPHY;
	outStanding = OUTSTANDINGQUESTIONAIRE;
	supportCase = SUPPORTCASE;
	messageCenter = MESSAGECENTER;
	supportCenter = SUPPORTCENTER;
	myCase = MYCASE;
	summaryQues = SUMMARYQUESTIONNAIRE;
	wapiCompleted = WAPICOMPLETED;
	dlqiCompleted = DLQICOMPLETED;
	pssCompleted = PSSCOMPLETED;
	qsqOneCompleted = QSQONECOMPLETED;
	qsqTwoCompleted = QSQTWOCOMPLETED;
	letPersonlize = LETPERSONALIZE;
	prescriptionStatus = PRESCRIPTIONSTATUS;
	symptomLanding = SYMPTOMLANDING;
	action = ACTION;
	history = HISTORY;
	articleCategory = ARTICLECATEGORY;
	detailedArticle = DETAILEDARTICLE;
	searchResult = SEARCHRESULT;
	symptomTrackerGraph = SYMPTOMTRACKERGRAPH;
	symptomTrackerMain = SYMPTOMTRACKERMAIN;
	pssQuestionnaire = PSSQUESTIONNAIRE;
	wapiQuestionnaire = WAPIQUESTIONNAIRE;
	qualitativeTwo = QUALITATIVETWOQUESTIONNAIRE;
	qualativeFour = QUALITATIVEFOURQUESTIONNAIRE;
	medicalInformation = MEDICALINFORMATION;
	reportAdverse = REPORTADVERSE;
	platFormSupport = REPORTADVERSE;
	createPost = CREATEPOST;
	unAssignedsite = BI_PSP_UNASSIGNED;
	acute = BI_PSPB_Acute;
	loginUrl = LOGINURL;
	brandedUrl = BRANDEDURL;
	secureLogout = BI_PSPB_SecureLogout;
	updateRx = UPDATERX;


    //Qualitative Date for topbar navigation
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
		if (error) {
			this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
		} else if (data) {
			this.threeMonthsVar = data.threeMonthsVar;
			this.forteenWeeks = data.forteenWeeks;
			this.target2monthsdate = data.target2monthsdate ?? null;
			this.target14wksdate = data.target14wksdate ?? null;
		}
		} catch (err) {
		this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from LWC
		}
	}


	//Used to get information regarding the loggedin caregiver
	patientInfo() {
		getCaregiverAccounts({ userId: Id })
			.then(patient => {
				this.activeData = patient;
				if (this.activeData.length > 0) {
					this.showCareGiverMenus = true
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			})
	}
	//Used to get the notification count using task
	taskInfo(id) {
		getUnreadCases({ userId: id })
			.then(user => {
				if (user != null) {
					this.notificationCount = user.length;
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			})
	}
	//Navigation
	openUpdatePrescription() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.updateRx);
	}
	//Used to get the user and profile information of the current loggedin user to render the navigation bar details.
	connectedCallback() {
		this.getenrollefunction();
		this.currentPageUrl = window.location.href;
		this.urlSegments = this.currentPageUrl.split('/');
		this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;

		const regex = /\/([^\\/?#]+)(?:\?.*|)$/i;
		const match = regex.exec(this.currentPageUrl);
		this.lastSegment = match && match[1];
		if (this.lastSegment != null && this.lastSegment !== '') {
			this.showUnderlineforMenus();
		} else {
			this.showHomeLine = true;
		}
		if (Id != null || Id !== undefined) {
			
			userDetails({ userId: Id })
				.then(user => {
					this.currentUserIfo = user;
					if (this.currentUserIfo.BI_PSPB_Caregiver__c === true) {
						this.patientInfo();
					}
					this.userName = user.FirstName + ' ' + user.LastName;
					profileDetails({ profileId: user.ProfileId })
						.then(profile => {
							this.userInfo = profile;
							if (this.userInfo.Name === this.adminProfile || this.userInfo.Name === this.patientProfile || this.userInfo.Name === this.caregiverProfiles) {
								this.showMenu = true;
								this.showNavDetails = true;
								this.showToLogin = false;
								if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
									this.caregiverDeskMenu = false;
									this.patientDeskMenu = true;
								} else {
									this.caregiverDeskMenu = true;
									this.patientDeskMenu = false;
								}
							} else if (this.userInfo.Name === this.brandedDevProfile) {
								this.showMenu = false;
								this.showNavDetails = false;
								this.showToLogin = true;
							}

						})
						.catch(error => {
							this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex

						})
				})
				.catch(error => {
					this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from LWC
				})
		} else {
			this.showMenu = false;
			this.showNavDetails = false;
			this.showToLogin = true;
		}
		try {
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split('/');
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error from LWC
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
					} else {
						this.showTabMenu = false;
					}
				} else {
					this.showTabMenu = false;
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
				this.showTabMenu = false;
			});
	}
	//used to fetch the relative enrolle detials of the current user
	getenrollefunction() {
		getEnrolle({ userId: this.userId })
			.then(result => {
				if (result != null) {
					if (result[0].patientEnrolle != null) {
						this.enroll = result[0].patientEnrolle.Id;
						this.taskcounter(this.enroll);
					} else if (result[0].error != null) {
						this.showError = true;
						this.errorMessage = result[0].error;
					}
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			})
	}

	//used to get the task count for the current logged in user
	taskcounter(acci) {
		getTaskCount({ accountId: acci })
			.then(result => {
				this.taskCount = result;
			})
			.catch(error => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			});
	}
	//This method is used to identify the current page and renders the highliged bar for menus

	showUnderlineforMenus() {
		if (this.lastSegment) {
			if (this.lastSegment === this.challenges || this.lastSegment === this.trophy) {
				this.showChallenge = true;
			} else if (this.lastSegment === this.infoLanding || this.lastSegment === this.articleCategory || this.lastSegment === this.searchResult || this.lastSegment === this.detailedArticle || this.lastSegment === acuteVideoPage) {
				this.showInformationCenter = true;
			} else if (this.lastSegment === this.symptomLanding || this.lastSegment === this.symptomTrackerGraph || this.lastSegment === this.symptomTrackerMain) {
				this.showSymptomTracker = true;
			} else if (this.lastSegment === this.outStanding || this.lastSegment === this.summaryQues || this.lastSegment === this.dlqiCompleted || this.lastSegment === this.letPersonlize || this.lastSegment === this.pssQuestionnaire || this.lastSegment === this.dlqiCompleted || this.lastSegment === this.qualitativeTwo || this.lastSegment === this.qualativeFour || this.lastSegment === this.wapiCompleted || this.lastSegment === this.dlqiCompleted || this.lastSegment === this.pssCompleted || this.lastSegment === this.qsqOneCompleted || this.lastSegment === this.qsqTwoCompleted) {
				this.showQuestionnaires = true;
			} else if (this.lastSegment === this.unAssignedUrl || this.lastSegment === this.acuteDashboard) {
				this.showHomeLine = true;
			} else if (this.lastSegment === this.supportCenter || this.lastSegment === this.medicalInformation || this.lastSegment === this.reportAdverse || this.lastSegment === this.platFormSupport || this.lastSegment === this.myCase) {
				this.showSupport = true;
			} else if (this.lastSegment === this.allPost || this.lastSegment === this.chatterSignUp || this.lastSegment === this.myPost || this.lastSegment === this.createPost || this.lastSegment === this.follower || this.lastSegment === this.following) {
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
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(Patientstatus, { userid: `$userId` })
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;
				if (this.patientstatusval === this.unAssignedsite) {
					this.showtreatvideo = false;
				}
				else {
					this.showtreatvideo = true;
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);// Catching Potential Error from Apex

			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant);// Catching Potential Error from LWC
		}
	}
	//Used to decide the Navigation for community chatter
	openCommunity() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {
				if (result === true) {
					window.location.assign(this.baseUrl + this.unAssignedUrl + this.allPost);

				}
				if (result === false) {
					window.location.assign(this.baseUrl + this.unAssignedUrl + this.chatterSignUp);

				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			})
	}
	//Navigation for Caregiver/Patient
	userNavigation() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.myProfile);
		} else {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.caregiverProfile);
		}
	}
	userNavigationMyprofile() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.myProfile);
		} else {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.caregiverProfile);
		}
	}
	userNavigationMyCaregiver() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.myCaregiver);
		} else {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.patientInformation);
		}
	}
	userNavigationSelectAvatar() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.patientAvatar);
		} else {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.selectAvatar);
		}
	}
	userNavigationNotSettings() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.patientNotification);
		} else {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.caregiverNotification);
		}
	}
	//Navigation
	checkUser() {
		this.showToLogin = false;
		window.location.assign(this.baseUrl + this.brandedUrl + this.loginUrl);
	}
	openInformationCenter() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.infoLanding);
	}
	openhome() {
		if (this.patientstatusval === this.acute) {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.acuteDashboard);
		} else {

			window.location.assign(this.baseUrl + this.unAssignedUrl);
		}
	}
	openChallenges() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.challenges);
	}
	//Navigation
	openQuestions() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.outStanding);
	}
	openSymptomTracker() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.symptomLanding);
	}
	openSupport() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.supportCase);
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
		let desiredUrl;
		if (index !== -1) {
			desiredUrl = urlParts.slice(0, index + 1).join('/');
		}
		window.location.assign(desiredUrl.replace(/\/s/g, '/') + this.secureLogout + this.baseUrl + this.unAssignedUrl);
	}
	openMyProfile() {
		window.location.assign(this.baseUrl + this.unAssignedUrl);
	}
	//used for rendering the components
	openMobMenu() {
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
	}

	userMenuNavigation() {
		if (this.currentUserIfo.BI_PSPB_Caregiver__c === false) {
			this.caregiverAMlist = false;
			this.patientAMlist = true;
			this.showMenu = false;
			this.showuserSubmenu = false;
		} else {
			this.caregiverAMlist = true;
			this.patientAMlist = false;
			this.showMenu = false;
			this.showuserSubmenu = false;
		}
	}
	/*--Patient Profile Links--*/
	openPatMyProfile() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.myProfile);
	}
	openPatMyCaregiver() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.myCaregiver);
	}
	openPatSelectAvatar() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.patientAvatar);
	}
	openPatNotSettings() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.patientNotification);
	}
	/*--Patient Profile Links Ends--*/

	/*--Caregiver Profile Links--*/
	openCarMyProfile() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.caregiverProfile);
	}
	openCarMyCaregiver() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.patientInformation);
	}
	openCarSelectAvatar() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.selectAvatar);
	}
	openCarNotSettings() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.caregiverNotification);
	}
	openCarNotSettings1() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.messageCenter);
	}
	/*--Caregiver Profile Links Ends--*/

	openSupport2() {
		this.showMenu = false;
		this.showSupportmenu = true;
	}
	//Used to render the components
	openQuestions2() {
		this.showMenu = false;
		this.showquestionnairemenu = true;
	}
	openInformationCenter2() {
		this.showMenu = false;
		this.showInformationCentermenu = true;
	}
	openchalenges2() {
		this.showMenu = false;
		this.showChallengesmenu = true;
	}
	openCommunities() {
		this.showMenu = false;
		this.showCommunitymenu = true;
	}

	handleback() {
		this.showMenu = true;
		this.showquestionnairemenu = false;

	}
	/*   Patient Community SubMenu */

	openAllPosts() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {
				if (result === true) {
					window.location.assign(this.baseUrl + this.unAssignedUrl + this.allPost);
				}
				if (result === false) {
					window.location.assign(this.baseUrl + this.unAssignedUrl + this.chatterSignUp);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			});
	}
	openMyPosts() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {
				if (result === true) {
					window.location.assign(this.baseUrl + this.unAssignedUrl + this.myPost);
				}
				if (result === false) {
					window.location.assign(this.baseUrl + this.unAssignedUrl + this.chatterSignUp);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			});
	}
	openMyFollowers() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {
				if (result === true) {
					window.location.assign(this.baseUrl + this.unAssigned + this.follower);
				}
				if (result === false) {
					window.location.assign(this.baseUrl + this.unAssignedUrl + this.chatterSignUp);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			});
	}
	openFollowing() {
		checkCommunityUsername({ userId: this.userId })
			.then((result) => {
				if (result === true) {
					window.location.assign(this.baseUrl + this.unAssigned + this.following);
				}
				if (result === false) {
					window.location.assign(this.baseUrl + this.unAssignedUrl + this.chatterSignUp);
				}
			})
			.catch((error) => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			});
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
	openArticles() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.infoLanding);
	}
	openPTV() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.acutePatient);
	}
	openSupportCenter() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.supportCenter);
	}
	openMyCases() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.myCase);
	}
	openTrophycase() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.trophy);
	}
	/*showquestionnairemenu links*/
	openoutstandingquestionnaire() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.outStanding);

	}
	opensummary() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.summaryQues);
	}
	opencompletedquestionnaire() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.dlqiCompleted);
	}
	openletspersonalize() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.letPersonlize);
	}

	updatePrescriptionLink() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.updateRx);
	}
	prescriptionStatusLink() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.prescriptionStatus);
	}
	openGeneralNC() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.messageCenter);
	}
	openActionRequiredNC() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.action);
	}
	openHistoryNC() {
		window.location.assign(this.baseUrl + this.unAssignedUrl + this.history);
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
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.dlqiCompleted);
		}
		else if (this.stpss > 0) {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.pssCompleted);
		}
		else if (this.stwai > 0) {
			window.location.assign(this.baseUrl + this.unAssignedUrl + this.wapiCompleted);
		}
		else if (this.stqsq > 0) {
			if (this.target14wksdate != null) {
				if (this.status === completedLabel || this.status ===expired) {
				window.location.assign(this.baseUrl + this.unAssignedUrl + this.qsqTwoCompleted);
			}
			else {
				window.location.assign(this.baseUrl + this.unAssignedUrl + this.qsqOneCompleted);
			}
		}
		else{
				window.location.assign(this.baseUrl + this.unAssignedUrl + this.qsqOneCompleted);
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