/*
 * @description This class is used for guest users, which is why it is not shared. 
 * It is used to retrieve data from the product from CareProgramProduct objects.
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023     Created             Initial development
 * 1.1      Ashif  04-Apr-2024     Updated             Catch log added
 */
public without sharing class BI_PSPB_getProductList {
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
	private static String applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';
	//custom label
	private static String errorForThrow = System.Label.BI_PSP_ConsoleError;
	private static String spevigo = System.Label.BI_PSPB_spevigo;
    private static String errorForCareprogramProduct = System.Label.BI_PSPB_CareprogramProduct;
	// This method provides a list of options to the combobox for products
	
/*
@description     Used to fecth the Product of the Care program product, return in lwc biPspbHcpEnrollement
@return          Return CareProgramProduct
*/
	@AuraEnabled(cacheable=true)
	public static List<CareProgramProduct> getProductList() {
		List<CareProgramProduct> lstCarePgmProducts = new List<CareProgramProduct>();
		try {
			//Since this object is invoked from a Guest User Profile which has limited access to the Health Cloud objects, User Mode cannot be used here
			// This is a searchable combo box. If the Aura Enabled Exception is thrown, for every character search, the error 
			// will be displayed that disrupts the screen design. 
            //In the respective LWC, the error message is displayed as 'Unable to find' below the combo box input field 
            //(that will be visible to the user)  if the record is not found. the record is not found.
            List<CareProgram> careprogram = [SELECT Id FROM CareProgram WHERE Name  =:spevigo Limit 1];
            if(!careprogram.isEmpty()){
            	lstCarePgmProducts = [
					SELECT Id, Name
					FROM CareProgramProduct
					WHERE CareProgramId = :careprogram[0].id
                ];
            // This is a searchable combo box. If the Aura Enabled Exception is thrown, for every character search, the error 
			// will be displayed that disrupts the screen design. 
            //In the respective LWC, the error message is displayed as 'Unable to find' below the combo box input field 
            //(that will be visible to the user)  if the record is not found.
            }else{
               throw new AurahandledException(errorForCareprogramProduct);  
            }
		} catch (Exception ex) {BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_getProductList.class.toString(),null,
				System.now());
			// Returning null if an exception occurs
			// Handling error in Lwc
			return null;
		}
		return lstCarePgmProducts;
	}

/* 
@description     Used to fetch the Product detail in care program product, return in lwc biPspbHcpEnrollement
@return          Return Product deatils
*/
	@AuraEnabled(cacheable=true)
	public static List<CareProgramProduct> getprescritionData(String productId) {
		List<CareProgramProduct> carepgmProductList = new List<CareProgramProduct>();
		try {
			//Since this object is invoked from a Guest User Profile which has limited access 
			//to the Health Cloud objects, User Mode cannot be used here
            if(String.isBlank(productId)){
              throw new AurahandledException(errorForCareprogramProduct);  
            }
			carepgmProductList = [
				SELECT
					Id,
					Name,
					BI_PSPB_Product_code__c,
					BI_PSPB_Dosage__c,
					BI_PSPB_Unit__c,
					BI_PSPB_Unit__r.Name
				FROM CareProgramProduct
				WHERE Id = :productId
				LIMIT 1
			];
            if(carepgmProductList.isEmpty()){
                throw new AurahandledException(errorForCareprogramProduct);
            }
		} catch (Exception ex) {BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_getProductList.class.toString(),null,
				System.now());
			throw new AurahandledException(errorForCareprogramProduct);
		}
		return carepgmProductList;
	}
}