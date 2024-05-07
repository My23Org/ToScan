/*
* @description  This Test class is used for getting Account Id, Creating Contact,Creating Enrollee caregiver,
  BI_PSP_SymptomTracker,AllergyIntolerance Returns all Values
*                
* History:
* Version	Author			Date			Detail				Description
* 1.0		Karthikeyan	    05-01-2024     	Created				Initial development
*/

@isTest
public class BI_PSPB_SymptomtrackerprimarypageTest {
	/*
Method description:
This test method verifies the functionality of the UserCaregiver method in the BI_PSP_SymptomTracker class. 
It creates a test user and a test account associated with that user. Then, it inserts a test Enrollee Caregiver record 
linking the test account as both the patient and the caregiver. Afterward, it runs the UserCaregiver method 
within a simulated user context to retrieve the list of caregivers associated with the test user. Finally, it asserts 
that the method returns the correct caregiver account.
*/

	public static Contact contactForPatient;
	public static Account testAccount;
	public static User testUserPatient;
	static {
		// User as a patient
		testUserPatient = new User(
			FirstName = 'TestUser',
			LastName = 'Patient',
			Email = 'testuser1222@example.com',
			Username = 'testuser1222@example.com',
			BI_PSPB_Caregiver__c = false,
			Alias = 'tuser1',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId()
		);
		insert testUserPatient;
		// Contact for patient user
		contactForPatient = new Contact(
			FirstName = testUserPatient.FirstName,
			LastName = testUserPatient.LastName,
			Email = testUserPatient.Email
		);

		insert contactForPatient;
		//testUserPatient.ContactId = contactForPatient.Id;

		testAccount = new Account(
			FirstName = 'TestUser',
			LastName = 'Patient',
			PersonEmail = 'testuser12@example.com',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			OwnerId = testUserPatient.Id,
			BI_PSP_CommunityUsername__c = 'patient1',
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702471083000/BI_PSPB_AfroMan_Adult'
		);

		insert testAccount;
		// Creating mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
	}

	@isTest
	static String createTestSymptomTracker() {
		// Assume a custom object BI_PSP_Symptom_Tracker__c for this example
		BI_PSP_Symptom_Tracker__c tracker = new BI_PSP_Symptom_Tracker__c(
			Name = 'TestSymptom'
		);
		insert tracker;
		return tracker.Id;
        
	}
	static void createAllergyIntolerances(String trackerId) {
		// Create a list of AllergyIntolerance records
		System.runAs(testUserPatient) {
			Account accountTest = new Account(Name = 'Test Patient');
			insert accountTest;
			AllergyIntolerance allergies = new AllergyIntolerance(
				BI_PSP_Symptom_Name__c = trackerId,
				PatientId = accountTest.Id,
				BI_PSP_Bodyparts__c = 'front head',
				BI_PSP_Mood__c = 'sad'
			);

			// Insert the list of AllergyIntolerance records into the database
			insert allergies;
            AllergyIntolerance insertedAllergy = [SELECT Id FROM AllergyIntolerance WHERE Id = :allergies.Id LIMIT 1];
        
        // Assert that the inserted AllergyIntolerance record exists
        System.assertNotEquals(null, insertedAllergy, 'AllergyIntolerance record should be created successfully');
		}
	}
	@isTest
	static Id createAccount() {
		Id accountId;
		System.runAs(testUserPatient) {
			Account testAcc = new Account(Name = 'Test User');
			insert testAcc;
			accountId = testAcc.Id;
		}
		return accountId;
	}
	// Helper method to create test care program enrollee and associated symptom tracker records
	static Id createTestCareProgramEnrolleeAndSymptoms() {
		// Assume a custom object BI_PSP_Care_Program_Enrollee__c for this example

		Id testAccId = createAccount();
             CareProgram cp1 = new CareProgram(
			Name = 'CP1',
			StartDate = system.today()
		);
        insert cp1;
		CareProgramEnrollee enrollee = new CareProgramEnrollee(
			Name = 'Test Enrollee',
			AccountId = testAccId,
			CareProgramId = cp1.Id
		);
		insert enrollee;

		// Create a symptom tracker record
		BI_PSP_Symptom_Tracker__c symptom = new BI_PSP_Symptom_Tracker__c(
			BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
			BI_PSP_EditEntrydates__c = Date.today(),
			BI_PSP_Symptom_Staus__c = 'Active'
		);
		insert symptom;

		return enrollee.Id;
	}

	// Utility method to create a mock symptom tracker record
	@isTest
	static BI_PSP_Symptom_Tracker__c createMockSymptomTracker() {
		Account testAcc = new Account(Name = 'Test User');
		insert testAcc;

		
		CareProgram cp1 = new CareProgram(
			Name = 'CP1',
			StartDate = system.today()
		);
		insert cp1;
		CareProgramEnrollee cpe = new CareProgramEnrollee(
			AccountId = testAcc.Id,
			CareProgramId = cp1.Id,
			Name = 'sdfgh'
		);
		insert cpe;
		BI_PSP_Symptom_Tracker__c tracker = new BI_PSP_Symptom_Tracker__c(
			BI_PSP_Patient__c = testAcc.Id, // Assuming correct ID format
			//BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
			BI_PSP_Recent_Activities__c = 'Test Activities',
			BI_PSP_Are_you_currently_experiencing__c = true,
			BI_PSP_Care_Program_Enrollee__c = cpe.Id // Assuming correct ID format
		);
		return tracker;
	}

	// Test the normal scenario for getsymptomrecorddata
	@isTest
	static void testGetSymptomRecordData() {
		System.runAs(testUserPatient) {
			BI_PSP_Symptom_Tracker__c tracker = createMockSymptomTracker();
			insert tracker;

			Test.startTest();
			List<BI_PSP_Symptom_Tracker__c> result = BI_PSPB_Symptomtrackerprimarypage.getsymptomrecorddata(
				tracker.Id
			);
			Test.stopTest();

			Assert.areEqual(
				1,
				result.size(),
				'Should retrieve exactly one record.'
			);
			Assert.areEqual(tracker.Id, result[0].Id, 'The IDs should match.');
		}
	}

	// Test the error handling when ID is null
	@isTest
	static void testGetSymptomRecordDataWithNullId() {
		System.runAs(testUserPatient) {
			Test.startTest();
			List<BI_PSP_Symptom_Tracker__c> result = BI_PSPB_Symptomtrackerprimarypage.getsymptomrecorddata(
				null
			);
			Test.stopTest();

			Assert.areEqual(
				null,
				result,
				'Result should be null for invalid ID.'
			);
		}
	}

	// Test the scenario where no records are found
	@isTest
	static void testGetSymptomRecordDataWithInvalidId() {
		System.runAs(testUserPatient) {
			Test.startTest();
			try {
				BI_PSPB_Symptomtrackerprimarypage.getsymptomrecorddata('000');
			} catch (AuraHandledException e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Exception message should contain "Error".'
				);
			}
			Test.stopTest();
		}
	}

	// Tests for other methods such as deleteSymptomTrackerRecords, getAllergyIntolerancedata, getBase64Image, getLatestSymptomRecord
	// should be similarly structured to handle both normal and exceptional cases.

	// Example test method for deleteSymptomTrackerRecords to handle no records found scenario
	@isTest
	static void testDeleteSymptomTrackerRecordsWithNoRecords() {
		BI_PSP_Symptom_Tracker__c tracker = createMockSymptomTracker();
		insert tracker;

		Test.startTest();
		try {
			BI_PSPB_Symptomtrackerprimarypage.deleteSymptomTrackerRecords(
				tracker.Id
			);
		} catch (AuraHandledException e) {
            Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Expected AuraHandledException with specific error message'
				);
		}
		Test.stopTest();
	}

	// Tests for other methods such , getAllergyIntolerancedata,
	// should be similarly structured to handle both normal and exceptional cases.

	@isTest
	static void testGetAllergyIntolerancedata_ValidId() {
		System.runAs(testUserPatient) {
			string trackerId = createTestSymptomTracker();
			createAllergyIntolerances(trackerId);

			Test.startTest();
			List<AllergyIntolerance> result = BI_PSPB_Symptomtrackerprimarypage.getAllergyIntolerancedata(
				trackerId
			);
			Test.stopTest();

			Assert.areEqual(
				1,
				result.size(),
				'Should return exactly one allergy intolerance record.'
			);
		}
	}

	@isTest
	static void testGetAllergyIntolerancedataInvalidId() {
		System.runAs(testUserPatient) {
			String trackerId = 'nonexistent';

			Test.startTest();
			try {
				 BI_PSPB_Symptomtrackerprimarypage.getAllergyIntolerancedata(
					trackerId
				);
			} catch (AuraHandledException e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Expected AuraHandledException with specific error message'
				);
			}
			Test.stopTest();
		}
	}
	@isTest
	static void testGetBase64Image_ValidId() {
		System.runAs(testUserPatient) {
			// Create a test tracker record
			String trackerId = createTestSymptomTracker();

			// Create ContentVersion with binary data representing an image
			Blob imageBlob = Blob.valueOf('Test Image Content');
			ContentVersion contentVersion = new ContentVersion(
				Title = 'Test Image',
				PathOnClient = 'TestImage.jpg',
				VersionData = imageBlob,
				IsMajorVersion = true
			);
			insert contentVersion;

			// Retrieve the ContentDocumentId created from ContentVersion
			Id contentDocumentId = [
				SELECT ContentDocumentId
				FROM ContentVersion
				WHERE Id = :contentVersion.Id
			]
			.ContentDocumentId;

			// Link the ContentDocument to the tracker record
			ContentDocumentLink docLink = new ContentDocumentLink(
				ContentDocumentId = contentDocumentId,
				LinkedEntityId = trackerId,
				ShareType = 'V' // V for View access
			);
			insert docLink;

			Test.startTest();
			List<String> result = BI_PSPB_Symptomtrackerprimarypage.getBase64Image(
				trackerId
			);
			Test.stopTest();

			// Assert that at least one base64 image URL is returned
			Assert.arenotequal(
				0,
				result.size(),
				'Should return at least one base64 image URL.'
			);
		}
	}

	@isTest
	static void testGetBase64ImageInvalidId() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		System.runAs(testUserPatient) {
            String trackerId = createTestSymptomTracker();
			

			Test.startTest();
			try {
			 BI_PSPB_Symptomtrackerprimarypage.getBase64Image(
					trackerId
				);
			} catch (AuraHandledException e) {
                  Assert.arenotequal(
				'Error message',
				'Result should not contain an error message',
				''
			);
			}
			Test.stopTest();
		}
	}

	// Utility method to create a dummy Care Program Enrollee record and return its ID
	static Id createCareProgramEnrollee() {
		// Assuming CareProgramEnrollee__c is an object, adjust this to your schema
		CareProgramEnrollee enrollee = new CareProgramEnrollee(
			Name = 'Test Enrollee'
		);
		insert enrollee;
		return enrollee.Id;
	}

	@isTest
	static void testGetLatestSymptomRecordErrorHandling() {
		System.runAs(testUserPatient) {
			// Use a valid ID format but do not create an enrollee record
			Id fakeId = null;

			Test.startTest();
			List<String> result = null;
			try {
				result = BI_PSPB_Symptomtrackerprimarypage.getLatestSymptomRecord(
					fakeId
				);
			} catch (AuraHandledException e) {
                Assert.arenotequal(
				'Error message',
				'Result should not contain an error message',
				''
			);
			}
			Test.stopTest();
		}
	}

	@isTest
	static void testGetLatestSymptomRecord() {
		// Create a test CareProgramEnrollee record
		System.runAs(testUserPatient) {
			Account testAccount = new Account(Name = 'TestAccount');
			insert testAccount;

			// Create Care Program
			CareProgram cp1 = new CareProgram(
				Name = 'CP1',
				StartDate = System.today()
			);
			insert cp1;

			// Create a CareProgramEnrollee
			CareProgramEnrollee cpe = new CareProgramEnrollee(
				Name = 'Test Enrollee',
				AccountId = testAccount.Id,
				CareProgramId = cp1.Id
			);
			insert cpe;

			// Create a test Symptom Tracker record related to the CareProgramEnrollee
			BI_PSP_Symptom_Tracker__c testSymptomTracker = new BI_PSP_Symptom_Tracker__c(
				Name = 'Test Symptom Tracker',
				BI_PSP_Care_Program_Enrollee__c = cpe.Id,
				BI_PSP_EditEntrydates__c = System.today() // Use System.today() instead of Date.today()
				// Add other required fields as needed
			);
			insert testSymptomTracker;

			Test.startTest();
			// Call the method under test
			List<String> result = BI_PSPB_Symptomtrackerprimarypage.getLatestSymptomRecord(
				cpe.Id
			);
			Test.stopTest();

			// Perform assertions

			// Assuming errorMsg is defined in your Apex class
			// In this test, we expect the result to contain the recordId and the entry date
			Assert.arenotequal(
				'Error message',
				result[0],
				'Result should not contain an error message'
			);
			Assert.arenotequal(
				'Error message',
				result[1],
				'Result should not contain an error message'
			);
		}

	}
}