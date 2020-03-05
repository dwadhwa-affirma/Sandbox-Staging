trigger WIRESTransactionTrigger on WIRES_Transaction__c (before insert, after insert) {
	
    //------------------------------------------------------------------After Insert  ------------------------------------------------------------------------------//
    
    Set<Id> WTIds = new Set<Id>();
    
    if(Trigger.isInsert){
    	
    	if(Trigger.isAfter){
    		
        	for(Integer i=0; i<trigger.new.size(); i++){
        	   	
        	   	WTIds.add(trigger.new[i].id);
            } 
    	}
	}
    
    if(WTIds.size() > 0){
        
    	Database.executeBatch(new WiresTransToDocuSignBatch(WTIds),1);
    }
    
    //------------------------------------------------------------------Before Insert  ------------------------------------------------------------------------------//
 if(Trigger.isInsert && Trigger.isBefore){ 
    for(WIRES_Transaction__c objWIRESTransaction: trigger.New)
    {
    	string AccountNo= objWIRESTransaction.FromAccount__c;    	
    
    	
    	List<Account_Details__c> listAccountDetails = [select id,Brand__c,OPEN_DATE__c from Account_Details__c where Name =: AccountNo 
    											and ID1__c =: objWIRESTransaction.Share_ID__c limit 1];

		Integer numberofDays = listAccountDetails[0].OPEN_DATE__c.daysBetween(Date.today());
    	if(numberofDays >=45){
    		objWIRESTransaction.FlagAccountOpenfor45Days__c = true;
    	}
    		
    	
    	
    	set<string> typeList = new set<string>();
       
       for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
       		typeList.add(t.name);	
       }
       
       Person_Account__c paPrimary = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name, PersonID__r.Name, PersonID__r.Email_raw__c FROM Person_Account__c 
                             WHERE Account_Number__r.Name =: AccountNo and TypeTranslate__c  like '%Primary%' limit 1];
                             
       objWIRESTransaction.Member_Name__c = paPrimary.PersonID__r.Name;
       objWIRESTransaction.Member_Email__c = paPrimary.PersonID__r.Email_raw__c;
           
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