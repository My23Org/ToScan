/**
@description	This class contains test methods to verify the functionality of 
				methods related to reacting to the posts  and fetching reactions 
				with valid and invalid inputs.
@author					Deepa
@Last Modified On   	04/28/2024
@Last Modified By 		Deepa
*/
@isTest
public class BI_PSPB_EmojiReactionCtrlTest {
	// Test data variables
	public static User testUserPatient;	
	public static User testUserCaregiver;
	public static User testUserWithoutAccount;
	public static Account testAccount;
	public static Account testAccountWithCommunityUsername;
	public static Contact contactForPatient;
	public static Contact contactForCaregiver;
	public static Contact contactForPatientWithoutAccount;
	// Constructor to create test data.
	static {
		// Creating user as a Patient.
		testUserPatient = new User(
			FirstName = 'TestUser12',LastName = 'LastName12',
			Email = 'testuser12@example.com',UserName = 'testuser12@example.com',
			BI_PSPB_Caregiver__c = false,Alias = 'tuser1',EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',ProfileId = 
			[SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile'].Id);
		// Creating user as a Caregiver.
		testUserCaregiver = new User(FirstName = 'TestUser23',
			LastName = 'LastName23',Email = 'testuser23@example.com',
			UserName = 'testuser23@example.com',BI_PSPB_Caregiver__c =true,
			Alias = 'tuser2',EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',ProfileId = 
			[SELECT Id FROM Profile WHERE Name ='BI_PSP_Caregiver Profile'].Id);
		// Creating user as a patient without account.
		testUserWithoutAccount = new User(
			FirstName = 'TestUser',
			LastName = 'WithoutAccount',
			Email = 'testuserwithoutaccount@example.com',
			Username = 'testuserwithoutaccount@example.com',
			BI_PSPB_Caregiver__c = true,Alias = 'tuser2',
			EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = [
				SELECT Id FROM Profile WHERE Name = 'BI_PSP_Caregiver Profile'].Id);
		// Creating contact for Patient.
		contactForPatient = new Contact(
			FirstName = testUserPatient.FirstName,LastName = testUserPatient.LastName,
			Email = testUserPatient.Email);
		// Creating contact for Caregiver.
		contactForCaregiver = new Contact(
			FirstName = testUserCaregiver.FirstName,
			LastName = testUserCaregiver.LastName,Email = testUserCaregiver.Email);
		// Contact for patient without account.
		contactForPatientWithoutAccount = new Contact(
			FirstName = testUserWithoutAccount.FirstName,
			LastName = testUserWithoutAccount.LastName,
			Email = testUserWithoutAccount.Email);
		insert contactForPatient;
		insert contactForCaregiver;
		insert contactForPatientWithoutAccount;
		// Assigning contacts to the respective user.
		testUserPatient.ContactId = contactForPatient.Id;
		testUserCaregiver.ContactId = contactForCaregiver.Id;
		testUserWithoutAccount.ContactId = contactForPatientWithoutAccount.Id;
		insert testUserPatient;
		insert testUserCaregiver;
		insert testUserWithoutAccount;
		// Creating account for Patient.
		testAccount = new Account(
			FirstName = 'TestUser12',LastName = 'LastName12',
			PersonEmail = 'testuser12@example.com',RecordTypeId = 
			[SELECT Id FROM RecordType WHERE SObjectType = 'Account'AND 
			Name = 'Person Account'].Id,OwnerId = testUserPatient.Id);
		// Creating account for Caregiver.
		testAccountWithCommunityUsername = new Account(
			FirstName = 'TestUser23',LastName = 'LastName23',
			PersonEmail = 'testuser23@example.com',
			BI_PSPB_Selected_Patient_ID__c = testAccount.Id,
			RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account'
			AND Name = 'Person Account'].Id,OwnerId = testUserCaregiver.Id,
			BI_PSP_CommunityUsername__c = 'patient1',BI_PSP_AvatarUrl__c=
			'/Branded/resource/1702471083000/BI_PSPB_AfroMan_Adult');
		insert testAccount;
		insert testAccountWithCommunityUsername;
		// Creating mock BI_SFCOE_LOG_App_Settings__c record.
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo');
		insert settings;
	}
	/**
	* @description Test method to verify the behavior of saving emoji
	with valid input.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest	
	static void testSaveEmojis() {
		System.runAs(testUserPatient){
			// Creating post without reaction.
			BI_PSP_FeedItem__c feedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category');
			insert feedItem;
			// Creating reactions for the above post.
			BI_PSP_EmojiReactionController__c testEmoji = 
			new BI_PSP_EmojiReactionController__c(BI_PSP_ReactionResult__c = '12',
				BI_PSP_FeedItem__c = feedItem.Id);
			insert testEmoji;	
		Test.startTest();
			// Method called with valid input.
			BI_PSP_EmojiReactionController__c result = 
			BI_PSPB_EmojiReactionCtrl.saveEmoji('1', feedItem.Id, testUserPatient.Id);
		Test.stopTest();
		// Fetching list of reactions for that post after reacting.
		BI_PSP_EmojiReactionController__c expectedRecord = 
			[SELECT Id,BI_PSP_ReactionResult__c,BI_PSP_FeedItem__c,BI_PSP_AccountE__c
			FROM BI_PSP_EmojiReactionController__c
			WHERE BI_PSP_FeedItem__c = :feedItem.Id
			AND BI_PSP_AccountE__c = :testAccount.Id];
		// Checking for reactions that is updated.
		Assert.areEqual(expectedRecord,result,'Reactions updated for this post');
		}
	}
	/**
	* @description Test method to verify the behavior of the saveEmoji method
	with invalid input to cover exception.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmojiException() {
		System.runAs(testUserPatient){
			try{
				// Creating post for reacting.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category');
				insert testFeedItem;
				Test.startTest();
					// Method call with null value for reaction.
					BI_PSPB_EmojiReactionCtrl.saveEmoji(null,
					testFeedItem.Id,testUserPatient.Id);
				Test.stopTest();
				}
			catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the saveEmoji method
	with invalid input to throw exception while reacting.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmojiThrow() {
		System.runAs(testUserPatient){
			try{
				// Creating post for reacting.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category');
				insert testFeedItem;
				Test.startTest();
					// Method call with more than 20 characters value for reaction.
					BI_PSPB_EmojiReactionCtrl.saveEmoji(
						'Neededmorethan20characterstothrowexception',testFeedItem.Id,
						testUserPatient.Id);
				Test.stopTest();
				}
			catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the saveEmoji method
	with invalid input to throw exception while updating reaction.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmojiUpdatingThrow() {
		System.runAs(testUserPatient){
			try{
				// Creating post for reacting.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category');
				insert testFeedItem;
				// Creating a reaction for the above post.
				BI_PSP_EmojiReactionController__c existingReaction =
				new BI_PSP_EmojiReactionController__c(
					BI_PSP_ReactionResult__c = '1',BI_PSP_FeedItem__c = testFeedItem.Id,
					BI_PSP_AccountE__c = testAccount.Id);
				insert existingReaction;
				Test.startTest();
					// Method call with more than 20 characters value for reaction.
					BI_PSPB_EmojiReactionCtrl.saveEmoji(
						'Neededmorethan20characterstothrowexception',testFeedItem.Id,
						testUserPatient.Id);
				Test.stopTest();
				}
			catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the saveEmoji method
	with valid input to update the reaction over the existing reaction.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmojiForExistingReaction() {
		System.runAs(testUserPatient){
			// Creating post for reacting.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category');
			insert testFeedItem;
			// Creating a reaction for the above post.
			BI_PSP_EmojiReactionController__c existingReaction =
			new BI_PSP_EmojiReactionController__c(
				BI_PSP_ReactionResult__c = '1',BI_PSP_FeedItem__c = testFeedItem.Id,
				BI_PSP_AccountE__c = testAccount.Id);
			insert existingReaction;
			Test.startTest();
				// Method call to react for that post.
				BI_PSPB_EmojiReactionCtrl.saveEmoji('4',testFeedItem.Id,
				testUserPatient.Id);
			Test.stopTest();
			// Retrieving the updated existing reaction record.
			existingReaction = [SELECT Id, BI_PSP_ReactionResult__c FROM 
			BI_PSP_EmojiReactionController__c WHERE Id = :existingReaction.Id];
			// Verify the result
			Assert.areequal('4', existingReaction.BI_PSP_ReactionResult__c,
			'Existing reaction record is updated');
		}
	}
	/**
	* @description Test method to verify the behavior of the saveEmoji method
	with invalid input as user without account.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmojiForUserWithoutAccount() {
		System.runAs(testUserPatient){
			try{
			// Creating post for reacting.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category');
				insert testFeedItem;
				Test.startTest();
					// Method call to react for that post.
					BI_PSPB_EmojiReactionCtrl.saveEmoji('4',testFeedItem.Id,
					testUserWithoutAccount.Id);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	getReactionsByFeedItemId method with valid and invalid input.
	* This method tests the retrieval of emoji reactions by feed item ID.
	*/
	@isTest
	static void testgetReactionsByFeedItemId() {
		System.runAs(testUserPatient){
			// Creating post.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category');
			insert testFeedItem;
			// Creating one reaction for the above post.
			BI_PSP_EmojiReactionController__c firstReaction =
				new BI_PSP_EmojiReactionController__c();
				firstReaction.BI_PSP_FeedItem__c = testFeedItem.Id;
				firstReaction.BI_PSP_ReactionResult__c = '3';
				firstReaction.BI_PSP_AccountE__c = testAccount.Id ;
			insert firstReaction;
			// Creating another reaction for the above post.
			BI_PSP_EmojiReactionController__c secondReaction =
				new BI_PSP_EmojiReactionController__c();
				secondReaction.BI_PSP_FeedItem__c = testFeedItem.Id;
				secondReaction.BI_PSP_ReactionResult__c = '3';
				secondReaction.BI_PSP_AccountE__c = testAccountWithCommunityUsername.Id ;
			insert secondReaction;
			Test.startTest();
				// Method call for fetching reactions with valid input.
				String result = BI_PSPB_EmojiReactionCtrl.getReactionsByFeedItemId(
					testFeedItem.Id,testUserPatient.Id);
				// Method call for fetching reactions with invalid input.
				String exceptionResult = BI_PSPB_EmojiReactionCtrl.getReactionsByFeedItemId(
					'invalidid', testUserPatient.Id);
			Test.stopTest();
			// Checking for the reactions for that post.
			Assert.areequal('3', result, 
			'The reaction result should match the expected value');
			// Checking for the result without reaction.
			Assert.areequal('No reaction yet', exceptionResult,
			'The method should return no reaction yet ');
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	getReactionsByFeedItemId method with invalid input as user without account.
	* This method tests the retrieval of emoji reactions by feed item ID.
	*/
	@isTest
	static void testgetReactionsForUserWithoutAccount() {
		System.runAs(testUserPatient){
			try{
				// Creating post.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',
					BI_PSP_Category__c = 'Test Category');
				insert testFeedItem;
				Test.startTest();
					// Method call for fetching reactions with valid input.
					BI_PSPB_EmojiReactionCtrl.getReactionsByFeedItemId(
						testFeedItem.Id,testUserWithoutAccount.Id);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	getReactionsByFeedItemId method with invalid input as null value.
	* This method tests the retrieval of emoji reactions by feed item ID.
	*/
	@isTest
	static void testgetReactionNull() {
		System.runAs(testUserPatient){
			try{
				// Creating post.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',
					BI_PSP_Category__c = 'Test Category');
				insert testFeedItem;
				Test.startTest();
					// Method call for fetching reactions with valid input.
					BI_PSPB_EmojiReactionCtrl.getReactionsByFeedItemId(
					null,null);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	deleteemojireaction method with valid and invalid inputs.
	* This method tests deletion of emoji reactions by feed item ID.
	*/
	@isTest
	static void testDeleteEmojiReaction() {
		System.runAs(testUserPatient){
			// Creating post.
			BI_PSP_FeedItem__c postRecord = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category',
				BI_PSP_SoftDelete__c = 'No');
			insert postRecord;
			// Creating reaction for that post.
			BI_PSP_EmojiReactionController__c firstReaction = 
				new BI_PSP_EmojiReactionController__c(BI_PSP_ReactionResult__c = '1',
				BI_PSP_FeedItem__c = postRecord.Id,BI_PSP_AccountE__c = testAccount.Id);
			insert firstReaction;
			Test.startTest();
				// Method call with valid input.
				BI_PSPB_EmojiReactionCtrl.deleteemojireaction(postRecord.Id,
				testUserPatient.Id);
			Test.stopTest();
			// Fetching reaction to check that is deleted or not.
			List<BI_PSP_EmojiReactionController__c> reactionDeleted = [
				SELECT Id FROM BI_PSP_EmojiReactionController__c WHERE 
				BI_PSP_FeedItem__c = :postRecord.Id AND 
				BI_PSP_AccountE__c = :testAccount.Id];
			// Checking for the reaction that is deleted.
			Assert.areequal(0,reactionDeleted.size(),'The emoji reaction is deleted.');
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	deleteemojireaction method with invalid input.
	* This method tests deletion of emoji reactions by feed item ID.
	*/
	@isTest
	static void testDeleteEmojiReactionForException() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call with invalid input.
					BI_PSPB_EmojiReactionCtrl.deleteemojireaction('invalid feed ID',
					testUserPatient.Id);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	deleteemojireaction method with null value as input.
	* This method tests deletion of emoji reactions by feed item ID.
	*/
	@isTest
	static void testDeleteEmojiReactionForNullException() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call with null value as input.
					BI_PSPB_EmojiReactionCtrl.deleteemojireaction(null,
					testAccountWithCommunityUsername.Id);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	deleteemojireaction method with invalid input.
	* This method tests deletion of emoji reactions by feed item ID.
	*/
	@isTest
	static void testDeleteEmojiReactionForNoExistingReaction() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call with invalid input.
					BI_PSPB_EmojiReactionCtrl.deleteemojireaction('invalid feed ID',
					testUserPatient.Id);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	deleteemojireaction method with invalid input.
	* This method tests deletion of emoji reactions by feed item ID.
	*/
	@isTest
	static void testDeleteEmojiReactionForUserWithoutAccount() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call with invalid input.
					BI_PSPB_EmojiReactionCtrl.deleteemojireaction('invalid feed ID',
					testUserWithoutAccount.Id);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalThumbsUp method with valid inputs.
	* This method tests the retrieval of total thumbs-up reactions for a post.
	*/
	@isTest
	static void testtotalthumbsups() {
		System.runAs(testUserPatient){
			// Creating post.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category');
			insert testFeedItem;
			// Creating a reaction with thumbs up for the above post.
			BI_PSP_EmojiReactionController__c thumbsUpReaction = 
				new BI_PSP_EmojiReactionController__c(
				BI_PSP_ReactionResult__c = '1',BI_PSP_FeedItem__c = testFeedItem.Id);
			insert thumbsUpReaction;
			Test.startTest();
				// Method call to fetch ThumbsUp with valid input.
				List<BI_PSP_EmojiReactionController__c> totalThumbsUpList = 
					BI_PSPB_EmojiReactionCtrl.totalthumbsup(testFeedItem.Id);
			Test.stopTest();
			// Fetching reactions for that post.
			List<BI_PSP_EmojiReactionController__c> reactionAfterReacting =
				[SELECT Id FROM BI_PSP_EmojiReactionController__c WHERE
				BI_PSP_FeedItem__c = :testFeedItem.Id AND BI_PSP_ReactionResult__c = '1'
				AND BI_PSP_AccountE__c != null];
			// Checking for number of reactions for that post.
			Assert.areequal(reactionAfterReacting.size(), totalThumbsUpList.size(),
			'There should be one thumbs up reaction.');
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalThumbsUp method with invalid input.
	* This method tests the retrieval of total thumbs-up reactions for a post.
	*/
	@isTest
	static void testtotalthumbsupsForException() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call with null value as input.
					BI_PSPB_EmojiReactionCtrl.totalThumbsup(null);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalsmile method with valid inputs.
	* This method tests the retrieval of total smile reactions for a post.
	*/
	@isTest
	static void testTotalSmile() {
		System.runAs(testUserPatient){
			// Creating post.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category');
			insert testFeedItem;
			// Reacting with smile emoji for the above post.
			BI_PSP_EmojiReactionController__c totalsmile =
				new BI_PSP_EmojiReactionController__c(
				BI_PSP_ReactionResult__c = '2',BI_PSP_FeedItem__c = testFeedItem.Id);
			insert totalsmile;
			Test.startTest();
			// Method call with valid input.
			List<BI_PSP_EmojiReactionController__c> totalSmileList = 
			BI_PSPB_EmojiReactionCtrl.totalsmile(testFeedItem.Id);
			Test.stopTest();
			// Fetching smile reactions for that post.
			List<BI_PSP_EmojiReactionController__c> reactionAfterReacting =[SELECT Id
				FROM BI_PSP_EmojiReactionController__c WHERE
				BI_PSP_FeedItem__c = :testFeedItem.Id AND BI_PSP_ReactionResult__c = '2'
				AND BI_PSP_AccountE__c != null];
			// Checking for number of smile reactions.
			Assert.areequal(reactionAfterReacting.size(), totalSmileList.size(),
			'There should be one smile reaction.');
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalsmile method with invalid inputs.
	* This method tests the retrieval of total smile reactions for a post.
	*/
	@isTest
	static void testTotalSmileForException() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call with invalid input. 
						BI_PSPB_EmojiReactionCtrl.totalsmile(null);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalfoldedhands method with valid inputs.
	* This method tests the retrieval of total Folded hands reactions for a post.
	*/
	@isTest
	static void testTotalFoldedHands() {
		System.runAs(testUserPatient){
			// Creating a post.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category');
			insert testFeedItem;
			// Creating reaction for that post with Folded hands.
			BI_PSP_EmojiReactionController__c totalfoldedhands = 
				new BI_PSP_EmojiReactionController__c(BI_PSP_ReactionResult__c = '3',
				BI_PSP_FeedItem__c = testFeedItem.Id);
			insert totalfoldedhands;
			Test.startTest();
				// Method call to fetch Folded Hands reaction.
				List<BI_PSP_EmojiReactionController__c> totalFoldedHandsList =
				BI_PSPB_EmojiReactionCtrl.totalfoldedhands(testFeedItem.Id);
			Test.stopTest();
			// Fetching Folded Hands reactions for that post.
			List<BI_PSP_EmojiReactionController__c> reactionAfterReacting =[
				SELECT Id FROM BI_PSP_EmojiReactionController__c WHERE
				BI_PSP_FeedItem__c = :testFeedItem.Id AND BI_PSP_ReactionResult__c = '3'
				AND BI_PSP_AccountE__c != null];
			// Checking for number of Folded Hands for that post.
			Assert.areequal(reactionAfterReacting.size(), totalFoldedHandsList.size(),
			'The reaction result should be folded hands.');
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalfoldedhands method with invalid inputs.
	* This method tests the retrieval of total Folded hands reactions for a post.
	*/
	@isTest
	static void testTotalFoldedHandsForException() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call to fetch reaction with invalid input.
						BI_PSPB_EmojiReactionCtrl.totalfoldedhands(null);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalheart method with valid inputs.
	* This method tests the retrieval of total heart reactions for a post.
	*/
	@isTest
	static void testTotalHeart() {
		System.runAs(testUserPatient){
			// Creating post
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',BI_PSP_Category__c = 'Test Category',
				BI_PSP_SoftDelete__c = 'No');
			insert testFeedItem;
			// Creating heart reaction for the above post.
			BI_PSP_EmojiReactionController__c totalheart =
				new BI_PSP_EmojiReactionController__c(
				BI_PSP_ReactionResult__c = '4',BI_PSP_FeedItem__c = testFeedItem.Id);
			insert totalheart;
			Test.startTest();
			// Method call to react with Heart emoji.
			List<BI_PSP_EmojiReactionController__c> totalHeartList =
			BI_PSPB_EmojiReactionCtrl.totalheart(testFeedItem.Id);
			
			Test.stopTest();
			// Fetching reactions of heart for that post.
			List<BI_PSP_EmojiReactionController__c> reactionAfterReacting =
				[SELECT Id FROM BI_PSP_EmojiReactionController__c WHERE
				BI_PSP_FeedItem__c = :testFeedItem.Id AND BI_PSP_ReactionResult__c = '3'
				AND BI_PSP_AccountE__c != null];
			// Checking for number of heart reactions for that post.
			Assert.areequal(reactionAfterReacting.size(), totalHeartList.size(),
			'The reaction result should be folded hands.');
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalheart method with invalid input.
	* This method tests the retrieval of total heart reactions for a post.
	*/
	@isTest
	static void testTotalHeartForException() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call to react with invalid input.
						BI_PSPB_EmojiReactionCtrl.totalheart(null);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalthinkingface method with valid inputs.
	* This method tests retrieval of total Thinking face reactions for a post.
	*/
	@isTest
	static void testTotalThinkingFace() {
		System.runAs(testUserPatient){
			// Creating a post.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category');
			insert testFeedItem;
			// Creating reactions of Thinking face for that post.
			BI_PSP_EmojiReactionController__c totalthinkingface = 
				new BI_PSP_EmojiReactionController__c(BI_PSP_ReactionResult__c = '5',
				BI_PSP_FeedItem__c = testFeedItem.Id);
			insert totalthinkingface;
			Test.startTest();
			// Method call to react with Thinking face.
			List<BI_PSP_EmojiReactionController__c> totalThinkingFaceList =
			BI_PSPB_EmojiReactionCtrl.totalthinkingface(testFeedItem.Id);
			Test.stopTest();
			// Fetching Thinking face reactions for that post.
			List<BI_PSP_EmojiReactionController__c> reactionAfterReacting =
				[SELECT Id FROM BI_PSP_EmojiReactionController__c WHERE
				BI_PSP_FeedItem__c = :testFeedItem.Id AND BI_PSP_ReactionResult__c = '3'
				AND BI_PSP_AccountE__c != null];
			// Checking for heart reactions for that post.
			Assert.areequal(reactionAfterReacting.size(), totalThinkingFaceList.size(),
			'The reaction result should be folded hands.');
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalthinkingface method with invalid input.
	* This method tests retrieval of total Thinking face reactions for a post.
	*/
	@isTest
	static void testTotalThinkingFaceForException() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call to react with null.
						BI_PSPB_EmojiReactionCtrl.totalthinkingface(null);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
	/**
	* @description Test method to verify the following status of two different 
	account with valid input.
	*/
	@isTest
	static void testCheckFollowingStatus() {
		System.runAs(testUserPatient){
			// Creating post.
			BI_PSP_FeedFollow__c followRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_Account__c = testAccount.Id,
				BI_PSP_AccountUser__c = testAccountWithCommunityUsername.Id);
			insert followRecord;
			Test.startTest();
			// Method call to check following status.
			List<BI_PSP_FeedFollow__c> result =
			BI_PSPB_EmojiReactionCtrl.checkFollowingStatus(testAccount.Id,
			testAccountWithCommunityUsername.Id);
			// Fetching follow status.
			List<BI_PSP_FeedFollow__c> feedFollowRecords = [SELECT Id,BI_PSP_Account__c,
				BI_PSP_AccountUser__c,BI_PSP_Type__c FROM
				BI_PSP_FeedFollow__c WHERE BI_PSP_Account__c = :testAccount.Id
				AND BI_PSP_AccountUser__c = :testAccountWithCommunityUsername.Id
				AND BI_PSP_Type__c = 'Following'];
			// Checking for follow records.
			Assert.areEqual(feedFollowRecords,result,
			'Expected following records are found');
			}
	}
	/**
	* @description Test method to verify the following status of two different 
	account with invalid input.
	*/
	@isTest
	static void testCheckFollowingStatusForException() {
		System.runAs(testUserPatient){
			try{
				Test.startTest();
					// Method call to check following status with null parameter.
						BI_PSPB_EmojiReactionCtrl.checkFollowingStatus(null, null);
				Test.stopTest();
			} catch(Exception e){
				/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
				Assert.areEqual('Script-thrown exception',e.getMessage(),
				'Method thrown exception');
			}
		}
	}
}