// This lightning web component is used to display the searched article and search avatar message
// To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
// To import Apex Classes
import retrieveMediaFromCMSNews from '@salesforce/apex/BI_PSPB_CmsCtrl.retrieveMediaFromCMSNews';
import showfilterresponse from '@salesforce/apex/BI_PSPB_PersonalizedMessagesCtrl.retrieveAssessmentRecordsForCurrentUser';
import Patientstatus from '@salesforce/apex/BI_PSPB_treatmentvideocmd.patientStatus';
import updatereaction from '@salesforce/apex/BI_PSPB_CmsCtrl.updatereaction';
// To import Custom Labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import statusacute from '@salesforce/label/c.BI_PSPB_Acute';
import statuschronic from '@salesforce/label/c.BI_PSPB_statusChronic';
import spcategoryone from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryOne';
import spcategorytwo from '@salesforce/label/c.BI_PSPB_articleSpevigoCategoryTwo';
import spcategoryvalone from '@salesforce/label/c.BI_PSPB_spArticleCategoryValOne';
import spcategoryvaltwo from '@salesforce/label/c.BI_PSPB_spArticleCategoryValTwo';
import statusunassigned from '@salesforce/label/c.BI_PSP_Unassigned';
import articletwentyseven from '@salesforce/label/c.BI_PSPB_articleTwentySeven';
import articletwentyeight from '@salesforce/label/c.BI_PSPB_articleTwentyEight';
import articletwentynine from '@salesforce/label/c.BI_PSPB_articleTwentyNine';
import articletwentyfive from '@salesforce/label/c.BI_PSPB_articleTwentyFive';
import articletwentysix from '@salesforce/label/c.BI_PSPB_articleTwentySix';
import searchnoresults from '@salesforce/label/c.BI_PSPB_searchNoResults';
import articlecategoryone from '@salesforce/label/c.BI_PSPB_articleCategoryOne';
import articlecategorytwo from '@salesforce/label/c.BI_PSPB_articleCategoryTwo';
import articlecategorythree from '@salesforce/label/c.BI_PSPB_articleCategoryThree';
import articlecategoryfour from '@salesforce/label/c.BI_PSPB_articleCategoryFour';
import articlecategoryfive from '@salesforce/label/c.BI_PSPB_articleCategoryFive';
import articlecategoryvalone from '@salesforce/label/c.BI_PSPB_articleCategoryValOne';
import articlecategoryvaltwo from '@salesforce/label/c.BI_PSPB_articleCategoryValTwo';
import articlecategoryvalthree from '@salesforce/label/c.BI_PSPB_articleCategoryValThree';
import articlecategoryvalfour from '@salesforce/label/c.BI_PSPB_articleCategoryValFour';
import articlecategoryvalfive from '@salesforce/label/c.BI_PSPB_articleCategoryValFive';
import articlenineteen from '@salesforce/label/c.BI_PSPB_articleNineteen';
import gpptag from '@salesforce/label/c.BI_PSPB_GppTag';
import gpptreatment from '@salesforce/label/c.BI_PSPB_gppTreatment';
import gppsymptoms from '@salesforce/label/c.BI_PSPB_gppSymptoms';
import gppflare from '@salesforce/label/c.BI_PSPB_gppFlare';
import gppcontagious from '@salesforce/label/c.BI_PSPB_gppContagious';
import gppspread from '@salesforce/label/c.BI_PSPB_gppSpread';
import explaininggpp from '@salesforce/label/c.BI_PSPB_explaningGpp';
import gppintimacy from '@salesforce/label/c.BI_PSPB_gppIntimacy';
import gppdiscomfort from '@salesforce/label/c.BI_PSPB_gppDiscomfort';
import gppcomorbidities from '@salesforce/label/c.BI_PSPB_gppComorbidities';
import comorbidities from '@salesforce/label/c.BI_PSPB_Comorbidities';
import lettinghcp from '@salesforce/label/c.BI_PSPB_lettingHcp';
import checklist from '@salesforce/label/c.BI_PSPB_checklist';
import preparingadvance from '@salesforce/label/c.BI_PSPB_preparingAdvance';
import impsigns from '@salesforce/label/c.BI_PSPB_impSigns';
import emmercare from '@salesforce/label/c.BI_PSPB_emercare';
import qsask from '@salesforce/label/c.BI_PSPB_qsAsk';
import talkingtohcp from '@salesforce/label/c.BI_PSPB_talkingToHcp';
import gppvisit from '@salesforce/label/c.BI_PSPB_gppVisit';
import symptomlist from '@salesforce/label/c.BI_PSPB_symptomList';
import gpptypes from '@salesforce/label/c.BI_PSPB_gppTypes';
import treatmenthelp from '@salesforce/label/c.BI_PSPB_treatmentsHelp';
import supportgpp from '@salesforce/label/c.BI_PSPB_supportGpp';
import managegpp from '@salesforce/label/c.BI_PSPB_manageGpp';
import manageflares from '@salesforce/label/c.BI_PSPB_manageflares';
import medihelp from '@salesforce/label/c.BI_PSPB_getMediHelp';
import flarescause from '@salesforce/label/c.BI_PSPB_flaresAndCauses';
import gppques from '@salesforce/label/c.BI_PSPB_gppQues';
import gppcare from '@salesforce/label/c.BI_PSPB_gppCare';
import gpppreg from '@salesforce/label/c.BI_PSPB_gppPregnancy';
import talkpart from '@salesforce/label/c.BI_PSPB_talkPartner';
import discomfortstring from '@salesforce/label/c.BI_PSPB_discomfort';
import intimacystr from '@salesforce/label/c.BI_PSPB_intimacyStr';
import pregngpp from '@salesforce/label/c.BI_PSPB_pregnancyGpp';
import sitename from '@salesforce/label/c.BI_PSPB_TestsiteName';
import articlestring from '@salesforce/label/c.BI_PSPB_ArticleString';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import hcpinfo from '@salesforce/label/c.BI_PSPB_hcpInfo';
import gppchal from '@salesforce/label/c.BI_PSPB_gppChallenges';
import gppdiagn from '@salesforce/label/c.BI_PSPB_gppDiagnosis';
import gppexperi from '@salesforce/label/c.BI_PSPB_gppExperiences';
import accptreat from '@salesforce/label/c.BI_PSPB_acceptanceTreatment';
import brandedsiteurl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unassignedsiteurl from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import detailpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterDetailPage';
import categorypage from '@salesforce/label/c.BI_PSPB_BRInfoCenterCategoryPage';
import landingpage from '@salesforce/label/c.BI_PSPB_BRInfoCenterLandingPage';
import acutepage from '@salesforce/label/c.BI_PSPB_AcuteVideoPage';
import chronicpage from '@salesforce/label/c.BI_PSPB_chronicVideoPage';
import scarprocess from '@salesforce/label/c.BI_PSPB_scarprocess';
import dealstr from '@salesforce/label/c.BI_PSPB_dealString';
import scargpp from '@salesforce/label/c.BI_PSPB_scarGpp';
import protectgpp from '@salesforce/label/c.BI_PSPB_protectGpp';
import gppcomplicat from '@salesforce/label/c.BI_PSPB_gppComplicat';
import avoidcomplicat from '@salesforce/label/c.BI_PSPB_avoidComplicat';
import pregnancy from '@salesforce/label/c.BI_PSPB_pregnancy';
import choicesgpp from '@salesforce/label/c.BI_PSPB_choicesGpp';
import gppeat from '@salesforce/label/c.BI_PSPB_gppEat';
import actgpp from '@salesforce/label/c.BI_PSPB_actGpp';
import choices from '@salesforce/label/c.BI_PSPB_choices';
import eating from '@salesforce/label/c.BI_PSPB_eating';
import stigma from '@salesforce/label/c.BI_PSPB_stigma';
import challenges from '@salesforce/label/c.BI_PSP_challenges';
import getsupport from '@salesforce/label/c.BI_PSPB_gettingSupport';
import diagnomethod from '@salesforce/label/c.BI_PSPB_diagnosisMethod';
import shareexperience from '@salesforce/label/c.BI_PSPB_shareExperi';
import howtotalk from '@salesforce/label/c.BI_PSPB_howToTalk';
import sharing from '@salesforce/label/c.BI_PSPB_sharing';
import what from '@salesforce/label/c.BI_PSPB_what';
import why from '@salesforce/label/c.BI_PSPB_why';
import whoofgpp from '@salesforce/label/c.BI_PSPB_whoOfGpp';
import causesgpp from '@salesforce/label/c.BI_PSPB_causesGpp';
import contagiousness from '@salesforce/label/c.BI_PSPB_contagiousness';
import explainittoothers from '@salesforce/label/c.BI_PSPB_explainToOthers';
import flares from '@salesforce/label/c.BI_PSPB_flares';
import symptomrecognize from '@salesforce/label/c.BI_PSPB_symptomsToRecognize';
import incidence from '@salesforce/label/c.BI_PSPB_incidence';
import meanofraregpp from '@salesforce/label/c.BI_PSPB_meanOfRareGpp';
import rareofgpp from '@salesforce/label/c.BI_PSPB_rareOfGpp';
import peoplewithgpp from '@salesforce/label/c.BI_PSPB_peopleWithGpp';
import activityetc from '@salesforce/label/c.BI_PSPB_activityEtc';
import care from '@salesforce/label/c.BI_PSPB_care';
import talkgpptohcp from '@salesforce/label/c.BI_PSPB_talkGppToHcp';
import colleguesetc from '@salesforce/label/c.BI_PSPB_colleguesetc';
import howto from '@salesforce/label/c.BI_PSPB_howTo';
import itstriggers from '@salesforce/label/c.BI_PSPB_itsTriggers';
import gppcauses from '@salesforce/label/c.BI_PSPB_gppCauses';
import triggersforgpp from '@salesforce/label/c.BI_PSPB_triggersForGpp';
import gppfeelings from '@salesforce/label/c.BI_PSPB_gppFeelings';
import managinggpp from '@salesforce/label/c.BI_PSPB_managiningGpp';
import tipsongpp from '@salesforce/label/c.BI_PSPB_tipsOnGpp';
import livingwithgpp from '@salesforce/label/c.BI_PSPB_livingWithGpp';
import tips from '@salesforce/label/c.BI_PSPB_tips';
import feelingsetc from '@salesforce/label/c.BI_PSPB_manageFeelingsEtc';
import evententer from '@salesforce/label/c.BI_PSP_EventEnter';
import viewlabel from '@salesforce/label/c.BI_PSPB_View';
import articleone from '@salesforce/label/c.BI_PSPB_articleOne';
import articletwo from '@salesforce/label/c.BI_PSPB_articleTwo';
import articlethree from '@salesforce/label/c.BI_PSPB_articleThree';
import articlefour from '@salesforce/label/c.BI_PSPB_articleFour';
import articlefive from '@salesforce/label/c.BI_PSPB_articleFive';
import articlesix from '@salesforce/label/c.BI_PSPB_articleSix';
import articleseven from '@salesforce/label/c.BI_PSPB_articleSeven';
import articleeight from '@salesforce/label/c.BI_PSPB_articleEight';
import articlenine from '@salesforce/label/c.BI_PSPB_articleNine';
import articleten from '@salesforce/label/c.BI_PSPB_articleTen';
import articleeleven from '@salesforce/label/c.BI_PSPB_articleEleven';
import articletwelve from '@salesforce/label/c.BI_PSPB_articleTwelve';
import articlethirteen from '@salesforce/label/c.BI_PSPB_articleThirteen';
import articlefourteen from '@salesforce/label/c.BI_PSPB_articleFourteen';
import articlefifteen from '@salesforce/label/c.BI_PSPB_articleFifteen';
import articlesixteen from '@salesforce/label/c.BI_PSPB_articleSixteen';
import articleseventeen from '@salesforce/label/c.BI_PSPB_articleSeventeen';
import articleeighteen from '@salesforce/label/c.BI_PSPB_articleEighteen';
import articletwenty from '@salesforce/label/c.BI_PSPB_articleTwenty';
import articletwentyone from '@salesforce/label/c.BI_PSPB_articleTwentyOne';
import articletwentytwo from '@salesforce/label/c.BI_PSPB_articleTwentyTwo';
import articletwentythree from '@salesforce/label/c.BI_PSPB_articleTwentyThree';
import articletwentyfour from '@salesforce/label/c.BI_PSPB_articleTwentyFour';
import BI_PSPB_ArticleOneRT from '@salesforce/label/c.BI_PSPB_ArticleOneRT';
import BI_PSPB_ArticleTwoRT from '@salesforce/label/c.BI_PSPB_ArticleTwoRT';
import BI_PSPB_ArticleThreeRT from '@salesforce/label/c.BI_PSPB_ArticleThreeRT';
import BI_PSPB_ArticleFourRT from '@salesforce/label/c.BI_PSPB_ArticleFourRT';
import BI_PSPB_ArticleFiveRT from '@salesforce/label/c.BI_PSPB_ArticleFiveRT';
import BI_PSPB_ArticleSixRT from '@salesforce/label/c.BI_PSPB_ArticleSixRT';
import BI_PSPB_ArticleSevenRT from '@salesforce/label/c.BI_PSPB_ArticleSevenRT';
import BI_PSPB_ArticleEightRT from '@salesforce/label/c.BI_PSPB_ArticleEightRT';
import BI_PSPB_ArticleNineRT from '@salesforce/label/c.BI_PSPB_ArticleNineRT';
import BI_PSPB_ArticleTenRT from '@salesforce/label/c.BI_PSPB_ArticleTenRT';
import BI_PSPB_ArticleElevenRT from '@salesforce/label/c.BI_PSPB_ArticleElevenRT';
import BI_PSPB_ArticleTwelveRT from '@salesforce/label/c.BI_PSPB_ArticleTwelveRT';
import BI_PSPB_ArticleThirteenRT from '@salesforce/label/c.BI_PSPB_ArticleThirteenRT';
import BI_PSPB_ArticleFourteenRT from '@salesforce/label/c.BI_PSPB_ArticleFourteenRT';
import BI_PSPB_ArticleFifteenRT from '@salesforce/label/c.BI_PSPB_ArticleFifteenRT';
import BI_PSPB_ArticleSixteenRT from '@salesforce/label/c.BI_PSPB_ArticleSixteenRT';
import BI_PSPB_ArticleSeventeenRT from '@salesforce/label/c.BI_PSPB_ArticleSeventeenRT';
import BI_PSPB_ArticleEighteenRT from '@salesforce/label/c.BI_PSPB_ArticleEighteenRT';
import BI_PSPB_ArticleNineteenRT from '@salesforce/label/c.BI_PSPB_ArticleNineteenRT';
import BI_PSPB_ArticleTwentyRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyRT';
import BI_PSPB_ArticleTwentyOneRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyOneRT';
import BI_PSPB_ArticleTwentyTwoRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyTwoRT';
import BI_PSPB_ArticleTwentyThreeRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyThreeRT';
import BI_PSPB_ArticleTwentyFourRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyFourRT';
import BI_PSPB_ArticleTwentyFiveRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyFiveRT';
import BI_PSPB_ArticleTwentySixRT from '@salesforce/label/c.BI_PSPB_ArticleTwentySixRT';
import BI_PSPB_ArticleTwentySevenRT from '@salesforce/label/c.BI_PSPB_ArticleTwentySevenRT';
import BI_PSPB_ArticleTwentyEightRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyEightRT';
import BI_PSPB_ArticleTwentyNineRT from '@salesforce/label/c.BI_PSPB_ArticleTwentyNineRT';
// To get Current UserId
import Id from '@salesforce/user/Id';

export default class BiPspbsearcharticlecmp extends LightningElement {
	// Proper naming conventions with camel case for all the variable will be followed in the future releases
	// Track variable Declarations(re-render variables)
	@track userId = Id;
	@track searchre = '';
	@track shownoresults = false;
	@track resulti = '';
	@track currentlength;
	@track originalsearchitemsofsearch = [];
	@track showloadmore = false;
	@track showjustforme_sec = false;
	@track showbrandednav = true;
	@track image12 = [];
	@track heightofcal;
	@track patientstatusval = '';
	@track categorytreatmentnewadb;
	@track searchitems = [];
	@track originalsearchitems = [];
	@track standarItems = [];
	@track results = [];
	@track result = [];
	@track touch = false;
	@track down = true;
	@track up = false;
	@track urlq;
	// Global variables(without @track does not trigger automatic re-renders)
	currentPageUrl;
	urlSegments;
	baseUrl;
	siteUrlq;
	searchTerm = '';
	relatedItems = [];
	channelName = sitename;
	image1;
	image2;
	image3;
	heading1;
	heading2;
	heading3;
	description1;
	description2;
	description3;
	threeDifferentNumbers;
	titlear;
	topics = {
		[articleone]: [BI_PSPB_ArticleOneRT],
		[articletwo]: [BI_PSPB_ArticleTwoRT],
		[articlethree]: [BI_PSPB_ArticleThreeRT],
		[articlefour]: [BI_PSPB_ArticleFourRT],
		[articlefive]: [BI_PSPB_ArticleFiveRT],
		[articlesix]: [BI_PSPB_ArticleSixRT],
		[articleseven]: [BI_PSPB_ArticleSevenRT],
		[articleeight]: [BI_PSPB_ArticleEightRT],
		[articlenine]: [BI_PSPB_ArticleNineRT],
		[articleten]: [BI_PSPB_ArticleTenRT],
		[articleeleven]: [BI_PSPB_ArticleElevenRT],
		[articletwelve]: [BI_PSPB_ArticleTwelveRT],
		[articlethirteen]: [BI_PSPB_ArticleThirteenRT],
		[articlefourteen]: [BI_PSPB_ArticleFourteenRT],
		[articlefifteen]: [BI_PSPB_ArticleFifteenRT],
		[articlesixteen]: [BI_PSPB_ArticleSixteenRT],
		[articleseventeen]: [BI_PSPB_ArticleSeventeenRT],
		[articleeighteen]: [BI_PSPB_ArticleEighteenRT],
		[articlenineteen]: [BI_PSPB_ArticleNineteenRT],
		[articletwenty]: [BI_PSPB_ArticleTwentyRT],
		[articletwentyone]: [BI_PSPB_ArticleTwentyOneRT],
		[articletwentytwo]: [BI_PSPB_ArticleTwentyTwoRT],
		[articletwentythree]: [BI_PSPB_ArticleTwentyThreeRT],
		[articletwentyfour]: [BI_PSPB_ArticleTwentyFourRT],
		[articletwentyfive]: [BI_PSPB_ArticleTwentyFiveRT],
		[articletwentysix]: [BI_PSPB_ArticleTwentySixRT],
		[articletwentyseven]: [BI_PSPB_ArticleTwentySevenRT],
		[articletwentyeight]: [BI_PSPB_ArticleTwentyEightRT],
		[articletwentynine]: [BI_PSPB_ArticleTwentyNineRT]
	}
	// button labels
	standarItemlink = [
		{ id: 1, title: articlecategoryone, titleadb: articlecategoryvalone },
		{
			id: 2,
			title: articlecategorytwo,
			titleadb: articlecategoryvaltwo
		},
		{
			id: 3,
			title: articlecategorythree,
			titleadb: articlecategoryvalthree
		},
		{
			id: 4,
			title: articlecategoryfour,
			titleadb: articlecategoryvalfour
		},
		{
			id: 5,
			title: articlecategoryfive,
			titleadb: articlecategoryvalfive
		}
	];

	data_tags = [
		{
			searchTermn: [gpptag, flarescause],
			standardItem: [
				{ id: 1, title: gppsymptoms },
				{ id: 2, title: gppques }
			]
		},
		{
			searchTermn: [what, why, whoofgpp],
			standardItem: [
				{ id: 3, title: gppques },
				{ id: 4, title: causesgpp },
				{ id: 5, title: gppcontagious }
			]
		},
		{
			searchTermn: [contagiousness, explainittoothers],
			standardItem: [
				{ id: 6, title: gppcontagious },
				{ id: 7, title: gppspread },
				{ id: 8, title: explaininggpp }
			]
		},
		{
			searchTermn: [scarprocess, dealstr],
			standardItem: [
				{ id: 9, title: scargpp },
				{ id: 10, title: protectgpp }
			]
		},
		{
			searchTermn: [avoidcomplicat, pregnancy],
			standardItem: [
				{ id: 11, title: gppcomplicat },
				{ id: 12, title: gpppreg }
			]
		},
		{
			searchTermn: [flares, symptomrecognize],
			standardItem: [
				{ id: 13, title: gppflare },
				{ id: 14, title: gppsymptoms },
				{ id: 15, title: gpptypes }
			]
		},
		{
			searchTermn: [incidence, meanofraregpp],
			standardItem: [
				{ id: 16, title: rareofgpp },
				{ id: 17, title: peoplewithgpp }
			]
		},
		{
			searchTermn: [causesgpp, itstriggers],
			standardItem: [
				{ id: 18, title: gppcauses },
				{ id: 19, title: triggersforgpp }
			]
		},
		{
			searchTermn: [talkgpptohcp, colleguesetc, howto],
			standardItem: [
				{ id: 20, title: explaininggpp },
				{ id: 21, title: talkingtohcp }
			]
		},
		{
			searchTermn: [livingwithgpp, tips, feelingsetc],
			standardItem: [
				{ id: 22, title: tipsongpp },
				{ id: 23, title: managinggpp },
				{ id: 24, title: gppfeelings }
			]
		},
		{
			searchTermn: [shareexperience, howtotalk],
			standardItem: [
				{ id: 25, title: gppexperi },
				{ id: 26, title: sharing },
				{ id: 27, title: explaininggpp }
			]
		},
		{
			searchTermn: [diagnomethod, accptreat],
			standardItem: [
				{ id: 28, title: gppdiagn },
				{ id: 29, title: supportgpp },
				{ id: 30, title: gpptreatment }
			]
		},
		{
			searchTermn: [stigma, challenges, getsupport],
			standardItem: [
				{ id: 31, title: supportgpp },
				{ id: 32, title: gppchal }
			]
		},
		{
			searchTermn: [choices, eating, activityetc],
			standardItem: [
				{ id: 33, title: choicesgpp },
				{ id: 34, title: gppeat },
				{ id: 35, title: actgpp }
			]
		},
		{
			searchTermn: [pregngpp, care, hcpinfo],
			standardItem: [
				{ id: 36, title: gpppreg },
				{ id: 37, title: gppcare },
				{ id: 38, title: talkingtohcp }
			]
		},
		{
			searchTermn: [intimacystr, talkpart, discomfortstring],
			standardItem: [
				{ id: 39, title: gppintimacy },
				{ id: 40, title: gppdiscomfort },
				{ id: 41, title: explaininggpp }
			]
		},
		{
			searchTermn: [manageflares, medihelp],
			standardItem: [
				{ id: 42, title: managegpp },
				{ id: 43, title: supportgpp }
			]
		},
		{
			searchTermn: [comorbidities, lettinghcp],
			standardItem: [
				{ id: 44, title: gppcomorbidities },
				{ id: 45, title: supportgpp },
				{ id: 46, title: talkingtohcp }
			]
		},
		{
			searchTermn: [impsigns, emmercare],
			standardItem: [
				{ id: 47, title: gppflare },
				{ id: 48, title: gppsymptoms },
				{ id: 49, title: gpptypes }
			]
		},
		{
			searchTermn: [treatmenthelp],
			standardItem: [
				{ id: 50, title: gppflare },
				{ id: 51, title: gppsymptoms },
				{ id: 52, title: gpptreatment }
			]
		},
		{
			searchTermn: [articlenineteen],
			standardItem: [
				{ id: 571, title: gppflare },
				{ id: 581, title: gppsymptoms },
				{ id: 591, title: gpptreatment },
				{ id: 491, title: gpptypes }
			]
		},
		{
			searchTermn: [symptomlist],
			standardItem: [
				{ id: 53, title: gppsymptoms },
				{ id: 54, title: talkingtohcp },
				{ id: 55, title: gppvisit }
			]
		},
		{
			searchTermn: qsask,
			standardItem: [{ id: 56, title: talkingtohcp }]
		},
		{
			searchTermn: [impsigns, emmercare],
			standardItem: [
				{ id: 57, title: gppflare },
				{ id: 58, title: gppsymptoms },
				{ id: 59, title: gpptreatment }
			]
		},
		{
			searchTermn: [checklist, preparingadvance],
			standardItem: [
				{ id: 57, title: gppflare },
				{ id: 58, title: gppsymptoms },
				{ id: 59, title: gpptreatment }
			]
		}
	];

	// To navigate information center landing page
	openArticlesPage() {
		window.location.assign(this.siteUrlq + landingpage);
	}

	// To navigate information center video page based on patient status value(Acute or Chronic)
	openPTVPage() {
		if (this.patientstatusval === statusacute) {
			window.location.assign(this.siteUrlq + acutepage);
		} else if (this.patientstatusval === statuschronic) {
			if (this.urlq === brandedurl) {
				window.location.assign(this.siteUrlq + chronicpage);
			} else {
				window.location.assign(this.siteUrlq + acutepage);
			}
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve patient status value
	@wire(Patientstatus)
	wiredpatientstatus({ error, data }) {
		try {
			if (data) {
				this.patientstatusval = data;

				if (this.patientstatusval === statusacute) {
					this.categorytreatmentnew = spcategorytwo;
					this.categorytreatmentnewadb = spcategoryvaltwo;
				} else if (this.patientstatusval === statuschronic) {
					this.categorytreatmentnew = spcategoryone;
					this.categorytreatmentnewadb = spcategoryvalone;
				}
				if (this.patientstatusval === statusunassigned) {
					this.showbrandednav = false;
				} else if (this.urlq === brandedurl) {
					this.categorytreatmentnew = spcategoryone;
					this.categorytreatmentnewadb = spcategoryvalone;
				} else {
					this.categorytreatmentnew = spcategorytwo;
					this.categorytreatmentnewadb = spcategoryvaltwo;
				}

				// Handle the data
			} else if (error) {
				// Handle the error
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	/* If user having null assessment record then disabled the just for me navigation */
	// To retrieve letspersonalize assessment data
	@wire(showfilterresponse)
	wiredfilterresponse({ error, data }) {
		try {
			if (data) {
				this.showjustforme_sec = false;

				let showresponsedata = data;
				if (showresponsedata.length === 1) {
					this.showjustforme_sec = true;
				} else if(data === null) {
					this.showjustforme_sec = false;
				}
			} else if (error) {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
			} else {
				this.showjustforme_sec = false;
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	/*There's no need to check for null because in Apex, we're throwing an AuraHandledException. 
	Therefore, null data won't be encountered.*/
	// To retrieve CMS article data
	@wire(retrieveMediaFromCMSNews, { channelName: '$channelName' })
	wiredData({ error, data }) {
		try {
			if (data) {
				let objStr = JSON.parse(data);

				objStr.map((element) => {
					const timestamp = new Date().getTime();
					const cbValue = `cb=${timestamp}`;

					return (this.results = [
						...this.results,
						{
							image: element.url + '?' + cbValue,
							text: element.title,
							text2: element.subtitle,
							page: element.url,
							titleadb: articlestring + ' ' + element.title,
							readtime: this.topics[element.title]
						}
					]);
				});
				if (this.results.length > 0) {

					if (this.urlq !== brandedurl || this.urlq === brandedurl) {
						if (this.patientstatusval === statusacute) {
							const filteredDatanacute = this.results.filter(
								(entry) =>
									entry.text !== articletwentyseven &&
									entry.text !== articletwentyeight
							);
							this.results = filteredDatanacute;
						}

						if (this.patientstatusval === statuschronic) {
							const filteredDatachronic = this.results.filter(
								(entry) =>
									entry.text !== articletwentysix &&
									entry.text !== articletwentyfive
							);
							this.results = filteredDatachronic;
						}
						if (this.patientstatusval === statusunassigned) {
							const filteredDataun = this.results.filter(
								(entry) =>
									entry.text !== articletwentyseven &&
									entry.text !== articletwentyeight &&
									entry.text !== articletwentysix &&
									entry.text !== articletwentyfive &&
									entry.text !== articletwentynine
							);
							this.results = filteredDataun;
						}

						if (this.patientstatusval === '') {
							const filteredData = this.results.filter(
								(entry) =>
									entry.text !== articletwentyseven &&
									entry.text !== articletwentyeight &&
									entry.text !== articletwentysix &&
									entry.text !== articletwentyfive &&
									entry.text !== articletwentynine
							);
							this.results = filteredData;
						}
					}
					this.image12 = this.results;

					this.originalsearchitems = this.results;

					this.error = undefined;
					this.image12 = this.results;

					this.image12 = this.results;

					this.pageReferenceLogic();
				} else if (error) {
					this.error = error;
					this.results = undefined;
					this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
				}
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error from Lwc
		}
	}

	// To capitalize first letter of the input string
	capitalizeFirstLetter(inputString) {
		// Check if the input is a non-empty string
		if (typeof inputString === 'string' && inputString.length > 0) {
			return inputString.charAt(0).toUpperCase() + inputString.slice(1);
		}
		// Handle empty or non-string inputs
		return inputString;
	}

	// Generate a random number between 2 and 4 (inclusive)
	get dynamicProperty() {
		const newRandomNumber = Math.floor(Math.random() * 3) + 2;
		return newRandomNumber;
	}

	// To clear the search input
	clearinput() {
		const inputElement = this.template.querySelector('.search-bar');

		inputElement.value = '';

		if (inputElement) {
			inputElement.value = '';
		}
	}

	// To clear the Search input for mobile search bar
	clearinputnew() {
		const inputElement = this.template.querySelector('.search-barnew');

		inputElement.value = '';

		if (inputElement) {
			inputElement.value = '';
		}
	}

	// To navigate  information center detail article page
	handleReloadAndNavigate(event) {
		const finaltitle = event.currentTarget.dataset.name;
		const articlename = finaltitle;
		updatereaction({
			articlename: articlename, reaction: viewlabel
		})
			.then(() => {
				this.titlear = viewlabel+ ': ' + articlename;
			})
			.catch((error) => {
				this.showToast(errormessage, error.body.message, errorvariant); // Catching Potential Error from Apex
				// Handle error, if needed
			});

		window.location.href =
			this.baseUrl + this.siteUrlq + detailpage + articlename;
	}

	// To navigate information center category page
	handleButtonnavigate() {
		window.location.href =
			this.baseUrl + this.siteUrlq + categorypage + articlecategoryone;
	}

	// To navigate information center search results page
	handleSearch(event) {
		const searchTerm = event.target.value.toLowerCase();
		this.searchre = event.target.value;

		this.searchitems = [];
		// Filter related items based on the search term

		for (const element of this.originalsearchitems) {
			const item = element;
			if (item.text.toLowerCase().includes(searchTerm)) {
				this.searchitems.push(item);
			}
		}

		let searchvalu = searchTerm;
		let searchval = this.capitalizeFirstLetter(searchvalu);
		this.standarItems = [];
		for (let i = 0; i < this.data_tags.length; i++) {
			for (let j = 0; j < this.data_tags[i].searchTermn.length; j++) {
				if (
					this.data_tags[i].searchTermn[j].toLowerCase() ===
					searchval.toLowerCase()
				) {
					for (let k = 0; k < this.data_tags[i].standardItem.length; k++) {
						this.standarItems.push(this.data_tags[i].standardItem[k]);
					}
					break;
				}
			}
		}
		this.standarItems = [...new Set(this.standarItems)];

		if (this.searchitems.length === 0) {
			this.shownoresults = true;
		} else {
			this.shownoresults = false;
		}

		this.showloadmore = true;

		this.currentlength = 5;
		this.originalsearchitemsofsearch = this.searchitems;
		this.searchitems = this.originalsearchitemsofsearch.slice(
			0,
			this.currentlength
		);

		if (this.currentlength < this.originalsearchitemsofsearch.length) {
			this.showloadmore = true;
		} else {
			this.showloadmore = false;
		}
	}

	// To load the article in search results page if more than 5 articles are present
	loadmore() {
		this.currentlength = this.currentlength + 5;
		this.searchitems = this.originalsearchitemsofsearch.slice(
			0,
			this.currentlength
		);
		if (this.currentlength < this.originalsearchitemsofsearch.length) {
			this.showloadmore = true;
		} else {
			this.showloadmore = false;
		}
	}

	// To map the cms article data to search results
	pageReferenceLogic() {
		const searchTerm = this.resulti;
		this.searchitems = [];

		if (this.originalsearchitems.length > 1) {
			for (const element of this.originalsearchitems) {
				const item = element;
				if (item.text.toLowerCase().includes(searchTerm)) {
					this.searchitems.push(item);
				}
			}

			let searchvalu = searchTerm;
			let searchval = this.capitalizeFirstLetter(searchvalu);
			this.standarItems = [];

			for (let i = 0; i < this.data_tags.length; i++) {
				for (let j = 0; j < this.data_tags[i].searchTermn.length; j++) {
					if (
						this.data_tags[i].searchTermn[j].toLowerCase() ===
						searchval.toLowerCase()
					) {
						for (let k = 0; k < this.data_tags[i].standardItem.length; k++) {
							this.standarItems.push(this.data_tags[i].standardItem[k]);
						}
						break;
					}
				}
			}
			this.standarItems = [...new Set(this.standarItems)];

			if (this.searchitems.length === 0) {
				this.shownoresults = true;
			} else {
				this.shownoresults = false;
			}

			this.showloadmore = true;

			this.currentlength = 5;
			this.originalsearchitemsofsearch = this.searchitems;
			this.searchitems = this.originalsearchitemsofsearch.slice(
				0,
				this.currentlength
			);

			if (this.currentlength < this.originalsearchitemsofsearch.length) {
				this.showloadmore = true;
			} else {
				this.showloadmore = false;
			}
		}
	}

	// Wire method to capture the current page reference and extract the state id value
	// We are unable to utilize "data" or "error" as CurrentPageReference is default API.
	@wire(CurrentPageReference)
	pageReference({ state }) {
		try {
			if (state && state.id) {
				this.resulti = state.id;
				this.searchre = this.resulti;
				this.searchitems.push({ id: 100, text: '...' });
				const searchTerm = String(state.id);

				this.searchitems = [];
				// Filter related items based on the search term
				for (const element of this.originalsearchitems) {
					const item = element;
					if (item.text.toLowerCase().includes(searchTerm)) {
						this.searchitems.push(item);
					}
				}
				let searchvalu = searchTerm;
				let searchval = this.capitalizeFirstLetter(searchvalu);
				this.standarItems = [];

				if (this.searchitems.length === 0) {
					this.searchitems.push({ id: 100, text: searchnoresults });
					this.shownoresults = true;
				} else {
					this.shownoresults = false;
				}

				for (const element of this.data_tags) {
					for (let j = 0; j < element.searchTermn.length; j++) {
						if (
							element.searchTermn[j].toLowerCase() ===
							searchval.toLowerCase()
						) {
							for (let k = 0; k < element.standardItem.length; k++) {
								this.standarItems.push(element.standardItem[k]);
							}
							break;
						}
					}
				}
				this.standarItems = [...new Set(this.standarItems)];
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant); // Catching Potential Error
		}
	}

	// To load the search method
	handleSearchButtonClick() {
		this.handleSearch();
	}

	// Method to handle key up event for search input
	handleSearchInputKeyUp(event) {
		if (event.key === evententer) {
			this.handleSearch(event);
		}
	}

	// Method to handle focus on the search bar
	handleSearchBarFocus() {
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.borderColor = '#7B4D00';
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.borderWidth = '2px';
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.transition = '0.1s';
	}

	// Method to handle blur event on the search bar
	handleSearchBarBlur() {
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.borderColor = 'rgb(105, 105, 105)';
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.borderWidth = '2px';
		this.template.querySelector(
			'hr.search-bar-border-bottom'
		).style.transition = '0.1s';
	}

	// Getter method to determine the style class based on whether no search results are shown
	get sytleofnoresult() {
		if (this.shownoresults) {
			return 'noresultcontain';
		}
		return 'empty-container';
	}

	// Method to filter results by titles
	filterResultsByTitles(titlesToFilter) {
		const filteredResults = [];

		for (const element of this.results) {
			const result = element
			let titleFound = false;

			for (const ele of titlesToFilter) {
				if (
					result.text.trim().toLowerCase() ===
					ele.trim().toLowerCase()
				) {
					titleFound = true;
					break;
				}
			}

			if (titleFound) {
				result.count = this.count % 2 !== 0;
				this.count += 1;
				filteredResults.push(result);
			}
		}
		return filteredResults;
	}

	// Method to get random elements from an array without repetition
	getRandomElementsWithoutRepetition(arr, count, selectedTopics) {
		const shuffled = arr.sort(() => 0.5 - Math.random());
		const selectedQuestions = [];

		for (const question of shuffled) {
			const topic = question.split(' ')[0]; // Extract the first word as the topic

			selectedTopics.push(topic);
			selectedQuestions.push(question);

			if (selectedQuestions.length === count) {
				break; // Stop when the required number of questions is reached
			}
		}

		//Remove Spevigo articles if it is unassigned

		if (this.urlq !== brandedurl) {
			if (selectedQuestions.indexOf(articletwentyseven) !== -1) {
				selectedQuestions.splice(
					selectedQuestions.indexOf(articletwentyseven),
					1
				);
			}
			if (selectedQuestions.indexOf(articletwentyeight) !== -1) {
				this.searchitems.splice(
					selectedQuestions.indexOf(articletwentyeight),
					1
				);
			}
			if (selectedQuestions.indexOf(articletwentysix) !== -1) {
				selectedQuestions.splice(
					selectedQuestions.indexOf(articletwentysix),
					1
				);
			}
			if (selectedQuestions.indexOf(articletwentyfive) !== -1) {
				selectedQuestions.splice(
					selectedQuestions.indexOf(articletwentyfive),
					1
				);
			}
			if (selectedQuestions.indexOf(articletwentynine) !== -1) {
				selectedQuestions.splice(
					selectedQuestions.indexOf(articletwentynine),
					1
				);
			}
		}

		return selectedQuestions;
	}

	// Method to handle rendering adjustments
	renderedCallback() {
		try {
			// Get the flexi element by its ID
			let flexiEle = this.template.querySelector('.flexiirow');
			// Check the condition

			const windowWidth = window.innerWidth;
			const displayvideotab = this.template.querySelector(
				'.grid-containerNavTab'
			);

			if (windowWidth <= 1000) {
				if (displayvideotab) {
					displayvideotab.style.display = 'none';
				}
			} else if (displayvideotab) {
					displayvideotab.style.display = '';
				}

			if (this.searchitems.length <= 3) {
				// Update the height if the condition is met
				flexiEle.style.height = '900px';
				this.heightofcal = 900;
			} else {
				// Set a default height if the condition is not met
				let spacecalculation = this.searchitems.length * 219.6 + 150;
				if (this.showloadmore === true) {
					spacecalculation = spacecalculation + 30;
				}

				flexiEle.style.height = spacecalculation + 'px';
				this.heightofcal = spacecalculation;
			}

			if (this.showloadmore === false && this.searchitems.length > 3) {
				flexiEle = this.template.querySelector('.flexiirow');

				let spacecalculationnew = this.searchitems.length * 216.6 + 130;

				flexiEle.style.height = spacecalculationnew + 'px';
				this.heightofcal = spacecalculationnew;
			}
			if (this.shownoresults === true) {
				flexiEle = this.template.querySelector('.flexiirow');

				flexiEle.style.height = '930px';
				this.heightofcal = 930;
			}

			if (window.innerWidth <= 1000) {
				if (this.searchitems.length <= 0) {
					flexiEle.style.height = 600 + 'px';
					this.heightofcal = 600;
				} else if (this.searchitems.length === 1) {
					flexiEle.style.height = 800 + 'px';
					this.heightofcal = 800;
				} else if (this.searchitems.length === 2) {
					flexiEle.style.height = 1000 + 'px';
					this.heightofcal = 1000;
				} else if (this.searchitems.length === 3) {
					flexiEle.style.height = 1339 + 'px';
					this.heightofcal = 1339;
				} else if (this.searchitems.length <= 5) {
					flexiEle.style.height = this.searchitems.length * 416 + 'px';
					this.heightofcal = this.searchitems.length * 416;
				} else if (this.searchitems.length <= 10) {
					flexiEle.style.height = this.searchitems.length * 362 + 'px';
					this.heightofcal = this.searchitems.length * 362;
				} else if (this.searchitems.length <= 15) {
					flexiEle.style.height = this.searchitems.length * 352 + 'px';
					this.heightofcal = this.searchitems.length * 352;
				} else if (this.searchitems.length <= 20) {
					flexiEle.style.height = this.searchitems.length * 362 - 300 + 'px';
					this.heightofcal = this.searchitems.length * 362 - 300;
				} else {
					flexiEle.style.height = this.searchitems.length * 362 - 430 + 'px';
					this.heightofcal = this.searchitems.length * 362 - 430;
				}
			}

			if (this.touch === true) {
				flexiEle.style.height = this.heightofcal + 450 + 'px';
			} else if (this.touch === false) {
				flexiEle.style.height = this.heightofcal + 'px';
			}
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}

	// Method to handle button click to navigate detail article page
	handleButtonClicknew(event) {
		const finaltitle = event.currentTarget.dataset.name;
		const articlename = finaltitle;

		window.location.href = this.baseUrl + this.siteUrlq + articlename;
	}

	// Method to set touch state to true
	click() {
		this.touch = true;
		this.down = false;
		this.up = true;
	}

	// Method to set touch state to false
	notclick() {
		this.touch = false;
		this.down = true;
		this.up = false;
	}

	// To get the site name from the Current site url
	connectedCallback() {
		try {
			const currentURL = window.location.href;

			// Create a URL object
			const urlObject = new URL(currentURL);

			// Get the path
			const path = urlObject.pathname;

			// Split the path using '/' as a separator
			const pathComponents = path.split('/');

			// Find the component you need (in this case, 'Branded')
			const desiredComponent = pathComponents.find((component) =>
				[brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
					component.toLowerCase()
				)
			);

			if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
				this.urlq = brandedurl;
				this.siteUrlq = brandedsiteurl;
			} else {
				this.urlq = unassignedurl;
				this.siteUrlq = unassignedsiteurl;
			}
			this.currentPageUrl = window.location.href;
			this.urlSegments = this.currentPageUrl.split('/');
			this.baseUrl = `${this.urlSegments[0]}//${this.urlSegments[2]}`;
			this.showbrandednav = true;
		} catch (error) {
			this.showToast(errormessage, error.message, errorvariant); // Catching Potential Error
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