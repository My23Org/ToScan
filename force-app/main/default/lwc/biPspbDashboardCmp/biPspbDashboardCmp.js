/* The provided Lightning web component creates a dashboard layout featuring user notifications, reminders, challenges, and articles. It utilizes Lightning Layout for responsive design, organizing components into rows and columns */
import { LightningElement } from "lwc";
import Id from "@salesforce/user/Id";
export default class BiPspbDashboardCmp extends LightningElement 
{
userid = Id;
}