/*
* @description 		This class is used for reacting to a post,
					fetching reactions for a post, deleting reactions and 
					to fetch accounts that are reacted with particular reactions.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Deepa		05-Dec-2023		Created			Initial development.
* 1.1		Deepa 		01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Deepa		04-Apr-2024		Updated			Catch log added.
* 1.3		Deepa		22-Apr-2024		Updated			Code Review.
* 1.4		Deepa		27-Apr-2024		Updated			Indentation.
*/
public with sharing class BI_PSPB_EmojiReactionCtrl {
	// Static variables initialization.
	private static BI_SFCOE_LOG_App_Settings__c settings =
		BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c : '';
	private static String thumbsup = System.Label.BI_PSP_Thumbsup;
	private static String smile = System.Label.BI_PSP_Smile;
	private static String foldedHands = System.Label.BI_PSP_Foldedhand;
	private static String heart = System.Label.BI_PSP_Heart;
	private static String thinkingFace = System.Label.BI_PSP_Thinkingface;
	private static String following = System.Label.BI_PSP_Following;
	private static String error = System.Label.BI_PSP_ConsoleError;
	private static String noReaction = System.Label.BI_PSP_Noreactions;
	private static String errorMessage = '';
	// Custom labels for all error when thrown exception.
	private static String errorWhileReacting =
		System.Label.BI_PSPB_Eroor_For_React_Post;
	private static String errorWhileGettingAccountId =
		System.Label.BI_PSPB_Error_For_Account;
	private static String errorWhileGettingUser =
		System.Label.BI_PSPB_Error_For_User;
	private static String errorWhileGettingReactions =
		System.Label.BI_PSPB_Error_for_Display_Reaction;
	private static String errorWhileUnreacting =
		System.Label.BI_PSPB_Error_For_Unreact_Post;
	private static String errorWhileGettingFollowStatus =
		System.Label.BI_PSPB_Error_For_Checking_Follow_Status;
	/**
	@description	Used to save a reaction for a particular post.
	@param			reactions - The Reaction that is to be saved.
	@param 			feedItemId - The Id of the post for which the 
					Reaction is being saved.
	@param 			userId - The Id of the user who is saving the Reaction.
	@return			BI_PSP_EmojiReactionController__c - The saved Emoji 
					Reaction record.
					Returns saved record to biPspbMyPost and biPspbAllPost LWC.
	*/
	@AuraEnabled
	public static BI_PSP_EmojiReactionController__c saveEmoji(String reactions,
		String feedItemId, String userId) {
		List < BI_PSP_EmojiReactionController__c > existingReactions;
	BI_PSP_EmojiReactionController__c newReactions;
		try {
			//checking userId and  feedItemId is not null.
			if (String.isNotBlank(userId) && String.isNotBlank(feedItemId) &&
				String.isNotBlank(reactions)) {
			// Get account Id for the user.
			String accountId = BI_PSPB_FeedItemCtrl.getUserAccountId(userId);
				// Check if accountId is not blank
				if (String.isNotBlank(accountId)) {
					// Query if existing reactions there for the given feed item and account.
					existingReactions = [SELECT Id, BI_PSP_ReactionResult__c FROM 
				BI_PSP_EmojiReactionController__c WHERE BI_PSP_FeedItem__c = : feedItemId
				AND BI_PSP_AccountE__c = : accountId WITH USER_MODE LIMIT 1];
					// Check if existing reactions are found.
					if (!existingReactions.isEmpty()) {
						// Update the existing reaction record.
						existingReactions[0].BI_PSP_ReactionResult__c = reactions;
						// update the  records into the database.
						Database.SaveResult[] updateReaction = Database.update(
							new List < BI_PSP_EmojiReactionController__c > {
								existingReactions[0]
					}, false, AccessLevel.USER_MODE);
						// Loop through the save results to check for any errors.
						for (Database.SaveResult saveResult : updateReaction) {
							// Check if the updation was not successful.
							if (!saveResult.isSuccess()) {
								// Loop through the errors for each record.
								for (Database.Error error : saveResult.getErrors()) {
									// Build an error message with the error details.
									errorMessage += 'Error ' + error.getFields() + '--'
										+ error.getMessage() + '\n';
								}
							}
						}
						// Check if there are any error messages generated during the updation.
						if (String.isNotBlank(errorMessage)) {
							BI_SFCOE_LOG_Util.handleDatabaseSaveResults(updateReaction,
								BI_PSPB_EmojiReactionCtrl.class.toString(), System.now());
							throw new AuraHandledException(errorWhileReacting);
						}
						//return the updated value.
						return existingReactions[0];
					} else {
						// Create a new reaction record.
						newReactions =
							new BI_PSP_EmojiReactionController__c(
								BI_PSP_ReactionResult__c = reactions,
								BI_PSP_FeedItem__c = feedItemId, BI_PSP_AccountE__c = accountId);
						// Insert the new reaction record.
						Database.SaveResult[] insertReaction = Database.insert(
							new List < BI_PSP_EmojiReactionController__c > {
								newReactions
							}, false, AccessLevel.USER_MODE);
						// Check for errors during insertion.
						for (Database.SaveResult saveResult : insertReaction) {
							// Check if the insertion was not successful.
							if (!saveResult.isSuccess()) {
								// Loop through the errors for each record.
								for (Database.Error error : saveResult.getErrors()) {
									// Build an error message with the error details.
									errorMessage += 'Error ' + error.getFields() + '--'
										+ error.getMessage() + '\n';
								}
							}
						}
						// Check if there are any error messages generated during the insertion.
						if (String.isNotBlank(errorMessage)) {
							BI_SFCOE_LOG_Util.handleDatabaseSaveResults(insertReaction,
								BI_PSPB_EmojiReactionCtrl.class.toString(), System.now());
							throw new AuraHandledException(errorWhileReacting);
						}
					}
				} else {
					// Throwing exception when account not found.
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			}
			else {
				throw new AuraHandledException(error);
			}
		}
		catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(ex, applicationName,
				BI_PSPB_EmojiReactionCtrl.class.toString(), null, System.now());
			throw new AuraHandledException(errorWhileReacting);
		}
		/** Here 'newReactions' is not checked for null exception as 
			it is handled in LWC.
		*/
		return newReactions;
	}
	/**
	@description	Used to check if the reaction for the post is saved or not.
	@param			feedItemId - The Id of the post for which the
					Reaction is being saved.
	@param 			userId - The Id of the user for whom reactions
					are being retrieved.
	@return 		String - A string representing the reactions for 
					the specified post.
					Returns to biPspbMyPost and biPspbAllPost LWC.
	*/
	@AuraEnabled(cacheable = true)
	public static String getReactionsByFeedItemId(String feedItemId,
		String userId) {
		List < BI_PSP_EmojiReactionController__c > reactions;
		try {
			// Check  feedItemId and userId for not null.
			if ((String.isNotBlank(feedItemId)) &&
				(String.isNotBlank(userId))) {
				// Retrieving the account Id corresponding to the provided User Id.
				String accountId = BI_PSPB_FeedItemCtrl.getUserAccountId(userId);
				if (String.isNotBlank(accountId)) {
					// Query EmojiReactions for the specific feed item and user's account.
					reactions = [SELECT	Id, BI_PSP_ReactionResult__c, BI_PSP_AccountE__c
					FROM BI_PSP_EmojiReactionController__c WHERE 
					BI_PSP_FeedItem__c = : feedItemId AND BI_PSP_AccountE__c = : accountId
					WITH USER_MODE LIMIT 1];
				} else {
					// Throw an exception if account ID retrieval fails.
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			}
			else {
				// Throw a generic exception if feedItemId or userId is blank.
				throw new AuraHandledException(errorWhileGettingUser);
			}
			// Check if any reactions were found.
			if (!reactions.isEmpty()) {
				// Returning reactions when record is found. 
				return reactions[0].BI_PSP_ReactionResult__c;
			}
			else {
				// Return a placeholder value  if no reactions are found.
				return noReaction;
			}
		}
		catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(ex, applicationName,
				BI_PSPB_EmojiReactionCtrl.class.toString(), null, System.now());
			throw new AuraHandledException(error);
		}
	}
	/**
	@description	This is the method to delete the reaction for a post.
	@param 			feedItemId - The Id of the post from which the emoji
					reaction is being deleted.
	@param 			userId - The Id of the user who is deleting the emoji reaction.
	This method is used in biPspbAllPost and biPspbMyPost LWC.
	*/
	@AuraEnabled
	public static void deleteEmojiReaction(String feedItemId, String userId) {
		try {
			// Check for valid feedItemId and userId
			if (String.isNotBlank(feedItemId) &&
				String.isNotBlank(userId)) {
				// Retrieving the account Id corresponding to the provided User Id.
			String accountId = BI_PSPB_FeedItemCtrl.getUserAccountId(userId);
				if (String.isNotBlank(accountId)) {
					// Query EmojiReactions for the specific feed item and user's account
					List < BI_PSP_EmojiReactionController__c > reactions =[SELECT Id,
					BI_PSP_ReactionResult__c, CreatedById, BI_PSP_AccountE__c
					FROM BI_PSP_EmojiReactionController__c WHERE
					BI_PSP_FeedItem__c = : feedItemId AND BI_PSP_AccountE__c = : accountId
					WITH USER_MODE LIMIT 1];
					if (!reactions.isEmpty()) {
						// Delete the reactions.
						Database.DeleteResult[] deleteReaction = Database.delete(
							new List < BI_PSP_EmojiReactionController__c > { reactions[0]},
							false, AccessLevel.USER_MODE);
						// Check for errors during deletion.
						for (Database.DeleteResult saveResult : deleteReaction) {
							if (!saveResult.isSuccess()) {
								for (Database.Error error : saveResult.getErrors()) {
									errorMessage += 'Error ' + error.getFields() + '--'
										+ error.getMessage() + '\n';
								}
							}
						}
						if (String.isNotBlank(errorMessage)) {
							// Log the error message and throw an exception.
							BI_SFCOE_LOG_Util.logMessage(applicationName,
								BI_PSPB_FollowUserCtrl.class.toString(), '', System.now(),
								errorMessage, BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
							throw new AuraHandledException(errorWhileUnreacting);
						}
					}
					else {
						// Throw an exception if no reactions are found to delete.
						throw new AuraHandledException(errorWhileGettingReactions);
					}
				}
				else {
					// Throw an exception if account ID retrieval fails.
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			}
			else {
				// Throw a generic exception if feedItemId or userId is blank.
				throw new AuraHandledException(error);
			}
		}
		catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(ex, applicationName,
				BI_PSPB_EmojiReactionCtrl.class.toString(), null, System.now());
			throw new AuraHandledException(error);
		}
	}
	// We separately Query the Each Reactions for Lwc Notification Functionality.	
	/**
	@description 	To count the total number of thumbs-up 
					reactions for a given feed item.  
	@param 			feedItemId - The Id of the feed item for
					which thumbs-up reactions are counted.
	@return 		List<BI_PSP_EmojiReactionController__c> - A list of 
					thumbs-up reactions.
					Returns to biPspbMyPost and biPspbAllPost LWC.
	*/
	@AuraEnabled
	public static List<BI_PSP_EmojiReactionController__c> totalThumbsup(
		String feedItemId) {
		list < BI_PSP_EmojiReactionController__c > totalThumbsup;
		try {
			//check if the feedItemId is not null.
			if (String.isNotBlank(feedItemId)) {
				// Query to count total thumbs-up reactions for a post.
				totalThumbsup = [SELECT Id, BI_PSP_ReactionResult__c, CreatedById,
					BI_PSP_AccountE__c, BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
					BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c FROM 
					BI_PSP_EmojiReactionController__c WHERE BI_PSP_FeedItem__c = : feedItemId
					AND BI_PSP_ReactionResult__c = : thumbsup
					AND BI_PSP_AccountE__c != null WITH USER_MODE];
					} else {
				// Throw an exception if feedItemId ID is null.
				throw new AuraHandledException(errorWhileGettingReactions);
			}
		}
		catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(ex, applicationName,
				BI_PSPB_EmojiReactionCtrl.class.toString(), null, System.now());
			throw new AuraHandledException(error);
		}
		/** Here 'totalThumbsup' is not checked for null exception as 
			it is handled in LWC.
			There are two different scenario such as it takes an action when 
			it is returned as null and another action when it is returned with values.
		*/
		return totalThumbsup;
	}
	/**
	@description 	To count the total number of smile reactions 
					for a particular post.
	@param 			feedItemId - The Id of the feed item for which 
					smile reactions are counted.
	@return 		List<BI_PSP_EmojiReactionController__c> - A list of 
					smile reactions.
					Returns to biPspbMyPost and biPspbAllPost LWC.
	*/
	@AuraEnabled
	public static List<BI_PSP_EmojiReactionController__c> totalSmile(
		String feedItemId) {
		list < BI_PSP_EmojiReactionController__c > totalSmile;
		try {
			if (String.isNotBlank(feedItemId)) {
				// Fetching all smile emojis for a post.
				totalSmile = [SELECT id, BI_PSP_ReactionResult__c, CreatedById,
					BI_PSP_AccountE__c, BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
					BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c FROM 
		BI_PSP_EmojiReactionController__c WHERE BI_PSP_FeedItem__c = : feedItemId
		AND BI_PSP_ReactionResult__c = : smile AND BI_PSP_AccountE__c != null
		WITH USER_MODE];
			} else {
				// Throw an exception if feedItemId ID is null.
				throw new AuraHandledException(errorWhileGettingReactions);
			}
		}
		catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(ex, applicationName,
				BI_PSPB_EmojiReactionCtrl.class.toString(), null, System.now());
			throw new AuraHandledException(error);
		}
		/** Here 'totalSmile' is not checked for null exception as 
			it is handled in LWC.
			There are two different scenario such as it takes an action when 
			it is returned as null and another action when it is returned with values.
		*/
		return totalSmile;
	}
	/**
	@description 	To count the total number of folded hands reactions 
					for a particular post.
	@param 			feedItemId - The Id of the feed item for which 
					smile reactions are counted.
	@return 		List<BI_PSP_EmojiReactionController__c> - A list of 
					folded hands reactions.
					Returns to biPspbMyPost and biPspbAllPost LWC.
	*/
	@AuraEnabled
	public static List<BI_PSP_EmojiReactionController__c> totalFoldedhands(
		String feedItemId) {
		list < BI_PSP_EmojiReactionController__c > totalFoldedhands;
		try {
			// Query to count total folded hands emoji reactions for a post.
			if (String.isNotBlank(feedItemId)) {
				totalFoldedhands = [SELECT id, BI_PSP_ReactionResult__c,
					CreatedById, BI_PSP_AccountE__c,
					BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
					BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c FROM 
			BI_PSP_EmojiReactionController__c WHERE BI_PSP_FeedItem__c = : feedItemId
			AND BI_PSP_ReactionResult__c = : foldedHands AND BI_PSP_AccountE__c != null
			WITH USER_MODE];
			} else {
				// Throw an exception if feedItemId ID is null.
				throw new AuraHandledException(errorWhileGettingReactions);
			}
		}
		catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(ex, applicationName,
				BI_PSPB_EmojiReactionCtrl.class.toString(), null, System.now());
			throw new AuraHandledException(error);
		}
		/** Here 'totalFoldedhands' is not checked for null exception as 
			it is handled in LWC.
			There are two different scenario such as it takes an action when 
			it is returned as null and another action when 
			it is returned with values.
		*/
		return totalFoldedhands;
	}
	/**
	@description 	To count the total number of heart reactions 
					for a particular post.
	@param 			feedItemId - The Id of the feed item for which 
					heart reactions are counted.
	@return 		List<BI_PSP_EmojiReactionController__c> - A list of 
					heart reactions.
					Returns to biPspbMyPost and biPspbAllPost LWC.
	*/
	@AuraEnabled
	public static List<BI_PSP_EmojiReactionController__c> totalHeart(
		String feedItemId) {
		list < BI_PSP_EmojiReactionController__c > totalHeart;
		try {
			// Query to count total heart reactions for a post.
			if (String.isNotBlank(feedItemId)) {
				totalHeart = [SELECT id, BI_PSP_ReactionResult__c,
					CreatedById, BI_PSP_AccountE__c,
					BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
					BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c FROM
			BI_PSP_EmojiReactionController__c WHERE
			BI_PSP_FeedItem__c = : feedItemId AND BI_PSP_ReactionResult__c = : heart
			AND BI_PSP_AccountE__c != null WITH USER_MODE];
			} else {
				// Throw an exception if feedItemId ID is null.
				throw new AuraHandledException(errorWhileGettingReactions);
			}
		}
		catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(ex, applicationName,
				BI_PSPB_EmojiReactionCtrl.class.toString(), null, System.now());
			throw new AuraHandledException(error);
		}
		/** Here 'totalHeart' is not checked for null exception as 
			it is handled in LWC.
			There are two different scenario such as it takes an action when 
			it is returned as null and another action when it is returned with values.
		*/
		return totalHeart;
	}
	/**
	@description 	To count the total number of thinking face reactions 
					for a particular post.
	@param 			feedItemId - The Id of the feed item for which 
					thinking face reactions are counted.
	@return 		List<BI_PSP_EmojiReactionController__c> - A list of
					thinking face reactions.
					Returns to biPspbMyPost and biPspbAllPost LWC.
	*/
	@AuraEnabled
	public static List<BI_PSP_EmojiReactionController__c> totalThinkingface(
		String feedItemId) {
		List < BI_PSP_EmojiReactionController__c > totalThinkingfaceList;
		try {
			if (String.isNotBlank(feedItemId)) {
				// Query to count total thinking face reactions for a post.
				totalThinkingfaceList = [SELECT Id, BI_PSP_ReactionResult__c, CreatedById,
					BI_PSP_AccountE__c, BI_PSP_AccountE__r.BI_PSP_CommunityUsername__c,
					BI_PSP_AccountE__r.BI_PSP_AvatarUrl__c FROM
			BI_PSP_EmojiReactionController__c WHERE BI_PSP_FeedItem__c = : feedItemId
			AND BI_PSP_ReactionResult__c = : thinkingFace AND BI_PSP_AccountE__c != null
			WITH USER_MODE];
			} else {
				// Throw an exception if feedItemId ID is null.
				throw new AuraHandledException(errorWhileGettingReactions);
			}
		}
		catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(ex, applicationName,
				BI_PSPB_EmojiReactionCtrl.class.toString(), null, System.now());
			throw new AuraHandledException(error);
		}
		/** Here 'totalThinkingfaceList' is not checked for null exception as 
			it is handled in LWC.
			There are two different scenario such as it takes an action when 
			it is returned as null and another action when it is returned with values.
		*/
		return totalThinkingfaceList;
	}
	/**
	@description 	Used to check if the user reacting to the post
					is following the posted user.
	@param 			loggedAccountId - The Id of the logged-in user's account.
	@param 			otherAccountId - The Id of the account being checked for 
					follow status.
	@return 		List<BI_PSP_FeedFollow__c> - A list of feed follow records.
					Returns to biPspbMyPost and biPspbAllPost LWC.
	*/
	@AuraEnabled
	public static List<BI_PSP_FeedFollow__c> checkFollowingStatus(
		String loggedAccountId, String otherAccountId) {
		List < BI_PSP_FeedFollow__c > feedFollowRecords;
		try {
			//check loggedAccountId and otherAccountId is not null.
			if (String.isNotBlank(loggedAccountId)
				&& String.isNotBlank(otherAccountId)) {
				// Query to check if the reacted user is following the posted user.
				feedFollowRecords = [SELECT Id, BI_PSP_Account__c,
					BI_PSP_AccountUser__c, BI_PSP_Type__c FROM BI_PSP_FeedFollow__c
			WHERE BI_PSP_Account__c = : loggedAccountId AND 
			BI_PSP_AccountUser__c = : otherAccountId
			AND BI_PSP_Type__c = : following WITH USER_MODE LIMIT 1];
			} else {
				// Throw an exception if loggedAccountId and otherAccountId is null.
				throw new AuraHandledException(errorWhileGettingFollowStatus);
			}
		}
		catch (Exception ex) {
			// Catch any other exceptions that might occur during the process.
			// Log the exception and throw a general error exception.
			BI_SFCOE_LOG_Util.handleException(ex, applicationName,
				BI_PSPB_EmojiReactionCtrl.class.toString(), null, System.now());
			throw new AuraHandledException(errorWhileGettingFollowStatus);
		}
		/** Here 'feedFollowRecords' is not checked for null exception as 
			it is handled in LWC.
			There are two different scenario such as it takes an action when 
			it is returned as null and another action when it is returned with values.
		*/
		return feedFollowRecords;
	}
}