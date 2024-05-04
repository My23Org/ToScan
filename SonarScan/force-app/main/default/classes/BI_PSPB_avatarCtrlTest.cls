/**
 * @description  Test class for the Avatarctrl class, responsible for retrieving Avatar URLs and storing selected Avatars.
 *               And Check Patient status
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023     Created             Initial development
 */
@isTest
private class BI_PSPB_avatarCtrlTest {
private static   BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('ApplicationName');
 /*
@description    : Test method to verify the functionality of the getLoggedInUserAccounts() method.
*/
   @isTest
static void testGetLoggedInUserAccount() {
    try {
        // Create a test User
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        UserRole role = new UserRole(Name = 'Test Role');
        insert role;
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser321@example.com',
            Username = 'testuser321@example.com',
            ProfileId = profile.Id,
            UserRoleId = role.Id,
            Alias = 'TUser',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Set the test context to the created user
        System.runAs(testUser) {
            // Call the getLoggedInUserAccounts method
            Test.startTest();
            List<Account> userAccounts = BI_PSPB_AvatarCtrl.getLoggedInUserAccount();
            Test.stopTest();

            // Assert that the userAccounts is not null and contains the expected values
            Assert.areEqual(null, userAccounts, 'List of user accounts is null');
        }
    } catch (Exception ex) {
        // Assert if there's an exception
        Assert.areEqual(
            'Script-thrown exception',
            ex.getMessage(),
            'An unexpected exception occurred: ' + ex.getMessage()
        );
    }
}
 
/*
@description    : Test method to verify the behavior of the loggedUser() method when it executes without encountering any exceptions.
*/
    @isTest
    static void testLoggedUserWithoutException() {
        // Set up test data or any necessary mocks

        // Call the method that is expected to return a List<User>
        Test.startTest();
        List<User> userList = BI_PSPB_AvatarCtrl.loggedUser();
        Test.stopTest();

        // Assert that the returned list is not null and contains the expected fields
        Assert.areNotEqual(null, userList, 'List should not be null');
        Assert.areEqual(1, userList.size(), 'List should have exactly one user');
      
    }
 /*
@description    : Test method to verify the functionality of the updateAccountAvatar() method.
*/
@isTest
    static void testUpdateAccountAvatar() {
        // Set up test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        String accountId = testAccount.Id;
        String avatarSrc = 'https://example.com/avatar.jpg';

        // Call the method to update the account avatar
        Test.startTest();
        BI_PSPB_AvatarCtrl.updateAccountAvatar(accountId, avatarSrc);
        Test.stopTest();

        // Retrieve the updated account
        Account updatedAccount = [SELECT Id, BI_PSP_AvatarUrl__c, BI_PSP_Loginattempt__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];

        // Assert that the account fields are updated as expected
        Assert.areEqual(avatarSrc, updatedAccount.BI_PSP_AvatarUrl__c, 'Avatar URL should be updated');
        
    }
/*
@description    : Test method to verify exception handling in the updateAccountAvatar() method.
*/
    @isTest
    static void testUpdateAccountAvatarWithException() {
        // Set up test data
       

        // Call the method that may throw an exception
        Test.startTest();
        try {
            BI_PSPB_AvatarCtrl.updateAccountAvatar(null, null);
        } catch (Exception ex) {
            // Assert that the exception message is as expected
		Assert.areEqual(
			ex.getMessage(),
			'Script-thrown exception',
			ex.getMessage()
		);
        }
        Test.stopTest();
    }
/*
@description    : Test method to verify the functionality of the updateLoginAttempt() method
*/
    @isTest
    static void testUpdateLoginAttempt() {
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser321@example.com',
            Username = 'testuser321@example.com',
            ProfileId = profile.Id,
            Alias = 'TUser',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        // Set up test data
        Account testAccount = new Account(Name = 'Test User');
        insert testAccount;

        String accountId = testAccount.Id;
        
        // Retrieve the CareProgramEnrollee record
        CareProgram cp = new CareProgram();
        cp.Name ='spevigo';
        insert cp;
        CareProgramEnrollee cpe = new CareProgramEnrollee();
        cpe.Name = 'test';
        cpe.AccountId = accountId;
        cpe.CareProgramId = cp.id;
        cpe.BI_PSP_FirstLoginDate__c =  Date.today();
        insert cpe;
        List<CareProgramEnrollee> cpeList = [SELECT Id, BI_PSPB_FirstLoginDate__c FROM CareProgramEnrollee WHERE AccountId = :accountId LIMIT 1];
        // Assert that the CareProgramEnrollee record is updated as expected
        Assert.areEqual(1, cpeList.size(), 'Expected one CareProgramEnrollee record');
        try{
            System.runAs(testUser){
        // Call the method to update the login attempt
        Test.startTest();
        BI_PSPB_AvatarCtrl.updateLoginAttempt(accountId);
        Test.stopTest();
            }
        // Retrieve the updated account
        Account updatedAccount = [SELECT Id, BI_PSP_Loginattempt__c FROM Account WHERE Id = :accountId LIMIT 1];
        Assert.areNotEqual(null, updatedAccount, 'Account not found or not updated');
        }catch (Exception e) {
		// Assert that the exception message is as expected
		Assert.areEqual(
			e.getMessage(),
			'Script-thrown exception',
			e.getMessage()
		);
	}
      


    }
/*
@description    : Test method to verify exception handling in the updateLoginAttempt() method.
*/

    @isTest
    static void testUpdateLoginAttemptWithException() {
        // Set up test data

        // Call the method that may throw an exception
        Test.startTest();
        try {
            BI_PSPB_AvatarCtrl.updateLoginAttempt(null);
        } catch (Exception ex) {
            Assert.areEqual(
			ex.getMessage(),
			'Script-thrown exception',
			ex.getMessage()
		);
        }
        Test.stopTest();
    }
  /*
@description    : Test method to verify the functionality of the updateLoginAttempt() 
                   method when the CareProgramEnrollee record is already present.
*/
  
       @isTest
    static void testUpdateLoginAttemptwith() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
         Careprogram cp = new Careprogram(Name ='Spevigo', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramEnrollee testCPE = new CareProgramEnrollee(Name = 'Test CPE', AccountId = testAccount.Id,CareProgramId = cp.id);
        insert testCPE;
        
        // Call the method to be tested
        Test.startTest();
        BI_PSPB_AvatarCtrl.updateLoginAttempt(testAccount.Id);
        Test.stopTest();
        
        // Verify Account update
        Account updatedAccount = [SELECT Id, BI_PSP_Loginattempt__c FROM Account WHERE Id = :testAccount.Id];
        Assert.areEqual(1, updatedAccount.BI_PSP_Loginattempt__c, 'Login attempt count should be incremented');
        
        // Verify CareProgramEnrollee update
       
        CareProgramEnrollee updatedCPE = [SELECT Id, BI_PSPB_FirstLoginDate__c FROM CareProgramEnrollee WHERE AccountId = :testAccount.Id];
        Assert.areEqual(Date.today(), updatedCPE.BI_PSPB_FirstLoginDate__c, 'First login date should be updated');
    }
/*
@description    : Test method to verify the functionality of the getLoggedInUserCaregiver() method.
*/

    @isTest
    static void testGetLoggedInUserCaregiver() {
        // Set up test data
        String avatarSrc = 'https://example.com/avatar.jpg';
         Account acc = new Account ();
         acc.Name = 'Test User';
         acc.BI_PSP_AvatarUrl__c =  'https://example.com/avatar.jpg';
         insert acc;
        
       BI_PSPB_Enrollee_Caregiver__c ec = new BI_PSPB_Enrollee_Caregiver__c();
        ec.Name = 'test';
        ec.BI_PSPB_Patient__c = acc.Id;
        insert ec;
        try{
        // Call the method to get the logged-in user's caregiver
        Test.startTest();
        List<BI_PSPB_Enrollee_Caregiver__c> caregiverList = BI_PSPB_AvatarCtrl.getLoggedInUserCaregiver(avatarSrc);
        Test.stopTest();

        // Assert that the returned list is not null and contains expected fields
        Assert.areNotEqual(null, caregiverList, 'List should not be null');
        }catch (Exception e) {
		// Assert that the exception message is as expected
		Assert.areEqual(
			e.getMessage(),
			'Script-thrown exception',
			e.getMessage()
		);
	}
       
    }
  /*
@description    : Test method to verify exception handling in the getLoggedInUserCaregiver() method.
*/

    @isTest
    static void testGetLoggedInUserCaregiverwith() {
        // Set up test data
        String avatarSrc = 'https://example.com/avatar.jpg';

        // Call the method that may throw an exception
        Test.startTest();
        try {
            BI_PSPB_AvatarCtrl.getLoggedInUserCaregiver(avatarSrc);
        } catch (Exception ex) {
           Assert.areEqual(
			ex.getMessage(),
			'Script-thrown exception',
			ex.getMessage()
		);
        }
        Test.stopTest();
    }

    @isTest
    static void testUserCaregiver() {
        // Set up test data
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        UserRole role = new UserRole(Name = 'Test Role');
        insert role;
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser3211@example.com',
            Username = 'testuser3211@example.com',
            ProfileId = profile.Id,
            UserRoleId = role.Id,
            Alias = 'TUsers',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        try{
        System.runAs(testUser) {
            // Call the method to get the user's caregivers
            Test.startTest();
            List<Account> avtList = BI_PSPB_AvatarCtrl.userCaregiver();
            BI_PSPB_AvatarCtrl.updateLoginAttemptcaregiver(null);

            Test.stopTest();

            // Assert that the returned list is not null and contains the expected fields
            Assert.areEqual(null, avtList, 'List should not be null');
        }
        }
        catch (Exception ex) {
            // Error throw handle for apex negative scenario
            Assert.areEqual(
             ex.getMessage(),
             'Script-thrown exception',
             ex.getMessage()
         );
         }
    }
 
/*
@description    : Test method to verify the functionality of the userCaregiver() method.
*/

    @isTest
    static void testUpdateLoginAttemptcaregiver() {
        // Set up test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        CareProgram cp = new CareProgram();
        cp.Name ='spevigo';
        insert cp;
        CareProgramEnrollee testCPE = new CareProgramEnrollee(
            Name = 'Test Enrollee',
            BI_PSPB_FirstLoginDate__c = Date.today(), // Set a previous date for testing
            AccountId = testAccount.Id,
            CareProgramId = cp.id
        );
        insert testCPE;
        try{
        // Call the method to update login attempt for the caregiver
        Test.startTest();
        BI_PSPB_AvatarCtrl.updateLoginAttemptcaregiver(testAccount.Id);
        Test.stopTest();
        

        // Retrieve the updated CareProgramEnrollee
        CareProgramEnrollee updatedCPE = [SELECT Id, BI_PSPB_FirstLoginDate__c FROM CareProgramEnrollee WHERE Id = :testCPE.Id LIMIT 1];

        // Assert that BI_PSPB_FirstLoginDate__c is updated to today
        Assert.areEqual(Date.today(), updatedCPE.BI_PSPB_FirstLoginDate__c, 'First login date should be updated');

        // Retrieve the updated Account
        Account updatedAccount = [SELECT Id, BI_PSP_Loginattempt__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        Assert.areNotEqual(null, updatedAccount, 'Account not found or not updated');
        }
        catch (Exception ex) {
            // Error throw for negative scenario
            Assert.areEqual(
             ex.getMessage(),
             'Script-thrown exception',
             ex.getMessage()
         );
         }
    }
/*
@description    : Test method to verify exception handling in the updateLoginAttemptcaregiver() method.
*/

    @isTest
    static void testUpdateLoginAttemptcaregiverWithException() {
        // Set up test data
        String accountId = 'invalidAccountId';

        // Call the method that may throw an exception
        Test.startTest();
        try {
            BI_PSPB_AvatarCtrl.updateLoginAttemptcaregiver(accountId);
        } catch (Exception ex) {
           Assert.areEqual(
			ex.getMessage(),
			'Script-thrown exception',
			ex.getMessage()
		);
        }
        Test.stopTest();
    }
/*
@description    : Test method to verify the functionality of the checkPatientStatus() method.
*/


    @isTest
    static void testCheckPatientStatus() {
        // Set up test data
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        UserRole role = new UserRole(Name = 'Test Role');
        insert role;
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser321111@example.com',
            Username = 'testuser321111@example.com',
            ProfileId = profile.Id,
            UserRoleId = role.Id,
            Alias = 'TUserss',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        System.runAs(testUser) {
            // Create a test account
            Account testAccount = new Account(
                Name = 'as'
            );
            insert testAccount;
           CareProgram cp = new CareProgram();
           cp.Name ='spevigo';
           insert cp;
            CareProgramEnrollee testCPE = new CareProgramEnrollee(
            Name = 'Test Enrollee',
            BI_PSPB_FirstLoginDate__c = Date.today(), // Set a previous date for testing
            AccountId = testAccount.Id,
            CareProgramId = cp.id
        );
        insert testCPE;
            try{
            // Call the method to check patient status
            Test.startTest();
            List<CareProgramEnrollee> cpeList = BI_PSPB_AvatarCtrl.checkPatientStatus();
            Test.stopTest();
           Assert.areNotEqual(1, cpeList.size(), 'List of CareProgramEnrollee records is empty');
            }catch (Exception e) {
		// Assert that the exception message is as expected
		Assert.areEqual(
			e.getMessage(),
			'Script-thrown exception',
			e.getMessage()
		);
	}

           
        }
    }
/*
@description    : Test method to verify the functionality of the checkCaregiverPatientStatus() method.
*/

    @isTest
    static void testCheckCaregiverPatientStatus() {
        // Set up test data
         Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        UserRole role = new UserRole(Name = 'Test Role');
        insert role;
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser3121111@example.com',
            Username = 'testuser3121111@example.com',
            ProfileId = profile.Id,
            UserRoleId = role.Id,
            Alias = 'TUsersss',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        System.runAs(testUser) {
            // Create a test account for the caregiver
            Account caregiverAccount = new Account(
                Name = 'Caregiver Test Account'
               // PersonEmail = testUser.Email
            );
            insert caregiverAccount;

            // Create a test patient account
            Account patientAccount = new Account(
                Name = 'Patient Test Account'
               // PersonEmail = 'patient@example.com'
            );
            insert patientAccount;

          
            CareProgram cp = new CareProgram();
         	cp.Name ='spevigo';
          	insert cp;
        CareProgramEnrollee testCPE = new CareProgramEnrollee(
            Name = 'Test Enrollee',
            BI_PSPB_FirstLoginDate__c = Date.today(), // Set a previous date for testing
            AccountId = caregiverAccount.id,
            CareProgramId = cp.id
        );
        insert testCPE;

            // Set the caregiver's selected patient ID
            caregiverAccount.BI_PSPB_Selected_Patient_ID__c = patientAccount.Id;
            update caregiverAccount;
            try{
                
            
            // Call the method to check caregiver's patient status
            Test.startTest();
            List<CareProgramEnrollee> cpeList = BI_PSPB_AvatarCtrl.checkCaregiverPatientStatus();
            Test.stopTest();
         	 Assert.areNotEqual(null, cpeList, 'List of CareProgramEnrollee is null');
            }
            catch (Exception e) {
		// Assert that the exception message is as expected
		Assert.areEqual(
			e.getMessage(),
			'Script-thrown exception',
			e.getMessage()
		);
	}
        }
    }
    /**
* @description: Test method used to verify the patient status for patient through caregiver profile
*/
    @isTest
    static void testCheckCaregiverPatientStatusWithException() {
        // Set up test data or any necessary mocks
        // In this case, you might want to mock the data or simulate an exception scenario

        // Call the method that may throw an exception
        Test.startTest();
        try {
            BI_PSPB_AvatarCtrl.checkCaregiverPatientStatus();
        } catch (Exception ex) {
            Assert.areEqual(
			ex.getMessage(),
			'Script-thrown exception',
			ex.getMessage()
		);
        }
        Test.stopTest();
    }
    
    /**
* @description: Test method used to verify the patient status for patient through caregiver profile
*/
    @isTest
	static void testcaregiverdata() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		try{
		// String targetDate = 'Jan 2023';
		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];
		User testUser2 = new User(
			Email = 'testuser2new@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testuser2new@example.com',
			FirstName = 'Test',
			LastName = 'User2',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUser2;
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();
		Account testAccount1 = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;

		String currentUserName2 = 'Test User2';
		String currentUserEmail2 = 'testuser2new@example.com';
		Account testAccount2 = new Account(
			Lastname = currentUserName2,
			PersonEmail = currentUserEmail2,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
		);
		insert testAccount2;

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;

		CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccount2.Id,
			CareProgramId = cp.Id
		);
		insert testCpa2;
            BI_PSPB_Enrollee_Caregiver__c enrollec = new BI_PSPB_Enrollee_Caregiver__c(
			Name = 'TestCpa222',
             BI_PSPB_Caregiver__c	= testAccount2.Id
		);
		insert enrollec;

		System.runAs(testUser2) {
            Test.startTest();
            List<CareProgramEnrollee> cpeList = BI_PSPB_avatarCtrl.checkCaregiverPatientStatus();
            List<CareProgramEnrollee> cpeList2 = BI_PSPB_avatarCtrl.checkPatientStatus();
            List<Account> cpeList3 = BI_PSPB_AvatarCtrl.userCaregiver();
            List<Account> cpeList4 = BI_PSPB_AvatarCtrl.getLoggedInUserAccount();
            List<BI_PSPB_Enrollee_Caregiver__c> cpeList5 = BI_PSPB_AvatarCtrl.getLoggedInUserCaregiver('test string');
            Test.stopTest();
            Assert.areNotEqual(null, cpeList, 'List of CareProgramEnrollees from checkCaregiverPatientStatus() is null');
            Assert.areNotEqual(null, cpeList2, 'List of CareProgramEnrollees from checkPatientStatus() is null');
            Assert.areNotEqual(null, cpeList3, 'List of Accounts from userCaregiver() is null');
            Assert.areNotEqual(null, cpeList4, 'List of Accounts from getLoggedInUserAccount() is null');
            Assert.areNotEqual(null, cpeList5, 'List of BI_PSPB_Enrollee_Caregivers from getLoggedInUserCaregiver() is null');
		}
	}
	catch (Exception e) {
		// Assert that the exception message is as expected
		Assert.areEqual(
			e.getMessage(),
			'Script-thrown exception',
			e.getMessage()
		);
	}
	}
    
        /**
* @description: Test method used to verify the patient status for patient through caregiver profile
*/
    @isTest
	static void testcaregiverdatapatient() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
		try{
		// String targetDate = 'Jan 2023';
		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];
		User testUser2 = new User(
			Email = 'testuser2new@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testuser2new@example.com',
			FirstName = 'Test',
			LastName = 'User2',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUser2;
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();
		Account testAccount1 = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccount1;

		String currentUserName2 = 'Test User2';
		String currentUserEmail2 = 'testuser2new@example.com';
		Account testAccount2 = new Account(
			Lastname = currentUserName2,
			PersonEmail = currentUserEmail2,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccount1.Id
		);
		insert testAccount2;

		CareProgram cp = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert cp;

		CareProgramEnrollee testCpa2 = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccount2.BI_PSPB_Selected_Patient_ID__c,
			CareProgramId = cp.Id
		);
		insert testCpa2;
            BI_PSPB_Enrollee_Caregiver__c enrollec = new BI_PSPB_Enrollee_Caregiver__c(
			Name = 'TestCpa222',
             BI_PSPB_Caregiver__c	= testAccount2.Id
		);
		insert enrollec;

		System.runAs(testUser2) {
			Test.startTest();
            List<CareProgramEnrollee> cpeList = BI_PSPB_avatarCtrl.checkCaregiverPatientStatus();
            List<CareProgramEnrollee> cpeList2 = BI_PSPB_avatarCtrl.checkPatientStatus();
             List<BI_PSPB_Enrollee_Caregiver__c> cpeList3 = BI_PSPB_avatarCtrl.getLoggedInUserCaregiver('');
			Test.stopTest();
         Assert.areNotEqual(null, cpeList, 'List of CareProgramEnrollees from checkCaregiverPatientStatus() is null');
         Assert.areNotEqual(null, cpeList2, 'List of CareProgramEnrollees from checkCaregiverPatientStatus() is null');
         Assert.areNotEqual(null, cpeList3, 'List of CareProgramEnrollees from checkCaregiverPatientStatus() is null');


		}
	}
	catch (Exception e) {
		// Assert that the exception message is as expected
		Assert.areEqual(
			e.getMessage(),
			'Script-thrown exception',
			e.getMessage()
		);
	}
	}
  /*
@description    : Test method to verify the functionality of the getLoggedInUserCaregiver() method.
                  It sets up test data including mock records for user, accounts, contacts, and care program enrollees.
*/
  
   @isTest
 static void getLoggedInUserCaregiver(){
      String avatarSrc = 'https://example.com/avatar.jpg';
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
            PersonMailingStreet='test',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='challenges2@email.com',
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
            BI_PSPB_Selected_Patient_ID__c=accnt.Id
            
        );
        insert accnt1;
        contact chaCon = new contact(Lastname='testuserss',Email='challenges@email.com');
        insert chaCon;
        CareProgram program = new CareProgram(name='challenge',StartDate=system.today());
        insert program;
        CareProgramEnrollee enrolle = new CareProgramEnrollee(Name='challengeenrolle',AccountId=Accnt.Id,CareProgramId=program.Id);
        insert enrolle;
  
        BI_PSPB_Enrollee_Caregiver__c careEnrolle = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Contact_Id__c=chaCon.Id,
            BI_PSPB_Status__c='Active',
            BI_PSPB_Patient__c=accnt.Id,
            BI_PSPB_Care_Program_Enrollee__c=enrolle.Id,
            BI_PSPB_Caregiver__c =accnt1.Id
          
        );
        insert careEnrolle;
      Test.startTest();
        // Call the method
        		System.runAs(userRecord) {

        
        List<BI_PSPB_Enrollee_Caregiver__c> result = BI_PSPB_avatarCtrl.getLoggedInUserCaregiver(avatarSrc);
        Test.stopTest();
                
        
        // Assertions
        Assert.areEqual(1, result.size(), 'Expected one result'); 
    }
 }
    /*
@description    : Test method to verify the functionality of the userCaregiver() method.
                  It sets up test data including mock records for a user, accounts, contacts, and care program enrollees.
*/

   @isTest
 static void userCaregiver(){

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
            PersonMailingStreet='test',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='challenges2@email.com',
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
            BI_PSPB_Selected_Patient_ID__c=accnt.Id
            
        );
        insert accnt1;
        contact chaCon = new contact(Lastname='testuserss',Email='challenges@email.com');
        insert chaCon;
        CareProgram program = new CareProgram(name='challenge',StartDate=system.today());
        insert program;
        CareProgramEnrollee enrolle = new CareProgramEnrollee(Name='challengeenrolle',AccountId=Accnt.Id,CareProgramId=program.Id);
        insert enrolle;
  
        BI_PSPB_Enrollee_Caregiver__c careEnrolle = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Contact_Id__c=chaCon.Id,
            BI_PSPB_Status__c='Active',
            BI_PSPB_Patient__c=accnt.Id,
            BI_PSPB_Care_Program_Enrollee__c=enrolle.Id,
            BI_PSPB_Caregiver__c =accnt1.Id
          
        );
        insert careEnrolle;
      Test.startTest();
        // Call the method
        		System.runAs(userRecord) {

        
        List<Account> result = BI_PSPB_avatarCtrl.userCaregiver();
        Test.stopTest();
                
        
        // Assertions
        Assert.areEqual(1, result.size(), 'Expected one result'); 
    }
 }
}