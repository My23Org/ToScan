//This component get the patients status and show the case created date ,type ,status,and discriptions
// To import libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// To import user Id
import Id from '@salesforce/user/Id';
//To Import apex clases 
import getCaseFiles from '@salesforce/apex/BI_PSPB_InsertCaserecordforUpdateRx.getCasesForPatient';
import accid from '@salesforce/apex/BI_PSPB_FeedItemCtrl.getUserAccountId';
// To Import Custom Labels
import Submitted from '@salesforce/label/c.BI_PSPB_Submitted';
import Prescriptionunderverification from '@salesforce/label/c.BI_PSPB_Prescription_under_verification';
import PrescriptionVerified from '@salesforce/label/c.BI_PSPB_Prescription_Verified';
import InvalidPrescription from '@salesforce/label/c.BI_PSPB_Invalid_Prescription';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import BI_PSPB_Error_For_Account from '@salesforce/label/c.BI_PSPB_Error_For_Account';

// Define the LWC component
export default class BiPspbPrescriptionstatus extends LightningElement {
	@track userid = Id; // Track the current user's ID
	@track cases; // Track cases
	@track accname; // Track the account name
	@track nopresription=false;
	@track withPrescription=true;
	@track Mobileprescrition=true;
	Statusoptions = [ // Define options for status
		{ label: Submitted, value: Submitted },
		{ label: Prescriptionunderverification, value: Prescriptionunderverification },
		{ label: PrescriptionVerified, value: PrescriptionVerified },
		{ label: InvalidPrescription, value: InvalidPrescription },
	];

	// Fetch account ID
	@wire(accid, { userId: '$userid' })
	wiredAccId({ data, err }) {

		if (data && data.length > 0) {
			try {
				this.accname = data; // Set the account name

				this.getall(this.accname); // Call the function to fetch cases
			}
			catch (error) {
				// Handle any errors that occur within the try block
				this.showToast(errormessage, error.message, errorvariant);
			}
		} else if (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
		else{
				this.showToast(errormessage, BI_PSPB_Error_For_Account, errorvariant); // Catch Exception
			}
	}


	// Function to fetch all cases
	getall(acc) {
		try {
			getCaseFiles({ patientId: acc, caseStatus: '' }) // Call Apex method to get cases
				.then(result => {
					if(result && result.length ===0){
						this.nopresription = true;
						this.withPrescription=false;
						this.Mobileprescrition=false;					

					}


					this.cases = result.map(caseRecord => { // Map each case record
						let status = '';

						// Switch case to determine status
						switch (caseRecord.Status) {
							case Submitted:
								status = 'Submitted';
								break;
							case Prescriptionunderverification:
								status = 'Prescription';
								break;
							case PrescriptionVerified:
								status = 'Verified';
								break;
							case InvalidPrescription:
								status = 'Invalid';
								break;
							default:
								status = 'Unknown';
						}

						return {
							...caseRecord, // Spread existing case record properties
							FormattedDate: this.formatDate(caseRecord.CreatedDate), // Format created date
							status: status // Set the status property
						};
					});
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant);
				});
		}
		catch (err) {
			// Handle any errors that occur within the try block
			this.showToast(errormessage, err.message, errorvariant);
		}
	}


	// Format date function
	formatDate(createdDate) {
		const dateObject = new Date(createdDate); // Create date object from created date
		const formattedDate = dateObject.toLocaleDateString(); // Format date to locale string
		return formattedDate; // Return formatted date
	}

	// Handle status change
	handleChange(event) {
		const selectedValue = event.target.value; // Get selected value
		this.actionfunc(selectedValue); // Call function to handle action based on selected value

	}

	// Fetch cases based on selected status
	actionfunc(selectedValue) {
		try {
			getCaseFiles({ patientId: this.accname, caseStatus: selectedValue }) // Call Apex method to get cases based on selected status
				.then(result => {


					this.cases = result.map(caseRecord => { // Map each case record
						let status = '';
						switch (caseRecord.Status) {
							case Submitted:
								status = 'Submitted';
								break;
							case Prescriptionunderverification:
								status = 'Prescription';
								break;
							case PrescriptionVerified:
								status = 'Verified';
								break;
							case InvalidPrescription:
								status = 'Invalid';
								break;
							default:
								status = 'Unknown';
						}
						return {
							...caseRecord, // Spread existing case record properties
							FormattedDate: this.formatDate(caseRecord.CreatedDate), // Format created date
							status: status // Adding the 'status' property to each caseRecord
						};
					});
				})
				.catch(error => {
					this.showToast(errormessage, error.message, errorvariant); // Log error if fetching cases fails
				});
		}
		catch (err) {
			// Handle any errors that occur within the try block
			this.showToast(errormessage, err.message, errorvariant);
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