/*
*@description    This class is used to create lead with its child record. 
				Lead is being created by guest user, so this class is enabled without sharing mode.
* History:
* Version	Author			Date			Detail				Description
* 1.0		Ashif	        05-01-2024  	Created				Initial development
* 1.1		NandhaKumar 	04-feb-2023		Created			    created a new method name as createCaregiverRecord
* 1.2		NandhaKumar 	04-Apr-2023		Updated				Catch log added
*/

public without sharing class BI_PSPB_leadCreationCtrl {
    
    private static String physician = System.Label.BI_PSPB_PhysicianRecordtype;
    private static String HealthcareProvider = System.Label.BI_PSPB_Healthcare_Provider;
    private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
        'PSPB'
    );
    // Application name of the System
    private static String applicationName = settings != null
		? settings.BI_SFCOE_LOG_Application__c
		: '';
    private static String caregiver = System.Label.BI_PSPB_Caregiver;
    private static String errorMsg = '';
    // Custom Error message label
    private static String recordCannotFound = System.Label.BI_PSP_record_not_found_error_message;
    private static String recordInsertionFailed = System.Label.BI_PSP_record_insert_error_message;
    /*  
@description		Used to Create the Lead record return in lwc biPspbHcpEnrollment,
                    all the wrapper class parameters null check in lwc 
@param				String combinedString combination value of the given value lead in hcp enrollemnet
@param				String HCPID Created physician record id
@param				String licence Selected physician license
@param				String HCPName Selected physician Name
@return				return Lead id
*/
    
    @AuraEnabled
    public static Id createLead(
        DataWrapper data,
        String HCPID,
        String licence,
        String HCPName
    ) {
        try {
            List<Contact> referringContacts = new List<Contact>();
            // Query for the Contact with the provided Name, License, or ID
            //We are adding the nested if statement in accordance with the busness requirement.
            //Since this object is invoked from a Guest User Profile which has limited access, User Mode cannot be used here
            if (String.isNotBlank(HCPName)) {
                referringContacts = [
                    SELECT Id
                    FROM Contact
                    WHERE Name = :HCPName
                    LIMIT 1
                ];
            } else if (String.isNotBlank(HCPID)) {
                referringContacts = [SELECT Id FROM Contact WHERE Id = :HCPID LIMIT 1];
            } else if (String.isNotBlank(licence)) {
                referringContacts = [
                    SELECT Id
                    FROM Contact
                    WHERE BI_PSPB_License_number__c = :licence
                    LIMIT 1
                ];
            }
            if (!referringContacts.isEmpty()) {
                // Create the Lead record and associate it with the found Contact
                Lead newLead = new Lead();
                newLead.FirstName = data.firstName;
                newLead.LastName = data.lastName;
                newLead.HealthCloudGA__BirthDate__c = Date.valueOf(data.dob); // Assuming DOB is a String, convert it to Date.
                newLead.Email = data.email;
                newLead.HealthCloudGA__Gender__c = data.sex;
                newLead.Phone = data.phone;
                newLead.BI_PSPB_Physician_Name_c__c = referringContacts[0].Id;
                newLead.BI_PSPB_Enrolled_By__c = HealthcareProvider;
                // Insert the Lead record
                Database.SaveResult[] saveResult = Database.insert(
                    new List<Lead>{ newLead },
                    false
                );
                // Iterate over each save result
                for (Database.SaveResult saveResultItem : saveResult) {
                    if (!saveResultItem.isSuccess()) {
                        for (Database.Error error : saveResultItem.getErrors()) {
                            errorMsg +=   'Error ' + error.getFields() +
                                '--' +error.getMessage() + '\n';
                        }
                    }
                }
                if (String.isNotBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                        saveResult, BI_PSPB_leadCreationCtrl.class.toString(),
                        System.now()
                    );
                    throw new AuraHandledException(recordInsertionFailed);
                }
                if(newLead!=null)
                {
                    return newLead.Id;
                }
                else{
                    throw new AuraHandledException(recordInsertionFailed);
                }
                
            } else {
                // Handle the case where referringContacts list is empty
                throw new AuraHandledException(
                    recordCannotFound
                );
            }
        } catch (Exception ex) {
            // Log and handle the exception
            BI_SFCOE_LOG_Util.handleException(
                ex, applicationName,BI_PSPB_LeadCreationCtrl.class.getName(),
                null, System.now()
            );
           throw new AuraHandledException(recordInsertionFailed);
        }
    }
    /*  
@description		Used to create Lead Caregiver Object if Patient is minor return in lwc biPspbHcpEnrollment
@param				String combinedStringcaregiver combination value of the given value leadcaregiver in hcp enrollemnet
@param				String LeadID created lead record id
@return				caregiver id
*/
    @AuraEnabled
    public static Id caregiverCreate(DataWrapper caregiverdata, String LeadID) {
        try {
            if(caregiverdata != null){
                if (!String.isblank(caregiverdata.firstName)&&!String.isblank(caregiverdata.lastName)&&!String.isblank(caregiverdata.email)
                    &&!String.isblank(caregiverdata.dob)&&!String.isblank(caregiverdata.relation)&&!String.isblank(LeadID) ) {
                    BI_PSPB_Lead_Caregiver__c care = new BI_PSPB_Lead_Caregiver__c();
                    care.BI_PSPB_First_Name__c = caregiverdata.firstName;
                    care.BI_PSPB_Last_Name__c = caregiverdata.lastName;
                    care.BI_PSPB_E_mail_ID__c = caregiverdata.email;
                    care.BI_PSPB_Date_of_Birth__c = Date.valueOf(caregiverdata.dob);
                    care.BI_PSPB_Phone_number__c = caregiverdata.phone;
                    care.BI_PSPB_Relationship_to_Patient__c = caregiverdata.relation;
                    care.BI_PSPB_Lead__c = LeadID;
                    // Insert the record
                    Database.SaveResult[] saveResult = Database.insert(
                        new List<BI_PSPB_Lead_Caregiver__c>{ care },
                        false
                    );
                    // Iterate over each save result
                    
                    for (Database.SaveResult saveResults : saveResult) {
                        if (!saveResults.isSuccess()) {
                            for (Database.Error error : saveResults.getErrors()) {
                                errorMsg += 'Error ' + error.getFields() +
                                    '--' + error.getMessage() + '\n';
                            }
                        }
                    }
                    if (String.isNotBlank(errorMsg)) {
                        BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                            saveResult, BI_PSPB_leadCreationCtrl.class.toString(),
                            System.now()
                        );
                        throw new AuraHandledException(recordInsertionFailed);
                    }
                    if(care!=null)
                    {
                        return care.Id;
                    }else{
                        throw new AuraHandledException( recordCannotFound );    
                    }
                    
                } else {
                    // Handle the case where caregiverdata is null
                    throw new AuraHandledException( recordCannotFound );
                }
            }else {
                // Handle the case where caregiverdata is null
                throw new AuraHandledException( recordCannotFound );
            }
        } catch (Exception ex) {
            // Log and handle the exception
            BI_SFCOE_LOG_Util.handleException(
                ex,applicationName,
                BI_PSPB_LeadCreationCtrl.class.toString(),
                null,System.now()
            );
            throw new AuraHandledException(recordInsertionFailed);
        }
    }
    /* 
@description		Used to Create the HCP record (Physician record) return in lwc biPspbHcpEnrollment,
                    all the wrapper class parameters null check in lwc 
@param				String combinedString combination value of the given value physician in hcp enrollemnet
@return				return Hcpcreate id
*/
    @AuraEnabled
    public static Id hcpCreate(DataWrapper hcpData) {
        try {
            if (hcpData != null) {
                Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
                    .get(physician)
                    .getRecordTypeId();
                Contact con = new Contact();
                con.FirstName = hcpData.firstName;
                con.LastName = hcpData.lastName;
                con.BI_PSPB_License_number__c = hcpData.lisence;
                con.BI_PSPB_Practice__c = hcpData.practice;
                con.BI_PSPB_Practice_Type__c = HcpData.type;
                con.Phone = hcpData.phone;
                con.Email = hcpData.email;
                con.MailingCountryCode = hcpData.country;
                con.MailingStateCode = hcpData.state;
                con.MailingCity = hcpData.city;
                con.MailingStreet = hcpData.street;
                con.MailingPostalCode = hcpData.code;
                con.RecordTypeId = recordTypeId;
                Database.SaveResult[] saveResultsone = Database.insert(
                    new List<Contact>{ con },
                    false
                );
                // Iterate over each save result
                
                for (Database.SaveResult saveResult : saveResultsone) {
                    if (!saveResult.isSuccess()) {
                        for (Database.Error error : saveResult.getErrors()) {
                            errorMsg +=
                                'Error ' + error.getFields() +
                                '--' + error.getMessage() +'\n';
                        }
                    }
                }
                if (String.isNotBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                        saveResultsone,
                        BI_PSPB_leadCreationCtrl.class.toString(),
                        System.now()
                    );
                    throw new AuraHandledException(recordInsertionFailed);
                }
                if (con != null) {
                    return con.Id;
                } else {
                    throw new AuraHandledException( recordCannotFound  );
                }
            } else {
                // Handle the case where values list does not have at least 9 elements
                throw new AuraHandledException( recordCannotFound);
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,applicationName, BI_PSPB_LeadCreationCtrl.class.toString(),
                null,System.now()
            );
            throw new AuraHandledException(recordInsertionFailed);
        }
    }
    
    /*  
@description		Used to Create the Prescription record return in lwc biPspbHcpEnrollment,all the wrapper class parameters null check in lwc 
@param  			String combinedString combination value of the given value prescription in hcp enrollemnet
@param           	String dosage 
@param           	String refill value of given patient while enrollenment
@param           	String LeadID created lead id
@return         	return Prescriptionrcreate id
*/
    @AuraEnabled
    public static Id prescriptionrCreate(
        DataWrapper prescriptiondata,
        String Quantity,
        String refill,
        String LeadID
    ) {
        try {
            //Since this object is invoked from a Guest User Profile which has limited access to the Health Cloud objects, User Mode cannot be used here
            if (prescriptiondata != null && !String.isBlank(Quantity) && !String.isBlank(refill) && !String.isBlank(LeadID)) {
                CareProgramProduct[] Drugs = [
                    SELECT Id, BI_PSPB_Unit__c, BI_PSPB_Dosage__c, BI_PSPB_Product_code__c
                    FROM CareProgramProduct
                    WHERE Name = :prescriptiondata.drug
                    LIMIT 1
                ];
               if(!Drugs.IsEmpty()){
                BI_PSPB_Lead_Prescription__c pres = new BI_PSPB_Lead_Prescription__c();
                pres.BI_PSPB_Dosage__c = Drugs[0].BI_PSPB_Dosage__c;
                pres.BI_PSPB_Quantity__c = integer.valueOf(Quantity);
                pres.BI_PSPB_Frequency__c = integer.valueOf(prescriptiondata.frequency);
                pres.BI_PSPB_of_Refills__c = integer.valueOf(refill);
                pres.BI_PSPB_Drug_Code__c = Drugs[0].BI_PSPB_Product_code__c;
                pres.BI_PSPB_Unit__c = Drugs.isEmpty()
                    ? null
                    : Drugs[0].BI_PSPB_Unit__c;
                pres.BI_PSPB_Prescribed_Date__c = Date.valueOf(prescriptiondata.dob);
                pres.BI_PSPB_Frequency_Unit__c = prescriptiondata.unit;
                pres.BI_PSPB_Drug__c = Drugs.isEmpty() ? null : Drugs[0].Id;
                pres.BI_PSPB_Lead__c = LeadID;
               
                Database.SaveResult[] saveResultsone = Database.insert(
                    new List<BI_PSPB_Lead_Prescription__c>{ pres },
                    false
                );
                // Iterate over each save result
                
                for (Database.SaveResult saveResult : saveResultsone) {
                    if (!saveResult.isSuccess()) {
                        for (Database.Error error : saveResult.getErrors()) {
                            errorMsg +=
                                'Error ' + error.getFields() + '--' +
                                error.getMessage() + '\n';
                        }
                    }
                }
                if (String.isNotBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                        saveResultsone,
                        BI_PSPB_leadCreationCtrl.class.toString(),
                        System.now()
                    );
                    throw new AuraHandledException(recordInsertionFailed);
                }
                if(pres!=null)
                {
                    return pres.Id;
                }else{
                    throw new AuraHandledException(recordCannotFound );
                }
                
            } else {
                // Handle the case where values list does not have at least 9 elements
                throw new AuraHandledException( recordCannotFound );
            }
            } else {
                // Handle the case where values list does not have at least 9 elements
                throw new AuraHandledException( recordCannotFound );
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex, applicationName, BI_PSPB_LeadCreationCtrl.class.toString(),
                null,System.now()
            );
            throw new AuraHandledException(recordInsertionFailed);
        }
    }
    /*  
@description     	Used to Create the Consent record ,return in lwc biPspbHcpEnrollment
@param           	String LeadID created lead id
@return         	return Consent id

*/
    @AuraEnabled
    public static Id consentCreate(String LeadID) {
        try {
            if(!String.isBlank(LeadID)){
            BI_PSP_Lead_Consent__c consent = new BI_PSP_Lead_Consent__c();
            consent.BI_PSP_I_agree__c = true;
            consent.BI_PSPB_Consent_Category__c = HealthcareProvider;
            consent.BI_PSP_Lead__c = LeadID;
            Database.SaveResult[] saveResults = Database.insert(
                new List<BI_PSP_Lead_Consent__c>{ consent },
                false
            );
            
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) {
                    for (Database.Error error : saveResult.getErrors()) {
                        errorMsg +=
                            'Error ' + error.getFields() +
                            '--' + error.getMessage() + '\n';
                    }
                }
            }
            if (String.isNotBlank(errorMsg)) {
                BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                    saveResults, BI_PSPB_leadCreationCtrl.class.toString(),
                    System.now()
                );
                throw new AuraHandledException(recordInsertionFailed);
            }
            
            if (consent != null) {
                return consent.Id;
            } else {
                throw new AuraHandledException( recordCannotFound );
            }
        }else {
            throw new AuraHandledException( recordCannotFound );
        }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex, applicationName,
                BI_PSPB_LeadCreationCtrl.class.toString(),
                null,System.now()
            );
            throw new AuraHandledException(recordInsertionFailed);
        }
    }
    
    /*  
@description     	Used to fetch the account email,return in lwc biPspbHcpEnrollment
@return         	return account email
*/
    @AuraEnabled(cacheable=true)
    public static List<Account> getExistingAccounts(String email) {
        try {
            if(String.isBlank(email)){
              // If there is no account, we return null, ensuring the absence of an error when proceeding with the creation process.
                return null;
            }
            //Since this object is invoked from a Guest User Profile which has limited access, User Mode cannot be used here
            list<Account> acc = [
                SELECT
                id,
                FirstName,
                LastName,
                BI_PSP_Birthdate__c,
                RecordType.Name,
                BI_PSPB_User_Type__c,
                PersonEmail
                FROM Account
                WHERE PersonEmail =: email Limit 1
            ];
           
            if (!acc.IsEmpty()) {
                return acc;
                
            } else {
             // If there is no account, we return null, ensuring the absence of an error when proceeding with the creation process.
                return null;
                
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,applicationName,BI_PSPB_LeadCreationCtrl.class.toString(),
                null,System.now()
            );
            throw new AuraHandledException( recordCannotFound );
                
        }
    }
    
   
    
    /*  
@description     	Used to fetch the the created lead,return in lwc biPspbHcpEnrollment
@param          	ID createLeadId created lead id
@return         	return lead record
*/
    @AuraEnabled(cacheable=true)
    public static list<lead> getLead(String createLeadId) {
        try {
            if(!String.isBlank(createLeadId)){
            // Since the guest user has limited access, the data is returned to them, so user mode is not used.
            list<lead> ld = [
                SELECT
                Id,
                FirstName,
                LastName,
                HealthCloudGA__BirthDate__c,
                Email,
                HealthCloudGA__Gender__c,
                Phone
                FROM Lead
                WHERE id = :createLeadId
            ];
            
            if (!ld.IsEmpty()) {
                return ld;
            } else {
                throw new AuraHandledException(
                    recordCannotFound
                );
            }
            }else{
               throw new AuraHandledException(
                    recordCannotFound
                ); 
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex, applicationName,BI_PSPB_LeadCreationCtrl.class.toString(),
                null,System.now()
            );
            throw new AuraHandledException(
                    recordCannotFound
                );
        }
    }
    /*  
@description     	Used to fetch the the caregiver record,return in lwc biPspbHcpEnrollment
@param           	String CaregivercreateId created caregiver id
@return         	return caregiver record
*/
    @AuraEnabled(cacheable=true)
    public static list<BI_PSPB_Lead_Caregiver__c> getCaregiver(
        String CaregivercreateId
    ) {
        try {
            if(!String.isBlank(CaregivercreateId)){
            // Since the guest user has limited access, the data is returned to them, so user mode is not used.
            list<BI_PSPB_Lead_Caregiver__c> leadCaregiver = [
                SELECT
                Id,
                BI_PSPB_First_Name__c,
                BI_PSPB_Last_Name__c,
                BI_PSPB_E_mail_ID__c,
                BI_PSPB_Date_of_Birth__c,
                BI_PSPB_Phone_number__c,
                BI_PSPB_Relationship_to_Patient__c
                FROM BI_PSPB_Lead_Caregiver__c
                WHERE BI_PSPB_Lead__c = :CaregivercreateId
            ];
            if (!leadCaregiver.IsEmpty()) {
                return leadCaregiver;
            } else {
                throw new AuraHandledException(
                    recordCannotFound
                );
            }
            }else {
                throw new AuraHandledException(
                    recordCannotFound
                );
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,applicationName, BI_PSPB_LeadCreationCtrl.class.toString(),
                null,System.now()
            );
            throw new AuraHandledException(recordCannotFound);
        }
    }
    /*  
@description     	Used to fetch the the prescribtion record,return in lwc biPspbHcpEnrollment
@param           	String PrescriptionrcreateId created Prescription id 
@return         	return prescribtion record
*/
    @AuraEnabled(cacheable=true)
    public static list<BI_PSPB_Lead_Prescription__c> getPresinfo(
        String PrescriptionrcreateId
    ) {
        try {
            if(!String.isBlank (PrescriptionrcreateId)){
            // Since the guest user has limited access, the data is returned to them, so user mode is not used.
            list<BI_PSPB_Lead_Prescription__c> leadPrescription = [
                SELECT
                Id,
                BI_PSPB_Lead_Prescription__c.BI_PSPB_Drug__r.Name,
                BI_PSPB_Dosage__c,
                BI_PSPB_Quantity__c,
                BI_PSPB_Frequency__c,
                BI_PSPB_of_Refills__c,
                BI_PSPB_Drug_Code__c,
                BI_PSPB_Unit__c,
                BI_PSPB_Prescribed_Date__c,
                BI_PSPB_Frequency_Unit__c,
                BI_PSPB_Drug__c
                FROM BI_PSPB_Lead_Prescription__c
                WHERE BI_PSPB_Lead__c = :PrescriptionrcreateId
            ];
            if (!leadPrescription.IsEmpty()) {
                return leadPrescription;
            } else {
                throw new AuraHandledException(
                    recordCannotFound
                );
            }
            }else {
                throw new AuraHandledException(
                    recordCannotFound
                );
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,applicationName, BI_PSPB_LeadCreationCtrl.class.toString(),
                null, System.now()
            );
            throw new AuraHandledException(recordCannotFound);
        }
    }
    
  
    /*  
@description     	Used to create the caregiver record,return in lwc biPspbaddcaregiver
                    all the wrapper class parameters null check in lwc 
@param           	String combinedStringhcare combination value of Add caregiver 
@return         	return caregiver record
*/
    
    @AuraEnabled
    public static Id createCaregiverRecord(DataWrapper newcaregive) {
        try {
            if(newcaregive != null){
            Contact contactToInsert = new Contact();
     
            Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(caregiver).getRecordTypeId();
            // Create a new Contact record
            contactToInsert = new Contact(
                FirstName = newcaregive.firstName,
                LastName = newcaregive.lastName,
                BI_PSPB_Relationship_To_Patient__c = newcaregive.relation,
                Email = newcaregive.email,
                BI_PSPB_Birthdate__c = Date.valueOf(newcaregive.dob),
                Phone = newcaregive.phone,
                RecordTypeId = recordTypeId
            );
                
            
            // Insert the Contact record
            Database.SaveResult[] saveResults = Database.insert(
                new List<Contact>{ contactToInsert },
                false
            );
            // Handle the save results
            
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) {
                    for (Database.Error error : saveResult.getErrors()) {
                        errorMsg += 'Error ' + error.getFields() +
                            '--' + error.getMessage() + '\n';
                    }
                }
            }
            
            if (String.isNotBlank(errorMsg)) {
                BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                    saveResults, BI_PSPB_leadCreationCtrl.class.toString(), System.now()
                );
                throw new AuraHandledException(recordInsertionFailed);
            }
            
            // Query the CareProgramEnrollee record by Id
            //Since this object is invoked from a Guest User Profile which has limited access to the Health Cloud objects, 
            //User Mode cannot be used here
            CareProgramEnrollee enrollee = [
                SELECT Id, AccountId
                FROM CareProgramEnrollee
                WHERE Id = :newcaregive.caregiverId
                LIMIT 1
            ];
            // Check if a valid CareProgramEnrollee record is found
            if (enrollee != null) {
                // Create a new BI_PSPB_Enrollee_Caregiver__c record
                BI_PSPB_Enrollee_Caregiver__c caregiverToInsert = new BI_PSPB_Enrollee_Caregiver__c(
                    Name = contactToInsert.FirstName, // You may adjust this as needed
                    BI_PSPB_Care_Program_Enrollee__c = enrollee.Id,
                    BI_PSPB_Patient__c = enrollee.AccountId,
                    BI_PSPB_Contact_Id__c = contactToInsert.Id
                );
                // Insert the BI_PSPB_Enrollee_Caregiver__c record
                Database.SaveResult[] saveResultsone = Database.insert(
                    new List<BI_PSPB_Enrollee_Caregiver__c>{ caregiverToInsert },
                    false
                );
                // Handle the save results
                
                for (Database.SaveResult saveResult : saveResultsone) {
                    if (!saveResult.isSuccess()) {
                        for (Database.Error error : saveResult.getErrors()) {
                            errorMsg += 'Error ' + error.getFields() +
                                '--' + error.getMessage() + '\n';
                        }
                    }
                }
                
                if (String.isNotBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                        saveResultsone, BI_PSPB_leadCreationCtrl.class.toString(),
                        System.now()
                    );
                    throw new AuraHandledException(recordInsertionFailed);
                }
            } else {
                throw new AuraHandledException( recordCannotFound );
            }
            if (contactToInsert != null) {
                return contactToInsert.Id;
            } else {
                throw new AuraHandledException( recordCannotFound );
            }
                
            }else{
                throw new AuraHandledException( recordCannotFound  );
            }
            // Return the Id of the inserted Contact record
        } catch (Exception ex) {
            // Log and handle the exception
            BI_SFCOE_LOG_Util.handleException(
                ex,applicationName, BI_PSPB_LeadCreationCtrl.class.toString(),
                null,System.now()
            );
           throw new AuraHandledException(
                    recordCannotFound
                );
        }
            
        
    }
    /* 
@description Used to  the enroolee caregiver record for associate the patient and caregiver,
             return in lwc biPspbaddcaregiver all the wrapper class parameters null check in lwc 
@param       String patientId careprogram enrolle id
@param       String firstName Name of the Caregiver
@param       String email Name of the Caregiver
@return      return created  id
*/
    @AuraEnabled
    public static Id createEnroleeCargiver(
        String patientId,
        String firstName,
        String email
    ) {
        try {
        if(!String.isBlank(patientId) && String.isBlank(firstName) && !String.isBlank(email)){
            //Since this object is invoked from a Guest User Profile which has limited access, User Mode cannot be used here
            BI_PSPB_Enrollee_Caregiver__c caregiverToInsert = new BI_PSPB_Enrollee_Caregiver__c();
            CareProgramEnrollee enrollee = [
                SELECT Id, AccountId
                FROM CareProgramEnrollee
                WHERE Id = :patientId
                LIMIT 1
            ];
            contact contactvalue = [
                SELECT Id, Email
                FROM contact
                WHERE Email = :email
                LIMIT 1
            ];
            // Check if a valid CareProgramEnrollee record is found
            if (enrollee != null) {
                // Create a new BI_PSPB_Enrollee_Caregiver__c record
                caregiverToInsert = new BI_PSPB_Enrollee_Caregiver__c(
                    Name = firstName, // You may adjust this as needed
                    BI_PSPB_Care_Program_Enrollee__c = enrollee.Id,
                    BI_PSPB_Patient__c = enrollee.AccountId,
                    BI_PSPB_Contact_Id__c = contactvalue.Id
                );
                
                // Insert the BI_PSPB_Enrollee_Caregiver__c record
                Database.SaveResult[] saveResults = Database.insert(
                    new List<BI_PSPB_Enrollee_Caregiver__c>{ caregiverToInsert },
                    false
                );
                
                for (Database.SaveResult saveResult : saveResults) {
                    if (!saveResult.isSuccess()) {
                        for (Database.Error error : saveResult.getErrors()) {
                            errorMsg += 'Error ' + error.getFields() +
                                '--' + error.getMessage() + '\n';
                        }
                    }
                }
                
                if (String.isNotBlank(errorMsg)) {
                    BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
                        saveResults, BI_PSPB_leadCreationCtrl.class.toString(),
                        System.now()
                    );
                    throw new AuraHandledException(recordInsertionFailed);
                }
            }
            if (caregiverToInsert != null) {
                return caregiverToInsert.Id;
            } else {
                throw new AuraHandledException( recordCannotFound  );
            }// Return the Id of the inserted BI_PSPB_Enrollee_Caregiver__c record
         
            }
        else {
                throw new AuraHandledException( recordCannotFound  );
        }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,applicationName, BI_PSPB_LeadCreationCtrl.class.toString(),
                null, System.now()
            );
          throw new AuraHandledException(
                    recordCannotFound
                );
        }
    }
    /*  
@description     	Used to check if a caregiver record already exists based on the caregiver creation ID,
return in lwc biPspbHcpEnrollment
@param           	String CaregivercreateId: The ID of the caregiver record being created.
@return         	Returns a Boolean value indicating whether a caregiver record already exists.
*/
    
    @AuraEnabled(cacheable=true)
    public static Boolean getcothanks(String CaregivercreateId) {
        try {
            if(!String.isBlank(CaregivercreateId)){
            // Since the guest user has limited access, the data is returned to them, so user mode is not used.
            list<BI_PSPB_Lead_Caregiver__c> leadCaregiver = [
                SELECT
                Id,
                BI_PSPB_First_Name__c,
                BI_PSPB_Last_Name__c,
                BI_PSPB_E_mail_ID__c,
                BI_PSPB_Date_of_Birth__c,
                BI_PSPB_Phone_number__c,
                BI_PSPB_Relationship_to_Patient__c
                FROM BI_PSPB_Lead_Caregiver__c
                WHERE BI_PSPB_Lead__c = :CaregivercreateId
            ];
            // Since the guest user has limited access, the data is returned to them, so user mode is not used.
            if(!leadCaregiver.IsEmpty()){
                list<Contact> con = [
                    SELECT Id, Name
                    FROM Contact
                    WHERE
                    FirstName = :leadCaregiver[0].BI_PSPB_First_Name__c
                    AND LastName = :leadCaregiver[0].BI_PSPB_Last_Name__c
                    AND Email = :leadCaregiver[0].BI_PSPB_E_mail_ID__c
                    LIMIT 1
                ];
                if (con.size() == 1) {
                    return true;
                } else {
                    return false;
                }
                }else {
                    throw new AuraHandledException( recordCannotFound );
                }
             }else {
                throw new AuraHandledException( recordCannotFound );
            }
        } catch (Exception ex) {
            BI_SFCOE_LOG_Util.handleException(
                ex,applicationName, BI_PSPB_LeadCreationCtrl.class.toString(),
                null, System.now()
            );
            throw new AuraHandledException(
                    recordCannotFound
                );
        }
    }
/* @description  Wrapper classes are used to hold a group of related data fields together.used to createLead,
                caregiverCreate,hcpCreate,prescriptionrCreate,consentCreate,createCaregiverRecord.
* @param        firstname The new first name of the patient or caregiver.
* @param        lastname The new last name of the patient or caregiver.
* @param        email The new email address of the patient or caregiver.
* @param        dob The new birthdate of the patient or caregiver.
* @param        sex The new gender of the patient or caregiver.
* @param        lisence The new lisence for the practictioner.
* @param        street The new street address of the patient or caregiver.
* @param        city The new city of the patient or caregiver.
* @param        state The new state of the patient or caregiver.
* @param        country The new country of the patient or caregiver.
* @param        postalCode The new postal code of the patient or caregiver.
* @param        phone The new phone number of the patient or caregiver.
* @param  		relation The new relationwithPatient to the Patient.
* @param        drug The new drug select from the Healthcare provider.
* @param        unit The new unit of the drug which select from healthcare provider.
* @param        frequency The new frequency of the drug select from healthcare provider. 
* @param      	caregiverId this ID is used to query the caregiver record.
*/
    public class DataWrapper {
        @AuraEnabled
        public String firstName { get; set; }
        @AuraEnabled
        public String lastName { get; set; }
        @AuraEnabled
        public String email { get; set; }
        @AuraEnabled
        public String phone { get; set; }
        @AuraEnabled
        public String practice { get; set; }
        @AuraEnabled
        public String type { get; set; }
        @AuraEnabled
        public String lisence { get; set; }
        @AuraEnabled
        public String city { get; set; }
        @AuraEnabled
        public String street { get; set; }
        @AuraEnabled
        public String country { get; set; }
        @AuraEnabled
        public String state { get; set; }
        @AuraEnabled
        public String code { get; set; }
        @AuraEnabled
        public String sex { get; set; }
        @AuraEnabled
        public String dob { get; set; }
        @AuraEnabled
        public String relation { get; set; }
        @AuraEnabled
        public String drug { get; set; }
        @AuraEnabled
        public String unit { get; set; }
        @AuraEnabled
        public String frequency { get; set; }
        @AuraEnabled
        public String caregiverId { get; set; }
    }
}