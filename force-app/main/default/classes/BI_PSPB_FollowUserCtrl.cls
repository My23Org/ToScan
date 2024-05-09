/*
* @description 		This class is used to fetch, insert and delete 
					the follow and following records.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Ragavi		05-Dec-2023		Created			Initial development.
* 1.1		Ragavi 		05-Jan-2024		Updated			Updated to 
														filter records without nullpointer 
														exception.
* 1.2		Ragavi		04-Apr-2024		Updated			Catch log added.
* 1.3		Ragavi		22-Apr-2024		Updated			Code Review.
* 1.4		Ragavi	 	27-Apr-2024		Updated			Indentation.
*/
public with sharing class BI_PSPB_FollowUserCtrl { 
	// Static variables initialization.
	private static BI_SFCOE_LOG_App_Settings__c settings = 
    BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
    private static String applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c : '';
	private static String follower = System.Label.BI_PSP_Follower;
	private static String following = System.Label.BI_PSP_Following;
	private static String errorMessage = '';
	private static String errorWhileUnfollowing = 
		System.Label.BI_PSPB_Error_For_Unfollow;
	private static String errorWhileFollowing = 
		System.Label.BI_PSPB_Error_For_Follow_Account;
	private static String alreadyFollowing = 
		System.Label.BI_PSPB_Error_For_Follow_User;
	private static String errorWhileGettingAccountId = 
		System.Label.BI_PSPB_Error_For_Account;
	private static String errorWhileGettingUser = 
		System.Label.BI_PSPB_Error_For_User;
	private static String errorWhileGettingFollowers = 
		System.Label.BI_PSPB_Error_For_Getting_Follower;
	/**
	* @description		Used to follow the accounts as followers and following.
	* @param			accountIdToFollow - Id of the user to follow.
	* @param 			userWhoFollows - Id of the user who follows.
	This method is used in biPspbMyFollowers,biPspbMyFollowing,biPspbAllPost
	and biPspbMyPost LWC.
	*/
	@AuraEnabled(cacheable=false)
	public static void followUser(String accountIdToFollow,String userWhoFollows)	
	 {
		try {
			// Check if accountIdToFollow and userWhoFollows are not blank.
			if (String.isNotBlank(accountIdToFollow) 
				&&String.isNotBlank(userWhoFollows)) {
				// Getting the account Id from user Id.
				String accountIdWhoFollows = BI_PSPB_FeedItemCtrl.getUserAccountId(
					userWhoFollows);
				// Check if accountIdWhoFollows is not blank.
				if (String.isNotBlank(accountIdWhoFollows)) {
					// List to hold new records to be inserted.
					List<BI_PSP_FeedFollow__c> insertFeedFollowList = 
						new List<BI_PSP_FeedFollow__c>();
					//Checking for if there any existing records before following.
					List<BI_PSP_FeedFollow__c> existingRecords = [
						SELECT Id FROM BI_PSP_FeedFollow__c WHERE
							(BI_PSP_Account__c = :accountIdWhoFollows
							AND BI_PSP_AccountUser__c = :accountIdToFollow
							AND BI_PSP_Type__c = :following)
							OR (BI_PSP_Account__c = :accountIdToFollow
							AND BI_PSP_AccountUser__c = :accountIdWhoFollows
							AND BI_PSP_Type__c = :follower) WITH USER_MODE LIMIT 1 ];
					// Check if there are no existing records for the follow relationship.
					if (existingRecords.isEmpty()) {
						// Create a new record for the follower.
						BI_PSP_FeedFollow__c newfollower = new BI_PSP_FeedFollow__c(
							BI_PSP_Account__c = accountIdWhoFollows,
							BI_PSP_AccountUser__c = accountIdToFollow,
							BI_PSP_Type__c = following);
						insertFeedFollowList.add(newfollower);
						// Create a new record for the user being followed.
						BI_PSP_FeedFollow__c newfollowing = new BI_PSP_FeedFollow__c(
							BI_PSP_Account__c = accountIdToFollow,
							BI_PSP_AccountUser__c = accountIdWhoFollows,
							BI_PSP_Type__c = follower);
						insertFeedFollowList.add(newfollowing);
						// Insert the new records into the database.
						Database.SaveResult[] insertFeedFollow = Database.insert(
							insertFeedFollowList,false,AccessLevel.USER_MODE);
						// Loop through the save results to check for any errors.
						for (Database.SaveResult saveResult : insertFeedFollow) {
							// Check if the insertion was not successful.
							if (!saveResult.isSuccess()) {
								// Loop through the errors for each record.
								for (Database.Error error : saveResult.getErrors()) {
									// Build an error message with the error details.
									errorMessage += 'Error ' + error.getFields() +'--' + 
									error.getMessage() +'\n';		
								}
							}
						}
						// Check if there are any error messages generated during the insertion.
						if (String.isNotBlank(errorMessage)) {
							// Log the database save results.
							BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
								insertFeedFollow,BI_PSPB_FollowUserCtrl.class.toString(),System.now()
							);
							// Throw an exception indicating an error occurred while following the user.
							throw new AuraHandledException(errorWhileFollowing);
						}
					} else {
						// If no errors occurred during the insertion, but the follow 
						//relationship already exists,
						// throw an exception indicating that user is already being followed.
						throw new AuraHandledException(alreadyFollowing);
					}
				} else {
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			} else {
				throw new AuraHandledException(errorWhileGettingAccountId);
			}
		} catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FollowUserCtrl.class.toString(),
				null,System.now()
			);
			throw new AuraHandledException(errorWhileFollowing);
		}
	}
	/**
	* @description		Used to fetch all followers of the loggedin user.
	* @param			userId - Id of the user to get followers for that user.
	* @return			List<BI_PSP_FeedFollow__c> - All followers for that user.
						Returns to biPspbMyFollowers and biPspbMyFollowing LWC.
	*/
	@AuraEnabled(cacheable=false)
	public static List<BI_PSP_FeedFollow__c> getMyFollowers(String userId) {
		List<BI_PSP_FeedFollow__c> followers;
		try {
			// Checking if the userId provided is not blank.
			if (String.isNotBlank(userId)) {
				// Retrieving the account Id corresponding to the provided User Id.
				String accountId = BI_PSPB_FeedItemCtrl.getUserAccountId(userId);
				// Checking if the accountId obtained is not blank.
				if (String.isNotBlank(accountId)) {
					// Querying the database to retrieve followers for the logged-in user.
					followers = [
						SELECT BI_PSP_AccountUser__c,
						BI_PSP_AccountUser__r.BI_PSP_CommunityUsername__c,BI_PSP_Type__c,
						BI_PSP_Account__c,BI_PSP_Account__r.BI_PSP_CommunityUsername__c,
						BI_PSP_AccountUser__r.BI_PSP_AvatarUrl__c	FROM BI_PSP_FeedFollow__c
						WHERE	BI_PSP_Account__c = :accountId	AND (BI_PSP_Type__c = :follower
						OR BI_PSP_Type__c = :following)	WITH USER_MODE	];
				} else {
					// Handling the case where accountId is blank,
					// indicating a problem with retrieval.
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			} else {
				// Handling the case where userId is blank, indicating an issue with the input.
				throw new AuraHandledException(errorWhileGettingUser);
			}
		} catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FollowUserCtrl.class.toString(),
				null,System.now() );
			throw new AuraHandledException(errorWhileGettingFollowers);
		}
		/** Here 'followers' is not checked for null exception as 
			it is handled in LWC.
			There are two different scenario such as it takes an action when 
			it is returned as null and another action when it is returned with values.
		*/
		return followers;
	}
	/**
	* @description		Used to unfollow the account that is being followed.
	* @param			accountIdToUnFollow - Id of the account that to be unfollowed.
	* @param			userIdWhoUnFollows - Id of the user who unfollows.
	This method is used in biPspbMyFollowers,biPspbMyFollowing,biPspbAllPost
	and biPspbMyPost LWC.
	*/
	@AuraEnabled(cacheable=false)
	public static void unfollowUser(
		String accountIdToUnFollow,String userIdWhoUnFollows) {
		try {
			// Checking if both accountIdToUnFollow and userIdWhoUnFollows are not blank.
			if (String.isNotBlank(accountIdToUnFollow)  &&
				String.isNotBlank(userIdWhoUnFollows) ) {
				// Getting the account Id corresponding to the userIdWhoUnFollows.
				String accountIdWhoUnfollows = BI_PSPB_FeedItemCtrl.getUserAccountId(
					userIdWhoUnFollows);
				// Checking if the accountId obtained is not blank.
				if (String.isNotBlank(accountIdWhoUnfollows)) {
					// Creating a list to hold the records to be unfollowed.
					List<BI_PSP_FeedFollow__c> insertFeedUnfollowList = 
					new List<BI_PSP_FeedFollow__c>();
					// Querying  to retrieve the follower and following records to unfollow.
					BI_PSP_FeedFollow__c unfollower = [
						SELECT Id FROM BI_PSP_FeedFollow__c WHERE
							BI_PSP_Account__c = :accountIdWhoUnfollows
							AND BI_PSP_AccountUser__c = :accountIdToUnFollow
							AND BI_PSP_Type__c = :following WITH USER_MODE ];
					BI_PSP_FeedFollow__c unfollowing = [
						SELECT Id FROM BI_PSP_FeedFollow__c WHERE
							BI_PSP_Account__c = :accountIdToUnFollow
							AND BI_PSP_AccountUser__c = :accountIdWhoUnfollows
							AND BI_PSP_Type__c = :follower WITH USER_MODE ];
					/*Checking if both follower and following records exist 
						before proceeding with unfollowing. */
					if (unfollowing != null && unfollower != null) {
						// Adding the follower and following records to the list for deletion.
						insertFeedUnfollowList.add(unfollowing);
						insertFeedUnfollowList.add(unfollower);
						// Deleting the follower and following records.
						Database.DeleteResult[] unfollowAccount = Database.delete(
							insertFeedUnfollowList,false,AccessLevel.USER_MODE
						);
						// Handling any errors that occur during deletion.
						for (Database.DeleteResult saveResult : unfollowAccount) {
							if (!saveResult.isSuccess()) {
								for (Database.Error error : saveResult.getErrors()) {
									errorMessage += 'Error ' + error.getFields() +
									'--' +	error.getMessage() +'\n';
								}
							}
						}
						// Logging errors if any and throwing an exception.
						if (String.isNotBlank(errorMessage)) {
							BI_SFCOE_LOG_Util.logMessage(
								applicationName,BI_PSPB_FollowUserCtrl.class.toString(),'',
								System.now(),errorMessage,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
							throw new AuraHandledException(errorWhileUnfollowing);
						}
					}
				} else {
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			} else {
				throw new AuraHandledException(errorWhileGettingUser);
			}
		} catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FollowUserCtrl.class.toString(),
				null,System.now());
			throw new AuraHandledException(errorWhileUnfollowing);
		}
	}
}