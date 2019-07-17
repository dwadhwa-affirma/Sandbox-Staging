public class MemberAccountWrapperFor360ViewController {
	@AuraEnabled
    public static Map<string, object> GetAllData(string accid)
    {
    	Integer PageNo = 1,  PageSize = 10;
    	Account_Details__c accDRec = [Select Id, Name from Account_Details__c where Id=:accid Limit 1];
        System.debug('Parent Account Id is::::'+accDRec); 
    	   	
       
        Map<string, object> m = new Map<string, object>();
        Object accList =  GetAccList(accDRec.Name, PageNo, PageSize, '', '', '');
       	m.put('accList', accList);
       	
       	Object cardList = GetCardList(accDRec.Name,PageNo,PageSize, '', '', '');
       	m.put('cardList', cardList);
       
       	Object contactlist = GetContactDetails(accDRec.Name,PageNo,PageSize, '', '', '');
       	m.put('contactList', contactlist);
        
        Object activecaselist = GetActiveCaseDetails(accDRec.Name,PageNo,PageSize, '', '', '');
        m.put('activecaseList', activecaselist);
        	
        Object closecaselist = GetCloseCaseDetails(accDRec.Name,PageNo,PageSize, '', '', '');
        m.put('closecaseList', closecaselist);
        
        Object commentslist = GetCaseComments(accDRec.Name,PageNo,PageSize, '', '', '');
        m.put('commentslist', commentslist);
        
        Object taskList = GetActiveTasksDetails(accDRec.Name,PageNo,PageSize, '', '', '');
        m.put('taskList', taskList);  
        
        Object warningList = GetWarningCodeDetails(accDRec.Name,PageNo,PageSize, '', '', '');
        m.put('warningList', warningList);
        return m;
    }
    
    
	@AuraEnabled
	public static Map<string, object> GetPagingData(string accid,Integer PageNo, Integer PageSize, String SectionName, string SortBy, string SortDir,string SearchText)
	{
		Map<string, object> m = new Map<string, object>();
		Account_Details__c accDRec = [Select Id, Name from Account_Details__c where Id=:accid Limit 1];
        System.debug('Parent Account Id is::::'+accDRec); 
        
        if(SectionName == 'accList')
        {
	    	Object accList =  GetAccList(accDRec.Name, PageNo, PageSize, SortBy, SortDir,SearchText);	       
	       m.put('accList', accList);		
        }
        if(SectionName == 'cardList')
        {
        	Object cardList = GetCardList(accDRec.Name,PageNo,PageSize, SortBy,  SortDir,SearchText);
        	m.put('accList', cardList);
        }
        if(SectionName == 'related persons')
        {
        	Object contactlist = GetContactDetails(accDRec.Name,PageNo,PageSize, SortBy,  SortDir,SearchText);
        	m.put('accList', contactlist);
        }
        if(SectionName == 'active cases')
        {
        	Object activecaselist = GetActiveCaseDetails(accDRec.Name,PageNo,PageSize,SortBy,SortDir,SearchText);
        	m.put('accList', activecaselist);
        }       
         if(SectionName == 'close cases')
        {
        	Object closecaselist = GetCloseCaseDetails(accDRec.Name,PageNo,PageSize,SortBy,SortDir,SearchText);
        	m.put('accList', closecaselist);
        }
        if(SectionName == 'Case Comments')
        {
        	Object casecomments = GetCaseComments(accDRec.Name,PageNo,PageSize,SortBy,SortDir,SearchText);
        	m.put('accList', casecomments);
        }
        if(SectionName == 'Active Tasks')
        {
        	Object taskList = GetActiveTasksDetails(accDRec.Name,PageNo,PageSize,SortBy,SortDir,SearchText);
        	m.put('accList', taskList);
        }       	
        if(SectionName == 'Warning/Comments')
        {
        	Object warningList = GetWarningCodeDetails(accDRec.Name,PageNo,PageSize,SortBy,SortDir,SearchText);
        	m.put('accList', warningList);
        }
       
		return m;	
	
	}	
	
	private static object GetAccList(String accRecName,Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
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
        		system.debug('string convered to date!');
        		searchquery +=  '(Name LIKE \'%' + SearchText + '%\' or RecType__c LIKE \'%' + SearchText + '%\' or Brand__c LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or ID1__c LIKE \'%' + SearchText + '%\' or Loan_Number__c LIKE \'%' + SearchText + '%\' or Emp_Available_Balance__c LIKE  \'%' + SearchText + '%\' or Emp_Balance__c LIKE \'%' + SearchText + '%\' or Close_Date__c = '+SearchText+' or  OPEN_DATE__c = '+ SearchText+')';
        		isDate = true;
        	}
        	catch(Exception ex){
        		searchquery += '(Name LIKE \'%' + SearchText + '%\' or RecType__c LIKE \'%' + SearchText + '%\' or Brand__c LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or ID1__c LIKE \'%' + SearchText + '%\' or Loan_Number__c LIKE \'%' + SearchText + '%\' or Emp_Available_Balance__c LIKE  \'%' + SearchText + '%\' or Emp_Balance__c LIKE \'%' + SearchText + '%\')';
            }
        }
        
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
                              ' Open_Date_PST__c, '+
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                     		  'Maturity_Date__c, ' +
                              ' Available_Balance__c FROM Account_Details__c WHERE Name = \''+ accRecName + '\' and RecType__c != \'CARD\' and ' + searchquery + ' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
                  string temp = '%' + SearchText + '%';
                  ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name =:accRecName and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp)];
                if(isDate)
                  	ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name =:accRecName and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp or Close_Date__c =: dtSearchText or OPEN_DATE__c =: dtSearchText)];
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
                              ' Open_Date_PST__c, '+
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c WHERE Name = \'' + accRecName +  '\' and RecType__c != \'CARD\' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
				ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name =:accRecName and RecType__c != 'CARD'];
        	}
            
      		system.debug('SOQLQuery---' + SOQLQuery);
		List<sObject> sobjList = Database.query(SOQLQuery);
        Member360View test = new Member360View();
        test.accList = sobjList;
        test.totalrecords = Integer.Valueof(ARs[0].get('cnt'));
        return test;
	
	}
	
	
	
	private static object GetCardList(String accRecName,Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
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
        string SOQLQuery = '';		
        string searchquery = '';
        if(SearchText != '')
        {
        	searchquery += '(Name LIKE \'%' + SearchText + '%\' or Card_Number_Last_4_Digits__c LIKE \'%' + SearchText + '%\' or Brand__c LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or Card_Name__c LIKE \'%' + SearchText + '%\')';
        }
        
      
       		if(searchquery.length() > 0)
        	{
        		SOQLQuery = 'SELECT Id, ' +
                              'Name, ' +
                              'RecType__c, ' +
                              'TypeTranslate__c, ' +
                              'ID1__c, ' +
                              'Balance__c, ' +
                              'Combined_Account_ID__c, ' +
                              'Brand__c, ' +
                              'Loan_Number__c, ' +
                              'Close_Date__c, ' +
                              'Card_Number_Last_4_Digits__c, ' +
                              'OPEN_DATE__c, ' +
                              'Expiration_Date__c, ' +
                              'Issue_Date__c, ' +
                              'Emp_Balance__c, ' +
                              'Card_Name__c FROM Account_Details__c Where Name = \'' + accRecName +  '\' and RecType__c = \'CARD\' and ' + searchquery + ' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
							  
                string temp = '%' + SearchText + '%';				
				ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Name =:accRecName and RecType__c = 'CARD' and (Name LIKE : temp or Card_Number_Last_4_Digits__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or Card_Name__c LIKE : temp)];
        	}
        	else
        	{
        		SOQLQuery = 'SELECT Id, ' +
                              'Name, ' +
                              'RecType__c, ' +
                              'TypeTranslate__c, ' +
                              'ID1__c, ' +
                              'Balance__c, ' +
                              'Combined_Account_ID__c, ' +
                              'Brand__c, ' +
                              'Loan_Number__c, ' +
                              'Close_Date__c, ' +
                              'Card_Number_Last_4_Digits__c, ' +
                              'OPEN_DATE__c, ' +
                              'Expiration_Date__c, ' +
                              'Issue_Date__c, ' +
                              'Emp_Balance__c, ' +
                              'Card_Name__c FROM Account_Details__c Where Name = \'' + accRecName +  '\' and RecType__c = \'CARD\' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
							  
              ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Name =:accRecName and RecType__c = 'CARD'];
        	}
        
		
		system.debug('SOQLQuery---' + SOQLQuery);
		List<Account_Details__c> cardList = Database.query(SOQLQuery);		
		for(Account_Details__c card : cardList){
			List<AggregateResult> countResult =[select Count(Id) from CFCU_Mastercard_Alerts__c  where Card_Number__c =: card.Card_Number_Last_4_Digits__c and Member_Number__c =: card.Name ];
			 integer countCardRecords = (Integer)  countResult [0].get('expr0');
			 if(countCardRecords > 0)
			 {
           		card.Onboarded__c = true;
			 }
			 else
			 {
			 	card.Onboarded__c = false;		 
			 }
       } 	
        Member360View card = new Member360View();
        card.accList = cardList;
        card.totalrecords = Integer.Valueof( ARs[0].get('cnt'));
        return card;
	
	}
	
	private static object GetContactDetails(String accRecName, Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
	{		
        Integer PageSize_Local = Integer.Valueof( PageSize);
        Integer PageNo_Local = Integer.Valueof( PageNo);
        string SOQLQuery = '';
		string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
        	orderString = ' Order by ' + SortBy + ' ' + SortDir;	
        	
        }        
		string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
        	AggregateResult[] ARs;
       
        
         string searchquery = '';
        if(SearchText != '')
        {
        	searchquery += 'and (PersonID__r.Name LIKE \'%' + SearchText + '%\' or Account_Number__r.Name LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or Account_Number__r.Brand__c LIKE \'%' + SearchText + '%\' or Account_Number__r.TypeTranslate__c LIKE \'%' + SearchText + '%\' or Account_Type__c LIKE \'%' + SearchText + '%\')';
        }
     
        SOQLQuery = 'Select Id,' +
                              'personId__c,' +
                              'Account_Number__c,' +
                              'TypeTranslate__c,' +
                              'Account_Type__c,' +
                              'Relationship__c,' +
                              'PersonID__r.SSN_Last_4__pc,' +
                              'Open_Date__c,' +
                             // PersonID__r.BIRTH_DATE__pc,
                              'Account_Number__r.Name,' +
                              'Account_Number__r.TypeTranslate__c,' +
                              'PersonID__r.FirstName,' +
                              'PersonID__r.LastName,' +
                              'PersonID__r.Name,' +
                              'Account_Number__r.Brand__c From Person_Account__c WHERE Account_Number__r.Name = \'' + accRecName +  '\' ' + searchquery + ' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset ;        
        		if(searchquery.length() > 0)
        		{
        			string temp = '%' + SearchText + '%';
        			ARs  = [SELECT Count(id) cnt FROM Person_Account__c Where Account_Number__r.Name =: accRecName and (PersonID__r.Name LIKE : temp or Account_Number__r.Name LIKE : temp or TypeTranslate__c LIKE : temp or Account_Number__r.Brand__c LIKE : temp or Account_Number__r.TypeTranslate__c LIKE : temp or Account_Type__c LIKE : temp)];
        		}
        		else
        		{
        			ARs  = [SELECT Count(id) cnt FROM Person_Account__c Where Account_Number__r.Name =: accRecName];
        		}
        		
       
       system.debug('SOQLQuery---' + SOQLQuery);
		List<sObject> ContactList = Database.query(SOQLQuery);
       Member360View lstcontact = new Member360View();
        lstcontact.accList = ContactList;
        lstcontact.totalrecords = Integer.Valueof( ARs[0].get('cnt'));
        return lstcontact;
    }
        
    private static object GetActiveCaseDetails(String accRecName, Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
    {        
        Integer PageSize_Local = Integer.Valueof(PageSize);
        Integer PageNo_Local = Integer.Valueof(PageNo);
        string SOQLQuery = '';
		string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
        	orderString = ' Order by ' + SortBy + ' ' + SortDir;	
        	
        }        
		string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
        AggregateResult[] ARs;
        
        string searchquery = '';
        boolean isDate = false;
		Datetime dtStartTime;
		Datetime dtEndTime;
        if(SearchText != '')
        {
        	try{
        		string temp = SearchText + ' 12:00 AM';
        		dtStartTime = Datetime.Parse(temp);        		
        		string starttime = string.valueOf(dtStartTime).substringBefore(' ') + 'T08:00:00Z';
        		dtEndTime = dtStartTime.addDays(1);
        		string endtime = string.valueOf(dtEndTime).substringBefore(' ') + 'T08:00:00Z';
        		system.debug('string convered to date!' + dtStartTime + 'enddate - ' + dtEndTime);
        		searchquery +=  'and (CaseNumber LIKE \'%' + SearchText + '%\' or Account_Number__r.Name LIKE \'%' + SearchText + '%\' or Account.Name LIKE \'%' + SearchText + '%\' or Category__c LIKE \'%' + SearchText + '%\' or Subject LIKE \'%' + SearchText + '%\' or Origin LIKE \'%' + SearchText + '%\' or Account_Number__r.Brand__c LIKE \'%' + SearchText + '%\' or Status LIKE \'%' + SearchText + '%\' or Owner.Name LIKE \'%' + SearchText + '%\' or (CreatedDate >= '+ starttime +' and CreatedDate <= '+ endtime +'))';
        		isDate = true;
        	}
        	catch(Exception ex){
        		searchquery += 'and (CaseNumber LIKE \'%' + SearchText + '%\' or Account_Number__r.Name LIKE \'%' + SearchText + '%\' or Account.Name LIKE \'%' + SearchText + '%\' or Category__c LIKE \'%' + SearchText + '%\' or Subject LIKE \'%' + SearchText + '%\' or Origin LIKE \'%' + SearchText + '%\' or Account_Number__r.Brand__c LIKE \'%' + SearchText + '%\' or Status LIKE \'%' + SearchText + '%\' or Owner.Name LIKE \'%' + SearchText + '%\')';
        	}
        }
        
        SOQLQuery = 'Select Id,' +
                           'CaseNumber,' +
                           'OwnerId,' +
                           'Owner.Name,' +
                           'Status,' +
                           'Category__c,' +
                           'Account_Number__c,' +
                           'Primary_Category__c,' +
                           'Tertiary_Category__c,' +
                           'Secondary_Category__c,' +
                           'Account_Number__r.Brand__c,' +
                           'Account.Name,' +
                           'Account_Number__r.Name,' +
                           'Account_Number__r.TypeTranslate__c,' +                           
                           'Subject,' +
                           'CreatedDate,' +
                           'Origin,' +
                           'Parent.CaseNumber,' +
                           'ClosedDate FROM case WHERE Account_Number__r.Name = \'' + accRecName +  '\'  AND Status != \'Closed\' ' + searchquery + ' ' +  orderString;
       	
       	 
       	if(searchquery.length() > 0)
        {
        	string temp = '%' + SearchText + '%';
        	ARs  = [SELECT Count(id) cnt FROM case Where Account_Number__r.Name =:accRecName AND Status != 'Closed' and (CaseNumber LIKE :  temp or Account_Number__r.Name LIKE :  temp or Account.Name LIKE :  temp or Category__c LIKE :  temp or Subject LIKE :  temp or Origin LIKE :  temp or Account_Number__r.Brand__c LIKE :  temp or Status LIKE :  temp or Owner.Name LIKE :  temp)];
        	if(isDate)
        		ARs  = [SELECT Count(id) cnt FROM case Where Account_Number__r.Name =:accRecName AND Status != 'Closed' and (CaseNumber LIKE :  temp or Account_Number__r.Name LIKE :  temp or Account.Name LIKE :  temp or Category__c LIKE :  temp or Subject LIKE :  temp or Origin LIKE :  temp or Account_Number__r.Brand__c LIKE :  temp or Status LIKE :  temp or Owner.Name LIKE :  temp or (CreatedDate >=: dtStartTime and CreatedDate <=: dtEndTime))];
       	}
        else
        {
        	ARs  = [SELECT Count(id) cnt FROM case Where Account_Number__r.Name =:accRecName AND Status != 'Closed'];
        }
       	system.debug('SOQLQuery Active Cases ---' + SOQLQuery);
		List<sObject> caseList = Database.query(SOQLQuery);
		
		//Start: CRM-1400: Get Multiple Accounts added to case - DB
        

		List<CaseAccountMemberDetail__c> camd = new List<CaseAccountMemberDetail__c>();
		List<CaseAccountMemberDetail__c> finalcamd = new List<CaseAccountMemberDetail__c>();
		 map<id, case> casemap = new map<id, case>();
		 set<id> caseIdsfromMultiple = new set<id>();
		 
        camd = [select id,Case__c, MemberAccountid__c,  case__r.CaseNumber,case__r.OwnerId,
        				case__r.Owner.Name , case__r.Status, case__r.Category__c,
        				case__r.Primary_Category__c, case__r.Tertiary_Category__c,case__r.Secondary_Category__c,
        				case__r.Account.Name,
        				Account_Name__c, 
        				case__r.Subject, case__r.Origin,case__r.Parent.CaseNumber, case__r.ClosedDate
        				 from CaseAccountMemberDetail__c where Account_Name__c =: accRecName AND case__r.Status != 'Closed'];//and MemberAccountid__c not in: lMemberIds
          system.debug('camd=='+camd);	
          
       	 
        
         map<id, string> caseAccountmap = new map<id, string>();
            map<id, string> caseMemberAccountNamemap = new map<id, string>();
            map<id, string> caseMemberAccountBrandmap = new map<id, string>();
            set<string> memberAccountIds = new set<string>();
             List<account_details__c> memberAccountList = new List<account_details__c>();
           
            
         for(sObject so:caseList){
         	caseAccountmap.put(so.id, (string)so.get('Account_Number__c'));
         	casemap.put(so.id, (case)so);  
         	memberAccountIds.add((string)so.get('Account_Number__c'));   
         	
         }
         
          for(CaseAccountMemberDetail__c so:camd){         	
         	caseIdsfromMultiple.add(so.case__c);         	
         	
         }
         
          List<case> caseMemberAccountList = [select id, casenumber, Account_Number__c,Category__c, Status , Subject, Account.Name,
          									  ParentId, Origin, CreatedDate, Account_Number__r.Brand__c, Owner.Name, Parent.CaseNumber, AccountId
          										 from case where Id in: caseIdsfromMultiple];	
           
           for(case so:caseMemberAccountList){         	
         		casemap.put(so.id, so);           	
         		caseAccountmap.put(so.id, so.Account_Number__c);
         } 
            
         memberAccountList = [select id, name, Brand__c from account_details__c where id in: memberAccountIds];
         
         for(account_details__c i: memberAccountList){
         	caseMemberAccountNamemap.put(i.id,i.Name);
         	caseMemberAccountBrandmap.put(i.id,i.Brand__c);
         }
         
         for(CaseAccountMemberDetail__c a:camd){   
         	system.debug('a.case__r.casenumber ===' +a.case__r.casenumber);       
         	system.debug('caseAccountmap.get(a.case__c)===' +caseAccountmap.get(a.case__c));       	
         	if(caseAccountmap.get(a.case__c) != null){
         		string maid = caseAccountmap.get(a.case__c);
         		if(maid != a.MemberAccountid__c){
         			finalcamd.add(a);
         			system.debug('finalcamd===' +a.case__r.casenumber ); 
         		}
         	}
         	else{
         		finalcamd.add(a);
         		system.debug('finalcamdelse===' +a.case__r.casenumber ); 
         	}
         		
         }
         
         Schema.DescribeFieldResult fieldResult = Case.parentId.getDescribe();
		Schema.SObjectField field = fieldResult.getSObjectField();
          system.debug('finalcamd=='+finalcamd);	
          
          List<CaseModel> finalCaseList = new List<CaseModel>();
           List<CaseModel> finalCaseListwithPageSize = new List<CaseModel>();
           List<CaseModel> finalCaseListwithPageSizeSorted = new List<CaseModel>();
          
         for(sObject so:caseList){
         	CaseModel Tempcase = new CaseModel();
         	Tempcase.Id = so.id;
         	Tempcase.CaseNumber = (string)so.get('CaseNumber');
         	Tempcase.Category = (string)so.get('Category__c');
         	Tempcase.Status = (string)so.get('Status');
         	Tempcase.AccountNumber = (string)so.get('Account_Number__c');
         	Tempcase.AccountName = caseMemberAccountNamemap.get((string)so.get('Account_Number__c'));
         	Tempcase.Subject = (string)so.get('Subject');
         	if(so.getSobject('Account') != null)
         	Tempcase.MemberName = (string)so.getSobject('Account').get('Name');
         	Tempcase.ParentId = (string)so.get('ParentId');
         	 if((Case)so.getSObject(field) != null)
         	Tempcase.ParentCaseNumber = (string)so.getSObject(field).get('CaseNumber');
         	Tempcase.Origin = (string)so.get('Origin');
         	Tempcase.CreatedDate = (datetime)so.get('CreatedDate');
         	Tempcase.Brand =  caseMemberAccountBrandmap.get((string)so.get('Account_Number__c'));
         	if(so.getSobject('Owner') != null)
         	Tempcase.OwnerName = (string)so.getSobject('Owner').get('Name');
         		if(so.getSobject('Account') != null)
         	Tempcase.AccountId = (string)so.getSobject('Account').get('Id');
         	finalCaseList.add(Tempcase);
         
         }
         
          
         for(CaseAccountMemberDetail__c so:finalcamd){
         	case c = new case();
        	c = casemap.get(so.case__c);
         	CaseModel Tempcase = new CaseModel();
         	Tempcase.Id = c.id;
         	Tempcase.CaseNumber = c.CaseNumber;
         	Tempcase.Category = c.Category__c;
         	Tempcase.Status = c.Status;
         	Tempcase.AccountNumber = so.MemberAccountid__c;
         	Tempcase.AccountName = so.Account_Name__c;
         	Tempcase.Subject = c.Subject;
         	Tempcase.MemberName = c.Account.Name;
         	Tempcase.ParentId =  c.ParentId;
         	Tempcase.Origin = c.Origin;
         	Tempcase.CreatedDate = c.CreatedDate;
         	Tempcase.Brand = c.Account_Number__r.Brand__c;
         	Tempcase.OwnerName = c.Owner.Name;
            Tempcase.ParentCaseNumber = c.Parent.CaseNumber;
            Tempcase.AccountId = c.AccountId;
         	finalCaseList.add(Tempcase);
         		
         }
        system.debug('finalCaseList=='+finalCaseList) ;
        
        integer counter = ((PageNo_Local - 1 ) * PageSize_Local);
        integer PageSize_LocaltoLimit = PageSize_Local+counter;
        
         system.debug('counter=='+counter) ;
          system.debug('PageSize_LocaltoLimit=='+PageSize_LocaltoLimit) ;
          
      /*  if(finalCaseList.size() > 0){
	        for(integer i=counter;i<PageSize_LocaltoLimit;i++){
	        	if(i < finalCaseList.size() && finalCaseList[i] != null)
	        	finalCaseListwithPageSize.add(finalCaseList[i]);
	        }
        }   */  
         
         //Start: CRM-1501 - Sorting related changes
        
        CaseModelWrapper[] casewrapperList = new CaseModelWrapper[0];
			    for(CaseModel key: finalCaseList) {
            		casewrapperList.add(new CaseModelWrapper(key));
        		}
        		
        if(SortBy == 'CreatedDate'){
        	  SORT_BY = OpenDate_SORT;
        }        
       	
       	else if(SortBy == 'ClosedDate'){
        	  SORT_BY = ClosedDate_SORT;
        } 
       	
       	else if(SortBy == 'CaseNumber'){
        	  SORT_BY = CaseNumber_SORT;
        } 
        
        else if(SortBy == 'Parent.CaseNumber'){
        	  SORT_BY = ParentCase_SORT;
        }
        
        else if(SortBy == 'Account_Number__r.Name'){
        	  SORT_BY = AccountNo_SORT;
        } 
        
        else if(SortBy == 'Account.Name'){
        	  SORT_BY = MemberName_SORT;
        } 
        
        else if(SortBy == 'Category__c'){
        	  SORT_BY = CaseCategory_SORT;
        } 
        
        else if(SortBy == 'Subject'){
        	  SORT_BY = CaseSubject_SORT;
        } 
        
        else if(SortBy == 'Origin'){
        	  SORT_BY = CaseOrigin_SORT;
        } 
        
        else if(SortBy == 'Account_Number__r.Brand__c'){
        	  SORT_BY = Brand_SORT;
        } 
        
        else if(SortBy == 'Status'){
        	  SORT_BY = Status_SORT;
        } 
        
        else if(SortBy == 'Owner.Name'){
        	  SORT_BY = Owner_SORT;
        } 
          
        else{
        	  SORT_BY = OpenDate_SORT;
        }
      
        casewrapperList.sort();
        system.debug('casewrapperList==='+casewrapperList);
        
         system.debug('SortDir==='+SortDir);
        
         system.debug('SortBy==='+SortBy);
        
        
        if(SortDir.contains('Desc') || (SortDir == '' && SortBy == '')){
	        for(Integer i = casewrapperList.size()-1; i>=0;i--) {
	            		finalCaseListwithPageSizeSorted.Add(casewrapperList[i].casemodel);
	        		}
        }
       else{
	        for(Integer i = 0; i<casewrapperList.size();i++) {
	            		finalCaseListwithPageSizeSorted.Add(casewrapperList[i].casemodel);
	        		}
        }
        system.debug('finalCaseListwithPageSizeSorted==='+finalCaseListwithPageSizeSorted);
       // system.debug('casewrapperListcasemodel==='+casewrapperList.casemodel);
        
         if(finalCaseListwithPageSizeSorted.size() > 0){
	        for(integer i=counter;i<PageSize_LocaltoLimit;i++){
	        	if(i < finalCaseListwithPageSizeSorted.size() && finalCaseListwithPageSizeSorted[i] != null)
	        	finalCaseListwithPageSize.add(finalCaseListwithPageSizeSorted[i]);
	        }
        }
        //End: CRM-1501 - Sorting related changes  
        
      
		
       	Member360View lstCase = new Member360View();
        lstCase.accList = finalCaseListwithPageSize;
        lstCase.totalrecords =finalCaseList.size(); //Integer.Valueof(ARs[0].get('cnt')) + caseList.size();
         //End: CRM-1400: Get Multiple Accounts added to case - DB
         
        return lstCase;
    }
    
    
    private static object GetCloseCaseDetails(String accRecName, Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
    {        
        Integer PageSize_Local = Integer.Valueof(PageSize);
        Integer PageNo_Local = Integer.Valueof(PageNo);
        string SOQLQuery = '';
		string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
        	orderString = ' Order by ' + SortBy + ' ' + SortDir;	
        	
        }        
		string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
        AggregateResult[] ARs;
             
        string searchquery = '';
        boolean isDate = false;        
        Datetime dtStartTime;
		Datetime dtEndTime;
        if(SearchText != '')
        {
        	try{
        		string temp = SearchText + ' 12:00 AM';
        		dtStartTime = Datetime.Parse(temp);        		
        		string starttime = string.valueOf(dtStartTime).substringBefore(' ') + 'T08:00:00Z';
        		dtEndTime = dtStartTime.addDays(1);
        		string endtime = string.valueOf(dtEndTime).substringBefore(' ') + 'T08:00:00Z';
        		system.debug('string convered to date!' + dtStartTime + 'enddate - ' + dtEndTime);
        		searchquery +=  'and (CaseNumber LIKE \'%' + SearchText + '%\' or Account_Number__r.Name LIKE \'%' + SearchText + '%\' or Account.Name LIKE \'%' + SearchText + '%\' or Category__c LIKE \'%' + SearchText + '%\' or Subject LIKE \'%' + SearchText + '%\' or Origin LIKE \'%' + SearchText + '%\' or Account_Number__r.Brand__c LIKE \'%' + SearchText + '%\' or Status LIKE \'%' + SearchText + '%\' or Owner.Name LIKE \'%' + SearchText + '%\' or (CreatedDate >= '+ starttime +' and CreatedDate <= '+ endtime +') or (ClosedDate >= '+ starttime +' and ClosedDate <= '+ endtime +'))';
        		isDate = true;
        	}
        	catch(Exception ex){
        		searchquery += 'and (CaseNumber LIKE \'%' + SearchText + '%\' or Account_Number__r.Name LIKE \'%' + SearchText + '%\' or Account.Name LIKE \'%' + SearchText + '%\' or Category__c LIKE \'%' + SearchText + '%\' or Subject LIKE \'%' + SearchText + '%\' or Origin LIKE \'%' + SearchText + '%\' or Account_Number__r.Brand__c LIKE \'%' + SearchText + '%\' or Status LIKE \'%' + SearchText + '%\' or Owner.Name LIKE \'%' + SearchText + '%\')';
        	}
        }
        
        SOQLQuery = 'Select Id,' +
                           'CaseNumber,' +
                           'OwnerId,' +
                           'Owner.Name,' +
                           'Status,' +
                           'Category__c,' +
                            'Account_Number__c,' +
                           'Primary_Category__c,' +
                           'Tertiary_Category__c,' +
                           'Secondary_Category__c,' +
                           'Account_Number__r.Brand__c,' +
                           'Account.Name,' +
                           'Account_Number__r.Name,' +
                           'Account_Number__r.TypeTranslate__c,' +
                           'ParentId,' +
                           'Subject,' +
                           'CreatedDate,' +
                           'Origin,' +
                           'Parent.CaseNumber,' +
                           'ClosedDate FROM case WHERE Account_Number__r.Name = \'' + accRecName +  '\' AND Status = \'Closed\' ' + searchquery + ' ' +  orderString;
		
		if(searchquery.length() > 0)
        {
        	string temp = '%' + SearchText + '%';
        	ARs  = [SELECT Count(id) cnt FROM case Where Account_Number__r.Name =:accRecName AND Status = 'Closed' and (CaseNumber LIKE :  temp or Account_Number__r.Name LIKE :  temp or Account.Name LIKE :  temp or Category__c LIKE :  temp or Subject LIKE :  temp or Origin LIKE :  temp or Account_Number__r.Brand__c LIKE :  temp or Status LIKE :  temp or Owner.Name LIKE :  temp)];
        	if(isDate)
        		ARs  = [SELECT Count(id) cnt FROM case Where Account_Number__r.Name =:accRecName AND Status = 'Closed' and (CaseNumber LIKE :  temp or Account_Number__r.Name LIKE :  temp or Account.Name LIKE :  temp or Category__c LIKE :  temp or Subject LIKE :  temp or Origin LIKE :  temp or Account_Number__r.Brand__c LIKE :  temp or Status LIKE :  temp or Owner.Name LIKE :  temp or (CreatedDate >=: dtStartTime and CreatedDate <=: dtEndTime) or (ClosedDate >=: dtStartTime and ClosedDate <=: dtEndTime))];
       	}
       	else
       	{
       		ARs  = [SELECT Count(id) cnt FROM case Where Account_Number__r.Name =:accRecName AND Status = 'Closed'];
       	}
		
		
		system.debug('SOQLQuery---' + SOQLQuery);
		List<sObject> caseList = Database.query(SOQLQuery);
		
		//Start: CRM-1400: Get Multiple Accounts added to case - DB
        

		List<CaseAccountMemberDetail__c> camd = new List<CaseAccountMemberDetail__c>();
		List<CaseAccountMemberDetail__c> finalcamd = new List<CaseAccountMemberDetail__c>();
		 map<id, case> casemap = new map<id, case>();
		 set<id> caseIdsfromMultiple = new set<id>();
		 
        camd = [select id,Case__c, MemberAccountid__c,  case__r.CaseNumber,case__r.OwnerId,
        				case__r.Owner.Name , case__r.Status, case__r.Category__c,
        				case__r.Primary_Category__c, case__r.Tertiary_Category__c,case__r.Secondary_Category__c,
        				case__r.Account.Name,
        				Account_Name__c, 
        				case__r.Subject, case__r.Origin,case__r.Parent.CaseNumber, case__r.ClosedDate
        				 from CaseAccountMemberDetail__c where Account_Name__c =: accRecName AND case__r.Status = 'Closed'];//and MemberAccountid__c not in: lMemberIds
          system.debug('camd=='+camd);	
          
       	 
        
         map<id, string> caseAccountmap = new map<id, string>();
            map<id, string> caseMemberAccountNamemap = new map<id, string>();
            map<id, string> caseMemberAccountBrandmap = new map<id, string>();
            set<string> memberAccountIds = new set<string>();
             List<account_details__c> memberAccountList = new List<account_details__c>();
           
            
         for(sObject so:caseList){
         	caseAccountmap.put(so.id, (string)so.get('Account_Number__c'));
         	casemap.put(so.id, (case)so);  
         	memberAccountIds.add((string)so.get('Account_Number__c'));   
         	
         }
         
          for(CaseAccountMemberDetail__c so:camd){         	
         	caseIdsfromMultiple.add(so.case__c);         	
         	
         }
         
          List<case> caseMemberAccountList = [select id, casenumber, Account_Number__c,Category__c, Status , Subject, Account.Name,
          									  ParentId, Origin, CreatedDate, Account_Number__r.Brand__c, Owner.Name, Parent.CaseNumber, AccountId
          										 from case where Id in: caseIdsfromMultiple];	
           
           for(case so:caseMemberAccountList){         	
         		casemap.put(so.id, so);           	
         		caseAccountmap.put(so.id, so.Account_Number__c);
         } 
            
         memberAccountList = [select id, name, Brand__c from account_details__c where id in: memberAccountIds];
         
         for(account_details__c i: memberAccountList){
         	caseMemberAccountNamemap.put(i.id,i.Name);
         	caseMemberAccountBrandmap.put(i.id,i.Brand__c);
         }
         
         for(CaseAccountMemberDetail__c a:camd){   
         	system.debug('a.case__r.casenumber ===' +a.case__r.casenumber);       
         	system.debug('caseAccountmap.get(a.case__c)===' +caseAccountmap.get(a.case__c));       	
         	if(caseAccountmap.get(a.case__c) != null){
         		string maid = caseAccountmap.get(a.case__c);
         		if(maid != a.MemberAccountid__c){
         			finalcamd.add(a);
         			system.debug('finalcamd===' +a.case__r.casenumber ); 
         		}
         	}
         	else{
         		finalcamd.add(a);
         		system.debug('finalcamdelse===' +a.case__r.casenumber ); 
         	}
         		
         }
         
         Schema.DescribeFieldResult fieldResult = Case.parentId.getDescribe();
		Schema.SObjectField field = fieldResult.getSObjectField();
          system.debug('finalcamd=='+finalcamd);	
          
          List<CaseModel> finalCaseList = new List<CaseModel>();
           List<CaseModel> finalCaseListwithPageSize = new List<CaseModel>();
          
         for(sObject so:caseList){
         	CaseModel Tempcase = new CaseModel();
         	Tempcase.Id = so.id;
         	Tempcase.CaseNumber = (string)so.get('CaseNumber');
         	Tempcase.Category = (string)so.get('Category__c');
         	Tempcase.Status = (string)so.get('Status');
         	Tempcase.AccountNumber = (string)so.get('Account_Number__c');
         	Tempcase.AccountName = caseMemberAccountNamemap.get((string)so.get('Account_Number__c'));
         	Tempcase.Subject = (string)so.get('Subject');
         	if(so.getSobject('Account') != null)
         	Tempcase.MemberName = (string)so.getSobject('Account').get('Name');
         	Tempcase.ParentId = (string)so.get('ParentId');
         	 if((Case)so.getSObject(field) != null)
         	Tempcase.ParentCaseNumber = (string)so.getSObject(field).get('CaseNumber');
         	Tempcase.Origin = (string)so.get('Origin');
         	Tempcase.CreatedDate = (datetime)so.get('CreatedDate');
         	Tempcase.ClosedDate = (datetime)so.get('ClosedDate');
         	Tempcase.Brand =  caseMemberAccountBrandmap.get((string)so.get('Account_Number__c'));
         	if(so.getSobject('Owner') != null)
         	Tempcase.OwnerName = (string)so.getSobject('Owner').get('Name');
         		if(so.getSobject('Account') != null)
         	Tempcase.AccountId = (string)so.getSobject('Account').get('Id');
         	finalCaseList.add(Tempcase);
         
         }
         
          
         for(CaseAccountMemberDetail__c so:finalcamd){
         	case c = new case();
        	c = casemap.get(so.case__c);
         	CaseModel Tempcase = new CaseModel();
         	Tempcase.Id = c.id;
         	Tempcase.CaseNumber = c.CaseNumber;
         	Tempcase.Category = c.Category__c;
         	Tempcase.Status = c.Status;
         	Tempcase.AccountNumber = so.MemberAccountid__c;
         	Tempcase.AccountName = so.Account_Name__c;
         	Tempcase.Subject = c.Subject;
         	Tempcase.MemberName = c.Account.Name;
         	Tempcase.ParentId =  c.ParentId;
         	Tempcase.Origin = c.Origin;
         	Tempcase.CreatedDate = c.CreatedDate;
         	Tempcase.ClosedDate = c.ClosedDate;
         	Tempcase.Brand = c.Account_Number__r.Brand__c;
         	Tempcase.OwnerName = c.Owner.Name;
            Tempcase.ParentCaseNumber = c.Parent.CaseNumber;
            Tempcase.AccountId = c.AccountId;
         	finalCaseList.add(Tempcase);
         		
         }
        system.debug('finalCaseList=='+finalCaseList) ;
        
        integer counter = ((PageNo_Local - 1 ) * PageSize_Local);
        integer PageSize_LocaltoLimit = PageSize_Local+counter;
        
         system.debug('counter=='+counter) ;
          system.debug('PageSize_LocaltoLimit=='+PageSize_LocaltoLimit) ;
          
        if(finalCaseList.size() > 0){
	        for(integer i=counter;i<PageSize_LocaltoLimit;i++){
	        	if(i < finalCaseList.size() && finalCaseList[i] != null)
	        	finalCaseListwithPageSize.add(finalCaseList[i]);
	        }
        }     
         
        
        
      
		
       	Member360View lstCase = new Member360View();
        lstCase.accList = finalCaseListwithPageSize;
        lstCase.totalrecords =finalCaseList.size(); //Integer.Valueof(ARs[0].get('cnt')) + caseList.size();
         //End: CRM-1400: Get Multiple Accounts added to case - DB
		
		
		return lstCase;        
    }
	
	private static object GetCaseComments(String accRecName, Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
    {        
        Integer PageSize_Local = Integer.Valueof(PageSize);
        Integer PageNo_Local = Integer.Valueof(PageNo);
        string SOQLQuery = '';
		string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
        	if(SortBy == 'AccountName')
        		SortBy = 'Account.Name';
        	else if(SortBy == 'AccountNumberName')
        		SortBy = 'Account_Number__r.Name';
        	else if(SortBy == 'Category')
        		SortBy = 'Category__c';
        	orderString = ' Order by ' + SortBy + ' ' + SortDir;	
        	
        }        
		string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
         list<string> lstCaseId = new List<string>();
       	
		list<casewithcommentsModel> returnvalueModel = new list<casewithcommentsModel>();
		list<AggregateResult> lstAllCases = null;
		if(SearchText.length() > 0)
		{
			string temp = '%' + SearchText + '%';
			lstAllCases = [Select ParentId from CaseComment where ParentId in (select Id from Case where Account_Number__r.Name =: accRecName And Status != 'Closed' AND (CaseNumber LIKE : temp OR Account_Number__r.Name LIKE :temp OR Account.Name LIKE : temp or Category__c LIKE : temp OR Status LIKE : temp)) group by ParentId];
			if(lstAllCases.size() == 0)
			{
				lstAllCases = [Select ParentId from CaseComment where ParentId in (select Id from Case where Account_Number__r.Name =: accRecName And Status != 'Closed') AND CommentBody LIKE:temp group by ParentId];
			}
		}
		else
		{
			lstAllCases = [Select ParentId from CaseComment where ParentId in (select Id from Case where Account_Number__r.Name =: accRecName And Status != 'Closed') group by ParentId];
		}
       	
       	Integer TotalRecords = lstAllCases.size();
       
       for(AggregateResult c: lstAllCases) {
      		lstCaseId.add(string.valueOf(c.get('ParentId')));      		           
        } 
      
       
        SOQLQuery = 'Select Id,' +
                           'CaseNumber,' +
                           'Status,' +
                           'Category__c,' +  
                           'Account.Name,' +
                           'Account_Number__r.Name,' +
                           'Subject '+
                           'FROM case WHERE Id IN (\'' + string.join(lstCaseId,'\',\'') +  '\') ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
		
		
		
        System.debug('SOQLQuery is:::'+SOQLQuery);
        list<case> caseList = Database.query(SOQLQuery);
        list<string> lstPagedCaseId = new List<string>();
         list<casewithcommentsModel> lstCasewithcommentsModel = new list<casewithcommentsModel>();
    	for(Case c : caseList)
    	{
    		lstPagedCaseId.add(string.ValueOf(c.Id));
    		lstCasewithcommentsModel.add(new casewithcommentsModel(c.Id,c.CaseNumber,c.Category__c,c.Status,c.Account_Number__r.Name,c.Account.Name, c.Subject));
    	}
       
        
        List<CaseComment> caseCommentList = [Select CommentBody, IsPublished, ParentId, CreatedById, CreatedDate, LastModifiedDate from CaseComment Where ParentId IN :lstPagedCaseId order by LastModifiedDate DESC];
     
      
      System.debug('casecommentlist is:::'+caseCommentList);    
    		
    		for(casewithcommentsModel model: lstCasewithcommentsModel)
            {    
                for(CaseComment ccomm : caseCommentList)
                {
                  	if(model.caseId == ccomm.ParentId)
                    {
                    	if(model.lstCaseComments == null || model.lstCaseComments.size() <0)
                    		model.lstCaseComments = new list<CaseComment>();
                    	model.lstCaseComments.add(ccomm);                     	                 		
                    }
                }
            }         
          
          
          for(casewithcommentsModel model: lstCasewithcommentsModel)
          {
          	if(model.lstCaseComments != null && model.lstCaseComments.size() >0 && returnvalueModel.size() < PageSize_Local)
          	{
          		returnvalueModel.add(model);
          	}
          	if(returnvalueModel.size() == PageSize_Local){
          		break;
          	}
          }
          System.debug('Case Comments are:::::'+ returnvalueModel); 
      
		Member360View lastCaseComment = new Member360View();
        lastCaseComment.accList = returnvalueModel;
        lastCaseComment.totalrecords = TotalRecords;
		return lastCaseComment;       
    }
    
    private static object GetActiveTasksDetails(String accRecName, Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
    {        
        Integer PageSize_Local = Integer.Valueof(PageSize);
        Integer PageNo_Local = Integer.Valueof(PageNo);
        string SOQLQuery = '';
		string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
        	if(SortBy == 'AccountName')
        		SortBy = 'Account.Name';
        	else if(SortBy == 'AccountNumberName')
        		SortBy = 'Account_Number__r.Name';
        	else if(SortBy == 'Category')
        		SortBy = 'Category__c';
        	orderString = ' Order by ' + SortBy + ' ' + SortDir;	
        	
        }        
		string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
       list<taskModel> returnvalueModel = new list<taskModel>();
		list<AggregateResult> lstAllCases = null;
        list<string> lstCaseId = new List<string>();
		if(SearchText.length() > 0)
		{
			string temp = '%' + SearchText + '%';
			lstAllCases = [Select WhatId from Task where What.Type='Case' AND WhatId in (select Id from Case where Account_Number__r.Name =:accRecName And Status != 'Closed' AND (CaseNumber LIKE : temp OR Account_Number__r.Name LIKE :temp OR Account.Name LIKE : temp or Category__c LIKE : temp OR Status LIKE : temp)) group by WhatId];
		}
		else
		{
			lstAllCases = [Select WhatId from Task where What.Type='Case' AND WhatId in (select Id from Case where Account_Number__r.Name =:accRecName And Status != 'Closed') group by WhatId];
		}
       	
       	Integer TotalRecords = lstAllCases.size();
       
       for(AggregateResult c: lstAllCases) {
      		lstCaseId.add(string.valueOf(c.get('WhatId')));      		           
        } 
        SOQLQuery = 'Select Id,' +
                           'CaseNumber,' +
                           'Status,' +
                           'Category__c,' +  
                           'Account.Name,' +
                           'Account_Number__r.Name,' +
                           'Subject '+
                           'FROM case WHERE Id IN (\'' + string.join(lstCaseId,'\',\'') +  '\') ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
		
		
		
        System.debug('SOQLQuery is:::'+SOQLQuery);
        list<case> caseList = Database.query(SOQLQuery);
        list<string> lstPagedCaseId = new List<string>();
         list<taskModel> lstTasksModel = new list<taskModel>();
         for(Case c: caseList) {
      		lstPagedCaseId.add(string.ValueOf(c.Id));
      		lstTasksModel.add(new taskModel(c.Id,c.CaseNumber,c.Category__c,c.Status,c.Account_Number__r.Name,c.Account.Name, c.Subject));           
        }   
        		
        List<Task> tskList = [Select Id, Subject, whatId, Type, What.Name, Status, Priority, Description from Task where What.Type='Case' AND WhatId IN :lstPagedCaseId order by LastModifieddate DESC NULLS LAST];
      
	       System.debug('casecommentlist is:::'+tskList);       
    		
    		for(taskModel model: lstTasksModel)
            {    
                for(Task tsk : tskList)
                {
                  	if(model.caseId == tsk.WhatId)
                    {
                    	if(model.lstTasks == null || model.lstTasks.size() <0)
                    		model.lstTasks = new list<Task>();
                    	model.lstTasks.add(tsk);  
                    	                		
                    }
                }
            }     
          for(taskModel model: lstTasksModel)
          {
          	if(model.lstTasks != null && model.lstTasks.size() >0)
          	{
          		returnvalueModel.add(model);
          	}
          }
          System.debug('Tasks are:::::'+ returnvalueModel); 
      		
		Member360View lastModel = new Member360View();
        lastModel.accList = returnvalueModel;
        lastModel.totalrecords = TotalRecords;
		return lastModel;
    }
	
	
	private static object GetWarningCodeDetails(String accRecName, Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
	{
		Integer PageSize_Local = Integer.Valueof(PageSize);
        Integer PageNo_Local = Integer.Valueof(PageNo);
        string SOQLQuery = '';
		string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
        	if(SortBy == 'accNum')
        		SortBy = 'Name';
        	else if(SortBy == 'tpeTrans')
        		SortBy = 'TypeTranslate__c';
        	else if(SortBy == 'recTpe')
        		SortBy = 'RecType__c';
        	else if(SortBy == 'shareNo')
        		SortBy = 'ID1__c';
        	orderString = ' Order by ' + SortBy + ' ' + SortDir;	
        	
        }        
		string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
		integer startIndex = (PageNo_Local - 1 ) * PageSize_Local;
		integer endIndex = startIndex + PageSize_Local - 1;
		
        string searchquery = '';
        boolean isSearchComments = false;
        if(SearchText.length() > 0)
        {
        	if(SearchText.equalsIgnoreCase('Comments') || SearchText.equalsIgnoreCase('Warning Code'))
        		isSearchComments = true;
        	else
        	searchquery += 'and (Name LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or RecType__c LIKE \'%' + SearchText + '%\' or ID1__c LIKE \'%' + SearchText + '%\')';
        }
              
        list<Account_Details__c> accountDetailsList = new list<Account_Details__c>();
        
        SOQLQuery = 'Select Id,'+
                                     'Name,'+
                                     'Close_Date__c,'+
                                     'RecType__c,'+
                                     'TypeTranslate__c,'+
                                     'ID1__c,'+
                                     'WARNING_01_CODE__c,'+
                                     'WARNING_02_CODE__c,'+
                                     'WARNING_03_CODE__c,'+
                                     'WARNING_04_CODE__c,'+
                                     'WARNING_05_CODE__c,'+
                                     'WARNING_06_CODE__c,'+
                                     'WARNING_07_CODE__c,'+
                                     'WARNING_08_CODE__c,'+
                                     'WARNING_09_CODE__c,'+
                                     'WARNING_10_CODE__c,'+
                                     'WARNING_11_CODE__c,'+
                                     'WARNING_12_CODE__c,'+
                                     'WARNING_13_CODE__c,'+
                                     'WARNING_14_CODE__c,'+
                                     'WARNING_15_CODE__c,'+
                                     'WARNING_16_CODE__c,'+
                                     'WARNING_17_CODE__c,'+
                                     'WARNING_18_CODE__c,'+
                                     'WARNING_19_CODE__c,'+
                                     'WARNING_20_CODE__c,'+
                                     'Comment_Block_01__c,'+
                                     'Comment_Block_02__c,'+
                                     'Comment_Block_03__c,'+
                                     'Comment_Block_04__c,'+
                                     'Comment_Block_05__c,'+
                                     'Comment_Block_06__c,'+
                                     'Comment_Block_07__c,'+
                                     'Comment_Block_08__c,'+
                                     'Comment_Block_09__c,'+
                                     'Comment_Block_10__c,'+
                                     'Comment_Block_11__c,'+
                                     'Comment_Block_12__c,'+
                                     'Comment_Block_13__c,'+
                                     'Comment_Block_14__c,'+
                                     'Comment_Block_15__c,'+
                                     'Comment_Block_16__c,'+
                                     'Comment_Block_17__c,'+
                                     'Comment_Block_18__c,'+
                                     'Comment_Block_19__c,'+
                                     'Comment_Block_20__c FROM Account_Details__c Where Name = \'' + accRecName +  '\' ' + searchquery + ' ' +  orderString ;
       
        accountDetailsList = Database.query(SOQLQuery);    
        system.debug(accountDetailsList); 
        
       list<document> docList =[SELECT Id,Name FROM Document];
        map<string,Id> docMap = new map<string,Id>();
        for(Document d: docList){
            docMap.put(d.Name,d.Id);
        }
                                    
         list<warningStringWrapper> wsWrapperList = new list<warningStringWrapper>();
                                    
         for(Account_Details__c var: accountDetailsList){
             
             if(var.WARNING_01_CODE__c != '000-NONE' && var.WARNING_01_CODE__c != NULL && var.WARNING_01_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_01_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_01__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_01__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_02_CODE__c != '000-NONE' && var.WARNING_02_CODE__c != NULL && var.WARNING_02_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_02_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_02__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_02__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_03_CODE__c != '000-NONE' && var.WARNING_03_CODE__c != NULL && var.WARNING_03_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_03_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_03__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_03__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_04_CODE__c != '000-NONE' && var.WARNING_04_CODE__c != NULL && var.WARNING_04_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_04_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_04__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_04__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_05_CODE__c != '000-NONE' && var.WARNING_05_CODE__c != NULL && var.WARNING_05_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_05_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_05__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_05__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_06_CODE__c != '000-NONE' && var.WARNING_06_CODE__c != NULL && var.WARNING_06_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_06_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_06__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_06__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_07_CODE__c != '000-NONE' && var.WARNING_07_CODE__c != NULL && var.WARNING_07_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_07_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_07__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_07__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_08_CODE__c != '000-NONE' && var.WARNING_08_CODE__c != NULL && var.WARNING_08_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_08_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_08__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_08__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_09_CODE__c != '000-NONE' && var.WARNING_09_CODE__c != NULL && var.WARNING_09_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_09_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_09__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_09__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_10_CODE__c != '000-NONE' && var.WARNING_10_CODE__c != NULL && var.WARNING_10_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_10_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_10__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_10__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_11_CODE__c != '000-NONE' && var.WARNING_11_CODE__c != NULL && var.WARNING_11_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_11_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_11__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_11__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_12_CODE__c != '000-NONE' && var.WARNING_12_CODE__c != NULL && var.WARNING_12_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_12_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_12__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_12__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_13_CODE__c != '000-NONE' && var.WARNING_13_CODE__c != NULL && var.WARNING_13_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_13_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_13__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_13__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_14_CODE__c != '000-NONE' && var.WARNING_14_CODE__c != NULL && var.WARNING_14_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_14_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_14__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_14__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_15_CODE__c != '000-NONE' && var.WARNING_15_CODE__c != NULL && var.WARNING_15_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_15_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_15__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_15__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_16_CODE__c != '000-NONE' && var.WARNING_16_CODE__c != NULL && var.WARNING_16_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_16_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_16__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_16__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_17_CODE__c != '000-NONE' && var.WARNING_17_CODE__c != NULL && var.WARNING_17_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_17_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_17__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_17__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_18_CODE__c != '000-NONE' && var.WARNING_18_CODE__c != NULL && var.WARNING_18_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_18_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_18__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_18__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_19_CODE__c != '000-NONE' && var.WARNING_19_CODE__c != NULL && var.WARNING_19_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_19_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_19__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_19__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
             if(var.WARNING_20_CODE__c != '000-NONE' && var.WARNING_20_CODE__c != NULL && var.WARNING_20_CODE__c != '0-NONE'){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Warning Code')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_20_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
             }
             if(var.Comment_Block_20__c != null){
             	if(SearchText == '' || isSearchComments== false || (isSearchComments && SearchText.equalsIgnoreCase('Comment')))
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_20__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
             }
         }
          system.debug(wsWrapperList);
       if(endIndex > wsWrapperList.size()-1)
       		endIndex = wsWrapperList.size()-1;
       list<warningStringWrapper> lstwarningComments = new list<warningStringWrapper>(); 
       for(integer i=startIndex;i<=endIndex;i++)
       {
       		warningStringWrapper wrapper = wsWrapperList.get(i);
       		lstwarningComments.add(wrapper);
       }
       
        Member360View lstWsWrapper = new Member360View();
        lstWsWrapper.accList = lstwarningComments;
        lstWsWrapper.totalrecords = wsWrapperList.size();
		return lstWsWrapper; 
    }
    
    @AuraEnabled
    public static object GetMasterCardAlertsData(Integer PageNo, Integer PageSize, string SortBy, string SortDir,string Account, string Card,string SearchText)
    {
    	Integer PageSize_Local = Integer.Valueof(PageSize);
        Integer PageNo_Local = Integer.Valueof(PageNo);
        string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
        string SOQLQuery = '';
		string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
        	orderString = ' Order by ' + SortBy + ' ' + SortDir;	
        	
        }        
        string searchquery = '';
        if(SearchText.length() > 0)
        {
        	searchquery += 'and (OdsKey__c LIKE \'%' + SearchText + '%\' or transCountry__c LIKE \'%' + SearchText + '%\' or emailAddress__c LIKE \'%' + SearchText + '%\' or FirstName__c LIKE \'%' + SearchText + '%\' or LastName__c LIKE \'%' + SearchText + '%\' or merchantname__c LIKE \'%' + SearchText + '%\' or transAmount__c =: ' + SearchText + ' or transAmtAlert__c =: ' + SearchText + ')';
        }
		
		SOQLQuery = 'select OdsKey__c,transCountry__c,emailAddress__c,FirstName__c,LastName__c,merchantname__c,Card_Number__c,Name,Member_Number__c,transAmount__c, transAmtAlert__c from CFCU_Mastercard_Alerts__c where Card_Number__c =\''  + Card + '\' and Member_Number__c =\'' + Account + '\' ' + searchquery + ' ' + orderString +   '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
    	System.debug('SOQLQuery is for Master Card Alerts --- ' + SOQLQuery);
    	
    	List<sObject> accList = Database.query(SOQLQuery);
    	Member360View lstCardAlerts = new Member360View();
        lstCardAlerts.accList = accList;
    	
    	if(searchquery.length() > 0)
    	{
    		lstCardAlerts.totalrecords = accList.size();
    	}
    	else
    	{
    		AggregateResult[] ARs  = [SELECT Count(id) cnt FROM CFCU_Mastercard_Alerts__c Where Card_Number__c =: Card AND Member_Number__c =: Account];
    		lstCardAlerts.totalrecords = Integer.Valueof(ARs[0].get('cnt'));
    	}
    	
    	
        
		return lstCardAlerts;
    }
    
	public class Member360View
	{
		@AuraEnabled
		public object accList {get;set;}
		@AuraEnabled
		public integer totalrecords {get;set;}
	}	
	
	 public class warningStringWrapper {
	 	@AuraEnabled
        public Id accId {get; set;}
        @AuraEnabled
        public String accNum {get; set;}
        @AuraEnabled
        public Date CloseDate {get; set;}
        @AuraEnabled
        public String WarningCode {get; set;}
        @AuraEnabled
        public String tpeTrans {get; set;}
        @AuraEnabled
        public String recTpe {get; set;}
        @AuraEnabled
        public string imgUrl {get;set;}
        @AuraEnabled
        public String shareNo {get;set;}
        @AuraEnabled       
        public String Descriptn {get;set;}        
        
            public warningStringWrapper(Id id, String Name, Date Close_Date, String wc, String rt, String tt, map<string,id> docMap, String shrNo, String som) {
            accId = id;
            accNum = Name;
            CloseDate = Close_Date;
            WarningCode = wc;
            tpeTrans = tt;
            recTpe = rt;
            imgUrl = docMap.get(wc);
            shareNo = shrNo;
           // Commts = cmts;
            Descriptn = som;
            system.debug(Name);
            system.debug('docMap is:::'+imgUrl);              
        }
    }
    
    public class casewithcommentsModel {
    	@AuraEnabled
    	public Id caseId {get; set;}
    	
    	@AuraEnabled
		public String CaseNumber {get; set;}
		
		@AuraEnabled
		public String Category {get; set;}
		
		@AuraEnabled
		public String Status {get; set;}
		
		@AuraEnabled
		public String AccountNumberName {get; set;}
		
		@AuraEnabled
		public String AccountName {get; set;}
		
		@AuraEnabled
		public String Subject {get; set;}
		
		@AuraEnabled
		public list<caseComment> lstCaseComments{get;set;}		
			
		public casewithcommentsModel(Id id, string CaseNum, string cat, string sts, string actnumName, string actName, string sub)
		{
			caseId = id;
			CaseNumber = CaseNum;
			Category = cat;
			Status = sts;
			AccountNumberName = actnumName;
			AccountName = actName;
			Subject = sub;
		}
    }

	public class taskModel {
    	@AuraEnabled
    	public Id caseId {get; set;}
    	
    	@AuraEnabled
		public String CaseNumber {get; set;}
		
		@AuraEnabled
		public String Category {get; set;}
		
		@AuraEnabled
		public String Status {get; set;}
		
		@AuraEnabled
		public String AccountNumberName {get; set;}
		
		@AuraEnabled
		public String AccountName {get; set;}
		
		@AuraEnabled
		public String Subject {get; set;}
		
		@AuraEnabled
		public list<Task> lstTasks{get;set;}		
			
		public taskModel(Id id, string CaseNum, string cat, string sts, string actnumName, string actName, string sub)
		{
			caseId = id;
			CaseNumber = CaseNum;
			Category = cat;
			Status = sts;
			AccountNumberName = actnumName;
			AccountName = actName;
			Subject = sub;
		}
    }
    
      //Start: CRM-1400 - DB
    
    public class CaseModel {
        @AuraEnabled
        public string Id {get; set;}
        
        @AuraEnabled
        public String CaseNumber {get; set;}
        
        @AuraEnabled
        public String Category {get; set;}
        
        @AuraEnabled
        public String Status {get; set;}
        
        @AuraEnabled
        public String AccountNumber {get; set;}
        
        @AuraEnabled
        public String AccountName {get; set;}
        
        @AuraEnabled
        public String Subject {get; set;}
        
         @AuraEnabled
        public String MemberName {get; set;}
        
         @AuraEnabled
        public String AccountId {get; set;}
        
        @AuraEnabled
        public String ParentId {get; set;}
        
         @AuraEnabled
        public String ParentCaseNumber {get; set;}
        
        @AuraEnabled
        public String Origin {get; set;}
        
        @AuraEnabled
        public datetime CreatedDate {get; set;}
        
        @AuraEnabled
        public datetime ClosedDate {get; set;}
        
        @AuraEnabled
        public string Brand {get; set;}
        
        @AuraEnabled
        public string OwnerName {get; set;}
            
       
    }
    
     //End: CRM-1400 - DB
     
      //Start: CRM-1501 - DB
     
  
	    /** The literal for sorting by Case Number */
	    public static String CaseNumber_SORT = 'casenumber';
	
	    /** The literal for sorting by Parent Case */
	    public static String ParentCase_SORT = 'parentcase';
	
	    /** The literal for sorting by Account No */
	    public static  String AccountNo_SORT = 'accountno';
	
	    /** The literal for sorting by Member Name */
	    public static String MemberName_SORT = 'membername';
	    
	     /** The literal for sorting by Case Category */
	    public static String CaseCategory_SORT = 'category';    
	    
	     /** The literal for sorting by Case Subject */
	    public static String CaseSubject_SORT = 'subject';
	    
	     /** The literal for sorting by Case Origin */
	    public static String CaseOrigin_SORT = 'origin';
	    
	     /** The literal for sorting by Open Date */
	    public static String OpenDate_SORT = 'opendate';
	    
	    public static String ClosedDate_SORT = 'closeddate';
	    
	    /** The literal for sorting by Brand */
	    public static String Brand_SORT = 'brand';
	    
	    /** The literal for sorting by Status */
	    public static String Status_SORT = 'status';
	    
	    /** The literal for sorting by Owner */
	    public static String Owner_SORT = 'owner';
	
	    /** What we are sorting by */
	    public static String SORT_BY = OpenDate_SORT;
     

    /** A wrapper class to make casemodel sortable */
    public class CaseModelWrapper implements Comparable {    
    	
    	 public CaseModel casemodel;     

        
        /**
        * A generic constructor
        */
        public CaseModelWrapper() {}

        /**
        * Constructor based on an employee record
        *
        * @param employee The employee to use
        */
        public CaseModelWrapper(CaseModel casemodel) {         
            this.casemodel =  casemodel; 
          
        }

        private Integer sortByCaseNumber(CaseModelWrapper casemodel) {
            if (this.casemodel.CaseNumber > casemodel.casemodel.CaseNumber) {
                return 1;
            }

            if (this.casemodel.CaseNumber == casemodel.casemodel.CaseNumber) {
                return 0;
            }

            return -1;
        }
        
         private Integer sortByParentCase(CaseModelWrapper casemodel) {
            if (this.casemodel.ParentCaseNumber > casemodel.casemodel.ParentCaseNumber) {
                return 1;
            }

            if (this.casemodel.ParentCaseNumber == casemodel.casemodel.ParentCaseNumber) {
                return 0;
            }

            return -1;
        }
		
		 private Integer sortByAccountNo(CaseModelWrapper casemodel) {
            if (this.casemodel.AccountNumber > casemodel.casemodel.AccountNumber) {
                return 1;
            }

            if (this.casemodel.AccountNumber == casemodel.casemodel.AccountNumber) {
                return 0;
            }

            return -1;
        }
		
       
        private Integer sortByMemberName(CaseModelWrapper casemodel) {
            if (this.casemodel.membername > casemodel.casemodel.membername) {
                return 1;
            }

            if (this.casemodel.membername == casemodel.casemodel.membername) {
                return 0;
            }

            return -1;
        }
        
        private Integer sortByCaseCategory(CaseModelWrapper casemodel) {
            if (this.casemodel.Category > casemodel.casemodel.Category) {
                return 1;
            }

            if (this.casemodel.Category == casemodel.casemodel.Category) {
                return 0;
            }

            return -1;
        }
        
         private Integer sortByCaseSubject(CaseModelWrapper casemodel) {
            if (this.casemodel.Subject > casemodel.casemodel.Subject) {
                return 1;
            }

            if (this.casemodel.Subject == casemodel.casemodel.Subject) {
                return 0;
            }

            return -1;
        }
        
        private Integer sortByCaseOrigin(CaseModelWrapper casemodel) {
            if (this.casemodel.origin > casemodel.casemodel.origin) {
                return 1;
            }

            if (this.casemodel.origin == casemodel.casemodel.origin) {
                return 0;
            }

            return -1;
        }
        
        private Integer sortByOpenDate(CaseModelWrapper casemodel) {
            if (this.casemodel.CreatedDate > casemodel.casemodel.CreatedDate) {
                return 1;
            }

            if (this.casemodel.CreatedDate == casemodel.casemodel.CreatedDate) {
                return 0;
            }

            return -1;
        }
        
         private Integer sortByClosedDate(CaseModelWrapper casemodel) {
            if (this.casemodel.ClosedDate > casemodel.casemodel.ClosedDate) {
                return 1;
            }

            if (this.casemodel.ClosedDate == casemodel.casemodel.ClosedDate) {
                return 0;
            }

            return -1;
        }
        
         private Integer sortByBrand(CaseModelWrapper casemodel) {
            if (this.casemodel.brand > casemodel.casemodel.brand) {
                return 1;
            }

            if (this.casemodel.brand == casemodel.casemodel.brand) {
                return 0;
            }

            return -1;
        }
        
          private Integer sortByStatus(CaseModelWrapper casemodel) {
            if (this.casemodel.status > casemodel.casemodel.Status) {
                return 1;
            }

            if (this.casemodel.status == casemodel.casemodel.Status) {
                return 0;
            }

            return -1;
        }
        
          private Integer sortByOwner(CaseModelWrapper casemodel) {
            if (this.casemodel.OwnerName > casemodel.casemodel.OwnerName) {
                return 1;
            }

            if (this.casemodel.OwnerName == casemodel.casemodel.OwnerName) {
                return 0;
            }

            return -1;
          }

      

        /**
        * The comparator method used in sorting
        * 
        * @param obj The object to compare to
        * @return the integer value of the comparison between the objects
        */
        public Integer compareTo(Object obj) {
            CaseModelWrapper casemodel = (CaseModelWrapper)(obj);

            if (SORT_BY == CaseNumber_SORT) {
                return sortByCaseNumber(casemodel);
            }
            
             if (SORT_BY == ParentCase_SORT) {
                return sortByParentCase(casemodel);
            }
            
             if (SORT_BY == AccountNo_SORT) {
                return sortByAccountNo(casemodel);
            }
            
             if (SORT_BY == MemberName_SORT) {
                return sortByMemberName(casemodel);
            }
            
             if (SORT_BY == CaseCategory_SORT) {
                return sortByCaseCategory(casemodel);
            }
            
             if (SORT_BY == CaseSubject_SORT) {
                return sortByCaseSubject(casemodel);
            }
            
             if (SORT_BY == CaseOrigin_SORT) {
                return sortByCaseOrigin(casemodel);
            }
            
             if (SORT_BY == OpenDate_SORT) {
                return sortByOpenDate(casemodel);
            }
            
            if (SORT_BY == ClosedDate_SORT) {
                return sortByClosedDate(casemodel);
            }
            
             if (SORT_BY == Brand_SORT) {
                return sortByBrand(casemodel);
            }
            
             if (SORT_BY == Status_SORT) {
                return sortByStatus(casemodel);
            }
            
             if (SORT_BY == Owner_SORT) {
                return sortByOwner(casemodel);
            }

           
            // If we don't have a know sort by, let's just return that they are all equal
            return 0;
        }
    }
       //End: CRM-1501 - DB 
}