/**
@description    Test class for the BI_PSPB_symptomTrackerTasksCtrl class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_symptomTrackerTasksCtrlTest {
public static User testUser;
	public static Contact contactForPatient;
	static {
		//Create the test user
		testUser = new User(
			FirstName = 'Test',
			LastName = 'Patient',
			Email = 'testuser12@example.com',
			UserName = 'testuser12@example.com',
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
		// Contact for patient user
		contactForPatient = new Contact(
			FirstName = testUser.FirstName,
			LastName = testUser.LastName,
			Email = testUser.Email
		);
		insert contactForPatient;
		testUser.ContactId = contactForPatient.Id;
		insert testUser;
	}
       /**
* @description Test method to verify the behavior of markTaskRead method.
*/
    @isTest 
    static void testMarkTaskRead() {
        try{
        System.runAs(testUser) {
			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			// Retrieve the created record type Id
        // Create a test Task
        Task testTask = new Task(
            Subject = 'Test Task',
            Status = 'Not Started'
        );
        insert testTask;

        // Call the method
        Test.startTest();
        List<Task> updatedTasks = BI_PSPB_symptomTrackerTasksCtrl.markTaskRead(testTask.Id);
        Test.stopTest();

        // Verify that the task was updated
        Task updatedTask = [SELECT Id, Status FROM Task WHERE Id = :updatedTasks[0].Id];
        Assert.areequal('Read', updatedTask.Status, 'Task should have been marked as Read');
    }
        } 
        catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }
      /**
* @description Test method to verify the behavior of markTaskCompleted method.
*/
    @isTest static void testMarkTaskCompleted() {
        try{
             System.runAs(testUser){
        Task testTask = new Task(
            Subject = 'Test Task',
            Status = 'Not Started',
            BI_PSP_Category__c = 'Symptom Tracker'
        );
        insert testTask;

        // Call the method
        Test.startTest();
        List<Task> updatedTasks = BI_PSPB_symptomTrackerTasksCtrl.markTaskCompleted(testTask.Id);
        Test.stopTest();

        // Verify that the task was updated
        Task updatedTask = [SELECT Id, Status FROM Task WHERE Id = :updatedTasks[0].Id];
        Assert.areequal('Completed', updatedTask.Status, 'Task should have been marked as Completed');
        }
        }
        // Create a test Task
        catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        
    }
      /**
* @description Test method to verify the behavior of markTaskCompleted method.
*/
        @isTest static void testMarkTaskCompletedNegative() {
            try{
        // Create a test Task
        System.runAs(testUser){
        Task testTask = new Task(
            Subject = 'Test Task',
            Status = 'Not Started',
            BI_PSP_Category__c = 'Symptom Tracker'
        );
        insert testTask;

        // Call the method
        Test.startTest();
        List<Task> updatedTasks = BI_PSPB_symptomTrackerTasksCtrl.markTaskCompleted(null);
        Test.stopTest();

        // Verify that the task was updated
        Task updatedTask = [SELECT Id, Status FROM Task WHERE Id = :updatedTasks[0].Id];
        Assert.areequal('Completed', updatedTask.Status, 'Task should have been marked as Completed');
        }
            }
            catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        
    }
      /**
* @description Test method to verify the behavior of markTaskRead method.
*/
    @isTest
    static void testFailureCase() {
        try{
        // Prepare test data with null values to trigger the exception
        System.runAs(testUser){
        Id accountId = null;

        // Call the method
        Test.startTest();
            BI_PSPB_symptomTrackerTasksCtrl.markTaskRead(accountId);
        Test.stopTest();
    }
        }
        catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }
      /**
* @description Test method to verify the behavior of markTaskCompleted method.
*/
    @isTest
    static void testFailureCompleteCase() {
        try{
        // Prepare test data with null values to trigger the exception
       System.runAs(testUser){
        Id accountId = null;

        // Call the method
        Test.startTest();
            BI_PSPB_symptomTrackerTasksCtrl.markTaskCompleted(accountId);
        Test.stopTest();
       } }
        catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }
}