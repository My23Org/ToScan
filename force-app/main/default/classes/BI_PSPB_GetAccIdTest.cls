/*
* @description   This Apex test class verifies the functionality of the BI_PSPB_GetAccId class by testing the getAccDetails method.
* History:
* Version	Author			Date			Detail				Description
* 1.0		NandhaKumar	    06.12.2023  	Created				Initial development
*/
/**
* Test method for testing the getAccDetails method in the BI_PSPB_GetAccId class.
* This method verifies the functionality of retrieving an account associated with a user.
* It creates a test user and a corresponding test account.
* The getAccDetails method is then called with the test user's Id.
* Assertions are made to verify the following scenarios:
* - Positive scenario: User exists and has a corresponding account. Expected account is retrieved.
* - Negative scenario: User does not exist. Expected result is null.
*/
@isTest
public class BI_PSPB_GetAccIdTest {
    
    @isTest
    static void testGetAccDetails() {
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
        
        // Create a test account
        Account testAccount = new Account(
            FirstName = testUser.FirstName,
            LastName = testuser.LastName,
            PersonEmail = testUser.Email
            // Add any other required fields
        );
        insert testAccount;
        System.runAs(testUser) {
            try{
            Test.startTest();
            
            // Test positive scenario: User exists and has a corresponding account
            Account resultAccount = BI_PSPB_GetAccId.getAccDetails();
            Assert.areEqual(testAccount.Id, resultAccount.Id, 'Retrieved account should match the test account');
            
            
            //   // Test negative scenario: User does not exist
            // In this case, the method should return null
            User testUser2 = new User(
                FirstName = 'nonexistent',
                LastName = 'user',
                Email = 'nonexistent@example.com',
                Username = 'nonexistent@example.com',
                Alias = 'nonex',
                CommunityNickname = 'nonexistentuser',
                ProfileId = UserInfo.getProfileId(),
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles'
            );
            insert testUser2;
            System.runAs(testUser2) {
                Account resultAccountNull = BI_PSPB_GetAccId.getAccDetails();
                Assert.areEqual(null, resultAccountNull, 'Expected null as user does not exist');
            }
            
            
            Test.stopTest();
                 }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
        }
       
    }
}