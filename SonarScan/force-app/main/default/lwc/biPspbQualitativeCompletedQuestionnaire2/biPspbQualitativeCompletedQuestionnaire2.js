//This is Qualitative satisfaction questionnaire completed Questionnaire(LWC). This allows you to see your submited Responses.
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getAssessmentQuestions from '@salesforce/apex/BI_PSP_Assessment.getQualitativeAssesmentQues';
import getAssessm from '@salesforce/apex/BI_PSP_CompletedQuestionareS.getQSQcompletedQuestionares1';
import getexpdate from '@salesforce/apex/BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnaire1';
import getqsq1expired from '@salesforce/apex/BI_PSP_CompletedQuestionareS.getQSQExpiredQuestionnairesec';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getAssessmentCountsByCurrentUserName';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
//To import Static Resource
import pss from '@salesforce/resourceUrl/BI_PSP_PSSimage';
import letpersonalize from '@salesforce/resourceUrl/BI_PSP_letspersonalizeimage';
import testimg from '@salesforce/resourceUrl/BI_PSP_DLQIimage';
import workandactivity from '@salesforce/resourceUrl/BI_PSP_WPAIimage';
import qualitative from '@salesforce/resourceUrl/BI_PSP_Qualitativeimage';
import BI_PSP_qsqtext from '@salesforce/label/c.BI_PSP_qsqtext';
//To import Custom labels
import BI_PSP_informationcentre from '@salesforce/label/c.BI_PSP_informationcentre';
import BI_PSP_symptomtracker from '@salesforce/label/c.BI_PSP_symptomtracker';
import BI_PSP_challenges from '@salesforce/label/c.BI_PSP_challenges';
import BI_PSP_Questionnaire from '@salesforce/label/c.BI_PSP_Questionnaire';
import BI_PSP_treatmentvideos from '@salesforce/label/c.BI_PSP_treatmentvideos';
import BI_PSP_support from '@salesforce/label/c.BI_PSP_support';
import BI_PSP_introductionCategory from '@salesforce/label/c.BI_PSP_introductionCategory';
import BI_PSP_PssCategory from '@salesforce/label/c.BI_PSP_PssCategory';
import BI_PSP_WapiCategory from '@salesforce/label/c.BI_PSP_WapiCategory';
import BI_PSP_DlqiCategory from '@salesforce/label/c.BI_PSP_DlqiCategory';
import BI_PSP_QualitativeCategory from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import BI_PSP_Wapi from '@salesforce/label/c.BI_PSP_WAPI';
import BI_PSP_completedquestionnaire from '@salesforce/label/c.BI_PSP_completedquestionnaire';
import BI_PSP_roll_out from '@salesforce/label/c.BI_PSP_roll_out';
import BI_PSP_expiredon from '@salesforce/label/c.BI_PSP_expiredon';
import BI_PSP_selectmonth from '@salesforce/label/c.BI_PSP_selectmonth';
import BI_PSP_noassessmentsfound from '@salesforce/label/c.BI_PSP_noassessmentsfound';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import completed from '@salesforce/label/c.BI_PSP_CompletedOn';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import wapiCompletedQuestionnaire from '@salesforce/label/c.BI_PSPB_BRWapiCompletedQuestionnaire';
import pssCompletedQuestionnaire from '@salesforce/label/c.BI_PSPB_BRPsoriasisCompletedQuesUrl';
import qualitativeCompletedFourteenMonths from '@salesforce/label/c.BI_PSPB_BRQualitativefourteenweeksCompletedUrl';
import dlqiCompletedUrl from '@salesforce/label/c.BI_PSPB_BRDlqiCompletedUrl';
import yesLabel from '@salesforce/label/c.BI_PSP_yes';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
//To get UserId
import Id from '@salesforce/user/Id';
export default class BiPspbQualitativeCompletedQuestionnaire2 extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track firstQuestionText;
	@track firstQuestionVersinId;
	@track secondQuestionText;
	@track secondQuestionVersinId;
	@track thirdQuestionText;
	@track thirdQuestionVersinId;
	@track fourthQuestionText;
	@track fourthQuestionVersinId;
	@track fifthQuestionText;
	@track fifthQuestionVersinId;
	@track sixthQuestionText;
	@track sixthQuestionVersinId;
	@track seventhQuestionText;
	@track seventhQuestionVersinId;
	@track eightQuestionText;
	@track eightQuestionVersinId;
	@track sliderValue = 0;
	@track sliderValuesec = 0;
	@track sliderValuethree = 0;
	//Global variables(without @track does not trigger automatic re-renders)
	informationcentre = BI_PSP_informationcentre;
	symptomtracker = BI_PSP_symptomtracker;
	challenges = BI_PSP_challenges;
	questionnaire = BI_PSP_Questionnaire;
	treatmentvideos = BI_PSP_treatmentvideos;
	support = BI_PSP_support;
	userid = Id;
	records = [];
	questionData = [];
	stpss = 0;
	stwai = 0;
	stqsq = 0;
	stdlq = 0;
	urlq;
	completedon = completed;
	cardimage = letpersonalize;
	cardimage1 = testimg;
	cardimage2 = pss;
	cardimage3 = workandactivity;
	cardimage4 = qualitative;
	fifthQuestDisplay = true;
	unselectedFifthQues = false; //new one
	isFiveThere;
	introduction = BI_PSP_introductionCategory;
	pss = BI_PSP_PssCategory;
	dlqi = BI_PSP_DlqiCategory;
	wapi = BI_PSP_WapiCategory;
	qsq = BI_PSP_QualitativeCategory;
	workAPI = BI_PSP_Wapi;
	selectmonth = BI_PSP_selectmonth;
	notfound = BI_PSP_noassessmentsfound;
	completedqn = BI_PSP_completedquestionnaire;
	rollout = BI_PSP_roll_out;
	expiredon = BI_PSP_expiredon;
	qsqtext = BI_PSP_qsqtext;
	assessmentlen;
	assessmentResponses;
	firstQuestionResponse;
	secondQuestionResponse;
	thirdQuestionResponse;
	fourthQuestionResponse;
	fifthQuestionResponse;
	sixthQuestionResponse;
	seventhQuestionResponse;
	eigthQuestionResponse;
	assessments = []; // Updated to store a list of assessments
	selectedAssessment; // Added variable to store the selected assessment
	assessmentResponseses = [];
	rolloutDate;
	expireDate;
	//to get site url
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
				this.urlq = brandedUrlNavi;
			} else {
				this.urlq = unAssignedUrlNavi;
			}
		} catch (error) {
			this.showToast(consoleErrorMessage, error.message, errorvariant);//Catching Potential Error
		}
	}
	//To get the Assessment record which is expired
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getqsq1expired)
	wiredwapiexpiredResponses({ data, error }) {
		try {
			if (data) {
				this.assessmentlen = data.length;
			} else if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant);//Catching Potential Error Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant);//Catching Potential Error LWC
		}
	}

	//To get Qualitative date for side bar navigation
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant);//Catching Potential Error Apex
			} else if (data) {
				this.target2monthsdate = data.target2monthsdate ?? null;
				this.target14wksdate = data.target14wksdate ?? null;
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant);//Catching Potential Error LWC
		}
	}

	// slider part 1

	updateThumbLabelPosition() {
		// Use requestAnimationFrame to wait for the next rendering cycle
		requestAnimationFrame(() => {
			this.sliderValue = this.firstQuestionResponse;

			const slider = this.template.querySelector('.slider');
			const thumbLabel = this.template.querySelector('.thumb-label');

			const thumbWidth = parseInt(window.getComputedStyle(thumbLabel).width);
			const sliderWidth = slider.offsetWidth;
			const thumbPosition =
				(this.sliderValue / slider.max) * (sliderWidth - thumbWidth);

			const newPosition = thumbPosition + thumbWidth / 2 - sliderWidth / 2;
			const maxPosition = sliderWidth - thumbWidth;

			thumbLabel.style.left =
				Math.min(maxPosition, Math.max(0, newPosition)) + 'px';
			thumbLabel.setAttribute('data-value', this.sliderValue);

			// Update the content of the thumb-label
			thumbLabel.textContent = this.sliderValue;
		});
	}

	// slider part 2

	updateThumbLabelPositionsec() {
		// Use requestAnimationFrame to wait for the next rendering cycle
		requestAnimationFrame(() => {
			this.sliderValuesec = this.thirdQuestionResponse;
			const slider = this.template.querySelector('.slidersec');
			const thumbLabel = this.template.querySelector('.thumb-labelsec');

			const thumbWidth = parseInt(window.getComputedStyle(thumbLabel).width);
			const sliderWidth = slider.offsetWidth;
			const thumbPosition =
				(this.sliderValuesec / slider.max) * (sliderWidth - thumbWidth);

			const newPosition = thumbPosition + thumbWidth / 2 - sliderWidth / 2;
			const maxPosition = sliderWidth - thumbWidth;

			thumbLabel.style.left =
				Math.min(maxPosition, Math.max(0, newPosition)) + 'px';
			thumbLabel.setAttribute('data-value', this.sliderValuesec);

			// Update the content of the thumb-label
			thumbLabel.textContent = this.sliderValuesec;
		});
	}

	// slider part 3
	updateThumbLabelPositionthree() {
		// Use requestAnimationFrame to wait for the next rendering cycle
		requestAnimationFrame(() => {
			this.sliderValuethree = this.fourthQuestionResponse;
			const slider = this.template.querySelector('.sliderthree');
			const thumbLabel = this.template.querySelector('.thumb-labelthree');

			const thumbWidth = parseInt(window.getComputedStyle(thumbLabel).width);
			const sliderWidth = slider.offsetWidth;
			const thumbPosition =
				(this.sliderValuethree / slider.max) * (sliderWidth - thumbWidth);

			const newPosition = thumbPosition + thumbWidth / 2 - sliderWidth / 2;
			const maxPosition = sliderWidth - thumbWidth;

			thumbLabel.style.left =
				Math.min(maxPosition, Math.max(0, newPosition)) + 'px';
			thumbLabel.setAttribute('data-value', this.sliderValuethree);

			// Update the content of the thumb-label
			thumbLabel.textContent = this.sliderValuethree;
		});
	}

	//to get Assessment Question
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getAssessmentQuestions)
	wiredAssessmentQuestion({ error, data }) {
		try {
			if (data) {
				this.questionData = data.map((question) => ({
					id: question.Id,
					questionText: question.QuestionText,
					activeVersionId: question.ActiveVersion
						? question.ActiveVersion.Id
						: null
				}));

				const firstQuestion = this.questionData[0];
				const secondQuestion = this.questionData[1];
				const thirdQuestion = this.questionData[2];
				const fourthQuestion = this.questionData[3];
				const fifthQuestion = this.questionData[4];
				const sixthQuestion = this.questionData[5];
				const seventhQuestion = this.questionData[6];
				const eighthQuestion = this.questionData[7];

				this.firstQuestionText = firstQuestion.questionText;

				this.firstQuestionVersinId = firstQuestion.activeVersionId;

				this.secondQuestionText = secondQuestion.questionText;

				this.secondQuestionVersinId = secondQuestion.activeVersionId;

				this.thirdQuestionText = thirdQuestion.questionText;

				this.thirdQuestionVersinId = thirdQuestion.activeVersionId;

				this.fourthQuestionText = fourthQuestion.questionText;

				this.fourthQuestionVersinId = fourthQuestion.activeVersionId;

				this.fifthQuestionText = fifthQuestion.questionText;

				this.fifthQuestionVersinId = fifthQuestion.activeVersionId;

				this.sixthQuestionText = sixthQuestion.questionText;

				this.sixthQuestionVersinId = sixthQuestion.activeVersionId;

				this.seventhQuestionText = seventhQuestion.questionText;

				this.seventhQuestionVersinId = seventhQuestion.activeVersionId;

				this.eightQuestionText = eighthQuestion.questionText;

				this.eightQuestionVersinId = eighthQuestion.activeVersionId;
			} else if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant);//Catching Potential Error Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant);//Catching Potential Error LWC
		}
	}

	// To get the selected Assessment
	@wire(getAssessm, { targetDate: '$selectedAssessment' })
	wiredAssessmentResponses({ error, data }) {
		try {
			// Check if the result is defined before accessing its properties

			if (data) {
				this.records = data;

				// this.records = data;

				if (data.length === 0) {
					// You can set default values or perform any other necessary actions
					return;
				}

				this.assessmentResponsesesdate = data.map((response) => ({
					res: response.Assessment.EffectiveDateTime
				}));

				this.assessmentResponsesesdate1 = data.map((response) => ({
					res: response.Assessment.BI_PSP_RolloutforCompletedQuestionnarie__c
				}));

				const ds = this.assessmentResponsesesdate[0];
				const ds1 = this.assessmentResponsesesdate1[0];
				const thedate = ds.res;
				const thedate2 = ds1.res;

				//rolloutdate:
				const currentDate = new Date(thedate);

				this.expireDate = currentDate.toLocaleDateString('en-US', {
					year: 'numeric',
					month: 'short',
					day: 'numeric'
				});
				//expireDate:
				const currentDate1 = new Date(thedate2);
				this.rolloutDate = currentDate1.toLocaleDateString('en-US', {
					year: 'numeric',
					month: 'short',
					day: 'numeric'
				});

				this.records.forEach((record) => {
					if (record.BI_PSP_ResponseOrder__c === 1) {
						this.firstQuestionResponse = record.ResponseText;
					}
					if (record.BI_PSP_ResponseOrder__c === 2) {
						this.secondQuestionResponse = record.ResponseText;
					}
					if (record.BI_PSP_ResponseOrder__c === 3) {
						this.thirdQuestionResponse = record.ResponseText;
					}
					if (record.BI_PSP_ResponseOrder__c === 4) {
						this.fourthQuestionResponse = record.ResponseText;
					}
					if (record.BI_PSP_ResponseOrder__c === 5) {
						this.isFiveThere = yesLabel;
						this.fifthQuestionResponse = record.ResponseText;
						this.fifthQuestionResponse = Array.from(
							record.ResponseText.split(',').filter(
								(element) => element.trim() !== ''
							)
						);
					}

					if (record.BI_PSP_ResponseOrder__c === 6) {
						this.sixthQuestionResponse = record.ResponseText;
					}
				});

				if (this.isFiveThere !== yesLabel) {
					this.fifthQuestDisplay = false;
					this.unselectedFifthQues = true;
				}

				this.updateThumbLabelPosition();
				this.updateThumbLabelPositionsec();
				this.updateThumbLabelPositionthree();
			} else if (error) {
				this.showToast(consoleErrorMessage, error.message, errorvariant);
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant);
		}
	}
	get assessmentOptions() {
		return this.assessments.map((assessment) => ({
			label: assessment.formattedDate,
			value: assessment.effectiveDate
		}));
	}
	//To get Rollout and expire date
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getexpdate)
	wiredExpiresResponses({ data, error }) {
		try {
			if (data) {
				// Map the assessments and format the date for each
				this.assessments = data.map((response) => ({
					effectiveDate: this.formatDate(response.EffectiveDateTime),
					expirationDate: this.formatDate(response.ExpirationDateTime),
					formattedDate: this.formatDate(response.EffectiveDateTime)
				}));

				this.someMethodOutsideWire();
			} else if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant);
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant);
		}
	}

	// Utility method to format the date using Intl.DateTimeFormat
	formatDate(dateString) {
		const options = { year: 'numeric', month: 'long' };
		return new Date(dateString).toLocaleDateString(undefined, options);
	}

	handleAssessmentChange(event) {
		const selectedValues = event.target.value;

		//this.selectedAssessment = this.assessments.find(assessment => assessment.effectiveDate === selectedValues);
		this.selectedAssessment = selectedValues;
	}

	// Example of iterating through this.assessments and storing field values in other properties
	someMethodOutsideWire() {
		// Example: Store the field values in other properties
		this.storedEffectiveDates = this.assessments.map(
			(assessment) => assessment.effectiveDate
		);
		this.storedExpirationDates = this.assessments.map(
			(assessment) => assessment.expirationDate
		);
		this.storedFormattedDates = this.assessments.map(
			(assessment) => assessment.formattedDate
		);

		// Access the first record from the storedEffectiveDates and storedExpirationDates arrays
		if (
			this.storedEffectiveDates.length > 0 &&
			this.storedExpirationDates.length > 0
		) {
			const firstEffectiveDate = this.storedEffectiveDates[0];
			const firstExpirationDate = this.storedExpirationDates[0];

			// Log or use the retrieved values as needed

			this.htmlEffect = firstEffectiveDate;
			this.selectedAssessment = firstEffectiveDate;

			this.htmlExpirationDate = firstExpirationDate;
		}
	}

	//To get total assessment count
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
			if (data) {
				this.count = data;

				if (this.count.length > 0) {
					this.stwai = this.count[0];
					this.stpss = this.count[1];
					this.stdlq = this.count[2];
					this.stqsq = this.count[3];
				}
			} else if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant);//Catching Potential Error Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant);//Catching Potential Error LWC
		}
	}
	get checkdlqi() {
		return this.stdlq > 0 ? '' : 'disabled';
	}
	get checkpss() {
		return this.stpss > 0 ? '' : 'disabled';
	}

	get checkwai() {
		return this.stwai > 0 ? '' : 'disabled';
	}

	//navigation for side bar
	navigateToCategory2() {
		window.location.assign(this.urlq + dlqiCompletedUrl);
	}
	navigateToCategory3() {
		window.location.assign(this.urlq + pssCompletedQuestionnaire);
	}
	navigateToCategory4() {
		window.location.assign(this.urlq + wapiCompletedQuestionnaire);
	}
	navigateToCategory5() {
		if (this.target14wksdate != null && this.assessmentlen > 0) {
			window.location.assign(this.urlq + qualitativeCompletedFourteenMonths);
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