/*

Apex Class Name    :BI_PSP_UpdateRolloutsTest
Created Date       : December 15, 2023
description       : To make the Assessment Expired by the conditions
author            : Harish
@Last Modified On  :11/03/2024
@Last Modified by  :Abinsha

*/

@isTest
public class BI_PSP_UpdateRolloutsTest {
    
   @isTest
    static void testSchedulerCacth() {
           // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test Assessment record
        Assessment testAssessment = new Assessment();
        testAssessment.Name = 'Test Assessment';
        testAssessment.AssessmentStatus = 'Completed';
        testAssessment.ExpirationDateTime = System.now().addDays(-30);
        testAssessment.CreatedDate = DateTime.now().addDays(-30); // Exactly 30 days ago
        // Add other required fields here
        insert testAssessment;

        // Schedule the job
        
        Test.startTest();
         BI_PSP_UpdateRollouts scheduler = new BI_PSP_UpdateRollouts();
        scheduler.execute(null);
        Test.stopTest();

        // Verify that the Assessment record has been updated
        Assessment updatedAssessment = [SELECT Id, AssessmentStatus, ExpirationDateTime FROM Assessment WHERE Id = :testAssessment.Id];
       
        Assert.areEqual('Expired', updatedAssessment.AssessmentStatus, 'AssessmentStatus should be set to Expired');
        
        // Verify that ExpirationDateTime is updated by 30 days
        Datetime expectedExpirationDateTime = testAssessment.ExpirationDateTime.addDays(30);
        Assert.areEqual(expectedExpirationDateTime, updatedAssessment.ExpirationDateTime.addDays(30), 'ExpirationDateTime should be updated by 30 days');

    }


    @isTest
    static void testScheduler() {
         // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        // Create a test Assessment record
        Assessment testAssessment = new Assessment();
        testAssessment.Name = 'Test Assessment';
        testAssessment.AssessmentStatus = 'Completed';
        testAssessment.ExpirationDateTime = System.now().addDays(-30);
        testAssessment.CreatedDate = System.now().addDays(-3); // Exactly 30 days ago
        // Add other required fields here
        insert testAssessment;
        

        // Schedule the job
        BI_PSP_UpdateRollouts scheduler = new BI_PSP_UpdateRollouts();
        String jobName = 'BI_PSP_UpdateRolloutsTest' + Datetime.now().getTime();
        String cronExp = '0 0 * * * ?';
        Test.startTest();
        System.schedule(jobName, cronExp, scheduler);
        Test.stopTest();

        // Verify that the Assessment record has been updated
        Assessment updatedAssessment = [SELECT Id, AssessmentStatus, ExpirationDateTime FROM Assessment WHERE Id = :testAssessment.Id];
       
        Assert.areEqual('Expired', updatedAssessment.AssessmentStatus, 'AssessmentStatus should be set to Expired');
        
        // Verify that ExpirationDateTime is updated by 30 days
        Datetime expectedExpirationDateTime = testAssessment.ExpirationDateTime.addDays(30);
        Assert.areEqual(expectedExpirationDateTime, updatedAssessment.ExpirationDateTime.addDays(30), 'ExpirationDateTime should be updated by 30 days');

    }
    

  
}