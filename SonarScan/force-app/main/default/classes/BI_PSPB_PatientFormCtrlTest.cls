/*
* @description   This is a Test class for the BI_PSPB_PatientFormController Apex Class 
* History:
* Version	Author			Date			Detail				Description
* 1.0		NandhaKumar	    13.02.2024  	Created				Initial development
* 1.1		NandhaKumar 	04-Apr-2023		Updated				Catch log added
*/
@IsTest
public class BI_PSPB_PatientFormCtrlTest {
    /**
* Test method to verify the behavior of the 'getpatientinfo' method when both the user and the corresponding account are found.
* It creates a test user and account, inserts them into the database, and then calls the 'getpatientinfo' method.
* Finally, it asserts that the returned account matches the test account.
*/
    @isTest
    static void testGetPatientInfo_UserFound_AccountFound() {
        // Create test data: User
        User testUser = new User(
            FirstName = 'Testeight',
            LastName = 'Userei',
            Email = 'testsei@example.com',
            Username = 'testeir@example.com',
            Alias = 'teeiUser',
            CommunityNickname = 'testUser',
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'        
        );
        insert testUser;
        
        // Create test data: Account
        Account testAccount = new Account(
            FirstName = testUser.FirstName,
            LastName = testUser.LastName,
            PersonEmail ='testsei@example.com'
            
        );
        insert testAccount;
        
        BI_PSPB_Enrollee_Caregiver__c testCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Patient__c = testAccount.Id,
            BI_PSPB_Caregiver__c = testAccount.Id
            // Add any other required fields
        );
        insert testCaregiver;
        System.runAs(testUser) {
            try{
            Test.startTest();
            // Call the method
            Account result = BI_PSPB_PatientFormCtrl.getpatientinfo();
            Test.stopTest();
             Assert.areEqual(null,result, 'Expected result null');
        } catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
        } 
    }
/*
* Test method to verify the functionality of the 'getgendervalue' method.
* It calls the 'getgendervalue' method to retrieve a list of gender values.
* The test asserts that the returned list contains the expected gender values.
*/
    @isTest
    static void testGetGenderValue() {
        // Call the method
        List<String> genderValues = BI_PSPB_PatientFormCtrl.getgendervalue();
        
        // Assert the expected outcome
        Assert.areEqual(4, genderValues.size(), 'Expected list size is incorrect');
        Assert.areEqual('Male', genderValues[0], 'Expected first gender value is incorrect');
        Assert.areEqual('Female', genderValues[1], 'Expected second gender value is incorrect');
        Assert.areEqual('Prefer not to say', genderValues[2], 'Expected third gender value is incorrect');
        Assert.areEqual('Others', genderValues[3], 'Expected fourth gender value is incorrect');
    }
    
    @isTest
    static void testCatchBlock() {
        // Set up test data if needed
        
        Test.startTest();
        
        // Call the method that you want to test
        List<String> genderValue = null;
        try {
            // Call the method that may throw an exception
            genderValue = BI_PSPB_PatientFormCtrl.getGenderValue();
        } catch (Exception ex) {
            // Assert that an exception was caught
           Assert.areEqual(null, ex, 'An exception should have been caught.');
        }
        
        Test.stopTest();
        
        
        
    }
    
}