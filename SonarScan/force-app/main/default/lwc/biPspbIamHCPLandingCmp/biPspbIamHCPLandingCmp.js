import { LightningElement } from 'lwc';
// Imports resourceUrl to reference external resources for proper rendering and functionality.
import HCPBannerImage from '@salesforce/resourceUrl/BI_PSP_HCPBannerImage';
import hcpBannerImage from '@salesforce/resourceUrl/BI_PSPB_hcpbannerimage';
import PatientIconCalender from '@salesforce/resourceUrl/BI_PSP_PatientIconCalender';
import PatientIconCenter from '@salesforce/resourceUrl/BI_PSP_PatientIconCenter';
import PatientIconSecurity from '@salesforce/resourceUrl/BI_PSP_PatientIconSecurity';
import HCPFeatureBanner from '@salesforce/resourceUrl/BI_PSP_HCPFeatureBanner';
import PatientIconEarn from '@salesforce/resourceUrl/BI_PSP_PatientIconEarn';
import PatientIconHub from '@salesforce/resourceUrl/BI_PSP_PatientIconHub';
import PatientIconUnique from '@salesforce/resourceUrl/BI_PSP_PatientIconUnique';
import PatientIconVisual from '@salesforce/resourceUrl/BI_PSP_PatientIconVisual';
import IamHCPIconChat from '@salesforce/resourceUrl/BI_PSP_IamHCPIconChat';
import IamHCPIconYoutube from '@salesforce/resourceUrl/BI_PSP_IamHCPIconYoutube';
import IamHCPIconBooks from '@salesforce/resourceUrl/BI_PSP_IamHCPIconBooks';
import patientenrolmentfrom from '@salesforce/resourceUrl/BI_PSPB_Patientenrolmentfrom';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
// Imports NavigationMixin for seamless component navigation between views/pages.
import { NavigationMixin } from 'lightning/navigation';
//To import Custom lable
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import hcpEnrollement from '@salesforce/label/c.BI_PSPB_HCPEnrollment';
export default class BiPspbIamHCPLandingCmp extends NavigationMixin(LightningElement)
{
	BGpp = BGpp;
	hcpBannerImage = hcpBannerImage;
	HCPBannerImage = HCPBannerImage;
	PatientIconCalender = PatientIconCalender;
	PatientIconCenter = PatientIconCenter;
	PatientIconSecurity = PatientIconSecurity;
	HCPFeatureBanner = HCPFeatureBanner;
	PatientIconEarn = PatientIconEarn;
	PatientIconHub = PatientIconHub;
	PatientIconUnique = PatientIconUnique;
	PatientIconVisual = PatientIconVisual;
	IamHCPIconChat = IamHCPIconChat;
	IamHCPIconYoutube = IamHCPIconYoutube;
	IamHCPIconBooks = IamHCPIconBooks;
	patientenrolmentfrom = patientenrolmentfrom;
	Brandedsiteurl = brSiteUrl;
	hcpEnrollemetUrl = hcpEnrollement;
	handledownload() {
		const resourcepath = patientenrolmentfrom;
		window.open(resourcepath);
		return null;
	}

	get displayBackgroundImage() {
		return `background-image: url('${this.HCPBannerImage}');background-size: cover; background-repeat: no-repeat;`;
	}

	openHCPpage() {
		window.location.assign(this.Brandedsiteurl + this.hcpEnrollemetUrl);
	}
}