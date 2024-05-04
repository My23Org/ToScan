/*
 * @description Test class for testing the conversion of Leads to Patient accounts in the BI_PSPB_LeadConvertMultiple class.
 * This class includes test methods for various scenarios related to lead conversion and handling patient status.
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023     Created             Initial development
 * 1.1      Ashif  04-Apr-2024     Updated             Catch log added
 */
@isTest
public class BI_PSPB_LeadConvertMultipleTest {
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'ApplicationName'
	);
	/**
	 * @description This test method verifies the conversion of Leads to Patient accounts. It creates sample data
	 * including Leads, Contacts, Accounts, and related objects, then tests the conversion process using the
	 * BI_PSPB_LeadConvertMultiple.convertlead() method. It asserts that the correct number of accounts
	 * are created after lead conversion.
	 */
	@isTest
	public static void converLeadTest() {
		CareProgram care = new CareProgram(
			Description = 'atest',
			Name = 'Spevigo',
			Status = 'Active',
			StartDate = system.today() - 500,
			EndDate = system.today() - 500
		);

		insert care;
		CareProgram care2 = new CareProgram(
			Description = 'btest',
			Name = 'Spevigo',
			Status = 'Active',
			StartDate = system.today() - 500,
			EndDate = system.today() - 500
		);

		insert care2;
		Account Acc = new Account(Name = 'ragunath', Type = 'EDI');
		insert Acc;
		Account Acc2 = new Account(Name = 'ragunath2', Type = 'EDI');
		insert Acc2;

		RecordType rt = [
			SELECT Id
			FROM RecordType
			WHERE
				SObjectType = 'Contact'
				AND DeveloperName = 'BI_PSPB_Caregiver'
		];
		Contact con = new Contact(
			FirstName = 'jhon',
			LastName = 'benny',
			BI_PSPB_Relationship_To_Patient__c = 'Parent',
			MiddleName = 'mohana',
			Birthdate = system.today() - 500,
			Email = 'As1@gmail.com',
			Phone = '1234567890',
			AccountId = Acc.id,
			BI_PSPB_Practice_Name__c = Acc.id,
			RecordTypeId = rt.Id
		);
		insert con;
		Contact con2 = new Contact(
			FirstName = 'jhon2',
			LastName = 'benny2',
			BI_PSPB_Relationship_To_Patient__c = 'Parent',
			MiddleName = 'mohana',
			Birthdate = system.today() - 500,
			Email = 'As@gmail.com',
			Phone = '1234567899',
			AccountId = Acc2.id,
			BI_PSPB_Practice_Name__c = Acc2.id,
			RecordTypeId = rt.Id
		);
		insert con2;

		Lead le = new Lead(
			FirstName = 'jhon',
			LastName = 'benny' + datetime.now(),
			LeadSource = 'Other',
			HealthCloudGA__Gender__c = 'Male',
			HealthCloudGA__BirthDate__c = Date.today().addYears(-15),
			CountryCode = 'US',
			Street = '1/1 Street',
			City = 'Ramnad',
			StateCode = 'AK',
			PostalCode = '623525',
			Email = 'As@gmail.com',
			MobilePhone = '1234567890',
			BI_PSPB_Enrolled_By__c = 'Healthcare Provider',
			BI_PSPB_Care_Program__c = care.Id,
			BI_PSPB_Physician_Name_c__c = con.Id,
			BI_PSPB_Preferred_Communication_Method__c = 'Email'
		);

		insert le;

		Lead le22 = new Lead(
			FirstName = 'jhon2',
			LastName = 'benny2' + datetime.now(),
			LeadSource = 'Other',
			HealthCloudGA__Gender__c = 'Male',
			HealthCloudGA__BirthDate__c = Date.today().addYears(-15),
			CountryCode = 'US',
			Street = '1/1 Street',
			City = 'Ramnad',
			StateCode = 'AK',
			PostalCode = '623525',
			Email = 'Asf@gmail.com',
			MobilePhone = '1234567891',
			BI_PSPB_Enrolled_By__c = 'Healthcare Provider',
			BI_PSPB_Care_Program__c = care.Id,
			BI_PSPB_Physician_Name_c__c = con2.Id,
			BI_PSPB_Preferred_Communication_Method__c = 'Email'
		);

		insert le22;

		List<id> idlist = new List<id>{ le.Id, le22.Id };
		BI_PSPB_Lead_Caregiver__c testLeadCaregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_First_Name__c = 'TestCaregiverFirstName',
			BI_PSPB_Last_Name__c = 'TestCaregiverLastName',
			BI_PSPB_E_mail_ID__c = 'As@gmail.com',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(1990, 1, 1),
			BI_PSPB_Lead__c = le.Id
			// Add other required fields
		);
		insert testLeadCaregiver;
		BI_PSPB_Lead_Caregiver__c testLeadCaregiver2 = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_First_Name__c = 'TestCaregiverFirstName',
			BI_PSPB_Last_Name__c = 'TestCaregiverLastName',
			BI_PSPB_E_mail_ID__c = 'As2@gmail.com',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(1990, 1, 1),
			BI_PSPB_Lead__c = le22.Id
			// Add other required fields
		);
		insert testLeadCaregiver2;

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
			CareProgramId = care.Id
		);
		insert testDrug;
		BI_PSPB_Lead_Prescription__c LP = new BI_PSPB_Lead_Prescription__c(
			BI_PSPB_Lead__c = le.Id,
			BI_PSPB_Drug__c = testDrug.Id,
			BI_PSPB_Dosage__c = 10,
			BI_PSPB_Quantity__c = 2,
			BI_PSPB_Frequency__c = 12,
			BI_PSPB_of_Refills__c = 23,
			BI_PSPB_Drug_Code__c = '100',
			BI_PSPB_Unit__c = um.Id,
			BI_PSPB_Frequency_Unit__c = 'Per day',
			BI_PSPB_Prescribed_Date__c = system.today() - 500
		);

		insert LP;
		BI_PSPB_Lead_Prescription__c LP2 = new BI_PSPB_Lead_Prescription__c(
			BI_PSPB_Lead__c = le22.Id,
			BI_PSPB_Drug__c = testDrug.Id,
			BI_PSPB_Dosage__c = 10,
			BI_PSPB_Quantity__c = 2,
			BI_PSPB_Frequency__c = 12,
			BI_PSPB_of_Refills__c = 23,
			BI_PSPB_Drug_Code__c = '100',
			BI_PSPB_Unit__c = um.Id,
			BI_PSPB_Frequency_Unit__c = 'Per day',
			BI_PSPB_Prescribed_Date__c = system.today() - 500
		);

		insert LP2;
		String recType = [
			SELECT Id
			FROM RecordType
			WHERE
				Name = 'BI_PSP_Challenge'
				AND SobjectType = 'HealthCloudGA__CarePlanTemplate__c'
		]
		.Id;
		HealthCloudGA__CarePlanTemplate__c careplanTemp = new HealthCloudGA__CarePlanTemplate__c(
			Name = 'challenge',
			recordtypeId = recType,
			HealthCloudGA__Description__c = 'Description',
			BI_PSP_Challenge_Level__c = 'Level 1',
			BI_PSP_Challenge_Reward_Points__c = 30
		);
		insert careplanTemp;
		HealthCloudGA__CareProgramPlanTemplate__c careprogram = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CareProgram__c = cp.Id,
			HealthCloudGA__CarePlanTemplate__c = careplanTemp.Id
		);
		insert careprogram;
		HealthCloudGA__CareProgramPlanTemplate__c careprogram1 = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CareProgram__c = cp.Id,
			HealthCloudGA__CarePlanTemplate__c = careplanTemp.Id
		);
		insert careprogram1;
		CareProgramEnrollee enrolle = new CareProgramEnrollee(
			Name = 'challengeenrolle',
			AccountId = Acc.Id,
			CareProgramId = care2.Id
		);
		insert enrolle;

		Medication md = new Medication();
		md.Name = 'testmd';
		md.BI_PSPB_Care_Program__c = le.BI_PSPB_Care_Program__c;
		insert md;
		Test.startTest();

		BI_PSPB_LeadConvertMultiple.convertlead(idlist);
		Test.stopTest();
		list<Account> accounts = [SELECT id FROM Account];
		System.assertEquals(
			8,
			accounts.size(),
			'Incorrect number of accounts created after Lead conversion'
		);
	}

	/**
	 * @description This test method verifies the functionality of the getContact() method in the BI_PSPB_LeadConvertMultiple class.
	 * It inserts test data including an Account and a Contact with a specific practice name. Then, it calls the getContact() method
	 * with the ID of the test contact and asserts that the method returns the expected result, ensuring that the contact is found.
	 */
	@isTest
	static void testGetContactFound() {
		// Insert test data
		Account acc = new Account();
		acc.Name = 'testname';
		insert acc;
		Contact testContact = new Contact(
			LastName = 'TestPhysician',
			BI_PSPB_Practice_Name__c = acc.id
		);
		insert testContact;

		// Call the method being tested
		Test.startTest();
		List<Contact> result = BI_PSPB_LeadConvertMultiple.getContact(
			testContact.Id
		);
		Test.stopTest();

		// Assert that the method returns the expected result
		System.assertEquals(1, result.size(), 'Contact should be found');
	}

	/**
	 * @description This test method verifies the behavior of the convertlead() method in the BI_PSPB_LeadConvertMultiple class when
	 * called with an empty list of lead IDs. It ensures that the method handles this scenario appropriately, such as not attempting
	 * lead conversion and not creating any new accounts.
	 */
	@isTest
	public static void converLeadNegativeTest() {
		CareProgram care = new CareProgram(
			Description = 'atest',
			Name = 'Spevigo',
			Status = 'Active',
			StartDate = system.today() - 500,
			EndDate = system.today() - 500
		);

		insert care;
		CareProgram care2 = new CareProgram(
			Description = 'btest',
			Name = 'Spevigo',
			Status = 'Active',
			StartDate = system.today() - 500,
			EndDate = system.today() - 500
		);

		insert care2;
		Account Acc = new Account(Name = 'ragunath', Type = 'EDI');
		insert Acc;
		Account Acc2 = new Account(Name = 'ragunath2', Type = 'EDI');
		insert Acc2;

		Contact con = new Contact(
			FirstName = 'jhon',
			LastName = 'benny',
			BI_PSPB_Relationship_To_Patient__c = 'Parent',
			MiddleName = 'mohana',
			Birthdate = system.today() - 500,
			Email = 'As1@gmail.com',
			Phone = '1234567890',
			AccountId = Acc.id,
			BI_PSPB_Practice_Name__c = Acc.id
		);
		insert con;
		Contact con2 = new Contact(
			FirstName = 'jhon2',
			LastName = 'benny2',
			BI_PSPB_Relationship_To_Patient__c = 'Parent',
			MiddleName = 'mohana',
			Birthdate = system.today() - 500,
			Email = 'As@gmail.com',
			Phone = '1234567899',
			AccountId = Acc2.id,
			BI_PSPB_Practice_Name__c = Acc2.id
		);
		insert con2;

		Lead le = new Lead(
			FirstName = 'jhon',
			LastName = 'benny' + datetime.now(),
			LeadSource = 'Other',
			HealthCloudGA__Gender__c = 'Male',
			HealthCloudGA__BirthDate__c = Date.today().addYears(-15),
			CountryCode = 'US',
			Street = '1/1 Street',
			City = 'Ramnad',
			StateCode = 'AK',
			PostalCode = '623525',
			Email = 'As@gmail.com',
			MobilePhone = '1234567890',
			BI_PSPB_Enrolled_By__c = 'Healthcare Provider',
			BI_PSPB_Care_Program__c = care.Id,
			BI_PSPB_Physician_Name_c__c = con.Id,
			BI_PSPB_Preferred_Communication_Method__c = 'Email'
		);

		insert le;

		Lead le22 = new Lead(
			FirstName = 'jhon2',
			LastName = 'benny2' + datetime.now(),
			LeadSource = 'Other',
			HealthCloudGA__Gender__c = 'Male',
			HealthCloudGA__BirthDate__c = Date.today().addYears(-15),
			CountryCode = 'US',
			Street = '1/1 Street',
			City = 'Ramnad',
			StateCode = 'AK',
			PostalCode = '623525',
			Email = 'Asf@gmail.com',
			MobilePhone = '1234567891',
			BI_PSPB_Enrolled_By__c = 'Healthcare Provider',
			BI_PSPB_Care_Program__c = care.Id,
			BI_PSPB_Physician_Name_c__c = con2.Id,
			BI_PSPB_Preferred_Communication_Method__c = 'Email'
		);

		insert le22;

		BI_PSPB_Lead_Caregiver__c testLeadCaregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_First_Name__c = 'TestCaregiverFirstName',
			BI_PSPB_Last_Name__c = 'TestCaregiverLastName',
			BI_PSPB_E_mail_ID__c = 'As@gmail.com',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(1990, 1, 1),
			BI_PSPB_Lead__c = le.Id
			// Add other required fields
		);
		insert testLeadCaregiver;
		BI_PSPB_Lead_Caregiver__c testLeadCaregiver2 = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_First_Name__c = 'TestCaregiverFirstName',
			BI_PSPB_Last_Name__c = 'TestCaregiverLastName',
			BI_PSPB_E_mail_ID__c = 'As2@gmail.com',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(1990, 1, 1),
			BI_PSPB_Lead__c = le22.Id
			// Add other required fields
		);
		insert testLeadCaregiver2;

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
			CareProgramId = care.Id
		);
		insert testDrug;
		BI_PSPB_Lead_Prescription__c LP = new BI_PSPB_Lead_Prescription__c(
			BI_PSPB_Lead__c = le.Id,
			BI_PSPB_Drug__c = testDrug.Id,
			BI_PSPB_Dosage__c = 10,
			BI_PSPB_Quantity__c = 2,
			BI_PSPB_Frequency__c = 12,
			BI_PSPB_of_Refills__c = 23,
			BI_PSPB_Drug_Code__c = '100',
			BI_PSPB_Unit__c = um.Id,
			BI_PSPB_Frequency_Unit__c = 'Per day',
			BI_PSPB_Prescribed_Date__c = system.today() - 500
		);

		insert LP;
		BI_PSPB_Lead_Prescription__c LP2 = new BI_PSPB_Lead_Prescription__c(
			BI_PSPB_Lead__c = le22.Id,
			BI_PSPB_Drug__c = testDrug.Id,
			BI_PSPB_Dosage__c = 10,
			BI_PSPB_Quantity__c = 2,
			BI_PSPB_Frequency__c = 12,
			BI_PSPB_of_Refills__c = 23,
			BI_PSPB_Drug_Code__c = '100',
			BI_PSPB_Unit__c = um.Id,
			BI_PSPB_Frequency_Unit__c = 'Per day',
			BI_PSPB_Prescribed_Date__c = system.today() - 500
		);

		insert LP2;
		String recType = [
			SELECT Id
			FROM RecordType
			WHERE
				Name = 'BI_PSP_Challenge'
				AND SobjectType = 'HealthCloudGA__CarePlanTemplate__c'
		]
		.Id;
		HealthCloudGA__CarePlanTemplate__c careplanTemp = new HealthCloudGA__CarePlanTemplate__c(
			Name = 'challenge',
			recordtypeId = recType,
			HealthCloudGA__Description__c = 'Description',
			BI_PSP_Challenge_Level__c = 'Level 1',
			BI_PSP_Challenge_Reward_Points__c = 30
		);
		insert careplanTemp;
		HealthCloudGA__CareProgramPlanTemplate__c careprogram = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CareProgram__c = cp.Id,
			HealthCloudGA__CarePlanTemplate__c = careplanTemp.Id
		);
		insert careprogram;
		HealthCloudGA__CareProgramPlanTemplate__c careprogram1 = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CareProgram__c = cp.Id,
			HealthCloudGA__CarePlanTemplate__c = careplanTemp.Id
		);
		insert careprogram1;
		CareProgramEnrollee enrolle = new CareProgramEnrollee(
			Name = 'challengeenrolle',
			AccountId = Acc.Id,
			CareProgramId = care2.Id
		);
		insert enrolle;

		Medication md = new Medication();
		md.Name = 'testmd';
		md.BI_PSPB_Care_Program__c = le.BI_PSPB_Care_Program__c;
		insert md;
		Test.startTest();

		BI_PSPB_LeadConvertMultiple.convertlead(new List<id>());
		Test.stopTest();
        

		list<Account> accounts = [select id from Account];
		System.assertEquals(
			2,
			accounts.size(),
			'Incorrect number of accounts created after Lead conversion'
		);	
    }

	/**
	 * @description This test method verifies the behavior of the getContact() method in the BI_PSPB_LeadConvertMultiple class when
	 * an exception occurs during its execution. It ensures that the method gracefully handles the exception scenario and returns
	 * the expected result.
	 */
	@isTest
	static void testPatientstatusWithException() {
		// Create a test user
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];

		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'testuser12343@example.com',
			UserName = 'testusernew123@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			ProfileId = standardUserProfile.Id,
			BI_PSPB_Caregiver__c = true
		);
		insert testUser;

		// Create a test contact associated with the user
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'Contact',
			Email = testUser.Email,
			BI_PSPB_Selected_Patient_ID__c = testUser.Id
		);
		insert testContact;

		// Create a test account associated with the contact
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		// Mock an exception by forcing a failure in the SOQL query
		try {
			// Call the method to be tested
			System.runAs(testUser) {
				Test.startTest();
				List<Contact> resultnew = BI_PSPB_LeadConvertMultiple.getContact(
					testAccount.Id
				);
				Test.stopTest();

				Assert.areEqual(
					0,
					resultnew.size(),
					'Unexpected result for Patientstatus when an exception occurs'
				);
			}
		} catch (Exception e) {
			// Perform additional assertions if needed
			Assert.areNotEqual(
				null,
				e.getMessage(),
				'Exception message should not be null'
			);
		}
	}

	/**
	 * @description This test method verifies the negative scenario of the convertlead() method in the BI_PSPB_LeadConvertMultiple class.
	 * It ensures that the method gracefully handles the scenario where the input list of lead IDs is empty, resulting in no lead conversion.
	 */
	@isTest
	public static void converLeadTestNegative() {
		CareProgram care = new CareProgram(
			Description = 'atest',
			Name = 'Spevigo',
			Status = 'Active',
			StartDate = system.today() - 500,
			EndDate = system.today() - 500
		);

		insert care;
		CareProgram care2 = new CareProgram(
			Description = 'btest',
			Name = 'Spevigo',
			Status = 'Active',
			StartDate = system.today() - 500,
			EndDate = system.today() - 500
		);

		insert care2;
		Account Acc = new Account(Name = 'ragunath', Type = 'EDI');
		insert Acc;
		Account Acc2 = new Account(Name = 'ragunath2', Type = 'EDI');
		insert Acc2;

		Contact con = new Contact(
			FirstName = 'jhon',
			LastName = 'benny',
			BI_PSPB_Relationship_To_Patient__c = 'Parent',
			MiddleName = 'mohana',
			Birthdate = system.today() - 500,
			Email = 'As1@gmail.com',
			Phone = '1234567890',
			AccountId = Acc.id,
			BI_PSPB_Practice_Name__c = Acc.id
		);
		insert con;
		Contact con2 = new Contact(
			FirstName = 'jhon2',
			LastName = 'benny2',
			BI_PSPB_Relationship_To_Patient__c = 'Parent',
			MiddleName = 'mohana',
			Birthdate = system.today() - 500,
			Email = 'As@gmail.com',
			Phone = '1234567899',
			AccountId = Acc2.id,
			BI_PSPB_Practice_Name__c = Acc2.id
		);
		insert con2;

		Lead le = new Lead(
			FirstName = 'jhon',
			LastName = 'benny' + datetime.now(),
			LeadSource = 'Other',
			HealthCloudGA__Gender__c = 'Male',
			HealthCloudGA__BirthDate__c = Date.today().addYears(-15),
			CountryCode = 'US',
			Street = '1/1 Street',
			City = 'Ramnad',
			StateCode = 'AK',
			PostalCode = '623525',
			Email = 'As@gmail.com',
			MobilePhone = '1234567890',
			BI_PSPB_Enrolled_By__c = 'Healthcare Provider',
			BI_PSPB_Care_Program__c = care.Id,
			BI_PSPB_Physician_Name_c__c = con.Id,
			BI_PSPB_Preferred_Communication_Method__c = 'Email'
		);

		insert le;

		Lead le22 = new Lead(
			FirstName = 'jhon2',
			LastName = 'benny2' + datetime.now(),
			LeadSource = 'Other',
			HealthCloudGA__Gender__c = 'Male',
			HealthCloudGA__BirthDate__c = Date.today().addYears(-15),
			CountryCode = 'US',
			Street = '1/1 Street',
			City = 'Ramnad',
			StateCode = 'AK',
			PostalCode = '623525',
			Email = 'Asf@gmail.com',
			MobilePhone = '1234567891',
			BI_PSPB_Enrolled_By__c = 'Healthcare Provider',
			BI_PSPB_Care_Program__c = care.Id,
			BI_PSPB_Physician_Name_c__c = con2.Id,
			BI_PSPB_Preferred_Communication_Method__c = 'Email'
		);

		insert le22;

		List<id> idlist = new List<id>{ le.Id, le22.Id };

		BI_PSPB_Lead_Caregiver__c testLeadCaregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_First_Name__c = 'TestCaregiverFirstName',
			BI_PSPB_Last_Name__c = 'TestCaregiverLastName',
			BI_PSPB_E_mail_ID__c = 'As@gmail.com',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(1990, 1, 1),
			BI_PSPB_Lead__c = le.Id
			// Add other required fields
		);
		insert testLeadCaregiver;
		BI_PSPB_Lead_Caregiver__c testLeadCaregiver2 = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_First_Name__c = 'TestCaregiverFirstName',
			BI_PSPB_Last_Name__c = 'TestCaregiverLastName',
			BI_PSPB_E_mail_ID__c = 'As2@gmail.com',
			BI_PSPB_Date_of_Birth__c = Date.newInstance(1990, 1, 1),
			BI_PSPB_Lead__c = le22.Id
			// Add other required fields
		);
		insert testLeadCaregiver2;

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
			CareProgramId = care.Id
		);
		insert testDrug;
		BI_PSPB_Lead_Prescription__c LP = new BI_PSPB_Lead_Prescription__c(
			BI_PSPB_Lead__c = le.Id,
			BI_PSPB_Drug__c = testDrug.Id,
			BI_PSPB_Dosage__c = 10,
			BI_PSPB_Quantity__c = 2,
			BI_PSPB_Frequency__c = 12,
			BI_PSPB_of_Refills__c = 23,
			BI_PSPB_Drug_Code__c = '100',
			BI_PSPB_Unit__c = um.Id,
			BI_PSPB_Frequency_Unit__c = 'Per day',
			BI_PSPB_Prescribed_Date__c = system.today() - 500
		);

		insert LP;
		BI_PSPB_Lead_Prescription__c LP2 = new BI_PSPB_Lead_Prescription__c(
			BI_PSPB_Lead__c = le22.Id,
			BI_PSPB_Drug__c = testDrug.Id,
			BI_PSPB_Dosage__c = 10,
			BI_PSPB_Quantity__c = 2,
			BI_PSPB_Frequency__c = 12,
			BI_PSPB_of_Refills__c = 23,
			BI_PSPB_Drug_Code__c = '100',
			BI_PSPB_Unit__c = um.Id,
			BI_PSPB_Frequency_Unit__c = 'Per day',
			BI_PSPB_Prescribed_Date__c = system.today() - 500
		);

		insert LP2;
		String recType = [
			SELECT Id
			FROM RecordType
			WHERE
				Name = 'BI_PSP_Challenge'
				AND SobjectType = 'HealthCloudGA__CarePlanTemplate__c'
		]
		.Id;
		HealthCloudGA__CarePlanTemplate__c careplanTemp = new HealthCloudGA__CarePlanTemplate__c(
			Name = 'challenge',
			recordtypeId = recType,
			HealthCloudGA__Description__c = 'Description',
			BI_PSP_Challenge_Level__c = 'Level 1',
			BI_PSP_Challenge_Reward_Points__c = 30
		);
		insert careplanTemp;
		HealthCloudGA__CareProgramPlanTemplate__c careprogram = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CareProgram__c = cp.Id,
			HealthCloudGA__CarePlanTemplate__c = careplanTemp.Id
		);
		insert careprogram;
		HealthCloudGA__CareProgramPlanTemplate__c careprogram1 = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CareProgram__c = cp.Id,
			HealthCloudGA__CarePlanTemplate__c = careplanTemp.Id
		);
		insert careprogram1;
		CareProgramEnrollee enrolle = new CareProgramEnrollee(
			Name = 'challengeenrolle',
			AccountId = Acc.Id,
			CareProgramId = care2.Id
		);
		insert enrolle;

		Medication md = new Medication();
		md.Name = 'testmd';
		md.BI_PSPB_Care_Program__c = care.id;
		insert md;

		Test.startTest();

		BI_PSPB_LeadConvertMultiple.convertlead(idlist);
		Test.stopTest();

		list<Account> accounts = [SELECT id FROM Account];
		System.assertEquals(
			4,
			accounts.size(),
			'Incorrect number of accounts created after Lead conversion'
		);
	}
}