//This component is used to display all followers Who are following the logedUser and the user can follow and unfollow others.
// To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import userId from '@salesforce/user/Id';
//  To import Apex Classes
import followuser from '@salesforce/apex/BI_PSPB_FollowUserCtrl.followUser';
import displayFollowers from '@salesforce/apex/BI_PSPB_FollowUserCtrl.getMyFollowers';
import unFollowUser from '@salesforce/apex/BI_PSPB_FollowUserCtrl.unfollowUser';
import gettingAvatar from '@salesforce/apex/BI_PSPB_CommunityUsername.gettingAvatar';
// To import Static Resources
import allpost from '@salesforce/resourceUrl/BI_PSP_Allpost';
import tickIcon from '@salesforce/resourceUrl/BI_PSP_Deletetoastmsg';
// To import Custom Labels
import BI_PSP_Following from '@salesforce/label/c.BI_PSP_Following';
import BI_PSP_Follower from '@salesforce/label/c.BI_PSP_Follower';
import BI_PSP_Follow from '@salesforce/label/c.BI_PSP_Follow';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorVariant from '@salesforce/label/c.BI_PSPB_errorVariant';
export default class biPspbMyFollowers extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track usernames;
	@track total = 0;
	@track followingPopup = false;
	@track followingPopupConfirmation = false;
	@track msg = '';
	@track followImgBtn = false;
	@track follow = false;
	@track following = false;
	@track selectedUserId;
	@track popup = false;
	@track selectedUser;
	@track avatarFollow;
	@track isLoading;
	@track loggedUserAvatar;
	@track showDivUnfollow = false;
	@track isDesktop = false;
	@track closeAvaataaar = 'avatarcontentno';
	@track button;
	@track showDiv = false;
	@track followPopup = false;
	@track followPopupConfirmation = false;
	//Declaration of variables
	ticicon = tickIcon;
	currentUserId = userId;
	allpostImg = allpost;
	followersCount = false;
	//This connected callback used to get Avatar,Get followers list and resize the desktop view when popup opens
	connectedCallback() {
		try {
			this.retrieveFollowers();
			this.retrieveAvatar();
			this.isDesktop = this.isDesktopView();
			window.addEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
			this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error
		}
	}
	//Used to remove the Event from the fixed screen 
	disconnectedCallback() {
		try {
			window.removeEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
			this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error
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

	// To get avatar of the users
	retrieveAvatar() {
		try {
			gettingAvatar({ userId: this.currentUserId })
				.then(result => {
					if (result.length > 0 && result[0].BI_PSP_AvatarUrl__c) {
						this.loggedUserAvatar = result[0].BI_PSP_AvatarUrl__c;
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for then-catch
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for try-catch
		}
	}
	// To retrieve all followers list
	retrieveFollowers() {
		try {
			displayFollowers({ userId: this.currentUserId })
				.then(result => {
					this.total = result.filter(follower => follower?.BI_PSP_Type__c === BI_PSP_Follower).length;
					if (result && result.length > 0) {
						this.followersCount = this.total > 0;
						if (this.total > 0) {
							this.isLoading = false;
							this.usernames = result.filter(follower => follower?.BI_PSP_Type__c === BI_PSP_Follower);
							let test1 = result.filter(follower => follower?.BI_PSP_Type__c === BI_PSP_Following);
							this.usernames = this.usernames.map(follower => (
								{
									...follower,
									followImgBtn: test1.some(obj => obj.BI_PSP_AccountUser__c === follower?.BI_PSP_AccountUser__c) ? BI_PSP_Following : BI_PSP_Follow,
									pspBrValue: follower.BI_PSP_AccountUser__r.BI_PSP_AvatarUrl__c ? follower.BI_PSP_AccountUser__r.BI_PSP_AvatarUrl__c : this.loggedUserAvatar,
								}));
						}
						if(this.total === 0){
							this.isLoading = false;
							this.followersCount = false;
						}
					}
					else if(result.length === 0 || result === null){
							this.isLoading = false;
							this.followersCount = false;
					}
					else {
						this.showToast(errormessage, errormessage, errorVariant); // Catching Potential Error for Null/other
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for then-catch
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for then-catch
		}
	}
	// To unfollow the user
	UnFollowingyes() {
		try {
			this.isLoading = true;
			unFollowUser({ accountIdToUnFollow: this.acctuserid, userIdWhoUnFollows: this.currentUserId })
				.then(() => {
					this.usernames = this.usernames.map(follower => ({
						...follower,
						followImgBtn: follower.BI_PSP_AccountUser__c === this.acctuserid ? BI_PSP_Follow : follower.followImgBtn,
					}));
					this.isLoading = false;
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for then-catch
				});
			this.followingPopup = false;
			this.followingPopupConfirmation = false;
			document.body.style.overflow = '';
			this.showDiv = false;
			this.showDivUnfollow = true;
			//Settimeout Is used to hide the toastmessage after unfollow and close automatically
			window.scrollTo({ top: 0, behavior: 'smooth' });
			try {
				setTimeout(() => {
					this.showDivUnfollow = false;
				}, 6000);
			} catch (error) {
				this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for setTimeout
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for then-catch
		}
	}
	// To follow the user
	Followyes() {
		try {
			this.isLoading = true;
			console.log('pass', this.acctuserid, this.currentUserId);
			followuser({ accountIdToFollow: this.acctuserid, userWhoFollows: this.currentUserId })
				.then(() => {
					this.usernames = this.usernames.map(follower => ({
						...follower,
						followImgBtn: follower.BI_PSP_AccountUser__c === this.acctuserid ? BI_PSP_Following : follower.followImgBtn,
					}));
					this.isLoading = false;
				})
				.catch(error => {
					console.log('insertfailre', error);
					this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for then-catch
				});
			this.followPopup = false;
			this.followPopupConfirmation = false;
			document.body.style.overflow = '';
			this.showDiv = true;
			this.showDivUnfollow = false;
			//Settimeout Is used to hide the toastmessage after unfollow and close automatically
			window.scrollTo({ top: 0, behavior: 'smooth' });
			try {
				setTimeout(() => {
					this.showDiv = false;
				}, 6000);
			}
			catch (error) {
				this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for Settimeout
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorVariant); // Catching Potential Error for try-catch
		}
	}
	// To close avatar
	closeavatar() {
		this.closeAvaataaar = 'noavatar';
	}
	// To handle follow button on click    
	handleFollowButtonClick(event) {
		this.selectedUserId = event.target.dataset.id;
		this.selectedUser = event.target.dataset.username;
		this.acctuserid = event.target.dataset.accid;
		this.button = event.target.dataset.following;
		this.avatarFollow = event.target.dataset.avatar;
		if (this.button === BI_PSP_Follow) {
			this.follow = true;
			this.followPopup = true;
			if (this.isDesktop) {
				document.body.style.overflow = 'hidden';
			} else {
				document.body.style.overflow = '';
			}
		}
		else {
			this.following = true;
			this.followingPopup = true;
			if (this.isDesktop) {
				document.body.style.overflow = 'hidden';
			} else {
				document.body.style.overflow = '';
			}
		}
	}

	// To handle follow popup when clicked on profile
	buttonhandleFollowButtonClick(event) {
		this.selectedUserId = event.target.dataset.id;
		this.selectedUser = event.target.dataset.username;
		this.acctuserid = event.target.dataset.accid;
		this.button = event.target.dataset.following;
		this.avatarFollow = event.target.dataset.avatar;
		if (this.button === BI_PSP_Follow) {
			this.followPopupConfirmation = true;
			if (this.isDesktop) {
				document.body.style.overflow = 'hidden';
			} else {
				document.body.style.overflow = '';
			}
		}
		else {
			this.followingPopupConfirmation = true;
			if (this.isDesktop) {
				document.body.style.overflow = 'hidden';
			} else {
				document.body.style.overflow = '';
			}
		}
	}

	// To close the popups
	closePopup() {
		this.followPopup = false;
		this.followPopupConfirmation = false;
		this.followingPopup = false;
		this.followingPopupConfirmation = false;
		document.body.style.overflow = '';
	}

	// To open popup when follow button is clicked
	handleFollowPopupButtonClick() {
		this.followPopupConfirmation = true;
	}

	// To close toast message
	closetoastmsg() {
		this.showDiv = false;
	}

	// To close toast message
	closetoast() {
		this.showDivUnfollow = false;
	}

	// To handle following button when clicked
	handleFollowingPopupButtonClick() {
		this.followingPopupConfirmation = true;
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = ''; // Reset to default
		}
	}

	// To open popup when following button is clicked
	handleFollowingButtonClick(event) {
		this.selectedUserId = event.target.dataset.id;
		this.selectedUser = event.target.dataset.username;
		this.acctuserid = event.target.dataset.accid;
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