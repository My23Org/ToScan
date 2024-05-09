/*
* @description 	This class is used for setting up,fetching the username and 
				also the avatar of the user for the community.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Deepa		05-Dec-2023		Created			Initial development.
* 1.1		Deepa 		20-Jan-2024		Updated			Updated for caregiver.
* 1.2		Deepa		04-Apr-2024		Updated			Catch log added.
* 1.3		Deepa		22-Apr-2024		Updated			Code Review.
* 1.4 		Deepa		27-Apr-2024		Updated			Updated for KO.
*/
public with sharing class BI_PSPB_CommunityUsername {
	private static BI_SFCOE_LOG_App_Settings__c settings = 
	BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c : '';
	// Custom labels for error while throwing exception.
	private static String errorWhileGettingUser =
	System.Label.BI_PSPB_Error_For_User;
	private static String errorWhileGettingAccountId =
	System.Label.BI_PSPB_Error_For_Account;
	private static String errorWhileGettingUsername =
	System.Label.BI_PSPB_Error_For_UserName;
	private static String errorWhileCreatingUsername = 
	System.Label.BI_PSPB_Error_For_Create_User_Name;
	private static String errorWhileGettingAvatar =
	System.Label.BI_PSPB_Error_For_Image;
	private static String errorMessage = '';
	/**
	* @description	To check the username for community already exists.
	* @param		userId - The Id of the user for checking username.
	* @return		Boolean Returns true , if there is a username already.
					Returns false when there is no username.
					Returns boolean value to biPspbCreatPost,biPspbMyPost,
					biPspbAllPost,biPspbNavBar LWC.
	*/
	@AuraEnabled
	public static Boolean checkCommunityUsername(String userId) {
	Account accountRecord;
	try {
		// Checking if userId is not blank.
		if(String.isNotBlank(userId)){
			String accountId = BI_PSPB_FeedItemCtrl.getUserAccountId(userId);
			if(String.isNotBlank(accountId)){
				// Query for Account to check if BI_PSP_CommunityUsername__c is not null.
				accountRecord = [SELECT Id,BI_PSP_CommunityUsername__c
				FROM Account WHERE Id = :accountId WITH USER_MODE LIMIT 1];
			}
			else{
				// Logging an error if account ID is blank.
				BI_SFCOE_LOG_Util.logMessage(applicationName,
				BI_PSPB_CommunityUsername.class.toString(),'',System.now(),
				errorWhileGettingAccountId,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			}
		}else{
			// Logging an error if userId is blank.
			BI_SFCOE_LOG_Util.logMessage(applicationName,
			BI_PSPB_CommunityUsername.class.toString(),'',System.now(),
			errorWhileGettingUser,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
		}
		if(accountRecord != null && 
		accountRecord.BI_PSP_CommunityUsername__c != null){
			// Returning true when BI_PSP_CommunityUsername__c is not null.
			return true;
		}else{
			// Returning false when BI_PSP_CommunityUsername__c is null.
			return false;
		}
	} catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(ex,applicationName,
		BI_PSPB_CommunityUsername.class.toString(),null,System.now());
		throw new AuraHandledException(errorWhileGettingUsername);
		}
	}
	/**
	* @description	Retrieves the CommunityUsername for a user.
	* @param		userId(String) - The Id of the user to check community username.
	* @return		Account - The Account record containing the 
					CommunityUsername, or null if not found.
					Returns to biPspbChatterUsername LWC.
	*/
	@AuraEnabled
	public static Account getCommunityUsername(String userId) {
	Account accountRecord;
	try {
		if(String.isBlank(userId)){
			 // Throwing an exception when userId is blank.
			throw new AuraHandledException(errorWhileGettingUsername);
		}else{
			// Getting the account ID associated with the user ID.
			String accountId = BI_PSPB_FeedItemCtrl.getUserAccountId(userId);
			if(String.isBlank(accountId)){
				// Throwing an exception when account ID is blank.
				throw new AuraHandledException(errorWhileGettingAccountId);
			}else{
				// Query for Account to get the CommunityUsername.
				accountRecord = [SELECT Id,FirstName,LastName,PersonEmail,Phone,
				BI_PSP_CommunityUsername__c FROM Account WHERE Id = :accountId  
				WITH USER_MODE LIMIT 1];
			}
	}    
	}catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(ex,applicationName,
		BI_PSPB_CommunityUsername.class.toString(),null,System.now());
		throw new AuraHandledException(errorWhileGettingUsername);
	}
		/** Here 'accountRecord' is not checked for null exception as 
				it is handled in LWC.
				There are two different scenario such as it takes an action when 
				it is returned as null and another action when it is returned with values.
		*/
		return accountRecord;
	}
	/**
	* @description	Creates a CommunityUsername for the specified
					user if it doesn't exist.
	* @param		userId - The Id of the user to create username.
	* @param		username - The username to insert.
	This method is used in biPspbChatterUsername LWC.
	*/
	@AuraEnabled
	public static void  insertCommunityUsername(String userId,string username){
	try {
		Account accountRecord;
		if(String.isNotBlank(userId) && String.isNotBlank(username)){
			// Getting the account ID associated with the user ID.
			String accountId = BI_PSPB_FeedItemCtrl.getUserAccountId(userId);
			if(String.isNotBlank(accountId)){
				// Query for Account to get the CommunityUsername.
				accountRecord = [SELECT Id,FirstName,LastName,PersonEmail,Phone,
				BI_PSP_CommunityUsername__c FROM Account WHERE Id = :accountId
				WITH USER_MODE LIMIT 1];
				// Updating the CommunityUsername field with the provided username.
				// Here accountRecord cannot be null when accountId is not null.
					accountRecord.BI_PSP_CommunityUsername__c = username;
					// Updating the Account record.
					Database.SaveResult[] saveResults = Database.update(
					new List<Account>{accountRecord},false,AccessLevel.USER_MODE);
					for (Database.SaveResult saveResult : saveResults) {
						if (!saveResult.isSuccess()) {
							for (Database.Error error : saveResult.getErrors()) {
								errorMessage += 'Error ' + error.getFields() 
								+ '--' + error.getMessage() + '\n';
							}
						}
					}
					if (String.isNotBlank(errorMessage)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveResults,
						BI_PSPB_CommunityUsername.class.toString(),System.now());
						throw new AuraHandledException(errorWhileCreatingUsername);
					}
			} else {
				// Throwing an exception when account ID is blank.
				throw new AuraHandledException(errorWhileGettingAccountId);
			}
		} else {
			// Throwing an exception when user ID is blank.
			throw new AuraHandledException(errorWhileGettingUser);
		}
	} catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(ex,applicationName,
		BI_PSPB_CommunityUsername.class.toString(),null,System.now());
		throw new AuraHandledException(errorWhileCreatingUsername);
	}
	}
	/**
	* @description	Retrieves the avatar image for the logged-in user
					to display it in the page.
	* @param		userId - The Id of the logged-in user to get avatar image.
	* @return		List<Account> - The list of accounts containing the 
					Avatar information.Returns to biPspbAllPost,biPspbMyPost,
					biPspbCreatePost,biPspbChatterUsername,biPspbMyFollowing and 
					biPspbMyFollowers LWC.
	*/
	@AuraEnabled
	public static list<Account> gettingAvatar(String userId) {
	list<Account> accountRecord;
	try {
		if(String.isNotBlank(userId)){
			// Getting the account ID associated with the user ID.
			String accountId = BI_PSPB_FeedItemCtrl.getUserAccountId(userId);
			if(String.isNotBlank(accountId)){
			// Query for Account to get Avatar URL.
			accountRecord = [SELECT Id,BI_PSP_AvatarUrl__c FROM Account WHERE 
			Id = :accountId AND  BI_PSP_AvatarUrl__c != null WITH USER_MODE LIMIT 1];
			}
			else{
				// Throwing an exception when account ID is blank.
				throw new AuraHandledException(errorWhileGettingAccountId);
			}
		} else {
			// Throwing an exception when user ID is blank.
			throw new AuraHandledException(errorWhileGettingUser);
		}
		if(!accountRecord.isEmpty()){
			return accountRecord;
		} else {
			// Throwing an exception when accountRecord is blank.
			throw new AuraHandledException(errorWhileGettingAvatar);
		}
	} catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(ex,applicationName,
		BI_PSPB_CommunityUsername.class.toString(),null,System.now());
		throw new AuraHandledException(errorWhileGettingAvatar);
	}	
	}
}