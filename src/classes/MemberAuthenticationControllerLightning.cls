public class MemberAuthenticationControllerLightning{
         
    @AuraEnabled
    
    public static  Map<string,object> getMemberSearchData(string PhoneNumber, string MemberNumber, string SSNNumber,string IVRGUIDFromUrl)
    {
      	Boolean visible;
      	Boolean OOW;
      	Boolean OTP;
      	Boolean PubCFCU;
      	
      	Id profileId=userinfo.getProfileId();
      	Profile UserProfile = [Select Id,Name from Profile where Id=:profileId];
		system.debug('ProfileName'+UserProfile);
		
	      List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
	      verificationObject userEnteredInformation = new verificationObject();
	     
	    
	      verifyCaller vc = new verifyCaller();
	      list<Account> NameList = new List<Account>();  
	       
	      userEnteredInformation.phoneNumber = PhoneNumber;
	      userEnteredInformation.memberNumber = MemberNumber;
	      userEnteredInformation.SSN = SSNNumber;
	      
	      
	      NameList = vc.queryByParametersAvailable(userEnteredInformation, false); 
	      
	      Map<string,object> result = new  Map<string,object>();
	      result.put('Account', NameList);
	   
	      LevelModel = GetMemberAuthenticationLevel();
	      result.put('Profile',UserProfile);
			
			Blob b = Crypto.GenerateAESKey(128);
			String h = EncodingUtil.ConvertTohex(b);
			String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
			system.debug(guid);
			result.put('GUID',guid);
			
		 	//-----------Code for ReLoad Begin------------------------------------------------------------------
		 	
		 	integer minutes = GetMemberAuthenticationSessionTime();
	        List<Authenticated_Log__c> AuthLog = new List<Authenticated_Log__c>();
	        system.debug('IVRGUIDFromUrl##'+ IVRGUIDFromUrl);
	        
	        if(IVRGUIDFromUrl != null && IVRGUIDFromUrl !=''){	        	
	        
		        AuthLog = [Select id , Guid__c, SalesforceID__c, IVR_GUID__c from Authenticated_Log__c where IVR_GUID__c =: IVRGUIDFromUrl and createddate >=: Datetime.now().addMinutes(minutes) Limit 1] ;
		        system.debug('AuthLogSize##'+ AuthLog.size());
		        
		        if(AuthLog.size() > 0 ){
		        	
		        	result.put('ReLoadRequired', true);
		        	result.put('AuthLog', AuthLog);
		        }
		        else{
		        	result.put('ReLoadRequired', false);
		        }
	        }
	        
			//-----------Code for ReLoad End------------------------------------------------------------------
		
			
	      return result;
    }
    
     @AuraEnabled
    public static Map<string,string> GetAccountNumber(string accdetailid)/* This is for OOW tab*/
    {
      
            string AccountNumber;
         	string MemberName;
         	string FlowURL;
         	string AccountId;
         	OOW_Flow_URL__c oowf = OOW_Flow_URL__c.getValues('OOW Boomi Flow URL');
		
			if(oowf.URL__c != null){
				FlowURL = oowf.URL__C;
			}
			 
        	Map<string,string> strMap = new  Map<string,string>();
            List<Person_Account__c> p = [SELECT Id, Account_Number__c,PersonID__r.Name, PersonID__r.FirstName,PersonID__r.LastName, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:accdetailid  limit 1];
            if(p.size() > 0)
            {    
	         	AccountNumber = p[0].Account_Number__r.Name;
	         	MemberName =  p[0].PersonID__r.Name;
	         	AccountId = p[0].Account_Number__c;
            }
         	
         	strMap.put('AccountNumber',AccountNumber);
       		strMap.put('MemberName',MemberName);
       		strMap.put('FlowURL',FlowURL);
       		strMap.put('AccountId',AccountId);
            return strMap;
        
                         
       
    }
    
    @AuraEnabled
    public static void SaveOOWLogData(string status, string MemberNumber, string MemberId, string reason, string notes, string GUID, string name, string Error, string IVRGUIDFromUrl)/*This is to save OOW log*/
    {
      RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='OOW Execution Log' and SobjectType='Authenticated_Log__c'];
      
       String[] sp2 ;
    	if(name != null && name != '' ){
    		 sp2 = name.split(' ');}
      
      Authenticated_Log__c log = new Authenticated_Log__c();
      log.RecordTypeId= rec.id;
      If(status == 'failed')
      	log.OOW_Status__c = 'Failed';
      If(status == 'passed')
      	log.OOW_Status__c = 'Passed';	
      log.OOW_Member_Number__c = MemberNumber;
      if(reason == '')
     {
         log.OOW_Reason__c = 'N/A';
     }
     else
     {
         log.OOW_Reason__c = reason;
     }
     if(Error != null && Error != '')
     {
     	log.OOW_Notes__c = notes + ' Error:' + Error;
     }
     else
     {
     	log.OOW_Notes__c = notes;
     }
      
      log.SalesforceID__c = MemberId;
      log.Member__c = MemberId;
      log.Staff_Name__c = UserInfo.getName();
      log.Member_Number__c = MemberNumber;
      log.GUID__c = GUID;
      log.IVR_GUID__c = IVRGUIDFromUrl;
      If(status == 'failed')
      	log.Decision__c = 'Failed';
      If(status == 'passed')
      	log.Decision__c = 'Passed';
      system.debug('sp2##'+ sp2);
      if(sp2.size() > 0)log.First_Name__c = sp2[0];
      if(sp2.size() > 2) log.Last_Name__c = sp2[2];
      else if(sp2.size() > 0)log.Last_Name__c = sp2[1];
      
      insert log;
      
      system.debug('log##'+ log);
      
    }
    
    @AuraEnabled
    public static void KYMSaveLogData(string MemberId, string reason, string otherReason, string GUID)/*This is to save OOW log*/
    {
      RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='KYM Log' and SobjectType='Authenticated_Log__c'];
       string  AccountNumber;
      List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:MemberId limit 1];
         if(p.size() > 0)
         {
         	 AccountNumber = p[0].Account_Number__r.Name;
         }
         
     
      
      Authenticated_Log__c log = new Authenticated_Log__c();
      log.RecordTypeId= rec.id;
      log.KYM_Reason__c = reason;
      log.KYM_Member_Number__c = AccountNumber;
      log.KYM_Other_Reason__c = otherReason;
      log.SalesforceID__c = MemberId;
      log.Member__c = MemberId;
      log.Staff_Name__c = UserInfo.getName();
      log.Member_Number__c = AccountNumber;
      log.Member__c = MemberId;
      log.GUID__c = GUID;
      log.Decision__c = reason;
      insert log;
      
      system.debug('log##'+ log);
      
    }
    
    @AuraEnabled
    public static void PublicWalletSaveLogData(string MemberId, string Status, string GUID, string DOBMatch, string IdNumberMatch, String MMNMatch, string EmailMatch, string AdditionalTokenOption3Match, string IVRGUIDFromUrl)
    {
      RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='Public Wallet Log' and SobjectType='Authenticated_Log__c'];
       string  AccountNumber;
      List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:MemberId  limit 1];
      if(p.size() > 0)
      {
           AccountNumber = p[0].Account_Number__r.Name;
      }
      Authenticated_Log__c log = new Authenticated_Log__c();
      log.RecordTypeId= rec.id;
      log.Public_Wallet_Status__c = status;
      log.SalesforceID__c = MemberId;
      log.Member__c = MemberId;
      log.Staff_Name__c = UserInfo.getName();
      log.Decision__c = status;
      log.Member_Number__c = AccountNumber;
      log.GUID__c = GUID;
      log.IVR_GUID__c = IVRGUIDFromUrl;
      log.DOBMatch__c = DOBMatch ;
      log.IdNumberMatch__c =  IdNumberMatch ;
      log.MMNMatch__c = MMNMatch ;
      log.EmailMatch__c = EmailMatch ;
      log.Additional_Token_Option3_Match__c = AdditionalTokenOption3Match ;
      insert log;
      
      
    }
    
    @AuraEnabled
    public static void CFCUWalletSaveLogData(string MemberId, string Status, string GUID, string BeneficiaryDetailMatch, string JointOwnerDetailMatch, string CardNumberMatch, string AdditionalTokenOption1Match, string AdditionalTokenOption2Match, string LoanDetailMatch, string IVRGUIDFromUrl)
    {
      string  AccountNumber;
      RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='CFCU Wallet Log' and SobjectType='Authenticated_Log__c'];
      List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:MemberId  limit 1];
      if(p.size() > 0){
     	 AccountNumber = p[0].Account_Number__r.Name;
      }
      Authenticated_Log__c log = new Authenticated_Log__c();
      log.RecordTypeId= rec.id;
      log.CFCU_Wallet_Status__c = status;
      log.SalesforceID__c = MemberId;
      log.Member__c = MemberId;
      log.Decision__c = status;
      log.Staff_Name__c = UserInfo.getName();
      log.Member_Number__c = AccountNumber;
      log.GUID__c = GUID;
      log.IVR_GUID__c = IVRGUIDFromUrl;
      log.BeneficiaryDetailMatch__c = BeneficiaryDetailMatch;
      log.Joint_OwnerDetailsMatch__c = JointOwnerDetailMatch;
      log.CardNumberMatch__c = CardNumberMatch;
      log.Additional_Token_Option1_Match__c = AdditionalTokenOption1Match;
      log.Additional_Token_Option2_Match__c = AdditionalTokenOption2Match;
      log.Loan_Detail_Match__c = LoanDetailMatch;
       
      
      insert log;
      
      
    }
    
    @AuraEnabled
    public static void InsertLogData(string MemberId, string Decision, string FDL, string PhoneNumber, string EnteredSSN, string PageUrl, string OverrideType, String OverrideSupervisor, String ManagerCallbackComments, string GUID, string IVRGUIDFromUrl)
    {
       string  AccountNumber;
       string AccountId;
       
       RecordType rec =[select Id,Name,SobjectType from RecordType where name ='IVR Authentication Log' and SobjectType='Authenticated_Log__c'];
       List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:MemberId  limit 1];
       if(p.size() > 0)
       {
      	 AccountNumber = p[0].Account_Number__r.Name;
      	 AccountId = p[0].Account_Number__c;
       }
          system.debug('test'+MemberId);
      
      //Account_Details__c accDetail = [select id,name from Account_Details__c where name =:AccountNumber and RecType__c = 'ACCT' limit 1];
          
      Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.IVR_Sent_URL__c = substring(PageUrl, 1000);
        log.CallerPhoneNumber__c = substring(PhoneNumber, 16);
        log.EnteredMemberNumber__c = substring(AccountNumber, 15);
        log.EnteredSSN__c = substring(EnteredSSN, 4);
        log.SalesforceID__c = MemberId;
        log.Decision__c = Decision;
        log.Failed_Desired_Level__c= FDL;
        if(OverrideSupervisor != null && OverrideSupervisor != 'Select'){
        	User u = [select id, name from user where name =:OverrideSupervisor limit 1];
        	log.Override_Request_Supervisor__c = OverrideSupervisor;
        	log.Override_Supervisor__c = u.id;
    	}
        if(OverrideType != null){	
        	log.Override_Request_Type__c = OverrideType;
        }
        log.Member__c = MemberId;
        log.Staff_Name__c =UserInfo.getName();
        log.Member_Number__c = AccountNumber;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
      
      insert log;
      
     //--------------------------------------------Aut-205--------------------------------------------------------------------//
     
     list<CaseRecordType__c> scList = [SELECT Id,Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 SLA__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c='Account Services' AND Teritiary_Category__c='Authentication Failed' LIMIT 1];
       
		Group gp = [select Id, Name from Group where  Type = 'Queue' AND NAME = 'Manager, Call Center Queue'];
		case cs = new case();
			 for(CaseRecordType__c crt : scList){
		            cs.RecordTypeId = scList[0].RecordTypeId__c;
		            cs.Primary_Category__c = scList[0].Primary_Category__c;
		            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
		            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
		            cs.Sla__c = scList[0].SLA__c;
	            
             	}    
				cs.AccountId = MemberId;
				cs.Status = 'Open';
				cs.Subject = 'Manager Callback - Override Requested';
				cs.ownerid = gp.id;
				cs.CaseComments__c = ManagerCallbackComments;
				cs.Account_Number__c = AccountId;
				cs.MAAP_Log__c = log.id;
				insert cs;
        
        if(cs != null){
        	CaseComment cc = new CaseComment();
    		cc.ParentId = cs.id;
    		cc.CommentBody =  ManagerCallbackComments;
    		insert cc;	
        }
        
  	//--------------------------------------------Aut-205--------------------------------------------------------------------//
  		
    }
        
    public static string substring(string val, integer length)
    {
        if(val != null && val != '')
        {
            return val.left(length);
        }   
        return val;
        
    
    }
    
    @AuraEnabled    
    public static Map<string,List<object>> GetCFCUWalletInfo(String selectedID, string IVRGUIDFromUrl)
    {
    	
    	Map<string,List<object>> resultmap = new Map<string,List<object>>();
		Map <id,Person_Account__c> uniqueMembersDetail = new  Map <id,Person_Account__c>();
		List<Account_Details__c> MemberNumberLoanDetail = new List<Account_Details__c>();
		List<Person_Account__c> JTMemberNameDobDetails = new List<Person_Account__c>();
		List<Account_Details__c> cardDetails = new List<Account_Details__c>();
        verifyCaller vc = new verifyCaller();
        
		string JTSelectedID;
		List<JointMemberRelationshipWrapper> JTwrapperLst = new List<JointMemberRelationshipWrapper>();
    	List<Account_Details__c> MemberAccountDetail = new List<Account_Details__c>();
        List<Person_Account__c> RelatedPerson = new List<Person_Account__c>();
        // do not query for beneficiary as we don't want information to be displayed for selected user who is a beneficiary.
        RelatedPerson = [select Account_Number__c from Person_Account__c where TypeTranslate__C != '0004/Beneficiary' and PersonID__c =:selectedID];
        List<id> relatedIds = new List<Id>();
        for(Person_Account__c p : relatedPerson ){
            relatedIds.add(p.Account_Number__c);
        }
        system.debug('relatedIds---'+relatedIds);
        MemberAccountDetail  = [Select Name, id,TypeTranslate__c,Balance__c,OPEN_DATE__c ,Close_Date__c,PAYMENT__c from  Account_Details__c where (Parent_Account__c in :relatedIds Or id in :relatedIds)];
        system.debug('MemberNumberDOBDetail----'+MemberAccountDetail );
		set<String> accName = new Set<String>();
		for(Account_Details__c var: MemberAccountDetail){
            accName.add(var.Name);
        }
			List<Person_Account__c> relatedPerson1 = new List<Person_Account__c>();
			relatedPerson1 = [Select Id,personId__c,Account_Number__c,TypeTranslate__c,Account_Type__c,
							Relationship__c,PersonID__r.SSN_Last_4__pc,Open_Date__c,PersonID__r.BIRTH_DATE__pc,
							Account_Number__r.Name,Account_Number__r.TypeTranslate__c, PersonID__r.FirstName, PersonID__r.LastName,Person_Account__c.Name ,PersonID__r.Name 
							from Person_Account__c where 
							Account_Number__r.Name IN :accName ];
			system.debug('relatedPersonLoan---'+relatedPerson1); 

			if(!relatedPerson1.isEmpty())
					{                        
									  
							   string Thisvalue = 'Primary';        
							   Set<id> personId = new Set<id>(); 
							   set<id> personId1 = new Set<id>();        
									
							   uniqueMembersDetail = new Map <id,Person_Account__c>();      
							   for(Person_Account__c mem : relatedPerson1){  
									
									   if(!string.isEmpty(mem.TypeTranslate__c)){       
										  
											if(mem.TypeTranslate__c.contains('Joint Owner') || mem.TypeTranslate__c.contains('Joint Member') || mem.TypeTranslate__c.contains('Member') 
											|| mem.TypeTranslate__c.contains('Beneficiary') || mem.TypeTranslate__C.contains('Authorized Signer')
											 || mem.TypeTranslate__C.contains('Trustee') || mem.TypeTranslate__C.contains('Custodian') || mem.TypeTranslate__C.contains('Primary')
											 || mem.TypeTranslate__c.contains('Representative Payee')
											 )
											 {      
													system.debug('###  ### 1 - personId ' + personId);
													system.debug('###  ### 2 - personId ' + mem.personId__c); 
													system.debug('###  ### 2 - personId ' + selectedID);  
												   if(!personId.contains(mem.personId__c) ){
														if (selectedID != mem.personId__c)
														{     
														   personId.add(mem.personId__c);       
														   system.debug('not primary');  
															 system.debug('mem##'+ mem);
														   JTMemberNameDobDetails.add(mem);
														}             
												   }                                                                
										   }        
									  }     
						
							   }    
									  
									JTSelectedID = '';
									if(!JTMemberNameDobDetails.isEmpty()){ 
											JointMemberRelationshipWrapper JTW;
											system.debug('Not null');
											for(Person_Account__c pc : JTMemberNameDobDetails){ 
												JTW = new JointMemberRelationshipWrapper();
												JTW.JointMembername  = pc.PersonID__r.Name;
												JTW.ID = pc.PersonID__c;
												JTW.RelationShip = pc.TypeTranslate__c;
												JTW.AccountNumber = pc.Account_Number__r.Name;
												JTwrapperLst.add(JTW);
												
												if(JTSelectedID == '')
												{
													JTSelectedID = JTW.ID + '# # ';
												}
												else
												{
													
													JTSelectedID = JTSelectedID + ';' + JTW.ID + '# # ';
												}
											} 
																																					
										       
										
							   }        
							         
										
							   system.debug('uniqueMembersDetail---'+uniqueMembersDetail);                      
							   
							   system.debug('JTMemberNameDobDetails'+JTMemberNameDobDetails); 
							   system.debug('JTwrapperLst---'+JTwrapperLst); 
					}
					
					resultmap.put('RelationshipData',JTwrapperLst);
					cardDetails = vc.CardNumbersAuth(selectedID);
					system.debug('cardDetails'+cardDetails);
					MemberNumberLoanDetail  = [Select Name, id,TypeTranslate__c,Balance__c,OPEN_DATE__c ,Close_Date__c,PAYMENT__c from  Account_Details__c
					 							where (RecType__c = 'LOAN' or RecType__c = 'MORT' or RecType__c = 'SHAR' or RecType__c = 'STDL') AND (Parent_Account__c in :relatedIds Or id in :relatedIds)];
					resultmap.put('LoanData',MemberNumberLoanDetail);
					resultmap.put('CardDetails',cardDetails);
					//--------------------------Code to maintain state of Pass/ Fail Button within a day------------------------------------
					RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='CFCU Wallet Log' and SobjectType='Authenticated_Log__c' limit 1];
					List<Authenticated_Log__c> authlog = new List<Authenticated_Log__c>();	
					authlog = [Select Id,SalesforceID__c,Member__c,Decision__c,CFCU_Wallet_Status__c,Staff_Name__c,GUID__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,
								CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Loan_Detail_Match__c
								From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : selectedID order by createddate desc Limit 1];					
					
						resultmap.put('CFCULastSessionInfo',authlog);
					
					//--------------------------Code to maintain state of Pass/ Fail Button within a day-----------------------------------
					 //--------------------------Code to maintain state of Pass/ Fail Button on Reload------------------------------------
           				integer minutes = GetMemberAuthenticationSessionTime();
						
						List<Authenticated_Log__c> ReLoadAuthlog = new List<Authenticated_Log__c>();	
						ReLoadAuthlog = [Select Id,SalesforceID__c,Member__c,Decision__c,CFCU_Wallet_Status__c,Staff_Name__c,GUID__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,
								CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Loan_Detail_Match__c
									From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : selectedID AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl];					
					if(ReLoadAuthlog.size() > 0)
					{
						resultmap.put('CFCUReloadInfo',ReLoadAuthlog);
					}
					//--------------------------Code to maintain state of Pass/ Fail Button on Reload-----------------------------------
					return resultmap;
    	
    }
    
    @AuraEnabled        
    public static Map<string,string> getPublicWalletInfo(String MemberId, string IVRGUIDFromUrl )
    {
	    string IDNumberToMatch = '';
	    string DLStateIdPassportToMatch='';
	    String[] dobparse;
	    
        Map<string,string> result = new  Map<string,string>();
        String DLcode;
        String birthDate;
        String ZipCode;
        String MothersMaidenName;
        String EmailList = '';
        Set<String> EmailSet = new Set<String>();
         
        for(Account selectedOne : [select Name,FirstName ,Email_raw__c , Alternate_Email__pc,Residential_Zipocde__pc,  LastName , ID, SSN_Last_4__pc, BIRTH_DATE__pc,Mothers_Maiden_Name__pc, PersonEmail,  ID_1_Description__pc,ID_2_Description__pc,ID_3_Description__pc, ID_1_Number__pc ,ID_2_Number__pc, ID_3_Number__pc, ID_1_Type__pc, ID_2_Type__pc, ID_3_Type__pc, ID_1_Expiration_Date__pc, ID_2_Expiration_Date__pc, ID_3_Expiration_Date__pc, ID_1_Type__c, ID_2_Type__c, ID_3_Type__c from Account where id =:MemberId]){   
            
            if(selectedOne.BIRTH_DATE__pc != null){
            	
            	dobparse = string.ValueOf(selectedOne.BIRTH_DATE__pc).split('-');
          		birthDate = string.ValueOf(dobparse[1]) + '-'+ String.valueOf(dobparse[2])+ '-' + String.valueOf(dobparse[0]);
            	result.put('BDate',birthDate);
            }
            else
            {
            
            	result.put('BDate','');
            }
            
            if(selectedOne.Residential_Zipocde__pc != null){
            	
            	ZipCode = selectedOne.Residential_Zipocde__pc;
            	result.put('ZCode',ZipCode);
            }
            else
            {
            	result.put('ZCode','');
            }
            if(selectedOne.Mothers_Maiden_Name__pc != null){
            	MothersMaidenName = selectedOne.Mothers_Maiden_Name__pc;
            	result.put('MothersMaidenName',MothersMaidenName);
            }
            else
            {
            	result.put('MothersMaidenName','');
            }
            
            if(selectedOne.PersonEmail != null){
            	
            	EmailSet.add(selectedOne.PersonEmail.toLowercase());
            
            }
            if(selectedOne.Alternate_Email__pc != null){
            	
            	EmailSet.add(selectedOne.Alternate_Email__pc.toLowercase());
            }
            
            if(selectedOne.Email_raw__c  != null){
            	
            	EmailSet.add(selectedOne.Email_raw__c.toLowercase());
         	}
        	
        	system.debug('EmailSet'+EmailSet);
        	
        	if(EmailSet.size() > 0){
        		for(String s : EmailSet){
        			
        			if(EmailList != ''){
        				EmailList = EmailList + ' , ' + s;
        			}
        			else{
        				EmailList = s;
        			}
        		}	
        	}
        	
        	result.put('Emails',EmailList);
        	
            if(selectedOne.ID_1_Type__c == null){ 
                if(selectedOne.ID_2_Type__c != null){
                    string ID_1_Type = '';
                    if(selectedOne.ID_2_Type__pc == null)
                    {
                        ID_1_Type = null;
                    }
                    if(selectedOne.ID_2_Type__pc == 2)
                    {
                        ID_1_Type = 'DL';
                    }
                    else if(selectedOne.ID_2_Type__pc == 3)
                    {
                        ID_1_Type = 'SID';
                    }
                    else if(selectedOne.ID_2_Type__pc == 4 || selectedOne.ID_2_Type__pc == 5)
                    {
                        ID_1_Type = 'PSPT'; 
                    }
                    
                    List<String> valuesToJoin = new List<String>();
                    
                    
                    selectedOne.ID_2_Description__pc = (selectedOne.ID_2_Description__pc == '' || selectedOne.ID_2_Description__pc == null) ? '' : string.valueof(selectedOne.ID_2_Description__pc) + ' | ';
                    
                    DLStateIdPassportToMatch = ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_2_Description__pc	 + '' + (selectedOne.ID_2_Number__pc == null? '' : string.valueof(selectedOne.ID_2_Number__pc)+ ' | ') + '' + (selectedOne.ID_2_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_2_Expiration_Date__pc.date()));
                    
					if(DLStateIdPassportToMatch.endsWith(' | '))
					{
						DLStateIdPassportToMatch = DLStateIdPassportToMatch.substring(0,DLStateIdPassportToMatch.lastIndexOf(' | '));
					}                        
                }
                else
                {
                    string ID_1_Type = '';
                    if(selectedOne.ID_3_Type__pc == null)
                    {
                        ID_1_Type = null;
                    }
                    if(selectedOne.ID_3_Type__pc == 2)
                    {
                        ID_1_Type = 'DL';
                    }
                    else if(selectedOne.ID_3_Type__pc == 3)
                    {
                        ID_1_Type = 'SID';
                    }
                    else if(selectedOne.ID_3_Type__pc == 4 || selectedOne.ID_3_Type__pc == 5)
                    {
                        ID_1_Type = 'PSPT'; 
                    }
                    
                    selectedOne.ID_3_Description__pc = (selectedOne.ID_3_Description__pc == '' || selectedOne.ID_3_Description__pc == null) ? '' : string.valueof(selectedOne.ID_3_Description__pc) + ' | ';
                    
                    DLStateIdPassportToMatch = ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_3_Description__pc	 + '' + (selectedOne.ID_3_Number__pc == null? '' : string.valueOf(selectedOne.ID_3_Number__pc) +' | ') + '' + (selectedOne.ID_3_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_3_Expiration_Date__pc.date()));
                    
                    if(DLStateIdPassportToMatch.endsWith(' | '))
					{
						DLStateIdPassportToMatch = DLStateIdPassportToMatch.substring(0,DLStateIdPassportToMatch.lastIndexOf(' | '));
					}
                }
            }
            else{
                    string ID_1_Type = '';
                    if(selectedOne.ID_1_Type__pc == null)
                    {
                        ID_1_Type = null;
                    }
                    if(selectedOne.ID_1_Type__pc == 2)
                    {
                        ID_1_Type = 'DL';
                    }
                    else if(selectedOne.ID_1_Type__pc == 3)
                    {
                        ID_1_Type = 'SID';
                    }
                    else if(selectedOne.ID_1_Type__pc == 4|| selectedOne.ID_1_Type__pc == 5)
                    {
                        ID_1_Type = 'PSPT'; 
                    }
                    
                    selectedOne.ID_1_Description__pc = (selectedOne.ID_1_Description__pc == '' || selectedOne.ID_1_Description__pc == null) ? '' : string.valueof(selectedOne.ID_1_Description__pc) + ' | ';
                    
                	DLStateIdPassportToMatch =  ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_1_Description__pc  +''+ (selectedOne.ID_1_Number__pc == null ? '' : string.valueof(selectedOne.ID_1_Number__pc) + ' | ') + '' + (selectedOne.ID_1_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_1_Expiration_Date__pc.date()));
                	
                	if(DLStateIdPassportToMatch.endsWith(' | '))
					{
						DLStateIdPassportToMatch = DLStateIdPassportToMatch.substring(0,DLStateIdPassportToMatch.lastIndexOf(' | '));
					}
            }
            
            // Set ID Number Status 
            system.debug('IdNumber---'+DLStateIdPassportToMatch);
            
           if (DLStateIdPassportToMatch != '')
           {
                DLcode = DLStateIdPassportToMatch;
                result.put('DLcode', DLcode);
           }
           //--------------------------Code to maintain state of Pass/ Fail Button within a day------------------------------------
					RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='Public Wallet Log' and SobjectType='Authenticated_Log__c' limit 1];
					List<Authenticated_Log__c> authlog = new List<Authenticated_Log__c>();	
					authlog = [Select Id,SalesforceID__c,Member__c,Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c
								From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : MemberId order by createddate desc Limit 1];					
					if(authlog.size() > 0)
					{
						result.put('PublicWalletStatus',authlog[0].Public_Wallet_Status__c);
						result.put('DOBMatch',authlog[0].DOBMatch__c);
						result.put('IdNumberMatch',authlog[0].IdNumberMatch__c);
						result.put('MMNMatch',authlog[0].MMNMatch__c);
						result.put('EmailMatch',authlog[0].EmailMatch__c);
						result.put('AdditionalTokenMatch',authlog[0].Additional_Token_Option3_Match__c);
					}
					//--------------------------Code to maintain state of Pass/ Fail Button within a day-----------------------------------
           
           //--------------------------Code to maintain state of Pass/ Fail Button on Reload------------------------------------
           				integer minutes = GetMemberAuthenticationSessionTime();
						
						List<Authenticated_Log__c> ReLoadAuthlog = new List<Authenticated_Log__c>();	
						ReLoadAuthlog = [Select Id,SalesforceID__c,Member__c,Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c
									From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : MemberId AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl];					
					if(ReLoadAuthlog.size() > 0)
					{
						result.put('RePublicWalletStatus',ReLoadAuthlog[0].Public_Wallet_Status__c);
						result.put('ReDOBMatch',ReLoadAuthlog[0].DOBMatch__c);
						result.put('ReIdNumberMatch',ReLoadAuthlog[0].IdNumberMatch__c);
						result.put('ReMMNMatch',ReLoadAuthlog[0].MMNMatch__c);
						result.put('ReEmailMatch',ReLoadAuthlog[0].EmailMatch__c);
						result.put('ReAdditionalTokenMatch',ReLoadAuthlog[0].Additional_Token_Option3_Match__c);
					}
					//--------------------------Code to maintain state of Pass/ Fail Button on Reload-----------------------------------
        
    	}  
    	return result;
    }
    @AuraEnabled
	public static Map<string,object> GetFailedDesiredLevelLog(string MemberId)
	{
		Boolean IsFailedDesiredLevel;
		 Map<string,object> result = new  Map<string,object>();
		List<Authenticated_Log__c> authlog = new List<Authenticated_Log__c>();	
		authlog = [select id,createddate ,Decision__c from Authenticated_Log__c where createddate = Last_n_days:7 
					and SalesforceID__c =:MemberId and RecordType.name = 'IVR Authentication Log' and Decision__c='Failed Desired Level'];
		
		if(authlog.size() > 0){
			IsFailedDesiredLevel = true;
		}
		else{
			IsFailedDesiredLevel = false;
		}
		result.put('Visible',IsFailedDesiredLevel);
		result.put('Count',authlog.size());
		return result;
		
	}
	@AuraEnabled
	
	public static Map<string,object> MemberVerificationAttemptsCheck(string MemberId, string GUID, string DebitCardStatus, String SSNFromURL, String MemberNumberFromURL,String PhoneFromURL, String PageURL, string IVRGUIDFromUrl, boolean ReLoadRequired, string ReasonCodeFromURL, string HighFlagFromUrl, integer PointsObtained)
	{
		Boolean visible;
		Double attempt;
		Boolean OOW = true;
		Boolean OTP = true;
		Boolean PublicWallet = true;
		Boolean CFCUWallet = true;
		string PWColor ='Grey' ;
		string CWColor ='Grey' ;
		string OOWColor ='Grey';
		string OTPColor ='Grey';
		Map<string,object> result = new  Map<string,object>();
		Boolean FailedDesiredLevelCount;
		List<MC_PIN_Change__c> PC = new List<MC_PIN_Change__c>();
		List<Authenticated_Log__c> FDLog = new List<Authenticated_Log__c>();
		boolean IsPinChanged;
		string  AccountNumber;
		List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
				FROM Person_Account__c where PersonID__c =:MemberId limit 1];
		if(p.size() > 0) {
			
			AccountNumber = p[0].Account_Number__r.Name;
			pc = [select id,Transmission_Date__c,CreatedDate,Member_Number__c,Function__c from MC_PIN_Change__c where Member_Number__c =: AccountNumber and CreatedDate = LAST_N_DAYS:30 and Function__c = 'PIN Change'];
			if(pc.size() > 0){
				IsPinChanged = true;
				result.put('PINChange',IsPinChanged);
			}
			else{
				IsPinChanged = false;
				result.put('PINChange',IsPinChanged);
			}
		}
		
		FDLog = [select id,createddate ,Decision__c from Authenticated_Log__c where createddate = yesterday 
					and SalesforceID__c =:MemberId and RecordType.name = 'IVR Authentication Log' and Decision__c='Failed Desired Level'];
		
		if(FDLog.size() > 0){
				
			result.put('FDLogPreviousDay',true);
		}
		else{
			result.put('FDLogPreviousDay',false);
		}			 
		
		List<Account> accList = [select id, PersonID__c from Account where id= : MemberId];
		string PersonID;
		string MemberType;
		if(accList.size()> 0)
		{
			PersonID = accList[0].PersonID__c;
		}
		if(PersonID.startsWith('C'))
		{
			MemberType ='Foreign';
		}
		else
		{
			MemberType ='Domestic';
		}
		
		result.put('MemberType',MemberType);
	    
	    
		    List<Member_Verification_Attempt__c> mt = [Select id,Member_Name__c, Member_Salesforce_Id__c, Number_of_Attempts__c from Member_Verification_Attempt__c where Member_Salesforce_Id__c =:MemberId and Authentication_Type__c != 'OTP' and CreatedDate = Today limit 1];
		     system.debug('MemberId##'+ MemberId); 
		     system.debug('ReLoadRequired##'+ ReLoadRequired);  
		    if(mt.size() > 0 && ReLoadRequired == false ){
		    	
		    	mt[0].Number_of_Attempts__c = mt[0].Number_of_Attempts__c + 1;
		    	attempt = mt[0].Number_of_Attempts__c;
		    	update mt;
		    }
		    else if(mt.size() == 0 && ReLoadRequired == false){
		    	
		    	Member_Verification_Attempt__c mva = new Member_Verification_Attempt__c();
		    	mva.Member_Salesforce_Id__c = MemberId;
		    	mva.Member_Name__c = AccountNumber;
		    	mva.Number_of_Attempts__c = 1;
		    	attempt = 1;
		    	insert mva;
		    }
		    else if(mt.size() > 0 && ReLoadRequired == true)
		    {
		    	attempt = mt[0].Number_of_Attempts__c;
		    } 
	   //--------------------------------------------- OTP color ----------------------------------------------------------------//
		
		for(Authenticated_Log__c OTPlog : [select id,createddate, GUID__c,Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and  OTP_Status__c != null and SalesforceID__c =:MemberId and RecordType.name = 'OTP Authentication Log' order by RecordType.name, createddate desc limit 1]){
			
			if(OTPlog.OTP_Status__c == 'Failed' ){
				OTP = false;
				OTPColor ='Red';
			}
			if(OTPlog.OTP_Status__c == 'Passed' ){
				OTPColor ='Grey';
			}
		}
		result.put('OTPColor', OTPColor);
		
		
		
		//--------------------------------------------- OOW color ----------------------------------------------------------------//
		
		for(Authenticated_Log__c OOWlog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'OOW Execution Log' order by RecordType.name, createddate desc limit 1]){
			
			if(OOWlog.OOW_Status__c == 'Failed'){
				OOW = false;
				OOWColor ='Red';
			}
			
			if(OOWlog.OOW_Status__c == 'Passed'){
				OOWColor ='Grey';
			}
		}
		result.put('OOWColor', OOWColor);
		
		//--------------------------------------------- Public Wallet color ----------------------------------------------------------------//
		
		for(Authenticated_Log__c Publiclog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'Public Wallet Log' order by RecordType.name, createddate desc limit 1]){
		
			if(Publiclog.Public_Wallet_Status__c == 'Failed'){
				PublicWallet = false;
				PWColor ='Red';
			}
			if(Publiclog.Public_Wallet_Status__c == 'Passed'){
				PWColor ='Grey';
			}
		}
		 
		result.put('PWColor', PWColor);
		
		//--------------------------------------------- CFCU Wallet color ----------------------------------------------------------------//
		 
		for(Authenticated_Log__c CFCUlog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'CFCU Wallet Log' order by RecordType.name, createddate desc limit 1]){
			
			if(CFCUlog.CFCU_Wallet_Status__c == 'Failed'){
				CFCUWallet = false;
				CWColor ='Red';
			}
			if(CFCUlog.CFCU_Wallet_Status__c == 'Passed'){
				CWColor ='Grey';
			}
		}
		result.put('CWColor', CWColor);
		if(OOW == false && OTP == false && (PublicWallet == false || CFCUWallet == false)){
			visible = false;
		} 		
		else{
			visible = true;	
		}
								
		system.debug('ttt'+visible)  ;
		result.put('Visible',visible); 
		result.put('Attempts',attempt);
		result.put('OOWStatusForDay',OOW);
		result.put('OTPStatusForDay',OTP);
		result.put('PublicWalletStatusForDay',PublicWallet) ;
		result.put('CFCUWalletStatusForDay',CFCUWallet);
		result.put('AccountNumber',AccountNumber);
		List<Authenticated_Log__c> authlog = new List<Authenticated_Log__c>();	
		authlog = [select id,createddate ,Decision__c from Authenticated_Log__c where createddate = Last_n_days:7 
					and SalesforceID__c =:MemberId and RecordType.name = 'IVR Authentication Log' and Decision__c='Failed Desired Level'];
		
		if(authlog.size() > 0){
			FailedDesiredLevelCount = true;
		}
		else{
			FailedDesiredLevelCount = false;
		}
		result.put('Show Failed Desired Level',authlog.size());
				
// Implementation to achieve level of authentication based on Open tab
				
	    List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
		
		List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
		
		LevelModel = GetMemberAuthenticationLevel();
		ScoringModel = GetScoringModelData(MemberType);
		
		Double TotalScore=0;
		
		map<string,Integer> scoremap = new map<string,Integer>();
		set<Integer> scoreset = new set<Integer>();
		double ScoreRequired;
// check for KYM tab
		Boolean IsKYMAvailable = false;
		Id profileId=userinfo.getProfileId();
      	Profile UserProfile = [Select Id,Name from Profile where Id=:profileId];
		system.debug('ProfileName'+UserProfile);
		if(UserProfile.Name == 'Branch'){
			IsKYMAvailable = true;
			
		}
		else{
			IsKYMAvailable = false;
		}
		
		
// check for OPT tab based on cancelled attempt
		Boolean IsOTPAvailable = true;
		
		
//	check based on Debit card 

	Boolean IsDebitPinAvailable = false;
	if(DebitCardStatus == 'true'){
		IsDebitPinAvailable = true;
	}else{
		IsDebitPinAvailable = false;
	}	
		
// check based on combination of OOW/OTP/Public and CFCU Wallet
	
	Boolean IsPublicWalletAvailable = false;
	Boolean IsOOWAvailable = false;
	Boolean IsCFCUWalletAvailable = false;
	 if(visible == false && PublicWallet == true )
	{
		IsPublicWalletAvailable = true;
	}
	if(visible == false && CFCUWallet == true )
	{
		IsCFCUWalletAvailable = true;
	}
	if(visible == false && OOW == true)
	{
		IsOOWAvailable = true;
	}
	
	if(visible == true)
	{
		IsPublicWalletAvailable = true;
		IsOOWAvailable = true;
		IsCFCUWalletAvailable = true;
	}
	
	string DebitPinStatus='';
	if(DebitCardStatus =='true'){
		DebitPinStatus ='Pass';
	}
	else if(DebitCardStatus =='false'){
		DebitPinStatus ='Fail';
	}
	
	if(ReLoadRequired == true)
 	{
 		Map<string,object> AutLogDataMap =  getDataForReload(memberid, GUID, IVRGUIDFromUrl,DebitPinStatus);
 		if(AutLogDataMap.get('IsOOWAvailable') == true)
 		{
 			OOW = true;
 		}
 		else
 		{
 			OOW = false;
 		}
 		if(AutLogDataMap.get('IsPublicWalletAvailable') == true)
 		{
 			PublicWallet = true;
 		}
 		else
 		{
 			PublicWallet = false;
 		}
 		if(AutLogDataMap.get('IsCFCUWalletAvailable') == true)
 		{
 			CFCUWallet = true;
 		}
 		else
 		{
 			CFCUWallet = false;
 		}
 		if(AutLogDataMap.get('IsOTPAvailable') == true)
 		{
 			OTP = true;
 		}
 		else
 		{
 			OTP = false;
 		}
 	}
	
	
// calculation for total score available 	
	if(IsKYMAvailable == true)
	{
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
		{
			if(sm.Authentication_Type__c == 'KYM')
			{
				TotalScore = TotalScore + sm.Positive_Point_Value__c;
				scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
				scoreset.add(sm.Positive_Point_Value__c.intValue());
			}
			else
			{
				TotalScore = TotalScore;
			}
		}
	}
	
	system.debug('KYM' + IsKYMAvailable);
	system.debug('TotalScore KYM' + TotalScore);
	if(OTP == true)
	{
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
		{
			if(sm.Authentication_Type__c == 'OTP')
			{
				TotalScore = TotalScore + sm.Positive_Point_Value__c;
				scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
				scoreset.add(sm.Positive_Point_Value__c.intValue());
			}
			else
			{
				TotalScore = TotalScore;
			}
		}
	}
	system.debug('OTP' + IsOTPAvailable);
	system.debug('TotalScore OTP' + TotalScore);
	double DebitPinScore =0;
	if(DebitCardStatus == 'true'){
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
		{
			if(sm.Authentication_Type__c == 'Debit Pin')
			{
				DebitPinScore =  sm.Positive_Point_Value__c;
				
			}
			
		}
	}
	
	system.debug('DEBIT PIN' + IsDebitPinAvailable);
	system.debug('TotalScore Debit' + TotalScore);
	
	if(MemberType =='Foreign')
	{
		IsOOWAvailable = false;
	}
	else
	{
		IsOOWAvailable = true;
	}
	
	if(OOW == true){
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
		{
			if(sm.Authentication_Type__c == 'OOW')
			{
				TotalScore = TotalScore + sm.Positive_Point_Value__c;
				scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
				scoreset.add(sm.Positive_Point_Value__c.intValue());
			}
			else
			{
				TotalScore = TotalScore;
			}
		}
	}
	
	system.debug('OOW' + IsOOWAvailable);
	system.debug('TotalScore OOW' + TotalScore);
	
	if(PublicWallet == true){
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
		{
			if(sm.Authentication_Type__c == 'Public Wallet')
			{
				TotalScore = TotalScore + sm.Positive_Point_Value__c;
				scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
				scoreset.add(sm.Positive_Point_Value__c.intValue());
			}
			else
			{
				TotalScore = TotalScore;
			}
		}
	}
	
	system.debug('Public' + IsPublicWalletAvailable);
	system.debug('TotalScore Public' + TotalScore);
	
	
	if(CFCUWallet == true){
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
		{
			if(sm.Authentication_Type__c == 'CFCU Wallet')
			{
				TotalScore = TotalScore + sm.Positive_Point_Value__c;
				scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
				scoreset.add(sm.Positive_Point_Value__c.intValue());
			}
			else
			{
				TotalScore = TotalScore;
			}
		}
	}
	system.debug('Cfcu' + IsCFCUWalletAvailable );
	system.debug('TotalScore Public' + TotalScore);
	
	
	List<Integer> scorelist = new list<Integer>(scoreset);
	scorelist.sort();
	List<Integer> finalList = new List<Integer>();
	for(Integer i = scorelist.size()-1; i>=0;i--)
	{
	    finalList.add(scorelist.get(i));
	}
	
	
	system.debug('Size##'+ scorelist.size());
	system.debug('scorelist##'+ scorelist);
	system.debug('finalList##'+ finalList);
	
	
	// ------------------Inserting log while user came from URL ----------------------------------//
		
		if(ReLoadRequired == false){
			if(PageURL != null || PageURL != ' '){
				RecordType rec =[select Id,Name,SobjectType from RecordType where name ='IVR Authentication Log' and SobjectType='Authenticated_Log__c'];
				Authenticated_Log__c log = new Authenticated_Log__c();
		        log.IVR_Sent_URL__c = PageURL;
		        log.CallerPhoneNumber__c = PhoneFromURL;
		        log.EnteredMemberNumber__c = MemberNumberFromURL;
		        log.EnteredSSN__c = SSNFromURL;
		        log.Staff_Name__c = UserInfo.getName();
		        log.Member_Number__c = AccountNumber;
		        log.GUID__c = GUID;
		        log.IVR_GUID__c = IVRGUIDFromUrl;
		        if(DebitCardStatus == 'true'){
		        	log.IVR_Pin_Match__c = 'Pass';
		        	log.PINMatch__c = 'Pass';
		        }
		        if(DebitCardStatus == 'false'){
		        	log.IVR_Pin_Match__c = 'Fail';
		        	log.PINMatch__c = 'Fail';
		        }
		        
		        log.RecordtypeId = rec.Id; 
		        log.SalesforceID__c = MemberId;
		        log.Member__c = MemberId;
		        log.HP_HV__c = HighFlagFromUrl;
        		log.IVR_Code__c = ReasonCodeFromURL;
		        insert log;
		        system.debug('log##' + log);
		        RecordType rec1 =[select Id,Name,SobjectType from RecordType where name ='Debit Pin Log' and SobjectType='Authenticated_Log__c'];
                Authenticated_Log__c log1 = new Authenticated_Log__c();
		        log1.IVR_Sent_URL__c = PageURL;
                if(DebitCardStatus == 'true'){
		        	log1.IVR_Pin_Match__c = 'Pass';
		        	log1.PINMatch__c = 'Pass';
                    log1.Decision__c = 'Pass';
		        }
		        if(DebitCardStatus == 'false'){
		        	log1.IVR_Pin_Match__c = 'Fail';
		        	log1.PINMatch__c = 'Fail';
                    log1.Decision__c = 'Fail';
		        }
		        log1.GUID__c = GUID;
		        log1.Staff_Name__c = UserInfo.getName();
		        log1.Member_Number__c = AccountNumber;
		        log1.RecordtypeId = rec1.Id; 
		        log1.SalesforceID__c = MemberId;
		        log1.Member__c = MemberId;
		        insert log1;
		        system.debug('log1##' + log1);
			}
		}
		// ------------------Inserting log while user came from URL ----------------------------------//
		
		//------------------- Fetching Auth Logs for last 30 days achievable level--------------------//
		
		List<Authenticated_Log__c> LastAchieveLogs = new List<Authenticated_Log__c>();
		LastAchieveLogs = [select id,Last_Achievable_Level__c, GUID__c from Authenticated_Log__c where createdDate = Last_n_days:30 and SalesforceID__c =:MemberId and RecordType.name = 'IVR Authentication Log' and Last_Achievable_Level__c != null order by CreatedDate desc Limit 1];
		String level = ' ';
		if(LastAchieveLogs.size() > 0){
			result.put('LastAchievableLevel',LastAchieveLogs[0].Last_Achievable_Level__c);
		}
		
		//------------------- Fetching Auth Logs for last 30 days achievable level ends here--------------------//
		
		//---------------------To Get Which level is achieved on load and what would be the next achievable level based on Debitcard status--------------------------//
			//Aut-190 implementation starts here
			integer OTPAvailable = 0;
			integer PublicWalletAvailable = 0;
			integer CFCUWalletAvailable = 0;
			integer OOWAvailable = 0;
			integer CurrentScore = 0;
			boolean IsLevel1Achieved = false;
			boolean IsLevel2Achieved = false;
			boolean IsLevel3Achieved = false;
			
			if(IsOTPAvailable == true){OTPAvailable=1;}
			if(IsPublicWalletAvailable == true){PublicWalletAvailable=1;}
			if(IsCFCUWalletAvailable == true){CFCUWalletAvailable=1;}
			if(IsOOWAvailable == true){OOWAvailable=1;}
			map<string, List<string>> NextTabToAchieveLevelMap =  GetTabsToAchieveNextLevel(LevelModel, ScoringModel, MemberType, DebitPinStatus, IsPinChanged, OTPAvailable, PublicWalletAvailable, CFCUWalletAvailable,OOWAvailable, CurrentScore);
			List<string>  NextTabLevel2 = NextTabToAchieveLevelMap.get('NextTabLevel2');
        	List<string>  NextTabLevel3 = NextTabToAchieveLevelMap.get('NextTabLevel3');
        	List<string> EachLevelStatus = NextTabToAchieveLevelMap.get('EachLevelStatus');
        	if(NextTabLevel2.size() > 0)
        	{
        		string NextTabLevel2LastString = NextTabLevel2.get(NextTabLevel2.size()-1);
        		NextTabLevel2LastString = NextTabLevel2LastString.removeEnd('or');
        		NextTabLevel2.remove((NextTabLevel2.size()-1));
        		NextTabLevel2.add(NextTabLevel2LastString);
        		system.debug('NextTabLevel2LastString#'+ NextTabLevel2LastString);
        	}
			if(NextTabLevel3.size() > 0){
				string NextTabLevel3LastString = NextTabLevel3.get(NextTabLevel3.size()-1);			
				NextTabLevel3LastString = NextTabLevel3LastString.removeEnd('or');			
				NextTabLevel3.remove((NextTabLevel3.size()-1));			
				NextTabLevel3.add(NextTabLevel3LastString);
				system.debug('NextTabLevel3LastString#'+ NextTabLevel3LastString);
			}
								
			system.debug('NextTabLevel2List#'+ NextTabLevel2);
			system.debug('NextTabLevel3List#'+ NextTabLevel3);
			
			if(EachLevelStatus.size() >0)
			{
				for(string s: EachLevelStatus){
					
					if(s == 'Level 2 Achieved'){
						IsLevel2Achieved = true;
					}
					if(s == 'Level 3 Achieved'){
						IsLevel3Achieved = true;
					}
				}
			}
			
			if(IsLevel2Achieved == true){
        		result.put('NextTabLevel2', 'Level Reached');
        	}
        	else
        	{
        		result.put('NextTabLevel2', NextTabLevel2);
        	}
        	if(IsLevel3Achieved == true){
        		result.put('NextTabLevel3', 'Level Reached');
        	}
        	else{
        		result.put('NextTabLevel3', NextTabLevel3);
        	}
			result.put('IsLevel1Achieved',IsLevel1Achieved);
			result.put('IsLevel2Achieved',IsLevel2Achieved);
			result.put('IsLevel3Achieved',IsLevel3Achieved);
			
			system.debug('NextTabLevel2List#'+ NextTabLevel2);
			system.debug('NextTabLevel3List#'+ NextTabLevel3);
		//----------------------To Get Which level is achieved on load and what would be the next achievable level based on Debitcard status----------------------------------------------------//
		
			result.put('IsKYMAvailable',IsKYMAvailable);
			result.put('IsOTPAvailable',IsOTPAvailable);
			result.put('IsDebitPinAvailable',IsDebitPinAvailable);
			result.put('IsOOWAvailable',IsOOWAvailable);
			result.put('IsPublicWalletAvailable',IsPublicWalletAvailable);
			result.put('IsCFCUWalletAvailable',IsCFCUWalletAvailable);
			
			result.put('MaximumPointsAvailable',TotalScore);
			result.put('LevelModel', LevelModel);
			result.put('ScoringModel', ScoringModel);
		
			return result;
	}
	
	
	@AuraEnabled
	
	public static map<string, List<string>> GetTabsToAchieveNextLevel(List<Member_Authentication_Level_Model__c> LevelModel, List<Member_Authentication_Scoring_Model__c> ScoringModel, string MemberType, string DebitPinStatus, boolean IsPinChanged, integer IsOTPAvailable, integer IsPublicWalletAvailable,integer IsCFCUWalletAvailable,integer IsOOWAvailable, integer CurrentScore)
	{
		system.debug('CurrentScore##'+ CurrentScore);
		map<string, List<string>> resultMap = new map<string, List<string>>();
		Decimal DebitPinPositiveScore;
		Decimal DebitPinNegativeScore;
		Decimal PINChangeNegativeScore;
		Decimal PINChangePositiveScore;
		Decimal PublicWalletScore;
		Decimal CFCUWalletScore;
		Decimal OTPScore;
		Decimal OOWScore;
		Decimal Level2Limit;
		Decimal Level3Limit;
		List<string>  NextTabLevel2 = new List<string>();
        List<string>  NextTabLevel3 = new List<string>();
        List<string>  EachLevelStatus = new List<string>();
        system.debug('ScoringModel##'+ ScoringModel);
        for(Member_Authentication_Scoring_Model__c sm : ScoringModel  )
		{
			if(sm.Authentication_Type__c == 'Public Wallet')
			{
				PublicWalletScore = sm.Positive_Point_Value__c;
			}
			if(sm.Authentication_Type__c == 'CFCU Wallet'){
				
				CFCUWalletScore = sm.Positive_Point_Value__c;				
			}
			if(sm.Authentication_Type__c == 'OTP'){
				
				OTPScore = sm.Positive_Point_Value__c;				
			}
			if(sm.Authentication_Type__c == 'OOW'){
				
				OOWScore = sm.Positive_Point_Value__c;				
			}
			if(sm.Authentication_Type__c == 'Debit Pin' )
			{
				system.debug('sm.Negative_Point_Value__c##'+ sm.Negative_Point_Value__c);
				DebitPinPositiveScore = sm.Positive_Point_Value__c;
				DebitPinNegativeScore = sm.Negative_Point_Value__c;
			}
			if(sm.Authentication_Type__c == 'PIN Change'){
				
				PINChangeNegativeScore = sm.Negative_Point_Value__c;
				PINChangePositiveScore = sm.Positive_Point_Value__c;				
			}
			
		}
		system.debug('DebitPinStatus##'+ DebitPinStatus);	
		system.debug('CurrentScorePre##'+ CurrentScore);
		system.debug('DebitPinNegativeScore##'+ DebitPinNegativeScore);
        if(DebitPinStatus == 'Fail'){
        	CurrentScore = CurrentScore - DebitPinNegativeScore.intValue();
        }
        else if(DebitPinStatus == 'Pass')
        {
        	CurrentScore = CurrentScore + DebitPinPositiveScore.intValue();
        }
        system.debug('CurrentScorePost1##' + CurrentScore);
        system.debug('IsPinChanged##' + IsPinChanged);
        if(IsPinChanged == true){
        	CurrentScore = CurrentScore - PINChangeNegativeScore.intValue();
        }
        else if(IsPinChanged == false){
        	
        	CurrentScore = CurrentScore + PINChangePositiveScore.intValue();
        }
        system.debug('CurrentScorePost2##' + CurrentScore);
        for(Member_Authentication_Level_Model__c lm :LevelModel )
			{
					
					if(lm.Tiers__c == 'Level 2' )
					{
						Level2Limit = lm.Range_Start__c;
						if(CurrentScore > = lm.Range_Start__c){
						
							EachLevelStatus.add('Level 2 Achieved');
						}
					}
					if(lm.Tiers__c == 'Level 3' )
					{
						Level3Limit = lm.Range_Start__c;
						if(CurrentScore > = lm.Range_Start__c){
						
							EachLevelStatus.add('Level 3 Achieved');
						}						
					}
			}
        
        If(IsPublicWalletAvailable == 1 && Level2Limit > CurrentScore && (((IsPublicWalletAvailable * PublicWalletScore) + CurrentScore) >= Level2Limit)){
              
                             NextTabLevel2.add('Pub Wallet or');
		
		}
		
        If(IsCFCUWalletAvailable == 1 && Level2Limit > CurrentScore && (((IsCFCUWalletAvailable * CFCUWalletScore) + CurrentScore) >= Level2Limit)){
              
                              NextTabLevel2.add('CFCU Wallet or');
		
		}
		
		If(IsOTPAvailable == 1 && Level2Limit > CurrentScore && (((IsOTPAvailable * OTPScore) + CurrentScore) >= Level2Limit)){
              
                             NextTabLevel2.add('OTP or');
		
		}
		system.debug('IsOOWAvailable##' + IsOOWAvailable);
		system.debug('CurrentScore##' + CurrentScore);
		system.debug('OOWScore##' + OOWScore);
		system.debug('Level2Limit##' + Level2Limit);
		If(IsOOWAvailable == 1 && Level2Limit > CurrentScore && (((IsOOWAvailable * OOWScore) + CurrentScore) >= Level2Limit)){
              
                            NextTabLevel2.add('OOW or');
		
		}
		
        /*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
        if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable) *	(PublicWalletScore + CFCUWalletScore + CurrentScore)) >= Level2Limit) && 
			((CFCUWalletScore + CurrentScore ) < Level2Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level2Limit )
			)
			{
			
				NextTabLevel2.add('(Public Wallet + CFCU Wallet) or');
			}
        
		if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsOOWAvailable) *	(PublicWalletScore + OOWScore + CurrentScore)) >= Level2Limit) && 
			((OOWScore + CurrentScore ) < Level2Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level2Limit )
			)
			{
			
				NextTabLevel2.add('(Public Wallet + OOW) or');
			}
		
		if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsOTPAvailable) *	(PublicWalletScore + OTPScore + CurrentScore)) >= Level2Limit) && 
			((OTPScore + CurrentScore ) < Level2Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level2Limit )
			)
			{
			
				NextTabLevel2.add('(Public Wallet + OTP) or');
			}
			
		if((CurrentScore < Level2Limit) &&  (((IsCFCUWalletAvailable * IsOOWAvailable) *	(CFCUWalletScore + OOWScore + CurrentScore)) >= Level2Limit) && 
			((OOWScore + CurrentScore ) < Level2Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level2Limit )
			)
			{
			
				NextTabLevel2.add('(CFCU Wallet + OOW) or');
			}
			
		if((CurrentScore < Level2Limit) &&  (((IsCFCUWalletAvailable * IsOTPAvailable) *	(CFCUWalletScore + OTPScore + CurrentScore)) >= Level2Limit) && 
			((OTPScore + CurrentScore ) < Level2Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level2Limit )
			)
			{					
				NextTabLevel2.add('(CFCU Wallet + OTP) or');
			}
			
		if((CurrentScore < Level2Limit) &&  (((IsOOWAvailable * IsOTPAvailable) *	(OOWScore + OTPScore + CurrentScore)) >= Level2Limit) && 
			((OTPScore + CurrentScore ) < Level2Limit ) &&
			((OOWScore + CurrentScore ) < Level2Limit )
			)
			{					
				NextTabLevel2.add('(OOW + OTP) or');
			}
		/*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
		if((CurrentScore < Level2Limit) &&  (((IsCFCUWalletAvailable * IsOOWAvailable * IsOTPAvailable) *	(CFCUWalletScore + OOWScore +OTPScore + CurrentScore)) >= Level2Limit) && 
			((OOWScore + CurrentScore ) < Level2Limit ) &&
			((OTPScore + CurrentScore ) < Level2Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level2Limit ) && 
			((OTPScore + OOWScore + CFCUWalletScore +  CurrentScore) >= Level2Limit) && 	
			((CFCUWalletScore + OTPScore + CurrentScore ) < Level2Limit) &&
			((CFCUWalletScore + OOWScore + CurrentScore ) < Level2Limit) &&
			((OOWScore + OTPScore + CurrentScore ) < Level2Limit) 
			
			)
			{
			
				NextTabLevel2.add('(CFCU Wallet + OOW + OTP) or');
			}
		if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsOOWAvailable * IsOTPAvailable) *	(PublicWalletScore + OOWScore +OTPScore + CurrentScore)) >= Level2Limit) && 
			((OOWScore + CurrentScore ) < Level2Limit ) &&
			((OTPScore + CurrentScore ) < Level2Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level2Limit ) && 
			((OTPScore + OOWScore + PublicWalletScore +  CurrentScore) >= Level2Limit) && 	
			((PublicWalletScore + OTPScore + CurrentScore ) < Level2Limit) &&
			((PublicWalletScore + OOWScore + CurrentScore ) < Level2Limit) &&
			((OOWScore + OTPScore + CurrentScore ) < Level2Limit) 
			
			)
			{
			
				NextTabLevel2.add('(Public Wallet + OOW + OTP) or');
			}
		if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable * IsOOWAvailable ) *	(PublicWalletScore + CFCUWalletScore + OOWScore + CurrentScore)) >= Level2Limit) && 
			((OOWScore + CurrentScore ) < Level2Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level2Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level2Limit ) && 
			((CFCUWalletScore + OOWScore + PublicWalletScore +  CurrentScore) >= Level2Limit) && 	
			((PublicWalletScore + CFCUWalletScore + CurrentScore ) < Level2Limit) &&
			((PublicWalletScore + OOWScore + CurrentScore ) < Level2Limit) &&
			((OOWScore + CFCUWalletScore + CurrentScore ) < Level2Limit) 
			
			)
			{
			
				NextTabLevel2.add('(Public Wallet + CFCU Wallet + OOW) or');
			}
		if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable * IsOTPAvailable ) *	(PublicWalletScore + CFCUWalletScore + OTPScore + CurrentScore)) >= Level2Limit) && 
			((OTPScore + CurrentScore ) < Level2Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level2Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level2Limit ) && 
			((CFCUWalletScore + OTPScore + PublicWalletScore +  CurrentScore) >= Level2Limit) && 	
			((PublicWalletScore + CFCUWalletScore + CurrentScore ) < Level2Limit) &&
			((PublicWalletScore + OTPScore + CurrentScore ) < Level2Limit) &&
			((OTPScore + CFCUWalletScore + CurrentScore ) < Level2Limit) 
			
			)
			{
			
				NextTabLevel2.add('(Public Wallet + CFCU Wallet + OTP) or');
			}
        system.debug('Next Tab#'+ NextTabLevel2);
		resultMap.put('NextTabLevel2', NextTabLevel2);
		
		
        /*---------------------------------------------------------------Level 3----------------------------------------------------------------------------------------------------*/
        If(IsPublicWalletAvailable == 1 && Level3Limit > CurrentScore && (((IsPublicWalletAvailable * PublicWalletScore) + CurrentScore) >= Level3Limit)){
              
                             NextTabLevel3.add('Pub Wallet or');
		
		}
		
        If(IsCFCUWalletAvailable == 1 && Level3Limit > CurrentScore && (((IsCFCUWalletAvailable * CFCUWalletScore) + CurrentScore) >= Level3Limit)){
              
                             NextTabLevel3.add('CFCU Wallet or');
		
		}
		
		If(IsOTPAvailable == 1 && Level3Limit > CurrentScore && (((IsOTPAvailable * OTPScore) + CurrentScore) >= Level3Limit)){
              
                            NextTabLevel3.add('OTP or');
		
		}
		
		If(IsOOWAvailable == 1 && Level3Limit > CurrentScore && (((IsOOWAvailable * OOWScore) + CurrentScore) >= Level3Limit)){
              
                            NextTabLevel3.add('OOW or');
		
		}
		
        /*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
        if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable) *	(PublicWalletScore + CFCUWalletScore + CurrentScore)) >= Level3Limit) && 
			((CFCUWalletScore + CurrentScore ) < Level3Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level3Limit )
			)
			{
			
				NextTabLevel3.add('(Public Wallet + CFCU Wallet) or');
			} 
			
        
		if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsOOWAvailable) *	(PublicWalletScore + OOWScore + CurrentScore)) >= Level3Limit) && 
			((OOWScore + CurrentScore ) < Level3Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level3Limit )
			)
			{
			
				NextTabLevel3.add('(Public Wallet + OOW) or');
			}
			
		
		if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsOTPAvailable) *	(PublicWalletScore + OTPScore + CurrentScore)) >= Level3Limit) && 
			((OTPScore + CurrentScore ) < Level3Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level3Limit )
			)
			{
			
				NextTabLevel3.add('(Public Wallet + OTP) or');
			}
			
			
		if((CurrentScore < Level3Limit) &&  (((IsCFCUWalletAvailable * IsOOWAvailable) *	(CFCUWalletScore + OOWScore + CurrentScore)) >= Level3Limit) && 
			((OOWScore + CurrentScore ) < Level3Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level3Limit )
			)
			{
			
				NextTabLevel3.add('(CFCU Wallet + OOW) or');
			} 
			
			
		if((CurrentScore < Level3Limit) &&  (((IsCFCUWalletAvailable * IsOTPAvailable) *	(CFCUWalletScore + OTPScore + CurrentScore)) >= Level3Limit) && 
			((OTPScore + CurrentScore ) < Level3Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level3Limit )
			)
			{					
				NextTabLevel3.add('(CFCU Wallet + OTP) or');
			}
			
		if((CurrentScore < Level3Limit) &&  (((IsOOWAvailable * IsOTPAvailable) *	(OOWScore + OTPScore + CurrentScore)) >= Level3Limit) && 
			((OTPScore + CurrentScore ) < Level3Limit ) &&
			((OOWScore + CurrentScore ) < Level3Limit )
			)
			{					
				NextTabLevel3.add('(OOW + OTP) or');
			}
			
		/*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
		if((CurrentScore < Level3Limit) &&  (((IsCFCUWalletAvailable * IsOOWAvailable * IsOTPAvailable) *	(CFCUWalletScore + OOWScore +OTPScore + CurrentScore)) >= Level3Limit) && 
			((OOWScore + CurrentScore ) < Level3Limit ) &&
			((OTPScore + CurrentScore ) < Level3Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level3Limit ) && 
			((OTPScore + OOWScore + CFCUWalletScore +  CurrentScore) >= Level3Limit) && 	
			((CFCUWalletScore + OTPScore + CurrentScore ) < Level3Limit) &&
			((CFCUWalletScore + OOWScore + CurrentScore ) < Level3Limit) &&
			((OOWScore + OTPScore + CurrentScore ) < Level3Limit) 
			
			)
			{
			
				NextTabLevel3.add('(CFCU Wallet + OOW + OTP) or');
			}
			
		if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsOOWAvailable * IsOTPAvailable) *	(PublicWalletScore + OOWScore +OTPScore + CurrentScore)) >= Level3Limit) && 
			((OOWScore + CurrentScore ) < Level3Limit ) &&
			((OTPScore + CurrentScore ) < Level3Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level3Limit ) && 
			((OTPScore + OOWScore + PublicWalletScore +  CurrentScore) >= Level3Limit) && 	
			((PublicWalletScore + OTPScore + CurrentScore ) < Level3Limit) &&
			((PublicWalletScore + OOWScore + CurrentScore ) < Level3Limit) &&
			((OOWScore + OTPScore + CurrentScore ) < Level3Limit) 
			
			)
			{
			
				NextTabLevel3.add('(Public Wallet + OOW + OTP) or');
			}
			
		if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable * IsOOWAvailable ) *	(PublicWalletScore + CFCUWalletScore + OOWScore + CurrentScore)) >= Level3Limit) && 
			((OOWScore + CurrentScore ) < Level3Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level3Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level3Limit ) && 
			((CFCUWalletScore + OOWScore + PublicWalletScore +  CurrentScore) >= Level3Limit) && 	
			((PublicWalletScore + CFCUWalletScore + CurrentScore ) < Level3Limit) &&
			((PublicWalletScore + OOWScore + CurrentScore ) < Level3Limit) &&
			((OOWScore + CFCUWalletScore + CurrentScore ) < Level3Limit) 
			
			)
			{
			
				NextTabLevel3.add('(Public Wallet + CFCU Wallet + OOW) or');
			}
			
		if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable * IsOTPAvailable ) *	(PublicWalletScore + CFCUWalletScore + OTPScore + CurrentScore)) >= Level3Limit) && 
			((OTPScore + CurrentScore ) < Level3Limit ) &&
			((CFCUWalletScore + CurrentScore ) < Level3Limit ) &&
			((PublicWalletScore + CurrentScore ) < Level3Limit ) && 
			((CFCUWalletScore + OTPScore + PublicWalletScore +  CurrentScore) >= Level3Limit) && 	
			((PublicWalletScore + CFCUWalletScore + CurrentScore ) < Level3Limit) &&
			((PublicWalletScore + OTPScore + CurrentScore ) < Level3Limit) &&
			((OTPScore + CFCUWalletScore + CurrentScore ) < Level3Limit) 
			
			)
			{
			
				NextTabLevel3.add('(Public Wallet + CFCU Wallet + OTP) or');
			}
			
        system.debug('Next Tab level 3#'+ NextTabLevel3);
      	 
        resultMap.put('NextTabLevel3', NextTabLevel3);
        resultMap.put('EachLevelStatus', EachLevelStatus);
        
        return resultMap;
	}
   
	 @AuraEnabled    
     public static List<Member_Authentication_Level_Model__c> GetMemberAuthenticationLevel()
     {
     	List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
        LevelModel = [Select id, Name, Tiers__c, Description__c,Range_Start__c, Range_End__c from Member_Authentication_Level_Model__c order by Name];
	   
		return LevelModel;
     }
      @AuraEnabled    
     public static List<Member_Authentication_Scoring_Model__c> GetScoringModelData(string MemberType)
     {
     	List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
        
        if(MemberType!= null)
	      {
	        if(MemberType == 'Foreign'){
	        
	          ScoringModel =[select id, Name, Authentication_Type__c,Foreign_Domestic_Flag__c,IsDomestic__c,IsForeign__c,IsPass__c,Negative_Point_Value__c,Positive_Point_Value__c
	                from Member_Authentication_Scoring_Model__c where IsForeign__c =true];
	        }
	        else if(MemberType == 'Domestic')
	        {
	          ScoringModel =[select id, Name, Authentication_Type__c,Foreign_Domestic_Flag__c,IsDomestic__c,IsForeign__c,IsPass__c,Negative_Point_Value__c,Positive_Point_Value__c
	                from Member_Authentication_Scoring_Model__c where IsDomestic__c =true];
	        }
	        
	      }
                	   
		return ScoringModel;
     }
     
	@AuraEnabled
	public static Map<string,object> GetNextAuthenticationType(string MemberId, string MemberType, Integer MaximumPointsAvailable,Integer PointsObtained, boolean IsKYMAvailable, boolean IsOTPAvailable, boolean IsDebitPinAvailable, boolean IsOOWAvailable, boolean IsPublicWalletAvailable, boolean IsCFCUWalletAvailable, string IVRGUIDFromUrl)
	{
		
		//---------------------------------Aut-190 implementation starts here------------------------------------------------------------------------
		system.debug('PointsObtained##'+ PointsObtained);
		boolean IsLevel1Achieved = false;
		boolean IsLevel2Achieved = false;
		boolean IsLevel3Achieved = false;
		
		Map<string,object> result = new  Map<string,object>();
		List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
		List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
		
		
		LevelModel = GetMemberAuthenticationLevel();
		ScoringModel = GetScoringModelData(MemberType);
		
		
			
			List<MC_PIN_Change__c> PC = new List<MC_PIN_Change__c>();
			List<Authenticated_Log__c> FDLog = new List<Authenticated_Log__c>();
			boolean IsPinChanged;
			string  AccountNumber;
			List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
				FROM Person_Account__c where PersonID__c =:MemberId limit 1];
			if(p.size() > 0) {
			
			AccountNumber = p[0].Account_Number__r.Name;
			pc = [select id,Transmission_Date__c,CreatedDate,Member_Number__c,Function__c from MC_PIN_Change__c where Member_Number__c =: AccountNumber and CreatedDate = LAST_N_DAYS:30 and Function__c = 'PIN Change'];
			if(pc.size() > 0){
				IsPinChanged = true;
				result.put('PINChange',IsPinChanged);
			}
			else{
				IsPinChanged = false;
				result.put('PINChange',IsPinChanged);
			}
		}
			
			integer OTPAvailable = 0;
			integer PublicWalletAvailable = 0;
			integer CFCUWalletAvailable = 0;
			integer OOWAvailable = 0;
			integer CurrentScore = 0;
			string DebitCardStatus = 'false';
			if(IsOTPAvailable == true){OTPAvailable=1;}
			if(IsPublicWalletAvailable == true){PublicWalletAvailable=1;}
			if(IsCFCUWalletAvailable == true){CFCUWalletAvailable=1;}
			if(IsOOWAvailable == true){OOWAvailable=1;}
			if(IsOOWAvailable == true){OOWAvailable=1;}
			if(IsDebitPinAvailable == true ){
				DebitCardStatus = 'Pass';
			}else{
				DebitCardStatus = 'Fail';
			}
			system.debug('PointsObtained1##'+ PointsObtained);
			map<string, List<string>> NextTabToAchieveLevelMap =  GetTabsToAchieveNextLevel(LevelModel, ScoringModel, MemberType, DebitCardStatus, IsPinChanged, OTPAvailable, PublicWalletAvailable, CFCUWalletAvailable,OOWAvailable, PointsObtained);
			List<string>  NextTabLevel2 = NextTabToAchieveLevelMap.get('NextTabLevel2');
        	List<string>  NextTabLevel3 = NextTabToAchieveLevelMap.get('NextTabLevel3');
        	List<string> EachLevelStatus = NextTabToAchieveLevelMap.get('EachLevelStatus');
        	
        	if(NextTabLevel2.size() > 0)
        	{
        		string NextTabLevel2LastString = NextTabLevel2.get(NextTabLevel2.size()-1);
        		NextTabLevel2LastString = NextTabLevel2LastString.removeEnd('or');
        		NextTabLevel2.remove((NextTabLevel2.size()-1));
        		NextTabLevel2.add(NextTabLevel2LastString);
        		system.debug('NextTabLevel2LastString#'+ NextTabLevel2LastString);
        	}
			if(NextTabLevel3.size() > 0){
				string NextTabLevel3LastString = NextTabLevel3.get(NextTabLevel3.size()-1);			
				NextTabLevel3LastString = NextTabLevel3LastString.removeEnd('or');			
				NextTabLevel3.remove((NextTabLevel3.size()-1));			
				NextTabLevel3.add(NextTabLevel3LastString);
				system.debug('NextTabLevel3LastString#'+ NextTabLevel3LastString);
			}
			
			
			
			system.debug('NextTabLevel2List#'+ NextTabLevel2);
			system.debug('NextTabLevel3List#'+ NextTabLevel3);
			if(EachLevelStatus.size() >0)
			{
				for(string s: EachLevelStatus){
					
					if(s == 'Level 2 Achieved'){
						IsLevel2Achieved = true;
					}
					if(s == 'Level 3 Achieved'){
						IsLevel3Achieved = true;
					}
				}
			}
			
			if(IsLevel2Achieved == true){
        		result.put('NextTabLevel2', 'Level Reached');
        	}
        	else if(IsLevel2Achieved == false && NextTabLevel2.size()==0){
        		result.put('NextTabLevel2', 'Not Achievable');
        		
        	}
			else if(IsLevel2Achieved == false && NextTabLevel2.size()> 0){
				result.put('NextTabLevel2', NextTabLevel2);
			}
        	if(IsLevel3Achieved == true){
        		result.put('NextTabLevel3', 'Level Reached');
        	}
        	else if(IsLevel3Achieved == false && NextTabLevel3.size()==0){
        		result.put('NextTabLevel3', 'Not Achievable');
        		
        	}
			else if(IsLevel3Achieved == false && NextTabLevel3.size()> 0){
				result.put('NextTabLevel3', NextTabLevel3);
			}
			
			result.put('IsLevel1Achieved',IsLevel1Achieved);
			result.put('IsLevel2Achieved',IsLevel2Achieved);
			result.put('IsLevel3Achieved',IsLevel3Achieved);
			
			//---------------------------------Aut-190 implementation Ends here------------------------------------------------------------------------
			
			string CurrentAuthenticationLevel;
			string LevelofAuthentication;
			for(Member_Authentication_Level_Model__c lm :LevelModel )
			{
				if(lm.Tiers__c == 'Level 1' && MaximumPointsAvailable >= lm.Range_Start__c && MaximumPointsAvailable <= lm.Range_End__c )
				{
					LevelofAuthentication = lm.Tiers__c;
					
				}
				else if(lm.Tiers__c == 'Level 2' && MaximumPointsAvailable >= lm.Range_Start__c && MaximumPointsAvailable <= lm.Range_End__c)
				{
					LevelofAuthentication = lm.Tiers__c;
					
				}
				else if(lm.Tiers__c == 'Level 3' && MaximumPointsAvailable >= lm.Range_Start__c)
				{
					LevelofAuthentication = lm.Tiers__c;
					
				}
				
			}
			
			for(Member_Authentication_Level_Model__c lm :LevelModel )
				{
					if(lm.Tiers__c == 'Level 1' && PointsObtained >= lm.Range_Start__c && PointsObtained <= lm.Range_End__c )
					{
						system.debug('stage1');
						CurrentAuthenticationLevel = lm.Tiers__c;
					}
					else if(lm.Tiers__c == 'Level 2' && PointsObtained >= lm.Range_Start__c && PointsObtained <= lm.Range_End__c)
					{
						system.debug('stage2');
						CurrentAuthenticationLevel = lm.Tiers__c;
						
					}
					else if(lm.Tiers__c == 'Level 3' && PointsObtained >= lm.Range_Start__c)
					{
						system.debug('stage3');
						CurrentAuthenticationLevel = lm.Tiers__c;
						
					}
					
				}
			
			if(IVRGUIDFromUrl !='' && IVRGUIDFromUrl !=null ){
				integer minutes = GetMemberAuthenticationSessionTime();
		     	list<Member_Verification_Attempt__c> mva = new List<Member_Verification_Attempt__c>();
		     	mva = [Select id, IVR_GUID__c, Member_Salesforce_Id__c, Points_Obtained__c, Maximum_Points_Available__c,Current_Authentication_Level__c,Highest_Achievable_Level__c, Next_Level__c from Member_Verification_Attempt__c where IVR_GUID__c=:IVRGUIDFromUrl and Member_Salesforce_Id__c =: memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) limit 1];
		     	if(mva.size() > 0)
		     	{
		     		mva[0].Current_Authentication_Level__c = CurrentAuthenticationLevel; 
		     		mva[0].Highest_Achievable_Level__c = LevelofAuthentication; 
		     		//mva[0].Next_Level__c = ToGetHighestLevel; 
		     		mva[0].Points_Obtained__c = PointsObtained;
     				mva[0].Maximum_Points_Available__c = MaximumPointsAvailable;
		     		update mva;
		     	}else if(mva.size() == 0)
		     	{
		     		Member_Verification_Attempt__c mv = new Member_Verification_Attempt__c();
		     		mv.Member_Salesforce_Id__c = memberid;
		     		mv.IVR_GUID__c = IVRGUIDFromUrl;
		     		mv.Current_Authentication_Level__c = CurrentAuthenticationLevel;
		     		mv.Highest_Achievable_Level__c = LevelofAuthentication;
		     		//mv.Next_Level__c = ToGetHighestLevel;
		     		mv.Points_Obtained__c = PointsObtained;
     				mv.Maximum_Points_Available__c = MaximumPointsAvailable;
		     		insert mv;	
		     		
		     	}
		}
		
		return result;
	}
	
	/* @AuraEnabled
	public static Map<string,object> GetNextAuthenticationType(string MemberId, string MemberType, Integer MaximumPointsAvailable,Integer PointsObtained, boolean IsKYMAvailable, boolean IsOTPAvailable, boolean IsDebitPinAvailable, boolean IsOOWAvailable, boolean IsPublicWalletAvailable, boolean IsCFCUWalletAvailable, string IVRGUIDFromUrl)
	{
		Map<string,object> result = new  Map<string,object>();
		List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
		
		List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
		
		if(MemberType!= null)
	      {
	        if(MemberType == 'Foreign'){
	        
	          ScoringModel =[select id, Name, Authentication_Type__c,Foreign_Domestic_Flag__c,IsDomestic__c,IsForeign__c,IsPass__c,Negative_Point_Value__c,Positive_Point_Value__c
	                from Member_Authentication_Scoring_Model__c where IsForeign__c =true];
	        }
	        else if(MemberType == 'Domestic')
	        {
	          ScoringModel =[select id, Name, Authentication_Type__c,Foreign_Domestic_Flag__c,IsDomestic__c,IsForeign__c,IsPass__c,Negative_Point_Value__c,Positive_Point_Value__c
	                from Member_Authentication_Scoring_Model__c where IsDomestic__c =true];
	        }
	        
	      }
	      
		LevelModel = [Select id, Name, Tiers__c, Description__c,Range_Start__c, Range_End__c from Member_Authentication_Level_Model__c];
		
		string LevelofAuthentication;
		string CurrentAuthenticationLevel;
		map<string,Integer> scoremap = new map<string,Integer>();
		set<Integer> scoreset = new set<Integer>();
		integer ScoreRequired;
		
		if(IsKYMAvailable == true){
			for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
			{
				if(sm.Authentication_Type__c == 'KYM')
				{
					scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
					scoreset.add(sm.Positive_Point_Value__c.intValue());
				}
				
			}
	 	}
	
	system.debug('KYM' + IsKYMAvailable);
	
	if(IsOTPAvailable == true){
			for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
			{
				if(sm.Authentication_Type__c == 'OTP')
				{
					scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
					scoreset.add(sm.Positive_Point_Value__c.intValue());
				}
				
			}
		}
	system.debug('OTP' + IsOTPAvailable);
	system.debug('DEBIT PIN' + IsDebitPinAvailable);
	
	
	if(IsOOWAvailable == true){
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
		{
			if(sm.Authentication_Type__c == 'OOW'){
				scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
				scoreset.add(sm.Positive_Point_Value__c.intValue());
			}
			
		}
	}
	
	system.debug('OOW' + IsOOWAvailable);
	
	if(IsPublicWalletAvailable == true){
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel){
			if(sm.Authentication_Type__c == 'Public Wallet')
			{
				scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
				scoreset.add(sm.Positive_Point_Value__c.intValue());
			}
			
		}
	}
	
	system.debug('Public' + IsPublicWalletAvailable);
	if(IsCFCUWalletAvailable == true){
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel){
			if(sm.Authentication_Type__c == 'CFCU Wallet')
			{
				scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
				scoreset.add(sm.Positive_Point_Value__c.intValue());
			}
			
		}
	}
	system.debug('Cfcu' + IsCFCUWalletAvailable );
	
	for(Member_Authentication_Level_Model__c lm :LevelModel )
	{
		if(lm.Tiers__c == 'Level 1' && MaximumPointsAvailable >= lm.Range_Start__c && MaximumPointsAvailable <= lm.Range_End__c )
		{
			LevelofAuthentication = lm.Tiers__c;
			ScoreRequired = lm.Range_Start__c.intValue();
		}
		else if(lm.Tiers__c == 'Level 2' && MaximumPointsAvailable >= lm.Range_Start__c && MaximumPointsAvailable <= lm.Range_End__c)
		{
			LevelofAuthentication = lm.Tiers__c;
			ScoreRequired = lm.Range_Start__c.intValue();
		}
		else if(lm.Tiers__c == 'Level 3' && MaximumPointsAvailable >= lm.Range_Start__c)
		{
			LevelofAuthentication = lm.Tiers__c;
			ScoreRequired = lm.Range_Start__c.intValue();
		}
		
	}
	for(Member_Authentication_Level_Model__c lm :LevelModel )
	{
		if(lm.Tiers__c == 'Level 1' && PointsObtained >= lm.Range_Start__c && PointsObtained <= lm.Range_End__c )
		{
			CurrentAuthenticationLevel = lm.Tiers__c;
		}
		else if(lm.Tiers__c == 'Level 2' && PointsObtained >= lm.Range_Start__c && PointsObtained <= lm.Range_End__c)
		{
			CurrentAuthenticationLevel = lm.Tiers__c;
			
		}
		else if(lm.Tiers__c == 'Level 3' && PointsObtained >= lm.Range_Start__c)
		{
			CurrentAuthenticationLevel = lm.Tiers__c;
			
		}
		
	}
	
	List<Integer> scorelist = new list<Integer>(scoreset);
	scorelist.sort();
	List<Integer> finalList = new List<Integer>();
	for(Integer i = scorelist.size()-1; i>=0;i--)
	{
	    finalList.add(scorelist.get(i));
	}
	
	
	system.debug('Size##'+ scorelist.size());
	system.debug('scorelist##'+ scorelist);
	system.debug('finalList##'+ finalList);
	integer scoreobtained;
	integer j =0;
	string ToGetHighestLevel='';
	if(IsOTPAvailable == true){
		ToGetHighestLevel='OTP';
	}
	else{
			if(ScoreRequired > PointsObtained)
			{
				for(integer i=0; i< finalList.size(); i++){
					
					if(j==0){
						
						if(finalList[i] < ScoreRequired){
							scoreobtained = finalList[i];
							system.debug('scoreobtained1##' + scoreobtained);
							j++;
						}
						else{ 
							if(finalList.size() != (i+1)){	
								if(finalList[i] >= ScoreRequired && finalList[i+1] <= ScoreRequired){
									if(ScoreRequired == finalList[i+1]){
										scoreobtained = finalList[i+1];
										system.debug('scoreobtained2##' + scoreobtained);
										j++;
									}
									else{
										scoreobtained = finalList[i];
										system.debug('scoreobtained3##' + scoreobtained);
										j++;
									}
								}
							}
							else{
								scoreobtained = finalList[i];	
							}
						}
					}												
				}
				
				for (string key : scoremap.keySet()){
					if(scoremap.get(key) == scoreobtained){
				    	system.debug('Authenticate##' +  key);
				    	ToGetHighestLevel = key;
				    }
				    
				}
			}
	}
		
		
		system.debug('scoreobtained4##' + scoreobtained);
		
		
	//}	
		
		
		result.put('LevelofAuthentication',LevelofAuthentication);
		result.put('NextLevel',ToGetHighestLevel);
		result.put('CurrentAuthenticationLevel',CurrentAuthenticationLevel);
		result.put('ScoreRequired',ScoreRequired );
		
		if(IVRGUIDFromUrl !='' && IVRGUIDFromUrl !=null ){
				integer minutes = GetMemberAuthenticationSessionTime();
		     	list<Member_Verification_Attempt__c> mva = new List<Member_Verification_Attempt__c>();
		     	mva = [Select id, IVR_GUID__c, Member_Salesforce_Id__c, Points_Obtained__c, Maximum_Points_Available__c,Current_Authentication_Level__c,Highest_Achievable_Level__c, Next_Level__c from Member_Verification_Attempt__c where IVR_GUID__c=:IVRGUIDFromUrl and Member_Salesforce_Id__c =: memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) limit 1];
		     	if(mva.size() > 0)
		     	{
		     		mva[0].Current_Authentication_Level__c = CurrentAuthenticationLevel; 
		     		mva[0].Highest_Achievable_Level__c = LevelofAuthentication; 
		     		mva[0].Next_Level__c = ToGetHighestLevel; 
		     		mva[0].Points_Obtained__c = PointsObtained;
     				mva[0].Maximum_Points_Available__c = MaximumPointsAvailable;
		     		update mva;
		     	}else if(mva.size() == 0)
		     	{
		     		Member_Verification_Attempt__c mv = new Member_Verification_Attempt__c();
		     		mv.Member_Salesforce_Id__c = memberid;
		     		mv.IVR_GUID__c = IVRGUIDFromUrl;
		     		mv.Current_Authentication_Level__c = CurrentAuthenticationLevel;
		     		mv.Highest_Achievable_Level__c = LevelofAuthentication;
		     		mv.Next_Level__c = ToGetHighestLevel;
		     		mv.Points_Obtained__c = PointsObtained;
     				mv.Maximum_Points_Available__c = MaximumPointsAvailable;
		     		insert mv;	
		     		
		     	}
		}
		
		
		return result;
				
	}
*/	
	@AuraEnabled
	public static void SaveOTPCancelledAttempt(string MemberId, string GUID, string IVRGUIDFromUrl)
	{
			string  AccountNumber;
			List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
				FROM Person_Account__c where PersonID__c =:MemberId limit 1];
				if(p.size() > 0)
				{
					AccountNumber = p[0].Account_Number__r.Name;
				}
				
	    	 RecordType rec =[select Id,Name,SobjectType from RecordType where name ='OTP Authentication Log' and SobjectType='Authenticated_Log__c'];
	     
	   
	    	
	      	Authenticated_Log__c log = new Authenticated_Log__c();
	        log.RecordTypeId= rec.id;
	        log.SalesforceID__c = MemberId;
	        log.Decision__c = 'OTP - Cancelled';
	        log.Member__c = MemberId;
	        log.Staff_Name__c = UserInfo.getName();
	        log.Member_Number__c = AccountNumber;
	        log.GUID__c = GUID;
	        log.IVR_GUID__c = IVRGUIDFromUrl;
	     	insert log;
            system.debug('OTP-Log##' + log.Id);
	    
				
			
		
	}
	
	@AuraEnabled
	public static void SaveLastAchievableLevelLogs(string MemberId, string GUID, String LastLevel, string IVRGUIDFromUrl)
	{
		string  AccountNumber;
		List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
									FROM Person_Account__c where PersonID__c =:MemberId limit 1];
		if(p.size() > 0)
		{
			AccountNumber = p[0].Account_Number__r.Name;
		}
				
		RecordType rec =[select Id,Name,SobjectType from RecordType where name ='IVR Authentication Log' and SobjectType='Authenticated_Log__c'];
		
		Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.SalesforceID__c = MemberId;
        log.Last_Achievable_Level__c = LastLevel;
        log.Member__c = MemberId;
        log.Member_Number__c = AccountNumber;
        log.Staff_Name__c = UserInfo.getName();
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        log.Decision__c = 'Level Achieved';
        insert log;
				
	}
	
	@AuraEnabled
	public static void SaveCaseWithLogData(string MemberId, string AccountNumber, string casecomment, string AccountId, string GUID, string IVRGUIDFromUrl)
	{
		list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 SLA__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c='Special Situations' AND Teritiary_Category__c='Unusual Activity' LIMIT 1];
       
    		Group gp = [select Id, Name from Group where  Type = 'Queue' AND NAME = 'Authentication Failed – Unusual Activity'];
			case cs = new case();
			 for(CaseRecordType__c crt : scList){
		            cs.RecordTypeId = scList[0].RecordTypeId__c;
		            cs.Primary_Category__c = scList[0].Primary_Category__c;
		            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
		            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
		            cs.Sla__c = scList[0].SLA__c;
	            
             	}    
				cs.AccountId = MemberId;
				cs.Status = 'Open';
				cs.Subject = 'Unusual Activity';
				cs.ownerid = gp.id;
				cs.CaseComments__c = casecomment;
				cs.Account_Number__c = AccountId;
				insert cs;
        
        if(cs != null){
        	CaseComment cc = new CaseComment();
    		cc.ParentId = cs.id;
    		cc.CommentBody =  casecomment;
    		insert cc;	
        }
          			
        RecordType rec =[select Id,Name,SobjectType from RecordType where name ='IVR Authentication Log' and SobjectType='Authenticated_Log__c'];
           
      	Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.SalesforceID__c = MemberId;
        log.Decision__c = 'Unusual Activity-Authentication Failed';
        log.Member__c = MemberId;
        log.Staff_Name__c = UserInfo.getName();
        log.Member_Number__c = AccountNumber;
        log.Case__c = cs.id;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
     	insert log;
     	
    	    			
	}
	
	/*@AuraEnabled
	public static List<Member_Verification_Attempt__c> GetOTPCancelledAttempt(string MemberId)
	{
			
				List<Member_Verification_Attempt__c> mt = [Select id,Member_Name__c,Authentication_Type__c,OTP_Cancelled_Attempt__c, Member_Salesforce_Id__c, Number_of_Attempts__c
						 from Member_Verification_Attempt__c where Member_Salesforce_Id__c =:MemberId and CreatedDate = Today limit 1];
	    return mt;   
	}*/
	@AuraEnabled
	public static List<AuthenticationLogWrapper> GetLogHistoryDetailData(string MemberId, string GUID, string IVRGUIDFromUrl)
	{
		system.debug('MemberId#'+ MemberId);
		system.debug('GUID#'+ GUID);
		List<AuthenticationLogWrapper> logWrapper =  new List<AuthenticationLogWrapper>();
		string SOQLQuery = '';
		SOQLQuery = 'SELECT ' +
					'CFCU_Wallet_Status__c, ' + 
					'Decision__c, ' + 
					'Id, ' + 
					'PINMatch__c, ' + 
					'KYM_Member_Number__c, ' + 
					'KYM_Other_Reason__c, ' + 
					'KYM_Reason__c,' + 
					'Member_Name__c, '+ 
					'Member__c,' + 
					'Name,' + 
					'Staff_Name__c,'+
					'Member_Number__c, ' + 
					'Case__r.CaseNumber , ' +
					'Case__r.CaseComments__c , ' +
					'OOW_Member_Number__c, ' + 
					'OOW_Notes__c,' + 
					'OOW_Reason__c, '+
					'OOW_Status__c, ' +
					'OTP_Status__c, ' + 
					'SalesforceID__c,' + 
					'Public_Wallet_Status__c,' + 
					'CreatedDate,' +
					'RecordType.Name, ' + 
					'IVR_Sent_URL__c, ' +
					'CallerPhoneNumber__c, ' + 
					'Failed_Desired_Level__c, '+
					'Override_Request_Type__c, ' +
					'Last_Achievable_Level__c, ' +
					'Override_Request_Supervisor__c, ' +
					'GUID__c '  + 
					' FROM Authenticated_Log__c where SalesforceID__c =  \'' +  MemberId  +  '\''  +
					'  and GUID__c = \'' +  GUID  +  '\''  ;
		
		
		
																		
		system.debug('SOQLQuery##'+ SOQLQuery);																		
		List<Authenticated_Log__c> LogList= Database.query(SOQLQuery);
		system.debug('LogList#'+ LogList);
		system.debug('LogListSize#'+ LogList.size());
		if(LogList.size() > 0)
		{
			for(Authenticated_Log__c log: LogList)
				{
					AuthenticationLogWrapper lw = new AuthenticationLogWrapper();
					lw.GUID = log.GUID__c;
					log.IVR_GUID__c = IVRGUIDFromUrl;
					lw.DebitPin = log.PinMatch__c;
					lw.CreatedDate = log.CreatedDate.formatGMT('MM-dd-yyyy HH:mm:ss');
					lw.LogNumber = log.Name;
					lw.UserName = log.Staff_Name__c;
					lw.MemberNumber = log.Member_Number__c;
					lw.PhoneNumber= log.CallerPhoneNumber__c;
					if(log.RecordType.Name == 'IVR Authentication Log'){
						lw.AuthenticationType = 'MAAP Authentication Log';
					}
					else{						
						lw.AuthenticationType = log.RecordType.Name;
					}
					lw.Decision= log.Decision__c;
					lw.CaseNumber= log.Case__r.CaseNumber;
					if(log.KYM_Other_Reason__c != null || log.KYM_Other_Reason__c !='' && log.RecordType.Name == 'KYM Log')
					{
						lw.CaseComment = log.KYM_Other_Reason__c;
					}
					else{
						lw.CaseComment = log.Case__r.CaseComments__c;
					}
					lw.OverrideRequestType= log.Override_Request_Type__c;
					lw.OverrideRequestedSupervisor = log.Override_Request_Supervisor__c;
					if(log.Failed_Desired_Level__c =='Level 1 Authentication' || log.Last_Achievable_Level__c =='Level 1'){
						lw.FDL = 'Level 1';
					}
					else if(log.Failed_Desired_Level__c =='Level 2 Authentication' || log.Last_Achievable_Level__c =='Level 2'){
						lw.FDL = 'Level 2';
					}
					else if(log.Failed_Desired_Level__c =='Level 3 Authentication' || log.Last_Achievable_Level__c =='Level 3'){
						lw.FDL = 'Level 3';
					}
					else{
					
						lw.FDL = '';
					}
					logWrapper.add(lw);
					
					system.debug('log##' + lw);
					
				}
		}
		system.debug('logWrapper##' + logWrapper);
		return logWrapper;
		
	}
	
	@AuraEnabled
	public static List<AuthenticationLogWrapper> GetLogHistoryData(string MemberId, Integer Days, string GUID)
	{
		
		List<AuthenticationLogWrapper> logWrapper =  new List<AuthenticationLogWrapper>();
		string SOQLQuery = '';
		SOQLQuery = 'SELECT ' +
					'CFCU_Wallet_Status__c, ' + 
					'Decision__c, ' + 
					'Id, ' + 
					'PINMatch__c, ' + 
					'KYM_Member_Number__c, ' + 
					'KYM_Other_Reason__c, ' + 
					'KYM_Reason__c,' + 
					'Member_Name__c, '+ 
					'Member__c,' + 
					'Name,' + 
					'Staff_Name__c,'+
					'Member_Number__c, ' + 
					'Case__r.CaseNumber , ' +
					'Case__r.CaseComments__c , ' +
					'OOW_Member_Number__c, ' + 
					'OOW_Notes__c,' + 
					'OOW_Reason__c, '+
					'OOW_Status__c, ' +
					'OTP_Status__c, ' + 
					'SalesforceID__c,' + 
					'Public_Wallet_Status__c,' + 
					'CreatedDate,' +
					'RecordType.Name, ' + 
					'IVR_Sent_URL__c, ' +
					'CallerPhoneNumber__c, ' + 
					'Failed_Desired_Level__c, '+
					'Override_Request_Type__c, ' +
					'Last_Achievable_Level__c, ' +
					'Override_Request_Supervisor__c, ' +
					'GUID__c '  + 
					' FROM Authenticated_Log__c where SalesforceID__c =  \'' +  MemberId  +  '\''  +
					'  and createddate = LAST_N_DAYS:' + Days + ' order by createddate desc , RecordType.Name' ;
		
		
		
																		
		system.debug('SOQLQuery##'+ SOQLQuery);																		
		List<Authenticated_Log__c> LogList= Database.query(SOQLQuery);
		
		map<string,Authenticated_Log__c> guidmap = new map<string,Authenticated_Log__c>();
		
		if(LogList.size()> 0)
		{
			for(Authenticated_Log__c log:LogList)
			{
				
				guidmap.put(log.Guid__c, log);
				
				
				
			}
		}
		system.debug('guidmap#'+ guidmap);
		if(guidmap.size() > 0)
		{
			for(Authenticated_Log__c log:guidmap.values())
			{
				AuthenticationLogWrapper lw = new AuthenticationLogWrapper();
				lw.GUID = log.GUID__c;
				lw.DebitPin = log.PinMatch__c;
				
				lw.CreatedDate = log.CreatedDate.formatGMT('MM-dd-yyyy HH:mm:ss');
				
				lw.LogNumber = log.Name;
				lw.UserName = log.Staff_Name__c;
				lw.MemberNumber = log.Member_Number__c;
				lw.PhoneNumber= log.CallerPhoneNumber__c;
				if(log.RecordType.Name == 'IVR Authentication Log'){
						lw.AuthenticationType = 'MAAP Authentication Log';
					}
				else{						
						lw.AuthenticationType = log.RecordType.Name;
					}
				lw.Decision= log.Decision__c;
				lw.CaseNumber= log.Case__r.CaseNumber;
				lw.CaseComment = log.Case__r.CaseComments__c;
				lw.OverrideRequestType= log.Override_Request_Type__c;
				lw.OverrideRequestedSupervisor = log.Override_Request_Supervisor__c;
				
				if(log.Failed_Desired_Level__c =='Level 1 Authentication' || log.Last_Achievable_Level__c =='Level 1'){
					lw.FDL = 'Level 1';
				}
				else if(log.Failed_Desired_Level__c =='Level 2 Authentication' || log.Last_Achievable_Level__c =='Level 2'){
					lw.FDL = 'Level 2';
				}
				else if(log.Failed_Desired_Level__c =='Level 3 Authentication' || log.Last_Achievable_Level__c =='Level 3'){
					lw.FDL = 'Level 3';
				}
				else{
					
					lw.FDL = '';
				}
				
				
				
				guidmap.put(log.Guid__c, log);
				logWrapper.add(lw);
				
				system.debug('log##' + lw);
			}
		}
		
		
		
			
		return logWrapper;		
	}
	
	@AuraEnabled
	public static List<User> GetSupervisor(string MemberId, Integer Days, string GUID)
	{
		
		set<ID> UserIdSet = new set<ID>();
		List<User> UserList = new List<User>();
		List<Group> grp = [select Id, Name from Group where Name = 'Manager Override Supervisor'];
		List<GroupMember> grpMember = [SELECT Id, group.name, group.type, UserOrGroupId FROM GroupMember where group.id =: grp[0].Id];
		if(grpMember.size() > 0)
		{
			for(GroupMember gm : grpMember )
			{
				UserIdSet.add(gm.UserOrGroupId);
			}
		}
		
		if(UserIdSet.size() > 0)
		{
			UserList = [Select Id, Name from User where Id IN:UserIdSet];
		}
		
		
		return UserList;
	}
	
	@AuraEnabled
    public static Map<string,object> getLevel(string accoutid)
    { 
    	Map<string,object> result = new  Map<string,object>();
        
        List<Authenticated_Log__c> LastLog = [SELECT CFCU_Wallet_Status__c, Decision__c, Id,KYM_Member_Number__c,KYM_Other_Reason__c,KYM_Reason__c,Member_Name__c,Member__c,Name,Staff_Name__c,Member_Number__c,
					Last_Achievable_Level__c,OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c,OTP_Status__c,SalesforceID__c,Public_Wallet_Status__c,
					CreatedDate,RecordType.Name,IVR_Sent_URL__c,CallerPhoneNumber__c,Failed_Desired_Level__c,Override_Request_Type__c,Override_Request_Supervisor__c,
					GUID__c FROM Authenticated_Log__c where SalesforceID__c =:accoutid AND CreatedDate = Today AND Last_Achievable_Level__c != null order by CreatedDate desc LIMIT 1];    
        
        if(LastLog.size() > 0){
        	result.put('Level',LastLog[0].Last_Achievable_Level__c);
        }
        return result;
    }
    
     @AuraEnabled    
     public static void SaveFailedDesiredLevelLog(string MemberId,string Decision, string FDL, string GUID, string IVRGUIDFromUrl)
     {			
     	List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                					FROM Person_Account__c where PersonID__c =:MemberId  limit 1];
		string AccountNumber;     
	    if(p.size() > 0){
	    	AccountNumber = p[0].Account_Number__r.Name;
	    }
		      
 		RecordType rec =[select Id,Name,SobjectType from RecordType where name ='IVR Authentication Log' and SobjectType='Authenticated_Log__c'];
 		Authenticated_Log__c log = new Authenticated_Log__c();
	    log.RecordTypeId= rec.id;
	    log.SalesforceID__c = MemberId;
	    log.Decision__c = Decision;
	    log.Failed_Desired_Level__c= FDL;
	    log.Member__c = MemberId;
	    log.Member_Number__c = AccountNumber;
	    log.Staff_Name__c =UserInfo.getName();
	    log.GUID__c = GUID;
	    log.IVR_GUID__c = IVRGUIDFromUrl;
	    insert log;
     	
     }
    
	@AuraEnabled
    public static Map<string,object> getDataForReload(string memberid, string GUID, string IVRGUIDFromUrl, string DebitCardStatus )
    { 
		integer OTPAvailable = 0;
		integer PublicWalletAvailable = 0;
		integer CFCUWalletAvailable = 0;
		integer OOWAvailable = 0;
		integer CurrentScore = 0;
		boolean IsPinChanged;
		string  AccountNumber;
		string DebitPinStatus='';
		boolean IsLevel1Achieved = false;
		boolean IsLevel2Achieved = false;
		boolean IsLevel3Achieved = false;
		List<MC_PIN_Change__c> PC = new List<MC_PIN_Change__c>();
		List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();		
		List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
    	Map<string,object> AuthLogMap = new  Map<string,object>();
    	
        integer minutes = GetMemberAuthenticationSessionTime();
        LevelModel = GetMemberAuthenticationLevel();
        List<Account> accList = [select id, PersonID__c from Account where id= : MemberId];
		string PersonID;
		string MemberType;
		if(accList.size()> 0)
		{
			PersonID = accList[0].PersonID__c;
		}
		if(PersonID.startsWith('C'))
		{
			MemberType ='Foreign';
		}
		else
		{
			MemberType ='Domestic';
		}
		
		system.debug('MemberType##'+ MemberType);
		ScoringModel = GetScoringModelData(MemberType);
        system.debug('ScoringModel##'+ ScoringModel);
        
        RecordType OOWRec = [select Id,Name,SobjectType from RecordType where Name ='OOW Execution Log' and SobjectType='Authenticated_Log__c'];
        List<Authenticated_Log__c> OOWLogData = [SELECT ID, Decision__c, Member_Name__c,Member__c,Name,Staff_Name__c,Member_Number__c,
					OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c,IVR_GUID__c,GUID__c
					 FROM Authenticated_Log__c where SalesforceID__c =:memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl and RecordTypeId=: OOWRec.Id Limit 1];    
        if(OOWLogData.size() > 0){
       		AuthLogMap.put('OOWLogData',OOWLogData);
       		AuthLogMap.put('IsOOWAvailable',false);
        }
        else{
        	AuthLogMap.put('IsOOWAvailable',true);
        	OOWAvailable = 1;
        }
        
        RecordType PublicRec = [select Id,Name,SobjectType from RecordType where Name ='Public Wallet Log' and SobjectType='Authenticated_Log__c' limit 1];
        List<Authenticated_Log__c> PublicLogData = new List<Authenticated_Log__c>();	
		PublicLogData = [Select Id,SalesforceID__c,Member__c,Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c
							From Authenticated_Log__c where createddate = Today and RecordTypeId= : PublicRec.id and SalesforceID__c = : MemberId AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl];
         if(PublicLogData.size() > 0){
       		AuthLogMap.put('PublicLogData',PublicLogData);
       		AuthLogMap.put('IsPublicWalletAvailable',false);
        }
        else{
        	AuthLogMap.put('IsPublicWalletAvailable',true);
        	PublicWalletAvailable = 1;
        }
        
        
        RecordType CFCURec = [select Id,Name,SobjectType from RecordType where Name ='CFCU Wallet Log' and SobjectType='Authenticated_Log__c' limit 1];
        List<Authenticated_Log__c> CFCULogData = new List<Authenticated_Log__c>();	
		CFCULogData = [Select Id,SalesforceID__c,Member__c,CFCU_Wallet_Status__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c, Loan_Detail_Match__c
							From Authenticated_Log__c where createddate = Today and RecordTypeId= : CFCURec.id and SalesforceID__c = : MemberId AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl];
         if(CFCULogData.size() > 0){
       		AuthLogMap.put('CFCULogData',CFCULogData);
       		AuthLogMap.put('IsCFCUWalletAvailable',false);
        }
        else{
        		AuthLogMap.put('IsCFCUWalletAvailable',true);
        		CFCUWalletAvailable = 1;
        	}
        
        RecordType OTPRec = [select Id,Name,SobjectType from RecordType where Name ='OTP Authentication Log' and SobjectType='Authenticated_Log__c' limit 1];
     	
     	List<Authenticated_Log__c> OTPLogData = [SELECT ID, Decision__c, OTP_Email__c,OTP_Phone__c,OTP_Status__c
					 FROM Authenticated_Log__c where OTP_Status__c != null and  SalesforceID__c =:memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl and RecordTypeId=: OTPRec.Id limit 1];
		if(OTPLogData.size() > 0){
			AuthLogMap.put('OTPLogData',OTPLogData);
			AuthLogMap.put('IsOTPAvailable',false);
		}
		else
		{
			AuthLogMap.put('IsOTPAvailable',true);
			OTPAvailable = 1;
		}
				
		list<Member_Verification_Attempt__c> mva = new List<Member_Verification_Attempt__c>();
     	mva = [Select id, IVR_GUID__c, Member_Salesforce_Id__c, Points_Obtained__c, Maximum_Points_Available__c, Current_Authentication_Level__c, Highest_Achievable_Level__c, Next_Level__c from Member_Verification_Attempt__c where IVR_GUID__c=:IVRGUIDFromUrl and Member_Salesforce_Id__c =: memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) limit 1];
       
     	if(mva.size() > 0)
     	{
     		AuthLogMap.put('ScorePoints',mva);
     		CurrentScore = mva[0].Points_Obtained__c.intValue();
     	}
     	system.debug('ScorePoints##'+ AuthLogMap);
     	
     	List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
				FROM Person_Account__c where PersonID__c =:memberid limit 1];
		if(p.size() > 0) {
			
			AccountNumber = p[0].Account_Number__r.Name;
			pc = [select id,Transmission_Date__c,CreatedDate,Member_Number__c,Function__c from MC_PIN_Change__c where Member_Number__c =: AccountNumber and CreatedDate = LAST_N_DAYS:30 and Function__c = 'PIN Change'];
			if(pc.size() > 0){
				IsPinChanged = true;
				
			}
			else{
				IsPinChanged = false;
				
			}
		}
     		
     	
		
		
		
		
		if(DebitCardStatus =='true'){
			DebitPinStatus ='Pass';
		}
		else if(DebitCardStatus =='false'){
			DebitPinStatus ='Fail';
		}
		system.debug('CurrentScore##' + CurrentScore);
		system.debug('OOWAvailable##'+ OOWAvailable);
		
     	map<string, List<string>> NextTabToAchieveLevelMap =  GetTabsToAchieveNextLevel(LevelModel, ScoringModel, MemberType, DebitPinStatus, IsPinChanged, OTPAvailable, PublicWalletAvailable, CFCUWalletAvailable,OOWAvailable, CurrentScore);
		List<string>  NextTabLevel2 = NextTabToAchieveLevelMap.get('NextTabLevel2');
    	List<string>  NextTabLevel3 = NextTabToAchieveLevelMap.get('NextTabLevel3');
    	List<string> EachLevelStatus = NextTabToAchieveLevelMap.get('EachLevelStatus');
    	if(NextTabLevel2.size() > 0)
        	{
        		string NextTabLevel2LastString = NextTabLevel2.get(NextTabLevel2.size()-1);
        		NextTabLevel2LastString = NextTabLevel2LastString.removeEnd('or');
        		NextTabLevel2.remove((NextTabLevel2.size()-1));
        		NextTabLevel2.add(NextTabLevel2LastString);
        		system.debug('NextTabLevel2LastString#'+ NextTabLevel2LastString);
        	}
			if(NextTabLevel3.size() > 0){
				string NextTabLevel3LastString = NextTabLevel3.get(NextTabLevel3.size()-1);			
				NextTabLevel3LastString = NextTabLevel3LastString.removeEnd('or');			
				NextTabLevel3.remove((NextTabLevel3.size()-1));			
				NextTabLevel3.add(NextTabLevel3LastString);
				system.debug('NextTabLevel3LastString#'+ NextTabLevel3LastString);
			}
								
			system.debug('NextTabLevel2List#'+ NextTabLevel2);
			system.debug('NextTabLevel3List#'+ NextTabLevel3);
			
     		system.debug('EachLevelStatus##'+ EachLevelStatus);
		
		if(EachLevelStatus.size() >0)
		{
			for(string s: EachLevelStatus){
				
				if(s == 'Level 2 Achieved'){
					IsLevel2Achieved = true;
				}
				if(s == 'Level 2 Achieved'){
					IsLevel2Achieved = true;
				}
			}
		}
		
		if(IsLevel2Achieved == true){
    		AuthLogMap.put('NextTabLevel2', 'Level Reached');
    	}
    	else
    	{
    		AuthLogMap.put('NextTabLevel2', NextTabLevel2);
    	}
    	if(IsLevel3Achieved == true){
    		AuthLogMap.put('NextTabLevel3', 'Level Reached');
    	}
    	else{
    		AuthLogMap.put('NextTabLevel3', NextTabLevel3);
    	}
		AuthLogMap.put('IsLevel1Achieved',IsLevel1Achieved);
		AuthLogMap.put('IsLevel2Achieved',IsLevel2Achieved);
		AuthLogMap.put('IsLevel3Achieved',IsLevel3Achieved);
	
		
        return AuthLogMap;
    }
    
    
    @AuraEnabled
    
     public static integer GetMemberAuthenticationSessionTime()
     {
     	List<Member_Authentication_Session_Time__c> custSetting = new List<Member_Authentication_Session_Time__c>();
       	custSetting = [Select id, Name, Session_Time__c from Member_Authentication_Session_Time__c];
	    integer minutes=0;
	    if(custSetting.size() > 0){        	
	       	minutes =  custSetting[0].Session_Time__c.intValue();        	        	
	    }
		minutes = minutes * (-1);
		return minutes;
     }
    
    
    
	public class AuthenticationLogWrapper{
      
      	@AuraEnabled
      	
        public string GUID {get;set;}
      	
      	@AuraEnabled
      	
        public String CreatedDate {get;set;}
        @AuraEnabled
      	
        public string LogNumber {get;set;}
        @AuraEnabled
        
        
        public string UserName {get;set;}
        @AuraEnabled
        
        public string MemberNumber {get; set;}        
        @AuraEnabled
        
        public string PhoneNumber {get;set;}
        @AuraEnabled
        
        public string AuthenticationType {get;set;}
        @AuraEnabled
        
        public string Decision {get;set;}
         @AuraEnabled
        
        public string FDL {get;set;}
        
         @AuraEnabled
        
        public string CaseNumber {get;set;}
         @AuraEnabled
         public string CaseComment {get;set;}
         @AuraEnabled
         
        public string OverrideRequestType {get;set;}
        @AuraEnabled
        
        public string OverrideRequestedSupervisor {get;set;}
        
         @AuraEnabled
        
        public string DebitPin {get;set;}
     
      }
	
    
   public class JointMemberRelationshipWrapper{
      
      	@AuraEnabled
        public string AccountNumber {get;set;}
      
        @AuraEnabled
        public string RelationShip {get;set;}
      
        @AuraEnabled
        public string JointMembername {get; set;}
        
        @AuraEnabled
        public Id ID {get;set;}
     
      }
    
    
}