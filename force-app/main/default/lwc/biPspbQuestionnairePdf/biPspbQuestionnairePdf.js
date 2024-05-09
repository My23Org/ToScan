//To import Libraries
import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//To get Current UserId
import Id from '@salesforce/user/Id';
//To import Static Resources
import chartjs from '@salesforce/resourceUrl/BI_PSP_Chartjs';
import RedCircle from '@salesforce/resourceUrl/BI_PSP_RedCircle';
import YellowCircle from '@salesforce/resourceUrl/BI_PSP_YellowCircle';
import Orangecircle from '@salesforce/resourceUrl/BI_PSP_Orangecircle';
import Greencircle from '@salesforce/resourceUrl/BI_PSP_Greencircle';
import Greycircle from '@salesforce/resourceUrl/BI_PSP_Greycircle';
import BI_PSP_Correct from '@salesforce/resourceUrl/BI_PSP_Correct';
import BI_PSP_Wrong from '@salesforce/resourceUrl/BI_PSP_Wrong';
import BI_PSP_NotApplicable from '@salesforce/resourceUrl/BI_PSP_NotApplicable';
import BI_PSP_NA from '@salesforce/resourceUrl/BI_PSP_NA';
import BI_PSP_LineGrey from '@salesforce/resourceUrl/BI_PSP_LineGrey';
import BI_PSP_LineYellow from '@salesforce/resourceUrl/BI_PSP_LineYellow';
import BI_PSP_LineBrown from '@salesforce/resourceUrl/BI_PSP_LineBrown';
//To import Apex Classes
import fetchAssessmentDetails from '@salesforce/apex/BI_PSP_GraphCtrl.getQuestionnaireDetails';
import pss_ShortDescription from '@salesforce/label/c.BI_PSP_PssCategory';
import dlqi_ShortDescription from '@salesforce/label/c.BI_PSP_DlqiCategory';
import verySevere_ShortDescription from '@salesforce/label/c.BI_PSP_verysevere';
import severe_ShortDescription from '@salesforce/label/c.BI_PSP_severe';
import moderate_ShortDescription from '@salesforce/label/c.BI_PSP_moderate';
import mild_ShortDescription from '@salesforce/label/c.BI_PSP_mild';
import none_ShortDescription from '@salesforce/label/c.BI_PSP_none';
import verymuch_ShortDescription from '@salesforce/label/c.BI_PSP_verymuch';
import alot_ShortDescription from '@salesforce/label/c.BI_PSP_alot';
import alittle_ShortDescription from '@salesforce/label/c.BI_PSP_alittle';
import notatall_ShortDescription from '@salesforce/label/c.BI_PSP_notatall';
import notrelevant_ShortDescription from '@salesforce/label/c.BI_PSP_notrelevant';
import softDelete_ShortDescription from '@salesforce/label/c.BI_PSP_SoftDelete';
import no_ShortDescription from '@salesforce/label/c.BI_PSP_no';
import skinCondition_ShortDescription from '@salesforce/label/c.BI_PSPB_skinCondition';
import skinQuestion_ShortDescription from '@salesforce/label/c.BI_PSPB_skinQuestion';
import shortQuestion1_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion1';
import shortQuestion2_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion2';
import shortQuestion3_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion3';
import shortQuestion4_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion4';
import shortQuestion5_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion5';
import shortQuestion6_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion6';
import shortQuestion7_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion7';
import shortQuestion8_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion8';
import shortQuestion9_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion9';
import shortQuestion10_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion10';
import shortQuestion11_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion11';
import shortQuestion12_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion12';
import shortQuestion13_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion13';
import shortQuestion14_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion14';
import shortQuestion15_ShortDescription from '@salesforce/label/c.BI_PSPB_ShortQuestion15';
import notApplicable_ShortDescription from '@salesforce/label/c.BI_PSPB_notApplicable';
import pain_ShortDescription from '@salesforce/label/c.BI_PSPB_Pain';
import redness_ShortDescription from '@salesforce/label/c.BI_PSPB_Redness';
import itching_ShortDescription from '@salesforce/label/c.BI_PSPB_Itching';
import burning_ShortDescription from '@salesforce/label/c.BI_PSPB_Burning';
import wapiCategory_ShortDescription from '@salesforce/label/c.BI_PSP_WapiCategory';
import line_ShortDescription from '@salesforce/label/c.BI_PSPB_line';
import errorvariant from '@salesforce/label/c.BI_PSPB_errorVariant';
import errormessage from '@salesforce/label/c.BI_PSP_ConsoleError';
import BI_PSPB_last3months from '@salesforce/label/c.BI_PSPB_last3months';
import BI_PSPB_last6months from '@salesforce/label/c.BI_PSPB_last6months';
import BI_PSPB_last12months from '@salesforce/label/c.BI_PSPB_last12months';
import BI_PSPB_SelectaMonth from '@salesforce/label/c.BI_PSPB_month';
import BI_PSPB_SelectaQuestion from '@salesforce/label/c.BI_PSPB_SelectaQuestion';
import BI_PSPB_RangeofMonths from '@salesforce/label/c.BI_PSPB_RangeofMonths';
import BI_PSPB_1month from '@salesforce/label/c.BI_PSPB_1month';
import January from '@salesforce/label/c.BI_PSPB_January';
import February from '@salesforce/label/c.BI_PSPB_February';
import March from '@salesforce/label/c.BI_PSPB_March';
import April from '@salesforce/label/c.BI_PSPB_April';
import May from '@salesforce/label/c.BI_PSPB_May';
import June from '@salesforce/label/c.BI_PSPB_June';
import July from '@salesforce/label/c.BI_PSPB_July';
import August from '@salesforce/label/c.BI_PSPB_August';
import September from '@salesforce/label/c.BI_PSPB_September';
import October from '@salesforce/label/c.BI_PSPB_October';
import November from '@salesforce/label/c.BI_PSPB_November';
import December from '@salesforce/label/c.BI_PSPB_December';
import BI_PSPB_highlightBack from '@salesforce/label/c.BI_PSPB_highlightBack';
import BI_PSPB_erolls from '@salesforce/label/c.BI_PSPB_erolls';
import BI_PSPB_Selected_Category from '@salesforce/label/c.BI_PSPB_Selected_Category';
import BI_PSPB_lastdate from '@salesforce/label/c.BI_PSPB_lastdate';
import BI_PSPB_Selected_MonthValue from '@salesforce/label/c.BI_PSPB_Selected_MonthValue';
import BI_PSPB_2d from '@salesforce/label/c.BI_PSPB_2d';

export default class BiPspbQuestionnairePdf extends LightningElement {
	//Proper naming conventions with camel case for all the variable will be followed in the future releases
	//Track variable Declarations(re-render variables)
	@track selectedCategory;
	@track transformedData = [];
	@track assessmentResponse;
	@track dlqifirst = [];
	@track dlqisecond = [];
	@track dlqifive = [];
	@track pss = [];
	@track dlqithree = [];
	@track dlqifour = [];
	@track pssShow;
	@track dlqishow1;
	@track dlqishow2;
	@track dlqishow3;
	@track dlqishow4;
	@track dlqishow5;
	@track wPAIShow;
	@track wpaiFirst = [];
	@track wpaiSecond = [];
	@track wpaiThird = [];
	@track calculatedMonths;
	//Global variables(without @track does not trigger automatic re-renders)
	chartInitialized = false;
	LineGrey = BI_PSP_LineGrey;
	LineYellow = BI_PSP_LineYellow;
	LineBrown = BI_PSP_LineBrown;
	RedCircle = RedCircle;
	YellowCircle = YellowCircle;
	Orangecircle = Orangecircle;
	Greencircle = Greencircle;
	Greycircle = Greycircle;
	BI_PSP_Correct = BI_PSP_Correct;
	BI_PSP_Wrong = BI_PSP_Wrong;
	BI_PSP_NotApplicable = BI_PSP_NotApplicable;
	BI_PSP_NA = BI_PSP_NA;
	BI_PSP_PSS_ShortDescription = pss_ShortDescription;
	BI_PSP_DLQI_ShortDescription = dlqi_ShortDescription;
	BI_PSP_verySevere_ShortDescription = verySevere_ShortDescription;
	BI_PSP_severe_ShortDescription = severe_ShortDescription;
	BI_PSP_moderate_ShortDescription = moderate_ShortDescription;
	BI_PSP_mild_ShortDescription = mild_ShortDescription;
	BI_PSP_none_ShortDescription = none_ShortDescription;
	BI_PSP_verymuch_ShortDescription = verymuch_ShortDescription;
	BI_PSP_alot_ShortDescription = alot_ShortDescription;
	BI_PSP_alittle_ShortDescription = alittle_ShortDescription;
	BI_PSP_notatall_ShortDescription = notatall_ShortDescription;
	BI_PSP_notrelevant_ShortDescription = notrelevant_ShortDescription;
	BI_PSP_SoftDelete_ShortDescription = softDelete_ShortDescription;
	BI_PSP_no_ShortDescription = no_ShortDescription;
	BI_PSPB_skinCondition_ShortDescription = skinCondition_ShortDescription;
	BI_PSPB_skinQuestion_ShortDescription = skinQuestion_ShortDescription;
	BI_PSPB_ShortQuestion1_ShortDescription = shortQuestion1_ShortDescription;
	BI_PSPB_ShortQuestion2_ShortDescription = shortQuestion2_ShortDescription;
	BI_PSPB_ShortQuestion3_ShortDescription = shortQuestion3_ShortDescription;
	BI_PSPB_ShortQuestion4_ShortDescription = shortQuestion4_ShortDescription;
	BI_PSPB_ShortQuestion5_ShortDescription = shortQuestion5_ShortDescription;
	BI_PSPB_ShortQuestion6_ShortDescription = shortQuestion6_ShortDescription;
	BI_PSPB_ShortQuestion7_ShortDescription = shortQuestion7_ShortDescription;
	BI_PSPB_ShortQuestion8_ShortDescription = shortQuestion8_ShortDescription;
	BI_PSPB_ShortQuestion9_ShortDescription = shortQuestion9_ShortDescription;
	BI_PSPB_ShortQuestion10_ShortDescription = shortQuestion10_ShortDescription;
	BI_PSPB_ShortQuestion11_ShortDescription = shortQuestion11_ShortDescription;
	BI_PSPB_ShortQuestion12_ShortDescription = shortQuestion12_ShortDescription;
	BI_PSPB_ShortQuestion13_ShortDescription = shortQuestion13_ShortDescription;
	BI_PSPB_ShortQuestion14_ShortDescription = shortQuestion14_ShortDescription;
	BI_PSPB_ShortQuestion15_ShortDescription = shortQuestion15_ShortDescription;
	BI_PSPB_notApplicable_ShortDescription = notApplicable_ShortDescription;
	BI_PSPB_Pain_ShortDescription = pain_ShortDescription;
	BI_PSPB_Redness_ShortDescription = redness_ShortDescription;
	BI_PSPB_Itching_ShortDescription = itching_ShortDescription;
	BI_PSPB_Burning_ShortDescription = burning_ShortDescription;
	BI_PSP_WapiCategory_ShortDescription = wapiCategory_ShortDescription;
	BI_PSP_line_ShortDescription = line_ShortDescription;
	assessmentData;
	userId = Id;
	showChart;
	chartDatachartData;
	monthsToDisplay;
	bubbles = '';
	selectedMonthValue = '';
	showMonthSelector;
	wpaiFirstshow;
	wpaiThirdshow;
	selectedSingleMonth;
	placeholder = BI_PSPB_SelectaQuestion;
	formattedDate;
	endDate;
	gotData = true;
	// Array of options for picklist selection
	picklistOptions = [
		{ label: this.BI_PSP_WapiCategory_ShortDescription, value: this.BI_PSP_WapiCategory_ShortDescription },
		{ label: this.BI_PSP_DLQI_ShortDescription, value: this.BI_PSP_DLQI_ShortDescription },
		{ label: this.BI_PSP_PSS_ShortDescription, value: this.BI_PSP_PSS_ShortDescription }
	];
	placeholderdate = BI_PSPB_RangeofMonths;
	// Array of options for date range selection
	picklistOptionsdate = [
		{ label: BI_PSPB_last12months, value: BI_PSPB_last12months },
		{ label: BI_PSPB_last6months, value: BI_PSPB_last6months },
		{ label: BI_PSPB_last3months, value: BI_PSPB_last3months },
		{ label: BI_PSPB_1month, value: BI_PSPB_1month }
	];
	placeholderMonth = BI_PSPB_SelectaMonth;
	// Array of options for month selection
	picklistOptionsMonth = [
		{ label: January, value: January },
		{ label: February, value: February },
		{ label: March, value: March },
		{ label: April, value: April },
		{ label: May, value: May },
		{ label: June, value: June },
		{ label: July, value: July },
		{ label: August, value: August },
		{ label: September, value: September },
		{ label: October, value: October },
		{ label: November, value: November },
		{ label: December, value: December }
	];
	// Fetch URL parameters and initialize component
	connectedCallback() {
		try {
			let urlParams = new URLSearchParams(window.location.href.split('?')[1]);
			let eroll = urlParams.get(BI_PSPB_erolls);
			let selectedCategory = urlParams.get(BI_PSPB_Selected_Category);
			let lastdate = urlParams.get(BI_PSPB_lastdate);
			this.selectedCategory = selectedCategory;
			this.selectedMonthValue = urlParams.get(BI_PSPB_Selected_MonthValue);
			this.getQuestionnaireAssesmentResponse(eroll, selectedCategory, lastdate);
		}
		catch (error) {
			this.showToast(errormessage, error.message, errorvariant);
		}
	}
	// Getter to extract unique months from transformedData
	get months() {
		const uniqueMonths = new Set();
		this.transformedData.forEach(item => {
			item.months.forEach(monthItem => {
				uniqueMonths.add(monthItem.Month);
			});
		});
		return Array.from(uniqueMonths);
	}
	// Method to toggle background highlighting
	highlightbackground() {
		if (this.bubbles === '') {
			this.bubbles = BI_PSPB_highlightBack;
		} else {
			this.bubbles = '';
		}
	}
	// handling month change
	handleMonthChange(event) {
		this.selectedMonthValue = event.target.value;
		if (this.selectedMonthValue === BI_PSPB_1month) {
			this.showMonthSelector = true;
		} else {
			this.showMonthSelector = false;
			this.endDate = parseInt(this.selectedMonthValue.match(/\d+/)[0], 10);
			if (this.endDate) {
				this.handleCalculateMonths(this.endDate);
			}
		}
	}
	// Method to calculate months based on the provided number of months
	handleCalculateMonths(numberOfMonths) {
		const currentDate = new Date();
		const currentYear = currentDate.getFullYear();
		let startMonth, endMonth;
		if (numberOfMonths === 1) {
			startMonth = 1;
			endMonth = 1;
		} else if (numberOfMonths > 1 && numberOfMonths <= 11) {
			startMonth = currentDate.getMonth() - numberOfMonths + 1;
			if (startMonth <= 0) {
				startMonth += 12;
			}
			endMonth = currentDate.getMonth();
		} else {
			startMonth = currentDate.getMonth() - 12 + 1;
			if (startMonth <= 0) {
				startMonth += 12;
			}
			endMonth = currentDate.getMonth();
		}
		this.calculatedMonths = this.getMonthsInRange(startMonth, endMonth, currentYear);
		this.getQuestionnaireAssesmentResponse(this.enrolleId, this.selectedCategory, JSON.stringify(this.calculatedMonths));
		this.transformedData = [];
		this.dlqifirst = [];
		this.dlqisecond = [];
		this.dlqifive = [];
		this.pss = [];
		this.dlqithree = [];
		this.dlqifour = [];
		this.wpaiSecond = [];
		this.wpaiFirst = [];
		this.wpaiThird = [];
	}
	// Method to generate an array of months within the specified range
	getMonthsInRange(start, end, year) {
		const months = [];
		if (start <= end) {
			for (let i = start; i <= end; i++) {
				months.push(`${this.currentMonthName(i)} ${year}`);
			}
		} else {
			for (let i = start; i <= 12; i++) {
				months.push(`${this.currentMonthName(i)} ${year - 1}`);
			}
			for (let i = 1; i <= end; i++) {
				months.push(`${this.currentMonthName(i)} ${year}`);
			}
		}
		return months;
	}
	// Method to get the name of the month based on its index
	currentMonthName(monthIndex) {
		const monthNames = [
			January, February, March, April, May, June,
			July, August, September, October, November, December
		];
		return monthNames[monthIndex - 1];
	}
	// Method to format a date string into a readable format
	formatDate(dateString) {
		const date = new Date(dateString);
		const month = date.toLocaleString('default', { month: 'long' });
		const year = date.getFullYear();
		return `${month} ${year}`;
	}
	// Method to handle change in selected single month
	handleSingleMonthChange(event) {
		this.selectedSingleMonth = event.target.value;
		this.calculatedMonths = this.formatDate(this.selectedSingleMonth);
		this.getQuestionnaireAssesmentResponse(this.enrolleId, this.selectedCategory, JSON.stringify(this.calculatedMonths));
		this.transformedData = [];
		this.dlqifirst = [];
		this.dlqisecond = [];
		this.dlqifive = [];
		this.pss = [];
		this.dlqithree = [];
		this.dlqifour = [];
		this.wpaiSecond = [];
		this.wpaiFirst = [];
		this.wpaiThird = [];
	}
	// Method to handle change in selected category
	handleCategoryChange(event) {
		this.selectedCategory = event.target.value;
		this.getQuestionnaireAssesmentResponse(this.enrolleId, this.selectedCategory, JSON.stringify(this.calculatedMonths));
		this.transformedData = [];
		this.dlqifirst = [];
		this.dlqisecond = [];
		this.dlqifive = [];
		this.pss = [];
		this.dlqithree = [];
		this.dlqifour = [];
		this.wpaiSecond = [];
		this.wpaiFirst = [];
		this.wpaiThird = [];
	}
	// Method to fetch assessment details based on enrolles, categoryvalues and rangeofMonths
	getQuestionnaireAssesmentResponse(enrolles, categoryvalues, rangeofMonths) {
		if (enrolles && categoryvalues && rangeofMonths) {
			fetchAssessmentDetails({ erolleId: enrolles, questionnaireCategory: categoryvalues, selectedMonths: rangeofMonths })
				.then(result => {
					if (result !== null) {
						this.assessmentResponse = result;
						this.showChart = true;
						this.gotData = true;
						for (const monthKey in this.assessmentResponse) {
							if (Object.hasOwnProperty.call(this.assessmentResponse, monthKey)) {
								const month = this.assessmentResponse[monthKey];
								for (const question of month) {
									let existingQuestion = this.transformedData.find(item => item.Question === question.AssessmentQuestion.BI_PSP_shortQuestionText__c);
									if (!existingQuestion) {
										existingQuestion = {
											Question: question.AssessmentQuestion.BI_PSP_shortQuestionText__c,
											months: [],
											value: question.ResponseText
										};
									}
									if (categoryvalues === this.BI_PSP_PSS_ShortDescription) {
										existingQuestion.months.push({
											Month: monthKey,
											Value: question.ResponseText === this.BI_PSP_verySevere_ShortDescription ? this.RedCircle : question.ResponseText === this.BI_PSP_severe_ShortDescription ? this.Orangecircle
												: question.ResponseText === this.BI_PSP_moderate_ShortDescription ? this.YellowCircle : question.ResponseText === this.BI_PSP_mild_ShortDescription ? this.Greencircle
													: question.ResponseText === this.BI_PSP_none_ShortDescription ? this.Greycircle : this.BI_PSP_NA
										});
									} else if (categoryvalues === this.BI_PSP_DLQI_ShortDescription) {
										if (question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_skinCondition_ShortDescription ||
											question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_skinQuestion_ShortDescription) {
											existingQuestion.months.push({
												Month: monthKey,
												Value: question.ResponseText === this.BI_PSP_verymuch_ShortDescription ? this.RedCircle : question.ResponseText === this.BI_PSP_alot_ShortDescription ? this.Orangecircle
													: question.ResponseText === this.BI_PSP_alittle_ShortDescription ? this.YellowCircle : question.ResponseText === this.BI_PSP_notatall_ShortDescription ? this.Greencircle
														: question.ResponseText === this.BI_PSP_notrelevant_ShortDescription ? this.Greycircle : this.BI_PSP_NA
											});
										}
										else if (question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion1_ShortDescription ||
											question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion2_ShortDescription
											|| question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion3_ShortDescription
											|| question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion4_ShortDescription
										) {
											existingQuestion.months.push({
												Month: monthKey,
												Value: question.ResponseText === this.BI_PSP_verymuch_ShortDescription ? this.RedCircle : question.ResponseText === this.BI_PSP_alot_ShortDescription ? this.Orangecircle
													: question.ResponseText === this.BI_PSP_alittle_ShortDescription ? this.YellowCircle : question.ResponseText === this.BI_PSP_notatall_ShortDescription ? this.Greencircle
														: question.ResponseText === this.BI_PSP_notrelevant_ShortDescription ? this.Greycircle : this.BI_PSP_NA
											});
										}
										else if (question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion5_ShortDescription) {
											existingQuestion.months.push({
												Month: monthKey,
												Value: question.ResponseText === this.BI_PSP_SoftDelete_ShortDescription ? this.BI_PSP_Correct : question.ResponseText === this.BI_PSP_no_ShortDescription ? this.BI_PSP_Wrong
													: question.ResponseText === this.BI_PSP_notrelevant_ShortDescription ? this.BI_PSP_NotApplicable : this.BI_PSP_NA
											});
										}
										else if (question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion6_ShortDescription) {
											existingQuestion.months.push({
												Month: monthKey,
												Value: question.ResponseText === this.BI_PSP_alot_ShortDescription ? this.Orangecircle : question.ResponseText === this.BI_PSP_alittle_ShortDescription ? this.YellowCircle
													: question.ResponseText === this.BI_PSP_notatall_ShortDescription ? this.Greencircle
														: question.ResponseText === this.BI_PSPB_notApplicable_ShortDescription ? this.BI_PSP_NA : this.BI_PSP_NA
											});
										}
										else if (question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion7_ShortDescription ||
											question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion8_ShortDescription ||
											question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion9_ShortDescription) {
											existingQuestion.months.push({
												Month: monthKey,
												Value: question.ResponseText === this.BI_PSP_verymuch_ShortDescription ? this.RedCircle : question.ResponseText === this.BI_PSP_alot_ShortDescription ? this.Orangecircle
													: question.ResponseText === this.BI_PSP_alittle_ShortDescription ? this.YellowCircle : question.ResponseText === this.BI_PSP_notatall_ShortDescription ? this.Greencircle
														: question.ResponseText === this.BI_PSP_notrelevant_ShortDescription ? this.Greycircle : this.BI_PSP_NA
											});
										}

									} else if (categoryvalues === this.BI_PSP_WapiCategory_ShortDescription) {
										if (question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion10_ShortDescription) {
											existingQuestion.months.push({
												Month: monthKey,
												Value: question.ResponseText === this.BI_PSP_SoftDelete_ShortDescription ? this.BI_PSP_Correct : question.ResponseText === this.BI_PSP_no_ShortDescription ? this.BI_PSP_Wrong : this.BI_PSP_NA
											});
										} else if (question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion13_ShortDescription ||
											question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion12_ShortDescription) {
											existingQuestion.months.push({
												Month: monthKey,
												Value: question.ResponseText != null ? question.ResponseText : 0,
												borderColor: '#403A60'
											});
										} else if (question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion11_ShortDescription) {
											existingQuestion.months.push({
												Month: monthKey,
												Value: question.ResponseText != null ? question.ResponseText : 0,
												borderColor: '#ECDCA8'
											});
										} else if (question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion14_ShortDescription ||
											question.AssessmentQuestion.BI_PSP_shortQuestionText__c === this.BI_PSPB_ShortQuestion15_ShortDescription) {
											existingQuestion.months.push({
												Month: monthKey,
												Value: question.ResponseText != null ? question.ResponseText : 0,
												borderColor: '#926B45'
											});
										}
									}
									this.transformedData.push(existingQuestion);
								}
							}
						}
						if (this.transformedData.length > 0 && categoryvalues === this.BI_PSP_DLQI_ShortDescription) {
							let desiredQuestion = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_skinCondition_ShortDescription
							);
							this.dlqifirst.push(desiredQuestion);
							let desiredQuestion1 = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_skinQuestion_ShortDescription
							);
							this.dlqifirst.push(desiredQuestion1);

							let desiredQuestion2 = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_ShortQuestion1_ShortDescription
							);
							this.dlqisecond.push(desiredQuestion2);

							let desiredQuestion3 = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_ShortQuestion2_ShortDescription
							);
							this.dlqisecond.push(desiredQuestion3);

							let desiredQuestion4 = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_ShortQuestion3_ShortDescription
							);
							this.dlqisecond.push(desiredQuestion4);

							let desiredQuestion5 = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_ShortQuestion4_ShortDescription
							);
							this.dlqisecond.push(desiredQuestion5);

							let desiredQuestion6 = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_ShortQuestion5_ShortDescription
							);
							this.dlqithree.push(desiredQuestion6);
							this.dlqithree = this.dlqithree.filter(item => item !== null);
							if (this.dlqithree.length > 0) {
								if (this.dlqithree[0].value !== this.BI_PSP_SoftDelete_ShortDescription) {
									let desiredQuestion7 = this.transformedData.find(question =>
										question.Question === this.BI_PSPB_ShortQuestion6_ShortDescription
									);
									this.dlqifour.push(desiredQuestion7);
								}
							}
							let desiredQuestion8 = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_ShortQuestion7_ShortDescription
							);
							this.dlqifive.push(desiredQuestion8);

							let desiredQuestion9 = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_ShortQuestion8_ShortDescription
							);
							this.dlqifive.push(desiredQuestion9);

							let desiredQuestion10 = this.transformedData.find(question =>
								question.Question === this.BI_PSPB_ShortQuestion9_ShortDescription
							);
							this.dlqifive.push(desiredQuestion10);

							this.dlqifive = this.dlqifive.filter(item => item !== null);
							if (this.dlqifive.length > 0 && this.dlqifive !== null) {
								this.dlqishow5 = true;
								this.pssShow = false;
								this.wPAIShow = false;
								this.wpaiFirstshow = false;
								this.wpaiThirdshow = false;
							}
							this.dlqisecond = this.dlqisecond.filter(item => item !== null);
							if (this.dlqisecond.length > 0 && this.dlqisecond !== null) {
								this.dlqishow2 = true;
								this.pssShow = false;
								this.wPAIShow = false;
								this.wpaiFirstshow = false;
								this.wpaiThirdshow = false;
							}
							this.dlqifirst = this.dlqifirst.filter(item => item !== null);
							if (this.dlqifirst.length > 0 && this.dlqifirst !== null) {
								this.dlqishow1 = true;
								this.pssShow = false;
								this.wPAIShow = false;
								this.wpaiFirstshow = false;
								this.wpaiThirdshow = false;
							}
							this.dlqithree = this.dlqithree.filter(item => item !== null);
							if (this.dlqithree.length > 0 && this.dlqithree !== null) {
								this.dlqishow3 = true;
								this.pssShow = false;
								this.wPAIShow = false;
								this.wpaiFirstshow = false;
								this.wpaiThirdshow = false;
							}
							this.dlqifour = this.dlqifour.filter(item => item !== null);
							if (this.dlqifour.length > 0 && this.dlqifour !== null) {
								this.dlqishow4 = true;
								this.pssShow = false;
								this.wPAIShow = false;
								this.wpaiFirstshow = false;
								this.wpaiThirdshow = false;
							}

						} else
							if (this.transformedData.length > 0 && categoryvalues === this.BI_PSP_PSS_ShortDescription) {
								let desiredQuestion = this.transformedData.find(question =>
									question.Question === this.BI_PSPB_Pain_ShortDescription
								);
								this.pss.push(desiredQuestion);
								let desiredQuestion1 = this.transformedData.find(question =>
									question.Question === this.BI_PSPB_Redness_ShortDescription
								);
								this.pss.push(desiredQuestion1);
								let desiredQuestion2 = this.transformedData.find(question =>
									question.Question === this.BI_PSPB_Itching_ShortDescription
								);
								this.pss.push(desiredQuestion2);
								let desiredQuestion3 = this.transformedData.find(question =>
									question.Question === this.BI_PSPB_Burning_ShortDescription
								);
								this.pss.push(desiredQuestion3);
								this.pss = this.pss.filter(item => item !== null);
								if (this.pss.length > 0) {
									this.pssShow = true;
									this.dlqishow1 = false;
									this.dlqishow2 = false;
									this.dlqishow5 = false;
									this.dlqishow3 = false;
									this.dlqishow4 = false;
									this.wPAIShow = false;
									this.wpaiFirstshow = false;
									this.wpaiThirdshow = false;
								}
							} else
								if (this.transformedData.length > 0 && categoryvalues === this.BI_PSP_WapiCategory_ShortDescription) {
									let desiredQuestion = this.transformedData.find(question =>
										question.Question === this.BI_PSPB_ShortQuestion10_ShortDescription
									);
									this.wpaiFirst.push(desiredQuestion);
									let desiredQuestion1 = this.transformedData.find(question =>
										question.Question === this.BI_PSPB_ShortQuestion11_ShortDescription
									);
									this.wpaiSecond.push(desiredQuestion1);
									let desiredQuestion2 = this.transformedData.find(question =>
										question.Question === this.BI_PSPB_ShortQuestion15_ShortDescription
									);
									this.wpaiSecond.push(desiredQuestion2);
									let desiredQuestion3 = this.transformedData.find(question =>
										question.Question === this.BI_PSPB_ShortQuestion13_ShortDescription
									);
									this.wpaiSecond.push(desiredQuestion3);
									let desiredQuestion4 = this.transformedData.find(question =>
										question.Question === this.BI_PSPB_ShortQuestion12_ShortDescription
									);
									this.wpaiThird.push(desiredQuestion4);
									let desiredQuestion5 = this.transformedData.find(question =>
										question.Question === this.BI_PSPB_ShortQuestion14_ShortDescription
									);
									this.wpaiThird.push(desiredQuestion5);
									this.wpaiFirst = this.wpaiFirst.filter(item => item !== null);
									if (this.wpaiFirst.length > 0 && this.wpaiFirst !== null) {
										this.wpaiFirstshow = true;
										this.pssShow = false;
										this.dlqishow1 = false;
										this.dlqishow2 = false;
										this.dlqishow5 = false;
										this.dlqishow3 = false;
										this.dlqishow4 = false;
									}
									this.wpaiSecond = this.wpaiSecond.filter(item => item !== null);
									if (this.wpaiSecond.length > 0 && this.wpaiSecond !== null) {
										this.wPAIShow = true;
										this.pssShow = false;
										this.dlqishow1 = false;
										this.dlqishow2 = false;
										this.dlqishow5 = false;
										this.dlqishow3 = false;
										this.dlqishow4 = false;
									}
									this.wpaiThird = this.wpaiThird.filter(item => item !== null);
									if (this.wpaiThird.length > 0 && this.wpaiThird !== null) {
										this.wpaiThirdshow = true;
										this.pssShow = false;
										this.dlqishow1 = false;
										this.dlqishow2 = false;
										this.dlqishow5 = false;
										this.dlqishow3 = false;
										this.dlqishow4 = false;
									}
								}
						if (this.wPAIShow === true && this.wpaiSecond !== null) {
							this.lineChart();
						}
						if (this.wpaiThirdshow === true && this.wpaiThird !== null) {
							this.lineChart1();
						}
						//The setTimeout with a small delay ensures UI updates occur after the current rendering tasks, preventing glitches.
						setTimeout(() => {
							try {
								this.myFunction();
							}
							catch (error) {
								this.showToast(errormessage, error.message, errorvariant);
							}
						}, 2000);
					}
					else {
						this.showChart = false;
						this.gotData = false;
						this.assessmentResponse = null;
					}
				})
				.catch(error => {
					this.showChart = false;
					this.showToast(errormessage, error.message, errorvariant);
				})
		}
	}
	// Method to print the current window
	myFunction() {
		window.print();
	}
	// Method to load and render line chart
	lineChart() {
		loadScript(this, chartjs)
			.then(() => {
				this.renderLineChart();
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	// Method to load and render another line chart
	lineChart1() {
		loadScript(this, chartjs)
			.then(() => {
				this.renderLineChart1();
			})
			.catch(error => {
				this.showToast(errormessage, error.message, errorvariant);
			});
	}
	// Method to render line chart based on data
	renderLineChart1() {
		let canvas = this.template.querySelector('.line-chart1');
		let ctx = canvas.getContext(BI_PSPB_2d);
		let allMonths = [...new Set([].concat(...this.wpaiThird.map(question => question.months.map(month => month.Month))))];
		let datasets = this.wpaiThird.map(question => {
			return {
				/*label: question.Question,*/
				data: [null, ...allMonths.map(month => {
					let foundMonth = question.months.find(qMonth => qMonth.Month === month);
					return foundMonth ? foundMonth.Value : 0;
				}), null],
				borderColor: question.months[0].borderColor,
				fill: false
			};
		});
		let data = {
			labels: ['', ...allMonths, ''],
			datasets: datasets
		};
		const options = {
			legend: {
				display: false
			},
			scales: {
				yAxes: [
					{
						ticks: {
							stepSize: 2,
							min: 0,
							max: 10,
						},
					},
				],
			},

		};
		new window.Chart(ctx, {
			type: this.BI_PSP_line_ShortDescription,
			data: data,
			options: options
		});
		this.wpaiThird = [];
	}
	// Method to render line chart based on another set of data
	renderLineChart() {
		let canvas = this.template.querySelector('.line-chart');
		let ctx = canvas.getContext(BI_PSPB_2d);
		let allMonths = [...new Set([].concat(...this.wpaiSecond.map(question => question.months.map(month => month.Month))))];
		let datasets = this.wpaiSecond.map(question => {
			return {
				/*label: question.Question,*/
				data: [null, ...allMonths.map(month => {
					let foundMonth = question.months.find(qMonth => qMonth.Month === month);
					return foundMonth ? foundMonth.Value : 0;
				}), null],
				borderColor: question.months[0].borderColor,
				fill: false
			};
		});

		let data = {
			labels: ['', ...allMonths, ''],
			datasets: datasets
		};
		const options = {
			legend: {
				display: false
			},
			scales: {
				yAxes: [
					{
						ticks: {
							stepSize: 10,
							min: 0,
							max: 100,
						},
					},
				],
			},
		};

		new window.Chart(ctx, {
			type: this.BI_PSP_line_ShortDescription,
			data: data,
			options: options
		});
		this.wpaiSecond = [];
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