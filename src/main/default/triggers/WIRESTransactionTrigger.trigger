trigger WIRESTransactionTrigger on WIRES_Transaction__c (before insert,before update, after insert,after update) {
    
    System.debug('In the trigger');
    
    //------------------------------------------------------------------Before Update  ------------------------------------------------------------------------------//
    
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Integer i=0; i<trigger.new.size(); i++){
            
            if((trigger.old[i].Current_Reviewer__c != trigger.new[i].Current_Reviewer__c) || 
               (trigger.old[i].Current_Second_Reviewer__c != trigger.new[i].Current_Second_Reviewer__c)
              ){  
                  trigger.new[i].Current_Reviewer_Modified_Date__c=DateTime.now();
              }
            
            if(trigger.old[i].Has_Additional_Documents__c==false && trigger.new[i].Has_Additional_Documents__c== true) {
                List<string> emails=new List<string>();
                System.debug('In update flag trigger');
                set<Id> userIds=new set<Id>();
                userIds.add(trigger.new[i].Current_Reviewer__c);
                userIds.add(trigger.new[i].First_Reviewer__c);
                
                List<User> users =[Select Id,Email From User Where Id=:userIds];
                for(User u: users){
                    emails.add(u.Email);
                }
                WiresEmailController.SendAdditionalDocumentsNotification(trigger.new[i].Id,emails,trigger.new[i].Name,trigger.new[i].TotalFromAccount__c,trigger.new[i].Source__c);
            }
            
        }
    }
    
    //------------------------------------------------------------------After Update  ------------------------------------------------------------------------------//
    
    if(Trigger.isAfter && Trigger.isUpdate){
        set<Id> docSignCompletedAtOnlineIds=new set<Id>();
        set<Id> docSignDeclinedAtOnlineIds=new set<Id>();
        
        set<Id> sentToWireXchangeIds=new set<Id>();
        set<Id> rejectedWiresIds=new set<Id>();
        
        for(Integer i=0; i<trigger.new.size(); i++){
            //------------------------------- Checking if the status is being changed and status = 'Completed'-----------------//
            if(trigger.old[i].Status__c != 'Completed' && trigger.new[i].Status__c == 'Completed'){  
                if(trigger.new[i].Source__c==WiresConstant.Source_OnlineBanking){
                    docSignCompletedAtOnlineIds.add(trigger.new[i].id);
                }
            }
            
            //------------------------------- Checking if the status is being changed and status = 'Voided'-----------------//
            if(trigger.old[i].Status__c != 'Declined' && trigger.new[i].Status__c == 'Declined'){  
                if(trigger.new[i].Source__c==WiresConstant.Source_OnlineBanking){
                    docSignDeclinedAtOnlineIds.add(trigger.new[i].id);
                }
            }
            
            //----------- Checking if the approval status is being changed and status = 'Released In WireXchange'--------------//
            if(trigger.old[i].Approval_Status__c != 'Released In WireXchange' && trigger.new[i].Approval_Status__c == 'Released In WireXchange'){
                if(trigger.new[i].Source__c!=WiresConstant.Source_Branch){
                    sentToWireXchangeIds.add(trigger.new[i].id);
                }
            }
            
            //----------- Checking if the approval status is being changed and status = 'Rejected'--------------//
            if(trigger.old[i].Approval_Status__c != 'Rejected' && trigger.new[i].Approval_Status__c == 'Rejected'){
                if(trigger.new[i].Source__c==WiresConstant.Source_Branch){
                    rejectedWiresIds.add(trigger.new[i].id);
                }
            }
            
        }
        
        if(docSignCompletedAtOnlineIds.size()>0){
            WiresTransactionApprovalController.SendProgressNotification(docSignCompletedAtOnlineIds);
            WiresSMSNotificationController.SendProgressSMSNotification(docSignCompletedAtOnlineIds);
            WiresTransactionApprovalController.SetIdentityVerificationUsed(docSignCompletedAtOnlineIds);
            WiresTransactionApprovalController.CheckRedFlgsAndUpdateStatus(docSignCompletedAtOnlineIds);
        }
        
        if(docSignDeclinedAtOnlineIds.size()>0){
            WiresTransactionApprovalController.SetWiresStatusToDSDeclined(docSignDeclinedAtOnlineIds);
        }
        
        
        if(sentToWireXchangeIds.size()>0){
            WiresTransactionApprovalController.ReleasedToWireXchangeEmailNotification(sentToWireXchangeIds);
            WiresSMSNotificationController.ReleasedToWireXchangeSMSNotification(sentToWireXchangeIds);
        }
        
        if(rejectedWiresIds.size()>0){
            WiresEmailController.SendBranchWireCancelledOrRejectEmailNotification(rejectedWiresIds,false);
        }
    }
    //------------------------------------------------------------------After Insert  ------------------------------------------------------------------------------//
    
    List<WIRES_Transaction__c> WTIds = new List<WIRES_Transaction__c>();
    
    if(Trigger.isInsert){
        
        if(Trigger.isAfter){
            
            for(Integer i=0; i<trigger.new.size(); i++){        	
                if(trigger.new[i].ParentTransaction__c == null)	
                    WTIds.add(trigger.new[i]);
            } 
            
            if(WTIds.size() > 0){
                Set<Id> range1To5000 = new Set<Id>();
                Set<Id> range50001To10000 = new Set<Id>();
                Set<Id> rangeGrtThen10000 = new Set<Id>();
                
                Set<Id> rangeForInPersonSigning = new Set<Id>();                
                
                for(Integer i=0; i<WTIds.size(); i++){ 
                    
                    if(WTIds[i].Source__c!=WiresConstant.Source_Branch){
                        
                        if(WTIds[i].WireAmount__c<=5000){
                            if(WTIds[i].Frequency__c==WiresConstant.OneTime){
                            	range1To5000.add(WTIds[i].Id);
                            }
                        }
                        
                        if(WTIds[i].WireAmount__c>5000 && WTIds[i].WireAmount__c<=10000){
                            if(WTIds[i].Frequency__c==WiresConstant.OneTime){
                            	range50001To10000.add(WTIds[i].Id);
                            }
                        }
                        
                        if(WTIds[i].WireAmount__c>10000){
                            if(WTIds[i].Frequency__c==WiresConstant.OneTime){
                            	rangeGrtThen10000.add(WTIds[i].Id);
                            }
                        }
                    }
                    
                    if(WTIds[i].Source__c==WiresConstant.Source_Branch){
                        if(WTIds[i].Frequency__c==WiresConstant.OneTime){
                        	rangeForInPersonSigning.add(WTIds[i].Id);
                        }
                    }
                }        
                
                // we also need docuSign for wires amount less than 5k
                // STRY0011574: Online - DocuSign should be sent to customer for all online wires.
                if(range1To5000.size()>0){
                    WiresTransToDocuSign.docusignAPIcall(range1To5000);
                }
                
                if(range50001To10000.size()>0){
                    WiresTransToDocuSign.docusignAPIcall(range50001To10000);
                }
                
                if(rangeGrtThen10000.size()>0){
                    WiresTransToDocuSign.docusignAPIcall(rangeGrtThen10000);
                }
                
                if(range1To5000.size()>0){
                    //WiresTransactionApprovalController.SendProgressNotification(range1To5000);
                    //WiresSMSNotificationController.SendProgressSMSNotification(range1To5000);
                    //WiresTransactionApprovalController.CheckRedFlgsAndUpdateStatus(range1To5000);
                }
                
                if(rangeForInPersonSigning.size()>0){
                    InPersonSigningContoller inPersonSigning=new InPersonSigningContoller();
                    for(Id id:rangeForInPersonSigning){
                        inPersonSigning.AssignWiresToInPersonSigningHandler(id);
                    }
                }
                
            }
        }
    }
    
    
    //------------------------------------------------------------------Before Insert  ------------------------------------------------------------------------------//
    if(Trigger.isInsert && Trigger.isBefore){ 
        for(WIRES_Transaction__c objWIRESTransaction: trigger.New)
        {
            
            string AccountNo= objWIRESTransaction.FromAccount__c;    	
            
            Account_Details__c accDetail=[SELECT Id,Name, Brand__c FROM Account_Details__c WHERE Name=:AccountNo AND RecType__c = 'ACCT' LIMIT 1];
            if(accDetail!=null){
                objWIRESTransaction.Brand__c=accDetail.Brand__c;
            }
            
            if(objWIRESTransaction.Frequency__c == 'Recurring'){
                objWIRESTransaction.SendOn__c = null;    	
            }
            
            if(objWIRESTransaction.Source__c == WiresConstant.Source_Branch)
                objWIRESTransaction.Status__c = 'N/A';
            
            List<Account_Details__c> listAccountDetails = [select id,Brand__c,ID1__c,OPEN_DATE__c from Account_Details__c where Name =: AccountNo 
                                                           and ID1__c =: objWIRESTransaction.Share_ID__c limit 1];
            system.debug('listAccountDetails'+listAccountDetails);
            
            Integer numberofDays =0;
            if(listAccountDetails.size()>0){
                numberofDays = listAccountDetails[0].OPEN_DATE__c.daysBetween(Date.today());
            }
            
            if(numberofDays >=45){
                objWIRESTransaction.FlagAccountOpenfor45Days__c = true;
            }
            
            set<string> typeList = new set<string>();
            
            for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
                typeList.add(t.name);	
            }
            
            Person_Account__c paPrimary;
            
            if(objWIRESTransaction.Source__c=='Online Banking'){
                string likeClause = '%' + String.escapeSingleQuotes( objWIRESTransaction.Member_SSN__c.trim());
                paPrimary = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, 
                             Account_Number__r.Name, PersonID__r.Home_Phone__pc,
                             PersonID__r.Residential_City__pc,PersonID__r.Residential_State__pc, 
                             PersonID__r.Residential_Street__pc, PersonID__r.Residential_Zipocde__pc, 
                             PersonID__r.Name, PersonID__r.Email_raw__c 
                             FROM Person_Account__c 
                             WHERE PersonID__r.PersonID__c like :likeClause AND
                             Account_Number__r.Name =: AccountNo 
                             Limit 1];
            }else{
                
                string likeClause = '%' + String.escapeSingleQuotes( objWIRESTransaction.Member_SSN__c.trim());
                paPrimary = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c,
                             Account_Number__r.Name, PersonID__r.Home_Phone__pc,
                             PersonID__r.Residential_City__pc,PersonID__r.Residential_State__pc, 
                             PersonID__r.Residential_Street__pc, PersonID__r.Residential_Zipocde__pc, 
                             PersonID__r.Name, PersonID__r.Email_raw__c 
                             FROM Person_Account__c 
                             WHERE PersonID__r.PersonID__c like :likeClause 
                             AND Account_Number__r.Name =: AccountNo 
                             Limit 1];
            }
            
            objWIRESTransaction.Member__c = paPrimary.PersonID__c;
            objWIRESTransaction.Member_Name__c = paPrimary.PersonID__r.Name;
            objWIRESTransaction.Member_Email__c = paPrimary.PersonID__r.Email_raw__c;
            objWIRESTransaction.Member_Home_Phone__c =  paPrimary.PersonID__r.Home_Phone__pc;
            objWIRESTransaction.Member_Address__c = paPrimary.PersonID__r.Residential_Street__pc;
            objWIRESTransaction.Member_City_State_Zip__c = paPrimary.PersonID__r.Residential_City__pc + ', '+ paPrimary.PersonID__r.Residential_State__pc + ' '+ paPrimary.PersonID__r.Residential_Zipocde__pc ;
            
            decimal amount=objWIRESTransaction.WireAmount__c;
            
            string amountInWord = ConvertCurrencyToWordsEN.english_number((long)amount)+' Dollars';
            string centInWord=ConvertCurrencyToWordsEN.cent_in_word((decimal)amount);
            if(centInWord!=''){
                amountInWord=amountInWord+' and '+centInWord;
            }
            objWIRESTransaction.Wire_Amount_In_Word__c= amountInWord;
            
            if(objWIRESTransaction.Source__c==WiresConstant.Source_Branch){
                
                if(objWIRESTransaction.Frequency__c==WiresConstant.Reccuring){
                    objWIRESTransaction.Approval_Status__c = WiresConstant.ApprovalStatus_Recurring;
                }else if(objWIRESTransaction.ParentTransaction__c==null){
                	objWIRESTransaction.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForMemberReview;
                }
                
                objWIRESTransaction.CreatedById =objWIRESTransaction.LaunchByUserId__c;
                
            }else {
                if(objWIRESTransaction.Frequency__c==WiresConstant.Reccuring){
                    objWIRESTransaction.Approval_Status__c = WiresConstant.ApprovalStatus_Recurring;
                }
            }
            
            list<Person_Account__c> paList = [SELECT Id,PersonID__c,
                                              Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c 
                                              WHERE Account_Number__r.Name =: AccountNo and TypeTranslate__c IN:typeList];
            
            set<String> accountNumberSet = new set<String>();
            set<Id> accIdset = new set<Id>();
            set<String> acctypeSet = new set<String>();
            list<string> allRelatedAccounts = new list<string>();
            
            for (Person_Account__c var: paList)
            {
                accountNumberSet.add(var.Account_Number__r.Name);
                acctypeSet.add(var.Account_Number__r.RecType__c);
                accIdSet.add(var.Account_Number__c);
            }
            
            list<Account_Details__c> accList = new list<Account_Details__c>();
            if (acctypeSet.contains('ACCT'))
            {
                accList = [SELECT Id,
                           Name FROM Account_Details__c WHERE Name IN: accountNumberSet and RecType__c != 'CARD'];
            }
            else
            {
                accList = [SELECT Id,
                           Name
                           FROM Account_Details__c Where Id IN: accIdSet and RecType__c != 'CARD'];
            }
            system.debug('allRelatedAccounts 2---' + allRelatedAccounts);
            
            set<String> accName = new Set<String>();
            
            for (Account_Details__c var: accList)
            {
                accName.add(var.Name);
            }
            
            list<Person_Account__c> ContactList = new list<Person_Account__c>();
            ContactList = [Select
                           
                           Account_Number__c, personId__c
                           
                           From Person_Account__c WHERE Account_Number__r.Name IN: accName];
            list<string> accids = new list<string>();
            
            for (Person_Account__c var: ContactList)
            {
                accids.add(var.Account_Number__c);
                allRelatedAccounts.add(var.personId__c);
                
            }
            system.debug('allRelatedAccounts 3---' + allRelatedAccounts);       
            
            
            List<Account> listAccount;
            List<accounthistory> listhistory;        
            List<wrapperAccount> listWrapperAccount = new List<wrapperAccount>();
            
            if (allRelatedAccounts != null && allRelatedAccounts.size() > 0)
            {
                
                listAccount = [select Id, Member_Verification_OTP_Invalid_Attempt__c, Home_Phone__pc, FirstName, LastName, Mobile_Phone__pc, Work_Phone__pc, PersonEmail, Alternate_Email__pc from Account where ID in :allRelatedAccounts];
                listhistory = [Select accountid,field,OldValue, NewValue, CreatedDate From accounthistory where accountid in :allRelatedAccounts and createddate >: (date.TODAY() - 30)];
                List<accounthistory> listhistoryOlder = [Select accountid,field,OldValue, NewValue, CreatedDate From accounthistory where accountid in :allRelatedAccounts and createddate <=: (date.TODAY() - 30)];
                
                set<string> listContacts = new set<string>();
                
                
                for (Account accountLocal : listAccount)
                {
                    if (accountLocal.Mobile_Phone__pc != null && accountLocal.Mobile_Phone__pc != '')
                    {
                        if(!listContacts.contains(accountLocal.Mobile_Phone__pc))
                        {
                            wrapperAccount accLocal = new wrapperAccount();
                            
                            accLocal.fieldType = 'P';
                            accLocal.value = accountLocal.Mobile_Phone__pc;
                            //accLocal.encryptedvalue = encryptPhone(accountLocal.Mobile_Phone__pc);
                            accLocal.fieldName = 'Mobile_Phone__pc - ' + accountLocal.Id;
                            accLocal.isEnabled = isContactEnabled(accountLocal.Mobile_Phone__pc,'Mobile_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);                       
                            
                            listWrapperAccount.Add(accLocal);
                            listContacts.add(accountLocal.Mobile_Phone__pc);
                        }
                    }
                }
                for (Account accountLocal : listAccount)
                {
                    if (accountLocal.Home_Phone__pc != null && accountLocal.Home_Phone__pc != '')
                    {
                        if (!listContacts.contains(accountLocal.Home_Phone__pc))
                        {
                            wrapperAccount accLocal = new wrapperAccount();
                            accLocal.fieldType = 'P';
                            accLocal.value = accountLocal.Home_Phone__pc;
                            //accLocal.encryptedvalue = encryptPhone(accountLocal.Home_Phone__pc);
                            accLocal.fieldName = 'Home_Phone__pc - ' + accountLocal.Id;
                            accLocal.isEnabled = isContactEnabled(accountLocal.Home_Phone__pc,'Home_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                            
                            listWrapperAccount.Add(accLocal);
                            listContacts.add(accountLocal.Home_Phone__pc);
                        }
                        
                    }
                }
                for (Account accountLocal : listAccount)
                {
                    if (accountLocal.Work_Phone__pc != null && accountLocal.Work_Phone__pc != '')
                    {
                        if (!listContacts.contains(accountLocal.Work_Phone__pc))
                        {
                            wrapperAccount accLocal = new wrapperAccount();
                            accLocal.fieldType = 'P';
                            accLocal.value = accountLocal.Work_Phone__pc;
                            //accLocal.encryptedvalue = encryptPhone(accountLocal.Work_Phone__pc);
                            accLocal.fieldName = 'Work_Phone__pc - ' + accountLocal.Id;
                            accLocal.isEnabled = isContactEnabled(accountLocal.Work_Phone__pc,'Work_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                            
                            listWrapperAccount.Add(accLocal);
                            listContacts.add(accountLocal.Work_Phone__pc);
                        }
                    }
                }
                for (Account accountLocal : listAccount)
                {
                    if (accountLocal.PersonEmail != null && accountLocal.PersonEmail != '')
                    {
                        if (!listContacts.contains(accountLocal.PersonEmail))
                        {
                            wrapperAccount accLocal = new wrapperAccount();
                            accLocal.fieldType = 'E';
                            accLocal.value = accountLocal.PersonEmail;
                            //accLocal.encryptedvalue = encryptEmail(accountLocal.PersonEmail);
                            accLocal.fieldName = 'PersonEmail - ' + accountLocal.Id;
                            accLocal.isEnabled = isContactEnabled(accountLocal.PersonEmail,'PersonEmail',accountLocal.id,listhistory,listhistoryOlder,false);
                            
                            listWrapperAccount.Add(accLocal);
                            listContacts.add(accountLocal.PersonEmail);
                        }
                    }
                }
                
                
                
                
                for (Account accountLocal : listAccount)
                {
                    if (accountLocal.Mobile_Phone__pc != null && accountLocal.Mobile_Phone__pc != '')
                    {
                        if (!listContacts.contains(accountLocal.Mobile_Phone__pc))
                        {
                            wrapperAccount accLocal = new wrapperAccount();
                            
                            accLocal.fieldType = 'P';
                            accLocal.value = accountLocal.Mobile_Phone__pc;
                            //accLocal.encryptedvalue = encryptPhone(accountLocal.Mobile_Phone__pc);
                            accLocal.fieldName = 'Mobile_Phone__pc - ' + accountLocal.Id;
                            accLocal.isEnabled = isContactEnabled(accountLocal.Mobile_Phone__pc,'Mobile_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                            
                            listWrapperAccount.Add(accLocal);
                            listContacts.add(accountLocal.Mobile_Phone__pc);
                        }
                    }
                }
                for (Account accountLocal : listAccount)
                {
                    if (accountLocal.Home_Phone__pc != null && accountLocal.Home_Phone__pc != '')
                    {
                        if (!listContacts.contains(accountLocal.Home_Phone__pc))
                        {
                            wrapperAccount accLocal = new wrapperAccount();
                            accLocal.fieldType = 'P';
                            accLocal.value = accountLocal.Home_Phone__pc;
                            //accLocal.encryptedvalue = encryptPhone(accountLocal.Home_Phone__pc);
                            accLocal.fieldName = 'Home_Phone__pc - ' + accountLocal.Id;
                            accLocal.isEnabled = isContactEnabled(accountLocal.Home_Phone__pc,'Home_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                            
                            listWrapperAccount.Add(accLocal);
                            listContacts.add(accountLocal.Home_Phone__pc);
                        }
                        
                    }
                }
                for (Account accountLocal : listAccount)
                {
                    if (accountLocal.Work_Phone__pc != null && accountLocal.Work_Phone__pc != '')
                    {
                        if (!listContacts.contains(accountLocal.Work_Phone__pc))
                        {
                            wrapperAccount accLocal = new wrapperAccount();
                            accLocal.fieldType = 'P';
                            accLocal.value = accountLocal.Work_Phone__pc;
                            //accLocal.encryptedvalue = encryptPhone(accountLocal.Work_Phone__pc);
                            accLocal.fieldName = 'Work_Phone__pc - ' + accountLocal.Id;
                            accLocal.isEnabled = isContactEnabled(accountLocal.Work_Phone__pc,'Work_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                            
                            listWrapperAccount.Add(accLocal);
                            listContacts.add(accountLocal.Work_Phone__pc);
                        }
                    }
                }
                for (Account accountLocal : listAccount)
                {
                    if (accountLocal.PersonEmail != null && accountLocal.PersonEmail != '')
                    {
                        if (!listContacts.contains(accountLocal.PersonEmail))
                        {
                            wrapperAccount accLocal = new wrapperAccount();
                            accLocal.fieldType = 'E';
                            accLocal.value = accountLocal.PersonEmail;
                            //accLocal.encryptedvalue = encryptEmail(accountLocal.PersonEmail);
                            accLocal.fieldName = 'PersonEmail - ' + accountLocal.Id;
                            accLocal.isEnabled = isContactEnabled(accountLocal.PersonEmail,'PersonEmail',accountLocal.id,listhistory,listhistoryOlder,false);
                            
                            listWrapperAccount.Add(accLocal);
                            listContacts.add(accountLocal.PersonEmail);
                        }
                    }
                }
                
            }
            
            boolean isEmailStable=true, isHomePhoneStable=true, isMobilePhoneStable=true, isWorkPhoneStable=true;
            
            if (listWrapperAccount != null && listWrapperAccount.size() > 0)
            {
                
                
                for (wrapperAccount a : listWrapperAccount)
                {
                    if (a.fieldType == 'E' && a.isEnabled == false)
                    {
                        isEmailStable = false;
                        
                    }
                    else if (a.fieldType == 'P' && a.fieldName.contains('Mobile_Phone__pc') && a.isEnabled == false)
                    {
                        isMobilePhoneStable = false;
                        
                    }
                    else if (a.fieldType == 'P' && a.fieldName.contains('Home_Phone__pc') && a.isEnabled == false)
                    {
                        isHomePhoneStable = false;
                        
                    }
                    else if (a.fieldType == 'P' && a.fieldName.contains('Work_Phone__pc') && a.isEnabled == false)
                    {
                        isWorkPhoneStable = false;
                        
                    }
                }           
                if(isEmailStable) {
                    objWIRESTransaction.FlagEmailStablefor30Days__c = true;
                }
                if(isMobilePhoneStable) {
                    objWIRESTransaction.FlagMobilePhoneStablefor30Days__c = true;
                }
                if(isHomePhoneStable) {
                    objWIRESTransaction.FlagHomePhoneStablefor30Days__c = true;
                }
                if(isWorkPhoneStable) {
                    objWIRESTransaction.FlagWorkPhoneStablefor30Days__c = true;
                }
                
            }
            
            
            
        }     
    }    
    
    
    
    public static boolean isContactEnabled(string FieldValue, string FieldName, string accountid,  List<accounthistory> listhistory, List<accounthistory> listhistoryOlder, boolean phone)
    {
        Set<String> contactFields = new Set<string>{ 'Mobile_Phone__pc','Home_Phone__pc','Work_Phone__pc'};
            
            
            if(!phone )
        {
            contactFields = new Set<string>{ 'PersonEmail'};
                
                }
        
        boolean CurrentFieldUpdatedIn30Days = false;
        for(accounthistory accHistory : listhistory)
        {
            
            if(accHistory.accountid == accountid && FieldName == accHistory.Field)
            {
                CurrentFieldUpdatedIn30Days = true;
            }
        }
        if(!CurrentFieldUpdatedIn30Days)
        {
            return true;
        }
        
        
        
        for(string field  : contactFields){
            
            
            string OldestValue = '';
            DateTime OldestTime;
            
            
            accounthistory oldestAccountHistory = new accounthistory(); 
            system.debug('-------field###' + field);
            for(accounthistory accHistory : listhistory)
            {
                system.debug('------------------------------accHistory###' + accHistory);
                if(accHistory.accountid == accountid && field == accHistory.Field)
                {
                    if(OldestTime == null)
                    {
                        OldestTime = accHistory.CreatedDate;
                        if(accHistory.OldValue != null)
                        {
                            OldestValue = string.valueOf( accHistory.OldValue);
                        }
                        else
                        {
                            OldestValue = '';
                        }
                        oldestAccountHistory = accHistory;
                    }
                    else
                    {
                        if(accHistory.CreatedDate < OldestTime)
                        {
                            OldestTime = accHistory.CreatedDate;
                            OldestValue = string.valueOf( accHistory.OldValue);
                            oldestAccountHistory = accHistory;
                        }
                    }
                }	
            }
            if(OldestValue == FieldValue)
            {
                return true;
            }
            
        }
        
        
        boolean foundInOlderValue = false;
        for(accounthistory accounthistoryLocal : listhistoryOlder){
            string oldValue='',newValue='';
            if(accounthistoryLocal.OldValue != null)
            {
                oldValue = string.valueOf(accounthistoryLocal.OldValue) ;
            }
            if(accounthistoryLocal.newValue != null)
            {
                newValue = string.valueOf(accounthistoryLocal.newValue) ;
            }
            
            else if(accounthistoryLocal.accountid == accountid && contactFields.Contains(FieldName) && (oldValue == FieldValue && newValue == FieldValue ))
            {
                return true;
            }
        }
        
        
        
        
        return false;
        
        
    } 
    
    public class wrapperAccount
    {
        public string fieldName { get; set; }
        public string fieldType { get; set; }
        public string value { get; set; }
        public string encryptedvalue { get; set; }
        public boolean isEnabled {get; set;}
    }
}