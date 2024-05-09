//This LWC creates a reminder notification interface.
//It features an icon and text to prompt users to choose their preferred reminder method and includes a link to the notification settings page for configuring preferences.
//To import library
import { LightningElement, track } from "lwc";
// To import static resource
import Boxedicon from "@salesforce/resourceUrl/BI_PSPB_yellowBox";
export default class BiPspbReminderNotificationSett extends LightningElement {
  //@track variable declaration
  @track Boxedicon = Boxedicon;
}