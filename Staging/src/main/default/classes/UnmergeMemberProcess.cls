public class UnmergeMemberProcess {
    
   		 @AuraEnabled 				
			public static List<object> GetMemberList()
			{
				
				List<object> listObj = new List<object>(); 

    			date LastNDays = system.today().addDays(-30);
    			system.debug('LastNDays###' + LastNDays);			
				List<Account> accounts = new List<Account>();				
    			accounts =[SELECT Id, FirstName,Home_Phone_Number__c, Email_raw__c, LastName, Name, Residential_City__pc,Residential_Country__pc,Residential_Street__pc,Mobile_Phone__pc,
    										Converted_On__c, Residential_Country_Code__pc,Residential_Extra_Address__pc,Residential_State__pc, Residential_Zipocde__pc FROM Account where RecordType.Name = 'Person Account' and Converted_On__c >: LastNDays and IsConverted__c=true order by Converted_On__c desc];   			
		        
    			listObj.Add(accounts);			
				
				return listObj;
			}
    
    @AuraEnabled			
    public static string UnMergeMemberAccount(Id mid){
    	 Converted_PreMember__c cpm = [SELECT First_Name__c, Middle_Name__c,Last_Name__c,Alternate_Email__c,Alt_E_Mail_Address__c,Annual_Revenue__c,Assistant__c,Parent_Lead__c,
								    	 ID_1_Type__c, Email_raw__c,Asst_Phone__c,Birthdate__c,Birth_Date__c,Converted_On__c,CreatedById,CreatedDate,Death_Date__c,
								    	 Department__c,Description__c,Do_Not_Call__c,Email_Opt_Out__c,Employees__c,Employee_Restricted_Access__c,
								    	 Employer_Name__c,Employer_Occupation__c,Extended_Name__c,E_Mail_Address__c,Fax_Opt_Out__c,Fax__c,
								    	 Home_Phone_Number__c,Home_Phone__c,Id,ID_1_Description__c,ID_1_Expiration_Date__c,ID_1_Issuance_Date__c,
								    	 ID_1_Number__c,ID_1_Verification_Date__c,ID_2_Description__c,ID_2_Expiration_Date__c,ID_2_Issuance_Date__c,
								    	 ID_2_Number__c,ID_2_Type1__c,ID_2_Type__c,ID_2_Verification_Date__c,ID_3_Description__c,ID_3_Expiration_Date__c,
								    	 ID_3_Issuance_Date__c,ID_3_Number__c,ID_3_Type_1__c,ID_3_Type__c,ID_3_Verification_Date__c,Industry__c,
								    	 Initial_Record__c,IsConverted__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastModifiedDate__c,
								    	 Last_NA_LEHS__c,Last_NA__c,Last_Stay_in_Touch_Request_Date__c,Last_Stay_in_Touch_Save_Date__c,Lead_Source__c,
								    	 Mailing_Address__c,Member_Number__c,Member_Record_Type__c,Member_Site__c,Member_Source__c,
								    	 NA_Eligibility__c,NA_LEHS_Complete__c,NA_LEHS_Update__c,NA_LEOM_Complete__c,NA_LEOM_Update__c,NA_Opt_Out__c,NA_Opt_Out_Date__c,NA_Opt_Out_Updated__c,
    									 NA_LEAV_Complete__c,NA_LECF_Complete__c,NA_LECP_Complete__c,NA_LEEM_Complete__c,NA_LEMD_Complete__c,NA_LEMP_Complete__c,NA_LEMQ_Complete__c,NA_LEOL_Complete__c,
    									 NA_LEPT_Complete__c,NA_LESB_Complete__c,NA_LESF_Complete__c,NA_LEWS_Complete__c,
								    	 Residential_City__c, Residential_Country__c, Residential_Country_Code__c, Residential_Extra_Address__c, Residential_State__c, Residential_Street__c, Residential_Zipcode__c, Occupation__c, Work_Phone__c, Work_Phone_Extension__c, Work_Phone_Number__c, Mobile__c,Mobile_Country_Code__c, Mobile_Opt_Out__c, Mobile_Phone_Number__c, Mothers_Maiden_Name__c,  Member_Verification_OTP_Invalid_Attempt__c,Name,Name__c,OwnerId,Pre_Member_Number__c,SystemModstamp FROM Converted_PreMember__c where Member__c =: mid limit 1];
    	 Account ma  = [SELECT Id,Pre_Member_Number__c, PersonEmail,FirstName,MiddleName,LastName,Salutation ,Suffix, Owner.Name,Parent_Lead__c,CreatedDate,Phone_Check__c, Residential_Street__pc, RecordType.Name, Residential_Zipocde__pc, Alternate_Email__pc,
    										  Alt_Email_Raw__c, AnnualRevenue,Bad_Email__c, BillingCity,BillingCountry,BillingCountryCode,BillingGeocodeAccuracy,BillingLatitude,
    										  BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,BillingStreet,BIRTH_DATE__pc,IsCustomerPortal,Death_Date__pc,Description,Email_raw__c,
    										  Employee_Restricted_Access__c,NumberOfEmployees,Employer_Name__pc,Employer_Occupation__pc,Extended_Name__pc,Fax,Home_Phone_Number__c,Home_Phone__pc,
    										  ID_1_Description__pc,ID_1_Expiration_Date__pc,ID_1_Issuance_Date__pc,ID_1_Number__pc,ID_1_Type__pc,ID_1_Type__c,ID_1_Verification_Date__pc,
    										  ID_2_Description__pc,ID_2_Expiration_Date__pc,ID_2_Issuance_Date__pc,ID_2_Number__pc,ID_2_Type__pc,ID_2_Verification_Date__pc,ID_3_Description__pc,
    										  ID_3_Expiration_Date__pc,ID_3_Issuance_Date__pc,ID_3_Number__pc,ID_3_Type__pc,ID_3_Verification_Date__pc,Industry,Initial_Record__pc,
    										  LastModifiedDate__pc,AccountNumber,Site,AccountSource,Member_Verification_OTP_Invalid_Attempt__c,et4ae5__Mobile_Country_Code__pc,
    										  et4ae5__HasOptedOutOfMobile__pc,Mobile_Phone__pc,Mothers_Maiden_Name__pc,Multi_Name__pc,MultiAddress__pc,MultiDOB__pc,MultiMMN__pc,MultiSSN__pc,
    										  NA_Eligibility__c,NA_LEHS_Complete__c,NA_LEHS_Update__c,NA_LEOM_Complete__c,NA_LEOM_Update__c,NA_Opt_Out__c,NA_Opt_Out_Date__c,NA_Opt_Out_Updated__c,
    										  NA_LEAV_Complete__c,NA_LECF_Complete__c,NA_LECP_Complete__c,NA_LEEM_Complete__c,NA_LEMD_Complete__c,NA_LEMP_Complete__c,NA_LEMQ_Complete__c,NA_LEOL_Complete__c,
    										  NA_LEPT_Complete__c,NA_LESB_Complete__c,NA_LESF_Complete__c,NA_LEWS_Complete__c,Name_Format__pc,Occupation__pc,Onbase_Drivers_License__c,
    										  Onbase_Signature_Card__c,Ownership,PersonID__pc,Phone,Phone_Type__pc,Rating,Residential_City__pc,Residential_Country__pc,
    										  Residential_Country_Code__pc,Residential_Extra_Address__pc,Residential_State__pc,Sex__pc,ShippingCity,ShippingCountry,ShippingCountryCode,
    										  ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,
    										  PersonLeadSource, Last_NA__c, Last_NA_LEHS__c, Converted_On__c,IsConverted__c, PersonDepartment,PersonLastCURequestDate,PersonLastCUUpdateDate,  PersonAssistantName,PersonAssistantPhone,PersonBirthdate,PersonDoNotCall, PersonHasOptedOutOfEmail,PersonHasOptedOutOfFax, Sic,SicDesc,smagicinteract__SMSOptOut__pc,SSN_Last_4__pc,SSN_TIN_Encrypted__pc,SSN_TIN_Type__pc,TickerSymbol,Type,Website,Work_Phone_Extension__pc,Work_Phone__pc
    										  FROM Account where RecordType.Name = 'Person Account' and Id=:mid];
    	String RecTypeId= [select Id from RecordType where (Name='Pre Member') and (SobjectType='Account')].Id;
    	
    	Account pma = new Account();
    	pma.RecordTypeID=RecTypeId;

    	pma.Member__c = null;
    	pma.Pre_Member_Number__c = cpm.Pre_Member_Number__c;
    	pma.Parent_Lead__c = cpm.Parent_Lead__c;
    	pma.Alternate_Email__pc= cpm.Alt_E_Mail_Address__c;
    	pma.Alt_Email_Raw__c =cpm.Alternate_Email__c;
    	pma.AnnualRevenue = cpm.Annual_Revenue__c;
    	pma.PersonAssistantName = cpm.Assistant__c;
		pma.PersonAssistantPhone = cpm.Asst_Phone__c;
		//String.valueOf(pma.Billing_Address__c) = cpm.BillingAddress;
		pma.PersonBirthdate = cpm.Birthdate__c;
		pma.BIRTH_DATE__pc =cpm.Birth_Date__c;
		//pma.Converted_On__c = cpm.Converted_On__c;			
						
		pma.Death_Date__pc =cpm.Death_Date__c;
		pma.PersonDepartment = cpm.Department__c;
		pma.Description =cpm.Description__c;
		pma.PersonDoNotCall = cpm.Do_Not_Call__c;
		pma.PersonHasOptedOutOfEmail = cpm.Email_Opt_Out__c;
		pma.Email_raw__c = cpm.Email_raw__c;
		//pma.NumberOfEmployees = cpm.Employees__c;
		pma.Employee_Restricted_Access__c =cpm.Employee_Restricted_Access__c;
		pma.Employer_Name__pc = cpm.Employer_Name__c;
		pma.Employer_Occupation__pc = cpm.Employer_Occupation__c;
		pma.Extended_Name__pc = cpm.Extended_Name__c;
		pma.Email_raw__c = cpm.E_Mail_Address__c;
		pma.PersonHasOptedOutOfFax = cpm.Fax_Opt_Out__c;
		pma.Fax=cpm.Fax__c;
		pma.Home_Phone_Number__c =cpm.Home_Phone_Number__c;
		pma.Home_Phone__pc=cpm.Home_Phone__c;					    
		pma.ID_1_Description__pc =cpm.ID_1_Description__c;
		pma.ID_1_Expiration_Date__pc =cpm.ID_1_Expiration_Date__c;
		pma.ID_1_Issuance_Date__pc=cpm.ID_1_Issuance_Date__c;
		pma.ID_1_Number__pc =cpm.ID_1_Number__c;
		pma.ID_1_Verification_Date__pc=cpm.ID_1_Verification_Date__c;
		pma.ID_2_Description__pc=cpm.ID_2_Description__c;
		pma.ID_2_Expiration_Date__pc =cpm.ID_2_Expiration_Date__c;
		pma.ID_2_Issuance_Date__pc =cpm.ID_2_Issuance_Date__c;
		pma.ID_2_Number__pc =cpm.ID_2_Number__c;
	    pma.ID_1_Type__Pc =cpm.ID_1_Type__c;
		pma.ID_2_Type__pc =cpm.ID_2_Type__c;
		pma.ID_2_Verification_Date__pc =cpm.ID_2_Verification_Date__c;
		pma.ID_3_Description__pc = cpm.ID_3_Description__c;
		pma.ID_3_Expiration_Date__pc =cpm.ID_3_Expiration_Date__c;
		pma.ID_3_Issuance_Date__pc =cpm.ID_3_Issuance_Date__c;
		pma.ID_3_Number__pc = cpm.ID_3_Number__c;
		
		pma.ID_3_Type__pc =cpm.ID_3_Type__c;
		pma.ID_3_Verification_Date__pc =cpm.ID_3_Verification_Date__c;
		pma.Industry =cpm.Industry__c;
		pma.Initial_Record__pc =cpm.Initial_Record__c;
		pma.IsConverted__c = false;					
		
	
		
		pma.PersonLeadSource =cpm.Lead_Source__c;
		//pma.Mailing_Address__c=cpm.PersonMailingAddress;
		pma.AccountNumber =cpm.Member_Number__c;
		pma.RecordTypeId =cpm.Member_Record_Type__c;
		pma.Site =cpm.Member_Site__c;
		pma.AccountSource = cpm.Member_Source__c;
		pma.Member_Verification_OTP_Invalid_Attempt__c = cpm.Member_Verification_OTP_Invalid_Attempt__c;
						
		//pma.Name =cpm.Name__c;
						
		pma.Pre_Member_Number__c =cpm.Pre_Member_Number__c;	
		pma.NA_Eligibility__c = ma.NA_Eligibility__c;
		pma.NA_LEHS_Complete__c= ma.NA_LEHS_Complete__c;
		pma.NA_LEHS_Update__c = ma.NA_LEHS_Update__c; 
		pma.NA_LEOM_Complete__c = ma.NA_LEOM_Complete__c;
		pma.NA_LEOM_Update__c = ma.NA_LEOM_Update__c;
		pma.NA_Opt_Out__c = ma.NA_Opt_Out__c;
		pma.NA_Opt_Out_Date__c = ma.NA_Opt_Out_Date__c;
		pma.NA_Opt_Out_Updated__c = ma.NA_Opt_Out_Updated__c;
		pma.NA_LEAV_Complete__c = ma.NA_LEAV_Complete__c;
		pma.NA_LECF_Complete__c = ma.NA_LECF_Complete__c;
		pma.NA_LECP_Complete__c = ma.NA_LECP_Complete__c;
		pma.NA_LEEM_Complete__c = ma.NA_LEEM_Complete__c;
		pma.NA_LEMD_Complete__c = ma.NA_LEMD_Complete__c;
		pma.NA_LEMP_Complete__c = ma.NA_LEMP_Complete__c;
		pma.NA_LEMQ_Complete__c = ma.NA_LEMQ_Complete__c;
		pma.NA_LEOL_Complete__c = ma.NA_LEOL_Complete__c;
		pma.NA_LEPT_Complete__c = ma.NA_LEPT_Complete__c;
		pma.NA_LESB_Complete__c = ma.NA_LESB_Complete__c;
		pma.NA_LESF_Complete__c = ma.NA_LESF_Complete__c;
		pma.NA_LEWS_Complete__c = ma.NA_LEWS_Complete__c;	
		pma.LastName = cpm.Last_Name__c;	
		pma.FirstName = cpm.First_Name__c;	
		pma.MiddleName = cpm.Middle_Name__c;
		pma.PersonOtherPhone = cpm.Work_Phone__c;
    	pma.Work_Phone_Extension__pc = cpm.Work_Phone_Extension__c;
    	pma.Work_Phone__pc = cpm.Work_Phone_Number__c;
    	pma.PersonMobilePhone = cpm.Mobile__c;
    	pma.et4ae5__Mobile_Country_Code__pc = cpm.Mobile_Country_Code__c;
    	pma.et4ae5__HasOptedOutOfMobile__pc = cpm.Mobile_Opt_Out__c;
    	pma.Mobile_Phone__pc = cpm.Mobile_Phone_Number__c;
    	pma.Mothers_Maiden_Name__pc = cpm.Mothers_Maiden_Name__c;
    	pma.Occupation__pc = cpm.Occupation__c;		
    		
    	pma.Residential_City__pc = cpm.Residential_City__c;
    	pma.Residential_Country__pc = cpm.Residential_Country__c;
    	pma.Residential_Country_Code__pc = cpm.Residential_Country_Code__c;
    	pma.Residential_Extra_Address__pc = cpm.Residential_Extra_Address__c;    				
    	pma.Residential_State__pc = cpm.Residential_State__c;
    	pma.Residential_Street__pc = cpm.Residential_Street__c;
    	pma.Residential_Zipocde__pc = cpm.Residential_Zipcode__c;	
    	insert pma;
    	system.debug('pma===='+ pma.id);
    	List<Needs_Assesment__c> NAForCPM = new List<Needs_Assesment__c>();
    	List<Needs_Assesment__c> NAForPM = new List<Needs_Assesment__c>();		
    	
    	ma.IsConverted__c=false;
    	ma.Converted_On__c = null;
    	ma.NA_Eligibility__c = false;
		ma.NA_LEHS_Complete__c= false;
		ma.NA_LEHS_Update__c = null;
		ma.NA_LEOM_Complete__c = false;
		ma.NA_LEOM_Update__c = null;
		ma.NA_Opt_Out__c = false;
		ma.NA_Opt_Out_Date__c = null;
		ma.NA_Opt_Out_Updated__c = null;
		ma.NA_LEAV_Complete__c = false;
		ma.NA_LECF_Complete__c = false;
		ma.NA_LECP_Complete__c =false;
		ma.NA_LEEM_Complete__c = false;
		ma.NA_LEMD_Complete__c = false;
		ma.NA_LEMP_Complete__c = false;
		ma.NA_LEMQ_Complete__c = false;
		ma.NA_LEOL_Complete__c = false;
		ma.NA_LEPT_Complete__c = false;
		ma.NA_LESB_Complete__c = false;
		ma.NA_LESF_Complete__c = false;
		ma.NA_LEWS_Complete__c = false;
    	update ma;
		
		NAForPM =[SELECT Rec_Comment_New__c,LEWS_Comment_New__c,LESF_Comments_New__c,LESB_SharedBranching_Comments_New__c,LEPT_Comments_New__c,LEOM_PlanUnforeseen_New__c,
		    						LEOM_Comments_New__c,LEMP_Transfer_Comments_New__c,LEMP_Payment_Transfer_Comments_New__c,LEMP_International_Transfer_Comments_New__c,
		    						LEMP_Debit_Card_Usage_Comments_New__c,LEMP_Credit_Card_You_Use_Often_New__c,LEMP_Credit_Card_Usage_Reason_Comments_N__c,
		    						LEMP_Credit_Card_Usage_Other_New__c,LEMP_Credit_Card_Usage_Comments_New__c,LEMD_CommentsForDD_New__c,LEMD_CommentsDC_New__c,
		    						LEHS_Comment_New__c,LEEM_Comments_New__c,LEAV_ContactPreferences_New__c,LECF_Comment_New__c,LECF_Experience_Improvement_Feedback_New__c,
		    						Member__r.BIRTH_DATE__pc, CDs__c,College_Plan__c,College_Timeframe__c,College__c,Complete_PFCE__c,CreatedById,
		    						CreatedDate,Do_you_Rent_or_Own__c,EBMS_Complete__c,EMYS_Complete__c,Home_Improvement_Plan__c,
		    						Home_Improvement_Timeframe__c,Home_Improvement__c,Housing_Last_Updated_On__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,
		    						LastReferencedDate,LastViewedDate,Last_LEHS__c,Last_LEOM__c,LEAV_AnticipateFinance__c,LEAV_ContactPreferences__c,LEAV_CurrentBalance__c,
		    						LEAV_CurrentLoanProvider__c,LEAV_CurrentRate__c,LEAV_Current__c,LEAV_EndDateLoan__c,LEAV_Last_Updated_On__c,LEAV_PlanDate__c,LEAV_PlanningToBuy__c,
		    						LECF_800_Feedback__c,LECF_800__c,LECF_ATM_Feedback__c,LECF_ATM__c,LECF_Branch_Feedback__c,LECF_Branch__c,LECF_Comment__c,LECF_Experience_Improvement_Feedback__c,
		    						LECF_Last_Updated_On__c,LECF_Member_Feedback__c,LECF_Mobile_banking_Feedback__c,LECF_Mobile_banking__c,LECF_Online_banking_Feedback__c,
		    						LECF_Online_banking__c,LECP_Comments__c,LECP_ContactPhone_No__c,LECP_ContactPhone_Yes__c,LECP_Last_Updated_On__c,LECP_Written_Materials_Way_To_Send_Email__c,
		    						LECP_Written_Materials_Way_To_Send_Mail__c,LEEM_Comments__c,LEEM_Deductible_Plan_No__c,LEEM_Deductible_Plan_Yes__c,LEEM_Deductible_Plan__c,
		    						LEEM_Health_Savings_Account_No__c,LEEM_Health_Savings_Account_Yes__c,LEEM_Health_Savings_Account__c,LEEM_Last_Updated_On__c,LEEM_Money_In_Primary_Account__c,
		    						LEEM_Retirement_Savings_Accounts_Comment__c,LEEM_Savings_For_Retirement_401__c,LEEM_Savings_For_Retirement_IRA__c,LEEM_Savings_For_Retirement_O_Account__c,
		    						LEEM_Savings_For_Retirement_O_R_Account__c,LEHS_1_Status__c,LEHS_2_Status__c,LEHS_Comment__c,LEHS_Complete__c,LEHS_Current_Balance__c,LEHS_Current_Lender__c,
		    						LEHS_End_Date__c,LEHS_End_Year__c,LEHS_Have_Realtor__c,LEHS_Last_Updated_On__c,LEHS_Planning_to_Purchase__c,LEHS_Purchase_When__c,LEHS_Rate__c,LEHS_Type_of_Mortgage__c,
		    						LEMD_ATM__c,LEMD_At_another_financial_institution__c,LEMD_At_another_financial_insti_YesNo__c,LEMD_CFCU_Spectrum_YesNo__c,LEMD_CFCU_Spectrum__c,LEMD_CommentsDC__c,
		    						LEMD_CommentsForDD__c,LEMD_In_person_branch__c,LEMD_Last_Updated_On__c,LEMD_Mobile__c,LEMD_No__c,LEMD_Online__c,LEMP_Carry_Credit_Card_Balance__c,
		    						LEMP_Credit_Card_Usage_Cash_Back__c,LEMP_Credit_Card_Usage_Comments__c,LEMP_Credit_Card_Usage_Low_Interest_Rate__c,LEMP_Credit_Card_Usage_No_Annual_Fee__c,
		    						LEMP_Credit_Card_Usage_Other__c,LEMP_Credit_Card_Usage_Reason_Comments__c,LEMP_Credit_Card_Usage_Rewards__c,LEMP_Credit_Card_You_Use_Often__c,
		    						LEMP_Debit_Card_Usage_Comments__c,LEMP_Debit_Card_Usage_Gasstation__c,LEMP_Debit_Card_Usage_Grocries__c,LEMP_Debit_Card_Usage_Online__c,LEMP_Debit_Card_Usage_Other__c,
		    						LEMP_Debit_Card_Usage_Retail__c,LEMP_International_Transfer_Comments__c,LEMP_International_Transfer_Frequency__c,LEMP_Last_Updated_On__c,LEMP_Payment_Transfer_Comments__c,
		    						LEMP_Pay_Individuals_A2A__c,LEMP_Pay_Individuals_ACH__c,LEMP_Pay_Individuals_BillPay__c,LEMP_Pay_Individuals_CC__c,LEMP_Pay_Individuals_Check__c,LEMP_Pay_Individuals_DC__c,
		    						LEMP_Pay_Individuals_Other__c,LEMP_Pay_MoveMoney_A2A__c,LEMP_Pay_MoveMoney_ACH__c,LEMP_Pay_MoveMoney_BillPay__c,LEMP_Pay_MoveMoney_CC__c,LEMP_Pay_MoveMoney_Check__c,
		    						LEMP_Pay_MoveMoney_DC__c,LEMP_Pay_MoveMoney_Other__c,LEMP_Pay_Recurring_A2A__c,LEMP_Pay_Recurring_ACH__c,LEMP_Pay_Recurring_BillPay__c,LEMP_Pay_Recurring_CC__c,
		    						LEMP_Pay_Recurring_Check__c,LEMP_Pay_Recurring_DC__c,LEMP_Pay_Recurring_Other__c,LEMP_Transfer_Comments__c,LEMP_Transfer_Frequency__c,LEMQ_Last_Updated_On__c,
		    						LEOL_Last_Updated_On__c,LEOL_Other_Existing_Loans__c,LEOM_1_Status__c,LEOM_2_Status__c,LEOM_3_Status__c,LEOM_4_Status__c,LEOM_5_Status__c,LEOM_6_Status__c,
		    						LEOM_7_Status__c,LEOM_College_Update__c,LEOM_Comments__c,LEOM_Complete__c,LEOM_Home_Update__c,LEOM_Last_Updated_On__c,LEOM_Life_Events_Update__c,
		    						LEOM_Medical_Update__c,LEOM_Other_Expenses_Update__c,LEOM_PlanUnforeseen__c,LEOM_Retirement_Update__c,LEOM_RV_Boat_Update__c,LEOM_Travel_Update__c,LEPT_Comments__c,
		    						LEPT_Convenient_locations__c,LEPT_Deposit_rates__c,LEPT_Financial_Institution__c,LEPT_Have_financial_advisor_there__c,LEPT_Last_Response_Date_for_Comments__c,
		    						LEPT_Last_Response_Date_For_FI__c,LEPT_Last_Updated_On__c,LEPT_Loan_rates__c,LEPT_Online_mobile_apps__c,LEPT_Other__c,LESB_Aware_ConvBranching__c,
		    						LESB_Aware_SharedBranching__c,LESB_Last_Updated_On__c,LESB_SharedBranching_Comments__c,LESF_ATM_Location_YesNo__c,LESF_ATM_Location__c,
		    						LESF_Aware_ATM_Netword__c,LESF_Aware_ATM_Network_YesNo__c,LESF_Comments__c,LESF_Last_Updated_On__c,LEWS_CFCU_ATM__c,LEWS_Comment__c,LEWS_InPerson__c,
		    						LEWS_Last_Updated_On__c,LEWS_Other_ATM__c,LEWS_Shared_ATM__c,Life_Events_Plan__c,Life_Events_Timeframe__c,Life_Events__c,Medical_Plan__c,Medical_Timeframe__c,
		    						Medical__c,Member__c,Modification_Period__c,Name,Other_Plan__c,Other_Timeframe__c,Other__c,Purchase_RV_Boat_Plan__c,Purchase_RV_Boat_Timeframe__c,
		    						Purchase_RV_Boat__c,Rec_Comment__c,REC_LEAV_1__c,REC_LEAV_Outcome_1__c,REC_LECF_1__c,REC_LECF_2__c,REC_LECF_3__c,REC_LECF_4__c,REC_LECF_Outcome_1__c,
		    						REC_LECF_Outcome_2__c,REC_LECF_Outcome_3__c,REC_LECF_Outcome_4__c,REC_LEEM_1__c,REC_LEEM_2__c,Rec_LEEM_Outcome_1__c,Rec_LEEM_Outcome_2__c,Rec_LEHS_1_Outcome__c,
		    						Rec_LEHS_1__c,Rec_LEHS_2__c,Rec_LEHS_3__c,Rec_LEHS_Outcome_2__c,Rec_LEHS_Outcome_3__c,REC_LEMD_1__c,REC_LEMD_2__c,REC_LEMD_3__c,REC_LEMD_Outcome_1__c,
		    						REC_LEMD_Outcome_2__c,REC_LEMD_Outcome_3__c,REC_LEMP_1__c,REC_LEMP_2__c,REC_LEMP_3__c,REC_LEMP_4__c,REC_LEMP_5__c,REC_LEMP_6__c,REC_LEMP_7__c,REC_LEMP_8__c,
		    						REC_LEMP_Outcome_1__c,REC_LEMP_Outcome_2__c,REC_LEMP_Outcome_3__c,REC_LEMP_Outcome_4__c,REC_LEMP_Outcome_5__c,REC_LEMP_Outcome_6__c,REC_LEMP_Outcome_7__c,
		    						REC_LEMP_Outcome_8__c,Rec_LEMQ_1__c,REC_LEMQ_Outcome_1__c,Rec_LEOL_1__c,Rec_LEOL_2__c,Rec_LEOL_Outcome_1__c,Rec_LEOL_Outcome_2__c,Rec_LEOM_1__c,Rec_LEOM_2__c,
		    						Rec_LEOM_3__c,Rec_LEOM_4__c,Rec_LEOM_5__c,Rec_LEOM_6__c,Rec_LEOM_7__c,Rec_LEOM_Outcome_1__c,Rec_LEOM_Outcome_2__c,Rec_LEOM_Outcome_3__c,Rec_LEOM_Outcome_4__c,
		    						Rec_LEOM_Outcome_5__c,Rec_LEOM_Outcome_6__c,Rec_LEOM_Outcome_7__c,REC_LEPT_1__c,REC_LEPT_Outcome_1__c,Retirement_New__c,Retirement_Plan__c,
		    						Retirement_Timeframe__c,Retirement__c,Role_Name__c,SystemModstamp,Travel_Plan__c,Travel_Timeframe__c,Travel__c FROM Needs_Assesment__c where Member__c =: mid];
		    						
		    			
		    			system.debug('NAForPM###' + NAForPM);
		    			Set<Id> AssessmentId = new Set<Id>();
		    			for(Needs_Assesment__c  na : NAForPM)
		    			{
		    				AssessmentId.Add(na.Id);
		    			}
		    			system.debug('AssessmentId###' + AssessmentId);
		    			list<NA_Other_Existing_Loans__c> otherExistingLoans = new list<NA_Other_Existing_Loans__c>();
						otherExistingLoans = [Select Balance__c,CreatedById,CreatedDate,End_Date__c,Financial_Institution__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,
													Needs_Assessment__c,Rate__c,SystemModstamp,Type_of_Loan__c 
                        						from NA_Other_Existing_Loans__c where Needs_Assessment__c IN: AssessmentId];
                        
                        list<NA_Membership_Referral_Questions__c> loans = new list<NA_Membership_Referral_Questions__c>();
						loans = [SELECT Age__c,CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,Name__c,Needs_Assessment__c,OwnerId,SystemModstamp,Want_to_Refer_Membership__c 
                        			from NA_Membership_Referral_Questions__c where Needs_Assessment__c =: AssessmentId];
                        			
                        list<NA_Deposit__c> deposits = new list<NA_Deposit__c>();
						deposits = [SELECT Balance__c,CreatedById,CreatedDate,Financial_Instituition__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,Needs_Assessment__c,Rate__c,SystemModstamp,Type__c 
                        				from NA_Deposit__c where Needs_Assessment__c =: AssessmentId];	
                        				
                        list<NA_Other_Existing_Loans__c> InsertotherExistingLoans = new  list<NA_Other_Existing_Loans__c>();
                        list<NA_Membership_Referral_Questions__c> Insertloans = new list<NA_Membership_Referral_Questions__c>();				
		    			list<NA_Deposit__c> Insertdeposits = new list<NA_Deposit__c>();
		    			
		    						
		    			
		    			
		    			if(NAForPM.Size() > 0)
		    			{
		    				for(Needs_Assesment__c na : NAForPM)
		    				{
		    					
		    					
		    								Id naid ;
						    				na.id = null;
						    				na.Member__c = pma.id;
						    				insert na;
						    				naid = na.id;
						    				system.debug('na.id###' + na.id);

							    				if(otherExistingLoans.size()> 0)
							    				{
							    					for(NA_Other_Existing_Loans__c exloan :otherExistingLoans )	
							    					{
							    						exloan.id = null;
							    						exloan.Needs_Assessment__c = naid;
							    						InsertotherExistingLoans.add(exloan);
							    						
							    					}
							    					
							    					insert InsertotherExistingLoans;
							    				}
						    				
							    				if(loans.size() > 0)
							    				{
							    					for(NA_Membership_Referral_Questions__c refques :loans )	
							    					{
							    						refques.id = null;
							    						refques.Needs_Assessment__c = naid;
							    						Insertloans.Add(refques);
							    					}
							    					
							    					insert Insertloans;
							    				}
						    				
							    				if(deposits.size() > 0)
							    				{
							    					for(NA_Deposit__c dep :deposits )	
							    					{
							    						dep.id = null;
							    						dep.Needs_Assessment__c = naid;
							    						Insertdeposits.Add(dep);
							    					}
							    					
							    					insert Insertdeposits;
							    				}
						    				
						    					
						    			     }
		    					
		    					
		    				}
		    			
		    			List<Needs_Assesment__c> listToDelete = [select id  FROM Needs_Assesment__c where Member__c =: mid];
		    			
		    			delete listToDelete;
		    			
		    			
		  List<Opportunity> OpportunityForCPM = new List<Opportunity>();
		  OpportunityForCPM = [Select Id,AccountId,IsMemberOpportunity__c,	StageName,Product_Type__c, Product_Sub__c, Brand__c from opportunity where AccountId =: mid and IsCreatedAsMember__c = false ];
		  List<Opportunity> updateopp = new List<Opportunity>();
		  if(OpportunityForCPM.Size() > 0)
		    {
		    				for(Opportunity opp: OpportunityForCPM )
		    				{
		    					
			    					opp.Allow_Error__c =true;
			    					opp.AccountId = pma.id;
			    					opp.StageName = 'New';	    					
			    					updateopp.add(opp);		
		    										
		    					
		    				}
		    				system.debug('updateopp##'+ updateopp);
		    				update updateopp;		    				
		    }
		    			
		    			  			
    	  delete cpm;
    	  return pma.Id;
    }
    
    
}