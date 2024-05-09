/*This is Work and Activity Impairment (WPAI) completed Questionnaire and  this allows you to see Wapi Completed Questionnaire 
	with submitted responses.*/
//To import Libraries
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To import Apex classes
import getAssessm from '@salesforce/apex/BI_PSP_CompletedQuestionareS.getCompletedQuestionares';
import getTheAssesmentQuestion from '@salesforce/apex/BI_PSP_GetAssessmentQuestions.getTheAssesmentQuestion';
import getwapiexpired from '@salesforce/apex/BI_PSP_CompletedQuestionareS.getQstnrcurrentcompleteddate';
import getRolloutdate from '@salesforce/apex/BI_PSP_Assessment.getRolloutdate';
import getAssessmentsByCurrentUserNamepss from '@salesforce/apex/BI_PSP_CurrentAndCaregiverUser.getAssessmentsByCurrentUserName';
import getPatientAfterThreemonthsAndFourteenWeeks from '@salesforce/apex/BI_PSP_QualitativeSatisfactions.getPatientAfterThreemonthsAndFourteenWeeks';
import countAssessment from '@salesforce/apex/BI_PSP_Assessment.getAssessmentCountsByCurrentUserName';
//To import Static Resource
import pss from '@salesforce/resourceUrl/BI_PSP_PSSimage';
import letpersonalize from '@salesforce/resourceUrl/BI_PSP_letspersonalizeimage';
import testimg from '@salesforce/resourceUrl/BI_PSP_DLQIimage';
import workandactivity from '@salesforce/resourceUrl/BI_PSP_WPAIimage';
import qualitative from '@salesforce/resourceUrl/BI_PSP_Qualitativeimage';
//To import Custom labels
import BI_PSP_introductionCategory from '@salesforce/label/c.BI_PSP_introductionCategory';
import BI_PSP_PssCategory from '@salesforce/label/c.BI_PSP_PssCategory';
import BI_PSP_WapiCategory from '@salesforce/label/c.BI_PSP_WapiCategory';
import BI_PSP_DlqiCategory from '@salesforce/label/c.BI_PSP_DlqiCategory';
import BI_PSP_QualitativeCategory from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import BI_PSP_Wapi from '@salesforce/label/c.BI_PSP_WAPI';
import BI_PSP_WAPIbottom1 from '@salesforce/label/c.BI_PSP_WAPIbottom1';
import BI_PSP_DLQIbottom3 from '@salesforce/label/c.BI_PSP_DLQIbottom3';
import BI_PSP_selectmonth from '@salesforce/label/c.BI_PSP_selectmonth';
import BI_PSP_completedquestionnaire from '@salesforce/label/c.BI_PSP_completedquestionnaire';
import BI_PSP_roll_out from '@salesforce/label/c.BI_PSP_roll_out';
import BI_PSP_expiredon from '@salesforce/label/c.BI_PSP_expiredon';
import BI_PSP_errorloading from '@salesforce/label/c.BI_PSP_errorloading';
import BI_PSP_noassessmentsfound from '@salesforce/label/c.BI_PSP_noassessmentsfound';
import BI_PSP_includetext from '@salesforce/label/c.BI_PSP_includetext';
import BI_PSP_hours from '@salesforce/label/c.BI_PSP_chatterHours';
import BI_PSP_wapiskip from '@salesforce/label/c.BI_PSP_wapiskip';
import BI_PSP_wapisectext from '@salesforce/label/c.BI_PSP_wapisectext';
import BI_PSP_wapislider2 from '@salesforce/label/c.BI_PSP_wapislider2';
import BI_PSP_wapidailyleft from '@salesforce/label/c.BI_PSP_wapidailyleft';
import BI_PSP_wapidailyright from '@salesforce/label/c.BI_PSP_wapidailyright';
import BI_PSP_wapiworkleft from '@salesforce/label/c.BI_PSP_wapiworkleft';
import BI_PSP_wapiworkright from '@salesforce/label/c.BI_PSP_wapiworkright';
import dlqi_category from '@salesforce/label/c.BI_PSP_QualitativeCategory';
import brandedurl from '@salesforce/label/c.BI_PSPB_siteUrl';
import completed from '@salesforce/label/c.BI_PSP_CompletedOn';
import unassignedurl from '@salesforce/label/c.BI_PSPB_UnAssignedSiteUlr';
import brandedUrlNavi from '@salesforce/label/c.BI_PSPB_BrandedSiteURL';
import unAssignedUrlNavi from '@salesforce/label/c.BI_PSPB_UnassignedSiteURL';
import pssCompletedQuestionnaire from '@salesforce/label/c.BI_PSPB_BRPsoriasisCompletedQuesUrl';
import qualitativeCompletedFourteenMonths from '@salesforce/label/c.BI_PSPB_BRQualitativefourteenweeksCompletedUrl';
import qualitativeCompletedtwoMonths from '@salesforce/label/c.BI_PSPB_BR_QualitativeTwoMonthsCompletedUrl';
import expired from '@salesforce/label/c.BI_PSP_Expired';
import completedLabel from '@salesforce/label/c.BI_PSP_Completed';
import consoleErrorMessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import dlqiCompletedUrl from '@salesforce/label/c.BI_PSPB_BRDlqiCompletedUrl';
//To get UserId
import Id from '@salesforce/user/Id';
export default class BiPspbWapiCompletedQuestionnaire extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track sliderValue = 0;
	@track sliderValuesec = 0;
	//Global variables(without @track does not trigger automatic re-renders)
	userid = Id;
	drfatRecords = [];
	completedon = completed;
	stpss = 0;
	stwai = 0;
	stqsq = 0;
	stdlq = 0;
	assessmentResponseses;
	shouldShowComponent = false;
	questionData;
	categoryname = dlqi_category;
	urlq;
	firstQuestionText;
	firstQuestionId;
	secondQuestionId;
	secondQuestionText;
	thirdQuestionText;
	thirdQuestionVersionId;
	fourthQuestionText;
	fourthQuestionVersionId;
	fifthQuestionText;
	fifthQuestionVersionId;
	sixthQuestionText;
	sixthQuestionVerionId;
	firstQuestionResponse;
	secondQuestionResponse;
	thirdQuestionResponse;
	fourthQuestionResponse;
	fifthQuestionResponse;
	sixthQuestionResponse;
	cardimage = letpersonalize;
	cardimage1 = testimg;
	cardimage2 = pss;
	cardimage3 = workandactivity;
	cardimage4 = qualitative;
	wapiCategoryname = BI_PSP_WapiCategory;
	introduction = BI_PSP_introductionCategory;
	pss = BI_PSP_PssCategory;
	dlqi = BI_PSP_DlqiCategory;
	wapi = BI_PSP_WapiCategory;
	qsq = BI_PSP_QualitativeCategory;
	workAPI = BI_PSP_Wapi;
	wapibot1 = BI_PSP_WAPIbottom1;
	wapibot2 = BI_PSP_DLQIbottom3;
	selectmonth = BI_PSP_selectmonth;
	completedqn = BI_PSP_completedquestionnaire;
	rollout = BI_PSP_roll_out;
	expiredon = BI_PSP_expiredon;
	errorloading = BI_PSP_errorloading;
	notfound = BI_PSP_noassessmentsfound;
	includetext = BI_PSP_includetext;
	hours = BI_PSP_hours;
	skiptext = BI_PSP_wapiskip;
	slidertext = BI_PSP_wapisectext;
	slidertext2 = BI_PSP_wapislider2;
	worksliderleft = BI_PSP_wapiworkleft;
	worksliderright = BI_PSP_wapiworkright;
	dailysliderleft = BI_PSP_wapidailyleft;
	dailysliderright = BI_PSP_wapidailyright;
	dateResponses = [];
	storedate;
	expireDate;
	rolloutDate;
	selectedAssessment;
	assessments = [];
	forTwoResp = false;
	forSixResponse = false;
	// To get site Url to find the Current SiteName
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
			this.showToast(consoleErrorMessage, error.message, errorvariant); //Catching Potential Error
		}
	}

	//To place the value in right position inside the slider
	updateThumbLabelPosition() {
		requestAnimationFrame(() => {
			// Use requestAnimationFrame to wait for the next rendering cycle
			this.sliderValue = this.fifthQuestionResponse;

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

	//To place the value in right position inside the slider
	updateThumbLabelPositionsec() {
		// Use requestAnimationFrame to wait for the next rendering cycle
		requestAnimationFrame(() => {
			this.sliderValuesec = this.sixthQuestionResponse;

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
	//Get Qualitative date for side bar navigation
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getPatientAfterThreemonthsAndFourteenWeeks)
	wiredResult({ error, data }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error Apex
			} else if (data) {
				this.threeMonthsVar = data.threeMonthsVar;
				this.forteenWeeks = data.forteenWeeks;
				this.target2monthsdate = data.target2monthsdate ?? null;
				this.target14wksdate = data.target14wksdate ?? null;
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error LWC
		}
	}

	// To get Assessment record and status for particular record
	/*Null checks are not performed because if there is no Assessment with completed Status
	it will not navigate to this page.
    */
	@wire(getAssessmentsByCurrentUserNamepss, { categoryname: '$categoryname' })
	wiredAssessments({ error, data }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error Apex
			} else if (data) {
				this.assessmentId = data.length > 0 ? data[0].Id : null;
				this.status = data.length > 0 ? data[0].AssessmentStatus : null;
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error LWC
		}
	}

	// To get rollout date
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getRolloutdate)
	wiredQSPData({ error, data }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error Apex
			}
			if (data) {
				this.dateResponses = data;
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error LWC
		}
	}

	//Getting assessment Question
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getTheAssesmentQuestion)
	wiredAssessmentQuestion({ error, data }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.body.message, errorvariant); // Catching Potential Error Apex
			} else if (data) {
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

				this.firstQuestionText = firstQuestion.questionText;

				this.firstQuestionVersinId = firstQuestion.activeVersionId;
				this.secondQuestionText = secondQuestion.questionText;
				this.secondQuestionVersinId = secondQuestion.activeVersionId;

				this.thirdQuestionText = thirdQuestion.questionText;
				this.thirdQuestionVersionId = thirdQuestion.activeVersionId;
				this.fourthQuestionText = fourthQuestion.questionText;
				this.fourthQuestionVersionId = fourthQuestion.activeVersionId;
				this.fifthQuestionText = fifthQuestion.questionText;
				this.fifthQuestionVersionId = fifthQuestion.activeVersionId;
				this.sixthQuestionText = sixthQuestion.questionText;
				this.sixthQuestionVerionId = sixthQuestion.activeVersionId;
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error LWC
		}
	}
	//To get the current record completed data
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getwapiexpired, { categoryName: '$wapiCategoryname' })
	wiredwapiexpiredResponses({ data, error }) {
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
				this.showToast(consoleErrorMessage, error.message, errorvariant); // Catching Potential Error Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error LWC
		}
	}

	// Utility method to format the date using Intl.DateTimeFormat
	formatDate(dateString) {
		const options = { year: 'numeric', month: 'long' };
		return new Date(dateString).toLocaleDateString(undefined, options);
	}

	// Wire method to fetch data of completed assessment
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(getAssessm, { targetDate: '$selectedAssessment', categoryName: '$wapiCategoryname' })
	wiredAssessmentResponses({ error, data }) {
		try {
			// Check if the result is defined before accessing its properties
			if (data) {
				this.drfatRecords = data;
				this.assessmentResponsesesdate = data.map((response) => ({
					res: response.Assessment.EffectiveDateTime
				}));
				this.assessmentResponsesesdate1 = data.map((response) => ({
					res: response.Assessment.BI_PSP_RolloutforCompletedQuestionnarie__c
				}));
				this.assessmentResponseses = data.map((response) => ({
					res: response.ResponseText ? response.ResponseText : null

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
				if (
					this.assessmentResponseses &&
					this.assessmentResponseses.length >= 6
				) {
					// this.shouldShowComponent=true;
					this.forSixResponse = true;
					this.forTwoResp = false;
					const firstQuestionres = this.assessmentResponseses[0];
					const secondQuestionres = this.assessmentResponseses[1];
					const thirdQuestionres = this.assessmentResponseses[2];
					const fourthQuestionres = this.assessmentResponseses[3];
					const fifthQuestionres = this.assessmentResponseses[4];
					const sixthQuestionres = this.assessmentResponseses[5];

					if (firstQuestionres.res !== null) {
						this.firstQuestionResponse = firstQuestionres.res;
					}
					if (secondQuestionres.res !== null) {
						this.secondQuestionResponse = secondQuestionres.res;
					}

					if (thirdQuestionres.res !== null) {
						this.thirdQuestionResponse = thirdQuestionres.res;
					}
					if (fourthQuestionres.res !== null) {
						this.fourthQuestionResponse = fourthQuestionres.res;
					}
					if (fifthQuestionres.res !== null) {
						this.fifthQuestionResponse = fifthQuestionres.res;
					}
					if (sixthQuestionres.res !== null) {
						this.sixthQuestionResponse = sixthQuestionres.res;
						this.updateThumbLabelPositionsec();
					}

					this.updateThumbLabelPosition();
					//   this.updateThumbLabelPositionsec();
				}

				// else if(this.assessmentResponseses && this.assessmentResponseses.length <= 2 )
				else if (
					this.assessmentResponseses &&
					this.assessmentResponseses.length <= 2
				) {
					this.shouldShowComponent = true;
					this.forTwoResp = true;
					this.forSixResponse = false;

					this.drfatRecords.forEach((record) => {
						if (record.BI_PSP_ResponseOrder__c === 1) {
							this.firstQuestionResponse = record.ResponseText;
						}
						if (record.BI_PSP_ResponseOrder__c === 6) {
							this.sixthQuestionResponse = record.ResponseText;
							this.updateThumbLabelPositionsec();
						}
					});
				} else if (
					this.assessmentResponseses &&
					this.assessmentResponseses.length <= 4
				) {
					this.shouldShowComponent = true;
					this.forTwoResp = true;
					this.forSixResponse = false;

					this.drfatRecords.forEach((record) => {
						if (record.BI_PSP_ResponseOrder__c === 1) {
							this.firstQuestionResponse = record.ResponseText;
						}
						if (record.BI_PSP_ResponseOrder__c === 6) {
							this.sixthQuestionResponse = record.ResponseText;
							this.updateThumbLabelPositionsec();
						}
					});
				}
			} else if (error) {
				this.showToast(consoleErrorMessage, error.message, errorvariant); // Catching Potential Error Apex
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error LWC
		}
	}

	get assessmentOptions() {
		return this.assessments.map((assessment) => ({
			label: assessment.formattedDate,
			value: assessment.effectiveDate
		}));
	}

	handleAssessmentChange(event) {
		const selectedValues = event.target.value;

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

		// Log the stored field values
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

	//To get completed Assessment for current user
	//There's no need to check for null because in Apex, we're throwing an AuraHandledException. Therefore, null data won't be encountered.
	@wire(countAssessment)
	wiredAssessmentResponsesqsq({ data, error }) {
		try {
			if (error) {
				this.showToast(consoleErrorMessage, error.message, errorvariant); // Catching Potential Error Apex
			}
			else if (data ) {
				this.count = data;

				if (this.count.length > 0) {
					this.stwai = this.count[0];
					this.stpss = this.count[1];
					this.stdlq = this.count[2];
					this.stqsq = this.count[3];
				}
			}
		} catch (err) {
			this.showToast(consoleErrorMessage, err.message, errorvariant); // Catching Potential Error LWC
		}
	}

	get checkdlqi() {
		return this.stdlq > 0 ? '' : 'disabled';
	}
	get checkpss() {
		return this.stpss > 0 ? '' : 'disabled';
	}

	get checkqsq() {
		return this.stqsq > 0 ? '' : 'disabled';
	}
	//navigation method for other completed Questionnaries
	navigateToCategory2() {
		window.location.assign(this.urlq + dlqiCompletedUrl);
	}
	navigateToCategory3() {
		window.location.assign(this.urlq + pssCompletedQuestionnaire);
	}

	navigateToCategory5() {
		if (this.target14wksdate != null) {
			if (this.status === completedLabel || this.status === expired) {
				window.location.assign(this.urlq + qualitativeCompletedFourteenMonths);
			} else {
				window.location.assign(this.urlq + qualitativeCompletedtwoMonths);
			}
		} else {
			window.location.assign(this.urlq + qualitativeCompletedtwoMonths);
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