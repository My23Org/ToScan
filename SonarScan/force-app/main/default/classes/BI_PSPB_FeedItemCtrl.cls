/*
* @description 		This class is used for displaying all posts,
					softdeleting the posts,creating a new post,
					creating a comment for a particular post.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Deepa		05-Dec-2023		Created			Initial development.
* 1.1		Deepa 		01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Deepa		04-Apr-2024		Updated			Catch log added.
* 1.3		Deepa		22-Apr-2024		Updated			Code Review.
* 1.4		Deepa 		27-Apr-2024		Updated			Indentation.
*/
public with sharing class BI_PSPB_FeedItemCtrl {
	// Static variables declaration.
	private static String softDelete = System.Label.BI_PSP_SoftDelete;
	private static BI_SFCOE_LOG_App_Settings__c settings = 
	BI_SFCOE_LOG_App_Settings__c.getValues('PSPB');
	private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c : '';
	// Custom labels for all error when thrown exception.
	private static String follow = System.Label.BI_PSP_Follow;
	private static String following = System.Label.BI_PSP_Following;
	private static String error = System.Label.BI_PSP_ConsoleError;
	private static String errorMessage = '';
	private static String errorWhileDeleting =
	System.Label.BI_PSPB_Error_For_Post_Deletion;
	private static String errorWhileFetchingPost =
	System.Label.BI_PSPB_Error_For_Post_Selection;
	private static String errorWhileGettingAccountId =
	System.Label.BI_PSPB_Error_For_Account;
	private static String errorWhileCreatingPost =
	System.Label.BI_PSPB_Error_For_Post_Creation;
	private static String errorWhileGettingUser =
	System.Label.BI_PSPB_Error_For_User;
	private static String errorWhileCreatingComment =
	System.Label.BI_PSPB_Error_For_Commenting;
	private static String errorWhileGettingComment =
	System.Label.BI_PSPB_Error_For_Comment;
	private static String errorWhileEditingComment =
	System.Label.BI_PSPB_Error_For_Updating;
	private static String errorWhileDeletingComment =
	System.Label.BI_PSPB_Error_For_Delete;
	/**
	* @description	Used to softdelete a post from the database.
	* @param		feedItemId - The Id	of the post to be soft deleted.
	This method is used in biPspbMyPost LWC.
	*/
	@AuraEnabled
	public static void softDeleteFeedItem(String feedItemId) {
		try {
			if (String.isNotBlank(feedItemId)) {
				// Fetching the post of this Id, that is to be deleted.
				BI_PSP_FeedItem__c feedItemToUpdate = [
					SELECT Id, BI_PSP_SoftDelete__c FROM BI_PSP_FeedItem__c
					WHERE Id = :feedItemId WITH USER_MODE];
				if (feedItemToUpdate != null) {
					// Updating the 'BI_PSP_SoftDelete__c' field to softdelete the post.
					feedItemToUpdate.BI_PSP_SoftDelete__c = softDelete;
					Database.SaveResult[] updateFeedItem = Database.update(
						new List<BI_PSP_FeedItem__c>{ feedItemToUpdate },false,
						AccessLevel.USER_MODE);
					for (Database.SaveResult saveResult : updateFeedItem) {
						if (!saveResult.isSuccess()) {
							// Handling errors if any during update operation.
							for (Database.Error error : saveResult.getErrors()) {
								errorMessage +='Error ' +error.getFields() +'--' +
									error.getMessage() +'\n';}
						}
					}
					if (String.isNotBlank(errorMessage)) {
						// Handling error if occurred during update operation.
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
							updateFeedItem,BI_PSPB_FeedItemCtrl.class.toString(),
							System.now());
						throw new AuraHandledException(errorWhileDeleting);
					}
				} else {
					// Throwing exception when post is not found.
					throw new AuraHandledException(errorWhileFetchingPost);
				}
			} else {
				// Throwing exception when post is not deleted.
				throw new AuraHandledException(errorWhileDeleting);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,
			BI_PSPB_FeedItemCtrl.class.toString(),null,System.now());
			throw new AuraHandledException(errorWhileDeleting);
		}
	}
	/**
	* @description		Used to create a post with category and 
						subcategory for that user.
	* @param			category - The	category of	the	post.
	* @param			subcategory - The subcategory of the post.
	* @param			userId - The user ID associated with the post.
	This method is used in biPspbCreatePost LWC.
	*/
	@AuraEnabled
	public static void insertFeedItem(String category,
		String subcategory,String userId) {
		BI_PSP_FeedItem__c newFeedItem;
		try {
			if (String.isNotBlank(category) && String.isNotBlank(subcategory) &&
				String.isNotBlank(userId)) {
				// Getting account Id for the user.
				String accountId = getUserAccountId(userId);
				if (String.isNotBlank(accountId)) {
					//Creating new post with the entered category and sub category by the user.
					newFeedItem = new BI_PSP_FeedItem__c(
						BI_PSP_Phrase__c = subcategory,BI_PSP_Category__c = category,
						BI_PSP_AccountR__c = accountId);
					Database.SaveResult[] createFeedItem = Database.insert(
						new List<BI_PSP_FeedItem__c>{ newFeedItem },false,
						AccessLevel.USER_MODE);
					//	Check if any errors	occurred during	insertion.
					for (Database.SaveResult saveResult : createFeedItem) {
						if (!saveResult.isSuccess()) {
							for (Database.Error error : saveResult.getErrors()) {
								errorMessage +='Error ' +error.getFields() +
									'--' +error.getMessage() +'\n';
							}
						}
					}
					if (String.isNotBlank(errorMessage)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
							createFeedItem,BI_PSPB_FeedItemCtrl.class.toString(),
							System.now());
						// Throwing exception when post is not created.
						throw new AuraHandledException(errorWhileCreatingPost);
					}
				} else {
					// Throwing exception when account is not found.
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			} else {
				// Throwing exception when post is not found.
				throw new AuraHandledException(errorWhileFetchingPost);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,
				BI_PSPB_FeedItemCtrl.class.toString(),null,System.now());
			throw new AuraHandledException(errorWhileCreatingPost);
		}
	}
	/**
	* @description	Used to get all posts that are created by the logged 
					in user to display in mypost.
	* @param		userId - The ID of the user for which to retrieve post 
					details.
	* @return		List<BI_PSP_FeedItem__c> - List of posts that are created 
					by the logged in user.
					The list is returned to biPspbMyPost LWC.
	*/
	@AuraEnabled(cacheable=true)
	public static List<BI_PSP_FeedItem__c> myPost(string userId) {
		List<BI_PSP_FeedItem__c> filteredResults;
		try {
			if (String.isNotBlank(userId)) {
				// Getting account Id of the user.
				String accountId = getUserAccountId(userId);
				if (String.isNotBlank(accountId)) {
					/** List of posts that are created by the logged in user
					 with reactions and comments.*/
					List<BI_PSP_FeedItem__c> myPostRecords = [
						SELECT Id,BI_PSP_Category__c,BI_PSP_Phrase__c,
							BI_PSP_SoftDelete__c,OwnerId,CreatedDate,
							CreatedBy.BI_PSP_CommunityUserName__c,
							(SELECT Id, BI_PSP_Comment__c, BI_PSP_CommentDelete__c
								FROM BI_PSP_FeedComment__r WHERE 
								BI_PSP_CommentDelete__c != :softDelete),
							(SELECT Id, BI_PSP_ReactionResult__c FROM 
							BI_PSP_EmojiReactionController__r) FROM BI_PSP_FeedItem__c
						WHERE BI_PSP_AccountR__c = :accountId WITH USER_MODE
						ORDER BY CreatedDate DESC];
					if (!myPostRecords.isEmpty()) {
						filteredResults = new List<BI_PSP_FeedItem__c>();
						for (BI_PSP_FeedItem__c item : myPostRecords) {
							if (item.BI_PSP_SoftDelete__c != softDelete) {
								filteredResults.add(item);
							}
						}
					} else {
						// Throwing error when post is not found.
						throw new AuraHandledException(errorWhileFetchingPost);
					}
				} else {
					// Throwing error when account not found.
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			} else {
				// Throwing error when user not found.
				throw new AuraHandledException(errorWhileGettingUser);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FeedItemCtrl.class.toString(),
				null,System.now());
			throw new AuraHandledException(errorWhileFetchingPost);
		}
		/** Here 'filteredResults' is not checked for null exception as 
				it is handled in LWC.
				There are two different scenario such as it takes an action when 
				it is returned as null and another action when it is returned with values.
		*/
		return filteredResults;
	}
	/**		
	* @description	Used to fetch all posts from database.Fetch and display 
					allposts and also display if the poster is 
					already being Followed by the current user.
	* @param		userId - The ID	of	the	user for which	to	retrieve post 
					details.
	* @return		List<BI_PSP_FeedItem__c> List of posts	that are to	
					be	displayed in All post page.
					List is returned to biPspbAllPost LWC.
	*/
	@AuraEnabled(cacheable=true)
	public static List<BI_PSP_FeedItem__c> getAllPost(String userId) {
		List<BI_PSP_FeedItem__c> filteredResults;
		try {
			if (String.isNotBlank(userId)) {
				// Getting account Id of the user.
				String accountId = getUserAccountId(userId);
				if (String.isNotBlank(accountId)) {
					// List of all posts with comments and reactions.
					List<BI_PSP_FeedItem__c> allPostRecords = [
						SELECT Id,BI_PSP_Category__c,BI_PSP_Phrase__c,
							BI_PSP_FollowStatus__c,BI_PSP_SoftDelete__c,OwnerId,
							CreatedBy.Username,CreatedBy.FirstName,CreatedBy.LastName,
							CreatedBy.BI_PSP_CommunityUserName__c,BI_PSP_AccountR__c,
							CreatedById,CreatedDate,BI_PSP_AccountR__r.BI_PSP_AvatarUrl__c,
							BI_PSP_AccountR__r.BI_PSP_CommunityUsername__c,
							(SELECT Id, BI_PSP_Comment__c, BI_PSP_CommentDelete__c
								FROM BI_PSP_FeedComment__r WHERE 
								BI_PSP_CommentDelete__c != :softDelete),
							(SELECT Id, BI_PSP_ReactionResult__c FROM 
							BI_PSP_EmojiReactionController__r)
						FROM BI_PSP_FeedItem__c WHERE BI_PSP_AccountR__c != NULL
						WITH USER_MODE ORDER BY CreatedDate DESC];
					filteredResults = new List<BI_PSP_FeedItem__c>();
					//Fetching follow status.
					List<BI_PSP_FeedFollow__c> currentUserFollowing = [
						SELECT Id, BI_PSP_AccountUser__c FROM BI_PSP_FeedFollow__c
						WHERE BI_PSP_Account__c = :accountId AND BI_PSP_Type__c = :following
						WITH USER_MODE];
					Set<Id> followingUserIds = new Set<Id>();
						for (BI_PSP_FeedFollow__c followRecord : currentUserFollowing) {
							followingUserIds.add(followRecord.BI_PSP_AccountUser__c);
						}
						for (BI_PSP_FeedItem__c item : allPostRecords) {
							if (
								item.BI_PSP_SoftDelete__c != softDelete &&
								item.BI_PSP_Category__c != null && item.BI_PSP_Phrase__c != null
							) {
								//	Check if the creator of	the	post is	being followed.
								if (followingUserIds.contains(item.BI_PSP_AccountR__c)) {
									item.BI_PSP_FollowStatus__c = following;
								} else {
									item.BI_PSP_FollowStatus__c = follow;
								}
								filteredResults.add(item);
							}
						}
				} else {
					// Throwing error when account not found.
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			} else {
				// Throwing error when user not found.
				throw new AuraHandledException(errorWhileGettingUser);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FeedItemCtrl.class.toString(),
				null,System.now());
			throw new AuraHandledException(errorWhileFetchingPost);
		}
		/** Here 'filteredResults' is not checked for null exception as 
			it is handled in LWC.
			There are two different scenario such as it takes an action when 
			it is returned as null and another action when it is returned with values.
		*/
		return filteredResults;
	}
	/**
	* @description	Used to insert the comments for a particular post.
	* @param		commentContent - The content of	the	comment	
					to	be	inserted.
	* @param		postId - The ID	of	the	post to	which the comment belongs.
	* @param		userId - The ID	of	the	user who is	inserting the comment.
	This method is used in biPspbCreatePost LWC.
	*/
	@AuraEnabled
	public static void insertComment(
		String commentContent,String postId,string userId) {
		BI_PSP_FeedComment__c createComment;
		try {
			if ((String.isNotBlank(commentContent)) && (String.isNotBlank(postId)) &&
				(String.isNotBlank(userId))) {
				// Getting account Id of the user.
				String accountId = getUserAccountId(userId);
				if (String.isNotBlank(accountId)) {
					// Create a comment for a post.
					createComment = new BI_PSP_FeedComment__c();
					createComment.BI_PSP_Comment__c = commentContent;
					createComment.BI_PSP_FeedItem__c = postId;
					createComment.BI_PSP_AccountCmt__c = accountId;
					Database.SaveResult[] createCommentRecord = Database.insert(
						new List<BI_PSP_FeedComment__c>{ createComment },false,
						AccessLevel.USER_MODE);
					//	Check if any errors	occurred during	insertion.
					for (Database.SaveResult saveResult : createCommentRecord) {
						if (!saveResult.isSuccess()) {
							for (Database.Error error : saveResult.getErrors()) {
								errorMessage +='Error ' +error.getFields() +
									'--' +error.getMessage() +'\n';
							}
						}
					}
					if (String.isNotBlank(errorMessage)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
							createCommentRecord,BI_PSPB_FeedItemCtrl.class.toString(),
							System.now());
						// Throwing error when comment is not created.
						throw new AuraHandledException(errorWhileCreatingComment);
					}
				} else {
					// Throwing error when account not found.
					throw new AuraHandledException(errorWhileGettingAccountId);
				}
			} else {
				// Throwing error when post is not found.
				throw new AuraHandledException(errorWhileFetchingPost);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FeedItemCtrl.class.toString(),
				null,System.now());
			throw new AuraHandledException(errorWhileCreatingComment);
		}
	}
	/**
	* @description	Used to fetch all the comments for each post.
	* @param		feedItemId - The ID of the post for which to retrieve 
					comments.
	* @return		List<BI_PSP_FeedComment__c>	- List	of	comments for that 
					particular post.
					List is returned to biPspbAllPost and biPspbMyPost LWC.
	*/
	@AuraEnabled
	public static list<BI_PSP_FeedComment__c> viewComments(string feedItemId) {
		list<BI_PSP_FeedComment__c> comments;
		try {
			if (String.isNotBlank(feedItemId)) {
				// Comments of the particular posts.
				comments = [
					SELECT id,BI_PSP_Comment__c,BI_PSP_CommentDelete__c,
					CreatedDate,CreatedById,BI_PSP_FeedItem__c,
					BI_PSP_AccountCmt__r.BI_PSP_AvatarUrl__c,
					BI_PSP_AccountCmt__r.BI_PSP_CommunityUsername__c,BI_PSP_AccountCmt__c
					FROM BI_PSP_FeedComment__c WHERE
					BI_PSP_FeedItem__c = :feedItemId AND 
					BI_PSP_CommentDelete__c != :softDelete AND BI_PSP_AccountCmt__c != NULL
					WITH USER_MODE ORDER BY CreatedDate DESC];
			} else {
				// Throwing error when post not found.
				throw new AuraHandledException(errorWhileFetchingPost);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FeedItemCtrl.class.toString(),
				null,System.now());
			throw new AuraHandledException(errorWhileGettingComment);
		}
		/** Here 'comments' is not checked for null exception as 
			it is handled in LWC.
			There are two different scenario such as it takes an action when 
			it is returned as null and another action when it is returned with values.
		*/
		return comments;
	}
	/**
	* @description		Used to	update the existing comment for a post.
	* @param			commentToUpdate - The string of	the	comment	that 
						is to be updated.
	* @param			commentId - The	ID	of	the	comment	to	be	edited.
	* @return			BI_PSP_FeedComment__c - The	edited	feed comment record.
						List is returned to biPspbAllPost and biPspbMyPost LWC.
	*/
	@AuraEnabled
	public static BI_PSP_FeedComment__c editComment(String commentToUpdate,
	String commentId) {
		BI_PSP_FeedComment__c commentToEdit;
		try {
			if (
				(String.isNotBlank(commentToUpdate)) && (String.isNotBlank(commentId))
			) {
				// Fetching the comment that is to be updated.
				commentToEdit = [
					SELECT id, BI_PSP_Comment__c FROM BI_PSP_FeedComment__c
					WHERE id = :commentId WITH USER_MODE];
				if (commentToEdit != null) {
					commentToEdit.BI_PSP_Comment__c = commentToUpdate;
					Database.SaveResult[] updateComment = Database.update(
						new List<BI_PSP_FeedComment__c>{ commentToEdit },false,
						AccessLevel.USER_MODE);
					//	Check if any errors	occurred during	updation.
					for (Database.SaveResult saveResult : updateComment) {
						if (!saveResult.isSuccess()) {
							for (Database.Error error : saveResult.getErrors()) {
								errorMessage +='Error ' +error.getFields() +
									'--' +error.getMessage() +'\n';
							}
						}
					}
					if (String.isNotBlank(errorMessage)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
							updateComment,BI_PSPB_FeedItemCtrl.class.toString(),
							System.now());
						// Throwing error while editing comment.
						throw new AuraHandledException(errorWhileEditingComment);
					}
				} else {
					// Throwing error when comments not found.
					throw new AuraHandledException(errorWhileGettingComment);
				}
			} else {
				throw new AuraHandledException(error);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FeedItemCtrl.class.toString(),
				null,System.now());
			throw new AuraHandledException(errorWhileEditingComment);
		}
		/** Here 'commentToEdit' is not checked for null exception as 
				it is handled in LWC.
			*/
		return commentToEdit;
	}
	/**
	* @description	Used to	softdelete a comment from particular post.
	* @param		feedCommentItemId -	The	ID of the feed comment 
					item to be soft deleted.
	This method is used in biPspbMyPost,biPspbAllPost LWC.
	*/
	@AuraEnabled
	public static void softDeleteFeedCommentItem(String feedCommentItemId) {
		try {
			if (String.isNotBlank(feedCommentItemId)) {
				// Fetchig the comment that is to be deleted.
				BI_PSP_FeedComment__c feedCommentItemToUpdate = [
					SELECT Id, BI_PSP_CommentDelete__c FROM BI_PSP_FeedComment__c
					WHERE Id = :feedCommentItemId WITH USER_MODE];
				if (feedCommentItemToUpdate != null) {
					feedCommentItemToUpdate.BI_PSP_CommentDelete__c = softDelete;
					Database.SaveResult[] deletePost = Database.update(
						new List<BI_PSP_FeedComment__c>{ feedCommentItemToUpdate },false,
						AccessLevel.USER_MODE);
					//	Check if any errors	occurred during	updation.
					for (Database.SaveResult saveResult : deletePost) {
						if (!saveResult.isSuccess()) {
							for (Database.Error error : saveResult.getErrors()) {
								errorMessage +='Error ' +error.getFields() +
								'--' +error.getMessage() +'\n';
							}
						}
					}
					if (String.isNotBlank(errorMessage)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
							deletePost,BI_PSPB_FeedItemCtrl.class.toString(),
							System.now());
						// Throwing error while deleting comments.
						throw new AuraHandledException(errorWhileDeletingComment);
					}
				} else {
					// Throwing error when comment not found.
					throw new AuraHandledException(errorWhileGettingComment);
				}
			} else {
				// Throwing error when comment not found.
				throw new AuraHandledException(errorWhileGettingComment);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FeedItemCtrl.class.toString(),
				null,System.now());
			throw new AuraHandledException(error);
		}
	}
	/**
	* @description	Used to	fetch list of comment options for a	particular	post.
	* @param		feedItemId - The ID	of the	post  for which	to 
					retrieve	comment	options.
	* @return		list<BI_PSP_FeedItem__c> - List of	BI_PSP_FeedItem__c	
					objects	representing comment options.
					List is returned to biPspbMyPost LWC.
	*/
	@AuraEnabled(cacheable=true)
	public static list<BI_PSP_FeedItem__c> getCommentOptions(string feedItemId) {
		list<BI_PSP_FeedItem__c> feed;
		try {
			if (String.isNotBlank(feedItemId)) {
				// List of comment options for respective category and sub-category.
				feed = [SELECT id, BI_PSP_Phrase__c, BI_PSP_Category__c FROM 
				BI_PSP_FeedItem__c WHERE id = :feedItemId WITH USER_MODE];
				if (feed.isEmpty()) {
					throw new AuraHandledException(errorWhileGettingComment);
				}
			} else {
				throw new AuraHandledException(errorWhileGettingComment);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,applicationName,BI_PSPB_FeedItemCtrl.class.toString(),
				null,System.now());
			throw new AuraHandledException(error);
		}
		return feed;
	}
	/**
	* @description	Used to	get	user Id	and	check for the associated account Id.
	* @param		userId - The Id	of the logged-in user.
	* @return		Id - Account Id	of the	user.
					Id is returned to LWC such as biPspbMyPost,biPspbAllPost,
					BI_PSPB_InsertCaserecordforUpdateRx and biPspbNotificSetting and 
					apex classes such as BI_PSPB_FeedItemCtrl,BI_PSPB_FollowUserCtrl,
					BI_PSPB_CommunityUsername and BI_PSPB_EmojiReactionCtrl LWC.
	*/
	@AuraEnabled(cacheable=true)
	public static Id getUserAccountId(String userId) {
		String accountId = null;
		try {
			/** Here userId is checked for null value as it is passed from multiple 
			methods from various classes.*/
			if (String.isNotBlank(userId)) {
				// User Id of the logged in user.
				/**Custom fields are not visibile in UserInfo hence using SOQL
				 to get Custom field from User Object.*/
				List<User> loggedInUser = [SELECT Id, Name, Email, BI_PSPB_Caregiver__c
					FROM User WHERE Id = :userId WITH USER_MODE LIMIT 1];
				//	Checking whether logged	in	user list is not empty.
				if (!loggedInUser.isEmpty()) {
					User user = loggedInUser[0];
					if (user.Name != null && user.Email != null && 
						user.BI_PSPB_Caregiver__c == false) {
						//	Query	for	an	account	based	on	user's	Name and Email.
						Account accountOfUser = [
							SELECT Id, Name, PersonEmail FROM Account WHERE 
							Name = :user.Name AND PersonEmail = :user.Email WITH USER_MODE LIMIT 1];
						/** Check if user's	Name and Email match with account's
						Name and PersonEmail.*/
						if (accountOfUser != null) {
							accountId = accountOfUser.Id;
						}
					} else {
						//	Query for related BI_PSPB_Enrollee_Caregiver__c	records.
						List<BI_PSPB_Enrollee_Caregiver__c> caregiverRecords = [
							SELECT Id,Name,
							BI_PSPB_Caregiver__r.BI_PSPB_Selected_Patient_ID__c
							FROM BI_PSPB_Enrollee_Caregiver__c WHERE
							BI_PSPB_Caregiver__r.Name = :user.Name
							AND BI_PSPB_Caregiver__r.PersonEmail = :user.Email
							AND BI_PSPB_Caregiver__r.BI_PSPB_Selected_Patient_ID__c != NULL
							WITH USER_MODE];
						if (!caregiverRecords.isEmpty()) {
							accountId = caregiverRecords[0]
							.BI_PSPB_Caregiver__r.BI_PSPB_Selected_Patient_ID__c;
						}
					}
					if (String.isBlank(accountId)) {
						BI_SFCOE_LOG_Util.logMessage(applicationName,
							BI_PSPB_FeedItemCtrl.class.toString(),'',
							System.now(),errorWhileGettingAccountId,
							BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSPB_FeedItemCtrl.class.toString(),'',
						System.now(),errorWhileGettingUser,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_FeedItemCtrl.class.toString(),'',
					System.now(),errorWhileGettingUser,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				throw new AuraHandledException(errorWhileGettingUser);
			}
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,
				applicationName,BI_PSPB_FeedItemCtrl.class.toString(),
				null,System.now());
			throw new AuraHandledException(errorWhileGettingAccountId);
		}
		/** Here 'accountId' is not checked for null exception as 
			it is handled in LWC and apex classes to which they are returned.
		*/
		return accountId;
	}
}