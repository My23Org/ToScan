/**
* @description Test class for BI_PSPB_GraphCtrl class.
* This test class is used for testing the functionality of the BI_PSPB_GraphController class, which is responsible for fetching values from Symptom Tracker and Questionnaire objects for chart.
* Author: Gowsic N
* Code Coverage: 86%
* Last Modified On: 5-02-2024
* Last Modified By: Gowsic N
*/
@istest
public class BI_PSP_GraphCtrlTest
{
	/**
* @description Test data setup method to prepare the necessary data for testing.
*/
	public Date dates = null;
	
	public String name = '';
	
	public String symptom = '';
	
	@testsetup
	public static void testdata()
	{
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		String recTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
		Account accountValue = new Account(
			RecordTypeID=recTypeId,
			LastName='testuserss',
			PersonMailingStreet='test@email.com',
			PersonMailingPostalCode='12345',
			PersonMailingCity='SFO',
			PersonEmail='challenges@email.com',
			PersonHomePhone='1234567',
			PersonMobilePhone='12345678'
		);
		insert accountValue;
		CareProgram program = new CareProgram(name='challenge',StartDate=system.today());
		insert program;
		CareProgramEnrollee enrolle = new CareProgramEnrollee(Name='challengeenrolle',AccountId=accountValue.Id,CareProgramId=program.Id);
		insert enrolle;
		
		Assessment assessmentdata = new Assessment(
			Name = 'Introduction',
			AssessmentStatus = 'In Progress',
			BI_PSP_StatusForPersonalization__c = 'Complete',
			BI_PSP_CareProgramEnrollee__c = enrolle.Id,
			BI_PSP_DateForCQ__c = 'test'
		);
		insert assessmentdata;
		
		AssessmentQuestion questiondata = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata;
		
		AssessmentQuestion questiondata2 = new AssessmentQuestion(
			Name = 'test questionname2',
			DeveloperName = 'Valid_Name_1293',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata2;
		
		AssessmentQuestionVersion questionversion2 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata2.id,
			QuestionText = 'What is your gender?',
			Name = 'test data2',
			IsActive = true
		);
		insert questionversion2;
		
		AssessmentQuestionResponse testResponse2 = new AssessmentQuestionResponse(
			ResponseText = 'Female',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion2.id,
			Name = 'test data'
		);
		insert testResponse2;
		
		AssessmentQuestionVersion questionversion = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata.id,
			QuestionText = 'I don’t feel like I am doing enough to stay healthy in terms of diet, exercise, etc.',
			Name = 'test data',
			IsActive = true
		);
		insert questionversion;
		
		AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
			ResponseText = 'Yes',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion.id,
			Name = 'test data'
		);
		insert testResponse;
		
		AssessmentQuestion questiondata3 = new AssessmentQuestion(
			Name = 'test questionname3',
			DeveloperName = 'Valid_Name_12393',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata3;
		
		AssessmentQuestionVersion questionversion3 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata3.id,
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			Name = 'test data3',
			IsActive = true
		);
		insert questionversion3;
		
		AssessmentQuestionResponse testResponse3 = new AssessmentQuestionResponse(
			ResponseText = 'No',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion3.id,
			Name = 'test data'
		);
		insert testResponse3;
		
		AssessmentQuestion questiondata4 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_12394',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata4;
		
		AssessmentQuestionVersion questionversion4 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata4.id,
			QuestionText = 'What aspects of your life have been affected by GPP?',
			Name = 'test data4',
			IsActive = true
		);
		insert questionversion4;
		
		AssessmentQuestionResponse testResponse4 = new AssessmentQuestionResponse(
			ResponseText = 'Relationships with friends and family,Relationship with Partner,Self Esteem',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion4.id,
			Name = 'test data'
		);
		insert testResponse4;
		
		AssessmentQuestion questiondata5 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_12395',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata5;
		
		AssessmentQuestionVersion questionversion5 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata5.id,
			QuestionText = 'Do you have other medical conditions?',
			Name = 'test data5',
			IsActive = true
		);
		insert questionversion5;
		
		AssessmentQuestionResponse testResponse5 = new AssessmentQuestionResponse(
			ResponseText = 'Yes',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion5.id,
			Name = 'test data'
		);
		insert testResponse5;
		
		AssessmentQuestion questiondata6 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_12396',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata6;
		
		AssessmentQuestionVersion questionversion6 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata6.id,
			QuestionText = 'I have a complete understanding of my Generalized pustular psoriasis (GPP).',
			Name = 'test data6',
			IsActive = true
		);
		insert questionversion6;
		
		AssessmentQuestionResponse testResponse6 = new AssessmentQuestionResponse(
			ResponseText = 'No',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion6.id,
			Name = 'test data'
		);
		insert testResponse6;
		
		AssessmentQuestion questiondata7 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_12397',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata7;
		
		AssessmentQuestionVersion questionversion7 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata7.id,
			QuestionText = 'I feel confident about recognizing GPP flares.',
			Name = 'test data7',
			IsActive = true
		);
		insert questionversion7;
		
		AssessmentQuestionResponse testResponse7 = new AssessmentQuestionResponse(
			ResponseText = 'No',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion7.id,
			Name = 'test data'
		);
		insert testResponse7;
		AssessmentQuestion questiondata8 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_12398',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata8;
		
		AssessmentQuestionVersion questionversion8 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata8.id,
			QuestionText = 'I can manage my GPP flares.',
			Name = 'test data8',
			IsActive = true
		);
		insert questionversion8;
		
		AssessmentQuestionResponse testResponse8 = new AssessmentQuestionResponse(
			ResponseText = 'No',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion8.id,
			Name = 'test data'
		);
		insert testResponse8;
		
		AssessmentQuestion questiondata9 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_12399',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata9;
		
		AssessmentQuestionVersion questionversion9 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata9.id,
			QuestionText = 'I have a complete understanding of Spevigo (spesolimab) and how it is used to treat my GPP',
			Name = 'test data9',
			IsActive = true
		);
		insert questionversion9;
		
		AssessmentQuestionResponse testResponse9 = new AssessmentQuestionResponse(
			ResponseText = 'No',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion9.id,
			Name = 'test data'
		);
		insert testResponse9;
		
		AssessmentQuestion questiondata10 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_1231010',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata10;
		
		AssessmentQuestionVersion questionversion10 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata10.id,
			QuestionText = 'I am not good at talking to my physician about my GPP.',
			Name = 'test data10',
			IsActive = true
		);
		insert questionversion10;
		
		AssessmentQuestionResponse testResponse10 = new AssessmentQuestionResponse(
			ResponseText = 'Yes',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion10.id,
			Name = 'test data'
		);
		insert testResponse10;
		
		AssessmentQuestion questiondata11 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_1231111',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata11;
		
		AssessmentQuestionVersion questionversion11 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata11.id,
			QuestionText = 'I rely only on my physician to manage my GPP.',
			Name = 'test data11',
			IsActive = true
		);
		insert questionversion11;
		
		AssessmentQuestionResponse testResponse11 = new AssessmentQuestionResponse(
			ResponseText = 'No',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion11.id,
			Name = 'test data'
		);
		insert testResponse11;
		
		AssessmentQuestion questiondata12 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_1231212',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata12;
		
		AssessmentQuestionVersion questionversion12 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata12.id,
			QuestionText = 'GPP is affecting my mental health (e.g. leading to depression and/or anxiety).',
			Name = 'test data12',
			IsActive = true
		);
		insert questionversion12;
		
		AssessmentQuestionResponse testResponse12 = new AssessmentQuestionResponse(
			ResponseText = 'Yes',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion12.id,
			Name = 'test data'
		);
		insert testResponse12;
		
		AssessmentQuestion questiondata13 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_1331313',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questiondata13;
		
		AssessmentQuestionVersion questionversion13 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata13.id,
			QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
			Name = 'test data13',
			IsActive = true
		);
		insert questionversion13;
		
		AssessmentQuestionResponse testResponse13 = new AssessmentQuestionResponse(
			ResponseText = 'No',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion13.id,
			Name = 'test data'
		);
		insert testResponse13;
		String recType= [select Id from RecordType where (Name='BI_PSP_Challenge') and (SobjectType='HealthCloudGA__CarePlanTemplate__c')].Id;
		HealthCloudGA__CarePlanTemplate__c careplanTemp = new HealthCloudGA__CarePlanTemplate__c(
			Name='challenge',
			recordtypeId=recType,
			HealthCloudGA__Description__c='Description',
			BI_PSP_Challenge_Level__c='Level 1',
			BI_PSP_Challenge_Reward_Points__c=30
		);
		insert careplanTemp;
		HealthCloudGA__CareProgramPlanTemplate__c careprogram = 
			new HealthCloudGA__CareProgramPlanTemplate__c(
				HealthCloudGA__CareProgram__c=program.Id,HealthCloudGA__CarePlanTemplate__c=careplanTemp.Id
			);
		insert careprogram;
		BI_PSP_Symptom_Tracker__c symptomdata = new BI_PSP_Symptom_Tracker__c(
			BI_PSP_EditEntrydates__c = System.Today(),
			BI_PSP_Recent_Activities__c = 'Stress',
			BI_PSP_Care_Program_Enrollee__c= enrolle.Id
		);
		insert symptomdata;
		AllergyIntolerance allergyIntolerancedata = new AllergyIntolerance(
			BI_PSP_Symptoms__c = careprogram.Id,
			BI_PSP_Symptom_Name__c = symptomdata.id,
			BI_PSP_Bodyparts__c = ' head',
			BI_PSP_Intensity__c =  10,
			PatientId = accountValue.Id,
			BI_PSP_Temperature__c = Decimal.valueof ('100.5'),
			BI_PSP_Mood__c = 'sad'
		);
		insert allergyIntolerancedata;
	}
	
	/**
* @description Test methd responsible for fetching values from Questionnaire.
*/
	@isTest
	public static void testPositive1() {
		
		// Retrieve CareProgramEnrollee record created in test setup
		CareProgramEnrollee enrollee = [SELECT Id FROM CareProgramEnrollee WHERE Name = 'challengeenrolle' LIMIT 1];
		Assessment assessmentdata = new Assessment(
			Name = 'Psoriasis Symptom Scale (PSS)',
			AssessmentStatus = 'Completed',
			BI_PSP_StatusForPersonalization__c = 'Complete',
			BI_PSP_CareProgramEnrollee__c = enrollee.Id,
			BI_PSP_DateForCQ__c = 'test'
		);
		insert assessmentdata;
		AssessmentQuestion questiondata13 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_13313134',
			DataType = 'Decimal',
			QuestionCategory = 'Psoriasis Symptom Scale (PSS)'
		);
		insert questiondata13;
		AssessmentQuestionVersion questionversion13 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata13.id,
			QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
			Name = 'Psoriasis Symptom Scale (PSS)',
			IsActive = true
		);
		insert questionversion13;
		
		AssessmentQuestionResponse testResponse12 = new AssessmentQuestionResponse(
			ResponseText = 'Yes',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion13.id,
			Name = assessmentdata.Name
		);
		insert testResponse12;
		
		Test.startTest();
		try{
		// Call the method under test
		BI_PSP_GraphCtrl.getQuestionnaireDetails(enrollee.Id, 'Psoriasis Symptom Scale (PSS)', 'Completed');
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();
	}
	
	@isTest
	static void testGetSymptomTrackerDetailsException() {
		Test.startTest();
		// Call the method with parameters that will cause an exception
		try{
		BI_PSP_GraphCtrl.getSymptomTrackerDetails('true', null, null);
		
		BI_PSP_GraphCtrl.getQuestionnaireDetails('false', '3', 'true');
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();
	}
	
	/**
* @description Test methd responsible for fetching values from Symptom Tracker.
*/
	@isTest
	public static void testPositive2() {
		
		Test.StartTest();
		// Retrieving CareProgramEnrollee record for testing
		CareProgramEnrollee userAccount = [Select id,name from CareProgramEnrollee where Name='challengeenrolle'];
		Date fdate = system.today()-1;
		Date ldate = system.today()+30;
		try{
		// Testing getSymptomTrackerDetails method with null inputs
		List<BI_PSP_GraphCtrl.SymptomTracker> result1 = BI_PSP_GraphCtrl.getSymptomTrackerDetails(null,null,null);
		System.assert(result1 == null || result1.size() == 0, 'Expecting null or empty list for null inputs');
		
		// Testing getSymptomTrackerDetails method with valid inputs
		List<BI_PSP_GraphCtrl.SymptomTracker> result2 = BI_PSP_GraphCtrl.getSymptomTrackerDetails(userAccount.id, fdate, ldate);
	   
		
		// Assert that the result list contains expected number of elements
		Assert.areEqual(1, result2.size(), 'Result list should contain one element');
		
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.StopTest();
	}
	
	
	@isTest
	static void testGetQuestionnaireLast() {
		
		// Create test data
		CareProgramEnrollee userAccount = [Select id,name from CareProgramEnrollee where Name='challengeenrolle'];
		List<Assessment> assessments = new List<Assessment>();
		assessments.add(new Assessment(/*BI_PSP_DateForCQ__c='Mar 2024',*/Name = 'Assessment 1',AssessmentStatus = 'Completed', BI_PSP_CareProgramEnrollee__c = userAccount.Id));
		assessments.add(new Assessment(/*BI_PSP_DateForCQ__c='Mar 2024',*/Name = 'Assessment 2',AssessmentStatus = 'Completed', BI_PSP_CareProgramEnrollee__c = userAccount.Id));
		insert assessments; 
		// Call the method being tested
		Test.startTest();
		try{
		BI_PSP_GraphCtrl.getQuestionnaireLast(userAccount.Id, 'Mar 2024');
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();
	}
	@isTest
	static void testGetQuestionnairePos() {
		// Retrieve CareProgramEnrollee record created in test setup
		CareProgramEnrollee enrollee = [SELECT Id FROM CareProgramEnrollee WHERE Name = 'challengeenrolle' LIMIT 1];
		Assessment assessmentdata = new Assessment(
			Name = 'Psoriasis Symptom Scale (PSS)',
			AssessmentStatus = 'Completed',BI_PSP_DateForCQ__c='Mar 2024',
			BI_PSP_StatusForPersonalization__c = 'Complete',
			BI_PSP_CareProgramEnrollee__c = enrollee.Id
		);
		insert assessmentdata;
		AssessmentQuestion questiondata13 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_13313134',
			DataType = 'Decimal',
			QuestionCategory = 'Psoriasis Symptom Scale (PSS)'
		);
		insert questiondata13;
		AssessmentQuestionVersion questionversion13 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata13.id,
			QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
			Name = 'Psoriasis Symptom Scale (PSS)',
			IsActive = true
		);
		insert questionversion13;
		
		AssessmentQuestionResponse testResponse12 = new AssessmentQuestionResponse(
			ResponseText = 'Yes',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion13.id,
			Name = assessmentdata.Name
		);
		insert testResponse12;
		
		Test.startTest();
		try{
		// Call the method under test
		BI_PSP_GraphCtrl.getQuestionnaireDetails(enrollee.Id, 'Psoriasis Symptom Scale (PSS)',  'Mar 2024');
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();
	}
		@isTest
	static void testGetQuestionnairePos1() {
		// Retrieve CareProgramEnrollee record created in test setup
		CareProgramEnrollee enrollee = [SELECT Id FROM CareProgramEnrollee WHERE Name = 'challengeenrolle' LIMIT 1];
		Assessment assessmentdata = new Assessment(
			Name = 'Psoriasis Symptom Scale (PSS)',
			AssessmentStatus = 'Completed',
			BI_PSP_StatusForPersonalization__c = 'Complete',
			BI_PSP_CareProgramEnrollee__c = enrollee.Id
		);
		insert assessmentdata;
		AssessmentQuestion questiondata13 = new AssessmentQuestion(
			Name = 'test questionname4',
			DeveloperName = 'Valid_Name_13313134',
			DataType = 'Decimal',
			QuestionCategory = 'Psoriasis Symptom Scale (PSS)'
		);
		insert questiondata13;
		AssessmentQuestionVersion questionversion13 = new AssessmentQuestionVersion(
			AssessmentQuestionId = questiondata13.id,
			QuestionText = 'I have required support at home from my family members and/or caregiver to manage my GPP condition.',
			Name = 'Psoriasis Symptom Scale (PSS)',
			IsActive = true
		);
		insert questionversion13;
		
		AssessmentQuestionResponse testResponse12 = new AssessmentQuestionResponse(
			ResponseText = 'Yes',
			BI_PSP_Category__c = '',
			AssessmentId = assessmentdata.id,
			AssessmentQuestionId = questionversion13.id,
			Name = assessmentdata.Name
		);
		insert testResponse12;
		
		Test.startTest();
		try{
		// Call the method under test
		BI_PSP_GraphCtrl.getQuestionnaireDetails(enrollee.Id, 'Psoriasis Symptom Scale (PSS)',  'Mar 2024');
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();
	}    
	@isTest
	static void testGetQuestionnaireLastPos() {
		
		// Create test data
		CareProgramEnrollee userAccount = [Select id,name from CareProgramEnrollee where Name='challengeenrolle'];
		List<Assessment> assessments = new List<Assessment>();
		assessments.add(new Assessment(BI_PSP_DateForCQ__c='Mar 2024',Name = 'Assessment 1',AssessmentStatus = 'Completed', BI_PSP_CareProgramEnrollee__c = userAccount.Id));
		assessments.add(new Assessment(BI_PSP_DateForCQ__c='Mar 2024',Name = 'Assessment 2',AssessmentStatus = 'Completed', BI_PSP_CareProgramEnrollee__c = userAccount.Id));
		insert assessments; 
		// Call the method being tested
		Test.startTest();
		try{
		BI_PSP_GraphCtrl.getQuestionnaireLast(userAccount.Id, 'Mar 2024');
		}Catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();
		// Assert the result
	}
}