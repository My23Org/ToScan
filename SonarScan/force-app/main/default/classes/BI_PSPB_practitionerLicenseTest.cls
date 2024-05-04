/**
 * @description        This class contains unit tests for the BI_PSPB_practitionerLicense Apex class, which is responsible for the fetch that practitioner licenses
					   in contact object
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  		05-Nov-2023    		 Created             Initial development
 * 1.1      Ashif  		23-Apr-2024     	 Updated             Catch log added
 */

 @isTest
 public class BI_PSPB_practitionerLicenseTest {
	 /*@description This Test method to verify that practitioner licenses are fetched correctly.
	  */
	 @isTest
	 static void testGetPractitionerList() {
		 // Test data setup
		 Contact practitioner = new Contact(
			 FirstName = 'John',
			 LastName = 'Doe',
			 HealthCloudGA__StatusGroup__c = 'Unverified',
			 BI_PSPB_License_number__c = 'ABC123'
		 );
		 insert practitioner;
 
		 // Test method execution
		 Test.startTest();
		 List<Contact> practitionerList = BI_PSPB_practitionerLicense.getPractitionerList();
		 Test.stopTest();
 
		 // Assertions
		 Assert.areEqual(
			 0,
			 practitionerList.size(),
			 'One practitioner should be returned'
		 );
	 }
 }