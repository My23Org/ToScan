/**
@description    Test class for the BI_PSPB_CreateCaseCtrl class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_CreateCaseCtrlTest {
	/**
	 * Test method for the createCase() method in the BI_PSPB_CreateCaseCtrl class.
	 */
	public static User testUser;
	public static Contact contactForPatient;
	static {
		//Create the test user

		testUser = new User(
			FirstName = 'Test',
			LastName = 'Account',
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
@description Test method to verify the behavior of createCase method.
*/
	@isTest
	static void testCreateCase() {
		// Create the Account record with the fetched Record Type Id
		System.runAs(testUser) {
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			Account testAccount = new Account(
				Name = 'Test Account',
				RecordTypeId = testRecordType.Id
			);
			insert testAccount;

			Account testAccountRecord = new Account(
				Name = 'Test Account',
				RecordTypeId = testRecordType.Id
			);
			insert testAccountRecord;
			CareProgram testCP = new CareProgram(Name = 'Spevigo');
			insert testCP;
			CareProgramEnrollee cpe = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpe;
			CareProgramEnrollee cpeo = new CareProgramEnrollee(
				AccountId = testAccountRecord.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpeo;
			String type = 'Medical Information Enquiry';
			String subType = 'Treatment';
			String description = 'Some Description';
			String patient = cpe.Id;

			System.runAs(testUser) {
				// Call the method being tested
				Test.startTest();
				Id newCaseId = BI_PSPB_CreateCaseCtrl.createCase(
					type,
					subType,
					description,
					patient
				);
				List<Case> leadRecord = [
					SELECT Id
					FROM Case
					WHERE Id = :newCaseId
				];
				assert.areEqual(
					1,
					leadRecord.size(),
					'Lead should have been created'
				);
				Test.stopTest();
			}
		}
	}
	/**
@description Test method to verify the behavior of createCase method.
*/
	@isTest
	static void testWrongCreateCase() {
		try {
			System.runAs(testUser) {
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create test data
				Account testAccount = new Account(
					Name = 'Test Account',
					RecordTypeId = testRecordType.Id
				);
				insert testAccount;
				Account testAccountRecord = new Account(
					Name = 'Test Account',
					RecordTypeId = testRecordType.Id
				);
				insert testAccountRecord;
				CareProgram testCP = new CareProgram(Name = 'Spevigo');
				insert testCP;
				CareProgramEnrollee cpe = new CareProgramEnrollee(
					AccountId = testAccount.Id,
					Name = 'Test Enrollee',
					CareProgramId = testCP.Id
				);
				insert cpe;
				CareProgramEnrollee cpeo = new CareProgramEnrollee(
					AccountId = testAccountRecord.Id,
					Name = 'Test Enrollee',
					CareProgramId = testCP.Id
				);
				insert cpeo;
				String type = 'MedicalInformationEnquiry';
				String subType = 'Treatmenttsss';
				String description = 'Some Description';
				String patient = cpe.Id;

				// Call the method being tested
				Test.startTest();
				Id newCaseId = BI_PSPB_CreateCaseCtrl.createCase(
					type,
					subType,
					description,
					patient
				);
				List<Case> leadRecord = [
					SELECT Id
					FROM Case
					WHERE Id = :newCaseId
				];
				assert.areEqual(
					1,
					leadRecord.size(),
					'Lead should have been created'
				);
				Test.stopTest();
			}
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of draftCase method.
*/
	@isTest
	static void testDraftCase() {
		System.runAs(testUser) {
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			// Create test data
			Account testAccount = new Account(
				Name = 'Test Account',
				RecordTypeId = testRecordType.Id
			);
			insert testAccount;
			Account testAccountRecord = new Account(
				Name = 'Test Account',
				RecordTypeId = testRecordType.Id
			);
			insert testAccountRecord;
			CareProgram testCP = new CareProgram(Name = 'Spevigo');
			insert testCP;
			CareProgramEnrollee cpe = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpe;
			CareProgramEnrollee cpeo = new CareProgramEnrollee(
				AccountId = testAccountRecord.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpeo;
			String type = 'Medical Information Enquiry';
			String subType = 'Treatment';
			String description = 'Some Description';
			String patient = cpe.Id;

			// Call the method being tested
			Test.startTest();
			Id newCaseId = BI_PSPB_CreateCaseCtrl.draftCase(
				type,
				subType,
				description,
				patient
			);
			List<Case> leadRecord = [
				SELECT Id
				FROM Case
				WHERE Id = :newCaseId
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead should have been created'
			);
			Test.stopTest();
		}
	}
	/**
@description Test method to verify the behavior of draftCase method.
*/
	@isTest
	static void testWrongDraftCase() {
		try {
			System.runAs(testUser) {
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create test data
				Account testAccount = new Account(
					Name = 'Test Account',
					RecordTypeId = testRecordType.Id
				);
				insert testAccount;
				Account testAccountRecord = new Account(
					Name = 'Test Account',
					RecordTypeId = testRecordType.Id
				);
				insert testAccountRecord;
				CareProgram testCP = new CareProgram(Name = 'Spevigo');
				insert testCP;
				CareProgramEnrollee cpe = new CareProgramEnrollee(
					AccountId = testAccount.Id,
					Name = 'Test Enrollee',
					CareProgramId = testCP.Id
				);
				insert cpe;
				CareProgramEnrollee cpeo = new CareProgramEnrollee(
					AccountId = testAccountRecord.Id,
					Name = 'Test Enrollee',
					CareProgramId = testCP.Id
				);
				insert cpeo;
				String type = 'MedicalInformationEnquiry';
				String subType = 'Treatmentttsss';
				String description = 'Some Description';
				String patient = cpe.Id;

				// Call the method being tested
				Test.startTest();
				Id newCaseId = BI_PSPB_CreateCaseCtrl.draftCase(
					type,
					subType,
					description,
					patient
				);
				List<Case> leadRecord = [
					SELECT Id
					FROM Case
					WHERE Id = :newCaseId
				];
				assert.areEqual(
					1,
					leadRecord.size(),
					'Lead should have been created'
				);
				Test.stopTest();
			}
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of draftCase method.
*/
	@isTest
	static void getCatchDraft() {
		try {
			System.runAs(testUser) {
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				Account testAccount = new Account(
					Name = 'Test Account',
					RecordTypeId = testRecordType.Id
				);
				insert testAccount;

				Test.startTest();
				BI_PSPB_CreateCaseCtrl.draftCase('', '', '', '');
				Test.stopTest();
			}
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of createCase method.
*/
	@isTest
	static void getCatchCreate() {
		try {
			System.runAs(testUser) {
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				Account testAccount = new Account(
					Name = 'Test Account',
					RecordTypeId = testRecordType.Id
				);
				insert testAccount;
				Test.startTest();
				BI_PSPB_CreateCaseCtrl.createCase('', '', '', '');
				Test.stopTest();
			}
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
@description Test method to verify the behavior of getPractitionerList method.
*/
	@isTest
	static void testGetPractitionerList() {
		try {
			System.runAs(testUser) {
				RecordType testRecordType = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account'
					LIMIT 1
				];
				// Create test data
				Account testAccount = new Account(
					Name = 'Test Account',
					RecordTypeId = testRecordType.Id
				);
				insert testAccount;
				Account testAccountRecord = new Account(
					Name = 'Test Account',
					RecordTypeId = testRecordType.Id
				);
				insert testAccountRecord;
				CareProgram testCP = new CareProgram(Name = 'Spevigo');
				insert testCP;
				CareProgramEnrollee cpe = new CareProgramEnrollee(
					AccountId = testAccount.Id,
					Name = 'Test Enrollee',
					CareProgramId = testCP.Id
				);
				insert cpe;
				CareProgramEnrollee cpeo = new CareProgramEnrollee(
					AccountId = testAccountRecord.Id,
					Name = 'Test Enrollee',
					CareProgramId = testCP.Id
				);
				insert cpeo;

				// Call the method to test
				Test.startTest();
				List<CareProgramEnrollee> enrollees = BI_PSPB_CreateCaseCtrl.getPractitionerList();
				List<CareProgramEnrollee> leadRecord = [
				SELECT Id
				FROM CareProgramEnrollee
				WHERE Id = :enrollees
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead should have been created'
			);
				Test.stopTest();
			}
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
}