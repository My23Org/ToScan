/**
@description    Test class for the BI_PSPB_TreatmentVideoNotification class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@IsTest
private class BI_PSPB_TreatmentVideoNotificationTest {
/**
     * @description   Test method to validate the BI_PSP_EmailAndSMS method of the BI_PSP_TreatmentVideoNotification class.
     */
    @IsTest
    static void testEmailAndSMS() {
        // Create test data - Care Program Enrollee
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        CareProgram testCP = new CareProgram(Name = 'Spevigo');
        insert testCP;
        CareProgramEnrollee testCPE = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee',
                                                              BI_PSPB_Send_Notification__c = 'Yes', 
                                                              CareProgramId = testCP.Id);
        insert testCPE;
        Test.startTest();
        BI_PSPB_treatmentVideoNotification.emailAndSMS();
        Test.stopTest();
        List<CareProgramEnrollee> leadRecord = [
					SELECT Id
					FROM CareProgramEnrollee
					WHERE Id = :testCPE.Id
				];
				assert.areEqual(
					1,
					leadRecord.size(),
					'Lead should have been created'
				);
    }
      /**
* @description Test method to verify the behavior of emailAndSMS method.
*/
     @isTest
    static void getcatch() {
        Profile standardUserProfile = [
            //creating Profile
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        if (standardUserProfile == null) {
            // If 'Standard User' profile not found, create it or handle the error
            Assert.areEqual(false,standardUserProfile, 'Standard User profile not found. Please create it or update test data setup.');
        }
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
            ProfileId = standardUserProfile.Id,
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
        System.runAs(testUser) {
            Test.startTest();
            BI_PSPB_TreatmentVideoNotification.emailAndSMS();
            Test.stopTest();
            List<Contact> leadRecord = [
					SELECT Id
					FROM Contact
					WHERE Id = :con.Id
				];
				assert.areEqual(
					1,
					leadRecord.size(),
					'Lead should have been created'
				);
        }
    }
}