/**
@description			This class contains test methods to verify the functionality of 
						methods related to BI_PSPB_InsertCaserecordforUpdateRx with
						valid and invalid inputs.
@author					Joyal christopher
@Last Modified On		04/23/2024
@Last Modified By		Joyal Christopher
*/
@isTest
public class BI_PSPB_InsertCaserecordforUpdateRxTest {
	// Constructor to create test data
	public static User testUser;
	public static Contact contactForPatient;
	static {
		//Create the test user
		testUser = new User(
			FirstName = 'Test',
			LastName = 'Patient',
			Email = 'testuser12@example.com',
			UserName = 'testuser12@example.com',
			BI_PSPB_Caregiver__c = false,
			Alias = 'tuser1',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
			]
			.Id
		);
		// Contact for patient user
		contactForPatient = new Contact(
			FirstName = testUser.FirstName,
			LastName = testUser.LastName,
			Email = testUser.Email
		);
		insert contactForPatient;
		testUser.ContactId = contactForPatient.Id;
		insert testUser;
	}
	/**
	 * @description The test method to Insert the CareProgramEnrollee
	 */
	@isTest
	static void testGetCareProgramEnrolleeIdPositive() {
		System.runAs(testUser) {
			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			// Retrieve the created record type Id
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			// Create test data
			Account testPatient = new Account(
				Name = 'Test Patient',
				RecordTypeId = testRecordType.Id
			);
			insert testPatient;
			// Create a Care Program record
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Care Program'
			);
			insert testCareProgram;
			/*Create a Care Program Enrollee record associated 
			with the patient and care program
			*/
			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testPatient.Id,
				CareProgramId = testCareProgram.Id,
				Name = 'Test Enrollee'
			);
			insert testCPE;
			Test.startTest();
			// Call the method to test
			Id resultId = BI_PSPB_InsertCaserecordforUpdateRx.getCareProgramEnrolleeId(
				testPatient.Id
			);
			Test.stopTest();
			// Assert the result
			// // Assert the result
			Assert.areEqual(
				true,
				resultId != null,
				'Care Program Enrollee Id should not be null when a valid Account Id is provided'
			);
		}
	}
	/**
 * @description The test method for Nagative scenario
 				Insert the CareProgramEnrollee
*/
	@isTest
	static void testGetCareProgramEnrolleeIdNegative() {
		try {
			System.runAs(testUser) {
				// Create mock BI_SFCOE_LOG_App_Settings__c record
				BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
					Name = 'PSPB',
					BI_SFCOE_LOG_Application__c = 'Spevigo'
				);
				insert settings;
				// Retrieve the created record type Id
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create test data
				Account testPatient = new Account(
					Name = 'Test Patient',
					RecordTypeId = testRecordType.Id
				);
				insert testPatient;
				// Create a Care Program record
				CareProgram testCareProgram = new CareProgram(
					Name = 'Test Care Program'
				);
				insert testCareProgram;
				/* Create a Care Program Enrollee record 
				associated with the patient and care program*/
				CareProgramEnrollee testCPE = new CareProgramEnrollee(
					AccountId = testPatient.Id,
					CareProgramId = testCareProgram.Id,
					Name = 'Test Enrollee'
				);
				insert testCPE;
				Test.startTest();
				// Call the method to test
				BI_PSPB_InsertCaserecordforUpdateRx.getCareProgramEnrolleeId(
				null
				);
				Test.stopTest();
			}
		} catch (Exception e) {
			/* While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
		/**
 * @description The test method to check the case record.
*/
	@isTest
	static void testGetCasesForPatientPositive() {
		System.runAs(testUser) {
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			// Create test data
			Account testPatientAccount = new Account(
				Name = 'Test Patient',
				RecordTypeId = testRecordType.Id
			);
			insert testPatientAccount;

			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Care Program'
			);
			insert testCareProgram;
			CareProgramEnrollee testCPE = new CareProgramEnrollee(
				AccountId = testPatientAccount.Id,
				CareProgramId = testCareProgram.Id,
				Name = 'Test Enrollee'
			);
			insert testCPE;
			// Call the method under test
			Test.startTest();
			List<Case> resultCases =
			BI_PSPB_InsertCaserecordforUpdateRx.getCasesForPatient(
				testPatientAccount.Id,
				'Open'
			);
			Test.stopTest();
			// Verify the results
			Assert.areEqual(
				0,
				resultCases.size(),
				'Expected zero open case for the patient account'
			);
		}
	}
/**
 * @description The test method to check the case record for negative scenario.
*/
	@isTest
	static void testGetCasesForPatientNegative() {
		try {
			System.runAs(testUser) {
				BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
					Name = 'ApplicationName',
					BI_SFCOE_LOG_Application__c = 'Spevigo'
				);
				insert settings;
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create a test account for the patient
				Account testPatientAccount = new Account(
					Name = 'Test Patient',
					RecordTypeId = testRecordType.Id
					// Add other required fields as needed
				);
				insert testPatientAccount;
				// Call the method under test with a null status value to trigger an exception
				Test.startTest();
				BI_PSPB_InsertCaserecordforUpdateRx.getCasesForPatient(
				testPatientAccount.Id,
				null
				);
			}
			Test.stopTest();
		} catch (Exception e) {
			/* While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
/**
 * @description The test method to check the case record Insertion.
*/
	@isTest
	static void testGetCaseRecordWithFiles() {
		System.runAs(testUser) {
			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			//Get Aaccount Record Type
			RecordType testRecordTypeForAccount = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			// Create account record
			Account acc = new Account(
				Name = 'Test Patient',
				RecordTypeId = testRecordTypeforAccount.Id
			);
			insert acc;
			//Get case record Type
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Case'
				LIMIT 1
			];
			// Create case record
			Case newCase = new Case(
				RecordTypeId = testRecordType.Id, // Assign the Record Type Id here
				AccountId = acc.Id
			);
			insert newCase;

			BI_PSPB_InsertCaserecordforUpdateRx.BI_PSPB_caseForUpdateRxWrapper
			caseRecord = 
			new BI_PSPB_InsertCaserecordforUpdateRx.BI_PSPB_caseForUpdateRxWrapper();
			caseRecord.eprescription = 'Yes';
			caseRecord.physicalCopy = 'Yes';
			caseRecord.prescriptionSentTo = 'test prescription';
			caseRecord.additionalComments = 'test comment';
			List<String> fileIds = new List<String>{ 'FileId1', 'FileId2' };
			Test.startTest();
			// Call the method to test
			BI_PSPB_InsertCaserecordforUpdateRx.getcaseRecordWithFiles(
				acc.Id,
				caseRecord,
				fileIds
			);
			Test.stopTest();
			List<Case> insertedCase = [
				SELECT
					Id,
					RecordTypeId,
					AccountId,
					BI_PSPB_e_prescription__c,
					BI_PSPB_physical_copy__c,
					BI_PSPB_prescription_sent_to__c,
					BI_PSPB_Additional_Comments__c
				FROM Case
				WHERE Id = :newCase.Id
			];
			Assert.areEqual(
				1,
				insertedCase.size(),
				'Expected zero open case for the patient account'
			);
		}
	}
/**
 * @description The test method to check the case record 
 				Insertion for negative scenario.
*/
	@isTest
	static void testGetCaseRecordWithFilesNegative() {
		try {
			System.runAs(testUser) {
				// Create mock BI_SFCOE_LOG_App_Settings__c record
				BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
					Name = 'ApplicationName',
					BI_SFCOE_LOG_Application__c = 'Spevigo'
				);
				insert settings;
				//Get Aaccount Record Type
				RecordType testRecordTypeForAccount = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create account record
				Account acc = new Account(
					Name = 'Test Patient',
					RecordTypeId = testRecordTypeforAccount.Id
				);
				insert acc;
				//Get case record Type
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Case'
					LIMIT 1
				];
				// Create case record
				Case newCase = new Case(
					RecordTypeId = testRecordType.Id, // Assign the Record Type Id here
					AccountId = acc.Id
				);
				insert newCase;
				BI_PSPB_InsertCaserecordforUpdateRx.BI_PSPB_caseForUpdateRxWrapper 
				caseRecord = 
				new BI_PSPB_InsertCaserecordforUpdateRx.BI_PSPB_caseForUpdateRxWrapper();
				caseRecord.eprescription = 'Yes';
				caseRecord.physicalCopy = 'Yes';
				caseRecord.prescriptionSentTo = 'test prescription';
				caseRecord.additionalComments = 'test comment';
				List<String> fileIds = new List<String>{ 'FileId1', 'FileId2' };
				Test.startTest();
				// Call the method to test
				BI_PSPB_InsertCaserecordforUpdateRx.getcaseRecordWithFiles(
					null,
					null,
					null
				);
				BI_PSPB_InsertCaserecordforUpdateRx.getcaseRecordWithFiles(
					null,
					caseRecord,
					fileIds
				);
				Test.stopTest();
			}
		} catch (Exception e) {
			/* While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
}