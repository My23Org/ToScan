//This is a consolidated component that creates a dashboard layout featuring user notifications, update prescription, challenges, and articles. It utilizes Lightning Layout for responsive design, organizing components into rows and columns
//To import Libraries
import { LightningElement } from 'lwc';
//To import current user ID
import Id from '@salesforce/user/Id';

export default class BiPspbDashboardCmp extends LightningElement 
{
    userid = Id;
}