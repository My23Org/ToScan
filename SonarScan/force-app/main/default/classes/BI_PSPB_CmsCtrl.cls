/*
 * @description  This class facilitates the retrieval of data from the Content Management System (CMS) 
   to display articles for the Information Center. Additionally, it provides functionality to retrieve 
   the like response for articles for the current user.
 * History:
 * Version	Author			Date			Detail				Description
 * 1.0		Gokul Krishnan	05-Nov-2023		Created				Initial development
 * 1.1		Gokul Krishnan 	05-Feb-2024		Updated				Updated the patient status retrieve
 * 1.2		Gokul Krishnan	04-Apr-2024		Updated				Catch log added
 * 1.3 		Gokul Krishnan  02-May-2024		Developed			developed article like response retrieve and 
																update
 */

 public with sharing class BI_PSPB_CmsCtrl {
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
	private static string applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
	// Custom label for english language
	private static string usEnglish = System.Label.BI_PSPB_LocaleSidKey;
	// Custom label for cms image and news type
	private static string cmsImage = System.Label.BI_PSP_CmsImage;
	private static string cmsNews = System.Label.BI_PSP_CmsNews;
	// Custom label for Like and Dislike reaction
	private static string likeLabel = System.Label.BI_PSP_Like;
	private static string dislikeLabel = System.Label.BI_PSP_Dislike;
	// Custom label for error messages
	private static string errorCmsImageRetrieve = System.Label.BI_PSP_ErrorCmsImageRetrieve;
	private static string errorCmsNewsRetrieve = System.Label.BI_PSP_ErrorCmsNewsRetrieve;
	private static string errorCmsChannelIdRetrieve = System.Label.BI_PSP_ErrorCmsChannelIdRetrieve;
	private static string errorCmsNewsImageRetrieve = System.Label.BI_PSP_ErrorCmsNewsImageRetrieve;
	private static string articleParameterError = System.Label.BI_PSPB_ArticleParameterError;
	private static String enrolleNotFoundError = System.Label.BI_PSP_Enrollee_NF;
	private static String errorRetrieveLike = System.Label.BI_PSPB_ErrorRetrieveArticleLike;
	private static String errorCrudArticleLike = System.Label.BI_PSPB_ErrorCRUDArticleLike;

	private static string errorMessage = '';
	private static string errorMessageUpdate = '';
	private static string errorMessageDelete = '';

	/*
	 *@description     This method retrieves CMS images for a given channelName within a specified time range.
	 				   return in lwc biPspbArticlesForDashboard, biPspbcategoryarticlecmp, biPspbInformationcenterlanding,
					   biPspbrecentarticles, biPspbsearcharticlecmp
	 *@param           String channelName - The name of the channel for which images are to be retrieved.
	 *@return          String - JSON serialized list of image data.
	 */

	@AuraEnabled(cacheable=true)
	public static String retrieveMediaFromCMS(String channelName) {
		try {
			if (String.isBlank(channelName)) {
				throw new AuraHandledException(errorCmsChannelIdRetrieve);
			}
			String channelId = getChannelId(channelName);
			if (String.isBlank(channelId)) {
				throw new AuraHandledException(errorCmsChannelIdRetrieve);
			}

			//get the image content
			DateTime startDate = DateTime.newInstance(2023, 10, 2, 17, 0, 0);
			String formattedStartDate = startDate.formatGMT(
				'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''
			);

			DateTime endDate = DateTime.now();
			String formattedEndDate = endDate.formatGMT(
				'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''
			);
			ConnectApi.ManagedContentVersionCollection obj = ConnectApi.ManagedContent.getAllContent(
				channelId,
				0,
				25,
				usEnglish,
				cmsImage,
				false,
				formattedStartDate,
				formattedEndDate,
				true
			);

			List<ReturnWrapper> wrapperList = new List<ReturnWrapper>();
			//loop through each item and prepare a wrapper list
			for (ConnectApi.ManagedContentVersion versionObj : obj.items) {
				ReturnWrapper wrapper = new ReturnWrapper();
				wrapper.title = versionObj.title;

				//get the url
				Map<String, ConnectApi.ManagedContentNodeValue> contentNodesMap = versionObj.contentNodes;
				for (String str : contentNodesMap.keySet()) {
					if (str == 'source') {
						wrapper.url = ((ConnectApi.ManagedContentMediaSourceNodeValue) contentNodesMap.get(
								str
							))
							.url;
					}
				}
				wrapperList.add(wrapper);
			}
			return JSON.serialize(wrapperList);
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_CmsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorCmsImageRetrieve);
		}
	}

	/*
	@description     This method retrieves news content for a given channelName within a specified time range.
					 return in lwc biPspbarticlecontentpage
	@param           String channelName - The name of the channel for which news content is to be retrieved.
	@param           String news - Additional parameter, currently not used.
	@return          String - JSON serialized list of news data.
	*/
	@AuraEnabled(cacheable=true)
	public static String retrieveNewsFromCMS(String channelName) {
		try {
			if (String.isBlank(channelName)) {
				throw new AuraHandledException(errorCmsChannelIdRetrieve);
			}
			String channelId = getChannelId(channelName);
			if (String.isBlank(channelId)) {
				throw new AuraHandledException(errorCmsChannelIdRetrieve);
			}

			DateTime startDate = DateTime.newInstance(2023, 2, 2, 17, 0, 0);
			String formattedStartDate = startDate.formatGMT(
				'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''
			);

			DateTime endDate = DateTime.now();
			String formattedEndDate = endDate.formatGMT(
				'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''
			);

			//Get the news content
			ConnectApi.ManagedContentVersionCollection obj = ConnectApi.ManagedContent.getAllContent(
				channelId,
				0,
				100,
				usEnglish,
				cmsNews,
				false,
				formattedStartDate,
				formattedEndDate,
				true
			);

			List<ReturnWrapper> wrapperList = new List<ReturnWrapper>();

			//Loop through each item and prepare a wrapper list
			for (ConnectApi.ManagedContentVersion versionObj : obj.items) {
				ReturnWrapper wrapper = new ReturnWrapper();
				wrapper.title = versionObj.title;
				//Get the content nodes
				Map<String, ConnectApi.ManagedContentNodeValue> contentNodesMap = versionObj.contentNodes;

				//Iterate through content nodes to find the 'body' node
				for (String str : contentNodesMap.keySet()) {
					if (str == 'body') {
						// Assuming 'body' is a RichText node
						ConnectApi.ManagedContentNodeValue bodyNode = contentNodesMap.get(
							str
						);

						wrapper.body = string.valueOf(bodyNode);

						//Use debug information to extract content from the bodyNode
						//For example, if 'text' is a property of bodyNode, you might do:
					} else if (str == 'source') {
						// Assuming 'source' is the URL node
						wrapper.url = ((ConnectApi.ManagedContentMediaSourceNodeValue) contentNodesMap.get(
								str
							))
							.url;
					}
				}
				wrapperList.add(wrapper);
			}
			return JSON.serialize(wrapperList);
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_CmsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorCmsNewsRetrieve);
		}
	}

	/*
	@description     This method retrieves the unique identifier (channelId) for a given channelName.
					 return in apex  BI_PSPB_CmsCtrl method retrieveMediaUrlFromCMS, retrieveNewsFromCMS
	@param           String channelName - The name of the channel for which the channelId is to be retrieved.
	@return          String - The unique identifier (channelId) of the specified channelName.
	*/
	//get channelId
	private static String getChannelId(String channelName) {
		try {
			if (String.isBlank(channelName)) {
				throw new AuraHandledException(errorCmsChannelIdRetrieve);
			}
			ConnectApi.ManagedContentChannelCollection channelRepObj = ConnectApi.ManagedContent.getAllDeliveryChannels(
				0,
				10
			);

			//loop through the channels and return the channel Id
			for (
				ConnectApi.ManagedContentChannel channelObj : channelRepObj.channels
			) {
				if (channelObj.channelName == channelName) {
					return channelObj.channelId;
				} else {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSPB_CmsCtrl.class.toString(),
						'',
						System.now(),
						errorCmsChannelIdRetrieve,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			}
			return null;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_CmsCtrl.class.toString(),
				null,
				System.now()
			);
			return null;
			// Error throw in apex methods retrieveNewsFromCMS, retrieveMediaFromCMS, retrieveMediaFromCMSNews
		}
	}

	/*
	@description     Retrieves news content including title, subtitle, and image URL for a given channelName within a specified time range.
					 return in lwc biPspbArticlesForDashboard, biPspbcategoryarticlecmp, biPspbInformationcenterlanding,
					 biPspbrecentarticles, biPspbsearcharticlecmp
	@param           String channelName - The name of the channel for which news content is to be retrieved.
	@return          String - JSON serialized list of news data including title, subtitle, and image URL.
	*/
	@AuraEnabled(cacheable=true)
	public static String retrieveMediaFromCMSNews(String channelName) {
		try {
			if (String.isBlank(channelName)) {
				throw new AuraHandledException(errorCmsChannelIdRetrieve);
			}
			String channelId = getChannelId(channelName);

			if (String.isBlank(channelId)) {
				throw new AuraHandledException(errorCmsChannelIdRetrieve);
			}

			//get the image content
			DateTime startDate = DateTime.newInstance(2023, 10, 2, 17, 0, 0);
			String formattedStartDate = startDate.formatGMT(
				'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''
			);

			DateTime endDate = DateTime.now();
			String formattedEndDate = endDate.formatGMT(
				'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''
			);
			ConnectApi.ManagedContentVersionCollection obj = ConnectApi.ManagedContent.getAllContent(
				channelId,
				0,
				100,
				usEnglish,
				cmsNews,
				true,
				formattedStartDate,
				formattedEndDate,
				true
			);

			List<ReturnWrapper> wrapperList = new List<ReturnWrapper>();

			//loop through each item and prepare a wrapper list
			for (ConnectApi.ManagedContentVersion versionObj : obj.items) {
				ReturnWrapper wrapper = new ReturnWrapper();
				wrapper.title = versionObj.title;
				ConnectApi.ManagedContentNodeValue contentNode = versionObj.contentNodes.get(
					'excerpt'
				);
				ConnectApi.ManagedContentNodeValue bannerimage = versionObj.contentNodes.get(
					'bannerImage'
				);

				String subst = String.valueOf(contentNode);
				if (!String.isBlank(subst)) {
					String substi = subst.substring(88, subst.length() - 1);
					wrapper.subtitle = substi;
				} else {
					wrapper.subtitle = subst;
				}
				String imgurl = String.valueOf(bannerimage);
				if (!String.isBlank(imgurl)) {
					String urlim = imgurl.substring(
						imgurl.indexOf('url') + 4,
						imgurl.length() - 1
					);

					wrapper.url = urlim;
				} else {
					wrapper.url = String.valueOf(bannerimage);
				}

				wrapperList.add(wrapper);
			}
			return JSON.serialize(wrapperList);
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_CmsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorCmsNewsImageRetrieve);
		}
	}

/*
@description     Retrieves the user's reaction to a specific article for the current user within the 
				 Lightning Web Component.
				 return in lwc biPspbarticlelikebtn
@param           String articlename - The name of the article for which the user's reaction is to be retrieved.
@return          String - The user's reaction to the article (either like or dislike).
*/

	@AuraEnabled(cacheable=true)
	public static String checkreaction(String articlename) {
		//Query for the CareProgramEnrollee record
		//String userIdcurrent = UserInfo.getUserId();
		try {
			if (String.isBlank(articlename)) {
				throw new AuraHandledException(articleParameterError);
			}
			Id careProgramEnrolleeId = BI_PSPB_PersonalizedMessagesCtrl.getCareProgramEnrolleId();
			if (String.isBlank(careProgramEnrolleeId)) {
				throw new AuraHandledException(enrolleNotFoundError);
			}
			// User mode is not enabled because article like object lookup relationship with care program enrollee(health cloud object)
			List<BI_PSPB_Article_like__c> likereaction = [
				SELECT
					id,
					BI_PSPB_Article_name__c,
					BI_PSPB_Reaction__c,
					BI_PSPB_CareProgramEnrollee__c
				FROM BI_PSPB_Article_like__c
				WHERE
					BI_PSPB_CareProgramEnrollee__c = :careProgramEnrolleeId
					AND BI_PSPB_Article_name__c = :articlename
				LIMIT 1
			];
			if (!likereaction.isEmpty()) {
				return likereaction[0].BI_PSPB_Reaction__c;
			}
			return dislikeLabel;
		} catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_CmsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorRetrieveLike);
		}
	}

/*
@description     Retrieves and updates the user's reaction to a specific article within the 
				 Lightning Web Component biPspbarticlelikebtn.
@param           String articlename - The name of the article for which the user's reaction is to
									  be retrieved or updated.
				 String reaction - The user's reaction to the article (either "Like" or "Dislike").
@void			 If the reaction is "Like", updates the existing record or creates a new one if it doesn't exist.
    			 If the reaction is "Dislike", deletes the existing record if it exists.
*/

	@AuraEnabled(cacheable=false)
	public static void updatereaction(String articlename, String reaction) {
		try {
			if (String.isBlank(articlename) || String.isBlank(reaction)) {
				throw new AuraHandledException(articleParameterError);
			}

			Id careProgramEnrolleeId = BI_PSPB_PersonalizedMessagesCtrl.getCareProgramEnrolleId();
			if (String.isBlank(careProgramEnrolleeId)) {
				throw new AuraHandledException(enrolleNotFoundError);
			}
			// User mode is not enabled because article like object lookup relationship with care program enrollee(health cloud object)
			List<BI_PSPB_Article_like__c> likereaction = [
				SELECT
					id,
					BI_PSPB_Article_name__c,
					BI_PSPB_Reaction__c,
					BI_PSPB_CareProgramEnrollee__c
				FROM BI_PSPB_Article_like__c
				WHERE
					BI_PSPB_CareProgramEnrollee__c = :careProgramEnrolleeId
					AND BI_PSPB_Article_name__c = :articlename
				LIMIT 1
			];
			if (!likereaction.isEmpty()) {
				if (reaction == likeLabel) {
					likereaction[0].BI_PSPB_Reaction__c = reaction;
					BI_PSPB_Article_like__c likereactobj = new BI_PSPB_Article_like__c(
						Id = likereaction[0].Id
					);

					Database.SaveResult updateResultss = Database.update(
						likereactobj,
						false
					);
					if (!updateResultss.isSuccess()) {
						for (
							Database.Error error : updateResultss.getErrors()
						) {
							errorMessageUpdate +=
								'Error ' +
								error.getFields() +
								'--' +
								error.getMessage() +
								'\n';
						}
						if (!String.isBlank(errorMessageUpdate)) {
							BI_SFCOE_LOG_Util.logMessage(
								applicationName,
								BI_PSPB_CmsCtrl.class.toString(),
								'',
								System.now(),
								errorMessageUpdate,
								BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
							);
							throw new DMLException(errorMessageUpdate);
						}
					}
				} else if (reaction == dislikeLabel) {
					Database.DeleteResult[] deleteResults = Database.delete(
						likereaction,
						false
					);
					for (Database.DeleteResult result : deleteResults) {
						if (!result.isSuccess()) {
							for (Database.Error error : result.getErrors()) {
								errorMessageDelete +=
									'Error ' +
									error.getFields() +
									'--' +
									error.getMessage() +
									'\n';
							}
							if (!String.isBlank(errorMessageDelete)) {
								BI_SFCOE_LOG_Util.logMessage(
									applicationName,
									BI_PSPB_CmsCtrl.class.toString(),
									'',
									System.now(),
									errorMessageDelete,
									BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
								);
								throw new DMLException(errorMessageDelete);
							}
						}
					}
				}
			} else {
				if (reaction == likeLabel) {
					BI_PSPB_Article_like__c likereactionrec = new BI_PSPB_Article_like__c();

					likereactionrec.BI_PSPB_Article_name__c = articlename;
					likereactionrec.BI_PSPB_Reaction__c = reaction;
					likereactionrec.BI_PSPB_CareProgramEnrollee__c = careProgramEnrolleeId;
					likereaction.add(likereactionrec);

					Database.SaveResult[] insertResults = Database.insert(
						likereaction,
						false
					);
					for (Database.SaveResult insertResult : insertResults) {
						if (!insertResult.isSuccess()) {
							for (
								Database.Error error : insertResult.getErrors()
							) {
								errorMessage +=
									'Error ' +
									error.getFields() +
									'--' +
									error.getMessage() +
									'\n';
							}
						}
					}
					if (!String.isBlank(errorMessage)) {
						BI_SFCOE_LOG_Util.logMessage(
							applicationName,
							BI_PSPB_CmsCtrl.class.toString(),
							'',
							System.now(),
							errorMessage,
							BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
						);
						throw new DMLException(errorMessage);
					}
				}
			}
		} catch (Exception ex) {
			String applicationName = BI_SFCOE_LOG_App_Settings__c.getInstance()
				.BI_SFCOE_LOG_Application__c;
			BI_SFCOE_LOG_Util.handleException(
				ex,
				applicationName,
				BI_PSPB_CmsCtrl.class.toString(),
				null,
				System.now()
			);
			throw new AuraHandledException(errorCrudArticleLike);
		}
	}

/*
@description     Wrapper class representing news content including title, subtitle, and image URL 
for a given channelName within a specified time range.
@param title - title of the cms news or image
@param url 	 - url of the cms image
@param subtitle - subtitle of the cms news
@param body  - body content of the cms news */

	public class ReturnWrapper {
		String title { get; set; }
		String url { get; set; }
		String subtitle { get; set; }
		public String body { get; set; }
	}
}