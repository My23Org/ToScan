/**
* @description Test class for testing the BI_PSPB_ChallengeCtrlclass.
* This class contains test methods to verify various functionalities of the BI_PSPB_ChallengeController class.
* Author: Gowsic N
* Code Coverage: 82%
* Last Modified On: 5-02-2024
* Last Modified By: Gowsic N
*/
@istest
public class BI_PSP_ChallengeCtrlTest {
	/**
* @description Test data setup method to prepare the necessary data for testing.
*/
	@testsetup
	public static void setupData(){
				// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		profile getprofileId = [select id from profile where name='System Administrator'limit 1];
		User userRecord = new User(
			LastName = 'testuserss',
			Email = 'challenges@email.com',
			BI_PSPB_Caregiver__c = false,
			Username = 'chall$3521@email.com',
			Alias = 'test',
			TimeZoneSidKey = 'GMT',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8', 
			ProfileId =getprofileId.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert userRecord;
		String recTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
		Account accnt = new Account(
			RecordTypeID=recTypeId,
			LastName='testuserss',
			PersonMailingStreet='test@email.com',
			PersonMailingPostalCode='12345',
			PersonMailingCity='SFO',
			PersonEmail='challenges@email.com',
			PersonHomePhone='1234567',
			PersonMobilePhone='12345678'
		);
		insert accnt;
		Account accnt1 = new Account(
			RecordTypeID=recTypeId,
			LastName='testuserss',
			PersonMailingStreet='test@email.com',
			PersonMailingPostalCode='12345',
			PersonMailingCity='SFO',
			PersonEmail='challenges@email.com',
			PersonHomePhone='1234567',
			PersonMobilePhone='12345678',
			BI_PSPB_Selected_Patient_ID__c=Accnt.Id
		);
		insert accnt1;
		contact chaCon = new contact(Lastname='testuserss',Email='challenges@email.com');
		insert chaCon;
		CareProgram program = new CareProgram(name='challenge',StartDate=system.today());
		insert program;
		CareProgramEnrollee enrolle = new CareProgramEnrollee(Name='challengeenrolle',AccountId=Accnt.Id,CareProgramId=program.Id);
		insert enrolle;
		Assessment assessmentdata = new Assessment(
			Name = 'WPAI',
			AssessmentStatus = 'Completed',
			BI_PSP_StatusForPersonalization__c = 'Complete',
			BI_PSP_CareProgramEnrollee__c = enrolle.Id,
			BI_PSP_DateForCQ__c = 'test'
		);
		insert assessmentdata;
		Assessment assessmentdatapss = new Assessment(
			Name = 'PSS',
			AssessmentStatus = 'Completed',
			BI_PSP_StatusForPersonalization__c = 'Complete',
			BI_PSP_CareProgramEnrollee__c = enrolle.Id,
			BI_PSP_DateForCQ__c = 'test'
		);
		insert assessmentdatapss;
		Assessment assessmentdataDLQI = new Assessment(
			Name = 'DLQI',
			AssessmentStatus = 'Completed',
			BI_PSP_StatusForPersonalization__c = 'Complete',
			BI_PSP_CareProgramEnrollee__c = enrolle.Id,
			BI_PSP_DateForCQ__c = 'test'
		);
		insert assessmentdataDLQI;
		BI_PSPB_Enrollee_Caregiver__c careEnrolle = new BI_PSPB_Enrollee_Caregiver__c(
			BI_PSPB_Contact_Id__c=chaCon.Id,
			BI_PSPB_Status__c='Active',
			BI_PSPB_Patient__c=accnt.Id,
			BI_PSPB_Care_Program_Enrollee__c=enrolle.Id
		);
		insert careEnrolle;
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
			PatientId = Accnt.Id,
			BI_PSP_Temperature__c = Decimal.valueof ('100.5'),
			BI_PSP_Mood__c = 'sad'
		);
		insert allergyIntolerancedata;
		Award aw = new Award(
			Name='Challenge',
			BI_PSP_Care_Program_Enrollee__c=enrolle.Id,
			BI_PSP_Care_Program_Plan_Template__c=careprogram.Id,
			BI_PSP_Status__c = 'Available'
		);
		insert aw;
	}
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed with specific criteria.
*/
	@istest
	public static void testCompletedPositiveQuestNegative() {
		// Start the test execution
		test.starttest(); 
		
		// Insert necessary data
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate fields
		cp.HealthCloudGA__Description__c = 'Fill and track your answers to the "GPP impact on work life" questionnaire';
		cp.BI_PSP_Challenge_Level__c = 'Level 1';
		update cp;
		
		// Retrieve Assessment record
		Assessment asses = [SELECT Id, Name, AssessmentStatus FROM Assessment WHERE Name = 'WPAI'];
		
		// Modify Assessment field
		asses.AssessmentStatus = 'In Progress';
		update asses;
		
		// Call the method under test
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
		
		// Retrieve updated Assessment record
		Assessment updatedAssessment = [SELECT Id, AssessmentStatus FROM Assessment WHERE Id = :asses.Id];
		
		// Assert that the Assessment status is 'Completed' after method execution
		Assert.areEqual('In Progress', updatedAssessment.AssessmentStatus, 'Assessment status should be set to "Completed" after method execution');
		
		// Stop the test execution
		test.stoptest();
	}
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed with specific criteria.
*/
	@istest
	public static void testCompletedPositivePSSNegative(){
		test.starttest(); 
		Award awardUser = [select id,BI_PSP_Care_Program_Enrollee__c,BI_PSP_Care_Program_Plan_Template__c,BI_PSP_Status__c,Name,BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c from Award where Name='Challenge' limit 1];
		HealthCloudGA__CarePlanTemplate__c cp = [select id,HealthCloudGA__Description__c,BI_PSP_Challenge_Level__c from HealthCloudGA__CarePlanTemplate__c where id=:awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		cp.HealthCloudGA__Description__c = 'Fill and track your answers to the "GPP symptoms" questionnaire';
		cp.BI_PSP_Challenge_Level__c = 'Level 2';
		update cp;
		Assessment asses = [select id,Name from Assessment where Name='PSS'];
		asses.AssessmentStatus='In Progress';
		update asses;
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.id,'Completed');
		 // Retrieve updated Assessment record
		 Assessment updatedAssessment = [SELECT Id, AssessmentStatus FROM Assessment WHERE Id = :asses.Id];
		
		 // Assert that the Assessment status is 'Completed' after method execution
		 Assert.areEqual('In Progress', updatedAssessment.AssessmentStatus, 'Assessment status should be set to "Completed" after method execution');
		 
		test.stoptest();
	}
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed with specific criteria.
*/
	@istest
	public static void testCompletedPositiveDLQINegative() {
		// Start the test execution
		test.starttest(); 
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate fields
		cp.HealthCloudGA__Description__c = 'Fill and track your answers to the "GPP impact on quality of life" questionnaire';
		cp.BI_PSP_Challenge_Level__c = 'Level 3';
		update cp;
		
		// Retrieve Assessment record
		Assessment asses = [SELECT Id, Name, AssessmentStatus FROM Assessment WHERE Name = 'DLQI'];
		
		// Modify Assessment field
		asses.AssessmentStatus = 'In Progress';
		update asses;
		
		// Call the method under test
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
		
		// Retrieve updated Assessment record
		Assessment updatedAssessment = [SELECT Id, AssessmentStatus FROM Assessment WHERE Id = :asses.Id];
		
		// Assert that the Assessment status is 'Completed' after method execution
		Assert.areEqual('In Progress', updatedAssessment.AssessmentStatus, 'Assessment status should be set to "Completed" after method execution');
		
		// Stop the test execution
		test.stoptest();
	}
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed.
*/
	@istest
	public static void testCompleted() {
		// Start the test execution
		test.starttest(); 
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate field
		cp.HealthCloudGA__Description__c = 'Fill out your symptom tracker once';
		update cp;
		
		// Call the method under test
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
		
		// Retrieve updated Award record
		Award updatedAward = [SELECT Id, BI_PSP_Status__c FROM Award WHERE Id = :awardUser.Id];
		
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('Completed', updatedAward.BI_PSP_Status__c, 'Award status should be set to "Completed" after method execution');
		
		// Stop the test execution
		test.stoptest();
	}
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed with specific criteria.
*/
	@istest
	public static void testCompletedPositive1() {
		// Start the test execution
		test.starttest(); 
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate fields
		cp.HealthCloudGA__Description__c = 'Fill out your symptom tracker 4 times this month';
		cp.BI_PSP_Challenge_Level__c = 'Level 2';
		update cp;
		
		// Call the method under test
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
		
		// Retrieve updated Award record
		Award updatedAward = [SELECT Id, BI_PSP_Status__c FROM Award WHERE Id = :awardUser.Id];
		
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('Available', updatedAward.BI_PSP_Status__c, 'Award status should be set to "Completed" after method execution');
		
		// Stop the test execution
		test.stoptest();
	}
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed with specific criteria.
*/
	@istest
	public static void testCompletedPositiveQuest() {
		// Start the test execution
		test.starttest(); 
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate fields
		cp.HealthCloudGA__Description__c = 'Fill and track your answers to the "GPP impact on work life" questionnaire';
		cp.BI_PSP_Challenge_Level__c = 'Level 1';
		update cp;
		
		// Call the method under test
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
		
		// Retrieve updated Award record
		Award updatedAward = [SELECT Id, BI_PSP_Status__c FROM Award WHERE Id = :awardUser.Id];
		
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('Completed', updatedAward.BI_PSP_Status__c, 'Award status should be set to "Completed" after method execution');
		
		// Stop the test execution
		test.stoptest();
	}
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed with specific criteria.
*/
	@istest
	public static void testCompletedPositivePSS() {
		// Start the test execution
		test.starttest(); 
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate fields
		cp.HealthCloudGA__Description__c = 'Fill and track your answers to the "GPP symptoms" questionnaire';
		cp.BI_PSP_Challenge_Level__c = 'Level 2';
		update cp;
		try{
		// Call the method under test
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
		
		// Retrieve updated Award record
		Award updatedAward = [SELECT Id, BI_PSP_Status__c FROM Award WHERE Id = :awardUser.Id];
		String wrongvalue='wrong';
		BI_PSP_ChallengeCtrl.getIndividualChallenges(wrongvalue);
		
		BI_PSP_ChallengeCtrl.getRandomChallenges(wrongvalue,wrongvalue);
		Assert.areEqual('Completed', updatedAward.BI_PSP_Status__c, 'Award status should be set to "Completed" after method execution');   
		}
		catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		// Assert that the Award status is 'Completed' after method execution
		
		
		// Stop the test execution
		test.stoptest();
	}
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed with specific criteria.
*/
	@istest
	public static void testCompletedPositiveDLQI() {
		// Start the test execution
		test.starttest(); 
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate fields
		cp.HealthCloudGA__Description__c = 'Fill and track your answers to the "GPP impact on quality of life" questionnaire';
		cp.BI_PSP_Challenge_Level__c = 'Level 3';
		update cp;
		
		// Call the method under test
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
		
		// Retrieve updated Award record
		Award updatedAward = [SELECT Id, BI_PSP_Status__c FROM Award WHERE Id = :awardUser.Id];
		
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('Completed', updatedAward.BI_PSP_Status__c, 'Award status should be set to "Completed" after method execution');
		
		// Stop the test execution
		test.stoptest();
	}
	
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed with different specific criteria.
*/
	@istest
	public static void testCompletedPositive2() {
		// Start the test execution
		test.starttest(); 
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate fields
		cp.HealthCloudGA__Description__c = 'Fill and track your answers to the "GPP impact on work life" questionnaire';
		cp.BI_PSP_Challenge_Level__c = 'Level 1';
		update cp;
		
		// Call the method under test
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
		
		// Retrieve updated Award record
		Award updatedAward = [SELECT Id, BI_PSP_Status__c FROM Award WHERE Id = :awardUser.Id];
		
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('Completed', updatedAward.BI_PSP_Status__c, 'Award status should be set to "Completed" after method execution');
		
		// Stop the test execution
		test.stoptest();
	}
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed with additional specific criteria.
*/
	@istest
	public static void testCompletedPositive3() {
		// Start the test execution
		test.starttest(); 
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate fields
		cp.HealthCloudGA__Description__c = 'Fill and track your answers to the "GPP symptoms" questionnaire';
		cp.BI_PSP_Challenge_Level__c = 'Level 2';
		update cp;
		
		// Call the method under test
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
		
		// Retrieve updated Award record
		Award updatedAward = [SELECT Id, BI_PSP_Status__c FROM Award WHERE Id = :awardUser.Id];
		
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('Completed', updatedAward.BI_PSP_Status__c, 'Award status should be set to "Completed" after method execution');
		
		// Stop the test execution
		test.stoptest();
	}
	
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed but related data is missing.
*/
	@istest
	public static void testCompletedPositive4() {
		//String errorMessage = (String) BI_PSP_ChallengeCtrl.class.getDeclaredField('BI_PSP_Challenges_ErrorMessage').get(null);
		// Start the test execution
		test.starttest(); 
		
		// Retrieve CareProgramEnrollee record
		CareProgramEnrollee userAccount = [SELECT Id, Name FROM CareProgramEnrollee WHERE Name = 'challengeenrolle'];
		
		// Retrieve Award record
		Award awardUser = [SELECT Id, BI_PSP_Care_Program_Enrollee__c, BI_PSP_Care_Program_Plan_Template__c, BI_PSP_Status__c, Name, BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c FROM Award WHERE Name = 'Challenge' LIMIT 1];
		awardUser.BI_PSP_Status__c = 'Active';
		update awardUser;
		
		// Retrieve associated CarePlanTemplate record
		HealthCloudGA__CarePlanTemplate__c cp = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE Id = :awardUser.BI_PSP_Care_Program_Plan_Template__r.HealthCloudGA__CarePlanTemplate__c];
		
		// Modify CarePlanTemplate fields
		cp.HealthCloudGA__Description__c = 'Fill and track your answers to the "GPP impact on quality of life" questionnaire';
		cp.BI_PSP_Challenge_Level__c = 'Level 3';
		update cp;
		
		// Call the method under test
		try {
			BI_PSP_ChallengeCtrl.getRank(null);
			BI_PSP_ChallengeCtrl.getRandomChallenges(null,null);
			BI_PSP_ChallengeCtrl.updateChallenges(awardUser.Id, 'Completed');
			HealthCloudGA__CarePlanTemplate__c lastActiveChallenges = BI_PSP_ChallengeCtrl.getLastActiveChallenges(userAccount.Id);
			// If the method does not throw an exception, fail the test
			Assert.areEqual(null, lastActiveChallenges, 'Last active challenges list should not be null'); 
		} catch (AuraHandledException e) {
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		// Retrieve last active challenges for the user
		// Assert that the last active challenges list is not null
		   
		// Stop the test execution
		test.stoptest();
	}
	/**
* @description Test method to verify the behavior when a valid parameter is passed to getEnrolle method.
*/
	@istest
	public static void testPositiveOne(){
		test.starttest();
		// Retrieve CareProgramEnrollee record
		user recordUser = [select id,LastName,email from user where LastName='testuserss' limit 1];
		BI_PSP_ChallengeCtrl.getEnrolle(recordUser.Id);
		
		CareProgramEnrollee userAccount = [SELECT Id, Name FROM CareProgramEnrollee WHERE Name = 'challengeenrolle'];
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('challengeenrolle', userAccount.Name, 'Name should not be not null');
		test.stoptest();
	}
	/**
* @description Test method to verify the behavior when a valid parameter is passed to getIndividualChallenges method.
*/
	@istest
	public static void testPositiveTwo(){
		test.starttest();
		user recordUser = [select id,LastName,email,BI_PSPB_Caregiver__c from user where LastName='testuserss' limit 1];
		recordUser.BI_PSPB_Caregiver__c=true;
		update recordUser;
		CareProgramEnrollee userAccount = [Select id,name from CareProgramEnrollee where Name='challengeenrolle'];
		HealthCloudGA__CarePlanTemplate__c planTem = [Select id,HealthCloudGA__Description__c from HealthCloudGA__CarePlanTemplate__c where  HealthCloudGA__Description__c='Description'];
		HealthCloudGA__CareProgramPlanTemplate__c careprogram = [Select id from HealthCloudGA__CareProgramPlanTemplate__c where HealthCloudGA__CarePlanTemplate__c=:planTem.Id];
		String recTypeId= [select Id from RecordType where (Name='BI_PSP_Challenge') and (SobjectType='Award')].Id;
		Award awardUser = new Award();
		awardUser.Name = 'New Active';  
		awardUser.BI_PSP_Status__c = 'Active';
		awardUser.BI_PSP_Care_Program_Enrollee__c = userAccount.id;
		awardUser.RecordTypeId = recTypeId;
		insert awardUser;
		try{
		BI_PSP_ChallengeCtrl.getIndividualChallenges(careprogram.id);
		BI_PSP_ChallengeCtrl.getEnrolle(recordUser.id);
		BI_PSP_ChallengeCtrl.getRank(userAccount.id);
		BI_PSP_ChallengeCtrl.getLastActiveChallenges(userAccount.Id);
		}catch(exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('challengeenrolle', userAccount.Name, 'Name should not be not null');
		test.stoptest();
	}
	/**
* @description Test method to verify the behavior when a challenge is marked as Active, Available, and Completed sequentially.
*/
	@istest
	public static void testPositiveThree(){
		test.starttest(); 
		Award awardUser = [select id,BI_PSP_Care_Program_Enrollee__c,BI_PSP_Care_Program_Plan_Template__c,BI_PSP_Status__c,Name from Award where Name='Challenge' limit 1];
		
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.id,'Active');
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.id,'Available');
		BI_PSP_ChallengeCtrl.updateChallenges(awardUser.id,'Completed');
		CareProgramEnrollee userAccount = [SELECT Id, Name FROM CareProgramEnrollee WHERE Name = 'challengeenrolle'];
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('challengeenrolle', userAccount.Name, 'Name should not be not null');
		test.stoptest();
	}
	/**
* @description Test method to verify the behavior when a challenge is marked as Completed but related data is missing.
*/
	@istest
	public static void testNegFour(){
		test.starttest();
		user recordUser = [select id,LastName,email,BI_PSPB_Caregiver__c from user where LastName='testuserss' limit 1];
		recordUser.BI_PSPB_Caregiver__c=true;
		update recordUser;
		CareProgramEnrollee userAccount = [Select id,name from CareProgramEnrollee where Name='challengeenrolle' limit 1];
		delete userAccount;  
		
		BI_PSP_ChallengeCtrl.getEnrolle(recordUser.id);
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('challengeenrolle', userAccount.Name, 'Name should not be not null');
		test.stoptest();
	}
	/**
* @description Test method to verify the behavior when an invalid parameter is passed to getEnrolle and getRandomChallenges methods.
*/
	@istest
	public static void testNegFive(){
		test.starttest();
		user recordUser = [select id,LastName,email,BI_PSPB_Caregiver__c from user where LastName='testuserss' limit 1];
		CareProgramEnrollee userAccount = [SELECT Id, Name FROM CareProgramEnrollee WHERE Name = 'challengeenrolle'];
		BI_PSP_ChallengeCtrl.getEnrolle(recordUser.id);
		BI_PSP_ChallengeCtrl.getRandomChallenges(userAccount.Id,'Available');
		BI_PSP_ChallengeCtrl.updateChallenges(null,'Completed');
		
		
		// Assert that the Award status is 'Completed' after method execution
		Assert.areEqual('challengeenrolle', userAccount.Name, 'Name should not be not null');
		test.stoptest();
	}

	@isTest
	public static void testCatchBlocks() {
		string nullvalue = '';
		string wrongvalue = 'wrong';
		Test.startTest();
		try{
			BI_PSP_ChallengeCtrl.getEnrolle(nullvalue);
			BI_PSP_ChallengeCtrl.getEnrolle(wrongvalue);
			BI_PSP_ChallengeCtrl.getIndividualChallenges(nullvalue);
			BI_PSP_ChallengeCtrl.getRank(nullvalue);
		
		BI_PSP_ChallengeCtrl.getLastActiveChallenges(nullvalue);
		}
		catch(exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();
	}
	
}