// This lightning web component is used to display the Post created by them in the Patient Community (MyPosts) Page
// To import Libraries
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import current user ID
import Id from '@salesforce/user/Id';
//  To import Apex Classes
import gettingAvatar from '@salesforce/apex/BI_PSPB_CommunityUsername.gettingAvatar';
import getUserAccountId from '@salesforce/apex/BI_PSPB_FeedItemCtrl.getUserAccountId';
import checkCommunityUsername from '@salesforce/apex/BI_PSPB_CommunityUsername.checkCommunityUsername';
import mypost from '@salesforce/apex/BI_PSPB_FeedItemCtrl.myPost';
import getReactionsByFeedItemId from '@salesforce/apex/BI_PSPB_EmojiReactionCtrl.getReactionsByFeedItemId';
import emojiSave from '@salesforce/apex/BI_PSPB_EmojiReactionCtrl.saveEmoji';
import emojiFollow from '@salesforce/apex/BI_PSPB_EmojiReactionCtrl.checkFollowingStatus';
import deleteFeedItem from '@salesforce/apex/BI_PSPB_FeedItemCtrl.softDeleteFeedItem';
import totalThumbsup from '@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalThumbsup';
import totalSmile from '@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalSmile';
import totalFoldedhands from '@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalFoldedhands';
import totalHeart from '@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalHeart';
import totalThinkingface from '@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalThinkingface';
import insertCommentOption from '@salesforce/apex/BI_PSPB_FeedItemCtrl.insertComment';
import viewComments from '@salesforce/apex/BI_PSPB_FeedItemCtrl.viewComments';
import editComment from '@salesforce/apex/BI_PSPB_FeedItemCtrl.editComment';
import deleteCommentItem from '@salesforce/apex/BI_PSPB_FeedItemCtrl.softDeleteFeedCommentItem';
import followUser from '@salesforce/apex/BI_PSPB_FollowUserCtrl.followUser';
import unfollowUser from '@salesforce/apex/BI_PSPB_FollowUserCtrl.unfollowUser';
import deleteEmojiReaction from '@salesforce/apex/BI_PSPB_EmojiReactionCtrl.deleteEmojiReaction';
import getCommentOptions from '@salesforce/apex/BI_PSPB_FeedItemCtrl.getCommentOptions';
// To import Static Resources
import thumbsup from '@salesforce/resourceUrl/BI_PSP_ChatterThumbsup';
import smile from '@salesforce/resourceUrl/BI_PSP_ChatterSmile';
import handsfolded from '@salesforce/resourceUrl/BI_PSP_ChatterHandsfolded';
import heart from '@salesforce/resourceUrl/BI_PSP_ChatterHeart';
import thoughtful from '@salesforce/resourceUrl/BI_PSP_ChatterThoughtful';
import allpost from '@salesforce/resourceUrl/BI_PSP_Allpost';
import deleteIcon from '@salesforce/resourceUrl/BI_PSP_DeleteImage';
import deleteToastImage from '@salesforce/resourceUrl/BI_PSP_Deletetoastmsg';
import noCommentImg from '@salesforce/resourceUrl/BI_PSP_NoComments';
import editIcon from '@salesforce/resourceUrl/BI_PSP_EditImg';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import following from '@salesforce/label/c.BI_PSP_Following';
import You from '@salesforce/label/c.BI_PSP_chatterYou';
import noUsername from '@salesforce/label/c.BI_PSP_chatterNoUsername';
import BI_PSP_chatterYear from '@salesforce/label/c.BI_PSP_chatterYear';
import BI_PSP_chatterYears from '@salesforce/label/c.BI_PSP_chatterYears';
import BI_PSP_chatterMonth from '@salesforce/label/c.BI_PSP_chatterMonth';
import BI_PSP_chatterMonths from '@salesforce/label/c.BI_PSP_chatterMonths';
import BI_PSP_chatterDay from '@salesforce/label/c.BI_PSP_chatterDay';
import BI_PSP_chatterDays from '@salesforce/label/c.BI_PSP_chatterDays';
import BI_PSP_chatterHour from '@salesforce/label/c.BI_PSP_chatterHour';
import BI_PSP_chatterHours from '@salesforce/label/c.BI_PSP_chatterHours';
import BI_PSP_chatterMinute from '@salesforce/label/c.BI_PSP_chatterMinute';
import BI_PSP_chatterMinutes from '@salesforce/label/c.BI_PSP_chatterMinutes';
import BI_PSP_chatterSecond from '@salesforce/label/c.BI_PSP_chatterSecond';
import BI_PSP_chatterSeconds from '@salesforce/label/c.BI_PSP_chatterSeconds';
import BI_PSP_chatterAgo from '@salesforce/label/c.BI_PSP_chatterAgo';
import BI_PSPB_CreatePostUrl from '@salesforce/label/c.BI_PSPB_createpostUrl';
import BI_PSPB_ChatterUsernameUrl from '@salesforce/label/c.BI_PSPB_ChatterUsernameUrl';
import BI_PSPB_MyPostUrl from '@salesforce/label/c.BI_PSPB_myPostUrl';
import BI_PSP_chatterThumsUp from '@salesforce/label/c.BI_PSP_chatterThumsUp';
import BI_PSP_chatterSmile from '@salesforce/label/c.BI_PSP_chatterSmile';
import BI_PSP_chatterHandsFolded from '@salesforce/label/c.BI_PSP_chatterHandsFolded';
import BI_PSP_chatterHeart from '@salesforce/label/c.BI_PSP_chatterHeart';
import BI_PSP_chatterThoughtful from '@salesforce/label/c.BI_PSP_chatterThoughtful';
import BI_PSP_Thumbsup from '@salesforce/label/c.BI_PSP_Thumbsup';
import BI_PSP_Smile from '@salesforce/label/c.BI_PSP_Smile';
import BI_PSP_Foldedhand from '@salesforce/label/c.BI_PSP_Foldedhand';
import BI_PSP_Heart from '@salesforce/label/c.BI_PSP_Heart';
import BI_PSP_Thinkingface from '@salesforce/label/c.BI_PSP_Thinkingface';
import BI_PSP_ChatterUnableToReact from '@salesforce/label/c.BI_PSP_ChatterUnableToReact';
import BI_PSP_chatterNoComments from '@salesforce/label/c.BI_PSP_chatterNoComments';
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
import BI_PSP_chatterOptRootingForYou from '@salesforce/label/c.BI_PSP_chatterOptRootingForYou';
import BI_PSP_chatterOptLifeFullOf from '@salesforce/label/c.BI_PSP_chatterOptLifeFullOf';
import BI_PSP_chatterOptICantTellWhen from '@salesforce/label/c.BI_PSP_chatterOptICantTellWhen';
import BI_PSP_chatterOptThatGreat from '@salesforce/label/c.BI_PSP_chatterOptThatGreat';
import BI_PSP_chatterOptAwesome from '@salesforce/label/c.BI_PSP_chatterOptAwesome';
import BI_PSP_chatterOptKeepItUp from '@salesforce/label/c.BI_PSP_chatterOptKeepItUp';
import BI_PSP_chatterOptEnjoyReality from '@salesforce/label/c.BI_PSP_chatterGppFeelAlone';
import BI_PSP_chatterOptBraveStrong from '@salesforce/label/c.BI_PSP_chatterOptBraveStrong';
import BI_PSP_chatterOptHappyForU from '@salesforce/label/c.BI_PSP_chatterOptHappyForU';
import BI_PSP_chatterOptGetEasy from '@salesforce/label/c.BI_PSP_chatterOptGetEasy';
import BI_PSP_chatterOptThankUSaying from '@salesforce/label/c.BI_PSP_chatterOptThankUSaying';
import BI_PSP_chatterOptRightAttitude from '@salesforce/label/c.BI_PSP_chatterOptRightAttitude';
import BI_PSP_chatterOptOurLifeFull from '@salesforce/label/c.BI_PSP_chatterOptOurLifeFull';
import BI_PSP_chatterOptManyThingsCannot from '@salesforce/label/c.BI_PSP_chatterOptManyThingsCannot';
import BI_PSP_chatterOptDontGiveUp from '@salesforce/label/c.BI_PSP_chatterOptDontGiveUp';
import BI_PSP_chatterOptProudOfYou from '@salesforce/label/c.BI_PSP_chatterOptProudOfYou';
import BI_PSP_chatterOptAmazing from '@salesforce/label/c.BI_PSP_chatterOptAmazing';
import BI_PSP_chatterOptInspiration from '@salesforce/label/c.BI_PSP_chatterOptInspiration';
import BI_PSP_chatterOptEverythingAlright from '@salesforce/label/c.BI_PSP_chatterOptEverythingAlright';
import BI_PSP_chatterOptIWentThrough from '@salesforce/label/c.BI_PSP_chatterOptIWentThrough';
import BI_PSP_chatterOptEmbarrased from '@salesforce/label/c.BI_PSP_chatterOptEmbarrased';
import BI_PSP_chatterOptDontBeHard from '@salesforce/label/c.BI_PSP_chatterOptDontBeHard';
import BI_PSP_chatterOptImSoProud from '@salesforce/label/c.BI_PSP_chatterOptImSoProud';
import BI_PSP_chatterOptYouAmazing from '@salesforce/label/c.BI_PSP_chatterOptYouAmazing';
import BI_PSP_chatterOptTryNotTo from '@salesforce/label/c.BI_PSP_chatterOptTryNotTo';
import BI_PSP_chatterOptYouDefine from '@salesforce/label/c.BI_PSP_chatterOptYouDefine';
import BI_PSP_chatterOptYouGreatWonder from '@salesforce/label/c.BI_PSP_chatterOptYouGreatWonder';
import BI_PSP_chatterOptKeepUpGood from '@salesforce/label/c.BI_PSP_chatterOptKeepUpGood';
import BI_PSP_chatterOptFeltSame from '@salesforce/label/c.BI_PSP_chatterOptFeltSame';
import BI_PSP_chatterOptTalkingDoctor from '@salesforce/label/c.BI_PSP_chatterOptTalkingDoctor';
import BI_PSP_chatterOptPatientOrg from '@salesforce/label/c.BI_PSP_chatterOptPatientOrg';
import BI_PSP_chatterOptFindSomeone from '@salesforce/label/c.BI_PSP_chatterOptFindSomeone';
import BI_PSP_chatterOptStayStrong from '@salesforce/label/c.BI_PSP_chatterOptStayStrong';
import BI_PSP_chatterOptTalkPsoriasis from '@salesforce/label/c.BI_PSP_chatterOptTalkPsoriasis';
import BI_PSP_chatterOptNormalFeel from '@salesforce/label/c.BI_PSP_chatterOptNormalFeel';
import BI_PSP_chatterOptFindToTalk from '@salesforce/label/c.BI_PSP_chatterOptFindToTalk';
import BI_PSP_chatterOptHavingFeel from '@salesforce/label/c.BI_PSP_chatterOptHavingFeel';
import BI_PSP_chatterOptBeCareful from '@salesforce/label/c.BI_PSP_chatterOptBeCareful';
import BI_PSP_chatterOptFeltSameway from '@salesforce/label/c.BI_PSP_chatterOptFeltSameway';
import BI_PSP_chatterOptPossibleTo from '@salesforce/label/c.BI_PSP_chatterOptPossibleTo';
import BI_PSP_chatterOptGoodHear from '@salesforce/label/c.BI_PSP_chatterOptGoodHear';
import BI_PSP_chatterOptWonderful from '@salesforce/label/c.BI_PSP_chatterOptWonderful';
import BI_PSP_chatterOptDisease from '@salesforce/label/c.BI_PSP_chatterOptDisease';
import BI_PSP_chatterOptThankInspiration from '@salesforce/label/c.BI_PSP_chatterOptThankInspiration';
import BI_PSP_chatterOptExperienceMyself from '@salesforce/label/c.BI_PSP_chatterOptExperienceMyself';
import BI_PSP_chatterOptHopeOut from '@salesforce/label/c.BI_PSP_chatterOptHopeOut';
import BI_PSP_chatterOptDermatologi from '@salesforce/label/c.BI_PSP_chatterOptDermatologi';
import BI_PSP_chatterOptTalkEmply from '@salesforce/label/c.BI_PSP_chatterOptTalkEmply';
import BI_PSP_chatterOptDermatologistGPP from '@salesforce/label/c.BI_PSP_chatterOptDermatologistGPP';
import BI_PSP_chatterOptTryComfort from '@salesforce/label/c.BI_PSP_chatterOptTryComfort';
import BI_PSP_chatterOptPleasedHelp from '@salesforce/label/c.BI_PSP_chatterOptPleasedHelp';
import BI_PSP_chatterOptSpeakDermato from '@salesforce/label/c.BI_PSP_chatterOptSpeakDermato';
import BI_PSP_chatterOptTalkToDoctor from '@salesforce/label/c.BI_PSP_chatterOptTalkToDoctor';
import BI_PSP_chatterOptAnotherDermato from '@salesforce/label/c.BI_PSP_chatterOptAnotherDermato';
import BI_PSP_chatterOptWillPass from '@salesforce/label/c.BI_PSP_chatterOptWillPass';
import BI_PSP_chatterOptGoingFine from '@salesforce/label/c.BI_PSP_chatterOptGoingFine';
import BI_PSP_chatterOptThingsImprove from '@salesforce/label/c.BI_PSP_chatterOptThingsImprove';
import BI_PSP_chatterOptStayPositive from '@salesforce/label/c.BI_PSP_chatterOptStayPositive';
import BI_PSP_chatterOptGoingAlright from '@salesforce/label/c.BI_PSP_chatterOptGoingAlright';
import BI_PSP_chatterOptKeepPositive from '@salesforce/label/c.BI_PSP_chatterOptKeepPositive';
import BI_PSP_chatterOptSameEmotion from '@salesforce/label/c.BI_PSP_chatterOptSameEmotion';
import BI_PSP_chatterOptTalkDermatoToHelp from '@salesforce/label/c.BI_PSP_chatterOptTalkDermatoToHelp';
import BI_PSP_ChatterSlash from '@salesforce/label/c.BI_PSP_ChatterSlash';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import BI_PSPB_Error_For_Account from '@salesforce/label/c.BI_PSPB_Error_For_Account';
import BI_PSPB_Error_For_Post_Selection from '@salesforce/label/c.BI_PSPB_Error_For_Post_Selection';
export default class biPspbMyPost extends LightningElement {
	//Proper naming conventions with camel case for all the variables will be followed in the future releases
	// Declaration of variables with @track
	@track UserAccId;
	@track loggedUserAvatar;
	@track navigationFromNotificationCommentId;
	@track navigationFromNotificationReactionId;
	@track isLoading;
	@track feedItemIdToDelete;
	@track usename;
	@track countrecord;
	@track showSpinner;
	@track getthumbsup;
	@track getsmile;
	@track getfoldedhands;
	@track getheart;
	@track getthinkingface;
	@track userIdforFollow;
	@track avatarDataforreaction;
	@track feedItemIdemoji;
	@track emojitext;
	@track emojitext1;
	@track emojitext2;
	@track emojitext3;
	@track emojitext4;
	@track editComment;
	@track navtitle;
	@track navbody;
	@track showeditthecomment;
	@track commentid;
	@track commentBox;
	@track feedcommentItemIdToDelete;
	@track editTheCommentTxt = 'editTheCommentTxt';//css attribute call
	@track displayHide = '';
	@track getComments = false;
	@track showPostDetails = false;
	@track showDeleteToastMsg = false;
	@track isNewPopupOpen = false;
	@track emojifollowing = false;
	@track emojiFollowProfile = false;
	@track showDiv = false;
	@track showDivUnfollow = false;
	@track emojifollowpopup = false;
	@track emojifollowingpopup = false;
	@track noreactionforthisemoji = false;
	@track showEmojiPopup = false;
	@track displayTemplatethumbsup = true;
	@track displayTemplatesmile = false;
	@track displayTemplatefoldedhands = false;
	@track displayTemplateheart = false;
	@track displayTemplatethinkingface = false;
	@track isthreedotclassopen = false;
	@track isSecondPopupOpen = false;
	@track isFirstPopupOpen = false;
	@track showDeleteToastMsgforcomment = false;
	@track displaycomment = [];
	@track resultvalue = [];
	@track postDetails = [];
	@track avtvarfor;
	//Declaration of variables
	userId = Id;
	editImg = editIcon;
	isCurrentUserCommentCreator = false;
	comment = '';
	commentoption = [];
	imgThumbs = thumbsup;
	imgSmile = smile;
	imgHands = handsfolded;
	imgLike = heart;
	imgThought = thoughtful;
	deleteImg = deleteIcon;
	allpostImg = allpost;
	deleteToast = deleteToastImage;
	noComment = noCommentImg;

	// To fetch the account Id of the user
	@wire(getUserAccountId, { userId: '$userId' })
	wiredUserIdtoAccId({ error, data }) {
		try {
			if (data && data.length > 0) {
				this.UserAccId = data;
			}
			else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant);
			}
			else {
				this.showToast(errormessage, BI_PSPB_Error_For_Account, errorvariant);
			}
		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}
	}

	// get all records for mypost
	@wire(mypost, { userId: '$userId' })
	recordssss({ error, data }) {
		try {
			this.isLoading = true;
			if (data && data.length > 0) {
				this.showPostDetails = true;
				this.isLoading = false;
				//this map is to display mypost page with specific conditions after got all list of raw data from apex
				this.postDetails = data.map(post => ({
					...post,
					//calculate the time of post posted
					formattedTimeDifference: this.calculateTimeDifference(post.CreatedDate),
					//display total comments count of the post
					commentCount: post.BI_PSP_FeedComment__r ? post.BI_PSP_FeedComment__r.length : 0,
					//display total reaction count of the post
					countEmoji: post.BI_PSP_EmojiReactionController__r ? post.BI_PSP_EmojiReactionController__r.length : 0,
					toReact: true,
					reactionResult: '',
					showEmojiPopup: false,
					emojiYouReacted: '',
					//This opens the commentBox after navigation from notification (only if navigate from notification)
					commentBox: this.navigationFromNotificationCommentId && post.Id === this.navigationFromNotificationCommentId ? !post.commentBox : false,
					secondPopupClass: this.navigationFromNotificationReactionId && post.Id === this.navigationFromNotificationReactionId ? 'second-popup' : 'second-popup hidden',
				}));
				this.showallpost = true;
				this.checkAllReactions();
				this.commentBox = true;
				//remove the local storage id from notification navigation
				if (this.navigationFromNotificationReactionId) {
					window.localStorage.removeItem('selectedItemId');
				}
				if (this.navigationFromNotificationCommentId) {
					window.localStorage.removeItem('selectedItemIdforComment');
				}
			}
			else if (error) {
				this.isLoading = false;
				this.showToast(errormessage, error.body.message, errorvariant);
			}
			else if (data && data.length === 0 || data === null) {
				this.isLoading = false;
				this.showPostDetails = false;
			}
			else {
				this.isLoading = true;
				this.showToast(errormessage, BI_PSPB_Error_For_Post_Selection, errorvariant);
			}

		}
		catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}
	}

	//This connected callback used to get Avatar for reaction,post and comments,get localstorage value from notification navigation and set toastmessage template as false
	connectedCallback() {
		try {
			window.addEventListener('resize', this.handleResize.bind(this));
			// Navigation from Notification to view the Reacted Emoji's
			const selectedItemId = window.localStorage.getItem('selectedItemId');
			if (selectedItemId) {
				this.navigationFromNotificationReactionId = selectedItemId;
				this.viewReactionfromnavigation(this.navigationFromNotificationReactionId);
			}
			// Navigation from Notification to view the Commnets
			// Check if localStorage contains selectedItemIdforComment
			const selectedItemIdforComment = window.localStorage.getItem('selectedItemIdforComment');
			if (selectedItemIdforComment) {
				this.navigationFromNotificationCommentId = selectedItemIdforComment;
				this.commentbtnfromnavigation(this.navigationFromNotificationCommentId);
			}
			this.detectBrandedOrUnassigned();
			this.checkAllReactions();
			this.avatarImgLeftside();
			this.getComments = false;
			this.showDeleteToastMsg = false;
			this.isDesktop = this.isDesktopView();
			//This code is to find current site is Unasssigned / Branded site  and navigate accordingly
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split(BI_PSP_ChatterSlash);
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//Used to remove the Event from the fixed screen 
	disconnectedCallback() {
		try {
			window.removeEventListener('resize', this.handleResize.bind(this));
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
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

	// To get avatar of the logged in user
	avatarImgLeftside() {
		try {
			gettingAvatar({ userId: this.userId })
				.then(result => {
					if (result.length > 0 && result[0].BI_PSP_AvatarUrl__c) {
						this.loggedUserAvatar = result[0].BI_PSP_AvatarUrl__c;
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//After clicking create a new post go to createpost page with checking communityusername
	goToCreatepost() {
		try {
			checkCommunityUsername({ userId: this.userId })
				.then((result) => {
					if (result === true) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_CreatePostUrl);
					}
					else if (result === false) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_ChatterUsernameUrl);
					}
					else {
						this.showToast(errormessage, errormessage, errorvariant); // Catching Potential Error
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				})
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// Formate the Date with Created Dated like 2 yearsAgo,30 minutes ago,etc
	calculateTimeDifference(createdDate) {
		const currentTime = new Date();
		const postTime = new Date(createdDate);
		const timeDifference = currentTime - postTime;
		const seconds = Math.floor(timeDifference / 1000);
		const minutes = Math.floor(seconds / 60);
		const hours = Math.floor(minutes / 60);
		const days = Math.floor(hours / 24);
		const months = Math.floor(days / 30);
		const years = Math.floor(days / 365);
		if (years > 0) {
			return `${years} ${years === 1 ? BI_PSP_chatterYear : BI_PSP_chatterYears} ${BI_PSP_chatterAgo}`;
		} 
		if (months > 0) {
			return `${months} ${months === 1 ? BI_PSP_chatterMonth : BI_PSP_chatterMonths} ${BI_PSP_chatterAgo}`;
		} 
		if (days > 0) {
			return `${days} ${days === 1 ? BI_PSP_chatterDay : BI_PSP_chatterDays} ${BI_PSP_chatterAgo}`;
		} 
		if (hours > 0) {
			return `${hours} ${hours === 1 ? BI_PSP_chatterHour : BI_PSP_chatterHours} ${BI_PSP_chatterAgo}`;
		} 
		if (minutes > 0) {
			return `${minutes} ${minutes === 1 ? BI_PSP_chatterMinute : BI_PSP_chatterMinutes} ${BI_PSP_chatterAgo}`;
		}
		return `${seconds} ${seconds === 1 ? BI_PSP_chatterSecond : BI_PSP_chatterSeconds} ${BI_PSP_chatterAgo}`;
	}

	// close the Toast message for delete post
	closeToastMsgForPost() {
		this.showDeleteToastMsg = false;
	}

	// close the Toast message for delete post
	closeToastMsgForComment() {
		this.showDeleteToastMsgforcomment = false;
	}

	// after calling this function for used to open the delete post popup from below
	get newPopupClass() {
		return this.isNewPopupOpen ? 'new-popup-container' : 'new-popup-container hidden';
	}

	// To open a popup to delete the post
	openNewPopup(event) {
		this.postDetails = this.postDetails.map(post => ({
			...post,
			showEmojiPopup: false,
			commentBox: false,
			displayHide: '',
		}));
		this.feedItemIdToDelete = event.currentTarget.dataset.customFeeditemId;

		this.isNewPopupOpen = true;
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = '';
		}
	}

	//close the delete post popup toast message
	closeNewPopup() {
		this.isNewPopupOpen = false;
		document.body.style.overflow = '';

	}

	// To delete a post
	handleDeletePost() {
		try {
			deleteFeedItem({ feedItemId: this.feedItemIdToDelete })
				.then(() => {
					this.postDetails = this.postDetails.filter(post => post.Id !== this.feedItemIdToDelete);
					this.isNewPopupOpen = false;
					document.body.style.overflow = '';
					window.scrollTo({ top: 0, behavior: 'smooth' });
					this.showDeleteToastMsg = true;
					//Settimeout function used to close the ToastMessage automatically few seconds after it displays
					//Here it close the Delete Post toast Message
					try {
						setTimeout(() => {
							this.showDeleteToastMsg = false;
						}, 6000);
					} catch (error) {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
					}
					if (this.postDetails.length === 0) {
						window.location.assign(BI_PSP_ChatterSlash + this.urlq + BI_PSPB_MyPostUrl);
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// close Follow and unfollow toast message popup
	closetstfollow() {
		this.showDiv = false;
	}

	closetstunflw() {
		this.showDivUnfollow = false;
	}

	// To check whether the user is being followed or not 
	follorunfollemoji(event) {
		this.avtvarfor = event.currentTarget.dataset.avat;
		this.usename = event.currentTarget.dataset.name;
		this.userIdforFollow = event.currentTarget.dataset.accid;
		try {
			emojiFollow({ loggedAccountId: this.UserAccId, otherAccountId: this.userIdforFollow })
				.then(result => {
					if (this.UserAccId === this.userIdforFollow) {
						this.emojiFollowProfile = false;
						this.emojifollowing = false;
						document.body.style.overflow = '';
					}
					else if (result && result.length > 0) {
						this.countrecord = result.length;

						if (result[0].BI_PSP_Type__c === following) {
							this.emojifollowing = true;
							if (this.isDesktop) {
								document.body.style.overflow = 'hidden';
							} else {
								document.body.style.overflow = '';
							}
						} else {
							this.emojiFollowProfile = true;
							if (this.isDesktop) {
								document.body.style.overflow = 'hidden';
							} else {
								document.body.style.overflow = '';
							}
						}
					} else {
						this.emojiFollowProfile = true;
						if (this.isDesktop) {
							document.body.style.overflow = 'hidden';
						} else {
							document.body.style.overflow = '';
						}
					}
					return result;
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//open the follow/unfollow popup with fixed screen
	emojiFollowPopupButtonClick() {
		this.emojifollowpopup = true;
		this.emojiFollowProfile = false;
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = '';
		}
	}

	//close the follow/unfollow popup
	emojiclosePopup() {
		this.emojiFollowProfile = false;
		this.emojifollowpopup = false;
		this.emojifollowing = false;
		this.emojifollowingpopup = false;
		if (this.isSecondPopupOpen === true) {

			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = '';
		}
	}

	// To follow the user 
	emojiFollowyes() {
		try {
			followUser({ accountIdToFollow: this.userIdforFollow, userWhoFollows: this.userId })
				.then(() => {
					this.showDiv = true;
					window.scrollTo({ top: 0, behavior: 'smooth' });
					//Settimeout function used to close the ToastMessage automatically few seconds after it displays
					//Here it close the follow toast Message
					try {
						setTimeout(() => {
							this.showDiv = false;
						}, 6000);
					} catch (error) {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
					}
					this.showDivUnfollow = false;
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
					return false;
				});
			this.emojiFollowProfile = false;
			this.emojifollowpopup = false;
			document.body.style.overflow = '';
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//open the following popup with fixed screen
	emojiFollowingPopupButtonClick() {
		this.emojifollowingpopup = true;
		this.emojifollowing = false;
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = '';
		}
	}

	// To unfollow the user
	emojiUnFollowingyes() {
		try {
			unfollowUser({ accountIdToUnFollow: this.userIdforFollow, userIdWhoUnFollows: this.userId })
				.then(() => {
					this.showDiv = false;
					this.showDivUnfollow = true;
					window.scrollTo({ top: 0, behavior: 'smooth' });
					//Settimeout function used to close the ToastMessage automatically few seconds after it displays
					//Here it close the unfollow toast Message
					try {
						setTimeout(() => {
							this.showDivUnfollow = false;
						}, 6000);
					} catch (error) {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
					return false;
				});
			this.emojifollowing = false;
			this.emojifollowingpopup = false;
			document.body.style.overflow = '';
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//After clicking the react button show the popup with 5 emoji's (only clicked post's emoji button)
	ReactionBtn(event) {
		const postId = event.currentTarget.dataset.customFeeditemId;
		this.postDetails = this.postDetails.map(post => ({
			...post,
			showEmojiPopup: post.Id === postId ? !post.showEmojiPopup : false,
			commentBox: false,
			displayHide: '',
		}));
	}

	// After cliking the Emoji's  save the details 
	reactWith(event) {
		//show loading spinnner for react
		this.showSpinner = true;
		//Settimeout function used to close the spinner automatically few seconds after it displays
		//Here it close spinner after react cliked
		try {
			setTimeout(() => {
				this.showSpinner = false;
			}, 1000);
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
		const feedItemId = event.currentTarget.dataset.customFeeditemId;
		const emojis = event.currentTarget.dataset.reactionType;

		//call apex to store emoji saved information
		try {
			emojiSave({ reactions: emojis, feedItemId: feedItemId, userId: this.userId })
				.then(result => {
					this.resultvalue = Array.isArray(result) ? result : [result];
					if (this.resultvalue && this.resultvalue.length > 0) {
						this.resultfinal = true;
						this.postDetails = this.postDetails.map((post) => {
							if (post.Id === feedItemId) {
								return {
									...post,
									showEmojiPopup: false,
									toReact: false,
									emojiYouReacted: this.getResultEmoji(result.BI_PSP_ReactionResult__c),//then change the reactbutton to 'emoji'name that you reacted
									countEmoji: post.countEmoji + 1, //after emoji inserted increase emojicount + 1
									emojiReactedImg: this.getResultEmojiImg(result.BI_PSP_ReactionResult__c),
								};
							}
							return post;
						});
					}
					else {
						this.postDetails = this.postDetails.map(post => ({
							...post,
							showEmojiPopup: false,
						}));
						this.showToast(errormessage, BI_PSP_ChatterUnableToReact, errorvariant); // Catching Potential Error
					}
				})
				.catch(error => {
					this.postDetails = this.postDetails.map(post => ({
						...post,
						showEmojiPopup: false,
					}));
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.postDetails = this.postDetails.map(post => ({
				...post,
				showEmojiPopup: false,
			}));
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// after insert update the emojibox 
	getResultEmoji(reactionResult) {
		switch (reactionResult) {
			case BI_PSP_Thumbsup:
				return BI_PSP_chatterThumsUp;
			case BI_PSP_Smile:
				return BI_PSP_chatterSmile;
			case BI_PSP_Foldedhand:
				return BI_PSP_chatterHandsFolded;
			case BI_PSP_Heart:
				return BI_PSP_chatterHeart;
			case BI_PSP_Thinkingface:
				return BI_PSP_chatterThoughtful;
			default:
				return '';
		}
	}

	// after insert update the emojibox image
	getResultEmojiImg(reactionResult) {
		switch (reactionResult) {
			case BI_PSP_Thumbsup:
				return this.imgThumbs;
			case BI_PSP_Smile:
				return this.imgSmile;
			case BI_PSP_Foldedhand:
				return this.imgHands;
			case BI_PSP_Heart:
				return this.imgLike;
			case BI_PSP_Thinkingface:
				return this.imgThought;
			default:
				return '';
		}
	}

	//check the reactions if already reacted or not (if any changes made in mypost page)
	checkAllReactions() {
		this.postDetails.forEach((post) => {
			this.checkReactions(post.Id);
		});
	}

	// get the id of the post and do the changes accordingly
	checkReactions(postId) {
		try {
			getReactionsByFeedItemId({ feedItemId: postId, userId: this.userId })
				.then((result) => {
					if (result && result.length > 0) {
						const reactionType = parseInt(result, 10); // Assuming result is a numeric string
						const emojiMap = {
							1: BI_PSP_chatterThumsUp,
							2: BI_PSP_chatterSmile,
							3: BI_PSP_chatterHandsFolded,
							4: BI_PSP_chatterHeart,
							5: BI_PSP_chatterThoughtful,
						};
						this.postDetails = this.postDetails.map((post) => {
							if (post.Id === postId) {
								post.toReact = reactionType === undefined || isNaN(reactionType);
								post.emojiYouReacted = emojiMap[reactionType] || 'None';
								switch (post.emojiYouReacted) {
									case BI_PSP_chatterThumsUp:
										post.emojiReactedImg = this.imgThumbs || '👍';
										break;
									case BI_PSP_chatterSmile:
										post.emojiReactedImg = this.imgSmile || '😊';
										break;
									case BI_PSP_chatterHandsFolded:
										post.emojiReactedImg = this.imgHands || '🙏';
										break;
									case BI_PSP_chatterHeart:
										post.emojiReactedImg = this.imgLike || '❤️';
										break;
									case BI_PSP_chatterThoughtful:
										post.emojiReactedImg = this.imgThought || '🤔';
										break;
									default:
										post.emojiReactedImg = '';
										break;
								}
							}
							return post;
						});
					}
					else {
						this.showToast(errormessage, errormessage, errorvariant); // Catching Potential Error
					}
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// To unreact the post
	unreact(event) {
		this.postDetails = this.postDetails.map(post => ({
			...post,
			commentBox: false,
		}));
		//show loading spinnner for unreact
		this.showSpinner = true;
		//Settimeout function used to close the spinner automatically few seconds after it displays
		//Here it close spinner after unreact
		try {
			setTimeout(() => {
				this.showSpinner = false;
			}, 1000);
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
		this.showEmojiPopup = false;
		const feedItemId = event.currentTarget.dataset.customFeeditemId;
		try {
			deleteEmojiReaction({ feedItemId: feedItemId, userId: this.userId })
				.then(() => {
					this.postDetails = this.postDetails.map((post) => {
						if (post.Id === feedItemId) {
							return {
								...post,
								toReact: true,
								countEmoji: post.countEmoji - 1,//decrease the emoji count
							};
						}
						return post;
					});
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
					this.checkAllReactions();
				})
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//close the emoji reaction popup
	closeemojiPopup() {
		this.postDetails = this.postDetails.map(post => ({
			...post,
			showEmojiPopup: false
		}));
	}

	// this popup has the information about the reacted user's for the particular post    
	closeSecondPopup(event) {
		this.displayTemplatethumbsup = true;
		this.displayTemplatesmile = false;
		this.displayTemplatefoldedhands = false;
		this.displayTemplateheart = false;
		this.displayTemplatethinkingface = false;
		this.noreactionforthisemoji = false;
		const clickedPostId = event.currentTarget.dataset.customFeeditemId;
		this.postDetails = this.postDetails.map(post => ({
			...post,
			secondPopupClass: post.Id === clickedPostId ? '!second-popup' : 'second-popup hidden',
		}));
		this.isSecondPopupOpen = false;
		document.body.style.overflow = '';
		this.currentPostId = null;
	}

	//open the particular reaction popup 
	get secondPopupClass() {
		return this.isSecondPopupOpen ? '!second-popup' : 'second-popup hidden';
	}

	// After clicking show the thumbsup emoji reacted users
	viewReaction(event) {
		this.emojitext = 'emojitextbox';
		this.emojitext1 = 'emojitext';
		this.emojitext2 = 'emojitext';
		this.emojitext3 = 'emojitext';
		this.emojitext4 = 'emojitext';
		const clickedPostId = event.currentTarget.dataset.customFeeditemId;
		this.postDetails = this.postDetails.map(post => ({
			...post,
			secondPopupClass: post.Id === clickedPostId ? 'second-popup' : 'second-popup hidden',
			showEmojiPopup: false,
			commentBox: false,
			displayHide: '',
		}));
		this.isSecondPopupOpen = true;
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = '';
		}
		this.currentPostId = clickedPostId;
		this.displayTemplatethumbsup = true;
		this.feedItemIdemoji = event.currentTarget.dataset.customFeeditemId;
		try {
			totalThumbsup({ feedItemId: this.feedItemIdemoji })
				.then((result) => {
					if (result && result.length > 0) {
						this.noreactionforthisemoji = false;
						this.displayTemplatethumbsup = true;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
						this.getthumbsup = result;
						this.getthumbsup = this.getthumbsup.map(Thumbsup => ({
							...Thumbsup,
							avatarDataforreaction: Thumbsup.BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c,
							reactionyouname: this.UserAccId === Thumbsup.BI_PSP_AccountE__c ? You : Thumbsup.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
						}));
					}
					else {
						this.noreactionforthisemoji = true;
						this.displayTemplatethumbsup = false;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
					this.noreactionforthisemoji = true;
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//show thumbs emoji reaction - users
	showTemplatethumbsup() {
		this.emojitext = 'emojitextbox';
		this.emojitext1 = 'emojitext';
		this.emojitext2 = 'emojitext';
		this.emojitext3 = 'emojitext';
		this.emojitext4 = 'emojitext';
		try {
			totalThumbsup({ feedItemId: this.feedItemIdemoji })
				.then((result) => {
					if (result && result.length > 0) {
						this.noreactionforthisemoji = false
						this.displayTemplatethumbsup = true;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
						this.getthumbsup = result;
						this.getthumbsup = this.getthumbsup.map(Thumbsup => ({
							...Thumbsup,
							avatarDataforreaction: Thumbsup.BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c,
							reactionyouname: this.UserAccId === Thumbsup.BI_PSP_AccountE__c ? You : Thumbsup.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
						}));
					}
					else {
						this.noreactionforthisemoji = true;
						this.displayTemplatethumbsup = false;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
					this.noreactionforthisemoji = true;
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// show smile emoji reaction - users
	showTemplatesmile() {
		this.emojitext = 'emojitext';
		this.emojitext1 = 'emojitextbox';
		this.emojitext2 = 'emojitext';
		this.emojitext3 = 'emojitext';
		this.emojitext4 = 'emojitext';
		try {
			totalSmile({ feedItemId: this.feedItemIdemoji })
				.then((result) => {
					if (result && result.length > 0) {
						this.noreactionforthisemoji = false;
						this.displayTemplatesmile = true;
						this.getsmile = result;
						this.displayTemplatethumbsup = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
						this.getsmile = this.getsmile.map(Smile => ({
							...Smile,
							avatarDataforreaction: Smile.BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c,
							reactionyouname: this.UserAccId === Smile.BI_PSP_AccountE__c ? You : Smile.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
						}));
					}
					else {
						this.noreactionforthisemoji = true;
						this.displayTemplatethumbsup = false;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
					}
				})
				.catch(error => {
					this.noreactionforthisemoji = true;
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//show foldedhands emoji reaction - users
	showTemplatefoldedhands() {
		this.emojitext = 'emojitext';
		this.emojitext1 = 'emojitext';
		this.emojitext2 = 'emojitextbox';
		this.emojitext3 = 'emojitext';
		this.emojitext4 = 'emojitext';
		try {
			totalFoldedhands({ feedItemId: this.feedItemIdemoji })
				.then((result) => {
					if (result && result.length > 0) {
						this.noreactionforthisemoji = false;
						this.displayTemplatefoldedhands = true;
						this.getfoldedhands = result;
						this.displayTemplatethumbsup = false;
						this.displayTemplatesmile = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
						this.getfoldedhands = this.getfoldedhands.map(foldedhands => ({
							...foldedhands,
							avatarDataforreaction: foldedhands.BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c,
							reactionyouname: this.UserAccId === foldedhands.BI_PSP_AccountE__c ? You : foldedhands.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
						}));
					}
					else {
						this.noreactionforthisemoji = true;
						this.displayTemplatethumbsup = false;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
					}
				})
				.catch(error => {
					this.noreactionforthisemoji = true;
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//show heart emoji reaction - users
	showTemplateheart() {
		this.emojitext = 'emojitext';
		this.emojitext1 = 'emojitext';
		this.emojitext2 = 'emojitext';
		this.emojitext3 = 'emojitextbox';
		this.emojitext4 = 'emojitext';
		try {
			totalHeart({ feedItemId: this.feedItemIdemoji })
				.then((result) => {
					if (result && result.length > 0) {
						this.noreactionforthisemoji = false;
						this.displayTemplateheart = true;
						this.getheart = result;
						this.displayTemplatethumbsup = false;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplatethinkingface = false;
						this.getheart = this.getheart.map(Heart => ({
							...Heart,
							avatarDataforreaction: Heart.BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c,
							reactionyouname: this.UserAccId === Heart.BI_PSP_AccountE__c ? You : Heart.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
						}));
					}
					else {
						this.noreactionforthisemoji = true;
						this.displayTemplatethumbsup = false;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
					}
				})
				.catch(error => {
					this.noreactionforthisemoji = true;
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//show thinkingface emoji reaction - users
	showTemplatethinkingface() {
		this.emojitext = 'emojitext';
		this.emojitext1 = 'emojitext';
		this.emojitext2 = 'emojitext';
		this.emojitext3 = 'emojitext';
		this.emojitext4 = 'emojitextbox';
		try {
			totalThinkingface({ feedItemId: this.feedItemIdemoji })
				.then((result) => {
					if (result && result.length > 0) {
						this.noreactionforthisemoji = false;
						this.displayTemplatethinkingface = true;
						this.getthinkingface = result;
						this.displayTemplatethumbsup = false;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.getthinkingface = this.getthinkingface.map(think => ({
							...think,
							avatarDataforreaction: think.BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c,
							reactionyouname: this.UserAccId === think.BI_PSP_AccountE__c ? You : think.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
						}));
					}
					else {
						this.noreactionforthisemoji = true;
						this.displayTemplatethumbsup = false;
						this.displayTemplatesmile = false;
						this.displayTemplatefoldedhands = false;
						this.displayTemplateheart = false;
						this.displayTemplatethinkingface = false;
					}
				})
				.catch(error => {
					this.noreactionforthisemoji = true;
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//show these three dot at only mobile view    
	get threedotclass() {
		return this.isthreedotclassopen ? 'threedot-container' : 'threedot-container hidden';
	}

	threedotopen(event) {
		this.commentid = event.currentTarget.dataset.customFeeditemId;
		this.displaycomment = this.displaycomment.map(comment => ({
			...comment,
			threedotclass: comment.Id === this.commentid ? !comment.threedotclass : false,
		}));
		this.isthreedotclassopen = true;
		document.body.style.overflow = 'hidden';
	}

	//close the action popup 
	closethreedot() {
		this.isthreedotclassopen = false;
		document.body.style.overflow = '';
	}

	get firstPopupClass() {
		return this.isFirstPopupOpen ? 'popup-container' : 'popup-container hidden';
	}

	//OPEN THE ACTION POPUP after clicking the threedots
	openFirstPopup(event) {
		this.isthreedotclassopen = false;
		document.body.style.overflow = '';
		this.feedcommentItemIdToDelete = event.currentTarget.dataset.customFeeditemId;
		this.postitemid = event.currentTarget.dataset.customPostitemId;
		this.isFirstPopupOpen = true;
		document.body.style.overflow = 'hidden';
	}

	//close the delete comment confirmation popup
	closeFirstPopup() {
		this.isFirstPopupOpen = false;
		document.body.style.overflow = '';
	}

	// To delete the comment
	handledelete() {
		this.isFirstPopupOpen = false;
		document.body.style.overflow = '';
		try {
			deleteCommentItem({ feedCommentItemId: this.feedcommentItemIdToDelete })
				.then(() => {
					this.displaycomment = this.displaycomment.filter(comment => comment.Id !== this.feedcommentItemIdToDelete);
					this.postDetails = this.postDetails.map(post => {
						if (post.Id === this.postitemid) {
							return {
								...post,
								commentCount: post.commentCount - 1,
							};
						}
						return post;
					});
					window.scrollTo({ top: 0, behavior: 'smooth' });
					//Settimeout function used to close the ToastMessage automatically few seconds after it displays
					//Here it close the Delete Comment toast Message
					this.showDeleteToastMsgforcomment = true;
					try {
						setTimeout(() => {
							this.showDeleteToastMsgforcomment = false;
						}, 6000);
					} catch (error) {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	//close the commentbox 
	commentcancel() {
		this.postDetails = this.postDetails.map(post => ({
			...post,
			commentBox: false,
			displayHide: '',
		}));
		this.comment = '';
		this.commentoption = [];
	}

	// To comment on a post
	handleCommentChange(event) {
		this.comment = event.target.value;
		try {
			if (this.comment && this.comment !== BI_PSP_chatterNoComments) {
				const feedItemId = event.currentTarget.dataset.customFeeditemId;
				insertCommentOption({ commentContent: this.comment, postId: feedItemId, userId: this.userId })
					.then(() => {

						this.comment = '';
						this.postDetails = this.postDetails.map(post => {
							if (post.Id === feedItemId) {
								return {
									...post,
									commentCount: post.commentCount + 1,
									commentBox: post.Id === feedItemId ? !post.commentBox : false,
									displayHide: post.Id === feedItemId && !post.commentBox ? 'Hide' : '',
								};
							}
							return post;
						});
						this.comment = '';
					})
					.catch(error => {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
						this.comment = '';
					});
			}
			else {
				this.comment = '';
			}
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// To edit the comment for a post
	editTheComment(event) {
		this.editTheCommentTxt = 'editTheCommentTxt';
		this.isthreedotclassopen = false;
		document.body.style.overflow = '';

		this.commentid = event.currentTarget.dataset.customFeeditemId;
		this.displaycomment = this.displaycomment.map(comment => ({
			...comment,
			showeditthecomment: comment.Id === this.commentid ? !comment.showeditthecomment : false,
		}));
	}

	//Hide the edit dropdown
	closeshoweditthecomment() {
		this.editTheCommentTxt = 'HideeditTheCommentTxt';
		this.displaycomment = this.displaycomment.map(comment => ({
			...comment,
			showeditthecomment: false,
		}));
	}

	//To update the comment
	handleCommentChangeedit(event) {
		try {
			this.editComment = event.target.value;
			this.commentId = event.currentTarget.dataset.customFeeditemId;
			if (this.editComment && this.editComment !== BI_PSP_chatterNoComments) {
				editComment({ commentToUpdate: this.editComment, commentId: this.commentid })
					.then(result => {
						if (result && result !== null) {
							this.displaycomment = this.displaycomment.map((comment) => {
								if (comment.Id === this.commentid) {
									return {
										...comment,
										BI_PSP_Comment__c: result.BI_PSP_Comment__c,
										showeditthecomment: false,
									};
								}
								return comment;
							});
							this.editComment = '';
							this.comment = '';
						} else {
							this.editComment = '';
							this.comment = '';
							this.showToast(errormessage, errormessage, errorvariant); // Catching Potential Error
						}
					})
					.catch(error => {
						this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
						this.editComment = '';
						this.comment = '';
					});
			}
		}
		catch (error) {
			this.editComment = '';
			this.comment = '';
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
	}

	// To calculate time difference for comments from creaed time
	calculateTimeDifferenceforcomment(createdDate) {
		const currentTime = new Date();
		const postTime = new Date(createdDate);
		const timeDifference = currentTime - postTime;
		const seconds = Math.floor(timeDifference / 1000);
		const minutes = Math.floor(seconds / 60);
		const hours = Math.floor(minutes / 60);
		const days = Math.floor(hours / 24);
		const months = Math.floor(days / 30);
		const years = Math.floor(days / 365);
		if (years > 0) {
			return `${years} ${years === 1 ? BI_PSP_chatterYear : BI_PSP_chatterYears} ${BI_PSP_chatterAgo}`;
		} 
		if (months > 0) {
			return `${months} ${months === 1 ? BI_PSP_chatterMonth : BI_PSP_chatterMonths} ${BI_PSP_chatterAgo}`;
		} 
		if (days > 0) {
			return `${days} ${days === 1 ? BI_PSP_chatterDay : BI_PSP_chatterDays} ${BI_PSP_chatterAgo}`;
		} 
		if (hours > 0) {
			return `${hours} ${hours === 1 ? BI_PSP_chatterHour : BI_PSP_chatterHours} ${BI_PSP_chatterAgo}`;
		} 
		if (minutes > 0) {
			return `${minutes} ${minutes === 1 ? BI_PSP_chatterMinute : BI_PSP_chatterMinutes} ${BI_PSP_chatterAgo}`;
		}
		return `${seconds} ${seconds === 1 ? BI_PSP_chatterSecond : BI_PSP_chatterSeconds} ${BI_PSP_chatterAgo}`;
	}

	//comment button and show the comments (users who commented for the post with date,name,comment etc...)
	closecomment(event) {
		const postId = event.currentTarget.dataset.customFeeditemId;
		this.postDetails = this.postDetails.map(post => ({
			...post,
			commentBox: post.Id === postId ? !post.commentBox : false,
			displayHide: '',
		}));
		this.commentBox = true;
	}
	commentbtn(event) {
		const postId = event.currentTarget.dataset.customFeeditemId;
		this.postDetails = this.postDetails.map(post => ({
			...post,
			commentBox: post.Id === postId ? !post.commentBox : false,
			displayHide: post.Id === postId && !post.commentBox ? 'Hide' : '',
			showEmojiPopup: false
		}));
		this.commentBox = true;
		try {
			viewComments({ feedItemId: postId })
				.then(result => {
					if (result && result.length > 0) {
						this.displaycomment = result;
						this.getComments = true;
						this.displaycomment = result.map(post => ({
							...post,
							formattedTimeDifferenceforcomment: this.calculateTimeDifferenceforcomment(post.CreatedDate),
							isCurrentUserCommentCreator: this.UserAccId === post.BI_PSP_AccountCmt__c,
							avatarDataforcomment: post.BI_PSP_AccountCmt__r.BI_PSP_AvatarUrl__c,
							youname: this.UserAccId === post.BI_PSP_AccountCmt__c ? You : (post.BI_PSP_AccountCmt__r.BI_PSP_CommunityUsername__c != null ? post.BI_PSP_AccountCmt__r.BI_PSP_CommunityUsername__c : noUsername),
						}));
					}
					else {
						this.getComments = false;
					}
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error1
					this.getComments = false;
				});
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
		}
		// filter the comments options  according to phrase and category
		const title = event.currentTarget.dataset.customFeeditemTitle;
		const body = event.currentTarget.dataset.customFeeditemBody;

		if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeIMiss) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
				{ label: BI_PSP_chatterOptLifeFullOf, value: BI_PSP_chatterOptLifeFullOf },
				{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
			];
		}
		else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeWorking) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptEnjoyReality, value: BI_PSP_chatterOptEnjoyReality },
				{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
			];
		}
		else if (body === BI_PSP_chatterLifeNotAlways && title === BI_PSP_chatterLifestyle) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptGetEasy, value: BI_PSP_chatterOptGetEasy },
				{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
				{ label: BI_PSP_chatterOptThankUSaying, value: BI_PSP_chatterOptThankUSaying },
				{ label: BI_PSP_chatterOptRightAttitude, value: BI_PSP_chatterOptRightAttitude },
			];
		}
		else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeMyCloth) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
				{ label: BI_PSP_chatterOptOurLifeFull, value: BI_PSP_chatterOptOurLifeFull },
				{ label: BI_PSP_chatterOptManyThingsCannot, value: BI_PSP_chatterOptManyThingsCannot },
			];
		}
		else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeIWould) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
				{ label: BI_PSP_chatterOptDontGiveUp, value: BI_PSP_chatterOptDontGiveUp },
				{ label: BI_PSP_chatterOptManyThingsCannot, value: BI_PSP_chatterOptManyThingsCannot },
			];
		}
		else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeEvenGpp) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptProudOfYou, value: BI_PSP_chatterOptProudOfYou },
				{ label: BI_PSP_chatterOptAmazing, value: BI_PSP_chatterOptAmazing },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
			];
		}
		else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeAfterOver) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptInspiration, value: BI_PSP_chatterOptInspiration },
				{ label: BI_PSP_chatterOptOurLifeFull, value: BI_PSP_chatterOptOurLifeFull },
				{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
			];
		}
		else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeThereAre) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
				{ label: BI_PSP_chatterOptGetEasy, value: BI_PSP_chatterOptGetEasy },
				{ label: BI_PSP_chatterOptEverythingAlright, value: BI_PSP_chatterOptEverythingAlright },
				{ label: BI_PSP_chatterOptOurLifeFull, value: BI_PSP_chatterOptOurLifeFull },
				{ label: BI_PSP_chatterOptManyThingsCannot, value: BI_PSP_chatterOptManyThingsCannot },

			];
		}
		else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeIDid) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialActivelyWork) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptIWentThrough, value: BI_PSP_chatterOptIWentThrough },
				{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
				{ label: BI_PSP_chatterOptEverythingAlright, value: BI_PSP_chatterOptEverythingAlright },
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialToExplain) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptEmbarrased, value: BI_PSP_chatterOptEmbarrased },
				{ label: BI_PSP_chatterOptDontBeHard, value: BI_PSP_chatterOptDontBeHard },
				{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialTalking) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptImSoProud, value: BI_PSP_chatterOptImSoProud },
				{ label: BI_PSP_chatterOptYouAmazing, value: BI_PSP_chatterOptYouAmazing },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialOnlyClose) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptTryNotTo, value: BI_PSP_chatterOptTryNotTo },
				{ label: BI_PSP_chatterOptEmbarrased, value: BI_PSP_chatterOptEmbarrased },
				{ label: BI_PSP_chatterOptYouDefine, value: BI_PSP_chatterOptYouDefine }
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialSharedMy) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialStaying) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
				{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialWantToIntimate) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptIWentThrough, value: BI_PSP_chatterOptIWentThrough },
				{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
				{ label: BI_PSP_chatterOptEverythingAlright, value: BI_PSP_chatterOptEverythingAlright },
				{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialGotChance) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialEmbarrase) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptEmbarrased, value: BI_PSP_chatterOptEmbarrased },
				{ label: BI_PSP_chatterOptTryNotTo, value: BI_PSP_chatterOptTryNotTo },
				{ label: BI_PSP_chatterOptYouDefine, value: BI_PSP_chatterOptYouDefine },
				{ label: BI_PSP_chatterOptYouGreatWonder, value: BI_PSP_chatterOptYouGreatWonder },
			];
		}
		else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialThingsBetter) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptKeepUpGood, value: BI_PSP_chatterOptKeepUpGood },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
			];
		}
		else if (title === BI_PSP_chatterMedical && body === BI_PSP_chatterMedicalDontFeel) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptFeltSame, value: BI_PSP_chatterOptFeltSame },
				{ label: BI_PSP_chatterOptTalkingDoctor, value: BI_PSP_chatterOptTalkingDoctor },
				{ label: BI_PSP_chatterOptPatientOrg, value: BI_PSP_chatterOptPatientOrg },
				{ label: BI_PSP_chatterOptFindSomeone, value: BI_PSP_chatterOptFindSomeone },
			];
		}
		else if (title === BI_PSP_chatterMedical && body === BI_PSP_chatterMedicalSeenDoc) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptStayStrong, value: BI_PSP_chatterOptStayStrong },
				{ label: BI_PSP_chatterOptTalkPsoriasis, value: BI_PSP_chatterOptTalkPsoriasis },
				{ label: BI_PSP_chatterOptFeltSame, value: BI_PSP_chatterOptFeltSame },
			];
		}
		else if (title === BI_PSP_chatterMedical && body === BI_PSP_chatterMedicalFinally) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
			];
		}
		else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycFeelAlone) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptIWentThrough, value: BI_PSP_chatterOptIWentThrough },
				{ label: BI_PSP_chatterOptNormalFeel, value: BI_PSP_chatterOptNormalFeel },
				{ label: BI_PSP_chatterOptFindToTalk, value: BI_PSP_chatterOptFindToTalk },
				{ label: BI_PSP_chatterOptStayStrong, value: BI_PSP_chatterOptStayStrong },
				{ label: BI_PSP_chatterOptHavingFeel, value: BI_PSP_chatterOptHavingFeel },
			];
		}
		else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycFeelAnxious) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
				{ label: BI_PSP_chatterOptNormalFeel, value: BI_PSP_chatterOptNormalFeel },
				{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
			];
		}
		else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycWornOut) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptBeCareful, value: BI_PSP_chatterOptBeCareful },
				{ label: BI_PSP_chatterOptFeltSameway, value: BI_PSP_chatterOptFeltSameway },
				{ label: BI_PSP_chatterOptPossibleTo, value: BI_PSP_chatterOptPossibleTo },
				{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
			];
		}
		else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycThingsBetter) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
				{ label: BI_PSP_chatterOptGoodHear, value: BI_PSP_chatterOptGoodHear },
				{ label: BI_PSP_chatterOptWonderful, value: BI_PSP_chatterOptWonderful },
			];
		}
		else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycDontLetGpp) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptDisease, value: BI_PSP_chatterOptDisease },
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptKeepUpGood, value: BI_PSP_chatterOptKeepUpGood },
				{ label: BI_PSP_chatterOptThankInspiration, value: BI_PSP_chatterOptThankInspiration },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
			];
		}
		else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycGPPHardBattle) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptNormalFeel, value: BI_PSP_chatterOptNormalFeel },
				{ label: BI_PSP_chatterOptExperienceMyself, value: BI_PSP_chatterOptExperienceMyself },
				{ label: BI_PSP_chatterOptStayStrong, value: BI_PSP_chatterOptStayStrong },
			];
		}
		else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycTodayFeel) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptHopeOut, value: BI_PSP_chatterOptHopeOut },
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptKeepUpGood, value: BI_PSP_chatterOptKeepUpGood },
				{ label: BI_PSP_chatterOptThankInspiration, value: BI_PSP_chatterOptThankInspiration },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
			];
		}
		else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycEvenThough) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptKeepUpGood, value: BI_PSP_chatterOptKeepUpGood },
				{ label: BI_PSP_chatterOptThankInspiration, value: BI_PSP_chatterOptThankInspiration },
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
			];
		}
		else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycIAccept) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
			];
		}
		else if (title === BI_PSP_chatterOccupation && body === BI_PSP_chatterOccICannot) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptDermatologi, value: BI_PSP_chatterOptDermatologi },
				{ label: BI_PSP_chatterOptTalkEmply, value: BI_PSP_chatterOptTalkEmply },
				{ label: BI_PSP_chatterOptIWentThrough, value: BI_PSP_chatterOptIWentThrough },
			];
		}
		else if (title === BI_PSP_chatterOccupation && body === BI_PSP_chatterOccComplicate) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptDermatologistGPP, value: BI_PSP_chatterOptDermatologistGPP },
				{ label: BI_PSP_chatterOptTryComfort, value: BI_PSP_chatterOptTryComfort },
				{ label: BI_PSP_chatterOptTalkingDoctor, value: BI_PSP_chatterOptTalkingDoctor },
			];
		}
		else if (title === BI_PSP_chatterOccupation && body === BI_PSP_chatterOccWorlColleague) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
			];
		}

		else if (title === BI_PSP_chatterOccupation && body === BI_PSP_chatterOccFeelMyFamily) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptPleasedHelp, value: BI_PSP_chatterOptPleasedHelp },
				{ label: BI_PSP_chatterOptSpeakDermato, value: BI_PSP_chatterOptSpeakDermato },
			];
		}
		else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppIDontKnow) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptTalkToDoctor, value: BI_PSP_chatterOptTalkToDoctor },
				{ label: BI_PSP_chatterOptFindToTalk, value: BI_PSP_chatterOptFindToTalk },
				{ label: BI_PSP_chatterOptAnotherDermato, value: BI_PSP_chatterOptAnotherDermato },
			];
		}
		else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppWhileGiving) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptWillPass, value: BI_PSP_chatterOptWillPass },
				{ label: BI_PSP_chatterOptGoingFine, value: BI_PSP_chatterOptGoingFine },
				{ label: BI_PSP_chatterOptThingsImprove, value: BI_PSP_chatterOptThingsImprove },
				{ label: BI_PSP_chatterOptGetEasy, value: BI_PSP_chatterOptGetEasy },
				{ label: BI_PSP_chatterOptStayPositive, value: BI_PSP_chatterOptStayPositive },
			];
		}
		else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppSkinImprove) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
			];
		}
		else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppActivelyExplore) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptStayPositive, value: BI_PSP_chatterOptStayPositive },
				{ label: BI_PSP_chatterOptGoingAlright, value: BI_PSP_chatterOptGoingAlright },
				{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
			];
		}
		else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppUnderstanding) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
				{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
				{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
				{ label: BI_PSP_chatterOptRightAttitude, value: BI_PSP_chatterOptRightAttitude },
				{ label: BI_PSP_chatterOptKeepPositive, value: BI_PSP_chatterOptKeepPositive },
			];
		}
		else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppFeelAlone) {
			this.commentoption = [
				{ label: BI_PSP_chatterOptSameEmotion, value: BI_PSP_chatterOptSameEmotion },
				{ label: BI_PSP_chatterOptTalkToDoctor, value: BI_PSP_chatterOptTalkToDoctor },
				{ label: BI_PSP_chatterOptTalkDermatoToHelp, value: BI_PSP_chatterOptTalkDermatoToHelp },
			];
		}
		else {
			this.commentoption = [
				{ label: BI_PSP_chatterNoComments, value: BI_PSP_chatterNoComments },
			];
		}
	}

	//after clicking the reactions button on the notification components it redirect to mypost, so open the particular reacted post
	//scroll to the particular post and open the viewReaction popup
	viewReactionfromnavigation(navigationFromNotificationReactionId) {
		this.emojitext = 'emojitextbox';
		this.emojitext1 = 'emojitext';
		this.emojitext2 = 'emojitext';
		this.emojitext3 = 'emojitext';
		this.emojitext4 = 'emojitext';

		const clickedPostId = navigationFromNotificationReactionId;
		this.postDetails = this.postDetails.map(post => ({
			...post,
			secondPopupClass: post.Id === clickedPostId ? 'second-popup' : 'second-popup hidden',
			showEmojiPopup: false,
			commentBox: false,
		}));
		this.isSecondPopupOpen = true;
		if (this.isDesktop) {
			document.body.style.overflow = 'hidden';
		} else {
			document.body.style.overflow = '';
		}
		this.currentPostId = clickedPostId;
		this.displayTemplatethumbsup = true;
		this.feedItemIdemoji = clickedPostId;
		totalThumbsup({ feedItemId: this.feedItemIdemoji })
			.then((result) => {
				if (result && result.length > 0) {
					this.noreactionforthisemoji = false;
					this.displayTemplatethumbsup = true;
					this.displayTemplatesmile = false;
					this.displayTemplatefoldedhands = false;
					this.displayTemplateheart = false;
					this.displayTemplatethinkingface = false;
					this.getthumbsup = result;
					this.getthumbsup = this.getthumbsup.map(Thumbsup => ({
						...Thumbsup,
						avatarDataforreaction: Thumbsup.BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c,
						reactionyouname: this.UserAccId === Thumbsup.BI_PSP_AccountE__c ? You : Thumbsup.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
					}));
				}
				else {
					this.noreactionforthisemoji = true;
					this.displayTemplatethumbsup = false;
					this.displayTemplatesmile = false;
					this.displayTemplatefoldedhands = false;
					this.displayTemplateheart = false;
					this.displayTemplatethinkingface = false;
				}
			})
			.catch(error => {

				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
				this.noreactionforthisemoji = true;
			});
		//setInterval is used for open the particular Comment when user create the reaction and click the view comments button on notification page
		//it should open that particular comment only with the localstorage id by passing from  biPspbgeneralnotificationform
		let counter = 0
		let intervalId = setInterval(() => {
			counter = counter + 1;
			const postElementbyclass = this.template.querySelector('.' + clickedPostId);
			if (postElementbyclass) {
				postElementbyclass.scrollIntoView({ behavior: 'smooth', block: 'start' });
				clearInterval(intervalId); // Stop the interval
			}
			if (counter === 5) {
				clearInterval(intervalId);
			}
		}, 1000);
	}

	//scroll to the particular comment and open the commentBox
	commentbtnfromnavigation(navigationFromNotificationCommentId) {
		const postId = navigationFromNotificationCommentId;
		this.postDetails = this.postDetails.map(post => ({
			...post,
			commentBox: post.Id === postId ? !post.commentBox : false,
			displayHide: post.Id === postId && !post.commentBox ? 'Hide' : '',
			showEmojiPopup: false,
		}));
		this.commentBox = true;
		//setInterval is used for open the particular Comment when user create the comment and click the view comments button on notification page
		//it should open that particular comment only with the localstorage id by passing from  biPspbgeneralnotificationform
		let counter = 0
		let intervalId = setInterval(() => {
			counter = counter + 1;
			const postElementbyclass = this.template.querySelector('.' + postId);
			if (postElementbyclass) {
				postElementbyclass.scrollIntoView({ behavior: 'smooth', block: 'start' });
				clearInterval(intervalId); // Stop the interval
				this.postDetails = this.postDetails.map(post => ({
					...post,
					displayHide: post.Id === postId && post.commentBox ? 'Hide' : '',
					showEmojiPopup: false,
				}));
			}
			if (counter === 5) {
				clearInterval(intervalId);
			}
		}, 100);
		//show other user comments for a post after navigation from notification
		viewComments({ feedItemId: postId })
			.then(result => {
				if (result && result.length > 0) {
					this.displaycomment = result;
					this.getComments = true;

					this.displaycomment = result.map(post => ({
						...post,
						formattedTimeDifferenceforcomment: this.calculateTimeDifferenceforcomment(post.CreatedDate),
						isCurrentUserCommentCreator: this.UserAccId === post.BI_PSP_AccountCmt__c,
						avatarDataforcomment: post.BI_PSP_AccountCmt__r.BI_PSP_AvatarUrl__c,
						youname: this.UserAccId === post.BI_PSP_AccountCmt__c ? You : post.BI_PSP_AccountCmt__r.BI_PSP_CommunityUsername__c,
					}));
				}
				else {
					this.getComments = false;
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
				this.getComments = false;
			});
		// get title and phrases for navigation from notification to comments
		getCommentOptions({ feedItemId: postId })
			.then(result => {
				if (result && result.length > 0) {
					this.navtitle = result[0].BI_PSP_Category__c;
					this.navbody = result[0].BI_PSP_Phrase__c;

					const title = this.navtitle;
					const body = this.navbody;
					//This Dependent dropdown are again implemented for after clicking the comments from notification it should be contagious 
					//so,After getting id from the notification via local storage the dependent dropdown shows the value based on the post category and phrase
					if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeIMiss) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
							{ label: BI_PSP_chatterOptLifeFullOf, value: BI_PSP_chatterOptLifeFullOf },
							{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
						];
					}
					else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeWorking) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptEnjoyReality, value: BI_PSP_chatterOptEnjoyReality },
							{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
						];
					}
					else if (body === BI_PSP_chatterLifeNotAlways && title === BI_PSP_chatterLifestyle) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptGetEasy, value: BI_PSP_chatterOptGetEasy },
							{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
							{ label: BI_PSP_chatterOptThankUSaying, value: BI_PSP_chatterOptThankUSaying },
							{ label: BI_PSP_chatterOptRightAttitude, value: BI_PSP_chatterOptRightAttitude },
						];
					}
					else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeMyCloth) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
							{ label: BI_PSP_chatterOptOurLifeFull, value: BI_PSP_chatterOptOurLifeFull },
							{ label: BI_PSP_chatterOptManyThingsCannot, value: BI_PSP_chatterOptManyThingsCannot },
						];
					}
					else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeIWould) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
							{ label: BI_PSP_chatterOptDontGiveUp, value: BI_PSP_chatterOptDontGiveUp },
							{ label: BI_PSP_chatterOptManyThingsCannot, value: BI_PSP_chatterOptManyThingsCannot },
						];
					}
					else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeEvenGpp) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptProudOfYou, value: BI_PSP_chatterOptProudOfYou },
							{ label: BI_PSP_chatterOptAmazing, value: BI_PSP_chatterOptAmazing },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
						];
					}
					else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeAfterOver) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptInspiration, value: BI_PSP_chatterOptInspiration },
							{ label: BI_PSP_chatterOptOurLifeFull, value: BI_PSP_chatterOptOurLifeFull },
							{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
						];
					}
					else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeThereAre) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
							{ label: BI_PSP_chatterOptGetEasy, value: BI_PSP_chatterOptGetEasy },
							{ label: BI_PSP_chatterOptEverythingAlright, value: BI_PSP_chatterOptEverythingAlright },
							{ label: BI_PSP_chatterOptOurLifeFull, value: BI_PSP_chatterOptOurLifeFull },
							{ label: BI_PSP_chatterOptManyThingsCannot, value: BI_PSP_chatterOptManyThingsCannot },

						];
					}

					else if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeIDid) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
						];
					}

					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialActivelyWork) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptIWentThrough, value: BI_PSP_chatterOptIWentThrough },
							{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
							{ label: BI_PSP_chatterOptEverythingAlright, value: BI_PSP_chatterOptEverythingAlright },
						];
					}
					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialToExplain) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptEmbarrased, value: BI_PSP_chatterOptEmbarrased },
							{ label: BI_PSP_chatterOptDontBeHard, value: BI_PSP_chatterOptDontBeHard },
							{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
						];
					}

					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialTalking) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptImSoProud, value: BI_PSP_chatterOptImSoProud },
							{ label: BI_PSP_chatterOptYouAmazing, value: BI_PSP_chatterOptYouAmazing },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
						];
					}
					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialOnlyClose) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptTryNotTo, value: BI_PSP_chatterOptTryNotTo },
							{ label: BI_PSP_chatterOptEmbarrased, value: BI_PSP_chatterOptEmbarrased },
							{ label: BI_PSP_chatterOptYouDefine, value: BI_PSP_chatterOptYouDefine }
						];
					}
					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialSharedMy) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
						];
					}
					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialStaying) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
							{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },

						];
					}
					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialWantToIntimate) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptIWentThrough, value: BI_PSP_chatterOptIWentThrough },
							{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
							{ label: BI_PSP_chatterOptEverythingAlright, value: BI_PSP_chatterOptEverythingAlright },
							{ label: BI_PSP_chatterOptBraveStrong, value: BI_PSP_chatterOptBraveStrong },
						];
					}
					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialGotChance) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
						];
					}
					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialEmbarrase) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptEmbarrased, value: BI_PSP_chatterOptEmbarrased },
							{ label: BI_PSP_chatterOptTryNotTo, value: BI_PSP_chatterOptTryNotTo },
							{ label: BI_PSP_chatterOptYouDefine, value: BI_PSP_chatterOptYouDefine },
							{ label: BI_PSP_chatterOptYouGreatWonder, value: BI_PSP_chatterOptYouGreatWonder },
						];
					}
					else if (title === BI_PSP_chatterSocial && body === BI_PSP_chatterSocialThingsBetter) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptKeepUpGood, value: BI_PSP_chatterOptKeepUpGood },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
						];
					}

					else if (title === BI_PSP_chatterMedical && body === BI_PSP_chatterMedicalDontFeel) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptFeltSame, value: BI_PSP_chatterOptFeltSame },
							{ label: BI_PSP_chatterOptTalkingDoctor, value: BI_PSP_chatterOptTalkingDoctor },
							{ label: BI_PSP_chatterOptPatientOrg, value: BI_PSP_chatterOptPatientOrg },
							{ label: BI_PSP_chatterOptFindSomeone, value: BI_PSP_chatterOptFindSomeone },
						];

					}

					else if (title === BI_PSP_chatterMedical && body === BI_PSP_chatterMedicalSeenDoc) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptStayStrong, value: BI_PSP_chatterOptStayStrong },
							{ label: BI_PSP_chatterOptTalkPsoriasis, value: BI_PSP_chatterOptTalkPsoriasis },
							{ label: BI_PSP_chatterOptFeltSame, value: BI_PSP_chatterOptFeltSame },
						];
					}

					else if (title === BI_PSP_chatterMedical && body === BI_PSP_chatterMedicalFinally) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
						];
					}

					else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycFeelAlone) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptIWentThrough, value: BI_PSP_chatterOptIWentThrough },
							{ label: BI_PSP_chatterOptNormalFeel, value: BI_PSP_chatterOptNormalFeel },
							{ label: BI_PSP_chatterOptFindToTalk, value: BI_PSP_chatterOptFindToTalk },
							{ label: BI_PSP_chatterOptStayStrong, value: BI_PSP_chatterOptStayStrong },
							{ label: BI_PSP_chatterOptHavingFeel, value: BI_PSP_chatterOptHavingFeel },
						];
					}

					else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycFeelAnxious) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
							{ label: BI_PSP_chatterOptNormalFeel, value: BI_PSP_chatterOptNormalFeel },
							{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
						];
					}

					else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycWornOut) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptBeCareful, value: BI_PSP_chatterOptBeCareful },
							{ label: BI_PSP_chatterOptFeltSameway, value: BI_PSP_chatterOptFeltSameway },
							{ label: BI_PSP_chatterOptPossibleTo, value: BI_PSP_chatterOptPossibleTo },
							{ label: BI_PSP_chatterOptRootingForYou, value: BI_PSP_chatterOptRootingForYou },
						];
					}

					else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycThingsBetter) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
							{ label: BI_PSP_chatterOptGoodHear, value: BI_PSP_chatterOptGoodHear },
							{ label: BI_PSP_chatterOptWonderful, value: BI_PSP_chatterOptWonderful },
						];
					}

					else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycDontLetGpp) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptDisease, value: BI_PSP_chatterOptDisease },
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptKeepUpGood, value: BI_PSP_chatterOptKeepUpGood },
							{ label: BI_PSP_chatterOptThankInspiration, value: BI_PSP_chatterOptThankInspiration },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
						];
					}

					else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycGPPHardBattle) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptNormalFeel, value: BI_PSP_chatterOptNormalFeel },
							{ label: BI_PSP_chatterOptExperienceMyself, value: BI_PSP_chatterOptExperienceMyself },
							{ label: BI_PSP_chatterOptStayStrong, value: BI_PSP_chatterOptStayStrong },
						];
					}

					else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycTodayFeel) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptHopeOut, value: BI_PSP_chatterOptHopeOut },
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptKeepUpGood, value: BI_PSP_chatterOptKeepUpGood },
							{ label: BI_PSP_chatterOptThankInspiration, value: BI_PSP_chatterOptThankInspiration },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
						];
					}
					else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycEvenThough) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptKeepUpGood, value: BI_PSP_chatterOptKeepUpGood },
							{ label: BI_PSP_chatterOptThankInspiration, value: BI_PSP_chatterOptThankInspiration },
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
						];
					}

					else if (title === BI_PSP_chatterPsychologi && body === BI_PSP_chatterPsycIAccept) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
						];
					}

					else if (title === BI_PSP_chatterOccupation && body === BI_PSP_chatterOccICannot) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptDermatologi, value: BI_PSP_chatterOptDermatologi },
							{ label: BI_PSP_chatterOptTalkEmply, value: BI_PSP_chatterOptTalkEmply },
							{ label: BI_PSP_chatterOptIWentThrough, value: BI_PSP_chatterOptIWentThrough },
						];
					}

					else if (title === BI_PSP_chatterOccupation && body === BI_PSP_chatterOccComplicate) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptDermatologistGPP, value: BI_PSP_chatterOptDermatologistGPP },
							{ label: BI_PSP_chatterOptTryComfort, value: BI_PSP_chatterOptTryComfort },
							{ label: BI_PSP_chatterOptTalkingDoctor, value: BI_PSP_chatterOptTalkingDoctor },
						];
					}

					else if (title === BI_PSP_chatterOccupation && body === BI_PSP_chatterOccWorlColleague) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
						];
					}

					else if (title === BI_PSP_chatterOccupation && body === BI_PSP_chatterOccFeelMyFamily) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptPleasedHelp, value: BI_PSP_chatterOptPleasedHelp },
							{ label: BI_PSP_chatterOptSpeakDermato, value: BI_PSP_chatterOptSpeakDermato },
						];
					}

					else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppIDontKnow) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptTalkToDoctor, value: BI_PSP_chatterOptTalkToDoctor },
							{ label: BI_PSP_chatterOptFindToTalk, value: BI_PSP_chatterOptFindToTalk },
							{ label: BI_PSP_chatterOptAnotherDermato, value: BI_PSP_chatterOptAnotherDermato },
						];
					}

					else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppWhileGiving) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptWillPass, value: BI_PSP_chatterOptWillPass },
							{ label: BI_PSP_chatterOptGoingFine, value: BI_PSP_chatterOptGoingFine },
							{ label: BI_PSP_chatterOptThingsImprove, value: BI_PSP_chatterOptThingsImprove },
							{ label: BI_PSP_chatterOptGetEasy, value: BI_PSP_chatterOptGetEasy },
							{ label: BI_PSP_chatterOptStayPositive, value: BI_PSP_chatterOptStayPositive },
						];
					}

					else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppSkinImprove) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
						];
					}

					else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppActivelyExplore) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptStayPositive, value: BI_PSP_chatterOptStayPositive },
							{ label: BI_PSP_chatterOptGoingAlright, value: BI_PSP_chatterOptGoingAlright },
							{ label: BI_PSP_chatterOptICantTellWhen, value: BI_PSP_chatterOptICantTellWhen },
						];
					}
					else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppUnderstanding) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat },
							{ label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
							{ label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU },
							{ label: BI_PSP_chatterOptRightAttitude, value: BI_PSP_chatterOptRightAttitude },
							{ label: BI_PSP_chatterOptKeepPositive, value: BI_PSP_chatterOptKeepPositive },
						];
					}
					else if (title === BI_PSP_chatterGPP && body === BI_PSP_chatterGppFeelAlone) {
						this.commentoption = [
							{ label: BI_PSP_chatterOptSameEmotion, value: BI_PSP_chatterOptSameEmotion },
							{ label: BI_PSP_chatterOptTalkToDoctor, value: BI_PSP_chatterOptTalkToDoctor },
							{ label: BI_PSP_chatterOptTalkDermatoToHelp, value: BI_PSP_chatterOptTalkDermatoToHelp },
						];
					}
					else {
						this.commentoption = [
							{ label: BI_PSP_chatterNoComments, value: BI_PSP_chatterNoComments },
						];
					}
				}
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
			});
	}

	// To detect the site is branded or unassigned
	detectBrandedOrUnassigned() {
		const currentURL = window.location.href;
		const urlObject = new URL(currentURL);
		const path = urlObject.pathname;
		const pathComponents = path.split('/');
		const desiredComponent = pathComponents.find(component =>
			[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(component.toLowerCase())
		);
		if (desiredComponent && desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
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