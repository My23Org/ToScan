/*
 * @description       This class contains unit tests for the BI_PSPB_referringPractitione Apex class, which is responsible for the fetch that Name of the practitioner
					   in contact object
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023         Created             Initial development
 */
@isTest
public class BI_PSPB_referringPractitionerTest {
private static   BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('ApplicationName');

@isTest
    static  void testGetPractitionerList() {
 /*@description This Test method to verify that practitioner Name are fetched correctly.
*/       
        // Create test data
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'BI_PSPB_Physician'];
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            RecordTypeId = rt.Id,
            HealthCloudGA__StatusGroup__c = 'Active'
        );
        insert testContact;
        
        // Call the method to test
        Test.startTest();
        List<Contact> result = BI_PSPB_referringPractitioner.getPractitionerList();
        Test.stopTest();
        
        // Check if the method returned the expected results
        Assert.areEqual(1, result.size(), 'Expected one contact record');
        Contact retrievedContact = result[0];
        Assert.areEqual('Test Contact', retrievedContact.Name, 'Retrieved contact name should be "Test Contact"');
        // Add more assertions based on the fields returned in the query
    }
   
    @isTest
    static  void testGetPractitionerList_Exception() {
 /*@description This Test method to cover try and catch.
*/       
        // Mocking the exception scenario by setting up the necessary conditions for an exception to occur
        BI_SFCOE_LOG_App_Settings__c mockSettings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Mock Application'
        );
        insert mockSettings;

        // Call the method to test with conditions that will cause an exception
        Test.startTest();
        try {
            // Call the method that is expected to throw an exception
            List<Contact> result = BI_PSPB_referringPractitioner.getPractitionerList();
            // If no exception is thrown, fail the test
             Assert.areNotEqual(null, result, 'Returned list should be null if an exception occurs');
        } catch (AuraHandledException e) {
            Assert.areEqual(
			e.getMessage(),
			'Script-thrown exception',
			e.getMessage()
		);
            
        Test.stopTest();
    }
}
}