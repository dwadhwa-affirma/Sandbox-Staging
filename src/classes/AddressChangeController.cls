public class AddressChangeController {
	
	 public class AccountList360
    {
        public string Id {get;set;}
        public string Name {get;set;}
        public string RecType {get;set;}
        public string TypeTranslate {get;set;}
        public string ID1 {get;set;}
        
        public string Brand {get;set;}
        public string Combined_Account_ID {get;set;}
        public string Loan_Number {get;set;}
        public Date Close_Date {get;set;}
        public string Card_Number_Last_4_Digits {get;set;}
        public Date OPEN_DATE {get;set;}
        public Date  Expiration_Date {get;set;}
        public date Issue_Date {get;set;}
        public string Emp_Available_Balance {get;set;}
        public decimal Available_Balance {get;set;}
        public string Emp_Balance {get;set;}
        
        public decimal Balance {get;set;}
        public string Relationship {get;set;}
        
        
    }
    
    public class Member360View
    {
        @AuraEnabled
        public object accList {get;set;}
        @AuraEnabled
        public integer totalrecords {get;set;}
    }
    
	
@AuraEnabled
    public static Map<string, object> GetAllData(string accid)
    {
        Integer PageNo = 1,  PageSize = 10;
        Account acc = [SELECT Id, Name from Account where id =: accid];
        list<Person_Account__c> paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:accId];
        
        
        
        List<string> accountNumberSet = new List<string>();
        List<string> accIdset = new List<string>();
        List<string> acctypeSet = new List<string>();
        Map<string,string> listRelationships = new  Map<string,string>(); 
        Map<string,string> listRelationshipsName = new  Map<string,string>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
            listRelationships.put(var.Account_Number__c,var.TypeTranslate__c);
            listRelationshipsName.put(var.Account_Number__r.Name,var.TypeTranslate__c);
        }
        
       
       
        Map<string, object> m = new Map<string, object>();
        
        
        system.debug('listRelationships++ GetAllData+++++' + listRelationships);
        system.debug('listRelationshipsName++ GetAllData++' + listRelationshipsName);
        system.debug('acctypeSet++ GetAllData++' + acctypeSet);
        system.debug('accountNumberSet++ GetAllData++' + accountNumberSet);
        system.debug('accIdset++ GetAllData++' + accIdset);
        
        Object accList =  GetAccList(listRelationships,listRelationshipsName,acctypeSet, accountNumberSet, accIdset, 1, 1000, '', '', '');
        
        Member360View localAcc =    (Member360View)accList;
        List<Account_Details__c> listACCList = (List<Account_Details__c>)localAcc.accList;
        List<String> accountNumberSetWOBeneficiary = new List<String>();
        List<String> accIdSetWOBeneficiary = new List<String>();
        
        for(Account_Details__c item: listACCList)
        {
            accountNumberSetWOBeneficiary.add(item.Name);
            accIdSetWOBeneficiary.add(item.id);
            
        }
		

        Object accList1 =  GetAccList(listRelationships,listRelationshipsName,acctypeSet, accountNumberSet, accIdset, PageNo, PageSize, '', '', '');
                 
     
        
        Member360View test = (Member360View)accList1;
        List<sObject> sobjList =  (List<sObject>)test.accList;      
        
        set<string> AccountNames= new set<string>();
                
        for(sObject so:sobjList){
        	AccountNames.add((string)so.get('Name'));
         	system.debug('Test=='+(string)so.get('Name'));         	
         }

		m.put('accList', AccountNames);
        m.put('MemberName',acc.Name);
        return m;
    }
    
    private static object GetAccList(Map<string,string> listRelationships,Map<string,string> listRelationshipsName,   List<string> acctypeSet, List<string> accountNumberSet, 
            List<string> accIdset,Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
    {
         Integer PageSize_Local = Integer.Valueof( PageSize);
        Integer PageNo_Local = Integer.Valueof( PageNo);
        string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
            orderString = ' Order by ' + SortBy + ' ' + SortDir;    
            
        }        
        
      
        string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
            AggregateResult[] ARs;
        list<Account_Details__c>  accList = new list<Account_Details__c>();
        string SOQLQuery = '';
        string searchquery = '';
        boolean isDate = false;
        Date dtSearchText;
        if(SearchText != '')
        {
            try{
                dtSearchText = Date.Parse(SearchText);
                string month = string.valueOf(dtSearchText.month());
                string date1 = string.valueOf(dtSearchText.day());
                if(dtSearchText.month() <=9)
                    month = '0' + string.valueOf(dtSearchText.month());
                if(dtSearchText.day() <= 9)
                    date1 = '0' + string.valueOf(dtSearchText.day());
                SearchText = string.valueOf(dtSearchText.year()) + '-' + month + '-' + date1;
                
                searchquery +=  '(Name LIKE \'%' + SearchText + '%\' or RecType__c LIKE \'%' + SearchText + '%\' or Brand__c LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or ID1__c LIKE \'%' + SearchText + '%\' or Loan_Number__c LIKE \'%' + SearchText + '%\' or Emp_Available_Balance__c LIKE  \'%' + SearchText + '%\' or Emp_Balance__c LIKE \'%' + SearchText + '%\' or Close_Date__c = '+SearchText+' or  OPEN_DATE__c = '+ SearchText+')';
                isDate = true;
            }
            catch(Exception ex){
                searchquery += '(Name LIKE \'%' + SearchText + '%\' or RecType__c LIKE \'%' + SearchText + '%\' or Brand__c LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or ID1__c LIKE \'%' + SearchText + '%\' or Loan_Number__c LIKE \'%' + SearchText + '%\' or Emp_Available_Balance__c LIKE  \'%' + SearchText + '%\' or Emp_Balance__c LIKE \'%' + SearchText + '%\')';
            }
        }
        
        if(true){
            
            if(searchquery.length() > 0)
            {
                 SOQLQuery = 'SELECT Id, ' +
                               ' Name, ' +
                              ' RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c WHERE Name IN (\'' + string.join(accountNumberSet,'\',\'') +  '\') and RecType__c != \'CARD\' and ' + searchquery + ' ' +  orderString;
                  string temp = '%' + SearchText + '%';
                  ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp)];
                  if(isDate)
                    ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp or Close_Date__c =: dtSearchText or OPEN_DATE__c =: dtSearchText)];
            }
            else
            {
                SOQLQuery = 'SELECT Id, ' +
                               ' Name, ' +
                              ' RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c WHERE Name IN (\'' + string.join(accountNumberSet,'\',\'') +  '\') and RecType__c != \'CARD\' ' +  orderString;
                ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD'];
            }
            
        }else{
            
            if(searchquery.length() > 0)
            {
                SOQLQuery = ' SELECT Id, ' +
                              ' Name, ' +
                              '  RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c Where Id IN (\'' + string.join(accIdSet,'\',\'') +  '\') and RecType__c != \'CARD\' and ' + searchquery + ' ' +  orderString;
                
                string temp = '%' + SearchText + '%';               
                ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Id IN:accIdSet and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp)];
                if(isDate)
                    ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp or Close_Date__c =: dtSearchText or OPEN_DATE__c =: dtSearchText)];
            }
            else
            {
                SOQLQuery = ' SELECT Id, ' +
                              ' Name, ' +
                              '  RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c Where Id IN (\'' + string.join(accIdSet,'\',\'') +  '\') and RecType__c != \'CARD\' ' +  orderString;
                                
                ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Id IN:accIdSet and RecType__c != 'CARD'];
            }
            
        }
        
        
        
        List<sObject> sobjList = Database.query(SOQLQuery);
        
        List<AccountList360> listAccountList360 = new List<AccountList360>();
        List<String> AccountListIdSet = new List<String>();
        
        for(sObject acc1 : sobjList)
        {
            Account_Details__c acc = (Account_Details__c)acc1;
            
            AccountList360 obj = new AccountList360();
            obj.Id = acc.Id;
            obj.Name = acc.Name;
            obj.RecType = acc.RecType__c;
            obj.TypeTranslate = acc.TypeTranslate__c;
            obj.Balance = acc.Balance__c;
            obj.ID1 = acc.ID1__c;
            obj.Combined_Account_ID = acc.Combined_Account_ID__c;
            
            obj.Card_Number_Last_4_Digits = acc.Card_Number_Last_4_Digits__c;
            obj.Combined_Account_ID = acc.Combined_Account_ID__c;
            obj.Loan_Number = acc.Loan_Number__c;
            obj.Brand = acc.Brand__c;
            obj.Loan_Number = acc.Loan_Number__c;
            obj.Close_Date = acc.Close_Date__c;
            obj.Expiration_Date = acc.Expiration_Date__c;
            obj.OPEN_DATE = acc.OPEN_DATE__c;
            obj.Issue_Date = acc.Issue_Date__c;
            obj.Emp_Balance = acc.Emp_Balance__c;
            obj.Emp_Available_Balance = acc.Emp_Available_Balance__c;
            obj.Available_Balance = acc.Available_Balance__c;
            if(true){
                obj.Relationship = listRelationshipsName.get(obj.Name);         
                
            }
            else
            {
                obj.Relationship = listRelationships.get(obj.Id);
            }
            
            
            if(obj.Relationship != null && !obj.Relationship.contains('Beneficiary'))
            {
                listAccountList360.add(obj);
                AccountListIdSet.Add(obj.Id);   
                accList.add(acc);
            }    
        
        }
        
      
      if(AccountListIdSet.size() > 0)
      {  
      
                SOQLQuery = ' SELECT Id, ' +
                              ' Name, ' +
                              '  RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Card_Name__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c Where Id IN (\'' + string.join(AccountListIdSet,'\',\'') +  '\') ' +  orderString + ' LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
                                
              sobjList = Database.query(SOQLQuery);
                
                for(sObject acc : sobjList)
                {
                     Account_Details__c acc1 = (Account_Details__c)acc;
                    
                    if(true){
                        acc1.Card_Name__c = listRelationshipsName.get(acc1.Name);           
                        
                    }
                    else
                    {
                        acc1.Card_Name__c = listRelationships.get(acc1.Id);
                    }
                    
                }
                
                Member360View test = new Member360View();
                test.accList = sobjList;
                test.totalrecords = AccountListIdSet.size();
                
                
                return test;
     
      } 
      else
      {
         Member360View test = new Member360View();
            test.accList = new List<Account_Details__c>();
            
            
                test.totalrecords = 0;
                return test;
        
      }
        
        
       
    
    }
    
}