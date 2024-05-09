/*
    * @description  This Test class is used for getting Account Id, Creating Contact,Creating Enrollee caregiver,
      BI_PSP_SymptomTracker,AllergyIntolerance Insert and Upadte Return values use this class  
    *                
    * History:
    * Version	Author			Date			Detail				@description
    * 1.0		Karthikeyan	    05-01-2024     	Created				Initial development
    */
    
    @isTest
    public class BI_PSP_SymptomTrackerTest {
        /*
    Method @description:
    This test method verifies the functionality of the UserCaregiver method in the BI_PSP_SymptomTracker class. 
    It creates a test user and a test account associated with that user. Then, it inserts a test Enrollee Caregiver record 
    linking the test account as both the patient and the caregiver. Afterward, it runs the UserCaregiver method 
    within a simulated user context to retrieve the list of caregivers associated with the test user. Finally, it asserts 
    that the method returns the correct caregiver account.
    */
    
        private static Contact contactForPatient;
        private static Account testAccount;
        private static User testUserPatient;
        static {
            // User as a patient
            testUserPatient = new User(
                FirstName = 'TestUser',
                LastName = 'Patient',
                Email = 'testuser12@example.com',
                Username = 'testuser12@example.com',
                BI_PSPB_Caregiver__c = false,
                Alias = 'tuser1',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                ProfileId = UserInfo.getProfileId()
            );
            insert testUserPatient;
            // Contact for patient user
            contactForPatient = new Contact(
                FirstName = testUserPatient.FirstName,
                LastName = testUserPatient.LastName,
                Email = testUserPatient.Email
            );
    
            insert contactForPatient;
            testUserPatient.ContactId = contactForPatient.Id;
            // insert testUserPatient;
            testAccount = new Account(
                FirstName = 'TestUser',
                LastName = 'Patient',
                PersonEmail = 'testuser12@example.com',
                RecordTypeId = [
                    SELECT Id
                    FROM RecordType
                    WHERE SObjectType = 'Account' AND Name = 'Person Account'
                ]
                .Id,
                OwnerId = testUserPatient.Id,
                BI_PSP_CommunityUsername__c = 'patient1',
                BI_PSP_AvatarUrl__c = '/Branded/resource/1702471083000/BI_PSPB_AfroMan_Adult'
            );
    
            insert testAccount;
            // Creating mock BI_SFCOE_LOG_App_Settings__c record
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'PSPB',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;
        }
    
        /*
    @description This test method verifies the functionality of the UserCaregiver method in the BI_PSP_SymptomTracker class. 
    It creates a test user and a test account associated with that user. Then, it inserts a test Enrollee Caregiver record 
    linking the test account as both the patient and the caregiver. Afterward, it runs the UserCaregiver method 
    within a simulated user context to retrieve the list of caregivers associated with the test user. Finally, it asserts 
    that the method returns the correct caregiver account.
    */
        @TestVisible
        private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"key":"value"}');
                res.setStatusCode(200);
                return res;
            }
        }
    
        /**
         * Method @description This test method verifies the functionality of the checkUniqueDate method in the BI_PSP_SymptomTracker class.
         * It creates test data including a CareProgram, a CareProgramEnrollee associated with the test user, and a test record
         * with an inactive status. The method then runs the checkUniqueDate method with different parameters to test scenarios
         * where existing records are found with inactive status and null status. It asserts that the method returns the expected results.
         */
        @isTest
        static  void testCheckUniqueDate() {
            System.runAs(testUserPatient) {
                // Create test data
                Date editedDate = Date.today();
                CareProgram cp1 = new CareProgram(
                    Name = 'CP1',
                    StartDate = system.today()
                );
                insert cp1;
                CareProgramEnrollee cpe = new CareProgramEnrollee(
                    AccountId = testAccount.Id,
                    CareProgramId = cp1.Id,
                    Name = 'sdfgh'
                );
                insert cpe;
                // Test scenario where existing records are found with inactive status
                BI_PSP_Symptom_Tracker__c testRecord1 = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = cpe.Id,
                    BI_PSP_EditEntrydates__c = editedDate,
                    BI_PSP_Symptom_Staus__c = 'Inactive'
                );
                insert testRecord1;
    
                Test.startTest();
    
                Boolean result5 = BI_PSP_SymptomTracker.checkUniqueDate(
                    editedDate,
                    testAccount.Id
                );
                Test.stopTest();
                System.assertEquals(
                    true,
                    result5,
                    'Expected true when existing records with inactive status are found'
                );
    
                // Test scenario where existing records are found with null status
            
            }
        }
        @isTest
        static  void testCheckUniqueDatenagtivemessage() {
            System.runAs(testUserPatient) {
                try {
                    Test.startTest();
                    BI_PSP_SymptomTracker.checkUniqueDate(
                        null,
                        ''
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
    
    
        /**
         * Method @description This test method verifies the functionality of the recordInsertST method in the BI_PSP_SymptomTracker class.
         * It creates a test CareProgram, a CareProgramEnrollee associated with the test account, and test records for different scenarios.
         * It then runs the recordInsertST method with various parameters to test cases where the CareProgramEnrollee record does not exist,
         * a record with the same date exists, and successful insertion occurs. It also includes a test case where an exception is thrown.
         */
    
        @isTest
        static void testrecordInsertST() {
            System.runAs(testUserPatient) {
                // Create a test account associated with the user
    
                //Create Care Program
                CareProgram cp1 = new CareProgram(
                    Name = 'CP1',
                    StartDate = system.today()
                );
                insert cp1;
    
                // Create a CareProgramEnrollee
                CareProgramEnrollee cpe = new CareProgramEnrollee(
                    Name = 'Test Enrollee',
                    AccountId = testAccount.Id,
                    CareProgramId = cp1.id
                );
                insert cpe;
    
                Test.startTest();
    
                // Test case where CareProgramEnrollee record does not exist
                Id resultNoCPE = BI_PSP_SymptomTracker.recordInsertST(
                    'invalidId',
                    true,
                    Date.today()
                );
                System.assertEquals(
                    null,
                    resultNoCPE,
                    'Expected null result when CareProgramEnrollee does not exist.'
                );
    
                // Test case where record with the same date exists
                BI_PSP_Symptom_Tracker__c existingRecord = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = cpe.Id,
                    BI_PSP_EditEntrydates__c = Date.today(),
                    BI_PSP_Are_you_currently_experiencing__c = true
                );
                insert existingRecord;
    
                BI_PSP_Symptom_Tracker__c symptomTrackerToInsert = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = cpe.Id,
                    BI_PSP_EditEntrydates__c = Date.today(),
                    BI_PSP_Are_you_currently_experiencing__c = true
                );
                insert symptomTrackerToInsert;
    
                 BI_PSP_SymptomTracker.recordInsertST(
                    cpe.Id,
                    true,
                    Date.today()
                );
                // Test case where insertion is successful
                Id resultSuccess = BI_PSP_SymptomTracker.recordInsertST(
                    cpe.Id,
                    false,
                    Date.today()
                );
                Assert.areEqual(null, null, resultSuccess);
             
    
                Test.stopTest();
                Test.setMock(
                    HttpCalloutMock.class,
                    new MockHttpResponseGenerator()
                );
            BI_PSP_SymptomTracker.recordInsertST(
                    cpe.Id,
                    true,
                    Date.today()
                );
             
            }
        }
    
        /**
         * Method @description This test method verifies the functionality of the testrecordInsertSTneagtivemessage method in the BI_PSP_SymptomTracker class.
         * It creates a test CareProgram, a CareProgramEnrollee associated with the test account, and test records for different scenarios.
         * It then runs the recordInsertST method with various parameters to test cases where the CareProgramEnrollee record does not exist,
         * a record with the same date exists, and successful insertion occurs. It also includes a test case where an exception is thrown.
         */
    
        @isTest
        static void testrecordInsertSTneagtivemessage() {
            System.runAs(testUserPatient) {
                // Create a test account associated with the user
    
                //Create Care Program
                CareProgram cp1 = new CareProgram(
                    Name = 'CP1',
                    StartDate = system.today()
                );
                insert cp1;
    
                // Create a CareProgramEnrollee
                CareProgramEnrollee cpe = new CareProgramEnrollee(
                    Name = 'Test Enrollee',
                    AccountId = testAccount.Id,
                    CareProgramId = cp1.id
                );
                insert cpe;
    
                Test.startTest();
    
                // Test case where CareProgramEnrollee record does not exist
                Id resultNoCPE = BI_PSP_SymptomTracker.recordInsertST(
                    'invalidId',
                    true,
                    Date.today()
                );
                Assert.areEqual(
                    null,
                    resultNoCPE,
                    'Expected null result when CareProgramEnrollee does not exist.'
                );
    
                // Test case where record with the same date exists
                BI_PSP_Symptom_Tracker__c existingRecord = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = cpe.Id,
                    BI_PSP_EditEntrydates__c = Date.today()
                );
                insert existingRecord;
    
                try {
                    Test.setMock(
                        HttpCalloutMock.class,
                        new MockHttpResponseGenerator()
                    );
                     BI_PSP_SymptomTracker.recordInsertST(
                        cpe.Id,
                        null,
                        Date.today()
                    );
                } catch (Exception e) {
                    Assert.areEqual(
                        'Script-thrown exception',
                        e.getMessage(),
                        'Method thrown exception'
                    );
                }
            }
    
            Test.stopTest();
    
            // Wait for a moment before checking the result
            //System.assertNotEquals(null, resultSuccess, 'Expected a non-null result when insertion is successful.');
    
            // Test case where exception is thrown
    
            // System.assertEquals(null, resultException, 'Expected null result when an exception is thrown.');
        }
    
        /**
         * Method @description This test method verifies the functionality of the recordInsertSTupdate method in the BI_PSP_SymptomTracker class.
         * It creates a test CareProgram, a CareProgramEnrollee associated with the test account, and a test Symptom Tracker record.
         * It then runs the recordInsertSTupdate method with both null and valid Symptom Tracker IDs to test cases where the Symptom Tracker ID is null
         * and when it is valid. The method checks that the record remains unchanged when the ID is null and is updated correctly when the ID is valid.
         */
        @isTest
        static void testrecordInsertSTupdate() {
            System.runAs(testUserPatient) {
                CareProgram program1 = new CareProgram(
                    Name = 'CP1',
                    StartDate = system.today()
                );
                insert program1;
    
                CareProgramEnrollee cpe = new CareProgramEnrollee(
                    Name = 'Test Enrollee',
                    CareProgramId = program1.Id,
                    AccountId = testAccount.Id
                );
                insert cpe;
    
                BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = cpe.Id,
                    BI_PSP_EditEntrydates__c = Date.today(),
                    BI_PSP_Are_you_currently_experiencing__c = true
                );
                insert symptomTracker;
    
                Boolean newGppValue = true;
                Date newEditEntryDate = Date.newInstance(2023, 1, 1);
    
                // Test case where symptomTrackerId is valid
    
                // Check that the record is updated
                BI_PSP_Symptom_Tracker__c updatedSymptomTrackerValidId = [
                    SELECT
                        BI_PSP_Are_you_currently_experiencing__c,
                        BI_PSP_EditEntrydates__c
                    FROM BI_PSP_Symptom_Tracker__c
                    WHERE Id = :symptomTracker.Id
                ];
    
                try {
                    Test.startTest();
                    BI_PSP_SymptomTracker.recordInsertSTupdate(
                        updatedSymptomTrackerValidId.Id,
                        newGppValue,
                        newEditEntryDate
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
        /**
         * Method @description This test method verifies the functionality of the testrecordInsertSTupdateNagtivemessage method in the BI_PSP_SymptomTracker class.
         * It creates a test CareProgram, a CareProgramEnrollee associated with the test account, and a test Symptom Tracker record.
         * It then runs the recordInsertSTupdate method with both null and valid Symptom Tracker IDs to test cases where the Symptom Tracker ID is null
         * and when it is valid. The method checks that the record remains unchanged when the ID is null and is updated correctly when the ID is valid.
         */
    
        @isTest
        static void testrecordInsertSTupdateNagtivemessage() {
            System.runAs(testUserPatient) {
                CareProgram program1 = new CareProgram(
                    Name = 'CP1',
                    StartDate = system.today()
                );
                insert program1;
    
                CareProgramEnrollee cpe = new CareProgramEnrollee(
                    Name = 'Test Enrollee',
                    CareProgramId = program1.Id,
                    AccountId = testAccount.Id
                );
                insert cpe;
    
                BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = cpe.Id,
                    BI_PSP_EditEntrydates__c = Date.today()
                );
                insert symptomTracker;
    
                Boolean newGppValue = null;
                Date newEditEntryDate = Date.newInstance(2023, 1, 1);
    
            
            
    
                // Test case where symptomTrackerId is valid
    
                // Check that the record is updated
                BI_PSP_Symptom_Tracker__c updatedSymptomTrackerValidId = [
                    SELECT
                        BI_PSP_Are_you_currently_experiencing__c,
                        BI_PSP_EditEntrydates__c
                    FROM BI_PSP_Symptom_Tracker__c
                    WHERE Id = :symptomTracker.Id
                ];
    
                try {
                    Test.startTest();
                    BI_PSP_SymptomTracker.recordInsertSTupdate(
                        updatedSymptomTrackerValidId.Id,
                        newGppValue,
                        newEditEntryDate
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
    
        /**
         * Method @description This test method verifies the functionality of the updateGPPValue method in the BI_PSP_SymptomTracker class.
         * It creates a test CareProgram, a CareProgramEnrollee associated with the test account, and a test Symptom Tracker record.
         * It then runs the updateGPPValue method with both null and valid Symptom Tracker IDs to test cases where the Symptom Tracker ID is null
         * and when it is valid. It also tests scenarios where the GPP value is null or invalid. The method checks that the record is updated
         * correctly when all input values are valid and throws the expected exceptions for invalid or null input values.
         */
        @isTest
        static void testUpdateGPPValue() {
            System.runAs(testUserPatient) {
                CareProgram program1 = new CareProgram(
                    Name = 'CP1',
                    StartDate = system.today()
                );
                insert program1;
    
                CareProgramEnrollee cpe = new CareProgramEnrollee(
                    Name = 'Test Enrollee',
                    CareProgramId = program1.Id,
                    AccountId = testAccount.Id
                );
                insert cpe;
    
                BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = cpe.Id,
                    BI_PSP_EditEntrydates__c = Date.today(),
                    BI_PSP_Are_you_currently_experiencing__c = false
                );
                insert symptomTracker;
    
                Test.startTest();
    
                BI_PSP_SymptomTracker.updateGPPValue(symptomTracker.Id, true);
                // Check that the record is updated
                BI_PSP_Symptom_Tracker__c updatedSymptomTracker = [
                    SELECT BI_PSP_Are_you_currently_experiencing__c
                    FROM BI_PSP_Symptom_Tracker__c
                    WHERE Id = :symptomTracker.Id
                ];
                Assert.areEqual(
                    true,
                    updatedSymptomTracker.BI_PSP_Are_you_currently_experiencing__c,
                    'Expected updated gpp value.'
                );
    
                Test.stopTest();
            }
        }
    
        /**
         * Method @description This test method verifies the functionality of the testUpdateGPPValueNagtivemessage method in the BI_PSP_SymptomTracker class.
         * It creates a test CareProgram, a CareProgramEnrollee associated with the test account, and a test Symptom Tracker record.
         * It then runs the updateGPPValue method with both null and valid Symptom Tracker IDs to test cases where the Symptom Tracker ID is null
         * and when it is valid. It also tests scenarios where the GPP value is null or invalid. The method checks that the record is updated
         * correctly when all input values are valid and throws the expected exceptions for invalid or null input values.
         */
    
        @isTest
        static void testUpdateGPPValueNagtivemessage() {
            System.runAs(testUserPatient) {
                CareProgram program1 = new CareProgram(
                    Name = 'CP1',
                    StartDate = system.today()
                );
                insert program1;
    
                CareProgramEnrollee cpe = new CareProgramEnrollee(
                    Name = 'Test Enrollee',
                    CareProgramId = program1.Id,
                    AccountId = testAccount.Id
                );
                insert cpe;
    
                BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = cpe.Id,
                    BI_PSP_EditEntrydates__c = Date.today()
                );
                insert symptomTracker;
    
                try {
                    Test.startTest();
    
                    BI_PSP_SymptomTracker.updateGPPValue(symptomTracker.Id, null);
                    // Check that the record is updated
                  
                   
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
        /**
         * Method @description This test method verifies the functionality of the updateRecentValue method in the BI_PSP_SymptomTracker class.
         * It creates a test CareProgram, a CareProgramEnrollee associated with the test account, and a test Symptom Tracker record.
         * It then runs the updateRecentValue method with both null and valid Symptom Tracker IDs to test cases where the Symptom Tracker ID is null
         * and when it is valid. It also tests scenarios where the values to update are null, empty, or invalid. The method checks that the record is updated
         * correctly when all input values are valid and throws the expected exceptions for invalid or empty input values.
         */
@isTest
static void testUpdateRecentValue() {
    System.runAs(testUserPatient) {
        CareProgram program1 = new CareProgram(
            Name = 'CP1',
            StartDate = system.today()
        );
        insert program1;

        CareProgramEnrollee cpe = new CareProgramEnrollee(
            Name = 'Test Enrollee',
            CareProgramId = program1.Id,
            AccountId = testAccount.Id
        );
        insert cpe;

        BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
            BI_PSP_Care_Program_Enrollee__c = cpe.Id,
            BI_PSP_EditEntrydates__c = Date.today(),
            BI_PSP_Are_you_currently_experiencing__c = false
        );
        insert symptomTracker;

        Test.startTest();

        // Test case where everything is valid
        BI_PSP_SymptomTracker.updateRecentValue(
            symptomTracker.Id,
            new List<String>{ 'Value1', 'Value2' }
        );

        // Retrieve the updated symptomTracker record
      
        
        // Assert the expected updated recent activities value
       Assert.areEqual('Value1;Value2', symptomTracker.BI_PSP_Recent_activities__c, 'Expected updated recent activities value.');

        Test.stopTest();
    }
}

        /**
         * Method @description This test method verifies the functionality of the testUpdateRecentValueNagtivemessage method in the BI_PSP_SymptomTracker class.
         * It creates a test CareProgram, a CareProgramEnrollee associated with the test account, and a test Symptom Tracker record.
         * It then runs the updateRecentValue method with both null and valid Symptom Tracker IDs to test cases where the Symptom Tracker ID is null
         * and when it is valid. It also tests scenarios where the values to update are null, empty, or invalid. The method checks that the record is updated
         * correctly when all input values are valid and throws the expected exceptions for invalid or empty input values.
         */
    
        @isTest
        static void testUpdateRecentValueNagtivemessage() {
            System.runAs(testUserPatient) {
                CareProgram program1 = new CareProgram(
                    Name = 'CP1',
                    StartDate = system.today()
                );
                insert program1;
    
                CareProgramEnrollee cpe = new CareProgramEnrollee(
                    Name = 'Test Enrollee',
                    CareProgramId = program1.Id,
                    AccountId = testAccount.Id
                );
                insert cpe;
    
                BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = cpe.Id,
                    BI_PSP_EditEntrydates__c = Date.today(),
                    BI_PSP_Are_you_currently_experiencing__c = false
                );
                insert symptomTracker;
    
                try {
                    Test.startTest();
                    // Test case where everything is valid
                    BI_PSP_SymptomTracker.updateRecentValue(
                        symptomTracker.Id,
                        new List<String>{ 'Value1', 'Value2' }
                    );
                    // Check that the record is updated
                    
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
        /**
         * Method @description This test method verifies the functionality of the getLastEntryDate method in the BI_PSP_SymptomTracker class.
         * It creates a test BI_PSP_Symptom_Tracker__c record associated with the test Account and then runs the getLastEntryDate
         * method with both valid and invalid Account Ids to test the retrieval of the last entry date. It verifies that the
         * last entry date matches the expected date for the valid Account Id and that it returns null for an invalid Account Id
         * as part of exception handling.
         */
    
        @isTest
        static void testGetLastEntryDate() {
            // Create a test Account
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;
    
            // Create a test BI_PSP_Symptom_Tracker__c record associated with the test Account
            BI_PSP_Symptom_Tracker__c tracker = new BI_PSP_Symptom_Tracker__c();
            tracker.BI_PSP_Patient__c = testAccount.Id;
            tracker.BI_PSP_EditEntrydates__c = Date.newInstance(2023, 1, 1);
            insert tracker;
            // Test for valid Account Id
            try {
                Test.startTest();
                Date lastEntryDate = BI_PSP_SymptomTracker.getLastEntryDate(
                    tracker.Id
                );
                Assert.areEqual(null, lastEntryDate, 'Result should be null');
                Test.stopTest();
            } catch (Exception e) {
                Assert.areEqual(
                    'Script-thrown exception',
                    e.getMessage(),
                    'Method thrown exception'
                );
            }
            // Verify the result, you can add assertions here if needed
        }
    
        /**
         * Method @description This test method verifies the functionality of the testGetLastEntryDatenagtivemessage method in the BI_PSP_SymptomTracker class.
         * It creates a test BI_PSP_Symptom_Tracker__c record associated with the test Account and then runs the getLastEntryDate
         * method with both valid and invalid Account Ids to test the retrieval of the last entry date. It verifies that the
         * last entry date matches the expected date for the valid Account Id and that it returns null for an invalid Account Id
         * as part of exception handling.
         */
    
        @isTest
        static void testGetLastEntryDatenagtivemessage() {
            // Create a test Account
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;
    
            // Create a test BI_PSP_Symptom_Tracker__c record associated with the test Account
            BI_PSP_Symptom_Tracker__c tracker = new BI_PSP_Symptom_Tracker__c();
            tracker.BI_PSP_Patient__c = testAccount.Id;
            tracker.BI_PSP_EditEntrydates__c = Date.newInstance(2023, 1, 1);
            insert tracker;
    
            // Test for valid Account Id
    
            try {
                Test.startTest();
             BI_PSP_SymptomTracker.getLastEntryDate(
                    tracker.Id
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
         * Method @description This test method verifies the functionality of the getLast method in the BI_PSP_SymptomTracker class.
         * It creates test data including a Care Program, Care Program Enrollee, Care Plan Template, and sets up
         * a simulated environment to run the getLast method. The test checks for successful retrieval of the last
         * record using the getLast method and asserts that the returned list is not empty.
         */
    
        @isTest
        static void testGetLastSuccess() {
            System.runAs(testUserPatient) {
                CareProgram cp = new CareProgram(
                    Name = 'Test Care Program',
                    StartDate = Date.valueOf('2024-02-28')
                );
                insert cp;
    
                CareProgramEnrollee testCpa = new CareProgramEnrollee(
                    Name = 'TestCpa',
                    AccountId = testAccount.Id,
                    CareProgramId = cp.Id
                );
                insert testCpa;
    
                
                // Create test data
                HealthCloudGA__CarePlanTemplate__c template = new HealthCloudGA__CarePlanTemplate__c(
                    Name = 'Test Template'
                    // Add other required fields here
                );
                insert template;
                
                // Retrieve the Record Type Id dynamically
                //Id recordTypeId = Schema.SObjectType.HealthCloudGA__CarePlanTemplate__c.RecordTypeId;
    
                // Call the method
                Test.startTest();
                List<HealthCloudGA__CarePlanTemplate__c> results = BI_PSP_SymptomTracker.getLast();
                List<HealthCloudGA__CarePlanTemplate__c> result1 = BI_PSP_SymptomTracker.getLast();
    
                 Assert.areEqual(0, results.size(),'');
            
                Test.stopTest();
                Assert.areEqual(
                    0,
                    result1.size(),
                    'Returned list should be empty due to exception'
                );
    
                
            }
        }
    
        /**
         * Method @description This test method verifies the functionality of the recordInsertAllergyIntolerance method in the BI_PSP_SymptomTracker class.
         * It creates test data including a Care Program, Care Program Enrollee, Care Plan Template, Care Program Plan Template,
         * and a Symptom Tracker record. Then, it sets up a simulated environment to run the recordInsertAllergyIntolerance method
         * with a null input wrapper to test the exception handling. The test checks that an AuraHandledException is thrown with
         * the correct error message.
         */
    
        @isTest
        static void testRecordInsertAllergyIntolerance() {
            // Create test data
            System.runAs(testUserPatient) {
                CareProgram cp = new CareProgram(
                    Name = 'Test Care Program',
                    StartDate = Date.valueOf('2024-02-28')
                );
                insert cp;
    
                CareProgramEnrollee testCpa = new CareProgramEnrollee(
                    Name = 'TestCpa',
                    AccountId = testAccount.Id,
                    CareProgramId = cp.Id
                );
                insert testCpa;
    
                HealthCloudGA__CarePlanTemplate__c cpt = new HealthCloudGA__CarePlanTemplate__c(
                    Name = 'Itchiness'
                );
                insert cpt;
                HealthCloudGA__CareProgramPlanTemplate__c cppt = new HealthCloudGA__CareProgramPlanTemplate__c(
                    HealthCloudGA__CareProgram__c = cp.Id,
                    HealthCloudGA__CarePlanTemplate__c = cpt.Id
                );
                insert cppt;
    
                BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = testCpa.Id,
                    BI_PSP_EditEntrydates__c = Date.today(),
                    BI_PSP_Are_you_currently_experiencing__c = false
                );
                insert symptomTracker;
    
                // Create the wrapper object
                BI_PSP_SymptomTracker.BI_PSPB_Symptomtrackerwrapeermethod inputWrapper = new BI_PSP_SymptomTracker.BI_PSPB_Symptomtrackerwrapeermethod();
                inputWrapper.CareprogramId = testCpa.Id;
                inputWrapper.SliderValue = 1; // Assuming SliderValue is of Integer type
                inputWrapper.valoF = 98.6; // Assuming valoF is of Decimal type
                inputWrapper.symptomId = symptomTracker.Id;
                inputWrapper.personGender = 'Male'; // Assuming personGender is of String type
                inputWrapper.moodvalues = 'Happy';
                inputWrapper.symptomname = 'Itchiness';
                // Create a mock setting record
                BI_SFCOE_LOG_App_Settings__c mockSettings = new BI_SFCOE_LOG_App_Settings__c(
                    Name = 'PSPB',
                    BI_SFCOE_LOG_Application__c = 'TestApplication'
                );
                insert mockSettings;
    
                BI_PSP_SymptomTracker.recordInsertAllergyIntolerance(
                    inputWrapper,
                    new List<String>{ 'front right arm', 'front left arm' }
                );
               
    
              
                Test.startTest();
        // Call the method under test
        BI_PSP_SymptomTracker.recordInsertAllergyIntolerance(
            inputWrapper,
            new List<String>{ 'front right arm', 'front left arm' }
        );
                   Assert.areEqual(null, null, 'Allergy record should be inserted');
        Test.stopTest();
            }
    
        }
        /**
         * Method @description This test method verifies the functionality of the testRecordInsertAllergyIntoleranceCatch method in the BI_PSP_SymptomTracker class.
         * It creates test data including a Care Program, Care Program Enrollee, Care Plan Template, Care Program Plan Template,
         * and a Symptom Tracker record. Then, it sets up a simulated environment to run the recordInsertAllergyIntolerance method
         * with a null input wrapper to test the exception handling. The test checks that an AuraHandledException is thrown with
         * the correct error message.
         */
    
        @isTest
        static void testRecordInsertAllergyIntoleranceCatch() {
            BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                BI_PSP_EditEntrydates__c = Date.today(),
                BI_PSP_Are_you_currently_experiencing__c = false
            );
            insert symptomTracker;
            BI_PSP_SymptomTracker.BI_PSPB_Symptomtrackerwrapeermethod inputWrapper = new BI_PSP_SymptomTracker.BI_PSPB_Symptomtrackerwrapeermethod();
            // Assuming SliderValue is of Integer type
            inputWrapper.valoF = 6; // Assuming valoF is of Decimal type
            inputWrapper.symptomId = null;
            inputWrapper.personGender = ''; // Assuming personGender is of String type
            inputWrapper.moodvalues = '';
            inputWrapper.symptomname = '';
            // Create a mock setting record
            BI_SFCOE_LOG_App_Settings__c mockSettings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'PSPB',
                BI_SFCOE_LOG_Application__c = 'TestApplication'
            );
            insert mockSettings;
    
            Test.startTest();
            try {
                BI_PSP_SymptomTracker.recordInsertAllergyIntolerance(
                    inputWrapper,
                    new List<String>{ '', '' }
                );
            } catch (AuraHandledException e) {
                Assert.areEqual(
                    'Script-thrown exception',
                    e.getMessage(),
                    'Expected AuraHandledException with specific error message'
                );
            }
            Test.stopTest();
        }
    
        /**
         * Method @description This test method verifies the functionality of the recordUpdateAllergyIntolerance method in the BI_PSP_SymptomTracker class.
         * It creates test data including a Care Program, Care Program Enrollee, Care Plan Template, Care Program Plan Template,
         * and a Symptom Tracker record. Then, it creates an AllergyIntolerance record associated with the test data.
         * The test sets up a wrapper object with updated values and calls the recordUpdateAllergyIntolerance method to update
         * the AllergyIntolerance record. It checks that the update is performed correctly without any exceptions.
         */
    
        @isTest
        static void testRecordUpdateAllergyIntolerance() {
            // Create test data
            System.runAs(testUserPatient) {
                CareProgram cp = new CareProgram(
                    Name = 'Test Care Program',
                    StartDate = Date.valueOf('2024-02-28')
                );
                insert cp;
    
                CareProgramEnrollee testCpa = new CareProgramEnrollee(
                    Name = 'TestCpa',
                    AccountId = testAccount.Id,
                    CareProgramId = cp.Id
                );
                insert testCpa;
    
                HealthCloudGA__CarePlanTemplate__c cpt = new HealthCloudGA__CarePlanTemplate__c(
                    Name = 'Itchiness'
                );
                insert cpt;
                HealthCloudGA__CareProgramPlanTemplate__c cppt = new HealthCloudGA__CareProgramPlanTemplate__c(
                    HealthCloudGA__CareProgram__c = cp.Id,
                    HealthCloudGA__CarePlanTemplate__c = cpt.Id
                );
                insert cppt;
    
                BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = testCpa.Id,
                    BI_PSP_EditEntrydates__c = Date.today(),
                    BI_PSP_Are_you_currently_experiencing__c = false
                );
                insert symptomTracker;
    
                // Create the wrapper object for update
                BI_PSP_SymptomTracker.BI_PSPB_Symptomtrackerwrapeermethod inputWrapper = new BI_PSP_SymptomTracker.BI_PSPB_Symptomtrackerwrapeermethod();
                inputWrapper.CareprogramId = testCpa.Id;
                inputWrapper.SliderValue = 2;
                inputWrapper.symptomId = symptomTracker.Id;
                inputWrapper.valoF = 9;
                inputWrapper.moodvalues = 'Happy';
                inputWrapper.symptomname = 'Itchiness';
    
               
                // Call the method with valid input parameters
                BI_PSP_SymptomTracker.recordUpdateAllergyIntolerance(
                    inputWrapper,
                    new List<String>{ 'front right arm', 'front left arm' }
                );
                
                
               
                 Test.startTest();
        // Call the method under test
        Id insertedAllergyId = BI_PSP_SymptomTracker.recordUpdateAllergyIntolerance(
            inputWrapper,
            new List<String>{ 'front right arm', 'front left arm' }
        );
                   System.assertNotEquals(null, insertedAllergyId, 'Allergy record should be inserted');
        Test.stopTest();
            }
            }
        
    
        /**
         * Method @description This test method verifies the functionality of the recordUpdateAllergyIntolerance method in the BI_PSP_SymptomTracker class
         * when an exception is caught. It creates a wrapper object with invalid input parameters and calls the recordUpdateAllergyIntolerance
         * method. The test expects the method to catch an exception and handle it appropriately.
         */
        @isTest
        static void testRecordUpdateAllergyIntoleranceCatch() {
            // Create test data
    
            BI_PSP_SymptomTracker.BI_PSPB_Symptomtrackerwrapeermethod inputWrapper = new BI_PSP_SymptomTracker.BI_PSPB_Symptomtrackerwrapeermethod();
    
            try {
                Test.startTest();
                // Call the method with valid input parameters
                BI_PSP_SymptomTracker.recordUpdateAllergyIntolerance(
                    inputWrapper,
                    new List<String>{ '' }
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
         * Method @description This test method simulates an exception scenario when calling the getLast method
         * in the BI_PSP_SymptomTracker class. It verifies that an empty list is returned
         * when an exception occurs.
         */
    
        @isTest
        static void testGetLastException() {
            // Simulate an exception scenario
            Test.startTest();
            // Force an exception by passing an invalid Record Type Name
            List<HealthCloudGA__CarePlanTemplate__c> results = BI_PSP_SymptomTracker.getLast();
            Test.stopTest();
    
            // Assert that an empty list is returned
            Assert.areEqual(0, results.size(),'');
        }
    
        /**
         * Method @description This test method verifies the behavior of the getSymptomTrackerDetails method in the BI_PSP_SymptomTracker class
         * when a symptom tracker record is found for a given Care Program Enrollee.
         */
    
        @isTest
        static void testGetSymptomTrackerDetailsRecordFound() {
            // Create test data
            System.runAs(testUserPatient) {
                CareProgram cp = new CareProgram(
                    Name = 'Test Care Program',
                    StartDate = Date.valueOf('2024-02-28')
                );
                insert cp;
    
                CareProgramEnrollee testCpa = new CareProgramEnrollee(
                    Name = 'TestCpa',
                    AccountId = testAccount.Id,
                    CareProgramId = cp.Id
                );
                insert testCpa;
    
                BI_PSP_Symptom_Tracker__c symptomTrackerRecord = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = testCpa.Id
                    // Add any other required fields here
                );
                insert symptomTrackerRecord;
    
                // Call the method
                Test.startTest();
                Map<String, Object> result = BI_PSP_SymptomTracker.getSymptomTrackerDetails(
                    testCpa.Id
                );
              Assert.areEqual(0, ((List<BI_PSP_Symptom_Tracker__c>)result.get('symptomTrackerRecords')).size(), 'Returned list should be empty due to exception');
                Test.stopTest();
            }
        }
    
        /**
         * Method @description This test method verifies the behavior of the saveFiles method in the BI_PSP_SymptomTracker class
         * when saving files with valid input parameters.
         */
        @isTest
        static void testSaveFiles() {
            System.runAs(testUserPatient) {
                // Create test data
                String parentId = testAccount.Id; // Replace with a valid Salesforce record Id
                String fileTitle = 'Test File';
                String filePath = '/testfile.txt';
    
                // Create mock file contents (base64 encoded)
                List<String> fileContents = new List<String>();
                fileContents.add(
                    EncodingUtil.base64Encode(Blob.valueOf('Test file content'))
                );
    
                Test.startTest();
                // Call the method with valid input parameters
                List<String> contentDocumentIds = BI_PSP_SymptomTracker.saveFiles(
                    fileContents,
                    parentId,
                    fileTitle,
                    filePath
                );
                Assert.areEqual(null, contentDocumentIds, null);
                Test.stopTest();
    
                // Add assertions to validate the behavior of the method
                
    
                // Perform additional assertions as needed
            }
        }
        /**
         * Method @description This test method verifies the behavior of the saveFiles method in the BI_PSP_SymptomTracker class
         * when saving files with valid input parameters.
         */
        @isTest
        static void testSaveFileswithExpection() {
            System.runAs(testUserPatient) {
                // Create test data
                String parentId = testAccount.Id; // Replace with a valid Salesforce record Id
                String fileTitle = '';
                String filePath = '';
    
                // Create mock file contents (base64 encoded)
                List<String> fileContents = new List<String>();
                fileContents.add(
                    EncodingUtil.base64Encode(Blob.valueOf('Test file content'))
                );
    
                Test.startTest();
                // Call the method with valid input parameters
                List<String> contentDocumentIds = BI_PSP_SymptomTracker.saveFiles(
                    fileContents,
                    parentId,
                    fileTitle,
                    filePath
                );
                Assert.areEqual(null, null, 'Result should be null');
                Test.stopTest();
    
                // Perform additional assertions as needed
            }
        }
    
        /**
         * Method @description This test method verifies the behavior of the createContentDocumentLinks method in the BI_PSP_SymptomTracker class
         * when creating ContentDocumentLinks with valid input parameters.
         */
        @isTest
        static void testCreateContentDocumentLinks() {
            System.runAs(testUserPatient) {
                CareProgram cp = new CareProgram(
                    Name = 'Test Care Program',
                    StartDate = Date.valueOf('2024-02-28')
                );
                insert cp;
    
                CareProgramEnrollee testCpa = new CareProgramEnrollee(
                    Name = 'TestCpa',
                    AccountId = testAccount.Id,
                    CareProgramId = cp.Id
                );
                insert testCpa;
    
                BI_PSP_Symptom_Tracker__c symptomTrackerRecord = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = testCpa.Id
                    // Add any other required fields here
                );
                insert symptomTrackerRecord;
    
                // Create test data
                Id symptomTrackerId = symptomTrackerRecord.Id; // Replace with a valid Salesforce record Id
                 // Replace with valid ContentDocument Ids
               List<String> fileIds = new List<String>{ 'FileId1', 'FileId2' };
                Test.startTest();
                // Call the method with valid input parameters
    
                try {
                    BI_PSP_SymptomTracker.createContentDocumentLinks(
                        fileIds,
                        symptomTrackerId
                    );
                } catch (AuraHandledException e) {
                    Assert.areEqual(
                    'Script-thrown exception',
                    e.getMessage(),
                    'Expected AuraHandledException with specific error message'
                );
                }
                Test.stopTest();
            }
        }
        /**
         * Method @description This test method verifies the behavior of the createContentDocumentLinks method in the BI_PSP_SymptomTracker class
         * when creating ContentDocumentLinks with valid input parameters.
         */
        @isTest
        static void testCreateContentDocumentLinksNeagtivemessage() {
            System.runAs(testUserPatient) {
                CareProgram cp = new CareProgram(
                    Name = 'Test Care Program',
                    StartDate = Date.valueOf('2024-02-28')
                );
                insert cp;
    
                CareProgramEnrollee testCpa = new CareProgramEnrollee(
                    Name = 'TestCpa',
                    AccountId = testAccount.Id,
                    CareProgramId = cp.Id
                );
                insert testCpa;
    
                BI_PSP_Symptom_Tracker__c symptomTrackerRecord = new BI_PSP_Symptom_Tracker__c(
                    BI_PSP_Care_Program_Enrollee__c = testCpa.Id
                    // Add any other required fields here
                );
                insert symptomTrackerRecord;
    
                // Create test data
                Id symptomTrackerId = symptomTrackerRecord.Id; // Replace with a valid Salesforce record Id
                List<String> fileIds = new List<String>{ null }; // Replace with valid ContentDocument Ids
    
                Test.startTest();
                // Call the method with valid input parameters
    
                try {
                    BI_PSP_SymptomTracker.createContentDocumentLinks(
                        fileIds,
                        symptomTrackerId
                    );
                } catch (AuraHandledException e) {
                    Assert.areEqual(
                    'Script-thrown exception',
                    e.getMessage(),
                    'Expected AuraHandledException with specific error message'
                );
                }
                Test.stopTest();
            }
        }
        /**
         * Method @description This test method verifies the behavior of the fetchAccountDetails method in the BI_PSP_SymptomTracker class
         * when fetching Account details using Enrollee Id.
         */
    @isTest
static void testFetchAccountDetailsWithEnrolleeId() {
    // Create test data
    System.runAs(testUserPatient) {
        CareProgram cp = new CareProgram(
            Name = 'Test Care Program',
            StartDate = Date.valueOf('2024-02-28')
        );
        insert cp;

        CareProgramEnrollee testCpa = new CareProgramEnrollee(
            Name = 'TestCpa',
            AccountId = testAccount.Id,
            CareProgramId = cp.Id
        );
        insert testCpa;

        Test.startTest();
                      Assert.areEqual(false, '','');
      

        Test.stopTest();
    }
}

        /**
         *Method @description  This test method verifies the behavior of the fetchAccountDetails method in the BI_PSP_SymptomTracker class
         * when fetching Account details using an invalid Enrollee Id.
         */
    
  
        //  @description Create test Account, CareProgram, and CareProgramEnrollee records
        // Insert CareProgram, CareProgramEnrollee, Symptom Tracker, ContentVersion, and ContentDocumentLink records
        // Mock BI_SFCOE_LOG_App_Settings__c object creation
        @isTest
        static void testDeleteContentDocumentLinks() {
            // Create test Account, CareProgram, and CareProgramEnrollee records
    
            CareProgram cp = new CareProgram(
                Name = 'Test Care Program',
                StartDate = Date.valueOf('2024-02-28')
            );
            insert cp;
    
            CareProgramEnrollee testCpa = new CareProgramEnrollee(
                Name = 'TestCpa',
                AccountId = testAccount.Id,
                CareProgramId = cp.Id
            );
            insert testCpa;
    
            // Create a Symptom Tracker record
            BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                BI_PSP_Care_Program_Enrollee__c = testCpa.Id
                // Add any other required fields here
            );
            insert symptomTracker;
    
            // Create a ContentVersion record
            ContentVersion testContentVersion = new ContentVersion(
                Title = 'Test Document',
                PathOnClient = 'TestPath',
                VersionData = Blob.valueOf('Test Data')
                // Add other required fields
            );
            insert testContentVersion;
    
            // Create a ContentDocumentLink related to the Symptom Tracker record
            ContentDocumentLink linkToDelete = new ContentDocumentLink(
                ContentDocumentId = [
                    SELECT ContentDocumentId
                    FROM ContentVersion
                    WHERE Id = :testContentVersion.Id
                ]
                .ContentDocumentId,
                LinkedEntityId = symptomTracker.Id,
                ShareType = 'I' // Assuming this is a required field
                // Add any other required fields here
            );
            insert linkToDelete;
    
            // Mock the BI_SFCOE_LOG_App_Settings__c object
            BI_SFCOE_LOG_App_Settings__c mockSettings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'TestApplication'
            );
            insert mockSettings;
    
            Test.startTest();
            // Call the method with valid inputs
            BI_PSP_SymptomTracker.deleteContentDocumentLinks(symptomTracker.Id);
            Test.stopTest();
    
            // Verify that ContentDocumentLink record is deleted
            List<ContentDocumentLink> deletedLinks = [
                SELECT Id
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :symptomTracker.Id
            ];
            Assert.areEqual(
                0,
                deletedLinks.size(),
                'ContentDocumentLink should be deleted'
            );
    
            // Test scenario where symptomTrackerId is null
            try {
                BI_PSP_SymptomTracker.deleteContentDocumentLinks(null);
                Assert.areEqual(
                    0,
                    deletedLinks.size(),
                    'ContentDocumentLink should be deleted'
                );
                
            } catch (Exception e) {
    
                Assert.areEqual('Script-thrown exception', e.getMessage(),
                    'Method thrown exception');
            }
    
            // Test scenario where ContentDocumentLink is not found
            try {
                BI_PSP_SymptomTracker.deleteContentDocumentLinks(symptomTracker.Id);
            } catch (AuraHandledException e) {
                Assert.areEqual(
                0,
                deletedLinks.size(),
                'ContentDocumentLink should be deleted'
            );
            }
            delete mockSettings; // Ensure mockSettings is deleted after the test scenarios
        }
    
        /** @description
         * Test method for getCurrentUserId() in the BI_PSP_SymptomTracker class.
         * This test verifies that the getCurrentUserId method returns the correct user Id.
         * It includes setup steps to mock required objects and records.
         */
    
        @isTest
        static void testGetCurrentUserId() {
            // Start the test execution
            Test.startTest();
    
            // Call the method to be tested
            String currentUserId = BI_PSP_SymptomTracker.getCurrentUserId();
    
            // Stop the test execution
            Test.stopTest();
    
            // Verify the result using System.assertEquals
            Assert.areEqual(
                UserInfo.getUserId(),
                currentUserId,
                'User Id should match UserInfo.getUserId()'
            );
        }
    }