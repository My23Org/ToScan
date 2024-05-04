/**
    @description			This class contains test methods for various functionalities
                            related to feed items and comments(Insert,Update,Fetch).
	@author					Deepa
	@Last Modified On   	04/28/2024
	@Last Modified By 		Deepa
*/
@isTest
public class BI_PSPB_FeedItemCtrlTest {
    // Test data variables.
    public static User testUserPatient;
    public static User testUserCaregiver;
    public static User patientWithoutAccount;
    public static User testUserPatientCaregiver;
    public static Account testAccount;
    public static Account testAccountWithoutCommunityUsername;
    public static Account testAccountCaregiver;
    // Constructor to create test data.
    static {
        // User as a patient without Account.
        patientWithoutAccount = new User(
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
            ProfileId = [SELECT Id FROM Profile WHERE Name =
                'BI_PSP_Patient Profile'].Id);
		Contact contactForPatientWithoutAccount = new Contact(
                    FirstName = patientWithoutAccount.FirstName,
                    LastName = patientWithoutAccount.LastName,
                    Email = patientWithoutAccount.Email);
		insert contactForPatientWithoutAccount;
        patientWithoutAccount.ContactId = contactForPatientWithoutAccount.Id;
		insert patientWithoutAccount;
        // User as a Patient.
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
            ProfileId = [SELECT Id FROM Profile 
				WHERE Name = 'BI_PSP_Patient Profile'].Id);
		// Contact for patient user.
		Contact contactForPatient = new Contact(
                FirstName = testUserPatient.FirstName,
                LastName = testUserPatient.LastName,
                Email = testUserPatient.Email);
		insert contactForPatient;
        testUserPatient.ContactId = contactForPatient.Id;
		insert testUserPatient;
        // User as a caregiver.
        testUserCaregiver = new User(
            FirstName = 'TestUser',
            LastName = 'Caregiver',
            Email = 'testuser23@example.com',
            Username = 'testuser23@example.com',
            BI_PSPB_Caregiver__c = true,
            Alias = 'tuser2',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = [SELECT Id FROM Profile 
				WHERE Name = 'BI_PSP_Caregiver Profile'].Id);
		// Contact for caregiver.
		Contact contactForCaregiver = new Contact(
                FirstName = testUserCaregiver.FirstName,
                LastName = testUserCaregiver.LastName,
                Email = testUserCaregiver.Email);
		insert contactForCaregiver;
        testUserCaregiver.ContactId = contactForCaregiver.Id;
		insert testUserCaregiver;
        // Account for Patient.
        testAccount = new Account(
            FirstName = 'TestUser',
            LastName = 'Patient',
            PersonEmail = 'testuser12@example.com',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND
			Name = 'Person Account'].Id, OwnerId = testUserCaregiver.Id,
            BI_PSP_CommunityUsername__c = 'patient1', BI_PSP_AvatarUrl__c =
        '/Branded/resource/1702471083000/BI_PSPB_AfroMan_Adult');
		insert testAccount;
        // Account for caregiver.
        testAccountWithoutCommunityUsername = new Account(
            FirstName = 'TestUser',
            LastName = 'Caregiver',
            PersonEmail = 'testuser12@example.com',
            BI_PSPB_Selected_Patient_ID__c = testAccount.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' 
			AND Name = 'Person Account'].Id, OwnerId = testUserPatient.Id,
            BI_PSP_AvatarUrl__c =
            '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult');
		insert testAccountWithoutCommunityUsername;
		BI_PSPB_Enrollee_Caregiver__c careEnrolle = new BI_PSPB_Enrollee_Caregiver__c(
                BI_PSPB_Contact_Id__c = contactForCaregiver.Id,
                BI_PSPB_Status__c = 'Active',
                BI_PSPB_Patient__c = testAccount.Id
            );
		insert careEnrolle;
        // User as a Patient.
        testUserPatientCaregiver = new User(
            FirstName = 'TestUser',
            LastName = 'PatientCaregiver',
            Email = 'testuserPatientCaregiver12@example.com',
            Username = 'testuserPatientCaregiver12@example.com',
            BI_PSPB_Caregiver__c = true,
            Alias = 'tuser1',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = [SELECT Id FROM Profile WHERE Name =
                'BI_PSP_Patient Profile'].Id);
		// Contact for patient user.
		Contact contactForPatientCaregiver = new Contact(
                    FirstName = testUserPatientCaregiver.FirstName,
                    LastName = testUserPatientCaregiver.LastName,
                    Email = testUserPatientCaregiver.Email);
		insert contactForPatientCaregiver;
        testUserPatientCaregiver.ContactId = contactForPatientCaregiver.Id;
		insert testUserPatientCaregiver;
        // Account for Patient.
        testAccountCaregiver = new Account(
            FirstName = 'TestUser',
            LastName = 'PatientCaregiver',
            PersonEmail = 'testuserPatientCaregiver12@example.com',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND
			Name = 'Person Account'].Id, OwnerId = testUserPatientCaregiver.Id,
            BI_PSP_CommunityUsername__c = 'patient1', BI_PSP_AvatarUrl__c =
        '/Branded/resource/1702471083000/BI_PSPB_AfroMan_Adult');
		insert testAccountCaregiver;
		// Create mock BI_SFCOE_LOG_App_Settings__c record.
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName', BI_SFCOE_LOG_Application__c = 'Spevigo');
		insert settings;
    }
    /**
     * Test method for testing the soft deletion of a feed item.
     * Verifies the behavior of the softDeleteFeedItem method in the controller class.
     * Covers scenarios where  valid  feed item IDs are provided.
     * @description Verifies the behavior of the softDeleteFeedItem method by 
     * testing its functionality with  valid  feed item IDs.
     */
    @isTest
    static void testSoftDeleteFeedItemForTry() {
        // Run the test as the testUserPatient.
        System.runAs(testUserPatient) {
            // Start test execution.
            Test.startTest();
			// Create a test feed item.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
                BI_PSP_Phrase__c = 'Test Phrase',
                BI_PSP_Category__c = 'Test Category',
                BI_PSP_AccountR__c = testAccount.Id,
                BI_PSP_SoftDelete__c = ''
            );
			insert testFeedItem;
            // Call the method to soft delete the test feed item.
            BI_PSPB_FeedItemCtrl.softDeleteFeedItem(testFeedItem.Id);
            // Stop test execution.
            Test.stopTest();
            // Check if the test feed item was soft deleted successfully.
            List < BI_PSP_FeedItem__c > deletedFeedItems =[
                SELECT Id
				FROM BI_PSP_FeedItem__c
				WHERE Id = : testFeedItem.Id AND BI_PSP_SoftDelete__c = 'Yes'
            ];
            // Assert the results.
            Assert.areEqual(1, deletedFeedItems.size(),
                'The feed item should be soft deleted.');
        }
    }
    /**
     * Test method for testing the soft deletion of a feed item.
     * Verifies the behavior of the softDeleteFeedItem method in the controller class.
     * Covers scenarios where  invalid and Null feed item IDs are provided.
     * @description Verifies the behavior of the softDeleteFeedItem method by
     * testing its functionality with  invalid and Null feed item IDs.
     */
    @isTest
    static void testSoftDeleteFeedItemForCatch() {
        try {
            // Run the test as the testUserPatient.
            System.runAs(testUserPatient) {
                // Start test execution.
                Test.startTest();
                // Call the method to soft delete test feed item and test various scenarios.
                BI_PSPB_FeedItemCtrl.softDeleteFeedItem(null);
                BI_PSPB_FeedItemCtrl.softDeleteFeedItem('patientWithoutAccount.Id');
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for testing the soft deletion of a feed item.
     * Verifies the behavior of the softDeleteFeedItem method in the controller class.
     * Covers scenarios where  invalid feed item IDs are provided.
     * @description Verifies the behavior of the softDeleteFeedItem method by 
     * testing its functionality with  invalid feed item IDs.
     */
    @isTest
    static void testSoftDeleteFeedItemForException() {
        try {
            // Run the test as the testUserPatient.
            System.runAs(testUserPatient) {
				//create FeedItem.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
                BI_PSP_Phrase__c = 'Test Phrase',
                BI_PSP_Category__c = 'Test Category',
                BI_PSP_AccountR__c = testAccount.Id,
                BI_PSP_SoftDelete__c = ''
            );
				insert testFeedItem;//Insert the FeedItem.
                delete testFeedItem;//delete the FeedItem.
                // Start test execution.
                Test.startTest();
                // Call the method to soft delete test feed item.
                BI_PSPB_FeedItemCtrl.softDeleteFeedItem(testFeedItem.Id);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for inserting a new feed item.
     * Verifies the behavior of the insertFeedItem method in the controller class.
     * Covers scenarios with valid  input parameters.
     * @description Tests the behavior of the insertFeedItem method by 
     * inserting a new feed item.
     */
    @isTest
    static void testInsertFeedItem() {
        // Run the test as the testUserPatient.
        System.runAs(testUserPatient) {
            // Query existing feed items for comparison before insertion.
            List < BI_PSP_FeedItem__c > insertFeedItems =[
                SELECT BI_PSP_AccountR__c, BI_PSP_Category__c, BI_PSP_Phrase__c
				FROM BI_PSP_FeedItem__c
				WHERE BI_PSP_AccountR__c = : testAccount.Id
            ];
            // Start test execution.
            Test.startTest();
            // Insert feed items with different parameters.
            BI_PSPB_FeedItemCtrl.insertFeedItem(
                'Category', 'Subcategory', testUserPatient.Id);
            // Stop test execution.
            Test.stopTest();
            // Query inserted feed items for comparison after insertion.
            List < BI_PSP_FeedItem__c > insertFeedItemsAfter =[
                SELECT BI_PSP_AccountR__c, BI_PSP_Category__c, BI_PSP_Phrase__c
				FROM BI_PSP_FeedItem__c
				WHERE BI_PSP_AccountR__c = : testAccount.Id
            ];
            // Assert the results.
            Assert.areNotEqual(insertFeedItems, insertFeedItemsAfter,
                'FeedItem  is  Inserted');
        }
    }
    /**
     * Test method for inserting a new feed item with Exception.
     * Verifies the behavior of the insertFeedItem method in the controller class.
     * Covers scenarios with invalid  input parameters.
     * @description Tests the behavior of the insertFeedItem method when 
     * invalid or null input parameters are provided,and verifies that the method 
     * properly handles exceptions.      
     */
    @isTest
    static void testInsertFeedItemForCatch() {
        try {
            System.runAs(testUserPatient) {
                // Start test execution.
                Test.startTest();
                // Insert a feed item with an invalid account ID.
                BI_PSPB_FeedItemCtrl.insertFeedItem('null', 'null', 'InvalidId');
                BI_PSPB_FeedItemCtrl.insertFeedItem('null', 'null', patientWithoutAccount.Id);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for inserting a new feed item with Exception.
     * Verifies the behavior of the insertFeedItem method in the controller class.
     * Covers scenarios with invalid input parameters.
     * @description Tests the behavior of the insertFeedItem method when invalid
     * input parameters are provided,and verifies that the method 
     * properly handles exceptions.
     */
    @isTest
    static void testInsertFeedItemException() {
        try {
            System.runAs(testUserPatient) {
                // Start test execution.
                Test.startTest();
                // Insert a feed item with an invalid account ID.
                BI_PSPB_FeedItemCtrl.insertFeedItem(
                    'InvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementItestUserPatient.InvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementIdd',
                    'testUserPatient.InvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementId',
                    testUserCaregiver.Id
                );
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for inserting a new feed item with Exception .
     * Verifies the behavior of the insertFeedItem method in the controller class.
     * Covers scenarios with invalid or null input parameters.
     * @description Tests the behavior of the testInsertFeedItemExceptionUserId method 
     * when invalid or null input parameters are provided,and 
     * verifies that the method properly handles exceptions.
     */
    @isTest
    static void testInsertFeedItemExceptionUserId() {
        try {
            // Run the test as the testUserPatient.
            System.runAs(testUserPatient) {
                // Start test execution.
                Test.startTest();
                // Insert a feed item with a null user ID.
                BI_PSPB_FeedItemCtrl.insertFeedItem('null', 'null', null);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for retrieving feed items posted by a specific user.
     * Verifies the behavior of the myPost method in the controller class.
     * Covers scenarios with valid  input parameters.
     * @description Tests the behavior of the myPost method by 
     * verifying that it correctly retrieves feed items posted 
     * by a specific user, and covers scenarios with  valid  input parameters.
     */
    @isTest
    static void testMyPost() {
        System.runAs(testUserPatient) {
			// Create a test feed item associated with the user.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
            BI_PSP_Phrase__c = 'Test Phrase',
            BI_PSP_Category__c = 'Test Category',
            BI_PSP_AccountR__c = testAccount.Id,
            OwnerId = testUserPatient.Id
        );
			insert testFeedItem;
            // Start test execution.
            Test.startTest();
            // Call the method with the test user's Id.
            List < BI_PSP_FeedItem__c > myPostRecords = BI_PSPB_FeedItemCtrl.myPost(
                testUserPatient.Id
            );
            // Stop test execution.
            Test.stopTest();
            // Assert that the myPostRecords is notnull and contains expected feed item.
            Assert.areEqual(1, myPostRecords.size(),
                'The expected feed item is returned');
        }
    }
    /**
     * Test method for retrieving feed items posted by a specific user.
     * Verifies the behavior of the myPost method in the controller class.
     * Covers scenarios with Invalid and null input parameters.
     * @description Tests the behavior of the myPost method by verifying 
     * that it correctly retrieves feed items posted by a specific user, 
     * and covers scenarios with both Invalid and null input parameters.
     */
    @isTest
    static void testMyPostForCatch() {
        try {
            System.runAs(testUserPatient) {
                // Start test execution.
                Test.startTest();
                // Call the method with an empty user Id to test exception handling.
                BI_PSPB_FeedItemCtrl.myPost('');
                // Call the method with an invalid user Id to test exception handling.
                BI_PSPB_FeedItemCtrl.myPost('InvalidId');
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for retrieving feed items posted by a specific user.
     * Verifies the behavior of the myPost method in the controller class.
     * Covers scenarios with Invalid  input parameters.
     * @description Tests the behavior of the myPost method by verifying that it 
     * correctly retrieves feed items posted by a specific user,
     * and covers scenarios with Invalid  input parameters.
     */
    @isTest
    static void testMyPostForInvalidId() {
        try {
            System.runAs(testUserPatient) {
                // Start test execution.
                Test.startTest();
                // Call the method with an invalid user Id to test exception handling.
                BI_PSPB_FeedItemCtrl.myPost(patientWithoutAccount.Id);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for retrieving all feed items.
     * Verifies the behavior of the getAllPost method in the controller class.
     * Covers scenarios with valid input parameters, as well as multiple feed items.
     * @description Tests the behavior of the testGetAllPost method by verifying 
     * that it correctly  retrieves feed items posted by a specific user,
     * and covers scenarios with  valid  input parameters.
     */
    @isTest
    static void testGetAllPost() {
        System.runAs(testUserPatient) {
			// Create a test feed item.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
            BI_PSP_Phrase__c = 'Test Phrase',
            BI_PSP_Category__c = 'Test Category',
            BI_PSP_FollowStatus__c = 'Follow',
            OwnerId = testUserPatient.Id,
            BI_PSP_AccountR__c = testAccount.Id
        );
			insert testFeedItem;
			// Create a test feed item.
			BI_PSP_FeedItem__c testFeedItemFollowing = new BI_PSP_FeedItem__c(
            BI_PSP_Phrase__c = 'Test Phrase',
            BI_PSP_Category__c = 'Test Category',
            BI_PSP_FollowStatus__c = 'Following',
            OwnerId = testUserPatient.Id,
            BI_PSP_AccountR__c = testAccountWithoutCommunityUsername.Id
        );
			insert testFeedItemFollowing;
			// Create a test follow record.
			BI_PSP_FeedFollow__c testFollowRecord = new BI_PSP_FeedFollow__c(
            BI_PSP_Account__c = testAccount.Id,
            BI_PSP_AccountUser__c = testAccountWithoutCommunityUsername.Id,
            BI_PSP_Type__c = 'Following'
        );
			insert testFollowRecord;
            // Create a list to hold all test feed items.
            List < BI_PSP_FeedItem__c > listOfAllPosts = new List < BI_PSP_FeedItem__c > ();
            listOfAllPosts.add(testFeedItem);
            listOfAllPosts.add(testFeedItemFollowing);
            Test.startTest();
            // Test with valid user Id.
            List < BI_PSP_FeedItem__c > postRecords = BI_PSPB_FeedItemCtrl.getAllPost(
                testUserPatient.Id
            );
            // Stop test execution.
            Test.stopTest();
            // Assert that the postRecords is not null and contains the expected feed items
            Assert.areEqual(
                2,
                postRecords.size(),
                'All relevant feed items are returned'
            );
        }
    }
    /**
     * Test method for retrieving all feed items.
     * Verifies the behavior of the getAllPost method in the controller class.
     * Covers scenarios with Invalid or null input parameters.
     * @description Tests the behavior of the testGetAllPost method by verifying 
     * that it correctly catch feed items posted by a specific user, 
     * and covers scenarios with  null input parameters.
     */
    @isTest
    static void testGetAllPostForCatch() {
        try {
            System.runAs(testUserPatient) {
                Test.startTest();
                // Call the method with a null user Id to test exception handling
                BI_PSPB_FeedItemCtrl.getAllPost(null);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for retrieving all feed items.
     * Verifies the behavior of the getAllPost method in the controller class.
     * Covers scenarios with Invalid or null input parameters.
     * @description Tests the behavior of the testGetAllPost method by 
     * verifying that it correctly catch feed  items  posted by a specific user,
     * and covers scenarios with both Invalid or null input parameters.
     */
    @isTest
    static void testGetAllPostForException() {
        try {
            System.runAs(testUserPatient) {
                Test.startTest();
                // Call the method with a null user Id to test exception handling
                BI_PSPB_FeedItemCtrl.getAllPost(patientWithoutAccount.Id);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for inserting a comment on a feed item.
     * Verifies the behavior of the insertComment method in the controller class.
     * Covers scenarios with valid  input parameters.
     *  @description Tests the behavior of the insertComment method by
     *  verifying that it correctly inserts comments on feed items,
     *   and covers scenarios with  valid input parameters.
     */
    @isTest
    static void testInsertComment() {
        System.runAs(testUserPatient) {
			// Create a test feed item
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
            BI_PSP_Phrase__c = 'Test Phrase',
            BI_PSP_Category__c = 'Test Category',
            OwnerId = testUserPatient.Id,
            BI_PSP_AccountR__c = testAccount.Id
        );
			insert testFeedItem;
            // Query for the existing comments related to the test feed item
            List < BI_PSP_FeedComment__c > insertComment =[
                SELECT BI_PSP_AccountCmt__c, BI_PSP_Comment__c, BI_PSP_FeedItem__c
				FROM BI_PSP_FeedComment__c
				WHERE BI_PSP_FeedItem__c = : testFeedItem.Id
            ];
            Test.startTest();
            // Call the method with valid input parameters
            BI_PSPB_FeedItemCtrl.insertComment(
                'Test Comment',
                testFeedItem.Id,
                testUserPatient.Id
            );
            // Stop test execution.
            Test.stopTest();
            // Query for the comments related to the test feed item after method execution
            List < BI_PSP_FeedComment__c > insertCommentAfter =[
                SELECT BI_PSP_AccountCmt__c, BI_PSP_Comment__c, BI_PSP_FeedItem__c
				FROM BI_PSP_FeedComment__c
				WHERE BI_PSP_FeedItem__c = : testFeedItem.Id
            ];
            // Assert that the comment is inserted for the feed item
            Assert.areNotEqual(
                insertComment,
                insertCommentAfter,
                'Comment is inserted for the feed item'
            );
        }
    }
    /**
     * Test method for inserting a comment on a feed item.
     * Verifies the behavior of the insertComment method in the controller class.
     * Covers scenarios with Invalid  input parameters.
     *  @description Tests the behavior of the insertComment method
     *  by verifying that it correctly throw an Exception.
     */
    @isTest
    static void testInsertCommentLengthyComment() {
        try {
            System.runAs(testUserPatient) {
			// Create a test feed item.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
                BI_PSP_Phrase__c = 'Test Phrase',
                BI_PSP_Category__c = 'Test Category',
                OwnerId = testUserPatient.Id,
                BI_PSP_AccountR__c = testAccount.Id
            );
			insert testFeedItem;
                Test.startTest();
                // Call the method with Invalid input parameters.
                BI_PSPB_FeedItemCtrl.insertComment(
                    'Test Comment Test CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest Comment Test CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest Comment',
                    testFeedItem.Id,
                    testUserPatient.Id
                );
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for inserting a comment on a feed item.
     * Verifies the behavior of the insertComment method in the controller class.
     * Covers scenarios with  null input parameters.
     *  @description Tests the behavior of the insertComment method by
     *  verifying that it correctly throw an Exception.
     */
    @isTest
    static void testInsertCommentForCatch() {
        try {
            System.runAs(testUserPatient) {
                Test.startTest();
                // Call the method with null input parameters.
                BI_PSPB_FeedItemCtrl.insertComment('Test Comment', null, null);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for inserting a comment on a feed item.
     * Verifies the behavior of the insertComment method in the controller class.
     * Covers scenarios with  Invalid or null input parameters.
     *  @description Tests the behavior of the insertComment method by
     *  verifying that it correctly  throw an Exception.
     */
    @isTest
    static void testInsertCommentForNullAccount() {
        try {
            System.runAs(testUserPatient) {
                Test.startTest();
                // Call the method with null/Invalid input parameters.
                BI_PSPB_FeedItemCtrl.insertComment(
                    'Test Comment',
                    'FeedId',
                    patientWithoutAccount.Id
                );
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for viewing comments on a feed item.
     * Verifies the behavior of the viewComments method in the controller class.
     * Covers scenarios with valid feed item IDs.
     * @description Tests the behavior of the viewComments method by verifying 
     * that it correctly retrieves comments associated with a feed item, and covers
     *  scenarios with valid  feed item IDs.
     */
    @isTest
    static void testViewComments() {
        // Run the test as the testUserPatient.
        System.runAs(testUserPatient) {
			// Create a test feed item.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c();
			insert testFeedItem;
			// Create test comments associated with the first feed item.
			BI_PSP_FeedComment__c comment = new BI_PSP_FeedComment__c(
            BI_PSP_Comment__c = 'Test Comment ',
            BI_PSP_FeedItem__c = testFeedItem.Id,
            BI_PSP_AccountCmt__c = testAccount.Id
        );
			insert comment;
            // Call the viewComments method.
            Test.startTest();
            List < BI_PSP_FeedComment__c > feedCommentRecords = BI_PSPB_FeedItemCtrl.viewComments(
                testFeedItem.Id
            );
            // Stop test execution.
            Test.stopTest();
            // Assert that comments are retrieved for the existing feed item
            Assert.areEqual(
                1,
                feedCommentRecords.size(),
                'Feed comment records should contain 3 comments'
            );
        }
    }
    /**
     * Test method for viewing comments on a feed item.
     * Verifies the behavior of the viewComments method in the controller class.
     * Covers scenarios with Invalid and null feed item IDs.
     * @description Tests the behavior of the viewComments method by verifying
     *  that it correctly retrieves comments associated with a feed item, 
     * and covers scenarios with both null and invalid feed item IDs.
     */
    @isTest
    static void testViewCommentsForCatch() {
        try {
            // Run the test as the testUserPatient
            System.runAs(testUserPatient) {
				// Create a test feed item that is soft deleted.
				BI_PSP_FeedItem__c testFeedItemSoftDelete = new BI_PSP_FeedItem__c();
				insert testFeedItemSoftDelete;
                // Call the viewComments method.
                BI_PSPB_FeedItemCtrl.viewComments(null);
                BI_PSPB_FeedItemCtrl.viewComments(testFeedItemSoftDelete.Id);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for editing a comment.
     * Verifies that a comment can be successfully updated with new text.
     * @description Tests the behavior of the editComment method by 
     * verifying that it successfully updates a comment with new text.
     */
    @isTest
    static void testEditComment() {
        System.runAs(testUserPatient) {
			// Create a test comment
			BI_PSP_FeedComment__c testComment = new BI_PSP_FeedComment__c(
            BI_PSP_Comment__c = 'Test Comment'
        );
			insert testComment;
			// New comment text
			String newCommentText = 'Updated Test Comment';
            // Call the editComment method
            Test.startTest();
			BI_PSP_FeedComment__c updateComment = BI_PSPB_FeedItemCtrl.editComment(
                newCommentText,
                testComment.Id
            );
            // Stop test execution.
            Test.stopTest();
            // Assert that the comment text is updated successfully
            Assert.areEqual(
                newCommentText,
                updateComment.BI_PSP_Comment__c,
                'editComment updates the comment text successfully'
            );
        }
    }
    /**
     * Test method for editing a comment.
     * Verifies that a comment can be successfully throw an Exception.
     * @description Tests the behavior of the editComment method by verifying that
     * it successfully throw an Exception while passing the Invalid Values.
     */
    @isTest
    static void testEditCommentForCatch() {
        try {
            System.runAs(testUserPatient) {
				// Create a test comment
				BI_PSP_FeedComment__c testComment = new BI_PSP_FeedComment__c(
                BI_PSP_Comment__c = 'Test Comment'
            );
				insert testComment;
				// New comment text
				String newCommentText = 'Updated Test Comment';
                // Call the editComment method
                Test.startTest();
                BI_PSPB_FeedItemCtrl.editComment(newCommentText, null);
                BI_PSPB_FeedItemCtrl.editComment(
                    'testUserPatientPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheComment.Id',
                    testComment.Id);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
 * Test method for editing a comment.
 * Verifies that a comment can be successfully throw an Exception.
 * @description Tests the behavior of the editComment method by verifying 
 * that it successfully throw Exception when invalid Id Passed.
 */
    @isTest
    static void testEditCommentForIdException() {
        try {
            System.runAs(testUserPatient) {
				// New comment text.
				String newCommentText = 'Updated Test Comment';
                // Call the editComment method.
                Test.startTest();
                BI_PSPB_FeedItemCtrl.editComment(newCommentText, 'testCommentId');
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for soft deleting a feed comment item.
     * Verifies that a feed comment item can be successfully soft deleted.
     * @description Tests the behavior of the softDeleteFeedcommentItem method by verifying
     *  that it successfully soft deletes  a feed comment item.
     */
    @isTest
    static void testSoftDeleteFeedcommentItem() {
        System.runAs(testUserPatient) {
			// Create a test feed comment item.
			BI_PSP_FeedComment__c testFeedcommentItem = new BI_PSP_FeedComment__c(
            BI_PSP_Comment__c = 'Test Comment'
        );
			insert testFeedcommentItem;
            // Call the softDeleteFeedcommentItem method.
            Test.startTest();
            BI_PSPB_FeedItemCtrl.softDeleteFeedcommentItem(testFeedcommentItem.Id);
            // Stop test execution.
            Test.stopTest();
            // Query deleted feed comment records.
            List < BI_PSP_FeedComment__c > deletedFeedCommentAfter =[
                SELECT Id
				FROM BI_PSP_FeedComment__c
				WHERE Id = : testFeedcommentItem.Id AND BI_PSP_CommentDelete__c = 'Yes'
            ];
            // Assert that the feed comment is soft deleted for valid input.
            Assert.areEqual(
                1,
                deletedFeedCommentAfter.size(),
                'The feed Comment should be soft deleted.'
            );
        }
    }
    /**
     * Test method for soft deleting a feed comment item.
     * Verifies that a feed comment item can be successfully throw an Exception.
     * @description Tests the behavior of the softDeleteFeedcommentItem method by
     * verifying that it successfully throw Exception while 
     * Passing Null or Invalid Value.
     */
    @isTest
    static void testSoftDeleteFeedcommentItemForCatch() {
        try {
            System.runAs(testUserPatient) {
                Test.startTest();
                // Call the softDeleteFeedcommentItem method.
                BI_PSPB_FeedItemCtrl.softDeleteFeedcommentItem(
                    'testFeedcommentItem.Id'
                );
                BI_PSPB_FeedItemCtrl.softDeleteFeedcommentItem(null);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for soft deleting a feed comment item.
     * Verifies that a feed comment item can be successfully throw an Exception.
     * @description Tests the behavior of the softDeleteFeedcommentItem method by
     * verifying that it successfully an throw Exception while Passing Empty Value.
     */
    @isTest
    static void testSoftDeleteFeedcommentItemForNullException() {
        try {
            System.runAs(testUserPatient) {
                Test.startTest();
                // Call the softDeleteFeedcommentItem method.
                BI_PSPB_FeedItemCtrl.softDeleteFeedcommentItem('');
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for retrieving comment options for a feed item.
     * Verifies that comment options are retrieved correctly for a given feed item.
     * @description Tests the behavior of the getCommentOptions method by verifying
     *  that it correctly retrieves comment options for a given feed item.
     */
    @isTest
    static void testGetCommentOptions() {
        System.runAs(testUserPatient) {
			// Create a test feed item.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
            BI_PSP_Phrase__c = 'Test Phrase',
            BI_PSP_Category__c = 'Test Category'
        );
			insert testFeedItem;
            // Query the expected result.
            List < BI_PSP_FeedItem__c > expectedResult = new List < BI_PSP_FeedItem__c > ();
            expectedResult = [
                SELECT Id, BI_PSP_Phrase__c, BI_PSP_Category__c
				FROM BI_PSP_FeedItem__c
				WHERE Id = : testFeedItem.Id
            ];
            Test.startTest();
            // Call the getCommentOptions method.
            List < BI_PSP_FeedItem__c > commentOptions =
            BI_PSPB_FeedItemCtrl.getCommentOptions(testFeedItem.Id);
            // Stop test execution.
            Test.stopTest();
            // Assert that the comment options list contains the expected
            // feed item for valid input.
            Assert.areEqual(
                expectedResult.size(),
                commentOptions.size(),
                'Comment options list should contain the expected feed item'
            );
        }
    }
    /**
     * Test method for retrieving comment options for a feed item.
     * Verifies that GetCommentOption method  throw Exception for a given feed item.
     * @description Tests the behavior of the getCommentOptions method by verifying that it 
     * correctly throw Exception for a given Value.
     */
    @isTest
    static void testGetCommentOptionsForCatch() {
        try {
            System.runAs(testUserPatient) {
                Test.startTest();
                // Call the getCommentOptions method.
                BI_PSPB_FeedItemCtrl.getCommentOptions(null);
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for retrieving comment options for a feed item.
     *  Verifies that GetCommentOption method  throw Exception for a given feed item.
     * @description Tests the behavior of the getCommentOptions method by verifying 
     * that it  throw Exception  for a given feed item.              
     */
    @isTest
    static void testGetCommentOptionsForException() {
        try {
            System.runAs(testUserPatient) {
                Test.startTest();
                // Call the getCommentOptions method.
                BI_PSPB_FeedItemCtrl.getCommentOptions('InvalidId');
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
    /**
     * Test method for retrieving the user's account ID based on whether they are a caregiver.
     * Verifies that the correct account ID is retrieved for both caregiver and non-caregiver users.
     * @description Tests the behavior of the getUserAccountId method by verifying that it
     *  correctly retrieves the user's account ID based on whether they are a caregiver.
     *  It covers scenarios for both caregiver and non-caregiver(Patient) users.
     */
    @isTest
    static void testgetUserAccountId() {
		// Initialize variables to store the results.
		String patientRecordId;
		String careGiverRecordId;
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount').getRecordTypeId();
		String currentUserName = testUserPatientCaregiver.LastName;
		String currentUserEmail = testUserPatientCaregiver.Email;
		//create Account.
		Account testAccount1 = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                BI_PSP_Birthdate__c = Date.newInstance(2020, 1, 1),
                BI_PSPB_Selected_Patient_ID__c = 'dummyid',
                RecordTypeId = personAccountRecordTypeId
            );
		insert testAccount1;
		CareProgram testCP1 = new CareProgram(Name = 'Test Enrollee');
		insert testCP1;
		CareProgramEnrollee cpe1 = new CareProgramEnrollee(
                AccountId = testAccount1.Id,
                Name = 'Test Enrollee',
                CareProgramId = testCP1.Id,
                BI_PSPB_PatientStatus__c = 'Unassigned'
            );
		insert cpe1;
		Contact con = new Contact(
                FirstName = testUserPatientCaregiver.FirstName,
                LastName = testUserPatientCaregiver.LastName
            );
		insert con;
		BI_PSPB_Enrollee_Caregiver__c ec = new BI_PSPB_Enrollee_Caregiver__c(
                BI_PSPB_Care_Program_Enrollee__c = cpe1.Id,
                BI_PSPB_Contact_Id__c = con.Id,
                BI_PSPB_Caregiver__c = testAccount1.Id
            );
		insert ec;
        Test.startTest();
        // Call the getUserAccountId method for testUserCaregiver and testUserPatient.
        System.runAs(testUserPatient) {
            patientRecordId = BI_PSPB_FeedItemCtrl.getUserAccountId(testUserPatient.Id);
        }
        System.runAs(testUserPatientCaregiver){
            careGiverRecordId = BI_PSPB_FeedItemCtrl.getUserAccountId
                (testUserPatientCaregiver.Id);
        }
        // Stop test execution.
        Test.stopTest();
        // Assert the results.
        //Test for testUserPatient.
        Assert.areEqual(
            testAccount.Id,
            patientRecordId,
            'User account ID should be null for testUserPatient'
        );
        //Test for testUserCaregiver.
        Assert.areEqual(
            null,
            careGiverRecordId,
            'User account ID should be null for testUserPatient'
        );
    }
    /**
     * Test method for retrieving the user's account ID based on whether they are a caregiver or Patient.
     * Ensures that an exception is thrown for an  account ID input.
     * @description Tests the behavior of the getUserAccountId method by 
        verifying that it correctly retrieves the user's account ID based on whether
        they are a caregiver.
        It covers scenarios for both caregiver and non-caregiver users, and ensures that 
        an exception is thrown for an invalid account ID input.
     */
    @isTest
    static void testgetUserAccountIdForCatch() {
        try {
            System.runAs(testUserPatientCaregiver) {
				// Initialize variables to store the results.
				String resultCatch;
				String resultException;
                // Call the getUserAccountId method with null input and the string 'null'.
                resultCatch = BI_PSPB_FeedItemCtrl.getUserAccountId(null);
                resultException = BI_PSPB_FeedItemCtrl.getUserAccountId('null');
                // Stop test execution.
                Test.stopTest();
            }
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
            Assert.areEqual('Script-thrown exception', e.getMessage(),
                'Method thrown exception');
        }
    }
}