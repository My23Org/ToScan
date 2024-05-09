/*@description -- This test class ensures scheduled daily generation and insertion of dates for CRM Analytics, covering nullable field insertion, job scheduling accuracy, bulk record handling, and database error validation.*/
@isTest
public class BI_PSPB_dateTimeTest {
    public static User testUser;
        public static Contact contactForPatient;
        static {
		//Create the test user
		testUser = new User(
			FirstName = 'Test',
			LastName = 'Account',
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
    /* @description This test class method verifying successful insertion of records with a nullable field, ensuring proper handling of null values.*/
@isTest
static void testInsertWithNullableField() {
    System.runAs(testUser){
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'ApplicationName',
        BI_SFCOE_LOG_Application__c = 'Spevigo'
    );
    insert settings;
    Datetime currentDateTime = System.now();
    Date currentDate = currentDateTime.date();
    BI_PSPB_DateTimeMention__c newObj = new BI_PSPB_DateTimeMention__c();
    newObj.Name = String.valueOf(currentDate);
    newObj.BI_PSPB_Date__c = null; // Intentionally null
    Test.startTest();
    insert newObj; // This should succeed
    Test.stopTest();
    // Assert to verify the object was inserted
    BI_PSPB_DateTimeMention__c inserted = [SELECT Id FROM BI_PSPB_DateTimeMention__c WHERE Id = :newObj.Id];
    Assert.arenotequal(null, inserted, 'Object should be successfully inserted with a null BI_PSPB_Date__c');
    }
}
    /*  @description This test method ensuring successful scheduling and execution of a job at a specified time, verifying cron expression accuracy and execution count.*/
    @isTest
    static void testExecuteMethodScheduleJobSuccessfully() {
        System.runAs(testUser){
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        Date currentDate=Date.valueOf('2024-2-28');
        BI_PSPB_DateTimeMention__c newObj = new BI_PSPB_DateTimeMention__c();
            newObj.Name = string.valueof(currentDate);
            newObj.BI_PSPB_Date__c = currentDate;
        //insert newObj;
        BI_PSPB_dateTime schedulable = new BI_PSPB_dateTime();

        Test.startTest();
        // Schedule the job to run immediately
        String jobId = System.schedule('BI_PSPB_dateTime', '0 0 0 * * ?', schedulable);
        Test.stopTest();

        // Ensure job is scheduled
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                                    FROM CronTrigger 
                                    WHERE Id = :jobId];
        //Assert.areEqual(null, cronTrigger, 'Scheduled job should exist');
        Assert.areEqual('0 0 0 * * ?', cronTrigger.CronExpression, 'Cron expression does not match');
        Assert.areEqual(0, cronTrigger.TimesTriggered, 'Job has not been executed');
    }
    } 
    /* @description This test class method validating successful execution of a scheduled job, verifying proper scheduling and execution parameters.*/
@isTest
static void forCatch() {
    System.runAs(testUser){
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'ApplicationName',
        BI_SFCOE_LOG_Application__c = 'Spevigo'
    );
    insert settings;
    // Create a list to hold the records
    List<BI_PSPB_DateTimeMention__c> recordsToInsert = new List<BI_PSPB_DateTimeMention__c>();

    // Insert more than 150 records
    Integer numberOfRecords = 200; // Change this value to insert the desired number of records
    for (Integer i = 0; i < numberOfRecords; i++) {
        Date currentDate = Date.valueOf('2024-02-28').addDays(i); // Increment date for each record
        BI_PSPB_DateTimeMention__c newObj = new BI_PSPB_DateTimeMention__c(
            Name = String.valueOf(currentDate),
            BI_PSPB_Date__c = currentDate
        );
        recordsToInsert.add(newObj);
    }
    // Insert the records
    if(!recordsToInsert.isEmpty())
    {
    insert recordsToInsert;
    }
    // Schedule the job
    BI_PSPB_dateTime schedulable = new BI_PSPB_dateTime();
    Test.startTest();
    String jobId = System.schedule('BI_PSPB_dateTime', '0 0 0 * * ?', schedulable);
    Test.stopTest();

    // Ensure job is scheduled
    CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                                FROM CronTrigger 
                                WHERE Id = :jobId];
    Assert.areEqual('0 0 0 * * ?', cronTrigger.CronExpression, 'Cron expression does not match');
    Assert.areEqual(0, cronTrigger.TimesTriggered, 'Job has not been executed');
}
} 
    /*  @description This test class inserts invalid data to trigger exceptions, validating error handling functionality, crucial for maintaining database integrity in the application.*/
    @isTest
static void testDatabaseErrorHandling() {
    System.runAs(testUser){
    // Setup test data or configurations if necessary
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'Test Settings',
        BI_SFCOE_LOG_Application__c = 'Test App'
    );
    insert settings;
    // Setup to cause a DML exception, e.g., by violating a required field or constraint
    List<BI_PSPB_DateTimeMention__c> recordsToInsert = new List<BI_PSPB_DateTimeMention__c>();
    for (Integer i = 0; i < 5; i++) {
        recordsToInsert.add(new BI_PSPB_DateTimeMention__c(
            Name = null, // Assuming Name cannot be null based on validation rule
            BI_PSPB_Date__c = null
        ));
    }
    Test.startTest();
    try {
        insert recordsToInsert;
    } catch (Exception e) {
       assert.areEqual('null',e.getMessage(),'cannot insert');
    }
    Test.stopTest();
}
    // Assertions here to verify behavior such as checking log records, email sent, error messages recorded, etc.
}
}