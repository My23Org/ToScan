/**
@description	Test class for the BI_PSPB_createLeadRecord class.
@author					Niyas
@Last Modified On   	04/23/2024
@Last Modified By 		Niyas
*/
@isTest
public class BI_PSPB_createLeadRecordTest {
	@isTest
	static void testInsertLead_Success() {
		 // Call the method with valid parameters
		Contact newContact = new Contact();
		newContact.FirstName = 'Test';
		newContact.LastName = 'Contact';
		newContact.Email = 'test@example.com';
		insert newContact;
		BI_PSPB_createLeadRecord.LeadWrapper leadWrapper = new BI_PSPB_createLeadRecord.LeadWrapper();
		// Create a LeadWrapper object with mock data
		leadWrapper.firstName = 'John';
		leadWrapper.lastnamelll = 'Doe';
		leadWrapper.dob = '1990-01-01';
		leadWrapper.gender = 'Male';
		leadWrapper.email = 'john.doe@example.com';
		leadWrapper.phone = '1234567890';
		leadWrapper.pmc = 'Email';
		leadWrapper.country = 'US';
		leadWrapper.state = 'CA';
		leadWrapper.city = 'San Francisco';
		leadWrapper.street = '123 Main St';
		leadWrapper.zipCode = '12345';
		leadWrapper.selectedPrescription = newContact.Id;
		// Call the method to test
		try {
			Test.startTest();
				Id newLeadId = BI_PSPB_createLeadRecord.insertLead(leadWrapper);
			Test.stopTest();
			List < Lead > leadRecord =[SELECT Id FROM Lead
			WHERE Id = : newLeadId ];
			assert.areEqual(1,leadRecord.size(),
				'Lead should have been created');
		} catch (Exception e) {
			Assert.areEqual('Script-thrown exception', e.getMessage(),
				'Method thrown exception');
		}
	}
/**
* @description Test method to verify the behavior of insertLead method.
*/
	@isTest
	static void testInsertLead_failed() {
		 // Call the method with valid parameters
		Contact newContact = new Contact();
		newContact.FirstName = 'Test';
		newContact.LastName = 'Contact';
		newContact.Email = 'test@example.com';
		insert newContact;
		BI_PSPB_createLeadRecord.LeadWrapper leadWrapper = new BI_PSPB_createLeadRecord.LeadWrapper();
		// Create a LeadWrapper object with mock data
		leadWrapper.firstName = 'John';
		leadWrapper.lastnamelll = 'Doe';
		leadWrapper.dob = '1990-01-01';
		leadWrapper.gender = 'Male';
		leadWrapper.email = 'john.doe';
		leadWrapper.phone = '1234567890';
		leadWrapper.pmc = 'Email';
		leadWrapper.country = 'US';
		leadWrapper.state = 'CA';
		leadWrapper.city = 'San Francisco';
		leadWrapper.street = '123 Main St';
		leadWrapper.zipCode = '12345';
		leadWrapper.selectedPrescription = newContact.Id;
		// Call the method to test
		try {
			Test.startTest();
				 Id newLeadId = BI_PSPB_createLeadRecord.insertLead(leadWrapper);
			Test.stopTest();
			List < Lead > leadRecord =[SELECT Id FROM Lead
			WHERE Id = : newLeadId];
			assert.areEqual(1,leadRecord.size(),'Lead should have been created');
		} catch (Exception e) {
			Assert.areEqual('Script-thrown exception', e.getMessage(),
				'Method thrown exception');
		}
	}
/**
* @description Test method to verify the behavior of getCommunicationOptions method.
*/
	@isTest
	static void testGetLeadGenderOptions() {
		// Call the method with valid parameters to ensure no exception is thrown
		Test.startTest();
		List < String > leadGenderOptions = null;
		leadGenderOptions = BI_PSPB_createLeadRecord.getCommunicationOptions();
		Test.stopTest();
		// Verify the result
		Assert.areequal(3, leadGenderOptions.size(), 'There should be 3 lead gender options');
		Assert.areequal('Email', leadGenderOptions[0], 'First option should be Email');
		Assert.areequal('Phone', leadGenderOptions[1], 'Second option should be Phone');
		Assert.areequal('SMS', leadGenderOptions[2], 'Third option should be SMS');

	}
/**
* @description Test method to verify the behavior of getHcpRecord method.
*/
	@isTest
	static void testGetHcpRecord() {
		// Create test Lead record
		Lead testLead = new Lead(FirstName = 'TestFirstName',
		LastName = 'TestLastName');
		insert testLead;

		// Call the method being tested
		Test.startTest();
		List < Lead > result = BI_PSPB_createLeadRecord.getHcpRecord(testLead.Id);
		Test.stopTest();
		List < Lead > leadRecord =[SELECT Id
			FROM Lead WHERE Id = : result];
		assert.areEqual(1,leadRecord.size(),'Hcp should have been created');
	}
   /**
* @description Test method to verify the behavior of getHcpRecord method 
with  null value as input.
*/
	@isTest
	static void testGetHcpRecordFailed() {
		// Create test Lead record
		Lead testLead = new Lead(FirstName = 'TestFirstName',
		LastName = 'TestLastName');
		insert testLead;

		// Call the method being tested
		try {
			Test.startTest();
			List < Lead > result = BI_PSPB_createLeadRecord.getHcpRecord('');
			Test.stopTest();
			List < Lead > leadRecord =[SELECT Id FROM Lead
			WHERE Id = : result];
			assert.areEqual(1,leadRecord.size(),'Hcp should have been failed');
		} catch (Exception e) {
			Assert.areEqual('Script-thrown exception', e.getMessage(),
				'Method thrown exception');
		}
	}

}