/**
@description    Test class for the BI_PSPB_supportCaseCreate class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_supportCaseCreateTest {
	/**
	 *@description Test method to validate the createCase functionality.
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

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
	}
	/**
	 *@description Test method to validate the createCase functionality.
	 */
	@isTest
	static void testCreateCase() {
		try {
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			// Create test data
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			Account testNewAccount = new Account(
				Name = 'Test Account',
				RecordTypeId = testRecordType.Id
			);
			insert testNewAccount;
			CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
			insert testCP;
			CareProgramEnrollee cpe = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpe;
			CareProgramEnrollee cpeo = new CareProgramEnrollee(
				AccountId = testNewAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpeo;
			//List<String> fileIds = new List<String>();
			List<ContentVersion> testFiles = new List<ContentVersion>();
			for (Integer i = 0; i < 3; i++) {
				ContentVersion file = new ContentVersion(
					Title = 'Test File ' + i,
					PathOnClient = 'TestPathOnClient' + i + '.txt',
					VersionData = Blob.valueOf('Test File Content ' + i)
				);
				testFiles.add(file);
			}
			insert testFiles;

			// Call the method to be tested
			List<String> fileIds = new List<String>();
			for (ContentVersion file : testFiles) {
				fileIds.add(file.ContentDocumentId);
			}
			BI_PSPB_supportCaseCreate.LeadWrapper supportWrapper = new BI_PSPB_supportCaseCreate.LeadWrapper();
			supportWrapper.accountId = cpe.Id;
			supportWrapper.type = 'Medical Information Enquiry';
			supportWrapper.subType = 'Treatment';
			supportWrapper.description = 'description';
			// Call the method to be tested
			Test.startTest();
			Id caseId = BI_PSPB_supportCaseCreate.createCase(
				supportWrapper,
				fileIds
			);
			BI_PSPB_supportCaseCreate.caseDraft(supportWrapper, fileIds);
			BI_PSPB_supportCaseCreate.updateCase(
				caseId,
				'Medical Information Enquiry',
				'Updated Description',
				fileIds
			);
			List<Case> caseMedRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsMedical(
				cpe.Id
			);
			List<Case> caseRepRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsReport(
				cpe.Id
			);
			List<Case> casePlatformRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsPlatformSupport(
				cpe.Id
			);
			assert.areEqual(
				1,
				caseMedRecords.size(),
				'Case should have been created'
			);
			assert.areEqual(
				1,
				caseRepRecords.size(),
				'Case should have been created'
			);
			assert.areEqual(
				1,
				casePlatformRecords.size(),
				'Case should have been created'
			);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of createCase method.
	 */
	@isTest
	static void testCreateCaseFailed() {
		try {
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			// Create test data
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			Account testNewAccount = new Account(
				Name = 'Test Account',
				RecordTypeId = testRecordType.Id
			);
			insert testNewAccount;
			CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
			insert testCP;
			CareProgramEnrollee cpe = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpe;
			CareProgramEnrollee cpeo = new CareProgramEnrollee(
				AccountId = testNewAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpeo;
			List<ContentVersion> testFiles = new List<ContentVersion>();
			for (Integer i = 0; i < 3; i++) {
				ContentVersion file = new ContentVersion(
					Title = 'Test File ' + i,
					PathOnClient = 'TestPathOnClient' + i + '.txt',
					VersionData = Blob.valueOf('Test File Content ' + i)
				);
				testFiles.add(file);
			}
			insert testFiles;
			// Call the method to be tested
			List<String> fileIds = new List<String>();
			for (ContentVersion file : testFiles) {
				fileIds.add(file.ContentDocumentId);
			}
			BI_PSPB_supportCaseCreate.LeadWrapper supportWrapper = new BI_PSPB_supportCaseCreate.LeadWrapper();
			supportWrapper.accountId = cpe.Id;
			supportWrapper.type = 'Medical Information Enquiryyyyyy';
			supportWrapper.subType = 'Treatment';
			supportWrapper.description = 'description';
			// Call the method to be tested
			Test.startTest();
			Id caseId = BI_PSPB_supportCaseCreate.createCase(
				supportWrapper,
				fileIds
			);
			List<Case> leadRecord = [
				SELECT Id
				FROM Case
				WHERE Id = :caseId
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Case should have been created'
			);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of UpdateCase method.
	 */
	@isTest
	static void testUpdateCase() {
		try {
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			// Create test data
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			Account testNewAccount = new Account(
				Name = 'Test Account',
				RecordTypeId = testRecordType.Id
			);
			insert testNewAccount;
			CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
			insert testCP;
			CareProgramEnrollee cpe = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpe;
			Case caseupdate = new Case(
				BI_PSP_Patient__c = cpe.Id,
				BI_PSP_Type__c = 'Medical Information Enquiry',
				BI_PSPB_Sub_Type__c = 'Treatment',
				Status = 'Submitted'
			);
			insert caseUpdate;
			CareProgramEnrollee cpeo = new CareProgramEnrollee(
				AccountId = testNewAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpeo;
			List<ContentVersion> testFiles = new List<ContentVersion>();
			for (Integer i = 0; i < 3; i++) {
				ContentVersion file = new ContentVersion(
					Title = 'Test File ' + i,
					PathOnClient = 'TestPathOnClient' + i + '.txt',
					VersionData = Blob.valueOf('Test File Content ' + i)
				);
				testFiles.add(file);
			}
			insert testFiles;
			// Call the method to be tested
			List<String> fileIds = new List<String>();
			for (ContentVersion file : testFiles) {
				fileIds.add(file.ContentDocumentId);
			}
			BI_PSPB_supportCaseCreate.LeadWrapper supportWrapper = new BI_PSPB_supportCaseCreate.LeadWrapper();
			supportWrapper.accountId = cpe.Id;
			supportWrapper.type = 'Medical Information Enquiry';
			supportWrapper.subType = 'Treatment';
			supportWrapper.description = 'description';
			// Call the method to be tested
			Test.startTest();
			BI_PSPB_supportCaseCreate.updateCase(
				caseUpdate.Id,
				'Medical Information Enquiry',
				'Updated Description',
				fileIds
			);
			List<Case> caseMedRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsMedical(
				cpe.Id
			);
			List<Case> caseRepRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsReport(
				cpe.Id
			);
			List<Case> casePlatformRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsPlatformSupport(
				cpe.Id
			);
			assert.areEqual(
				1,
				caseMedRecords.size(),
				'Case should have been created'
			);
			assert.areEqual(
				1,
				caseRepRecords.size(),
				'Case should have been created'
			);
			assert.areEqual(
				1,
				casePlatformRecords.size(),
				'Case should have been created'
			);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of caseDraft method.
	 */
	@isTest
	static void testDraftCase() {
		try {
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			// Create test data
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			Account testNewAccount = new Account(
				Name = 'Test Account',
				RecordTypeId = testRecordType.Id
			);
			insert testNewAccount;
			CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
			insert testCP;
			CareProgramEnrollee cpe = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpe;
			CareProgramEnrollee cpeo = new CareProgramEnrollee(
				AccountId = testNewAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpeo;
			List<ContentVersion> testFiles = new List<ContentVersion>();
			for (Integer i = 0; i < 3; i++) {
				ContentVersion file = new ContentVersion(
					Title = 'Test File ' + i,
					PathOnClient = 'TestPathOnClient' + i + '.txt',
					VersionData = Blob.valueOf('Test File Content ' + i)
				);
				testFiles.add(file);
			}
			insert testFiles;
			// Call the method to be tested
			List<String> fileIds = new List<String>();
			for (ContentVersion file : testFiles) {
				fileIds.add(file.ContentDocumentId);
			}
			BI_PSPB_supportCaseCreate.LeadWrapper supportWrapper = new BI_PSPB_supportCaseCreate.LeadWrapper();
			supportWrapper.accountId = cpe.Id;
			supportWrapper.type = 'Medical Information Enquiry';
			supportWrapper.subType = 'Treatment';
			supportWrapper.description = 'description';
			// Call the method to be tested
			Test.startTest();
			BI_PSPB_supportCaseCreate.caseDraft(supportWrapper, fileIds);
			List<Case> caseMedRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsMedical(
				cpe.Id
			);
			List<Case> caseRepRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsReport(
				cpe.Id
			);
			List<Case> casePlatformRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsPlatformSupport(
				cpe.Id
			);
			assert.areEqual(
				1,
				caseMedRecords.size(),
				'Case should have been created'
			);
			assert.areEqual(
				1,
				caseRepRecords.size(),
				'Case should have been created'
			);
			assert.areEqual(
				1,
				casePlatformRecords.size(),
				'Case should have been created'
			);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of updateCase method.
	 */
	@isTest
	static void getCatchDraft() {
		try {
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
			BI_PSPB_supportCaseCreate.updateCase('', '', '', null);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of getPSPCaseRecordsMedical method.
	 */
	@isTest
	static void getCatchGetMedical() {
		try {
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
			BI_PSPB_supportCaseCreate.getPSPCaseRecordsMedical('qwqwwwqwqw');
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of getPSPCaseRecordsReport method.
	 */
	@isTest
	static void getCatchGetReport() {
		try {
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
			BI_PSPB_supportCaseCreate.getPSPCaseRecordsReport('qwqwwwqwqw');
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of getPSPCaseRecordsPlatformSupport method.
	 */
	@isTest
	static void getCatchGetPlatform() {
		try {
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
			BI_PSPB_supportCaseCreate.getPSPCaseRecordsPlatformSupport(
				'qwqwwwqwqw'
			);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of linkFilesToCase method.
	 */
	@isTest
	static void testlinkFilesToCase() {
		try {
			Test.startTest();
			BI_PSPB_supportCaseCreate.linkFilesToCase(null, null);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	@isTest
	static void testcaseDraft() {
		try {
			Test.startTest();
			BI_PSPB_supportCaseCreate.caseDraft(null, null);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of getPSPCaseRecordsMedical method.
	 */
	@isTest
	static void testgetPSPCaseRecordsMedicalNull() {
		try {
			Test.startTest();
			BI_PSPB_supportCaseCreate.getPSPCaseRecordsMedical(null);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Test method to verify the behavior of getPSPCaseRecordsMedical method.
	 */
	@isTest
	static void testDraftMedical() {
		try {
			RecordType testRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account'
				LIMIT 1
			];
			// Create test data
			Account testAccount = new Account(Name = 'Test Account');
			insert testAccount;
			Account testNewAccount = new Account(
				Name = 'Test Account',
				RecordTypeId = testRecordType.Id
			);
			insert testNewAccount;
			CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
			insert testCP;
			CareProgramEnrollee cpe = new CareProgramEnrollee(
				AccountId = testAccount.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCP.Id
			);
			insert cpe;
			Case cs = new Case(
				BI_PSP_Patient__c = cpe.Id,
				BI_PSP_Type__c = 'Medical Information Enquiry',
				BI_PSPB_Sub_Type__c = 'Treatment',
				Description = 'Description',
				Status = 'Draft'
			);
			insert cs;
			List<ContentVersion> testFiles = new List<ContentVersion>();
			for (Integer i = 0; i < 3; i++) {
				ContentVersion file = new ContentVersion(
					Title = 'Test File ' + i,
					PathOnClient = 'TestPathOnClient' + i + '.txt',
					VersionData = Blob.valueOf('Test File Content ' + i)
				);
				testFiles.add(file);
			}
			insert testFiles;
			// Call the method to be tested
			List<String> fileIds = new List<String>();
			for (ContentVersion file : testFiles) {
				fileIds.add(file.ContentDocumentId);
			}
			BI_PSPB_supportCaseCreate.LeadWrapper supportWrapper = new BI_PSPB_supportCaseCreate.LeadWrapper();
			supportWrapper.accountId = cpe.Id;
			supportWrapper.type = 'Medical Information Enquiry';
			supportWrapper.subType = 'Treatment';
			supportWrapper.description = 'description';
			// Call the method to be tested
			Test.startTest();
			List<Case> caseMedRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsMedical(
				cpe.Id
			);
			List<Case> caseRepRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsReport(
				cpe.Id
			);
			List<Case> casePlatformRecords = BI_PSPB_supportCaseCreate.getPSPCaseRecordsPlatformSupport(
				cpe.Id
			);
			assert.areEqual(
				0,
				caseMedRecords.size(),
				'Case should have been created'
			);
			assert.areEqual(
				0,
				caseRepRecords.size(),
				'Case should have been created'
			);
			assert.areEqual(
				0,
				casePlatformRecords.size(),
				'Case should have been created'
			);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
}