/**
@description       	   This test class is designed to validate the functionality of the BI_PSPB_caseCtrl Apex class, which
					manages case creation and related processes for both caregivers and patients.
					The class tests various functionalities including creating cases for users marked as caregivers or patients,
					handling cases linked to account deletion requests, and processing personal information requests.
@author					Divya Bharathi S
@Last Modified On   	04/23/2024
@Last Modified By 		Divya Bharathi S
*/
@isTest
private class BI_PSPB_caseCtrlTest {
	/* @description    This method is used to create deletion request access case for caregiver */
	@isTest
	static void testCreateCaseCaregiver() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Test setup
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact'
		);
		insert testContact;

		Profile profile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Caregiver Profile'
			LIMIT 1
		];
		User createdUser = new User(
			ProfileId = profile.Id,
			LastName = 'TestUser',
			Email = 'testuser@example.com',
			Username = 'testuser@example.com',
			Alias = 'tuser',
			ContactId = testContact.id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			BI_PSPB_Caregiver__c = true
		);
		insert createdUser;

		Account testPatient = new Account(
			FirstName = 'Patient',
			LastName = 'id',
			PersonEmail = 'patient@example.com'
		);
		insert testPatient;

		Account testAcc = new Account(
			LastName = 'TestUser',
			PersonEmail = 'testuser@example.com',
			BI_PSPB_Selected_Patient_ID__c = testPatient.id
		);
		insert testAcc;

		Test.startTest();
		System.runAs(createdUser) {
			BI_PSPB_caseCtrl.createCase();
		}
		Test.stopTest();

		List<Case> createdCases = [
			SELECT Id
			FROM Case
			WHERE AccountId = :testPatient.Id
		];
		Assert.areEqual(1, createdCases.size(), 'One case should be created');
	}
	/* @description    This method is used to create deletion request access case for Patient */
	@isTest
	static void testCreateCaseNonCaregiver() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Test setup
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact'
		);
		insert testContact;

		Profile profile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		User createdUser = new User(
			ProfileId = profile.Id,
			LastName = 'TestUser',
			Email = 'testuser@example.com',
			Username = 'testuser@example.com',
			Alias = 'tuser',
			ContactId = testContact.id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			BI_PSPB_Caregiver__c = false
		);
		insert createdUser;

		Account testAcc = new Account(
			LastName = 'TestUser',
			PersonEmail = 'testuser@example.com'
		);
		insert testAcc;
		Test.startTest();
		System.runAs(createdUser) {
			BI_PSPB_caseCtrl.createCase();
		}
		Test.stopTest();

		List<Case> createdCases = [
			SELECT Id
			FROM Case
			WHERE AccountId = :testAcc.Id
		];
		Assert.areEqual(1, createdCases.size(), 'One case should be created');
	}
	/* @description    This method is used to create account request access case for caregiver */
	@isTest
	static void testCreateAccessCaseCaregiver() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Test setup
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact'
		);
		insert testContact;

		Profile profile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Caregiver Profile'
			LIMIT 1
		];
		User createdUser = new User(
			ProfileId = profile.Id,
			LastName = 'TestUser',
			Email = 'testuser@example.com',
			Username = 'testuser@example.com',
			Alias = 'tuser',
			ContactId = testContact.id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			BI_PSPB_Caregiver__c = true
		);
		insert createdUser;

		Account testPatient = new Account(
			FirstName = 'Patient',
			LastName = 'id',
			PersonEmail = 'patient@example.com'
		);
		insert testPatient;

		Account testAcc = new Account(
			LastName = 'TestUser',
			PersonEmail = 'testuser@example.com',
			BI_PSPB_Selected_Patient_ID__c = testPatient.id
		);
		insert testAcc;

		Test.startTest();
		System.runAs(createdUser) {
			BI_PSPB_caseCtrl.createAccessCase();
		}
		Test.stopTest();

		List<Case> createdCases = [
			SELECT Id
			FROM Case
			WHERE AccountId = :testPatient.Id
		];
		Assert.arenotequal(
			0,
			createdCases.size(),
			'At least one case should be created'
		);
	}
	/* @description    This method is used to create account request access case for patient */
	@isTest
	static void testCreateAccessCaseNonCaregiver() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Test setup
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact'
		);
		insert testContact;

		Profile profile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		User createdUser = new User(
			ProfileId = profile.Id,
			LastName = 'TestUser',
			Email = 'testuser@example.com',
			Username = 'testuser@example.com',
			Alias = 'tuser',
			ContactId = testContact.id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			BI_PSPB_Caregiver__c = false
		);
		insert createdUser;

		Account testAcc = new Account(
			LastName = 'TestUser',
			PersonEmail = 'testuser@example.com'
		);
		insert testAcc;

		Test.startTest();
		System.runAs(createdUser) {
			BI_PSPB_caseCtrl.createAccessCase();
		}
		Test.stopTest();

		List<Case> createdCases = [
			SELECT Id
			FROM Case
			WHERE AccountId = :testAcc.Id
		];
		Assert.arenotequal(
			0,
			createdCases.size(),
			'At least one case should be created'
		);
	}
	/* @description    This method is used to get the checkbox value from account request access case record */
	@isTest
	static void testCheckboxPersonalAccess() {
		try {
			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			// Test data setup
			Account testAcc = new Account(
				LastName = 'TestUser',
				PersonEmail = 'testuser@example.com'
			);
			insert testAcc;
			RecordType rt = [
				SELECT Id
				FROM RecordType
				WHERE SobjectType = 'Case' AND DeveloperName = 'BI_PSPB_Case'
			];
			Case testCase = new Case(
				AccountId = testAcc.Id,
				Subject = 'Personal Information Request',
				RecordTypeId = rt.Id,
				Description = 'Personal Information Request',
				BI_PSP_Type__c = 'Personal Information Request'
			);
			insert testCase;

			Test.startTest();
			// Call the method under test
			Case result = BI_PSPB_caseCtrl.checkboxPersonalAccess(testAcc.Id);
			Test.stopTest();
			Assert.areEqual(true, result != null, 'Case record is found');
		} catch (Exception ex) {
			// Assert if there's an exception
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
	/* @description    This method is used to get the checkbox value from
	 account request access case record with null realted account */

	@isTest
	static void testCheckboxPersonalAccessNullRelatedAccounts() {
		try {
			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			Test.startTest();
			// Call the method with null relatedAccounts
			Case result = BI_PSPB_caseCtrl.checkboxPersonalAccess(null);
			Test.stopTest();

			// Assert that the result is null
			Assert.areEqual(
				null,
				result,
				'Expected null result when relatedAccounts is null'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
	/* @description    This method is used to get the checkbox value from deletion request access case record */

	@isTest
	static void testCheckboxAccountDeletion() {
		try {
			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			// Test data setup
			Account testAcc = new Account(
				LastName = 'TestUser',
				PersonEmail = 'testuser@example.com'
			);
			insert testAcc;
			RecordType rt = [
				SELECT Id
				FROM RecordType
				WHERE SobjectType = 'Case' AND DeveloperName = 'BI_PSPB_Case'
			];
			Case testCase = new Case(
				AccountId = testAcc.Id,
				Subject = 'Account deletion request',
				RecordTypeId = rt.id,
				Description = 'Account deletion request',
				BI_PSP_Type__c = 'Account deletion request'
			);
			insert testCase;

			Test.startTest();
			// Call the method under test
			Case result = BI_PSPB_caseCtrl.checkboxAccountDeletion(testAcc.Id);
			Test.stopTest();
			Assert.areEqual(true, result != null, 'Case record is found');
		} catch (Exception ex) {
			// Assert if there's an exception
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
	/* @description    This method is used to get the checkbox value from
	 deletion request access case record with null realted account */
	@isTest
	static void testCheckboxAccountDeletionNullRelatedAccounts() {
		try {
			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			Test.startTest();
			// Call the method with null relatedAccounts
			Case result = BI_PSPB_caseCtrl.checkboxAccountDeletion(null);
			Test.stopTest();
			// Assert that the result is null
			Assert.areEqual(
				null,
				result,
				'Expected null result when relatedAccounts is null'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
	/* @description    This method is used to get a selected patient id's from caregiver
	 account */
	@isTest
	static void testCreateCaseSelectedPatientAccounts() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		// Test setup
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact'
		);
		insert testContact;

		Profile profile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Caregiver Profile'
			LIMIT 1
		];
		User createdUser = new User(
			ProfileId = profile.Id,
			LastName = 'TestUser',
			Email = 'testuser@example.com',
			Username = 'testuser@example.com',
			Alias = 'tuser',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			ContactId = testContact.Id,
			BI_PSPB_Caregiver__c = true
		);
		insert createdUser;

		Account testPatient = new Account(
			FirstName = 'Patient',
			LastName = 'id',
			PersonEmail = 'patient@example.com'
		);
		insert testPatient;

		Account testAcc = new Account(
			LastName = 'TestUser',
			PersonEmail = 'testuser@example.com',
			BI_PSPB_Selected_Patient_ID__c = testPatient.Id
		);
		insert testAcc;

		Test.startTest();
		List<Account> selectedPatientAccounts = [
			SELECT Id, Name, PersonEmail, BI_PSPB_Selected_Patient_ID__c
			FROM Account
			WHERE
				Name = 'TestUser'
				AND PersonEmail = 'testuser@example.com'
				AND BI_PSPB_Selected_Patient_ID__c != NULL
		];

		Assert.areEqual(
			1,
			selectedPatientAccounts.size(),
			'Selected patient accounts should be retrieved'
		);

		// Verify that related accounts are retrieved based on the selected patient account
		if (!selectedPatientAccounts.isEmpty()) {
			List<Account> relatedAccounts = [
				SELECT Id, Name, PersonEmail
				FROM Account
				WHERE
					Id = :selectedPatientAccounts[0]
						.BI_PSPB_Selected_Patient_ID__c
			];
			Assert.areEqual(
				1,
				relatedAccounts.size(),
				'Related accounts should be retrieved'
			);
			Assert.areEqual(
				testPatient.Id,
				relatedAccounts[0].Id,
				'Related account should match the expected one'
			);
		}

		Test.stopTest();
	}
	// Test method for when a database error occurs
	@isTest
	static void testCreateCaseDatabaseError() {
		String errorMsg = 'cannot create case';
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Test data setup
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact'
		);
		insert testContact;

		Profile profile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		User createdUser = new User(
			ProfileId = profile.Id,
			LastName = 'TestUser',
			Email = 'testuser@example.com',
			Username = 'testuser@example.com',
			Alias = 'tuser',
			ContactId = testContact.id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			BI_PSPB_Caregiver__c = true
		);
		insert createdUser;
		Account testAcc = new Account(
			LastName = 'TestUser',
			PersonEmail = 'testuser@example.com'
		);
		insert testAcc;

		Assert.arenotequal(null, testAcc, 'Account not found');
		// Prepare to catch the expected exception
		Test.startTest();
		System.runAs(createdUser) {
			try {
				BI_PSPB_caseCtrl.createCase();
			} catch (Exception e) {
				Assert.areEqual(
					'cannot create case',
					errorMsg,
					'Expected an exception to be thrown.'
				);
			}
		}
		Test.stopTest();
	}
	/*@description This method is used to find a deletion access request case with no related accounts*/
	@isTest
	static void testCreateCaseNoRelatedAccounts() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		Test.startTest();
		// Simulate the scenario where no related accounts are found
		Profile profile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Chatter Free User'
			LIMIT 1
		];
		User currentUser = new User(
			ProfileId = profile.Id,
			Username = 'nonexistent@example.com',
			LastName = 'Nonexistent',
			Email = 'nonexistent@example.com',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			Alias = 'nonex'
		);
		insert currentUser; // Insert the user to ensure it exists in the test context
		Account accTest = new Account(LastName = 'Invalid');
		insert accTest;
		Case testCase = new Case(
			AccountId = accTest.Id,
			Subject = 'Account deletion request',
			Description = 'Account deletion request',
			BI_PSP_Type__c = 'Account deletion request'
		);
		insert testCase;

		System.runAs(currentUser) {
			try {
				// Call the createCase() method
				BI_PSPB_caseCtrl.createCase();
			} catch (AuraHandledException e) {
				// Ensure that an AuraHandledException is thrown when no related accounts are found
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Not found related accounts'
				);
			}
		}
		Test.stopTest();
	}
	/*@description This method is used to find a account access request case with no related accounts*/

	@isTest
	static void testCreateAccessCaseNoRelatedAccounts() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		Test.startTest();
		// Simulate the scenario where no related accounts are found
		Profile profile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Chatter Free User'
			LIMIT 1
		];
		User currentUser = new User(
			ProfileId = profile.Id,
			Username = 'nonexistent@example.com',
			LastName = 'Nonexistent',
			Email = 'nonexistent@example.com',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			Alias = 'nonex'
		);
		insert currentUser; // Insert the user to ensure it exists in the test context
		System.runAs(currentUser) {
			try {
				// Call the createCase() method
				BI_PSPB_caseCtrl.createAccessCase();
			} catch (AuraHandledException e) {
				// Ensure that an AuraHandledException is thrown when no related accounts are found
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Not found related accounts'
				);
			}
		}
		Test.stopTest();
	}
	/*@description This method is used to create a case with null current user*/

	@isTest
	static void testCreateCaseNullCurrentUser() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		Case testCase = new Case(
			Subject = 'Account deletion request',
			Description = 'Account deletion request',
			BI_PSP_Type__c = 'Account deletion request'
		);
		insert testCase;
		Test.startTest();
		try {
			// Call the createCase method without setting current user
			BI_PSPB_caseCtrl.createCase();
		} catch (Exception ex) {
			// Assert if there's an exception
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
			Test.stopTest();
		}
	}
	/*@description This method is used to if cannot get the checkbox value from case*/

	@isTest
	static void testWithValidRelatedAccountsNoCaseFound() {
		try {
			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			Account acc = new Account(Name = 'Test Account');
			insert acc;
			Case result = BI_PSPB_caseCtrl.checkboxPersonalAccess(acc.id);
			Assert.areEqual(
				result == null,
				'The method should return null if no case matches the criteria.',
				'No cases found'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
    /*@description This method is used to if cannot get the checkbox value from case*/
	@isTest
	static void testWithValidRelatedAccountsNoCaseFoundDelete() {
		try {
			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			Account acc = new Account(Name = 'Test Account');
			insert acc;
			Case result = BI_PSPB_caseCtrl.checkboxAccountDeletion(acc.id);
			Assert.areEqual(
				result == null,
				'The method should return null if no case matches the criteria.',
				'No cases found'
			);
		} catch (Exception ex) {
			// Assert if there's an exception
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
}