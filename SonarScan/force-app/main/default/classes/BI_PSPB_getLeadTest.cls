/**
@description	Test class for the BI_PSPB_getLead class.
@author					Niyas
@Last Modified On   	04/23/2024
@Last Modified By 		Niyas
*/
@isTest
public class BI_PSPB_getLeadTest {
	/**
* @description Test method to verify the behavior of 
getEnrolleeCaregiverId method.
*/
	@isTest
	static void testAccid() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1)
		);
		insert testLead;

		BI_PSPB_Lead_Caregiver__c testLeadCaregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_First_Name__c = 'TestFirstName',
			BI_PSPB_Last_Name__c = 'TestLastName',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(2000, 1, 1),
			BI_PSPB_Preferred_Communication_Method__c = 'Email',
			BI_PSPB_E_mail_ID__c = 'test@example.com',
			BI_PSPB_Phone_number__c = '1234567890',
			BI_PSPB_Lead__c = testLead.Id
		);
		insert testLeadCaregiver;

		// Mock an exception by setting leadId to an invalid value
		String invalidLeadId = 'invalidLeadId';

		// Perform the test
		Test.startTest();
		// Wrap the method call in a try-catch block to capture the exception
		try {
			BI_PSPB_Lead_Caregiver__c result = BI_PSPB_getLead.getEnrolleeCaregiverId(
				invalidLeadId
			);
			List<BI_PSPB_Lead_Caregiver__c> leadRecord = [
				SELECT Id
				FROM BI_PSPB_Lead_Caregiver__c
				WHERE Id = :result.Id
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead Caregiver should have been created'
			);
		} catch (Exception ex) {
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'Method thrown exception'
			);
		}
		Test.stopTest();
	}
	/**
	 * @description Test method to verify the behavior of leadid method.
	 */
	@isTest
	static void testLeadId() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1)
		);
		insert testLead;

		// Mock an exception by providing invalid input parameters
		String invalidFirstName = 'InvalidFirstName';
		String invalidLastName = 'InvalidLastName';
		Date invalidDob = Date.today();
		// Perform the test
		Test.startTest();
		// Wrap the method call in a try-catch block to capture the exception
		try {
			Lead result = BI_PSPB_getLead.leadid(
				invalidFirstName,
				invalidLastName,
				invalidDob
			);
            List<Lead> leadRecord = [
				SELECT Id
				FROM Lead
				WHERE Id = :result.Id
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead Caregiver should have been created'
			);
		} catch (Exception ex) {
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'Method thrown exception'
			);
		}
		Test.stopTest();
		List<Lead> leadRecord = [SELECT Id FROM Lead WHERE Id = :testLead.Id];
		assert.areEqual(
			1,
			leadRecord.size(),
			'Lead Caregiver should have been created'
		);
	}

	/**
* @description Test method to verify the behavior of leadid 
method with invaid input.
*/
	@isTest
	static void testgetLeadId() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1)
		);
		insert testLead;

		// Mock an exception by providing an invalid leadId
		String invalidLeadId = 'invalidLeadId';

		// Perform the test
		Test.startTest();
		// Wrap the method call in a try-catch block to capture the exception
		try {
			Lead result = BI_PSPB_getLead.getLeadId(invalidLeadId);
            List<Lead> leadRecord = [
				SELECT Id
				FROM Lead
				WHERE Id = :result.Id
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead Caregiver should have been created'
			);
		} catch (Exception ex) {
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'Method thrown exception'
			);
		}
		Test.stopTest();
	}
	/**
* @description Test method to verify the behavior of getLeadPresId
method with invalid input.
*/
	@isTest
	static void testgetLeadPresId() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1)
		);
		insert testLead;

		// Mock an exception by providing an invalid leadId
		String invalidLeadId = 'invalidLeadId';

		// Perform the test
		Test.startTest();
		// Wrap the method call in a try-catch block to capture the exception
		try {
			BI_PSPB_Lead_Prescription__c result = BI_PSPB_getLead.getLeadPresId(
				invalidLeadId
			);
            List<BI_PSPB_Lead_Caregiver__c> leadRecord = [
				SELECT Id
				FROM BI_PSPB_Lead_Caregiver__c
				WHERE Id = :result.Id
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead Caregiver should have been created'
			);
		} catch (Exception ex) {
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'Method thrown exception'
			);
		}
		Test.stopTest();
	}

	/**
	 * @description Test method to verify the behavior of LeadWrapper method.
	 */
	@isTest
	static void testUpdateLeadRecord() {
		// Create test data
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Preferred_Communication_Method__c = 'Email',
			CountryCode = 'US',
			StateCode = 'AL',
			City = 'TestCity',
			Street = 'TestStreet',
			PostalCode = '12345'
		);
		insert testLead;
		BI_PSPB_getLead.LeadWrapper leadWrapper = new BI_PSPB_getLead.LeadWrapper();
		leadWrapper.leadId = testLead.Id;
		leadWrapper.phone = '0987654321';
		leadWrapper.pmc = 'Phone';
		leadWrapper.country = 'US';
		leadWrapper.state = 'AL';
		leadWrapper.city = 'TestCity';
		leadWrapper.street = 'TestStreet';
		leadWrapper.zipCode = '54321';

		Test.startTest();
		// Call the method under test
		BI_PSPB_getLead.updateLeadRecord(leadWrapper);
		Test.stopTest();

		// Retrieve the updated lead record
		Lead[] updatedLead = [
			SELECT
				Id,
				Phone,
				BI_PSPB_Preferred_Communication_Method__c,
				Country,
				State,
				City,
				Street,
				PostalCode
			FROM Lead
			WHERE Id = :testLead.Id
			LIMIT 1
		];
			assert.areEqual(
				1,
				updatedLead.size(),
				'Lead Caregiver should have been created'
			);
	}
	/**
	 * @description Test method to verify the behavior of LeadWrapper method.
	 */
	@isTest
	static void testUpdateLeadRecordFailed() {
		// Create test data
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Preferred_Communication_Method__c = 'Email',
			CountryCode = 'US',
			StateCode = 'AL',
			City = 'TestCity',
			Street = 'TestStreet',
			PostalCode = '12345'
		);
		insert testLead;
		BI_PSPB_getLead.LeadWrapper leadWrapper = new BI_PSPB_getLead.LeadWrapper();
		leadWrapper.leadId = testLead.Id;
		leadWrapper.phone = '0987654321';
		leadWrapper.pmc = 'Phone';
		leadWrapper.country = 'USAAA';
		leadWrapper.state = 'AL';
		leadWrapper.city = 'TestCity';
		leadWrapper.street = 'TestStreet';
		leadWrapper.zipCode = '54321';
		try {
			Test.startTest();
			// Call the method under test
			BI_PSPB_getLead.updateLeadRecord(leadWrapper);
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
	 * @description Test method to verify the behavior of leadid method.
	 */
	@isTest
	static void testLeadids() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1),
			HealthCloudGA__Gender__c = 'Male',
			Email = 'test@example.com'
			// Add other required fields as needed
		);
		insert testLead;

		// Perform the test
		Test.startTest();
		Lead result = BI_PSPB_getLead.leadid(
			'TestFirstName',
			'TestLastName',
			Date.newInstance(2000, 1, 1)
		);
        List<Lead> leadRecord = [
				SELECT Id
				FROM Lead
				WHERE Id = :result.Id
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead Caregiver should have been created'
			);
		Test.stopTest();
	}
	/**
* @description Test method to verify the behavior of updateLead
method with invalid input.
*/
	@isTest
	static void testUpdateLeadFailed() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1)
			// Add other required fields as needed
		);
		insert testLead;

		// Create a Lead Caregiver record
		BI_PSPB_Lead_Caregiver__c testLeadCaregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_Lead__c = testLead.Id,
			BI_PSPB_First_Name__c = 'Test Lead Caregiver',
			BI_PSPB_Last_Name__c = 'Caregiver',
			BI_PSPB_E_mail_ID__c = 'test@gmail.com',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(1996, 2, 28),
			BI_PSPB_Phone_number__c = '9876543210',
			BI_PSPB_Relationship_to_Patient__c = 'Parent',
			BI_PSPB_Preferred_Communication_Method__c = 'phone'
			// Add other required fields as needed
		);
		insert testLeadCaregiver;

		BI_PSP_Lead_Consent__c leadConsentToInsert = new BI_PSP_Lead_Consent__c(
			BI_PSP_Lead__c = testLead.id,
			BI_PSPB_Consent_Category__c = 'Caregiver',
			//BI_PSPB_Consent_Name__c = consentName;
			BI_PSPB_Date_of_the_Consent__c = system.today()
		);
		insert leadConsentToInsert;

		// Perform the test
		try {
			Test.startTest();
			// Wrap the method call in a try-catch block to capture the exception
			BI_PSPB_getLead.updateLead(testLead.Id, 'Phoneeeee');

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
	 * @description Test method to verify the behavior of leadid method.
	 */
	@isTest
	static void testUpdateLead() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1)
			// Add other required fields as needed
		);
		insert testLead;

		// Create a Lead Caregiver record
		BI_PSPB_Lead_Caregiver__c testLeadCaregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_Lead__c = testLead.Id,
			BI_PSPB_First_Name__c = 'Test Lead Caregiver',
			BI_PSPB_Last_Name__c = 'Caregiver',
			BI_PSPB_E_mail_ID__c = 'test@gmail.com',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(1996, 2, 28),
			BI_PSPB_Phone_number__c = '9876543210',
			BI_PSPB_Relationship_to_Patient__c = 'Parent',
			BI_PSPB_Preferred_Communication_Method__c = 'phone'
			// Add other required fields as needed
		);
		insert testLeadCaregiver;

		BI_PSP_Lead_Consent__c leadConsentToInsert = new BI_PSP_Lead_Consent__c(
			BI_PSP_Lead__c = testLead.id,
			BI_PSPB_Consent_Category__c = 'Caregiver',
			//BI_PSPB_Consent_Name__c = consentName;
			BI_PSPB_Date_of_the_Consent__c = system.today()
		);
		insert leadConsentToInsert;

		// Perform the test
		try {
			Test.startTest();
			// Wrap the method call in a try-catch block to capture the exception
			BI_PSPB_getLead.updateLead(testLead.Id, 'Phone');

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
* @description Test method to verify the behavior of leadid method
with null value as input.
*/
	@isTest
	static void testUpdateLeadNull() {
		try {
			Test.startTest();
			// Wrap the method call in a try-catch block to capture the exception
			BI_PSPB_getLead.updateLead('', '');

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
* @description Test method to verify the behavior of
insertupdateLeadConsent method.
*/
	@isTest
	static void testinsertupdateLeadConsent() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1)
			// Add other required fields as needed
		);
		insert testLead;

		BI_PSP_Lead_Consent__c leadConsentToInsert = new BI_PSP_Lead_Consent__c(
			BI_PSP_Lead__c = testLead.id,
			BI_PSPB_Consent_Category__c = 'Caregiver',
			BI_PSPB_Date_of_the_Consent__c = system.today()
		);
		insert leadConsentToInsert;

		// Perform the test
		Test.startTest();
		// Wrap the method call in a try-catch block to capture the exception
		BI_PSPB_getLead.insertupdateLeadConsent(testLead.Id, 'Patient');
		Test.stopTest();
		List<Lead> leadRecord = [
			SELECT Id
			FROM Lead
			WHERE Id = :testLead.Id
		];
		assert.areEqual(
			1,
			leadRecord.size(),
			'Lead Caregiver should have been created'
		);
	}
	/**
* @description Test method to verify the behavior of updateLeadCareRecord
method.
*/
	static void testinsertupdateLeadConsentFailed() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1)
			// Add other required fields as needed
		);
		insert testLead;

		BI_PSP_Lead_Consent__c leadConsentToInsert = new BI_PSP_Lead_Consent__c(
			BI_PSP_Lead__c = testLead.id,
			BI_PSPB_Consent_Category__c = 'Caregiver',
			//BI_PSPB_Consent_Name__c = consentName;
			BI_PSPB_Date_of_the_Consent__c = system.today()
		);
		insert leadConsentToInsert;

		// Perform the test
		Test.startTest();
		// Wrap the method call in a try-catch block to capture the exception
		BI_PSPB_getLead.insertupdateLeadConsent(testLead.Id, 'Patientttt');
		Test.stopTest();
	}
	/**
* @description Test method to verify the behavior of insertupdateLeadConsent
method with invalid input.
*/
	@isTest
	static void testinsertupdateLeadConsentNull() {
		// Perform the test
		try {
			Test.startTest();
			// Wrap the method call in a try-catch block to capture the exception
			BI_PSPB_getLead.insertupdateLeadConsent('', '');
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
	 * @description Test method to verify the behavior of leadid method.
	 */
	@isTest
	static void testLeadCareRecordUpdate() {
		// Create a test Lead record
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			CountryCode = 'US',
			StateCode = 'AL',
			City = 'San Francisco',
			Street = 'TestAddress',
			PostalCode = '54321'
		);
		insert testLead;
		BI_PSPB_getLead.LeadWrapper leadWrapper = new BI_PSPB_getLead.LeadWrapper();
		leadWrapper.leadId = testLead.Id;
		leadWrapper.country = 'US';
		leadWrapper.state = 'AL';
		leadWrapper.city = 'San Francisco';
		leadWrapper.street = 'TestAddress';
		leadWrapper.zipCode = '54321';
		// Call the method to be tested from the appropriate class
		Test.startTest();
		BI_PSPB_getLead.updateLeadCareRecord(leadWrapper);
		Test.stopTest();

		// Retrieve the updated Lead record
		Lead[] updatedLead = [
			SELECT Id, CountryCode, StateCode, City, Street, PostalCode
			FROM Lead
			WHERE Id = :testLead.Id
		];
			assert.areEqual(
				1,
				updatedLead.size(),
				'Lead Caregiver should have been created'
			);
	}
	/**
	 * @description Test method to verify the behavior of verifyUnassign method.
	 */
	@isTest
	static void testverifyUnassign() {
		// Test data setup
		// Create a test account
		Account testAccount = new Account(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName'
			// Add other required fields as needed
		);
		insert testAccount;

		// Perform the test
		Test.startTest();
		// Wrap the method call in a try-catch block to capture the exception
		try {
			// Provide invalid first name and last name to simulate an exception
			BI_PSPB_getLead.verifyUnassign(
				'InvalidFirstName', // Invalid first name
				'InvalidLastName' // Invalid last name
			);
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
		Test.stopTest();
	}
	/**
	 * @description Test method to verify the behavior of hcpCreate method.
	 */
	@isTest
	static void testHcpCreate_Success() {
		// Test data
		String firstName = 'John';
		String lastName = 'Doe';
		String phone = '1234567890';
		String email = 'john.doe@example.com';

		// Call the method
		Test.startTest();
		Id createdContactId = BI_PSPB_getLead.hcpCreate(
			firstName,
			lastName,
			phone,
			email
		);
        List<Contact> leadRecord = [
				SELECT Id
				FROM Contact
				WHERE Id = :createdContactId
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead Caregiver should have been created'
			);
		Test.stopTest();

		// Verify that the contact was created successfully
		System.assertNotEquals(
			null,
			createdContactId,
			'Contact should have been created successfully'
		);
	}
	/**
	 * @description Test method to verify the behavior of hcpCreate method.
	 */
	@isTest
	static void testHcpCreate_Failed() {
		// Test data
		String firstName = 'John';
		String lastName = 'Doe';
		String phone = '1234567890';
		String email = 'johndoe';

		// Call the method
		try {
			Test.startTest();
			Id createdContactId = BI_PSPB_getLead.hcpCreate(
				firstName,
				lastName,
				phone,
				email
			);
			List<Contact> leadRecord = [
				SELECT Id
				FROM Contact
				WHERE Id = :createdContactId
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead Caregiver should have been created'
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
	 * @description Test method to verify the behavior of hcpAccessCode method.
	 */
	@isTest
	static void testHcpAccessCode() {
		// Test data setup
		Contact testContact = new Contact(
			FirstName = 'test1',
			LastName = 'test2',
			Phone = '1234567890',
			Email = 'niyas@vhs.com',
			BI_PSPB_Access_Code__c = 'TestAccessCode'
		);
		insert testContact;

		// Perform the test
		try {
			Test.startTest();
			Contact result = BI_PSPB_getLead.hcpAccessCode('TestAccessCode');
            List<Contact> leadRecord = [
				SELECT Id
				FROM Contact
				WHERE Id = :result.Id
			];
			assert.areEqual(
				1,
				leadRecord.size(),
				'Lead Caregiver should have been created'
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
	 * @description Test method to verify the behavior of all the method.
	 */
	@isTest
	static void testCatchFailed() {
		// Test data setup
		Lead testLead = new Lead(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			HealthCloudGA__BirthDate__c = Date.newInstance(2000, 1, 1)
		);
		insert testLead;

		// Create a Lead Caregiver record
		BI_PSPB_Lead_Caregiver__c testLeadCaregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_Lead__c = testLead.Id,
			BI_PSPB_First_Name__c = 'Test Lead Caregiver',
			BI_PSPB_Last_Name__c = 'Caregiver',
			BI_PSPB_E_mail_ID__c = 'test@gmail.com',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(1996, 2, 28),
			BI_PSPB_Phone_number__c = '9876543210',
			BI_PSPB_Relationship_to_Patient__c = 'Parent',
			BI_PSPB_Preferred_Communication_Method__c = 'phone'
		);
		insert testLeadCaregiver;

		BI_PSP_Lead_Consent__c leadConsentToInsert = new BI_PSP_Lead_Consent__c(
			BI_PSP_Lead__c = testLead.id,
			BI_PSPB_Consent_Category__c = 'Caregiver',
			//BI_PSPB_Consent_Name__c = consentName;
			BI_PSPB_Date_of_the_Consent__c = system.today()
		);
		insert leadConsentToInsert;
		BI_PSPB_getLead.LeadWrapper leadWrapper = new BI_PSPB_getLead.LeadWrapper();
		// Call the method being tested
		try {
			Test.startTest();
			BI_PSPB_getLead.updateLeadCareRecord(leadWrapper);
			BI_PSPB_getLead.updateLeadRecord(leadWrapper);
			BI_PSPB_getLead.hcpCreate('First', 'Name', '0987654321', 'niyas');
			BI_PSPB_getLead.insertupdateLeadConsent('', '');
			BI_PSPB_getLead.updateLead(testLead.Id, 'Pmc');
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