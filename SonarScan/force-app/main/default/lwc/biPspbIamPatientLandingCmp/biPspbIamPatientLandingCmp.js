import { LightningElement } from 'lwc';
// Imports resourceUrl to reference external resources for proper rendering and functionality.
import PatientBanner from '@salesforce/resourceUrl/BI_PSP_PatientBannerImage';
import patientbanner from '@salesforce/resourceUrl/BI_PSPB_Patientbannerimage';
import PatientIconCalender from '@salesforce/resourceUrl/BI_PSP_PatientIconCalender';
import PatientIconCenter from '@salesforce/resourceUrl/BI_PSP_PatientIconCenter';
import PatientIconSecurity from '@salesforce/resourceUrl/BI_PSP_PatientIconSecurity';
import PatientFeatureBanner from '@salesforce/resourceUrl/BI_PSP_PatientFeatureBanner';
import PatientIconEarn from '@salesforce/resourceUrl/BI_PSP_PatientIconEarn';
import PatientIconHub from '@salesforce/resourceUrl/BI_PSP_PatientIconHub';
import PatientIconUnique from '@salesforce/resourceUrl/BI_PSP_PatientIconUnique';
import PatientIconVisual from '@salesforce/resourceUrl/BI_PSP_PatientIconVisual';
import BGpp from '@salesforce/resourceUrl/BI_PSPB_BeyondGppLogo';
import mobile from '@salesforce/resourceUrl/BI_PSPB_mobilelandingpage';
//To import Custom lable
import brSiteUrl from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import patientEnrollement from '@salesforce/label/c.BI_PSPB_PatientEnrollment';
export default class BiPspbIamPatientLandingCmp extends LightningElement {
	Brandedsiteurl = brSiteUrl;
	patientEnrollemetUrl = patientEnrollement;
	BGpp = BGpp;
	mobilepic = mobile;
	patientbanner = patientbanner;
	iamPatientBanner = PatientBanner;
	PatientIconCalender = PatientIconCalender;
	PatientIconCenter = PatientIconCenter;
	PatientIconSecurity = PatientIconSecurity;
	PatientFeatureBanner = PatientFeatureBanner;
	PatientIconEarn = PatientIconEarn;
	PatientIconHub = PatientIconHub;
	PatientIconUnique = PatientIconUnique;
	PatientIconVisual = PatientIconVisual;
	get displayBackgroundImage() {
		return `background-image: url('${this.iamPatientBanner}');background-size: cover; background-repeat: no-repeat;`;
	}
	openPAENpage() {
		window.location.assign(this.Brandedsiteurl + this.patientEnrollemetUrl);
	}
}