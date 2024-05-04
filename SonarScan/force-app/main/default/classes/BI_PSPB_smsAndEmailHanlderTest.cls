/**
@description    Test class for the BI_PSPB_smsAndEmailHandler class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_smsAndEmailHanlderTest {
    /**
     * @description Test method to verify notification settings handling.
     */
    @isTest
    static void testNotificationSetting() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_Birthdate__c = Date.newInstance(2000, 1, 1));
        insert testAccount;
        CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
        insert testCP;
        CareProgramEnrollee cpe = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCP.Id, BI_PSPB_PatientStatus__c = 'Unassigned');
        insert cpe;
        Account testAccount1 = new Account(Name = 'Test Account', BI_PSP_Birthdate__c = Date.newInstance(2020, 1, 1));
        insert testAccount1;
        CareProgram testCP1 = new CareProgram(Name = 'Test Enrollee');
        insert testCP1;
        CareProgramEnrollee cpe1 = new CareProgramEnrollee(AccountId = testAccount1.Id, Name = 'Test Enrollee', CareProgramId = testCP1.Id, BI_PSPB_PatientStatus__c = 'Unassigned');
        insert cpe1;
         BI_PSP_Symptom_Tracker__c symptomTrackerRecord = new BI_PSP_Symptom_Tracker__c(
            Name = 'Test Symptom',
            BI_PSP_Care_Program_Enrollee__c = cpe.Id,
             BI_PSP_Patient__c = testAccount.Id,
            BI_PSP_Are_you_currently_experiencing__c = True
        );
        insert symptomTrackerRecord;
        Date reminderDate = Date.today();
        Date treatmentDate = Date.today().addDays(7);
        BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Reminder_Date__c = reminderDate,
            BI_PSPB_Date_of_Treatment__c = treatmentDate,
            BI_PSPB_Care_Program_Enrollee__c = cpe.Id,
            BI_PSPB_Status__c = 'Active'
        );
        insert testReminder;
        BI_PSP_Notification_Setting__c testSetting1 = new BI_PSP_Notification_Setting__c(
            BI_PSP_Patient__c = testAccount.Id,
            BI_PSP_SMS__c = true,
            BI_PSP_Email__c = true,
            BI_PSP_Notification_Type__c = 'Symptom Tracker'
        );
        insert testSetting1;
        
        BI_PSPB_Treatment_Reminder__c reminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = cpe1.Id,
            BI_PSPB_Reminder_Date__c = Date.today(),
            BI_PSPB_Date_of_Treatment__c = Date.today().addDays(1)
        );
        insert reminder;
        
        string gsss = 'GeneralChallenges';
        string gs = 'Video';
        string gc = 'GeneralSymptomTracker';
        string ga = 'Article';
        string gcp= 'CreatePost';
        string gcc = 'Comment';
        string gr = 'Reaction';
        string gf = 'Follow';
        string ast = 'ActionSymptomTracker';
        string atr1 = 'TR1';
        string atr2= 'TR3';
        string atr3 = 'TR7';
        string atr4 = 'TR10';
        string atr5 = 'TR14';
        string apd0 = 'PD0';
        string apd1 = 'PD1';
        string apd2 = 'PD3';
        string adlqi = 'DLQI';
        string apss = 'PSS';
        string awpai = 'WPAI';
        string aqsq = 'QSQ';
        List<Id> cpeIds = new List<Id>();
        cpeIds.add(cpe.Id);
        List<Id> cpeIds1 = new List<Id>();
        cpeIds1.add(cpe1.Id);
        List<Id> stIds = new List<Id>();
        stIds.add(symptomTrackerRecord.Id);
        // Set up the test context
        Test.startTest();
        // Call the method you want to test
            BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds1,gc,'');
            BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gsss,'');
            BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds1,gs,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds1,ga,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds1,gcp,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gcc,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gr,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gf,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(stIds,ast,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr1,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr2,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr3,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr4,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr5,'');
            BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,apd0,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,apd1,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,apd2,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,adlqi,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,apss,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,awpai,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,aqsq,'');
        Test.stopTest();
        List<CareProgramEnrollee> cpeRecords = [
			SELECT Id
			FROM CareProgramEnrollee
			WHERE Id = :cpe.Id
		];
		assert.areEqual(
			1,
			cpeRecords.size(),
			'Care program enrollee should have been created'
		);
    } 
    /**
* @description Test method to verify the behavior of handleTrigger method.
*/   
    @isTest
    static void testNotificationSettingMinor() {
        // Create test data
        Account testAccount1 = new Account(Name = 'Test Account', BI_PSP_Birthdate__c = Date.newInstance(2020, 1, 1));
        insert testAccount1;
        Account testAccount2 = new Account(FirstName = 'Test',LastName = 'Contact', BI_PSP_Birthdate__c = Date.newInstance(2000, 1, 1));
        insert testAccount2;
        CareProgram testCP1 = new CareProgram(Name = 'Test Enrollee');
        insert testCP1;
        CareProgramEnrollee cpe1 = new CareProgramEnrollee(AccountId = testAccount1.Id, Name = 'Test Enrollee', CareProgramId = testCP1.Id, BI_PSPB_PatientStatus__c = 'Unassigned');
        insert cpe1;
        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert con;
        BI_PSPB_Enrollee_Caregiver__c ec = new BI_PSPB_Enrollee_Caregiver__c(BI_PSPB_Care_Program_Enrollee__c = cpe1.Id, BI_PSPB_Contact_Id__c = con.Id);
        insert ec;
         BI_PSP_Symptom_Tracker__c symptomTrackerRecord = new BI_PSP_Symptom_Tracker__c(
            Name = 'Test Symptom',
            BI_PSP_Care_Program_Enrollee__c = cpe1.Id,
             BI_PSP_Patient__c = testAccount1.Id,
            BI_PSP_Are_you_currently_experiencing__c = True
        );
        insert symptomTrackerRecord;
        Date reminderDate = Date.today();
        Date treatmentDate = Date.today().addDays(7);
        BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Reminder_Date__c = reminderDate,
            BI_PSPB_Date_of_Treatment__c = treatmentDate,
            BI_PSPB_Care_Program_Enrollee__c = cpe1.Id,
            BI_PSPB_Status__c = 'Active'
        );
        insert testReminder;
        BI_PSP_Notification_Setting__c testSetting1 = new BI_PSP_Notification_Setting__c(
            BI_PSP_Patient__c = testAccount1.Id,
            BI_PSP_SMS__c = true,
            BI_PSP_Email__c = true,
            BI_PSP_Notification_Type__c = 'Symptom Tracker'
        );
        insert testSetting1;
        
        string gsss = 'GeneralChallenges';
        string gs = 'Video';
        string gc = 'GeneralSymptomTracker';
        string ga = 'Article';
        string gcp= 'CreatePost';
        string gcc = 'Comment';
        string gr = 'Reaction';
        string gf = 'Follow';
        string ast = 'ActionSymptomTracker';
        string atr1 = 'TR1';
        string atr2= 'TR3';
        string atr3 = 'TR7';
        string atr4 = 'TR10';
        string atr5 = 'TR14';
        string apd0 = 'PD0';
        string apd1 = 'PD1';
        string apd2 = 'PD3';
        string adlqi = 'DLQI';
        string apss = 'PSS';
        string awpai = 'WPAI';
        string aqsq = 'QSQ';
        List<Id> cpeIds = new List<Id>();
        cpeIds.add(cpe1.Id);
        List<Id> stIds = new List<Id>();
        stIds.add(symptomTrackerRecord.Id);
        // Set up the test context
        Test.startTest();
        
        // Call the method you want to test
            BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gc,'');
            BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gsss,'');
            BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gs,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,ga,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gcp,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gcc,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gr,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,gf,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(stIds,ast,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr1,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr2,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr3,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr4,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,atr5,'');
            BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,apd0,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,apd1,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,apd2,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,adlqi,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,apss,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,awpai,'');
        	BI_PSPB_smsAndEmailHandler.handleTrigger(cpeIds,aqsq,'');
        Test.stopTest();
        List<CareProgramEnrollee> cpeRecords = [
			SELECT Id
			FROM CareProgramEnrollee
			WHERE Id = :cpe1.Id
		];
		assert.areEqual(
			1,
			cpeRecords.size(),
			'Care program enrollee should have been created'
		);
    } 
    
}