//This lightning web component is used to display Navigation Bar in the Patient Community  Pages
// To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
// To import Custom Labels
import brandedUrl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedUrl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import BI_PSP_ChatterSlash from '@salesforce/label/c.BI_PSP_ChatterSlash';
import BI_PSPB_ChatterUsernameUrl from '@salesforce/label/c.BI_PSPB_ChatterUsernameUrl';
import BI_PSPB_MyPostUrl from '@salesforce/label/c.BI_PSPB_myPostUrl';
import BI_PSPB_AllPostUrl from '@salesforce/label/c.BI_PSPB_AllPostUrl';
import BI_PSPB_FollowerUrl from '@salesforce/label/c.BI_PSPB_FollowerUrl';
import BI_PSPB_FollowingUrl from '@salesforce/label/c.BI_PSPB_followingUrl';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import BI_PSPB_ChatterAllPost from '@salesforce/label/c.BI_PSPB_ChatterAllPost';
import BI_PSPB_ChatterMyPost from '@salesforce/label/c.BI_PSPB_ChatterMyPost';
import BI_PSPB_ChatterFollower from '@salesforce/label/c.BI_PSPB_ChatterFollower';
import BI_PSPB_ChatterFollowing from '@salesforce/label/c.BI_PSPB_ChatterFollowing';
//  To import Apex Classes
import checkCommunityUsername from '@salesforce/apex/BI_PSPB_CommunityUsername.checkCommunityUsername';
export default class biPspbChatterNavBar extends (LightningElement) {
	// Declaration of variables with @track
	@track navColor = 'navColor';
	@track navColor1 = 'navColor1';
	@track navColor2 = 'navColor2';
	@track navColor3 = 'navColor3';
	urlq;
	userId = Id;
	//ConnectedCallback used to get the path and  find the site is Branded or Unassigned
	connectedCallback() {
		try {
			this.pageFind();
			this.detectBrandedOrUnassigned();
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Result Null/other Exception
		}
	}
	//find the path name of currentpage
	pageFind() {
		try {
			const path = window.location.pathname;
			const startIndex = path.indexOf('/s/') + 3; // Adding 3 to skip '/s/'
			const afterSSegment = path.substring(startIndex);
			//Highlight  the color of the navbar - condition
			this.resetNavColors();
			if (afterSSegment === BI_PSPB_ChatterAllPost) {
				this.navColor = 'navColorHighlight';
			}
			if (afterSSegment === BI_PSPB_ChatterMyPost) {
				this.navColor1 = 'navColorHighlight';
			}
			if (afterSSegment === BI_PSPB_ChatterFollower) {
				this.navColor2 = 'navColorHighlight';
			}
			if (afterSSegment === BI_PSPB_ChatterFollowing) {
				this.navColor3 = 'navColorHighlight';
			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Result Null/other Exception
		}
	}
	//reset the color in normal form (like as existing)
	resetNavColors() {
		try {
			this.navColor = 'navColor';
			this.navColor1 = 'navColor1';
			this.navColor2 = 'navColor2';
			this.navColor3 = 'navColor3';
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Result Null/other Exception
		}
	}
	//Find the site is Branded or Unassigned and do the navigation accordingly
	detectBrandedOrUnassigned() {
		try {
			const currentURL = window.location.href;
			const urlObject = new URL(currentURL);
			const path = urlObject.pathname;
			const pathComponents = path.split(BI_PSP_ChatterSlash);
			const desiredComponent = pathComponents.find((component) =>
				[brandedUrl.toLowerCase(), unassignedUrl.toLowerCase()].includes(
					component.toLowerCase()
				)
			);
			//set the url and navigations are done within branded site
			if (
				desiredComponent &&
				desiredComponent.toLowerCase() === brandedUrl.toLowerCase()
			) {
				this.urlq = brandedUrl;
			}
			//set the url and navigations are done within unassigned site
			else {
				this.urlq = unassignedUrl;
			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Result Null/other Exception
		}
	}
	//navigate the allpost and check if communityusername is already exist for the currentuser
	navAllpost() {
		try {
			checkCommunityUsername({ userId: this.userId })
				.then((result) => {
					if (result === true) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_AllPostUrl);
					}
					else if (result === false) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_ChatterUsernameUrl);
					}
					else {
						this.showToast(errormessage, errormessage, errorvariant); // Result Null/other Exception
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // then-catch Exception
				});
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // catch Exception
		}
	}
	//navigate the mypost and check if communityusername is already exist for the currentuser
	navMypost() {
		try {
			checkCommunityUsername({ userId: this.userId })
				.then((result) => {
					if (result === true) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_MyPostUrl);
					}
					else if (result === false) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_ChatterUsernameUrl);
					}
					else {
						this.showToast(errormessage, errormessage, errorvariant); // Result Null/other Exception
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // then-catch Exception
				});
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // catch Exception
		}
	}
	//navigate the my followers and check if communityusername is already exist for the currentuser
	navMyfollowers() {
		try {
			checkCommunityUsername({ userId: this.userId })
				.then((result) => {
					if (result === true) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_FollowerUrl);
					}
					else if (result === false) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_ChatterUsernameUrl);
					}
					else {
						this.showToast(errormessage, errormessage, errorvariant); // Result Null/other Exception
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // then-catch Exception
				});
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // catch Exception
		}
	}
	//navigate the following and check if communityusername is already exist for the currentuser
	navFollowing() {
		try {
			checkCommunityUsername({ userId: this.userId })
				.then((result) => {
					if (result === true) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_FollowingUrl);
					}
					else if (result === false) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_ChatterUsernameUrl);
					} else {
						this.showToast(errormessage, errormessage, errorvariant); // Result Null/other Exception
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // then-catch Exception
				});
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // catch Exception
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