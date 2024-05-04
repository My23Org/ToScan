/**
 * @description This class provides support for managing My Cases page. It is responsible to retrieve and display case records form
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		20-Dec-2024		Created		This was an intial development.
 * 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */

public with sharing class BI_PSPB_CaseSupport {
    //varibale that holds the application name retrieved from Custom Settings.
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    //A variable That holds the name of our application to be used in catch exception handler.
    private static String applicationName = settings != null
        ? settings.BI_SFCOE_LOG_Application__c
        : '';
    private static String statusSubmitted = System.Label.BI_PSPB_Submitted;
    private static String statusDraft = System.Label.BI_PSPB_Draft;
    private static String statusNeedmoreInformation = System.Label.BI_PSPB_NeedmoreInformation;
    private static String jpg = System.Label.BI_PSPB_Jpg;
    private static String png = System.Label.BI_PSPB_Png;
    private static String Base64 = System.Label.BI_PSPB_Base64;
    private static String all = System.Label.BI_PSPB_All;
    private static String errorUserName = System.Label.BI_PSPB_Error_For_UserName;
    private static String errorImg = System.Label.BI_PSPB_Error_For_Image;
    private static String supportCenter = System.Label.BI_PSPB_Support_Center;
    /**
     * @description This method retrieves a list of cases based on the provided filter criteria,including type,status,and account Id.
     *  It queries the Case object and returns matching records.The querie we have used Careprogram Enrolle lookup Field so we can't add the user mode here.
     * @param type The type of cases to retrieve. Pass 'All' to retrieve all types.
     * @param status The status of cases to retrieve. Pass 'All' to retrieve cases with all statuses.
     * @param cpeId The Id of the Care program entrollee  associated with the cases.
     * @return A list of Case records matching the provided filter criteria.this return in the BI_PSPB_CaseSupport component
     */

    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(
        String type,
        String status,
        String cpeId
    ) {
        String query = '';
        try {
            //String BI_PSPB_SupportCenter = BI_PSPB_SupportCenterRecType.Name;
            CareProgramEnrollee cpe = [
                SELECT Id, AccountId
                FROM CareProgramEnrollee
                WHERE Id = :cpeId
                LIMIT 1
            ];
            if (cpe != null) {
                query =
                    'SELECT Id, CaseNumber, Subject, Status, Priority, Type, BI_PSP_Patient__c, BI_PSPB_Sub_Type__c, Description, CreatedDate FROM Case WHERE AccountId = \'' +
                    cpe.AccountId +
                    '\' AND RecordType.Name = \'' +
                    supportCenter +
                    '\'';

                if (!String.isBlank(status) && status == all) {
                    query +=
                        ' AND (Status =\'' +
                        statusSubmitted +
                        '\' OR Status=\'' +
                        statusDraft +
                        '\' OR Status=\'' +
                        statusNeedmoreInformation +
                        '\')';
                }
                if (type != all && status != all) {
                    query += ' AND Type = :type AND Status = :status ';
                    if (status == statusDraft) {
                        query +=
                            ' AND Type = :type AND (Status=\'' +
                            statusDraft +
                            '\' OR Status=\'' +
                            statusNeedmoreInformation +
                            '\')';
                    }
                }
                if (String.isNotBlank(status) && status != all) {
                    if (status == statusDraft) {
                        query +=
                            ' AND (Status=\'' +
                            statusDraft +
                            '\' OR Status=\'' +
                            statusNeedmoreInformation +
                            '\')';
                    } else {
                        query += ' AND Status = :status ';
                    }
                }
                query += 'Order by CreatedDate DESC';
                List<Case> cases = Database.query(query);

                if (!cases.isEmpty()) {
                    return cases;
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSPB_CaseSupport.class.toString(),
                        BI_PSPB_constantsClass.error,
                        System.now(),
                        '',
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                    throw new AuraHandledException(
                        BI_PSPB_constantsClass.error
                    );
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSPB_CaseSupport.class.toString(),
                    BI_PSPB_constantsClass.error,
                    System.now(),
                    '',
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(BI_PSPB_constantsClass.error);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSPB_CaseSupport.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(
                BI_PSPB_constantsClass.errorMsgCaseRecordNotFound
            );
        }
    }
    /**
     * @description This method retrieves the details of a specific Case record identified by the caseId parameter.
     * It queries the Case object and returns the corresponding Case record with various details.
     * @param caseId The Id of the Case record to retrieve details for.
     * @return The Case record containing details such as Id, Subject, Type, Description, Status, Sub-Type, Created Date, and Created By Id.
     *this return in the BI_PSPB_CaseSupport component
     */
    @AuraEnabled
    public static Case caserecord(Id caseId) {
        try {
            return [
                SELECT
                    Id,
                    Subject,
                    Type,
                    Description,
                    Status,
                    BI_PSPB_Sub_Type__c,
                    CreatedDate,
                    CreatedById
                FROM Case
                WHERE Id = :caseId
                WITH USER_MODE
            ];
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSPB_CaseSupport.class.toString(), //YourClassname
                null,
                System.now()
            );
            throw new AuraHandledException(
                BI_PSPB_constantsClass.errorMsgCaseRecordNotFound
            );
        }
    }
    /**
     * @description This method retrieves the name of the user identified by the userId parameter.
     * It queries the User object to find the user's name and returns the corresponding User record.
     * @return The User record containing the name of the user.
     * @param userid The Id of the user for which to retrieve the name.
     */
    @AuraEnabled
    public static User getname(Id userid) {
        try {
            list<User> nam = [
                SELECT Name
                FROM User
                WHERE Id = :userid
                WITH USER_MODE
                LIMIT 1
            ];
            //system.debug(nam);
            if (!nam.isEmpty()) {
                return nam[0];
            } else {
                throw new AuraHandledException(BI_PSPB_constantsClass.error);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSPB_CaseSupport.class.toString(), //YourClassname
                null,
                System.now()
            );
            throw new AuraHandledException(errorUserName);
        }
    }
    /**
     * Retrieves the base64 encoded image data associated with the provided caseId.
     * @description This method queries the ContentDocumentLink and ContentVersion objects to find the latest image data related to the provided caseId.
     * If image data is found, it is returned as a base64 encoded string. If no image data is found, an empty string is returned.
     * @param caseId The Id of the Case for which to retrieve the image data.
     * @return A base64 encoded string representing the image data, or an empty string if no image data is found.
     *this return in the BI_PSPB_CaseSupport component
     */

    @AuraEnabled(cacheable=true)
    public static String getBase64Image(Id caseId) {
        try {
            String base64URL = '';
            // Query ContentDocumentLink to get the ContentDocumentId related to the Case
            List<ContentDocumentLink> docLinks = [
                SELECT ContentDocumentId
                FROM ContentDocumentLink
                WHERE
                    LinkedEntityId = :caseId
                    AND ContentDocument.FileType IN ('jpg', 'png')
                WITH USER_MODE
                LIMIT 1
            ];
            if (!docLinks.isEmpty()) {
                Id contentDocumentId = docLinks[0].ContentDocumentId;

                // Query ContentVersion to retrieve the image data
                ContentVersion content = [
                    SELECT VersionData
                    FROM ContentVersion
                    WHERE
                        ContentDocumentId = :contentDocumentId
                        AND FileType IN ('jpg', 'png')
                    WITH USER_MODE
                    ORDER BY CreatedDate DESC
                    LIMIT 1
                ];

                if (content != null && content.VersionData != null) {
                    base64URL =
                        Base64 + EncodingUtil.base64Encode(content.VersionData);
                } else {
                    BI_SFCOE_LOG_Util.logMessage(
                        applicationName,
                        BI_PSPB_CaseSupport.class.toString(),
                        BI_PSPB_constantsClass.error,
                        System.now(),
                        '',
                        BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                    );
                    throw new AuraHandledException(
                        BI_PSPB_constantsClass.error
                    );
                }
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSPB_CaseSupport.class.toString(),
                    BI_PSPB_constantsClass.error,
                    System.now(),
                    '',
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(BI_PSPB_constantsClass.error);
            }
            if (base64URL != null) {
                return base64URL;
            } else {
                BI_SFCOE_LOG_Util.logMessage(
                    applicationName,
                    BI_PSPB_CaseSupport.class.toString(),
                    BI_PSPB_constantsClass.error,
                    System.now(),
                    '',
                    BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
                );
                throw new AuraHandledException(BI_PSPB_constantsClass.error);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,
                applicationName,
                BI_PSPB_CaseSupport.class.toString(),
                null,
                System.now()
            );
            throw new AuraHandledException(errorImg);
        }
    }
}