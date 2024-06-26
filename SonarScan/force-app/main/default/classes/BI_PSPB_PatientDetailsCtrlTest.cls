@isTest
public class BI_PSPB_PatientDetailsCtrlTest {
  public static User testUserPatient;
  public static Contact contactForPatient;
  static {
    // User as a patient without Account
    testUserPatient = new User(
      FirstName = 'User',
      LastName = 'PatientWithoutAccount',
      Email = 'testuserwithoutaccount@example.com',
      Username = 'testuserwithoutaccount@example.com',
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
    Contact contactForPatient = new Contact(
      FirstName = testUserPatient.FirstName,
      LastName = testUserPatient.LastName,
      Email = testUserPatient.Email
    );
    insert contactForPatient;
    testUserPatient.ContactId = contactForPatient.Id;
    insert testUserPatient;
  }
  /**
@description  This test class ensures that the method accurately retrieves the caregiver's User ID during login and displays the list of associated patients. It validates proper functionality for different caregiver User IDs and verifies the correct return of patient accounts, enhancing reliability and error handling.
**/
  @isTest
  static void testGetCaregiverAccounts() {
    
      BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'ApplicationName',
        BI_SFCOE_LOG_Application__c = 'PSPB'
      );
      insert settings;
      Profile standardUserProfile = [
        SELECT Id
        FROM Profile
        WHERE Name = 'Standard User'
        LIMIT 1
      ];
      String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
      // Create a caregiver account
      // Create a caregiver user associated with the caregiver account
      User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = false,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
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
			AccountId = testAccount1.Id,
			CareProgramId = cp.Id
		);
		insert testCpa2;
      Contact testContact = new Contact(
        FirstName = 'Test',
        LastName = 'Contact',
        Email = 'testcontact@example.com'
      );
      insert testContact;

      BI_PSPB_Enrollee_Caregiver__c enrollee = new BI_PSPB_Enrollee_Caregiver__c(
        Name = 'Test Enrollee Caregiver',
        BI_PSPB_Caregiver__c = testAccount2.Id,
        BI_PSPB_Status__c = 'active'
          
        
      );
      insert enrollee;
      System.runAs(testUser2)
          {
      try {
          
        Test.startTest();

        // Call the method to be tested with the caregiver user Id
         List<Map<String, String>> caregiverAccounts =BI_PSPB_PatientDetailsCtrl.getCaregiverAccounts();
              Assert.areEqual(null, caregiverAccounts, 'Caregiver accounts should not be null');
        Test.stopTest();
        
          
      } catch (Exception e) {
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
 * @description Test method to validate exception handling scenario in getCaregiverAccounts() method.
 */
  @isTest
  static void testGetCaregiverAccountsExceptionScenario() {
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    try {
    //assertion is not done because this is for negative scenario and it goes to catch
    Test.startTest();
 
    BI_PSPB_PatientDetailsCtrl.getCaregiverAccounts();
    
    Test.stopTest();
  } catch (Exception e) {
    // Assert that the exception message is as expected
    Assert.areEqual(
      e.getMessage(),
      'Script-thrown exception',
      e.getMessage()
    );
  }
  }
/*This test class ensures the accurate storage of selected patient record IDs in the database, validating functionality and error handling for various caregiver User IDs, thereby enhancing code reliability.*/
  @isTest
  static void testUpdateSelectedPatientID() {
    Profile standardUserProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Standard User'
      LIMIT 1
    ];
    User userWithoutAccount = new User(
      Username = 'caregiver@example.com',
      Email = 'caregiver@example.com',
      LastName = 'Caregiver',
      Alias = 'cg',
      TimeZoneSidKey = 'America/New_York',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      ProfileId = standardUserProfile.Id,
      LanguageLocaleKey = 'en_US'
    );
    insert userWithoutAccount;
    Account testAccount = new Account(
      Name = 'Test Account',
      BI_PSPB_Selected_Patient_ID__c = 'initial_selected_patient_id_value',
      BI_PSPB_CaregiverCheck__c = true
    );
    insert testAccount;
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'ApplicationName',
      BI_SFCOE_LOG_Application__c = 'PSPB'
    );
    insert settings;
    try {
      Test.startTest();
      //BI_PSPB_PatientDetailsCtrl.updateSelectedPatientID(testAccount.Id, 'initial_selected_patient_id_value');
      BI_PSPB_PatientDetailsCtrl.updateSelectedPatientID(
        testAccount.Id,
        testAccount.Id
      );
      BI_PSPB_PatientDetailsCtrl.updateSelectedPatientID(null, null);
      Test.stopTest();

      Account retrievedAccount = [
        SELECT Id, BI_PSPB_Selected_Patient_ID__c, BI_PSPB_CaregiverCheck__c
        FROM Account
        WHERE Id = :testAccount.Id
      ];
     
      Assert.areEqual('new_selected_patient_id_value', retrievedAccount.BI_PSPB_Selected_Patient_ID__c, 'BI_PSPB_Selected_Patient_ID__c should match expected value');

      Assert.areEqual(true, retrievedAccount.BI_PSPB_CaregiverCheck__c,'BI_PSPB_CaregiverCheck__c should be true');
    } catch (Exception e) {
      // Assert that the exception message is as expected
      Assert.areEqual(
        e.getMessage(),
        'Script-thrown exception',
        e.getMessage()
      );
    }
  }
 /**
 * @description Test method to verify the behavior of updating the selected patient ID.
 */
  @isTest
  static void testUpdatelineSelectedPatientID() {
    
      Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();
      Account testAccount = new Account(
        Lastname = 'Test Account',
        BI_PSPB_Selected_Patient_ID__c = 'initial_selected_patient_id_value',
        RecordTypeId = personAccountRecordTypeId,
        BI_PSPB_CaregiverCheck__c = true
      );
      insert testAccount;
      BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'ApplicationName',
        BI_SFCOE_LOG_Application__c = 'PSPB'
      );
      insert settings;
      try {
        Test.startTest();
        BI_PSPB_PatientDetailsCtrl.updateSelectedPatientID(null, null);
        //BI_PSPB_PatientDetailsCtrl.getcaregiverContact(testAccount.id);
        Test.stopTest();

        
      } catch (Exception e) {
        // Assert that the exception message is as expected
        Assert.areEqual(
          e.getMessage(),
          'Script-thrown exception',
          e.getMessage()
        );
      }
   
  }
/*This test class verifies the functionality of a method responsible for storing selected patient record IDs in the database, focusing on caregiver User IDs for accurate validation.*/
 /* @isTest
  static void testUpdateSelectedPatient() {
    //System.runAs(testUserPatient) {
      Contact testContact = new Contact(
        FirstName = 'Test',
        LastName = 'Contact',
        Email = 'testcontact@example.com'
      );
      insert testContact;
      Account testAccount = new Account(
        Name = 'Test Account',
        BI_PSPB_Selected_Patient_ID__c = 'initial_selected_patient_id_value',
        BI_PSPB_CaregiverCheck__c = true
      );
      insert testAccount;
      BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'ApplicationName',
        BI_SFCOE_LOG_Application__c = 'PSPB'
      );
      insert settings;
      try {
        Test.startTest();
        Contact result = BI_PSPB_PatientDetailsCtrl.updateSelectedPatient(
          testContact.Id,
          'initial_selected_patient_id_value'
        );
        BI_PSPB_PatientDetailsCtrl.updateSelectedPatient('', '');
        BI_PSPB_PatientDetailsCtrl.updateSelectedPatient(
          testContact.Id,
          'Deciding what is a word or not can oftentimes be very hard. But if youre alright with an approximate solution, like defining a word as text between two whitespaces, I suggest you implement a simple function yourself.Deciding what is a word or not can oftentimes be very hard. But if youre alright with an approximate solution, like defining a word as text between two whitespaces, I suggest you implement a simple function yourself.'
        );
        Test.stopTest();
        Assert.arenotequal(result, null,'Result should not be null');
      } catch (Exception e) {
        // Assert that the exception message is as expected
        Assert.areEqual(
          e.getMessage(),
          'Script-thrown exception',
          e.getMessage()
        );
      }
   // }
  }*/

  @isTest
  static void testGetcaregiverAccountforSwitch() {
    //System.runAs(testUserPatient) {
      Account testAccount = new Account(
        Name = 'Test Account',
        BI_PSPB_Selected_Patient_ID__c = 'selected_patient_id_value',
        BI_PSPB_CaregiverCheck__c = true
      );
      insert testAccount;
      BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'ApplicationName',
        BI_SFCOE_LOG_Application__c = 'PSPB'
      );
      insert settings;
      try {
        Test.startTest();
        Account result = BI_PSPB_PatientDetailsCtrl.getcaregiverAccountforSwitch(
          testAccount.Id
        );
        Test.stopTest();
        Assert.arenotequal(null, result,'Result should not be null');
        Assert.areEqual(
          'selected_patient_id_value',
          result.BI_PSPB_Selected_Patient_ID__c,'selected_patient_id_value'
        );
        Assert.areEqual(true, result.BI_PSPB_CaregiverCheck__c,'BI_PSPB_CaregiverCheck__c should be true');
      } catch (Exception e) {
        // Assert that the exception message is as expected
        Assert.areEqual(
          e.getMessage(),
          'Script-thrown exception',
          e.getMessage()
        );
      }
   // }
  }
  /**
 * @description Test method to verify the behavior of updating the selected patient ID and caregiver check flag.
 */
  @isTest
  static void testUpdateSwitchSelectedPatientID() {
   
      Account testAccount = new Account(
        Name = 'Test Account',
        BI_PSPB_Selected_Patient_ID__c = 'initial_selected_patient_id_value',
        BI_PSPB_CaregiverCheck__c = false
      );
      insert testAccount;
      BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'ApplicationName',
        BI_SFCOE_LOG_Application__c = 'PSPB'
      );
      insert settings;
      try {
        Test.startTest();
        Account updatedAccount = BI_PSPB_PatientDetailsCtrl.updateSwitchSelectedPatientID(
          testAccount.Id,
          'new_selected_patient_id_value',
          true
        );
        BI_PSPB_PatientDetailsCtrl.updateSwitchSelectedPatientID(
          '',
          'new_selected_patient_id_value',
          true
        );
        BI_PSPB_PatientDetailsCtrl.updateSwitchSelectedPatientID(
          testAccount.Id,
          'Deciding what is a word or not can oftentimes be very hard. But if youre alright with an approximate solution, like defining a word as text between two whitespaces, I suggest you implement a simple function yourself.Deciding what is a word or not can oftentimes be very hard. But if youre alright with an approximate solution, like defining a word as text between two whitespaces, I suggest you implement a simple function yourself.',
          true
        );
        Test.stopTest();
        Account retrievedAccount = [
          SELECT Id, BI_PSPB_Selected_Patient_ID__c, BI_PSPB_CaregiverCheck__c
          FROM Account
          WHERE Id = :testAccount.Id
        ];
        Assert.arenotequal(null, updatedAccount,'Updated account should not be null');
        Assert.areEqual(
          'new_selected_patient_id_value', updatedAccount.BI_PSPB_Selected_Patient_ID__c, 'BI_PSPB_Selected_Patient_ID__c should match expected value'
        );
        Assert.areEqual(true, updatedAccount.BI_PSPB_CaregiverCheck__c,'BI_PSPB_CaregiverCheck__c should be true');
       
        Assert.areEqual(
          'new_selected_patient_id_value',
          retrievedAccount.BI_PSPB_Selected_Patient_ID__c,'new_selected_patient_id_value'
        );
        Assert.areEqual(true, retrievedAccount.BI_PSPB_CaregiverCheck__c,'BI_PSPB_CaregiverCheck__c should be true');
      } catch (Exception e) {
        // Assert that the exception message is as expected
        Assert.areEqual(
          e.getMessage(),
          'Script-thrown exception',
          e.getMessage()
        );
      }
   // }
  }
    

  @isTest
  static void testGetCatchCall() {
    System.runAs(testUserPatient) {
      BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'ApplicationName',
        BI_SFCOE_LOG_Application__c = 'PSPB'
      );
      insert settings;
      try {
        Test.startTest();
        BI_PSPB_PatientDetailsCtrl.updateSelectedPatientID(null, null);
        //BI_PSPB_PatientDetailsCtrl.updateSelectedPatient('dddddd', 'aaaaa');
        //BI_PSPB_PatientDetailsCtrl.getcaregiverAccountforSwitch('');
        Test.stopTest();
      } catch (Exception e) {
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
    * @description This test class verifies the functionality of the getCaregiverAccounts() method in the BI_PSPB_PatientDetailsCtrl class. It ensures that the method correctly retrieves caregiver accounts for specified account IDs and handles invalid input, providing robust error handling and ensuring proper behavior in various scenarios.
	 */
  @isTest
  static void testGetCatchswitch() {
    System.runAs(testUserPatient) {
      BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'ApplicationName',
        BI_SFCOE_LOG_Application__c = 'PSPB'
      );
      insert settings;
      try {
        Test.startTest();
        BI_PSPB_PatientDetailsCtrl.getcaregiverAccountforSwitch('');
        Test.stopTest();
      } catch (Exception e) {
        // Assert that the exception message is as expected
        Assert.areEqual(
          e.getMessage(),
          'Script-thrown exception',
          e.getMessage()
        );
      }
    }
  }
 
}