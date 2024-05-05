//This lighting web component is used to view information about Boehringer Ingelheim through social media channels
// To import Libraries
import { LightningElement } from 'lwc';
// To import Custom Labels
import BI_PSPB_BRimprint from '@salesforce/label/c.BI_PSPB_BRimprint';
import BI_PSPB_BRdata from '@salesforce/label/c.BI_PSPB_BRdata';
import BI_PSPB_BRregistration from '@salesforce/label/c.BI_PSPB_BRregistration';
import BI_PSPB_BRlog from '@salesforce/label/c.BI_PSPB_BRlog';
import BI_PSPB_BRcookies from '@salesforce/label/c.BI_PSPB_BRcookies';
import BI_PSPB_BRofferings from '@salesforce/label/c.BI_PSPB_BRofferings';
import BI_PSPB_BRlistening from '@salesforce/label/c.BI_PSPB_BRlistening';
import BI_PSPB_BRpharmacovigilance from '@salesforce/label/c.BI_PSPB_BRpharmacovigilance';
import BI_PSPB_BRfurther from '@salesforce/label/c.BI_PSPB_BRfurther';
import BI_PSPB_BRprocessor from '@salesforce/label/c.BI_PSPB_BRprocessor';
import BI_PSPB_BRcompanies from '@salesforce/label/c.BI_PSPB_BRcompanies';
import BI_PSPB_BRtransfer from '@salesforce/label/c.BI_PSPB_BRtransfer';
import BI_PSPB_BRpharmaceutical from '@salesforce/label/c.BI_PSPB_BRpharmaceutical';
import BI_PSPB_BRcontent from '@salesforce/label/c.BI_PSPB_BRcontent';
import BI_PSPB_BRrecipients from '@salesforce/label/c.BI_PSPB_BRrecipients';
import BI_PSPB_BRretention from '@salesforce/label/c.BI_PSPB_BRretention';
import BI_PSPB_BRrights from '@salesforce/label/c.BI_PSPB_BRrights';
import BI_PSPB_BRquestions from '@salesforce/label/c.BI_PSPB_BRquestions';
import BI_PSPB_BRchangesprivacy from '@salesforce/label/c.BI_PSPB_BRchangesprivacy';
import BI_PSPB_BRfacebook from '@salesforce/label/c.BI_PSPB_BRfacebook';
import BI_PSPB_BRlegal from '@salesforce/label/c.BI_PSPB_BRlegal';
import BI_PSPB_BRtwitter from '@salesforce/label/c.BI_PSPB_BRtwitter';
import BI_PSPB_BRlinkedin from '@salesforce/label/c.BI_PSPB_BRlinkedin';
import BI_PSPB_BRcontroller from '@salesforce/label/c.BI_PSPB_BRcontroller';
import BI_PSPB_BRaddendum from '@salesforce/label/c.BI_PSPB_BRaddendum';

export default class BiPspbPrivacyNotice extends LightningElement {
	// Declaration of Global variables
	imprint = BI_PSPB_BRimprint;
	data = BI_PSPB_BRdata;
	registration = BI_PSPB_BRregistration;
	log = BI_PSPB_BRlog;
	cookies = BI_PSPB_BRcookies;
	offerings = BI_PSPB_BRofferings;
	listening = BI_PSPB_BRlistening;
	pharmacovigilance = BI_PSPB_BRpharmacovigilance;
	further = BI_PSPB_BRfurther;
	processor = BI_PSPB_BRprocessor;
	companies = BI_PSPB_BRcompanies;
	transfer = BI_PSPB_BRtransfer;
	pharmaceutical = BI_PSPB_BRpharmaceutical;
	content = BI_PSPB_BRcontent;
	recipients = BI_PSPB_BRrecipients;
	retention = BI_PSPB_BRretention;
	rights = BI_PSPB_BRrights;
	questions = BI_PSPB_BRquestions;
	changesprivacy = BI_PSPB_BRchangesprivacy;
	facebook = BI_PSPB_BRfacebook;
	legal = BI_PSPB_BRlegal;
	twitter = BI_PSPB_BRtwitter;
	linkedin = BI_PSPB_BRlinkedin;
	controller = BI_PSPB_BRcontroller;
	addendum = BI_PSPB_BRaddendum;
}