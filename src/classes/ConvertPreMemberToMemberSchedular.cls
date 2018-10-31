public class ConvertPreMemberToMemberSchedular implements Schedulable {
    
    
     public void execute(SchedulableContext obj)
        {
            List<ReportWrapperClass> EligibleMemberCollection = new List<ReportWrapperClass>();
            List<ReportWrapperClass> NonEligibleMemberCollection = new List<ReportWrapperClass>();
     		Boolean IsPhoneMatching = false;
            Boolean IsEmailMatching = false;
            Boolean IsStreetMatching = false;
            Boolean IsCityMatching = false;
            Boolean IsStateMatching = false;
            Boolean IsZipcodeMatching = false;
            MemberConversionSetting__c mcs = MemberConversionSetting__c.getValues('PrimaryRecord');
            Integer Days_Automation =0;
            Days_Automation = (Integer)mcs.Automation__c;   
            Days_Automation = (Days_Automation) * (-1);
            date LastNDays = system.today().addDays(Days_Automation);
            system.debug('LastNDays##'+ LastNDays);
            Date cutoffdate = mcs.Member_Matching_Cut_off_Date__c;
				
				if(cutoffdate == null)
				{
					cutoffdate = system.today().adddays(-1000);
				}
				 
            Boolean IsMatching = false;
            Set<ID> UpdateMAListIDSet = new Set<ID>();
            List<Account> UpdateMAList = new List<Account>();
            Set<ID> NonEligibleMemberIDSet = new Set<ID>();
            
            Map<ID, Account> MemberAccount1_ToFilter = new Map<ID, Account>([SELECT Id FROM Account where RecordType.Name = 'Person Account' and IsConverted__c=false  and createddate >=: LastNDays and createddate >: cutoffdate]);
            	
 			Set<ID> listAccountIds = MemberAccount1_ToFilter.keySet();
 				
 			List<Person_account__c> listOfAllNonBenificaries = [select id,PersonId__c,TypeTranslate__c,CreatedDate from Person_account__c 
 												where PersonId__c in:  listAccountIds and (not TypeTranslate__c like '%Beneficiary%')]; 
 			Set<Id> listAccountId_Qualified = new Set<Id>();
 			for(Person_account__c item : listOfAllNonBenificaries)
 			{
 				if(!listAccountId_Qualified.contains(item.PersonId__c))
 				{
 					listAccountId_Qualified.add(item.PersonId__c);
 				}
 			}
            
            List <Account> MemberAccount = [SELECT Id, Pre_Member_Number__c,PersonEmail, FirstName,MiddleName,LastName,Salutation ,Suffix,Phone_Check__c, Residential_Street__pc ,RecordType.Name, Residential_Zipocde__pc, Alternate_Email__pc,
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
                                            Sic,SicDesc,smagicinteract__SMSOptOut__pc,SSN_Last_4__pc,SSN_TIN_Encrypted__pc,SSN_TIN_Type__pc,TickerSymbol,Type,Website,Work_Phone_Extension__pc,Work_Phone__pc
                                            FROM Account where id in: listAccountId_Qualified];
                                            
            List <Account> PreMemberAccount = [SELECT Id,Pre_Member_Number__c,Name, PersonEmail,FirstName,MiddleName,LastName,Salutation ,Suffix, Owner.Name,Parent_Lead__c,CreatedDate,Phone_Check__c, Residential_Street__pc, RecordType.Name, Residential_Zipocde__pc, Alternate_Email__pc,
    										  Alt_Email_Raw__c, AnnualRevenue,Bad_Email__c, BillingCity,BillingCountry,BillingCountryCode,BillingGeocodeAccuracy,BillingLatitude,
    										  BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,BillingStreet,BIRTH_DATE__pc,IsCustomerPortal,Death_Date__pc,Description,Email_raw__c,
    										  Employee_Restricted_Access__c,NumberOfEmployees,Employer_Occupation__pc,Extended_Name__pc,Fax,Home_Phone_Number__c,Home_Phone__pc,
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
    										  Employer_Name__pc,PersonMobilePhone, PersonOtherPhone, PersonLeadSource, Last_NA__c, Last_NA_LEHS__c, Converted_On__c,IsConverted__c, PersonDepartment,PersonLastCURequestDate,PersonLastCUUpdateDate,  PersonAssistantName,PersonAssistantPhone,PersonBirthdate,PersonDoNotCall, PersonHasOptedOutOfEmail,PersonHasOptedOutOfFax, Sic,SicDesc,smagicinteract__SMSOptOut__pc,SSN_Last_4__pc,SSN_TIN_Encrypted__pc,SSN_TIN_Type__pc,TickerSymbol,Type,Website,Work_Phone_Extension__pc,Work_Phone__pc
    										  FROM Account where RecordType.Name = 'Pre Member' ];
                                              
            List<Account> EligiblePreMember = new List<Account>();
            List<Account> MemberAccount1 = new List<Account>(); 
            List<Task> TaskForPM = new List<Task>();
            List<Event> EventForPM = new List<Event>();
            List<Case> casesForPM = new List<Case>();
            List<Opportunity> OpportunityForPM = new List<Opportunity>();
            List<Needs_Assesment__c> NAForPM = new List<Needs_Assesment__c>();
            List<Needs_Assesment__c> NAForMember = new List<Needs_Assesment__c>();
            List<Note> NoteForPM = new List<Note>();
            
            Map<ID,ID> MapofId = new Map<ID,ID>();
            Map<ID,String> PreMemberNumberMap = new Map<ID,String>();
           
            Set<Id> EligiblePreMemberIdSet = new Set<Id>();
            Set<Id> EligibleMemberIdSet =  new Set<Id>();
           
            if(MemberAccount.size() > 0)
            {
            	if(PreMemberAccount.size() > 0)
            	{
            				for(Account ma : MemberAccount )
            				{
				                for(Account pma : PreMemberAccount)
				                {
				                	
				                	if(EligiblePreMemberIdSet.contains(pma.id))
				                        {
				                        	 continue; 
				                        }
				                       
				                	
				                	String ma_email_check = '';
				                    
				                     if(!string.isBlank(ma.Alternate_Email__pc)){
				                        ma_email_check = ma_email_check + ma.Alternate_Email__pc.toUpperCase() + ',';
				                    }
				                    if(!string.isBlank(ma.Alt_Email_Raw__c)){
				                        ma_email_check = ma_email_check + ma.Alt_Email_Raw__c.toUpperCase() + ',';
				                    }
				                    if(!string.isBlank(ma.PersonEmail)){
				                        ma_email_check = ma_email_check + ma.PersonEmail.toUpperCase() + ',';
				                    }
				                    if(!string.isBlank(ma.Email_raw__c)){
				                        ma_email_check = ma_email_check + ma.Email_raw__c.toUpperCase() + ',';
				                    }
				                    
				                    if(!string.isBlank(ma_email_check) && !string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName)  
				                        &&  !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName)  
				                        &&  ( (!string.isBlank(pma.Alternate_Email__pc) && ma_email_check.contains(pma.Alternate_Email__pc.toUpperCase())) 
				                                || (!string.isBlank(pma.Alt_Email_Raw__c) && ma_email_check.contains(pma.Alt_Email_Raw__c.toUpperCase())) 
				                                || (!string.isBlank(pma.Email_raw__c) && ma_email_check.contains(pma.Email_raw__c.toUpperCase()) ) 
				                                || (!string.isBlank(pma.PersonEmail) && ma_email_check.contains(pma.PersonEmail.toUpperCase())) ) 
				                        && ma.LastName.toUpperCase() == pma.LastName.toUpperCase() && ma.FirstName.toUpperCase() == pma.FirstName.toUpperCase()) 
				                    {
				                        IsMatching = true;
				                        IsEmailMatching = true;
				                        system.debug('Ismatching1#' + IsMatching);
				                    }
				                        
				                    else if (!string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(ma.Phone_Check__c)  
				                         && !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && !string.isBlank(pma.Phone_Check__c)  
				                        && ma.LastName == pma.LastName && ma.FirstName == pma.FirstName 
				                        && ( 
				                        
				                                (!string.isBlank(pma.Home_Phone__pc) && ma.Phone_Check__c.Contains(clearPhoneNumber(pma.Home_Phone__pc))) || 
				                                (!string.isBlank(pma.Work_Phone__pc) && ma.Phone_Check__c.Contains(clearPhoneNumber(pma.Work_Phone__pc))) || 
				                                (!string.isBlank(pma.Mobile_Phone__pc) && ma.Phone_Check__c.Contains(clearPhoneNumber(pma.Mobile_Phone__pc)))) )
				                    {
				                        IsMatching = true;
				                        IsPhoneMatching = true;
				                        system.debug('Ismatching2#' + IsMatching);
				                    }
				                    else if(!string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(ma.Residential_Street__pc) &&
				                    !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && !string.isBlank(pma.Residential_Street__pc) &&
				                    (ma.LastName == pma.LastName) && (ma.FirstName == pma.FirstName ) && (ma.Residential_Street__pc == pma.Residential_Street__pc))
				                    {
				                        IsMatching = true;
				                        system.debug('Ismatching3#' + IsMatching);
				                       
				                    }
				                    else if(!string.isBlank(ma.LastName) && !string.isBlank(ma.Residential_Street__pc) && !string.isBlank(ma.Residential_Zipocde__pc) &&
				                    !string.isBlank(pma.LastName) && !string.isBlank(pma.Residential_Street__pc) && !string.isBlank(pma.Residential_Zipocde__pc) &&
				                    
				                    (ma.FirstName == pma.FirstName ) && (ma.Residential_Street__pc == pma.Residential_Street__pc) && (ma.Residential_Zipocde__pc == pma.Residential_Zipocde__pc) )
				                    {
				                        IsMatching = true;
				                        system.debug('Ismatching4#' + IsMatching);
				                       
				                    }
				                    
				                    else if(
				                    !string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(ma.Residential_Zipocde__pc) &&
				                    !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && !string.isBlank(pma.Residential_Zipocde__pc) &&
				                    (ma.LastName == pma.LastName) && (ma.FirstName == pma.FirstName ) && (ma.Residential_Zipocde__pc == pma.Residential_Zipocde__pc) )
				                    {
				                        IsMatching = true;
				                        system.debug('Ismatching6#' + IsMatching);
				                       
				                    }                    
				                    
				                    
				                    else
				                    {
				                        IsMatching = false;
				                        
				                    } 
				                    
				                    
				                    if(!string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(ma.Residential_Zipocde__pc) &&
				                    !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && !string.isBlank(pma.Residential_Zipocde__pc) &&
				                    (ma.LastName == pma.LastName) && (ma.FirstName == pma.FirstName ) && (ma.Residential_Zipocde__pc == pma.Residential_Zipocde__pc) )
				                    {
				                        
				                        IsZipcodeMatching = true;
				                    }
				                    if(!string.isBlank(ma.LastName) && !string.isBlank(ma.Residential_Street__pc) && !string.isBlank(ma.Residential_Zipocde__pc) &&
				                    !string.isBlank(pma.LastName) && !string.isBlank(pma.Residential_Street__pc) && !string.isBlank(pma.Residential_Zipocde__pc) &&
				                    
				                    (ma.FirstName == pma.FirstName ) && (ma.Residential_Street__pc == pma.Residential_Street__pc) && (ma.Residential_Zipocde__pc == pma.Residential_Zipocde__pc) )
				                    {
				                       
				                        IsStreetMatching = true;
				                        IsZipcodeMatching = true;
				                    }         
				                    if(!string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(ma.Residential_Street__pc) &&
				                    !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && !string.isBlank(pma.Residential_Street__pc) &&
				                    (ma.LastName == pma.LastName) && (ma.FirstName == pma.FirstName ) && (ma.Residential_Street__pc == pma.Residential_Street__pc))
				                    {
				                        
				                        IsStreetMatching = true;
				                    }
				                     if (!string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(ma.Phone_Check__c)  
				                         && !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && !string.isBlank(pma.Phone_Check__c)  
				                        && ma.LastName == pma.LastName && ma.FirstName == pma.FirstName 
				                        && ( 
				                        
				                                (!string.isBlank(pma.Home_Phone__pc) && ma.Phone_Check__c.Contains(clearPhoneNumber(pma.Home_Phone__pc))) || 
				                                (!string.isBlank(pma.Work_Phone__pc) && ma.Phone_Check__c.Contains(clearPhoneNumber(pma.Work_Phone__pc))) || 
				                                (!string.isBlank(pma.Mobile_Phone__pc) && ma.Phone_Check__c.Contains(clearPhoneNumber(pma.Mobile_Phone__pc)))) )
				                    {
				                        
				                        IsPhoneMatching = true;
				                        
				                    }
				                    
				                    if(!string.isBlank(ma_email_check) && !string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName)  
				                        &&  !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName)  
				                        &&  ( (!string.isBlank(pma.Alternate_Email__pc) && ma_email_check.contains(pma.Alternate_Email__pc.toUpperCase())) 
				                                || (!string.isBlank(pma.Alt_Email_Raw__c) && ma_email_check.contains(pma.Alt_Email_Raw__c.toUpperCase())) 
				                                || (!string.isBlank(pma.Email_raw__c) && ma_email_check.contains(pma.Email_raw__c.toUpperCase()) ) 
				                                || (!string.isBlank(pma.PersonEmail) && ma_email_check.contains(pma.PersonEmail.toUpperCase())) ) 
				                        && ma.LastName.toUpperCase() == pma.LastName.toUpperCase() && ma.FirstName.toUpperCase() == pma.FirstName.toUpperCase()) 
				                    {
				                        
				                        IsEmailMatching = true;
				                       
				                    }
				                     IsStateMatching = false;
				                     if(!string.isBlank(ma.Residential_State__pc)  && !string.isBlank(pma.Residential_State__pc) && (ma.Residential_State__pc == pma.Residential_State__pc) )
				                    {
				                       
				                        IsStateMatching = true;
				                       
				                    } 
                                    IsCityMatching = false;
				                   if(!string.isBlank(ma.Residential_City__pc)  &&
				                    !string.isBlank(pma.Residential_City__pc) && (ma.Residential_City__pc == pma.Residential_City__pc) )
				                    {
				                       
				                        IsCityMatching = true;
				                       
				                    } 
				                    
				                    
				                    system.debug(IsStateMatching);
				                    if(IsMatching == true)
				                    {
				                      
				                      
				                      system.debug('true');
				                        ma.NA_Eligibility__c = pma.NA_Eligibility__c;
				                        ma.NA_LEHS_Complete__c= pma.NA_LEHS_Complete__c;
				                        ma.NA_LEHS_Update__c = pma.NA_LEHS_Update__c; 
				                        ma.NA_LEOM_Complete__c = pma.NA_LEOM_Complete__c;
				                        ma.NA_LEOM_Update__c = pma.NA_LEOM_Update__c;
				                        ma.NA_Opt_Out__c = pma.NA_Opt_Out__c;
				                        ma.NA_Opt_Out_Date__c = pma.NA_Opt_Out_Date__c;
				                        ma.NA_Opt_Out_Updated__c = pma.NA_Opt_Out_Updated__c;
				                        ma.NA_LEAV_Complete__c = pma.NA_LEAV_Complete__c;
				                        ma.NA_LECF_Complete__c = pma.NA_LECF_Complete__c;
				                        ma.NA_LECP_Complete__c = pma.NA_LECP_Complete__c;
				                        ma.NA_LEEM_Complete__c = pma.NA_LEEM_Complete__c;
				                        ma.NA_LEMD_Complete__c = pma.NA_LEMD_Complete__c;
				                        ma.NA_LEMP_Complete__c = pma.NA_LEMP_Complete__c;
				                        ma.NA_LEMQ_Complete__c = pma.NA_LEMQ_Complete__c;
				                        ma.NA_LEOL_Complete__c = pma.NA_LEOL_Complete__c;
				                        ma.NA_LEPT_Complete__c = pma.NA_LEPT_Complete__c;
				                        ma.NA_LESB_Complete__c = pma.NA_LESB_Complete__c;
				                        ma.NA_LESF_Complete__c = pma.NA_LESF_Complete__c;
				                        ma.NA_LEWS_Complete__c = pma.NA_LEWS_Complete__c;
				                        
				                       
				                        
				                        
				                        
				                        EligiblePreMember.Add(pma);
				                        EligiblePreMemberIdSet.Add(pma.Id);
				                        
				                        
				                        MapofId.put(pma.Id,ma.Id);
				                        PreMemberNumberMap.put(ma.Id, pma.Pre_Member_Number__c);
				                      
				                        ma.IsConverted__c= true;
				                        ma.Member__c = pma.Id;
				                        ma.Converted_On__c = system.today();
				                        
				                      
				                      system.debug('EligibleMemberCollection##' + EligibleMemberCollection); 
				                        
				                        
				                        if(!EligibleMemberIdSet.contains(ma.id))
				                        {
				                            MemberAccount1.Add(ma);
				                            EligibleMemberIdSet.add(ma.id);
				                            if(NonEligibleMemberIDSet.contains(ma.id))
				                            {
				                            	NonEligibleMemberIDSet.remove(ma.id);
				                            }
				                             ReportWrapperClass cls = new ReportWrapperClass();
						                      cls.Ma = ma;
						                      cls.pma = pma;
						                      cls.IsPhoneMatching = IsPhoneMatching;
						                      cls.IsEmailMatching = IsEmailMatching;
						                      cls.IsStreetMatching = IsStreetMatching;
		            						  cls.IsCityMatching = IsCityMatching;
		            						  cls.IsStateMatching = IsStateMatching;
		            						  cls.IsZipcodeMatching = IsZipcodeMatching;
		            						  cls.FirstName = ma.FirstName;
		            						  cls.LastName = ma.LastName;
						                      EligibleMemberCollection.add(cls); 
				                            
				                        }
				                        break;
				
				                    }
				                    else if(IsMatching == false)
				                    {	
				                    	
				                    		if(!EligibleMemberIdSet.contains(ma.id) && !NonEligibleMemberIDSet.contains(ma.id))
				                        	{
				                    			NonEligibleMemberIDSet.Add(ma.Id);
				                    		  ReportWrapperClass NonElgcls = new ReportWrapperClass();
						                      NonElgcls.Ma = ma;
						                      NonElgcls.pma = pma;
						                      NonElgcls.IsPhoneMatching = IsPhoneMatching;
						                      NonElgcls.IsEmailMatching = IsEmailMatching;
						                      NonElgcls.IsStreetMatching = IsStreetMatching;
		            						  NonElgcls.IsCityMatching = IsCityMatching;
		            						  NonElgcls.IsStateMatching = IsStateMatching;
		            						  NonElgcls.IsZipcodeMatching = IsZipcodeMatching;
		            						  NonElgcls.FirstName = ma.FirstName;
		            						  NonElgcls.LastName = ma.LastName;
						                      NonEligibleMemberCollection.add(NonElgcls);  
					                    			
				                        	}
				                        	
				                          	
				                        	
				                    }
				                }
				            }
            	}
            }          
            		List<Member_Conversion_Report__c> reportlist = new List<Member_Conversion_Report__c>();
            		List<Member_Conversion_Report__c> Matchinglist = new List<Member_Conversion_Report__c>();
            		List<Member_Conversion_Report__c> NotMatchinglist = new List<Member_Conversion_Report__c>();
            		Map<ID,Boolean> MapIDMatching = new Map<ID,Boolean>();
            		
            		Matchinglist = [Select Id, Createddate, Member__c, IsMatching__c from Member_Conversion_Report__c where createddate = today  ];
            		Set<id> NonEligibleMemberIDSetNotReported = new Set<id>();
            		
            		for(Id str : NonEligibleMemberIDSet)
					{    
						boolean memberreported = false;
						for(Member_Conversion_Report__c item : Matchinglist)
						
	            		{
	            			if(str == item.Member__c)
	            			{
	            				memberreported = true;
	            			}
	            			
	            		}
	            		if(!memberreported)
	            		
	            		{
	            			NonEligibleMemberIDSetNotReported.add(str);
	            		}
	            		
					}
            		
            		system.debug('NonEligibleMemberIDSet call###' + NonEligibleMemberIDSet);
            		system.debug('EligibleMemberCollection call###' + EligibleMemberCollection);
            		system.debug('NonEligibleMemberCollection call###' + NonEligibleMemberCollection);
            		
            		SetMergerReportData(NonEligibleMemberIDSetNotReported, PreMemberNumberMap, false,NonEligibleMemberCollection );
            		system.debug('EligibleMemberIDSet call###' + EligibleMemberIDSet);
            		SetMergerReportData(EligibleMemberIDSet, PreMemberNumberMap, true, EligibleMemberCollection);
            		
            		//NotMatchinglist = [Select Id, Createddate, Member__c, IsMatching__c from Member_Conversion_Report__c where createddate = today and IsMatching__c = false ];
            		if(Matchinglist.size() > 0)
            		{
            			for(Member_Conversion_Report__c m: Matchinglist )
            			{
            				MapIDMatching.put(m.Member__c,m.IsMatching__c);
            			}
            		}
            		
            		// This section create report for member not matched
            	
            //update EligiblePreMember;
            update MemberAccount1;
            
            if(EligiblePreMemberIdSet.Size() > 0)
            {
            	List<Converted_PreMember__c> cpmlist = new List<Converted_PreMember__c>();
            	for(Account pma: EligiblePreMember){
            		ID mid ;
            		    Converted_PreMember__c cpm = new Converted_PreMember__c();
            		 	mid = MapofId.get(pma.id);
    					cpm.Member__c = mid;
    					cpm.Pre_Member_Number__c = pma.Pre_Member_Number__c;
    					cpm.Alt_E_Mail_Address__c= pma.Alternate_Email__pc;
    					cpm.Alternate_Email__c = pma.Alt_Email_Raw__c;
    					cpm.Annual_Revenue__c = pma.AnnualRevenue;
    					cpm.Assistant__c = pma.PersonAssistantName;
						cpm.Asst_Phone__c = pma.PersonAssistantPhone;
						//String.valueOf(cpm.Billing_Address__c) = pma.BillingAddress;
						cpm.Birthdate__c = pma.PersonBirthdate;
						cpm.Birth_Date__c =pma.BIRTH_DATE__pc;
						//cpm.Converted_On__c = pma.Converted_On__c;			
						
						cpm.Death_Date__c =pma.Death_Date__pc;
						cpm.Department__c = pma.PersonDepartment;
						cpm.Description__c =pma.Description;
						cpm.Do_Not_Call__c = pma.PersonDoNotCall;
						cpm.Email_Opt_Out__c = pma.PersonHasOptedOutOfEmail;
						cpm.Email_raw__c = pma.Email_raw__c;
						cpm.Employees__c = pma.NumberOfEmployees;
						cpm.Employee_Restricted_Access__c =pma.Employee_Restricted_Access__c;
					    cpm.Employer_Name__c = pma.Employer_Name__pc;
					    cpm.Employer_Occupation__c = pma.Employer_Occupation__pc;
					    cpm.Extended_Name__c = pma.Extended_Name__pc;
					    cpm.E_Mail_Address__c = pma.Email_raw__c;
					    cpm.Fax_Opt_Out__c = pma.PersonHasOptedOutOfFax;
					    cpm.Fax__c=pma.Fax;
					    cpm.Home_Phone_Number__c =pma.Home_Phone_Number__c;
					    cpm.Home_Phone__c=pma.Home_Phone__pc;					    
					    cpm.ID_1_Description__c =pma.ID_1_Description__pc;
					    cpm.ID_1_Expiration_Date__c =pma.ID_1_Expiration_Date__pc;
					    cpm.ID_1_Issuance_Date__c=pma.ID_1_Issuance_Date__pc;
						cpm.ID_1_Number__c =pma.ID_1_Number__pc;
						cpm.ID_1_Verification_Date__c=pma.ID_1_Verification_Date__pc;
						cpm.ID_2_Description__c=pma.ID_2_Description__pc;
						cpm.ID_2_Expiration_Date__c =pma.ID_2_Expiration_Date__pc;
						cpm.ID_2_Issuance_Date__c =pma.ID_2_Issuance_Date__pc;
					    cpm.ID_2_Number__c =pma.ID_2_Number__pc;
					    cpm.ID_2_Type__c =pma.ID_2_Type__Pc;
					     cpm.ID_1_Type__c =pma.ID_1_Type__Pc;
					    cpm.ID_2_Verification_Date__c =pma.ID_2_Verification_Date__pc;
					    cpm.ID_3_Description__c = pma.ID_3_Description__pc;
					    cpm.ID_3_Expiration_Date__c =pma.ID_3_Expiration_Date__pc;
						cpm.ID_3_Issuance_Date__c =pma.ID_3_Issuance_Date__pc;
						cpm.ID_3_Number__c = pma.ID_3_Number__pc;						
						cpm.ID_3_Type__c =pma.ID_3_Type__pc;
						cpm.ID_3_Verification_Date__c =pma.ID_3_Verification_Date__pc;
						cpm.Industry__c =pma.Industry;
						cpm.Initial_Record__c =pma.Initial_Record__pc;
						cpm.IsConverted__c = pma.IsConverted__c;						
						cpm.Last_NA_LEHS__c = pma.Last_NA_LEHS__c;
						cpm.Last_NA__c = pma.Last_NA__c;
						cpm.Last_Stay_in_Touch_Request_Date__c =pma.PersonLastCURequestDate;
						cpm.Last_Stay_in_Touch_Save_Date__c =pma.PersonLastCUUpdateDate;
						cpm.Lead_Source__c =pma.PersonLeadSource;
						//cpm.Mailing_Address__c=pma.PersonMailingAddress;
						cpm.Member_Number__c =pma.AccountNumber;
						cpm.Member_Record_Type__c =pma.RecordTypeId;
						cpm.Member_Site__c =pma.Site;
						cpm.Member_Source__c = pma.AccountSource;
						cpm.Member_Verification_OTP_Invalid_Attempt__c = pma.Member_Verification_OTP_Invalid_Attempt__c;
						
						cpm.Name__c =pma.Name;
						
						cpm.Pre_Member_Number__c =pma.Pre_Member_Number__c;	
						
						cpm.NA_Eligibility__c = pma.NA_Eligibility__c;
						cpm.NA_LEHS_Complete__c= pma.NA_LEHS_Complete__c;
						cpm.NA_LEHS_Update__c = pma.NA_LEHS_Update__c; 
						cpm.NA_LEOM_Complete__c = pma.NA_LEOM_Complete__c;
						cpm.NA_LEOM_Update__c = pma.NA_LEOM_Update__c;
						cpm.NA_Opt_Out__c = pma.NA_Opt_Out__c;
						cpm.NA_Opt_Out_Date__c = pma.NA_Opt_Out_Date__c;
						cpm.NA_Opt_Out_Updated__c = pma.NA_Opt_Out_Updated__c;
						cpm.NA_LEAV_Complete__c = pma.NA_LEAV_Complete__c;
						cpm.NA_LECF_Complete__c = pma.NA_LECF_Complete__c;
						cpm.NA_LECP_Complete__c = pma.NA_LECP_Complete__c;
						cpm.NA_LEEM_Complete__c = pma.NA_LEEM_Complete__c;
						cpm.NA_LEMD_Complete__c = pma.NA_LEMD_Complete__c;
						cpm.NA_LEMP_Complete__c = pma.NA_LEMP_Complete__c;
						cpm.NA_LEMQ_Complete__c = pma.NA_LEMQ_Complete__c;
						cpm.NA_LEOL_Complete__c = pma.NA_LEOL_Complete__c;
						cpm.NA_LEPT_Complete__c = pma.NA_LEPT_Complete__c;
						cpm.NA_LESB_Complete__c = pma.NA_LESB_Complete__c;
						cpm.NA_LESF_Complete__c = pma.NA_LESF_Complete__c;
						 cpm.NA_LEWS_Complete__c = pma.NA_LEWS_Complete__c;	
						  cpm.Last_Name__c = pma.LastName;					
    					cpm.First_Name__c = pma.FirstName;
    					cpm.Middle_Name__c = pma.MiddleName;
    					cpm.Work_Phone__c = pma.PersonOtherPhone;
    					cpm.Work_Phone_Extension__c = pma.Work_Phone_Extension__pc;
    					cpm.Work_Phone_Number__c = pma.Work_Phone__pc;
    					cpm.Mobile__c = pma.PersonMobilePhone;
    					cpm.Mobile_Country_Code__c = pma.et4ae5__Mobile_Country_Code__pc;
    					cpm.Mobile_Opt_Out__c = pma.et4ae5__HasOptedOutOfMobile__pc;
    					cpm.Mobile_Phone_Number__c = pma.Mobile_Phone__pc;
    					cpm.Mothers_Maiden_Name__c = pma.Mothers_Maiden_Name__pc;
    					cpm.Occupation__c = pma.Occupation__pc;
    					cpm.Residential_City__c = pma.Residential_City__pc;
    					cpm.Residential_Country__c = pma.Residential_Country__pc;
    					cpm.Residential_Country_Code__c = pma.Residential_Country_Code__pc;
    					cpm.Residential_Extra_Address__c = pma.Residential_Extra_Address__pc;    				
    					cpm.Residential_State__c = pma.Residential_State__pc;
    					cpm.Residential_Street__c = pma.Residential_Street__pc;
    					cpm.Residential_Zipcode__c = pma.Residential_Zipocde__pc;
    					cpmlist.add(cpm);    					
            	}
            	insert cpmlist;
            	system.debug(cpmlist);
                TaskForPM = [SELECT AccountId,Id,Status,Subject,Type,WhatId,WhoId FROM Task where WhoId IN: EligiblePreMemberIdSet];
                EventForPM = [SELECT AccountId,Id,WhatId,WhoId FROM Event where WhoId IN: EligiblePreMemberIdSet ];
                casesForPM = [SELECT AccountId,Id FROM Case where AccountId IN: EligiblePreMemberIdSet];
                OpportunityForPM = [Select Id,AccountId,IsMemberOpportunity__c,Product_Type__c,Product_Sub__c from opportunity where AccountId IN:EligiblePreMemberIdSet ];
               
                NAForPM =[SELECT    Rec_Comment_New__c,LEWS_Comment_New__c,LESF_Comments_New__c,LESB_SharedBranching_Comments_New__c,LEPT_Comments_New__c,LEOM_PlanUnforeseen_New__c,
		    						LEOM_Comments_New__c,LEMP_Transfer_Comments_New__c,LEMP_Payment_Transfer_Comments_New__c,LEMP_International_Transfer_Comments_New__c,
		    						LEMP_Debit_Card_Usage_Comments_New__c,LEMP_Credit_Card_You_Use_Often_New__c,LEMP_Credit_Card_Usage_Reason_Comments_N__c,
		    						LEMP_Credit_Card_Usage_Other_New__c,LEMP_Credit_Card_Usage_Comments_New__c,LEMD_CommentsForDD_New__c,LEMD_CommentsDC_New__c,
		    						LEHS_Comment_New__c,LEEM_Comments_New__c,LEAV_ContactPreferences_New__c,LECF_Comment_New__c,LECF_Experience_Improvement_Feedback_New__c,	
                					Member__r.BIRTH_DATE__pc,CDs__c,College_Plan__c,College_Timeframe__c,College__c,Complete_PFCE__c,CreatedById,
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
		    						Retirement_Timeframe__c,Retirement__c,Role_Name__c,SystemModstamp,Travel_Plan__c,Travel_Timeframe__c,Travel__c FROM Needs_Assesment__c where Member__c IN: EligiblePreMemberIdSet];
		    						
		  NAForMember = [SELECT Rec_Comment_New__c,LEWS_Comment_New__c,LESF_Comments_New__c,LESB_SharedBranching_Comments_New__c,LEPT_Comments_New__c,LEOM_PlanUnforeseen_New__c,
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
		    						Retirement_Timeframe__c,Retirement__c,Role_Name__c,SystemModstamp,Travel_Plan__c,Travel_Timeframe__c,Travel__c FROM Needs_Assesment__c where Member__c IN: EligibleMemberIdSet];  						
		    						
                NoteForPm =[SELECT Id,ParentId FROM Note where ParentId IN: EligiblePreMemberIdSet];
               List<Needs_Assesment__c> NAForCPM = new List<Needs_Assesment__c>();
                List<Task> updatetask = new List<Task>();
                List<Event> updateEvent = new List<Event>();
                List<Opportunity> updateopp = new List<Opportunity>();
                List<Case> updatecase = new List<Case>();
                List<Needs_Assesment__c> updateNA = new List<Needs_Assesment__c>();
                List<Note> updatenote = new List<Note>();
                ID memberid ;
                
               system.debug('Need Assesment data'+ NAForPM);
		    			
		    			Set<Id> AssessmentId = new Set<Id>();
		    			for(Needs_Assesment__c  na : NAForPM)
		    			{
		    				AssessmentId.Add(na.Id);
		    			}
		    			
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
		    			
		    			Boolean MemberAbove18 = true;
		    			Boolean PrimaryAccountWithAtleastoneTrust = false;
		    			Boolean Eligibility = false;
                		
                		
                		
		    			
		    			
		    			 system.debug('PrimaryAccountWithAtleastoneTrust flag'+ PrimaryAccountWithAtleastoneTrust);
		    			 
		    			 
                
                if(TaskForPM.Size() > 0)
                {
                    for(Task t : TaskForPM)
                    {
                        memberid = MapofId.get(t.WhoId);
                        t.WhoId = memberid;
                        updatetask.Add(t);
                    }
                    system.debug('updatetask##'+ updatetask);
                    update updatetask;
                }
                
                if(EventForPM.Size() > 0)
                {
                    for(Event e : EventForPM)
                    {
                        memberid = MapofId.get(e.WhoId);
                        e.WhoId = memberid;
                        updateEvent.Add(e);
                    }
                    
                    update updateEvent;
                }
                
                if(casesForPM.Size() > 0)
                {
                    for(Case c:casesForPM)
                    {
                        memberid = MapofId.get(c.Accountid);
                        c.AccountId = memberid;
                        updatecase.Add(c);
                    }
                    
                    update updatecase;
                }
                
                if(OpportunityForPM.Size() > 0)
                {
                    for(Opportunity opp: OpportunityForPM )
                    {
                        memberid = MapofId.get(opp.Accountid);
                       // opp.IsMemberOpportunity__c = true;
                       
                        opp.AccountId = memberid;
                        opp.Allow_Error__c = true;
                        if (opp.Product_Type__c== 'Accounts/Shares' && opp.Product_Sub__c== 'Membership')
		    					{			    	    				
			    	    				opp.StageName = 'Closed Won' ;
			    	    							    	
			    				}
	    				/*if (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost' || opp.IsMemberOpportunity__c == false)
	    					{			    	    				
		    	    				opp.Allow_Error__c = true;
		    	    							    	
		    				}*/
                        updateopp.add(opp);
                        
                    }
                    system.debug('updateopp##'+ updateopp);
                    update updateopp;
                    
                }
             /*   if(NAForPm.Size() > 0)
		    	{
		    		for(Converted_PreMember__c cpm :cpmlist){
		    				for(Needs_Assesment__c na : NAForPM)
		    				{
		    					na.id = null;
						    	na.Member__c = cpm.Id;
		    					NAForCPM.add(na);
		    				}
		    				update NAForCPM;
		    		}
		    	}*/
                List<id> lst = new List<id>(EligibleMemberIdSet);
                ManualMemberMergeProcess.SetOppBranch(lst); 
               	if(NAForPm.Size() > 0)
		    	 { 
		    			 	Set<ID> NA_memberidset = new Set<ID>();
		    			 	for(Needs_Assesment__c na : NAForPM)
		    				{
		    					memberid = MapofId.get(na.Member__c);
		    					NA_memberidset.Add(memberid);
		    				}
		    					
		    				
		    					List<Person_Account__c> paList = [SELECT Id,PersonID__c, Account_Number__c, Account_Number__r.RecType__c, Relationship__c, Account_Number__r.TypeTranslate__c, TypeTranslate__c,
                 											Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =: NA_memberidset and Account_Number__r.RecType__c = 'ACCT'
                                         					and(Account_Number__r.TypeTranslate__c != '2-TRUST' or Account_Number__r.TYPE__c != 2) and TypeTranslate__c like '%PRIMARY%' ];
                                         					
                           for(Needs_Assesment__c na : NAForPM)
		    				{
				    					memberid = MapofId.get(na.Member__c);
				    					if(na.Member__r.BIRTH_DATE__pc!= null){ MemberAbove18 = na.Member__r.BIRTH_DATE__pc.addyears(18) < System.Today();}		
				    					if (paList.size() > 0 )
				    					{
				    						for(Person_Account__c pac : paList )
				    						{
				    							if(pac.PersonID__c == memberid )
				    							{
				    								PrimaryAccountWithAtleastoneTrust = true;
				    							}
				    						}
				            				
				       					}
				       					
				       					if(PrimaryAccountWithAtleastoneTrust && MemberAbove18){Eligibility = true;}
				       					system.debug('MemberAbove18##'+ MemberAbove18);
			    						 system.debug('Eligibility##'+ Eligibility);
				       					if(Eligibility == false)
				    					 {
				    						delete na;
				    					 }
				    					 else
				    					 {
				    						   if(NAForMember.size() == 0)
				    						     {
				    								Id naid ;
								    				na.id = null;
								    				na.Member__c = memberid;
								    				insert na;
								    				naid = na.id;
								    				system.debug('updateNA##'+ updateNA);
								    			
		
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
				    					
				                  
				    				
				    			}
		    					
		    				update UpdateMAList;
		  	 		}
		    			
		    			
                
                if(NoteForPM.size() > 0)
                {
                    for(Note n: NoteForPM)
                    {
                        memberid = MapofId.get(n.ParentId);
                        n.ParentId = memberid;
                        updatenote.Add(n);
                    }
                    system.debug('updatenote##'+ updatenote);
                    update updatenote;
                }
                
            }
            
            List<Logs__c> logslist = new List<Logs__c>();
            for(Account pma : EligiblePreMember)
            {
            	Logs__c logs = new Logs__c();
    			logs.Converted_Date__c = system.now();
    			logs.Pre_Member_Owner__c = pma.Owner.Name;
    			logs.Lead_Number__c = pma.Pre_Member_Number__c;
    			logs.Pre_Member_Created_Date__c = pma.CreatedDate; 
    			logs.Pre_Member_ID__c = pma.id;
    			logslist.Add(logs);
            }
            system.debug(logslist + 'logslist');
            insert logslist;
            //Deleting Premember after conversion
            delete EligiblePreMember;
            
        }
        
        
        public void SetMergerReportData(Set<id> listIds, Map<ID,String> PreMemberNumberMap, boolean matching, List<ReportWrapperClass> classcollection)
        {
        	
        	system.debug('listIds###' + listIds);
        	List<Member_Conversion_Report__c> reportlist = new List<Member_Conversion_Report__c>();
        						
	          	List<Person_Account__c>		 	palist = [SELECT Id,PersonID__c,Account_Number__r.Parent_Account__c, Account_Number__c, Account_Number__r.RecType__c, 
	          								Account_Number__r.Name,Account_Number__r.Id, PersonId__r.Createddate, Account_Number__r.Created_By_User__c, 
	          			 					Account_Number__r.Created_By_User_Alias__c, Account_Number__r.Created_By_Episys_User__c, Account_Number__r.Created_By_User_Text__c  
	          			 					FROM Person_Account__c WHERE PersonID__c IN : listIds  order by Account_Number__r.RecType__c];
	          			 					
	           set<id> notFound  = new set<id>(); 
	          	
	          	
	          	for(id notfoundid : listIds)
	          	{
	          		boolean flag = false;
	          	   for(Person_Account__c pa : palist){
			          	if(pa.PersonID__c == notfoundid && !notFound.contains(notfoundid))
			          	{
			          		flag = true;
			          	}
		          }
		          
		          if(!flag)
		          {
		          	notFound.add(notfoundid);
		          }
	          	}
	          
	           system.debug('notFound#'+notFound);
	          
	           if(notFound.size() > 0)
   			 	 {
   			 	 	List<Account> acclist =  [Select Id,ParentId, Name , Createddate, Owner.Name from Account where id IN :notFound];
   			 	 	 system.debug('acclist#'+acclist);
   			 	 	if(acclist.size() > 0)
   			 	 	{
   			 	 		
   			 	 			for(ReportWrapperClass cc: classcollection)
   			 	 			{
   			 	 				for(Account a : acclist)
   			 	 				{
   			 	 					if(cc.ma.id == a.id)
   			 	 					{
			   			 	 			Member_Conversion_Report__c report = new Member_Conversion_Report__c();
			   			 	 			if(matching)
			   			 	 			{
			   			 	 				report.Member_Number__c =  PreMemberNumberMap.get(a.id);
			   			 	 			}
			   			 	 			report.IsMatching__c = matching;
							           	report.Member_Created_Date__c = a.Createddate;
							       		report.User_Name__c = a.Owner.Name;
							       		report.Member__c = a.id;
							       		report.Process_Type__c ='Automated';
					   			 		report.Is_Phone_Matching__c = cc.IsPhoneMatching;
							       		report.Is_Email_Matching__c = cc.IsEmailMatching;
							       		report.Is_Street_Matching__c = cc.IsStreetMatching;
							       		report.Is_City_Matching__c = cc.IsCityMatching;
							       		report.Is_State_Matching__c = cc.IsStateMatching;
							       		report.Is_Zipcode_Matching__c = cc.IsZipcodeMatching;
					   			 		report.First_Name__c = cc.FirstName;
					   			 		report.Last_Name__c = cc.LastName;
							           	reportlist.Add(report);
   			 	 					}
   			 	 			}
   			 	 		}
   			 	 	}
   			 	 
   			 	 }		 	
   			 	 
   			 	 Set<id> memberiddone = new set<id>();
	   			
	   			 system.debug('palist#'+palist);
	   			 	for(ReportWrapperClass cc: classcollection)
   			 	 			{
   			 	 				 for(Person_Account__c pa : palist)
	   							 {
					   			 	if(!memberiddone.contains(pa.PersonID__c) && cc.ma.id == pa.PersonId__c)
					   			 	{
				   			 	
										Member_Conversion_Report__c report = new Member_Conversion_Report__c();
					   			 		report.IsMatching__c = matching;
					   			 		if(matching)
					   			 	 			{
					   			 	 				report.Member_Number__c =  PreMemberNumberMap.get(pa.PersonID__c);
					   			 	 			}
					   			 		
					   			 		report.Member_Created_Date__c = pa.PersonId__r.Createddate;
					   			 		report.Member__c = pa.PersonID__c;
					   			 		report.Member_Episys_Alias__c = pa.Account_Number__r.Created_By_User_Alias__c;
					   			 		report.Member_Episys_Id__c = pa.Account_Number__r.Created_By_User__c;
					   			 		report.User_Name__c = pa.Account_Number__r.Created_By_User_Text__c;
					   			 		
					   			 		report.Member_Account__c = pa.Account_Number__r.id;
					   			 		report.Process_Type__c ='Automated';
					   			 		report.Is_Phone_Matching__c = cc.IsPhoneMatching;
							       		report.Is_Email_Matching__c = cc.IsEmailMatching;
							       		report.Is_Street_Matching__c = cc.IsStreetMatching;
							       		report.Is_City_Matching__c = cc.IsCityMatching;
							       		report.Is_State_Matching__c = cc.IsStateMatching;
							       		report.Is_Zipcode_Matching__c = cc.IsZipcodeMatching;
					   			 		report.First_Name__c = cc.FirstName;
					   			 		report.Last_Name__c = cc.LastName;
					   			 		system.debug('report###'+ report);
					   			 		reportlist.Add(report);
									    memberiddone.add(pa.PersonID__c);
				   			 	}
				   			 	
				   			 }
	   			 }
   			 	system.debug('memberiddone#' + memberiddone);
   			 	system.debug('reportlist#' + reportlist.size());
   			 	
   			 	insert reportlist;
   			 	 
				//				
				
			
	          					
	          			 						
        
        }
        
        public static string clearPhoneNumber(string phoneNumber)
        {
        	if(phoneNumber != null)
        	{
        		return phoneNumber.remove(' ').remove('(').remove(')').remove('-');
        	}
        	return '';
        }
   


public class ReportWrapperClass{

public Account ma {get; set;}
public Account pma {get;set;}
public Boolean IsMatching {get;set;}
public Boolean IsPhoneMatching {get;set;}
public Boolean IsEmailMatching {get;set;}
public Boolean IsStreetMatching  {get;set;}
public Boolean IsCityMatching {get;set;}
public Boolean IsStateMatching {get;set;}
public Boolean IsZipcodeMatching {get;set;}
public String FirstName {get;set;}
public String LastName {get;set;}
	


}
}