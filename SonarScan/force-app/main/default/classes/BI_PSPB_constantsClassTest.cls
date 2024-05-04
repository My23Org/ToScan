/**
@description    Test class for the BI_PSPB_constantsClass class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_constantsClassTest {
     /**
     * Test method to verify the constants in the BI_PSPB_ConstantsClass.
     */
    @isTest
    static void testConstants() {
        try{
        // Test the constants
        Assert.areequal('General', BI_PSPB_constantsClass.ACTION_TYPE_GENERAL,'Action type is equal to "General"');
        Assert.areequal('Action', BI_PSPB_constantsClass.ACTION_TYPE_Action,'Action type is equal to "Action"');
        Assert.areequal('History', BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeHistory,'Action type is equal to "History"');
        Assert.areequal('General Notification', BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeGeneral,'Action type is equal to "General Notification"');
        Assert.areequal('Action required', BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeAction,'Action type is equal to "Action required"');
        Assert.areequal('Completed', BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeCompleted,'Action type is equal to "Completed"');
        Assert.areequal('Not Completed', BI_PSPB_constantsClass.ACTION_TYPE_NotificatonTypeIncompleted,'Action type is equal to "Not Completed"');
        Assert.areequal('In Progress', BI_PSPB_constantsClass.ACTION_TYPE_NotificationTypeInprogress,'Action type is equal to "In Progress"');
        Assert.areequal('Expired', BI_PSPB_constantsClass.ACTION_TYPE_NotificationTypeExpired,'Action type is equal to "Expired"');
        Assert.areequal('Read', BI_PSPB_constantsClass.ACTION_TYPE_Read,'Action type is equal to "Read"');
        Assert.areequal('UnRead', BI_PSPB_constantsClass.ACTION_TYPE_UnRead,'Action type is equal to "UnRead"');
        Assert.areequal('Symptom Tracker', BI_PSPB_constantsClass.ACTION_TYPE_SymptomTracker,'Action type is equal to "Symptom Tracker"');
        Assert.areequal('Challenges', BI_PSPB_constantsClass.ACTION_TYPE_Challenges,'Action type is equal to "Challenges"');
        Assert.areequal('Treatment', BI_PSPB_constantsClass.ACTION_TYPE_Treatment,'Action type is equal to "Treatment"');
        Assert.areequal('Prescription', BI_PSPB_constantsClass.ACTION_TYPE_Prescription,'Action type is equal to "Prescription"');
        }
        catch (AuraHandledException ex) {
			Assert.areEqual(
				'Script-thrown exception',
				ex.getMessage(),
				'Exception should match'
			);
		}
    }
}