public class MemberVerification
{
    public string accId {get;set;}
    public List<wrapperAccount> listWrapperAccount {get;set;}
    public List<wrapperAccount> listPhoneWrapperAccount {get;set;}
    public List<WrapperMem> listWrapperMem {get;set;}
    public string selectedID {get;set;} 
    public string RandomNumber {get;set;}
    public DateTime LastOTPSent {get;set;}
    public string EnteredOTP {get;set;}
    public string Verified {get;set;}
    public integer OTPExpiresAfterSeconds {get;set;}
    public integer OTPNextAttemptValidAfterHours {get;set;}
    public Account acc {get;set;}
    public string IsIneligibleLocal {get;set;}
    public string Brand {get;set;}
    public List<string> allRelatedAccounts {get;set;}
    public  list<String> accids {get;set;}
    public boolean ShowData {get;set;}
    public string NoContactInfo {get;set;}   
  
    public List<wrapperAccount> ListOfEmailsAndPhoneNumbers()
    {
        
            GetRelatedAccountsPopulated();              
            if(listWrapperAccount != null)
            {
                return listWrapperAccount;
            }
            
            if(listWrapperAccount == null || listWrapperAccount.size() == 0)
            {
                NoContactInfo = 'false';
                List<Account> listAccount; 
                List<accounthistory> listhistory;
                if(allRelatedAccounts != null && allRelatedAccounts.size() > 0)
                {
                    
                   listAccount = [select Id,Member_Verification_OTP_Invalid_Attempt__c,Home_Phone__pc,FirstName,LastName,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc from Account where ID in :allRelatedAccounts ];
                   listhistory = [Select accountid,field,OldValue, NewValue, CreatedDate From accounthistory where accountid in :allRelatedAccounts and createddate >: (date.TODAY() - 60)];
                   List<accounthistory> listhistoryOlder = [Select accountid,field,OldValue, NewValue, CreatedDate From accounthistory where accountid in :allRelatedAccounts and createddate <=: (date.TODAY() - 60)];
                   
                   listWrapperAccount = new List<wrapperAccount> ();
                   listPhoneWrapperAccount = new List<wrapperAccount>();
                   set<string> listContacts = new set<string>();
                   listWrapperMem = new List<wrapperMem> ();
                   
                       system.debug('-------------'+acc.id);
                           for(Account accountLocal : listAccount )
                           {
                           	system.debug('-accloc-'+accountLocal);
                           	   wrapperMem memLocal = new wrapperMem();
                           	   listContacts = new set<string>();
                           	   memLocal.MemberName =  accountLocal.FirstName + accountLocal.LastName;
                           	   memLocal.LstEmail = new List<wrapperAccount>();
                           	   memLocal.LstPhone = new List<wrapperAccount>(); 
                           	    if(accountLocal.Home_Phone__pc != null && accountLocal.Home_Phone__pc != '' && accountLocal.id == acc.id)
                                {        wrapperAccount accLocal = new wrapperAccount();
                                          
                                         accLocal.fieldType = 'P';
                                         accLocal.value = accountLocal.Home_Phone__pc ;
                                         accLocal.encryptedvalue = encryptPhone(accountLocal.Home_Phone__pc);
                                         accLocal.fieldName = 'Home_Phone__pc - ' + accountLocal.Id;   
                                         accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.Home_Phone__pc,'Home_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                         /* for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                                                    
                                            if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Home_Phone__pc') )
                                            {
                                                accLocal.isEnabled = false;
                                            }
                                         } */  
                                       listContacts.add(accountLocal.Home_Phone__pc);           
                                       memLocal.LstPhone.add(accLocal); 
                                        listWrapperAccount.Add(accLocal);                                                           
                                      
                                     
                                }
                                 if(accountLocal.Work_Phone__pc != null && accountLocal.Work_Phone__pc != '' && accountLocal.id == acc.id && !listContacts.contains(accountLocal.Work_Phone__pc))
                                {
                                         wrapperAccount accLocal = new wrapperAccount();
                                         accLocal.fieldType = 'P';
                                         accLocal.value = accountLocal.Work_Phone__pc;
                                         accLocal.encryptedvalue = encryptPhone(accountLocal.Work_Phone__pc);
                                         accLocal.fieldName = 'Work_Phone__pc - ' + accountLocal.Id;
                                         accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.Work_Phone__pc,'Work_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                        /*  for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                                                    
                                            if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Work_Phone__pc') )
                                            {
                                                accLocal.isEnabled = false;
                                            }
                                         }  */ 
                                         listContacts.add(accountLocal.Home_Phone__pc);
                                        memLocal.LstPhone.add(accLocal);
                                         listWrapperAccount.Add(accLocal);
                                       
                                 }
                                 if(accountLocal.Mobile_Phone__pc != null && accountLocal.Mobile_Phone__pc != ''  && accountLocal.id == acc.id && !listContacts.contains(accountLocal.Mobile_Phone__pc))
                                {
                                         wrapperAccount accLocal = new wrapperAccount();
                                        
                                         accLocal.fieldType = 'P';
                                         accLocal.value = accountLocal.Mobile_Phone__pc;
                                         accLocal.encryptedvalue = encryptPhone(accountLocal.Mobile_Phone__pc);
                                         accLocal.fieldName = 'Mobile_Phone__pc - ' + accountLocal.Id; 
                                         accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.Mobile_Phone__pc,'Mobile_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                        /* for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                                                    
                                            if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Mobile_Phone__pc') )
                                            {
                                                accLocal.isEnabled = false;
                                            }
                                         }  */   
                                         listContacts.add(accountLocal.Home_Phone__pc);
                                         memLocal.LstPhone.add(accLocal);  
                                          listWrapperAccount.Add(accLocal);                               
                                        
                                    
                                }
                                  if(accountLocal.PersonEmail != null && accountLocal.PersonEmail != '' && accountLocal.id == acc.id )
                                  {
                                         wrapperAccount accLocal = new wrapperAccount();
                                         accLocal.fieldType = 'E';
                                         accLocal.value = accountLocal.PersonEmail;
                                         accLocal.encryptedvalue = encryptEmail(accountLocal.PersonEmail);
                                         accLocal.fieldName = 'PersonEmail - ' + accountLocal.Id;
                                         accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.PersonEmail,'PersonEmail',accountLocal.id,listhistory,listhistoryOlder,false);
                                        /*for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                                                    
                                            if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'PersonEmail') )
                                            {
                                                accLocal.isEnabled = false;
                                            }
                                         }  */
                                        listContacts.add(accountLocal.Home_Phone__pc);
	                                     memLocal.LstEmail.add(accLocal); 
	                                      listWrapperAccount.Add(accLocal);
	                                }
                                 if(accountLocal.Alternate_Email__pc != null && accountLocal.Alternate_Email__pc != ''  && accountLocal.id == acc.id && !listContacts.contains(accountLocal.PersonEmail))
	                                
                            		{
                               
	                                     wrapperAccount accLocal = new wrapperAccount();
	                                     accLocal.fieldType = 'E';
	                                     accLocal.value = accountLocal.Alternate_Email__pc;
	                                     accLocal.encryptedvalue = encryptEmail(accountLocal.Alternate_Email__pc);
	                                     accLocal.fieldName = 'Alternate_Email__pc - ' + accountLocal.Id;
	                                     accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.Alternate_Email__pc,'Alternate_Email__pc',accountLocal.id,listhistory,listhistoryOlder,false);
	                                    /* for(accounthistory accounthistoryLocal : listhistory)
	                                     { 
	                                                                
	                                        if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Alternate_Email__pc') )
	                                        {
	                                            accLocal.isEnabled = false;
	                                        }
	                                     } */ 
	                                      memLocal.LstEmail.add(accLocal);
	                                      listWrapperAccount.Add(accLocal);
	                                    
                                }
                               if(accountLocal.Home_Phone__pc != null && accountLocal.Home_Phone__pc != '' && accountLocal.id != acc.id)
                                {        wrapperAccount accLocal = new wrapperAccount();
                                          
                                         accLocal.fieldType = 'P';
                                         accLocal.value = accountLocal.Home_Phone__pc ;
                                         accLocal.encryptedvalue = encryptPhone(accountLocal.Home_Phone__pc);
                                         accLocal.fieldName = 'Home_Phone__pc - ' + accountLocal.Id;   
                                         accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.Home_Phone__pc,'Home_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                         /* for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                                                    
                                            if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Home_Phone__pc') )
                                            {
                                                accLocal.isEnabled = false;
                                            }
                                         } */  
                                       listContacts.add(accountLocal.Home_Phone__pc);           
                                       memLocal.LstPhone.add(accLocal); 
                                        listWrapperAccount.Add(accLocal);                                                           
                                      
                                     
                                }
                                 if(accountLocal.Work_Phone__pc != null && accountLocal.Work_Phone__pc != '' && accountLocal.id != acc.id && !listContacts.contains(accountLocal.Work_Phone__pc))
                                {
                                         wrapperAccount accLocal = new wrapperAccount();
                                         accLocal.fieldType = 'P';
                                         accLocal.value = accountLocal.Work_Phone__pc;
                                         accLocal.encryptedvalue = encryptPhone(accountLocal.Work_Phone__pc);
                                         accLocal.fieldName = 'Work_Phone__pc - ' + accountLocal.Id;
                                         accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.Work_Phone__pc,'Work_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                        /*  for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                                                    
                                            if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Work_Phone__pc') )
                                            {
                                                accLocal.isEnabled = false;
                                            }
                                         }  */ 
                                         listContacts.add(accountLocal.Home_Phone__pc);
                                        memLocal.LstPhone.add(accLocal);
                                         listWrapperAccount.Add(accLocal);
                                       
                                 }
                                 if(accountLocal.Mobile_Phone__pc != null && accountLocal.Mobile_Phone__pc != ''  && accountLocal.id != acc.id && !listContacts.contains(accountLocal.Mobile_Phone__pc))
                                {
                                         wrapperAccount accLocal = new wrapperAccount();
                                        
                                         accLocal.fieldType = 'P';
                                         accLocal.value = accountLocal.Mobile_Phone__pc;
                                         accLocal.encryptedvalue = encryptPhone(accountLocal.Mobile_Phone__pc);
                                         accLocal.fieldName = 'Mobile_Phone__pc - ' + accountLocal.Id; 
                                         accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.Mobile_Phone__pc,'Mobile_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                        /* for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                                                    
                                            if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Mobile_Phone__pc') )
                                            {
                                                accLocal.isEnabled = false;
                                            }
                                         }  */   
                                         listContacts.add(accountLocal.Home_Phone__pc);
                                         memLocal.LstPhone.add(accLocal);  
                                          listWrapperAccount.Add(accLocal);                               
                                        
                                    
                                }
                                  if(accountLocal.PersonEmail != null && accountLocal.PersonEmail != '' && accountLocal.id != acc.id )
                                  {
                                         wrapperAccount accLocal = new wrapperAccount();
                                         accLocal.fieldType = 'E';
                                         accLocal.value = accountLocal.PersonEmail;
                                         accLocal.encryptedvalue = encryptEmail(accountLocal.PersonEmail);
                                         accLocal.fieldName = 'PersonEmail - ' + accountLocal.Id;
                                         accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.PersonEmail,'PersonEmail',accountLocal.id,listhistory,listhistoryOlder,false);
                                        /*for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                                                    
                                            if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'PersonEmail') )
                                            {
                                                accLocal.isEnabled = false;
                                            }
                                         }  */
                                        listContacts.add(accountLocal.Home_Phone__pc);
	                                     memLocal.LstEmail.add(accLocal); 
	                                      listWrapperAccount.Add(accLocal);
	                                }
                                 if(accountLocal.Alternate_Email__pc != null && accountLocal.Alternate_Email__pc != ''  && accountLocal.id != acc.id && !listContacts.contains(accountLocal.PersonEmail))
	                                
                            		{
                               
	                                     wrapperAccount accLocal = new wrapperAccount();
	                                     accLocal.fieldType = 'E';
	                                     accLocal.value = accountLocal.Alternate_Email__pc;
	                                     accLocal.encryptedvalue = encryptEmail(accountLocal.Alternate_Email__pc);
	                                     accLocal.fieldName = 'Alternate_Email__pc - ' + accountLocal.Id;
	                                     accLocal.isEnabled = MemberVerificationLightningController.isContactEnabled(accountLocal.Alternate_Email__pc,'Alternate_Email__pc',accountLocal.id,listhistory,listhistoryOlder,false);
	                                    /* for(accounthistory accounthistoryLocal : listhistory)
	                                     { 
	                                                                
	                                        if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Alternate_Email__pc') )
	                                        {
	                                            accLocal.isEnabled = false;
	                                        }
	                                     } */ 
	                                      memLocal.LstEmail.add(accLocal);
	                                      listWrapperAccount.Add(accLocal);
	                                    
                                }
                               if( memLocal.LstEmail.size() > 0  ||memLocal.LstPhone.size() > 0){
	                                                      
	                               listWrapperMem.add(memLocal);
                               }
                             
                               system.debug('-----local mem---'+memLocal);
                               
                           }
                          system.debug('-----------list mem------'+listWrapperMem);
                }
            }           
            
            return listWrapperAccount;
      
    }   
    
    public void SaveNoContactInfoLog()
    {
            Authenticated_Log__c log = new Authenticated_Log__c();
            system.debug('SalesForceID =' + acc.Id);
            log.SalesforceID__c = acc.Id;
            
            log.First_Name__c = acc.FirstName;
            log.Last_Name__c = acc.LastName;
            log.Staff_Name__c = UserInfo.getName();
            System.debug('log No Contact Info ' + log);
            
            upsert log;
            log.Decision__c = 'OTP - No Contact Info';
            update log;
            
            
    }
        
        
   public void GetRelatedAccountsPopulated()
   {
        if(accids == null || accids.Size() == 0)
            allRelatedAccounts = new list<string>();
            allRelatedAccounts.add(accID);
            
            
            OTPSettings__c data1 = OTPSettings__c.getValues('Member Verification');            
            OTPExpiresAfterSeconds = integer.valueOf(data1.OTPExpirationSeconds__c);            
            
            OTPNextAttemptValidAfterHours = integer.valueOf(data1.OTPNextAttemptValidAfterHours__c);            
            
            List<Account> listAccount;
            
            if(acc == null)
            {
              listAccount = [select Id,Member_Verification_OTP_Invalid_Attempt__c,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc from Account where ID =:accID ];            
              

              if(listAccount.size() > 0)
              {
                acc = listAccount[0];
              }
            }
            

             list<Person_Account__c> paList = new list<Person_Account__c>();
                paList = [SELECT Id,
                                 Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:acc.Id];
            set<String> accountNumberSet = new set<String>();
            set<Id> accIdset = new set<Id>();
            set<String> acctypeSet = new set<String>();
            for(Person_Account__c var: paList){
                accountNumberSet.add(var.Account_Number__r.Name);
                acctypeSet.add(var.Account_Number__r.RecType__c);
                accIdSet.add(var.Account_Number__c);
            }
                        
            list<Account_Details__c> accList = new list<Account_Details__c>();
            if(acctypeSet.contains('ACCT')){
                accList = [SELECT Id,
                                  Name FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD'];
            }
            else{
                accList = [SELECT Id,
                                  Name
                                   FROM Account_Details__c Where Id IN:accIdSet and RecType__c != 'CARD'];
            }
            
            
             set<String> accName = new Set<String>();
            
            for(Account_Details__c var: accList){
                accName.add(var.Name);
            }
           
            list<Person_Account__c> ContactList = new list<Person_Account__c>();
            ContactList = [Select 
                                  Account_Number__c,personId__c
                                   From Person_Account__c WHERE Account_Number__r.Name IN :accName and (NOT TypeTranslate__c like '%Beneficiary%')];
                  accids = new list<string>();
            
            for(Person_Account__c var: ContactList){
                accids.add(var.Account_Number__c);
                allRelatedAccounts.add(var.personId__c);
                
            }
        
   }     
        
        
    public void IsIneligible()
        
    
        {
            
            //GetRelatedAccountsPopulated();
            ListOfEmailsAndPhoneNumbers();
             system.debug('--------listWrapperAccount.size()---------'+listWrapperAccount.size());
            if(listWrapperMem.size() == 0)
            {
                    SaveNoContactInfoLog();
                    NoContactInfo = 'true';
                    Verified = 'NoContactInfo';
                    system.debug('----noco-------------'+NoContactInfo);
                   
                    return;
            }
                                     
            list<Account_Details__c>  listAccountDetails = [select Id,Comments_Block__c,
            Brand__c,
             Comment_Block_01__c,
                              Comment_Block_02__c,
                              Comment_Block_03__c,
                              Comment_Block_04__c,
                              Comment_Block_05__c,
                              Comment_Block_06__c,
                              Comment_Block_07__c,
                              Comment_Block_08__c,
                              Comment_Block_09__c,
                              Comment_Block_10__c,
                              Comment_Block_11__c,
                              Comment_Block_12__c,
                              Comment_Block_13__c,
                              Comment_Block_14__c,
                              Comment_Block_15__c,
                              Comment_Block_16__c,
                              Comment_Block_17__c,
                              Comment_Block_18__c,
                              Comment_Block_19__c,
                              Comment_Block_20__c
            
            
             from Account_Details__c where Id in: accids];
           system.debug('------------acc details '+listAccountDetails);
           
        list<string> wcwList = new list<string>();
        if(listAccountDetails.Size() > 0)
        {
            Brand = listAccountDetails[0].Brand__c;
            
            
                /*  for(Account_Details__c var: listAccountDetails){
                
                if(var.Comment_Block_01__c != NULL || var.Comment_Block_01__c != ''){
                    
                     wcwList.add(var.Comment_Block_01__c);
                }
                if(var.Comment_Block_02__c != NULL || var.Comment_Block_02__c != ''){
                    
                      wcwList.add(var.Comment_Block_02__c);
                }
                if(var.Comment_Block_03__c != NULL || var.Comment_Block_03__c != ''){
                    
                      wcwList.add(var.Comment_Block_03__c);
                }            
                if(var.Comment_Block_04__c != NULL || var.Comment_Block_04__c != ''){
                    
                      wcwList.add(var.Comment_Block_04__c);
                }
                if(var.Comment_Block_05__c != NULL || var.Comment_Block_05__c != ''){
                   
                      wcwList.add(var.Comment_Block_05__c);
                }
                if(var.Comment_Block_06__c != NULL || var.Comment_Block_06__c != ''){
                   
                      wcwList.add(var.Comment_Block_06__c);
                }
                if(var.Comment_Block_07__c != NULL || var.Comment_Block_07__c != ''){
                   
                      wcwList.add(var.Comment_Block_07__c);
                }
                if(var.Comment_Block_08__c != NULL || var.Comment_Block_08__c != ''){
                   
                      wcwList.add(var.Comment_Block_08__c);
                }
                if(var.Comment_Block_09__c != NULL || var.Comment_Block_09__c != ''){
                   
                      wcwList.add(var.Comment_Block_09__c);
                }
                if(var.Comment_Block_10__c != NULL || var.Comment_Block_10__c != ''){
                   
                      wcwList.add(var.Comment_Block_10__c);
                }
                if(var.Comment_Block_11__c != NULL || var.Comment_Block_11__c != ''){
                   
                      wcwList.add(var.Comment_Block_11__c);
                }
                if(var.Comment_Block_12__c != NULL || var.Comment_Block_12__c != ''){
                   
                      wcwList.add(var.Comment_Block_12__c);
                }
                if(var.Comment_Block_13__c != NULL || var.Comment_Block_13__c != ''){
                   
                      wcwList.add(var.Comment_Block_13__c);
                }
                if(var.Comment_Block_14__c != NULL || var.Comment_Block_14__c != ''){
                   
                      wcwList.add(var.Comment_Block_14__c);
                }
                if(var.Comment_Block_15__c != NULL || var.Comment_Block_15__c != ''){
                   
                      wcwList.add(var.Comment_Block_15__c); 
                }
                if(var.Comment_Block_16__c != NULL || var.Comment_Block_16__c != ''){
                   
                      wcwList.add(var.Comment_Block_16__c); 
                }
                if(var.Comment_Block_17__c != NULL || var.Comment_Block_17__c != ''){
                   
                      wcwList.add(var.Comment_Block_17__c); 
                }
                if(var.Comment_Block_18__c != NULL || var.Comment_Block_18__c != ''){
                   
                      wcwList.add(var.Comment_Block_18__c);
                }
                if(var.Comment_Block_19__c != NULL || var.Comment_Block_19__c != ''){
                   
                      wcwList.add(var.Comment_Block_19__c);
                }
                if(var.Comment_Block_20__c != NULL || var.Comment_Block_20__c != ''){
                    
                      wcwList.add(var.Comment_Block_20__c);
                }           */
            }
            
           /* if(wcwList.size()>0)
            {
                for(string str : wcwList)
                {
                    if(false)
                    {
                        
                        Authenticated_Log__c log = new Authenticated_Log__c();
                        log.SalesforceID__c = acc.Id;
                        log.First_Name__c = acc.FirstName;
                        log.Last_Name__c = acc.LastName;
                        log.Staff_Name__c = UserInfo.getName();
                        log.Decision__c = 'OTP – Not Eligible';
                        insert log;
                        acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
                        update acc;
                        System.Debug('not eligible---' + acc.id);
                        Verified='Changed';
                        IsIneligibleLocal = 'true';
                        return;
                    }
                }
            }
               IsIneligibleLocal = 'false';
        }
      
            else
            {
                 IsIneligibleLocal = 'false';
            }*/
            
              IsIneligibleLocal = 'false';
            
               system.debug('--------IsIneligibleLocal '+IsIneligibleLocal);
                      
        }
    
        
        
    public string encryptEmail(string value)
    {       
        
        List<String> listStr = value.split('@');

        string finalNumber = listStr[0].substring(0,1) + '*****'  + + listStr[0].substring(listStr[0].length()-1,listStr[0].length()) + '@' + listStr[1];
         //= listStr[0].substring
        return finalNumber;
    }
    
    public string encryptPhone(string value)
    {
        value = 'xxx-xxx-' + value.right(4);
        
        return value;
    }
    public string EmailPhoneNumber {get;set;}
    public boolean IsEmail {get;set;}
    
    public void ResendOTP()
    {
        GenerateRandomOTP();
        
    }
    
    public void GenerateRandomOTP()
    {
        
        string fieldName =   Apexpages.currentPage().getParameters().get('fieldName');
        string resend =   Apexpages.currentPage().getParameters().get('resend');
        
        system.debug('-------fname------'+fieldName);
        system.debug('----------re---'+resend);
        //RandomNumber =  string.valueOf( Integer.valueof( Math.random() * 100000000));
        //RandomNumber = RandomNumber.left(6);

        RandomNumber =String.valueOf(Math.random());
        RandomNumber= RandomNumber.substring(2,8);
        
        for(wrapperMem a : listWrapperMem){
			for(wrapperAccount wacc : a.lstEmail){
				 if(wacc.fieldName == fieldName)
			    	{
			        SendOTPEmail(RandomNumber, wacc.value);
                    system.debug('OTP - Email Sent ---'  +wacc.value);
                    system.debug('OTP - OTP Sent ---'  + RandomNumber);
                    EmailPhoneNumber = wacc.value;
                    IsEmail = true;
			            break;
			        }
				}
			
				for(wrapperAccount wacc : a.lstPhone){
			    	 if(wacc.fieldName == fieldName){
			      		IsEmail = false;
	                    SendSMS(wacc.value, string.valueof( RandomNumber), 'SMS - User');
	                    system.debug('OTP - SMS Sent ---'  + wacc.value);
	                    system.debug('OTP - OTP Sent ---'  + RandomNumber);
	                    EmailPhoneNumber = wacc.value;
			            break;
			        }
				}
        }
           
               
      /*  for(wrapperAccount a : listWrapperAccount){
            
            if(a.fieldName == fieldName)
            {
                
                if(a.fieldType == 'E')
                {
                    
                    SendOTPEmail(RandomNumber, a.value);
                    system.debug('OTP - Email Sent ---'  + a.value);
                    system.debug('OTP - OTP Sent ---'  + RandomNumber);
                    EmailPhoneNumber = a.value;
                    IsEmail = true;
                }
                else
                {
                    IsEmail = false;
                    SendSMS(a.value, string.valueof( RandomNumber), 'SMS - User');
                    system.debug('OTP - SMS Sent ---'  + a.value);
                    system.debug('OTP - OTP Sent ---'  + RandomNumber);
                    EmailPhoneNumber = a.value;
                }
                
            }
        }*/
        
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.SalesforceID__c = acc.Id;
        log.First_Name__c = acc.FirstName;
        log.Last_Name__c = acc.LastName;
        log.Staff_Name__c = UserInfo.getName();
        if(IsEmail != null && IsEmail && EmailPhoneNumber != null && EmailPhoneNumber != '')
        {
          log.OTP_Email__c = EmailPhoneNumber;
        }
        else if(IsEmail != null && EmailPhoneNumber != null && EmailPhoneNumber != '')
        {
            log.OTP_Phone__c = EmailPhoneNumber;
        }
        if(resend == 'true')
        {            
            log.Decision__c = 'OTP – Code Resent';           
          
        }
        else
        {
            log.Decision__c = 'OTP – Code Sent';
        }
      insert log;
        
        
    }
    
    public void cancelOTP()
    {
            Authenticated_Log__c log = new Authenticated_Log__c();
            log.SalesforceID__c = acc.Id;
            log.First_Name__c = acc.FirstName;
            log.Last_Name__c = acc.LastName;
            log.Staff_Name__c = UserInfo.getName();
            log.Decision__c = 'OTP – Code not provided';
            if(IsEmail != null && IsEmail && EmailPhoneNumber != null && EmailPhoneNumber != '')
            {
              log.OTP_Email__c = EmailPhoneNumber;
            }
            else if(IsEmail != null && EmailPhoneNumber != null && EmailPhoneNumber != '')
            {
                log.OTP_Phone__c = EmailPhoneNumber;
            }
            insert log;
            acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
            update acc;
            Verified = 'Cancelled';
    }
    
    public void SendSMS(string phone, string message,string Name)
    {
               List <smagicinteract__smsmagic__c> smsObjectList = new List <smagicinteract__smsmagic__c>();
            String senderId = 'CreditUnion';
            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
            smsObject.smagicinteract__SenderId__c = 'CreditUnion';
            string emailadd;
            if(Brand == 'Spectrum')
            {
                emailadd = 'SpectrumSMS';
            }
            else
            {
                emailadd = 'ChevronSMS';
            }
        list<smagicinteract__SMS_Template__c> listTemplate =  [select Id,smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__Name__c =: emailadd];
           
            smsObject.smagicinteract__PhoneNumber__c = phone;
             smsObject.smagicinteract__Name__c = Name; // records name
            smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
            smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            if(listTemplate.size() > 0 ) {
                 smsObject.smagicinteract__SMSText__c = listTemplate[0].smagicinteract__Text__c.replace('$MemberName', acc.FirstName + '  '  + acc.LastName).replace('$OTP_CODE',message);
            }
            smsObjectList.add(smsObject); 
            Database.insert(smsObjectList,false);
            LastOTPSent = System.Now();
            
    }
    
    
    
    private void SendOTPEmail(string OTP, string ToEmail)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(ToEmail);
        mail.setToAddresses(sendTo);
        string templatenAME = Brand + ' OTP Email';
        List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject from EmailTemplate where Name =: templatenAME];
        
        mail.setSubject(listEmailTemplate[0].Subject);
        
        
        string emailadd;
        if(Brand == 'Spectrum')
        {
            emailadd = 'noreply@spectrumcu.org';
        }
        else
        {
            emailadd = 'noreply@chevronfcu.org';
        }
        
        List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
        
        string body = listEmailTemplate[0].body.replace('$MemberName', acc.FirstName + '  '  + acc.LastName).replace('$OTP_CODE',OTP);
        mail.setPlainTextBody(body);
        if(listAdd.size() > 0){
         mail.setOrgWideEmailAddressId(listAdd[0].Id);
        }
        mails.add(mail);
        
        Messaging.sendEmail(mails);
        LastOTPSent = System.Now();
    }
   
    
    public void verifyOTP()
    {
        Long startTime = LastOTPSent.getTime();
        Long endTime = System.Now().getTime();
        Long milliseconds = endTime - startTime;
        Long seconds = milliseconds / 1000;
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.SalesforceID__c = acc.Id;
        log.First_Name__c = acc.FirstName;
        log.Last_Name__c = acc.LastName;
        if(IsEmail)
        {
          log.OTP_Email__c = EmailPhoneNumber;
        }
        else
        {
            log.OTP_Phone__c = EmailPhoneNumber;
        }
        log.Staff_Name__c = UserInfo.getName();
        system.debug('seconds ---' + seconds);
        system.debug('OTPExpiresAfterSeconds ---' + OTPExpiresAfterSeconds);
        if(seconds >= OTPExpiresAfterSeconds)
        {
            Verified = 'Expired';
            acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
            update acc;
            log.Decision__c = 'OTP – Code Expired';
        
        }
        else if(EnteredOTP == RandomNumber)
        {
            //acc.Member_Verification_OTP_Invalid_Attempt__c = null;
            //update acc;
            log.Decision__c = 'OTP – Code valid';
            Verified = 'Valid';
        }
        else
        {
            acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
            update acc;
            log.Decision__c = 'OTP – Code Failed';
            Verified = 'Invalid';
        }
        
        insert log;
    }
    
    public void DeclineOTP()
    {
        system.debug('DeclineOTP---' + acc);
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.SalesforceID__c = acc.Id;
        
        log.First_Name__c = acc.FirstName;
        log.Last_Name__c = acc.LastName;
        if(IsEmail != null && IsEmail && EmailPhoneNumber != null && EmailPhoneNumber != '')
        {
          log.OTP_Email__c = EmailPhoneNumber;
        }
        else if(IsEmail != null && EmailPhoneNumber != null && EmailPhoneNumber != '')
        {
            log.OTP_Phone__c = EmailPhoneNumber;
        }
        log.Staff_Name__c = UserInfo.getName();
        log.Decision__c = 'OTP – Contact Unconfirmed';
        insert log;
        acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
        update acc;
        Verified = 'Declined';
    }
    
    
    
    
    
    public List<SelectOption> PhoneList_Options
    {
        
        get {
            List<SelectOption> options = new List<SelectOption>();
            ListOfEmailsAndPhoneNumbers();    
            if(listWrapperAccount != null && listWrapperAccount.size() > 0)
            {
                 
                    for(wrapperAccount a : listWrapperAccount){
                            if(a.fieldType == 'P')
                            {                               
                            options.add(new SelectOption(a.fieldName,a.encryptedvalue, !a.isEnabled));
                            }
                        }
                        system.debug('Phoneoptions-----' + options);
            }
                return options;
        }
    }
    
    public List<SelectOption> EmailsList_Options
    {
        get {
            ListOfEmailsAndPhoneNumbers();
            List<SelectOption> options = new List<SelectOption>();    
            if(listWrapperAccount != null && listWrapperAccount.size() > 0)
            {
                
                    for(wrapperAccount a : listWrapperAccount){
                            if(a.fieldType == 'E')
                            {                               
                            options.add(new SelectOption(a.fieldName,a.encryptedvalue, !a.isEnabled));
                            }
                        }
                        system.debug('Emailoptions-----' + options);
               
            }
             return options;
        }
    }
    
    public List<WrapperMem> WrapperMemOptions
    {
        get {
            ListOfEmailsAndPhoneNumbers();            
             return listWrappermem;
        }
    }
    public class WrapperMem{
    	public string MemberName{get;set;}
    	public List<wrapperAccount> LstEmail{get;set;}
    	public List<wrapperAccount> LstPhone{get;set;}
    	
    }
    public class wrapperAccount
    {
        public string fieldName {get; set;}
        public string fieldType {get; set;}
        public string value {get; set;}
        public string encryptedvalue {get; set;}
        public boolean isEnabled {get; set;}
    } 
    
    public class warningCodeWrapper{
        public string comms {get;set;}

        public warningCodeWrapper(string var){
            comms = var;
        }
    }
    

    
}