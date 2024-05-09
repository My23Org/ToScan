// This lightning web component is used to Create CommunityUsername for Patient Community before Navigate to any Community Page
// To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
//  To import Apex Classes
import insertCommunityUsername from '@salesforce/apex/BI_PSPB_CommunityUsername.insertCommunityUsername';
import getCommunityUsername from '@salesforce/apex/BI_PSPB_CommunityUsername.getCommunityUsername';
import gettingAvatar from '@salesforce/apex/BI_PSPB_CommunityUsername.gettingAvatar';
//To import Static Resource
import warningIcon from '@salesforce/resourceUrl/BI_PSP_WarningIcon';
// To import Custom Labels
import brandedUrl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedUrl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import BI_PSP_ChatterSlash from '@salesforce/label/c.BI_PSP_ChatterSlash';
import BI_PSPB_AllPostUrl from '@salesforce/label/c.BI_PSPB_AllPostUrl';
export default class BiPspbChatterUsername extends (LightningElement)
{
	// Declaration of variables with @track
	@track userInputBox = 'userInputBox';
	@track loggedUserAvatar;
	@track communityUsername;
	@track showError = false;
	@track showErrorForNull = false;
	@track normal = true;
	@track showSpinner;
	//Variables
	errorImg = warningIcon;
	userId = Id;
	//ConnectedCallback used to get the path and  find the site is Branded or Unassigned
	connectedCallback() {
		try {
			this.detectBrandedOrUnassigned();
			this.avatarFunction();
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error for try-catch
		}
	}
	//Find the site is Branded or Unassigned and do the navigation accordingly
	avatarFunction() {
		try {
			gettingAvatar({ userId: this.userId })
				.then((result) => {
					if (result.length > 0 && result[0].BI_PSP_AvatarUrl__c) {
						this.loggedUserAvatar = result[0].BI_PSP_AvatarUrl__c;
					}
				})
				.catch((err) => {
					this.showToast(errormessage, err.message, errorvariant); // then-catch error
				});
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catch Error for try-catch
		}
	}
	//create Community username and Validate  if Username is null,Username equal to firstname,lastname,email and phone of Account. 
	handlecommunityUsername(event) {
		this.communityUsername = event.target.value;
		this.showError = false;
		this.showErrorForNull = false;
		this.normal = true;
	}
	// To save Community Username 
	handlesave() {
		try {
			this.userInputBox = 'userInputBox';
			if (!this.communityUsername)//If Username is null and the save button is clicked show errors
			{
				this.showErrorForNull = true;
				this.showError = false;
				this.normal = false;
				this.userInputBox = 'userInputBoxerror';
			} else {
				getCommunityUsername({ userId: this.userId })
					.then((result) => {
						this.userInputBox = 'userInputBox';
						//Validate the Entered Name and Raise error if condition not met
						if (
							result &&
							((this.communityUsername &&
								result.FirstName &&
								this.communityUsername
									.toLowerCase()
									.includes(result.FirstName.toLowerCase())) ||
								(result.LastName &&
									this.communityUsername
										.toLowerCase()
										.includes(result.LastName.toLowerCase())) ||
								(result.PersonEmail &&
									this.communityUsername
										.toLowerCase()
										.includes(result.PersonEmail.toLowerCase())) ||
								(result.Phone &&
									this.communityUsername
										.toLowerCase()
										.includes(result.Phone.toLowerCase())) ||
								(result.BI_PSP_CommunityUserName__c &&
									this.communityUsername
										.toLowerCase()
										.includes(
											result.BI_PSP_CommunityUserName__c.toLowerCase()
										)))
						) {
							this.userInputBox = 'userInputBoxerror';
							this.showError = true;
							this.showErrorForNull = false;
							this.normal = false;
						}
						//if all Validations are cleared then Create the Username  and Navigate to allpost Page
						else {
							if (this.communityUsername) {
								this.userInputBox = 'userInputBox';
								this.normal = true;
								this.showErrorForNull = false;
								this.showError = false;
								this.showSpinner = true;
								//SetTimeOut Used for loading spinner After clicking save changes while Creating Username 
								//Spinner Automattically close after few seconds and navigate allpost page if Community Username created
								try {
									setTimeout(() => {
										this.showSpinner = false;
									}, 4000);
								}
								catch (err) {
									this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error for setTimeout
								}
								insertCommunityUsername({
									userId: this.userId,
									username: this.communityUsername
								})
									.then(() => {
										window.location.assign(
											BI_PSP_ChatterSlash + this.urlq + BI_PSPB_AllPostUrl
										);
									})
									.catch((err) => {
										this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error for then-catch

									});
							}
						}
					})
					.catch((err) => {
						this.userInputBox = 'userInputBox';
						this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error for then-catch
					});
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error for try-catch
		}
	}

	// To check the site is branded or unassigned
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
			} else {
				this.urlq = unassignedUrl;
			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error for try-catch
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