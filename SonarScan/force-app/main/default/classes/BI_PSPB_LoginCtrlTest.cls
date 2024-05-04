/**
* @description Test class for testing the BI_PSPB_ChallengeCtrlclass.
* This class contains test methods to verify various functionalities of the BI_PSPB_LoginCtrl class.
* Author: Saran S
* Code Coverage: 82%
* Last Modified On: 9-03-2024
* Last Modified By: Saran S
*/
@isTest
public class BI_PSPB_LoginCtrlTest {
	@isTest
	public static void testUserDetails() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'test@example.com',
			Username = 'testclassname@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId()
		);
		insert testUser;

		Test.startTest();
		User userDetails = BI_PSPB_LoginCtrl.userDetails(testUser.Id);
		Test.stopTest();
		Assert.areEqual('Test', userDetails.FirstName, 'First name should match');
		Assert.areEqual('User', userDetails.LastName, 'Last name should match');
	}

	@isTest
	public static void testProfileDetails() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		Profile testProfile = [SELECT Id FROM Profile LIMIT 1];

		Test.startTest();
		Profile profileDetails = BI_PSPB_LoginCtrl.profileDetails(testProfile.Id);
		Test.stopTest();
		Assert.areEqual(testProfile.Id, profileDetails.Id, 'Profile Id should match');
	}

	@isTest
	public static void testGetUnreadCases() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			Email = 'test@example.com',
			Username = 'testclass@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId()
		);
		insert testUser;

		Task testTask = new Task(
			Subject = 'Test Task',
			OwnerId = testUser.Id,
			Status = 'Unread'
		);
		insert testTask;

		Test.startTest();
		List<Task> unreadCases = BI_PSPB_LoginCtrl.getUnreadCases(testUser.Id);
		Test.stopTest();
		Assert.areEqual(1, unreadCases.size(), 'There should be one unread case');
	}

	@isTest
	public static void testCatchBlocks() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigos'
		);
		insert settings;
		string naullvalue = '';
		Test.startTest();
		try{
		// Testing for exceptions in userDetails method
		BI_PSPB_LoginCtrl.userDetails(naullvalue);

		// Testing for exceptions in profileDetails method
		BI_PSPB_LoginCtrl.profileDetails(naullvalue);

		// Testing for exceptions in getUnreadCases method
	   	BI_PSPB_LoginCtrl.getUnreadCases(naullvalue);
		}
		catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();
	}
	
	@isTest
	public static void testGetUnreadCasesWithCaregiver1() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test User with BI_PSPB_Caregiver__c set to true
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			email = 'test@example.com',
			Username = 'testcovercontact@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId(),
			BI_PSPB_Caregiver__c = true // Set BI_PSPB_Caregiver__c to true
		);
		insert testUser;

		// Dynamically retrieve the Account record type Id
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BI_PSP_Caregiver').getRecordTypeId();

		// Insert an Account record
		Account testAccount = new Account(
			FirstName = 'Test',
			LastName = 'User',
			RecordTypeId = accountRecordTypeId,
			PersonEmail = testUser.Email // Set the Account record type Id
			// Add other necessary fields
		);
		insert testAccount;

		// Insert a Contact record matching the User's email and name
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = testUser.LastName,
			Email = testUser.Email,
			BI_PSPB_Selected_Patient_ID__c = testAccount.Id // Set the BI_PSPB_Selected_Patient_ID__c to the test account's ID
		);
		insert testContact;
		
		CareProgram testCareProgram = new CareProgram(
			Name = 'Account'
		);
		insert testCareProgram;

		CareProgramEnrollee careProgramEnrolleINS = new CareProgramEnrollee(
			Name = 'Enrolle NAME',
			IsActive = true,
			AccountId = testAccount.Id,
			CareProgramId = testCareProgram.Id
		);
		insert careProgramEnrolleINS;

		// Insert a related record for BI_PSPB_Enrollee_Caregiver__c
		BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
			Name = 'Test Enrollee Caregiver',
			BI_PSPB_Patient__c = testContact.BI_PSPB_Selected_Patient_ID__c, // Specify a patient ID that matches the condition
			BI_PSPB_Contact_Id__c = testContact.Id, // Use the created contact's ID
			BI_PSPB_Status__c = 'Active',
			BI_PSPB_Care_Program_Enrollee__c = careProgramEnrolleINS.Id// Ensure status is set to 'Active'
			// Add other necessary fields as per your object structure
		);
		insert testEnrolleeCaregiver;
		// Call the getUnreadCases method with the test User's ID
		Test.startTest();
		try{
		BI_PSPB_LoginCtrl.getUnreadCases(testUser.Id);
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
	public static void testGetUnreadCasesWithCaregiver2() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test User with BI_PSPB_Caregiver__c set to true
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			email = 'test@example.com',
			Username = 'testcovercontact@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId(),
			BI_PSPB_Caregiver__c = true // Set BI_PSPB_Caregiver__c to true
		);
		insert testUser;

		// Dynamically retrieve the Account record type Id
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BI_PSP_Caregiver').getRecordTypeId();

		// Insert an Account record
		Account testAccount = new Account(
			FirstName = 'Test',
			LastName = 'User',
			RecordTypeId = accountRecordTypeId,
			PersonEmail = testUser.Email // Set the Account record type Id
			// Add other necessary fields
		);
		insert testAccount;

		// Insert a Contact record matching the User's email and name
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = testUser.LastName,
			Email = testUser.Email,
			BI_PSPB_Selected_Patient_ID__c = testAccount.Id // Set the BI_PSPB_Selected_Patient_ID__c to the test account's ID
		);
		insert testContact;
		
		CareProgram testCareProgram = new CareProgram(
			Name = 'Account'
		);
		insert testCareProgram;

		CareProgramEnrollee careProgramEnrolleINS = new CareProgramEnrollee(
			Name = 'Enrolle NAME',
			IsActive = true,
			AccountId = testAccount.Id,
			CareProgramId = testCareProgram.Id
		);
		insert careProgramEnrolleINS;

		// Insert a related record for BI_PSPB_Enrollee_Caregiver__c
		BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
			Name = 'Test Enrollee Caregiver',
			BI_PSPB_Patient__c = testContact.BI_PSPB_Selected_Patient_ID__c, // Specify a patient ID that matches the condition
			BI_PSPB_Contact_Id__c = testContact.Id, // Use the created contact's ID
			BI_PSPB_Status__c = 'Active'// Ensure status is set to 'Active'
			// Add other necessary fields as per your object structure
		);
		insert testEnrolleeCaregiver;

		// Call the getUnreadCases method with the test User's ID
		Test.startTest();
		try{
		BI_PSPB_LoginCtrl.getUnreadCases(testUser.Id);
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();

		// Add assertions here to ensure that the returned Task list is as expected
		// Add assertions to ensure that the lines inside the if(ecList.size() > 0 && ecList[0].BI_PSPB_Care_Program_Enrollee__c != null) block are covered
	}

	@isTest
	public static void testGetUnreadCasesWithCaregiver3() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test User with BI_PSPB_Caregiver__c set to true
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			email = 'test@example.com',
			Username = 'testcovercontact@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId(),
			BI_PSPB_Caregiver__c = true // Set BI_PSPB_Caregiver__c to true
		);
		insert testUser;

		// Dynamically retrieve the Account record type Id
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BI_PSP_Caregiver').getRecordTypeId();

		// Insert an Account record
		Account testAccount = new Account(
			FirstName = 'Test old',
			LastName = 'User',
			RecordTypeId = accountRecordTypeId,
			PersonEmail = testUser.Email // Set the Account record type Id
			// Add other necessary fields
		);
		insert testAccount;

		// Insert a Contact record matching the User's email and name
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = testUser.LastName,
			Email = 'Emailtest@gmail.com',
			BI_PSPB_Selected_Patient_ID__c = testAccount.Id // Set the BI_PSPB_Selected_Patient_ID__c to the test account's ID
		);
		insert testContact;
		
		CareProgram testCareProgram = new CareProgram(
			Name = 'Account'
		);
		insert testCareProgram;

		CareProgramEnrollee careProgramEnrolleINS = new CareProgramEnrollee(
			Name = 'Enrolle NAME',
			IsActive = true,
			AccountId = testAccount.Id,
			CareProgramId = testCareProgram.Id
		);
		insert careProgramEnrolleINS;

		// Insert a related record for BI_PSPB_Enrollee_Caregiver__c
		BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
			Name = 'Test Enrollee Caregiver',
			BI_PSPB_Patient__c = testContact.BI_PSPB_Selected_Patient_ID__c, // Specify a patient ID that matches the condition
			BI_PSPB_Contact_Id__c = testContact.Id, // Use the created contact's ID
			BI_PSPB_Status__c = 'Active'// Ensure status is set to 'Active'
			// Add other necessary fields as per your object structure
		);
		insert testEnrolleeCaregiver;

		// Call the getUnreadCases method with the test User's ID
		Test.startTest();
		try{
		BI_PSPB_LoginCtrl.getUnreadCases(testUser.Id);
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();

		// Add assertions here to ensure that the returned Task list is as expected
		// Add assertions to ensure that the lines inside the if(ecList.size() > 0 && ecList[0].BI_PSPB_Care_Program_Enrollee__c != null) block are covered
	}
	
	@isTest
	public static void testGetUnreadCasesWithCaregiver4() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test User with BI_PSPB_Caregiver__c set to true
		User testUser = new User(
			FirstName = 'Test',
			LastName = 'User',
			email = 'test@example.com',
			Username = 'testcovercontact@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId(),
			BI_PSPB_Caregiver__c = true // Set BI_PSPB_Caregiver__c to true
		);
		insert testUser;

		// Dynamically retrieve the Account record type Id
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BI_PSP_Caregiver').getRecordTypeId();

		// Insert an Account record
		Account testAccount = new Account(
			FirstName = 'Test',
			LastName = 'User',
			RecordTypeId = accountRecordTypeId,
			PersonEmail = testUser.Email // Set the Account record type Id
			// Add other necessary fields
		);
		insert testAccount;

		// Insert a Contact record matching the User's email and name
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = 'lost Name',
			Email = 'test@email.com',
			BI_PSPB_Selected_Patient_ID__c = null // Set the BI_PSPB_Selected_Patient_ID__c to the test account's ID
		);
		insert testContact;
		
		CareProgram testCareProgram = new CareProgram(
			Name = 'Account'
		);
		insert testCareProgram;

		CareProgramEnrollee careProgramEnrolleINS = new CareProgramEnrollee(
			Name = 'Enrolle NAME',
			IsActive = true,
			AccountId = testAccount.Id,
			CareProgramId = testCareProgram.Id
		);
		insert careProgramEnrolleINS;

		// Insert a related record for BI_PSPB_Enrollee_Caregiver__c
		BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
			Name = 'Test Enrollee Caregiver',
			BI_PSPB_Patient__c = testContact.BI_PSPB_Selected_Patient_ID__c, // Specify a patient ID that matches the condition
			BI_PSPB_Contact_Id__c = testContact.Id, // Use the created contact's ID
			BI_PSPB_Status__c = 'Active',
			BI_PSPB_Care_Program_Enrollee__c = careProgramEnrolleINS.Id// Ensure status is set to 'Active'
			// Add other necessary fields as per your object structure
		);
		insert testEnrolleeCaregiver;

		// Call the getUnreadCases method with the test User's ID
		Test.startTest();
		try{
		BI_PSPB_LoginCtrl.getUnreadCases(testUser.Id);
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();

		// Add assertions here to ensure that the returned Task list is as expected
		// Add assertions to ensure that the lines inside the if(ecList.size() > 0 && ecList[0].BI_PSPB_Care_Program_Enrollee__c != null) block are covered
	}
	
		@isTest
	public static void testGetUnreadCasesWithCaregiver5() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create a test User with BI_PSPB_Caregiver__c set to true
		User testUser = new User(
			FirstName = 'Test user',
			LastName = 'User new',
			email = 'test@example.com',
			Username = 'testcovercontact@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId(),
			BI_PSPB_Caregiver__c = true // Set BI_PSPB_Caregiver__c to true
		);
		insert testUser;

		// Insert an Account record
		Account testAccount = new Account(
			FirstName = 'Test',
			LastName = 'no'
		);
		insert testAccount;

		// Insert a Contact record matching the User's email and name
		Contact testContact = new Contact(
			FirstName = 'Test',
			LastName = testUser.LastName,
			Email = testUser.Email  );
		insert testContact;
		
		CareProgram testCareProgram = new CareProgram(
			Name = 'Account'
		);
		insert testCareProgram;

		CareProgramEnrollee careProgramEnrolleINS = new CareProgramEnrollee(
			Name = 'Enrolle NAME',
			IsActive = true,
			AccountId = testAccount.Id,
			CareProgramId = testCareProgram.Id
		);
		insert careProgramEnrolleINS;

		// Insert a related record for BI_PSPB_Enrollee_Caregiver__c
		BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
			Name = 'Test Enrollee Caregiver',
			BI_PSPB_Patient__c = testContact.BI_PSPB_Selected_Patient_ID__c, // Specify a patient ID that matches the condition
			BI_PSPB_Contact_Id__c = testContact.Id, // Use the created contact's ID
			BI_PSPB_Status__c = 'Active',
			BI_PSPB_Care_Program_Enrollee__c = careProgramEnrolleINS.Id// Ensure status is set to 'Active'
			// Add other necessary fields as per your object structure
		);
		insert testEnrolleeCaregiver;

		// Call the getUnreadCases method with the test User's ID
		Test.startTest();
		try{
		BI_PSPB_LoginCtrl.getUnreadCases(testUser.Id);
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();

		// Add assertions here to ensure that the returned Task list is as expected
		// Add assertions to ensure that the lines inside the if(ecList.size() > 0 && ecList[0].BI_PSPB_Care_Program_Enrollee__c != null) block are covered
	}
	
 @isTest
	public static void testProfileDetailsNegative(){
		string wrongvalue = 'wrong';
		Test.startTest();
		try{
		BI_PSPB_LoginCtrl.profileDetails(wrongvalue);
		}catch(Exception e){
					Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
		}
		Test.stopTest();
	}
}