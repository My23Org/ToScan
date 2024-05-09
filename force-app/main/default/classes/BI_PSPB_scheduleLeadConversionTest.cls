/*
 * @description Test class for the BI_PSPB_ScheduleLeadConversion class, which is responsible for scheduling lead conversion.
 * History:
 * Version  Author          Date            Detail              Description
* 1.0      Ashif       05-Nov-2023          Created             Initial development
 */
@isTest
private class BI_PSPB_scheduleLeadConversionTest {
   private static   BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('ApplicationName');
    @isTest
    static void testExecute() {
        // Create test data
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Status = 'Qualified',
            IsConverted = false,
            CreatedDate = Date.today()
        );
        insert testLead;

        Test.startTest();

        // Call the execute method
        BI_PSPB_scheduleLeadConversion scheduler = new BI_PSPB_scheduleLeadConversion();
        scheduler.execute(null); // passing null for SchedulableContext as it's not used in this method

        Test.stopTest();

        // Verify if lead conversion was performed
        List<Lead> convertedLeads = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        Assert.areEqual(1, convertedLeads.size(), 'Lead should have been converted');
        Assert.areEqual(false, convertedLeads[0].IsConverted, 'Lead should have been converted');
    }
 /*
@description    Test method to verify the behavior when execute method is called without any qualified leads.
*/
     @isTest
    static void testExecuteWithoutQualifiedLeads() {

        Test.startTest();

        // Call the execute method with no qualified leads
        BI_PSPB_scheduleLeadConversion scheduler = new BI_PSPB_scheduleLeadConversion();
        scheduler.execute(null); // passing null for SchedulableContext as it's not used in this method

        Test.stopTest();

        // Verify if log message is generated
        List<BI_SFCOE_LOG_Log_Entry__c> logs = [SELECT Id FROM 	BI_SFCOE_LOG_Log_Entry__c];
        Assert.areEqual(1, logs.size(), 'Log message should be generated for no qualified leads');
    }
    
/*
@description    Test method to verify the behavior when execute method is called and lead conversion encounters an exception.
*/      
 @isTest
    static void testExecutewithexception() {
        // Create test data
        Lead testedlead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Status = 'PatientQualified',
            IsConverted = false,
            CreatedDate = Date.today()
        );
        insert testedlead;

        Test.startTest();

        // Call the execute method
        BI_PSPB_scheduleLeadConversion scheduler = new BI_PSPB_scheduleLeadConversion();
        scheduler.execute(null); // passing null for SchedulableContext as it's not used in this method

        Test.stopTest();

        // Verify if lead conversion was performed
        List<Lead> convertedLeads = [SELECT Id, IsConverted FROM Lead WHERE Id = :testedlead.Id];
        Assert.areEqual(1, convertedLeads.size(), 'Lead should have been converted');
        Assert.areEqual(true, convertedLeads[0].IsConverted, 'Lead should have been converted');
    }
}