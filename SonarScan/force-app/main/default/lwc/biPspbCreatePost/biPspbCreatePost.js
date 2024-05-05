//This lightning web component is used to Create Post by Selecting Category and Phrases in Patient Community Page
// To import Libraries 
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
//  To import Apex Classes
import checkCommunityUsername from '@salesforce/apex/BI_PSPB_CommunityUsername.checkCommunityUsername';
import gettingAvatar from '@salesforce/apex/BI_PSPB_CommunityUsername.gettingAvatar';
import createFeed from '@salesforce/apex/BI_PSPB_FeedItemCtrl.insertFeedItem';
//To import Static Resource
import warningIcon from '@salesforce/resourceUrl/BI_PSP_WarningIcon';
// To import Custom Labels
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import BI_PSP_chatterLifestyle from '@salesforce/label/c.BI_PSP_chatterLifestyle';
import BI_PSP_chatterSocial from '@salesforce/label/c.BI_PSP_chatterSocial';
import BI_PSP_chatterMedical from '@salesforce/label/c.BI_PSP_chatterMedical';
import BI_PSP_chatterPsychologi from '@salesforce/label/c.BI_PSP_chatterPsychologi';
import BI_PSP_chatterOccupation from '@salesforce/label/c.BI_PSP_chatterOccupation';
import BI_PSP_chatterGPP from '@salesforce/label/c.BI_PSP_chatterGPP';

import BI_PSP_chatterLifeIMiss from '@salesforce/label/c.BI_PSP_chatterLifeIMiss';
import BI_PSP_chatterLifeWorking from '@salesforce/label/c.BI_PSP_chatterLifeWorking';
import BI_PSP_chatterLifeNotAlways from '@salesforce/label/c.BI_PSP_chatterLifeNotAlways';
import BI_PSP_chatterLifeMyCloth from '@salesforce/label/c.BI_PSP_chatterLifeMyCloth';
import BI_PSP_chatterLifeIWould from '@salesforce/label/c.BI_PSP_chatterLifeIWould';
import BI_PSP_chatterLifeEvenGpp from '@salesforce/label/c.BI_PSP_chatterLifeEvenGpp';
import BI_PSP_chatterLifeAfterOver from '@salesforce/label/c.BI_PSP_chatterLifeAfterOver';
import BI_PSP_chatterLifeThereAre from '@salesforce/label/c.BI_PSP_chatterLifeThereAre';
import BI_PSP_chatterLifeIDid from '@salesforce/label/c.BI_PSP_chatterLifeIDid';

import BI_PSP_chatterSocialActivelyWork from '@salesforce/label/c.BI_PSP_chatterSocialActivelyWork';
import BI_PSP_chatterSocialToExplain from '@salesforce/label/c.BI_PSP_chatterSocialToExplain';
import BI_PSP_chatterSocialTalking from '@salesforce/label/c.BI_PSP_chatterSocialTalking';
import BI_PSP_chatterSocialOnlyClose from '@salesforce/label/c.BI_PSP_chatterSocialOnlyClose';
import BI_PSP_chatterSocialSharedMy from '@salesforce/label/c.BI_PSP_chatterSocialSharedMy';
import BI_PSP_chatterSocialStaying from '@salesforce/label/c.BI_PSP_chatterSocialStaying';
import BI_PSP_chatterSocialWantToIntimate from '@salesforce/label/c.BI_PSP_chatterSocialWantToIntimate';
import BI_PSP_chatterSocialGotChance from '@salesforce/label/c.BI_PSP_chatterSocialGotChance';
import BI_PSP_chatterSocialEmbarrase from '@salesforce/label/c.BI_PSP_chatterSocialEmbarrase';
import BI_PSP_chatterSocialThingsBetter from '@salesforce/label/c.BI_PSP_chatterSocialThingsBetter';

import BI_PSP_chatterMedicalDontFeel from '@salesforce/label/c.BI_PSP_chatterMedicalDontFeel';
import BI_PSP_chatterMedicalSeenDoc from '@salesforce/label/c.BI_PSP_chatterMedicalSeenDoc';
import BI_PSP_chatterMedicalFinally from '@salesforce/label/c.BI_PSP_chatterMedicalFinally';

import BI_PSP_chatterPsycFeelAlone from '@salesforce/label/c.BI_PSP_chatterPsycFeelAlone';
import BI_PSP_chatterPsycFeelAnxious from '@salesforce/label/c.BI_PSP_chatterPsycFeelAnxious';
import BI_PSP_chatterPsycWornOut from '@salesforce/label/c.BI_PSP_chatterPsycWornOut';
import BI_PSP_chatterPsycThingsBetter from '@salesforce/label/c.BI_PSP_chatterPsycThingsBetter';
import BI_PSP_chatterPsycDontLetGpp from '@salesforce/label/c.BI_PSP_chatterPsycDontLetGpp';
import BI_PSP_chatterPsycGPPHardBattle from '@salesforce/label/c.BI_PSP_chatterPsycGPPHardBattle';
import BI_PSP_chatterPsycTodayFeel from '@salesforce/label/c.BI_PSP_chatterPsycTodayFeel';
import BI_PSP_chatterPsycEvenThough from '@salesforce/label/c.BI_PSP_chatterPsycEvenThough';
import BI_PSP_chatterPsycIAccept from '@salesforce/label/c.BI_PSP_chatterPsycIAccept';

import BI_PSP_chatterOccICannot from '@salesforce/label/c.BI_PSP_chatterOccICannot';
import BI_PSP_chatterOccComplicate from '@salesforce/label/c.BI_PSP_chatterOccComplicate';
import BI_PSP_chatterOccWorlColleague from '@salesforce/label/c.BI_PSP_chatterOccWorlColleague';
import BI_PSP_chatterOccFeelMyFamily from '@salesforce/label/c.BI_PSP_chatterOccFeelMyFamily';

import BI_PSP_chatterGppIDontKnow from '@salesforce/label/c.BI_PSP_chatterGppIDontKnow';
import BI_PSP_chatterGppWhileGiving from '@salesforce/label/c.BI_PSP_chatterGppWhileGiving';
import BI_PSP_chatterGppSkinImprove from '@salesforce/label/c.BI_PSP_chatterGppSkinImprove';
import BI_PSP_chatterGppActivelyExplore from '@salesforce/label/c.BI_PSP_chatterGppActivelyExplore';
import BI_PSP_chatterGppUnderstanding from '@salesforce/label/c.BI_PSP_chatterGppUnderstanding';
import BI_PSP_chatterGppFeelAlone from '@salesforce/label/c.BI_PSP_chatterGppFeelAlone';
import BI_PSP_ChatterSlash from '@salesforce/label/c.BI_PSP_ChatterSlash';
import BI_PSPB_MyPostUrl from '@salesforce/label/c.BI_PSPB_myPostUrl';
import BI_PSPB_CreatePostUrl from '@salesforce/label/c.BI_PSPB_createpostUrl';
import BI_PSPB_ChatterUsernameUrl from '@salesforce/label/c.BI_PSPB_ChatterUsernameUrl';
export default class biPspbCreatePost extends (LightningElement) {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track categoryPlaceHolder = 'Select';
	@track phrasePlaceHolder = 'Select';
	@track selectLengthWidthChild = 'selectlengthWidth';
	@track selectLengthWidthParent = 'selectlengthWidth';
	@track parentValue = '';
	@track childValue = '';
	@track childOptions = [];
	@track warningCategory = false;
	@track warningPhrase = false;
	@track childDropdownDisabled = true;
	@track isDesktop = false;
	@track loggedUserAvatar;
	@track isPopupOpen = false;
	@track category;
	@track subcategory;
	@track showSpinner;
	//Category Option Values
	@track parentOptions = [
		{ label: BI_PSP_chatterLifestyle, value: BI_PSP_chatterLifestyle },
		{ label: BI_PSP_chatterSocial, value: BI_PSP_chatterSocial },
		{ label: BI_PSP_chatterMedical, value: BI_PSP_chatterMedical },
		{ label: BI_PSP_chatterPsychologi, value: BI_PSP_chatterPsychologi },
		{ label: BI_PSP_chatterOccupation, value: BI_PSP_chatterOccupation },
		{ label: BI_PSP_chatterGPP, value: BI_PSP_chatterGPP }
	];
	//Declaration of variables
	warningIconImg = warningIcon;
	userId = Id;

	//This connected callback used to find the site Branded/Unassigned ,and run avatarfunction and for Static page without scroll when popup opens
	connectedCallback() {
		try {
			this.detectBrandedOrUnassigned();
			this.avatarfunction();
			this.isDesktop = this.isDesktopView();
			window.addEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error for try-catch
		}
	}
	//Used to remove the Event from the fixed screen 
	disconnectedCallback() {
		try {
			window.removeEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error for try-catch 
		}
	}
	//set the desktop view to fix the screen for popup 
	handleResize() {
		this.isDesktop = this.isDesktopView();
	}
	// This function used to Fix the screen as static if the popup opens as per requirement
	isDesktopView() {
		const viewportWidth = window.innerWidth;
		return viewportWidth >= 1024 || viewportWidth <= 400;
	}
	//Get Avatar for AvatarContent 
	avatarfunction() {
		try {
			gettingAvatar({ userId: this.userId })
				.then((result) => {
					if (result.length > 0 && result[0].BI_PSP_AvatarUrl__c) {
						this.loggedUserAvatar = result[0].BI_PSP_AvatarUrl__c;
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error for then-catch
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}
	//Onchange function for Category Dropdown
	handleParentDropdownChange(event) {
		this.selectLengthWidthParent = 'selectlengthWidth';
		this.parentValue = event.target.value;
		this.childDropdownDisabled = false;
		//Phrase Values Dependent to category options so According to phrase choosen by the user get Phrase option values
		if (this.parentValue === BI_PSP_chatterLifestyle) {
			this.childOptions = [
				{ label: BI_PSP_chatterLifeIMiss, value: BI_PSP_chatterLifeIMiss },
				{ label: BI_PSP_chatterLifeWorking, value: BI_PSP_chatterLifeWorking },
				{ label: BI_PSP_chatterLifeNotAlways, value: BI_PSP_chatterLifeNotAlways },
				{ label: BI_PSP_chatterLifeMyCloth, value: BI_PSP_chatterLifeMyCloth },
				{ label: BI_PSP_chatterLifeIWould, value: BI_PSP_chatterLifeIWould },
				{ label: BI_PSP_chatterLifeEvenGpp, value: BI_PSP_chatterLifeEvenGpp },
				{ label: BI_PSP_chatterLifeAfterOver, value: BI_PSP_chatterLifeAfterOver },
				{ label: BI_PSP_chatterLifeThereAre, value: BI_PSP_chatterLifeThereAre },
				{ label: BI_PSP_chatterLifeIDid, value: BI_PSP_chatterLifeIDid }
			];
		} else if (this.parentValue === BI_PSP_chatterSocial) {
			this.childOptions = [
				{
					label:
						BI_PSP_chatterSocialActivelyWork,
					value:
						BI_PSP_chatterSocialActivelyWork
				},
				{
					label:
						BI_PSP_chatterSocialToExplain,
					value:
						BI_PSP_chatterSocialToExplain
				},
				{
					label:
						BI_PSP_chatterSocialTalking,
					value:
						BI_PSP_chatterSocialTalking
				},
				{
					label: BI_PSP_chatterSocialOnlyClose,
					value: BI_PSP_chatterSocialOnlyClose
				},
				{
					label:
						BI_PSP_chatterSocialSharedMy,
					value:
						BI_PSP_chatterSocialSharedMy
				},
				{
					label:
						BI_PSP_chatterSocialStaying,
					value:
						BI_PSP_chatterSocialStaying
				},
				{
					label:
						BI_PSP_chatterSocialWantToIntimate,
					value:
						BI_PSP_chatterSocialWantToIntimate
				},
				{
					label:
						BI_PSP_chatterSocialGotChance,
					value:
						BI_PSP_chatterSocialGotChance
				},
				{
					label: BI_PSP_chatterSocialEmbarrase,
					value: BI_PSP_chatterSocialEmbarrase
				},
				{
					label:
						BI_PSP_chatterSocialThingsBetter,
					value:
						BI_PSP_chatterSocialThingsBetter
				}
			];
		} else if (this.parentValue === BI_PSP_chatterMedical) {
			this.childOptions = [
				{
					label:
						BI_PSP_chatterMedicalDontFeel,
					value:
						BI_PSP_chatterMedicalDontFeel
				},
				{
					label: BI_PSP_chatterMedicalSeenDoc,
					value: BI_PSP_chatterMedicalSeenDoc
				},
				{
					label:
						BI_PSP_chatterMedicalFinally,
					value:
						BI_PSP_chatterMedicalFinally
				}
			];
		} else if (this.parentValue === BI_PSP_chatterPsychologi) {
			this.childOptions = [
				{
					label: BI_PSP_chatterPsycFeelAlone,
					value: BI_PSP_chatterPsycFeelAlone
				},
				{
					label:
						BI_PSP_chatterPsycFeelAnxious,
					value:
						BI_PSP_chatterPsycFeelAnxious
				},
				{
					label: BI_PSP_chatterPsycWornOut,
					value: BI_PSP_chatterPsycWornOut
				},
				{ label: BI_PSP_chatterPsycThingsBetter, value: BI_PSP_chatterPsycThingsBetter },
				{
					label:
						BI_PSP_chatterPsycDontLetGpp,
					value:
						BI_PSP_chatterPsycDontLetGpp
				},
				{
					label:
						BI_PSP_chatterPsycGPPHardBattle,
					value:
						BI_PSP_chatterPsycGPPHardBattle
				},
				{
					label: BI_PSP_chatterPsycTodayFeel,
					value: BI_PSP_chatterPsycTodayFeel
				},
				{
					label:
						BI_PSP_chatterPsycEvenThough,
					value:
						BI_PSP_chatterPsycEvenThough
				},
				{
					label:
						BI_PSP_chatterPsycIAccept,
					value:
						BI_PSP_chatterPsycIAccept
				}
			];
		} else if (this.parentValue === BI_PSP_chatterOccupation) {
			this.childOptions = [
				{
					label: BI_PSP_chatterOccICannot,
					value: BI_PSP_chatterOccICannot
				},
				{
					label: BI_PSP_chatterOccComplicate,
					value: BI_PSP_chatterOccComplicate
				},
				{
					label:
						BI_PSP_chatterOccWorlColleague,
					value:
						BI_PSP_chatterOccWorlColleague
				},
				{
					label:
						BI_PSP_chatterOccFeelMyFamily,
					value:
						BI_PSP_chatterOccFeelMyFamily
				}
			];
		} else if (
			this.parentValue === BI_PSP_chatterGPP
		) {
			this.childOptions = [
				{
					label:
						BI_PSP_chatterGppIDontKnow,
					value:
						BI_PSP_chatterGppIDontKnow
				},
				{
					label:
						BI_PSP_chatterGppWhileGiving,
					value:
						BI_PSP_chatterGppWhileGiving
				},
				{
					label: BI_PSP_chatterGppSkinImprove,
					value: BI_PSP_chatterGppSkinImprove
				},
				{
					label:
						BI_PSP_chatterGppActivelyExplore,
					value:
						BI_PSP_chatterGppActivelyExplore
				},
				{
					label:
						BI_PSP_chatterGppUnderstanding,
					value:
						BI_PSP_chatterGppUnderstanding
				},
				{
					label:
						BI_PSP_chatterGppFeelAlone,
					value:
						BI_PSP_chatterGppFeelAlone
				}
			];
		}
	}
	//Onchange function for Phrases deopdown 
	handleChildDropdownChange(event) {
		this.selectLengthWidthParent = 'selectlengthWidth';
		this.selectLengthWidthChild = 'selectlengthWidth';
		this.warningCategory = false;
		this.warningPhrase = false;
		//these query selector are used for to Dispaly/Remove  Error Message
		const errorDiv = this.template.querySelector('.valid');//Category  For Error
		const errorDiv1 = this.template.querySelector('.secondvalid');//Phrase For Error
		if (errorDiv && errorDiv.classList.contains('firstinvalid')) {
			errorDiv.classList.remove('firstinvalid');
			errorDiv.classList.add('valid');
		}
		if (errorDiv1 && errorDiv1.classList.contains('secondinvalid')) {
			errorDiv1.classList.remove('secondinvalid');
			errorDiv1.classList.add('secondvalid');
		}
		this.childValue = event.target.value;
	}

	//Confirmation popup for submit
	get popupClass() {
		let popupClass = this.isPopupOpen ? 'popup-container' : 'popup-container hidden';
		return popupClass;
	}
	//Clear the Values or options or invalidation after clicking cancel button
	togglecancel() {
		if (
			this.parentValue !== null &&
			this.parentValue !== '' &&
			this.childValue !== null &&
			this.childValue !== ''
		) {
			window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_CreatePostUrl);
		}
		this.categoryPlaceHolder = 'Select';
		this.phrasePlaceHolder = 'Select';
		this.selectLengthWidthChild = 'selectlengthWidth';
		this.selectLengthWidthParent = 'selectlengthWidth';
		this.warningCategory = false;
		this.warningPhrase = false;
		//first(category ) error message div
		const errorDiv = this.template.querySelector('.valid');
		//second(phrase) error messgae div
		const errorDiv1 = this.template.querySelector('.secondvalid');
		if (errorDiv && errorDiv.classList.contains('firstinvalid')) {
			errorDiv.classList.remove('firstinvalid');
			errorDiv.classList.add('valid');
		}
		if (errorDiv1 && errorDiv1.classList.contains('secondinvalid')) {
			errorDiv1.classList.remove('secondinvalid');
			errorDiv1.classList.add('secondvalid');
		}
	}
	// Open confirmation popup for submit and check Null value 
	togglePopup() {
		const errorDiv = this.template.querySelector('.valid');
		const errorDiv1 = this.template.querySelector('.secondvalid');
		if (!this.parentValue || !this.childValue) {
			//if category is null raise invalidation
			if (!this.parentValue) {
				errorDiv.classList.add('firstinvalid');
				this.warningCategory = true;
				this.selectLengthWidthParent = 'errorselectlengthWidth';
				this.selectLengthWidthChild = 'errorselectlengthWidth';
				this.categoryPlaceHolder = 'Select a topic';
			} else {
				if (errorDiv.classList.contains('firstinvalid')) {
					errorDiv.classList.remove('firstinvalid');
					errorDiv.classList.add('valid');
					this.warningCategory = false;
				}
			}
			//if phrase is null raise invalidation
			if (!this.childValue) {
				errorDiv1.classList.add('secondinvalid');
				this.warningPhrase = true;
				this.phrasePlaceHolder = 'Select a Phrase';
				this.selectLengthWidthChild = 'errorselectlengthWidth';
			} else {
				if (errorDiv1.classList.contains('secondinvalid')) {
					errorDiv1.classList.remove('secondinvalid');
					errorDiv1.classList.add('secondvalid');
					this.warningPhrase = false;
				}
			}
		}
		//if none of the field is null , fix the normal text instead of error text
		else {
			errorDiv.classList.add('valid');
			errorDiv1.classList.add('secondvalid');
			errorDiv1.classList.remove('secondinvalid');
			errorDiv.classList.remove('firstinvalid');
			this.warningPhrase = false;
			this.warningCategory = false;
			this.isPopupOpen = true;
			if (this.isDesktop) {
				document.body.style.overflow = 'hidden';
			} else {
				document.body.style.overflow = '';
			}
		}
	}
	//close the confirmation popup
	checkclosbtn() {
		this.isPopupOpen = false;
		document.body.style.overflow = '';
	}
	//submit button - after clicking yes in confirmation popup and create record then navigate to mypost page
	handleSubmit() {
		this.isPopupOpen = false;
		document.body.style.overflow = '';
		//show loading spinner after clicking the yes button on confirmation submit popup and it closes automatically
		this.showSpinner = true;
		try {
			setTimeout(() => {
				this.showSpinner = false;
			}, 3000);
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error for try-catch
		}
		//Insert the  Category and phrases (Create FeedPost)
		createFeed({
			category: this.parentValue,
			subcategory: this.childValue,
			userId: this.userId
		})
			.then(() => {
				this.isPopupOpen = false;
				document.body.style.overflow = '';
				this.checkCommunity();
			})
			.catch((error) => {
				// Close the popup after submission
				this.isPopupOpen = false;
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error for then-catch
			});
	}
	//before navigate to mypost page after clicking yes on confirmation popup check the communityusername if not createit.
	checkCommunity() {
		try {
			checkCommunityUsername({ userId: this.userId })
				.then((result) => {
					if (result === true) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_MyPostUrl);
					}
					else if (result === false) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_ChatterUsernameUrl);
					} else {
						this.showToast(errormessage, errorvariant); // Catching Potential Error for Null/other
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error for then-catch
				});
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error for try-catch
		}

	}
	// To detect the site is branded or unassigned 
	detectBrandedOrUnassigned() {
		const currentURL = window.location.href;
		const urlObject = new URL(currentURL);
		const path = urlObject.pathname;
		const pathComponents = path.split(BI_PSP_ChatterSlash);
		const desiredComponent = pathComponents.find((component) =>
			[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
				component.toLowerCase()
			)
		);
		//set the url and navigations are done within branded site
		if (
			desiredComponent &&
			desiredComponent.toLowerCase() === brandedurl.toLowerCase()
		) {
			this.urlq = brandedurl;
		}
		//set the url and navigations are done within unassigned site
		else {
			this.urlq = unassignedurl;
		}
	}
	// show the Toast message if the catch runs 
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}