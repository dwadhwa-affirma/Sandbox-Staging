public class MemberOTPVerificationLightningController
{


    private Account GetAccount(string accID)
    {
    	 system.debug('Account Id from GetAccount---' + accID);
        List<Account> listAccount;

        listAccount = [select Id,Member_Verification_OTP_Invalid_Attempt__c, FirstName, LastName, home_phone__pc, Mobile_Phone__pc, Work_Phone__pc, PersonEmail, Alternate_Email__pc from Account where ID =:accID];
        system.debug('listAccount---' + listAccount);
        if (listAccount.size() > 0)
        {
            Account acc = listAccount[0];

            return acc;
        }
        return null;

    }


    public static list<string> GetRelatedAccountsPopulated(string accID, account acc)
    {


        list<string> allRelatedAccounts = new list<string>();
        allRelatedAccounts.add(accID);


        system.debug('allRelatedAccounts 1---' + allRelatedAccounts);






        list<Person_Account__c> paList = new list<Person_Account__c>();
        paList = [SELECT Id,
                         Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:acc.Id];
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
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

                               From Person_Account__c WHERE Account_Number__r.Name IN: accName and (NOT TypeTranslate__c like '%Beneficiary%')]; //  and (NOT TypeTranslate__c like '%Beneficiary%')
        list<string> accids = new list<string>();

        for (Person_Account__c var: ContactList)
        {
            accids.add(var.Account_Number__c);
            allRelatedAccounts.add(var.personId__c);

        }
        system.debug('allRelatedAccounts 3---' + allRelatedAccounts);

        return allRelatedAccounts;

    }

    public static list<string> GetAccIdsPopulated(string accID, account acc)
    {

        list<String> accids = new list<string>();
        list<string> allRelatedAccounts = new list<string>();
        allRelatedAccounts.add(accID);


        system.debug('allRelatedAccounts 1---' + allRelatedAccounts);






        list<Person_Account__c> paList = new list<Person_Account__c>();
        paList = [SELECT Id,
                         Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:acc.Id];
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
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

                               From Person_Account__c WHERE Account_Number__r.Name IN: accName]; // and (NOT TypeTranslate__c like '%Beneficiary%')


        for (Person_Account__c var: ContactList)
        {
            accids.add(var.Account_Number__c);
            allRelatedAccounts.add(var.personId__c);

        }
        system.debug('allRelatedAccounts 3---' + allRelatedAccounts);

        return accids;

    }

    private static List<KeyValuePairModelWithBit> GetPhoneList_Options(List<wrapperAccount> listWrapperAccount)
    {


        List<KeyValuePairModelWithBit> options = new List<KeyValuePairModelWithBit>();

        if (listWrapperAccount != null && listWrapperAccount.size() > 0)
        {

            for (wrapperAccount a : listWrapperAccount)
            {
                if (a.fieldType == 'P')
                {
                    KeyValuePairModelWithBit pair = new KeyValuePairModelWithBit();
                    pair.Text = a.fieldName;
                    pair.Value = a.encryptedvalue;
                    pair.isEnabled = !a.isEnabled;
                    pair.memId = a.memberId;
                    options.add(pair);
                }
            }
            system.debug('Phoneoptions-----' + options);
        }
        return options;

    }
    
	private static List<KeyValuePairModelWithBit> GetMemList_Options(map<id,string> memid)
    {
        List<KeyValuePairModelWithBit> options = new List<KeyValuePairModelWithBit>();

        if (memid != null && memid.size() > 0)
        {
            for (id m : memid.keySet())
            {
               KeyValuePairModelWithBit pair = new KeyValuePairModelWithBit();
                    pair.Text = m;
                    pair.Value = memid.get(m);                
                    options.add(pair);
            }            
        }
            system.debug('mem-----' + options);
        return options;
    }
    private static List<KeyValuePairModelWithBit> GetEmailsList_Options(List<wrapperAccount> listWrapperAccount)
    {


        List<KeyValuePairModelWithBit> options = new List<KeyValuePairModelWithBit>();
        if (listWrapperAccount != null && listWrapperAccount.size() > 0)
        {

            for (wrapperAccount a : listWrapperAccount)
            {
                if (a.fieldType == 'E')
                {
                    KeyValuePairModelWithBit pair = new KeyValuePairModelWithBit();
                    pair.Text = a.fieldName;
                    pair.Value = a.encryptedvalue;
                    pair.isEnabled = !a.isEnabled;
                    pair.memId = a.memberId;
                    options.add(pair);
                }
            }
            system.debug('Emailoptions-----' + options);

        }
        return options;

    }

  @auraenabled
    public static OTPVerificationModel ListOfEmailsAndPhoneNumbers(string accid, Boolean IsAuth, String GUID, string IVRGUIDFromUrl )
    {
        system.debug('accid---' + accid);
         string  AccountNumber;
       	 List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:accid  limit 1];
         if(p.size() > 0){
        	AccountNumber = p[0].Account_Number__r.Name;
         }
        string Brand;
        MemberOTPVerificationLightningController objMVLC = new MemberOTPVerificationLightningController();
        Account acc = objMVLC.GetAccount(accID);
        List<string> allRelatedAccounts = GetRelatedAccountsPopulated(accid, acc);
        List<wrapperAccount> listWrapperAccount = new List<wrapperAccount>();
        system.debug('allRelatedAccounts 4---' + allRelatedAccounts);
        string IsIneligibleLocal = 'false';
        string NoContactInfo = 'false';
        List<Account> listAccount;
        List<accounthistory> listhistory;
     	Map<id,string> memid = new Map<id,string>();

        if (allRelatedAccounts != null && allRelatedAccounts.size() > 0)
        {

            listAccount = [select Id, Member_Verification_OTP_Invalid_Attempt__c, Home_Phone__pc, FirstName, LastName, Mobile_Phone__pc, Work_Phone__pc, PersonEmail, Alternate_Email__pc from Account where ID in :allRelatedAccounts];
            listhistory = [Select accountid,field,OldValue, NewValue, CreatedDate From accounthistory where accountid in :allRelatedAccounts and createddate >: (date.TODAY() - 30)];
            List<accounthistory> listhistoryOlder = [Select accountid,field,OldValue, NewValue, CreatedDate From accounthistory where accountid in :allRelatedAccounts and createddate <=: (date.TODAY() - 30)];
            listWrapperAccount = new List<wrapperAccount>();
            set<string> listContacts = new set<string>();


            for (Account accountLocal : listAccount)
            {
            	listContacts = new set<string>();
                if (accountLocal.Mobile_Phone__pc != null && accountLocal.Mobile_Phone__pc != '')
                {
                    if (!listContacts.contains(accountLocal.Mobile_Phone__pc) && accountLocal.id == acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        system.debug('FirstName##' + accountLocal.FirstName);
                        if(accountLocal.FirstName == null &&  accountLocal.LastName != null){                        
                            memid.put(accountLocal.id,accountLocal.LastName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName == null){
                            memid.put(accountLocal.id,accountLocal.FirstName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName != null){
                            memid.put(accountLocal.id,accountLocal.FirstName+ ' '+accountLocal.LastName);
                        }
						accLocal.Memberid= accountLocal.id;
                        accLocal.fieldType = 'P';
                        accLocal.value = accountLocal.Mobile_Phone__pc;
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.Mobile_Phone__pc;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptPhone(accountLocal.Mobile_Phone__pc);
                        }
                        
                        accLocal.fieldName = 'Mobile_Phone__pc - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.Mobile_Phone__pc,'Mobile_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);                       
                                       /*  for(accounthistory accounthistoryLocal : listhistory)
                                         {                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Mobile_Phone__pc') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         }  */                                       
                                         
                        listWrapperAccount.Add(accLocal);
                        listContacts.add(accountLocal.Mobile_Phone__pc);
                    }
                }
                if (accountLocal.Home_Phone__pc != null && accountLocal.Home_Phone__pc != '')
                {
                    if (!listContacts.contains(accountLocal.Home_Phone__pc) && accountLocal.id == acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        accLocal.Memberid= accountLocal.id;
						accLocal.MemberName=accountLocal.FirstName+ ' '+accountLocal.LastName;
                        accLocal.fieldType = 'P';
                        accLocal.value = accountLocal.Home_Phone__pc;
                        
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.Home_Phone__pc;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptPhone(accountLocal.Home_Phone__pc);
                        }
                        
                        accLocal.fieldName = 'Home_Phone__pc - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.Home_Phone__pc,'Home_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                       /*   for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Home_Phone__pc') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         }   */
                        listWrapperAccount.Add(accLocal);
                        listContacts.add(accountLocal.Home_Phone__pc);
                    }

                }
                if (accountLocal.Work_Phone__pc != null && accountLocal.Work_Phone__pc != '')
                {
                    if (!listContacts.contains(accountLocal.Work_Phone__pc) && accountLocal.id == acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        system.debug('FirstName##' + accountLocal.FirstName);
                        if(accountLocal.FirstName == null &&  accountLocal.LastName != null){                        
                            memid.put(accountLocal.id,accountLocal.LastName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName == null){
                            memid.put(accountLocal.id,accountLocal.FirstName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName != null){
                            memid.put(accountLocal.id,accountLocal.FirstName+ ' '+accountLocal.LastName);
                        }
                        accLocal.Memberid= accountLocal.id;
                        accLocal.fieldType = 'P';
                        accLocal.value = accountLocal.Work_Phone__pc;
                        
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.Work_Phone__pc;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptPhone(accountLocal.Work_Phone__pc);
                        }
                       
                        accLocal.fieldName = 'Work_Phone__pc - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.Work_Phone__pc,'Work_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                       /*   for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Work_Phone__pc') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         }*/
                        listWrapperAccount.Add(accLocal);
                        listContacts.add(accountLocal.Work_Phone__pc);
                    }
                }
                if (accountLocal.PersonEmail != null && accountLocal.PersonEmail != '')
                {
                    if (!listContacts.contains(accountLocal.PersonEmail) && accountLocal.id == acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        system.debug('FirstName##' + accountLocal.FirstName);
                        if(accountLocal.FirstName == null &&  accountLocal.LastName != null){                        
                            memid.put(accountLocal.id,accountLocal.LastName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName == null){
                            memid.put(accountLocal.id,accountLocal.FirstName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName != null){
                            memid.put(accountLocal.id,accountLocal.FirstName+ ' '+accountLocal.LastName);
                        }
                        
                        accLocal.Memberid= accountLocal.id;
                        accLocal.fieldType = 'E';
                        accLocal.value = accountLocal.PersonEmail;
                        
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.PersonEmail;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptEmail(accountLocal.PersonEmail);
                        }
                        
                        accLocal.fieldName = 'PersonEmail - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.PersonEmail,'PersonEmail',accountLocal.id,listhistory,listhistoryOlder,false);
                                       /*  for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'PersonEmail') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         } */
                        listWrapperAccount.Add(accLocal);
                        listContacts.add(accountLocal.PersonEmail);
                    }
                }
                if (accountLocal.Alternate_Email__pc != null && accountLocal.Alternate_Email__pc != '')
                {
                    if (!listContacts.contains(accountLocal.Alternate_Email__pc) && accountLocal.id == acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        system.debug('FirstName##' + accountLocal.FirstName);
                        if(accountLocal.FirstName == null &&  accountLocal.LastName != null){                        
                            memid.put(accountLocal.id,accountLocal.LastName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName == null){
                            memid.put(accountLocal.id,accountLocal.FirstName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName != null){
                            memid.put(accountLocal.id,accountLocal.FirstName+ ' '+accountLocal.LastName);
                        }
                        accLocal.Memberid= accountLocal.id;
                        accLocal.fieldType = 'E';
                        accLocal.value = accountLocal.Alternate_Email__pc;
                        
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.Alternate_Email__pc;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptEmail(accountLocal.Alternate_Email__pc);
                        }
                        
                        accLocal.fieldName = 'Alternate_Email__pc - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.Alternate_Email__pc,'Alternate_Email__pc',accountLocal.id,listhistory,listhistoryOlder,false);
                                   /*      for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Alternate_Email__pc') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         }  */
                        listWrapperAccount.Add(accLocal);
                        listContacts.Add(accountLocal.Alternate_Email__pc);
                    }
                }
            }

            for (Account accountLocal : listAccount)
            {
            	listContacts = new set<string>();
                if (accountLocal.Mobile_Phone__pc != null && accountLocal.Mobile_Phone__pc != '')
                {
                    if (!listContacts.contains(accountLocal.Mobile_Phone__pc) && accountLocal.id != acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        system.debug('FirstName##' + accountLocal.FirstName);
                       if(accountLocal.FirstName == null &&  accountLocal.LastName != null){                        
                            memid.put(accountLocal.id,accountLocal.LastName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName == null){
                            memid.put(accountLocal.id,accountLocal.FirstName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName != null){
                            memid.put(accountLocal.id,accountLocal.FirstName+ ' '+accountLocal.LastName);
                        }
						accLocal.Memberid= accountLocal.id;
                        accLocal.fieldType = 'P';
                        accLocal.value = accountLocal.Mobile_Phone__pc;
                        
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.Mobile_Phone__pc;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptPhone(accountLocal.Mobile_Phone__pc);
                        }
                        
                        accLocal.fieldName = 'Mobile_Phone__pc - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.Mobile_Phone__pc,'Mobile_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                         /*for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Mobile_Phone__pc') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         }*/
                        listWrapperAccount.Add(accLocal);
                        listContacts.add(accountLocal.Mobile_Phone__pc);
                    }
                }
                if (accountLocal.Home_Phone__pc != null && accountLocal.Home_Phone__pc != '')
                {
                    if (!listContacts.contains(accountLocal.Home_Phone__pc) && accountLocal.id != acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        system.debug('FirstName##' + accountLocal.FirstName);
                       if(accountLocal.FirstName == null &&  accountLocal.LastName != null){                        
                            memid.put(accountLocal.id,accountLocal.LastName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName == null){
                            memid.put(accountLocal.id,accountLocal.FirstName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName != null){
                            memid.put(accountLocal.id,accountLocal.FirstName+ ' '+accountLocal.LastName);
                        }
                        accLocal.Memberid= accountLocal.id;
                        accLocal.fieldType = 'P';
                        accLocal.value = accountLocal.Home_Phone__pc;
                        
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.Home_Phone__pc;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptPhone(accountLocal.Home_Phone__pc);
                        }
                       
                        accLocal.fieldName = 'Home_Phone__pc - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.Home_Phone__pc,'Home_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                         /*for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Home_Phone__pc') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         }*/
                        listWrapperAccount.Add(accLocal);
                        listContacts.add(accountLocal.Home_Phone__pc);
                    }

                }
                if (accountLocal.Work_Phone__pc != null && accountLocal.Work_Phone__pc != '')
                {
                    if (!listContacts.contains(accountLocal.Work_Phone__pc) && accountLocal.id != acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        system.debug('FirstName##' + accountLocal.FirstName);
                        if(accountLocal.FirstName == null &&  accountLocal.LastName != null){                        
                            memid.put(accountLocal.id,accountLocal.LastName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName == null){
                            memid.put(accountLocal.id,accountLocal.FirstName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName != null){
                            memid.put(accountLocal.id,accountLocal.FirstName+ ' '+accountLocal.LastName);
                        }
                        accLocal.Memberid= accountLocal.id;
                        accLocal.fieldType = 'P';
                        accLocal.value = accountLocal.Work_Phone__pc;
                        
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.Work_Phone__pc;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptPhone(accountLocal.Work_Phone__pc);
                        }
                        
                        accLocal.fieldName = 'Work_Phone__pc - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.Work_Phone__pc,'Work_Phone__pc',accountLocal.id,listhistory,listhistoryOlder,true);
                                         /*for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Work_Phone__pc') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         } */
                        listWrapperAccount.Add(accLocal);
                        listContacts.add(accountLocal.Work_Phone__pc);
                    }
                }
                if (accountLocal.PersonEmail != null && accountLocal.PersonEmail != '')
                {
                    if (!listContacts.contains(accountLocal.PersonEmail) && accountLocal.id != acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        system.debug('FirstName##' + accountLocal.FirstName);
                        if(accountLocal.FirstName == null &&  accountLocal.LastName != null){                        
                            memid.put(accountLocal.id,accountLocal.LastName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName == null){
                            memid.put(accountLocal.id,accountLocal.FirstName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName != null){
                            memid.put(accountLocal.id,accountLocal.FirstName+ ' '+accountLocal.LastName);
                        }
                        accLocal.Memberid= accountLocal.id;
                        accLocal.fieldType = 'E';
                        accLocal.value = accountLocal.PersonEmail;
                        
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.PersonEmail;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptEmail(accountLocal.PersonEmail);
                        }
                      
                        accLocal.fieldName = 'PersonEmail - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.PersonEmail,'PersonEmail',accountLocal.id,listhistory,listhistoryOlder,false);
                                         /*for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'PersonEmail') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         } */
                        listWrapperAccount.Add(accLocal);
                        listContacts.add(accountLocal.PersonEmail);
                    }
                }
                if (accountLocal.Alternate_Email__pc != null && accountLocal.Alternate_Email__pc != '')
                {
                    if (!listContacts.contains(accountLocal.Alternate_Email__pc) && accountLocal.id != acc.id)
                    {
                        wrapperAccount accLocal = new wrapperAccount();
                        system.debug('FirstName##' + accountLocal.FirstName);
                       if(accountLocal.FirstName == null &&  accountLocal.LastName != null){                        
                            memid.put(accountLocal.id,accountLocal.LastName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName == null){
                            memid.put(accountLocal.id,accountLocal.FirstName);
                        }
                        if(accountLocal.FirstName != null &&  accountLocal.LastName != null){
                            memid.put(accountLocal.id,accountLocal.FirstName+ ' '+accountLocal.LastName);
                        }
                        accLocal.Memberid= accountLocal.id;
                        accLocal.fieldType = 'E';
                        accLocal.value = accountLocal.Alternate_Email__pc;
                        
                        if(IsAuth == true){
                        	accLocal.encryptedvalue = accountLocal.Alternate_Email__pc;	
                        }
                        else{
                        	accLocal.encryptedvalue = encryptEmail(accountLocal.Alternate_Email__pc);
                        }
                        
                        accLocal.fieldName = 'Alternate_Email__pc - ' + accountLocal.Id;
                        accLocal.isEnabled = isContactEnabled(accountLocal.Alternate_Email__pc,'Alternate_Email__pc',accountLocal.id,listhistory,listhistoryOlder,false);
                                        /* for(accounthistory accounthistoryLocal : listhistory)
                                         { 
                                         	                     	
                                         	if((accounthistoryLocal.accountid == accountLocal.id) && (accounthistoryLocal.Field == 'Alternate_Email__pc') )
                                         	{
                                         		accLocal.isEnabled = false;
                                         	}
                                         }*/
                        listWrapperAccount.Add(accLocal);
                        listContacts.Add(accountLocal.Alternate_Email__pc);
                    }
                }
            }
            
        }


        if (listWrapperAccount.size() == 0)
        {
            SaveNoContactInfoLog(acc);

        }
        else
        {
            list<string> accids = GetAccIdsPopulated(accID, acc);
            system.debug('accids---' + accids);
            list<Account_Details__c> listAccountDetails = [select Id, Comments_Block__c,
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
            list<string> wcwList = new list<string>();
            if (listAccountDetails.Size() > 0)
            {
                Brand = listAccountDetails[0].Brand__c;


                for (Account_Details__c var: listAccountDetails)
                {

                    if (var.Comment_Block_01__c != NULL || var.Comment_Block_01__c != '')
                    {

                        wcwList.add(var.Comment_Block_01__c);
                    }
                    if (var.Comment_Block_02__c != NULL || var.Comment_Block_02__c != '')
                    {

                        wcwList.add(var.Comment_Block_02__c);
                    }
                    if (var.Comment_Block_03__c != NULL || var.Comment_Block_03__c != '')
                    {

                        wcwList.add(var.Comment_Block_03__c);
                    }
                    if (var.Comment_Block_04__c != NULL || var.Comment_Block_04__c != '')
                    {

                        wcwList.add(var.Comment_Block_04__c);
                    }
                    if (var.Comment_Block_05__c != NULL || var.Comment_Block_05__c != '')
                    {

                        wcwList.add(var.Comment_Block_05__c);
                    }
                    if (var.Comment_Block_06__c != NULL || var.Comment_Block_06__c != '')
                    {

                        wcwList.add(var.Comment_Block_06__c);
                    }
                    if (var.Comment_Block_07__c != NULL || var.Comment_Block_07__c != '')
                    {

                        wcwList.add(var.Comment_Block_07__c);
                    }
                    if (var.Comment_Block_08__c != NULL || var.Comment_Block_08__c != '')
                    {

                        wcwList.add(var.Comment_Block_08__c);
                    }
                    if (var.Comment_Block_09__c != NULL || var.Comment_Block_09__c != '')
                    {

                        wcwList.add(var.Comment_Block_09__c);
                    }
                    if (var.Comment_Block_10__c != NULL || var.Comment_Block_10__c != '')
                    {

                        wcwList.add(var.Comment_Block_10__c);
                    }
                    if (var.Comment_Block_11__c != NULL || var.Comment_Block_11__c != '')
                    {

                        wcwList.add(var.Comment_Block_11__c);
                    }
                    if (var.Comment_Block_12__c != NULL || var.Comment_Block_12__c != '')
                    {

                        wcwList.add(var.Comment_Block_12__c);
                    }
                    if (var.Comment_Block_13__c != NULL || var.Comment_Block_13__c != '')
                    {

                        wcwList.add(var.Comment_Block_13__c);
                    }
                    if (var.Comment_Block_14__c != NULL || var.Comment_Block_14__c != '')
                    {

                        wcwList.add(var.Comment_Block_14__c);
                    }
                    if (var.Comment_Block_15__c != NULL || var.Comment_Block_15__c != '')
                    {

                        wcwList.add(var.Comment_Block_15__c);
                    }
                    if (var.Comment_Block_16__c != NULL || var.Comment_Block_16__c != '')
                    {

                        wcwList.add(var.Comment_Block_16__c);
                    }
                    if (var.Comment_Block_17__c != NULL || var.Comment_Block_17__c != '')
                    {

                        wcwList.add(var.Comment_Block_17__c);
                    }
                    if (var.Comment_Block_18__c != NULL || var.Comment_Block_18__c != '')
                    {

                        wcwList.add(var.Comment_Block_18__c);
                    }
                    if (var.Comment_Block_19__c != NULL || var.Comment_Block_19__c != '')
                    {

                        wcwList.add(var.Comment_Block_19__c);
                    }
                    if (var.Comment_Block_20__c != NULL || var.Comment_Block_20__c != '')
                    {

                        wcwList.add(var.Comment_Block_20__c);
                    }
                }
                RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'OTP Authentication Log');
                if (wcwList.size() > 0)
                {
                    for (string str : wcwList)
                    {
                        if (str != null && str.Contains('TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS'))
                        {

                            Authenticated_Log__c log = new Authenticated_Log__c();
                            log.SalesforceID__c = acc.Id;
                            log.Member__c = acc.Id;
                            log.First_Name__c = acc.FirstName;
                            log.Last_Name__c = acc.LastName;
                            log.Staff_Name__c = UserInfo.getName();
                            log.Current_User__c = Userinfo.getuserid();
                            log.Decision__c = 'OTP – Not Eligible';
                            log.OTP_Decision__c = 'OTP – Not Eligible';
                            log.Member_Number__c = AccountNumber;
                            log.GUID__c = GUID;
                            log.IVR_GUID__c = IVRGUIDFromUrl;
                            log.RecordTypeId= rec.id;
                            insert log;
                            acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
                            update acc;
                            System.Debug('not eligible---' + acc.id);

                            IsIneligibleLocal = 'true';
							
							RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
       
						     List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
						     if(MasterAuthenticationLog.size() == 0)
						     {
						     	
						     	 Authenticated_Log__c log2 = new Authenticated_Log__c();
	                            log2.SalesforceID__c = acc.Id;
	                            log2.Member__c = acc.Id;
	                            log2.First_Name__c = acc.FirstName;
	                            log2.Last_Name__c = acc.LastName;
	                            log2.Staff_Name__c = UserInfo.getName();
	                            log2.Current_User__c = Userinfo.getuserid();
	                            log2.Decision__c = 'OTP – Not Eligible';
	                            log2.OTP_Decision__c = 'OTP – Not Eligible';
	                            log2.Member_Number__c = AccountNumber;
	                            log2.GUID__c = GUID;
	                            log2.IVR_GUID__c = IVRGUIDFromUrl;
	                            log2.RecordtypeId = rec1.id;
	                            insert log;
	                           						     	
						     }
						     else{
						     	
						     	MasterAuthenticationLog[0].SalesforceID__c = acc.Id;
	                            MasterAuthenticationLog[0].Member__c = acc.Id;
	                            MasterAuthenticationLog[0].First_Name__c = acc.FirstName;
	                            MasterAuthenticationLog[0].Last_Name__c = acc.LastName;
	                            MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
	                            MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
	                            MasterAuthenticationLog[0].Decision__c = 'OTP – Not Eligible';
	                            MasterAuthenticationLog[0].OTP_Decision__c = 'OTP – Not Eligible';
	                            MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
	                            MasterAuthenticationLog[0].GUID__c = GUID;
	                            update MasterAuthenticationLog[0];
						     	
						     }
							
							
							
							
                        }
                    }
                }


            }
        }
        List<KeyValuePairModelWithBit> listPhoneList = GetPhoneList_Options(listWrapperAccount);
        List<KeyValuePairModelWithBit> listEmailList = GetEmailsList_Options(listWrapperAccount);
        OTPVerificationModel obj = new OTPVerificationModel();
        obj.IsIneligible = 'false';
        obj.Brand = Brand;
        obj.PhoneList_Options = GetPhoneList_Options(listWrapperAccount);
		system.debug('obj.PhoneList_Options'+obj.PhoneList_Options);
        obj.EmailsList_Options = GetEmailsList_Options(listWrapperAccount);
        system.debug('obj.PhoneList_Options'+obj.EmailsList_Options);
        
        for(KeyValuePairModelWithBit value: obj.EmailsList_Options){
        	if(value.isEnabled == false){
       			obj.emailToShow = true;
       			break; 		
        	}	
        	else{
        		obj.emailToShow = false;
        	}
        }
        obj.LstMemid = GetMemList_Options(memid);
		system.debug('obj---' + obj);
        return obj;


    }
    @auraenabled
      public static void DeclineOTPAtFirstStep(string accid, String GUID, string IVRGUIDFromUrl)
    {
    	RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'OTP Authentication Log');
    	MemberOTPVerificationLightningController objMVLC = new MemberOTPVerificationLightningController();
        Account acc = objMVLC.GetAccount(accid);
        string  AccountNumber;
		List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:accid  limit 1];
         if(p.size() > 0){
        	 AccountNumber = p[0].Account_Number__r.Name;
         }
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.SalesforceID__c = acc.Id;
		log.Member__c = acc.Id;
        log.First_Name__c = acc.FirstName;
        log.Last_Name__c = acc.LastName;
		log.RecordTypeId= rec.id;
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.Decision__c = 'OTP – Contact Unconfirmed';
        log.OTP_Decision__c = 'OTP – Contact Unconfirmed';
        log.OTP_Status__c = 'Fail';
        log.Member_Number__c = AccountNumber;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        insert log;
        acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
        update acc;
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
       
		 List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
		 if(MasterAuthenticationLog.size() == 0)
		 {
		 	Authenticated_Log__c log2 = new Authenticated_Log__c();
	        log2.SalesforceID__c = acc.Id;
	        log2.RecordTypeid = rec1.id;
			log2.Member__c = acc.Id;
	        log2.First_Name__c = acc.FirstName;
	        log2.Last_Name__c = acc.LastName;
	        log2.Staff_Name__c = UserInfo.getName();
	        log2.Current_User__c = Userinfo.getuserid();
	        log2.Decision__c = 'OTP – Contact Unconfirmed';
	        log2.OTP_Decision__c = 'OTP – Contact Unconfirmed';
	        log2.OTP_Status__c = 'Fail';
	        log2.Member_Number__c = AccountNumber;
	        log2.GUID__c = GUID;
	        log2.IVR_GUID__c = IVRGUIDFromUrl;
	        insert log2;
		 }else{
			 	MasterAuthenticationLog[0].SalesforceID__c = acc.Id;
				MasterAuthenticationLog[0].Member__c = acc.Id;
		        MasterAuthenticationLog[0].First_Name__c = acc.FirstName;
		        MasterAuthenticationLog[0].Last_Name__c = acc.LastName;
		        MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
		        MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
		        MasterAuthenticationLog[0].Decision__c = 'OTP – Contact Unconfirmed';
		        MasterAuthenticationLog[0].OTP_Decision__c = 'OTP – Contact Unconfirmed';
		        MasterAuthenticationLog[0].OTP_Status__c = 'Fail';
		        MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
		        MasterAuthenticationLog[0].GUID__c = GUID;
		        update MasterAuthenticationLog[0];
		 }
        
        
        
    }
    private static void SaveNoContactInfoLog(Account acc)
    {
         string  AccountNumber;
         List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:acc.id  limit 1];
         if(p.size() > 0){
        	 AccountNumber = p[0].Account_Number__r.Name;
         }
          
        Authenticated_Log__c log = new Authenticated_Log__c();
        system.debug('SalesForceID =' + acc.Id);
        log.SalesforceID__c = acc.Id;
        log.Member__c = acc.Id;

        log.First_Name__c = acc.FirstName;
        log.Last_Name__c = acc.LastName;
        log.Staff_Name__c = UserInfo.getName();
        log.Member_Number__c = AccountNumber;
        System.debug('log No Contact Info ' + log);
       
		
        upsert log;
        log.Decision__c = 'OTP - No Contact Info';
        log.OTP_Decision__c = 'OTP - No Contact Info';
        update log;


    }


    public static string encryptPhone(string value)
    {
        value = 'xxx-xxx-' + value.right(4);

        return value;
    }
    public static string encryptEmail(string value)
    {

        List<String> listStr = value.split('@');

        string finalNumber = listStr[0].substring(0, 1) + '*****' + +listStr[0].substring(listStr[0].length() - 1, listStr[0].length()) + '@' + listStr[1];
        //= listStr[0].substring
        return finalNumber;
    }

    public class wrapperAccount
    {
        public string fieldName { get; set; }
        public string fieldType { get; set; }
        public string value { get; set; }
        public string encryptedvalue { get; set; }
		public boolean isEnabled {get; set;}
		public string MemberName{get;set;}
		public string MemberId{get;set;}
    }

    public class warningCodeWrapper
    {
        public string comms { get; set; }

        public warningCodeWrapper(string var)
        {
            comms = var;
        }
    }

    @auraenabled
    public static KeyValuePairModel GenerateRandomOTP(string fieldName, string BrandName, string resend, string accid, String GUID, string IVRGUIDFromUrl)
     {
	    RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'OTP Authentication Log');
		system.debug('AccountId in GenerateRandomOTP---' + accid);
        List<String> listStr = fieldName.split(' - ');
        string field = listStr[0];
        string accountid = listStr[1];
        string phone = '';
        string email = '';
        boolean IsEmail = false;
        Account accEmailTOSend = [select Id, Member_Verification_OTP_Invalid_Attempt__c, Home_Phone__pc, FirstName, LastName, Mobile_Phone__pc, Work_Phone__pc, PersonEmail, Alternate_Email__pc from Account where ID =: accountid];
        string AccountNumber;
        List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:accid limit 1];
          if(p.size() > 0){
        	 AccountNumber = p[0].Account_Number__r.Name;
         }

        if (field == 'Home_Phone__pc')

        {
            phone = accEmailTOSend.Home_Phone__pc;

        }
        else if (field == 'Mobile_Phone__pc')
        {
            phone = accEmailTOSend.Mobile_Phone__pc;

        }
        else if (field == 'Work_Phone__pc')
        {
            phone = accEmailTOSend.Work_Phone__pc;

        }
        else if (field == 'PersonEmail')
        {
            email = accEmailTOSend.PersonEmail;
            IsEmail = true;
        }
        else if (field == 'Alternate_Email__pc')
        {
            email = accEmailTOSend.Alternate_Email__pc;
            IsEmail = true;

        }
        //RandomNumber =  string.valueOf( Integer.valueof( Math.random() * 100000000));
        //RandomNumber = RandomNumber.left(6);
        
        

       string RandomNumber = String.valueOf(Math.random());
         RandomNumber= RandomNumber.substring(2,8);
         MemberOTPVerificationLightningController objMVLC = new MemberOTPVerificationLightningController();
		Account acc = objMVLC.GetAccount(accid);
		system.debug('Account in GenerateRandomOTP from GetAccount---' + acc);
        if(IsEmail)
        {
        	        
            SendOTPEmail(RandomNumber, email, BrandName, acc);

        }
        else
        {
            SendSMS(phone, string.valueof(RandomNumber), 'SMS - User', BrandName, acc);
        }
        
        system.debug('keyvaluemodel1---');
        KeyValuePairModel keyvaluemodel = new KeyValuePairModel();
        system.debug('keyvaluemodel2---' + keyvaluemodel ); 
        keyvaluemodel.Text = EncryptString(RandomNumber);
        keyvaluemodel.Value = EncryptString(string.valueof( system.now()));		
		
        system.debug('keyvaluemodel3---' + keyvaluemodel );
        system.debug('Firstname in GenerateRandomOTP ---' + acc.FirstName);
		system.debug('Lastname in GenerateRandomOTP ---' + acc.LastName);
         Authenticated_Log__c log = new Authenticated_Log__c();
         log.SalesforceID__c = acc.Id;
         log.RecordTypeId= rec.id;
         log.Member__c = acc.Id;
         log.First_Name__c = acc.FirstName;
         log.Last_Name__c = acc.LastName;
         log.Staff_Name__c = UserInfo.getName();
         log.Current_User__c = Userinfo.getuserid();
         log.GUID__c = GUID;
         log.IVR_GUID__c = IVRGUIDFromUrl;
         log.Member_Number__c = AccountNumber;
         if(IsEmail)
         {
           log.OTP_Email__c = email;
         }
         else
         {
             log.OTP_Phone__c = phone;
         }
         if(resend == 'true')
         {

             log.Decision__c = 'OTP – Code Resent';
			 log.OTP_Decision__c = 'OTP – Code Resent';

         }
         else
         {
             log.Decision__c = 'OTP – Code Sent';
             log.OTP_Decision__c = 'OTP – Code Sent';
         }
         system.debug('Log to be inserted in GenerateRandomOTP---' + log);
       insert log;
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
       
		 List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
		 if(MasterAuthenticationLog.size() == 0)
		 {
		 		Authenticated_Log__c log2 = new Authenticated_Log__c();
		         log2.SalesforceID__c = acc.Id;
		         log2.RecordTypeId= rec1.id;
		         log2.Member__c = acc.Id;
		         log2.First_Name__c = acc.FirstName;
		         log2.Last_Name__c = acc.LastName;
		         log2.Staff_Name__c = UserInfo.getName();
		         log2.Current_User__c = Userinfo.getuserid();
		         log2.GUID__c = GUID;
		         log2.IVR_GUID__c = IVRGUIDFromUrl;
		         log2.Member_Number__c = AccountNumber;
		         if(IsEmail)
		         {
		           log2.OTP_Email__c = email;
		         }
		         else
		         {
		             log2.OTP_Phone__c = phone;
		         }
		         if(resend == 'true')
		         {
		
		             log2.Decision__c = 'OTP – Code Resent';
					 log2.OTP_Decision__c = 'OTP – Code Resent';
		
		         }
		         else
		         {
		             log2.Decision__c = 'OTP – Code Sent';
		             log2.OTP_Decision__c = 'OTP – Code Sent';
		         }
		         system.debug('Log to be inserted in GenerateRandomOTP---' + log2);
		       insert log2;
		 	
		 }else{
		 	
		 	
		 		 MasterAuthenticationLog[0].SalesforceID__c = acc.Id;
		         MasterAuthenticationLog[0].RecordTypeId= rec1.id;
		         MasterAuthenticationLog[0].Member__c = acc.Id;
		         MasterAuthenticationLog[0].First_Name__c = acc.FirstName;
		         MasterAuthenticationLog[0].Last_Name__c = acc.LastName;
		         MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
		         MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
		         MasterAuthenticationLog[0].GUID__c = GUID;
		         MasterAuthenticationLog[0].IVR_GUID__c = IVRGUIDFromUrl;
		         MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
		         if(IsEmail)
		         {
		           MasterAuthenticationLog[0].OTP_Email__c = email;
		         }
		         else
		         {
		             MasterAuthenticationLog[0].OTP_Phone__c = phone;
		         }
		         if(resend == 'true')
		         {
		
		             MasterAuthenticationLog[0].Decision__c = 'OTP – Code Resent';
					 MasterAuthenticationLog[0].OTP_Decision__c = 'OTP – Code Resent';
		
		         }
		         else
		         {
		             MasterAuthenticationLog[0].Decision__c = 'OTP – Code Sent';
		             MasterAuthenticationLog[0].OTP_Decision__c = 'OTP – Code Sent';
		         }
		 		update MasterAuthenticationLog[0];
		 }
       
       
       system.debug('keyvaluemodel4---' + keyvaluemodel );
		return keyvaluemodel;

     }

	  
	@auraenabled
    public static string verifyOTP(string accid, string EnteredOTP, string fieldName, string model, String GUID,string IVRGUIDFromUrl)
    {
    	RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'OTP Authentication Log');
    	system.debug('AccountId in verifyOTP---' + accid);
    	system.debug('--verify OTP start--');
    	string fieldValue = fieldName;
    	List<String> listStr = fieldValue.split(' - ');
        string field = listStr[0];
        string accountid = listStr[1];
        string phone = '';
        string email = '';
        boolean IsEmail = false;
        Account accEmailTOSend = [select Id, Member_Verification_OTP_Invalid_Attempt__c, Home_Phone__pc, FirstName, LastName, Mobile_Phone__pc, Work_Phone__pc, PersonEmail, Alternate_Email__pc from Account where ID =: accountid];
        string  AccountNumber;
        List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:accountid limit 1];
        if(p.size() > 0)
        {
       	 AccountNumber = p[0].Account_Number__r.Name;
        }
		system.debug('field - ' + field);
		
        if (field == 'Home_Phone__pc')

        {
            phone = accEmailTOSend.Home_Phone__pc;

        }
        else if (field == 'Mobile_Phone__pc')
        {
            phone = accEmailTOSend.Mobile_Phone__pc;

        }
        else if (field == 'Work_Phone__pc')
        {
            phone = accEmailTOSend.Work_Phone__pc;

        }
        else if (field == 'PersonEmail')
        {
            email = accEmailTOSend.PersonEmail;
            IsEmail = true;
        }
        else if (field == 'Alternate_Email__pc')
        {
            email = accEmailTOSend.Alternate_Email__pc;
            IsEmail = true;

        }
    	system.debug('email - ' + email);
    	
		OTPSettings__c data1 = OTPSettings__c.getValues('Member Verification');
        integer OTPExpiresAfterSeconds = integer.valueOf(data1.OTPExpirationSeconds__c);
    	system.debug('OTPExpiresAfterSeconds - ' + OTPExpiresAfterSeconds);
    	
    	string Verified = '';
    	system.debug('DencryptString--- Start');
    	KeyValuePairModel newmodel = (KeyValuePairModel)JSON.deserialize(model, KeyValuePairModel.class);
    	
    	system.debug('decrypted date string - ' + DencryptString(newmodel.Value));
    	Datetime LastOTPSent =  Datetime.valueOf(DencryptString(newmodel.Value));
    	system.debug('DencryptString--- LastOTPSent' + LastOTPSent);
    	string RandomNumber = DencryptString(newmodel.Text);
    	system.debug('DencryptString--- RandomNumber' + RandomNumber);
    	MemberOTPVerificationLightningController objMVLC = new MemberOTPVerificationLightningController();
    	Account  acc =	objMVLC.GetAccount(accid);
    	system.debug('Account in verifyOTP from GetAccount---' + acc);
    	system.debug('Firstname in verifyOTP ---' + acc.FirstName);
		system.debug('Lastname in verifyOTP ---' + acc.LastName);
        Long startTime = LastOTPSent.getTime();
        Long endTime = System.Now().getTime();
        Long milliseconds = endTime - startTime;
        Long seconds = milliseconds / 1000;
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.SalesforceID__c = acc.Id;
        log.RecordTypeId =  rec.id;
        log.Member__c = acc.Id;
        log.First_Name__c = acc.FirstName;
        log.Last_Name__c = acc.LastName;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        log.Member_Number__c = AccountNumber;
        if(IsEmail)
        {
          log.OTP_Email__c = email;
        }
        else
        {
            log.OTP_Phone__c = phone;
        }
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        system.debug('seconds ---' + seconds);
        system.debug('OTPExpiresAfterSeconds ---' + OTPExpiresAfterSeconds);
        if(seconds >= OTPExpiresAfterSeconds)
        {
            Verified = 'Expired';
            acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
            update acc;
            log.Decision__c = 'OTP – Code Expired';
            log.OTP_Decision__c = 'OTP – Code Expired';
        
        }
        else if(EnteredOTP == RandomNumber)
        {
            //acc.Member_Verification_OTP_Invalid_Attempt__c = null;
            //update acc;
            log.Decision__c = 'OTP – Code Valid';
            log.OTP_Decision__c = 'OTP – Code Valid';
            log.OTP_Status__c = 'Pass';
            Verified = 'Valid';
        }
        else
        {
            acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
            update acc;
            log.Decision__c = 'OTP – Code Failed';
            log.OTP_Decision__c = 'OTP – Code Failed';
            log.OTP_Status__c = 'Fail';
            Verified = 'Invalid';
        }
        
        system.debug('Log to be inserted in verifyOTP---' + log);
        insert log;
        
         RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
       
		 List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
		 if(MasterAuthenticationLog.size() == 0)
		 {
		 	  	Authenticated_Log__c log2 = new Authenticated_Log__c();
		        log2.SalesforceID__c = acc.Id;
		        log2.RecordTypeId =  rec1.id;
		        log2.Member__c = acc.Id;
		        log2.First_Name__c = acc.FirstName;
		        log2.Last_Name__c = acc.LastName;
		        log2.GUID__c = GUID;
		        log2.IVR_GUID__c = IVRGUIDFromUrl;
		        log2.Member_Number__c = AccountNumber;
		        if(IsEmail)
		        {
		          log2.OTP_Email__c = email;
		        }
		        else
		        {
		            log2.OTP_Phone__c = phone;
		        }
		        log2.Staff_Name__c = UserInfo.getName();
		        log2.Current_User__c = Userinfo.getuserid();
		        if(seconds >= OTPExpiresAfterSeconds)
		        {
		            log2.Decision__c = 'OTP – Code Expired';
		            log2.OTP_Decision__c = 'OTP – Code Expired';
		        
		        }
		        else if(EnteredOTP == RandomNumber)
		        {
		            log2.Decision__c = 'OTP – Code Valid';
		            log2.OTP_Decision__c = 'OTP – Code Valid';
		            log2.OTP_Status__c = 'Pass';
		        }
		        else
		        {
		            log2.Decision__c = 'OTP – Code Failed';
		            log2.OTP_Decision__c = 'OTP – Code Failed';
		            log2.OTP_Status__c = 'Fail';
		        }
		        
		        system.debug('Log to be inserted in verifyOTP---' + log);
		        insert log2;
		 }else{
		 	
		 		MasterAuthenticationLog[0].SalesforceID__c = acc.Id;
		        MasterAuthenticationLog[0].Member__c = acc.Id;
		        MasterAuthenticationLog[0].First_Name__c = acc.FirstName;
		        MasterAuthenticationLog[0].Last_Name__c = acc.LastName;
		        MasterAuthenticationLog[0].GUID__c = GUID;
		        MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
		        if(IsEmail)
		        {
		          MasterAuthenticationLog[0].OTP_Email__c = email;
		        }
		        else
		        {
		            MasterAuthenticationLog[0].OTP_Phone__c = phone;
		        }
		        MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
		        MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
		        if(seconds >= OTPExpiresAfterSeconds)
		        {
		            MasterAuthenticationLog[0].Decision__c = 'OTP – Code Expired';
		            MasterAuthenticationLog[0].OTP_Decision__c = 'OTP – Code Expired';
		        
		        }
		        else if(EnteredOTP == RandomNumber)
		        {
		            MasterAuthenticationLog[0].Decision__c = 'OTP – Code Valid';
		            MasterAuthenticationLog[0].OTP_Decision__c = 'OTP – Code Valid';
		            MasterAuthenticationLog[0].OTP_Status__c = 'Pass';
		        }
		        else
		        {
		            MasterAuthenticationLog[0].Decision__c = 'OTP – Code Failed';
		            MasterAuthenticationLog[0].OTP_Decision__c = 'OTP – Code Failed';
		            MasterAuthenticationLog[0].OTP_Status__c = 'Fail';
		        }
		        
		        system.debug('Log to be inserted in verifyOTP---' + log);
		        update MasterAuthenticationLog[0];
		 }
        
        
        
        
        
        return Verified;
        
    }
     
	  
	  
    private static void SendOTPEmail(string OTP, string ToEmail, string Brand, Account acc)
    { 
    	system.debug('SendOTPEmail Called##');
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        system.debug('ToEmail##'+ToEmail);
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
        mail.setOrgWideEmailAddressId(listAdd[0].Id);
        mails.add(mail);
        system.debug('EMAIL##'+ listAdd[0].Id);
         system.debug('EMAILBODY##'+ body);
        Messaging.sendEmail(mails);
        system.debug('OTPmails##'+ mails);
        
    }

    private static void SendSMS(string phone, string message, string Name, string Brand, Account acc )
    {
        List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        String senderId = 'CreditUnion';
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c = 'CreditUnion';
        string emailadd;
        if (Brand == 'Spectrum')
        {
            emailadd = 'SpectrumSMS';
        }
        else
        {
            emailadd = 'ChevronSMS';
        }
        list<smagicinteract__SMS_Template__c> listTemplate =  [select Id, smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__Name__c =: emailadd];

        smsObject.smagicinteract__PhoneNumber__c = phone;
        smsObject.smagicinteract__Name__c = Name; // records name
        smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        if (listTemplate.size() > 0)
        {
            smsObject.smagicinteract__SMSText__c = listTemplate[0].smagicinteract__Text__c.replace('$MemberName', acc.FirstName + '  ' + acc.LastName).replace('$OTP_CODE', message);
        }
        smsObjectList.add(smsObject);
        Database.insert(smsObjectList, false);
       // LastOTPSent = System.Now();

    }
	private static string EncryptString(string plaindata)
	{
		 Blob cryptoKey = Blob.valueOf('39955410e8b11fa9');
		 
		 Blob data = Blob.valueOf(plaindata);
         Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey , data );
         String b64Data = EncodingUtil.base64Encode(encryptedData);

		return b64Data;
	}
    private static string DencryptString(string encrypteddata)
	{
		Blob cryptoKey = Blob.valueOf('39955410e8b11fa9');
		
  		 Blob data = EncodingUtil.base64Decode(encrypteddata);
         Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey , data);
         String dryptData = decryptedData.toString();
         System.debug('Printing dryptData '+dryptData);
         
         return dryptData;
	}
	
	
	 public static boolean isContactEnabled(string FieldValue, string FieldName, string accountid,  List<accounthistory> listhistory, List<accounthistory> listhistoryOlder, boolean phone)
    {
    	    Set<String> contactFields = new Set<string>{ 'Mobile_Phone__pc','Home_Phone__pc','Work_Phone__pc'};
    	    
    	    
    	    if(!phone )
    	    {
    	    	contactFields = new Set<string>{ 'PersonEmail','Alternate_Email__pc'};
    	    	
    	    }
    	    
    	    boolean CurrentFieldUpdatedIn60Days = false;
	    	for(accounthistory accHistory : listhistory)
	    	{
	    		
	    		if(accHistory.accountid == accountid && FieldName == accHistory.Field)
	    		{
	    			CurrentFieldUpdatedIn60Days = true;
	    		}
	    	}
	    	if(!CurrentFieldUpdatedIn60Days)
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
	
	@auraenabled
	public static double CancelOTP(string accid, String GUID, string fieldName, string IVRGUIDFromUrl)
	{
		 Double OTPAttemptCount;
		 List<Member_Verification_Attempt__c> mt1 = [Select id,Member_Name__c,Authentication_Type__c,OTP_Cancelled_Attempt__c, Member_Salesforce_Id__c, Number_of_Attempts__c
						 from Member_Verification_Attempt__c where Member_Salesforce_Id__c =:accid and CreatedDate = Today limit 1];
	    if(mt1.size() > 0)
	    {
	    	OTPAttemptCount = mt1[0].OTP_Cancelled_Attempt__c;
	    }
	    else{OTPAttemptCount=0;}
		
		Account acc = [select Id, Member_Verification_OTP_Invalid_Attempt__c, Home_Phone__pc, FirstName, LastName, Mobile_Phone__pc, Work_Phone__pc, PersonEmail, Alternate_Email__pc from Account where ID =: accid];
		 string  AccountNumber;
		List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                FROM Person_Account__c where PersonID__c =:accid limit 1];
        if(p.size() > 0)
        {
        	AccountNumber = p[0].Account_Number__r.Name;
        }
		string fieldValue = fieldName;
		string field = '';
		string accountid ='';
		if(fieldValue.length() > 0)
		{
	    	List<String> listStr = fieldValue.split(' - ');
	        field = listStr[0];
	        accountid = listStr[1];
		}
        string phone = '';
        string email = '';
        boolean IsEmail = false;
        
		system.debug('field - ' + field);
		
        if (field == 'Home_Phone__pc')
        {
            phone = acc.Home_Phone__pc;
        }
        else if (field == 'Mobile_Phone__pc')
        {
            phone = acc.Mobile_Phone__pc;
        }
        else if (field == 'Work_Phone__pc')
        {
            phone = acc.Work_Phone__pc;
        }
        else if (field == 'PersonEmail')
        {
            email = acc.PersonEmail;
            IsEmail = true;
        }
        else if (field == 'Alternate_Email__pc')
        {
            email = acc.Alternate_Email__pc;
            IsEmail = true;
        }		
		RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'OTP Authentication Log');
		Authenticated_Log__c log = new Authenticated_Log__c();
        log.SalesforceID__c = acc.Id;
        log.RecordtypeId = rec.Id;
        log.Member__c = acc.Id;
        log.First_Name__c = acc.FirstName;
        log.Last_Name__c = acc.LastName;
        if(IsEmail)
        {
          log.OTP_Email__c = email;
        }
        else
        {
            log.OTP_Phone__c = phone;
        }
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
		log.Decision__c = 'OTP – Code Not Provided';
		log.OTP_Decision__c = 'OTP – Code Not Provided';
		log.GUID__c = GUID;
		log.IVR_GUID__c = IVRGUIDFromUrl; 
		log.Member_Number__c = AccountNumber;
		insert log;			
		acc.Member_Verification_OTP_Invalid_Attempt__c = system.now();
        update acc;
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
       
		 List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
		 if(MasterAuthenticationLog.size() == 0)
		 {
		 	Authenticated_Log__c log2 = new Authenticated_Log__c();
	        log2.SalesforceID__c = acc.Id;
	        log2.recordTypeId = rec1.id;
	        log2.Member__c = acc.Id;
	        log2.First_Name__c = acc.FirstName;
	        log2.Last_Name__c = acc.LastName;
	        if(IsEmail)
	        {
	          log2.OTP_Email__c = email;
	        }
	        else
	        {
	            log2.OTP_Phone__c = phone;
	        }
	        log2.Staff_Name__c = UserInfo.getName();
	        log2.Current_User__c = Userinfo.getuserid();
			log2.Decision__c = 'OTP – Code Not Provided';
			log2.OTP_Decision__c = 'OTP – Code Not Provided';
			log2.GUID__c = GUID;
			log2.IVR_GUID__c = IVRGUIDFromUrl; 
			log2.Member_Number__c = AccountNumber;
			insert log2;	
		 }else
		 {
		 	MasterAuthenticationLog[0].SalesforceID__c = acc.Id;
	        MasterAuthenticationLog[0].recordTypeId = rec1.id;
	        MasterAuthenticationLog[0].Member__c = acc.Id;
	        MasterAuthenticationLog[0].First_Name__c = acc.FirstName;
	        MasterAuthenticationLog[0].Last_Name__c = acc.LastName;
	        if(IsEmail)
	        {
	          MasterAuthenticationLog[0].OTP_Email__c = email;
	        }
	        else
	        {
	            MasterAuthenticationLog[0].OTP_Phone__c = phone;
	        }
	        MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
	        MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
			MasterAuthenticationLog[0].Decision__c = 'OTP – Code Not Provided';
			MasterAuthenticationLog[0].OTP_Decision__c = 'OTP – Code Not Provided';
			MasterAuthenticationLog[0].GUID__c = GUID;
			MasterAuthenticationLog[0].IVR_GUID__c = IVRGUIDFromUrl; 
			MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
		 	update MasterAuthenticationLog[0];
		 }
        
        
        return OTPAttemptCount; 
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
	
	@AuraEnabled
    
   
     public static map<string,object> GetOTPLogForReload(string memberid, string IVRGUIDFromUrl, boolean IsUserSessionLoaded, boolean IsReLoadRequired)
     {
     	system.debug('IVRGUIDFromUrl##' + IVRGUIDFromUrl);
     	system.debug('IsUserSessionLoaded##' + IsUserSessionLoaded);
     	system.debug('IsReLoadRequired##' + IsReLoadRequired);
     	map<string,object> resultLog = new map<string,object>();
     	integer minutes = GetMemberAuthenticationSessionTime();
     	string Verified;
     	String CurrentUser = UserInfo.getUserId();
     	RecordType OTPRec = [select Id,Name,SobjectType from RecordType where Name ='OTP Authentication Log' and SobjectType='Authenticated_Log__c' limit 1];
     	List<Authenticated_Log__c> OTPLogData = new List<Authenticated_Log__c>();
     	OTPLogData = [SELECT ID, Decision__c, OTP_Email__c,OTP_Phone__c,OTP_Status__c
							 FROM Authenticated_Log__c where SalesforceID__c =:memberid and RecordTypeId=: OTPRec.Id and createddate =today];
     	system.debug('OTPLogDataSize##' + OTPLogData.size());
     	if(OTPLogData.size() == 0)
     	{
     		//return resultLog;
     	}else{
     		
     		if(IsUserSessionLoaded == false && IsReLoadRequired == false)
     		{
     			OTPLogData = [SELECT ID, Decision__c, OTP_Email__c,OTP_Phone__c,OTP_Status__c
					 FROM Authenticated_Log__c where SalesforceID__c =:memberid AND CreatedDate = today  and RecordTypeId=: OTPRec.Id and Decision__c = 'OTP – Code Failed'];
				for(Authenticated_Log__c log: OTPLogData)
		        {	        	
		        	if(log.Decision__c == 'OTP – Code Failed')
		        	{
		        		Verified = 'Invalid';
		        	}
		        }
		        resultLog.put('Verified', Verified);          			  
	     		
     		}
     		else if(IsUserSessionLoaded == true && IsReLoadRequired == false){
     			
     				OTPLogData = [SELECT ID, Decision__c, OTP_Email__c,OTP_Phone__c,OTP_Status__c
							 FROM Authenticated_Log__c where SalesforceID__c =:memberid AND Current_User__c=: CurrentUser AND  IVR_GUID__c =:IVRGUIDFromUrl and RecordTypeId=: OTPRec.Id order by createddate desc];
							 system.debug('OTPLogData1##' + OTPLogData);
					for(Authenticated_Log__c log: OTPLogData)
			        {
			        	if(log.Decision__c == 'OTP – Code Expired')
			        	{
			        		Verified = 'Expired';
			        	}
			        	if( log.Decision__c == 'OTP – Code Valid')
			        	{
			        		 Verified = 'Valid';
			        	}
			        	if(log.Decision__c == 'OTP – Code Failed')
			        	{
			        		Verified = 'Invalid';
			        	}
			        }
			        resultLog.put('Verified', Verified);
		            system.debug('OTPLogData2##' + OTPLogData);		  
		     		
     		}
     		else if(IsUserSessionLoaded == false && IsReLoadRequired == true){
     			 	OTPLogData = [SELECT ID, Decision__c, OTP_Email__c,OTP_Phone__c,OTP_Status__c
							 FROM Authenticated_Log__c where SalesforceID__c =:memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl and RecordTypeId=: OTPRec.Id];
					if(OTPLogData.size()==0)
					{
						OTPLogData = [SELECT ID, Decision__c, OTP_Email__c,OTP_Phone__c,OTP_Status__c
							 FROM Authenticated_Log__c where SalesforceID__c =:memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) and RecordTypeId=: OTPRec.Id];
					}
					for(Authenticated_Log__c log: OTPLogData)
				        {
				        	if(log.Decision__c == 'OTP – Code Expired')
				        	{
				        		Verified = 'Expired';
				        	}
				        	if( log.Decision__c == 'OTP – Code Valid')
				        	{
				        		 Verified = 'Valid';
				        	}
				        	if(log.Decision__c == 'OTP – Code Failed')
				        	{
				        		Verified = 'Invalid';
				        	}
				        }
				        resultLog.put('Verified', Verified);
			          	 system.debug('OTPLogData3##' + OTPLogData);		  
			     		
     		}
     		system.debug('resultLog##' + resultLog);
     		//return resultLog; 
     	}
     	system.debug('resultLog##' + resultLog);
    	return resultLog;
     }
	
 	@AuraEnabled
 	
     public static RecordType GetRecordTypeData(string sobjecttype, string RecordTypeName )
     {
     	RecordType rec = [Select id, Name, sobjecttype from RecordType where sobjecttype=: sobjecttype and Name=:RecordTypeName];
     	return rec;
     }
    @AuraEnabled
     public static List<Authenticated_Log__c> GetDataForMasterAuthenticationLog(string IVRGuid, Id RecordTypeId )
     {
     	List<Authenticated_Log__c> AuthLog = [Select Id, Name, RecordTypeId, IVR_Sent_URL__c,CallerPhoneNumber__c,EnteredMemberNumber__c,EnteredSSN__c, Failed_Desired_Level__c,
     	EnteredCardNumber__c,CardNumberMatch__c,PhoneNumberMatch__c, MemberNumberMatch__c, SSNnumberMatch__c,
		IVR_SSN__c,IVR_Card_Number__c,IVR_Member_Number__c,IVR_Member_Number_Match__c,IVR_SSN_Match__c,IVR_Card_Match__c,
		IVR_Pin_Match__c,PINMatch__c,HP_HV__c,IVR_Code__c,
     	Override_Request_Supervisor__c,Override_Supervisor__c,Override_Request_Type__c,
     	OOW_Status__c,OOW_Member_Number__c,OOW_Reason__c,OOW_Notes__c,First_Name__c,Last_Name__c,
     	Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c,
     	CFCU_Wallet_Status__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Loan_Detail_Match__c,
     	Decision__c,SalesforceID__c,Member__c,Member_Number__c,Staff_Name__c,Current_User__c,GUID__c,IVR_GUID__c from Authenticated_Log__c where IVR_GUID__c= :IVRGuid and RecordTypeId=:RecordTypeId];
     	return AuthLog;
     } 
}