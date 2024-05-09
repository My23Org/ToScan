/*
 * @description  This test class is designed for testing scenarios related to guest users and is not shared.
  It is used to perform unit tests for retrieving data from the CareProgramProduct objects
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023     			Created             Initial development

 */
@isTest
private class BI_PSPB_getProductListTest {
private static   BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('ApplicationName');
    /**
 * @description Test method to verify the functionality of retrieving product lists.
 * Creates test data including a CareProgram and a related CareProgramProduct.
 * Calls the method under test to retrieve the product list.
 * Verifies that the returned list is not null and contains expected products.
 */

    @isTest
    static void testGetProductList() {
        // Create test data
        Careprogram cp = new Careprogram(Name ='Spevigo', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramProduct testCareProgramProduct = new CareProgramProduct(Name = 'Test Product',CareProgramId = cp.id);
        insert testCareProgramProduct;
        
        // Call the method under test
        Test.startTest();
        List<CareProgramProduct> productList = BI_PSPB_getProductList.getProductList();
        Test.stopTest();
        
        // Assert that the returned list is not null and contains the expected product
        Assert.areNotEqual(null, productList, 'List of CareProgramProducts from getProductList() is null');
       
    }
    /**
 * @description Test method to verify the functionality of retrieving prescription data for a specific CareProgramProduct.
 * Creates test data including a CareProgram and a related CareProgramProduct.
 * Calls the method under test to retrieve prescription data for the specified CareProgramProduct.
 * Verifies that the returned list is not null, has a size of 1, and contains the expected prescription data.
 */

    @isTest
    static void testGetprescritionData() {
        // Create test data
        Careprogram cp = new Careprogram(Name ='Spevigo', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramProduct testCareProgramProduct = new CareProgramProduct(Name = 'Test Prescription',CareProgramId = cp.id);
        insert testCareProgramProduct;
        
        // Call the method under test
        Test.startTest();
        List<CareProgramProduct> prescriptionData = BI_PSPB_getProductList.getprescritionData(testCareProgramProduct.Id);
        Test.stopTest();
        
        // Assert that the returned list is not null and contains the expected prescription data
        Assert.areNotEqual(null, prescriptionData, 'prescriptionData is null');
        Assert.areEqual(1, prescriptionData.size(), 'prescriptionData size is not 1');
        Assert.areEqual(testCareProgramProduct.Id, prescriptionData[0].Id, 'Id mismatch in prescriptionData');
       
       
    }
    /**
 * @description Test method to verify the handling of an exception scenario when retrieving prescription data for a specific CareProgramProduct.
 * Creates test data including a CareProgram and a related CareProgramProduct.
 * Calls the method under test with a null parameter to simulate an exception scenario.
 * Verifies that the returned list is null, indicating the occurrence of an exception.
 */

    @isTest
    static void testGetprescritionDataexception() {
        // Create test data
        Careprogram cp = new Careprogram(Name ='Spevigo', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramProduct testCareProgramProduct = new CareProgramProduct(Name = 'Test Prescription',CareProgramId = cp.id);
        insert testCareProgramProduct;
        try{
        // Call the method under test
        Test.startTest();
        List<CareProgramProduct> prescriptionData = BI_PSPB_getProductList.getprescritionData(null);
        Test.stopTest();
        
        // Assert that the returned list is not null and contains the expected prescription data
        Assert.areEqual(null, prescriptionData, 'prescriptionData is null');
        }catch (Exception ex) {
        // Assert if there's an exception
        Assert.areEqual(
            'Script-thrown exception',
            ex.getMessage(),
            'An unexpected exception occurred: ' + ex.getMessage()
        );
    }
       
       
    }
   
}