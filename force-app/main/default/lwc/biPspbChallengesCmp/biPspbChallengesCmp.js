// This Lightning Web Component is a template with tab navigation for Challenges and Trophy Case, along with sections for Avatar Navigation and Challenge Component.
//To import Libraries
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To get Current UserId
import Id from '@salesforce/user/Id';
//To import custom labels
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import urlSlash from '@salesforce/label/c.BI_PSP_ChatterSlash';
import siteSlash from '@salesforce/label/c.BI_PSP_Slashsite';
import brChallengesSiteUrl from '@salesforce/label/c.BI_PSP_challengesURL';
import brtrophyCaseSiteUrl from '@salesforce/label/c.BI_PSP_trophyCaseURL';

export default class BiPspbChallengesCmp extends LightningElement {
  //Proper naming conventions with camel case for all the variable will be followed in the future releases
  @track currentXPvalue;
  userid = Id;
  urlq;
  slashUrl = urlSlash;
  slashSite = siteSlash;
  siteChallengesUrlBranded = brChallengesSiteUrl;
  siteTrophyCaseUrlBranded = brtrophyCaseSiteUrl;

  // To identify the site url
  connectedCallback() {
    try {
      const currentURL = window.location.href;
      const urlObject = new URL(currentURL); // Create a URL object // Get the path
      const path = urlObject.pathname; // Get the path
      const pathComponents = path.split('/'); // Split the path using '/' as a separator
      const desiredComponent = pathComponents.find((component) =>
        [brandedurl.toLowerCase(), unassignedurl.toLowerCase()].includes(
          component.toLowerCase()
        )
      ); // Find the component you need (in this case, 'Branded')

      if (desiredComponent.toLowerCase() === brandedurl.toLowerCase()) {
        this.urlq = brandedurl;
      } else {
        this.urlq = unassignedurl;
      }
    } catch (error) {
      this.showToast(errormessage, error.message, errorvariant);
    }
  }

  // This is used for send the Xp value to child Avatar Component
  sendxpvalue(event) {
    this.currentXPvalue = event.detail;
  }

  // This is used for navigate to specific url to the Challenges Page
  openChallenges() {
    window.location.assign(
      this.slashUrl + this.urlq + this.slashSite + this.siteChallengesUrlBranded
    );
  }

  // This is used for navigate to specific url to the Trophy Page
  openTrophyCase() {
    window.location.assign(
      this.slashUrl + this.urlq + this.slashSite + this.siteTrophyCaseUrlBranded
    );
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