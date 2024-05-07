// To import libraries
import { LightningElement, track, wire, } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadStyle } from "lightning/platformResourceLoader";
// To import user Id
import Id from "@salesforce/user/Id";
//To Import apex clases
import getCaseRecord from "@salesforce/apex/BI_PSPB_InsertCaserecordforUpdateRx.getcaseRecordWithFiles";
import accid from "@salesforce/apex/BI_PSPB_FeedItemCtrl.getUserAccountId";
// To Import Static Resources
import MY_ICON from "@salesforce/resourceUrl/BI_PSPB_uploadIocn";
import MY_ICON1 from "@salesforce/resourceUrl/BI_PSPB_RedUploadIcon";
import tic from "@salesforce/resourceUrl/BI_PSP_Deletetoastmsg";
import uploadfilecss from "@salesforce/resourceUrl/BI_PSPB_UploadfileSupport";
// To Import Custom Labels
import pharmacylabel from "@salesforce/label/c.BI_PSPB_ERROR_Message_For_Prescription";
import Uploadlabel from "@salesforce/label/c.BI_PSPB_Update_Latest_Prescription_Error";
import errormessage from "@salesforce/label/c.BI_PSP_ConsoleError";
import errorvariant from "@salesforce/label/c.BI_PSPB_errorVariant";
import No from "@salesforce/label/c.BI_PSPB_No";
import Yes from "@salesforce/label/c.BI_PSPB_Yes";
import BI_PSPB_Error_For_Account from '@salesforce/label/c.BI_PSPB_Error_For_Account';
import ErrorForLatestPrescription from "@salesforce/label/c.BI_PSPB_Update_Latest_Prescription_Error";

export default class BiPspbCaseSupport extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	@track showDiv = false;
	@track userid = Id;
	@track accname;
	@track PrescriptionerrorMessage = false;
	@track uploaderrorMessage = false;
	@track radiovalue9 = true;
	@track img1 = true;
	@track img2 = false;
	@track radiovalue3 = false;
	@track fileuploadstar = false;
	@track inputbox = "";
	@track fileupload = "file";
	@track imgpad = "imagepad2";
	@track pharmacyvalue = "";
	@track commentsvalue = "";
	@track selectedValue;
	@track BI_PSPB_prescription_sent_to;
	@track BI_PSPB_physical_copy__c = false;
	@track BI_PSPB_e_prescription__c = false;
	@track Message = false;
	@track radiovalue = "";
	@track getAttachFile = "";
	@track starname = "";
	@track uploadfile = "uploadfile";
	@track radiovalue1 = false;
	@track radiovalue2 = false;
	@track files = [];
	@track radiovaluesecond = "";
	@track fileName = "";
	@track handleUploadFinished = true;
	@track fileNames = [];
	@track BandU = true;
	label = {
		pharmacylabel,
		Uploadlabel
	};
	fileIds = [];
	rightimg = tic;
	uploadedAttachments = [];
	uploadedNotes = [];
	myIconUrl = MY_ICON;
	myIconUrl1 = MY_ICON1;
	value = "";
	options1 = [
		{ label: Yes, value: Yes },
		{ label: No, value: No }
	];
	options2 = [
		{ label: Yes, value: Yes },
		{ label: No, value: No }
	];

	//get the user id

	@wire(accid, { userId: "$userid" })
	wiredAccId({ data, error }) {
		try {
			if (data && data.length > 0) {
				this.accname = data; // Set the account name
			} else if(error){
				this.showToast(errormessage, error.message, errorvariant);
			}
			else{
				this.showToast(errormessage, BI_PSPB_Error_For_Account, errorvariant); // Catch Exception
			}
		} catch (err) {
			// Handle any errors that occur within the try block
			this.showToast(errormessage, err.message, errorvariant);
		}
	}

	// call the upload file width css
	connectedCallback() {
		try {
			loadStyle(this, uploadfilecss);
		} catch (err) {
			this.showToast(errormessage, err.message, errorvariant);
		}
	}

	handleConditionalfield4(event) {
		this.commentsvalue = event.target.value;
	}
	handleConditionalfield3(event) {
		this.pharmacyvalue = event.target.value;
			const prescription = this.template.querySelector(
			'lightning-input[data-field="prescription"]'
		);
		if(this.pharmacyvalue !=''){
			this.PrescriptionerrorMessage = false;
			prescription.className = "textInput";
			this.template.querySelector(
				'label[data-field="prescription"]'
			).className = "input-label";



		}
	}

	//if the priscription value is "yes" Additional Comments,files will show
	handleConditionalfield1(event) {
		this.radiovalue = event.target.value;
		if (this.radiovalue === Yes) {
			this.handleUploadFinished = true;
			this.radiovalue1 = false;
			this.radiovalue2 = false;
			this.Message = false;
			this.radiovalue9 = true;
			this.fileuploadstar = true;
			this.starname = "starclass";
			this.radiovalue3 = false;
			this.radiovaluesecond = "";
		}
		//if the priscription value is "No" epriscription and will show
		else {
			this.radiovalue1 = true;
			this.handleUploadFinished = true;
			this.radiovalue9 = this.radiovalue1 && this.radiovalue === No;
			this.radiovalue3 = this.radiovalue1 && this.radiovalue === Yes;
			this.fileuploadstar = false;
			this.starname = "";
			this.starname = "starclass";
			this.uploadfile = "uploadfile";
			this.fileupload = "file";
			this.imgpad = "imagepad2";
			this.img2 = false;
			this.img1 = true;
			this.errorMessage = false;
			
			
		}
	}
	// if the e-priscription value is "yes" pysical copy,Additional Comments,file upload fields will show
	handleConditionalfield2(event) {
		this.radiovaluesecond = event.target.value;
		const rdio = event.target.value;

		if (rdio === Yes) {
			this.radiovalue3 = true;
			this.Message = false;
			this.handleUploadFinished = false;
			this.radiovalue9 = true;
		} else {
			this.handleUploadFinished = false;
			this.radiovalue3 = false;
			this.Message = true;
			this.radiovalue9 = false;
		}
		if (this.radiovaluesecond === Yes) {
			this.handleUploadFinished = true;
		}
	}

	// clear file fuction

	clearFile() {
		const fileInput = this.template.querySelector('input[type="file"]');
		fileInput.value = "";
		this.fileName = "";
	}

	// if the  priscription input box is empty this error message will work
	errorvalidate() {
		let isValid = true;
		const prescription = this.template.querySelector(
			'lightning-input[data-field="prescription"]'
		);

		if (!prescription.value) {
			this.PrescriptionerrorMessage = true;
			isValid = false;
			prescription.className = "textInput-err";
			this.template.querySelector(
				'label[data-field="prescription"]'
			).className = "input-error-label";
		} else {
			this.PrescriptionerrorMessage = false;
			prescription.className = "textInput";
			isValid = true;
			this.template.querySelector(
				'label[data-field="prescription"]'
			).className = "input-label";
		}
		return isValid;
	}

	//  file  onupload fuctions
	handleUploadFinisheds(event) {
		this.files = event.detail.files;
		this.fileNames = this.files.map((file) => {
			const maxLength = window.innerWidth > 768 ? 35 : 20; // Maximum length of displayed filename
			return file.name.length > maxLength
				? file.name.substring(0, maxLength) + "..."
				: file.name;
		});

		this.fileIds = this.files.map((file) => file.documentId);
		//if user select the file this functions will work
		if (this.files !== "") {
			this.starname = "starclass";
			this.uploadfile = "uploadfile";
			this.fileupload = "file";
			this.imgpad = "imagepad2";
			this.img2 = false;
			this.img1 = true;
			this.errorMessage = false;
		}

		if (this.fileNames !== "") {
			this.BandU = false;
		}
	}

	//user submit the record  all select value will saveed in the database

	handleSubmit() {
		let caseupdate = {
			eprescription: this.radiovaluesecond,
			physicalCopy: this.radiovalue,
			prescriptionSentTo: this.pharmacyvalue,
			additionalComments: this.commentsvalue
		};
		// Validate the form only when radiovalue is 'no' and radiovaluesecond is 'yes'
		const isValid =
			this.radiovalue === No && this.radiovaluesecond === Yes
				? this.errorvalidate()
				: true;

		if (!isValid) {
			return;
		}

		// if radiovalue and file is not selected this if class function are worked.
		if (this.files == "" && this.radiovalue === Yes) {
			this.starname = "starclass2";
			this.uploadfile = "uploadfile2";
			this.fileupload = "file1";
			this.img2 = true;
			this.img1 = false;
			this.uploadfileerrorMessage = true;
			this.errorMessage = ErrorForLatestPrescription;
		}
		// if radio value and all values is given the record was summited in this elesif function
		else if (
			this.radiovalue === null ||
			(this.radiovalue === Yes && this.files !== "") ||
			this.radiovalue === No
		) {
			getCaseRecord({
				patientId: this.accname,
				Wrapper: caseupdate,
				fileIds: this.fileIds
			})
			// set timeout used for disable the popup message
				.then((result) => {
					this.showDiv = true;
					try {
						setTimeout(() => {
							this.showDiv = false;
						}, 3000);
					} catch (err) { 
						this.showToast(errormessage, err.message, errorvariant);
					}

					window.scrollTo({ top: 0, behavior: "smooth" });
				})
				.catch((error) => {
					this.showToast(errormessage, error.message, errorvariant);
				});
		}
	}

	// if the user click the cancel button all select value will removed

	reset() {
		this.radiovalue = "";
		this.radiovaluesecond = "";
		this.pharmacyvalue = "";
		this.commentsvalue = "";
		this.handleUploadFinisheds = "";
		this.starname = "starclass";
		this.uploadfile = "uploadfile";
		this.fileupload = "file";
		this.imgpad = "imagepad2";
		this.img2 = false;
		this.img1 = true;
		this.errorMessage = false;
		this.files = "";
		this.fileNames = "";
		this.BandU = true;
		this.PrescriptionerrorMessage = false;
		this.prescription1 = false;
	}
	// popup message close event

	handleclose() {
		this.showDiv = false;
	}
	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(event);
	}
}