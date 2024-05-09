// The Lightning Web Component displays All posts, providing a concise overview of each post's content.
// To import Libraries
import { LightningElement, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//  To import Apex Classes
import gettingAvatar from "@salesforce/apex/BI_PSPB_CommunityUsername.gettingAvatar";
import checkCommunityUsername from "@salesforce/apex/BI_PSPB_CommunityUsername.checkCommunityUsername";
import getUserAccountId from "@salesforce/apex/BI_PSPB_FeedItemCtrl.getUserAccountId";
import getall from "@salesforce/apex/BI_PSPB_FeedItemCtrl.getAllPost";
import insertcommentoption from "@salesforce/apex/BI_PSPB_FeedItemCtrl.insertComment";
import editComment from "@salesforce/apex/BI_PSPB_FeedItemCtrl.editComment";
import viewcomment from "@salesforce/apex/BI_PSPB_FeedItemCtrl.viewComments";
import deletecommentitem from "@salesforce/apex/BI_PSPB_FeedItemCtrl.softDeleteFeedCommentItem";
import followuser from "@salesforce/apex/BI_PSPB_FollowUserCtrl.followUser";
import unfollowuser from "@salesforce/apex/BI_PSPB_FollowUserCtrl.unfollowUser";
import totalthumbsup from "@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalThumbsup";
import totalsmile from "@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalSmile";
import totalfoldedhands from "@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalFoldedhands";
import totalheart from "@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalHeart";
import totalthinkingface from "@salesforce/apex/BI_PSPB_EmojiReactionCtrl.totalThinkingface";
import emojifollow from "@salesforce/apex/BI_PSPB_EmojiReactionCtrl.checkFollowingStatus";
import emojisave from "@salesforce/apex/BI_PSPB_EmojiReactionCtrl.saveEmoji";
import getReactionsByFeedItemId from "@salesforce/apex/BI_PSPB_EmojiReactionCtrl.getReactionsByFeedItemId";
import deleteemojireaction from "@salesforce/apex/BI_PSPB_EmojiReactionCtrl.deleteEmojiReaction";
// To import Static Resources
import thumbsup from "@salesforce/resourceUrl/BI_PSP_ChatterThumbsup";
import smile from "@salesforce/resourceUrl/BI_PSP_ChatterSmile";
import handsfolded from "@salesforce/resourceUrl/BI_PSP_ChatterHandsfolded";
import heart from "@salesforce/resourceUrl/BI_PSP_ChatterHeart";
import thoughtful from "@salesforce/resourceUrl/BI_PSP_ChatterThoughtful";
import allpost from "@salesforce/resourceUrl/BI_PSP_Allpost";
import NoCommentimg from "@salesforce/resourceUrl/BI_PSP_NoComments";
import deleteicon from "@salesforce/resourceUrl/BI_PSP_DeleteImage";
import deletetoastimage from "@salesforce/resourceUrl/BI_PSP_Deletetoastmsg";
import editicon from "@salesforce/resourceUrl/BI_PSP_EditImg";
// To import Custom Labels
import brandedurl from "@salesforce/label/c.BI_PSPB_siteUrl";
import unassignedurl from "@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr";
import following from "@salesforce/label/c.BI_PSP_Following";
import BI_PSP_Follow from "@salesforce/label/c.BI_PSP_Follow";
import You from "@salesforce/label/c.BI_PSP_chatterYou";
import noUsername from "@salesforce/label/c.BI_PSP_chatterNoUsername";
import BI_PSP_chatterYear from "@salesforce/label/c.BI_PSP_chatterYear";
import BI_PSP_chatterYears from "@salesforce/label/c.BI_PSP_chatterYears";
import BI_PSP_chatterMonth from "@salesforce/label/c.BI_PSP_chatterMonth";
import BI_PSP_chatterMonths from "@salesforce/label/c.BI_PSP_chatterMonths";
import BI_PSP_chatterDay from "@salesforce/label/c.BI_PSP_chatterDay";
import BI_PSP_chatterDays from "@salesforce/label/c.BI_PSP_chatterDays";
import BI_PSP_chatterHour from "@salesforce/label/c.BI_PSP_chatterHour";
import BI_PSP_chatterHours from "@salesforce/label/c.BI_PSP_chatterHours";
import BI_PSP_chatterMinute from "@salesforce/label/c.BI_PSP_chatterMinute";
import BI_PSP_chatterMinutes from "@salesforce/label/c.BI_PSP_chatterMinutes";
import BI_PSP_chatterSecond from "@salesforce/label/c.BI_PSP_chatterSecond";
import BI_PSP_chatterSeconds from "@salesforce/label/c.BI_PSP_chatterSeconds";
import BI_PSP_chatterAgo from "@salesforce/label/c.BI_PSP_chatterAgo";
import BI_PSPB_CreatePostUrl from "@salesforce/label/c.BI_PSPB_createpostUrl";
import BI_PSPB_ChatterUsernameUrl from "@salesforce/label/c.BI_PSPB_ChatterUsernameUrl";
import BI_PSP_chatterThumsUp from "@salesforce/label/c.BI_PSP_chatterThumsUp";
import BI_PSP_chatterSmile from "@salesforce/label/c.BI_PSP_chatterSmile";
import BI_PSP_chatterHandsFolded from "@salesforce/label/c.BI_PSP_chatterHandsFolded";
import BI_PSP_chatterHeart from "@salesforce/label/c.BI_PSP_chatterHeart";
import BI_PSP_chatterThoughtful from "@salesforce/label/c.BI_PSP_chatterThoughtful";
import BI_PSP_Thumbsup from "@salesforce/label/c.BI_PSP_Thumbsup";
import BI_PSP_Smile from "@salesforce/label/c.BI_PSP_Smile";
import BI_PSP_Foldedhand from "@salesforce/label/c.BI_PSP_Foldedhand";
import BI_PSP_Heart from "@salesforce/label/c.BI_PSP_Heart";
import BI_PSP_Thinkingface from "@salesforce/label/c.BI_PSP_Thinkingface";
import BI_PSP_ChatterUnableToReact from "@salesforce/label/c.BI_PSP_ChatterUnableToReact";
import BI_PSP_chatterNoComments from "@salesforce/label/c.BI_PSP_chatterNoComments";
import BI_PSP_chatterLifestyle from "@salesforce/label/c.BI_PSP_chatterLifestyle";
import BI_PSP_chatterSocial from "@salesforce/label/c.BI_PSP_chatterSocial";
import BI_PSP_chatterMedical from "@salesforce/label/c.BI_PSP_chatterMedical";
import BI_PSP_chatterPsychologi from "@salesforce/label/c.BI_PSP_chatterPsychologi";
import BI_PSP_chatterOccupation from "@salesforce/label/c.BI_PSP_chatterOccupation";
import BI_PSP_chatterGPP from "@salesforce/label/c.BI_PSP_chatterGPP";
import BI_PSP_chatterLifeIMiss from "@salesforce/label/c.BI_PSP_chatterLifeIMiss";
import BI_PSP_chatterLifeWorking from "@salesforce/label/c.BI_PSP_chatterLifeWorking";
import BI_PSP_chatterLifeNotAlways from "@salesforce/label/c.BI_PSP_chatterLifeNotAlways";
import BI_PSP_chatterLifeMyCloth from "@salesforce/label/c.BI_PSP_chatterLifeMyCloth";
import BI_PSP_chatterLifeIWould from "@salesforce/label/c.BI_PSP_chatterLifeIWould";
import BI_PSP_chatterLifeEvenGpp from "@salesforce/label/c.BI_PSP_chatterLifeEvenGpp";
import BI_PSP_chatterLifeAfterOver from "@salesforce/label/c.BI_PSP_chatterLifeAfterOver";
import BI_PSP_chatterLifeThereAre from "@salesforce/label/c.BI_PSP_chatterLifeThereAre";
import BI_PSP_chatterLifeIDid from "@salesforce/label/c.BI_PSP_chatterLifeIDid";
import BI_PSP_chatterSocialActivelyWork from "@salesforce/label/c.BI_PSP_chatterSocialActivelyWork";
import BI_PSP_chatterSocialToExplain from "@salesforce/label/c.BI_PSP_chatterSocialToExplain";
import BI_PSP_chatterSocialTalking from "@salesforce/label/c.BI_PSP_chatterSocialTalking";
import BI_PSP_chatterSocialOnlyClose from "@salesforce/label/c.BI_PSP_chatterSocialOnlyClose";
import BI_PSP_chatterSocialSharedMy from "@salesforce/label/c.BI_PSP_chatterSocialSharedMy";
import BI_PSP_chatterSocialStaying from "@salesforce/label/c.BI_PSP_chatterSocialStaying";
import BI_PSP_chatterSocialWantToIntimate from "@salesforce/label/c.BI_PSP_chatterSocialWantToIntimate";
import BI_PSP_chatterSocialGotChance from "@salesforce/label/c.BI_PSP_chatterSocialGotChance";
import BI_PSP_chatterSocialEmbarrase from "@salesforce/label/c.BI_PSP_chatterSocialEmbarrase";
import BI_PSP_chatterSocialThingsBetter from "@salesforce/label/c.BI_PSP_chatterSocialThingsBetter";
import BI_PSP_chatterMedicalDontFeel from "@salesforce/label/c.BI_PSP_chatterMedicalDontFeel";
import BI_PSP_chatterMedicalSeenDoc from "@salesforce/label/c.BI_PSP_chatterMedicalSeenDoc";
import BI_PSP_chatterMedicalFinally from "@salesforce/label/c.BI_PSP_chatterMedicalFinally";
import BI_PSP_chatterPsycFeelAlone from "@salesforce/label/c.BI_PSP_chatterPsycFeelAlone";
import BI_PSP_chatterPsycFeelAnxious from "@salesforce/label/c.BI_PSP_chatterPsycFeelAnxious";
import BI_PSP_chatterPsycWornOut from "@salesforce/label/c.BI_PSP_chatterPsycWornOut";
import BI_PSP_chatterPsycThingsBetter from "@salesforce/label/c.BI_PSP_chatterPsycThingsBetter";
import BI_PSP_chatterPsycDontLetGpp from "@salesforce/label/c.BI_PSP_chatterPsycDontLetGpp";
import BI_PSP_chatterPsycGPPHardBattle from "@salesforce/label/c.BI_PSP_chatterPsycGPPHardBattle";
import BI_PSP_chatterPsycTodayFeel from "@salesforce/label/c.BI_PSP_chatterPsycTodayFeel";
import BI_PSP_chatterPsycEvenThough from "@salesforce/label/c.BI_PSP_chatterPsycEvenThough";
import BI_PSP_chatterPsycIAccept from "@salesforce/label/c.BI_PSP_chatterPsycIAccept";
import BI_PSP_chatterOccICannot from "@salesforce/label/c.BI_PSP_chatterOccICannot";
import BI_PSP_chatterOccComplicate from "@salesforce/label/c.BI_PSP_chatterOccComplicate";
import BI_PSP_chatterOccWorlColleague from "@salesforce/label/c.BI_PSP_chatterOccWorlColleague";
import BI_PSP_chatterOccFeelMyFamily from "@salesforce/label/c.BI_PSP_chatterOccFeelMyFamily";
import BI_PSP_chatterGppIDontKnow from "@salesforce/label/c.BI_PSP_chatterGppIDontKnow";
import BI_PSP_chatterGppWhileGiving from "@salesforce/label/c.BI_PSP_chatterGppWhileGiving";
import BI_PSP_chatterGppSkinImprove from "@salesforce/label/c.BI_PSP_chatterGppSkinImprove";
import BI_PSP_chatterGppActivelyExplore from "@salesforce/label/c.BI_PSP_chatterGppActivelyExplore";
import BI_PSP_chatterGppUnderstanding from "@salesforce/label/c.BI_PSP_chatterGppUnderstanding";
import BI_PSP_chatterGppFeelAlone from "@salesforce/label/c.BI_PSP_chatterGppFeelAlone";
import BI_PSP_chatterOptRootingForYou from "@salesforce/label/c.BI_PSP_chatterOptRootingForYou";
import BI_PSP_chatterOptLifeFullOf from "@salesforce/label/c.BI_PSP_chatterOptLifeFullOf";
import BI_PSP_chatterOptICantTellWhen from "@salesforce/label/c.BI_PSP_chatterOptICantTellWhen";
import BI_PSP_chatterOptThatGreat from "@salesforce/label/c.BI_PSP_chatterOptThatGreat";
import BI_PSP_chatterOptAwesome from "@salesforce/label/c.BI_PSP_chatterOptAwesome";
import BI_PSP_chatterOptKeepItUp from "@salesforce/label/c.BI_PSP_chatterOptKeepItUp";
import BI_PSP_chatterOptEnjoyReality from "@salesforce/label/c.BI_PSP_chatterGppFeelAlone";
import BI_PSP_chatterOptBraveStrong from "@salesforce/label/c.BI_PSP_chatterOptBraveStrong";
import BI_PSP_chatterOptHappyForU from "@salesforce/label/c.BI_PSP_chatterOptHappyForU";
import BI_PSP_chatterOptGetEasy from "@salesforce/label/c.BI_PSP_chatterOptGetEasy";
import BI_PSP_chatterOptThankUSaying from "@salesforce/label/c.BI_PSP_chatterOptThankUSaying";
import BI_PSP_chatterOptRightAttitude from "@salesforce/label/c.BI_PSP_chatterOptRightAttitude";
import BI_PSP_chatterOptOurLifeFull from "@salesforce/label/c.BI_PSP_chatterOptOurLifeFull";
import BI_PSP_chatterOptManyThingsCannot from "@salesforce/label/c.BI_PSP_chatterOptManyThingsCannot";
import BI_PSP_chatterOptDontGiveUp from "@salesforce/label/c.BI_PSP_chatterOptDontGiveUp";
import BI_PSP_chatterOptProudOfYou from "@salesforce/label/c.BI_PSP_chatterOptProudOfYou";
import BI_PSP_chatterOptAmazing from "@salesforce/label/c.BI_PSP_chatterOptAmazing";
import BI_PSP_chatterOptInspiration from "@salesforce/label/c.BI_PSP_chatterOptInspiration";
import BI_PSP_chatterOptEverythingAlright from "@salesforce/label/c.BI_PSP_chatterOptEverythingAlright";
import BI_PSP_chatterOptIWentThrough from "@salesforce/label/c.BI_PSP_chatterOptIWentThrough";
import BI_PSP_chatterOptEmbarrased from "@salesforce/label/c.BI_PSP_chatterOptEmbarrased";
import BI_PSP_chatterOptDontBeHard from "@salesforce/label/c.BI_PSP_chatterOptDontBeHard";
import BI_PSP_chatterOptImSoProud from "@salesforce/label/c.BI_PSP_chatterOptImSoProud";
import BI_PSP_chatterOptYouAmazing from "@salesforce/label/c.BI_PSP_chatterOptYouAmazing";
import BI_PSP_chatterOptTryNotTo from "@salesforce/label/c.BI_PSP_chatterOptTryNotTo";
import BI_PSP_chatterOptYouDefine from "@salesforce/label/c.BI_PSP_chatterOptYouDefine";
import BI_PSP_chatterOptYouGreatWonder from "@salesforce/label/c.BI_PSP_chatterOptYouGreatWonder";
import BI_PSP_chatterOptKeepUpGood from "@salesforce/label/c.BI_PSP_chatterOptKeepUpGood";
import BI_PSP_chatterOptFeltSame from "@salesforce/label/c.BI_PSP_chatterOptFeltSame";
import BI_PSP_chatterOptTalkingDoctor from "@salesforce/label/c.BI_PSP_chatterOptTalkingDoctor";
import BI_PSP_chatterOptPatientOrg from "@salesforce/label/c.BI_PSP_chatterOptPatientOrg";
import BI_PSP_chatterOptFindSomeone from "@salesforce/label/c.BI_PSP_chatterOptFindSomeone";
import BI_PSP_chatterOptStayStrong from "@salesforce/label/c.BI_PSP_chatterOptStayStrong";
import BI_PSP_chatterOptTalkPsoriasis from "@salesforce/label/c.BI_PSP_chatterOptTalkPsoriasis";
import BI_PSP_chatterOptNormalFeel from "@salesforce/label/c.BI_PSP_chatterOptNormalFeel";
import BI_PSP_chatterOptFindToTalk from "@salesforce/label/c.BI_PSP_chatterOptFindToTalk";
import BI_PSP_chatterOptHavingFeel from "@salesforce/label/c.BI_PSP_chatterOptHavingFeel";
import BI_PSP_chatterOptBeCareful from "@salesforce/label/c.BI_PSP_chatterOptBeCareful";
import BI_PSP_chatterOptFeltSameway from "@salesforce/label/c.BI_PSP_chatterOptFeltSameway";
import BI_PSP_chatterOptPossibleTo from "@salesforce/label/c.BI_PSP_chatterOptPossibleTo";
import BI_PSP_chatterOptGoodHear from "@salesforce/label/c.BI_PSP_chatterOptGoodHear";
import BI_PSP_chatterOptWonderful from "@salesforce/label/c.BI_PSP_chatterOptWonderful";
import BI_PSP_chatterOptDisease from "@salesforce/label/c.BI_PSP_chatterOptDisease";
import BI_PSP_chatterOptThankInspiration from "@salesforce/label/c.BI_PSP_chatterOptThankInspiration";
import BI_PSP_chatterOptExperienceMyself from "@salesforce/label/c.BI_PSP_chatterOptExperienceMyself";
import BI_PSP_chatterOptHopeOut from "@salesforce/label/c.BI_PSP_chatterOptHopeOut";
import BI_PSP_chatterOptDermatologi from "@salesforce/label/c.BI_PSP_chatterOptDermatologi";
import BI_PSP_chatterOptTalkEmply from "@salesforce/label/c.BI_PSP_chatterOptTalkEmply";
import BI_PSP_chatterOptDermatologistGPP from "@salesforce/label/c.BI_PSP_chatterOptDermatologistGPP";
import BI_PSP_chatterOptTryComfort from "@salesforce/label/c.BI_PSP_chatterOptTryComfort";
import BI_PSP_chatterOptPleasedHelp from "@salesforce/label/c.BI_PSP_chatterOptPleasedHelp";
import BI_PSP_chatterOptSpeakDermato from "@salesforce/label/c.BI_PSP_chatterOptSpeakDermato";
import BI_PSP_chatterOptTalkToDoctor from "@salesforce/label/c.BI_PSP_chatterOptTalkToDoctor";
import BI_PSP_chatterOptAnotherDermato from "@salesforce/label/c.BI_PSP_chatterOptAnotherDermato";
import BI_PSP_chatterOptWillPass from "@salesforce/label/c.BI_PSP_chatterOptWillPass";
import BI_PSP_chatterOptGoingFine from "@salesforce/label/c.BI_PSP_chatterOptGoingFine";
import BI_PSP_chatterOptThingsImprove from "@salesforce/label/c.BI_PSP_chatterOptThingsImprove";
import BI_PSP_chatterOptStayPositive from "@salesforce/label/c.BI_PSP_chatterOptStayPositive";
import BI_PSP_chatterOptGoingAlright from "@salesforce/label/c.BI_PSP_chatterOptGoingAlright";
import BI_PSP_chatterOptKeepPositive from "@salesforce/label/c.BI_PSP_chatterOptKeepPositive";
import BI_PSP_chatterOptSameEmotion from "@salesforce/label/c.BI_PSP_chatterOptSameEmotion";
import BI_PSP_chatterOptTalkDermatoToHelp from "@salesforce/label/c.BI_PSP_chatterOptTalkDermatoToHelp";
import BI_PSP_ChatterSlash from "@salesforce/label/c.BI_PSP_ChatterSlash";
import errormessage from "@salesforce/label/c.BI_PSP_ConsoleError";
import errorvariant from "@salesforce/label/c.BI_PSPB_errorVariant";
import BI_PSPB_Error_For_Account from "@salesforce/label/c.BI_PSPB_Error_For_Account";
import BI_PSPB_Error_For_Post_Selection from "@salesforce/label/c.BI_PSPB_Error_For_Post_Selection";
// To import current user ID
import Id from "@salesforce/user/Id";
export default class biPspbAllPost extends LightningElement {
  //Proper naming conventions with camel case for all the variables will be followed in the future releases
  // Declaration of variables with @track
  @track navcreatepostid;
  @track editTheCommentTxt = "editTheCommentTxt"; //css attribute call
  @track userId = Id;
  @track UserAccId;
  @track allpost = [];
  @track acctid;
  @track avatr;
  @track isLoading;
  @track loggedUserAvatar;
  @track resultvalue = [];
  @track editcomment;
  @track commentid;
  @track postitemid;
  @track feedcommentItemIdToDelete;
  @track btvalue;
  @track commentbox;
  @track displaycomment = [];
  @track avatarDataforreaction;
  @track emojitext;
  @track emojitext1;
  @track emojitext2;
  @track emojitext3;
  @track emojitext4;
  @track postIdforfollow;
  @track showSpinner;
  @track getthumbsup;
  @track getsmile;
  @track getfoldedhands;
  @track getheart;
  @track getthinkingface;
  @track feedItemIdemoji;
  @track displayhide = "";
  @track selecteduserId;
  @track btnchk;
  @track buttonValue;
  @track usename;
  @track avt;
  @track avtvarfor;
  @track countrecord;
  @track getComments = false;
  @track showdelbtnforuser = false;
  @track isFirstPopupOpen = false;
  @track showeditthecomment = false;
  @track isthreedotclassopen = false;
  @track showdeletetoastmsg = false;
  @track emojifollowingpopup2 = false;
  @track noreactionforthisemoji = false;
  @track isSecondPopupOpen = false;
  @track emojifollowing = false;
  @track emifollow = false;
  @track isDesktop = false;
  @track emojifollowpopup2 = false;
  @track showallpost = false;
  @track followpopup = false;
  @track followingpopup = false;
  @track followpopup2 = false;
  @track followingpopup2 = false;
  @track showDiv = false;
  @track showDiv2 = false;
  @track showDiv3 = false;
  @track showDiv4 = false;
  @track showEmojiPopup = false;
  @track displayTemplatethumbsup = true;
  @track displayTemplatesmile = false;
  @track displayTemplatefoldedhands = false;
  @track displayTemplateheart = false;
  @track displayTemplatethinkingface = false;
  //Declaration of variables
  imgThumbs = thumbsup;
  imgSmile = smile;
  imgHands = handsfolded;
  imgLike = heart;
  imgThought = thoughtful;
  comment = "";
  commentoption = [];
  allpostimg = allpost;
  NoComment = NoCommentimg;
  deleteimg = deleteicon;
  deletetoast = deletetoastimage;
  editimg = editicon;
  isCurrentUserCommentCreator = false;

  // To fetch the account Id of the user
  @wire(getUserAccountId, { userId: "$userId" })
  wiredUserIdtoAccId({ error, data }) {
    try {
      if (data && data.length > 0) {
        this.UserAccId = data;
      } else if (error) {
        this.showToast(errormessage, error.body.message, errorvariant); //if data null throw exception
      } else {
        this.showToast(errormessage, BI_PSPB_Error_For_Account, errorvariant); // Catch Exception
      }
    } catch (err) {
      this.showToast(errormessage, err.message, errorvariant); // Catch Exception
    }
  }

  // Get all post
  @wire(getall, { userId: "$userId" })
  wiredFeedItems({ error, data }) {
    try {
      this.isLoading = true;
      if ((data && data.length === 0) || data === null) {
        this.isLoading = false;
        this.showallpost = false;
      } else if (data && data.length > 0) {
        this.showallpost = true;
        this.isLoading = false;
        this.allpost = data;
        //this map is to display allpost page with specific conditions after got all list of raw data from apex
        this.allpost = data?.map((post) => ({
          ...post,
          //calculate the time of post posted
          formattedTimeDifference: this.calculateTimeDifference(
            post.CreatedDate
          ),
          //display total comments count of the post
          CommentCount: post.BI_PSP_FeedComment__r
            ? post.BI_PSP_FeedComment__r.length
            : 0,
          //display total reaction count of the post
          CountEmoji: post.BI_PSP_EmojiReactionController__r
            ? post.BI_PSP_EmojiReactionController__r.length
            : 0,
          btnchk:
            post.BI_PSP_FollowStatus__c === following
              ? following
              : BI_PSP_Follow,
          youbtn: this.UserAccId === post.BI_PSP_AccountR__c ? false : true,
          postYouName:
            this.UserAccId === post.BI_PSP_AccountR__c
              ? You
              : post.BI_PSP_AccountR__r.BI_PSP_CommunityUsername__c != null
                ? post.BI_PSP_AccountR__r.BI_PSP_CommunityUsername__c
                : noUsername,
          imageavatar: post.BI_PSP_AccountR__r.BI_PSP_AvatarUrl__c,
          toreact: true,
          reactionResult: "",
          commentbox: false,
          displayhide: "",
          showEmojiPopup: false,
          emojiyoureacted: ""
        }));
        this.showallpost = true;
        this.checkAllReactions();
        this.commentbox = true;
      } else if (error) {
        this.isLoading = true;
        this.showToast(errormessage, error.body.message, errorvariant); //data null exception
      } else {
        this.isLoading = true;
        this.showToast(
          errormessage,
          BI_PSPB_Error_For_Post_Selection,
          errorvariant
        ); // catch Exception
      }
    } catch (err) {
      this.showToast(errormessage, err.message, errorvariant); // catch Exception
    }
  }

  //This connected callback used to get Avatar for reaction,post and comments,get localstorage value from notification navigation and detect the site Branded or Unbranded
  connectedCallback() {
    try {
      this.detectBrandedOrUnassigned();
      this.checkAllReactions();
      this.avatarImgLeftside();
      this.getComments = false;
      this.showdeletetoastmsg = false;
      this.isDesktop = this.isDesktopView();
      window.addEventListener("resize", this.handleResize.bind(this));
      // Navigation from Notification to view the following user Creates the Post
      const selectedItemIdforCreatepost = window.localStorage.getItem(
        "selectedItemIdforCreatepost"
      );
      if (selectedItemIdforCreatepost) {
        this.navcreatepostid = selectedItemIdforCreatepost;
        window.localStorage.removeItem("selectedItemIdforCreatepost");
      }
      //setInterval is used for scroll to the particular post when following user create the Post and click the view post button on notification page
      //it should scroll to the particular post only with the localstorage id by passing from  biPspbgeneralnotificationform
      let counter = 0;
      let intervalId = setInterval(() => {
        counter = counter + 1;
        const postElementbyclass = this.template.querySelector(
          "." + selectedItemIdforCreatepost
        );
        if (postElementbyclass) {
          postElementbyclass.scrollIntoView({
            behavior: "smooth",
            block: "start"
          });
          clearInterval(intervalId);
        }
        if (counter === 5) {
          clearInterval(intervalId);
        }
      }, 1000);
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // catch Exception
    }
  }

  //Used to remove the Event from the fixed screen
  disconnectedCallback() {
    try {
      window.removeEventListener("resize", this.handleResize.bind(this));
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // catch Exception
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
        .then((result) => {
          if (result.length > 0 && result[0].BI_PSP_AvatarUrl__c) {
            this.loggedUserAvatar = result[0].BI_PSP_AvatarUrl__c;
          }
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //After clicking create a new post go to createpost page with checking communityusername
  goToCreatepost() {
    try {
      checkCommunityUsername({ userId: this.userId })
        .then((result) => {
          if (result === true) {
            window.location.assign(
              BI_PSP_ChatterSlash + this.urlq + BI_PSPB_CreatePostUrl
            );
          } else if (result === false) {
            window.location.assign(
              BI_PSP_ChatterSlash + this.urlq + BI_PSPB_ChatterUsernameUrl
            );
          } else {
            this.showToast(errormessage, errormessage, errorvariant); // catch Exception
          }
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
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

  //After clicking the react button show the popup with 5 emoji's (only clicked post's emoji button)
  ReactionBtn(event) {
    const postId = event.currentTarget.dataset.customFeeditemId;
    this.allpost = this.allpost.map((post) => ({
      ...post,
      showEmojiPopup: post.Id === postId ? !post.showEmojiPopup : false,
      commentbox: false,
      displayhide: ""
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
      this.showToast(errormessage, error.message, errorvariant); // catch Exception
    }
    const feedItemId = event.currentTarget.dataset.customFeeditemId;
    const emojis = event.currentTarget.dataset.reactionType;
    //call apex to store emoji saved information
    try {
      emojisave({
        reactions: emojis,
        feedItemId: feedItemId,
        userId: this.userId
      })
        .then((result) => {
          this.resultvalue = Array.isArray(result) ? result : [result];
          if (this.resultvalue && this.resultvalue.length > 0) {
            this.resultfinal = true;
            this.allpost = this.allpost.map((post) => {
              if (post.Id === feedItemId) {
                return {
                  ...post,
                  showEmojiPopup: false,
                  toreact: false,
                  emojiyoureacted: this.getResultEmoji(
                    result.BI_PSP_ReactionResult__c
                  ),
                  CountEmoji: post.CountEmoji + 1,
                  emojiReactedImg: this.getResultEmojiImg(
                    result.BI_PSP_ReactionResult__c
                  )
                };
              }
              return post;
            });
          } else {
            this.postDetails = this.postDetails.map((post) => ({
              ...post,
              showEmojiPopup: false
            }));
            this.showToast(
              errormessage,
              BI_PSP_ChatterUnableToReact,
              errorvariant
            ); // catch Exception
          }
        })
        .catch((error) => {
          this.postDetails = this.postDetails.map((post) => ({
            ...post,
            showEmojiPopup: false
          }));
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
        });
    } catch (error) {
      this.postDetails = this.postDetails.map((post) => ({
        ...post,
        showEmojiPopup: false
      }));
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //after insert update the emojibox
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
        return "";
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
        return "";
    }
  }

  //check the reactions if already reacted or not (if any changes made in mypost page)
  checkAllReactions() {
    this.allpost.forEach((post) => {
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
              5: BI_PSP_chatterThoughtful
            };
            this.allpost = this.allpost.map((post) => {
              if (post.Id === postId) {
                post.toreact =
                  reactionType === undefined || isNaN(reactionType);
                post.emojiyoureacted = emojiMap[reactionType] || "None";
                switch (post.emojiyoureacted) {
                  case BI_PSP_chatterThumsUp:
                    post.emojiReactedImg = this.imgThumbs || "👍";
                    break;
                  case BI_PSP_chatterSmile:
                    post.emojiReactedImg = this.imgSmile || "😊";
                    break;
                  case BI_PSP_chatterHandsFolded:
                    post.emojiReactedImg = this.imgHands || "🙏";
                    break;
                  case BI_PSP_chatterHeart:
                    post.emojiReactedImg = this.imgLike || "❤️";
                    break;
                  case BI_PSP_chatterThoughtful:
                    post.emojiReactedImg = this.imgThought || "🤔";
                    break;
                  default:
                    post.emojiReactedImg = "";
                    break;
                }
              }
              return post;
            });
          } else {
            this.showToast(errormessage, errormessage, errorvariant); // Null check  catch Exception
          }
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  // To unreact the post
  unreact(event) {
    this.allpost = this.allpost.map((post) => ({
      ...post,
      commentbox: false
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
      this.showToast(errormessage, error.message, errorvariant); // catch Exception for setTimeout
    }
    this.showEmojiPopup = false;
    const feedItemId = event.currentTarget.dataset.customFeeditemId;
    //Delete the Emoji data
    try {
      deleteemojireaction({ feedItemId: feedItemId, userId: this.userId })
        .then(() => {
          this.allpost = this.allpost.map((post) => {
            if (post.Id === feedItemId) {
              return {
                ...post,
                toreact: true,
                CountEmoji: post.CountEmoji - 1
              };
            }
            return post;
          });
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
          this.checkAllReactions();
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //close the emoji reaction popup
  closeemojiPopup() {
    this.allpost = this.allpost.map((post) => ({
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
    this.isSecondPopupOpen = false;
    document.body.style.overflow = "";
    this.currentPostId = null;
    const clickedPostId = event.currentTarget.dataset.customFeeditemId;
    this.allpost = this.allpost.map((post) => ({
      ...post,
      secondPopupClass:
        post.Id === clickedPostId ? "!second-popup" : "second-popup hidden"
    }));
  }

  //open the particular reaction popup
  get secondPopupClass() {
    return this.isSecondPopupOpen ? "!second-popup" : "second-popup hidden";
  }

  // After clicking show the thumbsup emoji reacted users
  viewReaction(event) {
    this.emojitext = "emojitextbox";
    this.emojitext1 = "emojitext";
    this.emojitext2 = "emojitext";
    this.emojitext3 = "emojitext";
    this.emojitext4 = "emojitext";
    this.feedItemIdemoji = event.currentTarget.dataset.customFeeditemId;
    this.allpost = this.allpost.map((post) => ({
      ...post,
      secondPopupClass:
        post.Id === this.feedItemIdemoji
          ? "second-popup"
          : "second-popup hidden",
      showEmojiPopup: false,
      commentbox: false,
      displayhide: ""
    }));
    this.isSecondPopupOpen = true;
    if (this.isDesktop) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    this.displayTemplatethumbsup = true;
    try {
      totalthumbsup({ feedItemId: this.feedItemIdemoji })
        .then((result) => {
          if (result && result.length > 0) {
            this.noreactionforthisemoji = false;
            this.noreactionforthisemoji = false;
            this.displayTemplatethumbsup = true;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
            this.getthumbsup = result;
            this.getthumbsup = this.getthumbsup.map((Thumbsup) => ({
              ...Thumbsup,
              avatarDataforreaction:
                Thumbsup.BI_PSP_AccountE__r?.BI_PSP_AvatarUrl__c,
              reactionyouname:
                this.UserAccId === Thumbsup.BI_PSP_AccountE__c
                  ? You
                  : Thumbsup.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c
            }));
          } else {
            this.noreactionforthisemoji = true;
            this.displayTemplatethumbsup = false;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
          }
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
          this.noreactionforthisemoji = true;
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //show thumbs emoji reaction - users
  showTemplatethumbsup() {
    this.emojitext = "emojitextbox";
    this.emojitext1 = "emojitext";
    this.emojitext2 = "emojitext";
    this.emojitext3 = "emojitext";
    this.emojitext4 = "emojitext";
    try {
      totalthumbsup({ feedItemId: this.feedItemIdemoji })
        .then((result) => {
          if (result && result.length > 0) {
            this.noreactionforthisemoji = false;
            this.noreactionforthisemoji = false;
            this.displayTemplatethumbsup = true;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
            this.getthumbsup = result;
            this.getthumbsup = this.getthumbsup.map((Thumbsup) => ({
              ...Thumbsup,
              avatarDataforreaction:
                Thumbsup.BI_PSP_AccountE__r?.BI_PSP_AvatarUrl__c,
              reactionyouname:
                this.UserAccId === Thumbsup.BI_PSP_AccountE__c
                  ? You
                  : Thumbsup.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c
            }));
          } else {
            this.noreactionforthisemoji = true;
            this.displayTemplatethumbsup = false;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
          }
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
          this.noreactionforthisemoji = true;
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  // show smile emoji reaction - users
  showTemplatesmile() {
    this.emojitext = "emojitext";
    this.emojitext1 = "emojitextbox";
    this.emojitext2 = "emojitext";
    this.emojitext3 = "emojitext";
    this.emojitext4 = "emojitext";
    try {
      totalsmile({ feedItemId: this.feedItemIdemoji })
        .then((result) => {
          if (result && result.length > 0) {
            this.noreactionforthisemoji = false;
            this.displayTemplatesmile = true;
            this.getsmile = result;
            this.displayTemplatethumbsup = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
            this.getsmile = this.getsmile.map((Smile) => ({
              ...Smile,
              avatarDataforreaction:
                Smile.BI_PSP_AccountE__r?.BI_PSP_AvatarUrl__c,
              reactionyouname:
                this.UserAccId === Smile.BI_PSP_AccountE__c
                  ? You
                  : Smile.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c
            }));
          } else {
            this.noreactionforthisemoji = true;
            this.displayTemplatethumbsup = false;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
          }
        })
        .catch((error) => {
          this.noreactionforthisemoji = true;
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //show foldedhands emoji reaction - users
  showTemplatefoldedhands() {
    this.emojitext = "emojitext";
    this.emojitext1 = "emojitext";
    this.emojitext2 = "emojitextbox";
    this.emojitext3 = "emojitext";
    this.emojitext4 = "emojitext";
    try {
      totalfoldedhands({ feedItemId: this.feedItemIdemoji })
        .then((result) => {
          if (result && result.length > 0) {
            this.noreactionforthisemoji = false;
            this.displayTemplatefoldedhands = true;
            this.getfoldedhands = result;
            this.displayTemplatethumbsup = false;
            this.displayTemplatesmile = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
            this.getfoldedhands = this.getfoldedhands.map((foldedHands) => ({
              ...foldedHands,
              avatarDataforreaction:
                foldedHands.BI_PSP_AccountE__r?.BI_PSP_AvatarUrl__c,
              reactionyouname:
                this.UserAccId === foldedHands.BI_PSP_AccountE__c
                  ? You
                  : foldedHands.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c
            }));
          } else {
            this.noreactionforthisemoji = true;
            this.displayTemplatethumbsup = false;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
          }
        })
        .catch((error) => {
          this.noreactionforthisemoji = true;
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //show heart emoji reaction - users
  showTemplateheart() {
    this.emojitext = "emojitext";
    this.emojitext1 = "emojitext";
    this.emojitext2 = "emojitext";
    this.emojitext3 = "emojitextbox";
    this.emojitext4 = "emojitext";
    try {
      totalheart({ feedItemId: this.feedItemIdemoji })
        .then((result) => {
          if (result && result.length > 0) {
            this.noreactionforthisemoji = false;
            this.displayTemplateheart = true;
            this.getheart = result;
            this.displayTemplatethumbsup = false;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplatethinkingface = false;
            this.getheart = this.getheart.map((Heart) => ({
              ...Heart,
              avatarDataforreaction:
                Heart.BI_PSP_AccountE__r?.BI_PSP_AvatarUrl__c,
              reactionyouname:
                this.UserAccId === Heart.BI_PSP_AccountE__c
                  ? You
                  : Heart.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c
            }));
          } else {
            this.noreactionforthisemoji = true;
            this.displayTemplatethumbsup = false;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
          }
        })
        .catch((error) => {
          this.noreactionforthisemoji = true;
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //show thinkingface emoji reaction - users
  showTemplatethinkingface() {
    this.emojitext = "emojitext";
    this.emojitext1 = "emojitext";
    this.emojitext2 = "emojitext";
    this.emojitext3 = "emojitext";
    this.emojitext4 = "emojitextbox";
    try {
      totalthinkingface({ feedItemId: this.feedItemIdemoji })
        .then((result) => {
          if (result && result.length > 0) {
            this.noreactionforthisemoji = false;
            this.displayTemplatethinkingface = true;
            this.getthinkingface = result;
            this.displayTemplatethumbsup = false;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.getthinkingface = this.getthinkingface.map((think) => ({
              ...think,
              avatarDataforreaction:
                think.BI_PSP_AccountE__r?.BI_PSP_AvatarUrl__c,
              reactionyouname:
                this.UserAccId === think.BI_PSP_AccountE__c
                  ? You
                  : think.BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c
            }));
          } else {
            this.noreactionforthisemoji = true;
            this.displayTemplatethumbsup = false;
            this.displayTemplatesmile = false;
            this.displayTemplatefoldedhands = false;
            this.displayTemplateheart = false;
            this.displayTemplatethinkingface = false;
          }
        })
        .catch((error) => {
          this.noreactionforthisemoji = true;
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //show these three dot at only mobile view
  get threedotclass() {
    return this.isthreedotclassopen
      ? "threedot-container"
      : "threedot-container hidden";
  }

  threedotopen(event) {
    this.commentid = event.currentTarget.dataset.customFeeditemId;
    this.displaycomment = this.displaycomment.map((comment) => ({
      ...comment,
      threedotclass:
        comment.Id === this.commentid ? !comment.threedotclass : false
    }));
    this.isthreedotclassopen = true;
    document.body.style.overflow = "hidden";
  }
  //close the action popup
  closethreedot() {
    this.isthreedotclassopen = false;
    document.body.style.overflow = "";
  }

  //delete comment popup
  get firstPopupClass() {
    return this.isFirstPopupOpen ? "popup-container" : "popup-container hidden";
  }

  //OPEN THE ACTION POPUP after clicking the threedots
  openFirstPopup(event) {
    this.closethreedot();
    this.feedcommentItemIdToDelete =
      event.currentTarget.dataset.customFeeditemId;
    this.postitemid = event.currentTarget.dataset.customPostitemId;
    this.isFirstPopupOpen = true;
    document.body.style.overflow = "hidden";
  }

  //close the delete comment confirmation popup
  closeFirstPopup() {
    document.body.style.overflow = "";
    this.isFirstPopupOpen = false;
  }

  //close the Comment delete toast message
  closetoastmsg() {
    this.showdeletetoastmsg = false;
  }

  //close Commentbox
  closecomment(event) {
    const postId = event.currentTarget.dataset.customFeeditemId;
    this.allpost = this.allpost.map((post) => ({
      ...post,
      commentbox: post.Id === postId ? false : post.commentbox,
      displayhide: ""
    }));
    this.commentbox = true;
  }

  // close the edit dropdown comment
  closeshoweditthecomment(event) {
    this.editTheCommentTxt = "HideeditTheCommentTxt";
    this.commentid = event.currentTarget.dataset.customFeeditemId;
    this.displaycomment = this.displaycomment.map((comment) => ({
      ...comment,
      showeditthecomment: false
    }));
  }

  // To delete the comment
  handledelete() {
    //this.feedcommentItemIdToDelete =
    //	event.currentTarget.dataset.customFeeditemId;
    this.isFirstPopupOpen = false;
    document.body.style.overflow = "";
    try {
      deletecommentitem({ feedCommentItemId: this.feedcommentItemIdToDelete })
        .then(() => {
          this.displaycomment = this.displaycomment.filter(
            (comment) => comment.Id !== this.feedcommentItemIdToDelete
          );
          this.allpost = this.allpost.map((post) => {
            if (post.Id === this.postitemid) {
              return {
                ...post,
                CommentCount: post.CommentCount - 1
              };
            }
            return post;
          });
          this.showdeletetoastmsg = true;
          //Settimeout function used to close the ToastMessage automatically few seconds after it displays
          //Here it close the Delete Comment toast Message
          this.showDeleteToastMsgforcomment = true;
          window.scrollTo({ top: 0, behavior: "smooth" });
          try {
            setTimeout(() => {
              this.showdeletetoastmsg = false;
            }, 6000);
          } catch (error) {
            this.showToast(errormessage, error.message, errorvariant); // catch Exception for setTimeout
          }
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //open the follow popup at clicking profile avatar
  followUserpop(event) {
    this.allpost = this.allpost.map((post) => ({
      ...post,
      showEmojiPopup: false,
      commentbox: false,
      displayhide: ""
    }));
    this.postIdforfollow = event.currentTarget.dataset.customFeeditemId;
    this.selecteduserId = event.target.dataset.id;
    this.username = event.target.dataset.username;
    this.avatr = event.target.dataset.avatar;
    this.acctid = event.target.dataset.acc;
    this.btvalue = event.target.dataset.button;
    if (this.acctid === this.UserAccId) {
      this.followpopup = false;
      this.followingpopup = false;
      document.body.style.overflow = "";
    } else if (this.btvalue === BI_PSP_Follow) {
      this.followpopup = true;
      if (this.isDesktop) {
        document.body.style.overflow = "hidden";
      } else {
        document.body.style.overflow = "";
      }
    } else {
      this.followingpopup = true;
      if (this.isDesktop) {
        document.body.style.overflow = "hidden";
      } else {
        document.body.style.overflow = "";
      }
    }
  }

  // To open popup  when clicking profile button
  buttonfollowUserpop(event) {
    this.allpost = this.allpost.map((post) => ({
      ...post,
      showEmojiPopup: false,
      commentbox: false,
      displayhide: ""
    }));
    this.selecteduserId = event.target.dataset.id;
    this.username = event.target.dataset.username;
    this.avatr = event.target.dataset.avatar;
    this.acctid = event.target.dataset.acc;
    this.btvalue = event.target.dataset.button;
    if (this.acctid === this.UserAccId) {
      this.followpopup2 = false;
      this.followingpopup2 = false;
      document.body.style.overflow = "";
    } else if (this.btvalue === BI_PSP_Follow) {
      this.followpopup2 = true;
      if (this.isDesktop) {
        document.body.style.overflow = "hidden";
      } else {
        document.body.style.overflow = "";
      }
    } else {
      this.followingpopup2 = true;
      if (this.isDesktop) {
        document.body.style.overflow = "hidden";
      } else {
        document.body.style.overflow = "";
      }
    }
  }

  // To close popup for follow/unfollow
  closePopup() {
    this.followpopup = false;
    this.followpopup2 = false;
    this.followingpopup = false;
    this.followingpopup2 = false;
    document.body.style.overflow = "";
  }

  // open confirmation Following popup
  handleFollowingPopupButtonClick() {
    this.followingpopup2 = true;
    if (this.isDesktop) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    this.followingpopup = false;
  }

  // open confirmation Follow popup
  handleFollowPopupButtonClick() {
    this.followpopup2 = true;
    if (this.isDesktop) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    this.followpopup = false;
  }

  // To follow the user
  Followyes() {
    try {
      this.isLoading = true;
      followuser({
        accountIdToFollow: this.acctid,
        userWhoFollows: this.userId
      })
        .then(() => {
          this.allpost = this.allpost.map((post) => ({
            ...post,
            btnchk:
              post.BI_PSP_AccountR__c === this.acctid ? following : post.btnchk
          }));
          this.isLoading = false;
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
          return false;
        });
      this.followpopup = false;
      this.followpopup2 = false;
      document.body.style.overflow = "";
      this.showDiv = true;
      window.scrollTo({ top: 0, behavior: "smooth" });
      try {
        setTimeout(() => {
          this.showDiv = false;
        }, 6000);
      } catch (error) {
        this.showToast(errormessage, error.message, errorvariant); // catch Exception for setTimeout
      }
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  // To unfollow the user
  UnFollowingyes() {
    try {
      this.isLoading = true;
      unfollowuser({
        accountIdToUnFollow: this.acctid,
        userIdWhoUnFollows: this.userId
      })
        .then(() => {
          this.allpost = this.allpost.map((post) => ({
            ...post,
            btnchk:
              post.BI_PSP_AccountR__c === this.acctid
                ? BI_PSP_Follow
                : post.btnchk
          }));
          this.isLoading = false;
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
          return false;
        });
      this.followingpopup = false;
      this.followingpopup2 = false;
      document.body.style.overflow = "";
      this.showDiv2 = true;
      window.scrollTo({ top: 0, behavior: "smooth" });
      try {
        setTimeout(() => {
          this.showDiv2 = false;
        }, 6000);
      } catch (error) {
        this.showToast(errormessage, error.message, errorvariant); // catch Exception for SetTimeout
      }
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //  to follow the user for emoji
  follorunfollemoji(event) {
    try {
      this.usename = event.currentTarget.dataset.name;
      this.username = event.target.dataset.username;
      this.avt = event.currentTarget.dataset.accid;
      this.avtvarfor = event.currentTarget.dataset.avat;
      emojifollow({ loggedAccountId: this.UserAccId, otherAccountId: this.avt })
        .then((result) => {
          if (this.UserAccId === this.avt) {
            this.emifollow = false;
            this.emojifollowing = false;
            document.body.style.overflow = "";
          } else if (result && result.length > 0) {
            this.countrecord = result.length;
            if (result[0].BI_PSP_Type__c === following) {
              this.emojifollowing = true;
              if (this.isDesktop) {
                document.body.style.overflow = "hidden";
              } else {
                document.body.style.overflow = "";
              }
            } else {
              this.emifollow = true;
              if (this.isDesktop) {
                document.body.style.overflow = "hidden";
              } else {
                document.body.style.overflow = "";
              }
            }
          } else {
            this.emifollow = true;
            if (this.isDesktop) {
              document.body.style.overflow = "hidden";
            } else {
              document.body.style.overflow = "";
            }
          }
          return result;
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // then-Catch Exception
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  // open following  popup
  emojiFollowPopupButtonClick() {
    this.emojifollowpopup2 = true;
    this.emifollow = false;
    if (this.isDesktop) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
  }

  //close follow/following popup for Emoji
  emojiclosePopup() {
    this.emifollow = false;
    this.emojifollowpopup2 = false;
    this.emojifollowing = false;
    this.emojifollowingpopup2 = false;
    if (this.isSecondPopupOpen === true) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
  }

  // To follow the user for Emoji
  emojiFollowyes() {
    try {
      this.isLoading = true;
      followuser({ accountIdToFollow: this.avt, userWhoFollows: this.userId })
        .then(() => {
          this.allpost = this.allpost.map((post) => ({
            ...post,
            btnchk:
              post.BI_PSP_AccountR__c === this.acctid ||
              post.BI_PSP_AccountR__c === this.avt
                ? following
                : post.btnchk
          }));
          this.isLoading = false;
          window.scrollTo({ top: 0, behavior: "smooth" });
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // then-Catch Exception
          return false;
        });
      this.emifollow = false;
      this.emojifollowpopup2 = false;
      document.body.style.overflow = "";
      this.showDiv3 = true;
      try {
        setTimeout(() => {
          this.showDiv3 = false;
        }, 6000);
      } catch (error) {
        this.showToast(errormessage, error.message, errorvariant); // catch Exception for setTimeout
      }
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  // follow/following popup for confirmation
  emojiFollowingPopupButtonClick() {
    this.emojifollowingpopup2 = true;
    this.emojifollowing = false;
    if (this.isDesktop) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
  }

  // To unfollow the user for Emoji
  emojiUnFollowingyes() {
    try {
      this.isLoading = true;
      unfollowuser({
        accountIdToUnFollow: this.avt,
        userIdWhoUnFollows: this.userId
      })
        .then(() => {
          this.allpost = this.allpost.map((post) => ({
            ...post,
            btnchk:
              post.BI_PSP_AccountR__c === this.acctid ||
              post.BI_PSP_AccountR__c === this.avt
                ? BI_PSP_Follow
                : post.btnchk
          }));
          this.isLoading = false;
          window.scrollTo({ top: 0, behavior: "smooth" });
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // then-Catch Exception
          return false;
        });
      this.emojifollowing = false;
      this.emojifollowingpopup2 = false;
      document.body.style.overflow = "";
      this.showDiv4 = true;

      try {
        setTimeout(() => {
          this.showDiv4 = false;
        }, 6000);
      } catch (error) {
        this.showToast(errormessage, error.message, errorvariant); // catch Exception for setTimeout
      }
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  // close the follow toast message
  closetstfollow() {
    this.showDiv = false;
    this.showDiv3 = false;
  }
  //close the unfollow toast message
  closetstunflw() {
    this.showDiv2 = false;
    this.showDiv4 = false;
  }

  //close Comment Box
  commentcancel() {
    this.allpost = this.allpost.map((post) => ({
      ...post,
      commentbox: false,
      displayhide: ""
    }));
    this.comment = "";
    this.commentoption = [];
  }
  //insert a comment
  handleCommentChange(event) {
    try {
      this.comment = event.target.value;
      const feedItemId = event.currentTarget.dataset.customFeeditemId;
      if (this.comment && this.comment !== BI_PSP_chatterNoComments) {
        insertcommentoption({
          commentContent: this.comment,
          postId: feedItemId,
          userId: this.userId
        })
          .then(() => {
            this.comment = "";
            this.allpost = this.allpost.map((post) => {
              if (post.Id === feedItemId) {
                return {
                  ...post,
                  CommentCount: post.CommentCount + 1,
                  commentbox: post.Id === feedItemId ? !post.commentbox : false,
                  displayhide:
                    post.Id === feedItemId && !post.commentbox ? "Hide" : ""
                };
              }
              return post;
            });
            this.comment = "";
          })
          .catch((error) => {
            this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
            this.comment = "";
          });
      } else {
        this.comment = "";
      }
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }
  }

  //Open the EditComment Dropdown
  editTheComment(event) {
    this.editTheCommentTxt = "editTheCommentTxt";
    this.closethreedot();
    this.isthreedotclassopen = false;
    document.body.style.overflow = "";
    this.commentid = event.currentTarget.dataset.customFeeditemId;
    this.displaycomment = this.displaycomment.map((comment) => ({
      ...comment,
      showeditthecomment: comment.Id === this.commentid
    }));
  }

  //Edit the Comment
  handleCommentChangeedit(event) {
    try {
      this.editComment = event.target.value;
      this.commentId = event.currentTarget.dataset.customFeeditemId;
      if (this.editComment && this.editComment !== BI_PSP_chatterNoComments) {
        editComment({
          commentToUpdate: this.editComment,
          commentId: this.commentid
        })
          .then((result) => {
            if (result && result !== null) {
              this.displaycomment = this.displaycomment.map((comment) => {
                if (comment.Id === this.commentid) {
                  return {
                    ...comment,
                    BI_PSP_Comment__c: result.BI_PSP_Comment__c,
                    comment: "",
                    showeditthecomment: false
                  };
                }
                this.comment = "";
                return comment;
              });
              this.comment = "";
            } else {
              this.showToast(errormessage, errormessage, errorvariant); // catch Exception if result is null
            }
          })
          .catch((error) => {
            this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
            this.comment = "";
          });
        this.showeditthecomment = false;
        this.comment = "";
      }
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
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

  //Open  comment Box to view the All comments
  commentbtn(event) {
    const postId = event.currentTarget.dataset.customFeeditemId;
    this.allpost = this.allpost.map((post) => ({
      ...post,
      commentbox: post.Id === postId ? !post.commentbox : false,
      displayhide: post.Id === postId && !post.commentbox ? "Hide" : "",
      showEmojiPopup: false
    }));
    this.commentbox = true;
    try {
      //show other user comments for a post
      viewcomment({ feedItemId: postId })
        .then((result) => {
          if (result && result.length > 0) {
            this.displaycomment = result;
            this.getComments = true;
            this.displaycomment = result.map((post) => ({
              ...post,
              formattedTimeDifferenceforcomment:
                this.calculateTimeDifferenceforcomment(post.CreatedDate),
              isCurrentUserCommentCreator:
                this.UserAccId === post.BI_PSP_AccountCmt__c,
              avatarDataforcomment:
                post.BI_PSP_AccountCmt__r.BI_PSP_AvatarUrl__c,
              youname:
                this.UserAccId === post.BI_PSP_AccountCmt__c
                  ? You
                  : post.BI_PSP_AccountCmt__r.BI_PSP_CommunityUsername__c !=
                      null
                    ? post.BI_PSP_AccountCmt__r.BI_PSP_CommunityUsername__c
                    : noUsername
            }));
          } else {
            this.getComments = false;
          }
        })
        .catch((error) => {
          this.showToast(errormessage, error.message, errorvariant); // Then-Catch Exception
          this.getComments = false;
        });
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant); // Catch Exception
    }

    // filter the comments according to phrase and category
    const title = event.currentTarget.dataset.customFeeditemTitle;
    const body = event.currentTarget.dataset.customFeeditemBody;

    if (title === BI_PSP_chatterLifestyle && body === BI_PSP_chatterLifeIMiss) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptRootingForYou,
          value: BI_PSP_chatterOptRootingForYou
        },
        {
          label: BI_PSP_chatterOptLifeFullOf,
          value: BI_PSP_chatterOptLifeFullOf
        },
        {
          label: BI_PSP_chatterOptICantTellWhen,
          value: BI_PSP_chatterOptICantTellWhen
        }
      ];
    } else if (
      title === BI_PSP_chatterLifestyle &&
      body === BI_PSP_chatterLifeWorking
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptEnjoyReality,
          value: BI_PSP_chatterOptEnjoyReality
        },
        {
          label: BI_PSP_chatterOptBraveStrong,
          value: BI_PSP_chatterOptBraveStrong
        },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      body === BI_PSP_chatterLifeNotAlways &&
      title === BI_PSP_chatterLifestyle
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptGetEasy, value: BI_PSP_chatterOptGetEasy },
        {
          label: BI_PSP_chatterOptRootingForYou,
          value: BI_PSP_chatterOptRootingForYou
        },
        {
          label: BI_PSP_chatterOptThankUSaying,
          value: BI_PSP_chatterOptThankUSaying
        },
        {
          label: BI_PSP_chatterOptRightAttitude,
          value: BI_PSP_chatterOptRightAttitude
        }
      ];
    } else if (
      title === BI_PSP_chatterLifestyle &&
      body === BI_PSP_chatterLifeMyCloth
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptRootingForYou,
          value: BI_PSP_chatterOptRootingForYou
        },
        {
          label: BI_PSP_chatterOptOurLifeFull,
          value: BI_PSP_chatterOptOurLifeFull
        },
        {
          label: BI_PSP_chatterOptManyThingsCannot,
          value: BI_PSP_chatterOptManyThingsCannot
        }
      ];
    } else if (
      title === BI_PSP_chatterLifestyle &&
      body === BI_PSP_chatterLifeIWould
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptICantTellWhen,
          value: BI_PSP_chatterOptICantTellWhen
        },
        {
          label: BI_PSP_chatterOptDontGiveUp,
          value: BI_PSP_chatterOptDontGiveUp
        },
        {
          label: BI_PSP_chatterOptManyThingsCannot,
          value: BI_PSP_chatterOptManyThingsCannot
        }
      ];
    } else if (
      title === BI_PSP_chatterLifestyle &&
      body === BI_PSP_chatterLifeEvenGpp
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        {
          label: BI_PSP_chatterOptProudOfYou,
          value: BI_PSP_chatterOptProudOfYou
        },
        { label: BI_PSP_chatterOptAmazing, value: BI_PSP_chatterOptAmazing },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      title === BI_PSP_chatterLifestyle &&
      body === BI_PSP_chatterLifeAfterOver
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptInspiration,
          value: BI_PSP_chatterOptInspiration
        },
        {
          label: BI_PSP_chatterOptOurLifeFull,
          value: BI_PSP_chatterOptOurLifeFull
        },
        {
          label: BI_PSP_chatterOptBraveStrong,
          value: BI_PSP_chatterOptBraveStrong
        }
      ];
    } else if (
      title === BI_PSP_chatterLifestyle &&
      body === BI_PSP_chatterLifeThereAre
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptICantTellWhen,
          value: BI_PSP_chatterOptICantTellWhen
        },
        { label: BI_PSP_chatterOptGetEasy, value: BI_PSP_chatterOptGetEasy },
        {
          label: BI_PSP_chatterOptEverythingAlright,
          value: BI_PSP_chatterOptEverythingAlright
        },
        {
          label: BI_PSP_chatterOptOurLifeFull,
          value: BI_PSP_chatterOptOurLifeFull
        },
        {
          label: BI_PSP_chatterOptManyThingsCannot,
          value: BI_PSP_chatterOptManyThingsCannot
        }
      ];
    } else if (
      title === BI_PSP_chatterLifestyle &&
      body === BI_PSP_chatterLifeIDid
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialActivelyWork
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptIWentThrough,
          value: BI_PSP_chatterOptIWentThrough
        },
        {
          label: BI_PSP_chatterOptBraveStrong,
          value: BI_PSP_chatterOptBraveStrong
        },
        {
          label: BI_PSP_chatterOptEverythingAlright,
          value: BI_PSP_chatterOptEverythingAlright
        }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialToExplain
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptEmbarrased,
          value: BI_PSP_chatterOptEmbarrased
        },
        {
          label: BI_PSP_chatterOptDontBeHard,
          value: BI_PSP_chatterOptDontBeHard
        },
        {
          label: BI_PSP_chatterOptBraveStrong,
          value: BI_PSP_chatterOptBraveStrong
        }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialTalking
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        {
          label: BI_PSP_chatterOptImSoProud,
          value: BI_PSP_chatterOptImSoProud
        },
        {
          label: BI_PSP_chatterOptYouAmazing,
          value: BI_PSP_chatterOptYouAmazing
        },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialOnlyClose
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptTryNotTo, value: BI_PSP_chatterOptTryNotTo },
        {
          label: BI_PSP_chatterOptEmbarrased,
          value: BI_PSP_chatterOptEmbarrased
        },
        { label: BI_PSP_chatterOptYouDefine, value: BI_PSP_chatterOptYouDefine }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialSharedMy
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialStaying
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        {
          label: BI_PSP_chatterOptHappyForU,
          value: BI_PSP_chatterOptHappyForU
        },
        {
          label: BI_PSP_chatterOptRootingForYou,
          value: BI_PSP_chatterOptRootingForYou
        }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialWantToIntimate
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptIWentThrough,
          value: BI_PSP_chatterOptIWentThrough
        },
        {
          label: BI_PSP_chatterOptICantTellWhen,
          value: BI_PSP_chatterOptICantTellWhen
        },
        {
          label: BI_PSP_chatterOptEverythingAlright,
          value: BI_PSP_chatterOptEverythingAlright
        },
        {
          label: BI_PSP_chatterOptBraveStrong,
          value: BI_PSP_chatterOptBraveStrong
        }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialGotChance
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialEmbarrase
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptEmbarrased,
          value: BI_PSP_chatterOptEmbarrased
        },
        { label: BI_PSP_chatterOptTryNotTo, value: BI_PSP_chatterOptTryNotTo },
        {
          label: BI_PSP_chatterOptYouDefine,
          value: BI_PSP_chatterOptYouDefine
        },
        {
          label: BI_PSP_chatterOptYouGreatWonder,
          value: BI_PSP_chatterOptYouGreatWonder
        }
      ];
    } else if (
      title === BI_PSP_chatterSocial &&
      body === BI_PSP_chatterSocialThingsBetter
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptKeepUpGood,
          value: BI_PSP_chatterOptKeepUpGood
        },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome }
      ];
    } else if (
      title === BI_PSP_chatterMedical &&
      body === BI_PSP_chatterMedicalDontFeel
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptFeltSame, value: BI_PSP_chatterOptFeltSame },
        {
          label: BI_PSP_chatterOptTalkingDoctor,
          value: BI_PSP_chatterOptTalkingDoctor
        },
        {
          label: BI_PSP_chatterOptPatientOrg,
          value: BI_PSP_chatterOptPatientOrg
        },
        {
          label: BI_PSP_chatterOptFindSomeone,
          value: BI_PSP_chatterOptFindSomeone
        }
      ];
    } else if (
      title === BI_PSP_chatterMedical &&
      body === BI_PSP_chatterMedicalSeenDoc
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptStayStrong,
          value: BI_PSP_chatterOptStayStrong
        },
        {
          label: BI_PSP_chatterOptTalkPsoriasis,
          value: BI_PSP_chatterOptTalkPsoriasis
        },
        { label: BI_PSP_chatterOptFeltSame, value: BI_PSP_chatterOptFeltSame }
      ];
    } else if (
      title === BI_PSP_chatterMedical &&
      body === BI_PSP_chatterMedicalFinally
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      title === BI_PSP_chatterPsychologi &&
      body === BI_PSP_chatterPsycFeelAlone
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptIWentThrough,
          value: BI_PSP_chatterOptIWentThrough
        },
        {
          label: BI_PSP_chatterOptNormalFeel,
          value: BI_PSP_chatterOptNormalFeel
        },
        {
          label: BI_PSP_chatterOptFindToTalk,
          value: BI_PSP_chatterOptFindToTalk
        },
        {
          label: BI_PSP_chatterOptStayStrong,
          value: BI_PSP_chatterOptStayStrong
        },
        {
          label: BI_PSP_chatterOptHavingFeel,
          value: BI_PSP_chatterOptHavingFeel
        }
      ];
    } else if (
      title === BI_PSP_chatterPsychologi &&
      body === BI_PSP_chatterPsycFeelAnxious
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptRootingForYou,
          value: BI_PSP_chatterOptRootingForYou
        },
        {
          label: BI_PSP_chatterOptNormalFeel,
          value: BI_PSP_chatterOptNormalFeel
        },
        {
          label: BI_PSP_chatterOptICantTellWhen,
          value: BI_PSP_chatterOptICantTellWhen
        }
      ];
    } else if (
      title === BI_PSP_chatterPsychologi &&
      body === BI_PSP_chatterPsycWornOut
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptBeCareful,
          value: BI_PSP_chatterOptBeCareful
        },
        {
          label: BI_PSP_chatterOptFeltSameway,
          value: BI_PSP_chatterOptFeltSameway
        },
        {
          label: BI_PSP_chatterOptPossibleTo,
          value: BI_PSP_chatterOptPossibleTo
        },
        {
          label: BI_PSP_chatterOptRootingForYou,
          value: BI_PSP_chatterOptRootingForYou
        }
      ];
    } else if (
      title === BI_PSP_chatterPsychologi &&
      body === BI_PSP_chatterPsycThingsBetter
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        {
          label: BI_PSP_chatterOptHappyForU,
          value: BI_PSP_chatterOptHappyForU
        },
        { label: BI_PSP_chatterOptGoodHear, value: BI_PSP_chatterOptGoodHear },
        { label: BI_PSP_chatterOptWonderful, value: BI_PSP_chatterOptWonderful }
      ];
    } else if (
      title === BI_PSP_chatterPsychologi &&
      body === BI_PSP_chatterPsycDontLetGpp
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptDisease, value: BI_PSP_chatterOptDisease },
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptKeepUpGood,
          value: BI_PSP_chatterOptKeepUpGood
        },
        {
          label: BI_PSP_chatterOptThankInspiration,
          value: BI_PSP_chatterOptThankInspiration
        },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      title === BI_PSP_chatterPsychologi &&
      body === BI_PSP_chatterPsycGPPHardBattle
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptNormalFeel,
          value: BI_PSP_chatterOptNormalFeel
        },
        {
          label: BI_PSP_chatterOptExperienceMyself,
          value: BI_PSP_chatterOptExperienceMyself
        },
        {
          label: BI_PSP_chatterOptStayStrong,
          value: BI_PSP_chatterOptStayStrong
        }
      ];
    } else if (
      title === BI_PSP_chatterPsychologi &&
      body === BI_PSP_chatterPsycTodayFeel
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptHopeOut, value: BI_PSP_chatterOptHopeOut },
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptKeepUpGood,
          value: BI_PSP_chatterOptKeepUpGood
        },
        {
          label: BI_PSP_chatterOptThankInspiration,
          value: BI_PSP_chatterOptThankInspiration
        },
        { label: BI_PSP_chatterOptThatGreat, value: BI_PSP_chatterOptThatGreat }
      ];
    } else if (
      title === BI_PSP_chatterPsychologi &&
      body === BI_PSP_chatterPsycEvenThough
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptKeepUpGood,
          value: BI_PSP_chatterOptKeepUpGood
        },
        {
          label: BI_PSP_chatterOptThankInspiration,
          value: BI_PSP_chatterOptThankInspiration
        },
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome }
      ];
    } else if (
      title === BI_PSP_chatterPsychologi &&
      body === BI_PSP_chatterPsycIAccept
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptKeepItUp, value: BI_PSP_chatterOptKeepItUp },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      title === BI_PSP_chatterOccupation &&
      body === BI_PSP_chatterOccICannot
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptDermatologi,
          value: BI_PSP_chatterOptDermatologi
        },
        {
          label: BI_PSP_chatterOptTalkEmply,
          value: BI_PSP_chatterOptTalkEmply
        },
        {
          label: BI_PSP_chatterOptIWentThrough,
          value: BI_PSP_chatterOptIWentThrough
        }
      ];
    } else if (
      title === BI_PSP_chatterOccupation &&
      body === BI_PSP_chatterOccComplicate
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptDermatologistGPP,
          value: BI_PSP_chatterOptDermatologistGPP
        },
        {
          label: BI_PSP_chatterOptTryComfort,
          value: BI_PSP_chatterOptTryComfort
        },
        {
          label: BI_PSP_chatterOptTalkingDoctor,
          value: BI_PSP_chatterOptTalkingDoctor
        }
      ];
    } else if (
      title === BI_PSP_chatterOccupation &&
      body === BI_PSP_chatterOccWorlColleague
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        { label: BI_PSP_chatterOptHappyForU, value: BI_PSP_chatterOptHappyForU }
      ];
    } else if (
      title === BI_PSP_chatterOccupation &&
      body === BI_PSP_chatterOccFeelMyFamily
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptPleasedHelp,
          value: BI_PSP_chatterOptPleasedHelp
        },
        {
          label: BI_PSP_chatterOptSpeakDermato,
          value: BI_PSP_chatterOptSpeakDermato
        }
      ];
    } else if (
      title === BI_PSP_chatterGPP &&
      body === BI_PSP_chatterGppIDontKnow
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptTalkToDoctor,
          value: BI_PSP_chatterOptTalkToDoctor
        },
        {
          label: BI_PSP_chatterOptFindToTalk,
          value: BI_PSP_chatterOptFindToTalk
        },
        {
          label: BI_PSP_chatterOptAnotherDermato,
          value: BI_PSP_chatterOptAnotherDermato
        }
      ];
    } else if (
      title === BI_PSP_chatterGPP &&
      body === BI_PSP_chatterGppWhileGiving
    ) {
      this.commentoption = [
        { label: BI_PSP_chatterOptWillPass, value: BI_PSP_chatterOptWillPass },
        {
          label: BI_PSP_chatterOptGoingFine,
          value: BI_PSP_chatterOptGoingFine
        },
        {
          label: BI_PSP_chatterOptThingsImprove,
          value: BI_PSP_chatterOptThingsImprove
        },
        { label: BI_PSP_chatterOptGetEasy, value: BI_PSP_chatterOptGetEasy },
        {
          label: BI_PSP_chatterOptStayPositive,
          value: BI_PSP_chatterOptStayPositive
        }
      ];
    } else if (
      title === BI_PSP_chatterGPP &&
      body === BI_PSP_chatterGppSkinImprove
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptHappyForU,
          value: BI_PSP_chatterOptHappyForU
        },
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome }
      ];
    } else if (
      title === BI_PSP_chatterGPP &&
      body === BI_PSP_chatterGppActivelyExplore
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptStayPositive,
          value: BI_PSP_chatterOptStayPositive
        },
        {
          label: BI_PSP_chatterOptGoingAlright,
          value: BI_PSP_chatterOptGoingAlright
        },
        {
          label: BI_PSP_chatterOptICantTellWhen,
          value: BI_PSP_chatterOptICantTellWhen
        }
      ];
    } else if (
      title === BI_PSP_chatterGPP &&
      body === BI_PSP_chatterGppUnderstanding
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptThatGreat,
          value: BI_PSP_chatterOptThatGreat
        },
        { label: BI_PSP_chatterOptAwesome, value: BI_PSP_chatterOptAwesome },
        {
          label: BI_PSP_chatterOptHappyForU,
          value: BI_PSP_chatterOptHappyForU
        },
        {
          label: BI_PSP_chatterOptRightAttitude,
          value: BI_PSP_chatterOptRightAttitude
        },
        {
          label: BI_PSP_chatterOptKeepPositive,
          value: BI_PSP_chatterOptKeepPositive
        }
      ];
    } else if (
      title === BI_PSP_chatterGPP &&
      body === BI_PSP_chatterGppFeelAlone
    ) {
      this.commentoption = [
        {
          label: BI_PSP_chatterOptSameEmotion,
          value: BI_PSP_chatterOptSameEmotion
        },
        {
          label: BI_PSP_chatterOptTalkToDoctor,
          value: BI_PSP_chatterOptTalkToDoctor
        },
        {
          label: BI_PSP_chatterOptTalkDermatoToHelp,
          value: BI_PSP_chatterOptTalkDermatoToHelp
        }
      ];
    } else {
      this.commentoption = [
        { label: BI_PSP_chatterNoComments, value: BI_PSP_chatterNoComments }
      ];
    }
  }
  // To detect the site is branded or unassigned
  detectBrandedOrUnassigned() {
    const currentURL = window.location.href;
    const urlObject = new URL(currentURL);
    const path = urlObject.pathname;
    const pathComponents = path.split("/");
    const desiredComponent = pathComponents.find((component) =>
      [brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
        component.toLowerCase()
      )
    );
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