public class MemberAuthenticationControllerLightning{
         
    @AuraEnabled
    
    public static  Map<string,object> getMemberSearchData(string PhoneNumber, string MemberNumber, string SSNNumber, string DOBNumber)
    {
      	Boolean visible;
      	Boolean OOW;
      	Boolean OTP;
      	Boolean PubCFCU;
      	
      	Id profileId=userinfo.getProfileId();
      	Profile UserProfile = [Select Id,Name from Profile where Id=:profileId];
		system.debug('ProfileName'+UserProfile);
		
	      List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
	      List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
	      verificationObject userEnteredInformation = new verificationObject();
	      String[] dobparse;
	    
	      verifyCaller vc = new verifyCaller();
	      list<Account> NameList = new List<Account>();  
	       
	      userEnteredInformation.phoneNumber = PhoneNumber;
	      userEnteredInformation.memberNumber = MemberNumber;
	      userEnteredInformation.SSN = SSNNumber;
	      system.debug('DOBNumber##' + DOBNumber);
	      
	      
	      if(DOBNumber != null && DOBNumber!=''){ 
	        
	        dobparse = DOBNumber.split('-');
	          userEnteredInformation.DOB = string.ValueOf(dobparse[2]) + '-'+ String.valueOf(dobparse[0])+ '-' + String.valueOf(dobparse[1]);
	          
	          
	      }
	      
	      NameList = vc.queryByParametersAvailable(userEnteredInformation, false); 
	      
	      Map<string,object> result = new  Map<string,object>();
	      result.put('Account', NameList);
	      
	    /*  if(MemberType!= null)
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
	      */
	      LevelModel = [Select id, Name, Tiers__c, Description__c,Range_Start__c, Range_End__c from Member_Authentication_Level_Model__c];
	      
	      
	      
			//  result.put('ScoringModel',ScoringModel);
			  result.put('Profile',UserProfile);
			//  result.put('LevelModel',LevelModel);
	     
			Blob b = Crypto.GenerateAESKey(128);
			String h = EncodingUtil.ConvertTohex(b);
			String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
			system.debug(guid);
			result.put('GUID',guid);
			
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
    public static void SaveOOWLogData(string status, string MemberNumber, string MemberId, string reason, string notes, string GUID, string name, string Error)/*This is to save OOW log*/
    {
      RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='OOW Execution Log' and SobjectType='Authenticated_Log__c'];
      
       String[] sp2 ;
    	if(name != null && name != '' ){
    		 sp2 = name.split(' ');}
      
      Authenticated_Log__c log = new Authenticated_Log__c();
      log.RecordTypeId= rec.id;
      log.OOW_Status__c = status;
      log.OOW_Member_Number__c = MemberNumber;
      if(reason == '')
     {
         log.OOW_Reason__c = 'N/A';
     }
     else
     {
         log.OOW_Reason__c = reason;
     }
     if(Error != null || Error != '')
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
      log.Decision__c = status;
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
      log.GUID__c = GUID;
      log.Decision__c = reason;
      insert log;
      
      system.debug('log##'+ log);
      
    }
    
    @AuraEnabled
    public static void PublicWalletSaveLogData(string MemberId, string Status, string GUID)
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
      insert log;
      
      
    }
    
    @AuraEnabled
    public static void CFCUWalletSaveLogData(string MemberId, string Status, string GUID)
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
      insert log;
      
      
    }
    
    @AuraEnabled
    public static void InsertLogData(string MemberId, string Decision, string FDL, string PhoneNumber, string EnteredSSN, String DOB, string PageUrl, string OverrideType, String OverrideSupervisor, string GUID)
    {
        string  AccountNumber;
       RecordType rec =[select Id,Name,SobjectType from RecordType where name ='IVR Authentication Log' and SobjectType='Authenticated_Log__c'];
       List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:MemberId  limit 1];
       if(p.size() > 0)
       {
      	 AccountNumber = p[0].Account_Number__r.Name;
       }
          system.debug('test'+MemberId);
      
      //Account_Details__c accDetail = [select id,name from Account_Details__c where name =:AccountNumber and RecType__c = 'ACCT' limit 1];
          
      Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.IVR_Sent_URL__c = substring(PageUrl, 1000);
        log.CallerPhoneNumber__c = substring(PhoneNumber, 16);
        log.EnteredMemberNumber__c = substring(AccountNumber, 15);
        log.EnteredSSN__c = substring(EnteredSSN, 4);
        log.DOB__c = substring(DOB, 50);
        log.SalesforceID__c = MemberId;
        log.Decision__c = Decision;
        log.Failed_Desired_Level__c= FDL;
        if(OverrideSupervisor != null && OverrideSupervisor != 'Select'){
        	User u = [select id, name from user where name =:OverrideSupervisor];
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
      
      insert log;
      
      if(Decision == 'Authentication Passed'){      
      		//Case cs = new Case();
      		//cs.Account_Number__c = accDetail.Id;
      		//insert cs;
      }
  		
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
    public static Map<string,List<object>> GetCFCUWalletInfo(String selectedID)
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
					 							where (RecType__c = 'LOAN' or RecType__c = 'MORT' or RecType__c = 'STDL') AND (Parent_Account__c in :relatedIds Or id in :relatedIds)];
					resultmap.put('LoanData',MemberNumberLoanDetail);
					resultmap.put('CardDetails',cardDetails);
					return resultmap;
    	
    }
    
    @AuraEnabled        
    public static Map<string,string> getPublicWalletInfo(String MemberId)
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
	public static Map<string,object> MemberVerificationAttemptsCheck(string MemberId, string GUID, string DebitCardStatus, String SSNFromURL, String MemberNumberFromURL,String PhoneFromURL, String PageURL)
	{
		Boolean visible;
		Double attempt;
		Double OTPAttemptCount;
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
		
		string  AccountNumber;
		List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
				FROM Person_Account__c where PersonID__c =:MemberId limit 1];
		if(p.size() > 0) {
			
			AccountNumber = p[0].Account_Number__r.Name;
			pc = [select id,Transmission_Date__c,CreatedDate,Member_Number__c,Function__c from MC_PIN_Change__c where Member_Number__c =: AccountNumber and CreatedDate = LAST_N_DAYS:30 and Function__c = 'PIN Change'];
			if(pc.size() > 0){
				result.put('PINChange',true);
			}
			else{
				result.put('PINChange',false);
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
	    
	    if(mt.size() > 0){
	    	
	    	mt[0].Number_of_Attempts__c = mt[0].Number_of_Attempts__c + 1;
	    	attempt = mt[0].Number_of_Attempts__c;
	    	update mt;
	    }
	    else{
	    	
	    	Member_Verification_Attempt__c mva = new Member_Verification_Attempt__c();
	    	mva.Member_Salesforce_Id__c = MemberId;
	    	mva.Member_Name__c = AccountNumber;
	    	mva.Number_of_Attempts__c = 1;
	    	attempt = 1;
	    	insert mva;
	    } 
	    
	    List<Member_Verification_Attempt__c> mt1 = [Select id,Member_Name__c,Authentication_Type__c,OTP_Cancelled_Attempt__c, Member_Salesforce_Id__c, Number_of_Attempts__c
						 from Member_Verification_Attempt__c where Member_Salesforce_Id__c =:MemberId and CreatedDate = Today limit 1];
	    if(mt1.size() > 0)
	    {
	    	OTPAttemptCount = mt1[0].OTP_Cancelled_Attempt__c;
	    }
	    else{OTPAttemptCount=0;}
	    
		//--------------------------------------------- OTP color ----------------------------------------------------------------//
		
		for(Authenticated_Log__c OTPlog : [select id,createddate, GUID__c,Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and  OTP_Status__c != null and SalesforceID__c =:MemberId and RecordType.name = 'OTP Authentication Log' order by RecordType.name, createddate desc limit 1]){
			
			if(OTPlog.OTP_Status__c == 'failed' ){
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
			
			if(OOWlog.OOW_Status__c == 'failed'){
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
		
			if(Publiclog.Public_Wallet_Status__c == 'failed'){
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
			
			if(CFCUlog.CFCU_Wallet_Status__c == 'failed'){
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
		/*List<Authenticated_Log__c> GUIDList = new List<Authenticated_Log__c>();
		GUIDList  = [ select id, createddate, Decision__c, GUID__c from Authenticated_Log__c where createddate = Today and GUID__c!= null and SalesforceID__c=:MemberId and  Decision__c = 'Failed Desired Level'  order by createddate desc Limit 1 ];
				if(GUIDList.size() > 0)
				{
					result.put('GUIDofLastSession', null);
					system.debug('test');
					
				}
				else
				{
					result.put('GUIDofLastSession', GUIDList[0].GUID__c);
					system.debug('test1');
					
				}
		*/						
		system.debug('ttt'+visible)  ;
		result.put('Visible',visible); 
		result.put('Attempts',attempt);
		result.put('OOWStatusForDay',OOW);
		result.put('OTPStatusForDay',OTP);
		result.put('PublicWalletStatusForDay',PublicWallet) ;
		result.put('CFCUWalletStatusForDay',CFCUWallet);
		result.put('AccountNumber',AccountNumber);
		result.put('OTPAttemptCount', OTPAttemptCount);
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
		Double TotalScore=0;
		string LevelofAuthentication;
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
		if(OTPAttemptCount >= 2){
			IsOTPAvailable = false;
		}else{
			IsOTPAvailable = true;
		}
		
		
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
	if(visible == false && OTPAttemptCount < 2 )
	{
		IsOTPAvailable = false;
	}
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
	if(visible == true && OTPAttemptCount >= 2 )
	{
		IsOTPAvailable = false;
	}
	if(visible == true)
	{
		IsPublicWalletAvailable = true;
		IsOOWAvailable = true;
		IsCFCUWalletAvailable = true;
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
	/*if(DebitCardStatus == 'true' || DebitCardStatus == 'false'){
		IsCFCUWalletAvailable = false;
	}
	else
	{
		IsCFCUWalletAvailable = true;
	}*/
	
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
	for(Member_Authentication_Level_Model__c lm :LevelModel )
	{
		if(lm.Tiers__c == 'Level 1' && TotalScore >= lm.Range_Start__c && TotalScore <= lm.Range_End__c )
		{
			LevelofAuthentication = lm.Tiers__c;
			ScoreRequired = lm.Range_Start__c.intValue();
		}
		else if(lm.Tiers__c == 'Level 2' && TotalScore >= lm.Range_Start__c && TotalScore <= lm.Range_End__c)
		{
			LevelofAuthentication = lm.Tiers__c;
			ScoreRequired = lm.Range_Start__c.intValue();
		}
		else if(lm.Tiers__c == 'Level 3' && TotalScore >= lm.Range_Start__c)
		{
			LevelofAuthentication = 'Level 3';
			ScoreRequired = lm.Range_Start__c.intValue();
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
        if(ScoreRequired != null){
        	ScoreRequired = ScoreRequired - DebitPinScore;
        }
	if(LevelofAuthentication != 'Authentication Not Required'){
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
	
		system.debug('scoreobtained4##' + scoreobtained);
		
		for (string key : scoremap.keySet()){
			if(scoremap.get(key) == scoreobtained){
		    	system.debug('Authenticate##' +  key);
		    	ToGetHighestLevel = key;
		    }
		}
	}
		
		// ------------------Inserting log while user came from URL ----------------------------------//
		
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
	        insert log;
		}
		// ------------------Inserting log while user came from URL ----------------------------------//
		
		//------------------- Fetching Auth Logs for last 30 days achievable level--------------------//
		
		List<Authenticated_Log__c> LastAchieveLogs = new List<Authenticated_Log__c>();
		LastAchieveLogs = [select id,Last_Achievable_Level__c, GUID__c from Authenticated_Log__c where createdDate = Last_n_days:30 and SalesforceID__c =:MemberId and RecordType.name = 'IVR Authentication Log' and Last_Achievable_Level__c != null order by CreatedDate desc Limit 1];
		String level = ' ';
		if(LastAchieveLogs.size() > 0){
			result.put('LastAchievableLevel',LastAchieveLogs[0].Last_Achievable_Level__c);
		}
		
		//------------------- Fetching Auth Logs for last 30 days achievable level--------------------//
		
		//---------------------Getting Current Authentication level--------------------------//
			
			Decimal PointsObtained = 0;
			string CurrentAuthenticationLevel;
			system.debug('DebitCardStatus' + DebitCardStatus);
			if(DebitCardStatus == 'true')
			{
				for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
				{
					if(sm.Authentication_Type__c == 'Debit Pin')
					{
						PointsObtained = sm.Positive_Point_Value__c;
						
					}
					
				}
			}
			
			system.debug('PointsObtained##' + PointsObtained);
		
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
			system.debug('CurrentAuthenticationLevel##' + CurrentAuthenticationLevel);	
			result.put('CurrentAuthenticationLevel',CurrentAuthenticationLevel);
		//----------------------End Code----------------------------------------------------//
		
		result.put('IsKYMAvailable',IsKYMAvailable);
		result.put('IsOTPAvailable',IsOTPAvailable);
		result.put('IsDebitPinAvailable',IsDebitPinAvailable);
		result.put('IsOOWAvailable',IsOOWAvailable);
		result.put('IsPublicWalletAvailable',IsPublicWalletAvailable);
		result.put('IsCFCUWalletAvailable',IsCFCUWalletAvailable);
		
		result.put('MaximumPointsAvailable',TotalScore);
		result.put('HighestAchievableLevel',LevelofAuthentication);
		result.put('ToGetHighestLevel', ToGetHighestLevel);
		result.put('LevelModel', LevelModel);
		result.put('ScoringModel', ScoringModel);
		
		return result;
	}
	
	 @AuraEnabled
	public static Map<string,object> GetNextAuthenticationType(string MemberId, string MemberType, Integer MaximumPointsAvailable,Integer PointsObtained, boolean IsKYMAvailable, boolean IsOTPAvailable, boolean IsDebitPinAvailable, boolean IsOOWAvailable, boolean IsPublicWalletAvailable, boolean IsCFCUWalletAvailable)
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
	
	
/*	if(IsDebitPinAvailable == true){
		for(Member_Authentication_Scoring_Model__c sm: ScoringModel){
			if(sm.Authentication_Type__c == 'Debit Pin')
			{
				scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
				scoreset.add(sm.Positive_Point_Value__c.intValue());
			}
			
		}
	}*/
	
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
	//if(LevelofAuthentication != 'Authentication Not Required'){
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
		
		
		system.debug('scoreobtained4##' + scoreobtained);
		
		
	//}	
		
		
		result.put('LevelofAuthentication',LevelofAuthentication);
		result.put('NextLevel',ToGetHighestLevel);
		result.put('CurrentAuthenticationLevel',CurrentAuthenticationLevel);
		result.put('ScoreRequired',ScoreRequired );
		
		return result;
				
	}
	
	@AuraEnabled
	public static void SaveOTPCancelledAttempt(string MemberId, string GUID)
	{
			string  AccountNumber;
			List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
				FROM Person_Account__c where PersonID__c =:MemberId limit 1];
				if(p.size() > 0)
				{
					AccountNumber = p[0].Account_Number__r.Name;
				}
				List<Member_Verification_Attempt__c> mt = [Select id,Member_Name__c,Authentication_Type__c,OTP_Cancelled_Attempt__c, Member_Salesforce_Id__c, Number_of_Attempts__c
						 from Member_Verification_Attempt__c where Member_Salesforce_Id__c =:MemberId and CreatedDate = Today limit 1];
	    
	     RecordType rec =[select Id,Name,SobjectType from RecordType where name ='OTP Authentication Log' and SobjectType='Authenticated_Log__c'];
	     
	    if(mt.size() > 0){
	    	
	    	mt[0].OTP_Cancelled_Attempt__c = mt[0].OTP_Cancelled_Attempt__c + 1;
	    	update mt;
	    }
	    else{
             system.debug('Verification##');
	    	Member_Verification_Attempt__c mva = new Member_Verification_Attempt__c();
	    	mva.Member_Salesforce_Id__c = MemberId;
	    	if(p.size() > 0){
	    		mva.Member_Name__c = p[0].PersonID__r.Name;
	    	}
	    	mva.Authentication_Type__c = 'OTP';
	    	mva.OTP_Cancelled_Attempt__c = 1;
	    	insert mva;
	    	
	      	Authenticated_Log__c log = new Authenticated_Log__c();
	        log.RecordTypeId= rec.id;
	        log.SalesforceID__c = MemberId;
	        log.Decision__c = 'OTP - Cancelled';
	        log.Member__c = MemberId;
	        log.Staff_Name__c = UserInfo.getName();
	        log.Member_Number__c = AccountNumber;
	        log.GUID__c = GUID;
	     	 insert log;
            system.debug('OTP-Log##' + log.Id);
	    }
				
			
		
	}
	
	@AuraEnabled
	public static void SaveLastAchievableLevelLogs(string MemberId, string GUID, String LastLevel)
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
        log.Decision__c = LastLevel;
     	insert log;
				
	}
	
	@AuraEnabled
	public static void SaveCaseWithLogData(string MemberId, string AccountNumber, string casecomment, string AccountId, string GUID)
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
	public static List<AuthenticationLogWrapper> GetLogHistoryDetailData(string MemberId, string GUID)
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
					lw.DebitPin = log.PinMatch__c;
					lw.CreatedDate = log.CreatedDate.formatGMT('MM-dd-yyyy HH:mm:ss');
					lw.LogNumber = log.Name;
					lw.UserName = log.Staff_Name__c;
					lw.MemberNumber = log.Member_Number__c;
					lw.PhoneNumber= log.CallerPhoneNumber__c;
					lw.AuthenticationType= log.RecordType.Name;
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
				lw.AuthenticationType= log.RecordType.Name;
				lw.Decision= log.Decision__c;
				lw.CaseNumber= log.Case__r.CaseNumber;
				lw.CaseComment = log.Case__r.CaseComments__c;
				lw.OverrideRequestType= log.Override_Request_Type__c;
				lw.OverrideRequestedSupervisor = log.Override_Request_Supervisor__c;
				if(log.Failed_Desired_Level__c =='Yes'){
					lw.FDL = 'Yes';
				}
				else{
					lw.FDL = 'No';
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