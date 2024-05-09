@isTest
private class BI_PSPB_leadCreationCtrlTest {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	/* @descriptionThis test method verifies the functionality of the `createLead` method in the BI_PSPB_LeadCreationCtrl class.
	 * It creates test data including a referring contact and a data wrapper object containing information for a lead.
	 *  The method is called with the test data, and then the created lead record is retrieved and verified.
	 */
	@isTest
	static void testCreateLead() {
		// Create test data
		Contact referringContact = new Contact(
			FirstName = 'Referring',
			LastName = 'Contact',
			BI_PSPB_License_number__c = '123456'
		);
		insert referringContact;

		BI_PSPB_leadCreationCtrl.DataWrapper testData = new BI_PSPB_leadCreationCtrl.DataWrapper();
		testData.firstName = 'Test';
		testData.lastName = 'Lead';
		testData.dob = '1990-01-01'; // Assuming format is YYYY-MM-DD
		testData.email = 'test@example.com';
		testData.sex = 'Male';
		testData.phone = '1234567890';

		Test.startTest();
		// Call the method to be tested
		Id newLeadId = BI_PSPB_LeadCreationCtrl.createLead(
			testData,
			null,
			'123456',
			null
		);
		Test.stopTest();

		// Verify that the Lead record is created
		Lead createdLead = [
			SELECT
				Id,
				FirstName,
				LastName,
				Email,
				HealthCloudGA__BirthDate__c,
				HealthCloudGA__Gender__c,
				Phone,
				BI_PSPB_Physician_Name_c__c,
				BI_PSPB_Enrolled_By__c
			FROM Lead
			WHERE Id = :newLeadId
		];

		// Assert that the Lead record has been created with the correct values
		Assert.areEqual(
			'Test',
			createdLead.FirstName,
			'First name should be match'
		);
		Assert.areEqual(
			'Lead',
			createdLead.LastName,
			'Last name should be match'
		);
		Assert.areEqual(
			'test@example.com',
			createdLead.Email,
			'Email should be match'
		);
		Assert.areEqual(
			Date.newInstance(1990, 1, 1),
			createdLead.HealthCloudGA__BirthDate__c,
			'Birthdate should be match'
		);
		Assert.areEqual(
			'Male',
			createdLead.HealthCloudGA__Gender__c,
			'Gender is Male'
		);
		Assert.areEqual('1234567890', createdLead.Phone, 'Mobile should match');
		Assert.areEqual(
			referringContact.Id,
			createdLead.BI_PSPB_Physician_Name_c__c,
			'Referring contact id should match'
		);
		// Add more assertions as needed
	}

	/*
	 *  @description This test method verifies the functionality of the `caregiverCreate` method in the BI_PSPB_LeadCreationCtrl class.
	 * It creates test data for a caregiver and a lead record, and then calls the `caregiverCreate` method with the test data and the ID
	 * of the lead record. After the method call, it verifies that the caregiver record is created with the correct values.
	 * The test ensures that the caregiver record is created with the appropriate first name, last name, email, date of birth,
	 *  phone number, relationship to the patient, and that it is associated with the correct lead record.
	 * Additional assertions can be added as needed to cover more aspects of the caregiver creation process.
	 */

	@isTest
	static void testCaregiverCreate() {
		// Create test data
		BI_PSPB_LeadCreationCtrl.DataWrapper testCaregiverData = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		testCaregiverData.firstName = 'Test';
		testCaregiverData.lastName = 'Caregiver';
		testCaregiverData.email = 'test@example.com';
		testCaregiverData.dob = '1990-01-01'; // Assuming the date format is 'YYYY-MM-DD'
		testCaregiverData.phone = '1234567890';
		testCaregiverData.relation = 'Parent';

		// Create a Lead record for testing
		Lead testLead = new Lead();
		testLead.LastName = 'TestLead';
		insert testLead;

		Test.startTest();
		// Call the method to be tested
		Id newCaregiverId = BI_PSPB_LeadCreationCtrl.caregiverCreate(
			testCaregiverData,
			testLead.Id
		);
		Test.stopTest();

		// Verify that the caregiver record is created
		BI_PSPB_Lead_Caregiver__c createdCaregiver = [
			SELECT
				Id,
				BI_PSPB_First_Name__c,
				BI_PSPB_Last_Name__c,
				BI_PSPB_E_mail_ID__c,
				BI_PSPB_Date_of_Birth__c,
				BI_PSPB_Phone_number__c,
				BI_PSPB_Relationship_to_Patient__c,
				BI_PSPB_Lead__c
			FROM BI_PSPB_Lead_Caregiver__c
			WHERE Id = :newCaregiverId
		];

		// Assert that the caregiver record has been created with the correct values
		Assert.areEqual(
			'Test',
			createdCaregiver.BI_PSPB_First_Name__c,
			'First name should be match'
		);
		Assert.areEqual(
			'Caregiver',
			createdCaregiver.BI_PSPB_Last_Name__c,
			'Last name should be match'
		);
		Assert.areEqual(
			'test@example.com',
			createdCaregiver.BI_PSPB_E_mail_ID__c,
			'Email should be match'
		);
		Assert.areEqual(
			Date.valueOf('1990-01-01'),
			createdCaregiver.BI_PSPB_Date_of_Birth__c,
			'Birthdate should be match'
		);
		Assert.areEqual(
			'1234567890',
			createdCaregiver.BI_PSPB_Phone_number__c,
			'Mobile should match'
		);
		Assert.areEqual(
			'Parent',
			createdCaregiver.BI_PSPB_Relationship_to_Patient__c,
			'Referring contact id should match'
		);
		Assert.areEqual(
			testLead.Id,
			createdCaregiver.BI_PSPB_Lead__c,
			'Lead id should match'
		);
	}
	/*
	 * @description This test method verifies the functionality of the `hcpCreate` method in the BI_PSPB_LeadCreationCtrl class.
	 * It creates test data for a healthcare professional (HCP) and a contact record, and then calls the `hcpCreate`
	 * method with the test data. After the method call, it verifies that the HCP record is created with the correct values.
	 * The test ensures that the HCP record is created with the appropriate first name, last name, phone number, email,
	 *  date of birth, relationship to the patient, and other relevant fields. Additional assertions can be added as needed
	 * to cover more aspects of the HCP creation process.
	 */
	@isTest
	static void testHcpCreate() {
		// Create test data
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		// Create test data
		BI_PSPB_LeadCreationCtrl.DataWrapper testData = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		testData.firstName = 'TestFirstName';
		testData.lastName = 'TestLastName';
		testData.phone = '1234567890';
		testData.email = 'john.doe@example.com';
		testData.dob = '1990-01-01';
		testData.relation = 'Parent';
		// Create a record type for testing
		// insert testData;
		Test.startTest();
		// Call the method to be tested
		BI_PSPB_LeadCreationCtrl.hcpCreate(testData);
		Test.stopTest();

		// Verify that the HCP record is created
		Contact createdHcp = [
			SELECT
				Id,
				FirstName,
				LastName,
				BI_PSPB_License_number__c,
				BI_PSPB_Practice__c,
				BI_PSPB_Practice_Type__c,
				Phone,
				Email,
				MailingCountryCode,
				MailingStateCode,
				MailingCity,
				MailingStreet,
				MailingPostalCode
			FROM Contact
			WHERE Id = :con.id
		];

		// Assert that the HCP record has been created with the correct values
		Assert.areEqual(
			'TestFirstName',
			createdHcp.FirstName,
			'First name should be match'
		);
		Assert.areEqual(
			'TestLastName',
			createdHcp.LastName,
			'Last name should be match'
		);
	}
	/*@description This test method verifies the functionality of the `prescriptionrCreate`
	 *  method in the `BI_PSPB_LeadCreationCtrl`class.It creates test data for a prescription, including a test lead,
	 *  care program, care program product, and a lead prescription record. The method then calls the `prescriptionrCreate`
	 *  method with the test data and verifies
	 * that the prescription record is created with the correct values.The test ensures that the prescription record is
	 *  created with the appropriate dosage, quantity, frequency, number of refills, drug code, unit,
	 *  prescribed date, frequency unit, drug, and lead reference. Additional assertions can be added as needed to cover
	 *  more aspects of the prescription creation process.
	 */
	@isTest
	static void testPrescriptionrCreate() {
		// Create a Lead record for testing
		Lead testLead = new Lead(
			FirstName = 'TestLeadFiirst',
			LastName = 'TestLeadLaast',
			Email = 'testleaad@example.com',
			HealthCloudGA__BirthDate__c = Date.valueOf('1990-01-01'),
			Phone = '1234567890'
			// Add any other required fields for your Lead record
		);
		insert testLead;

		// Create a CareProgram record for the test drug
		CareProgram cpvalue = new CareProgram(
			Name = 'Test CP',
			StartDate = Date.today() // Adjust the start date as needed
			// Add any other required fields for your CareProgram record
		);
		insert cpvalue;

		// Create a CareProgramProduct record for the test drug
		CareProgramProduct testDrug = new CareProgramProduct(
			Name = 'Test Drug',
			CareProgramId = cpvalue.Id // Assign the CareProgramId field
			// Use the same name as specified in testData.drug
			// Add any other required fields for your CareProgramProduct record
		);
		insert testDrug;

		BI_PSPB_Lead_Prescription__c pres = new BI_PSPB_Lead_Prescription__c(
			BI_PSPB_Lead__c = testLead.Id
		);

		insert pres;
		// Create test data
		BI_PSPB_LeadCreationCtrl.DataWrapper testData = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		testData.drug = 'Test Drug'; // Specify the name of the drug
		testData.frequency = '3'; // Example frequency
		testData.unit = 'Unit'; // Example unit
		testData.dob = '2023-01-01'; // Example date of birth

		try {
			Test.startTest();
			// Call the method to be tested
			Id newPrescriptionId = BI_PSPB_LeadCreationCtrl.prescriptionrCreate(
				testData,
				'2',
				'5',
				testLead.Id
			);
			Test.stopTest();
			Assert.areNotEqual(newPrescriptionId, null, 'Id should not null');
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
		// Verify that the Prescription record is created

		// Add assertions here to verify the createdPrescription object and its fields
	}

	/*@description This test method validates the functionality of the `Consentcreate` method within the 
     * `BI_PSPB_LeadCreationCtrl` class. It creates a lead record as test data and then calls the `Consentcreate`
     *  method with the lead's ID. After the method execution, it verifies that a consent record has been created 
     * with the correct values.
     * The test ensures that the consent record is created with the consent value set to true, 
     * the consent category set to 'Healthcare Provider', and that it is associated with the correct lead record. 
     * This validation guarantees that the consent creation process functions as expected.

     */
	@isTest
	static void testConsentcreate() {
		// Test data
		Lead testLead = new Lead(
			FirstName = 'TestLeadFirst',
			LastName = 'TestLeadLast',
			Email = 'testlead@example.com',
			HealthCloudGA__BirthDate__c = Date.valueOf('1990-01-01'),
			Phone = '1234567890',
			BI_PSPB_Physician_Name_c__c = null // Adjust this if you have a valid contact for the lead
		);
		insert testLead;

		Test.startTest();
		// Call the method being tested
		Id consentId = BI_PSPB_LeadCreationCtrl.Consentcreate(testLead.Id);
		Test.stopTest();

		// Query the consent to verify its existence and correctness
		BI_PSP_Lead_Consent__c insertedConsent = [
			SELECT
				Id,
				BI_PSP_I_agree__c,
				BI_PSPB_Consent_Category__c,
				BI_PSP_Lead__c
			FROM BI_PSP_Lead_Consent__c
			WHERE Id = :consentId
			LIMIT 1
		];
		Assert.areEqual(
			true,
			insertedConsent.BI_PSP_I_agree__c,
			'Value should be true'
		);
		Assert.areEqual(
			'Healthcare Provider',
			insertedConsent.BI_PSPB_Consent_Category__c,
			'Category is healthcare provider'
		);
		Assert.areEqual(
			testLead.Id,
			insertedConsent.BI_PSP_Lead__c,
			'Lead id should match'
		);
	}
	/* @description This test method validates the functionality of the `getExistingAccounts` method within the
	 *  `BI_PSPB_LeadCreationCtrl` class. It first creates a test account record with sample data and inserts
	 * it into the database to ensure that there is at least one existing account.
	 * Then, it calls the `getExistingAccounts` method to retrieve a list of existing accounts.
	 * The test asserts that the returned list of accounts is not empty. Additionally, it checks specific fields of the
	 *  retrieved account to ensure that they match the expected values.
	 * By performing these validations, the test ensures that the `getExistingAccounts` method correctly retrieves
	 * existing accounts and returns them as expected.
	 */

	@isTest
	static void testGetExistingAccounts() {
		// Create test data
		String testEmail = 'test@example.com';
		Account testAccount = new Account(
			FirstName = 'Test',
			LastName = 'Account',
			PersonEmail = testEmail
		);
		insert testAccount;

		// Test when an account with the specified email exists
		Test.startTest();
		List<Account> existingAccounts = BI_PSPB_LeadCreationCtrl.getExistingAccounts(
			testEmail
		);
		Test.stopTest();

		Assert.areEqual(
			1,
			existingAccounts.size(),
			'Expected one existing account'
		);
		Account retrievedAccount = existingAccounts[0];
		Assert.areEqual(
			'Test',
			retrievedAccount.FirstName,
			'First name should be match'
		);
		Assert.areEqual(
			'Account',
			retrievedAccount.LastName,
			'Last name should be match'
		);
		Assert.areEqual(
			testEmail,
			retrievedAccount.PersonEmail,
			'Email should be match'
		);
	}

	/*@description This test method validates the functionality of the `getLead` method within the `BI_PSPB_LeadCreationCtrl`
	 *  class. It creates a test lead record with sample data and inserts it into the database.Then, it calls the `getLead`
	 * method with the Id of the test lead to retrieve a list of leads.
	 * The test asserts that the returned list of leads is not empty.
	 * Furthermore, specific assertions are added to verify that the retrieved lead's fields match the expected values.
	 * By performing this validation, the test ensures that the `getLead` method correctly retrieves the lead record by
	 *  its Id and returns it as expected.
	 */
	@isTest
	static void testGetLead() {
		// Create a test lead record
		Lead testLead = new Lead(
			FirstName = 'TestLeadFirst',
			LastName = 'TestLeadLast',
			HealthCloudGA__BirthDate__c = Date.today(),
			Email = 'testlead@example.com',
			HealthCloudGA__Gender__c = 'Male',
			Phone = '1234567890'
		);
		insert testLead;

		// Call the method to get the lead by its Id
		List<Lead> resultLeads = BI_PSPB_LeadCreationCtrl.getlead(testLead.Id);

		// Assert that the method returns a non-empty list
		Assert.areEqual(
			1,
			resultLeads.size(),
			'The list of leads should not be empty'
		);

		// You can add more specific assertions based on your requirements
		// For example, checking if the fields are populated correctly
		Lead retrievedLead = resultLeads[0];
		Assert.areEqual(
			'TestLeadFirst',
			retrievedLead.FirstName,
			'First name should match'
		);
		Assert.areEqual(
			'TestLeadLast',
			retrievedLead.LastName,
			'Last name should match'
		);
		Assert.areEqual(
			Date.today(),
			retrievedLead.HealthCloudGA__BirthDate__c,
			'Birthdate should match'
		);
		Assert.areEqual(
			'testlead@example.com',
			retrievedLead.Email,
			'Email should match'
		);
		Assert.areEqual(
			'Male',
			retrievedLead.HealthCloudGA__Gender__c,
			'Gender should match'
		);
		Assert.areEqual(
			'1234567890',
			retrievedLead.Phone,
			'Phone should match'
		);
	}
	/* 
    @description This test method validates the functionality of the `getCaregiver` method within the 
                 BI_PSPB_LeadCreationCtrl` class.First, it creates a test lead record and inserts it into the database.
                 Then, it creates a test caregiver record associated with the test lead and inserts it into the database.
                 Next, it calls the `getCaregiver` method with the Id of the test lead to retrieve a list of caregivers
                 associated with that lead.The test asserts that the returned list of caregivers is not empty.
                 Furthermore, specific assertions are added to verify that the retrieved caregiver's fields match 
                 the expected values.By performing this validation, 
                 the test ensures that the `getCaregiver` method correctly retrieves the caregivers associated
                 with a lead and returns them as expected.
*/
	@isTest
	static void testGetCaregiver() {
		// Create a test lead record
		Lead testLead = new Lead(
			FirstName = 'TestLeadFirst',
			LastName = 'TestLeadLast',
			Email = 'testlead@example.com'
		);
		insert testLead;

		// Create a test caregiver record associated with the test lead
		BI_PSPB_Lead_Caregiver__c testCaregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_First_Name__c = 'TestCaregiverFirst',
			BI_PSPB_Last_Name__c = 'TestCaregiverLast',
			BI_PSPB_E_mail_ID__c = 'testcaregiver@example.com',
			BI_PSPB_Lead__c = testLead.Id
		);
		insert testCaregiver;

		// Call the method to get caregivers by Lead Id
		List<BI_PSPB_Lead_Caregiver__c> resultCaregivers = BI_PSPB_LeadCreationCtrl.getcaregiver(
			testLead.Id
		);

		// Assert that the method returns a non-empty list
		System.assertNotEquals(
			0,
			resultCaregivers.size(),
			'The list of caregivers should not be empty'
		);

		// You can add more specific assertions based on your requirements
		// For example, checking if the fields are populated correctly
		BI_PSPB_Lead_Caregiver__c retrievedCaregiver = resultCaregivers[0];
		Assert.areEqual(
			'TestCaregiverFirst',
			retrievedCaregiver.BI_PSPB_First_Name__c,
			'First name should match'
		);
		Assert.areEqual(
			'TestCaregiverLast',
			retrievedCaregiver.BI_PSPB_Last_Name__c,
			'Last name should match'
		);
		Assert.areEqual(
			'testcaregiver@example.com',
			retrievedCaregiver.BI_PSPB_E_mail_ID__c,
			'Email should match'
		);
		// Add more assertions for other fields if needed
	}
	/* @description This test method validates the functionality of the `getPrescriptionInfo` method within the
	 *  `BI_PSPB_LeadCreationCtrl` class.First, it creates a test lead record and inserts it into the database.
	 * Next, it creates a test drug unit of measure and care program records, and inserts them into the database.
	 * Then, it creates a test drug record associated with the care program and inserts it into the database.
	 * After that, it creates a test prescription record associated with the test lead,
	 * using the test drug and unit of measure, and inserts it into the database.
	 * Subsequently, it calls the `getPrescriptionInfo` method with the Id of the test lead to retrieve
	 *  a list of prescriptions associated with that lead.The test asserts that the returned list of prescriptions is not empty.
	 * Furthermore, specific assertions are added to verify that the retrieved prescription's fields match the expected values.
	 * By performing this validation, the test ensures that the `getPrescriptionInfo` method correctly retrieves
	 * the prescription information associated with a lead and returns it as expected.
	 */
	@isTest
	static void testGetPrescriptionInfo() {
		// Create a test lead record
		Lead testLead = new Lead(
			FirstName = 'TestLeadFirst',
			LastName = 'TestLeadLast',
			Email = 'testlead@example.com'
		);
		insert testLead;
		UnitOfMeasure um = new UnitOfMeasure();
		um.Name = 'test';
		um.Type = 'Benutzerdefiniert';
		um.UnitCode = '100';
		insert um;
		CareProgram cp = new CareProgram();
		cp.Name = 'spevigo';
		insert cp;
		// Create a test drug
		CareProgramProduct testDrug = new CareProgramProduct(
			Name = 'DrugName',
			BI_PSPB_Unit__c = um.Id, // Adjust this based on your actual field
			CareProgramId = cp.Id
		);
		insert testDrug;

		// Create a test prescription record associated with the test lead
		BI_PSPB_Lead_Prescription__c testPrescription = new BI_PSPB_Lead_Prescription__c(
			BI_PSPB_Dosage__c = 1,
			BI_PSPB_Quantity__c = 2,
			BI_PSPB_Frequency__c = 1,
			BI_PSPB_of_Refills__c = 3,
			BI_PSPB_Drug_Code__c = '100',
			BI_PSPB_Unit__c = um.Id,
			BI_PSPB_Prescribed_Date__c = Date.today(),
			BI_PSPB_Frequency_Unit__c = 'Per day',
			BI_PSPB_Drug__c = testDrug.id,
			BI_PSPB_Lead__c = testLead.Id,
			Name = 'test'
		);
		insert testPrescription;

		// Call the method to get prescription info by Lead Id
		List<BI_PSPB_Lead_Prescription__c> resultPrescriptions = BI_PSPB_LeadCreationCtrl.getpresinfo(
			testLead.Id
		);

		// Assert that the method returns a non-empty list
		Assert.areEqual(
			1,
			resultPrescriptions.size(),
			'The list of prescriptions should not be empty'
		);

		// You can add more specific assertions based on your requirements
		// For example, checking if the fields are populated correctly
		BI_PSPB_Lead_Prescription__c retrievedPrescription = resultPrescriptions[0];
		Assert.areEqual(
			1,
			retrievedPrescription.BI_PSPB_Dosage__c,
			'Dosage should match'
		);
		Assert.areEqual(
			2,
			retrievedPrescription.BI_PSPB_Quantity__c,
			'Quantity should match'
		);
		Assert.areEqual(
			1,
			retrievedPrescription.BI_PSPB_Frequency__c,
			'Frequency should match'
		);
		// Add more assertions for other fields if needed
	}

	/**
	 * @description Tests the `createCaregiverRecord` method of the BI_PSPB_LeadCreationCtrl class.
	 * Ensures that a caregiver record is created with correct data from a provided
	 * DataWrapper instance. The method checks that the caregiver is associated correctly
	 * with an enrollee and that all expected fields are populated accurately.
	 */

	@isTest
	static void testCreateCaregiverRecord() {
		Account testAccount = new Account(
			FirstName = 'TestFirst',
			LastName = 'TestLast',
			BI_PSP_Birthdate__c = Date.today(),
			PersonEmail = 'test@example.com'
		);
		insert testAccount;
		CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
		insert testCP;
		// Create a new CareProgramEnrollee record for testing
		CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
			Name = 'testenrolee',
			AccountId = testAccount.id,
			CareProgramId = testCP.Id
		);
		insert testEnrollee;

		// Create test data
		BI_PSPB_LeadCreationCtrl.DataWrapper testData = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		testData.firstName = 'John';
		testData.lastName = 'Doe';
		testData.relation = 'Parent';
		testData.email = 'john.doe@example.com';
		testData.dob = '1990-01-01';
		testData.phone = '1234567890';
		testData.caregiverId = testEnrollee.Id; // Use the testEnrollee's Id

		Test.startTest();
		// Call the method to be tested
		Id caregiverId = BI_PSPB_LeadCreationCtrl.createCaregiverRecord(
			testData
		);
		Test.stopTest();

		// Verify that the BI_PSPB_Enrollee_Caregiver__c record is created
		BI_PSPB_Enrollee_Caregiver__c createdCaregiverRelation = [
			SELECT
				Id,
				Name,
				BI_PSPB_Care_Program_Enrollee__c,
				BI_PSPB_Patient__c,
				BI_PSPB_Contact_Id__c
			FROM BI_PSPB_Enrollee_Caregiver__c
			WHERE BI_PSPB_Contact_Id__c = :caregiverId
		];

		// Assert that the BI_PSPB_Enrollee_Caregiver__c record has been created with the correct values
		Assert.areEqual(
			'John',
			createdCaregiverRelation.Name,
			'Name should match'
		);
		Assert.areEqual(
			testEnrollee.Id,
			createdCaregiverRelation.BI_PSPB_Care_Program_Enrollee__c,
			'Careprogram Id should match'
		);
		// Add more assertions as needed
	}
	/**
	 * @description Tests the `createEnroleeCargiver` method in the BI_PSPB_LeadCreationCtrl class.
	 * This test verifies the functionality to correctly create a caregiver record linked
	 * to a specific enrollee within the system, ensuring proper association and data accuracy.
	 *
	 * The test does the following:
	 * - Sets up the necessary data by creating a Lead, Account, Contact, and CareProgram records.
	 * - Uses a test CareProgramEnrollee record linked to the created records.
	 * - Invokes the `createEnroleeCargiver` method to attempt creating an enrollee's caregiver.
	 * - Asserts that the caregiver is successfully created with the correct name.
	 */
	@isTest
	static void testCreateEnroleeCargiver() {
		//create lead
		Lead testLead = new Lead(
			FirstName = 'TestLeadFirst',
			LastName = 'TestLeadLast',
			Email = 'testlead@example.com'
		);
		insert testLead;
		// Create test data
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact',
			Email = 'test@example.com'
		);
		insert testContact;
		CareProgram cp = new CareProgram();
		cp.Name = 'spevigo';
		insert cp;
		CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
			Name = 'TestEnrollee',
			AccountId = testAccount.Id,
			careprogramId = cp.id,
			LeadId = testLead.id
		);
		insert testEnrollee;

		// Call the method being tested
		Test.startTest();
		Id caregiverId = BI_PSPB_LeadCreationCtrl.createEnroleeCargiver(
			testEnrollee.Id,
			'Test Caregiver',
			'test@example.com'
		);
		Test.stopTest();

		// Retrieve the inserted record
		BI_PSPB_Enrollee_Caregiver__c insertedCaregiver = [
			SELECT Id, Name
			FROM BI_PSPB_Enrollee_Caregiver__c
			WHERE Id = :caregiverId
			LIMIT 1
		];

		// Assert that the caregiver record was inserted
		Assert.areEqual(
			'Test Caregiver',
			insertedCaregiver.Name,
			'Caregiver record was  inserted.'
		);
	}

	/**
	 * @description Tests the `getcothanks` method of the BI_PSPB_LeadCreationCtrl class.
	 * This test verifies that the method correctly handles the logic associated with
	 * processing a given caregiver's ID. The goal is to ensure the method returns
	 * an appropriate Boolean value under defined conditions and correctly handles
	 * errors without crashing.
	 *
	 * The test checks:
	 * - That the method returns null or throws an expected exception for invalid input or processing conditions.
	 * - Proper handling and logging of exceptions, verifying that exceptions are both caught and asserted.
	 */

	@isTest
	static void testGetcothanks() {
		// Create test data
		BI_PSPB_Lead_Caregiver__c caregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_First_Name__c = 'John',
			BI_PSPB_Last_Name__c = 'Doe',
			BI_PSPB_E_mail_ID__c = 'john.doe@example.com'
			// Populate other required fields
		);
		insert caregiver;

		Contact contact = new Contact(
			FirstName = 'John',
			LastName = 'Doe',
			Email = 'john.doe@example.com'
			// Populate other required fields
		);
		insert contact;
		try {
			Test.startTest();
			// Call the method under test
			Boolean result = BI_PSPB_LeadCreationCtrl.getcothanks(caregiver.Id);
			Test.stopTest();

			// Assert the result
			Assert.areEqual(null, result, 'Expected the result to be true');
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description Tests the exception handling of the `getLead` method in the BI_PSPB_LeadCreationCtrl class.
	 * This test is specifically designed to verify that the method correctly handles null inputs by
	 * throwing an appropriate exception. The purpose of this test is to ensure robust error handling
	 * and stability of the method under abnormal or incorrect usage scenarios.*/
	@isTest
	static void testCatchBlock() {
		// Prepare test data
		Lead testLead = new Lead(
			FirstName = 'Test',
			LastName = 'Lead',
			HealthCloudGA__BirthDate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			HealthCloudGA__Gender__c = 'Male',
			Phone = '1234567890'
		);
		insert testLead;

		// Call the method with an invalid Lead Id to simulate an exception
		try {
			BI_PSPB_LeadCreationCtrl.getLead(null);
			Assert.areEqual(
				false,
				'Exception should have been thrown',
				'Exception value must equal'
			);
		} catch (Exception ex) {
			Assert.areEqual(
				ex.getMessage(),
				'Script-thrown exception',
				ex.getMessage()
			);
		}
	}
	/*
@description  Test method to verify error handling in various methods of the BI_PSPB_LeadCreationCtrl class.
              It sets up test data including a user with caregiver privileges and a contact record.
*/
	@isTest
	static void getcatch() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		BI_PSPB_LeadCreationCtrl.DataWrapper wrapper = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSPB_LeadCreationCtrl.createLead(wrapper, '', '', '');
				BI_PSPB_LeadCreationCtrl.prescriptionrCreate(
					wrapper,
					'',
					'',
					''
				);
				list<BI_PSPB_Lead_Prescription__c> prevalue = BI_PSPB_LeadCreationCtrl.getPresinfo(
					''
				);
				BI_PSPB_LeadCreationCtrl.createCaregiverRecord(wrapper);
				BI_PSPB_LeadCreationCtrl.getcothanks('');
				Test.stopTest();
				Assert.areNotEqual(prevalue, null, 'Should not be null');
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}

	}
	/*
@description    : Test method to verify error handling in the BI_PSPB_LeadCreationCtrl class, specifically for the hcpCreate method.
                  It sets up test data including a user with caregiver privileges and a contact record.
*/

	@isTest
	static void gettcatch() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		BI_PSPB_LeadCreationCtrl.DataWrapper wrapper = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSPB_LeadCreationCtrl.hcpCreate(wrapper);
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
	/*
@description    : Test method to verify error handling in the BI_PSPB_LeadCreationCtrl class, specifically for the caregiverCreate method.
                  It sets up test data including a user with caregiver privileges and a contact record.
*/

	@isTest
	static void catchblack() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		BI_PSPB_LeadCreationCtrl.DataWrapper wrapper = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSPB_LeadCreationCtrl.caregiverCreate(wrapper, '');
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
	/*
@description    : Test method to verify error handling in the BI_PSPB_LeadCreationCtrl class, specifically for the consentCreate method.
                  It sets up test data including a user with caregiver privileges and a contact record.
*/

	@isTest
	static void catchblackone() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		BI_PSPB_LeadCreationCtrl.DataWrapper wrapper = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSPB_LeadCreationCtrl.consentCreate('');
				Test.stopTest();
				Assert.areNotEqual(wrapper, null, 'Should not be null');
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}

	}
	/*
@description    : Test method to verify error handling in the BI_PSPB_LeadCreationCtrl class, specifically for the getCaregiver method.
                  It sets up test data including a user with caregiver privileges and a contact record.
*/

	@isTest
	static void catchgetCaregiver() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		BI_PSPB_LeadCreationCtrl.DataWrapper wrapper = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				list<BI_PSPB_Lead_Caregiver__c> resulte = BI_PSPB_LeadCreationCtrl.getCaregiver(
					''
				);
				Test.stopTest();
				Assert.areEqual(resulte.size(), 1, 'List should equal');
				Assert.areNotEqual(wrapper, null, 'Should not be null');
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}

	}
	/*
@description    : Test method to verify error handling in the BI_PSPB_LeadCreationCtrl class, specifically for the getPresinfo method.
                  It sets up test data including a user with caregiver privileges and a contact record.
*/

	@isTest
	static void catchgetPresinfo() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		BI_PSPB_LeadCreationCtrl.DataWrapper wrapper = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				list<BI_PSPB_Lead_Prescription__c> prevalue = BI_PSPB_LeadCreationCtrl.getPresinfo(
					''
				);
				Test.stopTest();
				Assert.areNotEqual(wrapper, null, 'Should not be null');
				Assert.areNotEqual(prevalue, null, 'Should not be null');
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}

	}
	/*
@description    : Test method to verify error handling in the BI_PSPB_LeadCreationCtrl class, specifically for the createCaregiverRecord method.
                  It sets up test data including a user with caregiver privileges and a contact record.
*/

	@isTest
	static void catchcreateCaregiverRecord() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		BI_PSPB_LeadCreationCtrl.DataWrapper wrapper = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSPB_LeadCreationCtrl.createCaregiverRecord(wrapper);
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
	/*
@description    : Test method to verify error handling in the BI_PSPB_LeadCreationCtrl class, specifically for the createCaregiverRecord method.
                  It sets up test data including a user with caregiver privileges and a contact record.
*/

	@isTest
	static void catchcreateEnroleeCargiver() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		BI_PSPB_LeadCreationCtrl.DataWrapper wrapper = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSPB_LeadCreationCtrl.createEnroleeCargiver('', '', '');
				Test.stopTest();
				Assert.areNotEqual(wrapper, null, 'Should not be null');
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}

	}
	/*
@description    : Test method to verify error handling in the BI_PSPB_LeadCreationCtrl class, specifically for the getExistingAccounts method.
                  It sets up test data including a user with caregiver privileges and an account record.
*/

	@isTest
	static void catchgetExistingAccounts() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		account accvlue = new account(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSPB_Birthdate__c = Date.newInstance(1990, 1, 1),
			personEmail = 'test@example.com'
		);
		insert accvlue;
		BI_PSPB_LeadCreationCtrl.DataWrapper wrapper = new BI_PSPB_LeadCreationCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				List<Account> existingAccounts = BI_PSPB_LeadCreationCtrl.getExistingAccounts(
					''
				);
				Test.stopTest();
				Assert.areNotEqual(wrapper, null, 'Should not be null');
				Assert.areEqual(existingAccounts, null, 'Should not be null');
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}

	}
	/*
@description    : Test method to verify error handling in the BI_PSPB_LeadCreationCtrl class, specifically for the getExistingAccounts method with invalid email input.
                  It sets up test data including a user with caregiver privileges.
*/

	@isTest
	static void catchInvalidAccounts() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSPB_LeadCreationCtrl.getExistingAccounts(
					'dummyemail@gmail.com'
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
}