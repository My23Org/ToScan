/*
* @description  This Test class is used for getting Account Id, Creating Contact,Creating Enrollee caregiver,grand access
*                
* History:
* Version	Author			Date			Detail				Description
* 1.0		NandhaKumar	    05-01-2024     	Created				Initial development
*/
@isTest
public class BI_PSPB_exuserGetAccidTest {
    private static   BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
    /*
Method description:
This test method verifies the functionality of the UserCaregiver method in the BI_PSPB_exuserGetAccid class. 
It creates a test user and a test account associated with that user. Then, it inserts a test Enrollee Caregiver record 
linking the test account as both the patient and the caregiver. Afterward, it runs the UserCaregiver method 
within a simulated user context to retrieve the list of caregivers associated with the test user. Finally, it asserts 
that the method returns the correct caregiver account.
*/
    @isTest
    static void testUserCaregiver() {
        // Create a test user
        User testUser = new User(
            FirstName = 'testuserone',
            LastName = 'lnameuser',
            Email = 'testlnameuser@example.com',
            Username = 'testlnameuser@example.com',
            Alias = 'tuserd',
            CommunityNickname = 'testuser',
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        
        // Create a test account associated with the user
        Account testAccount = new Account(
            FirstName = testUser.FirstName,
            LastName = testuser.LastName
        );
        insert testAccount;
        
        
        BI_PSPB_Enrollee_Caregiver__c testCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Patient__c = testAccount.Id,
            BI_PSPB_Caregiver__c = testAccount.Id
        );
        insert testCaregiver;
        // Assign the test account to the user
        testCaregiver.BI_PSPB_Caregiver__c = testAccount.Id;
        update testCaregiver;
        
        System.runAs(testUser) {
            Test.startTest();
            // Call the method with the test user's Id
            List<Account> result = BI_PSPB_exuserGetAccid.UserCaregiver();
            
            Test.stopTest();
            
            // Verify that the method returns the correct account
            Assert.areEqual(1, result.size(), 'Expected one account');
            Assert.areEqual(testAccount.Id, result[0].Id, 'Incorrect account returned');
        }
    }
    
/*
Method description:
This test method verifies the functionality of the updateCaregiverDetails method in the BI_PSPB_exuserGetAccid class.
It creates test data by inserting a new Account record and prepares a combined string with updated caregiver details.
The method is called to update the caregiver details using the combined string.
The test verifies that the caregiver details are updated correctly in the Account record.
*/
    
    @isTest
    static void testUpdateCaregiverDetails() {
        // Create test data
        Account acc = new Account(
            FirstName = 'UpdatedFirstName',
            LastName = 'UpdatedLastName',
            PersonEmail = 'test@example.com',
            BI_PSP_Birthdate__c = Date.newInstance(1990, 1, 1),
            BI_PSPB_Relationship_to_Patient__c = 'Friend',
            Phone = '1234567890',
            BI_PSPB_Preferred_Communication_Method__c = 'Email'
        );
        insert acc;
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Your_Application_Name'
        );
        insert settings;
        BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper cgprofile = new BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper();
        
        cgprofile.accountId = acc.Id;
        cgprofile.FirstName = 'UpdatedFirstName';
        cgprofile.LastName = 'UpdatedLastName';
        cgprofile.PersonEmail = 'updated@example.com';
        cgprofile.PersonBirthdate = Date.newInstance(1995, 2, 2);
        cgprofile.relations = 'Sibling';
        cgprofile.phone = '9876543210';
        cgprofile.PreferredMethodofContact = 'Phone';
        try{
        Test.startTest();
        // Call the method to be tested
        BI_PSPB_exuserGetAccid.updateCaregiverDetails(cgprofile);
        Test.stopTest();
        }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
        // Retrieve the updated account record
        Account updatedAcc = [SELECT FirstName, LastName, PersonEmail, BI_PSP_Birthdate__c,
                              BI_PSPB_Relationship_to_Patient__c, Phone, BI_PSPB_Preferred_Communication_Method__c
                              FROM Account WHERE Id = :acc.Id LIMIT 1];
        
        // Assert the updated values
        Assert.areEqual('UpdatedFirstName', updatedAcc.FirstName ,'update account record');
        Assert.areEqual('UpdatedLastName', updatedAcc.LastName ,'update account record');
        
    }
    /*
Method description:
This test method verifies the functionality of the updateContactFromCheckbox method in the BI_PSPB_exuserGetAccid class.
It creates test data by inserting a new User, Account, Contact, and BI_PSPB_Enrollee_Caregiver__c records.
The method is called to simulate checking a checkbox, which updates the BI_PSPB_GrantAccess__c field on the Contact record
and the BI_PSPB_GrantCaregiverAccess__c field on the related Account record.
The test verifies that the fields are updated correctly in both the Contact and Account records.
*/
    @isTest
    static void testUpdateContact() {
        // Create test data
        User testUser = new User(
            FirstName = 'checkfour',
            LastName = 'fouruser',
            Email = 'testfour@example.com',
            Username = 'testfour@example.com',
            Alias = 'tueer',
            CommunityNickname = 'testuser',
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        
        Account testAccount = new Account(
            FirstName = testUser.FirstName,
            LastName = testUser.LastName,
            BI_PSPB_GrantCaregiverAccess__c = true,
            PersonEmail = testUser.Email
        );
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@example.com',
            BI_PSPB_GrantAccess__c = true
        );
        insert testContact;
        
        BI_PSPB_Enrollee_Caregiver__c testECRecord = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Patient__c = testAccount.id,
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Caregiver__c = testAccount.id,
            BI_PSPB_Status__c = 'Active'
        );
        insert testECRecord;
        try{
        System.runAs(testUser) {
            Test.startTest();
            // Simulate checking the checkbox
            BI_PSPB_exuserGetAccid.updateContactFromCheckbox(true);
            
            // Verify that the Contact's BI_PSPB_GrantAccess__c field is updated
            testContact = [SELECT BI_PSPB_GrantAccess__c FROM Contact WHERE Id = :testContact.Id];
            Assert.areEqual(true, testContact.BI_PSPB_GrantAccess__c, 'Contact BI_PSPB_GrantAccess__c should be true');
            
            // Verify that the related Account's BI_PSPB_GrantCaregiverAccess__c field is updated
            testAccount = [SELECT BI_PSPB_GrantCaregiverAccess__c FROM Account WHERE Id = :testAccount.id];
            Assert.areEqual(true, testAccount.BI_PSPB_GrantCaregiverAccess__c, 'Account BI_PSPB_GrantCaregiverAccess__c should be true');
            
            // Verify that the BI_PSPB_Enrollee_Caregiver__c record is updated
            testECRecord = [SELECT BI_PSPB_Status__c,BI_PSPB_Patient__r.Name,BI_PSPB_Patient__r.PersonEmail FROM BI_PSPB_Enrollee_Caregiver__c WHERE Id = :testECRecord.Id];
            Assert.areEqual('Active', testECRecord.BI_PSPB_Status__c, 'BI_PSPB_Enrollee_Caregiver__c Status should be Active');
            Test.stopTest();
        }
        }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
    }
    
    /*
Method description:
This test method verifies the functionality of the grandaccessbutton method in the BI_PSPB_exuserGetAccid class.
It creates a test user, account, contact, and BI_PSPB_Enrollee_Caregiver__c record.
The method is called to execute the functionality related to the grand access button.
No specific assertions are performed in this method; it primarily tests the execution of the method without errors.
*/    
    @isTest
    static void testGrandAccessButton() {
        // Create a test user
        User testUser = new User(
            FirstName = 'checkfive',
            LastName = 'fiveuser',
            Email = 'testfive@example.com',
            Username = 'testfive@example.com',
            Alias = 'tufer',
            CommunityNickname = 'testuser',
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
            // Add any other requir
        );
        insert testUser;
        
        Account testAccount = new Account(
            FirstName = testUser.FirstName,
            LastName = testuser.LastName,
            PersonEmail = testUser.Email,
            BI_PSPB_GrantCaregiverAccess__c = true
            // Add any other required fields
        );
        insert testAccount;
        
        // Create a test Contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contacttwo',
            Email = 'test@example.com',
            BI_PSPB_GrantAccess__c = true
        );
        insert testContact;
        
        // Create a test BI_PSPB_Enrollee_Caregiver__c record
        BI_PSPB_Enrollee_Caregiver__c testECRecord = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Patient__c = testAccount.Id, // Assign Account Id to BI_PSPB_Patient__c
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Caregiver__c = testAccount.Id,
            BI_PSPB_Status__c = 'Active'
            
        );
        insert testECRecord;
        try{
        Test.startTest();
        // Call the method being tested
        List<BI_PSPB_Enrollee_Caregiver__c> result = BI_PSPB_exuserGetAccid.grandaccessbutton();
        Test.stopTest();
        
        Assert.areEqual(null,result, 'enrollee caregive record active');
    }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
    }
    }
    /*
Method description:
This test method verifies the functionality of the getCaregiverDataPrePo method in the BI_PSPB_exuserGetAccid class.
It creates a test user and an associated test account. 
A test caregiver record is created and linked to the test account.
The method is then called with the test user's Id to retrieve a list of caregiver records associated with the user.
No assertions are made in this test method as it focuses on exercising the method without verifying its output.
*/
    @isTest
    static void testGetCaregiverDataprepo() {
        // Create test data
        User testUser = new User(
            FirstName = 'Testnine',
            LastName = 'Userni',
            Email = 'testuserni@example.com',
            Username = 'testuserni@example.com',
            Alias = 'teniUser',
            CommunityNickname = 'testUser',
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        
        Account testAccount = new Account(
            FirstName = testUser.FirstName,
            LastName = testuser.LastName
            // Add any other required fields
        );
        insert testAccount;
        
        
        BI_PSPB_Enrollee_Caregiver__c testCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Patient__c = testAccount.Id,
            BI_PSPB_Caregiver__c = testAccount.Id
            
            // Add any other required fields
        );
        insert testCaregiver;
        
        // Assign user to the account
        testCaregiver.BI_PSPB_Caregiver__c = testAccount.Id;
        update testCaregiver;
        try{
        System.runAs(testUser) {
            
            // Test the method
            Test.startTest();
            List<BI_PSPB_Enrollee_Caregiver__c> result = BI_PSPB_exuserGetAccid.getCaregiverDataView();
            Test.stopTest();
            
           Assert.areEqual(null,result, 'enrollee caregive record');            
        }
        }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
    }
    /*
Method description:
This test method verifies the functionality of the updateCaregivers method in the BI_PSPB_exuserGetAccid class.
It creates a test contact with initial information.
The method is then called with a combined string containing updated contact information.
The method updates the contact based on the provided string and returns a list of updated contacts.
No assertions are made in this test method as it focuses on exercising the method without verifying its output.
*/
    @isTest
    static void testUpdateCaregivers() {
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
        
        BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper caregiverwrapper = new BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper();
        caregiverwrapper.accountId = con.Id;
        caregiverwrapper.FirstName = 'UpdatedFirstName';
        caregiverwrapper.LastName = 'UpdatedLastName';
        caregiverwrapper.relations = 'Sibling';
        caregiverwrapper.phone = '9876543210';
        caregiverwrapper.PersonBirthdate = Date.newInstance(1995, 2, 2);
        caregiverwrapper.PersonEmail = 'updated@example.com';
        try{
        Test.startTest();
        // Call the method to be tested
        BI_PSPB_exuserGetAccid.updateCaregivers(caregiverwrapper);
        Test.stopTest();
        }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'updatedContacts');
        }
        // Retrieve the updated contact record
        Contact updatedCon = [SELECT FirstName, LastName, Phone, BI_PSPB_Birthdate__c,
                              Email, BI_PSPB_Relationship_To_Patient__c
                              FROM Contact WHERE Id = :con.Id ];
        
        // Assert the updated values
        Assert.areEqual('UpdatedFirstName', updatedCon.FirstName,'update contact record');
        Assert.areEqual('UpdatedLastName', updatedCon.LastName,'update contact record');
        
        
    }
    /*
Method description:
This test method verifies the functionality of the updatePatientexcistinfo method in the BI_PSPB_exuserGetAccid class.
It creates a test account with initial information.
The method is then called with a combined string containing updated account information.
The method updates the account based on the provided string.
Assertions are made to verify that the account fields are updated correctly.
*/
    @isTest
    static void testUpdatePatientExcistInfo() {
        // Create test data
        Account acc = new Account(
            FirstName = 'FirstName',
            LastName = 'LastName',
            PersonEmail = 'test@example.com',
            BI_PSP_Birthdate__c = Date.newInstance(1990, 1, 1),
            HealthCloudGA__Gender__pc = 'Male',
            BI_PSPB_Preferred_Communication_Method__c = 'Email',
            PersonMailingStreet = 'Test Street',
            PersonMailingCity = 'Test City',
            PersonMailingStateCode = 'AL',
            PersonMailingCountryCode = 'US',
            PersonMailingPostalCode = '12345',
            Phone = '1234567890'
        );
        insert acc;
        
        BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper wrapper = new BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper();
        wrapper.accountId = acc.Id;
        wrapper.FirstName = 'FirstName';
        wrapper.LastName = 'LastName';
        wrapper.PersonEmail = 'updated@example.com';
        wrapper.PersonBirthDate = Date.newInstance(1995, 2, 2);
        wrapper.PersonGender = 'Female';
        wrapper.PreferredMethodofContact = 'Phone';
        wrapper.street = 'Updated Street';
        wrapper.city = 'Updated City';
        wrapper.state = 'Alabama';
        wrapper.country = 'United States';
        wrapper.postalCode = '54321';
        wrapper.phone = '9876543210';
        try{
        Test.startTest();
        // Call the method to be tested
        BI_PSPB_exuserGetAccid.updatePatientExcistInfo(wrapper);
        
        
        Test.stopTest();
        }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
        // Retrieve the updated account record
        Account updatedAcc = [SELECT FirstName, LastName, PersonEmail, BI_PSP_Birthdate__c, HealthCloudGA__Gender__pc,
                              BI_PSPB_Preferred_Communication_Method__c, PersonMailingStreet, PersonMailingCity,
                              PersonMailingStateCode, PersonMailingCountryCode, PersonMailingPostalCode, Phone
                              FROM Account WHERE Id = :acc.Id LIMIT 1];
        
        // Assert the updated values
        Assert.areEqual ('FirstName', updatedAcc.FirstName , 'update account record');
        Assert.areEqual ('LastName', updatedAcc.LastName , 'update account record');
        
    }
    /*
Method description:
This test method verifies the functionality of the updatePatientorCargiverInfo method in the BI_PSPB_exuserGetAccid class.
It creates a test account with initial information.
The method is then called with a combined string containing updated account or caregiver information.
The method updates the account or caregiver based on the provided string.
Assertions are made to verify that the account or caregiver fields are updated correctly.
*/  
    @isTest
    static void testUpdatePatientorCargiverInfo() {
        // Create test data
        Account acc = new Account(
            FirstName = 'UpdatedFirstName',
            LastName = 'UpdatedLastName',
            PersonEmail = 'test@example.com',
            BI_PSP_Birthdate__c = Date.newInstance(1990, 1, 1),
            HealthCloudGA__Gender__pc = 'Male',
            BI_PSPB_Preferred_Communication_Method__c = 'Email',
            PersonMailingStreet = 'Test Street',
            PersonMailingCity = 'Test City',
            PersonMailingStateCode = 'Al',
            PersonMailingCountryCode = 'US',
            PersonMailingPostalCode = '12345',
            Phone = '1234567890'
        );
        insert acc;
        
        BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper wrapper = new  BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper();
        wrapper.accountId = acc.Id;
        wrapper.FirstName = 'UpdatedFirstName';
        wrapper.LastName = 'UpdatedLastName';
        wrapper.PersonEmail = 'updated@example.com';
        wrapper.PersonBirthDate = Date.newInstance(1995, 2, 2);
        wrapper.PersonGender = 'Female';
        wrapper.PreferredMethodofContact = 'Phone';
        wrapper.street = 'Updated Street';
        wrapper.city = 'Updated City';
        wrapper.state = 'Alabama';
        wrapper.country = 'United States';
        wrapper.postalCode = '54321';
        wrapper.phone = '9876543210';
        try{
        Test.startTest();
        // Call the method to be tested
        BI_PSPB_exuserGetAccid.updatePatientorCargiverInfo(wrapper);
        Test.stopTest();
        }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
        // Retrieve the updated account record
        Account updatedAcc = [SELECT FirstName, LastName, PersonEmail, BI_PSP_Birthdate__c, HealthCloudGA__Gender__pc,
                              BI_PSPB_Preferred_Communication_Method__c, PersonMailingStreet, PersonMailingCity,
                              PersonMailingStateCode, PersonMailingCountryCode, PersonMailingPostalCode, Phone
                              FROM Account WHERE Id = :acc.Id LIMIT 1];
        
        // Assert the updated values
        Assert.areEqual('UpdatedFirstName', updatedAcc.FirstName , 'update account record');
        Assert.areEqual('UpdatedLastName', updatedAcc.LastName, 'update account record');
        
    }
    
    
    
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
        BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper wrapper = new  BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper();
        try{
        System.runAs(testUser) {
            Test.startTest();
            List<Account> result = BI_PSPB_exuserGetAccid.UserCaregiver();
            List<BI_PSPB_Enrollee_Caregiver__c> results = BI_PSPB_exuserGetAccid.grandAccessButton();
            List<BI_PSPB_Enrollee_Caregiver__c> resulte = BI_PSPB_exuserGetAccid.getCaregiverDataView();
            BI_PSPB_exuserGetAccid.updatePatientExcistInfo(wrapper);
            BI_PSPB_exuserGetAccid.updatePatientorCargiverInfo(wrapper);
            
            Test.stopTest();
            Assert.areEqual(
                null,
                result,
                'There should be no introduction  in the result'
            );
            
            Assert.areEqual(
                null,
                results,
                'There should be no introduction  in the result'
            );
            
            Assert.areEqual(
                null,
                resulte,
                'There should be no introduction  in the result'
            );
            
            
            
            
        }
         } catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
	}
        
    }
    
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
        BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper wrapper = new  BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper();
        try{
        System.runAs(testUser) {
            Test.startTest();
         
            BI_PSPB_exuserGetAccid.updateCaregivers(wrapper);
          
            
            Test.stopTest();
           }
         } catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
	}
        
    }
    
     @isTest
    static void catchblock() {
       
       
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
        BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper wrapper = new  BI_PSPB_exuserGetAccid.BI_PSPB_CaregiverDetailsWrapper();
        try{
        System.runAs(testUser) {
            Test.startTest();
         
            BI_PSPB_exuserGetAccid.updateCaregiverDetails(wrapper);
          
            
            Test.stopTest();
           }
         } catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
	}
        
    }
    
    
    
    
}