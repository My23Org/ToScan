/**
 * @description This class provides methods to retrieve the access token required for accessing the Omnichannel API.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		12-Jan-2024		Created		This was an intial development.
 * 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */
public with sharing class BI_PSPB_GetAccessToken {
	//varibale that holds the application name retrieved from Custom Settings.
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	//A variable That holds the name of our application to be used in catch exception handler.
	private static String applicationName = settings != null? settings.BI_SFCOE_LOG_Application__c
		: '';
	public static String GetAccessToken = System.Label.BI_PSPB_GetAccessToken;
	/**
	 * @description 	This method is used to generate the Access token for  Omnichannel API.
	 * 					It queries the custom metadata type to fetch the required API settings, constructs
	 * 					the request, sends it to the API endpoint, and processes the response to extract
	 * 					the access token.
	 *
	 * @return 			String accesstoken  retrieved from the API response, or null if an error occurs.Return value is
	 * 					Used in this classes BI_PSPB_AsynchronousEmailCallout,BI_PSPB_AsynchronousSmsCallout,BI_PSPB_GetMethodEmail,BI_PSPB_GetMethodSms
	 * @ncss
	 */

	public static String getAccessToken() {
		try {			
			BI_PSPB_Omnichannel_API_Setting__mdt filteredSettings = BI_PSPB_Omnichannel_API_Setting__mdt.getInstance(
				GetAccessToken
			);
       		String endpoint = filteredSettings.BI_PSPB_EndPoint__c;
			String clientId = filteredSettings.BI_PSPB_ClientId__c;
			String clientSecret = filteredSettings.BI_PSPB_ClientSecret__c;					
			// Check if the endpoint is found before proceeding
			if (
                String.isNotBlank(endpoint) &&
				String.isNotBlank(clientId) &&
				String.isNotBlank(clientSecret)
			) {
				HttpRequest req = new HttpRequest();
				req.setEndpoint(endpoint);
				req.setMethod('POST');
				req.setHeader(
					'Content-Type',
					'application/x-www-form-urlencoded'
				); // Set the content type to form-encoded

				String formEncodedData =
					'grant_type=client_credentials&client_id=' +
					clientId +
					'&client_secret=' +
					clientSecret;
				req.setBody(formEncodedData);
                       
				Http http = new Http();
				HttpResponse res = http.send(req);
				if (res.getStatusCode() == 200) {
					// Successfully received a response
					Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
					String accesstoken = (String) jsonResponse.get('access_token');
                    if(!String.isBlank(accesstoken))
                    {
                    	return accesstoken;
                    }else{
                    	BI_SFCOE_LOG_Util.logMessage(applicationName,
						BI_PSPB_GetAccessToken.class.toString(),
						BI_PSPB_constantsClass.accessTokenError,System.now(),'',
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
						);     
                    }
							
				} else {
					BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_GetAccessToken.class.toString(),
					BI_PSPB_constantsClass.httpResponseError,System.now(),'',
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,
				BI_PSPB_GetAccessToken.class.toString(),
				BI_PSPB_constantsClass.accessTokenError,System.now(),'',
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);  
			}	
            return null; 
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_GetAccessToken.class.toString(),
				null,
				System.now()
			);
            return null;
			
		}
	}
}