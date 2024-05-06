/*
 * @description This BI_PSPB_LeadConvertMultiple class used to convert the Lead to Patient.
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023     Created             Initial development
 * 1.1      Ashif  04-Apr-2024     Updated             Catch log added
 */
public with sharing class BI_PSPB_LeadConvertMultiple {
	//custom labels
	private static String converted = System.Label.BI_PSPB_Converted;
	private static String patient = System.Label.BI_PSPB_Patient;
	private static String caregiver = System.Label.BI_PSPB_Caregiver;
	private static String contact = System.Label.BI_PSPB_Contact;
	private static String healthcareProvider = System.Label.BI_PSPB_Healthcare_Provider;
	private static String lead = System.Label.BI_PSPB_Lead;
	private static String proposal = System.Label.BI_PSPB_Proposal;
	private static String treatmentremainders = System.Label.BI_PSPB_Treatmentremainders;
	private static String newcontentupdate = System.Label.BI_PSPB_Newcontentupdate;
	private static String questionnaires = System.Label.BI_PSP_NotificationQuestionnaires;
	private static String available = System.Label.BI_PSP_Available;
	private static String symptomTracker = System.Label.BI_PSP_symptomtracker;
	private static String active = System.Label.BI_PSPB_Active;
	private static String challenge = System.Label.BI_PSP_Challenge;
	private static String challenges = System.Label.BI_PSP_challenges;
	private static String community = System.Label.BI_PSPB_Community;
	private static String leadNullError = System.Label.BI_PSPB_LeadNullError;
	private static String awardInsertError = System.Label.BI_PSPB_AwardInsertError;
	private static String careProgramPlanError = System.Label.BI_PSPB_CareProgramPlanError;
	private static String careprogramEnrolleeIdNull = System.Label.BI_PSPB_CareprogramEnrolleeIdNull;
	private static String notificationIdNull = System.Label.BI_PSPB_NotificationIdNull;
	private static String accountNullError = System.Label.BI_PSPB_AccountNullError;
	private static String enrolleeCaregiverInsert = System.Label.BI_PSPB_EnrolleeCaregiverInsert;
	private static String leadCaregiverNull = System.Label.BI_PSPB_LeadCaregiverNull;
	private static String contactInsertError = System.Label.BI_PSPB_ContactInsertError;
	private static String careprogramEnrolleeNull = System.Label.BI_PSPB_CareprogramEnrolleeNull;
	private static String careprogramEnrolleeInsertError = System.Label.BI_PSPB_CareprogramEnrolleeInsertError;
	private static string convertError = System.Label.BI_PSPB_convertError;
	private static string medError = System.Label.BI_PSPB_medcationError;
    private static string errorforaccountupdate ='';
    private static string errorforcareprogram ='';
    private static string errorforcontact ='';
    private static string errorforenrollecaregiver ='';
    private static string errorforcareprogramprovider ='';
    private static string errorformedication ='';
    private static string errorforpatientdoage ='';
    private static string errornotifiactionsetting ='';
    private static string errorforaward ='';
	private static String conId ='';
	private static List<BI_PSPB_Lead_Prescription__c> lstLeadPrescription;
	// To retrieve Application name from setting
	private static BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues(
		'PSPB'
	);
	// Application name of the System
	private static String applicationName = settings != null ? settings.BI_SFCOE_LOG_Application__c
		: '';
/*  
@description		Used to convert the Lead record
@param				List of lead ids 
*/
	public static void convertlead(list<ID> lstLeadID) {
		//This method is using create the lead
          
		try {
			// Prepare a list to hold LeadConvert objects
			List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
              if(!lstLeadID.isEmpty()){
			for (Id leadId : lstLeadID) {
				Database.LeadConvert lc = new Database.LeadConvert();
				lc.setLeadId(leadID);
				lc.setConvertedStatus(converted);
				lc.bypassaccountdedupecheck = false;
				lc.bypassContactDedupeCheck = false;
				// Add more settings as needed
				leadConverts.add(lc);
			}

			// Convert leads

			List<Database.LeadConvertResult> lcResults = Database.convertLead(
				leadConverts,
				false
			);

			// Extract Account IDs from conversion results
			List<Id> accountIds = new List<Id>();
			List<id> convertedLeadIds = new List<id>();
			Map<Id, Lead> leadMap = new Map<Id, Lead>();
			for (Database.LeadConvertResult lcr : lcResults) {
				if (lcr.isSuccess()) {
					accountIds.add(lcr.getAccountId()); // Collect successful conversion Account IDs
					convertedLeadIds.add(lcr.getLeadId()); // Collect successful conversion Lead IDs
				} else {
					// Build a string to collect all error messages
					String errorDetails = '';
					for (Database.Error err : lcr.getErrors()) {
						errorDetails += err.getStatusCode() + ': ' +
							err.getMessage() +'\n'; // Concatenate all error messages
					}
				
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'',
					System.now(),convertError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			}

			List<Lead> lstConvertedLeads = new List<Lead>();
			if (!convertedLeadIds.isEmpty()) {
				//There is no need to use user mode because this class operates as a system administrator.
				lstConvertedLeads = [
					SELECT
						Id,
						FirstName,
						LastName,
						Email,
						MobilePhone,
						BI_PSPB_Care_Program__c,
						HealthCloudGA__Gender__c,
						HealthCloudGA__BirthDate__c,
						BI_PSPB_Care_Program__r.Name,
						BI_PSPB_Enrolled_By__c,
						convertedAccountId,
						LeadSource,
						BI_PSPB_Physician_Name_c__c,
						BI_PSPB_Preferred_Communication_Method__c
					FROM Lead
					WHERE Id IN :convertedLeadIds
				];
			}
			if (!lstConvertedLeads.isEmpty()) {
				for (Lead l : lstConvertedLeads) {
					leadMap.put(l.convertedAccountId, l);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_LeadConvertMultiple.class.toString(),
					'',
					System.now(),
					leadNullError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			// Query the converted Accounts and original Leads
			//           Map<Id, Lead> leadMap = new Map<Id, Lead>();
			List<Account> accountsToUpdate = new List<Account>();
			//There is no need to use user mode because this class operates as a system administrator.

			List<Account> convertedAccounts = [
				SELECT
					Id,
					PersonEmail,
					FirstName,
					LastName,
					HealthCloudGA__Gender__pc,
					BI_PSP_Birthdate__c,
					BI_PSPB_Preferred_Communication_Method__c,
					PersonMobilePhone,
					PersonLeadSource,
					BI_PSPB_Enrolled_By__c,
					BI_PSPB_User_Type__c
				FROM Account
				WHERE Id IN :leadMap.keyset()
			];
			if (!convertedAccounts.isEmpty()) {
				// Update Account records with Lead's email
				for (Account acc : convertedAccounts) {
					Lead lead = leadMap.get(acc.Id); // Assuming you have a way to map back to the original Lead
					if (lead != null) {
						acc.PersonEmail = lead.Email;
						acc.HealthCloudGA__Gender__pc = lead.HealthCloudGA__Gender__c;
						acc.BI_PSP_Birthdate__c = lead.HealthCloudGA__BirthDate__c;
						acc.BI_PSPB_Preferred_Communication_Method__c = lead.BI_PSPB_Preferred_Communication_Method__c;
						acc.PersonEmail = lead.Email;
						acc.PersonMobilePhone = lead.MobilePhone;
						acc.PersonLeadSource = lead.LeadSource;
						acc.BI_PSPB_User_Type__c = patient;
						acc.BI_PSPB_Enrolled_By__c = lead.BI_PSPB_Enrolled_By__c;
						accountsToUpdate.add(acc);
					}
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_patientOnboarding.class.toString(),
					'',
					System.now(),
					leadNullError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			// Perform the update

			Database.SaveResult[] saveResult = Database.update(
				accountsToUpdate,
				false
			);
			// Iterate over each save result
			for (Database.SaveResult saveResults : saveResult) {
				if (!saveResults.isSuccess()) {
					for (Database.Error error : saveResults.getErrors()) {
						errorforaccountupdate +='Error ' + error.getFields() +'--' +error.getMessage() +'\n';
					}
				}
			}
			if (String.isNotBlank(errorforaccountupdate)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveResult,
					BI_PSPB_LeadConvertMultiple.class.toString(),System.now());
			}

			Map<Id, CareProgramEnrollee> careProgramEnrolleesToInsert = new Map<Id, CareProgramEnrollee>();
			map<string, string> mpPatientEnrollee = new Map<string, string>();
			list<CareProgramEnrollee> lstCareProgEnrolleeInsert = new List<CareProgramEnrollee>();
			for (Account acc : accountsToUpdate) {
				Lead lead = leadMap.get(acc.Id);
				if (lead != null) {
					String patient = lead.FirstName + ' ' + lead.LastName;
					Id careProgramId = lead.BI_PSPB_Care_Program__c;

					CareProgramEnrollee cpe = new CareProgramEnrollee(
						Name = patient +
							'-' +
							lead.BI_PSPB_Care_Program__r.Name,
						CareProgramId = careProgramId,
						LeadId = lead.Id,
						AccountId = acc.Id,
						BI_PSPB_Enrolled_By__c = lead.BI_PSPB_Enrolled_By__c
					);
					lstCareProgEnrolleeInsert.add(cpe);
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_patientOnboarding.class.toString(),
                     '',System.now(),leadNullError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}
			}
			if (!lstCareProgEnrolleeInsert.isEmpty()) {
				
					// insert lstCareProgEnrolleeInsert;
					Database.SaveResult[] savedResult = Database.insert(
						lstCareProgEnrolleeInsert,
						false
					);
					// Iterate over each save result
					for (Database.SaveResult saveResults : savedResult) {
						if (!saveResults.isSuccess()) {
							for (
								Database.Error error : saveResults.getErrors()
							) {
								errorforcareprogram +=
									'Error ' +
									error.getFields() +
									'--' +
									error.getMessage() +
									'\n';
							}
						}
					}
					if (String.isNotBlank(errorforcareprogram)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
							saveResult,
							BI_PSPB_LeadConvertMultiple.class.toString(),
							System.now()
						);
					}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_LeadConvertMultiple.class.toString(),
					'',
					System.now(),
					careprogramEnrolleeIdNull,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			if (!lstCareProgEnrolleeInsert.isEmpty()) {
				for (
					CareProgramEnrollee cpEnrollee : lstCareProgEnrolleeInsert
				) {
					careProgramEnrolleesToInsert.put(cpEnrollee.Id, cpEnrollee);
					mpPatientEnrollee.put(cpEnrollee.AccountId, cpEnrollee.Id);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_LeadConvertMultiple.class.toString(),
					'',
					System.now(),
					careprogramEnrolleeIdNull,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			// Collect Lead IDs from accountsToUpdate
			Set<Id> leadIds = new Set<Id>();
			for (Account acc : accountsToUpdate) {
				if (leadMap.containsKey(acc.Id)) {
					leadIds.add(leadMap.get(acc.Id).Id);
				}
			}

			// Query BI_PSPB_Lead_Caregiver__c records related to the collected Lead IDs
			Map<Id, BI_PSPB_Lead_Caregiver__c> leadCaregiverMap = new Map<Id, BI_PSPB_Lead_Caregiver__c>();
			//There is no need to use user mode because this class operates as a system administrator.
			List<BI_PSPB_Lead_Caregiver__c> leadCaregivers = [
				SELECT
					Id,
					BI_PSPB_First_Name__c,
					BI_PSPB_Last_Name__c,
					BI_PSPB_E_mail_ID__c,
					BI_PSPB_Date_of_Birth__c,
					BI_PSPB_Preferred_Communication_Method__c,
					BI_PSPB_Relationship_To_Patient__c,
					BI_PSPB_Phone_number__c,
					BI_PSPB_Lead__c
				FROM BI_PSPB_Lead_Caregiver__c
				WHERE BI_PSPB_Lead__c IN :leadIds
			];
			for (BI_PSPB_Lead_Caregiver__c leadCaregiver : leadCaregivers) {
				leadCaregiverMap.put(
					leadCaregiver.BI_PSPB_Lead__c,
					leadCaregiver
				);
			}
			Id recordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName()
				.get(caregiver)
				.getRecordTypeId();
			// We verify that all contact email addresses match existing email addresses; we are unable to use limit checks.
			List<Contact> cont = [SELECT id, Name, email FROM contact WHERE RecordType.Id = :recordTypeId];
			List<Contact> caregiverContactsToInsert = new List<Contact>();
			List<BI_PSPB_Enrollee_Caregiver__c> enrolleeCaregiversToInsert = new List<BI_PSPB_Enrollee_Caregiver__c>();

			// Collect caregiver contacts to insert
			for (Account acc : accountsToUpdate) {
				Lead lead = leadMap.get(acc.Id);
				if (lead != null && lead.HealthCloudGA__BirthDate__c != null) {
					Date birthdate = lead.HealthCloudGA__BirthDate__c;
					Date today = Date.today();
					Integer age = today.year() - birthdate.year();

					if (age < 18) {
						BI_PSPB_Lead_Caregiver__c leadCaregiver = leadCaregiverMap.get(
							lead.Id
						);
						//We are adding the nested if statement in accordance with the busness requirement.
						if(!cont.isEmpty()) {
						if (leadCaregiver != null &&
							cont[0].email != leadCaregiver.BI_PSPB_E_mail_ID__c) {
							Contact caregiverContact = new Contact(
								FirstName = leadCaregiver.BI_PSPB_First_Name__c,
								LastName = leadCaregiver.BI_PSPB_Last_Name__c,
								Email = leadCaregiver.BI_PSPB_E_mail_ID__c,
								BI_PSPB_Birthdate__c = leadCaregiver.BI_PSPB_Date_of_Birth__c,
								BI_PSPB_Preferred_Communication_Method__c = leadCaregiver.BI_PSPB_Preferred_Communication_Method__c,
								BI_PSPB_Relationship_To_Patient__c = leadCaregiver.BI_PSPB_Relationship_To_Patient__c,
								Phone = leadCaregiver.BI_PSPB_Phone_number__c,
								BI_PSPB_GrantAccess__c = true,
								RecordTypeId = recordTypeId);

							caregiverContactsToInsert.add(caregiverContact);
						}
					}
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'',
						System.now(),leadNullError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			}

			// Insert caregiver contacts
			if (!caregiverContactsToInsert.isEmpty()) {
				
					Database.SaveResult[] save = Database.insert(caregiverContactsToInsert,
						false);
					// Iterate over each save result
					for (Database.SaveResult saveResults : save) {
						if (!saveResults.isSuccess()) {
							for (Database.Error error : saveResults.getErrors()) {
								errorforcontact +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
							}
						}
					}
					if (String.isNotBlank(errorforcontact)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(save,BI_PSPB_LeadConvertMultiple.class.toString(),
							System.now());
					}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),
					'',System.now(),contactInsertError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			}

			// Query Contact records based on BI_PSPB_E_mail_ID__c from leadCaregivers
			Map<String, Contact> contactMap = new Map<String, Contact>();
			List<String> leadmaplist = new List<String>();
			for (
				BI_PSPB_Lead_Caregiver__c leadCaregiver : leadCaregiverMap.values()
			) {
				if (leadCaregiver.BI_PSPB_E_mail_ID__c != null) {
					leadmaplist.add(leadCaregiver.BI_PSPB_E_mail_ID__c);
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),
						'',System.now(),leadCaregiverNull,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			}
			// checks the caregiver exists or not
			//There is no need to use user mode because this class operates as a system administrator.
			List<Contact> lstcon = [
				SELECT Id, Name, Email
				FROM Contact
				WHERE Email IN :leadmaplist
			];
			if (!lstcon.isEmpty()) {
				for (Contact con : lstcon) {
					contactMap.put(con.Email, con);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_LeadConvertMultiple.class.toString(),
					'',
					System.now(),
					contactInsertError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			// Now, perform the operations inside the loop

			for (Account acc : accountsToUpdate) {
				Lead lead = leadMap.get(acc.Id);
				BI_PSPB_Lead_Caregiver__c leadCaregiver = leadCaregiverMap.get(
					lead.Id
				);
				Contact con;
				if (!contactMap.isEmpty() && leadCaregiver != null) {
					if (leadCaregiver.BI_PSPB_E_mail_ID__c != null) {
						con = contactMap.get(
							leadCaregiver.BI_PSPB_E_mail_ID__c
						);
					}
				}
				if (con != null) {
					conId = con.Id;
					BI_PSPB_Enrollee_Caregiver__c enrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
					BI_PSPB_Care_Program_Enrollee__c = mpPatientEnrollee.get(
						acc.Id
					),
					BI_PSPB_Contact_Id__c = conId,
					BI_PSPB_Patient__c = acc.Id,
					Name = acc.FirstName + ' ' + acc.LastName,
					BI_PSPB_Status__c = Active
				);
				enrolleeCaregiversToInsert.add(enrolleeCaregiver);
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),
						'',System.now(),contactInsertError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
				

			}

			// Insert enrollee caregivers
			if (!enrolleeCaregiversToInsert.isEmpty()) {
				
					// insert enrolleeCaregiversToInsert;

					Database.SaveResult[] result = Database.insert(
						enrolleeCaregiversToInsert,
						false
					);

					// Iterate over each save result
					for (Database.SaveResult saveResults : result) {
						if (!saveResults.isSuccess()) {
							for (Database.Error error : saveResults.getErrors()) {
								errorforenrollecaregiver +='Error ' +error.getFields() +'--' +error.getMessage() +'\n';
							}
						}
					}
					if (String.isNotBlank(errorforenrollecaregiver)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(result,
							BI_PSPB_LeadConvertMultiple.class.toString(),System.now());
					}
				
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_LeadConvertMultiple.class.toString(),
					'',
					System.now(),
					enrolleeCaregiverInsert,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}

			List<CareProgramProvider> lstprovider = new List<CareProgramProvider>();
			List<MedicationRequest> lstMediRequest = new List<MedicationRequest>();
			List<PatientMedicationDosage> lstPatMedValues = new List<PatientMedicationDosage>();

			for (Account acc : accountsToUpdate) {
				Lead lead = leadMap.get(acc.Id);
				if (lead != null) {
					lstLeadPrescription = getleadPrescription(lead.Id);
					List<Contact> lstphysician = getContact(
							lead.BI_PSPB_Physician_Name_c__c
						);
					if (
						!lstLeadPrescription.isEmpty() && !lstPhysician.isEmpty()
					) {
						
						CareProgramProvider cpp = new CareProgramProvider(
							BI_PSPB_Care_Program_Enrollee__c = mpPatientEnrollee.get(
								acc.Id
							),
							CareProgramProductId = lstLeadPrescription[0]
								.BI_PSPB_Drug__c,
							Status = Active,
							Name = lstphysician[0].Name,
							CareProgramContactId = lstphysician[0].Id,
							AccountId = lstphysician[0]
								.BI_PSPB_Practice_Name__c,
							Role = healthcareProvider
						);
						lstprovider.add(cpp);
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),
						'',System.now(),leadNullError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			}

			Database.SaveResult[] saveprovider = Database.insert(
				lstprovider,
				false
			);
			// Iterate over each save result
			for (Database.SaveResult saveResults : saveprovider) {
				if (!saveResults.isSuccess()) {
					// Log the error
					for (Database.Error error : saveResults.getErrors()) {
						errorforcareprogramprovider +='Error ' +error.getFields() +'--' +
							error.getMessage() +'\n';
					}
				}
			}
			if (String.isNotBlank(errorforcareprogramprovider)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveprovider,
					BI_PSPB_LeadConvertMultiple.class.toString(),System.now());
			}
			map<string, string> mpAccountProvider = new Map<string, string>();
			if (!lstprovider.isEmpty()) {
				for (CareProgramProvider cpp : lstprovider) {
					mpAccountProvider.put(cpp.AccountId, cpp.id);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_LeadConvertMultiple.class.toString(),
					'',
					System.now(),
					leadNullError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			Map<Id, String> careprogramMap = new Map<Id, String>();
			if (!lstConvertedLeads.isEmpty()) {
				for (Lead lead : lstConvertedLeads) {
					careprogramMap.put(lead.Id, lead.BI_PSPB_Care_Program__c);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_LeadConvertMultiple.class.toString(),
					'',
					System.now(),
					leadNullError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			List<Medication> medList = new List<Medication>();

			// Gather all unique careProgramId values
			Set<String> careProgrmIds = new Set<String>();
			if (!careprogramMap.isEmpty()) {
				for (String careProgramId : careprogramMap.values()) {
					careProgrmIds.add(careProgramId);
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'',
					System.now(),leadNullError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			}
			// Query Medication records based on all gathered BI_PSPB_Care_Program__c values
			// There is no need to use user mode because this class operates as a system administrator.
			List<Medication> meds = [
				SELECT Id, BI_PSPB_Care_Program__c
				FROM Medication
				WHERE BI_PSPB_Care_Program__c IN :careProgrmIds
				LIMIT 1
			];
			if (meds.isEmpty()) {
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_LeadConvertMultiple.class.toString(),
					'',
					System.now(),
					leadNullError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}
			// Create a map to store Medication records by careProgramId
			Map<String, List<Medication>> careProgramIdToMedsMap = new Map<String, List<Medication>>();
			for (Medication med : meds) {
				String careProgramId = med.BI_PSPB_Care_Program__c;
				if (!careProgramIdToMedsMap.containsKey(careProgramId)) {
					careProgramIdToMedsMap.put(careProgramId,new List<Medication>());
				}
				careProgramIdToMedsMap.get(careProgramId).add(med);
			}

			// Add the queried Medication records to medList based on careProgramId
			for (Id leadId : careprogramMap.keySet()) {
				String careProgramId = careprogramMap.get(leadId);
				if (careProgramIdToMedsMap.containsKey(careProgramId)) {
					medList.addAll(careProgramIdToMedsMap.get(careProgramId));
				}
			}

			// Check if lstLeadPrescription is null or empty
			if (lstLeadPrescription != null && !lstLeadPrescription.isEmpty()) {
				for (Account acc : accountsToUpdate) {
					Lead lead = leadMap.get(acc.Id);
					if (lead != null) {
						for (
							BI_PSPB_Lead_Prescription__c lp : lstLeadPrescription
						) {
							// Check if med is not null or empty before accessing med[0]
							//We are adding the nested if statement in accordance with the busness requirement.
							if (!medList.isEmpty()) {
								MedicationRequest mr = new MedicationRequest(
									BI_PSPB_Care_Program_Enrollee__c = mpPatientEnrollee.get(acc.Id),
									BI_PSPB_Care_Program_Provider__c = mpAccountProvider.get(acc.Id),
									Status = Active,Type = proposal,
									BI_PSPB_Care_Program_Product__c = lp.BI_PSPB_Drug__c,
									PrescribedDate = lp.BI_PSPB_Prescribed_Date__c,
                                    RefillsAllowed = Integer.valueOf(
									lp.BI_PSPB_of_Refills__c),MedicationId = medList[0].Id, // Access med[0] only if med is not empty
									PatientId = acc.Id);
								    lstMediRequest.add(mr);
							} else {
								// Handle case where med is null or empty
								BI_SFCOE_LOG_Util.logMessage(
									applicationName,
									BI_PSPB_LeadConvertMultiple.class
										.toString(),
									'',
									System.now(),
									accountNullError,
									BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
								);
							}
						}
					}
				}
			} else {
				// Handle case where lstLeadPrescription is null or empty more gracefully
				BI_SFCOE_LOG_Util.logMessage(
					applicationName,
					BI_PSPB_LeadConvertMultiple.class.toString(),
					'',
					System.now(),
					accountNullError,
					BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
				);
			}

			Database.SaveResult[] saveMediRequest = Database.insert(
				lstMediRequest,
				false
			);
			// Iterate over each save result
			for (Database.SaveResult saveResults : saveMediRequest) {
				if (!saveResults.isSuccess()) {
					for (Database.Error error : saveResults.getErrors()) {
						errorformedication +='Error ' +error.getFields() +'--' +
							error.getMessage() +'\n';
					}
				}
			}
			if (String.isNotBlank(errorformedication)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(saveMediRequest,
					BI_PSPB_LeadConvertMultiple.class.toString(),System.now());
			}
			for (MedicationRequest mr : lstMediRequest) {
				PatientMedicationDosage pmd = new PatientMedicationDosage(ParentRecordId = mr.Id);
				lstPatMedValues.add(pmd);
			}

			Database.SaveResult[] savePatMedValues = Database.insert(
				lstPatMedValues,
				false
			);
			// Iterate over each save result
			for (Database.SaveResult saveResults : savePatMedValues) {
				if (!saveResults.isSuccess()) {
					for (Database.Error error : saveResults.getErrors()) {
						errorforpatientdoage +='Error ' +error.getFields() +
							'--' +error.getMessage() +'\n';
					}
				}
			}
			if (String.isNotBlank(errorforpatientdoage)) {
				BI_SFCOE_LOG_Util.handleDatabaseSaveResults(savePatMedValues,
					BI_PSPB_LeadConvertMultiple.class.toString(),System.now());
			}
			List<String> notificationtypes = new List<String>{
				treatmentremainders,
				newcontentupdate,
				questionnaires,
				symptomTracker,
				challenges,
				community
			};
			// create the notification setting for paticular patient
			List<BI_PSP_Notification_Setting__c> notificationSettings = new List<BI_PSP_Notification_Setting__c>();
				for (Account acc : accountsToUpdate) {
					// Assuming AccoundIds is a List<Id> and Patient is a String
					if (acc != null) {
						for (String notificationType : notificationtypes) {
							BI_PSP_Notification_Setting__c ns = new BI_PSP_Notification_Setting__c();
							NS.Name = acc.FirstName + '-' + notificationType;
							NS.BI_PSP_Notification_Type__c = notificationType;
							NS.BI_PSP_Patient__c = acc.id; // Assuming you want to associate it with the first account in the list
							notificationSettings.add(ns);
						}
					} else {
						BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'',
							System.now(),accountNullError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
					}
				}
				if (!notificationSettings.isEmpty()) {
					Database.SaveResult[] savenotification = Database.insert(
						notificationSettings,
						false
					);
					// Iterate over each save result
					for (Database.SaveResult saveResults : savenotification) {
						if (!saveResults.isSuccess()) {
							for (Database.Error error : saveResults.getErrors()) {
							errornotifiactionsetting +='Error ' + error.getFields() + '--' + error.getMessage() +'\n';
							}
						}
					}
					if (String.isNotBlank(errornotifiactionsetting)) {
						BI_SFCOE_LOG_Util.handleDatabaseSaveResults(savenotification,
							BI_PSPB_LeadConvertMultiple.class.toString(),System.now());
					}
				} else {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'',
						System.now(),notificationIdNull,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}
			 

			List<Award> insertAward = new List<Award>(); // Moved the list declaration outside the loop
			Id ChallengeRecordType = Schema.SObjectType.HealthCloudGA__CareProgramPlanTemplate__c.getRecordTypeInfosByName()
				.get(System.Label.BI_PSP_Challenge)
				.getRecordTypeId();
			// Set to store unique AccountIds from the mpPatientEnrollee map
			Set<String> accIds = mpPatientEnrollee.keySet();
			// Query CareProgramEnrollee records for the specified AccountIds

			List<CareProgramEnrollee> enrollees = [
				SELECT Id, CareProgramId, AccountId
				FROM CareProgramEnrollee
				WHERE AccountId IN :accIds
			];

			// Initialize the map to associate AccountId with CareProgramEnrollee
			Map<Id, CareProgramEnrollee> enrolleeMap = new Map<Id, CareProgramEnrollee>();
			for (CareProgramEnrollee enrollee : enrollees) {
				// Map AccountId to the corresponding CareProgramEnrollee record
				enrolleeMap.put(enrollee.AccountId, enrollee);
			}
			// Set to store unique CareProgramIds from retrieved CareProgramEnrollees
			Set<Id> careProgramIds = new Set<Id>();
			for (CareProgramEnrollee enrollee : enrolleeMap.values()) {
				careProgramIds.add(enrollee.CareProgramId);
			}
			// Query for relevant HealthCloudGA__CareProgramPlanTemplate__c records
			// There is no need to use user mode because this class operates as a system administrator.
			List<HealthCloudGA__CareProgramPlanTemplate__c> careProgramTemplates = [
				SELECT
					Id,
					HealthCloudGA__CareProgram__c,
					HealthCloudGA__CarePlanTemplate__r.Name,
					HealthCloudGA__CarePlanTemplate__r.BI_PSP_Challenge_Level__c
				FROM HealthCloudGA__CareProgramPlanTemplate__c
				WHERE
					HealthCloudGA__CareProgram__c IN :careProgramIds
					AND RecordTypeId = :ChallengeRecordType
			];
			// Map to associate CareProgramId with corresponding CareProgramPlanTemplates
			Map<Id, List<HealthCloudGA__CareProgramPlanTemplate__c>> templatesByCareProgramId = new Map<Id, List<HealthCloudGA__CareProgramPlanTemplate__c>>();
			for (
				HealthCloudGA__CareProgramPlanTemplate__c template : careProgramTemplates
			) {
				if (!templatesByCareProgramId.containsKey(template.HealthCloudGA__CareProgram__c)) {
					templatesByCareProgramId.put(template.HealthCloudGA__CareProgram__c,
						new List<HealthCloudGA__CareProgramPlanTemplate__c>());
				}
				templatesByCareProgramId.get(template.HealthCloudGA__CareProgram__c).add(template);
			}

			// Iterate over the accountsToUpdate list
			for (Account acc : accountsToUpdate) {
				// Retrieve the corresponding Lead record from the leadMap
				Lead lead = leadMap.get(acc.Id);
				if (lead == null) {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'',
						System.now(),leadNullError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}

				// Retrieve the CareProgramEnrollee record using the map
				CareProgramEnrollee patientEnrollee = enrolleeMap.get(acc.Id);
				if (patientEnrollee == null) {
					BI_SFCOE_LOG_Util.logMessage(
						applicationName,
						BI_PSPB_LeadConvertMultiple.class.toString(),
						'',
						System.now(),
						careprogramEnrolleeIdNull,
						BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
					);
				}

				// Retrieve relevant CareProgramPlanTemplates based on CareProgramId
				List<HealthCloudGA__CareProgramPlanTemplate__c> relevantTemplates = templatesByCareProgramId.get(
					patientEnrollee.CareProgramId
				);
				if (relevantTemplates.isEmpty()) {
					BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),
						'',System.now(),careProgramPlanError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
				}

				// Retrieve the Award record type ID for BI_PSP_Challenge
				Id awardRecordType = Schema.SObjectType.Award.getRecordTypeInfosByName().get(challenge)
				.getRecordTypeId();
				// Create Award records based on relevant CareProgramPlanTemplates
				for (HealthCloudGA__CareProgramPlanTemplate__c template : relevantTemplates) {
					Award challengeAward = new Award();
					String awardName = template.HealthCloudGA__CarePlanTemplate__r.Name +
						' - ' + template.HealthCloudGA__CarePlanTemplate__r.BI_PSP_Challenge_Level__c;
					challengeAward.Name = awardName;
					challengeAward.RecordTypeId = awardRecordType;
					challengeAward.BI_PSP_Care_Program_Enrollee__c = patientEnrollee.Id;
					challengeAward.BI_PSP_Care_Program_Plan_Template__c = template.Id;
					challengeAward.BI_PSP_Reward_Points__c = 0;
					challengeAward.BI_PSP_Status__c = available; // Assuming 'Available' is a valid picklist value

					insertAward.add(challengeAward); // Add to the list for bulk insertion
				}
			}

			if (!insertAward.isEmpty()) {
				// Check if there are awards to insert before performing DML operation

				Database.SaveResult[] saveResulted = Database.insert(
					insertAward,
					false
				);
				// Iterate over each save result
				for (Database.SaveResult saveResults : saveResulted) {
					if (!saveResults.isSuccess()) {
						for (Database.Error error : saveResults.getErrors()) {
							errorforaward +='Error ' +error.getFields() +'--' + error.getMessage() +'\n';
						}
					}
				}
				if (String.isNotBlank(errorforaward)) {
					BI_SFCOE_LOG_Util.handleDatabaseSaveResults(
						saveResulted,BI_PSPB_LeadConvertMultiple.class.toString(),System.now());
				}
			} else {
				BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'',
					System.now(),awardInsertError,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			}
		}else {
			BI_SFCOE_LOG_Util.logMessage(
				applicationName,
				BI_PSPB_LeadConvertMultiple.class.toString(),
				'',
				System.now(),
				leadNullError,
				BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR
			);
		}
		} catch (Exception ex) {
			// Handle exception
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),
				null,System.now());
		}
	}
	//@description This method is useful for fetching prescription records associated with a lead
	//@param leadId - converted leadId
	//@return lstLeadPrescription list containing the queried prescription records.
	private static List<BI_PSPB_Lead_Prescription__c> getleadPrescription(
		Id leadId
	) {

        List<BI_PSPB_Lead_Prescription__c> lstLeadPrescription;
	try {
		if(leadId != null || leadId !=''){
		// There is no need to use user mode because this class operates as a system administrator.
		lstLeadPrescription = [
			SELECT
				Id,
				BI_PSPB_Drug__r.Name,
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
			WHERE BI_PSPB_Lead__c = :leadId
			LIMIT 1
		];

		if (lstLeadPrescription.isEmpty()) {
			BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'', 
	System.now(),medError + leadId,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
		} 
	}
	else{
		BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'', 
		System.now(),medError + leadId,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
	}
	}catch (Exception ex) {
			BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_LeadConvertMultiple.class.getName(),
				null,System.now());
				
		}
       return lstLeadPrescription;
	}

	//@description This method is useful for fetching Contact records associated with a lead
	//@param physicianname - converted leadId's physician name
	//@return lstphysician list containing the queried Contact records.
	private static List<Contact> getContact(Id physicianId) {
        List<Contact> lstPhysician;
		try{
			if(physicianId != null || physicianId != ''){
		// There is no need to use user mode because this class operates as a system administrator.
		lstPhysician = [
			SELECT Id, Name, BI_PSPB_Practice_Name__c
			FROM Contact
			WHERE Id = :physicianId
			LIMIT 1
		];

		if (lstPhysician.isEmpty()) {
            // Logging an error message since the queried list is empty
			BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'', 
				System.now(),contact+ physicianId,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
			
		} 
	
    }else{
		BI_SFCOE_LOG_Util.logMessage(applicationName,BI_PSPB_LeadConvertMultiple.class.toString(),'', 
				System.now(),contact+ physicianId,BI_SFCOE_LOG_Util.LOG_SEVERITY_ERROR);
	}
	}
	catch (Exception ex) {
		BI_SFCOE_LOG_Util.handleException(ex,applicationName,BI_PSPB_LeadConvertMultiple.class.getName(),
			null,System.now());
			
	}
        return lstPhysician;
	}
	
}